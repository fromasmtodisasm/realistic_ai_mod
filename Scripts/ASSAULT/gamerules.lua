----------------------------------------------------------------------------------------
--FAR CRY script file
-- ASSAULT Game Rules
-- Created by Alberto Demichelis
-- modified by Martin Mittring
-- modified by Kevin Jenkins (changing teams and scoring)
--
-- team red is the attacker team
-- team blue is the defender team
--
----------------------------------------------------------------------------------------
Script:LoadScript("SCRIPTS/MULTIPLAYER/VotingState.lua");


GameRules={
	MapCheckPoints ={},								-- table of stored checkpoint entities

	respawndelay = 3,
	countnext = 0,

	mapstart = 0,
	intermissionstart = 0,
	scoreupdate = 3000,
		
	CurrentCheckPoint_Number = nil,		-- from the touched checkpoint (Properties.CheckPoint_Number) - is not the index in MapCheckPoints
	CheckPointIndices={},								-- refresh with self:RecalcCheckPointIndices()
	
	attackerTeam="red",
	defenderTeam="blue",

	red_played_attack=0,
	red_played_defense=0,
	blue_played_attack=0,
	blue_played_defense=0,
	
	first_attackers_time=0,
	timelimit=getglobal("gr_TimeLimit"),
	

	-- These two timers are handled by StartGameRulesLibTimer and DoGameRulesLibTimer
	respawnCycle=1, 									-- Set this 1 to enable the respawn cycle feature for this mod
	switchTeamsTimer=5, 							-- Seconds before switching teams after a win
	states={},												-- table of tall the ASSAULTCheckpoints
	CurrentProgressStep=0,						-- 0=not capturable(warmup), 1=touchable, [1.. GetCaptureStepCount()]
	
	ScoreMultipliers=
	{
		xCaptureStarted = 5,
		xCaptureAverted = 5,
		xCaptureFinished = 25,
		xBuildingBuilt = 5,
		xBuildingRepaired = 5,
		xBuildingDestroyed = 5,
		xHeal = 2,
		xKill = 5,
		xDeath = 0,
	},
}

Script:LoadScript("SCRIPTS/MULTIPLAYER/GameRulesClassLib.lua");	-- derive from class bases game rules
Script:LoadScript("scripts/ASSAULT/shared.lua");

GameRules.InitialPlayerStatistics["nCaptureFinished"]=0;			-- this entry can be used by MPStatistics:AddStatisticsDataEntity();
GameRules.InitialPlayerStatistics["nCaptureStarted"]=0;
GameRules.InitialPlayerStatistics["nCaptureAverted"]=0;

-- server_slot.
--	InitialPlayerProperties =
--	{
--		health		= 255, 			-- range: 0=dead .. 255=full health		health		= 100,
--		armor		= 100,
--		model		= "",			-- if this is set it is used as your player model e.g. "Objects/characters/workers/evil_worker/evil_worker.cgf"
--		equipEquipment	="NetPlayerPack"..playerid,
--	},

-------------------------------------------------------------------------------
--UTILITIES FUNC
-------------------------------------------------------------------------------

----------------------------------------------------------------------------------------
function GameRules:ScoreboardUpdate()
	local SlotMap=Server:GetServerSlotMap();
	
	for i, Slot in SlotMap do
		local Player = GetSlotPlayer(Slot);
		
		if Player and Player.cnt then
			local ClientId = Slot:GetId();

			local iDeaths = Player.cnt.deaths;			
			if not iDeaths then
				iDeaths=0;
			end
			
			local iTotalScore = 0;
			local iPlayerScore = 0;
			local iCapScore = 0;
			local iSupportScore = 0;
			local iKillScore = 0;

			iTotalScore, iPlayerScore, iCapScore, iSupportScore, iKillScore = GameRules:CalcPlayerScore(Slot);

			local szPlayerClass = Player.sCurrentPlayerClass;		
			local iPlayerClass = -1;
		
			if (szPlayerClass) then
				if (Player.sCurrentPlayerClass == "Grunt") then
					iPlayerClass = 0;
				elseif (Player.sCurrentPlayerClass == "Support") then
					iPlayerClass = 1;
				elseif (Player.sCurrentPlayerClass == "Sniper") then
					iPlayerClass = 2;
				end
			end
			
--			System:Log("szPlayerClass "..tostring(szPlayerClass).." "..tostring(iPlayerClass));

			local iPlayerTeam = -1;

			local szTeam=Game:GetEntityTeam(Player.id);

			if szTeam=="spectators" then
				iPlayerTeam = 0;
			elseif szTeam=="red" then
				iPlayerTeam = 1;
			elseif szTeam=="blue" then
				iPlayerTeam = 2 
			end
			
