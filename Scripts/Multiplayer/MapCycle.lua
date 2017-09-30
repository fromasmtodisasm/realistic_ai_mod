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
		
		for i, szLine in Lines do
			if (strlen(szLine) > 0) then
				iSpace = strfind(szLine, " ", 1, 1);
				
				if (iSpace) then
					szMapName = strsub(szLine, 1, iSpace-1);
					szGameType = strsub(szLine, iSpace+1, -1);
				else
					szMapName = szLine;
				end
				
				local Map = {};
				
				Map.szName = szMapName;
				Map.szGameType = szGameType;
				
				tinsert(self.MapList, Map);
			end
		end
		
		self.MapList.n = nil;
	end
end

-- call this everytime map changed
function MapCycle:OnMapChanged()

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
		MPStatistics:Init();
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
			GameRules:ChangeMap(Map.szName, Map.szGameType);
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