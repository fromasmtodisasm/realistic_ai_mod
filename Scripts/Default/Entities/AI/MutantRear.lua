Script:ReloadScript( "SCRIPTS/Default/Entities/AI/MutantRear_x.lua");
MutantRear=CreateAI(MutantRear_x)
------------------------------------------------------------------------------------

-- activate mutant stealth
function MutantRear:GoRefractive()
	self.refractionSwitchDirection = 1;	
	self.refractionValue = 0.15;	
	self.bUpdatePlayerEffectParams=1;
	--self:RenderShadow( 0 );	

	AI:Signal(SIGNALID_READIBILITY, 1, "VISIBLE_TO_REFRACTIVE",self.id);				
end

-- deactivate mutant stealth
function MutantRear:GoVisible()	
	self.refractionSwitchDirection = 2;
	-- died, go visible
	if (self.cnt.health < 1) then	
		self:ResetStealth();				
	end				

	AI:Signal(SIGNALID_READIBILITY, 1, "REFRACTIVE_TO_VISIBLE",self.id);				
end

-- dehactivate stealth when entity gets damage
function MutantRear:OnDamageCustom()	
	self:GoVisible();
end

-- update stealth
function MutantRear:Client_OnTimerCustom()			
	-- no stealth ?
	if(self.refractionSwitchDirection==0 or self.refractionSwitchDirection == 5) then
		return nil;	
	end 
	
	if(self.cnt.health < 1) then						
		self:ResetStealth();					
	 	return nil;
	end	
	
	--self.iPlayerEffect=1;
																	
	-- go invisible
	if(self.refractionSwitchDirection==1) then				
		-- set stealth
		self.isRefractive=1;		
		self.iPlayerEffect=5;	
		self:RenderShadow(0, 0);	
		
		-- interpolate refraction amount
		local	refrLimit =.01;
		self.refractionValue= self.refractionValue+(refrLimit-self.refractionValue)*_frametime*50;
		self.bUpdatePlayerEffectParams=1;
										
		-- clamp to refraction minimum limit
		if( self.refractionValue<refrLimit+0.01 ) then
			self.refractionValue = refrLimit;		
			
			--self.refractionSwitchDirection=3; -- reached maximum					
		end	
	elseif(self.refractionSwitchDirection==2) then -- go visible			
		-- set stealth
		self.isRefractive=1;		
		self.iPlayerEffect=5;		
		self:RenderShadow(0, 0);	
		
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
function MutantRear:OnResetCustom()								
	if (self.Properties.fileBackpackModel) then
		self:LoadObject( self.Properties.fileBackpackModel,1,0);
		self:AttachObjectToBone( 1, "Bip01 Spine2" );	
	end	
	
	if(self.refractionSwitchDirection ~= 5) then		
		self:GoRefractive();
	end				
end 

function MutantRear:ResetStealth()			
	self.refractionSwitchDirection = 5;
	self.refractionValue = 0.15;			
	self.isRefractive=0;		
	self.iPlayerEffect=1;
			
	self:RenderShadow(0, 1);	
end