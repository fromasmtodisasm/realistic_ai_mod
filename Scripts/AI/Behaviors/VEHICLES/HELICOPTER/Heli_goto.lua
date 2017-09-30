-- Helocipter Behaviour SCRIPT
--------------------------
AIBehaviour.Heli_goto = {
	Name = "Heli_goto",
	State = 0,
	dropCounter = 0,

	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSpawn = function(self,entity)
		System:Log("RECEIVED ON SPAWN")

--		entity:SelectPipe(0,"h_drive",entity.Properties.pathname..self.step)

	end,

	OnNoTarget = function(self,entity)
		Hud:AddMessage(entity:GetName()..": Heli_goto/OnNoTarget")
		System:Log(entity:GetName()..": Heli_goto/OnNoTarget")
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		Hud:AddMessage(entity:GetName()..": Heli_goto/OnPlayerSeen")
		System:Log(entity:GetName()..": Heli_goto/OnPlayerSeen")
	end,
	
	OnSomethingSeen = function(self,entity)
		Hud:AddMessage(entity:GetName()..": Heli_goto/OnSomethingSeen")
		System:Log(entity:GetName()..": Heli_goto/OnSomethingSeen")
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		Hud:AddMessage(entity:GetName()..": Heli_goto/OnEnemyMemory")
		System:Log(entity:GetName()..": Heli_goto/OnEnemyMemory")
	end,

	OnGrenadeSeen = function(self,entity,fDistance)
		AIBehaviour.Heli_idle:OnGrenadeSeen(entity,fDistance)
	end,

	OnGrenadeSeen_Flying = function(self,entity,sender)
		AIBehaviour.Heli_idle:OnGrenadeSeen_Flying(entity)
	end,

	OnGrenadeSeen_Colliding = function(self,entity,sender)
		AIBehaviour.Heli_idle:OnGrenadeSeen_Colliding(entity)
	end,

	FLY = function(self,entity,sender)

		entity:SetAICustomFloat(entity.Properties.fFlightAltitude)

	end,

	---------------------------------------------
	NEXTPOINT = function(self,entity,sender)

		--System:Log("\002 RECEIVED ------ NEXTPOINT")

		entity:Land()
		entity:SelectPipe(0,"standingthere")
--		entity.EventToCall = ""

	end,


	---------------------------------------------
	REINFORCMENT_OUT = function(self,entity,sender)

		entity:SelectPipe(0,"h_goto",entity.Properties.pointBackOff)

	end,


	---------------------------------------------
--	NEXTPOINT = function(self,entity,sender)

--System:Log(" GOTO Helicopter TIME2GO >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"..self.step)

--		self.step = self.step + 1
--		if (self.step >= entity.Properties.pathsteps) then
--			self.step = entity.Properties.pathstart
--		end

--		printf("let's go!! #%d",self.step)
--		entity:SelectPipe(0,"h_drive",entity.Properties.pathname..self.step)

--	end,

	OnSomethingDiedNearest = function(self,entity,sender)
	end,

	OnSomethingDiedNearest_x = function(self,entity,sender)
	end,

	OnReceivingDamage = function(self,entity,sender)
	end,

	OnBulletRain = function(self,entity,sender)
	end,

	OnCloseContact = function(self,entity,sender)
	end,

	ALARM_ON = function(self,entity,sender)
	end,

	ALERT_SIGNAL = function(self,entity,sender)
	end,

	NORMAL_THREAT_SOUND = function(self,entity,sender)
	end,

	LOOK_AT_BEACON = function(self,entity,sender)
	end,

	STOP_LOOK_AT_BEACON = function(self,entity,sender)
	end,

	INCOMING_FIRE = function(self,entity,sender)
	end,

	HEADS_UP_GUYS = function(self,entity,sender)
	end,

	GoForReinforcement = function(self,entity,sender)
	end,

	RunToAlarmSignal = function(self,entity,sender)
	end,

	FIND_A_TARGET = function(self,entity,sender)
	end,

	TARGET_LOST = function(self,entity,sender)
	end,

	SWITCH_TO_MORTARGUY = function(self,entity,sender)
	end,

	SEARCH_AMMUNITION = function(self,entity,sender)
	end,

	SELECT_IDLE = function(self,entity,sender)
	end,
	PRE_GRENADE_EXIT = function(self,entity,sender)
		-- Hud:AddMessage(entity:GetName()..": PRE_GRENADE_EXIT 2")
		-- System:Log(entity:GetName()..": PRE_GRENADE_EXIT 2")
	end,

	GRENADE_EXIT = function(self,entity,sender)
		-- Hud:AddMessage(entity:GetName()..": GRENADE_EXIT 2")
		-- System:Log(entity:GetName()..": GRENADE_EXIT 2")
	end,
}