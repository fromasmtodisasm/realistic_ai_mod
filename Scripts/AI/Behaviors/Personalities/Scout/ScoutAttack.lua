--------------------------------------------------
--    Created By: Petar
--   Description: Attack behaviour for the Scout personality
--------------------------
--

AIBehaviour.ScoutAttack = {
	Name = "ScoutAttack",
	Direction = 0,
	target_lost_muted = 1,
	call_alarm_muted = 1,
	rs_y = 1,
	no_MG = 1,
	
	OnLeftLean = function(self,entity,sender)
		if not entity.RunToTrigger and entity.not_sees_timer_start==0 and entity.Properties.KEYFRAME_TABLE~="VALERIE" and not entity.cnt.reloading then
			AI:Signal(0,1,"WHEN_LEFT_LEAN_ENTER",entity.id)
		end
	end,

	OnRightLean = function(self,entity,sender)
		if not entity.RunToTrigger and entity.not_sees_timer_start==0 and entity.Properties.KEYFRAME_TABLE~="VALERIE" and not entity.cnt.reloading then
			AI:Signal(0,1,"WHEN_RIGHT_LEAN_ENTER",entity.id)
		end
	end,

	OnNoTarget = function(self,entity)
		AIBehaviour.DEFAULT:OnNoTarget(entity)
		entity:InsertSubpipe(0,"reload")
		-- entity:InsertSubpipe(0,"scout_hunt_beacon") -- FIND_A_TARGET
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		if entity:ShootOrNo() then return end
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if not fDistance then fDistance = entity:GetDistanceToTarget() end
		if not fDistance then fDistance = 0 NotContact=1 end
		if not NotContact then
			AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY_ON_ATTACK(entity)
			if (entity:GetGroupCount() > 1) then
				AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN_GROUP",entity.id)
			else
				AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN",entity.id)
			end
		end

		if entity:CheckEnemyWeaponDanger() then	return end

		if entity.critical_status and fDistance > 30 then
			entity:SelectPipe(0,"hide_on_critical_status")
			do return end
		end
		if entity.ai_flanking then do return end end
		if (entity:GetGroupCount() > 1) then
			if (fDistance<15) then
				entity:SelectPipe(0,"scout_tooclose_attack_beacon")
				if not AI:IsMoving(self.id) then
					AIBehaviour.DEFAULT:AI_SETUP_DOWN(entity)
				end
			elseif (fDistance<30) then
				entity:SelectPipe(0,"scout_scramble_beacon")
				if not AI:IsMoving(self.id) then
					AIBehaviour.DEFAULT:AI_SETUP_DOWN(entity)
				end
			else
				self:START_HUNTING(entity)
			end
		else
			if (fDistance<15) then
				entity:SelectPipe(0,"scout_tooclose_attack")
			else
				AI:Signal(0,1,"NORMAL_THREAT_SOUND",entity.id)
			end
			if not AI:IsMoving(self.id) then
				AIBehaviour.DEFAULT:AI_SETUP_DOWN(entity)
			end
		end
		-- entity:GrenadeAttack()
		entity.ThrowGrenadeOnTimer = {_time+random(1.5,5),1}
	end,

	OnEnemySeen = function(self,entity)
		-- called when the enemy sees a foe which is not a living player
	end,
	---------------------------------------------
	OnFriendSeen = function(self,entity)
		-- called when the enemy sees a friendly target
	end,

	OnSomethingSeen = function(self,entity)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
	end,

	OnDeadBodySeen = function(self,entity,sender,fDistance)
		if entity.Properties.species==sender.Properties.species and fDistance<=10 and entity.sees~=1 then
			entity:InsertSubpipe(0,"retreat_on_dead_body_seen",sender.id)
		end
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if entity:RunToAlarm() then do return end end
		if not fDistance then fDistance = 0 NotContact=1 end
		if not NotContact then
			AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN",entity.id)
		end
		entity:GrenadeAttack(6)
	end,

	OnInterestingSoundHeard = function(self,entity)
		entity:SelectPipe(0,"scout_scramble")
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"NORMAL_THREAT_SOUND",entity.id)
		if entity.sees~=1 then
			if entity:SearchAmmunition() then do return end end
		end
		entity:SelectPipe(0,"scout_scramble")
	end,
	---------------------------------------------
	OnReload = function(self,entity)
		if random(1,2)==1 then
			entity:GrenadeAttack(6)
		end
	end,
	---------------------------------------------
	OnClipNearlyEmpty = function(self,entity)
		entity:SelectPipe(0,"scout_cover_NOW")
		-- entity:GrenadeAttack()
	end,
	---------------------------------------------
	OnNoHidingPlace = function(self,entity,sender)
		-- called when no hiding place can be found with the specified parameters
		AI:Signal(0,1,"NORMAL_THREAT_SOUND",entity.id)
	end,

	OnKnownDamage = function(self,entity,sender)
		-- AIBehaviour.CoverAttack:OnKnownDamage(entity,sender)
		entity:SelectPipe(0,"scout_cover_NOW")
		entity:InsertSubpipe(0,"DropBeaconTarget",sender.id)
		entity:InsertSubpipe(0,"pause_shooting")
		entity:InsertSubpipe(0,"setup_crouch")
	end,

	OnReceivingDamage = function(self,entity,sender)
		entity:TriggerEvent(AIEVENT_CLEAR)
		-- AIBehaviour.CoverAttack:OnReceivingDamage(entity,sender)
		entity:SelectPipe(0,"scout_cover_NOW")
		entity:InsertSubpipe(0,"pause_shooting")
		entity:InsertSubpipe(0,"setup_crouch")
	end,

	OnBulletRain = function(self,entity,sender)
		-- AIBehaviour.CoverAttack:OnBulletRain(entity,sender)
		if entity==sender then do return end end
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity.ai_flanking = nil
		entity:SelectPipe(0,"scout_incoming_fire")
		local rnd=random(1,5)
		if rnd==1 or entity.critical_status then
			if not entity.critical_status or (not entity.cnt.proning and entity.critical_status) then
				entity:InsertSubpipe(0,"setup_crouch")
			end
		elseif rnd==2 then
			entity:InsertSubpipe(0,"setup_stealth")
		end
		entity:GrenadeAttack(3)
	end,

	OnSomethingDiedNearest = function(self,entity,sender)
		AIBehaviour.CoverAttack:OnSomethingDiedNearest(entity,sender)
	end,

	OnSomethingDiedNearest_x = function(self,entity,sender)
	end,

	-- CUSTOM
	---------------------------------------------------------


	START_HUNTING = function(self,entity,sender)
		entity:SelectPipe(0,"scout_hunt_beacon")
		entity:InsertSubpipe(0,"scout_dropebeacon_and_target")
	end,

	INCOMING_FIRE = function(self,entity,sender)
	end,

	ALARM_ON = function(self,entity,sender)
	end,

	ALERT_SIGNAL = function(self,entity,sender)
	end,

	LOOK_AT_BEACON = function(self,entity,sender)
	end,

	HEADS_UP_GUYS = function(self,entity,sender)
		if entity.ForceSenderId then sender=System:GetEntity(entity.ForceSenderId) entity.ForceSenderId=nil end
		AIBehaviour.DEFAULT:AllWakeUp(entity)
		if entity.Properties.species==sender.Properties.species and entity~=sender
		and not entity.RunToTrigger and not entity.heads_up_guys and not entity.ai_flanking and entity.sees~=1 then
			if not entity.rs_x then	entity.rs_x = 1	end
			AI:Signal(0,1,"NORMAL_THREAT_SOUND",entity.id)
			if sender and sender.SenderId then
				if random(1,3)==1 then
					entity:InsertSubpipe(0,"acquire_beacon2",sender.id)
				end
				entity:SelectPipe(0,"check_beacon")
				entity:InsertSubpipe(0,"DropBeaconAt",sender.SenderId)
				local SenderDistance = entity:GetDistanceFromPoint(sender:GetPos())
				if SenderDistance and SenderDistance > 30 then
					entity:InsertSubpipe(0,"go_to_sender",sender.id)
				end
			end
			entity.heads_up_guys = 1
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,10)
			AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY(entity)
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)
		end
	end,

	-- GROUP SIGNALS
	---------------------------------------------
	KEEP_FORMATION = function(self,entity,sender)
		-- the team leader wants everyone to keep formation
	end,
	---------------------------------------------
	BREAK_FORMATION = function(self,entity,sender)
		-- the team can split
	end,
	---------------------------------------------
	IN_POSITION = function(self,entity,sender)
		-- some member of the group is safely in position
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
}