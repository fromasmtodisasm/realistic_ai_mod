Script:ReloadScript( "SCRIPTS/Default/Entities/AI/MutantScout_x.lua");
MutantScout=CreateAI(MutantScout_x)


-- activate mutant stealth
function MutantScout:GoRefractive()	
	self.refractionSwitchDirection = 1;	
	self.refractionValue = 0.15;	
	self.bUpdatePlayerEffectParams=1;
		
	AI:Signal(SIGNALID_READIBILITY, 1, "VISIBLE_TO_REFRACTIVE",self.id);				
end

-- deactivate mutant stealth
function MutantScout:GoVisible()	
	self.refractionSwitchDirection = 2;
	-- died, go visible
	if (self.cnt.health < 1) then	
		self:ResetStealth();				
	end				

	AI:Signal(SIGNALID_READIBILITY, 1, "REFRACTIVE_TO_VISIBLE",self.id);				
end

-- update stealth
function MutantScout:Client_OnTimerCustom()				
	-- no stealth ?
	if(self.refractionSwitchDirection==0) then
		return nil;	
	end 
	
	if(self.cnt.health < 1) then						
		self:ResetStealth();					
	 	return nil;
	end	
																	
	-- go invisible
	if(self.refractionSwitchDirection==1) then				
		-- set stealth
		self.isRefractive=1;		
		self.iPlayerEffect=5;	
		self:RenderShadow(0, 0 );	
		
		-- interpolate refraction amount
		local	refrLimit =.01;
		self.refractionValue= self.refractionValue+(refrLimit-self.refractionValue)*_frametime*50;
		self.bUpdatePlayerEffectParams=1;
										
		-- clamp to refraction minimum limit
		if( self.refractionValue<refrLimit+0.01 ) then
			self.refractionValue = refrLimit;							
		end	
	elseif(self.refractionSwitchDirection==2) then -- go visible
		-- set stealth
		self.isRefractive=1;		
		self.iPlayerEffect=5;	
		self:RenderShadow(0, 0 );	
	
		-- interpolate refraction amount
		local	refrLimit =0.15;
		self.refractionValue= self.refractionValue+(refrLimit-self.refractionValue)*_frametime*50;
		self.bUpdatePlayerEffectParams=1;
									
		-- reset state
		if(self.refractionValue>refrLimit-0.01 ) then
			self.refractionValue = refrLimit;
			self:ResetStealth();			
		end
	end		

end

-- reset states
function MutantScout:OnResetCustom()								
	self:ResetStealth();
	self:GoVisible();	
end 

function MutantScout:ResetStealth()
	self.refractionSwitchDirection = 0;
	self.refractionValue = 0.15;			
	self.isRefractive=0;			
	self.iPlayerEffect=1;		
	
	-- set shadows again
	self:RenderShadow(0, 1);	
end