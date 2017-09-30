--
-- CurrentMission
--
-- used for triggering and showing Client side messages
-- (split for attacker and defender - therefore only useful in som mods)
-- there is only once Message activate at a time

CurrentMission = {
	Properties = {
		MissionTextAttacker="",				-- e.g. "@AttackBridge" (localized) or "Attack the bride" (non localized)
		MissionTextDefender="",				-- e.g. "@DefendBridge" (localized) or "Defend the bride" (non localized)
  		fileStartSoundAttacker="",			-- e.g. "Sounds/doors/open.wav"
  		fileStartSoundDefender="",			-- e.g. "Sounds/doors/open.wav"
  		bRadarBeacon=1,						-- 1=position is shown on the radar / 0=hidden on radar
	},

	Editor={
		Model="Objects/Editor/M.cgf",		--
	},
	
	sndId=nil,								-- sound id, cannot be local because of garbage collector
}



-------------------------------------------------------------------------------
function CurrentMission:Event_Active()
	self:GotoState("Active");
	BroadcastEvent(self,"Active");		-- beware circular endless loop is possible
end


-------------------------------------------------------------------------------
function CurrentMission:OnReset()
	self:GotoState("Paused");
	self.sndId=nil;
end


-------------------------------------------------------------------------------
function CurrentMission:RegisterStates()
	self:RegisterState("Paused");
	self:RegisterState("Active");
end


-- callback from Hud
function CurrentMission:Render()
	
	if Client:GetGameState()~=CGS_INPROGRESS then
		return;
	end	
				
	%Game:SetHUDFont("hud", "ammo");

  if Hud.PlayerObjective=="POAtt" then											-- attacker
		Game:WriteHudString( 16, 56, "$1" .. self.Properties.MissionTextAttacker, 1, 1, 1, 1, 20, 20);
  elseif Hud.PlayerObjective=="PODef" then										-- defender
		Game:WriteHudString( 16, 56, "$1" .. self.Properties.MissionTextDefender, 1, 1, 1, 1, 20, 20);
	else
		if (_localplayer.entity_type == "spectator") then
		else
	
		Game:WriteHudString( 16, 56, "$1" .. "CurrentMission failed (wrong mod?)", 1, 1, 1, 1, 20, 20);		-- PlayerObjective is missing or wrong mod
		end
	end

	if self.Properties.bRadarBeacon==1 then
		Hud:SetRadarObjectivePos(self:GetPos());
	else
		Hud:SetRadarObjectivePos(nil);
	end
end

----------------------------------------------------
--SERVER
----------------------------------------------------
CurrentMission.Server={
	OnInit=function(self)
		self:RegisterStates();
		self:OnReset();
		self:NetPresent(nil);
		self:EnableUpdate(1);
	end,
-------------------------------------
	Paused={
	},
-------------------------------------
	Active={
		OnBeginState=function(self)
			GameRules.idCurrentMissionObject=self.id;
		end,
		OnUpdate=function(self)
			if GameRules.idCurrentMissionObject~=self.id then			-- only one objet is active at a time
				self:GotoState("Paused");
			end
		end,
		OnEndState=function(self)
			if GameRules.idCurrentMissionObject==self.id then
				GameRules.idCurrentMissionObject=nil;
			end
		end,
	},
}



----------------------------------------------------
--CLIENT
----------------------------------------------------
CurrentMission.Client={
	OnInit=function(self)
		self:RegisterStates();
		self:OnReset();
		self:EnableUpdate(1);
	end,
-------------------------------------
	Paused={
	},
-------------------------------------
	Active={
		OnUpdate=function(self)
			if not Hud then				-- during loading there is no Hud
				return
			end
			if Hud.idShowMissionObject==self.id then
				return;
			end
			
			Hud.idShowMissionObject=self.id;
		
     	-- sound
	    if Hud.PlayerObjective=="POAtt" then																	-- attacker
		    if self.Properties.fileStartSoundAttacker~="" then
	   			self.sndId=Sound:LoadSound(self.Properties.fileStartSoundAttacker);
	
					if self.sndId then
--						Sound:PlaySound(self.sndId);			-- deactivated an request (ChrisA)
					end
				end
			elseif Hud.PlayerObjective=="PODef" then															-- defender
		    if self.Properties.fileStartSoundDefender~="" then
    			self.sndId=Sound:LoadSound(self.Properties.fileStartSoundDefender);

					if self.sndId then
--						Sound:PlaySound(self.sndId);			-- deactivated an request (ChrisA)
					end
				end
			end
		end,

		OnEndState=function(self)
			if Hud.idShowMissionObject==self.id then
				Hud.idShowMissionObject=nil;
			end
		end,
	},
}