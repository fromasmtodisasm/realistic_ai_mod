-- Multiplayer Statistics
--
-- is only used on the server
-- if a player was renaming itself - the last name is printed

MPStatistics = {
	Teams={},							-- table of teamname={ ... }
	Entries={},						-- table of used entries
}





-------------------------------------------------------
function MPStatistics:Init()
	self.Teams={};

	local slots = Server:GetServerSlotMap();

	for i, slot in slots do
		slot.Statistics=nil;
	end
end



-------------------------------------------------------
-- /param shooter entity table
-- /param entry name of the entry string
-- /param delta number
function MPStatistics:AddStatisticsDataEntity( shooter , entry, delta )
	local player_slot=self:_GetServerSlotOfResponsiblePlayer(shooter);

	if not player_slot then
		System:Log("\002Error MPStatistics:AddStatisticsDataEntity nil");
		System:Log("\002  AddStatisticsData ".." "..entry.." "..tostring(delta));
		return;
	end
	
	self:_AddStatisticsData(player_slot,entry,delta);
end

-------------------------------------------------------
-- /param shooterSSID entity table
-- /param entry name of the entry string
-- /param delta number
function MPStatistics:AddStatisticsDataSSId( shooterSSID , entry, delta )
	local player_slot=Server:GetServerSlotBySSId(shooterSSID);

	if not player_slot then
		System:Log("\002Error MPStatistics:AddStatisticsDataSSId nil");
		System:Log("\002  AddStatisticsData ".." "..entry.." "..tostring(delta));
		return;
	end
	
	self:_AddStatisticsData(player_slot,entry,delta);
end


-------------------------------------------------------
-- /param player_slot server slot of the player
-- /param entry name of the entry string
-- /param delta number
function MPStatistics:_AddStatisticsData( player_slot , entry, delta )

--	System:Log("AddStatisticsData "..tostring(player_slot:GetPlayerId()).." "..entry.." "..tostring(delta));
	
	-- Add to the player --------------
	
	if not player_slot.Statistics then
		if(not GameRules.GetInitialPlayerStatistics)then		-- not a MP mod, e.g. Editor
			return;
		end
		player_slot.Statistics = GameRules:GetInitialPlayerStatistics();
	end
	
	local val=player_slot.Statistics[entry];

	if not val then			-- otherwise GameRules:GetInitialPlayerStatistics() supresses this info
		return;
	end

	player_slot.Statistics[entry]=val+delta;

	-- Add to the team ----------------
	
	local team=Game:GetEntityTeam(player_slot:GetPlayerId());
	
	if team then
		local val=self.Teams[team];

		if not val then
			self.Teams[team] = GameRules:GetInitialPlayerStatistics();
		end

		local val=self.Teams[team][entry];

		if not val then			-- otherwise GameRules:GetInitialPlayerStatistics() supresses this info
			return;
		end

		self.Teams[team][entry]=val+delta;
	else
		System:Log("AddStatisticsData error "..tostring( player_slot:GetPlayerId() ));
	end
end


-- shooter might be a entity (e.g rocket) or a player
function MPStatistics:_GetServerSlotOfResponsiblePlayer( shooter )
--	System:Log("GetServerSlotOfResponsiblePlayer a "..tostring(shooter));
	if not shooter then
		return;
	end
	
--	System:Log("GetServerSlotOfResponsiblePlayer b "..tostring(shooter.shooterSSID));
	
	if shooter.shooterSSID then
--		System:Log("GetServerSlotOfResponsiblePlayer c "..tostring(Server:GetServerSlotBySSId(shooter.shooterSSID)));
		return Server:GetServerSlotBySSId(shooter.shooterSSID);		-- used for delayed damage
	else
--		System:Log("GetServerSlotOfResponsiblePlayer d "..tostring(shooter.id).." "..tostring(Server:GetServerSlotByEntityId(shooter.id)));
		return Server:GetServerSlotByEntityId(shooter.id);				-- used for immediate damage
	end
end

-------------------------------------------------------
-- private method
function MPStatistics:_PrintTable( tableref )
	if tableref then
		for key,val in tableref do
			BroadcastConsolePrint("   "..key.."="..val);
		end
	end
end


function MPStatistics:Reset()
	local ServerSlots = Server:GetServerSlotMap();

	for i, Slot in ServerSlots do
	  Slot.Statistics = nil;
	end
end

-------------------------------------------------------
function MPStatistics:Print()
	BroadcastConsolePrint("");
	BroadcastConsolePrint("================================================================================");
	BroadcastConsolePrint("== Statistics                                                                 ==");
	BroadcastConsolePrint("================================================================================");
	BroadcastConsolePrint("Servername: "..Server:GetName());
	BroadcastConsolePrint("Levelname: "..Game:GetLevelName());
	BroadcastConsolePrint("================================================================================");
	BroadcastConsolePrint("== Player:                                                                    ==");
	BroadcastConsolePrint("================================================================================");

	local slots = Server:GetServerSlotMap();

	for i, slot in slots do
	  local ent = System:GetEntity(slot:GetPlayerId());
	  
	  if ent then			-- if there is a player connected
			BroadcastConsolePrint("Player: "..ent:GetName());

			if not slot.Statistics then
				slot.Statistics = GameRules:GetInitialPlayerStatistics();
			end

			self:_PrintTable(slot.Statistics);
		end
	end
	
	BroadcastConsolePrint("================================================================================");
	BroadcastConsolePrint("== Teams:                                                                     ==");
	BroadcastConsolePrint("================================================================================");

	for team,teamentries in self.Teams do
		BroadcastConsolePrint("Team: "..team);
		self:_PrintTable(teamentries);
	end

	BroadcastConsolePrint("================================================================================");
	BroadcastConsolePrint("");
end