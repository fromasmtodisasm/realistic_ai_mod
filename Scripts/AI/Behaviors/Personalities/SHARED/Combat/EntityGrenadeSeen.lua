AIBehaviour.EntityGrenadeSeen = {
	Name = "EntityGrenadeSeen",
	NOPREVIOUS = 1,

	OnSelected = function(self,entity)
	end,

	OnActivate = function(self,entity)
	end,

	OnSpawn = function(self,entity)
	end,

	OnNoTarget = function(self,entity)
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		entity:TriggerEvent(AIEVENT_CLEAR)
	end,

	OnEnemySeen = function(self,entity)
	end,

	OnFriendSeen = function(self,entity)
	end,

	OnSomethingSeen = function(self,entity)
		entity:TriggerEvent(AIEVENT_CLEAR)
	end,

	OnDeadBodySeen = function(self,entity,sender,fDistance)
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
	end,

	OnInterestingSoundHeard = function(self,entity,fDistance)
	end,

	OnThreateningSoundHeard = function(self,entity,fDistance)
	end,

	OnReload = function(self,entity)
	end,

	OnGroupMemberDied = function(self,entity)
	end,

	OnGroupMemberDiedNearest = function(self,entity)
	end,

	OnNoHidingPlace = function(self,entity,sender)
	end,

	OnNoFormationPoint = function(self,entity,sender)
	end,

	OnCoverRequested = function(self,entity,sender)
	end,

	OnKnownDamage = function(self,entity,sender)
	end,

	OnReceivingDamage = function(self,entity,sender)
	end,

	OnBulletRain = function(self,entity,sender)
	end,

	OnCloseContact = function(self,entity,sender)
	end,

	OnGrenadeSeen = function(self,entity,fDistance)
		entity.OnGrenadeSeen_sender = nil
		self:OnGrenadeSeen_Flying(entity)
	end,

	OnGrenadeSeen_Flying = function(self,entity)
		entity.RunToTrigger = 1
		if entity.Readibility then -- А то было дело, nil выдавало.
			entity:Readibility("GRENADE_SEEN",1)
		end
		if entity.OnGrenadeSeen_sender then
			entity.OnGrenadeSeen_senderid = entity.OnGrenadeSeen_sender.id
		else
			entity.OnGrenadeSeen_senderid = nil
		end
		if entity.OnGrenadeSeen_senderid then
			entity:SelectPipe(0,"grenade_run_away",entity.OnGrenadeSeen_senderid)
		else
			entity:SelectPipe(0,"grenade_run_away")
			AI:MakePuppetIgnorant(entity.id,0)
		end
		if entity.cnt and (not entity.cnt.weapon or entity.fireparams.fire_mode_type==FireMode_Melee) then
			entity:InsertSubpipe(0,"setup_stealth")
		else
			entity:InsertSubpipe(0,"setup_stand")
		end
	end,

	PRE_GRENADE_EXIT = function(self,entity,sender)
		-- Hud:AddMessage(entity:GetName()..": PRE_GRENADE_EXIT")
		if (entity.OnGrenadeSeen_senderid and entity.OnGrenadeSeen_senderid==entity.OnGrenadeSeen_sender.id) or not entity.OnGrenadeSeen_senderid then
			AI:Signal(0,-1,"GRENADE_EXIT",entity.id)
		end
	end,

	GRENADE_EXIT = function(self,entity,sender) -- Иногда не выходит из режима.
		-- Hud:AddMessage(entity:GetName()..": GRENADE_EXIT")
		AI:MakePuppetIgnorant(entity.id,0)
		if entity.cnt then
			entity.cnt.AnimationSystemEnabled = 1
		end
		entity:SetAnimationSpeed(1)
		entity:StartAnimation(0,"NULL",4) -- Мутанты иногда зависают после гранаты.
		AI:EnablePuppetMovement(entity.id,1)
		entity.RunToTrigger = nil
		entity.OnGrenadeSeen_sender = nil
		entity.OnGrenadeSeen_senderid = nil
		entity.ReallyGrenadeSees = nil
		AI:CreateGoalPipe("after_grenade_attack")
		AI:PushGoal("after_grenade_attack","just_shoot")
		AI:PushGoal("after_grenade_attack","acqtarget",1,"")
		-- AI:PushGoal("after_grenade_attack","signal",1,-1,"GRENADE_EXIT",0) -- Из-за того что иногда не выходит.
		if entity.cnt and (not entity.cnt.weapon or entity.fireparams.fire_mode_type==FireMode_Melee) then
			AI:PushGoal("after_grenade_attack","setup_stealth")
		else
			AI:PushGoal("after_grenade_attack","setup_stand")
		end
		AI:PushGoal("after_grenade_attack","hide",1,60,HM_NEAREST,1)
		-- AI:PushGoal("after_grenade_attack","signal",1,-1,"GRENADE_EXIT",0)
		AI:PushGoal("after_grenade_attack","setup_crouch")
		AI:PushGoal("after_grenade_attack","locate",0,"hidepoint")
		AI:PushGoal("after_grenade_attack","acqtarget",0,"")
		AI:PushGoal("after_grenade_attack","signal",1,-1,"CHECK_SEARCH_AMMUNITION",0)
		AI:PushGoal("after_grenade_attack","signal",1,-1,"GO_FOLLOW",0)
		entity:SelectPipe(0,"after_grenade_attack")
		entity:InsertSubpipe(0,"do_it_running")
		-- if entity.sees~=1 then
			-- if not entity:RunToAlarm() then
				-- entity.EventToCall = "OnEnemyMemory"
			-- end
		-- else
			entity:TriggerEvent(AIEVENT_CLEAR)
			entity.EventToCall = "OnPlayerSeen"
		-- end
		-- entity:TriggerEvent(AIEVENT_CLEAR)
		-- entity.EventToCall = "OnPlayerSeen"
	end,

	CHECK_SEARCH_AMMUNITION = function(self,entity,sender)
		AI:MakePuppetIgnorant(entity.id,0)
		if entity.SearchAmmunition and not entity:SearchAmmunition() and entity.sees~=1 then
			AI:Signal(0,-1,"FIND_A_TARGET",entity.id)
		end
	end,

	OnDeath = function(self,entity,sender)
		AIBehaviour.DEFAULT:OnDeath(entity)
	end,

	OnSomethingDiedNearest = function(self,entity,sender)
	end,

	OnSomethingDiedNearest_x = function(self,entity,sender)
	end,

	ALARM_ON = function(self,entity,sender)
	end,

	ALERT_SIGNAL = function(self,entity,sender)
	end,

	NORMAL_THREAT_SOUND = function(self,entity,sender)
	end,

	GoForReinforcement = function(self,entity,sender)
	end,

	RunToAlarmSignal = function(self,entity,sender)
	end,

	LOOK_AT_BEACON = function(self,entity,sender)
	end,

	STOP_LOOK_AT_BEACON = function(self,entity,sender)
	end,

	HEADS_UP_GUYS = function(self,entity,sender)
	end,

	INCOMING_FIRE = function(self,entity,sender)
	end,

	KEEP_FORMATION = function(self,entity,sender)
		-- the team leader wants everyone to keep formation
	end,

	BREAK_FORMATION = function(self,entity,sender)
		-- the team can split
	end,

	SINGLE_GO = function(self,entity,sender)
		-- the team leader has instructed this group member to approach the enemy
	end,

	GROUP_COVER = function(self,entity,sender)
		-- the team leader has instructed this group member to cover his friends
	end,

	IN_POSITION = function(self,entity,sender)
		-- some member of the group is safely in position
	end,

	GROUP_SPLIT = function(self,entity,sender)
		-- team leader instructs group to split
	end,

	PHASE_RED_ATTACK = function(self,entity,sender)
		-- team leader instructs red team to attack
	end,

	PHASE_BLACK_ATTACK = function(self,entity,sender)
		-- team leader instructs black team to attack
	end,

	GROUP_MERGE = function(self,entity,sender)
		-- team leader instructs groups to merge into a team again
	end,

	CLOSE_IN_PHASE = function(self,entity,sender)
		-- team leader instructs groups to initiate part one of assault fire maneuver
	end,

	ASSAULT_PHASE = function(self,entity,sender)
		-- team leader instructs groups to initiate part one of assault fire maneuver
	end,

	GROUP_NEUTRALISED = function(self,entity,sender)
		-- team leader instructs groups to initiate part one of assault fire maneuver
	end,
}