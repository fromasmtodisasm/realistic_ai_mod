
//////////////////////////////////////////////////////////////////////
//
//	Crytek Source code
//	Copyright (c) Crytek 2001-2004
//
//  File: XPuppetProxy.cpp
//  Description: handeling AI signals, changing behaviors
//
//  History:
//  - Dec, 12, 2002: Created by Petar Kotevski
//	- February 2005: Modified by Marco Corbetta for SDK release
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "XPuppetProxy.h"
#include <IScriptSystem.h>
#include "Game.h"
#include "XPlayer.h"
#include "XVehicle.h"
#include "WeaponClass.h"
#include "ScriptObjectVector.h"
#include "XEntityProcessingCmd.h"
#include <CryCharAnimationParams.h>
#include <float.h>
#include <IAISystem.h>

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////
CXPuppetProxy::CXPuppetProxy(IEntity *pEntity,IScriptSystem *pScriptSystem, CXGame *pGame):pSignalTable(pScriptSystem),pJumpTable(pScriptSystem)
{
	m_fMovementRestrictionDuration = -1;
	m_bAllowedToMove = false;
	m_nWeaponBoneID = -1;
	m_bWasSwimming = false;
	m_bFireOverride = false;
	m_bForcedToShoot = false;
	m_bInJump = false;
	m_pScriptSystem = pScriptSystem;
	m_pEntity = pEntity;
	m_nLastBodyPos = 0;
	m_vPreviousTargetPos = pEntity->GetPos();

	AllowVisibleUpdate = 2;
	AllowVisibleUpdate2 = 2;
    SetHorizontalFov=false;
    CurrentHorizontalFov=155;
    OriginalHorizontalFov=155;
    TempOriginalHorizontalFov=0;
    NewAngleOnCollisions=0;
    m_fMaxTimeToTrowGrenade=NULL;
    m_bPrevMovingStats=true;
    m_fSavedPos;
    m_nStrafeOnCollisions=NULL;
    m_bAllowAvoidCollisions=false;
    m_iPrevForward=NULL;
    m_iPrevStrafe=NULL;
    m_iPrevStanding=NULL;
    m_iPrevMode=NULL;
    m_fChageStanceTimeDelay=NULL;
    m_iEstimatedPosition=NULL;
    m_iEstimatedSpeed=NULL;

	if (m_pEntity->GetContainer())
	{
		if (!m_pEntity->GetContainer()->QueryContainerInterface(CIT_IPLAYER,(void**) &m_pPlayer))
			m_pPlayer = 0;
	}
	else
		m_pPlayer = 0;

	m_bDead = false;
	m_fBackwardSpeed = 0;
	m_fForwardSpeed = 0;
	m_vHeadDir = pEntity->GetAngles();
	m_vHeadDir = ConvertToRadAngles(m_vHeadDir);
	m_vTorsoDir = m_vHeadDir;
	m_vBodyDir = m_vHeadDir;
	m_pGame = pGame;

	m_AIHandler.Init( m_pGame, m_pEntity, m_pGame->GetSystem()->GetILog() );
	m_pEntity->GetScriptObject()->GetValue("JumpSelectionTable",pJumpTable);

	bool bFish = false;
	m_pEntity->GetScriptObject()->GetValue("IsFish",bFish);
	m_pPlayer->m_bIsFish = bFish;

	m_pCharacterPhysics = 0;
	ICryCharInstance *pInstance = m_pEntity->GetCharInterface()->GetCharacter(0);
	if (pInstance)
	{
		if (pInstance->GetModel())
		{
			m_nWeaponBoneID = pInstance->GetModel()->GetBoneByName("Bip01 R Forearm");
		}
	}

	m_pAISystem = NULL;
}

//////////////////////////////////////////////////////////////////////
CXPuppetProxy::~CXPuppetProxy()
{
	ICryCharInstance *pInstance = m_pEntity->GetCharInterface()->GetCharacter(0);
	if (pInstance)
		pInstance->RemoveAnimationEventSink(this);
}

int CXPuppetProxy::GetMyEntityId()
{
    int EntityId = m_pEntity->GetId();
    if (EntityId)
    {
        m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: m_pEntity ID: %d",m_pEntity->GetName(),EntityId);
        return EntityId;
    }
    return NULL;
}

