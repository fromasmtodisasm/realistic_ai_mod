
AIBehaviour.Car_goto = {
	Name = "Car_goto",
	

	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSpawn = function(self , entity )

	end,
	---------------------------------------------
	OnActivate = function(self, entity )
		self.allowed = 1;
	end,
	---------------------------------------------
	OnNoTarget = function(self, entity )
--		entity:SelectPipe(0,"return_to_start");
	end,

	---------------------------------------------
	OnEnemyMemory = function( self, entity )

--		entity:TriggerEvent(AIEVENT_REJECT);

	end,

	--------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )

--		entity:TriggerEvent(AIEVENT_REJECT);

	end,

	---------------------------------------------
	---------------------------------------------
	OnGroupMemberDied = function( self,entity,sender )
--do return end
--printf( "Vehicle -------------- OnDeath" );	
		if( sender == entity.driver ) then				-- stop if the driver is killed
			AI:Signal( 0, 1, "DRIVER_OUT",entity.id);
		end	
	end,	

	---------------------------------------------
	OnPlayerMemory = function(self, entity )
	end,
	---------------------------------------------
	OnEnemySeen = function(self, entity )
	end,
	---------------------------------------------
	OnDeadFriendSeen = function(self,entity )
	end,
	---------------------------------------------
	OnGranateSeen = function(self, entity )
	
		entity:InsertSubpipe(0,"c_grenade_run_away" );	
	
	end,
	---------------------------------------------
	OnDied = function( self,entity )
	end,
	---------------------------------------------
	---------------------------------------------
	

	-- CUSTOM
	---------------------------------------------
	

	---------------------------------------------
	DRIVER_OUT = function( self,entity,sender )
--printf( "car patol  -------------- driver out" );	
		entity:SelectPipe(0,"c_brake" );
		entity:DropPeople();		
	end,	


	--------------------------------------------
	next_point = function( self,entity, sender )
System:LogToConsole( "carGoto NEXTPOINT" );
		entity:SelectPipe(0,"c_standingthere");
	end,

}
