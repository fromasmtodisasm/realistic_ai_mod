SVcommands = {};

protectedNames = {
	namelist={},
	vn=1,
}

--player movement controls
Game:AddCommand("gr_move","SVcommands:movePlayerToTeam(%line);","gr_move [pId] [team=blue/red/spectators] <forceteam>");  --move player to team. Optional: <forceteam>. 1 = make them stay
Game:AddCommand("gr_moveall","SVcommands:moveAllToTeam(%1);","gr_moveall [team=blue/red/spectators]"); --move all but protected to team (can return)
Game:AddCommand("gr_release","SVcommands:ReleasePlayer(%1);","gr_release [pId]"); --release teamforcing on player
Game:AddCommand("gr_lock","SVcommands:SVlockTeam(%1);","gr_lock [team=red/blue]"); --players (except protected) cannot join a team
Game:AddCommand("gr_unlock","SVcommands:SVunlockTeam(%1);","gr_unlock [team=red/blue]"); --unlocks teams
Game:AddCommand("gr_unlockall","SVcommands:SVunlockall();","gr_unlockall"); --release ALL locks (forced player teams (gr_move) + (gr_lock))
Game:AddCommand("gr_switchteams","SVcommands:moveAllToOppositeTeam();","gr_switchteams"); --all players switch teams

--player admin utilities
Game:AddCommand("gr_list","SVcommands:SVListPlayers();","gr_list");  --displays detailed players list
Game:AddCommand("gr_punish","SVcommands:punishPlayer(%line);","gr_punish [pId] <extra time> <reason>"); -- when a player dies, they recieve extra respawn time. Optional: reason  
Game:AddCommand("gr_cpc","SVcommands:SetSVplayerClass(%1, %2);","gr_cpc [pId] [class = sniper1..4/engy1..4/grunt1..6"); --changes the players' class on next respawn
Game:AddCommand("gr_switchobjectives","GameRules:DoSwitchTeams();","gr_switchobjectives"); --players stay on same teams, but switch from offense to defense or vice versa

Game:AddCommand("gr_load_protected","SVcommands:loadProtected();","gr_load_protected"); --reloads the protected names file (profiles/server/p_names.txt)
Game:AddCommand("gr_add_protected","SVcommands:addProtectedById(%1);","gr_add_protected [pId]"); --add a player to protected name list
Game:AddCommand("gr_list_protected","SVcommands:printProtectedNames();","gr_list_protected"); --displays all current protected names
Game:AddCommand("gr_clear_protected","SVcommands:clearProtected();","gr_clear_protected"); --clears all protected names
Game:AddCommand("gr_save_protected","SVcommands:saveProtected();","gr_save_protected"); --saves protected names to p_names.txt


--server settings
Game:AddCommand("gr_setcrossname","SVcommands:SVsetcrossname(%1);","gr_setcrossname [0/1]"); --toggles enemy names from appearing on crosshairs.  1 = yes

-- the following commands change the mapcycle to file in server.cfg [gr_mapcycle_ffa / gr_mapcycle_assault / gr_mapcycle_tdm]
Game:AddCommand("gr_ffa","SVcommands:changeMapCycleFfa();","gr_ffa (changes mapcycle to gr_mapcycle_ffa)");
Game:AddCommand("gr_tdm","SVcommands:changeMapCycleTdm();","gr_tdm (changes mapcycle to gr_mapcycle_tdm)");
Game:AddCommand("gr_assault","SVcommands:changeMapCycleAssault();","gr_assault (changes mapcycle to gr_mapcycle_assault)");

Game:AddCommand("gr_exportstats","SVplayerTrack:ExportStats();",""); --creates a statsfile (automatically done when gr_stats_export = 1)

--server utilities
Game:AddCommand("gr_ss","SVcommands:serverSay(%line);","gr_ss [text]"); -- sends HUD message to all players
Game:AddCommand("gr_config","SVcommands:LoadConfig(%1);","gr_config [configfile]"); --(re)loads a config file and restarts the server
Game:AddCommand("gr_config1","SVcommands:LoadConfig1(%1);","gr_config1 [configfile]"); --(re)loads an alternate config file and restarts the server
Game:AddCommand("gr_reboot_server","SVcommands:PlaceRestartFile();","gr_reboot_server"); --reboots the server 
Game:AddCommand("gr_nextmap","GameRules:GotoNextMap();","gr_nextmap"); --go to the next map in the map cycle


