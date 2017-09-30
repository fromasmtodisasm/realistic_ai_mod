--------------------------------------------------
--   Created By: petar
--   Description: This behaviour will just make whoever dig in behind a medium cover
--------------------------

AIBehaviour.DigIn = {
	Name = "DigIn",
	NOPREVIOUS = 1,

	OnNoTarget = function(self,entity) -- Проверить.
		self.LOS = nil 
	end,

	OnKnownDamage = function(self,entity,sender)
		-- called when the enemy is damaged
		entity:InsertSubpipe(0,"not_so_random_hide_from",sender.id)
	end,
	
	---------------------------------------------
	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		self.LOS = 1 
		if (fDistance<5) then 
			AI:Signal(0,1,"TO_PREVIOUS",entity.id)
			entity:TriggerEvent(AIEVENT_CLEAR)
		end
	end,
	---------------------------------------------
	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		self.LOS = nil 
		-- if (entity:GetGroupCount() > 1) then	
			-- AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_LOST,"ENEMY_TARGET_LOST_GROUP",entity.id)	
		-- else
			-- AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_LOST,"ENEMY_TARGET_LOST",entity.id)	
		-- end
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity)
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity)
	end,
	---------------------------------------------
	OnReceivingDamage = function(self,entity,sender)
		entity:TriggerEvent(AIEVENT_CLEAR)
		entity:InsertSubpipe(0,"shoot_cover")
	end,
	--------------------------------------------------
	OnGrenadeSeen = function(self,entity,fDistance)
		AI:Signal(0,1,"TO_PREVIOUS",entity.id)
	end,
	
	OnGrenadeSeen_Flying = function(self,entity,sender)
		self:OnGrenadeSeen(entity)
	end,

	OnGrenadeSeen_Colliding = function(self,entity,sender)
		self:OnGrenadeSeen(entity)
	end,
	--------------------------------------------------
	OnBulletRain = function(self,entity,fDistance)
	end,

	OnGroupMemberDied = function(self,entity,sender)
	end,
	--------------------------------------------------
	OnGroupMemberDiedNearest = function(self,entity,sender)
	end,
	--------------------------------------------------
	-- GROUP SIGNALS
	--------------------------------------------------
	HEADS_UP_GUYS = function(self,entity,sender)
	end,
	---------------------------------------------
	INCOMING_FIRE = function(self,entity,sender)
	end,

	---------------------------------------------
	CHECK_FOR_TARGET = function(self,entity,sender)
		if (not self.LOS) then
			AI:Signal(0,1,"TO_PREVIOUS",entity.id)
			entity:TriggerEvent(AIEVENT_CLEAR)
		else
			if entity:GrenadeAttack(9) then -- Проверить.
				Hud:AddMessage(entity:GetName()..": DigIn/CHECK_FOR_TARGET/GrenadeAttack")
				System:Log(entity:GetName()..": DigIn/CHECK_FOR_TARGET/GrenadeAttack")
				entity:SelectPipe(0,"dig_in_attack") -- Начать заного.
			end
		end
	end,
	---------------------------------------------
	CHECK_FOR_SAFETY = function(self,entity,sender)
		if (self.LOS) then
			AI:Signal(0,1,"TO_PREVIOUS",entity.id)
			entity:TriggerEvent(AIEVENT_CLEAR)
		end
	end,

	TO_PREVIOUS = function(self,entity,sender)
		AI:Signal(0,1,"OnReload",entity.id)
	end

}