int CXPuppetProxy::Update(SOBJECTSTATE *state)
{
	FUNCTION_PROFILER( m_pGame->GetSystem(),PROFILE_AI );

	if (m_pPlayer)
	{
		if (!m_pPlayer->IsAlive())
			return 0;
	}

	m_pScriptSystem->BeginCall("BasicAI","DoChatter");
	m_pScriptSystem->PushFuncParam(m_pEntity->GetScriptObject());
	m_pScriptSystem->EndCall();

	Vec3d angles = m_pEntity->GetAngles(1);

	if(!m_pEntity->IsBound() || m_pPlayer->GetRedirected())	// move only if not bound
	{
		if ((-1e+9 < state->fValue && state->fValue < 1e+9))
		{
			// handle turning
			if (state->turnleft || state->turnright)
			{
				angles.z+=state->fValue;
			}
		}
		else
			state->fValue = 0;

		if ((-1e+9 < state->fValueAux && state->fValueAux < 1e+9))
		{
			angles.x+=state->fValueAux;
		}
		else
			state->fValueAux = 0;


		CXEntityProcessingCmd tempCommand;
		tempCommand.SetDeltaAngles(angles);

		if (m_pPlayer)
            m_pPlayer->ProcessAngles(tempCommand);
		else
			m_pEntity->SetAngles(angles,true,false);

		if (state->left || state->right)// && state->bHaveTarget)
		{
			Vec3d ang = m_pEntity->GetAngles();
			ang=ConvertToRadAngles(ang);

			Vec3d leftdir = ang;
			Matrix44 mat;
			mat.SetIdentity();
			if (state->left)
			{
				//mat.RotateMatrix(Vec3d(0,0,90));
		    mat=Matrix44::CreateRotationZYX(-Vec3d(0,0,+90)*gf_DEGTORAD)*mat; //NOTE: angles in radians and negated
			}
			else
			{
				//mat.RotateMatrix(Vec3d(0,0,-90));
				mat=Matrix44::CreateRotationZYX(-Vec3d(0,0,-90)*gf_DEGTORAD)*mat; //NOTE: angles in radians and negated
			}
			leftdir = mat.TransformPointOLD(leftdir);
			state->vMoveDir+=leftdir;
		}

		pe_action_move motion;
		if (state->vMoveDir.Length() > 0)
			motion.dir = GetNormalized(state->vMoveDir);
		else
			motion.dir.Set(0,0,0);

		if (state->jump)
		{
			FRAME_PROFILER( "AIJumpProcessing",m_pGame->GetSystem(),PROFILE_AI );
			if (m_pPlayer)
				m_pPlayer->m_stats.jumping = true;

			m_vJumpVector = state->vJumpDirection;
			m_fLastJumpDuration = state->fJumpDuration;
			m_nJumpDirection = (int)(state->nJumpDirection);

			_SmartScriptObject pDesiredJumpType(m_pScriptSystem,true);
			if (pJumpTable->GetAt(m_nJumpDirection,pDesiredJumpType))
			{
				_SmartScriptObject pDesiredJump(m_pScriptSystem,true);
				int cnt = pDesiredJumpType->Count();
				if (cnt>1)
					cnt = (rand() % (cnt)) + 1;
				m_nLastSelectedJumpAnim = cnt;
                if (pDesiredJumpType->GetAt(cnt,pDesiredJump))
				{
					const char *pAnimName;
					int nTakeoffFrame, nLandFrame;
					pDesiredJump->GetAt(1,pAnimName);
					pDesiredJump->GetAt(2,nTakeoffFrame);
					pDesiredJump->GetAt(3,nLandFrame);
					ICryCharInstance *pCharacter = m_pEntity->GetCharInterface()->GetCharacter(0);
					if (pCharacter)
					{
						// set up callbacks to jump and land correctly
						m_pGame->GetSystem()->GetILog()->Log("\001 [AIWARNING] Entity %s set a callback for animation %s (char %p)",m_pEntity->GetName(), pAnimName, pCharacter);
						pCharacter->AddAnimationEventSink(pAnimName,this);
						pCharacter->AddAnimationEvent(pAnimName,nTakeoffFrame,(void*)JUMP_TAKEOFF);
						pCharacter->AddAnimationEvent(pAnimName,nLandFrame,(void*)JUMP_LAND);
						m_pEntity->StartAnimation(0,pAnimName,3,0.1f);

						SAIEVENT sae;
						sae.fInterest = m_fLastJumpDuration;
						sae.fInterest += m_pEntity->GetAnimationLength(pAnimName) - ((nLandFrame-nTakeoffFrame)*0.03f);
						m_pEntity->GetAI()->Event(AIEVENT_ONBODYSENSOR,&sae);

						MovementControl(false, sae.fInterest);

					}
					else
						m_pGame->GetSystem()->GetILog()->Log("\003 [AIWARNING] Entity %s tried to jump but has no animated character!!",m_pEntity->GetName());

				}
			}
			else
				m_pGame->GetSystem()->GetILog()->Log("\003 [AIWARNING] No jumps specified for a certain direction for entity %s",m_pEntity->GetName());
			state->jump = false;
		}
		else
		{
			m_AIHandler.SetCurrentBehaviourVariable("fLastJumpDuration",state->fJumpDuration);
			if (m_pPlayer)
				m_pPlayer->m_stats.jumping = false;

			motion.dir *= m_fForwardSpeed;

			if( m_pPlayer->m_stats.bIsLimping )
			{
				motion.dir*=.73f;
			}
			else
				switch (state->bodystate)
			{
				case BODYPOS_STAND:
					if (state->run)
						motion.dir*=m_pPlayer->m_RunSpeedScale;
					break;
				case BODYPOS_CROUCH:
					motion.dir*=m_pPlayer->m_CrouchSpeedScale;
					break;
				case BODYPOS_PRONE:
					motion.dir*=m_pPlayer->m_ProneSpeedScale;
					break;
				case BODYPOS_STEALTH:
					if (state->run)
						motion.dir*=m_pPlayer->m_XRunSpeedScale;
					else
						motion.dir*=m_pPlayer->m_XWalkSpeedScale;
					break;
				case BODYPOS_RELAX:
					if (state->run)
						motion.dir*=m_pPlayer->m_RRunSpeedScale;
					else
						motion.dir*=m_pPlayer->m_RWalkSpeedScale;
					break;

			}
		}

		pe_player_dynamics pdyn;
		m_pEntity->GetPhysics()->GetParams(&pdyn);

		if (m_pPlayer)
		{

			// handle inertia
			// actual intertia change is done in CPlayer::UpdatePhysics
			// same for AirControl/bSwimming
			if (((state->bCloseContact || m_bInJump) && !m_pPlayer->IsSwimming()) || m_pPlayer->m_bIsFish )
				m_pPlayer->m_bInertiaOverride = true;
			else
				m_pPlayer->m_bInertiaOverride = false;
			if (m_pPlayer->IsSwimming()) // Водные процедуры. Сейчас работает правильно.
			{
			    //m_pGame->GetSystem()->GetILog()->Log("%s: IsSwimming",m_pEntity->GetName());
				// keep puppet on surface
				if(m_pPlayer->m_stats.fInWater>.4f) // Убрал и он продолжил всплывать. Может во время движения?
					motion.dir.z = 4.0f; // Наверно подниматься вверх по оси z во время движения. Если ось z - это вертикаль.

				// when swimming underwater and going up by press JUMP
				// if too close to surface - don't apply too much UP impulse
				// to prevent jumping out of water
				if(	m_pPlayer->m_stats.fInWater < m_pPlayer->m_PlayerDimSwim.heightEye)
					motion.dir.z *= m_pPlayer->m_stats.fKWater*.02f;	// if close to surface - don't go up too fast - not to jump out of water

				if (!m_bWasSwimming )
				{
					if (!m_pPlayer->m_bIsFish)
					{
						// player entered water
						m_pEntity->GetAI()->SetSignal(-1,"START_SWIMMING"); // Был 1
						m_bWasSwimming = true;
					}
				}
			}
			else if (m_bWasSwimming)
			{
				if (!m_pPlayer->m_bIsFish)
				{
					// player left water
					m_pEntity->GetAI()->SetSignal(-1,"STOP_SWIMMING");
					m_bWasSwimming = false;
				}
			}
		}

		//smooth AI movement, if AI is indoor is possible to use different acceleration values (if m_pPlayer->m_input_accel_indoor>0.0f).
		if (m_pPlayer)
		{
			bool indoor = false;
			float accel = m_pPlayer->m_input_accel;
			float decel = m_pPlayer->m_input_stop_accel;

			//if is the first time, get AISystem pointer.
			if (!m_pAISystem)
				m_pAISystem = m_pGame->GetSystem()->GetAISystem();

			int building;
			IVisArea *pArea;

			if (m_pAISystem && ((IAISystem *)m_pAISystem)->CheckInside(m_pEntity->GetPos(),building,pArea)) // Я внутри или снаружи?
			{
				indoor = true;
				if (m_pPlayer->m_input_accel_indoor>0.0f)
				{
					accel = m_pPlayer->m_input_accel_indoor;
					decel = m_pPlayer->m_input_stop_accel_indoor;
					//m_pGame->GetSystem()->GetILog()->Log("%s indoor(%.1f,%.1f)",m_pEntity->GetName(),accel,decel);
				}
			}

			//force AI to use smaller accelleration near target only when outdoor,
			//indoors have fDistanceFromTarget pretty small all the times and this cause AI to smooth to much, missing doors.
			if (state->fDistanceFromTarget>0 && !indoor)
				accel = min(state->fDistanceFromTarget,accel); // Что-то со скоростью походки связанное..

			m_pPlayer->DampInputVector(motion.dir,accel,decel,true,false);
		}

		// move entity
		ApplyMovement(&motion,state);


		// this is done in CPlayer::UpdatePhysics now
		// m_pEntity->GetPhysics()->SetParams(&pdyn);
		m_pPlayer->m_vDEBUGAIFIREANGLES = m_pEntity->GetAngles(); // Больше не нужно.

		// handle fire of weapon
		int temp;
		if (m_pPlayer && !m_pEntity->GetScriptObject()->GetValue("NEVER_FIRE",temp)) // ПРОВЕРИТЬ ПЛЮШКИ
		{ //Можно стрелять
			FRAME_PROFILER( "AIWeaponsFire",m_pGame->GetSystem(),PROFILE_AI );
			m_pPlayer->m_aimLook = state->aimLook;
            // В этом куске больше нет необходимости, но пусть остаётся, а то вдруг вылет...--
			Vec3d fireangles = state->vFireDir; // Чисто направление вылетающих из ствола пуль.
            //Vec3d fireangles(1.0f,0.0f,0.0f);
			Vec3d mvmtDir = state->vTargetPos - m_vPreviousTargetPos;
			if (mvmtDir.len2() > 20.f)
			{
				fireangles = state->vTargetPos + GetNormalized(mvmtDir)*4.5f;
				fireangles -= m_pEntity->GetPos();
			}

			fireangles = ConvertVectorToCameraAngles(fireangles);
			m_pPlayer->m_vDEBUGAIFIREANGLES = fireangles;
            // -------------------------------------------------------------------
            int AllowVisible=0;
            m_pEntity->GetScriptObject()->GetValue("AllowVisible", AllowVisible);
			if (m_bFireOverride)
			{
				m_pPlayer->m_stats.firing=true;
				m_pPlayer->m_aimLook = true;
				m_bFireOverride = false;
				//m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: m_bFireOverride",m_pEntity->GetName());
			}
			else if(m_bForcedToShoot&&AllowVisible==1) // Принудительная стрельба.
            {
				m_pPlayer->m_aimLook = state->aimLook;
				if (state->fire)
				{
					m_pPlayer->m_stats.firing = true;
					m_pPlayer->m_aimLook = true;
					//m_pPlayer->HoldWeapon();
				}
                m_bForcedToShoot = false;
                //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: m_bForcedToShoot",m_pEntity->GetName());
            }
			else
			{
				m_pPlayer->m_aimLook = state->aimLook;
				if (state->fire)
				{
					m_pPlayer->m_stats.firing = true;
					//m_pPlayer->m_aimLook = true;
					m_pPlayer->HoldWeapon();
				}
				else
					m_pPlayer->m_stats.firing = false;
                //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: not m_bFireOverride and not m_bForcedToShoot",m_pEntity->GetName());
			}

		}
		else // Нельзя.
			m_pPlayer->m_stats.firing = false;

		//Account for body position
		if (m_nLastBodyPos != state->bodystate)
		{
			FRAME_PROFILER( "AISwitchingStances",m_pGame->GetSystem(),PROFILE_AI );
			switch (state->bodystate)
			{
				case 1:
					m_dimCurrentDimensions = m_dimCrouchingPuppet;
					if (m_pPlayer)
						m_pPlayer->GoCrouch();
					break;

				case 2:
					m_dimCurrentDimensions = m_dimProningPuppet;
					if (m_pPlayer)
						m_pPlayer->GoProne();
					break;

				case 0:
					m_dimCurrentDimensions = m_dimStandingPuppet;
					if (m_pPlayer)
						m_pPlayer->GoStand();
					break;

				case 5:
					m_dimCurrentDimensions = m_dimStandingPuppet;
					if (m_pPlayer)
						m_pPlayer->GoStealth();
					break;

				case 4:
					m_dimCurrentDimensions = m_dimProningPuppet;
					break;

				case 3:
					m_dimCurrentDimensions = m_dimStandingPuppet;
					if (m_pPlayer)
						m_pPlayer->GoRelaxed();
					break;
			}

			m_nLastBodyPos = state->bodystate;
		}
	}
	else
	{
		if (m_pPlayer)
		{

			angles = m_pEntity->GetAngles( 1 );
			// handle turning
			if (state->turnleft || state->turnright)
				angles.z+=state->fValue;

			angles.x+=state->fValueAux;

			CXEntityProcessingCmd tempCommand;
			tempCommand.SetDeltaAngles(angles);

			m_pPlayer->ProcessAngles(tempCommand);

			if (state->fire)
			{ //Не нужно больше, но пусть остаётся.
				Vec3d fireangles = state->vFireDir;
				fireangles=ConvertVectorToCameraAngles(fireangles);
				m_pPlayer->m_vDEBUGAIFIREANGLES = fireangles;
				m_pPlayer->m_stats.firing=true;
				m_pPlayer->HoldWeapon(); // Добавил.
				m_pPlayer->m_aimLook = true;
			}
			else
			{
				m_pPlayer->m_stats.firing=false;
			}
		}
	}

	if (!(m_LastObjectState == *state))
	{
		m_LastObjectState = *state;
		UpdateMotor(state);
	}
	bool bSkipNextUpdate = false;
	{
		FRAME_PROFILER( "AISignalProcessing",m_pGame->GetSystem(),PROFILE_AI );
        while (!state->vSignals.empty())
        {
            AISIGNAL sstruct = state->vSignals.back();
            state->vSignals.pop_back();
            int signal = sstruct.nSignal;
            const char *szText = &sstruct.strText[0];
            IEntity* pSender= (IEntity*) sstruct.pSender;

            switch (signal)
            {
                case -10:
                    // throw a grenade
                    if (m_pPlayer)
                    {
                        Vec3d firepos,fireangles;
                        firepos = m_pPlayer->GetEntity()->GetPos();
                        firepos.z+=2.f;
                        //Попробовать убрать m_pPlayer->GetEntity()->GetAngles() когда крит исчезнет.
                        fireangles = m_pPlayer->GetEntity()->GetAngles(); // На всякий случай оставлю.
                        m_pPlayer->m_fGrenadeTimer=3;
                        fireangles = m_pEntity->GetAngles(); // Пока в режиме теста. Проверить бросок без оружия.
                        //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: SYSTEM FireGrenade",m_pEntity->GetName());
                        m_pPlayer->FireGrenade(firepos,fireangles,m_pPlayer->GetEntity());
                    }
                    break;
                case -20:
                    bSkipNextUpdate = true;
                    break;
            }
            SendSignal(signal,szText,pSender);
            /*if (szText!="setup_stand"  && szText!="setup_crouch" && szText!="setup_prone"
            && szText!="setup_stealth" && szText!="setup_relax"  && szText!="do_it_walking"
            && szText!="do_it_running")
                SendSignal(signal,szText,pSender);
            else
                bSkipNextUpdate = true;
            m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: %s",m_pEntity->GetName(),szText);*/
            /*if (szText=="setup_stand")
            else if (szText=="setup_crouch")
            else if (szText=="setup_prone")
            else if (szText=="setup_stealth")
            else if (szText=="setup_relax")
            else if (szText=="do_it_walking")
            else if (szText=="do_it_running")*/

		}
	}

    UpdateThrowGrenade(state); // Бросок гранаты, только без сигнала.

	if (state->nAuxSignal)
	{
	    //m_pGame->GetSystem()->GetILog()->Log("%s: nAuxSignal",m_pEntity->GetName());
		FRAME_PROFILER( "AIReadibilityProcessing",m_pGame->GetSystem(),PROFILE_AI );
		SendAuxSignal(state->nAuxSignal,state->szAuxSignalText.c_str());
		state->nAuxSignal = 0;
	}

	// send SYSTEM GAME EVENTS LAST!!! They are most important.
	if (state->bReevaluate && !bSkipNextUpdate)
		UpdateMind(state);

    m_pScriptSystem->BeginCall("BasicAI","AiUpdate");
    m_pScriptSystem->PushFuncParam(m_pEntity->GetScriptObject());
    m_pScriptSystem->EndCall();

    IEntity *pTargetEntity = 0;
    IAIObject *pObject = m_pEntity->GetAI();
    IPipeUser *pPipeUser = 0;
    if (pObject->CanBeConvertedTo(AIOBJECT_PIPEUSER,(void**)&pPipeUser))
    {
        IAIObject *pTheTarget = pPipeUser->GetAttentionTarget();
        if (pTheTarget)
        {
            if (pTheTarget->GetType()==AIOBJECT_PLAYER || pTheTarget->GetType()==AIOBJECT_PUPPET)
                pTargetEntity = (IEntity *) pTheTarget->GetAssociation();
        }
    }
    IPuppet *pPuppet=0;
    bool IPuppetEntity=m_pEntity->GetAI()->CanBeConvertedTo(AIOBJECT_PUPPET,(void**)&pPuppet);

    UpdateVisible(state,pPuppet,IPuppetEntity,pTargetEntity);

    bool IsMutant;
    m_pEntity->GetScriptObject()->GetValue("IsMutant", IsMutant);
    bool DoNotAvoidCollisionsOnTheMoveForward;
    m_pEntity->GetScriptObject()->GetValue("DoNotAvoidCollisionsOnTheMoveForward", DoNotAvoidCollisionsOnTheMoveForward);
    bool IsAnimal;
    m_pEntity->GetScriptObject()->GetValue("IsAnimal", IsAnimal);
    bool InVehicle = m_pPlayer->GetVehicle(); // РАСШИРИТЬ ПРОВЕРКУ
    bool HeJumping;
    m_pEntity->GetScriptObject()->GetValue("HeJumping", HeJumping);
    bool SetAlerted;
    m_pEntity->GetScriptObject()->GetValue("SetAlerted", SetAlerted); // MakeAlerted
    bool CurrentConversation;
    m_pEntity->GetScriptObject()->GetValue("CurrentConversation", CurrentConversation);
    int NewPos=NULL;
    m_pEntity->GetScriptObject()->GetValue("NewPos", NewPos);
    int NewSpeed=NULL;
    m_pEntity->GetScriptObject()->GetValue("NewSpeed", NewSpeed);
     // Нужно мутантам?
    int	jobFlag=0;
    bool CHANGE_STANCE;
    bool FORCE_RUN;
    bool ManInVehicle;
    bool ALLOW_JUMP;
    if (m_AIHandler.m_pBehavior) // Что бы не вылетало при повторной загрузке.
    {
        m_AIHandler.m_pBehavior->GetValue("JOB", jobFlag);
        m_AIHandler.m_pBehavior->GetValue("CHANGE_STANCE", CHANGE_STANCE); // Принудительно сменить положение тела.
        m_AIHandler.m_pBehavior->GetValue("FORCE_RUN", FORCE_RUN); //  Бежать при положении стоя или скрытно.
        m_AIHandler.m_pBehavior->GetValue("ManInVehicle", ManInVehicle); // Человек в машине (состояние такое).
        m_AIHandler.m_pBehavior->GetValue("ALLOW_JUMP", ALLOW_JUMP); //  Разрешить прыгать.
    }
    if (CHANGE_STANCE) // При 1, принудительно разрешить автоматически менять положение тела, скорость перемещения и прыгать во время работы в случае столкновения с препятствием.
        jobFlag=1;
    if (CurrentConversation) // Если болтают с помощью якорей, то тоже не выполнять все эти действия.
        jobFlag=1;
    if (ManInVehicle)
        InVehicle=true;
    /* 	generates string with appropriate animation name, according to naming convention depending on parametrs
    -- 	m_nForward: 	0 = Backward, 	1 = Forward
    -- 	m_nStrafe:  	0 = None, 		1 = Left, 		2 = Right
    -- 	m_nStanding: 	0 = Standing, 	1 = Crouching, 	2 = Prone,      3 = Stealth,    4 = Relax,
    -- 	m_nMode: 		0 = Idle, 		1 = Walking, 	2 = Running, 	3 = Jump, 	4 = Flying, 	5 = Dead,	6 = Turning, */
    int Forward = m_pPlayer->m_nForward;
    int Strafe = m_pPlayer->m_nStrafe; // Да, это поворот влево или вправо, вокруг своей оси.
    int Standing = m_pPlayer->m_nStanding;
    int Mode = m_pPlayer->m_nMode; // А на погибших действует всё это?
    //%s - string, %f - float, %d - integer
    //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: POS INFO: %d, %d, %d, %d",m_pEntity->GetName(),Forward,Strafe,Standing,Mode);
    //m_iPrevForward=Forward;
    //m_iPrevStrafe=Strafe;
    //m_iPrevStanding=Standing;
    //m_iPrevMode=Mode;

    //Vec3 pos,angle;
    Vec3d pos = m_pEntity->GetPos();
    Vec3d angle = m_pEntity->GetAngles();
    Vec3d dir = ConvertToRadAngles(angle);
    ray_hit hit;
    //int objTypes = ent_all-ent_terrain+ent_ignore_noncolliding;
    int objTypes = ent_all+ent_ignore_noncolliding;
    // Флаги тоже учитываются?
    int flags = rwi_ignore_terrain_holes+rwi_ignore_noncolliding+rwi_ignore_back_faces+rwi_any_hit+
                rwi_pierceability_mask+rwi_pierceability0+rwi_stop_at_pierceable+
                rwi_separate_important_hits+rwi_colltype_bit;
    float SavePosZ=pos.z;
    UpdateTurning(state,pos,angle,dir,hit,objTypes,flags,IsAnimal,InVehicle,HeJumping,SetAlerted,CurrentConversation,
    pPuppet,IPuppetEntity,pTargetEntity,Forward,Strafe,Standing,Mode);

    /*UpdateStance(state,pos,angle,dir,hit,objTypes,flags,IsAnimal,InVehicle,HeJumping,SetAlerted,CurrentConversation,
    pPuppet,IPuppetEntity,pTargetEntity,jobFlag,SavePosZ,IsMutant,Forward,Strafe,Standing,Mode,pPipeUser,FORCE_RUN,
    NewPos,NewSpeed);*/

    UpdateJumping(state,pos,angle,dir,hit,objTypes,flags,IsAnimal,InVehicle,HeJumping,SetAlerted,CurrentConversation,
    pPuppet,IPuppetEntity,pTargetEntity,jobFlag,SavePosZ,IsMutant,Forward,Strafe,Standing,Mode,pPipeUser,FORCE_RUN,ALLOW_JUMP);

    UpdateAvoidCollisions(state,pos,angle,Forward,Strafe,Standing,Mode,pPipeUser,CurrentConversation,DoNotAvoidCollisionsOnTheMoveForward,
    jobFlag,FORCE_RUN);

    int AllowVisible=0;
    m_pEntity->GetScriptObject()->GetValue("AllowVisible", AllowVisible);
    //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: AllowVisible: %d",m_pEntity->GetName(),AllowVisible);
    m_bPrevMovingStats=m_pPlayer->m_stats.moving; // Не убирать.
	if (state->bHaveTarget&&AllowVisible==1) // А может не надо? ))
		m_vPreviousTargetPos = state->vTargetPos;
    // СОХРАНИТЬ ВСЕ ВОЗМОЖНЫЕ К СОХРАНЕНИЮ ПЕРЕМЕННЫЕ!
	return 0;
}

