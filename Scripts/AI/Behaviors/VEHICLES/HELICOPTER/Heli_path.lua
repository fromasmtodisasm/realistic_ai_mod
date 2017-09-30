AIBehaviour.Heli_path = {
	Name = "Heli_path",

	OnNoTarget = function(self,entity)
		-- Hud:AddMessage(entity:GetName()..": Heli_path/OnNoTarget")
		System:Log(entity:GetName()..": Heli_path/OnNoTarget")
	end,
	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSpawn = function(self,entity)
		System:Log("Heli_path RECEIVED ON SPAWN")
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		-- Hud:AddMessage(entity:GetName()..": Heli_path/OnPlayerSeen")
		System:Log(entity:GetName()..": Heli_path/OnPlayerSeen")
	end,
	
	OnSomethingSeen = function(self,entity)
		-- Hud:AddMessage(entity:GetName()..": Heli_path/OnSomethingSeen")
		System:Log(entity:GetName()..": Heli_path/OnSomethingSeen")
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		-- Hud:AddMessage(entity:GetName()..": Heli_path/OnEnemyMemory")
		System:Log(entity:GetName()..": Heli_path/OnEnemyMemory")
	end,

	NEXTPOINT = function(self,entity,sender)

System:Log(" PATH Helicopter TIME2GO >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"..entity.pathStep)

		entity.pathStep = entity.pathStep + 1
		if (entity.pathStep >= entity.Properties.pathsteps) then
			-- local DropPoint = Game:GetTagPoint(entity.Properties.pointReinforce) -- Прикол, но трейнинге путь Вертолёта с кроу ведёт на базу, а не на точку атаки. В общем сюда вставлять эту штуку не катит.
			-- if entity.dropState==0 and DropPoint then
				-- AI:Signal(0,1,"BRING_REINFORCMENT",entity.id)
				-- do return end
			-- end
			if (entity.Properties.bPathloop==1) then
				entity.pathStep = entity.Properties.pathstart
			else
				AI:Signal(0,1,"GO_2_BASE",entity.id)
			end
		end

		printf("let's go!! #%d",entity.pathStep)

		if (entity.Properties.bIgnoreCollisions and entity.Properties.bIgnoreCollisions==1) then
			entity:SelectPipe(0,"h_goto_special",entity.Properties.pathname..entity.pathStep)
		else
			entity:SelectPipe(0,"h_goto",entity.Properties.pathname..entity.pathStep)
		end
	end,

	--------------------------------------------
	GO_ATTACK = function(self,entity,sender)

		entity:SelectPipe(0,"h_gotoattack",entity.Properties.pointAttack)
	end,


	--------------------------------------------
	BRING_REINFORCMENT = function(self,entity,sender)
		if (entity.dropState~=0 )	then
			do return end
		end
		-- Hud:AddMessage(entity:GetName()..": Heli_path/BRING_REINFORCMENT")
		-- System:Log(entity:GetName()..": Heli_path/BRING_REINFORCMENT")
		entity:SelectPipe(0,"h_drop",entity.Properties.pointReinforce)
--		entity.EventToCall = ""
	end,

	--------------------------------------------
	DRIVER_IN = function(self,entity,sender)

printf("Hely PATH -->> DRIVER_IN ")

		entity:Fly()
--		entity:SelectPipe(0,"h_goto",entity.Properties.pathname..0)

		if (entity.Properties.bIgnoreCollisions and entity.Properties.bIgnoreCollisions==1) then
			entity:SelectPipe(0,"h_goto_special",entity.Properties.pathname..entity.pathStep)
		else
			entity:SelectPipe(0,"h_goto",entity.Properties.pathname..entity.pathStep)
		end


	end,

	---------------------------------------------
	GO_2_BASE = function(self,entity,sender)
		entity:SetAICustomFloat(entity.Properties.fFlightAltitude)

		entity.EventToCall = ""
System:Log(" Helicopter path GO_2_BASE -------------------")
		entity:SelectPipe(0,"h_goto",entity.Properties.pointBackOff)
		entity:InsertSubpipe(0,"h_attack_stop")
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
		-- Hud:AddMessage(entity:GetName()..": PRE_GRENADE_EXIT 4")
		-- System:Log(entity:GetName()..": PRE_GRENADE_EXIT 4")
	end,

	GRENADE_EXIT = function(self,entity,sender)
		-- Hud:AddMessage(entity:GetName()..": GRENADE_EXIT 4")
		-- System:Log(entity:GetName()..": GRENADE_EXIT 4")
	end,
}