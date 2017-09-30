-- Helocipter Behaviour SCRIPT
--------------------------
AIBehaviour.Heli_transport = {
	Name = "Heli_transport",
	State = 0,
--	dropCounter = 0,
	
	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSpawn = function(self,entity )
		System:LogToConsole("helicopter transport RRECEIVED ON SPAWN");

--		entity:SelectPipe(0,"h_drop", entity.Properties.pathdroppoint);
	end,


	---------------------------------------------
--	OnReceivingDamage = function ( self, entity, sender)
--System:LogToConsole("helicopter transport OnReceivingDamage ---------------");
--		entity:InsertSubpipe(0, "h_move_erratically" );
--	end,

	-- CUSTOM
	---------------------------------------------
--	BRING_REINFORCMENT = function( self, entity, sender )
--System:LogToConsole("\001  BRING_REINFORCMENT doing");		
--		entity:SelectPipe(0,"h_drop", entity.Properties.pathdroppoint);
--	end,

	---------------------------------------------
	OnGroupMemberDied = function( self, entity, sender)

		--System:LogToConsole( "\001 Helicopter OnGroupMemberDied ----------------->>");
	
--		entity:MakeAlerted();
--		entity:InsertSubpipe(0,"DRAW_GUN");
	end,


	---------------------------------------------
	at_reinforsment_point = function( self,entity, sender )

		System:LogToConsole( " at_reinforsment_point  -------------------------------------------------->>>" );	
--		entity:SelectPipe(0,"h_standingthere");
		entity:SelectPipe(0,"h_standingtherestill");		
		entity:DropPeople();

	end,



	---------------------------------------------
	---------------------------------------------
	---------------------------------------------
	APPROACHING_DROPPOINT = function( self,entity, sender )

System:LogToConsole( " APPROACHING_DROPPOINT  -------------------------------------------------->>>" );	

--		entity:SetAICustomFloat( entity.Properties.dropAltitude );
		entity:ApproachingDropPoint( );	

	end,

	---------------------------------------------
	FLY = function( self,entity, sender )

		entity:SetAICustomFloat( entity.Properties.fAttackAltitude );
--		entity:SetAICustomFloat( entity.Properties.fFlightAltitude );

	end,

	---------------------------------------------
	ON_GROUND = function( self,entity, sender )

--		entity.troopers2Drop = entity.troopers2Drop - 1;
--		if( entity.troopers2Drop < 1 ) then
			
		--System:LogToConsole( "\001 Helicopter ON_GROUND ----------------->>   "..entity.troopersNumber);
		entity.troopersNumber = entity.troopersNumber - 1;			
			
		if( entity.troopersNumber < 1 ) then
--				AI:Signal(0, 1, "REINFORCMENT_OUT",entity.id);
--				AI:Signal(0, 1, "READY_TO_GO",entity.id);
				entity:SelectPipe(0,"h_timeout_readytogo");
				entity.dropState = 3;
			--System:LogToConsole( "\001 Helicopter ON_GROUND ----------------->>   GOOOOO ");				
				
		end	
	end,
	
	
	---------------------------------------------
--	REINFORCMENT_OUT = function( self,entity, sender )
--
--System:LogToConsole( " Helicopter REINFORCMENT_OUT ----------------- go?  "..entity.Properties.pointBackOff);
--
--	entity:SelectPipe(0,"h_goto_start", entity.Properties.pointBackOff);
--	
--	end,	

	---------------------------------------------
	READY_TO_GO	 = function( self,entity, sender )

System:LogToConsole( " Helicopter READY_TO_GO	 ----------------- go?  "..entity.Properties.pointBackOff);

	entity:DropDone( );

	entity:InsertSubpipe(0,"h_attack_stop" );
	entity.EventToCall = "REINFORCMENT_OUT";

	end,	

	--------------------------------------------
	DRIVER_IN = function( self,entity, sender )
	
printf( "Hely BRING_REINFORCMENT -->> DRIVER_IN " );
		
		entity:Fly();		
		entity:SelectPipe(0,"h_drop", entity.Properties.pointReinforce);
		
	end,	


	--------------------------------------------
	BRING_REINFORCMENT = function( self,entity, sender )

--		Hud:AddMessage("V22 RECEIVED BRING REINFORCEMENT IN TRANSPORT  ");

	end,

	
}