function SVcommands:SVsetcrossname(flag)
	if (tonumber(flag)==1) then
		setglobal("gr_CrossName", 1);
	end
	if (tonumber(flag)==0) then
		setglobal("gr_CrossName", 0);
	end
end

function SVcommands:serverSay(sMess)
	Server:BroadcastText(sMess);
end

function SVcommands:movePlayerToTeam(line)
	if (line) then
		toktable = tokenize(line);
		if (toktable[1] and toktable[2]) then
			local pId = tonumber(toktable[1]);
			local team = tostring(toktable[2]);
			local stay = 0;
			local blind = 0;
			if (toktable[3]) then
				stay=tonumber(toktable[3]);
			end
			if (toktable[4]) then
				blind=tonumber(toktable[4]);
			end
			local ss = Server:GetServerSlotBySSId(pId);
			if team~="spectators" and team~="blue" and team~="red" and team~="players" then 
				System:LogAlways("Usage: gr_move [pId] [team] <force 1/0>");
				return;
			end
			if ss and team then
				GameRules:ChangeTeam(ss,team,true);
				ss:Ready(nil);
		  		ss:ResetPlayTime();
				if (blind==0) then
					Server:BroadcastText(ss:GetName().." $omoved to "..team);
				end
				if (stay==1) and (team~="players") then
					SVplayerTrack:SetBySs(ss, "forcedteam", team, 0);
					System:LogAlways(ss:GetName().." is locked on the "..team);
				end
				return;
			end
		end
	end
	System:LogAlways("Usage: gr_move [pId] [team]");
	return;
end

function SVcommands:ReleasePlayer(pId)
	SVplayerTrack:SetById(pId,"forcedteam","",0);
	System:LogAlways("Released teamforcing on "..pId);
end

function SVcommands:moveAllToOppositeTeam()
	local Entity = System:GetEntity(GameRules.idScoreboard).cnt;
	
	local iY,X;
	local iLines=Entity:GetLineCount();
	local iColumns=Entity:GetColumnCount();
	local ss;
	local pId;
	local curTeam,newTeam;
	
	for iY=0,iLines-1 do
		pId = Entity:GetEntryXY(ScoreboardTableColumns.ClientID,iY)-1; -- first element is the clientid-1
		curTeam = Entity:GetEntryXY(ScoreboardTableColumns.iPlayerTeam,iY);
		ss = Server:GetServerSlotBySSId(pId);
		if (ss and tonumber(curTeam)==2) then
			SVcommands:movePlayerToTeam(pId.." red 0 1");
		end
		if (ss and tonumber(curTeam)==1) then
			SVcommands:movePlayerToTeam(pId.." blue 0 1");
		end
	end
	--GameRules:ResetMap();
end

function SVcommands:moveAllToTeam(team)
	local Entity = System:GetEntity(GameRules.idScoreboard).cnt;
	
	local iY,X;
	local iLines=Entity:GetLineCount();
	local iColumns=Entity:GetColumnCount();
	
	for iY=0,iLines-1 do
		local pId = Entity:GetEntryXY(ScoreboardTableColumns.ClientID,iY)-1;		-- first element is the clientid-1
		local nameThisClient = Entity:GetEntryXY(ScoreboardTableColumns.sName,iY);
		if pId~=-1 and SVcommands:ProtectedName(nameThisClient)~=1 then
			SVcommands:movePlayerToTeam(tostring(pId.." "..team.." 0"));
		end
	end
	Server:BroadcastText("Moved all to "..team);
end

function SVcommands:changeMapCycleAssault()
	SVcommands:changeMapCycle("assault");
end
function SVcommands:changeMapCycleFfa()
	SVcommands:changeMapCycle("ffa");
end
function SVcommands:changeMapCycleTdm()
	SVcommands:changeMapCycle("tdm");
end

