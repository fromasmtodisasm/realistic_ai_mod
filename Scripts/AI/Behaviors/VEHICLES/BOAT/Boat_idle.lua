
AIBehaviour.Boat_idle = {
	Name = "Boat_idle",
	

	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSpawn = function(self , entity )
		entity:SelectPipe(0,"b_standingthere");		
	end,
	---------------------------------------------
	OnActivate = function(self, entity )

	end,
	---------------------------------------------
	OnNoTarget = function(self, entity )
--		entity:SelectPipe(0,"return_to_start");
	end,
	---------------------------------------------
	OnPlayerSeen = function(self, entity )
	--	if (self.allowed == 1) then
--			entity:SelectPipe(0,"getinvehicle");
	--	end
	end,
	---------------------------------------------
	OnPlayerMemory = function(self, entity )
	end,
	---------------------------------------------
	OnEnemySeen = function(self, entity )
	end,
	---------------------------------------------
	OnEnemyMemory = function(self, entity )
--		entity:SelectPipe(0,"return_to_start");
--		entity:SelectPipe(0,"standingthere");
	end,
	---------------------------------------------
	OnDeadFriendSeen = function(self,entity )
	end,
	---------------------------------------------
	OnGranateSeen = function(self, entity )
	end,
	---------------------------------------------
	OnDied = function( self,entity )
	end,
	---------------------------------------------
	OnGroupMemberDied = function( self,entity )
	end,
	---------------------------------------------

	---------------------------------------------
	OnGroupMemberDiedNearest  = function ( self, entity, sender)
	
		AI:Signal(SIGNALFILTER_NEARESTGROUP, 1, "OnGroupMemberDiedNearest",entity.id);
	
	end,
	
	

	-- CUSTOM
	---------------------------------------------

	---------------------------------------------
	GUNNER_OUT = function( self,entity, sender )
		AI:Signal( 0, 1, "BRING_REINFORCMENT",entity.id);
	end,	
	
	
	--------------------------------------------
	BRING_REINFORCMENT = function( self,entity, sender )
	
printf( "Boat idle BRING_REINFORCMENT " );

--		entity:AIDriver( 1 );
		entity:LoadPeople();
		
--		entity:SelectPipe(0,"c_goto", entity.Properties.pointReinforce);
--		entity.EventToCall = ""
		
	end,	

	--------------------------------------------
	GO_PATH = function( self,entity, sender )

System:LogToConsole( " BOAT idle  on  GO_PATH " );

		if(entity.LoadPeople) then
			entity:LoadPeople();
		else
			entity.EventToCall = "next_point";	
		end	
		
--entity:SelectPipe(0,"c_standingthere");
		
	end,	

	--------------------------------------------
	GO_PATROL = function( self,entity, sender )

System:LogToConsole( " BOAT idle  on  GO_PATROL " );

		if(entity.LoadPeople) then
			entity:LoadPeople();
		else
			entity.EventToCall = "next_point";	
		end	
		
--entity:SelectPipe(0,"c_standingthere");
		
	end,	


	--------------------------------------------
	GO_ATTACK = function( self,entity, sender )

System:LogToConsole( " BOAT idle  on  GO_ATTACK " );

		if(entity.LoadPeople) then
			entity:LoadPeople();
		else	
			entity.EventToCall = "DRIVER_IN";	
		end	
	
	end,	

	--------------------------------------------
	GO_TRANSPORT = function( self,entity, sender )

System:LogToConsole( " BOAT idle  on  GO_TRANSPORT " );

		if(entity.LoadPeople) then
			entity:LoadPeople();
		end	
	end,	

}
