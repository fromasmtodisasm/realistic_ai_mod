
//////////////////////////////////////////////////////////////////////
//
//	Crytek Source code
//	Copyright (c) Crytek 2001-2004
//
//  File: XPuppetProxy.h
//  Description: class handeling AI signals, changing behaviors
//
//  History:
//  - Dec, 12, 2002: Created by Petar Kotevski
//	- February 2005: Modified by Marco Corbetta for SDK release
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_XPUPPETPROXY_H__79A09EA6_D523_43B3_804F_DA16597D8AB6__INCLUDED_)
#define AFX_XPUPPETPROXY_H__79A09EA6_D523_43B3_804F_DA16597D8AB6__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
#include <IAgent.h>
#include <string>

//////////////////////////////////////////////////////////////////////
#include "aihandler.h"

struct IPuppet;
struct IScriptSystem;
class CPlayer;
class CXGame;

#define HEAD_TORSO_MAX 0.8f
#define TORSO_BODY_MAX 0.6f

#define OBJECTBEHAVIOUR_HELICOPTER	30
#define OBJECTBEHAVIOUR_AIRPLANE  	50

#define JUMP_TAKEOFF	0xffff
#define JUMP_LAND		0xff00

//////////////////////////////////////////////////////////////////////
typedef struct StartupAnimFlags
{
	bool bMoving;
	bool bMovePending;

	StartupAnimFlags()
	{
		bMoving = false;
		bMovePending = false;
	}
} StartupAnimFlags;

//////////////////////////////////////////////////////////////////////
class CXPuppetProxy : public IPuppetProxy, public ICharInstanceSink
{
	CAIHandler	m_AIHandler;
	StartupAnimFlags	m_SAF;

	IPhysicalEntity *m_pCharacterPhysics;

	IEntity *m_pEntity;
	CPlayer *m_pPlayer;

	bool m_bFireOverride;
	bool m_bForcedToShoot;
	bool m_bWasSwimming;
	bool m_bAllowedToMove;

	Vec3d	 m_vBodyDir;
	Vec3d	 m_vTorsoDir;
	Vec3d	 m_vHeadDir;
	Vec3d	 m_vPreviousTargetPos;

	int		m_nWeaponBoneID;
	int		m_nLastSelectedJumpAnim;

	bool m_bInJump;

	_HScriptFunction	m_hBehaviourFunc;
	_HScriptFunction	m_hMotorFunc;
	_HScriptFunction	m_hSignalFunc;

	string	m_strRootBone;

	IScriptSystem *m_pScriptSystem;
	bool	m_bDead;

	float m_fForwardSpeed;
	float m_fBackwardSpeed;

	float m_fMovementRestrictionDuration;

	float m_fLastJumpDuration;
	int	  m_nJumpDirection;
	Vec3d m_vJumpVector;

	pe_player_dimensions	m_dimStandingPuppet;
	pe_player_dimensions	m_dimCrouchingPuppet;
	pe_player_dimensions	m_dimProningPuppet;

	pe_player_dimensions	m_dimCurrentDimensions;
	int	m_nLastBodyPos;

	int	AllowVisibleUpdate;
	int	AllowVisibleUpdate2;
	bool SetHorizontalFov;
	float CurrentHorizontalFov;
	float OriginalHorizontalFov;
	float TempOriginalHorizontalFov;
	float NewAngleOnCollisions;
	bool m_bPrevMovingStats;
	float m_fMaxTimeToTrowGrenade;
    int	m_iPrevForward;
    int	m_iPrevStrafe;
    int	m_iPrevStanding;
    int	m_iPrevMode;
    bool m_bPrevMode;
    Vec3d m_fSavedPos;
    int m_nStrafeOnCollisions;
    bool m_bAllowAvoidCollisions;
    float m_fChageStanceTimeDelay;
    int m_iEstimatedPosition;
    int m_iEstimatedSpeed;
    bool m_bEstimatedSpeed;
    int m_iSwitchAiming;
    int m_iPrevSwitchAiming;
    int m_nSetBodyState;
    int m_nSetRunState;
    int m_nCurrentSettedBodyState;
    int m_nCurrentSettedRunState;

	SOBJECTSTATE	m_LastObjectState;
	CXGame * m_pGame;

	_SmartScriptObject pSignalTable;
	_SmartScriptObject pJumpTable;