function SVcommands:changeMapCycle(changeTo)
	local mcfile=getglobal("gr_mapcycle_"..changeTo);
	if mcfile~="" then
		setglobal("sv_mapcyclefile", mcfile);
		MapCycle:Reload();
		MapCycle:nextmap();
		Server:BroadcastText("Mapcycle changed to "..changeTo);
	else
		System:LogAlways("Mapcyclefile not found in server config (gr_mapcycle_"..changeTo..")");
	end
end

function SVcommands:SVListPlayers()
	local Entity; 
	
	if GameRules then
		Entity = System:GetEntity(GameRules.idScoreboard).cnt;
	elseif ClientStuff then
		Entity = System:GetEntity(ClientStuff.idScoreboard).cnt;
	end

	local iY,X;
	local iLines=Entity:GetLineCount();
	local iColumns=Entity:GetColumnCount();
	local pteam ;
	local pclass;
	local tid;
	local prSpec=1;
	local prBlue=1;
	local prRed=1;
	local prPlay=1;
	System:LogAlways("Displaying detailed team lists:");
	for tid=-1,2 do

		for iY=0,iLines-1 do
			pteam="";
			pclass="";
			local iteam=Entity:GetEntryXY(ScoreboardTableColumns.iPlayerTeam,iY);
			local idThisClient = Entity:GetEntryXY(ScoreboardTableColumns.ClientID,iY)-1;
			
			if tid==iteam and idThisClient~=-1 then 
				if toNumberOrZero(tid)==-1 and prPlay==1 then
					System:LogAlways("$9[People]               $9Id  Class    Score  Name");
					prPlay=0;
				end
				if toNumberOrZero(tid)==0 and prSpec==1 then
					System:LogAlways("$3[Spectators]           $9Id  Class    Score  Name");
					prSpec=0;
				end
				if toNumberOrZero(tid)==1 and prRed==1 then
					System:LogAlways("$4[Team Red]             $9Id  Class    Score  Name");
					prRed=0;
				end
				if toNumberOrZero(tid)==2 and prBlue==1 then
					System:LogAlways("$2[Team Blue]            $9Id  Class    Score  Name");
					prBlue=0;
				end


				local iclass=Entity:GetEntryXY(ScoreboardTableColumns.iPlayerClass,iY);
				if toNumberOrZero(iclass)==-1 then
					pclass="$5         $1";
				end
				if toNumberOrZero(iclass)==0 then
					pclass="$5Grunt    $1";
				end
				if toNumberOrZero(iclass)==1 then
					pclass="$5Engineer $1";
				end
				if toNumberOrZero(iclass)==2 then
					pclass="$5Sniper   $1";
				end
				
				local prcl=idThisClient;
				
				if tonumber(prcl)<10 then
					prcl=tostring(" "..prcl);
				end
				
				local ikscore;
				local pkillscore="   ";

				if toNumberOrZero(iteam)~=-1 then
					ikscore=Entity:GetEntryXY(ScoreboardTableColumns.iPlayerScore,iY);
					pkillscore=ikscore;
					if (ikscore ~= nil) then
    					       if (tonumber(ikscore)<100) and (tonumber(ikscore)>9) then
    						pkillscore=tostring(" "..ikscore);
    					       end
    					       if (tonumber(ikscore)<10) and (tonumber(ikscore)>-1) then
    					       	pkillscore=tostring("  "..ikscore);
    		  			             end
    	           				if (tonumber(ikscore)<0) and (tonumber(ikscore)>-10) then
    	   	           				pkillscore=tostring(" "..ikscore);
            					end
            				else
            				        pkillscore=0;
            				end
				end

				System:LogAlways("$5                       "..prcl.."  "..pclass.."$1"..pkillscore.."    "..Entity:GetEntryXY(ScoreboardTableColumns.sName,iY));
			end
		end
	end
	
	if (GameRules) then
	
	    	System:LogAlways("Players connecting/crashed:");
	    	--show connecting/and or crashed players
		local Slots = Server:GetServerSlotMap();
		for i,ServerSlot in Slots do
			local slotNumber = ServerSlot:GetId();
			local playerId = ServerSlot:GetPlayerId();
			local player = System:GetEntity(playerId);
			if not (player) then
				System:LogAlways("ID: "..slotNumber.." CONNECTING");
			end
		end
	end

	System:LogAlways("");
