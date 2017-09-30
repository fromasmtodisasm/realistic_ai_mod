-------------------------------------------------------------------------
--	Helper functions for GameRules with team support implementation
--
--	created by MartinM
-------------------------------------------------------------------------

-- teams:
--
-- red
-- blue
-- spectators


Script:LoadScript("SCRIPTS/MULTIPLAYER/GameRulesLib.lua");				-- we derive from this

GameRules.bShowUnitHightlight=1;			-- 1/nil (show a 3d object on top of every friendly unit)
GameRules.bIsTeamBased = 1;

GameRules.InitialPlayerStatistics["nTeamKill"]=0;			-- this entry can be used by MPStatistics:AddStatisticsDataEntity();

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- utility function to keep track of the team scores
-- a mod may do this differently if the score of the team is not
-- simply a sum of player scores
function GameRules:UpdateTeamScores()

	local red_score=Game:GetTeamScore("red");
	local blue_score=Game:GetTeamScore("blue");
		--System:Log("scores [red="..red_score.."] blue=["..blue_score.."]");
    for i,flag in self.flags do
    	local state=flag:GetState();
    	if(state=="red")then
    		red_score=red_score+1;
    	elseif (state=="blue")then
    		blue_score=blue_score+1;
    	end
    end
    Server:SetTeamScore("red",red_score);
    Server:SetTeamScore("blue",blue_score);
    
    --TODO SET THE SCORES
end



function GameRules:INTERMISSION_BeginState()
	local red_score=Game:GetTeamScore("red");
	local blue_score=Game:GetTeamScore("blue");
	self.intermissionstart = _time;
	if(red_score~=blue_score)then
		if(red_score>blue_score)then
			Server:BroadcastText("["..red_score.."-"..blue_score.."] @TeamRedWon");
		else
			Server:BroadcastText("["..red_score.."-"..blue_score.."] @TeamBlueWon");
		end
	else
		Server:BroadcastText("["..red_score.."-"..blue_score.."] @TeamTie");
	end
end

function GameRules:INTERMISSION_OnUpdate()
	if _time>self.intermissionstart+6 then
   	self:GotoNextMap();
	end
end

function GameRules:PREWAR_Team_OnUpdate()
end



-------------------------------------------------------------------------------
-- used for friendly fire
-- \param target entity
-- \param shooter entity
-- \param hit hit table (hit.damage has to be there)
-- returns 1 if the damage should be ignored, nil otherwise
function GameRules:IgnoreDamageBetween(target,shooter,hit)

--	System:Log("GameRules:IgnoreDamageBetween 1"); -- debug

	if target==nil then
		return;
	end

	local shooterTeam = self.ReturnTeamThatDoesDamage(shooter,hit);
	
	if shooterTeam==nil then
		return;
	end
	
--	System:Log("GameRules:IgnoreDamageBetween 2 "..shooterTeam); -- debug

	if tonumber(gr_FriendlyFire)~=0 then			-- friendly fire is not activated
		return;
	end
	
	if hit.damage<=0 then											-- healing is not affected by friendly fire
		return;
	end
	
	if(hit.weapon and hit.weapon.IsVehicle)then
--		System:Log("Vehicle damage applies to everyone");
		return;
	end

--	System:Log("GameRules:IgnoreDamageBetween 3"); -- debug

	if self.ReturnIfPlayerDamagesHimself(target,shooter,hit) then
		return;
	end

	local targetTeam=Game:GetEntityTeam(target.id);
	
--	System:Log("GameRules:IgnoreDamageBetween 4 "..targetTeam); -- debug

	if targetTeam==shooterTeam then
--		System:Log("GameRules:IgnoreDamageBetween 5"); -- debug

		return 1;													-- ignore positive damage between team members
	end
end

GameRules.ClientCommandTable["GTK"]=function(String,ServerSlot,TokTable)

	if (count(TokTable) ~= 1) then
		return;
	end
        local szReplyString = TokTable[1];

        local judge=toNumberOrZero(SVplayerTrack:GetBySs(ServerSlot, "TKjudge"))
        local criminal=toNumberOrZero(SVplayerTrack:GetBySs(ServerSlot, "TKcriminal"))
        if (judge ~= nil) then
        	szReplyString = szReplyString.." "..judge.." "..criminal;
        end

        ServerSlot:SendCommand(szReplyString);
end

GameRules.ClientCommandTable["VTK"]=function(String,ServerSlot,TokTable)

	if (count(TokTable) ~= 4) then
		return;
	end
	local judge=tonumber(TokTable[2]);
	local criminal=tonumber(TokTable[3]);
	local verdict=tonumber(TokTable[4]);
        SVcommands:TKVerdict(judge,criminal,verdict);

end
