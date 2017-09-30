
AIBehaviour.Car_path = {
	Name = "Car_path",


	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSpawn = function(self,entity)

	end,
	---------------------------------------------
	OnActivate = function(self,entity)

	end,
	---------------------------------------------
	---------------------------------------------
	OnGrenadeSeen = function(self,entity)
		printf("Vehicle -------------- OnGranateSeen")
		entity:InsertSubpipe(0,"c_grenade_run_away")
	end,
	OnGrenadeSeen_Flying = function(self,entity,sender)
		self:OnGrenadeSeen(entity)
	end,

	OnGrenadeSeen_Colliding = function(self,entity,sender)
		self:OnGrenadeSeen(entity)
	end,
	OnGroupMemberDied = function(self,entity,sender) -- Сделать если в машине только люди из группы то...
		--do return end
		--printf("Vehicle -------------- OnDeath")
		if (sender==entity.driver) then				-- stop if the driver is killed
			AI:Signal(0,1,"DRIVER_OUT",entity.id)
		end
	end,

	---------------------------------------------
	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		--printf("Vehicle -------------- RejectPlayer")
		--		entity:TriggerEvent(AIEVENT_REJECT)
	end,

	--------------------------------------------
	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		--printf("Vehicle -------------- RejectPlayer")
		--		entity:TriggerEvent(AIEVENT_REJECT)
	end,

	---------------------------------------------
	-- CUSTOM
	---------------------------------------------
	---------------------------------------------
	VEHICLE_ARRIVED = function(self,entity,sender)
		printf("Vehicle is there")
		entity:SelectPipe(0,"v_brake")
	end,
	--------------------------------------------
	DRIVER_IN = function(self,entity,sender)
		if (entity.Properties.pathstartAlter and entity.driverT.entity) then
			if (entity.driverT.entity.Properties.special==1 and entity.Properties.pathstartAlter>=0) then
				entity.Properties.pathname = entity.driverT.entity.Properties.pathname 
				entity.step = entity.Properties.pathstartAlter - 1 
			end
		end
		AI:Signal(0,1,"next_point",entity.id)
	end,

	--------------------------------------------
	GO_CHASE = function(self,entity,sender)
		entity.EventToCall = "DRIVER_IN" 
	end,

	--------------------------------------------
	BRING_REINFORCMENT = function(self,entity,sender)
		entity.EventToCall = "DRIVER_IN" 
	end,
	--------------------------------------------
	EVERYONE_OUT = function(self,entity,sender)
		entity:SelectPipe(0,"c_brake")
--		entity:EveryoneOut()
		VC.DropPeople(entity)
--		AI:Signal(0,1,"next_point",entity.id)
	end,
	--------------------------------------------
	next_point = function(self,entity,sender)
		entity.step = entity.step + 1 
		if (entity.step >= entity.Properties.pathsteps) then
--			entity.step = entity.Properties.pathstart 
			if (entity.Properties.bPathloop==1) then
				entity.step = entity.Properties.pathstart 
			else
				if (entity.Event_PathEnd) then
					entity:Event_PathEnd()
				end
--				AI:Signal(0,1,"EVERYONE_OUT",entity.id)
				AI:Signal(0,1,"DRIVER_OUT",entity.id)
			end
		end
		printf("---->>let's go!!  #%d [%d] loop=%d",entity.step,entity.Properties.pathsteps,entity.Properties.bPathloop)
		entity:SelectPipe(0,entity:GetName().."path",entity.Properties.pathname..entity.step)
		
		if entity and (entity.driverT.entity.Properties.special==1 or entity.driverT.entity.Properties.species==_localplayer.Properties.species) and not entity.OldDriving then
			entity.OldDriving = 1  -- C++ -- Вернуть старое поведение машины.
			-- Hud:AddMessage(entity.driverT.entity:GetName()..": OldDriving")
		end
		
		-- local pipeName = entity:GetName().."path" 
		-- AI:CreateGoalPipe(pipeName)
		-- AI:PushGoal(pipeName,"ignoreall",0,1) -- Меня невидит
		-- -- AI:PushGoal(pipeName,"setup_crouch")
		-- AI:PushGoal(pipeName,"strafe",0,0)	-- Остановить торможение
		-- AI:PushGoal(pipeName,"acqtarget",0,"")
		-- -- AI:PushGoal(pipeName,"approach",1,1)
		-- -- AI:PushGoal(pipeName,"approach",1,1,1)
		-- AI:PushGoal(pipeName,"approach",1,7)
		-- AI:PushGoal(pipeName,"signal",0,1,"next_point",0)
	end,

	---------------------------------------------
	DRIVER_OUT = function(self,entity,sender)
--printf("car patol  -------------- driver out")
		entity:SelectPipe(0,"c_brake")
		entity:DropPeople()
		entity.OldDriving = nil  
	end,

	---------------------------------------------
	GUNNER_OUT = function(self,entity,sender)
--printf("car patol  -------------- driver out")
		entity:SelectPipe(0,"c_brake")
		entity:DropPeople()
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
}
