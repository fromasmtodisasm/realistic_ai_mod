QueryHandler = {};

----------------------------------------------------------------------------------
-- Get Server Rules
-- Return table with rules from 1..n
-- Each rule is a table from 1..2 with 1=rulename 2=rulevalue
----------------------------------------------------------------------------------
function QueryHandler:GetServerRules()

	if (GameRules and GameRules.GetServerRules) then
		return GameRules:GetServerRules();
	end

	local Temp = {};
	return Temp;
end


----------------------------------------------------------------------------------
-- Get Player Stats
-- Return table with players from 1..n
-- Each player is a table containing:
--   	- Name
--   	- Team
--   	- Skin
--   	- Score
--   	- Ping
--   	- Time
----------------------------------------------------------------------------------
function QueryHandler:GetPlayerStats()

	if (GameRules and GameRules.GetPlayerStats) then
		return GameRules:GetPlayerStats();
	end

	local Temp = {};
	return Temp;
end