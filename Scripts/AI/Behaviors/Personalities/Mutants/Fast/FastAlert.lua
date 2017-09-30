AIBehaviour.FastAlert = {
	Name = "FastAlert",

	OnNoTarget = function(self,entity)
		AIBehaviour.DEFAULT:OnNoTarget(entity)
		entity:InsertSubpipe(0,"reload")
		entity:MutantJump(AIAnchor.MUTANT_JUMP_TARGET_WALKING,30,2+1)
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		AIBehaviour.FastIdle:OnPlayerSeen(entity,fDistance,1)
	end,

	OnPlayerAiming = function(self,entity,sender)
	end,

	OnSomethingSeen = function(self,entity)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		AI:CreateGoalPipe("shoot_aggressively")
		AI:PushGoal("shoot_aggressively","dumb_shoot")
		AI:PushGoal("shoot_aggressively","acqtarget",1,"")
		AI:PushGoal("shoot_aggressively","timeout",1,1)
		AI:PushGoal("shoot_aggressively","just_shoot")
		entity:InsertSubpipe(0,"shoot_aggressively")
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
	end,

	OnInterestingSoundHeard = function(self,entity,fDistance)
		-- entity:TriggerEvent(AIEVENT_DROPBEACON)
		self:OnThreateningSoundHeard(entity,fDistance,1)
	end,

	OnThreateningSoundHeard = function(self,entity,fDistance)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if fDistance>entity.PropertiesInstance.soundrange then
			if entity.AI_CanWalk then
				entity:SelectPipe(0,"fast_run_to_target")
			else
				if not entity:MutantJump() then
					entity:SelectPipe(0,"fast_shoot")
				end
			end
		else
			if entity.AI_CanWalk then
				entity:SelectPipe(0,"fast_alert_shoot_approach")
				entity:InsertSubpipe(0,"do_it_walking")
			else
				entity:SelectPipe(0,"fast_shoot")
			end
		end
	end,

	OnClipNearlyEmpty = function(self,entity,sender)
	end,

	OnReload = function(self,entity)
		if entity.sees~=2 then
			entity:MutantJump()
		end
	end,

	OnNoHidingPlace = function(self,entity,sender)
	end,

	OnNoFormationPoint = function(self,entity,sender)
	end,

	OnCoverRequested = function(self,entity,sender)
	end,

	OnGrenadeSeen = function(self,entity,fDistance)
		AIBehaviour.FastIdle:OnGrenadeSeen(entity,fDistance)
	end,
	
	OnGrenadeSeen_Flying = function(self,entity,sender)
		self:OnGrenadeSeen(entity)
	end,

	OnGrenadeSeen_Colliding = function(self,entity,sender)
		self:OnGrenadeSeen(entity)
	end,

	OnKnownDamage = function(self,entity,sender)
		entity:InsertSubpipe(0,"DropBeaconTarget",sender.id)
		if not entity:MutantJump() then
			if entity.AI_CanWalk then
				entity:SelectPipe(0,"on_damage_scared")
			else
				entity:SelectPipe(0,"fast_alert_look_around")
			end
		end
	end,

	OnReceivingDamage = function(self,entity,sender)
		AIBehaviour.FastIdle:OnReceivingDamage(entity)
	end,

	OnBulletRain = function(self,entity,sender)
		AIBehaviour.FastIdle:OnBulletRain(entity,sender)
	end,

	OnSomethingDiedNearest = function(self,entity,sender)
		AIBehaviour.FastIdle:OnSomethingDiedNearest(entity,sender)
	end,
}