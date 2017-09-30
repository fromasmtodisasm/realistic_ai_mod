-- #Script.ReloadScript("scripts/default/hud/heatvision.lua")

--------------------------------------------------------------------
-- FarCry Script File
-- Description: Defines CryVision
-- Tiago Sousa
--------------------------------------------------------------------

HeatVision = {	
	EnergyDecreaseRate = 3,		
	ActivateSnd=Sound:LoadSound("sounds/items/nvisionactivate.wav"),
	PrevAmbientColor=nil,	
	IsActive=0,
}

-------------------------------------------------------
function HeatVision:OnInit()	
	HeatVision.IsActive=0;
	self.PrevAmbientColor=new(System:GetWorldColor());
end

-------------------------------------------------------
function HeatVision:OnActivate()			
	-- get all entities near by and set cryvision effect on them
	if(_localplayer) then
		local tblPlayers = { };		
		
		if(_localplayer.type=="Player" and _localplayer:GetPos()) then
			local LocalPlayerPos=_localplayer:GetPos();						
			Game:GetPlayerEntitiesInRadius(LocalPlayerPos, 999999, tblPlayers, 1);			
		else
			-- invalid player position? hack it..
			local LocalPlayerPos={ x=0, y=0, z=0};
			Game:GetPlayerEntitiesInRadius(LocalPlayerPos, 999999, tblPlayers, 1);			
		end
				
		if(tblPlayers and type(tblPlayers)=="table") then
			for i, player in tblPlayers do		
				if(tblPlayers[i].pEntity and tblPlayers[i].pEntity.iPlayerEffect) then					
					tblPlayers[i].pEntity.bPlayerHeatMask=1;
					BasicPlayer.ProcessPlayerEffects(tblPlayers[i].pEntity);	
				end				
			end											
		end
	end
		
	System:SetScreenFx("NightVision", 1);					  	
	
	-- Hack: Only activate sound, if its first time active. If its already active its due to reloading.
	if(HeatVision.IsActive==0) then
		Sound:PlaySound( self.ActivateSnd );			  		  					
	end
	
	self.PrevAmbientColor=new(System:GetWorldColor());
	local CurrAmbientColor=new(self.PrevAmbientColor);
	CurrAmbientColor[1]=CurrAmbientColor[1]+1.0; 
	CurrAmbientColor[2]=CurrAmbientColor[2]+1.0; 
	CurrAmbientColor[3]=CurrAmbientColor[3]+1.0; 
	System:SetWorldColor(CurrAmbientColor);			
	HeatVision.IsActive=1;
end

-------------------------------------------------------
function HeatVision:OnDeactivate(nofade)
	HeatVision.IsActive=0;
	-- get all entities near by and reset current effect on them (cryvision)
	if(_localplayer) then
		local tblPlayers = { };		
		
		if(_localplayer.type=="Player" and _localplayer:GetPos()) then
			local LocalPlayerPos=_localplayer:GetPos();						
			Game:GetPlayerEntitiesInRadius(LocalPlayerPos, 999999, tblPlayers, 1);			
		else
			-- invalid player position? hack it..
			local LocalPlayerPos={ x=0, y=0, z=0};
			Game:GetPlayerEntitiesInRadius(LocalPlayerPos, 999999, tblPlayers, 1);			
		end
		
		if(tblPlayers and type(tblPlayers)=="table") then
			for i, player in tblPlayers do		
				if(tblPlayers[i].pEntity and tblPlayers[i].pEntity.iPlayerEffect) then									
					tblPlayers[i].pEntity.bPlayerHeatMask=2;
					BasicPlayer.ProcessPlayerEffects(tblPlayers[i].pEntity);	
				end				
			end											
		end
	end
	
	System:SetScreenFx("NightVision", 0);							
	Sound:StopSound( self.ActivateSnd );												
	System:SetWorldColor(self.PrevAmbientColor);								
end

-------------------------------------------------------
function HeatVision:OnUpdate()
	--subtract energy
	local MyPlayer=_localplayer;
	-- only use energy if we are using 'pure' heatvision
	if ( MyPlayer and MyPlayer.type=="Player" and not ClientStuff.vlayers:IsActive("Binoculars") and self.EnergyDecreaseRate) then
		MyPlayer.ChangeEnergy( MyPlayer, _frametime * -self.EnergyDecreaseRate );
	end
	
end
-------------------------------------------------------
function HeatVision:OnShutdown()	
	HeatVision.IsActive=0;
end

-------------------------------------------------------
function HeatVision:OnRestore(pRestoreTbl)
	HeatVision.IsActive=pRestoreTbl.IsActive;
end