end


function SVcommands:SVforceNone()
	setglobal("gr_forcebluejoin",0);
	setglobal("gr_forceredjoin",0);
	System:LogAlways("Teams Unlocked");
end

function SVcommands:SVlockTeam(team)
	setglobal("gr_forcebluejoin",0);
	setglobal("gr_forceredjoin",0);
	if team=="red" then
		setglobal("gr_forcebluejoin",1);
		System:LogAlways("$4Red Team $olocked");
	end
	if team=="blue" then
		setglobal("gr_forceredjoin",1);
		System:LogAlways("$2Blue Team $olocked");
	end
	
end

function SVcommands:SVunlockTeam(team)
	if team=="red" then
		setglobal("gr_forcebluejoin",0);
		System:LogAlways("$4Red Team $ounlocked");
	end
	if team=="blue" then
		setglobal("gr_forceredjoin",0);
		System:LogAlways("$2Blue Team $ounlocked");
	end
	
end

function SVcommands:SVunlockall()
	SVcommands:SVforceNone();  --release forced team join
	for tr_id, player in PlayerTrack do
		local pId=player["pid"];
		SVplayerTrack:SetById(pId, "forcedteam", "", 0);
	end
	System:LogAlways("Released ALL teamlocks");
end

--protected names functions--

function SVcommands:loadProtected()
	local namesFile = openfile("profiles/server/p_names.txt", "r");
	if(namesFile) then
		protectedNames.namelist = {};
		protectedNames.vn=1;
		local name = read(namesFile, "*l");
		while(name) do
			SVcommands:addProtectedName(name);
			name = read(namesFile, "*l");
		end
		closefile(namesFile);
		System:LogAlways("Loaded protected names");
	else
		--System:LogAlways("No protected names found (..profiles/server/p_names.txt)");
	end
end

function SVcommands:addProtectedById(pId)
	local ss = Server:GetServerSlotBySSId(pId);
	if ss then
		local name = ss:GetName();
		SVcommands:addProtectedName(name);
		System:LogAlways("$oAdded "..name.." $oto protected names");
	else
		System:LogAlways(pId.."$o not found on list");
	end
end

function SVcommands:addProtectedName(name)
	protectedNames.namelist[protectedNames.vn]=name;
	protectedNames.vn=protectedNames.vn+1;
end

function SVcommands:clearProtected()
	protectedNames.namelist = {};
	protectedNames.vn=1;
	System:LogAlways("$oUnloaded all protected names");
end


function SVcommands:printProtectedNames()
	for i, name in protectedNames.namelist do
		System:LogAlways(protectedNames.namelist[i]);
	end
end

function SVcommands:saveProtected()
	local namesFile = openfile("profiles/server/p_names.txt", "w");
	if(namesFile) then 
		for i, pname in protectedNames.namelist do
			write(namesFile, protectedNames.namelist[i].."\n");
		end
		closefile(namesFile);
		System:LogAlways("$oSaved all protected names to profiles/server/p_names.txt");
	end
end


function SVcommands:ProtectedName(name)
	for i, pname in protectedNames.namelist do
		if name==protectedNames.namelist[i] then
			return 1;
		end
	end
	return 0;
end

function SVcommands:requestSpawn(server_slot)
	--if toNumberOrZero(getglobal("gr_allow_teamkilling"))~=1 or toNumberOrZero(getglobal("gr_static_respawn"))>0 then
	local punishTime = toNumberOrZero(SVplayerTrack:GetBySs(server_slot, "extrarespawn"));
	
	if punishTime==0 then 
		return 1;
	end
	local waitSecs=(toNumberOrZero(server_slot.last_death)+punishTime)-floor(_time);
	if waitSecs>0 then
		local reason=tostring(SVplayerTrack:GetBySs(server_slot, "reason"));
		if reason == "" then
			reason="unknown";
		end
		reason=tostring("$o(reason: "..reason.."$o)");
		if tonumber(floor(_time))~=tonumber(SVplayerTrack:GetBySs(server_slot, "lastmess")) then 
			server_slot:SendText("Cannot spawn "..reason.." wait $6"..floor(waitSecs).."$o seconds");
			SVplayerTrack:SetBySs(server_slot, "lastmess", tonumber(floor(_time)),0);
			SVplayerTrack:SetBySs(server_slot, "requestedspawn", 1 , 0);
		end
		return 0;
	end
	SVplayerTrack:SetBySs(server_slot, "extrarespawn", 0, 0);
	SVplayerTrack:SetBySs(server_slot, "reason", "", 0);
	SVplayerTrack:SetBySs(server_slot, "lastmess", 0, 0);
	--end
	return 1;