//////////////////////////////////////////////////////////////////////
void CXPuppetProxy::UpdateThrowGrenade(SOBJECTSTATE *state)
{
	bool AI_Throw_Grenade=false;
    m_pEntity->GetScriptObject()->GetValue("AI_Throw_Grenade", AI_Throw_Grenade);
    float TimeToThrowGrenade=NULL;
    m_pEntity->GetScriptObject()->GetValue("TimeToThrowGrenade", TimeToThrowGrenade);
    float CurrentTime=m_pGame->GetSystem()->GetITimer()->GetCurrTime();
    if (!m_fMaxTimeToTrowGrenade&&TimeToThrowGrenade!=NULL) // Не убирать !=NULL, иначе будет типа "истина" (как в булево значении).
        m_fMaxTimeToTrowGrenade=CurrentTime+TimeToThrowGrenade;
    //if (TimeToThrowGrenade)
        //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: TIME C: %f, TIME L: %f",m_pEntity->GetName(),CurrentTime,TimeToThrowGrenade);
    if ((m_fMaxTimeToTrowGrenade && (CurrentTime > m_fMaxTimeToTrowGrenade)) || AI_Throw_Grenade==true)
    {
        m_pEntity->GetScriptObject()->SetValue("TimeToThrowGrenade",NULL);
        m_fMaxTimeToTrowGrenade=NULL;
        AI_Throw_Grenade=true;
    }
    if (AI_Throw_Grenade)
    {
        if (m_pPlayer)
        {
            FRAME_PROFILER( "UpdateThrowGrenade",m_pGame->GetSystem(),PROFILE_AI);
            Vec3d firepos,fireangles;
            firepos = m_pPlayer->GetEntity()->GetPos();
            firepos.z+=2.f;
            //Попробовать убрать m_pPlayer->GetEntity()->GetAngles() когда крит исчезнет.
            fireangles = m_pPlayer->GetEntity()->GetAngles(); // На всякий случай оставлю.
            m_pPlayer->m_fGrenadeTimer=3;
            //fireangles = m_pEntity->GetAngles(); // Пока в режиме теста. Проверить бросок без оружия.
            //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: SYSTEM FireGrenade",m_pEntity->GetName());
            m_pPlayer->FireGrenade(firepos,fireangles,m_pPlayer->GetEntity());
            //m_pPlayer->m_fGrenadeTimer=3;
            //m_pPlayer->FireGrenade(firepos,fireangles,m_pPlayer->GetEntity());
        }
        m_pEntity->GetScriptObject()->SetValue("AI_Throw_Grenade",false);
    }
}

//////////////////////////////////////////////////////////////////////
void CXPuppetProxy::UpdateVisible(SOBJECTSTATE *state,IPuppet *pPuppet, bool IPuppetEntity, IEntity *pTargetEntity)
{
    float AmbientLightAmount = m_pGame->GetSystem()->GetI3DEngine()->GetAmbientLightAmountForEntity(m_pEntity); // Свет от окружающей среды.
    float LightAmount = m_pGame->GetSystem()->GetI3DEngine()->GetLightAmountForEntity(m_pEntity,false); // Свет от источников освещения. Не работает со спины потому что свет прорисовывается только когда это видит камера.// Если второй параметр истина, то будут приниматься во внимание только источники в виде усечённой пирамиды.
    float TotalLightScale=AmbientLightAmount+LightAmount;
    m_pEntity->GetScriptObject()->SetValue("AmbientLightAmount", AmbientLightAmount);
    m_pEntity->GetScriptObject()->SetValue("LightAmount", LightAmount);
    m_pEntity->GetScriptObject()->SetValue("TotalLightScale", TotalLightScale);
    // m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: ",m_pEntity->GetName());
    bool hely;
    m_pEntity->GetScriptObject()->GetValue("hely",hely);
    bool IsCar;
    m_pEntity->GetScriptObject()->GetValue("IsCar",IsCar);
    bool IsBoat;
    m_pEntity->GetScriptObject()->GetValue("IsBoat",IsBoat);
    if (hely||IsCar||IsBoat)
    {
        if (CurrentHorizontalFov!=OriginalHorizontalFov)
            if (IPuppetEntity)
            {
                AgentParameters params = pPuppet->GetPuppetParameters();
                CurrentHorizontalFov = OriginalHorizontalFov;
                params.m_fHorizontalFov = OriginalHorizontalFov;
                m_pEntity->GetScriptObject()->SetValue("CurrentHorizontalFov", OriginalHorizontalFov);
                pPuppet->SetPuppetParameters(params);
            }
        m_pEntity->GetScriptObject()->SetValue("AllowVisible", 1);
        return;
    }
    if (!SetHorizontalFov)
    {
        if (IPuppetEntity)
        {
            SetHorizontalFov=true;
            AgentParameters params = pPuppet->GetPuppetParameters();
            OriginalHorizontalFov=params.m_fHorizontalFov;
            CurrentHorizontalFov=params.m_fHorizontalFov;
            m_pEntity->GetScriptObject()->SetValue("OriginalHorizontalFov", params.m_fHorizontalFov);
            //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: SETFOV",m_pEntity->GetName());
        }
    }
    else
    {
        m_pEntity->GetScriptObject()->GetValue("CurrentHorizontalFov",CurrentHorizontalFov);
        m_pEntity->GetScriptObject()->GetValue("OriginalHorizontalFov",OriginalHorizontalFov);
        //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: GETFOV",m_pEntity->GetName());
    }
    // Задача: Сохранить текущую оригинальную преременную, подделать её на новый стандарт, а потом, в случае надобности
    // вернуть действительно оригинал из сохранения.
    /*bool TempHF;
    m_pEntity->GetScriptObject()->GetValue("TempHF",TempHF);
    if (TempHF)
        if (IPuppetEntity)
        {
            AgentParameters params = pPuppet->GetPuppetParameters();
            TempOriginalHorizontalFov=params.m_fHorizontalFov;
            if (OriginalHorizontalFov&&TempOriginalHorizontalFov)
                if (OriginalHorizontalFov!=TempOriginalHorizontalFov)
                {
                    OriginalHorizontalFov=TempOriginalHorizontalFov;
                    m_pEntity->GetScriptObject()->SetValue("OriginalHorizontalFov", TempOriginalHorizontalFov);
                    m_pEntity->GetScriptObject()->GetValue("CurrentHorizontalFov", TempOriginalHorizontalFov);
                    m_pEntity->GetScriptObject()->SetValue("TempHF", 0);
                    //pPuppet->SetPuppetParameters(params);
                }
                else if (CurrentHorizontalFov==TempOriginalHorizontalFov)

        }*/

    if (pTargetEntity)
    {
        float TargetAmbientLightAmount = m_pGame->GetSystem()->GetI3DEngine()->GetAmbientLightAmountForEntity(pTargetEntity); // Свет от окружающей среды.
        // Если второй параметр истина, то будут приниматься во внимание только источники в виде усечённой пирамиды.
        float TargetLightAmount = m_pGame->GetSystem()->GetI3DEngine()->GetLightAmountForEntity(pTargetEntity,false); // Свет от источников освещения.
        float TargetTotalLightScale = TargetAmbientLightAmount+TargetLightAmount; // Узнаём общее количество света на цели.
        m_pEntity->GetScriptObject()->SetValue("TargetAmbientLightAmount", TargetAmbientLightAmount); // При ПНВ, из значения с ПНВ вычитаем старое значение без ПНВ и получаем реальное число без ПНВ.
        m_pEntity->GetScriptObject()->SetValue("TargetLightAmount", TargetLightAmount);
        if (TargetTotalLightScale>1.0f)
            TargetTotalLightScale=1.0f;
        m_pEntity->GetScriptObject()->SetValue("TargetTotalLightScale", TargetTotalLightScale);
        bool IsIndoor;
        m_pEntity->GetScriptObject()->GetValue("IsIndoor", IsIndoor);
        bool TargetIsIndoor;
        pTargetEntity->GetScriptObject()->GetValue("IsIndoor", TargetIsIndoor);
        float MaxfDistance;
        if (!IsIndoor&&!TargetIsIndoor) // Оба снаружи.
            MaxfDistance = 300.0f; // 110.0f //ДОДЕЛАТЬ! // 200
        else if (IsIndoor&&TargetIsIndoor) // Оба внутри. // Можно чуть повысить порог оcвещённости, чтобы мутант на восстании видел.
            MaxfDistance = 110.0f;
        else if (!IsIndoor&&TargetIsIndoor) // Я снаружи, он внутри.
            MaxfDistance = 110.0f;
        else if (IsIndoor&&!TargetIsIndoor) // Я внутри, он снаружи.
            MaxfDistance = 300.0f;
        float fDistance = state->fDistanceFromTarget;
        if (fDistance>MaxfDistance)
            fDistance=MaxfDistance;
        float TargetMaxTotalLightScale = fDistance/MaxfDistance;
        if (TargetMaxTotalLightScale>0.9f)
            TargetMaxTotalLightScale=0.9f;
        //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: TargetMaxTotalLightScale: %f",m_pEntity->GetName(),TargetMaxTotalLightScale);
        m_pEntity->GetScriptObject()->SetValue("TargetMaxTotalLightScale", TargetMaxTotalLightScale);
        bool CryVision;
        m_pEntity->GetScriptObject()->GetValue("CryVision", CryVision);
        bool NightVision;
        m_pEntity->GetScriptObject()->GetValue("NightVision", NightVision);
        bool TargetIsCaged;
        pTargetEntity->GetScriptObject()->GetValue("IsCaged",TargetIsCaged);
        /*IPuppet *TpPuppet=0;
        float TargetSpecies;
        float MyEntitySpecies;
        bool TargetPuppetEntity=pTargetEntity->GetAI()->CanBeConvertedTo(AIOBJECT_PUPPET,(void**)&TpPuppet);
        if (TargetPuppetEntity)
        {
            AgentParameters params = TpPuppet->GetPuppetParameters();
            TargetSpecies=params.m_nSpecies;
        }
        if (IPuppetEntity)
        {
            AgentParameters params = pPuppet->GetPuppetParameters();
            MyEntitySpecies=params.m_nSpecies;
        }
        if (TargetIsCaged)
            if (TargetSpecies!=MyEntitySpecies)
                float target=1;*/
        /*if (TargetIsCaged&&IPuppetEntity)
        {
            AgentParameters params = pPuppet->GetPuppetParameters();
            CurrentHorizontalFov = 0;
            params.m_fHorizontalFov = 0;
            m_pEntity->GetScriptObject()->SetValue("CurrentHorizontalFov", 0);
            pPuppet->SetPuppetParameters(params);
        }*/

        int AllowVisible=0; // вынести за скобки if (pTargetEntity)
        if ((TargetTotalLightScale>TargetMaxTotalLightScale||CryVision||NightVision)&&!TargetIsCaged)
        {
            // Сделать цель видимой некоторое время если игрок стрелял или dumb_shot.
            AllowVisible=1;
            AllowVisibleUpdate=1;
            //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: AllowVisible",m_pEntity->GetName());
        }
        else
        {
            AllowVisible=0;
            AllowVisibleUpdate=2;
            //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: NO!!!",m_pEntity->GetName());
        }
        m_pEntity->GetScriptObject()->SetValue("AllowVisible", AllowVisible);
    }

    if (AllowVisibleUpdate!=0)
    {
        if (AllowVisibleUpdate==1&&(AllowVisibleUpdate2==0||AllowVisibleUpdate2==2))
        {
            AllowVisibleUpdate2=1;
            if (IPuppetEntity)
            {
                AgentParameters params = pPuppet->GetPuppetParameters();
                CurrentHorizontalFov = OriginalHorizontalFov;
                params.m_fHorizontalFov = OriginalHorizontalFov;
                m_pEntity->GetScriptObject()->SetValue("CurrentHorizontalFov", OriginalHorizontalFov);
                pPuppet->SetPuppetParameters(params);
            }
            UpdateMind(state);
        }
        else if (AllowVisibleUpdate==2&&(AllowVisibleUpdate2==0||AllowVisibleUpdate2==1))
        {
            AllowVisibleUpdate2=2;
            if (IPuppetEntity)
            {
                AgentParameters params = pPuppet->GetPuppetParameters();
                CurrentHorizontalFov = 0;
                params.m_fHorizontalFov = 0;
                m_pEntity->GetScriptObject()->SetValue("CurrentHorizontalFov", 0);
                pPuppet->SetPuppetParameters(params);
            }
            UpdateMind(state);
        }
    }

    if (IPuppetEntity)
    {
        if (CurrentHorizontalFov>=0&&CurrentHorizontalFov<OriginalHorizontalFov)
        {
            bool NullFov=false;
            if (AllowVisibleUpdate2==2)
                NullFov=true;
            AgentParameters params = pPuppet->GetPuppetParameters();
            if (NullFov)
            {
                CurrentHorizontalFov = CurrentHorizontalFov+0.2f;
            }
            else
            {
                CurrentHorizontalFov = CurrentHorizontalFov+1;
            }
            if ((NullFov&&CurrentHorizontalFov>=OriginalHorizontalFov)||CurrentHorizontalFov<0||(pTargetEntity&&NullFov))
                CurrentHorizontalFov=0;
            params.m_fHorizontalFov = CurrentHorizontalFov;
            m_pEntity->GetScriptObject()->SetValue("CurrentHorizontalFov", CurrentHorizontalFov);
            pPuppet->SetPuppetParameters(params);
        }
    }
}

