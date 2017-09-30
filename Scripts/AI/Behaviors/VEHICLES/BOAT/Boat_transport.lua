
AIBehaviour.Boat_transport = {
	Name = "Boat_transport",
	
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
	
		entity:InsertSubpipe(0,"c_grenade_run_away")
		
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
	
printf("---->>Boat_transport >>> DRIVER_IN "..entity.Properties.pointReinforce)			
	
		entity:SelectPipe(0,"b_goto_ignore",entity.Properties.pointReinforce)	
		entity:InsertSubpipe(0,"random_timeout")
		
--entity:SelectPipe(0,"c_standingthere")		
		
	end,	

	---------------------------------------------
	DRIVER_OUT = function(self,entity,sender)
printf("boat transport  -------------- driver out")	
		entity:SelectPipe(0,"b_standingthere")
		
		if (entity.UnloadPeople) then
			entity:UnloadPeople()
		end	
		
	end,	

	
	--------------------------------------------
	next_point = function(self,entity,sender)	
		printf("---->>Boat_transport >>> at droppoint ")		
		entity:SelectPipe(0,"b_timeout")
	end,


	--------------------------------------------
	reinforcment_out = function(self,entity,sender)	
	
		printf("---->>Boat_transport >>> do DropPeople")		
		if (entity.UnloadPeople) then
			entity:UnloadPeople()
		end	
		entity:SelectPipe(0,"b_standingthere")
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
