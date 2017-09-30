-- Helocipter Behaviour SCRIPT
--------------------------
AIBehaviour.Heli_transport = {
	Name = "Heli_transport",
	State = 0,
--	dropCounter = 0,

	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSpawn = function(self,entity)
		System:Log("helicopter transport RRECEIVED ON SPAWN")

--		entity:SelectPipe(0,"h_drop",entity.Properties.pathdroppoint)
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

--	OnReceivingDamage = function(self,entity,sender)
--System:Log("helicopter transport OnReceivingDamage ---------------")
--		entity:InsertSubpipe(0,"h_move_erratically")
--	end,

	-- CUSTOM
	---------------------------------------------
--	BRING_REINFORCMENT = function(self,entity,sender)
--System:Log("\001  BRING_REINFORCMENT doing")
--		entity:SelectPipe(0,"h_drop",entity.Properties.pathdroppoint)
--	end,

	---------------------------------------------
	-- OnGroupMemberDied = function(self,entity,sender)

		-- --System:Log("\001 Helicopter OnGroupMemberDied ----------------->>")

-- --		entity:MakeAlerted()
-- --		entity:InsertSubpipe(0,"DRAW_GUN")
	-- end,


	---------------------------------------------
	at_reinforsment_point = function(self,entity,sender)

		System:Log(" at_reinforsment_point  -------------------------------------------------->>>")
--		entity:SelectPipe(0,"h_standingthere")
		entity:SelectPipe(0,"h_standingtherestill")
		entity:DropPeople()

	end,



	---------------------------------------------
	---------------------------------------------
	---------------------------------------------
	APPROACHING_DROPPOINT = function(self,entity,sender)
		System:Log(" APPROACHING_DROPPOINT  -------------------------------------------------->>>")
		entity:ApproachingDropPoint()
	end,

	---------------------------------------------
	FLY = function(self,entity,sender)

		entity:SetAICustomFloat(entity.Properties.fAttackAltitude)
--		entity:SetAICustomFloat(entity.Properties.fFlightAltitude)

	end,

	---------------------------------------------
	ON_GROUND = function(self,entity,sender)
		-- Hud:AddMessage(entity:GetName()..": ON_GROUND")
		-- System:Log(entity:GetName()..": ON_GROUND")
--		entity.troopers2Drop = entity.troopers2Drop - 1
--		if (entity.troopers2Drop < 1) then

		--System:Log("\001 Helicopter ON_GROUND ----------------->>   "..entity.troopersNumber)
		entity.troopersNumber = entity.troopersNumber - 1

		-- if (entity.troopersNumber < 1) then
		if (entity.troopersNumber < 1) then
--				AI:Signal(0,1,"REINFORCMENT_OUT",entity.id)
--				AI:Signal(0,1,"READY_TO_GO",entity.id)
				if entity.CombatDropState then
					entity:SelectPipe(0,"a_h_timeout_readytogo")
				else
					entity:SelectPipe(0,"h_timeout_readytogo")
				end
				entity.dropState = 3
			--System:Log("\001 Helicopter ON_GROUND ----------------->>   GOOOOO ")

		end
	end,


	---------------------------------------------
--	REINFORCMENT_OUT = function(self,entity,sender)
--
--System:Log(" Helicopter REINFORCMENT_OUT ----------------- go?  "..entity.Properties.pointBackOff)
--
--	entity:SelectPipe(0,"h_goto_start",entity.Properties.pointBackOff)
--
--	end,

	---------------------------------------------
	READY_TO_GO	 = function(self,entity,sender)

System:Log(" Helicopter READY_TO_GO	 ----------------- go?  "..entity.Properties.pointBackOff)

	entity:DropDone() -- Вернуть скорость.

	entity:InsertSubpipe(0,"h_attack_stop") -- Отклеиться.
	entity.EventToCall = "REINFORCMENT_OUT"  -- Вызывает из следующего состояния (Heli_attack).

	end,

	--------------------------------------------
	DRIVER_IN = function(self,entity,sender)

printf("Hely BRING_REINFORCMENT -->> DRIVER_IN ")

		entity:Fly()
		entity:SelectPipe(0,"h_drop",entity.Properties.pointReinforce)

	end,


	--------------------------------------------
	BRING_REINFORCMENT = function(self,entity,sender)

--		Hud:AddMessage("V22 RECEIVED BRING REINFORCEMENT IN TRANSPORT  ")

	end,


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
		-- Hud:AddMessage(entity:GetName()..": PRE_GRENADE_EXIT 6")
		-- System:Log(entity:GetName()..": PRE_GRENADE_EXIT 6")
	end,

	GRENADE_EXIT = function(self,entity,sender)
		-- Hud:AddMessage(entity:GetName()..": GRENADE_EXIT 6")
		-- System:Log(entity:GetName()..": GRENADE_EXIT 6")
	end,
}