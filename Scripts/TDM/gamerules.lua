----------------------------------------------------------------------------------------
--FAR CRY script file
-- TDM Game Rules
--Created by Alberto Demichelis
----------------------------------------------------------------------------------------
Script:LoadScript("SCRIPTS/MULTIPLAYER/VotingState.lua");
Script:LoadScript("SCRIPTS/MULTIPLAYER/MultiplayerClassDefiniton.lua");

GameRules={
	InitialPlayerProperties = MultiplayerClassDefiniton.DefaultMultiPlayer,

	respawndelay = 3,
	countnext = 0,

	mapstart = 0,
--	autoready = nil,			-- is only used if gr_AutoReady~=0
	intermissionstart = 0,
	scoreupdate = 3000,
	timelimit=getglobal("gr_TimeLimit"),				-- might be a string/number or nil/0 when not used
	--is now in the serverscrg
	--mapcycle = { "hamster" }, -- add more map names here

	states={}
}

Script:LoadScript("SCRIPTS/MULTIPLAYER/GameRulesTeamLib.lua");	-- derive from class bases game rules


-------------------------------------------------------------------------------
--UTILITIES FUNC
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
function GameRules:OnInit()
	System:Log("$5GameRules Init: "..self:ModeDesc());
	Server:RemoveTeam("red");
	Server:RemoveTeam("blue");
	e_deformable_terrain=0;
	self.mapstart = _time;
	Server:AddTeam("red");
	Server:AddTeam("blue");	
	CreateStateMachine(self);
	self.voting_state=VotingState:new();
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
		local PlayerEnt = System:GetEntity(Slot:GetPlayerId());
		local Score = 0;
		
		if (PlayerEnt and PlayerEnt.cnt) then
			Score = PlayerEnt.cnt.score;
		end
		
		Player.Name = Slot:GetName();
		Player.Team = Game:GetEntityTeam(Slot:GetPlayerId());
		Player.Skin = "";
		Player.Score = Score;
		Player.Ping = Slot:GetPing();
		Player.Time = floor(Slot:GetPlayTime() / 60).."m";

		j = j + 1;
	end

	return Stats;
end

-------------------------------------------------------------------------------
function GameRules:GetPlayerScoreInfo(ServerSlot, Stream)
	if (not ServerSlot.Statistics) then
		ServerSlot.Statistics = GameRules:GetInitialPlayerStatistics();
	end

	local iSuicides = 0;	
	
	if (ServerSlot.Statistics["nSelfKills"]) then
		iSuicides = ServerSlot.Statistics["nSelfKills"];
	end

	local Player = System:GetEntity(ServerSlot:GetPlayerId());

	Stream:WriteBool(0);		-- not extended
	Stream:WriteShort(ServerSlot:GetPlayerId());
	Stream:WriteShort(Player.cnt.score);
	Stream:WriteShort(Player.cnt.deaths);
	Stream:WriteByte(GameRules:CalcEfficiency(Player.cnt.score, Player.cnt.deaths, iSuicides));
	Stream:WriteShort(ServerSlot:GetPing()*2);
end



-------------------------------------------------------------------------------
function GameRules:OnAfterLoad()
	self:ResetMapEntities();	
end

-------------------------------------------------------------------------------
-- This function is called whenever the server needs to return a packet containing
-- a description of the current Game: since a "mod" can contain multiple modes, this
-- should be taken into account here. the string should be relatively short.
function GameRules:ModeDesc()
    return "TDM";
end


function GameRules:DoRestart()

	self.restartbegin = nil;
	self.restartend = nil;

	self.mapstart=_time
	self.countnext=0;

	Server:SetTeamScore("blue",0);
 	Server:SetTeamScore("red",0);
 	
 	self:ResetPlayerScores(0, 0);
	self:NewGameState(CGS_INPROGRESS);									-- is calling self:ResetMapEntities()
	-- UpdateTimeLimit has to be after NewGameState because this is reseting the leveltime
	self:UpdateTimeLimit(getglobal("gr_TimeLimit"));
