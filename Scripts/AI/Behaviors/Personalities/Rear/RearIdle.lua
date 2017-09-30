--------------------------------------------------
--   Created By: Petar
--   Description: Rear Idle Behaviour
--------------------------


AIBehaviour.RearIdle = {
	Name = "RearIdle",

	OnSpawn = function(self,entity)
		-- Вызывается,когда враг появляется или перезагружается.
	end,

	OnActivate = function(self,entity) -- Сделать по активации тревожное состояние.
		-- called when enemy receives an activate event (from a trigger,for example)
	end,

	OnNoTarget = function(self,entity) -- Не убирать!
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		entity:TriggerEvent(AIEVENT_DROPBEACON) -- Оставить маяк.
		if not fDistance then fDistance = entity:GetDistanceToTarget() end
		if not fDistance then fDistance = 0 NotContact=1 end
		if not NotContact then
			AI:Signal(0,1,"SAY_FIRST_HOSTILE_CONTACT",entity.id)
		end
		entity:MakeAlerted()
		if not entity:RunToAlarm() then
			if (fDistance < 15) then
				entity:SelectPipe(0,"rear_target2close")
			else
				entity:SelectPipe(0,"rear_scramble")
			end
		end
		if not entity.cnt.proning and not entity.cnt.crouching then
			entity:InsertSubpipe(0,"setup_stand")
		end
	end,

	OnEnemySeen = function(self,entity)
		-- called when the enemy sees a foe which is not a living player
	end,

	---------------------------------------------
	OnFriendSeen = function(self,entity)
		-- called when the enemy sees a friendly target
	end,

	OnSomethingSeen = function(self,entity)
		if (entity:GetGroupCount() > 1) then
			AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_ALERT_SEEN_GROUP",entity.id)
		else
			AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_ALERT_SEEN",entity.id)
		end
	 	entity:SelectPipe(0,"rear_look_closer")
		entity:InsertSubpipe(0,"get_curious")
	 	entity:InsertSubpipe(0,"setup_stand")
		entity:TriggerEvent(AIEVENT_DROPBEACON)
	 	entity:InsertSubpipe(0,"DRAW_GUN")
		entity:ChangeAIParameter(AIPARAM_COMMRANGE,15)
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"LOOK_AT_BEACON",entity.id)
		entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
	end,

	OnInterestingSoundHeard = function(self,entity)
		if entity.ThreatenStatus and entity.ThreatenStatus >= 1 and entity.ThreatenStatus < 5 then
			entity:TriggerEvent(AIEVENT_DROPBEACON)
			entity:GunOut() -- Неправильно вытаскивает.
			entity:InsertSubpipe(0,"DRAW_GUN")
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,15)
			AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"LOOK_AT_BEACON",entity.id)
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)
		end
		if not entity.ThreatenStatus then
			entity.ThreatenStatus = 1
			entity:InsertSubpipe(0,"cover_lookat")
		elseif entity.ThreatenStatus==1 then
			if (entity:GetGroupCount() > 1) then
				AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_ALERT_HEARD_GROUP",entity.id)
			else
				AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_ALERT_HEARD",entity.id)
			end
			entity:SelectPipe(0,"rear_look_closer") -- LOOK_AT_BEACON вверху
			entity:InsertSubpipe(0,"setup_stand")
			entity.ThreatenStatus = 2
		elseif entity.ThreatenStatus==2 then
			entity.ThreatenStatus = 3
			if (entity:GetGroupCount() > 1) then
				AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_THREATENED_GROUP",entity.id)
			else
				AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_THREATENED",entity.id)
			end
			entity:SelectPipe(0,"rear_interested")
			entity.LAB = nil
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,30)
			AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"CLEAR_LOOK_AT_BEACON",entity.id)
			AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"LOOK_AT_BEACON",entity.id)
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)
		elseif entity.ThreatenStatus==3 then
			entity.LAB = nil
			entity.ThreatenStatus = 4
			entity:InsertSubpipe(0,"cover_lookat")
		elseif entity.ThreatenStatus==4 then
			entity.ThreatenStatus = 5
			entity:SelectPipe(0,"rear_comeout")	-- Сделать нормальную пайпу разведки.
			AI:Signal(0,1,"ALERT_SIGNAL",entity.id)
		end
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity)
		entity.LAB = nil
		entity:MakeAlerted()
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:GunOut()
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"NORMAL_THREAT_SOUND",entity.id)
		if (entity:GetGroupCount() > 1) then
			AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_THREATENED_GROUP",entity.id)
		else
			AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_THREATENED",entity.id)
		end
		AI:Signal(0,1,"ALERT_SIGNAL",entity.id)
		entity:SelectPipe(0,"rear_look_closer")
		-- entity:InsertSubpipe(0,"shoot_cover")
	 	entity:InsertSubpipe(0,"setup_stand")
	end,

	OnClipNearlyEmpty = function(self,entity,sender)
	end,

	OnReload = function(self,entity)
	end,

	OnNoHidingPlace = function(self,entity,sender)
	end,

	OnNoFormationPoint = function(self,entity,sender)
	end,

	OnKnownDamage = function(self,entity,sender)
		AIBehaviour.CoverIdle:OnKnownDamage(entity,sender)
	end,

	OnSomethingDiedNearest = function(self,entity,sender)
		if not entity.rs_x then
			AIBehaviour.DEFAULT:OnSomethingDiedNearest(entity,sender)
		else
			AIBehaviour.CoverIdle:OnSomethingDiedNearest(entity,sender)
		end
	end,
	--------------------------------------------------
	-- CUSTOM SIGNALS
	--------------------------------------------------
	TRY_TO_LOCATE_SOURCE = function(self,entity,sender)
		-- called from "randomhide"
		entity:SelectPipe(0,"rear_lookaround_threatened")
	end,
	--------------------------------------------------
	----------------- GROUP SIGNALS ------------------
	--------------------------------------------------
	OnCoverRequested = function(self,entity,sender)
	end,

	HEADS_UP_GUYS = function(self,entity,sender)
		if entity.ForceSenderId then sender=System:GetEntity(entity.ForceSenderId) entity.ForceSenderId=nil end
		AIBehaviour.DEFAULT:AllWakeUp(entity)
		if entity.Properties.species==sender.Properties.species then
			entity:MakeAlerted()
			if not entity.RunToTrigger then
				if entity.id~=sender.id then
					entity:SelectPipe(0,"rear_headup")
					entity:InsertSubpipe(0,"go_to_sender",sender.id)
					if sender.SenderId then
						entity:SelectPipe(0,"check_beacon")
						entity:InsertSubpipe(0,"DropBeaconAt",sender.SenderId)
					end
					entity:GettingAlerted()
				end
			end
		end
	end,
	------------------------------ Animation -------------------------------
	PlayGetDownAnim = function(self,entity,sender)
		entity:StartAnimation(0,"pgetdown",0)
	end,
	
	PlayGetUpAnim = function(self,entity,sender)
		entity:StartAnimation(0,"pgetup",0)
	end,
	
	RETURN_TO_FIRST = function(self,entity,sender)
		entity.ThreatenStatus = 2
		entity.ThreatenStatus2 = 2
		entity.ThreatenStatus3 = 1
		entity.ThreatenStatus4 = 2
		entity.ThreatenStatus5 = 1
		entity.ThreatenStatus6 = 1
		entity.ThreatenStatus7 = 3
		entity.no_MG = nil
		entity.THREAT_SOUND_SIGNAL_SENT = nil
		entity.FirstState=1
		entity.EventToCall = "OnSpawn"
	end,
	
	--------------------------------------------------
	KEEP_FORMATION = function(self,entity,sender)
		-- the team leader wants everyone to keep formation
	end,
	---------------------------------------------
	BREAK_FORMATION = function(self,entity,sender)
		-- the team can split
	end,
	---------------------------------------------
	SINGLE_GO = function(self,entity,sender)
		-- the team leader has instructed this group member to approach the enemy
	end,
	---------------------------------------------
	GROUP_COVER = function(self,entity,sender)
		-- the team leader has instructed this group member to cover his friends
	end,
	---------------------------------------------
	IN_POSITION = function(self,entity,sender)
		-- some member of the group is safely in position
	end,
	---------------------------------------------
	GROUP_SPLIT = function(self,entity,sender)
		-- team leader instructs group to split
	end,
	---------------------------------------------
	PHASE_RED_ATTACK = function(self,entity,sender)
		-- team leader instructs red team to attack
	end,
	---------------------------------------------
	PHASE_BLACK_ATTACK = function(self,entity,sender)
		-- team leader instructs black team to attack
	end,
	---------------------------------------------
	GROUP_MERGE = function(self,entity,sender)
		-- team leader instructs groups to merge into a team again
	end,
	---------------------------------------------
	CLOSE_IN_PHASE = function(self,entity,sender)
		-- team leader instructs groups to initiate part one of assault fire maneuver
	end,
	---------------------------------------------
	ASSAULT_PHASE = function(self,entity,sender)
		-- team leader instructs groups to initiate part one of assault fire maneuver
	end,
	---------------------------------------------
	GROUP_NEUTRALISED = function(self,entity,sender)
		-- team leader instructs groups to initiate part one of assault fire maneuver
	end,
}