--			System:Log("PlayerTeam "..tostring(szTeam).." "..tostring(iPlayerTeam)); -- debug

			local iSuicides = 0;
			if Slot.Statistics and Slot.Statistics["nSelfKills"] then
				iSuicides = Slot.Statistics["nSelfKills"];
			end
			
			self:SetScoreboardEntryXY(ScoreboardTableColumns.sName,ClientId,Slot:GetName());
			--self:SetScoreboardEntryXY(ScoreboardTableColumns.sName,ClientId,"JAAP");
			self:SetScoreboardEntryXY(ScoreboardTableColumns.iTotalScore,ClientId,iTotalScore);
			self:SetScoreboardEntryXY(ScoreboardTableColumns.iPlayerScore,ClientId,iPlayerScore);
--			self:SetScoreboardEntryXY(ScoreboardTableColumns.iDeaths,ClientId,iDeaths);
--			self:SetScoreboardEntryXY(ScoreboardTableColumns.iCapScore,ClientId,iCapScore);
			self:SetScoreboardEntryXY(ScoreboardTableColumns.iSupportScore,ClientId,iSupportScore);
--			self:SetScoreboardEntryXY(ScoreboardTableColumns.iSuicides,ClientId,iSuicides);
--			self:SetScoreboardEntryXY(ScoreboardTableColumns.iKillScore,ClientId,iKillScore);
			self:SetScoreboardEntryXY(ScoreboardTableColumns.iPlayerClass,ClientId,iPlayerClass);
			self:SetScoreboardEntryXY(ScoreboardTableColumns.iPlayerTeam,ClientId,iPlayerTeam);
		end
	end
end


-------------------------------------------------------------------------------
function GameRules:OnInit()

	setglobal("gr_checkpoint", "1");
	System:Log("$5GameRules Init: "..self:ModeDesc());
	--reset messagetrack
		MessageTrack = {};
--	for i, index in MessageTrack do
--		MessageTrack.index = nil;
--	end
	
	Server:RemoveTeam("red");
	Server:RemoveTeam("blue");
	e_deformable_terrain=0;
	Server:AddTeam("red");
	Server:AddTeam("blue");
	CreateStateMachine(self);
	self.voting_state=VotingState:new();
	if (tostring(getglobal("gr_PrewarOn"))=="1") then
		setglobal("gr_PrewarOn","0");
	end
end

-----------------------------------------------------------------------
-- For Server Browsers
-- Refer to GetPlayerStats in QueryHandler.lua for more info
-----------------------------------------------------------------------
function GameRules:GetPlayerStats()
	local SlotMap = Server:GetServerSlotMap();
	local Stats = {};
	local j = 1; -- to make it 1..n because SlotMap is 0..n-1
	
	for i, Slot in SlotMap do
		Stats[j] = {};	
		
		local Player = Stats[j];
		local iScore = GameRules:CalcPlayerScore(Slot);
		
		Player.Name = Slot:GetName();
		Player.Team = Game:GetEntityTeam(Slot:GetPlayerId());
		Player.Skin = "";
		Player.Score = iScore;
		Player.Ping = Slot:GetPing();
		Player.Time = floor(Slot:GetPlayTime() / 60).."m";

		j = j + 1;
	end

	return Stats;
end


function GameRules:CalcPlayerScore(ServerSlot)
	if (not ServerSlot.Statistics) then
		ServerSlot.Statistics = GameRules:GetInitialPlayerStatistics();
	end
	
	local Stat = ServerSlot.Statistics;
	local Mult = GameRules.ScoreMultipliers;
	local Player = System:GetEntity(ServerSlot:GetPlayerId());
	
	if (not Player) then
		return 0, 0, 0, 0, 0;
	end

	-- calculate total score
	local iScore = 0;
	local iCapScore = 0;
	local iSupportScore = 0;
	local iKillScore = 0;
	local iPlayerScore = 0;
	local iPlayerDeaths = 0;
	
	if (Player.cnt.score) then
		iPlayerScore = Player.cnt.score;
	end

	if (Player.cnt.deaths) then
		iPlayerDeaths = Player.cnt.deaths;
	end
	
	if(Stat["nCaptureStarted"])then
		iCapScore = iCapScore + Stat["nCaptureStarted"] * Mult["xCaptureStarted"];
		iCapScore = iCapScore + Stat["nCaptureAverted"] * Mult["xCaptureAverted"];
		iCapScore = iCapScore + Stat["nCaptureFinished"] * Mult["xCaptureFinished"];
		iSupportScore = iSupportScore + Stat["nBuildingBuilt"] * Mult["xBuildingBuilt"];
		iSupportScore = iSupportScore + Stat["nBuildingRepaired"] * Mult["xBuildingRepaired"];
		iSupportScore = iSupportScore + Stat["nBuildingDestroyed"] * Mult["xBuildingDestroyed"];
		iSupportScore = iSupportScore + Stat["nHealed"] * Mult["xHeal"];
		iKillScore = iKillScore + iPlayerScore * Mult["xKill"];
		iKillScore = iKillScore - iPlayerDeaths * Mult["xDeath"];
		iScore = iKillScore + iSupportScore + iCapScore;
	end
	
	return iScore, iPlayerScore, iCapScore, iSupportScore, iKillScore;
