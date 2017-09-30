
AIBehaviour.Car_transport = {
	Name = "Car_transport",
	allowed = 0,
	
	

	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSpawn = function(self , entity )

		self.step = entity.Properties.pathstart;

--		entity:SelectPipe(0,"v_drive", entity.Properties.pathname..self.step);
		
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
	OnGrenadeSeen = function(self, entity )

printf( "Vehicle -------------- OnGranateSeen" );	
	
		entity:InsertSubpipe(0,"c_grenade_run_away" );
		
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
	OnDeadEnemySeen = function(self,entity )
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity )
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function( self,entity )
	end,
	---------------------------------------------
	OnGunfireHeard = function(self,entity )
	end,
	---------------------------------------------
	OnFootstepsHeard = function(self, entity )
	end,
	---------------------------------------------
	OnGranateSeen = function(self, entity )
	end,
	---------------------------------------------
	OnLongTimeNoTarget = function(self, entity )
	end,
	---------------------------------------------
	OnDied = function( self,entity )
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
	---------------------------------------------
	OnNoNearerHidingPlace = function( self,entity , sender)

	end,	
	---------------------------------------------
	OnNoHidingPlace = function( self,entity, sender )
	end,	
	

	-- CUSTOM
	--------------------------------------------
	DRIVER_IN = function( self,entity, sender )
	
printf( "car BRING_REINFORCMENT -->> DRIVER_IN " );

		entity:SelectPipe(0,"c_goto_ignore", entity.Properties.pointReinforce);
		local pipeName = entity:GetName();
		AI:CreateGoalPipe(pipeName);
		AI:PushGoal(pipeName,"ignoreall",0,1);
		AI:PushGoal(pipeName,"strafe",0,0);						--stop breaking
		AI:PushGoal(pipeName,"acqtarget",0,"");
		if(entity.Properties.fApproachDist) then
			AI:PushGoal(pipeName,"approach",1,entity.Properties.fApproachDist);
		else	
			AI:PushGoal(pipeName,"approach",1,20);
		end	
		AI:PushGoal(pipeName,"signal",0,1,"next_point",0);
		entity:SelectPipe(0,pipeName, entity.Properties.pointReinforce);
		
--		entity:SelectPipe(0,"c_goto_ignore", entity.Properties.pointReinforce);
--		entity:SelectPipe(0,"c_goto", entity.Properties.pointReinforce);		
--		entity.EventToCall = ""
		
	end,	
	
	---------------------------------------------
	next_point = function( self,entity, sender )

printf( "car BRING_REINFORCMENT -->> arrived " );

		entity:SelectPipe(0,"c_brake");
--		entity:SelectPipe(0,"c_standingthere");		
--		entity:DropPeople();
		
	end,
	
	---------------------------------------------
	DRIVER_OUT = function( self,entity,sender )
--printf( "car patol  -------------- driver out" );	
		entity:SelectPipe(0,"c_standingthere" );
		entity:DropPeople();
	end,	


	---------------------------------------------
	stopped = function( self,entity, sender )
		
		printf( "carTransport STOPPED" );		
		entity:SelectPipe(0,"c_standingthere");		
		
		entity:DropPeople();

--		entity:PassengersOut();
--		entity:SelectPipe(0,"c_goto", entity.Properties.pointBackOff);		
			
	end,
	
	---------------------------------------------
	reinforcment_out = function( self,entity, sender )

System:LogToConsole( " Car REINFORCMENT_OUT ----------------- go?  "..entity.Properties.pointBackOff);

--entity:SelectPipe(0,"c_standingthere");
		entity:SelectPipe(0,"c_goto", entity.Properties.pointBackOff);		

	end,	
	

}
