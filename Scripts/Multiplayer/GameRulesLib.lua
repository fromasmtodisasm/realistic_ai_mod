Script:LoadScript("Scripts/Multiplayer/SVcommands.lua");
Script:LoadScript("Scripts/Multiplayer/SVplayerTrack.lua");
Script:LoadScript("SCRIPTS/Multiplayer/Task.lua");


------------------------------------------------------------------------
--	Helper functions for GameRules implementation
--
--	created by Alberto
--  modified by MartinM
-------------------------------------------------------------------------

-- teams:
--
-- players
-- spectators

-- If someone in script needs to know if we are running multiplayer or single player game.
GameRules.bMultiplayer = 1;
GameRules.bSingleplayer = nil;
GameRules.bIsTeamBased = nil;

CGS_INPROGRESS = 0;
CGS_COUNTDOWN = 1;
CGS_PREWAR = 2;
CGS_INTERMISSION = 3;

GameRules.states_map=
{
	[CGS_INPROGRESS] ="INPROGRESS",
	[CGS_COUNTDOWN] ="COUNTDOWN",
	[CGS_PREWAR] ="PREWAR",
	[CGS_INTERMISSION] = "INTERMISSION",
}
GameRules.TeamText = {red = "$4Red Team", blue = "$2Blue Team", players = "@TeamNamePlayers", spectators = "$3Spectators",};

GameRules.RespawnPoints={};										-- {[1]={x=,y=,z=,xA=,yA=,zA=,name=,lastUsedTime=},} use RecreateTableOfRespawnPoints(), lastUsedTime might be nil
GameRules.idCurrentMissionObject=nil;					-- used to make only one MissionObject entity active at a time
GameRules.idScoreboard=nil;										-- scoreboard entity id

if not GameRules.InitialPlayerStatistics then
	GameRules.InitialPlayerStatistics = {};			-- used for MP statistics but can be used for SP as well
end


GameRules.InitialPlayerStatistics["nKill"]=0;					-- this entry can be used by MPStatistics:AddStatisticsDataEntity();
GameRules.InitialPlayerStatistics["nSelfKill"]=0;			-- this entry can be used by MPStatistics:AddStatisticsDataEntity();
GameRules.InitialPlayerStatistics["nBulletShot"]=0;		-- this entry can be used by MPStatistics:AddStatisticsDataEntity();
GameRules.InitialPlayerStatistics["nBulletHit"]=0;			-- this entry can be used by MPStatistics:AddStatisticsDataEntity();
GameRules.InitialPlayerStatistics["nHeadshot"]=0;			-- this entry can be used by MPStatistics:AddStatisticsDataEntity();


