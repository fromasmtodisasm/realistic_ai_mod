-- Helocipter Behaviour SCRIPT
--------------------------
AIBehaviour.Heli_path = {
	Name = "Heli_path",

	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSpawn = function(self,entity )
		System:LogToConsole("Heli_path RECEIVED ON SPAWN");
	end,
	---------------------------------------------
	---------------------------------------------
	NEXTPOINT = function( self,entity, sender )
	
System:LogToConsole( " Helicopter TIME2GO >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"..entity.pathStep );	
	
		entity.pathStep = entity.pathStep + 1;

		if( entity.pathStep >= entity.Properties.pathsteps ) then
			if( entity.Properties.bPathloop == 1 ) then
				entity.pathStep = entity.Properties.pathstart;
			else	
				AI:Signal( 0, 1, "GO_2_BASE",entity.id);
			end
		end

		printf( "let's go!! #%d", entity.pathStep );

		if(entity.Properties.bIgnoreCollisions and entity.Properties.bIgnoreCollisions == 1) then
			entity:SelectPipe(0,"h_goto_special", entity.Properties.pathname..entity.pathStep);
		else
			entity:SelectPipe(0,"h_goto", entity.Properties.pathname..entity.pathStep);
		end
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

	--------------------------------------------
	DRIVER_IN = function( self,entity, sender )
	
printf( "Hely PATH -->> DRIVER_IN " );
		
		entity:Fly();		
--		entity:SelectPipe(0,"h_goto", entity.Properties.pathname..0);			
		
		if(entity.Properties.bIgnoreCollisions and entity.Properties.bIgnoreCollisions == 1) then
			entity:SelectPipe(0,"h_goto_special", entity.Properties.pathname..entity.pathStep);
		else
			entity:SelectPipe(0,"h_goto", entity.Properties.pathname..entity.pathStep);
		end	
		
		
	end,	

	---------------------------------------------
	GO_2_BASE = function( self,entity, sender )
		entity:SetAICustomFloat( entity.Properties.fFlightAltitude );	
	
		entity.EventToCall = "";
System:LogToConsole( " Helicopter path GO_2_BASE -------------------" );			
		entity:SelectPipe(0,"h_goto", entity.Properties.pointBackOff);
		entity:InsertSubpipe(0,"h_attack_stop" );
	end,

	---------------------------------------------
}