-- Helocipter Behaviour SCRIPT
--------------------------
AIBehaviour.Heli_idle = {
	Name = "Heli_idle",
	State = 0,
	dropCounter = 0,

	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSpawn = function(self,entity )
		System:LogToConsole("helicopter idle RECEIVED ON SPAWN");

		self.dropCounter = 0;
		self.step = entity.Properties.pathstart;

		entity:SelectPipe(0,"h_standingthere");		
		
	end,


	---------------------------------------------	
	SELECT_RED = function (self, entity, sender)
	end,

	---------------------------------------------	
	SELECT_BLACK = function (self, entity, sender)
	end,

	---------------------------------------------
	OnGroupMemberDied = function ( self, entity, sender)
	end,

	---------------------------------------------
	OnGroupMemberDiedNearest  = function ( self, entity, sender)
	
		AI:Signal(SIGNALFILTER_NEARESTGROUP, 1, "OnGroupMemberDiedNearest",entity.id);
	
	end,


	---------------------------------------------
	OnReceivingDamage = function ( self, entity, sender)
--System:LogToConsole("helicopter idle OnReceivingDamage ---------------");		
--		entity:InsertSubpipe(0, "h_move_erratically" );
	end,

	--------------------------------------------------
	OnBulletRain = function ( self, entity, sender)
		-- called when the enemy detects bullet trails around him
--System:LogToConsole("helicopter idle OnBulletRain  ---------------");
	end,

		---------------------------------------------
	OnGrenadeSeen = function( self, entity, fDistance )
		-- 
		
--System:LogToConsole("Heli_idle OnGrenadeSeen");

		entity:InsertSubpipe(0,"h_grenade_run_away" );
--		entity:SelectPipe(0,"h_grenade_run_away" );
		
	end,

	
	--------------------------------------------------
	--------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )
--System:LogToConsole("helicopter idle OnPlayerSeen ---------------");		
	
		entity.EventToCall = "NEXTPOINT";
--		entity:SelectPipe(0,"h_attack");
	end,

	--------------------------------------------
	BRING_REINFORCMENT = function( self,entity, sender )
	
		if( entity.dropState~=0  )	then
			do return end
		end
			
		entity:LoadPeople();
--		entity:Fly();
--		entity:SelectPipe(0,"h_drop", entity.Properties.pointReinforce);
----		entity.EventToCall = ""
	end,

	--------------------------------------------
	REINFORCMENT_RESTORE = function( self,entity, sender )
		entity.EventToCall = "DRIVER_IN";
	end,


	--------------------------------------------
	GO_ATTACK = function( self,entity, sender )
	
			
		entity:LoadPeople();
--		entity:Fly();		
--		entity:SelectPipe(0,"h_gotoattack", entity.Properties.pointAttack);
	end,

	--------------------------------------------
	ATTACK_RESTORE = function( self,entity, sender )
	
		entity.EventToCall = "GunnerLostTarget";
		entity.attacking = 1;
		
	entity:SelectPipe(0,"h_gotoattack", entity.Properties.pointAttack);		
	
--		entity.EventToCall = "DRIVER_IN";
--		entity:Fly();		
--		entity:SelectPipe(0,"h_gotoattack", entity.Properties.pointAttack);
	end,


	--------------------------------------------
	GO_PATROL = function( self,entity, sender )
		
		entity:LoadPeople();
	end,

	--------------------------------------------
	PATROL_RESTORE = function( self,entity, sender )
		entity.EventToCall = "NEXTPOINT";
		if(entity.pathStep > 0) then
			entity.pathStep = entity.pathStep - 1;
		else
			entity.pathStep = entity.Properties.pathsteps - 1;
		end	
	end,


	--------------------------------------------
	GO_PATH = function( self,entity, sender )
		
		entity:LoadPeople();
--		entity:Fly();		
--		entity:SelectPipe(0,"h_goto", entity.Properties.pathname..0);		
	end,

	--------------------------------------------
	PATH_RESTORE = function( self,entity, sender )
		entity.EventToCall = "NEXTPOINT";
		if(entity.pathStep > 0) then
			entity.pathStep = entity.pathStep - 1;
		else
			entity.pathStep = entity.Properties.pathsteps - 1;
		end	
	end,
	
	---------------------------------------------
	READY_TO_GO	 = function( self,entity, sender )

System:LogToConsole( " Helicopter READY_TO_GO	 ----------------- go?  "..entity.Properties.pointBackOff);

	entity:DropDone( );

	entity:InsertSubpipe(0,"h_attack_stop" );
	entity.EventToCall = "REINFORCMENT_OUT";

	end,
	---------------------------------------------
	
}