end

-------------------------------------------------------------------------------
function GetPlayerFromSSId(ssid)
	local Slot = Server:GetServerSlotBySSId(ssid);
	return System:GetEntity(Slot:GetPlayerId());
end

-------------------------------------------------------------------------------
function GameRules:InvalidateCapture(ssid)
	
	local currentcp = GameRules:GetNextBiggerCheckPointNumber();
	
	for i,cp in self.MapCheckPoints do
		if ((cp.Properties.bVisible == 1) and (cp.Properties.CheckPoint_Number == currentcp)) then
			if (cp.captureCollider and (cp.captureCollider == ssid)) then
				cp:Event_Averted();
			end
		end
	end
end

-------------------------------------------------------------------------------
function GameRules:OnAfterLoad()
end

-------------------------------------------------------------------------------
-- private method
function GameRules:_GetCaptureString()
	local next = self:CalcCheckPointIndex(self.CurrentCheckPoint_Number);

	return "P2 ".. next .." ".. self.CurrentProgressStep .." ".. count(self.CheckPointIndices)-1;		-- P2 0 [0..GetCaptureStepCount()] GoalCount
end

-------------------------------------------------------------------------------
function GameRules:UpdateCaptureProgressAllPlayers()
  Server:BroadcastCommand(self:_GetCaptureString());						-- invoke OnServerCmd() for all the clients
end
-------------------------------------------------------------------------------
function GameRules:UpdateCaptureProgressOnePlayer( server_slot )
  server_slot:SendCommand(self:_GetCaptureString());						-- invoke OnServerCmd() on the given client
end


-------------------------------------------------------------------------------
-- called on capturing a checkpoint
function GameRules:OnCaptureStep_Warmup()
	self.CurrentProgressStep=0;
	self:UpdateCaptureProgressAllPlayers();
end

-------------------------------------------------------------------------------
-- called on avert capture and on warmup end time
-- \param checkpointno number of the touched checkpoint
function GameRules:OnCaptureStep_Touchable( checkpointno )
	local next=GameRules:GetNextBiggerCheckPointNumber();

	if next~=nil and next==checkpointno then
		self.CurrentProgressStep=1;
		self:UpdateCaptureProgressAllPlayers();
	end
end

-------------------------------------------------------------------------------
-- \return 1,nil
function GameRules:OnCaptureStep_Next()
	self.CurrentProgressStep=self.CurrentProgressStep+1;

	if self.CurrentProgressStep>self:GetCaptureStepCount()+1 then
		self.CurrentProgressStep=0;
		return 1;
	end

	self:UpdateCaptureProgressAllPlayers();
	return nil;
end

-------------------------------------------------------------------------------
function GameRules:GetCaptureStepCount()
	return 4;
end


-------------------------------------------------------------------------------
-- This function is called whenever the server needs to return a packet containing
-- a description of the current Game: since a "mod" can contain multiple modes, this
-- should be taken into account here. the string should be relatively short.
function GameRules:ModeDesc()
    return "Assault";
end


-------------------------------------------------------------------------------
-- This function resets the game...
function GameRules:DoRestart()

	self.restartbegin = nil;
	self.restartend = nil;
	self.switchTeamsCountdown = nil;
	
	self.attackerTeam="red";
	self.defenderTeam="blue";
	
	self.red_played_attack=0;
	self.red_played_defense=0;
	
	self.blue_played_attack=0;
	self.blue_played_defense=0;
	
	Server:SetTeamScore("blue", 0);
 	Server:SetTeamScore("red", 0);

 	self:ResetPlayerScores(0, 0);
 	self:ResetMap();
 	self:UpdateTimeLimit(getglobal("gr_TimeLimit"));
end

