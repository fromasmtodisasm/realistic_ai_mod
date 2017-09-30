
-- shared index table between gamerules and clientstuff
-- send from server to client

ScoreboardTableColumns=
{
	ClientID=0,				-- send from server to client is automaticly set by GameRuleLib.lua
	sName=1,					-- directly shown in the scoreboard
	iTotalScore=2,		-- combined (cap, support, ...), needed for efficiency calculation
--	iDeaths=,				-- needed for efficiency calculation
--	iSuicides=,			-- needed for efficiency calculation
	iPlayerScore=3,		-- 
--	iCapScore=,			-- 
	iSupportScore=4,	-- 
--	iKillScore=,			-- directly shown in the scoreboard
	iPlayerClass=5,		-- e.g. grunt, support
	iPlayerTeam=6,		-- e.g. players, spectators, red, blue
}



