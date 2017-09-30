-- Helocipter Behaviour SCRIPT
--------------------------
AIBehaviour.Heli_goto = {
	Name = "Heli_goto",
	State = 0,
	dropCounter = 0,

	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSpawn = function(self,entity )
		System:LogToConsole("RECEIVED ON SPAWN");
		
--		entity:SelectPipe(0,"h_drive", entity.Properties.pathname..self.step);
		
	end,
	---------------------------------------------
	---------------------------------------------
	---------------------------------------------
	FLY = function( self,entity, sender )

		entity:SetAICustomFloat( entity.Properties.fFlightAltitude );
		
	end,	

	---------------------------------------------
	NEXTPOINT = function( self,entity, sender )

		--System:Log("\002 RECEIVED ------ NEXTPOINT");
	
		entity:Land();
		entity:SelectPipe(0,"standingthere");	
--		entity.EventToCall = ""
		
	end,
	

	---------------------------------------------
	REINFORCMENT_OUT = function( self,entity, sender )
	
		entity:SelectPipe(0,"h_goto", entity.Properties.pointBackOff);	
		
	end,

		
	---------------------------------------------
--	NEXTPOINT = function( self,entity, sender )
	
--System:LogToConsole( " Helicopter TIME2GO >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"..self.step );	
	
--		self.step = self.step + 1;
--		if( self.step >= entity.Properties.pathsteps ) then
--			self.step = entity.Properties.pathstart;			
--		end	
		
--		printf( "let's go!! #%d", self.step );
--		entity:SelectPipe(0,"h_drive", entity.Properties.pathname..self.step);

--	end,
	
}