-- make sure the table is loaded once
if (not MapCycle) then
	MapCycle =
	{
		iNextMap = 0, -- this is the server-creation map

	};
end

function MapCycle:Init()
	self.iNextMap = 0; -- this is the server-creation map
	self.fRestartTimer = nil;
end

-- load the map cycle from a plain text file
-- each line is one map
-- maps can be repeated
-- maps are played in the order specified in the file
function MapCycle:LoadFromFile(szFilename)
	self.MapList = {};
	self.iNextMap = 0; -- this is the server-creation map
	
	local Lines = ReadTableFromFile(szFilename, 1);
	if (Lines) then
	
		local iSpace;
		local szMapName;
		local szGameType;
		local szTimeLimit = getglobal("gr_TimeLimit");
		local szRespawntime = getglobal("gr_RespawnTime");
		local szInvulnerabilityTimer = getglobal("gr_InvulnerabilityTimer");
		local szMaxPlayers = getglobal("gr_MaxPlayers");
		local szMinTeamLimit = getglobal("gr_MinTeamLimit");
		local szMaxTeamLimit = getglobal("gr_MaxTeamLimit");
		
		
		for i, szLine in Lines do
			if (strlen(szLine) > 0) then
				local paramstr = tokenize(szLine);
				
				if paramstr[1] then 
					szMapName = paramstr[1];
				end
				if paramstr[2] then
					szGameType = paramstr[2];
				end
				
				if paramstr[3] then
					szTimeLimit = paramstr[3];
				end
				
				if paramstr[4] then
					szRespawnTime = paramstr[4];
				end
				
				if paramstr[5] then 
					szInvulnerabilityTimer = paramstr[5];
				end
				
				if paramstr[6] then
					szMaxPlayers = paramstr[6];
				end
			
				if paramstr[7] then
					szMinTeamLimit = paramstr[7];
				end
				
				if paramstr[8] then
					szMaxTeamLimit = paramstr[8];
				end
				
				
				local Map = {};
				
				Map.szName = szMapName;
				Map.szGameType = szGameType;
				Map.szTimeLimit = szTimeLimit;
				Map.szRespawnTime = szRespawnTime;
				Map.szInvulnerabilityTimer = szInvulnerabilityTimer;
				Map.szMaxPlayers = szMaxPlayers;
				Map.szMinTeamLimit = szMinTeamLimit;
				Map.szMaxTeamLimit = szMaxTeamLimit;
								
				tinsert(self.MapList, Map);
			end
		end
		
		self.MapList.n = nil;
	end
end




--[new, nextmap]
function MapCycle:nextmap()
		--[new playertracking]
		SVplayerTrack:Init();
		if toNumberOrZero(getglobal("gr_keep_lock"))==0 then
			SVcommands:SVunlockall();
		end
		--[end ]
		MPStatistics:Print();
		MPStatistics:Init();
		local m = self.MapList[self.iNextMap];
		if (m) then
			GameRules:ChangeMap(m.szName, m.szGameType, m.szTimeLimit, m.szRespawnTime, m.szInvulnerabilityTimer, m.szMaxPlayers, m.szMinTeamLimit, m.szMaxTeamLimit);
		end
end
--[end ]

-- call this everytime map changed
function MapCycle:OnMapChanged()

	MPStatistics:Init();
	if toNumberOrZero(getglobal("gr_keep_lock"))==0 then
		SVcommands:SVunlockall();
	end
	--[new playertracking]
	SVplayerTrack:Init();
	--[end ]
	if (not self:IsOk()) then
		return
	end
	
	System:Log("  g_LevelName was "..tostring(getglobal("g_LevelName")));
	System:Log("  g_GameType was "..tostring(getglobal("g_GameType")));

	self.iNextMap = self.iNextMap + 1;
	
	if (not self.MapList[self.iNextMap]) then
		self.iNextMap = 1;
	end
	
	setglobal("gr_NextMap", self.MapList[self.iNextMap].szName);

	System:Log("  set gr_NextMap to "..tostring(getglobal("gr_NextMap")));
	System:Log("  set iNextMap to "..self.iNextMap);
end

-- call this to know if a map cycling is possible or no
function MapCycle:IsOk()
	if (self.MapList and (count(self.MapList) > 0)) then
		return 1;
	end
	
	return nil;
end

-- call this to know if the scores are being shown, as a result of map finished
function MapCycle:IsShowingScores()
	if (self.fFinishedTimer or self.fRestartTimer) then
		return 1;
	end
	
	return nil;
end

-- call this when the map is finished
-- this function should load nextmap, and update self
function MapCycle:OnMapFinished(quiet)

	if (not quiet) then
		-- print game statistics into console and log
		MPStatistics:Print();
	end
	
	if toNumberOrZero(getglobal("gr_stats_export"))==1 then
		SVplayerTrack:ExportStats();
	end

	GameRules:ForceScoreBoard(1);
	self.fFinishedTimer = _time + 2;
end

-- call this function every frame
-- prolly from GameRules:OnUpdate()
function MapCycle:Update()
	if (self.fFinishedTimer and (_time > self.fFinishedTimer)) then

		self.fFinishedTimer = nil;

		if (not self:IsOk()) then
			self.fRestartTimer = _time + 5;
			Server:BroadcastText("@GameRestartIn $35$o @GameStartingInSeconds", 1);

			return
		end
		
		local Map = self.MapList[self.iNextMap];
		
		if (Map) then
			GameRules:ChangeMap(Map.szName, Map.szGameType, Map.szTimeLimit, Map.szRespawnTime, Map.szInvulnerabilityTimer, Map.szMaxPlayers, Map.szMinTeamLimit, Map.szMaxTeamLimit);
		end
	elseif (self.fRestartTimer) then		

		if (_time > self.fRestartTimer) then

			self.fRestartTimer = nil;
			
			if tostring(getglobal("gr_PrewarOn"))~="0" then
				self:NewGameState(CGS_PREWAR);
			else
				GameRules:DoRestart();
			end
		end
	end	
end

-- load the map cycle file
function MapCycle:Reload()
	if (getglobal("sv_mapcyclefile")) then
		MapCycle:LoadFromFile(getglobal("sv_mapcyclefile"));
	end
	self.iNextMap = 1;
end

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
MapCycle:Reload();
