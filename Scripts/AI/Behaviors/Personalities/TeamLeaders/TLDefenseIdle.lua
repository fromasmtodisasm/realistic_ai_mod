--    Created By: Petar
AIBehaviour.TLDefenseIdle = {
	Name = "TLDefenseIdle",
	switched = 0,

	-- SYSTEM EVENTS			-----

	OnSelected = function(self,entity)
	end,

	OnSpawn = function(self,entity)
		-- called when enemy spawned or reset
	end,

	OnActivate = function(self,entity)
		-- called when enemy receives an activate event (from a trigger,for example)
	end,

	OnNoTarget = function(self,entity)
		if self.WasInCombat then
			AIBehaviour.DEFAULT:OnNoTarget(entity)
			AIBehaviour.DEFAULT:AI_SETUP_UP(entity)
			entity:SelectPipe(0,"defense_keepcovered")
			local Protection = AI:FindObjectOfType(entity:GetPos(),20,AIAnchor.AIANCHOR_PROTECT_THIS_POINT)
			if Protection then
				entity:InsertSubpipe(0,"defend_point",Protection)
			else
				entity:InsertSubpipe(0,"defend_point")
			end
		end
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		if entity:ShootOrNo() then return end
		if not fDistance then fDistance = entity:GetDistanceToTarget() end
		if not fDistance then fDistance = 0 NotContact=1 end
		local GroupCount = entity:GetGroupCount()
		if not NotContact then
			AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY_ON_ATTACK(entity)
			if GroupCount > 1 then
				if random(1,2)==1 then
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN_GROUP",entity.id)
				else
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN",entity.id)
				end
			else
				AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN",entity.id)
			end
		end
		if entity:CheckEnemyWeaponDanger() then	return end
		if GroupCount>2 then
			AI:Signal(SIGNALID_READIBILITY,1,"LO_DEFENSIVE",entity.id) -- dont say anything if no group left alive
		else
			if entity.critical_status and fDistance > 30 then
				entity:SelectPipe(0,"hide_on_critical_status")
				do return end
			end
			if fDistance>30 then
				entity:RunToMountedWeapon()
			end
		end
		entity:GrenadeAttack()
		entity:SelectPipe(0,"defense_keepcovered")
		local Protection = AI:FindObjectOfType(entity:GetPos(),20,AIAnchor.AIANCHOR_PROTECT_THIS_POINT)
		if Protection then
			entity:InsertSubpipe(0,"defend_point",Protection)
		else
			entity:InsertSubpipe(0,"defend_point")
		end
		if not entity.AI_PlayerEngaged then
			if not NotContact then
				AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY(entity)
				AI:Signal(0,1,"SAY_FIRST_HOSTILE_CONTACT",entity.id)
			end
			entity:MakeAlerted()
			entity:InsertSubpipe(0,"setup_stand")
			entity.AI_PlayerEngaged = 1
		end
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		if not fDistance then fDistance = 0 NotContact=1 end
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if entity.AI_OnDanger then do return end end
		if entity.critical_status and fDistance > 30 then
			entity:SelectPipe(0,"hide_on_critical_status")
			do return end
		end
		entity:InsertSubpipe(0,"reload")
		if entity:RunToAlarm() then do return end end
		if not NotContact then
			if (entity:GetGroupCount() > 1) then
				if random(1,2)==1 then
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN_GROUP",entity.id)
				else
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN",entity.id)
				end
			else
				AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN",entity.id)
			end
		end
		if random(1,2)==1 then
			AIBehaviour.DEFAULT:AI_SETUP_UP(entity)
		else
			AIBehaviour.DEFAULT:AI_SETUP_DOWN(entity)
		end
	end,

	OnInterestingSoundHeard = function(self,entity)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
	end,

	OnThreateningSoundHeard = function(self,entity,fDistance)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if self.sees~=1 then
			self:OnPlayerSeen(entity,fDistance,1)
		end
	end,

	OnReload = function(self,entity)
		entity:InsertSubpipe(0,"take_cover")
	end,

	OnSomethingDiedNearest = function(self,entity,sender)
		AIBehaviour.CoverAttack:OnSomethingDiedNearest(entity,sender)
		entity:MakeAlerted()
		self:OnPlayerSeen(entity,0,1)
	end,

	OnSomethingDiedNearest_x = function(self,entity,sender)
		AIBehaviour.CoverAttack:OnSomethingDiedNearest_x(entity,sender)
	end,

	OnNoHidingPlace = function(self,entity,sender)
		AIBehaviour.DEFAULT:AI_SETUP_DOWN(entity)
	end,

	OnKnownDamage = function(self,entity,sender) -- Срабатывает когда ИИ видит или помнит того кто стрелял.
		entity:InsertSubpipe(0,"DropBeaconTarget",sender.id)
		entity:InsertSubpipe(0,"pause_shooting") -- Игроку надо сделать точно так же.
		entity:InsertSubpipe(0,"setup_crouch")
	end,

	OnReceivingDamage = function(self,entity,sender)
		-- called when the enemy is damaged
		entity:InsertSubpipe(0,"take_cover")
	end,

	OnCoverRequested = function(self,entity,sender)
		-- called when the enemy is damaged
	end,

	OnDeath = function(self,entity)
		AI:Signal(SIGNALFILTER_SUPERGROUP,1,"BREAK_FORMATION",entity.id)
		AIBehaviour.DEFAULT:OnDeath(entity,sender)
	end,

	KeepToSameCover = function(self,entity,sender)
		-- called when the enemy is damaged
		entity:SelectPipe(0,"defense_keepcovered")
	end,

	-- GROUP SIGNALS

	KEEP_FORMATION = function(self,entity,sender)
		-- the team leader wants everyone to keep formation
		entity:SelectPipe(0,"standfire")
	end,

	HEADS_UP_GUYS = function(self,entity,sender)
		-- the team leader wants everyone to keep formation
		self:OnPlayerSeen(entity,0,1)
	end,
}