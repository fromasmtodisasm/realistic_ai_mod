-- Helocipter Behaviour SCRIPT
--------------------------
AIBehaviour.Heli_patrol = {
	Name = "Heli_patrol",

	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSpawn = function(self,entity )
		System:LogToConsole("Heli_patrol RECEIVED ON SPAWN");
	end,
	---------------------------------------------
	---------------------------------------------
	NEXTPOINT = function( self,entity, sender )
	
System:LogToConsole( " Helicopter TIME2GO >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"..entity.pathStep );	
	
		entity.pathStep = entity.pathStep + 1;
		if( entity.pathStep >= entity.Properties.pathsteps ) then
			entity.pathStep = entity.Properties.pathstart;
		end	
		
		printf( "let's go!! #%d", entity.pathStep );
		entity:SelectPipe(0,"h_goto_patrol", entity.Properties.pathname..entity.pathStep);
	end,
	
	--------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )

		entity.EventToCall = "OnPlayerSeen";
			
	end,
	
	--------------------------------------------
	GO_ATTACK = function( self,entity, sender )
	
		entity:SelectPipe(0,"h_gotoattack", entity.Properties.pointAttack);
	end,

	
	--------------------------------------------
	BRING_REINFORCMENT = function( self,entity, sender )
	
		if( entity.dropState~=0  )	then
			do return end
		end
			
		entity:SelectPipe(0,"h_drop", entity.Properties.pointReinforce);
--		entity.EventToCall = ""
	end,

	---------------------------------------------
	GUNNER_OUT = function( self,entity, sender )
	
		if(entity:HasReinforcement() == 1)then
			AI:Signal(0, 1, "BRING_REINFORCMENT",entity.id);	
		else	
			AI:Signal(0, 1, "GO_2_BASE",entity.id);	
		end	

	end,

	--------------------------------------------
	DRIVER_IN = function( self,entity, sender )
	
printf( "Hely PATH -->> DRIVER_IN " );
		
		entity:Fly();		
		entity:SelectPipe(0,"h_goto_patrol", entity.Properties.pathname..0);			
		
	end,	


	---------------------------------------------
}