-- e.g. GameRules.ClientCommandTable["CPC"]=function(...
if not GameRules.ClientCommandTable then
	GameRules.ClientCommandTable={};				-- used from OnClientCmd() to process commands on the server from the client
end

--[new playertracking]
SVplayerTrack:Init();
--[end]

--------------------------------------------------------------------
-- Return Server Rules Table from 1..n
-- Each Rule is a table from 1..2 with 1=rulename 2=value
--------------------------------------------------------------------
function GameRules:GetServerRules()
	function PushRule(RuleTable, Rule)
		tinsert(RuleTable, {Rule, getglobal(Rule),});
	end

	local Rules = {};
	PushRule(Rules, "gr_ScoreLimit");
	PushRule(Rules, "gr_TimeLimit");
	PushRule(Rules, "gr_DamageScale");
	PushRule(Rules, "gr_HeadshotMultiplier");
	PushRule(Rules, "gr_RespawnTime");
	PushRule(Rules, "gr_PrewarOn");
	PushRule(Rules, "gr_DropFadeTime");
	PushRule(Rules, "gr_FriendlyFire");
	PushRule(Rules, "gr_MinTeamLimit");
	PushRule(Rules, "gr_MaxTeamLimit");
	PushRule(Rules, "gr_InvulnerabilityTimer");	

	PushRule(Rules, "gr_NextMap");
	PushRule(Rules, "gr_DedicatedServer");
	
	PushRule(Rules, "sv_punkbuster");
	
	return Rules;
end


-------------------------------------------------------------------------------
--
function GetSlotPlayer(slot)
    return System:GetEntity(slot:GetPlayerId());
end

-------------------------------------------------------------------------------
--
function GameRules:GetPlayerScoreInfo(ServerSlot, Stream)
	Stream:WriteByte(ServerSlot:GetId());
	Stream:WriteShort(ServerSlot:GetPing()*2);
end

-------------------------------------------------------------------------------
--
function DeletePlayer(id)
--	System:Log("DeletePlayer("..tostring(id)..")");
	if(id and id~=0)then
		Server:RemoveFromTeam(id);
		Server:RemoveEntity(id);
	end
end

-------------------------------------------------------------------------------
--
function GetPlayers()
	local players={}
	local slots=Server:GetServerSlotMap()
	for i, slot in slots do
	    local ent = System:GetEntity(slot:GetPlayerId());
		if ent and ent.type=="Player" then
		   players[ent.id]=ent;
		end
	end
	return players;
end



-------------------------------------------------------------------------------
--
function GameRules:Restart(x, quiet)
	local rrtime = 1;

	if(tonumber(x))then						-- can be converted to a number
		rrtime = tonumber(x);
	end
	
	self.restartbegin = _time;
	self.restartend = _time + rrtime;
	
	if (not quiet) then
		Server:BroadcastText("@GameRestartIn $3"..rrtime.."$o @GameStartingInSeconds", 1);
	end
end

-------------------------------------------------------------------------------
--
function GameRules:SetPlayerTimeLimit(Slot)
	local bReady = Slot:IsContextReady();
	
	if (bReady and tonumber(bReady) ~= 0) then
		local dam=format("%.2f", tonumber(self.timelimit));

		Slot:SendCommand("UTL "..dam);
	end
end


-------------------------------------------------------------------------------
--
function GameRules:UpdateTimeLimit(timelimit)
	self.timelimit = timelimit;
	
	local SlotMap = Server:GetServerSlotMap();
	
	for i, Slot in SlotMap do
		self:SetPlayerTimeLimit(Slot);
	end
end

-------------------------------------------------------------------------------
-- force scoreboard on all players
function GameRules:ForceScoreBoard(yes)
	local SlotMap = Server:GetServerSlotMap();

	for i, Slot in SlotMap do
		Game:ForceScoreBoard(Slot:GetPlayerId(), yes);
	end
end

-------------------------------------------------------------------------------
-- multicast the gamestate (one of the CGS_* above)
function GameRules:NewGameState(state)
	local slots = Server:GetServerSlotMap();
	
	for i, slot in slots do
		slot:SetGameState(state, _time-self.mapstart);
  end
  
--  System:Log("self:GotoState("..self.states_map[state]..");");
 	self:GotoState(self.states_map[state]);
end

-------------------------------------------------------------------------------
-- stats for respawning
--function GameRules:GetInitialPlayerProperties(server_slot)
--	return self.InitialPlayerProperties;
--end


-------------------------------------------------------------------------------
-- spawn a new player and put it in back in a team
-- custom properties can be nil(if the mod is not class based)
function GameRules:SpawnPlayer(server_slot,classid,team,custom_properties)

	--create a new player entity(in this MOD it always connect as spectator)
--	if(team)then
--		System:Log("GameRules:SpawnPlayer team="..team)
--	end
	SVplayerTrack:OnRespawn(server_slot);
	SVplayerTrack:SetBySs(server_slot, "lastteam", team, 0);
	
	local locInitialPlayerProperties=self:GetInitialPlayerProperties(server_slot);
	if locInitialPlayerProperties then
		SVplayerTrack:SetBySs(server_slot, "lastclass", locInitialPlayerProperties.sPlayerClass, 0);
	end
	local _model = server_slot:GetModel();
	local team_color;
	local rp;


	-- make sure to reset viewlayers
--	server_slot:SendCommand("GI WS");		-- Only do this once in OnAfterSpawnEntity

	if(team=="spectators") then				
		rp=Server:GetRandomRespawnPoint(team);
		if(rp==nil)then
			rp = Server:GetRandomRespawnPoint();
			if (rp==nil) then
				System:Log("GameRules:SpawnPlayer spawnpoints are missing")
				rp = {x=0, y=0, z=0, xA=0, yA=0, zA=0};
			else
				System:Log("GameRules:SpawnPlayer spawnpoints for '"..team.."' are missing")
			end
		end
	else	-- not "spectators"
		rp=self:GetTeamRespawnPoint(team,System:GetEntity(server_slot:GetPlayerId()));	--NOTE GetTeamRespawnPoint has to be implemented in the gamerules for each team MOD
		if (rp==nil) then
			System:Log("GameRules:SpawnPlayer haven't found a TeamRespawnPoint")
			rp=Server:GetRandomRespawnPoint();
			if (rp==nil) then
				rp={x=0, y=0, z=0, xA=0, yA=0, zA=0};
			end
		end

		if locInitialPlayerProperties and locInitialPlayerProperties.model then
			_model=locInitialPlayerProperties.model;
		end

		if(team=="red")then
			team_color={1,0,0};
		elseif(team=="blue")then
			team_color={0,0,1};
		end
	end
	
	if(not team_color)then
	
		local sColor=tonumber(server_slot:GetColor())+1;			-- [0|1|2|3|4|5|6|7|8|9]
		
		team_color = MultiplayerUtils.ModelColor[sColor];
		
		if (not team_color) then
			team_color = {0,0,0};
		end
--		System:Log("sColor = "..sColor);
	end
	
--	System:Log("***********************************************");
--	dump(team_color);
		
    -- TODO: replace randomness by actual collision detection
	local pos = {x = rp.x, y = rp.y, z = rp.z};
	local ang = {x = rp.xA, y = rp.yA, z = rp.zA};
	
	local sEntName=server_slot:GetName();
	
	local newent=Server:SpawnEntity({
		classid=classid,
		name=sEntName,
		pos=pos,
		angles=ang,
		model=_model,
		color=team_color,
		properties=custom_properties
	})
	
	local oldid=server_slot:GetPlayerId();

	--bind the new created player to the serverslot
	server_slot:SetPlayerId(newent.id);
	
	--delete the old player entity
	if oldid~=0 then
		DeletePlayer(oldid);
	end
	
	local debug=GetSlotPlayer(server_slot);
	if debug~=newent then
		error.error=1;
	end
	
	self:OnAfterSpawnEntity(server_slot);	
	Game:ForceScoreBoard(newent.id, 0);
	
	return newent;
end


-------------------------------------------------------------------------------
-- is updating GameRules.RespawnPoints
function GameRules:RecreateTableOfRespawnPoints()
	GameRules.RespawnPoints={};
	local i=1;
	
--	System:Log("RecreateTableOfRespawnPoints");--debug

	-- spawn at the first unoccupied tagpoint
	local pt = Server:GetFirstRespawnPoint();

	while(pt)do
		local entry=new(pt);
		GameRules.RespawnPoints[i] = entry;
		i=i+1;
		
--		System:Log("RecreateTableOfRespawnPoints "..i);--debug

		pt=Server:GetNextRespawnPoint();
	end	
end


-------------------------------------------------------------------------------
function GameRules:GetFreeTeamRespawnPoint(team,entityToIgnore)
	local respawnPoint=nil;
	local isPointExisting=0;
	local dz=0; -- Used to raise the spawn posititions if all checkpoints are full

	local ents=System:GetEntities();		-- very inefficient, needed for IsIntersectingPlayerOrVehicle

--	System:Log("GetFreeTeamRespawnPoint -------------------------");--debug

	-- Repeat until we find a point
	while (respawnPoint==nil) do
		-- spawn at the first unoccupied tagpoint
		
		for key,pt in GameRules.RespawnPoints do
			if(pt.name==team)then
				isPointExisting=1;
--				pt.z = pt.z + dz;
--				System:Log("GetFreeTeamRespawnPoint ...");--debug
--				dump(pt);	--debug
				if(GameRules:IsIntersectingPlayerOrVehicle(pt.x, pt.y, pt.z+dz, ents, entityToIgnore)==0)then
--					System:Log("IsIntersectingPlayerOrVehicle =0");	--debug
					if(respawnPoint)then
						if(respawnPoint.lastUsedTime and (not pt.lastUsedTime or pt.lastUsedTime<respawnPoint.lastUsedTime))then 
							respawnPoint = pt;		-- found a better one
--							System:Log("IsIntersectingPlayerOrVehicle a");	--debug
						end
					else
						respawnPoint = pt;		-- I found the first acceptable
--						System:Log("IsIntersectingPlayerOrVehicle b");	--debug
					end
				end
			end
		end	

		if(respawnPoint)then
			respawnPoint.lastUsedTime=_time;

			respawnPoint = new(respawnPoint);		-- create a copy because we will change the point
			respawnPoint.z=respawnPoint.z+dz;

			return respawnPoint;
		end

		if(isPointExisting==0)then
			return nil;				-- there is no spawnpoint for this team
		end
	
		-- all points full!  Raise up a bit
		dz=dz+2;
		
		if(dz>20)then
			System:Error("GameRules:GetFreeTeamRespawnPoint "..tostring(team).." failed");
			return nil;				-- to prevent endless loop
		end;	
	end

	return respawnPoint;
end

-------------------------------------------------------------------------------
-- returns the number of intersecting players at a particular point
function GameRules:IsIntersectingPlayerOrVehicle(x,y,z, ents, entityToIgnore)

	for i, entity in ents do
		if (entity~=entityToIgnore and entity.type=="Player") then

			local pos = entity:GetPos();
			local _dx=pos.x-x;
			local _dy=pos.y-y;
			local _dz=pos.z-z;
			-- if the entity is closer than 1 meter then consider it intersecting
			if (((_dx * _dx) + (_dy * _dy) + (_dz * _dz)) < 1) then
				return 1;
			end;
			
		elseif (entity.type=="Vehicle") then
			local bbox=entity:GetBBox();
			local min=bbox.min; local max=bbox.max;
			if (x > min.x and x < max.x and
					y > min.y and y < max.y and
					z > min.z and z < max.z) then
						return 1;

			end
		end
	end
	
	return 0;
end

-------------------------------------------------------------------------------
--
function GameRules:OnAfterSpawnEntity( server_slot )

	local newent=GetSlotPlayer(server_slot);
		
	if newent.type=="Player" then
	
		local locInitialPlayerProperties=self:GetInitialPlayerProperties(server_slot);
		
		--set the default stats
		if locInitialPlayerProperties then
			newent.cnt.health			= locInitialPlayerProperties.health;
			newent.cnt.max_health	= locInitialPlayerProperties.health;
			newent.cnt.armor			= locInitialPlayerProperties.armor;		
			newent.cnt.fallscale			= locInitialPlayerProperties.fallscale;	

			if locInitialPlayerProperties.StaminaTable then
				newent.cnt:InitStaminaTable( locInitialPlayerProperties.StaminaTable );
			end	
			if locInitialPlayerProperties.DynProp then
				newent.cnt:SetDynamicsProperties( locInitialPlayerProperties.DynProp );
			end

			if locInitialPlayerProperties.move_params then
				newent.cnt:SetMoveParams( locInitialPlayerProperties.move_params );
			end	
			
			newent.Properties.equipEquipment = locInitialPlayerProperties.equipEquipment;
			-- have to make a copy of the table at this point, because otherwise when the
			-- initial player properties change (class change, but before spawn) these
			-- changes will alias to Properties.equipEquipment and we won't know what stuff
			-- the player has anymore
			newent.currentEquipment = new(EquipPacks[newent.Properties.equipEquipment]);
			newent.sCurrentPlayerClass=locInitialPlayerProperties.sPlayerClass;		-- to identify class name
			
			-- your class is now <MultiplayerClassDefiniton.PlayerClasses>
			if locInitialPlayerProperties.sPlayerClass then
				Server:BroadcastCommand("YCN "..server_slot:GetPlayerId().." "..locInitialPlayerProperties.sPlayerClass);
			else
				Server:BroadcastCommand("YCN "..server_slot:GetPlayerId().." DefaultMultiPlayer");
			end

			BasicPlayer.InitAllWeapons(newent, 1);	-- because equipEquipment has changed
		end
			
		if (gr_InvulnerabilityTimer~=nil and toNumberOrZero(gr_InvulnerabilityTimer)>0) then
--			System:Log("Player "..newent:GetName().." spawned, activated invulnerbility");
			newent.invulnerabilityTimer=toNumberOrZero(gr_InvulnerabilityTimer);
			-- turn on invulnerability shader
--			System:Log("FX: Setting invulnerability shader: "..tostring(newent.name));
			Server:BroadcastCommand("FX", g_Vectors.v000, g_Vectors.v000, newent.id, 2);
		end
	
		newent.cnt.alive=1;
		newent:EnablePhysics(1);

		-- we would like its viewdistratio to be max (== 255)
		newent:SetViewDistRatio(255);
		
		if (team~="spectators") then
			if self.bShowUnitHightlight then
				local highlightpos=new(newent:GetPos());
				local highlight = Server:SpawnEntity("UnitHighlight",highlightpos);
			
				newent.idUnitHighlight = highlight.id;		-- only done on the server
			
				-- send "follow this player" command
				Server:BroadcastCommand("FX "..tonumber(newent.id), g_Vectors.v000, g_Vectors.v000,highlight.id,0);
			end
			-- deactivate radar enemies
			server_slot:SendCommand("HUD RR");		
		end

		-- reset viewlayers
		server_slot:SendCommand("GI WS");				
	end
end

function GameRules:GetPlayerTeamCount( team )
	local ret=0;
	local slots = Server:GetServerSlotMap();

	for i, slot in slots do
		local player_id=slot:GetPlayerId();

		if Game:GetEntityTeam(player_id)==team then
			ret=ret+1;
		end
	end

	return ret;
end

-------------------------------------------------------------------------------
-- called to change the team for a client, either because the mode has
-- changed, or the player hAs requested so manually (OnClientJoinTeamRequest).
-- the change may be denied if required
function GameRules:ChangeTeam(server_slot, new_team, force)
	
	--[new punished players cannot change team]
	if SVcommands:requestSpawn(server_slot)==0 then
                --System:Log("new punished players cannot change team");
		--return;
	end

	if toNumberOrZero(getglobal("gr_allow_spectators"))==0 then
		if new_team=="spectators" then
			server_slot:SendText("Spectating is not allowed in this game");
			return;	
		end
	end
		
	--[end]
	local player_id = server_slot:GetPlayerId();
	local requested_classid = PLAYER_CLASS_ID;
	
	if player_id ~= 0 then
		local player = System:GetEntity(player_id);
		local old_team = Game:GetEntityTeam(player_id);
					
		if force or new_team ~= old_team then
			--System:Log("player '"..tostring(server_slot:GetName()).."$1' changed team from "..tostring(old_team).." to "..tostring(new_team));

   		if new_team=="spectators" then
				requested_classid=SPECTATOR_CLASS_ID;
				
				if (self.respawnList) then
					self.respawnList[server_slot] = nil;
				end

				local newEntity=self:SpawnPlayer(server_slot,requested_classid,new_team);
				Server:AddToTeam("spectators",newEntity.id);

				return;
			end

			if (self.respawnList and  (self:GetGameState() ~= CGS_PREWAR)) then
--				System:Log("changing team! "..new_team.." team!");
				self.respawnList[server_slot] = {classid = requested_classid, team = new_team,};
			else
				local newEntity=self:SpawnPlayer(server_slot,requested_classid,new_team);
				Server:AddToTeam(new_team, newEntity.id);
				
				if (self.SetTeamObjectivesOnePlayer) then
					self:SetTeamObjectivesOnePlayer(server_slot);
				end
					
				if (self.UpdateCaptureProgressOnePlayer) then
					self:UpdateCaptureProgressOnePlayer(server_slot);
				end				
			end
		end
	else
        	--System:Log("player_id == 0");
        end
end

function GameRules:GetTeamMemberCountRL(team)	
	local iCount = 0;	
	
	if (self.respawnList) then
		local Slots = Server:GetServerSlotMap();
		
		for i,ServerSlot in Slots do
		
			local RespawnInfo = self.respawnList[ServerSlot];
			local szPlayerTeam;
			
			if (not RespawnInfo) then
				szPlayerTeam = Game:GetEntityTeam(ServerSlot:GetPlayerId());
			else
				szPlayerTeam = RespawnInfo.team;
				
				if (not szTeam) then
					szPlayerTeam = Game:GetEntityTeam(ServerSlot:GetPlayerId());
				end
			end
			
			if (team == szPlayerTeam) then
				iCount = iCount + 1;
			end
		end
	else
		iCount = iCount + Server:GetTeamMemberCount(team);
	end

	return iCount;
end


-------------------------------------------------------------------------------
function GameRules:HandleJoinTeamRequest(server_slot,new_team)
	--[new start]
	
	--player got some kinda respawn punishment
	if SVcommands:requestSpawn(server_slot)==0 then
		return;
	end
	
	if toNumberOrZero(getglobal("gr_allow_spectators"))==0 then
		if new_team=="spectators" then
			server_slot:SendText("Spectating is not allowed in this game");
			return;
		end
	end
			
	--first, check if player is forced to 1 team
	local forcedTeam=SVplayerTrack:GetBySs(server_slot, "forcedteam");
	
	if forcedTeam ~="" then 
		if new_team~="spectators" then
			new_team=forcedTeam;
			Server:BroadcastText(server_slot:GetName().."$o is not allowed to be in other team than "..new_team);
		end
	end
	
	--check for global teamforcing
	if forcedTeam == "" then
		if toNumberOrZero(getglobal("gr_forcebluejoin")) == 1 and SVcommands:ProtectedName(server_slot:GetName())~=1 then
			if new_team == "red" then
				new_team = "blue";
				Server:BroadcastText(server_slot:GetName().."$o cannot join ($4Red Team $o is locked)");
			end  
		end
		if toNumberOrZero(getglobal("gr_forceredjoin")) == 1 and SVcommands:ProtectedName(server_slot:GetName())~=1 then
			if new_team == "blue" then
				new_team = "red";
				Server:BroadcastText(server_slot:GetName().."$o cannot join ($2Blue Team $o is locked)");
			end		
		end
	end
	--[end]
	
	local maxplayers = toNumberOrZero(getglobal("gr_MaxTeamLimit"));
	
	if (maxplayers and maxplayers > 0 and self.bIsTeamBased) then
		if new_team~="spectators" and self:GetPlayerTeamCount(new_team)>=maxplayers then
	  	Server:BroadcastText("@ReachedMaxTeam "..GameRules.TeamText[new_team]);
			return;
		end
	end
	----
	self:ChangeTeam(server_slot,new_team, nil);
	
	if(new_team=="spectators" or new_team=="players")then
	  Server:BroadcastText(server_slot:GetName().."$o @HasJoinedThe "..GameRules.TeamText[new_team]);
	else
	  Server:BroadcastText(server_slot:GetName().."$o @HasJoinedThe "..GameRules.TeamText[new_team]);
	end

	--clear out any TK stuff from the slot.
	if (SVcommands:TKActive(server_slot:GetId())==1) then
		SVcommands:TKVerdict(server_slot:GetId(),0,-1);
	end

  server_slot:Ready(nil);
  server_slot:ResetPlayTime();
end


-------------------------------------------------------------------------------
function GameRules:ResetReadyState(state)
	local slots = Server:GetServerSlotMap();
	for i, slot in slots do
		slot:Ready(state);
	end
end


-------------------------------------------------------------------------------
--return a non nil value if the slot has a "player entity" assigned to him
function IsPlayer(slot)
    return System:GetEntity(slot:GetPlayerId()).type=="Player";
end


-------------------------------------------------------------------------------
-- callback for when the player uses the "team" console command
function GameRules:OnClientJoinTeamRequest(server_slot,team_name)
	self:Invoke("OnClientJoinTeamRequest",server_slot,team_name);
end



-------------------------------------------------------------------------------
function GameRules:GetGameState()
	local curstate=self:GetState();
	for i,val in self.states_map do
		if(val==curstate)then
			return i
		end
	end
end


-------------------------------------------------------------------------------
-- clean up when a client leaves
function GameRules:OnClientDisconnect( server_slot )
	-- this must be called before the player is deleted,
	-- because we might want to do some processing on player data	
	
	--[new store last used name]
	SVplayerTrack:SetBySs(server_slot,"name",server_slot:GetName(),0);
	--[end]
	
	self:Invoke("OnClientDisconnect",server_slot);

	Server:BroadcastText(server_slot:GetName().."$o @HasLeftGame");
	--remove the player from the team
	--remove the entity
	local player_id = server_slot:GetPlayerId();
	server_slot:SetPlayerId(0); -- set an invalid player id
	DeletePlayer(player_id);
	
	self:RemovePlayerFromScoreboard(server_slot:GetId());
	
end

-------------------------------------------------------------------------------
-- first time connect, mod can decide how to add the new client to the
-- game (spectator or not, etc). needs to spawn new entity.
function GameRules:OnClientConnect( server_slot, requested_classid )

	local newPlayer=self:SpawnPlayer(server_slot,SPECTATOR_CLASS_ID,"spectators");
	
	--inform player about current game state
	server_slot:SetGameState(self:GetGameState(), _time-self.mapstart);
	server_slot:Ready(nil);
	server_slot:ResetPlayTime();

	Server:BroadcastText(server_slot:GetName().."$o @HasConnected");

	Server:AddToTeam("spectators",newPlayer.id);
	
	local pt;
	pt=Server:GetRandomRespawnPoint("spectators")
	if(pt==nil)then
		pt = Server:GetFirstRespawnPoint();
		System:Log("ERROR: Spawn points for 'spectators' are missing, please check your map");
		if (pt==nil) then
			System:Log("ERROR: There are no spawn points");
			pt = {x=0, y=0, z=0, xA=0, yA=0, zA=0};
		end
	end
	
	newPlayer:SetPos(pt);	
	newPlayer:SetAngles({x=pt.xA, y=pt.yA, z=pt.zA});

	if self.bShowUnitHightlight then
		-- send "follow this player" command to the UnitHightlight objects
	  local slots = Server:GetServerSlotMap();
		for i, slot in slots do
	    local ent = System:GetEntity(slot:GetPlayerId());
	    
	    if ent and ent.idUnitHighlight then
				server_slot:SendCommand("FX "..tonumber(ent.id), g_Vectors.v000, g_Vectors.v000,ent.idUnitHighlight,0);
			end
	 	end
	end

	if floor(toNumberOrZero(getglobal("gr_RespawnTime")))~=0 and self.respawnCycle then
		server_slot:SendCommand("RTR "..tostring(self.respawnCycleTimer));
	end
	
	if (self.SetPlayerTimeLimit) then
		self:SetPlayerTimeLimit(server_slot);
	end
	
	-- update the teamcoloring/invulnerability shader for the player entities on the client that just connected
	local SlotMap = Server:GetServerSlotMap();
--	System:Log("Sending Team Color To "..server_slot:GetName().."...");
	
	for i, Slot in SlotMap do
		local Player = GetSlotPlayer(Slot);
		
		if (Player and Player.ApplyTeamColor) then
			if (not Player.invulnerabilityTimer or (Player.invulnerabilityTimer and Player.invulnerabilityTimer <= 0)) then
				-- this player is not invulnerable
				--System:Log("Player "..Slot:GetName().." is teamcolored!")	;				
				server_slot:SendCommand("FX", g_Vectors.v000, g_Vectors.v000, Slot:GetPlayerId(), 1);
			else
				-- this player is invulnerable
				--System:Log("Player "..Slot:GetName().." is invulnerable!");				
				server_slot:SendCommand("FX", g_Vectors.v000, g_Vectors.v000, Slot:GetPlayerId(), 2);
			end
		end
	end
	
	self:AddPlayerToScoreboard(server_slot:GetId());
	--[new playertracking]
	--player login 
	SVplayerTrack:OnConnect(server_slot);  
	--[end]
	
end


-------------------------------------------------------------------------------
function GameRules:OnUpdate()
	if (toNumberOrZero(getglobal("gr_static_respawn")) > 0) then
		SVplayerTrack:CheckRespawn();
	end
	--[new - high ping kick]
	if (toNumberOrZero(getglobal("gr_max_average_ping")) > 0) then
		local interval = toNumberOrZero(getglobal("gr_ping_check_interval"));
		local lastchecked = toNumberOrZero(getglobal("gr_last_checked"));
		--
		local tnow=_time;
		if (lastchecked > tnow) then 
			lastchecked=0;
		end
		if ((tnow-lastchecked) > interval) then
			--System:Log("checking "..tnow.." .. "..lastchecked); 
			lastchecked = tnow-0.01;
			SVplayerTrack:DoPingKick();
			setglobal("gr_last_checked",lastchecked);
		end
	end
	--
	-- autokick crashed ppl (listed as 'connecting' in gr_listplayers)
	local maxconnect = toNumberOrZero(getglobal("gr_autokick_connecting"));
	if maxconnect > 0 then
		local tnow=_time;
		local lastConnectCheck=toNumberOrZero(getglobal("gr_lastConnectCheck"));
		if (tnow-lastConnectCheck) > 5 then  --check every 5 seconds
			setglobal("gr_lastConnectCheck",tnow);
			local Slots = Server:GetServerSlotMap();
			for i,ServerSlot in Slots do
				local playerId = ServerSlot:GetPlayerId();
				local player = System:GetEntity(playerId);
				--System:LogAlways("checking : "..tostring(ServerSlot)); --xxx
				if not (player) then
					local connectcheck=SVplayerTrack:GetBySs(ServerSlot,"connectcheck");
					if connectcheck==0 then
						SVplayerTrack:SetBySs(ServerSlot,"connectcheck",tnow);
						--System:LogAlways("initialising connect"..tostring(ServerSlot));  --xxx
					else
						if (tnow-connectcheck)>maxconnect then
							GameRules:KickSlot(ServerSlot);
							System:LogAlways(" $4Kicking id "..playerId.." due to connection timeout");
							SVplayerTrack:SetBySs(ServerSlot,"connectcheck",0,0);
						end
					end
				else
					SVplayerTrack:SetBySs(ServerSlot,"connectcheck",0,0);
					--System:LogAlways("resetting time "..tostring(ServerSlot)); --xxx
				end
			end

		end
	end
	--[end]
	--statemachine update
	if (toNumberOrZero(getglobal("gr_TimeLimit")) > 999) then
		setglobal("gr_TimeLimit", 999);
	end
	if (toNumberOrZero(getglobal("gr_TimeLimit")) < 0) then
		setglobal("gr_TimeLimit", 0);
	end
	self:CheckPlayerCount();		-- might go to PREWAR or back when min player count is not ok

	if (self.restartbegin and (_time >= floor(self.restartend))) then
		self.restartbegin = nil;
		self.restartend = nil;
		self:DoRestart();
	end

	self:Update();
	MapCycle:Update();
	
	if GameRules.ScoreboardUpdate	then
		GameRules:ScoreboardUpdate();
	else
		System:Log("ERROR: GameRules:ScoreboardUpdate() not implemented");
	end
end


-------------------------------------------------------------------------------
-- player requests to be killed (typed in the "kill" console command)
function GameRules:OnKill(server_slot)
	self:Invoke("OnKill",server_slot);
end


-------------------------------------------------------------------------------
-- called for every damage on every player, so should be relatively efficient
-- most of a mods specific quirks are likely to go in here
function GameRules:OnDamage( hit )

--  System:Log("Lib GameRules:OnDamage");
  
  local theTarget = hit.target;
  local theShooter = hit.shooter;
   
  if (theTarget and theTarget.type == "Player" and theTarget.invulnerabilityTimer~=nil and  theTarget.invulnerabilityTimer>0) then
--	System:Log("Player "..theTarget:GetName().." is invulnerable, no damage is applied");
  	return -- Player is invulnerable, don't accept damage
  end
      
	self:Invoke("OnDamage",hit);
end


-------------------------------------------------------------------------------
-- called from the map reloading process
-- gamerules.lua is reloaded and thus reset before this is called
function GameRules:OnMapChange()

	-- reset chat protection table
--	for i, index in MessageTrack do
--		MessageTrack.index = nil;
--	end
	--System:Log("reset message track");

	System:Log("GameRules:OnMapChange");

	if tostring(getglobal("gr_PrewarOn")) ~= "0" then
		self:NewGameState(CGS_PREWAR);
	else
		self:NewGameState(CGS_INPROGRESS);
	end
	
	if (MapCycle) then
		MapCycle:OnMapChanged();
	end
	
	self:RecreateTableOfRespawnPoints();		-- update GameRules.RespawnPoints

	self:CreateScorebordEntity();
end


-------------------------------------------------------------------------------
function GameRules:CreateScorebordEntity()
	-- create only if needed
	if GameRules.idScoreboard then
		return
	end

	-- create Scoreboard
	local Scoreboard = Server:SpawnEntity({ classid=SYNCHED2DTABLE_CLASS_ID, name="Scoreboard" });

	if Scoreboard then
		GameRules.idScoreboard = Scoreboard.id;
	else
		GameRules.idScoreboard = nil;
	end

--	System:Log("create Scoreboard entity "..tostring(Scoreboard.id));
end

-------------------------------------------------------------------------------
function GameRules:COUNTDOWN_OnBeginState()
	self.countnext = 0;
end


-------------------------------------------------------------------------------
function GameRules:COUNTDOWN_OnUpdate()
	if _time>self.countnext+self.mapstart then
   	    if self.countnext==floor(gr_CountDown) then
    	    self.mapstart = _time;
        	self:NewGameState(CGS_INPROGRESS);
        	
	        local slots = Server:GetServerSlotMap();
        	for i, slot in slots do
--	        	    local ent = System:GetEntity(slot:GetPlayerId());
--	        	    if ent~=nil and ent.type=="Player" then
--	        	        self:ChangeTeam(slot, Game:GetEntityTeam(ent.id), 1);
--	        	    end
        	    slot:ResetPlayTime();
        	    
        	    -- set the default class for player
            end
            
        	GameRules:OnMapChange();	-- init map entites
   	    else
   	    	Server:BroadcastText("@CountdownNo "..(floor(gr_CountDown)-self.countnext), 0.95);
   	        self.countnext = self.countnext+1;
   	    end
    end
end




-------------------------------------------------------------------------------
-- called after player has died and presses fire to respawn
-- normal procedure is for this function to recreate an entity
function GameRules:OnClientRequestRespawn( server_slot, requested_classid )
	--[new start player cannot spawn]
	if SVcommands:requestSpawn(server_slot)==0 then
		return;
	end
	
	--Server:BroadcastText("id:"..requested_classid);
	
	--[new end]
	
	local player;
	
	-- If this game mode supports respawning in groups then put that player in
	-- the requested respawn list rather than respawning them immediately.
	-- They will be respawned in DoOntimerRespawnCycleTimer defined in GameRulesTeamLib.lua
	if floor(toNumberOrZero(getglobal("gr_RespawnTime")))~=0 and self.respawnCycle then
--		System:Log("client request respawn! same team!");
		if (self.respawnList[server_slot]) then
			self.respawnList[server_slot] = { classid = requested_classid, team = self.respawnList[server_slot].team, };
		else			
			server_slot:SendText("@RespawningIn "..self.respawnCycleTimer.." @GameStartingInSeconds", min(self.respawnCycleTimer, 6));
			self.respawnList[server_slot] = { classid = requested_classid, };
			--[new spawnmessage]
			SVcommands:DisplaySpawnMessage(server_slot);
			--[end]
		end	
		
		return 
	end;
	
	if(server_slot.last_death and (_time-server_slot.last_death<self.respawndelay))then
		return
	end
	
--	if(server_slot.last_death)then
--		System:Log("server_slot.last_death="..server_slot.last_death.." _time=".._time);
--	else
--		System:Log("server_slot.last_death=(nil)");
--	end
	
	self:RespawnPlayer(server_slot);

end




-------------------------------------------------------------------------------
function GameRules:RespawnPlayer( server_slot )
	SVplayerTrack:OnRespawn(server_slot);
	-- store old stats
	local prevPlayerEntity=GetSlotPlayer(server_slot);
	
	local oldscore;
	local olddeaths;
	
	if prevPlayerEntity~=nil and prevPlayerEntity.type=="Player" then
		oldscore=prevPlayerEntity.cnt.score;
		olddeaths=prevPlayerEntity.cnt.deaths;
	end

	-- create new player
	local oldteam=Game:GetEntityTeam(server_slot:GetPlayerId());
	local requested_classid = PLAYER_CLASS_ID;
	
	local player=self:SpawnPlayer(server_slot,requested_classid,oldteam);

	-- restore old stats
	if(oldscore or olddeaths)then
		player.cnt.score=oldscore;
		player.cnt.deaths = olddeaths;
	end

	Server:AddToTeam(oldteam,player.id);	
	
end


-------------------------------------------------------------------------------
function GameRules:OnSpectatorSwitchModeRequest(spect)
	if toNumberOrZero(getglobal("gr_allow_spectators"))==0 then
		return;
	end
	local curhost=spect.cnt:GetHost();
	local newhost=0;
	local players=GetPlayers();
--	System:LogToConsole("OnSpectatorSwitchModeRequest curr host="..curhost);
	if(count(players)==0)then 
--		System:LogToConsole("OnSpectatorSwitchModeRequest no players");
		return 
	end;
	
	for id,ent in players do
--		System:LogToConsole("pp");
		if(curhost==0)then
			spect.cnt:SetHost(id);
			return
		else
			if(curhost==id)then
				curhost=0;
			end
		end
	end
	
	spect.cnt:SetHost(0);
end




-------------------------------------------------------
-------------------------------------------------------
-- return 1=if interaction is accepted, otherwise nil
function GameRules:IsInteractionPossible(actor,entity)
	-- prevent a player who is in a vehicle from interacting with the entity
	if actor then
		if (actor.theVehicle) then
			return nil;
		end

		-- prevent corpses from interacting with something
		if(actor.cnt and actor.cnt.health and actor.cnt.health < 1)then
			return nil;
		end
	end

	local iCurstate=self:GetGameState();

	if(iCurstate~=CGS_INPROGRESS)then
		return nil;
	end
	
	return 1;
end


-------------------------------------------------------
-------------------------------------------------------
-- reset the state of all entities
function GameRules:ResetMapEntities()

	local entities=System:GetEntities();
	
	if(entities)then
		for i,ent in entities do
			if(ent)then
				if (ent.deleteOnGameReset) then
					Server:RemoveEntity(ent.id);
					ent = nil;
				elseif (ent.OnMultiplayerReset) then
					ent:OnMultiplayerReset();
				end

				-- store the initial position and angles of the entity, so they can be restored by the Phoenix
				if ent ~= nil and ent.GetPos then
					if not ent.PhoenixData then
						ent.PhoenixData = {};
						ent.PhoenixData.pos = new(ent:GetPos());
						ent.PhoenixData.angles = new(ent:GetAngles());	
					else
						-- we have phoenix data, so reset these guys
						local data = ent.PhoenixData;
						ent:SetPos(data.pos);
						ent:SetAngles(data.angles);
						if (ent.OnReset) then
							ent:OnReset();
						end
					end
				end
			end
		end
	end

	-- respawn all players
	
	local slots = Server:GetServerSlotMap();
	for i, slot in slots do
		local ent=System:GetEntity(slot:GetPlayerId());

		if ent and ent.type=="Player" then
			self:RespawnPlayer(slot);							-- was already a player so respawn
		end
	end
	
	self:CreateScorebordEntity();
end


-------------------------------------------------------
-- is invoked on server from SendCommand() call on client
function GameRules:OnClientCmd( server_slot ,cmd)
--	System:Log("RCV CLIENT CMD = ["..cmd.."]");

	local toktable=tokenize(cmd);
	
	if toktable~={} then
		local sCommand=toktable[1];
		
		local Function=self.ClientCommandTable[sCommand];
		
		if Function then
			Function(cmd,server_slot,toktable);
		end
	end
end



-------------------------------------------------------------------------------
-- count player that are in ready state (e.g. typed in /ready)
function GameRules:ReadyPlayersCount()
	local count=0;
	local slots = Server:GetServerSlotMap();
	for i, slot in slots do
		if(slot:IsReady())then
			local ent=System:GetEntity(slot:GetPlayerId());
			if(ent and ent.type=="Player")then
				count=count+1;
			end
		end
	end
	return count;
end

-------------------------------------------------------------------------------
-- callback from map cleanup
function GameRules:OnShutdown()
end






-------------------------------------------------------------------------------
--------- voting system -------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- callback for the "callvote" console command. votes can be called on
-- anything that we have a "game command" for (see below).
-- only 1 vote can be in progress at any one time, and votes timeout after 1 minute
function GameRules:OnCallVote(server_slot, command, arg1)
	if(command=="ready")then
		if IsPlayer(server_slot)==nil then
			server_slot:SendText("@VoteFailNoSpec");
			return
		end
		
		self:ReadyPlayer(server_slot);
		return
	else
		if tonumber(getglobal("gr_allow_voting"))==1 then
			self.voting_state:OnCallVote(server_slot, command, arg1);
		else
			server_slot:SendText("Voting is currently disabled.");
			return
		end
	end
end


-------------------------------------------------------------------------------
-- callback for the "vote" console command, which casts an actual vote
-- if this vote causes a majority on "yes", execute the "game command"
-- that was voted on
function GameRules:OnVote(server_slot, vote)
	self.voting_state:OnVote(server_slot, vote);
end


-------------------------------------------------------------------------------
-- specific voting version for the "ready" console command
-- (needs unanimous votes, can happen during another vote)
function GameRules:ReadyPlayer(server_slot)
	if self:GetState()~="PREWAR" then
		server_slot:SendText("@ReadyOnlyInPrewar");
		return
	end

	Server:BroadcastText(server_slot:GetName().." @IsReady");

	server_slot:Ready(1);
end



-- \return team_name or nil 
function GameRules.ReturnTeamThatDoesDamage(shooter,hit)
	if hit then
		if hit.weapon and hit.weapon.LaunchedByTeam then
			return hit.weapon.LaunchedByTeam;
		else
			if shooter==nil then
				return;
			end

			return Game:GetEntityTeam(shooter.id);			
		end
	end
end


-- currrently only for explosive damage
-- \return 1 or nil 
function GameRules.ReturnIfPlayerDamagesHimself(target,shooter,hit)
	if hit and hit.weapon and hit.weapon.shooterSSID and target then
		return Server:GetServerSlotBySSId(hit.weapon.shooterSSID):GetPlayerId() == target.id;
	end
	
	if shooter and target==shooter then
		return 1
	end
end


-------------------------------------------------------------------------------
-- if this function is specified in the gamerules, the pickups fade away after a while
function GameRules:GetPickupFadeTime()
	local UserVal=toNumberOrZero(getglobal("gr_DropFadeTime"));
	
	if not UserVal then
		UserVal=10;
	end
	
	if UserVal<1 then 
		UserVal=1;
	end
	
	if UserVal>100 then 
		UserVal=100;
	end

	return UserVal;
end


-------------------------------------------------------------------------------
-- private function to get the same damage calculation in all mods
-- /return nil=player is still living or no player was hit
--         1=player was killed by enemy
--         2=player self kill
--         3=team kill
function GameRules:UsualDamageCalculation(hit)
	local target = hit.target;
	local shooter = hit.shooter;
	local damage = hit.damage;
--	System:Log("\003 UsualDamageCalculation damage: "..hit.damage);
	-- usually used for friendly fire
	if self.IgnoreDamageBetween and self:IgnoreDamageBetween(target,shooter,hit)==1 then 
--		System:Log("UsualDamageCalculation IgnoreDamageBetween damage: "..hit.damage);		--debug
		return 
	end
	
	if not shooter then																								-- explosive damage (entity id might be reassigned)
		local ss_shooter=Server:GetServerSlotBySSId(hit.shooterSSID);
    if ss_shooter then		-- might be nil e.g. vehicle destroyes itself
    	shooter = System:GetEntity(ss_shooter:GetPlayerId());
    end
  end

	--if is falling damage the shooter could be nil
	if(shooter==nil)then 
--		System:Log("GAMERULES>SHOOTER == TARGET")
		shooter=hit.target; 
	end

	if(hit.explosion ~= nil)then
		local expl=target:IsAffectedByExplosion();
		if(expl<=0)then return end
		damage = expl * damage;
	end

--	System:Log("\003 UsualDamageCalculation shooter: "..shooter.id);

	if target==nil or target.type ~= "Player" or target.cnt.health<=0 then 
--		System:Log("GAMERULES>TARGET IS NOT A PLAYER");
		return nil;
	end   -- don't care about damage in prewar etc.

	local zone = target.cnt:GetBoneHitZone( hit.ipart);
    if zone==0 then zone = 2 end;
    
--	System:Log("\003 UsualDamageCalculation zone: "..zone);

  local headshot;				-- nil/1

	if(hit.target_material and hit.target_material.type=="head") then		-- HEAD SHOT
	  	headshot=1;
     		if toNumberOrZero(getglobal("gr_HeadshotMultiplier"))~= nil then
     			damage=damage*tonumber(getglobal("gr_HeadshotMultiplier"));
     		end
	end
	if toNumberOrZero(getglobal("gr_customdamagescale"))~=1 then
		damage = damage * tonumber(getglobal("gr_customdamagescale"));
	else
    		damage = damage * tonumber(gr_DamageScale);
    	end
--	System:Log("\003 UsualDamageCalculation before health and armor: "..target.cnt.health);
	if (damage > 0) then
		--- apply damage first to armor, if it is present
		if (hit.damage_type ~= "healthonly") then
			if (target.cnt.armor > 0) then
				target.cnt.armor= target.cnt.armor - (damage*0.5);
				-- clamp to zero
				if (target.cnt.armor < 0) then
					damage = -target.cnt.armor;
					target.cnt.armor = 0;
				else
					damage = 0;
				end
			end
		end
	end
	
	target.cnt.health = target.cnt.health - damage;

--	System:Log("\003 UsualDamageCalculation after health and armor: "..target.cnt.health);

 	-- negative damage (medic tool) is is bounded to max_health
	if(target.cnt.health>target.cnt.max_health) then
		target.cnt.health=target.cnt.max_health;
	end

	if target.cnt.health<=0 then
--		System:Log("\003 UsualDamageCalculation Killed");

		local shooterTeam = self.ReturnTeamThatDoesDamage(shooter,hit);

		target.cnt.health = 0;
		if shooter.id==target.id or shooter.type ~= "Player" then 
			return 2; -- shoot self or by neutral entity
		elseif Game:GetEntityTeam(target.id)==shooterTeam then
			return 3; -- player was killed by a team member
		else
			return 1; -- player was killed by enemy
		end
	end
	
	return nil;	-- player is still living
end

-------------------------------------------------------------------------------
-- this function sets the score of a player
function GameRules:SetPlayerScore(player, score, deaths)
	player.cnt.score = score;
	
	if (deaths) then
		player.cnt.deaths = deaths;
	end
end

-------------------------------------------------------------------------------
-- this function sets the scores of every player
function GameRules:ResetPlayerScores(score, deaths)

	local ServerSlotMap = Server:GetServerSlotMap();
	
	for i, Slot in ServerSlotMap do
		local Player = System:GetEntity(Slot:GetPlayerId());
		
		if (Player and (Player.type == "Player")) then
			self:SetPlayerScore(Player, score, deaths);
		end
	end

	if (MPStatistics) then
		MPStatistics:Reset();
	end
	--[new playertracking]
	SVplayerTrack:Init();
	--[end]
end

-------------------------------------------------------------------------------
-- private function to get the same score calculation in all mods
-- most of a mods specific quirks are likely to go in here
-- /param hit={ target=<entity>, shooter=<entity> }
-- /param damage_ret typically from UsualDamageCalculation()
function GameRules:UsualScoreCalculation( hit, damage_ret )
	
	if damage_ret==nil then																											-- player is still alive
		return
	end
	
	local target = hit.target;
	local shooter = hit.shooter;
	local situation = 0;                                                        -- normal kill
	local delta = 1;

	target:GotoState("Dead");		

	local ss_target=Server:GetServerSlotByEntityId(target.id);					-- serverslot
	local ss_shooter;																										-- serverslot

	if shooter then																											-- non explosive damage
		ss_shooter=Server:GetServerSlotByEntityId(shooter.id);
	else																																-- explosive damage (entity id might be reassigned)
		ss_shooter=Server:GetServerSlotBySSId(hit.shooterSSID);
    	if ss_shooter then		-- might be nil e.g. vehicle destroyes itself
    		shooter = System:GetEntity(ss_shooter:GetPlayerId());
    	end
  end
	
-- 	System:Log(">>>> damage_ret:"..damage_ret);

	
	local weapon = "World";
	local minstreak=toNumberOrZero(getglobal("gr_killing_spree"));
	local targetstreak = SVplayerTrack:GetBySs(ss_target, "killstreak");
	
	if(hit.weapon)then
		if(hit.weapon.IsBoat)then
			weapon="Boat";
		elseif(hit.weapon.IsVehicle)then
			weapon="Vehicle";
		elseif(hit.weapon.name)then
			weapon = hit.weapon.name;
		else
			weapon = hit.weapon.classname;
		end
	end

	-- clear out old verdict, if exists
	if (SVcommands:TKActive(ss_target:GetId())==1) then
		SVcommands:TKVerdict(ss_target:GetId(),0,-1);
	end

	if damage_ret==2 then			-- shoot self or by neutral entity
		situation = 1;
		MPStatistics:AddStatisticsDataEntity(target,"nSelfKill",1);
		SVplayerTrack:SetBySs(ss_target, "selfkills", 1, 1);
		SVplayerTrack:SetBySs(ss_target, "deaths", 1, 1);
		SVplayerTrack:SetStaticSpawn(ss_target);
		--SVcommands:TKJudge(ss_target:GetId(),ss_target:GetId())
		delta = -1;
		local targetstreak = SVplayerTrack:GetBySs(ss_target, "killstreak");
		if (minstreak~=0) and (targetstreak>=minstreak) then
			if (weapon=="Boat") then
				Server:BroadcastText("$6Killing spree of $4"..targetstreak.." KILLS $6("..ss_target:GetName().."$6) was $4ended$6 by a BOAT",2);
			elseif (weapon=="Vehicle") then 
				Server:BroadcastText("$6Killing spree of $4"..targetstreak.." KILLS $6("..ss_target:GetName().."$6) was $4ended$6 by a CAR",2);
			else
				Server:BroadcastText(ss_target:GetName().."$4ended $6his own killing spree of $4"..targetstreak.." KILLS",2);
			end
			
		end
	else
		if(hit.target_material and hit.target_material.type=="head") then					-- HEAD SHOT
			MPStatistics:AddStatisticsDataSSId(ss_shooter:GetId(),"nHeadshot",1);	-- successfully killed by headshot
			SVplayerTrack:SetBySs(ss_shooter,"headshots", 1, 1);
			--[new] headshot message
			if toNumberOrZero(getglobal("gr_announce_headshot")) == 1 then
				if toNumberOrZero(getglobal("gr_headshot_message_private")) == 1 then
					ss_shooter:SendText("$6You killed $o"..ss_target:GetName().."$6 with a $4headshot",2);
				else
					Server:BroadcastText("$4>$2>$4> "..ss_shooter:GetName().."$6 killed $o"..ss_target:GetName().."$6 with a $4headshot $4<$2<$4<",2);
				end
			end
			--[end]
		end
		if damage_ret==1 then		
			-- player was killed by enemy
			MPStatistics:AddStatisticsDataSSId(ss_shooter:GetId(),"nKill",1);
			SVplayerTrack:SetWeaponKill(ss_shooter, weapon);
			SVplayerTrack:SetBySs(ss_target, "deaths", 1, 1);
			SVplayerTrack:SetStaticSpawn(ss_target);
			local iCurrState=tonumber(GameRules.CurrentProgressStep); 
			if iCurrState then
				if (iCurrState > 1) then
					SVplayerTrack:SetBySs(ss_shooter, "flagactkills", 1, 1);  --kill when flag was activated
				end
			end
			SVplayerTrack:SetBySs(ss_shooter, "kills", 1, 1);
			if toNumberOrZero(getglobal("gr_rm_needed_kills"))>0 then
				SVplayerTrack:RMAddKill(ss_shooter);
			end
			SVplayerTrack:SetBySs(ss_shooter, "killstreak", 1, 1);
			local killstreak=SVplayerTrack:GetBySs(ss_shooter,"killstreak");
			if (killstreak>SVplayerTrack:GetBySs(ss_shooter,"hkillstreak")) then
				SVplayerTrack:SetBySs(ss_shooter,"hkillstreak",killstreak,0);
			end
			local killstreak= SVplayerTrack:GetBySs(ss_shooter, "killstreak");
			if (minstreak~=0) and (killstreak>=minstreak) then
				if toNumberOrZero(getglobal("gr_killing_spree_display")) == 0 then  --display message at each kill
					Server:BroadcastText(ss_shooter:GetName().."$6 is on a killing spree! ($4"..killstreak.." KILLS$6) (last kill with $4"..weapon.."$6)",2);
				end
			end
			local targetstreak = SVplayerTrack:GetBySs(ss_target, "killstreak");
			if (minstreak~=0) and (targetstreak>=minstreak) then
				Server:BroadcastText("$6Killing spree of $4"..targetstreak.." KILLS $6("..ss_target:GetName().."$6) was $4ended$6 by $o"..ss_shooter:GetName(),2);
			end
			
		elseif damage_ret==3 then																									-- player was killed by a team member
   	  		situation = 2;

			SVcommands:TKJudge(ss_target:GetId(),ss_shooter:GetId());
			ss_target:SendText("Press ESC to judge your team killer.");

			--delta = -1;
			delta = 0;
                        --self:PunishforTK(ss_shooter);
                  SVplayerTrack:SetBySs(ss_target, "deaths", 1, 1);
               	SVplayerTrack:SetStaticSpawn(ss_target);

			local targetstreak = SVplayerTrack:GetBySs(ss_target, "killstreak");
			if (minstreak~=0) and (targetstreak>=minstreak) then
				Server:BroadcastText("$6Killing spree of $4"..targetstreak.."$6 ("..ss_target:GetName().."$6) was $4ended$6 by his TEAMMATE $o"..ss_shooter:GetName(),2);
			end
			--[end]
		end
	end

	-- score changes?
	if ((shooter and shooter.type == "Player") or (damage_ret == 2)) then
		if (not shooter) then
			target.cnt.score=target.cnt.score+delta;
		else
			shooter.cnt.score=shooter.cnt.score+delta;
		end
	end
	


	if (target.type == "Player") then
		target.cnt.deaths=target.cnt.deaths+1;
		target.death_time = _time;
		if toNumberOrZero(getglobal("gr_rm_needed_kills"))>0 then
			SVplayerTrack:RMResetOne(ss_target);
		end
	end

-- 	System:Log(">>>> delta:"..delta);

	-- send hud text message to all clients
	local slots = Server:GetServerSlotMap();
	for i, slot in slots do
		if ss_shooter then
--	    	System:Log(">>>> 2 PKP "..target.id.." "..ss_shooter:GetPlayerId().." "..situation);
			slot:SendCommand("PKP "..target.id.." "..ss_shooter:GetPlayerId().." "..situation.." "..weapon);				-- usual print for others
		else
--	    	System:Log(">>>> 3 PKP "..target.id.." 1 "..situation);
			slot:SendCommand("PKP "..target.id.." 0 "..situation.." "..weapon);				-- self kill - instead of passing a dummy value could be done better
		end
 	end


	if ss_target then
		ss_target.last_death=_time;
	else
		System:Log("server slot is nil");
	end

	Game:ForceScoreBoard(target.id, 1);

	return delta;
end

function GameRules:PunishforTK(cId,pId)
	local ss_criminal = Server:GetServerSlotBySSId(cId);
	local ss_target = Server:GetServerSlotBySSId(pId);


	--[new punish teamkillers, either by respawntime or by moving to spectators]
	SVplayerTrack:SetBySs(ss_criminal, "tks", 1, 1);
	local tks=toNumberOrZero(SVplayerTrack:GetBySs(ss_criminal, "tks"));

	local stTk=tks;
	local freeKills = toNumberOrZero(getglobal("gr_free_teamkills"));
	local allowtk = toNumberOrZero(getglobal("gr_allow_teamkilling"));
	--Server:BroadcastText(ss_criminal:GetName().." $4<teamkilled> $o"..ss_target:GetName().."  $4["..stTk.."]", 2);

	if allowtk == 0 then
		if SVcommands:ProtectedName(ss_criminal:GetName())==0 or toNumberOrZero(getglobal("gr_punish_protected"))==1 then
			stTk=tostring(stTk.."/"..freeKills);
			-- check if player has too many teamkills, and should be moved to spectors for the rest of this game
--System:LogAlways("In TK Punish Routine");

			if (tks>=toNumberOrZero(getglobal("gr_teamkill_force_spectate")) and toNumberOrZero(getglobal("gr_teamkill_kick")) > 0)			then
				local pb = tonumber(getglobal("sv_punkbuster")); 
				if(pb and pb==1) then 
--System:LogAlways("In TK Punish Routine - Doing PB Kick");
					local ntime = tonumber(getglobal("gr_teamkill_kick_time")); 
					System:ExecuteCommand("pb_sv_kick \""..ss_criminal:GetName().."\" "..ntime.." Too many TKs"); 
					Server:BroadcastText(ss_criminal:GetName().."$o has been $3Kicked $ofor $3"..ntime.." minutes $o- too many teamkills.",2);
				else 
--System:LogAlways("In TK Punish Routine - Doing Standard Kick");
					GameRules:KickSlot(ss_criminal) 
					Server:BroadcastText(ss_criminal:GetName().."$o has been $3Kicked $o- too many teamkills.",2);
				end
			elseif tks>=toNumberOrZero(getglobal("gr_teamkill_force_spectate")) then
--System:LogAlways("In TK Punish Routine - Doing Force to Spectator");
				GameRules:Invoke("OnKill",ss_criminal);
				--System:LogAlways(tostring(ss_criminal:GetId()).." spectators 1");
				SVcommands:movePlayerToTeam(tostring(ss_criminal:GetId()).." spectators 1");  --force to spectators, cant change back (this map)
                                --System:LogAlways(tostring(ss_criminal:GetId()).." spectators BRUTE FORCE");
                                --GameRules:ChangeTeam(ss_criminal,"spectators",true);
				--System:LogAlways(tostring(ss_criminal:GetId()).." -"..ss_criminal:GetName().."move to spectators ");
				Server:BroadcastText(ss_criminal:GetName().."$o has been forced to $3Spectator $ofor too many teamkills. They can't join until next map",2);
				--GameRules:Invoke("OnKill",ss_criminal);
			elseif tks>freeKills then
--System:LogAlways("In TK Punish Routine - Increasing Respawn Time");
			-- check if player has too many teamkills, and should recieve a respawn punishment
				GameRules:Invoke("OnKill",ss_criminal);
				local PunishTime = (tks-freeKills)*toNumberOrZero(getglobal("gr_teamkill_extra_time"));
				if self.respawnCycleTimer then
					PunishTime = PunishTime + floor(self.respawnCycleTimer) - 1;  --add respawntime (-1, so that there is time to press mouse and spawn, when punishment is over, without having to wait another cycle)
				end
				if toNumberOrZero(getglobal("gr_static_respawn"))>0 then
					PunishTime = PunishTime + tonumber(getglobal("gr_static_respawn"));  --add respawntime
				end
				if PunishTime>0 then
				SVcommands:punishPlayer(ss_criminal:GetId().." "..PunishTime.." $4for teamkilling");
				--Server:BroadcastText(ss_criminal:GetName().."$o cannot join for $6"..PunishTime.."$o seconds. reason: Teamkilling",2);
				end
			end
		end
	end
end

function GameRules:GotoNextMap()
	local nextMap = getglobal("gr_NextMap");

	Game:LoadLevelMPServer(nextMap);
end


-- get the entries for MPStatistics
function GameRules:GetInitialPlayerStatistics()
	return new(self.InitialPlayerStatistics);
end


-------------------------------------------------------------------------------
--

function GameRules:ChangeMap(mapname, gametype, timelimit, respawntime, invulnerabilitytimer, maxplayers, minteamlimit, maxteamlimit)
	--[new extended function with params, for use with mapcycle]
	local szGameType = gametype;
	local szTimeLimit = timelimit;
	local szRespawnTime = respawntime;
	local szInvulnerabilityTimer = invulnerabilitytimer;
	local szMaxPlayers = maxplayers;
	local szMinTeamLimit = minteamlimit;
	local szMaxTeamLimit = maxteamlimit;
	
	if (not mapname or strlen(mapname) < 1) then
		return nil;
	end

	if (not gametype or strlen(gametype) < 1) then
		szGameType = getglobal("g_GameType");
	end
	
	if (not timelimit or strlen(timelimit) < 1) then
		szTimeLimit = getglobal("gr_TimeLimit");
	end
	
	if (not respawntime or strlen(respawntime) < 1) then
		szRespawnTime = getglobal("gr_RespawnTime");
	end
	
	if (not invulnerabilitytimer or strlen(invulnerabilitytimer) < 1) then
		szInvulnerabilityTimer = getglobal("gr_InvulnerabilityTimer");
	end
	
	if (not maxplayers or strlen(maxplayers) < 1) then
		szMaxPlayers = getglobal("gr_MaxPlayers");
	end
	if (not minteamlimit or strlen(minteamlimit) < 1) then
		szMinTeamLimit = getglobal("gr_MinTeamLimit");
	end
	if (not maxteamlimit or strlen(maxteamlimit) < 1) then
		szMaxTeamLimit = getglobal("gr_MaxTeamLimit");
	end
	
	--[end]
	System:Log("\001Map: "..mapname.." ("..szGameType..")");
	
	if (not Game:CheckMap(mapname, szGameType)) then
	
		if (Game:CheckMap(mapname)) then
			local szDefaultGameType = Game:GetMapDefaultMission(mapname);
			
			if (not szDefaultGameType) then
				System:Warning( "Map '"..mapname.."' does not support '"..szGameType.."'. No default Game Type found! Skipping this map!");
				MapCycle:OnMapChanged();
				MapCycle:OnMapFinished();
			
				return nil;
			else
				System:Warning( "Map '"..mapname.."' does not support '"..szGameType.."'. Using '"..szDefaultGameType.."' instead!");				
				szGameType = szDefaultGameType;
			end
		else
			System:Warning( "Map '"..mapname.."' not found! Skipping this map!");
			MapCycle:OnMapChanged();
			MapCycle:OnMapFinished();

			return nil;
		end
	end

	Server:BroadcastText("@ChangeMapTo "..mapname.." ("..szGameType..")", 10);
	
	setglobal("g_GameType", szGameType);
	setglobal("gr_NextMap", mapname);
	--[new] added these
	setglobal("gr_TimeLimit", szTimeLimit); 
	setglobal("gr_RespawnTime", szRespawnTime);
	setglobal("gr_InvulnerabilityTimer", szInvulnerabilityTimer);
	setglobal("sv_MaxPlayers", szMaxPlayers);
	setglobal("gr_MinTeamLimit", szMinTeamLimit);
	setglobal("gr_MaxTeamLimit", szMaxTeamLimit);
	--[end]
	GameRules:NewGameState(CGS_INTERMISSION);
	SVplayerTrack:Init();
	return 1;
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- below follow votable commands players can use for this mod.
-- to add a command, just add a similar function below: the name of the
-- function is what players type as first argument to "callvote", "arg"
-- is an optional second argument

GameCommands = {};


GameCommands.map=
{
	-- \return nil=call is not possible, otherwise the vote has started
	OnCallVote=function(self,serverslot,arg)
		local toktable=tokenize(arg);
		if toktable[1]~=nil then
			self.nextmap=toktable[1];
		else
			self.nextmap=arg;
		end
		if toktable[2]~=nil then
			self.nexttype=toktable[2];
		end

		return 1;
	end,

	OnExecute=function(self)
		GameRules:ChangeMap(self.nextmap,self.nexttype);
	end,

	-- arguments
	nextmap=nil,
	nexttype=nil,
}



GameCommands.kick=
{
	-- \return nil=call is not possible, otherwise the vote has started
	OnCallVote=function(self,serverslot,arg)

		local KickSlot=Server:GetServerSlotBySSId(arg);						-- id was specified
		
		if(not KickSlot)then
			KickSlot=MultiplayerUtils:GetServerslotFromName(arg);		-- name was specified
		end
		
		if(not KickSlot)then
			System:Log("GameCommands.kick: Slot of '"..arg.."' not found");
			serverslot:SendText("@VoteUnknCommand",3);
			return;
		end
		
		if(_localplayer and KickSlot==Server:GetServerSlotByEntityId(_localplayer.id))then
			System:Log("GameCommands.kick: don't kick the server");
			serverslot:SendText("@VoteUnknCommand",3);
			return;
		end
		
		self.PlayerSSID=KickSlot:GetId();
		return 1;
	end,

	OnExecute=function(self)
--	  Server:BroadcastText("@KickingPlayer "..arg);

		local pb = tonumber(getglobal("sv_punkbuster")); 
		local server_slot = Server:GetServerSlotBySSId(self.PlayerSSID);						-- id was specified
		if(pb and pb==1) then 
			local ntime = tonumber(getglobal("gr_teamkill_kick_time")); 
			System:ExecuteCommand("pb_sv_kick \""..server_slot:GetName().."\" "..ntime.." Voted off the server"); 
		else 
			GameRules:KickSlot(server_slot) 
		end 

-- 		GameRules:KickID(self.PlayerSSID);
	end,

	-- arguments
	PlayerSSID=nil,
}



GameCommands.restart=
{
	-- \return nil=call is not possible, otherwise the vote has started
	OnCallVote=function(self,serverslot,arg)
		if arg~=nil then
			self.restarttime=arg;
		end
		return 1;
	end,

	OnExecute=function(self)
	  Server:BroadcastText("@RestartingGame");
	  GameRules:Restart(self.restarttime);
	end,
	
	restarttime=5,
	-- arguments
}



-------------------------------------------------------------------------------
-- Kicks a player
function GameRules:Kick(player)

	if (not player or strlen(player) < 1) then
		return;
	end

	local KickSlot = MultiplayerUtils:GetServerslotFromName(player);

--	System:Log("GameRules:Kick "..player.." "..tostring(KickSlot));

	GameRules:KickSlot(KickSlot);	
end

-------------------------------------------------------------------------------
--
function GameRules:KickID(id)
	if (not id or strlen(id) < 1) then
		return;
	end

	local KickSlot = Server:GetServerSlotBySSId(id);
	
	GameRules:KickSlot(KickSlot);
end

-------------------------------------------------------------------------------
--
function GameRules:KickSlot(ServerSlot)
	if (_localplayer and ServerSlot) then
		if (_localplayer.id == ServerSlot:GetPlayerId()) then
			System:Log("don't kick the server");
			return;
		end
	end

	-- found nothing?
	if(not ServerSlot)then
		System:Log("failed to kick the player");
		return;
	end

--		printf("kicked player id %d...", KickIDServerSlot:GetPlayerId());
	System:Log("kicked player "..tostring(ServerSlot:GetName()));
	Server:BroadcastText("@KickingPlayer "..tostring(ServerSlot:GetName()));
	ServerSlot:Disconnect("@Kicked");
end

-------------------------------------------------------------------------------
--
function GameRules:Ban(player)
	if (not player or strlen(player) < 1) then
		return;
	end

	local BanSlot = MultiplayerUtils:GetServerslotFromName(player);
	
	GameRules:BanSlot(BanSlot);
end

-------------------------------------------------------------------------------
--
function GameRules:BanID(id)
	if (not id or strlen(id) < 1) then
		return;
	end

	local BanSlot = Server:GetServerSlotBySSId(id);
	
	GameRules:BanSlot(BanSlot);
end

-------------------------------------------------------------------------------
--
function GameRules:BanSlot(ServerSlot)
	if (_localplayer and ServerSlot) then
		if (_localplayer.id == ServerSlot:GetPlayerId()) then
			System:Log("don't ban the server");
			return;
		end
	end
	
	if (ServerSlot) then
		ServerSlot:BanByID();
		GameRules:KickSlot(ServerSlot);
	end
end

-------------------------------------------------------------------------------
--
function GameRules:Unban(id)
	if (id) then
		Server:Unban(tonumber(id));
	end
end
-------------------------------------------------------------------------------
-- Does initilization for respawn cycles
function GameRules:StartGameRulesLibTimer()
	if floor(toNumberOrZero(getglobal("gr_RespawnTime")))~=0 and self.respawnCycle then
		self.respawnList={};	
		self.respawnCycleTimer = 1; -- Add this counter to the table.  1 second so we spawn all dead players from the last map immediately.
	end
	
	self:SetTimer(1000); -- Set the on timer event for respawns
end

-------------------------------------------------------------------------------
function GameRules:DoGameRulesLibTimer()
	-- TASKLIST START --
	local nTaskEnable = tonumber(getglobal("gr_task_enable"));
	if ( nTaskEnable == 1) then
		TaskList:OnUpdate();
	end
	-- TASKLIST END --
	local bPerformedRespawn = 0;
	
	local bDoCycle;
	
	local fRespawnTime=floor(toNumberOrZero(getglobal("gr_RespawnTime")));
	
	if fRespawnTime~=0 and self.respawnCycle then
		bDoCycle=1;
	end

	if self.respawnCycleTimer and not bDoCycle then				-- gr_RespawnTime was set to 0
		Server:BroadcastCommand("RTR");
		self.respawnCycleTimer=nil;
		self.respawnList=nil;
	end

	if self.respawnCycleTimer and self.respawnCycleTimer > fRespawnTime then					-- gr_RespawnTime was lowered
		self.respawnCycleTimer=fRespawnTime;
		Server:BroadcastCommand("RTR "..self.respawnCycleTimer);
	end

	-- Does respawn cycles
	if bDoCycle then
		if self.respawnCycleTimer then
			self.respawnCycleTimer=self.respawnCycleTimer-1;
		end
			
		if (not self.respawnCycleTimer or self.respawnCycleTimer<=0) then
			bPerformedRespawn = 1;
			if self.respawnList then
				for server_slot,respawn_info in self.respawnList do
					
					local prevPlayerEntity=GetSlotPlayer(server_slot);
					
					local requested_classid = respawn_info.classid;
					local newteam = respawn_info.team;
					
					-- if no newteam specified, the new team is the old team
					if (not newteam) then
						newteam=Game:GetEntityTeam(server_slot:GetPlayerId());
					end
					
					local oldscore;
					local olddeaths;
					
					if prevPlayerEntity~=nil and prevPlayerEntity.type=="Player" then
						oldscore=prevPlayerEntity.cnt.score;
						olddeaths=prevPlayerEntity.cnt.deaths;
					end
					--also restore score when went to spectators
					if toNumberOrZero(getglobal("gr_keep_score"))==1 then
						if prevPlayerEntity~=nil and prevPlayerEntity.type=="spectator" then
							oldscore=prevPlayerEntity.cnt.score;
							olddeaths=prevPlayerEntity.cnt.deaths;
						end
					end
						
					local player;
					
					----
					local locInitialPlayerProperties=self:GetInitialPlayerProperties(server_slot);
					if locInitialPlayerProperties then
						local newClass=locInitialPlayerProperties.sPlayerClass;
						local activeClass=GameRules:CountClass(server_slot, newClass, newteam);
						if newClass=="Sniper" and activeClass>=tonumber(getglobal("gr_max_snipers")) then
							server_slot:SendText(server_slot:GetName().."$4 is not allowed to join as sniper. $6The maximum number of snipers is: "..tonumber(getglobal("gr_max_snipers")));
							newteam="spectators";
							requested_classid=SPECTATOR_CLASS_ID;
							Server:BroadcastText(server_slot:GetName().."$o was moved to $3Spectators.$o Reason: Too many snipers on that team");
						end
						if newClass=="Grunt" and activeClass>=tonumber(getglobal("gr_max_grunts")) then
							server_slot:SendText(server_slot:GetName().."$4 is not allowed to join as a grunt. $6The maximum number of grunts is: "..tonumber(getglobal("gr_max_grunts")));
							newteam="spectators";
							requested_classid=SPECTATOR_CLASS_ID;
							Server:BroadcastText(server_slot:GetName().."$o was moved to $3Spectators.$o Reason: Too many grunts on that team");
						end
						if newClass=="Support" and activeClass>=tonumber(getglobal("gr_max_engineers")) then
							server_slot:SendText(server_slot:GetName().."$4 is not allowed to join as an engineer. $6The maximum number of engineers is: "..tonumber(getglobal("gr_max_engineers")));
							newteam="spectators";
							requested_classid=SPECTATOR_CLASS_ID;
							Server:BroadcastText(server_slot:GetName().."$o was moved to $3Spectators.$o Reason: Too many engineers in that team");
						end
					end
					----				
					
					System:Log("spawning player in "..newteam.." team!");
					local player=self:SpawnPlayer(server_slot,requested_classid,newteam);
					
					-- copy old stats
					if(oldscore or olddeaths)then
						player.cnt.score=oldscore;
						player.cnt.deaths=olddeaths;
					end

					Server:AddToTeam(newteam,player.id);

					if (self.SetTeamObjectivesOnePlayer) then
						self:SetTeamObjectivesOnePlayer(server_slot);
					end
					
					if (self.UpdateCaptureProgressOnePlayer) then
						self:UpdateCaptureProgressOnePlayer(server_slot);
					end
				end
			end
			
			self.respawnList={};
			self.respawnCycleTimer = fRespawnTime;
			
--			printf("SENT RTR! " .. GameRules.respawnCycleTimer);
			Server:BroadcastCommand("RTR "..tostring(GameRules.respawnCycleTimer));
			
		else
			--for server_slot,requested_classid in self.respawnList do
			--	server_slot:SendText("@RespawningIn "..self.respawnCycleTimer, 1)
			--end
		end
	end

	local slots = Server:GetServerSlotMap();
	
	for i, slot in slots do
		local player = GetSlotPlayer(slot);
		if (player and player.invulnerabilityTimer~=nil and player.ApplyTeamColor~=nil) then
			player.invulnerabilityTimer = player.invulnerabilityTimer - 1;
			if (player.invulnerabilityTimer<=0) then
				--BasicPlayer.SecondShader_TeamColoring(self);
				-- turn off invulnerability shader
--				System:Log("Player "..player:GetName().." lost invulnerbility (timer)");
				Server:BroadcastCommand("FX", g_Vectors.v000, g_Vectors.v000, player.id, 1);
				player.invulnerabilityTimer=nil;
			else
				Server:BroadcastCommand("FX", g_Vectors.v000, g_Vectors.v000, player.id, 2);
				--slot:SendText("@InvEndsIn "..tostring(player.invulnerabilityTimer), 1);
			end
		end
	end
	
	-- process all entities - only done after a respawn wave :)
	if ((bPerformedRespawn == 1) or (fRespawnTime == 0)) then
		local ents=System:GetEntities();
		for i, entity in ents do
			if (entity.type == "Phoenix") then
				entity:RaiseFromAshes();
			end
		end
	end
	
	-- Keep the timer going	
	self:SetTimer(1000);	