-------------------------------------------------------------------------------
-- called from the map reloading process
-- gamerules.lua is reloaded and thus reset before this is called
function GameRules:OnMapChange()

	self:DoRestart();

	if tostring(getglobal("gr_PrewarOn"))~="0" then
		self:NewGameState(CGS_PREWAR);
	else
		self:NewGameState(CGS_INPROGRESS);
	end	

	if (MapCycle) then
		MapCycle:OnMapChanged();
	end
	
	GameRules:CreateScorebordEntity();
end

-------------------------------------------------------------------------------
--
function GameRules:SetToFirstCheckPoint()
--	System:Log("GameRules:SetToFirstCheckPoint");
	self.CurrentCheckPoint_Number=nil;
	
	local requestedCheckPoint = tonumber(getglobal("gr_checkpoint"));
	-- find the lowest number in entity.Properties.CheckPoint_Number and store it in CurrentCheckPoint_Number
	for i,entity in self.MapCheckPoints do
		if entity.Properties.CheckPoint_Number==requestedCheckPoint then
			self.CurrentCheckPoint_Number = entity.Properties.CheckPoint_Number;
		end
	end
	
	self:RefreshCheckpoints();
	self:OnCaptureStep_Warmup();
end





-------------------------------------------------------------------------------
-- send the player 
function GameRules:ASSAULTHandleJoinTeamRequest( server_slot,team )
	self:InvalidateCapture(server_slot:GetId());
	self:HandleJoinTeamRequest(server_slot,team);
	self:UpdateCaptureProgressOnePlayer(server_slot);
end


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function GameRules:INPROGRESS_OnDamage(hit)
	local damage_ret=self:UsualDamageCalculation(hit);
	
--	System:Log("GameRules:INPROGRESS_OnDamage "..tostring(damage_ret));

	-- we have to unregister dead players from the assault checkpoints
	if (damage_ret ~= nil) then		
		local deadguy_pos = hit.target:GetPos();
		deadguy_pos.z = deadguy_pos.z + 1.0;
		local pickup = Server:SpawnEntity("ClassAmmoPickup", deadguy_pos);
		if (pickup) then
			pickup:SetFadeTime(GameRules:GetPickupFadeTime());
			pickup.autodelete = 1;
			pickup.Properties.IsDropPack = 1;
			pickup:EnableSave(0);
			pickup:Physicalize(hit.target);
		end
	end
	
	self:UsualScoreCalculation(hit,damage_ret);
end


function GameRules:HandleClientDisconnect(server_slot)
	self:InvalidateCapture(server_slot:GetId()); 
	
	if (self.respawnList) then
		self.respawnList[server_slot]=nil; -- Remove this guy from the pending respawn list
	end
--self:CheckPlayersCount();		-- goto prewar if player count is not ok
end