//////////////////////////////////////////////////////////////////////
void CXPuppetProxy::UpdateTurning(SOBJECTSTATE *state,Vec3d pos,Vec3d angle,Vec3d dir,ray_hit hit,int objTypes,int flags,
bool IsAnimal,bool InVehicle,bool HeJumping,bool SetAlerted,bool CurrentConversation,IPuppet *pPuppet,bool IPuppetEntity,
IEntity *pTargetEntity,int Forward,int Strafe,int Standing,int Mode)
{
    bool TurningOnCollision=false; // Заменяет ForceResponsiveness.
    m_pEntity->GetScriptObject()->GetValue("TurningOnCollision", TurningOnCollision);
    bool RunToTrigger=false;
    m_pEntity->GetScriptObject()->GetValue("RunToTrigger", RunToTrigger);
    bool Following=false; // Следует ли за игроком.
    m_pEntity->GetScriptObject()->GetValue("Following", Following);
    bool TempIsBlinded=false; // Ослеплён ли фонариком.
    m_pEntity->GetScriptObject()->GetValue("TempIsBlinded", TempIsBlinded);

    Vec3d m_vEyePos;
	ICryCharInstance *pChar = m_pEntity->GetCharInterface()->GetCharacter(0);
	if (pChar)
	{
		ICryBone *m_pBoneHead = pChar->GetBoneByName("Bip01 Head"); // find bone in the list of bones;
        Vec3d bPos = m_pBoneHead->GetBonePosition();
        m_vEyePos = bPos + m_pEntity->GetPos();
	}
    //pos.z=pos.z+0.5f; // Надо так же сделать уровню глаз.
    pos=m_vEyePos;
    int HitOrNo = m_pGame->GetSystem()->GetIPhysicalWorld()->RayWorldIntersection(pos,dir,objTypes,flags,&hit,1,m_pEntity->GetPhysics());
    //int sees;
    //m_pEntity->GetScriptObject()->GetValue("sees", sees);

    /*AgentParameters params = pPuppet->GetPuppetParameters();
    m_pGame->GetSystem()->GetILog()->Log("\004 %s: RESPONSIVENESS: %f",m_pEntity->GetName(),params.m_fResponsiveness);
    pPuppet->SetPuppetParameters(params);*/

    if (HitOrNo&&pTargetEntity==0&&!InVehicle&&!HeJumping&&!IsAnimal&&!CurrentConversation&&!m_pPlayer->m_stats.moving
        &&!RunToTrigger&&!Following)
    {
		/*if (state->left || state->right)// && state->bHaveTarget)
		{
			Vec3d ang = m_pEntity->GetAngles();
			ang=ConvertToRadAngles(ang);

			Vec3d leftdir = ang;
			Matrix44 mat;
			mat.SetIdentity();
			if (state->left)
			{
				//mat.RotateMatrix(Vec3d(0,0,90));
		    mat=Matrix44::CreateRotationZYX(-Vec3d(0,0,+90)*gf_DEGTORAD)*mat; //NOTE: angles in radians and negated
			}
			else
			{
				//mat.RotateMatrix(Vec3d(0,0,-90));
				mat=Matrix44::CreateRotationZYX(-Vec3d(0,0,-90)*gf_DEGTORAD)*mat; //NOTE: angles in radians and negated
			}
			leftdir = mat.TransformPointOLD(leftdir);
			state->vMoveDir+=leftdir;
		}*/
        //pos.z=pos.z+0.1f; // Ахах, вверх улетел!
        if (NewAngleOnCollisions==0)
        {
            if (rand()%100<50)
            {
                //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: TURN +",m_pEntity->GetName());
                NewAngleOnCollisions=3.0f; // 3 или 5? // 3.0f
            }
            else
            {
                //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: TURN -",m_pEntity->GetName());
                NewAngleOnCollisions=-3.0f; // -3.0f
            }
        }
        angle.z=angle.z+NewAngleOnCollisions; // Другие оси глючат.
        if (IPuppetEntity) // Что-бы не поворачивались как бешенные.
        {
            AgentParameters params = pPuppet->GetPuppetParameters();
            //if (SetAlerted)
                //params.m_fResponsiveness = 10;
            //else
                params.m_fResponsiveness = 7.5f;
            pPuppet->SetPuppetParameters(params);
        }
        //m_pEntity->SetPos(pos);
        m_pEntity->SetAngles(angle); // Поправить остальные оси. Сделать поворот по другому. state->
        //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: TURN",m_pEntity->GetName());
        m_pEntity->GetScriptObject()->SetValue("TurningOnCollision", true);
    }
    //else if (NewAngleOnCollisions!=0||TurningOnCollision)
    else // Сделал условие так. Может это поможет избавиться от излишней крутливости.
    {
        //bool HeMoving = m_pEntity->IsMoving(); // Mode лучше подходит.
        if (IPuppetEntity&&Mode==0&&SetAlerted&&NewAngleOnCollisions!=0) // Что-бы не поворачивались как бешенные.
        {
            //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: STOP RESPONSIVENESS",m_pEntity->GetName());
            AgentParameters params = pPuppet->GetPuppetParameters();
            params.m_fResponsiveness = 0;
            //params.m_fResponsiveness = 7.5f;
            pPuppet->SetPuppetParameters(params);
        }
        else
        {
            //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: NORMAL RESPONSIVENESS",m_pEntity->GetName());
            if (IPuppetEntity&&!TempIsBlinded) // Что-бы не поворачивались как бешенные после выключения.
            {
                AgentParameters params = pPuppet->GetPuppetParameters();
                if (params.m_fResponsiveness==0)
                {
                    //m_pGame->GetSystem()->GetILog()->Log("\004 %s: m_fResponsiveness: %d",m_pEntity->GetName(),params.m_fResponsiveness);
                    //m_pGame->GetSystem()->GetILog()->Log("\004 %s: SET 7.5 RESPONSIVENESS",m_pEntity->GetName());
                    params.m_fResponsiveness = 7.5f;
                }
                pPuppet->SetPuppetParameters(params);
            }
            NewAngleOnCollisions=0;
            // При обнуленнии TurningOnCollision скрипт восстанавливает нормальный Responsiveness.
            m_pEntity->GetScriptObject()->SetValue("TurningOnCollision", false); // Пусть всегда NULL, а то может зависнуть.
        }
        //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: NOT TURN",m_pEntity->GetName());
    }
    if (NewAngleOnCollisions!=0)
    {
        AgentParameters params = pPuppet->GetPuppetParameters();
        if (params.m_fResponsiveness!=7.5f&&params.m_fResponsiveness!=0)
        {
            //m_pGame->GetSystem()->GetILog()->Log("\004 %s: 1 FORCE SET 7.5 RESPONSIVENESS: %f",m_pEntity->GetName(),params.m_fResponsiveness);
            params.m_fResponsiveness = 7.5f;
            //m_pGame->GetSystem()->GetILog()->Log("\004 %s: 2 FORCE SET 7.5 RESPONSIVENESS: %f",m_pEntity->GetName(),params.m_fResponsiveness);
        }
        pPuppet->SetPuppetParameters(params);
    }
}

