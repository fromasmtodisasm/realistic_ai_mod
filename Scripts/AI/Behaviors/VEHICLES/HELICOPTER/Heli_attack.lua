-- Helocipter Behaviour SCRIPT
--------------------------
AIBehaviour.Heli_attack = {
	Name = "Heli_attack",

	strafeDir = -1,
--	count = 0,

	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSpawn = function(self,entity )
		System:LogToConsole("Heli_attack RECEIVED ON SPAWN");
	end,
	---------------------------------------------
	---------------------------------------------
	OnNoTarget = function( self, entity )
--		AI:Signal(0, 1, "GO_2_BASE",entity.id);

		entity.seesPlayer = 0;
		self.advance(self,entity);
		do return end


	end,

	
	---------------------------------------------
	OnEnemyMemory = function( self, entity )
		-- called when the enemy can no longer see its foe, but remembers where it saw it last
--		entity:SelectPipe(0,"h_standingthere");
System:LogToConsole( " Helicopter attack OnEnemyMemory >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");		
--self.count = self.count + 1;

		entity.seesPlayer = 0;
			
		self.advance(self,entity);
		do return end
			
			
--		entity:SelectPipe(0,"h_looking" );	
--		entity:InsertSubpipe(0,"h_attack_stop" );		
		
	end,
	---------------------------------------------

	--------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )
--System:LogToConsole("helicopter idle OnPlayerSeen --------------- "..self.count);		
--self.count = self.count + 1;
	
		entity.seesPlayer = 1;
		entity:SelectPipe(0,"h_attack" );	

--		AI:Signal(0, 1, "NEXTPOINT",entity.id);
			
	end,

	
		---------------------------------------------
	OnGrenadeSeen = function( self, entity, fDistance )
		-- 
		
System:LogToConsole("Heli_attack OnGrenadeSeen");

		entity:InsertSubpipe(0,"h_grenade_run_away" );
--		entity:SelectPipe(0,"h_grenade_run_away" );

--		AI:Signal(0, 1, "STARTSTRAFE",entity.id);
		
	end,

	CHANGESTRAFE = function( self,entity, sender )
		
--		self.NEXTPOINT(self,entity);
--		do return end
		
		--AI:Signal(0, 1, "NEXTPOINT",entity.id);
		if( entity.curStrafeDir<0 ) then
			entity.strafeDir = 3;
			entity:InsertSubpipe(0,"h_strafe_right" );
--System:LogToConsole( " Helicopter attack CHANGESTRAFE  <<< " );
		else
			entity.strafeDir = -3;
			entity:InsertSubpipe(0,"h_strafe_left" );
--System:LogToConsole( " Helicopter attack CHANGESTRAFE  >>> " );
--			entity:InsertSubpipe(0,"h_strafe_left" );			
		end			
	
	end,

	
	STARTSTRAFE = function( self,entity, sender )

		entity:SetAICustomFloat( entity.Properties.fAttackAltitude );
--		entity:SetAICustomFloat( entity.Properties.fAttackAltitude + random(-6, 6) );			

--do return end
	
		if( entity.strafeDir<0 ) then
			entity.curStrafeDir = -1;
			entity.strafeDir = entity.strafeDir + 2;
			entity:InsertSubpipe(0,"h_strafe_left" );
--System:LogToConsole( " Helicopter attack STARTSTRAFE  <<< " );
	else
			entity.curStrafeDir = 1;
			entity.strafeDir = entity.strafeDir - 2;
			entity:InsertSubpipe(0,"h_strafe_right" );			
--System:LogToConsole( " Helicopter attack STARTSTRAFE  >>> " );
--			entity:InsertSubpipe(0,"h_strafe_left" );			
		end			

--		if( random(0, 100)<50 ) then
--			entity:InsertSubpipe(0,"h_strafe_left" );
--		else
--			entity:InsertSubpipe(0,"h_strafe_right" );
--		end
	end,
	
	---------------------------------------------
	advance = function( self,entity, sender )
	
		--System:Log( "\001 Helicopter attack NEXTPOINT >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" );	
	
		entity:SelectPipe(0,"h_attack_advance" );

	end,

	---------------------------------------------
	NEXTPOINT_ATTACK = function( self,entity, sender )
	
--System:LogToConsole( " Helicopter attack NEXTPOINT >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" );	

		
	
		entity:SetAICustomFloat( entity.Properties.fAttackAltitude );	
	
		if(entity.seesPlayer == 1) then
			entity:SelectPipe(0,"h_attack" );	
		else	
--			entity:SelectPipe(0,"h_attack" );
			entity:SelectPipe(0,"h_attack_short" );
		end		
--		AI:Signal(0, 1, "REINFORCMENT_OUT",entity.id);	

	end,


	---------------------------------------------
	REINFORCMENT_OUT = function( self,entity, sender )
	
System:LogToConsole( " Helicopter attack STARTATTACK >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" );	

		if( entity.Properties.attackrange>0 and entity.gunnerT~=nil and entity.gunnerT.entity~=nil ) then
			entity:Fly();		
			entity:SelectPipe(0,"h_gotoattack", entity.Properties.pointAttack);
--			entity:SetAICustomFloat( entity.Properties.fAttackAltitude );
--			entity:SelectPipe(0,"h_attack_start" );
		else				
			AI:Signal(0, 1, "GO_2_BASE",entity.id);	
		end	

	end,

	---------------------------------------------
	GO_2_BASE = function( self,entity, sender )
		entity:SetAICustomFloat( entity.Properties.fFlightAltitude );	
	
		entity.EventToCall = "";
System:LogToConsole( " Helicopter attack GO_2_BASE -------------------" );			
		entity:SelectPipe(0,"h_goto", entity.Properties.pointBackOff);
		entity:InsertSubpipe(0,"h_attack_stop" );
	end,

	---------------------------------------------
	BRING_REINFORCMENT = function( self,entity, sender )
		entity:SetAICustomFloat( entity.Properties.fFlightAltitude );	
	
		entity:SelectPipe(0,"h_drop", entity.Properties.pointReinforce);
		entity:InsertSubpipe(0,"h_attack_stop" );
		entity.EventToCall = "";
System:LogToConsole( " Helicopter attack GO_2_BASE -------------------" );			
	end,


	---------------------------------------------
	low_health = function( self,entity, sender )
		AI:Signal(0, 1, "GO_PATH",entity.id);
		entity.EventToCall = "NEXTPOINT";
	end,

	---------------------------------------------
	GUNNER_OUT = function( self,entity, sender )
	
		if(entity:HasReinforcement() == 1)then
			AI:Signal(0, 1, "BRING_REINFORCMENT",entity.id);	
		else	
			AI:Signal(0, 1, "GO_2_BASE",entity.id);	
		end	

	end,

	---------------------------------------------
	GunnerLostTarget= function( self,entity, sender )
	
--System:Log("\001 heli >>> GunnerLostTarget "..entity.landed);
		if(not entity.attacking) then return end
	
		entity:SelectPipe(0,"h_attack_advance" );

	end,

	--------------------------------------------
	DRIVER_IN = function( self,entity, sender )
	
--printf( "Hely ATTACK -->> DRIVER_IN " );
--System:Log("\001 heli >>> driverIn ");
		
		entity:Fly();		
		entity:SelectPipe(0,"h_gotoattack", entity.Properties.pointAttack);
		entity.attacking = 1;
		
	end,	


	---------------------------------------------
}