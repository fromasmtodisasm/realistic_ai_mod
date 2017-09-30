-- Helocipter Behaviour SCRIPT
--------------------------
AIBehaviour.Heli_patrol = {
	Name = "Heli_patrol",

	-- SYSTEM EVENTS			-----

	OnSpawn = function(self,entity)
		System:Log("Heli_patrol RECEIVED ON SPAWN")
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

	NEXTPOINT = function(self,entity,sender)

		System:Log(" PATROL Helicopter TIME2GO >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"..entity.pathStep)

		entity.pathStep = entity.pathStep + 1
		if (entity.pathStep >= entity.Properties.pathsteps) then
			entity.pathStep = entity.Properties.pathstart
		end

		printf("let's go!! #%d",entity.pathStep)
		entity:SelectPipe(0,"h_goto_patrol",entity.Properties.pathname..entity.pathStep)
	end,


	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		-- Hud:AddMessage(entity:GetName()..": Heli_patrol/OnPlayerSeen")
		-- System:Log(entity:GetName()..": Heli_patrol/OnPlayerSeen")
		entity.EventToCall = "OnPlayerSeen"
	end,


	GO_ATTACK = function(self,entity,sender)

		entity:SelectPipe(0,"h_gotoattack",entity.Properties.pointAttack)
	end,



	BRING_REINFORCMENT = function(self,entity,sender)

		if (entity.dropState~=0)	then
			do return end
		end

		entity:SelectPipe(0,"h_drop",entity.Properties.pointReinforce)
--		entity.EventToCall = ""
	end,


	GUNNER_OUT = function(self,entity,sender)

		if (entity:HasReinforcement()==1) then
			AI:Signal(0,1,"BRING_REINFORCMENT",entity.id)
		else
			AI:Signal(0,1,"GO_2_BASE",entity.id)
		end

	end,


	DRIVER_IN = function(self,entity,sender)

printf("Hely PATH -->> DRIVER_IN ")

		entity:Fly()
		entity:SelectPipe(0,"h_goto_patrol",entity.Properties.pathname..0)

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
		-- Hud:AddMessage(entity:GetName()..": PRE_GRENADE_EXIT 5")
		-- System:Log(entity:GetName()..": PRE_GRENADE_EXIT 5")
	end,

	GRENADE_EXIT = function(self,entity,sender)
		-- Hud:AddMessage(entity:GetName()..": GRENADE_EXIT 5")
		-- System:Log(entity:GetName()..": GRENADE_EXIT 5")
	end,
}