//////////////////////////////////////////////////////////////////////
void CXPuppetProxy::UpdateStance(SOBJECTSTATE *state,Vec3d pos,Vec3d angle,Vec3d dir,ray_hit hit,int objTypes,int flags,
    bool IsAnimal,bool InVehicle,bool HeJumping,bool SetAlerted,bool CurrentConversation,IPuppet *pPuppet,
    bool IPuppetEntity,IEntity *pTargetEntity,int jobFlag,float SavePosZ,bool IsMutant,int Forward,int Strafe,int Standing,
    int Mode,IPipeUser *pPipeUser,bool FORCE_RUN,int NewPos,int NewSpeed)
{   //ЗАМЕНИТЬ ПАЙПЫ НА СВОИ!
    // GetDimensions может помочь.
    /*Vec3d pos = m_pEntity->GetPos();
    Vec3d angle = m_pEntity->GetAngles();
    Vec3d dir = ConvertToRadAngles(angle);
    pos.z=pos.z+0.5f;
    int SetPos = m_pGame->GetSystem()->GetIPhysicalWorld()->RayWorldIntersection(pos,dir,objTypes,flags,&hit,1,m_pEntity->GetPhysics());
    pPipeUser->InsertSubPipe(0,"setup_crouch");*/

    /*pos=m_pEntity->GetCamera()->GetPos();
    angle=m_pEntity->GetCamera()->GetAngles();
    dir = ConvertToRadAngles(angle);
    objTypes = ent_all+ent_ignore_noncolliding;
    flags = rwi_ignore_terrain_holes+rwi_ignore_noncolliding+rwi_ignore_back_faces+rwi_any_hit+
                rwi_pierceability_mask+rwi_pierceability0+rwi_stop_at_pierceable+
                rwi_separate_important_hits+rwi_colltype_bit;
    dir.x=0;
    dir.y=-1;
    dir.z=0;
    if (m_pGame->GetSystem()->GetIPhysicalWorld()->RayWorldIntersection(pos,dir,objTypes,flags,&hit,1,m_pEntity->GetPhysics()))
    {
        m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: CLOSE, NOT SEEN",m_pEntity->GetName());
    }*/

    pos.z=SavePosZ+0.1f;
    int LowHit = m_pGame->GetSystem()->GetIPhysicalWorld()->RayWorldIntersection(pos,dir,objTypes,flags,&hit,1,m_pEntity->GetPhysics());
    pos.z=SavePosZ+0.5f;
    int LowMediumHit = m_pGame->GetSystem()->GetIPhysicalWorld()->RayWorldIntersection(pos,dir,objTypes,flags,&hit,1,m_pEntity->GetPhysics());
    pos.z=SavePosZ+1.0f;
    int MediumHit = m_pGame->GetSystem()->GetIPhysicalWorld()->RayWorldIntersection(pos,dir,objTypes,flags,&hit,1,m_pEntity->GetPhysics());
    pos.z=SavePosZ+1.5f;
    int MediumHighHit = m_pGame->GetSystem()->GetIPhysicalWorld()->RayWorldIntersection(pos,dir,objTypes,flags,&hit,1,m_pEntity->GetPhysics());
    pos.z=SavePosZ+2.0f;
    int HighHit = m_pGame->GetSystem()->GetIPhysicalWorld()->RayWorldIntersection(pos,dir,objTypes,flags,&hit,1,m_pEntity->GetPhysics());
    /*if (LowHit)
        m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: LowHit",m_pEntity->GetName());
    if (LowMediumHit)
        m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: LowMediumHit",m_pEntity->GetName());
    if (MediumHit)
        m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: MediumHit",m_pEntity->GetName());
    if (MediumHighHit)
        m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: MediumHighHit",m_pEntity->GetName());
    if (HighHit)
        m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: HighHit",m_pEntity->GetName());
    */
     //pos.x=pos.x+0.2f;
    // МОГУТ ЗАЦИКЛИТЬСЯ МЕЖДУ ДВУМЯ ПОЛОЖЕНИЯМИ
    /*m_pScriptSystem->BeginCall("BasicAI","UpdateStance");
    m_pScriptSystem->PushFuncParam(m_pEntity->GetScriptObject());
    //m_pScriptSystem->PushFuncParam(38);
    m_pScriptSystem->EndCall();*/

    bool bBodyPositionChanged=false;
    /*if (NewPos)
    {
        m_iPrevStanding=NewPos;
        bBodyPositionChanged=true;
        m_pEntity->GetScriptObject()->SetValue("NewPos", NULL);
        m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: NewPos: %d",m_pEntity->GetName(),NewPos);
    }
    if (NewSpeed)
    {
        m_iPrevMode=NewSpeed;
        bBodyPositionChanged=true;
        m_pEntity->GetScriptObject()->SetValue("NewSpeed", NULL);
        m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: NewSpeed: %d",m_pEntity->GetName(),NewSpeed);
    }*/
    /*if (m_iEstimatedPosition&&m_iEstimatedPosition!=Standing)
    {
        m_iPrevStanding = Standing;
        m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: NewPrevPos: %d, EstimatedPosition: %d",m_pEntity->GetName(),m_iPrevStanding,m_iEstimatedPosition);
        m_iEstimatedPosition = NULL;
        bBodyPositionChanged = true;
    }
    if (m_iEstimatedSpeed&&m_iEstimatedSpeed!=Mode)
    {
        m_iPrevMode=Mode;
        m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: NewPrevSpeed: %d, EstimatedSpeed: %d",m_pEntity->GetName(),m_iPrevMode,m_iEstimatedSpeed);
        m_iEstimatedSpeed = NULL;
        bBodyPositionChanged = true;
    }*/
    if (m_iEstimatedPosition&&m_iEstimatedPosition!=Standing)
    {
        //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: Standing: %d, EstimatedPosition: %d",m_pEntity->GetName(),Standing,m_iEstimatedPosition);
        m_iPrevStanding = NULL;
        m_iEstimatedPosition = NULL;
        bBodyPositionChanged = true;
    }
    if (m_iEstimatedSpeed&&m_iEstimatedSpeed!=Mode)
    {
        //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: Speed: %d, EstimatedSpeed: %d",m_pEntity->GetName(),Mode,m_iEstimatedSpeed);
        m_iPrevMode = NULL;
        m_iEstimatedSpeed = NULL;
        bBodyPositionChanged = true;
    }
    /*float CurrentTime=CurrentTime=m_pGame->GetSystem()->GetITimer()->GetCurrTime();
    if (NewPos||NewSpeed)
    {
        if (m_fChageStanceTimeDelay == NULL)
            m_fChageStanceTimeDelay = CurrentTime+1.0f;
    }
    if (m_fChageStanceTimeDelay)
    {
        if (CurrentTime>m_fChageStanceTimeDelay)
            m_fChageStanceTimeDelay = NULL;
        else
            bBodyPositionChanged=true;
    }*/
    if (jobFlag==0&&!InVehicle&&!IsMutant&&!IsAnimal&&!bBodyPositionChanged)
    {
        //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: STANDING",m_pEntity->GetName());
        if (m_iPrevStanding!=Standing)
        {
            if (m_iPrevStanding==0&&!HighHit)
                {
                    //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: PrevPos: %d",m_pEntity->GetName(),m_iPrevStanding);
                    pPipeUser->InsertSubPipe(0,"setup_stand");
                    m_iPrevStanding=NULL;
                    bBodyPositionChanged=true;
                }
            else if (m_iPrevStanding==1&&!LowMediumHit&&!MediumHit)
                {
                    //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: PrevPos: %d",m_pEntity->GetName(),m_iPrevStanding);
                    pPipeUser->InsertSubPipe(0,"setup_crouch");
                    m_iPrevStanding=NULL;
                    bBodyPositionChanged=true;
                }
            else if (m_iPrevStanding==2&&!LowHit&&!LowMediumHit)
                {
                    //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: PrevPos: %d",m_pEntity->GetName(),m_iPrevStanding);
                    pPipeUser->InsertSubPipe(0,"setup_prone");
                    m_iPrevStanding=NULL;
                    bBodyPositionChanged=true;
                }
            else if (m_iPrevStanding==3&&!MediumHit&&!MediumHighHit)
                {
                    //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: PrevPos: %d",m_pEntity->GetName(),m_iPrevStanding);
                    pPipeUser->InsertSubPipe(0,"setup_stealth");
                    m_iPrevStanding=NULL;
                    bBodyPositionChanged=true;
                }

        }
        if (m_iPrevMode!=Mode&&bBodyPositionChanged)
        {
            if (m_iPrevMode==1)
                {
                    //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: PrevSpeed: %d",m_pEntity->GetName(),m_iPrevMode);
                    pPipeUser->InsertSubPipe(0,"do_it_walking");
                    m_iPrevMode=NULL;
                }
            else if (m_iPrevMode==2)
                {
                    //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: PrevSpeed: %d",m_pEntity->GetName(),m_iPrevMode);
                    pPipeUser->InsertSubPipe(0,"do_it_running");
                    m_iPrevMode=NULL;
                }
        }
    }
    if (!LowHit&&!LowMediumHit&&!MediumHit&&!MediumHighHit&&HighHit&&Standing!=3&&jobFlag==0&&!InVehicle&&!IsMutant&&!IsAnimal&&Standing==0&&!bBodyPositionChanged)
    {
        if (!FORCE_RUN&&Mode!=1)
        {
            //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: STEALTHING",m_pEntity->GetName());
            /*if (!m_iPrevStanding)
                m_iPrevStanding=Standing;
            if (!m_iPrevMode)
                m_iPrevMode=Mode;*/
            /*if (!m_iPrevStanding)
            {
                m_iPrevStanding=Standing;
                if (!m_iPrevMode)
                    m_iPrevMode=Mode;
            }*/
            if (!m_iPrevStanding) // Тест.
            {
                m_iPrevStanding=Standing;
                m_iPrevMode=Mode;
                m_iEstimatedPosition=3;
                m_iEstimatedSpeed=1;
            }
            pPipeUser->InsertSubPipe(0,"setup_stealth");
            pPipeUser->InsertSubPipe(0,"do_it_walking");
            bBodyPositionChanged=true;
        }
        else if (Mode!=2)
        {
            //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: STEALTHING 2",m_pEntity->GetName());
            if (!m_iPrevStanding)
            {
                m_iPrevStanding=Standing;
                m_iPrevMode=Mode;
                m_iEstimatedPosition=3;
                m_iEstimatedSpeed=2;
            }
            pPipeUser->InsertSubPipe(0,"setup_stealth");
            pPipeUser->InsertSubPipe(0,"do_it_running");
            bBodyPositionChanged=true;
        }
    }
    if (!LowHit&&!LowMediumHit&&!MediumHit&&MediumHighHit&&HighHit&&Standing!=1&&Mode!=1&&jobFlag==0&&!InVehicle&&!IsMutant&&!IsAnimal&&!bBodyPositionChanged)
    {
         //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: CROUNCHING",m_pEntity->GetName());
         if (!m_iPrevStanding)
         {
             m_iPrevStanding=Standing;
             m_iPrevMode=Mode;
             m_iEstimatedPosition=1;
             m_iEstimatedSpeed=1;
         }
         pPipeUser->InsertSubPipe(0,"setup_crouch");
         pPipeUser->InsertSubPipe(0,"do_it_walking");
         bBodyPositionChanged=true;
    }
    if (!LowHit&&!LowMediumHit&&MediumHit&&MediumHighHit&&HighHit&&Standing!=2&&Mode!=1&&jobFlag==0&&!InVehicle&&!IsMutant&&!IsAnimal&&!bBodyPositionChanged)
    {
        //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: PRONING",m_pEntity->GetName());
        if (!m_iPrevStanding)
        {
            m_iPrevStanding=Standing;
            m_iPrevMode=Mode;
            m_iEstimatedPosition=2;
            m_iEstimatedSpeed=1;
        }
        pPipeUser->InsertSubPipe(0,"setup_prone");
        pPipeUser->InsertSubPipe(0,"do_it_walking");
        bBodyPositionChanged=true;
    }

    if ((Standing==1||Standing==2)&&Mode==2&&m_iPrevMode&&jobFlag==0&&!InVehicle&&!IsMutant&&!IsAnimal&&(!bBodyPositionChanged||(m_fChageStanceTimeDelay&&bBodyPositionChanged)))
    {
        //m_pGame->GetSystem()->GetILog()->Log("\004 %s: FORCE WALKING",m_pEntity->GetName());
        pPipeUser->InsertSubPipe(0,"do_it_walking");
        bBodyPositionChanged=true;
    }
}