end

function GameRules:CountClass(server_slot, class, team)	
	-- count 'active' players of class in this team
	--team= requested team
	
	local iCount = 0;	
	
	if (self.respawnList) then
		local Slots = Server:GetServerSlotMap();
		for i,ServerSlot in Slots do
			if server_slot~=ServerSlot then
				local Player = GetSlotPlayer(ServerSlot);
				local playerClass = "";
				if Player and Player.cnt then
					playerClass = ServerSlot.InitialPlayerProperties.sPlayerClass;
				end
				local RespawnInfo = self.respawnList[ServerSlot];
				local szPlayerTeam;
				
				if (not RespawnInfo) then
					szPlayerTeam = Game:GetEntityTeam(ServerSlot:GetPlayerId());
				else
					szPlayerTeam = RespawnInfo.team;
					
					if (not szTeam) then
						szPlayerTeam = Game:GetEntityTeam(ServerSlot:GetPlayerId());
					end
				end
				
				if (team == szPlayerTeam) and (playerClass == class) then
					iCount = iCount + 1;
				end
			end
		end
	else
		--not team based
		return 0;
	end
	return iCount;
end


--------------------------------------------------------
-- check the players counts (min players and max players
------------------------------------------------------
function GameRules:CheckPlayerCount()
	local iMinTeamLimit = toNumberOrZero(getglobal("gr_MinTeamLimit"));
	
	
	if (not self.bIsTeamBased) then
		if (tostring(getglobal("gr_PrewarOn")) ~= "0") then
			iMinTeamLimit = 1;
		else
			iMinTeamLimit = 0;
		end
	end
	
	local iCurrentState = self:GetGameState();
		
	if ((iMinTeamLimit < 1) and (iCurrentGameState == CGS_INPROGRESS)) then
		return;
	end

	local iTeam01Count = GameRules:GetTeamMemberCountRL("red");
	local iTeam02Count = GameRules:GetTeamMemberCountRL("blue");
	
	if(not self.bIsTeamBased)then
		iTeam01Count = GameRules:GetTeamMemberCountRL("players");
		iTeam02Count = iTeam01Count;
	end
	
	if (iTeam01Count < iMinTeamLimit or iTeam02Count < iMinTeamLimit) then
				
		if (iCurrentState == CGS_INPROGRESS) then
			self:NewGameState(CGS_PREWAR);
			if (self.bIsTeamBased) then
				Server:BroadcastText("@PlayerCountNotOk "..iMinTeamLimit.." @PlayerCountNotOk2", 2);
			else
				Server:BroadcastText("@PlayerCountNotOkNoTeam "..iMinTeamLimit.." @PlayerCountNotOk2NoTeam", 2);
			end
		end
	elseif ((iCurrentState == CGS_PREWAR) and ((not self.restartbegin) or self.restartbegin == 0)) then
		if ((Server:GetTeamMemberCount("red") > 0) and (Server:GetTeamMemberCount("blue") > 0)) then  -- be sure we have at least one spawned player on each team
			self:Restart(3, 1);
			Server:BroadcastText("@GameStartingIn "..(3).." @GameStartingInSeconds", 2);
		end
	end
end



--------------------------------------------------------
-- update Synched2DTable scoreboard
------------------------------------------------------
function GameRules:RemovePlayerFromScoreboard( idClient )
--	System:Log("GameRules:RemovePlayerFromScoreboard");						--debug
	local Entity = System:GetEntity(GameRules.idScoreboard).cnt;
	
	local iY;
	local iLines=Entity:GetLineCount();
	
	for iY=0,iLines-1 do
		local idThisClient = Entity:GetEntryXY(ScoreboardTableColumns.ClientID,iY)-1;		-- first element is the clientid-1

		-- clear line
		if idThisClient==idClient then
--			System:Log("GameRules:RemovePlayerFromScoreboard idThisClient==idClient");						--debug
			Entity:SetEntriesY(iY,0);
			return;
		end
	end
	
--	System:Log("Error: GameRules:RemovePlayerFromScoreboard not found");
end


--------------------------------------------------------
-- update Synched2DTable scoreboard
------------------------------------------------------
function GameRules:AddPlayerToScoreboard( idClient )
	local Entity = System:GetEntity(GameRules.idScoreboard).cnt;
	
	if not Entity then
		System:LogError("GameRules:AddPlayerToScoreboard internal error");			-- better than script error but shouln't happen
		return;
	end
	
	local iY;
	local iLines=Entity:GetLineCount();
	
	for iY=0,iLines-1 do
		local idThisClient = Entity:GetEntryXY(ScoreboardTableColumns.ClientID,iY)-1;		-- first element is the clientid-1

		if idThisClient==-1 then
			-- set player (should be already cleared)
			Entity:SetEntryXY(ScoreboardTableColumns.ClientID,iY,idClient+1);
--			System:Log("GameRules:AddPlayerToScoreboard line "..iY);		--debug
			return;
		end
	end

	Entity:SetEntryXY(ScoreboardTableColumns.ClientID,iLines,idClient+1);
--	System:Log("GameRules:AddPlayerToScoreboard line "..iLines);		--debug
end


--------------------------------------------------------
-- update Synched2DTable scoreboard
------------------------------------------------------
function GameRules:SetScoreboardEntryXY( iX, idClient, Value )
--	System:Log("GameRules:SetScoreboardEntryXY "..iX.." "..idClient.." "..tostring(Value));		--debug
	local Entity = System:GetEntity(GameRules.idScoreboard).cnt;
	
	if iX==0 then
		return;					-- first element is the clientid-1
	end
	
	local iY;
	local iLines=Entity:GetLineCount();
	
	for iY=0,iLines-1 do
		local idThisClient = Entity:GetEntryXY(ScoreboardTableColumns.ClientID,iY)-1;		-- first element is the clientid-1

		if idThisClient==idClient then
--			System:Log("GameRules:SetScoreboardEntryXY line "..iY);		--debug
			Entity:SetEntryXY(iX,iY,Value);
			return;
		end
	end
end

