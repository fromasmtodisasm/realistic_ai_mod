
AIBehaviour.Boat_patrol = {
	Name = "Boat_patrol",
	
	step = 0,
	

	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSpawn = function(self,entity)

		self.step = entity.Properties.pathstart 

	end,
	---------------------------------------------
	OnActivate = function(self,entity)

	end,
	---------------------------------------------
	---------------------------------------------
	OnGrenadeSeen = function(self,entity)

printf("Vehicle -------------- OnGranateSeen")	
	
--		entity:InsertSubpipe(0,"c_grenade_run_away")
		
	end,
	OnGrenadeSeen_Flying = function(self,entity,sender)
		self:OnGrenadeSeen(entity)
	end,

	OnGrenadeSeen_Colliding = function(self,entity,sender)
		self:OnGrenadeSeen(entity)
	end,
	OnGroupMemberDied = function(self,entity,sender)
--	OnDeath = function(self,entity,sender)

--do return end
	
printf("Vehicle -------------- OnDeath")	
	
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

		entity.EventToCall = "DRIVER_IN" 

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
	
		printf("-->>boat DRIVER_IN !!  point is #%d",entity.curPathStep)		
	
		AI:Signal(0,1,"next_point",entity.id)					
		
--entity:SelectPipe(0,"c_standingthere")		
		
	end,	

	---------------------------------------------
	DRIVER_OUT = function(self,entity,sender)
printf("boat path  -------------- driver out")	
		entity:SelectPipe(0,"b_standingthere")
		
--		if (entity.UnloadPeople) then
--			entity:UnloadPeople()
--		end	
	end,

	---------------------------------------------
	GUNNER_OUT = function(self,entity,sender)
		AI:Signal(0,1,"BRING_REINFORCMENT",entity.id)
	end,	

	--------------------------------------------
	BRING_REINFORCMENT = function(self,entity,sender)
		entity.EventToCall = "DRIVER_IN" 
	end,

	--------------------------------------------
	FLARE_OUT = function(self,entity,sender)
		AI:Signal(0,1,"BRING_REINFORCMENT",entity.id)
	end,

	--------------------------------------------
	next_point = function(self,entity,sender)	
	
		entity.curPathStep = entity.curPathStep + 1 
		if (entity.curPathStep >= entity.Properties.pathsteps) then
			entity.curPathStep = entity.Properties.pathstart 			
		end	
		
		printf("---->>let's go!!  #%d",entity.curPathStep)		
		entity:SelectPipe(0,"b_goto",entity.Properties.pathname..entity.curPathStep)
--		entity:SelectPipe(0,"c_goto_path",entity.Properties.pathname..self.step)		

	end,

	--------------------------------------------
	ON_GROUND = function(self,entity,sender)	
	
		if (entity.UnloadPeople) then
			entity:UnloadPeople()
		end	
		
		printf("---->>Boat_transport >>> onground ")		
		entity:SelectPipe(0,"b_standingthere")
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