	void *m_pAISystem;//!< point to AI system , needed to check if AI is inside indoor or not.

public:
	void SetFireOverride() { m_bFireOverride = true;}
	void ForcedShooting() { m_bForcedToShoot = true;}
	int GetMyEntityId();
	void SetPuppetDimensions(float height, float eye_height, float sphere_height, float radius);
	void SetSpeeds(float fwd, float bkw);
	void SetRootBone(const char *pRootBone);
	CXPuppetProxy(IEntity *pEntity,IScriptSystem *pScriptSystem, CXGame *pGame);
	virtual ~CXPuppetProxy();

	int Update(SOBJECTSTATE *state);
    void UpdateThrowGrenade(SOBJECTSTATE *state);
    void UpdateVisible(SOBJECTSTATE *state,IPuppet *pPuppet, bool IPuppetEntity, IEntity *pTargetEntity);

    void UpdateTurning(SOBJECTSTATE *state,Vec3d pos,Vec3d angle,Vec3d dir,ray_hit hit,int objTypes,int flags,
    bool IsAnimal,bool InVehicle,bool HeJumping,bool SetAlerted,bool CurrentConversation,IPuppet *pPuppet,
    bool IPuppetEntity,IEntity *pTargetEntity,int Forward,int Strafe,int Standing,int Mode,int jobFlag);

    void UpdateStance(SOBJECTSTATE *state,Vec3d pos,Vec3d angle,Vec3d dir,ray_hit hit,int objTypes,int flags,
    bool IsAnimal,bool InVehicle,bool HeJumping,bool SetAlerted,bool CurrentConversation,IPuppet *pPuppet,
    bool IPuppetEntity,IEntity *pTargetEntity,int jobFlag,float SavePosZ,bool IsMutant,int Forward,int Strafe,int Standing,
    int Mode,IPipeUser *pPipeUser,bool FORCE_RUN,int ClearPos,int ClearSpeed,bool BeforeRunState,int BeforeBodyState,
    bool AfterRunState,int AfterBodyState);

    void UpdateJumping(SOBJECTSTATE *state,Vec3d pos,Vec3d angle,Vec3d dir,ray_hit hit,int objTypes,int flags,
    bool IsAnimal,bool InVehicle,bool HeJumping,bool SetAlerted,bool CurrentConversation,IPuppet *pPuppet,
    bool IPuppetEntity,IEntity *pTargetEntity,int jobFlag,float SavePosZ,bool IsMutant,int Forward,int Strafe,int Standing,
    int Mode,IPipeUser *pPipeUser,bool FORCE_RUN,bool ALLOW_JUMP);

    void UpdateAvoidCollisions(SOBJECTSTATE *state,Vec3d pos,Vec3d angle,int Forward,int Strafe,int Standing,int Mode,
    IPipeUser *pPipeUser,bool CurrentConversation,bool DoNotAvoidCollisionsOnTheMoveForward,int jobFlag,bool FORCE_RUN,bool HeJumping);

	void Release() { delete this; }

	IPhysicalEntity* GetPhysics()
	{
		return m_pEntity->GetPhysics();
	}
	IEntity*	GetEntity()
	{
		return m_pEntity;
	}

	void OnStartAnimation(const char *sAnimation){}
	void OnAnimationEvent(const char *sAnimation,AnimSinkEventData UserData);
	void OnEndAnimation(const char *sAnimation);


	void SetSignalFunc(HSCRIPTFUNCTION pFunc);
	void SetBehaviourFunc(HSCRIPTFUNCTION pFunc);
	void SetMotorFunc(HSCRIPTFUNCTION pFunc);

	bool QueryProxy(unsigned char type, void **pProxy);

	void GetDimensions(int bodypos, float &eye_height, float &height);

	bool CheckStatus(unsigned char status);

protected:

	void UpdateMind(SOBJECTSTATE *state);
	int UpdateMotor(SOBJECTSTATE *state);

public:

	void Reset(void);
	void SendSignal(int signalID, const char * szText,IEntity *pSender);
	void SendAuxSignal(int signalID, const char * szText);
	bool CustomUpdate(Vec3d & vPos, Vec3d & vAngles);
	void ApplyHealth(float fHealth);

	void DebugDraw(struct IRenderer * pRenderer);
	void ApplyMovement(pe_action_move * move_params, SOBJECTSTATE *state);
	void MovementControl(bool bEnableMovement, float fDuration) { m_bAllowedToMove = bEnableMovement;
																  m_fMovementRestrictionDuration = fDuration;}
	void Save(CStream &str);
	void Load(CStream &str);
	void Load_PATCH_1(CStream &str);
};

#endif // !defined(AFX_XPUPPETPROXY_H__79A09EA6_D523_43B3_804F_DA16597D8AB6__INCLUDED_)
