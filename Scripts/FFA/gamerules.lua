----------------------------------------------------------------------------------------
--FAR CRY script file
--FFA GameRules
--Created by Alberto Demichelis
--modified by MartinM
--modified by MarcoK
--modified by MarcioM
----------------------------------------------------------------------------------------
Script:LoadScript("SCRIPTS/MULTIPLAYER/VotingState.lua");
Script:LoadScript("SCRIPTS/MULTIPLAYER/MultiplayerClassDefiniton.lua");		-- global MultiplayerClassDefiniton
Script:LoadScript("scripts/FFA/shared.lua");

GameRules={
	InitialPlayerProperties = MultiplayerClassDefiniton.DefaultMultiPlayer,

	respawndelay = 3,
	timelimit=getglobal("gr_TimeLimit"),			-- might be a string/number or nil/0 when not used
	states={}
}

Script:LoadScript("SCRIPTS/MULTIPLAYER/GameRulesLib.lua");	-- derive from class bases game rules


----------------------------------------------------------------------------------------
function GameRules:ScoreboardUpdate()
	local SlotMap=Server:GetServerSlotMap();
	
	for i, Slot in SlotMap do
		local Player = GetSlotPlayer(Slot);
		
		if Player and Player.cnt then
			local ClientId = Slot:GetId();
			
			local iScore = Player.cnt.score;			
			if not iScore then
				iScore=0;
			end
		
			local iDeaths = Player.cnt.deaths;			
			if not iDeaths then
				iDeaths=0;
			end

			local iPlayerTeam = -1;

			local szTeam=Game:GetEntityTeam(Player);

			if szTeam=="spectators" then
				iPlayerTeam = 0;
			elseif szTeam=="players" then
				iPlayerTeam = 1;
			end

			local iSuicides = 0;
			if Slot.Statistics and Slot.Statistics["nSelfKills"] then
				iSuicides = Slot.Statistics["nSelfKills"];
			end
						
			self:SetScoreboardEntryXY(ScoreboardTableColumns.sName,ClientId,Slot:GetName());
			self:SetScoreboardEntryXY(ScoreboardTableColumns.iScore,ClientId,iScore);
			self:SetScoreboardEntryXY(ScoreboardTableColumns.iDeaths,ClientId,iDeaths);
			self:SetScoreboardEntryXY(ScoreboardTableColumns.iSuicides,ClientId,iSuicides);
			self:SetScoreboardEntryXY(ScoreboardTableColumns.iPlayerTeam,ClientId,iPlayerTeam);
		end
	end
end


----------------------------------------------------------------------------------------
function GameRules:OnInit()
	System:Log("$5GameRules Init: "..self:ModeDesc());
	--reset messagetrack
		MessageTrack = {};
--	for i, index in MessageTrack do
--		MessageTrack.index = nil;
--	end
	Server:RemoveTeam("players");
	e_deformable_terrain=0;
	self.mapstart = _time;
	Server:AddTeam("players");
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
function GameRules:OnAfterLoad()
	self:ResetMapEntities();	
end

-------------------------------------------------------------------------------
-- This function is called whenever the server needs to return a packet containing
-- a description of the current Game: since a "mod" can contain multiple modes, this
-- should be taken into account here. the string should be relatively short.
function GameRules:ModeDesc()
    return "FFA";
end


function GameRules:DoRestart()

	self.restartbegin = nil;
	self.restartend = nil;
	
	self.mapstart=_time

	self:ResetPlayerScores(0, 0);
	self:NewGameState(CGS_INPROGRESS);								-- is calling self:ResetMapEntities()
	-- UpdateTimeLimit has to be after NewGameState because this is reseting the leveltime
	self:UpdateTimeLimit(getglobal("gr_TimeLimit"));
end

-------------------------------------------------------------------------------
-- stats for respawning
function GameRules:GetInitialPlayerProperties(server_slot)
	return self.InitialPlayerProperties;
end




-------------------------------------------------------------------------------
-- callback for when the player uses the "team" console command
function GameRules:OnClientJoinTeamRequest(server_slot,team)
	GameRules:HandleJoinTeamRequest(server_slot,team);
	
	if(sp and sp.type=="Player")then sp.cnt.score=0; end
end





-------------------------------------------------------------------------------
-- callback for the "vote" console command, which casts an actual vote
-- if this vote causes a majority on "yes", execute the "game command"
-- that was voted on
function GameRules:OnVote(server_slot, vote)
	self.voting_state:OnVote(server_slot, vote);
end




-------------------------------------------------------------------------------
function GameRules:INPROGRESS_OnDamage(hit)
	local damage_ret=self:UsualDamageCalculation(hit);
	
	if damage_ret==3 then
		damage_ret=1;		-- there is no team kill
	end

	if damage_ret then
		local target = hit.target;
		local shooter = hit.shooter;
	
		-- we have a kill, so drop the guys weapon
		local weapon = target.cnt.weapon;
		if weapon then
			BasicWeapon.Server.Drop( weapon, {Player = target, suppressSwitchWeapon = 1} );
		end
	end
	
	local delta = self:UsualScoreCalculation(hit,damage_ret);
end


-------------------------------------------------------------------------------
function GameRules:GetTeamRespawnPoint(team,entityToIgnore)
	local pt;
	
	pt = self:GetFreeTeamRespawnPoint("players",entityToIgnore);
	if(pt)then return pt; end

	System:Error("No possible respawn points ('players')");
end

-------------------------------------------------
--PREWAR
-------------------------------------------------
GameRules.states.PREWAR={
--------------------------------
	OnBeginState=function (self)
		self:ResetReadyState(nil);
	end,
	--------------------------------
	OnClientJoinTeamRequest=GameRules.HandleJoinTeamRequest,
}
-------------------------------------------------
--INPROGRESS
-------------------------------------------------
GameRules.states.INPROGRESS={
	OnBeginState=function(self)
		GameRules:StartGameRulesLibTimer();
		GameRules:ResetMapEntities();
		self.mapstart = _time;
		local slots = Server:GetServerSlotMap();
		for i, slot in slots do
			local ent = System:GetEntity(slot:GetPlayerId());
--			if ent and ent.type=="Player" then
--				self:ChangeTeam(slot, Game:GetEntityTeam(ent.id), 1);
--			end
			slot:ResetPlayTime();
		end
	end,
--------------------------------
	OnUpdate=function(self)
		if (MapCycle:IsShowingScores()) then
			return;
		end

		if(tonumber(gr_ScoreLimit)~=0)then
			local players=GetPlayers();
			for i,val in players do
				if (val.cnt.score>=tonumber(gr_ScoreLimit)) then
					Server:BroadcastText(val:GetName().." @PlyReachedScore");
					MapCycle:OnMapFinished();	
		    	return
				end
			end		
		end
		if (self.timelimit and tonumber(self.timelimit)>0) then
			if _time>self.mapstart+tonumber(self.timelimit)*60 then
		   	Server:BroadcastText("@TimeIsUp");
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
----------------------------
	--OnClientDisconnect = GameRules.HandleClientDisconnect,
}

GameRules.states.INTERMISSION={
--------------------------------
	OnBeginState=function (self)
		self.intermissionstart = _time;
	end,
--------------------------------
	OnUpdate=function(self)
		if _time>self.intermissionstart+6 then
	    	self:GotoNextMap();
    	end
	end
}
