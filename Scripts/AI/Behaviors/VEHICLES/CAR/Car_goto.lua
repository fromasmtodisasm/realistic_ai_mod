
AIBehaviour.Car_goto = {
	Name = "Car_goto",
	

	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSpawn = function(self,entity)

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
	---------------------------------------------
	OnGroupMemberDied = function(self,entity,sender)
--do return end
--printf("Vehicle -------------- OnDeath")	
		if (sender==entity.driver) then				-- stop if the driver is killed
			AI:Signal(0,1,"DRIVER_OUT",entity.id)
		end	
	end,	

	---------------------------------------------
	OnPlayerMemory = function(self,entity)
	end,
	---------------------------------------------
	OnEnemySeen = function(self,entity)
	end,
	---------------------------------------------
	OnDeadFriendSeen = function(self,entity)
	end,
	---------------------------------------------
	OnGranateSeen = function(self,entity)
	
		entity:InsertSubpipe(0,"c_grenade_run_away")	
	
	end,
	---------------------------------------------
	OnDied = function(self,entity)
	end,
	---------------------------------------------
	---------------------------------------------
	

	-- CUSTOM
	---------------------------------------------
	

	---------------------------------------------
	DRIVER_OUT = function(self,entity,sender)
--printf("car patol  -------------- driver out")	
		entity:SelectPipe(0,"c_brake")
		entity:DropPeople()		
	end,	


	--------------------------------------------
	next_point = function(self,entity,sender)
System:Log("carGoto NEXTPOINT")
		entity:SelectPipe(0,"c_standingthere")
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
