
AIBehaviour.Car_idle = {
	Name = "Car_idle",

	-- не работает
	
	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSpawn = function(self,entity)

	end,
	---------------------------------------------
	OnActivate = function(self,entity)

	end,
	---------------------------------------------
	OnNoTarget = function(self,entity)
--		entity:SelectPipe(0,"return_to_start")
	end,
	---------------------------------------------
	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		-- if (self.allowed==1) then
			-- entity:SelectPipe(0,"getinvehicle")
		-- end
	end,
	---------------------------------------------
	OnPlayerMemory = function(self,entity)
	end,
	---------------------------------------------
	OnEnemySeen = function(self,entity)
	end,
	---------------------------------------------
	OnEnemyMemory = function(self,entity,fDistance,NotContact)
--		entity:SelectPipe(0,"return_to_start")
--		entity:SelectPipe(0,"standingthere")
	end,
	---------------------------------------------
	OnDeadFriendSeen = function(self,entity)
	end,
	---------------------------------------------
	OnGranateSeen = function(self,entity)
	end,
	---------------------------------------------
	OnDied = function(self,entity)
	end,
	---------------------------------------------
	OnGroupMemberDied = function(self,entity)
	end,
	---------------------------------------------
	OnGroupMemberDiedNearest  = function(self,entity,sender)

		AI:Signal(SIGNALFILTER_NEARESTGROUP,1,"OnGroupMemberDiedNearest",entity.id)

	end,
	---------------------------------------------


	-- CUSTOM
	---------------------------------------------

	--------------------------------------------
	BRING_REINFORCMENT = function(self,entity,sender)

printf("car idle BRING_REINFORCMENT ")

--		entity:AIDriver(1)
		entity:LoadPeople()

--		entity:SelectPipe(0,"c_goto",entity.Properties.pointReinforce)
--		entity.EventToCall = ""

	end,

	--------------------------------------------
	GO_PATH = function(self,entity,sender)

		if (entity.LoadPeople) then
			entity:LoadPeople()
		end
--		entity.EventToCall = "next_point" 

--entity:SelectPipe(0,"c_standingthere")

	end,

	--------------------------------------------
	GO_PATROL = function(self,entity,sender)

		if (entity.LoadPeople) then
			entity:LoadPeople()
		end
--		entity.EventToCall = "next_point" 

--entity:SelectPipe(0,"c_standingthere")

	end,

	--------------------------------------------
	GO_CHASE = function(self,entity,sender)
		if (entity.LoadPeople) then
			entity:LoadPeople()
		end
	end,


--	SHARED_ENTER_ME_VEHICLE = function(self,entity,sender)
--	end,

	---------------------------------------------
	DRIVER_OUT = function(self,entity,sender)
--printf("car patol  -------------- driver out")

--System:Log("\001 DRIVER_OUT >> DropPeople ")

		entity:SelectPipe(0,"c_brake")
		entity:DropPeople()
	end,


	---------------------------------------------
	PLAYER_ENTERED = function(self,entity,sender)
--printf("car patol  -------------- driver out")

		-- if it's not Valery drivind -
		if (entity.driverT and entity.driverT.entity and entity.driverT.entity.Properties.special==0 and entity.driverT.entity~=_localplayer
		or
		entity.gunnerT and entity.gunnerT.entity and entity.gunnerT.entity.Properties.special==1 and entity.gunnerT.entity~=_localplayer
	) then
--System:Log("\001 PALYER_ENTERED >> DropPeople ")

			entity:SelectPipe(0,"c_brake")
			entity:DropPeople()
		end
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
