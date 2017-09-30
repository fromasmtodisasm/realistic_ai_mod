-- this script is used to create lua side only console variables

-- passing "NetSynch" as third parameter means server synchronized (cannot be changed on client and is syncroized if changed on the server)

Game:CreateVariable("gr_ScoreLimit", 0);												--
Game:CreateVariable("gr_TimeLimit", 30);												-- in minutes
Game:CreateVariable("gr_DamageScale", 1);												--
Game:CreateVariable("gr_HeadshotMultiplier", 2);								--

Game:CreateVariable("gr_NextMap", "");													-- e.g. "mp_airstrip"

Game:CreateVariable("gr_RespawnTime", 15);											-- in seconds, 0 to deactivate the respawning in waves
Game:CreateVariable("gr_PrewarOn", 0, "NetSynch");							-- 0/1=prewar gamestate on
Game:CreateVariable("gr_CountDown", 5);													-- countdown for round start

Game:CreateVariable("gr_DropFadeTime", 10, "NetSynch");					-- [1..100], time in seconds it takes for pickups to fade away

Game:CreateVariable("gr_RespawnAtDeathPos", 1);									--
Game:CreateVariable("gr_FriendlyFire", 0);											--

Game:CreateVariable("gr_DedicatedServer", 0);										--

Game:CreateVariable("gr_MinTeamLimit", "0");										-- >=1 game starts with prewar till enough players are in the game
Game:CreateVariable("gr_MaxTeamLimit", "16");										--

Game:CreateVariable("gr_InvulnerabilityTimer", 5, "NetSynch");	--
