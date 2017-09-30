
AIBehaviour.Car_transport = {
	Name = "Car_transport",
	allowed = 0,
	
	

	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSpawn = function(self,entity)

		self.step = entity.Properties.pathstart 

--		entity:SelectPipe(0,"v_drive",entity.Properties.pathname..self.step)
		
	end,
	---------------------------------------------
	OnActivate = function(self,entity)
		self.allowed = 1 
	end,
	---------------------------------------------
	OnNoTarget = function(self,entity)
--		entity:SelectPipe(0,"return_to_start")
	end,

	---------------------------------------------
	OnEnemyMemory = function(self,entity,fDistance,NotContact)

--		entity:TriggerEvent(AIEVENT_REJECT)

	end,

	--------------------------------------------
	OnPlayerSeen = function(self,entity,fDistance,NotContact)

--		entity:TriggerEvent(AIEVENT_REJECT)

	end,

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
	OnPlayerMemory = function(self,entity)
	end,
	---------------------------------------------
	OnEnemySeen = function(self,entity)
	end,
	---------------------------------------------
	OnDeadFriendSeen = function(self,entity)
	end,
	---------------------------------------------
	OnDeadEnemySeen = function(self,entity)
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity)
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity)
	end,
	---------------------------------------------
	OnGunfireHeard = function(self,entity)
	end,
	---------------------------------------------
	OnFootstepsHeard = function(self,entity)
	end,
	---------------------------------------------
	OnGranateSeen = function(self,entity)
	end,
	---------------------------------------------
	OnLongTimeNoTarget = function(self,entity)
	end,
	---------------------------------------------
	OnDied = function(self,entity)
	end,
	---------------------------------------------
	---------------------------------------------
	OnGroupMemberDied = function(self,entity,sender)
--do return end
--printf("Vehicle -------------- OnDeath")	
		if (sender==entity.driver) then				-- stop if the driver is killed
			AI:Signal(0,1,"DRIVER_OUT",entity.id)
		end	
	end,	
	---------------------------------------------
	---------------------------------------------
	OnNoNearerHidingPlace = function(self,entity,sender)

	end,	
	---------------------------------------------
	OnNoHidingPlace = function(self,entity,sender)
	end,	
	

	-- CUSTOM
	--------------------------------------------
	DRIVER_IN = function(self,entity,sender)

		entity:SelectPipe(0,"c_goto_ignore",entity.Properties.pointReinforce)
		local pipeName = entity:GetName().."transport" 
		entity:SelectPipe(0,pipeName,entity.Properties.pointReinforce)
	end,	
	
	---------------------------------------------
	next_point = function(self,entity,sender)

		entity:SelectPipe(0,"c_brake")
	end,
	
	---------------------------------------------
	DRIVER_OUT = function(self,entity,sender)
--printf("car patol  -------------- driver out")	
		entity:SelectPipe(0,"c_standingthere")
		entity:DropPeople()
	end,	


	---------------------------------------------
	stopped = function(self,entity,sender)
		
		printf("carTransport STOPPED")		
		entity:SelectPipe(0,"c_standingthere")		
		
		entity:DropPeople()

--		entity:PassengersOut()
--		entity:SelectPipe(0,"c_goto",entity.Properties.pointBackOff)		
			
	end,
	
	---------------------------------------------
	reinforcment_out = function(self,entity,sender)

System:Log(" Car REINFORCMENT_OUT ----------------- go?  "..entity.Properties.pointBackOff)

--entity:SelectPipe(0,"c_standingthere")
		entity:SelectPipe(0,"c_goto",entity.Properties.pointBackOff)		

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