-------------------------------------------------
--PREWAR
-------------------------------------------------
GameRules.states.PREWAR={
--------------------------------
	OnBeginState=function (self)
		GameRules:SetToFirstCheckPoint();

--		if(tonumber(gr_AutoReady)~=0)then
--			self.autoready=_time;
--			self.autoreadynotif=tonumber(gr_AutoReadyTime)*60;
--			Server:BroadcastText("@TheGameStartsIn $3"..(tonumber(gr_AutoReadyTime)*60));	-- $1the game will start automatically in
--		else
--			Server:BroadcastText("@WaitingForReadyPlayer");		-- $1waiting for players ready
--		end
		self:ResetReadyState(nil);

	end,
	--------------------------------
	OnUpdate=GameRules.PREWAR_Team_OnUpdate,
	--------------------------------
	OnClientJoinTeamRequest=GameRules.ASSAULTHandleJoinTeamRequest,
	--------------------------------
	OnEndState=function(self)
		Server:SetTeamScore("blue",0)
 		Server:SetTeamScore("red",0)
	end,
}
-------------------------------------------------
--COUNTDOWN
-------------------------------------------------
GameRules.states.COUNTDOWN={
--------------------------------
	OnBeginState=GameRules.COUNTDOWN_OnBeginState,
--------------------------------
	OnUpdate=GameRules.COUNTDOWN_OnUpdate,
--------------------------------
	OnClientJoinTeamRequest=GameRules.ASSAULTHandleJoinTeamRequest,
--------------------------------
	OnClientDisconnect = GameRules.HandleClientDisconnect,
}
-------------------------------------------------
--INPROGRESS
-------------------------------------------------
GameRules.states.INPROGRESS={
--------------------------------
	OnBeginState=function (self)
		GameRules:SetToFirstCheckPoint();
		GameRules:StartGameRulesLibTimer();
		GameRules:SetTeamObjectivesAllPlayers();		-- tell all players who is attacking and who defending
	end,
--------------------------------
	OnUpdate=function(self)
		
		if (MapCycle:IsShowingScores()) then
			return;
		end
				
		if(tonumber(gr_ScoreLimit)~=0)then
			local red_score=Game:GetTeamScore("red");
			local blue_score=Game:GetTeamScore("blue");		
			if(red_score>=tonumber(gr_ScoreLimit))then
				Server:BroadcastText("@RedTeamReachedScore");
	    	MapCycle:OnMapFinished();
			end
			if(blue_score>=tonumber(gr_ScoreLimit))then
		    Server:BroadcastText("@BlueTeamReachedScore");
	    	MapCycle:OnMapFinished();
			end
		end
	
		if (self.timelimit and (tonumber(self.timelimit) > 0)) then
			if _time>self.mapstart+tonumber(self.timelimit)*60 then
				-- Defenders win
				if toNumberOrZero(getglobal("gr_point_per_flag"))~=1 then
					local team_score=Game:GetTeamScore(self.defenderTeam);
					team_score=team_score+1;
					Server:SetTeamScore(self.defenderTeam,team_score);
				end
				self:SwitchTeams();
				Server:BroadcastText("@TheAttackersFail");
				self.mapstart = _time;
		  	end
		end
	end,
--------------------------------
	OnDamage=GameRules.INPROGRESS_OnDamage,
--------------------------------
	OnKill=function(self,server_slot)
		local id = server_slot:GetPlayerId();
	    if id ~= 0 then
	        local ent = System:GetEntity(id);
	 		local team = Game:GetEntityTeam(id);
	        if team ~= "spectators" then
	            self:OnDamage({ target = ent, shooter = ent, damage = 1000, ipart = 0 });
	        end
	    end
	end,
--------------------------------
	OnClientJoinTeamRequest=GameRules.ASSAULTHandleJoinTeamRequest,
	OnTimer=function(self)
		if (self.switchTeamsCountdown~=nil and self.switchTeamsCountdown>0) then
			self.switchTeamsCountdown=self.switchTeamsCountdown-1;
			if (self.switchTeamsCountdown==0) then
				self:ForceScoreBoard(0);
				self:DoSwitchTeams();
			else
				if toNumberOrZero(getglobal("gr_rm_needed_kills"))==0 then
					Server:BroadcastText("@GameOverSwitchTeamsIn "..self.switchTeamsCountdown, 0.9);
				end
				if toNumberOrZero(getglobal("gr_rm_needed_kills"))>0 then  --display only once
					if self.switchTeamsCountdown==5 then
						Server:BroadcastText("@GameOverSwitchTeamsIn "..self.switchTeamsCountdown, 0.9);
					end
				end
				
					
			end
		end
		
		-- Propigate the timer
		self:DoGameRulesLibTimer();
	end,
--------------------------------
	OnClientDisconnect = GameRules.HandleClientDisconnect,
}
-------------------------------------------------
--INTERMISSION
-------------------------------------------------
GameRules.states.INTERMISSION={
--------------------------------
	OnBeginState=GameRules.INTERMISSION_BeginState,
--------------------------------
	OnUpdate=GameRules.INTERMISSION_OnUpdate,
}
---------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- is updating GameRules.RespawnPoints
-- \param team e.g. "red", "blue", "spectators" or "players"
-- \return table {[1]={x=,y=,z=,xA=,yA=,zA=},[2]={x=,y=,z=,xA=,yA=,zA=},..} 
function GameRules:RecreateTableOfRespawnPoints()
	local checkpointnumber=self.CurrentCheckPoint_Number;
	local ents=System:GetEntities();		-- very inefficient
	local i=1;
	
	GameRules.RespawnPoints={};

	-- got through all AssultCheckpoints	
	for i,entity in self.MapCheckPoints do
		if entity.Properties.CheckPoint_Number==checkpointnumber then
			if (entity.Properties.bAttackerSpawnPoint==1) then
				local pt = new(entity:GetPos());
				local rot=entity:GetAngles();
				GameRules.RespawnPoints[i] = {x=pt.x, y=pt.y, z=pt.z, xA=rot.x, yA=rot.y, zA=rot.z, name=self.attackerTeam };
				i=i+1;
			end
			if (entity.Properties.bDefenderSpawnPoint==1) then
				local pt = new(entity:GetPos());
				local rot=entity:GetAngles();
				GameRules.RespawnPoints[i] = {x=pt.x, y=pt.y, z=pt.z, xA=rot.x, yA=rot.y, zA=rot.z, name=self.defenderTeam };
				i=i+1;
			end
		end
	end

	return ret;
