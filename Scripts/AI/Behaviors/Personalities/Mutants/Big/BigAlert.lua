AIBehaviour.BigAlert = { -- Не сделан.
	Name = "BigAlert",

	OnNoTarget = function(self,entity)
		AIBehaviour.DEFAULT:OnNoTarget(entity)
		-- entity:InsertSubpipe(0,"reload")
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		AIBehaviour.BigIdle:OnPlayerSeen(entity,fDistance,1)
	end,

	OnPlayerAiming = function(self,entity,sender)
	end,

	OnSomethingSeen = function(self,entity)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
	end,

	OnInterestingSoundHeard = function(self,entity,fDistance)
		self:OnThreateningSoundHeard(entity,fDistance,1)
	end,

	OnThreateningSoundHeard = function(self,entity,fDistance)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
	end,

	OnClipNearlyEmpty = function(self,entity,sender)
	end,

	OnReload = function(self,entity)
	end,

	OnNoHidingPlace = function(self,entity,sender)
	end,

	OnGrenadeSeen = function(self,entity,fDistance)
		AIBehaviour.BigIdle:OnGrenadeSeen(entity,fDistance)
	end,

	OnGrenadeSeen_Flying = function(self,entity,sender)
		self:OnGrenadeSeen(entity)
	end,

	OnGrenadeSeen_Colliding = function(self,entity,sender)
		self:OnGrenadeSeen(entity)
	end,

	OnNoFormationPoint = function(self,entity,sender)
	end,

	OnCoverRequested = function(self,entity,sender)
	end,

	OnKnownDamage = function(self,entity,sender)
		entity:InsertSubpipe(0,"DropBeaconTarget",sender.id)
	end,

	OnReceivingDamage = function(self,entity,sender)
		AIBehaviour.BigIdle:OnReceivingDamage(entity)
	end,

	OnBulletRain = function(self,entity,sender)
		AIBehaviour.BigIdle:OnBulletRain(entity,sender)
	end,

	OnSomethingDiedNearest = function(self,entity,sender)
		AIBehaviour.BigIdle:OnSomethingDiedNearest(entity,sender)
	end,
}