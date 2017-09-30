AIBehaviour.Heli_idle = {
	Name = "Heli_idle",
	State = 0,
	dropCounter = 0,

	OnNoTarget = function(self,entity)
		-- Hud:AddMessage(entity:GetName()..": Heli_idle/OnNoTarget")
		System:Log(entity:GetName()..": Heli_idle/OnNoTarget")
	end,

	OnSpawn = function(self,entity)
		-- Hud:AddMessage(entity:GetName()..": Heli_idle/OnSpawn")
		System:Log(entity:GetName()..": Heli_idle/OnSpawn")
		System:Log("helicopter idle RECEIVED ON SPAWN")
		self.dropCounter = 0
		self.step = entity.Properties.pathstart
		entity:SelectPipe(0,"h_standingthere")
	end,

	OnGrenadeSeen = function(self,entity,fDistance)
		entity:InsertSubpipe(0,"h_grenade_run_away")
	end,

	OnGrenadeSeen_Flying = function(self,entity,sender)
		self:OnGrenadeSeen(entity)
	end,

	OnGrenadeSeen_Colliding = function(self,entity,sender)
		self:OnGrenadeSeen(entity)
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		entity.EventToCall = "NEXTPOINT"
		-- entity:SelectPipe(0,"h_attack")
		-- Hud:AddMessage(entity:GetName()..": Heli_idle/OnPlayerSeen")
		System:Log(entity:GetName()..": Heli_idle/OnPlayerSeen")
	end,
	
	OnSomethingSeen = function(self,entity)
		-- Hud:AddMessage(entity:GetName()..": Heli_idle/OnSomethingSeen")
		System:Log(entity:GetName()..": Heli_idle/OnSomethingSeen")
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		-- Hud:AddMessage(entity:GetName()..": Heli_idle/OnEnemyMemory")
		System:Log(entity:GetName()..": Heli_idle/OnEnemyMemory")
	end,

	OnCloseContact = function(self,entity,sender)
	end,

	OnReceivingDamage = function(self,entity,sender)
		-- entity:InsertSubpipe(0,"h_move_erratically")
	end,

	OnBulletRain = function(self,entity,sender)
		-- Hud:AddMessage(entity:GetName()..": Heli_Idle/OnBulletRain")
		-- System:Log(entity:GetName()..": Heli_Idle/OnBulletRain")
	end,

	OnSomethingDiedNearest = function(self,entity,sender)
	end,

	OnSomethingDiedNearest_x = function(self,entity,sender)
	end,

	SELECT_RED = function(self,entity,sender)
	end,

	SELECT_BLACK = function(self,entity,sender)
	end,

	BRING_REINFORCMENT = function(self,entity,sender)
		if (entity.dropState~=0 )	then
			do return end
		end
		entity:LoadPeople()
		-- entity:Fly()
		-- entity:SelectPipe(0,"h_drop",entity.Properties.pointReinforce)
		-- -- entity.EventToCall = ""
	end,

	REINFORCMENT_RESTORE = function(self,entity,sender)
		entity.EventToCall = "DRIVER_IN"
	end,

	GO_ATTACK = function(self,entity,sender)
		entity:LoadPeople()
		-- entity:Fly()
		-- entity:SelectPipe(0,"h_gotoattack",entity.Properties.pointAttack)
	end,

	ATTACK_RESTORE = function(self,entity,sender)
		entity.EventToCall = "GunnerLostTarget"
		entity.attacking = 1
		entity:SelectPipe(0,"h_gotoattack",entity.Properties.pointAttack)
		-- entity.EventToCall = "DRIVER_IN"
		-- entity:Fly()
		-- entity:SelectPipe(0,"h_gotoattack",entity.Properties.pointAttack)
	end,

	GO_PATROL = function(self,entity,sender)
		-- Hud:AddMessage(entity:GetName()..": Heli_idle/GO_PATROL")
		-- System:Log(entity:GetName()..": Heli_idle/GO_PATROL")
		entity:LoadPeople()
	end,

	PATROL_RESTORE = function(self,entity,sender)
		entity.EventToCall = "NEXTPOINT"
		if (entity.pathStep > 0) then
			entity.pathStep = entity.pathStep - 1
		else
			entity.pathStep = entity.Properties.pathsteps - 1
		end
	end,

	GO_PATH = function(self,entity,sender)
		entity:LoadPeople()
		-- entity.EventToCall = "NEXTPOINT"
		-- Hud:AddMessage(entity:GetName()..": Heli_idle/GO_PATH")
		-- System:Log(entity:GetName()..": Heli_idle/GO_PATH")
		-- AIBehaviour.HeliAssaultPath:NEXTPOINT(entity)
		-- entity:Fly()
		-- entity:SelectPipe(0,"h_goto",entity.Properties.pathname..0)
	end,

	PATH_RESTORE = function(self,entity,sender)
		entity.EventToCall = "NEXTPOINT"
		if (entity.pathStep > 0) then
			entity.pathStep = entity.pathStep - 1
		else
			entity.pathStep = entity.Properties.pathsteps - 1
		end
	end,

	READY_TO_GO	 = function(self,entity,sender)
		System:Log(" Helicopter READY_TO_GO	 ----------------- go?  "..entity.Properties.pointBackOff)
		entity:DropDone()
		entity:InsertSubpipe(0,"h_attack_stop")
		entity.EventToCall = "REINFORCMENT_OUT"
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
		-- Hud:AddMessage(entity:GetName()..": PRE_GRENADE_EXIT 3")
		-- System:Log(entity:GetName()..": PRE_GRENADE_EXIT 3")
	end,

	GRENADE_EXIT = function(self,entity,sender)
		-- Hud:AddMessage(entity:GetName()..": GRENADE_EXIT 3")
		-- System:Log(entity:GetName()..": GRENADE_EXIT 3")
	end,
}