end






-------------------------------------------------------------------------------
-- private method
-- /return number or nil if there is no next number
function GameRules:GetNextBiggerCheckPointNumber()

	local ret;
	
	for i,entity in self.MapCheckPoints do
		if ret==nil then
			if entity.Properties.CheckPoint_Number>self.CurrentCheckPoint_Number then
				ret = entity.Properties.CheckPoint_Number;
			end
		else 
			if entity.Properties.CheckPoint_Number>self.CurrentCheckPoint_Number and entity.Properties.CheckPoint_Number<ret then
				ret = entity.Properties.CheckPoint_Number;
			end
		end
	end
	
	return ret;
end



-------------------------------------------------------------------------------
-- private method
function GameRules:RecalcCheckPointIndices()

	self.CheckPointIndices={};

	for i,entity in self.MapCheckPoints do
		self.CheckPointIndices[entity.Properties.CheckPoint_Number]=1;
	end
end

-------------------------------------------------------------------------------
-- private method
-- \return 0..self.CheckPointIndices_Count
function GameRules:CalcCheckPointIndex( inCheckPointNumber )

	local ret=0;
	
	for key,value in self.CheckPointIndices do
		if key<inCheckPointNumber then
			ret=ret+1;
		end
	end
	
	return ret;
end

-------------------------------------------------------------------------------
-- is called by the ASSAULTCheckPoint entity, test if the entity is an attacker
function GameRules:IsAttacker(entity)
	if (entity) then
		local team=Game:GetEntityTeam(entity.id);
	
		if (team == self.attackerTeam) then
		
			local slot=Server:GetServerSlotByEntityId(entity.id);
			
			if (self.respawnList) then
				local respawn = self.respawnList[slot];
		
				-- if the player will respawn on a different team, then he is not an attacker anymore.	
				if (respawn and respawn.team) then
					if (respawn.team ~= team) then
						return nil;
					end
				end
			end
			
			return 1;
		end
	end
	
	return nil;
end

-------------------------------------------------------------------------------
-- test if the entity is a defender
function GameRules:IsDefender(entity)
	if (entity) then
		local team=Game:GetEntityTeam(entity.id);
	
		if (team == self.defenderTeam) then
			return 1;
		end
	end
	
	return nil;
end


-------------------------------------------------------------------------------
function GameRules:GetTeamRespawnPoint(team,entityToIgnore)

	local pt;

	pt = self:GetFreeTeamRespawnPoint(team,entityToIgnore);
	if(pt)then return pt; end
	
	System:Error("No possible respawn points ('red'/'blue' or 'players')");
end



-- /return 1=yes everything is ok / 2=was touched in advance / nil=no message
function GameRules:IsCheckpointTouchable(checkpoint,collider)
	
	local newNumber=checkpoint.Properties.CheckPoint_Number;
	
	if newNumber<=self.CurrentCheckPoint_Number then
		return; -- checkpoint was already touched
	end

	if GameRules:GetState()~="INPROGRESS" then
		return;
	end	
	
	if collider.type~="Player" then
		return;
	end
	
	if collider.cnt.health<=0 then
		return;
	end
		
	return 1;	-- checkpoint was triggered by event
end

function GameRules:IsCheckpointTouchableSSId(checkpoint,colliderslotid)

	local newNumber=checkpoint.Properties.CheckPoint_Number;
	
	if newNumber<=self.CurrentCheckPoint_Number then
		return; -- checkpoint was already touched
	end

	if GameRules:GetState()~="INPROGRESS" then
		return;
	end
	
	local collider = GetPlayerFromSSId(colliderslotid);
	
	if collider.type~="Player" then
		return;
	end
	
	if collider.cnt.health<=0 then
		return;
	end
		
	return 1;	-- checkpoint was triggered by event
end