//////////////////////////////////////////////////////////////////////
void CXPuppetProxy::UpdateJumping(SOBJECTSTATE *state,Vec3d pos,Vec3d angle,Vec3d dir,ray_hit hit,int objTypes,int flags,
    bool IsAnimal,bool InVehicle,bool HeJumping,bool SetAlerted,bool CurrentConversation,IPuppet *pPuppet,
    bool IPuppetEntity,IEntity *pTargetEntity,int jobFlag,float SavePosZ,bool IsMutant,int Forward,int Strafe,int Standing,
    int Mode,IPipeUser *pPipeUser,bool FORCE_RUN,bool ALLOW_JUMP)
{
    // Тоже самое, только без флагов (указания типов объектов).
    pos.z=SavePosZ+0.1f;
    int LowHit = m_pGame->GetSystem()->GetIPhysicalWorld()->RayWorldIntersection(pos,dir,objTypes,0,&hit,1,m_pEntity->GetPhysics());
    pos.z=SavePosZ+0.5f;
    int LowMediumHit = m_pGame->GetSystem()->GetIPhysicalWorld()->RayWorldIntersection(pos,dir,objTypes,0,&hit,1,m_pEntity->GetPhysics());
    pos.z=SavePosZ+1.0f;
    int MediumHit = m_pGame->GetSystem()->GetIPhysicalWorld()->RayWorldIntersection(pos,dir,objTypes,0,&hit,1,m_pEntity->GetPhysics());
    pos.z=SavePosZ+1.5f;
    int MediumHighHit = m_pGame->GetSystem()->GetIPhysicalWorld()->RayWorldIntersection(pos,dir,objTypes,0,&hit,1,m_pEntity->GetPhysics());
    pos.z=SavePosZ+2.0f;
    int HighHit = m_pGame->GetSystem()->GetIPhysicalWorld()->RayWorldIntersection(pos,dir,objTypes,0,&hit,1,m_pEntity->GetPhysics());
    bool UseJumpAnim;
    m_pEntity->GetScriptObject()->GetValue("UseJumpAnim", UseJumpAnim);
    bool CrouchAfterJump;
    m_pEntity->GetScriptObject()->GetValue("CrouchAfterJump", CrouchAfterJump);
    bool AI_AtWeapon; // Успел или не успел сесть за пулемёт
    m_pEntity->GetScriptObject()->GetValue("AI_AtWeapon", AI_AtWeapon);
    bool Following; // Когда ИИ игрок следует за игроком, но его не пускает через запретную зону.
    m_pEntity->GetScriptObject()->GetValue("Following", Following);
    if (ALLOW_JUMP) // Флаг разрешает прыгать в режиме работы.
        jobFlag=0;
    const char *szCB=0; // CurrentBehaviour. Имя текущего поведения.
	if (m_AIHandler.m_pBehavior)
		m_AIHandler.m_pBehavior->GetValue("Name",szCB);
    //if (m_pPlayer->m_stats.flying&&m_pPlayer->m_stats.moving&&Standing==1&&Forward==1&&!InVehicle&&!IsMutant&&jobFlag==0&&!IsAnimal)
    /*if (m_pPlayer->m_stats.flying&&m_pPlayer->m_stats.moving&&Forward==1&&!InVehicle&&!IsMutant&&jobFlag==0&&!IsAnimal)
    {
        //if (LowHit&&!LowMediumHit&&!MediumHit&&!MediumHighHit&&!HighHit&&CrouchAfterJump)
        if (LowHit&&!LowMediumHit&&!MediumHit&&CrouchAfterJump)
        {
            //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: JUMPING0",m_pEntity->GetName());
            m_pScriptSystem->BeginCall("BasicAI","DoJump2");
            m_pScriptSystem->PushFuncParam(m_pEntity->GetScriptObject()); // Первый параметр
            m_pScriptSystem->PushFuncParam(20); // Первый параметр, который используется.
            m_pScriptSystem->PushFuncParam(60);
            m_pScriptSystem->EndCall();
            //m_pEntity->GetScriptObject()->SetValue("UseJumpAnim", 1);
            m_pEntity->GetScriptObject()->SetValue("HeJumping", 1);
        }
    }*/
    // ещё добавить проверку на только начал движение или уже давно.. убрать из коллизий кусты
    if (!m_pPlayer->m_stats.flying&&m_pPlayer->m_stats.moving&&Forward==1&&!InVehicle&&!IsMutant&&jobFlag==0&&!IsAnimal&&(LowHit||LowMediumHit||MediumHit||MediumHighHit||HighHit))
    {
        //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: JUMPING MAN",m_pEntity->GetName());
        /*if (LowHit&&!LowMediumHit&&!MediumHit&&!MediumHighHit&&!HighHit)
        {
            m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: JUMPING1",m_pEntity->GetName());
            m_pScriptSystem->BeginCall("BasicAI","DoJump2");
            m_pScriptSystem->PushFuncParam(m_pEntity->GetScriptObject()); // Первый параметр
            m_pScriptSystem->PushFuncParam(20); // Первый параметр, который используется.
            m_pScriptSystem->EndCall();
            m_pEntity->GetScriptObject()->SetValue("UseJumpAnim", 1);
            m_pEntity->GetScriptObject()->SetValue("HeJumping", 1);
        }*/
        if (LowHit&&LowMediumHit&&!MediumHit&&!MediumHighHit&&!HighHit&&Standing==0)
        {
            //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: JUMPING2",m_pEntity->GetName());
            m_pScriptSystem->BeginCall("BasicAI","DoJump2");
            m_pScriptSystem->PushFuncParam(m_pEntity->GetScriptObject());
            m_pScriptSystem->PushFuncParam(50); //80
            m_pScriptSystem->PushFuncParam(35);
            m_pScriptSystem->EndCall();
            m_pEntity->GetScriptObject()->SetValue("UseJumpAnim", 1);
            m_pEntity->GetScriptObject()->SetValue("HeJumping", 1);
        }
        else if (LowHit&&LowMediumHit&&MediumHit&&!MediumHighHit&&!HighHit&&Standing==0)
        {
            //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: JUMPING3",m_pEntity->GetName());
            m_pScriptSystem->BeginCall("BasicAI","DoJump2");
            m_pScriptSystem->PushFuncParam(m_pEntity->GetScriptObject());
            m_pScriptSystem->PushFuncParam(55); // 80
            m_pScriptSystem->PushFuncParam(35);
            m_pScriptSystem->EndCall();
            pPipeUser->InsertSubPipe(0,"setup_crouch");
            pPipeUser->InsertSubPipe(0,"do_it_walking");
            m_pEntity->GetScriptObject()->SetValue("UseJumpAnim", 1);
            m_pEntity->GetScriptObject()->SetValue("CrouchAfterJump", 1);
            m_pEntity->GetScriptObject()->SetValue("HeJumping", 1);
        }
        else if (LowHit&&LowMediumHit&&MediumHit&&MediumHighHit&&!HighHit&&Standing==0) // ==0 в угоду джунглям, !=2 - трубам.
        {
            //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: JUMPING4",m_pEntity->GetName());
            m_pScriptSystem->BeginCall("BasicAI","DoJump2");
            m_pScriptSystem->PushFuncParam(m_pEntity->GetScriptObject());
            m_pScriptSystem->PushFuncParam(60); // 90
            m_pScriptSystem->PushFuncParam(35);
            m_pScriptSystem->EndCall();
            pPipeUser->InsertSubPipe(0,"setup_crouch");
            //pPipeUser->InsertSubPipe(0,"do_it_walking");
            pPipeUser->InsertSubPipe(0,"do_it_running");
            m_pEntity->GetScriptObject()->SetValue("UseJumpAnim", 1);
            m_pEntity->GetScriptObject()->SetValue("CrouchAfterJump", 1);
            m_pEntity->GetScriptObject()->SetValue("HeJumping", 1);
        }
        else if (!LowHit&&!LowMediumHit&&!MediumHit&&MediumHighHit&&!HighHit&&(Standing==0||Standing==3)) // Трубная штука на кулере.
        {
            //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: JUMPING5",m_pEntity->GetName());
            m_pScriptSystem->BeginCall("BasicAI","DoJump2");
            m_pScriptSystem->PushFuncParam(m_pEntity->GetScriptObject());
            m_pScriptSystem->PushFuncParam(65); // 38
            m_pScriptSystem->PushFuncParam(35);
            m_pScriptSystem->EndCall();
            pPipeUser->InsertSubPipe(0,"setup_crouch");
            //pPipeUser->InsertSubPipe(0,"do_it_walking");
            pPipeUser->InsertSubPipe(0,"do_it_running");
            m_pEntity->GetScriptObject()->SetValue("UseJumpAnim", 1);
            m_pEntity->GetScriptObject()->SetValue("CrouchAfterJump", 1);
            m_pEntity->GetScriptObject()->SetValue("HeJumping", 1);
        }
    }
    /*if (CrouchAfterJump)
    {
        m_pScriptSystem->BeginCall("BasicAI","DoJump2");
        m_pScriptSystem->PushFuncParam(m_pEntity->GetScriptObject());
        m_pScriptSystem->PushFuncParam(10);
        m_pScriptSystem->PushFuncParam(100); //60
        m_pScriptSystem->EndCall();
       // m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: Push on fly forward",m_pEntity->GetName());
    }*/
    if (!m_pPlayer->m_stats.flying) // Если уже не в прыжке, то отключить...
    {
        if (HeJumping)
            m_pEntity->GetScriptObject()->SetValue("HeJumping", 0);
        if (UseJumpAnim)
            m_pEntity->GetScriptObject()->SetValue("UseJumpAnim", 0);
        if (CrouchAfterJump) //Булево
        {
            //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: CrouchAfterJump",m_pEntity->GetName());
            pPipeUser->InsertSubPipe(0,"setup_crouch");
            pPipeUser->InsertSubPipe(0,"do_it_walking");

            m_pScriptSystem->BeginCall("BasicAI","DoJump2");
            m_pScriptSystem->PushFuncParam(m_pEntity->GetScriptObject());
            m_pScriptSystem->PushFuncParam(20);
            m_pScriptSystem->PushFuncParam(20); //60
            m_pScriptSystem->EndCall();

            m_pEntity->GetScriptObject()->SetValue("CrouchAfterJump", 0);
        }
        if ((Following||szCB=="SearchAmmunition"||(!AI_AtWeapon&&szCB=="MountedGuy")||szCB=="RunToAlarm"
            ||szCB=="RunPath"||szCB=="RunToFriend"||szCB=="SharedReinforce"||szCB=="Job_RunTo"
            ||(szCB=="Job_RunToActivated"&&Mode==2))&&Standing==0&&(!m_pPlayer->m_stats.moving||!m_pEntity->IsMoving())) // Это ведь у всех против застревания может работать если удастся синхронизировать положение тела и скорость бега.
        {
            //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: JUMPING ON STUK",m_pEntity->GetName());
            m_pScriptSystem->BeginCall("BasicAI","DoJump2");
            m_pScriptSystem->PushFuncParam(m_pEntity->GetScriptObject());
            m_pScriptSystem->PushFuncParam(45);
            m_pScriptSystem->PushFuncParam(35);
            m_pScriptSystem->EndCall();
            m_pEntity->GetScriptObject()->SetValue("UseJumpAnim", 1);
            m_pEntity->GetScriptObject()->SetValue("HeJumping", 1);
        }
    }
}
//////////////////////////////////////////////////////////////////////
bool CXPuppetProxy::QueryProxy(unsigned char type, void **pProxy)
{
	if (type == AIPROXY_PUPPET)
	{
		*pProxy = (void *) this;
		return true;
	}
	else
		return false;
}

