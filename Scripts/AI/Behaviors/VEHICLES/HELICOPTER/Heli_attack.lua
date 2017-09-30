-- Helocipter Behaviour SCRIPT
--------------------------
AIBehaviour.Heli_attack = {
	Name = "Heli_attack",

	strafeDir = -1,
	-- count = 0,

	OnSelected = function(self,entity)
		Hud:AddMessage(entity:GetName()..": Heli_attack/OnSelected")
		System:Log(entity:GetName()..": Heli_attack/OnSelected")
	end,
	
	OnSpawn = function(self,entity)
		System:Log("Heli_attack RECEIVED ON SPAWN")
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

	OnNoTarget = function(self,entity)
		-- AI:Signal(0,1,"GO_2_BASE",entity.id)
		local DropPoint = Game:GetTagPoint(entity.Properties.pointReinforce)
		if entity.dropState==0 and DropPoint then
			AI:Signal(0,1,"BRING_REINFORCMENT",entity.id)
			do return end
		end
		entity.seesPlayer = 0
		self.advance(self,entity)
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact) -- Без цели в виде игрока улетает куда-то вдаль.
		-- Hud:AddMessage(entity:GetName()..": Heli_attack/OnPlayerSeen")
		-- System:Log(entity:GetName()..": Heli_attack/OnPlayerSeen")
		-- System:Log("helicopter idle OnPlayerSeen --------------- "..self.count)
		-- self.count = self.count + 1
		entity.seesPlayer = 1
		entity:SelectPipe(0,"h_attack")
		-- AI:Signal(0,1,"NEXTPOINT",entity.id)
	end,
	
	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		-- Hud:AddMessage(entity:GetName()..": Heli_attack/OnEnemyMemory")
		-- System:Log(entity:GetName()..": Heli_attack/OnEnemyMemory")
		-- entity:SelectPipe(0,"h_standingthere")
		System:Log(" Helicopter attack OnEnemyMemory >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
		-- self.count = self.count + 1
		if entity.dropState==0 then
			-- local dropTarget = Game:GetTagPoint(entity.Properties.pointReinforce)
			-- if dropTarget then
				entity.CombatDropState = 1
				AI:Signal(0,1,"BRING_REINFORCMENT",entity.id)
				do return end
			-- end
		end
		entity.seesPlayer = 0
		self.advance(self,entity)
		do return end
		-- entity:SelectPipe(0,"h_looking")
		-- entity:InsertSubpipe(0,"h_attack_stop")
	end,

	OnEnemySeen = function(self,entity)
	end,

	OnGrenadeSeen = function(self,entity,fDistance)
		System:Log("Heli_attack OnGrenadeSeen")
		entity:InsertSubpipe(0,"h_grenade_run_away")
		-- entity:SelectPipe(0,"h_grenade_run_away")
		-- AI:Signal(0,1,"STARTSTRAFE",entity.id)
	end,

	OnGrenadeSeen_Flying = function(self,entity,sender)
		self:OnGrenadeSeen(entity)
	end,

	OnGrenadeSeen_Colliding = function(self,entity,sender)
		self:OnGrenadeSeen(entity)
	end,

	CHANGESTRAFE = function(self,entity,sender) -- C++
		-- self.NEXTPOINT(self,entity)
		-- do return end
		-- AI:Signal(0,1,"NEXTPOINT",entity.id)
		if (entity.curStrafeDir<0) then
			entity.strafeDir = 3
			entity:InsertSubpipe(0,"h_strafe_right")
			-- System:Log(" Helicopter attack CHANGESTRAFE  <<< ")
		else
			entity.strafeDir = -3
			entity:InsertSubpipe(0,"h_strafe_left")
			-- System:Log(" Helicopter attack CHANGESTRAFE  >>> ")
			-- entity:InsertSubpipe(0,"h_strafe_left")
		end
	end,

	STARTSTRAFE = function(self,entity,sender)
		entity:SetAICustomFloat(entity.Properties.fAttackAltitude)
		-- entity:SetAICustomFloat(entity.Properties.fAttackAltitude + random(-6,6))
		-- do return end
		if (entity.strafeDir<0) then
			entity.curStrafeDir = -1
			entity.strafeDir = entity.strafeDir + 2
			entity:InsertSubpipe(0,"h_strafe_left")
			-- System:Log(" Helicopter attack STARTSTRAFE  <<< ")
		else
			entity.curStrafeDir = 1
			entity.strafeDir = entity.strafeDir - 2
			entity:InsertSubpipe(0,"h_strafe_right")
			-- System:Log(" Helicopter attack STARTSTRAFE  >>> ")
			-- entity:InsertSubpipe(0,"h_strafe_left")
		end
		-- if (random(0,100)<50) then
			-- entity:InsertSubpipe(0,"h_strafe_left")
		-- else
			-- entity:InsertSubpipe(0,"h_strafe_right")
		-- end
	end,

	advance = function(self,entity,sender)
		-- System:Log("\001 Helicopter attack NEXTPOINT >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
		entity:SelectPipe(0,"h_attack_advance")
	end,

	NEXTPOINT_ATTACK = function(self,entity,sender)
		-- System:Log(" Helicopter attack NEXTPOINT >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
		entity:SetAICustomFloat(entity.Properties.fAttackAltitude)
		if (entity.seesPlayer==1) then
			entity:SelectPipe(0,"h_attack")
		else
			-- entity:SelectPipe(0,"h_attack")
			entity:SelectPipe(0,"h_attack_short")
		end
		-- if entity.CombatDropState then
			-- AI:Signal(0,1,"REINFORCMENT_OUT",entity.id)
		-- end
	end,

	REINFORCMENT_OUT = function(self,entity,sender)
		-- Hud:AddMessage(entity:GetName()..": REINFORCMENT_OUT")
		-- System:Log(entity:GetName()..": REINFORCMENT_OUT")
		System:Log(" Helicopter attack STARTATTACK >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
		if entity.Properties.attackrange>0 and entity.gunnerT and entity.gunnerT.entity then
			if entity.CombatDropState then
				AI:Signal(0,1,"NEXTPOINT_ATTACK",entity.id)
			else
				entity:Fly() -- Восстанавливает обычную высоту полёта.
				entity:SelectPipe(0,"h_gotoattack",entity.Properties.pointAttack) -- Сначала к точке атаки, а потом к цели.
			end
			-- entity:SetAICustomFloat(entity.Properties.fAttackAltitude)
			-- entity:SelectPipe(0,"h_attack_start")
		else
			AI:Signal(0,1,"GO_2_BASE",entity.id)
		end
	end,

	GO_2_BASE = function(self,entity,sender)
		entity:SetAICustomFloat(entity.Properties.fFlightAltitude)
		-- entity.EventToCall = ""
		System:Log(" Helicopter attack GO_2_BASE -------------------")
		entity:SelectPipe(0,"h_goto",entity.Properties.pointBackOff)
		entity:InsertSubpipe(0,"h_attack_stop")
	end,

	BRING_REINFORCMENT = function(self,entity,sender)
		-- Hud:AddMessage(entity:GetName()..": Heli_attack/BRING_REINFORCMENT")
		System:Log(entity:GetName()..": Heli_attack/BRING_REINFORCMENT")
		-- entity:SetAICustomFloat(entity.Properties.fFlightAltitude)
		if entity.CombatDropState then
			-- entity:SetAICustomFloat(0)
			entity:SetAICustomFloat(entity.Properties.dropAltitude)
			entity.dropState=1
			entity:SelectPipe(0,"a_h_drop",entity.Properties.pointReinforce)
		else
			entity:SelectPipe(0,"h_drop",entity.Properties.pointReinforce)
		end
		entity:InsertSubpipe(0,"h_attack_stop")
	end,

	low_health = function(self,entity,sender)
		AI:Signal(0,1,"GO_PATH",entity.id)
		entity.EventToCall = "NEXTPOINT"
	end,

	GUNNER_OUT = function(self,entity,sender)
		if (entity:HasReinforcement()==1) then
			AI:Signal(0,1,"BRING_REINFORCMENT",entity.id)
		else
			AI:Signal(0,1,"GO_2_BASE",entity.id)
		end
	end,

	GunnerLostTarget= function(self,entity,sender)
		-- System:Log("\001 heli >>> GunnerLostTarget "..entity.landed)
		if (not entity.attacking) then return end
		entity:SelectPipe(0,"h_attack_advance")
	end,

	DRIVER_IN = function(self,entity,sender)
		-- printf("Hely ATTACK -->> DRIVER_IN ")
		-- System:Log("\001 heli >>> driverIn ")
		entity:Fly()
		entity:SelectPipe(0,"h_gotoattack",entity.Properties.pointAttack)
		entity.attacking = 1
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
		-- Hud:AddMessage(entity:GetName()..": PRE_GRENADE_EXIT 1")
		-- System:Log(entity:GetName()..": PRE_GRENADE_EXIT 1")
	end,

	GRENADE_EXIT = function(self,entity,sender)
		-- Hud:AddMessage(entity:GetName()..": GRENADE_EXIT 1")
		-- System:Log(entity:GetName()..": GRENADE_EXIT 1")
	end,
}