end


function SVcommands:TKJudge(pId,cId)
	local slot = Server:GetServerSlotBySSId(pId);
	if (slot ~=nil) then
		SVplayerTrack:SetBySs(slot, "TKjudge", pId, 0);
		SVplayerTrack:SetBySs(slot, "TKcriminal", cId, 0);
		return cId;
	end
	return nil;
end

function SVcommands:TKActive(pId)
	local slot = Server:GetServerSlotBySSId(pId);
	if (slot ~= nil) then
        	if (toNumberOrZero(SVplayerTrack:GetBySs(slot, "TKjudge")) > 0) then
        	       	return 1;
	      end
	end
	return nil;
end

function SVcommands:TKVerdict(pId,cId,verdict)
	local slot = Server:GetServerSlotBySSId(pId);
	if (slot==nil) then
		return;
	end
	if (toNumberOrZero(SVplayerTrack:GetBySs(slot, "TKjudge")) > 0) then
		SVplayerTrack:SetBySs(slot, "TKjudge", 0, 0);
        	SVplayerTrack:SetBySs(slot, "TKcriminal", 0, 0);
	
		if (verdict==1) then
		--SVcommands:punishPlayer(cId.." 10 for TK punishment");  
	         local ss_criminal = Server:GetServerSlotBySSId(cId);
	          GameRules:PunishforTK(cId,pId);
		end
		if (verdict==0 and cId~=0) then
			System:Log(cId.."'s TK forgiven");
		end
		if (verdict==-1 or cId==0) then
			System:Log("TK timeout");
		end
		return nil;
	end
end

function SVcommands:punishPlayer(line)
	--id, <time> <reason>
	if (line) then
		toktable = tokenize(line);
		local time=0;
		local reason="";
		if toktable[1] then
			local pId=tonumber(toktable[1]);
			if toktable[2] then 
				time=toNumberOrZero(toktable[2]);
			end
			tremove(toktable, 1);
			tremove(toktable, 1);
			reason = untokenize(toktable);
			local server_slot = Server:GetServerSlotBySSId(pId);
			if server_slot then
				GameRules:Invoke("OnKill", server_slot);
				if time>0 then
					SVplayerTrack:SetBySs(server_slot, "extrarespawn", time, 0);
					SVplayerTrack:SetBySs(server_slot, "reason", reason, 0);
				end
				if reason ~= "" then
					local timestr="";
					if time>0 then
						timestr=tostring("$o > $6"..time.." $osecond penalty");
					end
					Server:BroadcastText(server_slot:GetName().." $ohas been punished. Reason: "..reason.."$o"..timestr);
				end
				return;
			end			
		end
	end
	System:LogAlways("Usage: gr_punish [pId] <extra respawn time> <reason>");
end

