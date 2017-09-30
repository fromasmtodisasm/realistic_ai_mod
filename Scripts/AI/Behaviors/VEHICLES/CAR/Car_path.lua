
AIBehaviour.Car_path = {
	Name = "Car_path",
	

	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSpawn = function(self , entity )

	end,
	---------------------------------------------
	OnActivate = function(self, entity )

	end,
	---------------------------------------------
	---------------------------------------------
	OnGrenadeSeen = function(self, entity )

printf( "Vehicle -------------- OnGranateSeen" );	
	
		entity:InsertSubpipe(0,"c_grenade_run_away" );
		
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
	OnEnemyMemory = function( self, entity )
--printf( "Vehicle -------------- RejectPlayer" );	

--		entity:TriggerEvent(AIEVENT_REJECT);

	end,

	--------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )

--printf( "Vehicle -------------- RejectPlayer" );	

--		entity:TriggerEvent(AIEVENT_REJECT);

	end,

	---------------------------------------------
	-- CUSTOM
	---------------------------------------------
	---------------------------------------------
	VEHICLE_ARRIVED = function( self,entity, sender )
		printf( "Vehicle is there" );
		entity:SelectPipe(0,"v_brake");
	end,


	--------------------------------------------
	DRIVER_IN = function( self,entity, sender )
	
		if( entity.Properties.pathstartAlter and entity.driverT.entity) then
			if( entity.driverT.entity.Properties.special == 1 and entity.Properties.pathstartAlter>=0 ) then
				entity.Properties.pathname = entity.driverT.entity.Properties.pathname;
				entity.step = entity.Properties.pathstartAlter - 1;
			end	
		end
			
		AI:Signal( 0, 1, "next_point",entity.id);					
	end,	

	--------------------------------------------
	GO_CHASE = function( self,entity, sender )

		entity.EventToCall = "DRIVER_IN";
		
	end,	

	--------------------------------------------
	BRING_REINFORCMENT = function( self,entity, sender )

		entity.EventToCall = "DRIVER_IN";
		
	end,	


	--------------------------------------------
	EVERYONE_OUT = function( self,entity, sender )

		entity:SelectPipe(0,"c_brake");
--		entity:EveryoneOut();	
		VC.DropPeople( entity );
		
--		AI:Signal( 0, 1, "next_point",entity.id);					
		
	end,	
	

	
	--------------------------------------------
	next_point = function( self,entity, sender )	
	
		entity.step = entity.step + 1;
		if( entity.step >= entity.Properties.pathsteps ) then
--			entity.step = entity.Properties.pathstart;			
			if( entity.Properties.bPathloop == 1 ) then
				entity.step = entity.Properties.pathstart;			
			else	
				if(entity.Event_PathEnd) then
					entity:Event_PathEnd();
				end
--				AI:Signal( 0, 1, "EVERYONE_OUT",entity.id);
				AI:Signal( 0, 1, "DRIVER_OUT",entity.id);
			end	
		end	
		
		printf( "---->>let's go!!  #%d [%d] loop=%d", entity.step, entity.Properties.pathsteps, entity.Properties.bPathloop );		
		entity:SelectPipe(0,entity:GetName().."path", entity.Properties.pathname..entity.step);	

	end,

	---------------------------------------------
	DRIVER_OUT = function( self,entity,sender )
--printf( "car patol  -------------- driver out" );	
		entity:SelectPipe(0,"c_brake" );
		entity:DropPeople();
	end,	

	---------------------------------------------
	GUNNER_OUT = function( self,entity,sender )
--printf( "car patol  -------------- driver out" );	
		entity:SelectPipe(0,"c_brake" );
		entity:DropPeople();
	end,	

	
}
