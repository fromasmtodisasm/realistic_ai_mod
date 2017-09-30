
Script:LoadScript("scripts/Default/ClientStuff.lua");		-- derive functionality

Script:LoadScript("SCRIPTS/MULTIPLAYER/MultiplayerClassDefiniton.lua");		-- global MultiplayerClassDefiniton

---------------------------------------------------------------------------------
-- This is called whenever an entity is spawned on the client
function ClientStuff:OnSpawnEntity(entity)
	-- in multiplayer we want to have all entities updating even if we don't look at them
	entity:EnableUpdate(1);
	
	if (entity.type == "Player") then
		entity:SetViewDistRatio(255);										 	-- viewdistratio to be max (== 255)
		entity:RenderShadow( 1 );												 	-- enable rendering of player shadow
		BasicPlayer.SecondShader_TeamColoring(entity);		-- enable colorize shader (individual or team color)
		
		Hud:ResetRadar(entity);
	end
end

---------------------------------------------------------------------------------
-- change player objective
ClientStuff.ServerCommandTable["CPO"]=function(String,toktable)

	local tokcount=count(toktable);

	local newobjective;
		
	if tokcount>=2 then
		newobjective=toktable[2];
	end
		
	Hud.PlayerObjective = newobjective;
	
	if newobjective then
		Hud.PlayerObjectiveAnim = 1;	-- 1 is the pop up
		Hud.PlayerObjectiveAnimStart = _time;
		
		if newobjective == "POAtt" then
			Hud.PlayerObjectiveAnimTex = System:LoadImage("textures/hud/multiplayer/attacker_logo");
		else
			Hud.PlayerObjectiveAnimTex = System:LoadImage("textures/hud/multiplayer/defender_logo");
		end
	else
		Hud.PlayerObjectiveAnim=nil;
	end
end;


---------------------------------------------------------------------------------
-- respawn timer reset
ClientStuff.ServerCommandTable["RTR"]=function(String,toktable)

	if count(toktable)==2 then
		-- currently only used in the Hud
		-- set to the hud, and limboscreen
		local iRCL = tonumber(toktable[2]);
		
		if (iRCL) then
			Hud.iRespawnCycleLength = iRCL;
			Hud.iRespawnCycleStart = _time;
		end
	else
		Hud.iRespawnCycleLength = nil;
		Hud.iRespawnCycleStart = nil;
	end
end;


---------------------------------------------------------------------------------
-- your class is now <MultiplayerClassDefiniton.PlayerClasses>
-- needed to synchroize the player speed
ClientStuff.ServerCommandTable["YCN"]=function(String,toktable)
	if count(toktable)==2 then
		local classname=toktable[2];
		local myclass=MultiplayerClassDefiniton.PlayerClasses[classname];
		
		if not myclass then				-- e.g. DefaultMultiPlayer
			myclass=MultiplayerClassDefiniton[classname];
		end
		
		if myclass then
			local player=_localplayer;
			
			if player and player.cnt then
				player.cnt:SetMoveParams(myclass.move_params);
				player.cnt.max_health=myclass.health;						-- is not netsynced
				player.cnt.max_armor=myclass.max_armor;					-- is not netsynced
			else
				System:Error("ServerCommandTable YCN failed - internal network error");
			end
		end
	end
end;


---------------------------------------------------------------------------------
-- receive player count
ClientStuff.ServerCommandTable["RPC"] = function(String,TokTable)

	if not Hud then
		return;
	end

	Hud.iTeam01Count = tonumber(TokTable[2]);
	Hud.iTeam02Count = tonumber(TokTable[2+4]);
	Hud.iTeamSpecCount = tonumber(TokTable[2+4+4]);
	
	Hud.Team01ClassCount = {};
	Hud.Team02ClassCount = {};

	local iClassIndex = 1;
	for iClassIndex=1, 3 do
		Hud.Team01ClassCount[iClassIndex] = tonumber(TokTable[2 + iClassIndex]);
	end
	for iClassIndex=1, 3 do
		Hud.Team02ClassCount[iClassIndex] = tonumber(TokTable[2 + 4 + iClassIndex]);
	end

	Hud.bReceivedPlayerCount = 1;
end

---------------------------------------------------------------------------------
-- 
ClientStuff.ServerCommandTable["GPC"] = function(String,TokTable)
	
	if not Hud then
		return;
	end

	Hud.iSelfWeapon1 = nil;
	Hud.iSelfWeapon2 = nil;
	Hud.iSelfWeapon3 = nil;
	Hud.iSelfWeapon4 = nil;

	Hud.szSelfTeam = tostring(TokTable[2]);
	Hud.szSelfClass = tostring(TokTable[3]);
	
	for i=1, 4 do
		if (TokTable[2 + i]) then
			Hud["iSelfWeapon"..i] = tonumber(TokTable[3 + i]);
		end
	end
	
	Hud.bReceivedSelfStat = 1;
end


---------------------------------------------------------------------------------
--
ClientStuff.ServerCommandTable["UTL"] = function(String,TokTable)
	if (Hud) then
		Hud.fTimeLimit = tonumber(TokTable[2]);
	end
end

---------------------------------------------------------------------------------
--
function ClientStuff:GetInGameMenuVideoOn()
	return 0;
end


-------------------------------------------------------------------------------
-- callback for getting the in game menu
function ClientStuff:GetInGameMenuName()
	return "InGameNonTeam";
end

--------------------------------------------------------------------------------
-- called when a text message arrives
-- command is "say", "sayteam" or "sayone"
function ClientStuff:OnTextMessage(command, sendername, text)

	-- check if there is an ingamemenu
	local InGameMenu = ClientStuff:GetInGameMenuName();
	
	if (not InGameMenu) then
		return
	end
	
	-- check if the menu has a chatbox
	local ChatBox = UI:GetWidget("ChatBox", InGameMenu);
	
	if (not ChatBox) then
		return
	end
	
	-- at this point, nothing should go wrong...
	if (command == "sayone") then
		ChatBox:AddLine(sendername.." @MPChatPrivate "..text);
	elseif (command == "sayteam") then
		ChatBox:AddLine(sendername.." @MPChatTeam "..text);
	elseif (command == "say") then
		ChatBox:AddLine(sendername..":$1 "..text);
	end
end


---------------------------------------------------------------------------------
-- player killed player TargetEntityID,ShooterEntityID,situation=0/1/2,center=1/nil
ClientStuff.ServerCommandTable["PKP"]=function(String,toktable)
	local size=count(toktable);

-- 	System:Log(">>>> size "..size);

	if size==5 then
		local target=System:GetEntity(toktable[2]);
		local shooter=System:GetEntity(toktable[3]);
		local situation=toktable[4];
		local weapon=toktable[5];

--   	System:Log(">>>> 4 "..tostring(target));
--   	System:Log(">>>> 5 "..tostring(shooter));
--   	System:Log(">>>> 6 "..tostring(situation));

		if target and situation then
			local killmsg = {};
			
			killmsg.situation = situation;
			killmsg.weapon = weapon;
			
			if situation=="1" then
				killmsg.target = target:GetName();
			else
				if not shooter then
					return;
				end
				
				killmsg.shooter = shooter:GetName();
				killmsg.target = target:GetName();
			end

			-- add kill message
			Hud:AddMessage(killmsg, 7.5, 0, 1);
		end
	end
end;


