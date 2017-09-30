
AIBehaviour.Car_chase = {
	Name = "Car_chase",
	

	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSpawn = function(self , entity )

	end,
	---------------------------------------------
	OnActivate = function(self, entity )

	end,

	---------------------------------------------
	OnNoTarget = function( self, entity )
		-- called when the enemy stops having an attention target
--[kirill] designers don't want the chaser to ever stop
--		entity:DropPeople();
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
	
		entity:TriggerEvent(AIEVENT_PATHFINDON);
--printf( "Vehicle -------------- RejectPlayer" );	

--		entity:TriggerEvent(AIEVENT_REJECT);

	end,

	--------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )

		entity:TriggerEvent(AIEVENT_PATHFINDOFF);
--printf( "Vehicle -------------- RejectPlayer" );	

--		AI:Signal( 0, 1, "EVERYONE_OUT",entity.id);					
	
--		if( entity.Properties.bApproachPlayer == 1 ) then
--			entity:SelectPipe(0,"c_approach_n_drop");
--		else
--			AI:Signal( 0, 1, "EVERYONE_OUT",entity.id);				
--		end	

	end,

	---------------------------------------------
	-- CUSTOM
	---------------------------------------------
	---------------------------------------------
	DRIVER_IN = function( self,entity, sender )

		self:next_point(entity);
		
--entity:SelectPipe(0,"c_standingthere");		
		
	end,	
	
	--------------------------------------------
	EVERYONE_OUT = function( self,entity, sender )

		entity:SelectPipe(0,"c_brake");
--		entity:EveryoneOut();	
		VC.DropPeople( entity );		
--		AI:Signal( 0, 1, "next_point",entity.id);					
--entity:SelectPipe(0,"c_standingthere");		
		
	end,	
	

	--------------------------------------------
	next_point = function( self,entity, sender )	

--entity:TriggerEvent(AIEVENT_PATHFINDON);
	
--		printf( "---->>let's runOver!!  ");		
--		entity:SelectPipe(0,"c_runover");

		local pipeName = entity:GetName().."chase";
		AI:CreateGoalPipe(pipeName);
		AI:PushGoal(pipeName,"strafe",0,0);						--stop breaking
		AI:PushGoal(pipeName,"bodypos",0,1);		--	to update path when moving
		if(entity.Properties.fattackStickDist) then
			AI:PushGoal(pipeName,"approach",1,entity.Properties.fattackStickDist);
		else
			AI:PushGoal(pipeName,"approach",1,1);
		end	
		entity:SelectPipe(0,pipeName);

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