function SVcommands:SetSVplayerClass(id,pclx)
	local server_slot = Server:GetServerSlotBySSId(id);
	if server_slot then
		if pclx=="sniper1" then
			SVcommands:SetPC(server_slot,"Sniper",1,1,1,0);
		elseif pclx=="sniper2" then
			SVcommands:SetPC(server_slot,"Sniper",1,1,2,0);
		elseif pclx=="sniper3" then
			SVcommands:SetPC(server_slot,"Sniper",1,2,1,0);
		elseif pclx=="sniper4" then
			SVcommands:SetPC(server_slot,"Sniper",1,2,2,0);	
		elseif pclx=="engy1" then
			SVcommands:SetPC(server_slot,"Support",1,1,1,1);
		elseif pclx=="engy2" then
			SVcommands:SetPC(server_slot,"Support",1,1,2,1);
		elseif pclx=="engy3" then
			SVcommands:SetPC(server_slot,"Support",1,2,1,1);
		elseif pclx=="engy4" then
			SVcommands:SetPC(server_slot,"Support",1,2,2,1);
		elseif pclx=="grunt1" then
			SVcommands:SetPC(server_slot,"Grunt",1,1,1,1);
		elseif pclx=="grunt2" then
			SVcommands:SetPC(server_slot,"Grunt",1,1,1,2);
		elseif pclx=="grunt3" then
			SVcommands:SetPC(server_slot,"Grunt",1,1,1,3);
		elseif pclx=="grunt4" then
			SVcommands:SetPC(server_slot,"Grunt",1,1,2,1);
		elseif pclx=="grunt5" then
			SVcommands:SetPC(server_slot,"Grunt",1,1,2,2);
		elseif pclx=="grunt6" then
			SVcommands:SetPC(server_slot,"Grunt",1,1,2,3);
		else
			System:LogAlways("Usage: gr_cpc [playerid] [class]");
			System:LogAlways("Possible classes:");
			System:LogAlways("sniper1   - Sniper with Pistol and Sniper Rifle");
			System:LogAlways("sniper2   - Sniper with Pistol and Rocket Launcher");
			System:LogAlways("sniper3   - Sniper with MP5SD and Sniper Rifle");
			System:LogAlways("sniper4   - Sniper with MP5SD and Rocket Launcher");
			System:LogAlways("engineer1 - Engineer with M4 and Bombs");
			System:LogAlways("engineer2 - Engineer with M4 and Med Packs");
			System:LogAlways("engineer3 - Engineer with MP5SD and Bombs");
			System:LogAlways("engineer4 - Engineer with MP5SD and Med Packs");
			System:LogAlways("grunt1    - Grunt with P90 and AG36");
			System:LogAlways("grunt2    - Grunt with P90 and OICW");
			System:LogAlways("grunt3    - Grunt with P90 and SAW");
			System:LogAlways("grunt4    - Grunt with Shotgun and AG36");
			System:LogAlways("grunt5    - Grunt with Shotgun and OICW");
			System:LogAlways("grunt6    - Grunt with Shotgun and SAW");
		end
	else
		System:LogAlways("Invalid playerid. Usage: gr_cpc [playerid] [class]");
	end
end

function SVcommands:SetPC(server_slot, pcl, weapon1, weapon2,  weapon3, weapon4)
	local pclass=MultiplayerClassDefiniton.PlayerClasses[pcl];
	if pclass~=nil then
		server_slot.InitialPlayerProperties={};
		server_slot.InitialPlayerProperties.StaminaTable=pclass.StaminaTable;
		server_slot.InitialPlayerProperties.move_params=pclass.move_params;
		server_slot.InitialPlayerProperties.health=pclass.health;
		server_slot.InitialPlayerProperties.armor=pclass.armor;
		server_slot.InitialPlayerProperties.model=pclass.model;
			
		local mypack={};
		local no=1;
		
		if weapon1 and pclass.weapon1[weapon1] then
			mypack[no]={ Type="Weapon", Name=pclass.weapon1[weapon1], };
			no=no+1;
		end
		if weapon2 and pclass.weapon2[weapon2] then
			mypack[no]={ Type="Weapon", Name=pclass.weapon2[weapon2], };
			no=no+1;
		end
		if weapon3 and pclass.weapon3[weapon3] then
			mypack[no]={ Type="Weapon", Name=pclass.weapon3[weapon3], };
			no=no+1;
		end
		if weapon4 and pclass.weapon4[weapon4] then
			mypack[no]={ Type="Weapon", Name=pclass.weapon4[weapon4], };
			no=no+1;
		end
		

		if (pclass.primaryWeaponSlot ~= nil) then
			mypack[pclass.primaryWeaponSlot].Primary = 1;
		end
		mypack.Ammo=pclass.InitialAmmo;


		if (pclass.items ~= nil) then
			for i, item in pclass.items do
				mypack[no] = { Type="Item", Name = item, };
				no = no + 1;
			end
		end
		local PlayerEntity=GetSlotPlayer(server_slot);
		local packname;


		if not server_slot.uniqueServerSlotName then
			server_slot.uniqueServerSlotName = "NetPlayerPack" .. count(EquipPacks);
		end
		packname = server_slot.uniqueServerSlotName;
		EquipPacks[ packname ] = mypack; 
		server_slot.InitialPlayerProperties.equipEquipment=packname;
		server_slot.InitialPlayerProperties.sPlayerClass=pcl;
			
		local team = Game:GetEntityTeam(PlayerEntity.id);
		if team~="spectators" then
			local iCurstate=GameRules:GetGameState();
			if iCurstate~=CGS_INPROGRESS then
				GameRules:ChangeTeam(server_slot,team,1);	
			end
		end
	end