-------------------------------------------------------------------------------
-- is called by the ASSAULTCheckPoint entity
-- \param checkpoint ASSAULTCheckPoint
-- \param collider playerentity or nil if there was no collider (order is not checked, team is not checked)
function GameRules:TouchedCheckpoint(checkpoint,colliderssid)

	local newNumber=checkpoint.Properties.CheckPoint_Number;
	local collider = GetPlayerFromSSId(colliderssid);

	if GameRules:IsAttacker(collider) == nil then										-- otherwise checkpoint was triggered by event
		return -- only attacker can touch waypoints
	end

	if newNumber>self.CurrentCheckPoint_Number then
		
		if collider then										-- otherwise checkpoint was triggered by event
			local expected=self:GetNextBiggerCheckPointNumber();
		
			if newNumber~=expected then 	-- Don't touch checkpoints in advance
				return;
			end
			local ss = Server:GetServerSlotByEntityId(collider.id);
			if toNumberOrZero(getglobal("gr_flag_captured_message"))==1 then 
				local flagscapt=SVplayerTrack:GetBySs(ss,"flagscaptured")+1;
				Server:BroadcastText("$4>$2>$4>$2>$4> "..collider:GetName().."$6 CAPTURED the flag $4<$2<$4<$2<$4< $6("..flagscapt.." total)");
				Server:BroadcastText("$4>$2>$4>$2>$4> "..collider:GetName().."$6 CAPTURED the flag $4<$2<$4<$2<$4< $6("..flagscapt.." total)");
				Server:BroadcastText("$4>$2>$4>$2>$4> "..collider:GetName().."$6 CAPTURED the flag $4<$2<$4<$2<$4< $6("..flagscapt.." total)");
			else
				Server:BroadcastText(collider:GetName().."$o @CapturedObj");
			end
			if ss then
			 	if toNumberOrZero(getglobal("gr_rm_needed_kills"))>0 then
					SVplayerTrack:RMFlagCaptured(ss);
				end
				SVplayerTrack:SetBySs(ss,"flagscaptured", 1, 1);
			end
			
			MPStatistics:AddStatisticsDataEntity(collider,"nCaptureFinished",1);
		else
			Server:BroadcastText("@ObjWasCaptured");
		end

		if toNumberOrZero(getglobal("gr_point_per_flag"))==1 then
			local team_score=Game:GetTeamScore(self.attackerTeam);
			team_score=team_score+1;
			Server:SetTeamScore(self.attackerTeam,team_score);
		end
		self.CurrentCheckPoint_Number = newNumber;
		self:RefreshCheckpoints();
		self:OnCaptureStep_Warmup();
		
		--Server:BroadcastText("Next Objective is checkpoint "..self.CurrentCheckPoint_Number);
	end
	
	if self:HaveAttackersWon() then
		Server:BroadcastText("@AttackerWon");
		--GameCommands:restart();
		if toNumberOrZero(getglobal("gr_point_per_flag"))~=1 then		
			local team_score=Game:GetTeamScore(self.attackerTeam);
			team_score=team_score+1;
			Server:SetTeamScore(self.attackerTeam,team_score);
		end
		  
		self:SwitchTeams();
		self.mapstart = _time;
		if (self.switchTeamsTimer and self.switchTeamsTimer > 0) then
			self.mapstart = self.mapstart + self.switchTeamsTimer;
		end
	end
end

-------------------------------------------------------------------------------
-- after attacker managed to capture a checkpoint or game restarts
function GameRules:ResetAtCurrentCheckpoint()
	local slots = Server:GetServerSlotMap();
	
	for i, slot in slots do
		local ent = System:GetEntity(slot:GetPlayerId());
	
	  	if ent~=nil and ent.type=="Player" and Game:GetEntityTeam(ent.id)~="spectators" and ent.cnt.health >0 then
			local pos=self:GetTeamRespawnPoint(Game:GetEntityTeam(ent.id), ent);
			if (pos) then
				-- beam to new position - amoo and others is not reseted			
				ent:SetPos(pos);
				ent:SetAngles({x=pos.xA, y=pos.yA, z=pos.zA});
			end
		end
	end
end

-------------------------------------------------------------------------------
-- Start the countdown for switching teams
function GameRules:SwitchTeams()
	if toNumberOrZero(getglobal("gr_rm_needed_kills"))>0 then
		SVplayerTrack:RMReset();
	end

	self:InvalidateAllCaptures();

	if (tostring(self.attackerTeam) == "red") then
		self.red_played_attack = 1;
		self.blue_played_defense = 1;
	end

	if (tostring(self.attackerTeam) == "blue") then
		self.blue_played_attack = 1;
		self.red_played_defense = 1;
	end
	
	if ((self.red_played_attack == 1) and (self.red_played_defense == 1)) then
		
		self:UpdateTimeLimit(getglobal("gr_TimeLimit"));
		
		MapCycle:OnMapFinished();
		
	else
		
		if (self.timelimit and tonumber(self.timelimit) > 0) then
			self:UpdateTimeLimit((_time - self.mapstart) / 60);
			if toNumberOrZero(getglobal("gr_fulltime"))==1 then
				self:UpdateTimeLimit(getglobal("gr_TimeLimit"));
			end
		else
			self:UpdateTimeLimit(0);
		end
		
		if (self.switchTeamsTimer~=nil and self.switchTeamsTimer>0) then
			self:ForceScoreBoard(1);
			self.switchTeamsCountdown=self.switchTeamsTimer;
		else
			self:ForceScoreBoard(0);
			self:DoSwitchTeams(); -- with no timer switch immediately
		end
	end