end

-------------------------------------------------------------------------------
-- stats for respawning
function GameRules:GetInitialPlayerProperties(server_slot)
	if (MainPlayerEquipPack) then
		self.InitialPlayerProperties.equipEquipment = MainPlayerEquipPack;
	end

	return self.InitialPlayerProperties;
end







-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function GameRules:INPROGRESS_OnDamage(hit)
	local damage_ret=self:UsualDamageCalculation(hit);
	
	if (damage_ret ~= nil) then
		-- we have a kill, so drop the guys weapon
		local target = hit.target;
		local weapon = target.cnt.weapon;
		if (weapon) then
			BasicWeapon.Server.Drop( weapon, {Player = target, suppressSwitchWeapon = 1} );
		end
	end
	
	local delta = self:UsualScoreCalculation(hit,damage_ret);
	if (delta~=nil) then

		local team = nil;
		
		if(hit.weapon)then
			team = hit.weapon.LaunchedByTeam;
		end

		if not team then
			if hit.shooter then 
				team = Game:GetEntityTeam(hit.shooter.id);
			end
		end
		
		if team then			-- team might be nil (e.g. vehicle explosion killed player)
			Server:SetTeamScore(team,Game:GetTeamScore(team)+delta); -- Player's score directly affects team score
		end
	end
end


-------------------------------------------------------------------------------
function GameRules:GetTeamRespawnPoint(team,entityToIgnore)

	local pt;

	pt = self:GetFreeTeamRespawnPoint(team,entityToIgnore);
	if(pt)then return pt; end
	
	pt = self:GetFreeTeamRespawnPoint("players",entityToIgnore);
	if(pt)then return pt; end

	System:Error("No possible respawn points ('red'/'blue' or 'players')");
end



function GameRules:HandleClientDisconnect(server_slot)
	--self:CheckPlayersCount();
end
-------------------------------------------------
--PREWAR
-------------------------------------------------
GameRules.states.PREWAR={
--------------------------------
	OnBeginState=function (self)
--		if(tonumber(gr_AutoReady)~=0)then
--			self.autoready=_time;
--			self.autoreadynotif=tonumber(gr_AutoReadyTime)*60;
--			Server:BroadcastText("$1the game will start automatically in $3"..(tonumber(gr_AutoReadyTime)*60).."$1 sec");
--		else
--			Server:BroadcastText("$1waiting for ready players(type $2'ready' $1in the console)")
--			self.autoready=0;
--		end
		self:ResetReadyState(nil);
		
	end,
	--------------------------------
	OnUpdate=GameRules.PREWAR_Team_OnUpdate,
	--------------------------------
	OnClientJoinTeamRequest=GameRules.HandleJoinTeamRequest,
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
	OnClientJoinTeamRequest=GameRules.HandleJoinTeamRequest,
--------------------------------
	OnClientDisconnect = GameRules.HandleClientDisconnect,
}
-------------------------------------------------
--INPROGRESS
-------------------------------------------------
GameRules.states.INPROGRESS={
--------------------------------
	OnBeginState=function (self)
		--System:Log("OnBeginState");
		GameRules:StartGameRulesLibTimer();		
		GameRules:ResetMapEntities();

		Server:SetTeamScore("blue",0)
    Server:SetTeamScore("red",0)
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
		if (self.timelimit and tonumber(self.timelimit)>0) then
			if _time>self.mapstart+tonumber(self.timelimit)*60 then
    		MapCycle:OnMapFinished();
    	end
	  end
	end,
--------------------------------
	OnTimer=function(self)
		self:DoGameRulesLibTimer();		
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
	OnClientJoinTeamRequest=GameRules.HandleJoinTeamRequest,
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
--
----------------------------------------------------------------------------------