end

function SVcommands:DisplaySpawnMessage(server_slot)
	local mes;
	for i=1, 4 do
		mes=tostring(getglobal("gr_spawnmessage"..i));
		if mes~="" then
			server_slot:SendText(mes,3);
			

		end
	end
end

function SVcommands:LoadConfig(fname)
	SVcommands:LoadConfigfile(fname,0);
end

function SVcommands:LoadConfig1(fname)
	SVcommands:LoadConfigfile(fname,1);
end


function SVcommands:LoadConfigfile(fname,restart)
	if (Script:LoadScript('profiles/server/'..tostring(fname)..'.cfg', 1, 0)) then
		System:LogAlways("\001settings loaded '"..fname.."'.");
		if (toNumberOrZero(restart) == 1) then
			
			Game:LoadLevelMPServer(getglobal('gr_NextMap'));
			Script:LoadScript("scripts/default/entities/weapons/WeaponsParams.lua");
			Script:LoadScript("scripts/default/entities/weapons/OICWgrenade.lua");
			Script:LoadScript("scripts/default/entities/weapons/Rocket.lua");
			Script:LoadScript("scripts/default/entities/weapons/AG36Grenade.lua");
			
		end
		return 1;
	elseif (Script:LoadScript('profiles/server/'..tostring(fname), 1, 0)) then
		System:LogAlways("\001settings loaded '"..fname.."'.");
		if (toNumberOrZero(restart) == 1) then
			
			Game:LoadLevelMPServer(getglobal('gr_NextMap'));
			Script:LoadScript("scripts/default/entities/weapons/WeaponsParams.lua");
			Script:LoadScript("scripts/default/entities/weapons/OICWgrenade.lua");
			Script:LoadScript("scripts/default/entities/weapons/Rocket.lua");
			Script:LoadScript("scripts/default/entities/weapons/AG36Grenade.lua");
			
		end
		return 1;
	elseif (Script:LoadScript(tostring(fname), 1, 0)) then
		System:LogAlways("\001settings loaded '"..fname.."'.");
		if (toNumberOrZero(restart) == 1) then
			Game:LoadLevelMPServer(getglobal('gr_NextMap'));
			Script:LoadScript("scripts/default/entities/weapons/WeaponsParams.lua");
			Script:LoadScript("scripts/default/entities/weapons/OICWgrenade.lua");
			Script:LoadScript("scripts/default/entities/weapons/Rocket.lua");
			Script:LoadScript("scripts/default/entities/weapons/AG36Grenade.lua");
			
		end
		return 1;
	end
	
	System:LogAlways("\001failed to open file '"..fname.."'.");
	
	return nil;
end


function SVcommands:PlaceRestartFile()
	local file=openfile("winsv_restart.txt","w");
	if file then 
		closefile(file);
		System:LogAlways("Reboot file created. The server will now reboot.");
		Server:BroadcastText(" $4<<<THIS SERVER WILL $6SHUTDOWN $4AND $3RESTART $4IN A FEW SECONDS>>>");
	end
end

--load the protected names
SVcommands:loadProtected();

if (getglobal("gr_checkfirststart"))~=1 then
	if (getglobal("sv_mapcyclefile")) then
		MapCycle:LoadFromFile(getglobal("sv_mapcyclefile"));
		setglobal("gr_checkfirststart",1);
	end
end