end
-------------------------------------------------------------------------------
-- Change all client teams
function GameRules:ResetMap()

	self.mapstart = _time;
	self.countnext = 0;
	
	self:ResetMapEntities();
	
	-- put all checkpoints of the map in a lua table
	self.MapCheckPoints={};

	local ents=System:GetEntities();
	for i,entity in ents do
		if entity.classname=="ASSAULTCheckPoint" then
			self.MapCheckPoints[getn(self.MapCheckPoints)+1]=entity;
		end
	end

	self:RecalcCheckPointIndices();
	self:SetToFirstCheckPoint(); -- reset the checkpoints
	self:ResetAtCurrentCheckpoint();

	self:SetTeamObjectivesAllPlayers();
	self:NewGameState(CGS_INPROGRESS);
end

-------------------------------------------------------------------------------
-- Change all client teams
function GameRules:DoSwitchTeams()
	
	self.attackerTeam, self.defenderTeam = self.defenderTeam, self.attackerTeam;

	self:ResetMap();
end

-------------------------------------------------------------------------------
-- refresh all checkpoint objects (set state depending on self.CurrentCheckPoint_Number)
function GameRules:RefreshCheckpoints()
	local current=self.CurrentCheckPoint_Number;
	local nextone=self:GetNextBiggerCheckPointNumber();
	
	for i,entity in self.MapCheckPoints do
		if nextone and entity.Properties.CheckPoint_Number>nextone then
			entity:Event_Blocked();
		elseif entity.Properties.CheckPoint_Number>current then
--			entity:Event_Untouched();	
			entity:Event_Warmup();	
		elseif entity.Properties.CheckPoint_Number<current then
			assert(self.attackerTeam)
			entity:Event_Touched();
		else
			entity:Event_Spawn();
		end
	end

	self:RecreateTableOfRespawnPoints();		-- update GameRules.RespawnPoints
end


-------------------------------------------------------------------------------
function GameRules:GetAttackerTeam()
	return self.attackerTeam;
end

-------------------------------------------------------------------------------
function GameRules:GetDefenderTeam()
	return self.defenderTeam;
end


-------------------------------------------------------------------------------
function GameRules:InvalidateAllCaptures()

	local currentcp = GameRules:GetNextBiggerCheckPointNumber();

--	System:Log("GameRules:InvalidateAllCaptures"..tostring(currentcp));	-- debug

	for i,cp in self.MapCheckPoints do
		if ((cp.Properties.bVisible == 1) and (cp.Properties.CheckPoint_Number == currentcp)) then
			if(cp.captureCollider)then
				
--				System:Log("GameRules:InvalidateAllCaptures Event_Averted "..tostring(cp));	-- debug

				cp:Event_Averted();
			end
		end
	end
end

-------------------------------------------------------------------------------
-- return 1 or nil if not  
function GameRules:HaveAttackersWon()

	if (self.switchTeamsCountdown~=nil and self.switchTeamsCountdown>0) then
		return nil;		-- ongoing counter to team switch
	end
	
	for i,entity in self.MapCheckPoints do
		if entity.Properties.CheckPoint_Number>self.CurrentCheckPoint_Number then
			return nil;
		end
	end

	return 1;	-- there was no checkpoint with a bigger number
end



-------------------------------------------------------------------------------
-- tell one player who is attacking and who defending
function GameRules:SetTeamObjectivesOnePlayer( slot )
  local ent = System:GetEntity(slot:GetPlayerId());
    
	if ent~=nil then
		if (Game:GetEntityTeam(ent.id)==self.attackerTeam) then
			slot:SendCommand("CPO POAtt");						-- invoke OnServerCmd() on the client
		elseif (Game:GetEntityTeam(ent.id)==self.defenderTeam) then	
			slot:SendCommand("CPO PODef");						-- invoke OnServerCmd() on the client
		else	
			slot:SendCommand("CPO");									-- remove player objective invoke OnServerCmd() on the client
		end
	end
end

-------------------------------------------------------------------------------
-- tell all players who is attacking and who defending
function GameRules:SetTeamObjectivesAllPlayers()
	local slots = Server:GetServerSlotMap();

	for i, slot in slots do
	    self:SetTeamObjectivesOnePlayer(slot);    
	end
end