//////////////////////////////////////////////////////////////////////
void CXPuppetProxy::UpdateAvoidCollisions(SOBJECTSTATE *state,Vec3d pos,Vec3d angle,int Forward,int Strafe,int Standing,
    int Mode,IPipeUser *pPipeUser,bool CurrentConversation,bool DoNotAvoidCollisionsOnTheMoveForward,int jobFlag,
    bool FORCE_RUN)
{
    if (m_fSavedPos==pos&&(Forward==1||m_pPlayer->m_stats.moving||m_pEntity->IsMoving())&&m_bPrevMovingStats
        &&(m_bAllowAvoidCollisions||FORCE_RUN!=0)) // Положительный стрейф - влево.
    { // Пусть остаётся, иногда нужно.
        //if (m_nStrafeOnCollisions==NULL)
        {
            //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: COLLISION",m_pEntity->GetName());
            /*IGoalPipe *NewPipe=m_pGame->GetSystem()->GetAISystem()->CreateGoalPipe("strafe");
            GoalParameters par;
            if (rand()%100<50)
                par.m_nStrafeOnCollisions=10;
            else
                par.m_nStrafeOnCollisions=-10;
            NewPipe->PushGoal("strafe",1,par);*/
            m_nStrafeOnCollisions=1;
            if (rand()%100<50)
                pPipeUser->InsertSubPipe(0,"on_collision_strafe_left");
            else
                pPipeUser->InsertSubPipe(0,"on_collision_strafe_right");
            pPipeUser->InsertSubPipe(0,"on_collision_backoff"); // Лучше когда после стрейфа, тогда и стрейф, и баскофф проходит как надо.
            //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: StrafeOnCollisions",m_pEntity->GetName());
        }
    }
    else if (m_nStrafeOnCollisions!=NULL)
        m_nStrafeOnCollisions=NULL;
        //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: NOT COLLISION",m_pEntity->GetName());
    m_fSavedPos=pos; // Не убирать.
    ////////////////////////////////////////
    /*Vec3d ang = m_pEntity->GetAngles();
    ang=ConvertToRadAngles(ang);
    Vec3d leftdir = ang;
    Matrix44 mat;
    mat.SetIdentity();
    // +90 - влево, -90 вправо, 0 - вперёд, 180 - назад.
    mat=Matrix44::CreateRotationZYX(-Vec3d(0,0,-180)*gf_DEGTORAD)*mat;
    leftdir = mat.TransformPointOLD(leftdir);
    state->vMoveDir+=leftdir;*/

    Vec3d dir = ConvertToRadAngles(angle);
    ray_hit hit;
    //int objTypes = ent_all-ent_terrain+ent_ignore_noncolliding;
    int objTypes = ent_all+ent_ignore_noncolliding;
    // Флаги тоже учитываются.
    int flags = rwi_ignore_terrain_holes+rwi_ignore_noncolliding+rwi_ignore_back_faces+rwi_any_hit+
                rwi_pierceability_mask+rwi_pierceability0+rwi_stop_at_pierceable+
                rwi_separate_important_hits; // +rwi_colltype_bit - кусты.
    Vec3d RayPos=pos;
    RayPos.z=RayPos.z+0.5f; //0.5f;
    Matrix44 mat;
    Matrix44 TempMat;
    mat.SetIdentity();
    // +90 - влево, -90 вправо, 0 - вперёд, 180 - назад.
    TempMat=Matrix44::CreateRotationZYX(-Vec3d(0,0,0)*gf_DEGTORAD)*mat;
    Vec3d ForwardDir = TempMat.TransformPointOLD(dir);
    int ForwardHit = m_pGame->GetSystem()->GetIPhysicalWorld()->RayWorldIntersection(RayPos,ForwardDir,objTypes,flags,&hit,1,m_pEntity->GetPhysics());
    TempMat=Matrix44::CreateRotationZYX(-Vec3d(0,0,180)*gf_DEGTORAD)*mat;
    Vec3d BackDir = TempMat.TransformPointOLD(dir);
    int BackHit = m_pGame->GetSystem()->GetIPhysicalWorld()->RayWorldIntersection(RayPos,BackDir,objTypes,flags,&hit,1,m_pEntity->GetPhysics());
    TempMat=Matrix44::CreateRotationZYX(-Vec3d(0,0,+90)*gf_DEGTORAD)*mat;
    Vec3d LeftDir = TempMat.TransformPointOLD(dir);
    int LeftHit = m_pGame->GetSystem()->GetIPhysicalWorld()->RayWorldIntersection(RayPos,LeftDir,objTypes,flags,&hit,1,m_pEntity->GetPhysics());
    TempMat=Matrix44::CreateRotationZYX(-Vec3d(0,0,-90)*gf_DEGTORAD)*mat;
    Vec3d RightDir = TempMat.TransformPointOLD(dir);
    int RightHit = m_pGame->GetSystem()->GetIPhysicalWorld()->RayWorldIntersection(RayPos,RightDir,objTypes,flags,&hit,1,m_pEntity->GetPhysics());
    TempMat=Matrix44::CreateRotationZYX(-Vec3d(0,0,+45)*gf_DEGTORAD)*mat;
    Vec3d ForwardLeftDir = TempMat.TransformPointOLD(dir);
    int ForwardLeftHit = m_pGame->GetSystem()->GetIPhysicalWorld()->RayWorldIntersection(RayPos,ForwardDir,objTypes,flags,&hit,1,m_pEntity->GetPhysics());
    TempMat=Matrix44::CreateRotationZYX(-Vec3d(0,0,-45)*gf_DEGTORAD)*mat;
    Vec3d ForwardRightDir = TempMat.TransformPointOLD(dir);
    int ForwardRightHit = m_pGame->GetSystem()->GetIPhysicalWorld()->RayWorldIntersection(RayPos,ForwardDir,objTypes,flags,&hit,1,m_pEntity->GetPhysics());
    TempMat=Matrix44::CreateRotationZYX(-Vec3d(0,0,+135)*gf_DEGTORAD)*mat;
    Vec3d BackLeftDir = TempMat.TransformPointOLD(dir);
    int BackLeftHit = m_pGame->GetSystem()->GetIPhysicalWorld()->RayWorldIntersection(RayPos,BackDir,objTypes,flags,&hit,1,m_pEntity->GetPhysics());
    TempMat=Matrix44::CreateRotationZYX(-Vec3d(0,0,-135)*gf_DEGTORAD)*mat;
    Vec3d BackRightDir = TempMat.TransformPointOLD(dir);
    int BackRightHit = m_pGame->GetSystem()->GetIPhysicalWorld()->RayWorldIntersection(RayPos,BackDir,objTypes,flags,&hit,1,m_pEntity->GetPhysics());
    if (ForwardHit)
        dir=BackDir;
    else if (BackHit)
        dir=ForwardDir;
    else if (LeftHit)
        dir=RightDir;
    else if (RightHit)
        dir=LeftDir;
    else if (ForwardLeftHit)
        dir=BackRightDir;
    else if (ForwardRightHit)
        dir=BackLeftDir;
    else if (BackLeftHit)
        dir=ForwardRightDir;
    else if (BackRightHit)
        dir=ForwardLeftDir;
    bool HeMeleeAttack;
    m_pEntity->GetScriptObject()->GetValue("HeMeleeAttack", HeMeleeAttack); // Для людей тоже сделать.
    // Скобки сразу после jobFlag==0&& и в самом перед конце добавил недавно. Проверка.
    if ((jobFlag==0||FORCE_RUN!=0)&&(((Standing!=3&&Mode!=1&&!m_pPlayer->m_stats.moving)||(Standing!=3&&Mode==1)||(Standing==3&&Mode!=1))
        &&(!DoNotAvoidCollisionsOnTheMoveForward||(DoNotAvoidCollisionsOnTheMoveForward&&Forward==1&&!ForwardLeftHit
        &&!ForwardHit&&!ForwardRightHit))&&!CurrentConversation)) // Сделать, если не в движении, и в работе то не отталкивать. Хотя, джоб почему-то во время роликов не работает
        m_bAllowAvoidCollisions=true;
    else if (m_bAllowAvoidCollisions)
        m_bAllowAvoidCollisions=false;
    if (m_bAllowAvoidCollisions)
    {
        if (ForwardHit)
        { // Мутант пройти пытается, а ему избегание коллизий мешает. Надо сделать если прыгун не двигается, тогда поправлять.
            if (!BackHit&&!HeMeleeAttack&&!CurrentConversation)
                state->vMoveDir+=dir;
            if (Forward==1&&!HeMeleeAttack&&!CurrentConversation)
            {
                if (!LeftHit&&!ForwardLeftHit&&ForwardHit&&ForwardRightHit)
                    pPipeUser->InsertSubPipe(0,"on_collision_strafe_left");
                else if (!RightHit&&!ForwardRightHit&&ForwardHit&&ForwardLeftHit)
                    pPipeUser->InsertSubPipe(0,"on_collision_strafe_right");
                else if (rand()%100<50&&!LeftHit)
                    pPipeUser->InsertSubPipe(0,"on_collision_strafe_left");
                else if (!RightHit)
                    pPipeUser->InsertSubPipe(0,"on_collision_strafe_right");
            }
        }
        else if ((BackHit&&!ForwardHit)
                ||(LeftHit&&!RightHit)
                ||(!LeftHit&&RightHit)
                ||(ForwardLeftHit&&!BackRightHit&&!HeMeleeAttack&&!CurrentConversation)
                ||(!ForwardLeftHit&&BackRightHit)
                ||(ForwardRightHit&&!BackLeftHit&&!HeMeleeAttack&&!CurrentConversation)
                ||(!ForwardRightHit&&BackLeftHit))
                {
                    state->vMoveDir+=dir; // Вот эта штука и заставляет двигаться.
                    //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: state->vMoveDir",m_pEntity->GetName());
                }
    }
}
//////////////////////////////////////////////////////////////////////
void CXPuppetProxy::SetRootBone(const char *pRootBone)
{
	m_strRootBone = pRootBone;
}

//////////////////////////////////////////////////////////////////////
void CXPuppetProxy::SetSpeeds(float fwd, float bkw)
{
	m_fForwardSpeed = fwd;
	m_fBackwardSpeed = bkw;
	if(m_pPlayer)
		m_pPlayer->SetWalkSpeed( m_fForwardSpeed );
}

//////////////////////////////////////////////////////////////////////
void CXPuppetProxy::SetPuppetDimensions(float height, float eye_height, float sphere_height, float radius)
{
	m_dimStandingPuppet.heightEye = eye_height;
	m_dimStandingPuppet.heightCollider = sphere_height;
	m_dimStandingPuppet.sizeCollider.Set(0.6f,0.6f,radius);

	m_dimCrouchingPuppet.heightEye = eye_height * 0.5f;
	m_dimCrouchingPuppet.heightCollider = sphere_height * 0.5f;
	m_dimCrouchingPuppet.sizeCollider.Set(0.6f, 0.6f, radius*0.5f);

	m_dimProningPuppet.heightEye = eye_height *0.2f;
	m_dimProningPuppet.heightCollider = sphere_height * 0.2f;
	m_dimProningPuppet.sizeCollider.Set(0.7f, 0.6f, radius*0.2f);
}

//////////////////////////////////////////////////////////////////////
void CXPuppetProxy::GetDimensions(int bodypos, float &eye_height, float &height)
{
	if (bodypos)
	{
		if (bodypos == 1)
		{
			eye_height = m_dimCrouchingPuppet.heightEye;
            height = m_dimCrouchingPuppet.heightEye+0.05f;
		}
		else
		{
			eye_height = m_dimProningPuppet.heightEye;
            height = m_dimProningPuppet.heightEye+0.05f;
		}
	}
	else
	{
		eye_height = m_dimStandingPuppet.heightEye;
		height = m_dimStandingPuppet.heightEye+0.05f;
	}
}

//////////////////////////////////////////////////////////////////////
int CXPuppetProxy::UpdateMotor(SOBJECTSTATE *state)
{
	// create table to pass to motor script
	return 0;
}

//////////////////////////////////////////////////////////////////////
void CXPuppetProxy::UpdateMind(SOBJECTSTATE *state)
{
    //m_pGame->GetSystem()->GetILog()->LogToConsole("\004 %s: UpdateMind",m_pEntity->GetName());
	m_AIHandler.AIMind(state);
	state->bReevaluate = false;
	return;

	bool bScriptControl = false;
    int AllowVisible;
    m_pEntity->GetScriptObject()->GetValue("AllowVisible",AllowVisible);
	if (!state->bHaveTarget||(state->bHaveTarget&&AllowVisible==0))
		int a=5;

	_SmartScriptObject pTable(m_pScriptSystem);
	pTable->SetValue("haveTarget",state->bHaveTarget);
	pTable->SetValue("fInterest",state->fInterest);
	pTable->SetValue("fThreat",state->fThreat);
	pTable->SetValue("fDistance",state->fDistanceFromTarget);
	pTable->SetValue("nType",state->nTargetType);
	pTable->SetValue("bMemory",state->bMemory);
	pTable->SetValue("bSound",state->bSound);
	pTable->SetValue("bTakingDamage",state->bTakingDamage);
	pTable->SetValue("bTargetEnabled",state->bTargetEnabled);

	m_pScriptSystem->BeginCall( m_hBehaviourFunc );
	m_pScriptSystem->PushFuncParam(m_pEntity->GetScriptObject());
	m_pScriptSystem->PushFuncParam(*pTable);
	m_pScriptSystem->EndCall(bScriptControl);

	state->bReevaluate = false;
}

//////////////////////////////////////////////////////////////////////
void CXPuppetProxy::Reset(void)
{
	if (m_pPlayer)
			m_pPlayer->m_stats.FiringType = eNotFiring;
}

//////////////////////////////////////////////////////////////////////
void CXPuppetProxy::SendSignal(int signalID, const char * szText, IEntity *pSender)
{
	m_pEntity->SetNeedUpdate( true );
	m_AIHandler.AISignal( signalID, szText, pSender );
}

//////////////////////////////////////////////////////////////////////
void CXPuppetProxy::SendAuxSignal(int signalID, const char * szText)
{
	m_AIHandler.DoReadibilityPack(szText);
}

//////////////////////////////////////////////////////////////////////
void CXPuppetProxy::SetSignalFunc(HSCRIPTFUNCTION pFunc)
{
	m_hSignalFunc.Init(m_pScriptSystem,pFunc);
}

//////////////////////////////////////////////////////////////////////
void CXPuppetProxy::SetBehaviourFunc(HSCRIPTFUNCTION pFunc)
{
	m_hBehaviourFunc.Init(m_pScriptSystem,pFunc);
}

//////////////////////////////////////////////////////////////////////
void CXPuppetProxy::SetMotorFunc(HSCRIPTFUNCTION pFunc)
{
	m_hMotorFunc.Init(m_pScriptSystem,pFunc);
}

//////////////////////////////////////////////////////////////////////
bool CXPuppetProxy::CustomUpdate(Vec3d & vPos, Vec3d & vAngles)
{
	if (m_pPlayer)
	{
		if (_isnan(m_pPlayer->m_vCharacterAngles.x) || _isnan(m_pPlayer->m_vCharacterAngles.y) || _isnan(m_pPlayer->m_vCharacterAngles.z))
			GameWarning("m_vCharacterAngles for entity %s are NaN",m_pEntity->GetName());
		else
			vAngles = m_pPlayer->m_vCharacterAngles;
	}
	return false;
}

