
Script:LoadScript("scripts/default/hud/viewlayersmgr.lua")

ClientStuff={
	temp_layers={},
	temp_layers_save={},
}


function ClientStuff:ShowScoreBoard(bShow)
	if (ScoreBoardManager) then
		ScoreBoardManager.SetVisible(bShow);
	end
end

function ClientStuff:ResetScores()
	if (ScoreBoardManager) then
		ScoreBoardManager.ClearScores();
	end
end

function ClientStuff:SetPlayerScore(Stream)
end

ClientStuff.ServerCommandTable={};							-- used from OnServerCmd() to process commands on the client from the server

-- e.g. ClientStuff.ServerCommandTable["CPC"]=function(...


--------------------------------------------
function ClientStuff:OnInit()	
	--LAYERS--------------------------------------------------------	
	self.vlayers=ViewLayersMgr:new(),
	Script:LoadScript("scripts/default/hud/zoomview.lua");
	Script:LoadScript("scripts/default/hud/nightvision.lua");
	Script:LoadScript("scripts/default/hud/binoculars.lua");
	Script:LoadScript("scripts/default/hud/heatvision.lua");
	Script:LoadScript("scripts/default/hud/weaponscope.lua");
	Script:LoadScript("scripts/default/hud/motracklayer.lua");
	Script:LoadScript("scripts/default/hud/smokeblur.lua");
	Binoculars:OnInit();
	NightVision:OnInit();
	MoTrackLayer:OnInit();
	SmokeBlur:OnInit();
	HeatVision:OnInit();	
	self.vlayers:AddLayer("HeatVision",HeatVision);
	self.vlayers:AddLayer("NightVision",NightVision);
	self.vlayers:AddLayer("MoTrack",MoTrackLayer);
	self.vlayers:AddLayer("Binoculars",Binoculars);
	self.vlayers:AddLayer("WeaponScope",WeaponScope);
	self.vlayers:AddLayer("SmokeBlur",SmokeBlur);
end

--------------------------------------------
function ClientStuff:OnSave(stm)		
	if(self.temp_layers==nil) then
		stm:WriteBool(0);		
	else	
		stm:WriteBool(1);		
			
		-- only save required/important viewlayers			
		self.temp_layers.HeatVision=self.vlayers:IsActive("HeatVision");
		self.temp_layers.Binoculars=self.vlayers:IsActive("Binoculars");
		--self.temp_layers.WeaponScope=self.vlayers:IsActive("WeaponScope");
		self.temp_layers.SmokeBlur=self.vlayers:IsActive("SmokeBlur");		
		WriteToStream(stm, self.temp_layers);				

		if(not HeatVision) then
			stm:WriteBool(0);					
		else
			stm:WriteBool(1);		
			local pHeatVisionTbl=HeatVision;
			WriteToStream(stm, pHeatVisionTbl);									
		end
				
		if(not Binoculars) then
			stm:WriteBool(0);					
		else
			stm:WriteBool(1);		
			local pBinocularsTbl=Binoculars;
			WriteToStream(stm, pBinocularsTbl);									
		end
		
		if(not SmokeBlur) then
			stm:WriteBool(0);					
		else
			stm:WriteBool(1);		
			local pSmokeBlurTbl=SmokeBlur;
			WriteToStream(stm, pSmokeBlurTbl);									
		end
	end			
end

--------------------------------------------
function ClientStuff:OnLoad(stm)			
	local bObj=stm:ReadBool();	
	if(bObj) then
		self.vlayers:DeactivateAll();		
		self.temp_layers_save=ReadFromStream(stm);
	
		bObj=stm:ReadBool();	
		if(HeatVision and bObj) then
			local pHeatVisionTbl={};
			pHeatVisionTbl=ReadFromStream(stm);
			HeatVision:OnRestore(pHeatVisionTbl);
		end	
		
		bObj=stm:ReadBool();	
		if(Binoculars and bObj) then
			local pBinocularsTbl={};
			pBinocularsTbl=ReadFromStream(stm);
			Binoculars:OnRestore(pBinocularsTbl);
		end	

		bObj=stm:ReadBool();	
		if(SmokeBlur and bObj) then
			local pSmokeBlurTbl={};
			pSmokeBlurTbl=ReadFromStream(stm);
			SmokeBlur:OnRestore(pSmokeBlurTbl);
		end			
				
		self.bLoaded=1;
	end	
end

--------------------------------------------
function ClientStuff:OnReset()			
	self.vlayers:DeactivateAll();
	-- must reset layers else OnResumeGame restores them	
	self.temp_layers={};
	
	-- reset screen damage effect also
	if(not self.bLoaded or self.bLoaded==0) then	  
		Hud:ResetDamage();
	end
	
	--if _localplayer and _localplayer.cnt and _localplayer.cnt.SwitchFlashLight then
	--	_localplayer.cnt:SwitchFlashLight(0);
	--end	
end
--------------------------------------------
function ClientStuff:OnSetPlayer()    
	self:OnReset();
	
	if(_localplayer.theVehicle) then return end	-- this player is already in some vehicle - don't reset actionMap
	Input:SetActionMap("default");
	
	if (Mission and Mission.OnSetPlayer) then
		Mission:OnSetPlayer();
	end
end
--------------------------------------------
function ClientStuff:OnPauseGame()
	--System:Log("PAUSED");
	self.temp_layers.HeatVision=self.vlayers:IsActive("HeatVision");
	self.temp_layers.NightVision=self.vlayers:IsActive("NightVision");
	self.temp_layers.MoTrack=self.vlayers:IsActive("MoTrack");
	self.temp_layers.Binoculars=self.vlayers:IsActive("Binoculars");
	self.temp_layers.WeaponScope=self.vlayers:IsActive("WeaponScope");
	self.temp_layers.SmokeBlur=self.vlayers:IsActive("SmokeBlur");
	self.vlayers:DeactivateAll();
	
	if _localplayer and _localplayer.cnt and _localplayer.cnt.SwitchFlashLight then
		_localplayer.cnt:SwitchFlashLight(0);
	end

	-- disable looping firing sounds
	local ents=System:GetEntities();
	for i, entity in ents do
		if (entity.type == "Player" and entity.cnt and entity.cnt.weapon) then
			BasicWeapon.Client.OnStopFiring(entity.cnt.weapon, entity);
		end
	end	
end
--------------------------------------------
function ClientStuff:OnResumeGame()
	--System:Log("RESUME");
	for i,val in self.temp_layers do
		self.vlayers:ActivateLayer(i);
	end
end
--------------------------------------------
function ClientStuff:OnUpdate()	
	-- Hack: sincronize stuff in case of reloading
	if(self.bLoaded and self.bLoaded==1) then	  					  
		self.temp_layers=self.temp_layers_save;
		for i,val in self.temp_layers do
			self.vlayers:ActivateLayer(i);
		end	
		self.bLoaded=nil;
	end	
				
	self.vlayers:Update();	
end

--------------------------------------------
-- is called when map changes in MP or on disconnect
function ClientStuff:OnShutdown()		
	self:OnReset();
end

--------------------------------------------
-- This is called whenever an entity is spawned on the client

function ClientStuff:OnSpawnEntity(entity)
end

--------------------------------------------
function ClientStuff:OnMapChange()		
	self:OnReset();
	g_MapChanged=1;
end

--------------------------------------------
function ClientStuff:OnMenuEnter() 
	local stats = _localplayer.cnt;
	
	if (stats.weapon and stats.weapon.AimMode==1) then
		if(ClientStuff.vlayers:IsActive("WeaponScope"))then
			ClientStuff.vlayers:DeactivateLayer("WeaponScope",1);
		end
	end
end

-------------------------------------------------------------------------------
-- callback for getting the in game menu
function ClientStuff:GetInGameMenuName()
	return "InGameSingle";
end

-------------------------------------------------------------------------------
-- callback for getting the in game menu video state
function ClientStuff:GetInGameMenuVideoOn()
	return 1;
end


-------------------------------------------------------------------------------
--
function ClientStuff:OnServerCmd(cmd,pos,normal,entityid,userbyte)
--	System:Log("SERVER CMD ["..cmd.."]");
		
	local toktable=tokenize(cmd);
	
	if toktable~={} then
		local sCommand=toktable[1];
		
		local Function=self.ServerCommandTable[sCommand];
		
		if Function then
			Function(cmd,toktable,pos,normal,entityid,userbyte);
		end
	end
end


---------------------------------------------------------------------------------
-- show percentage for engineer tool
-- e.g. "P 1 55" for progress or "P" for no progress
-- /param 1=building, 2=repairing
-- /param precentage 0..100
ClientStuff.ServerCommandTable["P"]=function(String,toktable)
	if count(toktable)==2 then
		-- no progress (construction area is blocked)
		if toktable[2]=="1" then
			Hud:SetProgressIndicator("Player","@BuildProgress");
		elseif toktable[2]=="2" then
			Hud:SetProgressIndicator("Player","@RepairProgress");
		end
	elseif count(toktable)==3 then
		-- building or repairing
		if toktable[2]=="1" then
			Hud:SetProgressIndicator("Player","@BuildProgress",tonumber(toktable[3]));
		elseif toktable[2]=="2" then
			Hud:SetProgressIndicator("Player","@RepairProgress",tonumber(toktable[3]));
		end
	end
end;


---------------------------------------------------------------------------------
-- show percentage for game
-- e.g. "P2 1 3" 
-- /param checkpointno
-- /param [0..GameRules:GetCaptureStepCount()]
ClientStuff.ServerCommandTable["P2"]=function(String,toktable)
	if count(toktable)==4 then
		Hud:SetProgressIndicator("AssaultState","",tonumber(toktable[2]),tonumber(toktable[3]),tonumber(toktable[4]));
	end
end;

---------------------------------------------------------------------------------
-- remote console printout (verbosity 1)
-- e.g. "PCP hello test" 
ClientStuff.ServerCommandTable["RCP"]=function(String,toktable)
	local sText=strsub(String,5,strlen(String));

	System:LogAlways(sText);
end;


---------------------------------------------------------------------------------
-- 
ClientStuff.ServerCommandTable["FX"] = function(String,toktable,pos,normal,entityid,userbyte)
	if (entityid == nil or entityid == -1) then	return end

	local entity = System:GetEntity(entityid);
	
	if (entity == nil) then 
		System:Warning("OnRemoteEffect id="..tostring(entityid).." does not exist");
		return 
	end
	
	local client = entity.Client;
	-- check if we have a handler available
	if (client and client.OnRemoteEffect) then
		client.OnRemoteEffect(entity, toktable, pos, normal, userbyte);
	elseif (entity.OnRemoteEffect) then
		entity.OnRemoteEffect(entity, toktable, pos, normal, userbyte);
	end
end

---------------------------------------------------------------------------------
-- 
ClientStuff.ServerCommandTable["GI"] = function(String,toktable)
	local player=_localplayer;

	if (player and player.type ~= "spectator" and count(toktable)==2) then
		-- binoculars
		if(toktable[2] == "B") then
			if (player.cnt) then
			if(not player.cnt.has_binoculars) then
				player.cnt:GiveBinoculars(1);			
				Hud:AddPickup(14, 1);
			else
				Hud:AddPickup(14, -1);			
				end
			end
		elseif(toktable[2] == "C") then -- cryvision
			if(player.items) then										-- to prevent script error											
				player:ChangeEnergy(player.MaxEnergy);
												
					player.items.heatvisiongoggles = 1;		
					Hud:AddPickup(12, 1);
				
			end			
		elseif(toktable[2] == "F") then -- flashlight
			if (player.cnt) then
			if(not player.cnt.has_flashlight) then
				player.cnt:GiveFlashLight(1);
				Hud:AddPickup(16, 1);
			else
				Hud:AddPickup(16, -1);			
				end
			end
		elseif(toktable[2] == "WS") then -- reset viewlayers
			ClientStuff:OnReset();		
		--elseif(toktable[2] == "VL") then -- reset all view layers (after player respawn)
		
		end
	end
end
---------------------------------------------------------------------------------
-- 
ClientStuff.ServerCommandTable["HUD"] = function(String,toktable)
	local player=_localplayer;

	if (player and player.type ~= "spectator") then
		
		-- is weapon ? then activate weapons display
		if(count(toktable)==3 and toktable[2]=="W") then
			Hud.weapons_alpha=1;
			Hud.new_weapon=tonumber(toktable[3]);
		end
		
		if(count(toktable)==4) then
			-- generic pick								
			if(toktable[2]=="P") then 			
				Hud:AddPickup(Hud:GenericPickupsConversion(tonumber(toktable[3])), tonumber(toktable[4]));												
			end
			
			-- ammo pickup 
			if(toktable[2]=="A") then				
				Hud:AddPickup(Hud:AmmoPickupsConversion(toktable[3]), tonumber(toktable[4]));				
			end
		end
	end
	
	
	if(player) then
		if(count(toktable)==2 and toktable[2]=="RR") then
			Hud:ResetRadar(_localplayer);
		end	
	end
		
end