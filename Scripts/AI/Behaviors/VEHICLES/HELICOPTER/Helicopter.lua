-- Helocipter Behaviour SCRIPT
--------------------------
AIBehaviour.Helicopter = {
	Name = "Helicopter",
	State = 0,
	dropCounter = 0,

	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSpawn = function(self,entity )
		System:LogToConsole("RECEIVED ON SPAWN");

		self.dropCounter = 0;
		self.step = entity.Properties.pathstart;
		

		AI:CreateGoalPipe("h_drop");
		AI:PushGoal("h_drop","acqtarget",0,"");
		AI:PushGoal("h_drop","approach",1,25);
		AI:PushGoal("h_drop","signal",0,1,"LAND",0);
--		AI:PushGoal("h_drive","bodypos",0,1);
		AI:PushGoal("h_drive","lookat",0,0, 10);
		AI:PushGoal("h_drop","approach",1,3);		
		AI:PushGoal("h_drop","signal",0,1,"at_reinforsment_point",0);
		
		
		AI:CreateGoalPipe("h_drive");
--		AI:PushGoal("h_drive","locate",0);
--		AI:PushGoal("h_drive","locate",0,entity.Properties.pathname..self.step);		
		AI:PushGoal("h_drive","signal",0,1,"FLY",0);
		AI:PushGoal("h_drive","acqtarget",0,"");
--		AI:PushGoal("h_drive","timeout",1,20);		
--		AI:PushGoal("v_drive","jump",0,0);	
--		AI:PushGoal("h_drive","bodypos",1,1);	
		AI:PushGoal("h_drive","approach",1,25);
		AI:PushGoal("h_drive","signal",0,1,"LAND",0);
--		AI:PushGoal("h_drive","bodypos",0,1);
--		AI:PushGoal("h_drive","lookat",0,0, 10);
		AI:PushGoal("h_drive","approach",1,3);		
--		AI:PushGoal("h_drive","timeout",1,10);
--		AI:PushGoal("h_drive","signal",0,1,"TIME2GO",0);
		AI:PushGoal("h_drive","signal",0,1,"HELICOPTER_ARRIVED",0);

--		entity:SelectPipe(0,"h_drive", entity.Properties.pathname..self.step);
--		entity:SelectPipe(0,"h_drive", entity.Properties.pathname..self.step);		
--		entity:SelectPipe(0,"h_drive" );		


		entity:SelectPipe(0,"h_drop", entity.Properties.pathdroppoint);		
		
	end,
	---------------------------------------------
	OnActivate = function(self,entity )

	end,
	---------------------------------------------
	OnActivate2 = function(self,entity )

		entity:SelectPipe(0,"copterRound2");		
	end,
	---------------------------------------------
	OnActivate3 = function(self,entity )

		entity:SelectPipe(0,"copterRound3");		
	end,
	---------------------------------------------
	OnNoTarget = function( self,entity )

	end,
	---------------------------------------------
	OnPlayerSeen = function( self,entity )

	end,
	---------------------------------------------
	OnPlayerMemory = function(self,entity )

	end,
	---------------------------------------------
	OnEnemySeen = function(self,entity )

	end,
	---------------------------------------------
	OnEnemyMemory = function(self,entity )

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
	OnThreateningSoundHeard = function(self, entity )

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
	OnLongTimeNoTarget = function( self,entity )
	end,
	---------------------------------------------
	OnGroupMemberDied = function(self, entity )
	end,
	---------------------------------------------

	---------------------------------------------
	OnReceivingDamage = function ( self, entity, sender)
		-- called when the enemy is damaged
self:GoHome2();			
System:LogToConsole(" COPTER on damage ");		
	end,
	---------------------------------------------
	OnBulletRain = function ( self, entity, sender)

self:GoHome();	
System:LogToConsole(" COPTER on bullet rain ");
		-- called when the enemy senses bullet impacts around him
	end,


	-- CUSTOM
	---------------------------------------------
	BRING_REINFORCMENT = function( self, entity, sender )

		--System:LogToConsole("\001  BRING_REINFORCMENT doing");		
		entity:SelectPipe(0,"h_drop", entity.Properties.pathdroppoint);
	
	end,

	---------------------------------------------
	at_reinforsment_point = function( self,entity, sender )

		if( self.dropCounter ~= 0 ) then
System:LogToConsole( " Helicopter start goung --------------------------------------------------################## " );	
			AI:Signal(0, 1, "TIME2GO",entity.id);
			return
		end	
		entity:SelectPipe(0,"standingthere");
		entity:DropPeople();
	end,
	
	
	
	---------------------------------------------
	HELICOPTER_ARRIVED = function( self,entity, sender )

		entity:SelectPipe(0,"standingthere");

		do return end;

		if( self.dropCounter ~= 0 ) then
System:LogToConsole( " Helicopter start goung --------------------------------------------------################## " );	
			AI:Signal(0, 1, "TIME2GO",entity.id);
			return
		end	

	
		System:LogToConsole("I HAVE FINISHED!!! ");
		entity:SelectPipe(0,"standingthere");
				
		entity:DropPeople();
		
		
	end,

	---------------------------------------------
	LAND = function( self,entity, sender )

		entity:SetAICustomFloat( 17 );
--		entity:SetAICustomFloat( 5 );	
		
	end,	

	---------------------------------------------
	FLY = function( self,entity, sender )

		entity:SetAICustomFloat( entity.Properties.fFlightAltitude );
		
	end,	

		
	---------------------------------------------
	TIME2GO = function( self,entity, sender )
	
System:LogToConsole( " Helicopter TIME2GO >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"..self.step );	
	
		self.step = self.step + 1;
		if( self.step >= entity.Properties.pathsteps ) then
			self.step = entity.Properties.pathstart;			
		end	
		
		printf( "let's go!! #%d", self.step );
		entity:SelectPipe(0,"h_drive", entity.Properties.pathname..self.step);

	end,

	---------------------------------------------
	ON_GROUND = function( self,entity, sender )

		self.dropCounter = self.dropCounter + 1;

	System:LogToConsole( " Helicopter ON GROUND"..self.dropCounter );

		if( self.dropCounter == 6 ) then
System:LogToConsole( " Helicopter start goung --------------------------------------------------################## " );	
			AI:Signal(0, 1, "TIME2GO",entity.id);
		end	
	end,
	
	
}