//////////////////////////////////////////////////////////////////////
void CXPuppetProxy::DebugDraw(struct IRenderer * pRenderer)
{
	pRenderer->TextToScreenColor(50,66,0.3f,0.3f,0.3f,1.f,"- Proxy Information --");

	const char *szCurrentBehaviour=0;
	const char *szPreviousBehaviour=0;
	const char *szFirstBehaviour=0;

	if (m_AIHandler.m_pBehavior)
		m_AIHandler.m_pBehavior->GetValue("Name",szCurrentBehaviour);

	if (m_AIHandler.m_pPreviousBehavior)
		m_AIHandler.m_pPreviousBehavior->GetValue("Name",szPreviousBehaviour);

	if (!m_AIHandler.m_FirstBehaviorName.empty())
		szFirstBehaviour = m_AIHandler.m_FirstBehaviorName.c_str();


	pe_player_dynamics pdyn;
	m_pEntity->GetPhysics()->GetParams(&pdyn);
	pRenderer->TextToScreen(50,70,"GRAVITY IN PHYSICS :%.3f  AirControl: %.3f",pdyn.gravity,pdyn.kAirControl);

	if (m_pPlayer)
	{
		if (m_pPlayer->m_weaponPositionState == 1)
			pRenderer->TextToScreen(50,72,"WEAPON HOLSTERED");
		else if (m_pPlayer->m_weaponPositionState == 2)
			pRenderer->TextToScreen(50,72,"HOLDING WEAPON");
		else
			pRenderer->TextToScreen(50,72,"WEAPON POS UNDEFINED");
	}

	pe_status_living pliv;
	m_pEntity->GetPhysics()->GetStatus(&pliv);
	if (IsEquivalent(pliv.vel,pliv.velRequested,0.1f))
		pRenderer->SetMaterialColor(1,1,1,1);
	else
		pRenderer->SetMaterialColor(1,0,0,1);
	pRenderer->TextToScreen(40,66,"VEL_REQUESTED:(%.2f,%.2f,%.2f)  ACTUAL_VEL:(%.2f,%.2f,%.2f)",
		pliv.velRequested.x,pliv.velRequested.y,pliv.velRequested.z,pliv.vel.x,pliv.vel.y,pliv.vel.z);


	pRenderer->TextToScreen(50,74,"BEHAVIOUR: %s",szCurrentBehaviour);
	pRenderer->TextToScreen(50,76," PREVIOUS BEHAVIOUR: %s",szPreviousBehaviour);
	pRenderer->TextToScreen(50,78," DESIGNER ASSIGNED BEHAVIOUR: %s",szFirstBehaviour);


	ICryCharInstance *pInstance = m_pEntity->GetCharInterface()->GetCharacter(0);
	if (pInstance)
	{
		for (int i=0;i<5;i++)
		{
			int nId=-1;
			if ((nId = pInstance->GetCurrentAnimation(i))>=0)
			{
				pRenderer->TextToScreen(50.f,80.f+2*i," LAYER %d: ANIM: %s",i,pInstance->GetModel()->GetAnimationSet()->GetName(nId));
			}
		}

		pRenderer->TextToScreen(50,68,"Current animation scale %.3f",pInstance->GetAnimationSpeed());
	}
}

//////////////////////////////////////////////////////////////////////
void CXPuppetProxy::OnAnimationEvent(const char *sAnimation,AnimSinkEventData UserData)
{
	// only used for synchronizing animation jumps
	if (UserData.p == (void*)JUMP_TAKEOFF)
	{
		m_bInJump = true;
		pe_action_move motion;
		motion.dir = m_vJumpVector;
		motion.iJump = 1;
		m_pEntity->GetPhysics()->Action(&motion);
		m_pGame->GetSystem()->GetILog()->Log("\003 [AIWARNING] -------%s--------------- NOW APPLYING JUMP ACTION!! --------------------------------",sAnimation);

		_SmartScriptObject pDesiredJumpType(m_pScriptSystem,true);
		if (pJumpTable->GetAt(m_nJumpDirection,pDesiredJumpType))
		{
			_SmartScriptObject pDesiredJump(m_pScriptSystem,true);
			if (pDesiredJumpType->GetAt(m_nLastSelectedJumpAnim,pDesiredJump))
			{
				int nTakeoffFrame, nLandFrame;
				pDesiredJump->GetAt(2,nTakeoffFrame);
				pDesiredJump->GetAt(3,nLandFrame);

				float in_air_duration = (float)(nLandFrame-nTakeoffFrame) * (1.f/30.f);

				m_pPlayer->m_AnimationSystemEnabled = 0;
				m_pEntity->SetAnimationSpeed(in_air_duration/m_fLastJumpDuration);

			}
		}

		//0 means takeoff
		m_pEntity->SendScriptEvent( ScriptEvent_Jump,0 );
	}
	else if (UserData.p == (void*)JUMP_LAND)
	{
		m_pGame->GetSystem()->GetILog()->Log("\003 [AIWARNING] -------%s--------------- LANDED!! --------------------------------",sAnimation);
		m_pEntity->SetAnimationSpeed(1.f);
		m_pPlayer->m_AnimationSystemEnabled = 1;

		pe_action_move motion;
		motion.dir.Set(0,0,0);
		motion.iJump = 0;
		m_pEntity->GetPhysics()->Action(&motion);

		//1 means landing
		m_pEntity->SendScriptEvent( ScriptEvent_Jump,1 );
	}
	else
		m_pEntity->OnAnimationEvent(sAnimation,UserData);
}

//////////////////////////////////////////////////////////////////////
void CXPuppetProxy::OnEndAnimation(const char *sAnimation)
{

	{
		ICryCharInstance *pCharacter = m_pEntity->GetCharInterface()->GetCharacter(0);
		if (pCharacter)
		{
			m_pGame->GetSystem()->GetILog()->Log("\003 [AIWARNING] ---------------------- %s animation ended ------------------------------",sAnimation);
			m_bInJump = false;
			pCharacter->RemoveAnimationEvent(sAnimation,13,(void*)JUMP_TAKEOFF);
			pCharacter->RemoveAnimationEvent(sAnimation,29,(void*)JUMP_LAND);
			pCharacter->RemoveAnimationEventSink(sAnimation,this);
			m_pEntity->SetAnimationSpeed(1.f);
			m_pPlayer->m_AnimationSystemEnabled = 1;
		}
	}
}

//////////////////////////////////////////////////////////////////////
bool CXPuppetProxy::CheckStatus(unsigned char status)
{
	switch( status ){
		case AIPROXYSTATUS_INVEHICLE:
			if( m_pPlayer->GetVehicle() )
				return true;
			return false;
	}
	return false;
}

//////////////////////////////////////////////////////////////////////
void CXPuppetProxy::ApplyHealth(float fHealth)
{
	if (m_pPlayer)
	{
		if (fHealth > 1.f)
			m_pPlayer->m_stats.health = (int)fHealth;
	}
}

//////////////////////////////////////////////////////////////////////
void CXPuppetProxy::ApplyMovement(pe_action_move * move_params, SOBJECTSTATE *state)
{
	FUNCTION_PROFILER(m_pGame->GetSystem(),PROFILE_AI );

	if (!m_pGame->cv_game_AllowAIMovement->GetIVal())
		m_fMovementRestrictionDuration = 1.f;	// AI is not allowed to move

	if (m_fMovementRestrictionDuration>0)
	{
		m_fMovementRestrictionDuration-=m_pGame->GetSystem()->GetITimer()->GetFrameTime();
		SAIEVENT event;
		event.nDeltaHealth=0;
		m_pEntity->GetAI()->Event(AIEVENT_MOVEMENT_CONTROL,&event);
		move_params->dir.Set(0,0,0);
		move_params->iJump = 0;
		m_pEntity->GetPhysics()->Action(move_params);
		return;

	}

	if (!m_pGame->ai_num_of_bots->GetIVal())
	{
		m_pEntity->GetPhysics()->Action(move_params);
		return;
	}


	if (m_SAF.bMoving)
	{
		// puppet is already moving
		m_pEntity->GetPhysics()->Action(move_params);
	}
	else
	{
		// puppet is still stationary
		if (!m_SAF.bMovePending)
		{
			if (state->vMoveDir.Length() > 0)
			{
				m_SAF.bMovePending = true;
				Vec3d lookdir;
                int AllowVisible;
                m_pEntity->GetScriptObject()->GetValue("AllowVisible",AllowVisible);
				if (state->bHaveTarget&&AllowVisible==1)
					lookdir = state->vTargetPos - m_pEntity->GetAI()->GetPos();
				else
					lookdir = state->vMoveDir;

				ICryCharInstance *pInstance = m_pEntity->GetCharInterface()->GetCharacter(0);
				if (pInstance)
				{
					CryCharAnimationParams ccap;
					ccap.nLayerID = 0;
					ccap.fBlendInTime=0.1f;
					ccap.fBlendOutTime=0.1f;
					ccap.nFlags = ccap.FLAGS_ALIGNED;

					char animName[64] = "s";
					if (state->bodystate!=BODYPOS_RELAX)
						animName[0] = (state->bodystate==BODYPOS_STAND)?'a':'x';
					strcat(animName, (state->run)?"run":"walk");


					Vec3d angles = ConvertToRadAngles(m_pEntity->GetAI()->GetAngles());
					//if (lookdir.Length()>4.f)
					{
						float fDot = GetNormalized(lookdir).Dot(angles);

						if (fDot>0.5f)
						{
							strcat(animName,"fwd_start");
						}
						else if (fDot<-0.5f)
						{
							// moving generally back, use back start anim
							if (state->bHaveTarget&&AllowVisible==1)
								strcat(animName,"_turnaround_start");
							else
								strcat(animName,"back_start");
						}
						else
						{
							float zcross = lookdir.x*angles.y - lookdir.y*angles.x;
							if (zcross<0.f)
								strcat(animName,"left_start");
							else
								strcat(animName,"right_start");
						}

						pInstance->StartAnimation(animName,ccap);
					}

				}
			}
		}


		SAIEVENT event;
		event.nDeltaHealth=m_bAllowedToMove?1:0;
		m_pEntity->GetAI()->Event(AIEVENT_MOVEMENT_CONTROL,&event);

		if (m_bAllowedToMove)
			m_pEntity->GetPhysics()->Action(move_params);
	}

	pe_status_living pdyn;
	m_pEntity->GetPhysics()->GetStatus(&pdyn);
	Vec3d velocity = pdyn.vel;
	velocity.z = 0;
	if (velocity.Length()>0.0001f)
		m_SAF.bMoving = true;
	else
	{
		// don't allow puppet to move
		m_SAF.bMoving = false;
		SAIEVENT event;
		event.nDeltaHealth=0;
		m_pEntity->GetAI()->Event(AIEVENT_MOVEMENT_CONTROL,&event);
	}

	if (state->vMoveDir.Length()<0.0001f)
		m_SAF.bMovePending = false;
}

//////////////////////////////////////////////////////////////////////
void CXPuppetProxy::Load(CStream &stm)
{
	int nPresent=0;

	//check curr behaviour
	stm.Read(nPresent);
	if (nPresent)
	{
		char str[255];
		stm.Read(str,255);
		m_AIHandler.SetBehaviour(str);
	}

	// check prev
	stm.Read(nPresent);
	if (nPresent)
	{
		char str[255];
		stm.Read(str,255);
	}
	int vehicleId;
	stm.Read(vehicleId);
	if(vehicleId)
	{
		IEntity *pVehicleEnt = m_pGame->GetSystem()->GetIEntitySystem()->GetEntity(vehicleId);
		if(pVehicleEnt)
		{
			m_pEntity->GetScriptObject()->SetValue("theVehicle", pVehicleEnt->GetScriptObject());
			m_pGame->GetSystem()->GetILog()->Log(" the vehicle is %s",pVehicleEnt->GetName());
		}
	}
}

//////////////////////////////////////////////////////////////////////
void CXPuppetProxy::Load_PATCH_1(CStream &stm)
{
	int nPresent=0;

	//check curr behaviour
	stm.Read(nPresent);
	if (nPresent)
	{
		char str[255];
		stm.Read(str,255);
		m_AIHandler.SetBehaviour(str);
	}

	// check prev
	stm.Read(nPresent);
	if (nPresent)
	{
		char str[255];
		stm.Read(str,255);
	}
}

//////////////////////////////////////////////////////////////////////
void CXPuppetProxy::Save(CStream &stm)
{
		// save the current & previous behaviours
	const char *szString;
	if (m_AIHandler.m_pBehavior)
	{
		stm.Write((int)1); // we have a current behaviour
		m_AIHandler.m_pBehavior->GetValue("Name",szString);
		stm.Write(szString);
	}
	else
		stm.Write((int)0);

	if (m_AIHandler.m_pPreviousBehavior)
	{
		stm.Write((int)1);
		m_AIHandler.m_pPreviousBehavior->GetValue("Name",szString);
		stm.Write(szString);
	}
	else
		stm.Write((int)0);
	_SmartScriptObject pVehicle(m_pScriptSystem,true);
	if( m_pEntity->GetScriptObject()->GetValue("theVehicle", pVehicle))
	{
		int id;
		pVehicle->GetValue("id", id);
		stm.Write(id);
		m_pGame->GetSystem()->GetILog()->Log(" Writing vehicle id %d",id);
	}
	else
		stm.Write((int)0);
}
