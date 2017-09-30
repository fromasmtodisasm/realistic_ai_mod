SVplayerTrack={};

ptrack = {
	name="",            --playername
	pid="",             --player id
	guid="",            --guid, if pb is on (not implemented yet), else player id
	tks=0,              --teamkills
	extrarespawn=0,     --extra time to respawn, added to normal time (for teamkilling etc)
	reason="",          --message displayed when trying to spawn anyway
	requestedspawn=0,   --when a static spawn and/or punish is used, add player to spawnlist when time ran out
	forcedteam="",      --lock player to 1 team (red/blue/players) player can join specators. if forcedteam=spectators, player CANNOT join
	cannotrejoin=0,     --kick on reconnect
	lastmess=0,         --floored time wich last message was sent
	killstreak=0,       --number of kills without dying
	averageping=0,	    --average ping
	pingcounts=0,       --number of times ping checked
	pingwarnings=0,     --number of times average ping too high
	rm_killtimer=0,     --time rambo move expires  (rambo move)
	rm_kills=0,         --number of kills counting for rambo move (will reset when time expires)
	rm_flagstate=0,     --0 = not captured, 1 = activated, 2=captured ,3 = captured, running in extend mode (flagstate for THIS player)
	rm_movecount=0,     --number of rambomoves completed on that map
	rm_t_flagactivated=0,   --time flag was activated
	connectcheck=0,     --used for autokick players that crashed during connection or some other fkng reason
	
	flagssaved=0,       --number of saved flags
	flagsactivated=0,   --number of activated flags
	flagscaptured=0,    --number of captured flags
	headshots=0,        --number of headshots
	kills=0,            --number of kills
	selfkills=0,        --number of self-kills
	hkillstreak=0,      --highest killing spree
	flagactkills=0,     --kills made when flag is activated
	lastclass="Spectator",       --last class
	lastteam="spectators",        --last team
	wu_machete=0,       --kills with machete
	wu_grenade=0,       --kills with grenade
	wu_vehicle=0,       --kills with vehicle
	wu_sniper=0,        --kills with sniper
	wu_other=0,         --other

	bulletsfired=0,       --bullets fired
	bulletshit=0,         --bullets hit
	deaths=0,             --deaths
	TKcrime=0,
	TKjudge=0,
}
	

PlayerTrack = {}


---playertracking debug---
--Game:AddCommand("gr_pt_init","SVplayerTrack:Init();","");    
--Game:AddCommand("gr_pt_add","SVplayerTrack:AddPlayer(%1);","");    
Game:AddCommand("gr_pt_print","SVplayerTrack:PrintPlayer(%1);",""); 
--Game:AddCommand("gr_pt_printall","SVplayerTrack:PrintAll();","");  
--Game:AddCommand("gr_pt_set","SVplayerTrack:SetById(%1,%2,%3,%4);","");
--Game:AddCommand("gr_pt_reset","SVplayerTrack:ResetTkById(%1);","");



function SVplayerTrack:SetById(pId, entry, value, add)
	local tr_id=SVplayerTrack:GetTrackId(pId);
	if tr_id ~=nil then 
   		SVplayerTrack:Set(tr_id, entry, value, add);
     	else
     		System:LogAlways("error: playertracking > cant find tr_id for pid "..pId);
     	end
end

function SVplayerTrack:SetBySs(server_slot, entry, value, add)
	local pId=server_slot:GetId();
	local tr_id=SVplayerTrack:GetTrackId(pId);
	if tr_id ~=nil then 
   		SVplayerTrack:Set(tr_id, entry, value, add);
     	else
     		System:LogAlways("error: playertracking > cant find tr_id for pid "..pId);
     	end
end

function SVplayerTrack:SetStaticSpawn(server_slot)
	if toNumberOrZero(getglobal("gr_static_respawn"))>0 then
		SVplayerTrack:SetBySs(server_slot, "extrarespawn", toNumberOrZero(getglobal("gr_static_respawn")), 1);
		SVplayerTrack:SetBySs(server_slot, "reason", "$6fixed respawn timer", 0);
		SVplayerTrack:SetBySs(server_slot, "requestedspawn", 0, 0);
	end
end

function SVplayerTrack:CheckRespawn()
	if floor(_time)==toNumberOrZero(getglobal("gr_last_spawn_checked")) then
		return;
	end
	local slots=Server:GetServerSlotMap()
	for i, slot in slots do
		local ent = System:GetEntity(slot:GetPlayerId());
		if ent and ent.type=="Player" then
			if SVplayerTrack:GetBySs(slot, "requestedspawn")==1 and SVplayerTrack:SpawnAllowed(slot)==1 then
				GameRules:RespawnPlayer(slot);
			end
		end
	end
	setglobal("gr_last_spawn_checked", tonumber(floor(_time)));
end


function SVplayerTrack:SpawnAllowed(server_slot)
	local waittime = toNumberOrZero(SVplayerTrack:GetBySs(server_slot, "extrarespawn"));
	if waittime == 0 then 
		return 1;
	end
	local waitSecs=(toNumberOrZero(server_slot.last_death)+waittime)-floor(_time);
	if waitSecs > 0 then
		return 0;
	end
	return 1;
end

function SVplayerTrack:SetWeaponKill(server_slot, weapon)
	local pId=server_slot:GetId();
	local tr_id=SVplayerTrack:GetTrackId(pId);
	if tr_id ~=nil then 
		local wentry="wu_other";
		if weapon=="Machete" then
			wentry="wu_machete";
		end
		if (weapon=="Grenade") or (weapon=="HandGrenade") then
			wentry="wu_grenade";
		end
		if weapon=="SniperRifle" then
			wentry="wu_sniper";
		end
		if (weapon=="Boat") or (weapon=="Vehicle") then
			wentry="wu_vehicle";
		end
		
		SVplayerTrack:Set(tr_id, wentry, 1, 1);
     	else
     		System:LogAlways("error: playertracking > cant find tr_id for pid "..pId);
     	end
end
function SVplayerTrack:GetById(pId, entry)
	local tr_id=SVplayerTrack:GetTrackId(pId);
	if tr_id ~=nil then 
   		return SVplayerTrack:Get(tr_id, entry);
     	else
     		System:LogAlways("error: playertracking > cant find tr_id for pid "..pId);
     	end
     	return -1;
end



function SVplayerTrack:GetBySs(server_slot, entry)
	local pId=server_slot:GetId();
	local tr_id=SVplayerTrack:GetTrackId(pId);
	
	if tr_id ~=nil then 
   		return SVplayerTrack:Get(tr_id, entry);
     	else
     		System:LogAlways("error: playertracking > cant find tr_id for pid "..pId);
     	end
     	return -1;
end


function SVplayerTrack:Set(tr_id, entry, value, add)
	if tonumber(add)==1 then
		value=value+PlayerTrack[tr_id][entry];
	end
	PlayerTrack[tr_id][entry]=value;
end
				
function SVplayerTrack:Get(tr_id, entry)
	return PlayerTrack[tr_id][entry];
end

function SVplayerTrack:Init()
	PlayerTrack={};
end

function SVplayerTrack:AddPlayer(pId)
	
	local pt_pl=new(ptrack);
     	local ss=Server:GetServerSlotBySSId(pId);
	local keyid=SVplayerTrack:TrackingKey(pId);
     	
     	if ss then
		pt_pl["name"]=ss:GetName();
		pt_pl["pid"]=pId;
		pt_pl["guid"]=pId;  --PB***
		
		PlayerTrack[keyid]=pt_pl;
    	end
    	return keyid;
end

function SVplayerTrack:GetTrackId(pId)
	local tr_id;
	for tr_id, pt_pl in PlayerTrack do
		if tonumber(pt_pl["pid"])==tonumber(pId) then
			return tr_id;
		end
	end
	return SVplayerTrack:AddPlayer(pId);  --create new player
end


function SVplayerTrack:PrintAll()
	local tr_id
	for tr_id, pt_pl in PlayerTrack do
		SVplayerTrack:PrintPlayer(pt_pl["pid"]);
	end
end

function SVplayerTrack:PrintPlayer(pId)
	
	local ent=SVplayerTrack:GetEntityByPid(pId);
	if ent~=nil then
		System:LogAlways("name               ="..ent["name"]);
		System:LogAlways("pid                ="..ent["pid"]);
		System:LogAlways("guid               ="..ent["guid"]);
		System:LogAlways("tks                ="..ent["tks"]);
		System:LogAlways("extrarespawn       ="..ent["extrarespawn"]);
		System:LogAlways("reason             ="..ent["reason"]);
		System:LogAlways("forcedteam         ="..ent["forcedteam"]);
		System:LogAlways("cannotrejoin       ="..ent["cannotrejoin"]);
		System:LogAlways("lastmess           ="..ent["lastmess"]);
		System:LogAlways("killstreak         ="..ent["killstreak"]);
		System:LogAlways("averageping        ="..ent["averageping"]);
		System:LogAlways("pingcounts         ="..ent["pingcounts"]);
		System:LogAlways("pingwarnings       ="..ent["pingwarnings"]);
		System:LogAlways("rm_killtimer       ="..ent["rm_killtimer"]);
		System:LogAlways("rm_kills           ="..ent["rm_kills"]);
		System:LogAlways("rm_flagstate       ="..ent["rm_flagstate"]);
		System:LogAlways("rm_movecount       ="..ent["rm_movecount"]);
		System:LogAlways("rm_t_flagactivaged ="..ent["rm_t_flagactivated"]);
		
	end
end

function SVplayerTrack:GetEntityByPid(pId)
	local tr_id;
	local pt_pl;
	for tr_id, pt_pl in PlayerTrack do
		if tonumber(pt_pl["pid"])==tonumber(pId) then
			return pt_pl;
		end
	end
	return nil;
end

function SVplayerTrack:GetEntityBySs(server_slot)
	local pId=server_slot:GetId();
	local tr_id;
	local pt_pl;
	for tr_id, pt_pl in PlayerTrack do
		if tonumber(tr_id["pid"])==tonumber(pId) then
			return pt_pl;
		end
	end
	return nil;
end
function SVplayerTrack:TrackingKey(pId)
	---PB*** (pb_guid)
	return pId;
end

function SVplayerTrack:ExportStats()
	local mapinfoprinted=0;
	local hasplayers=0;
	for tr_id, pt_pl in PlayerTrack do  --yeah i know, too tired to bother
		hasplayers=1;
	end
	if hasplayers == 0 then 
		return;
	end
	local file=openfile(SVplayerTrack:GetFreeFile(),"w");
	if file then 
		for tr_id, pt_pl in PlayerTrack do
			if mapinfoprinted==0 then
				write(file,"Servername : "..Server:GetName().."\n");
				write(file,"Map        : "..Game:GetLevelName().."\n");
				mapinfoprinted=1;
			end
			local pid=SVplayerTrack:Get(tr_id,"pid");
			if pid~="" then
			
				local ss = Server:GetServerSlotBySSId(pid);
				local teamn="unknown";
				local plcass="unknown";
				local score="unknown";
				if ss then
					local plEnt=ss:GetPlayerId();
					teamn="<left_game>";
					pclass="<left_game>";
					if plEnt then
						if Game:GetEntityTeam(plEnt) then 
							teamn=Game:GetEntityTeam(plEnt);  --not in use
							pclass=ss.InitialPlayerProperties.sPlayerClass;  -- not in use
							score=GameRules:CalcPlayerScore(ss);
						end
					end
				else
					teamn="<left_game>";
					pclass="<left_game>";
				end
				write(file,"----------------------------------------------------------\n");
				write(file,"Name                  : "..pt_pl["name"].."\n"); 
				--write(file,"Team                  : "..teamn.."\n"); 
				--write(file,"Class                 : "..pclass.."\n");
				write(file,"Team                  : "..pt_pl["lastteam"].."\n"); 
				write(file,"Class                 : "..pt_pl["lastclass"].."\n");
				write(file,"----------------------------------------------------------\n");
				write(file,"Score                 : "..score.."\n");
				write(file,"Kills                 : "..pt_pl["kills"].."\n"); 
				write(file,"Deaths                : "..pt_pl["deaths"].."\n");
				write(file,"Teamkills             : "..pt_pl["tks"].."\n"); 
				write(file,"Selfkills             : "..pt_pl["selfkills"].."\n"); 
				write(file,"Flag_activated_kills  : "..pt_pl["flagactkills"].."\n"); 
				write(file,"Headshots             : "..pt_pl["headshots"].."\n"); 
				if toNumberOrZero(getglobal("gr_killing_spree"))>0 then
					write(file,"Highest_killing_spree : "..pt_pl["hkillstreak"].."\n"); 
				end
				write(file,"Flags_captured        : "..pt_pl["flagscaptured"].."\n"); 
				write(file,"Flags_activated       : "..pt_pl["flagsactivated"].."\n"); 
				write(file,"Flags_saved           : "..pt_pl["flagssaved"].."\n"); 
				if toNumberOrZero(getglobal("gr_rm_needed_kills"))>0 then
					write(file,"super_flag_captures : "..pt_pl["rm_movecount"].."\n");
				end
				if toNumberOrZero(getglobal("gr_max_average_ping"))>0 then
					write(file,"Average_ping          : "..pt_pl["averageping"].."\n"); 
				end
				write(file,"Kills_with_knife      : "..pt_pl["wu_machete"].."\n");
				write(file,"Kills_with_grenades   : "..pt_pl["wu_grenade"].."\n");
				write(file,"Kills_with_sniper     : "..pt_pl["wu_sniper"].."\n");
				write(file,"Kills_with_vehicle    : "..pt_pl["wu_vehicle"].."\n");
				write(file,"Kills_with_other      : "..pt_pl["wu_other"].."\n");
				write(file,"Bullets_fired         : "..pt_pl["bulletsfired"].."\n");
				write(file,"Bullets_hit           : "..pt_pl["bulletshit"].."\n");
				write(file,"END\n");
			end
		end
		closefile(file);
	end
end

function SVplayerTrack:GetFreeFile()

	local i=1;
	local retFile="";
	while (retFile=="") do
		local filename=SVplayerTrack:GetStatsfilename(i);
		local file=openfile(filename,"r");
		if (file) then 
			closefile(file);
			i=i+1;
		else
			retFile=filename;
		end
	end
	return retFile;
end

function SVplayerTrack:GetStatsfilename(num)
	return tostring(getglobal("gr_stats_dir").."statsfile_"..date("%y")..date("%m")..date("%d").."_"..Game:GetLevelName().."_"..num..".txt");
end

function SVplayerTrack:OnConnect(server_slot)  
	--PB***
	--player (re)connects, find old slot, if so, copy values
	
	SVcommands:DisplaySpawnMessage(server_slot);
	
	local name=server_slot:GetName();
	local id=server_slot:GetId();
	local tr_id;
	local pt_pl;
	for tr_id, pt_pl in PlayerTrack do
		if (pt_pl["name"]==name and pt_pl["pid"]~=id) then
	              	SVplayerTrack:AddPlayer(id);  --create new stats for new id
	              	local newtr_id = SVplayerTrack:TrackingKey(id);
	              	if newtr_id then
				PlayerTrack[newtr_id]=pt_pl; --copy old values
				PlayerTrack[newtr_id]["pid"]=id;    --overwrite with new id
				PlayerTrack[newtr_id]["guid"]=id;  --overwrite with new id --PB***
				PlayerTrack[tr_id]=new(ptrack); --reset existing (old) one
				return;
			end
		end
	        if (pt_pl["name"]==name and pt_pl["pid"]==id) then
	        	return;  --logged in on same id 
		end
	end
	SVplayerTrack:AddPlayer(id);  -- player not found, create new
end

function SVplayerTrack:ResetTkById(pId)
	SVplayerTrack:SetById(pId, "tks", 0, 0);
end

function SVplayerTrack:OnRespawn(server_slot)
	SVplayerTrack:RMResetOne(server_slot);
	SVplayerTrack:SetBySs(server_slot, "extrarespawn", 0, 0);  --should be here, in case of reconnect. player should then still be punished if punished at all.
	SVplayerTrack:SetBySs(server_slot, "requestedspawn", 0, 0);
end

function SVplayerTrack:RMResetOne(server_slot)
	--reset rambo move stats, and update highest killing spree
	local killstreak=SVplayerTrack:GetBySs(server_slot,"killstreak");
	if (killstreak>SVplayerTrack:GetBySs(server_slot,"hkillstreak")) then
		SVplayerTrack:SetBySs(server_slot,"hkillstreak",killstreak,0);
	end
	SVplayerTrack:SetBySs(server_slot,"killstreak",0,0);
	SVplayerTrack:SetBySs(server_slot,"rm_killtimer",0,0);
	SVplayerTrack:SetBySs(server_slot,"rm_kills",0,0);
	SVplayerTrack:SetBySs(server_slot,"rm_flagstate",0,0);	
end

function SVplayerTrack:RMAddKill(server_slot)
	--add kill to rambomove
	local killtimer=SVplayerTrack:GetBySs(server_slot,"rm_killtimer");
	if toNumberOrZero(killtimer)<_time and SVplayerTrack:GetBySs(server_slot,"rm_flagstate")~=1 then  --timer expired, or timer=0, and flag not activated by this player
		killtimer=_time;
		SVplayerTrack:SetBySs(server_slot,"rm_kills", 0, 0);		
		SVplayerTrack:SetBySs(server_slot,"rm_flagstate", 0, 0);
	end
	killtimer=killtimer+toNumberOrZero(getglobal("gr_rm_kill_addtime"));
	SVplayerTrack:SetBySs(server_slot,"rm_killtimer", killtimer, 0);
	SVplayerTrack:SetBySs(server_slot,"rm_kills", 1, 1);
	SVplayerTrack:RMCheckShowMess(server_slot);  -- check to show message
end

function SVplayerTrack:RMFlagActivated(server_slot)
	--flag activated
	if SVplayerTrack:GetBySs(server_slot,"rm_killtimer")<_time then
		SVplayerTrack:SetBySs(server_slot,"rm_kills",0,0);  	
	end
	SVplayerTrack:SetBySs(server_slot,"rm_flagstate",1,0);
	SVplayerTrack:SetBySs(server_slot,"rm_t_flagactivated",_time,0);  --time activated	
end

function SVplayerTrack:RMFlagCaptured(server_slot)
	--flag captured
	SVplayerTrack:SetBySs(server_slot,"rm_flagstate",2,0);
	local tdiff=_time - SVplayerTrack:GetBySs(server_slot,"rm_t_flagactivated");
	SVplayerTrack:RMAddKilltimer(server_slot, tdiff);  --refund flag activated time
	SVplayerTrack:SetBySs(server_slot,"rm_t_flagactivated", 0, 0);  --reset flag act. time
	SVplayerTrack:RMCheckShowMess(server_slot);
end

function SVplayerTrack:RMAddKilltimer(server_slot, killtime)
	local oldtime=SVplayerTrack:GetBySs(server_slot,"rm_killtimer");
	if oldtime<=_time then
		oldtime=_time;
	end
	SVplayerTrack:SetBySs(server_slot,"rm_killtimer",oldtime+killtime,0);
end


function SVplayerTrack:RMFlagSaved()
	--flag saved, correct rm_values of other players
	--local pid = server_slot:GetId();
	--local this_tr_id = SVplayerTrack:GetTrackId(pId);
	local tr_id;
	for tr_id, pt_pl in PlayerTrack do
		SVplayerTrack:Set(tr_id, "rm_flagstate", 0 ,0);  --reset all flag states
		if SVplayerTrack:Get(tr_id, "rm_t_flagactivated")>0 then
			local tdiff=_time - SVplayerTrack:Get(tr_id,"rm_t_flagactivated");
			local oldtime=SVplayerTrack:Get(tr_id,"rm_killtimer");
			if oldtime<=_time then
				oldtime=_time;
			end
			SVplayerTrack:Set(tr_id,"rm_killtimer",oldtime+tdiff, 0);
			SVplayerTrack:Set(tr_id, "rm_t_flagactivated", 0, 0);  --refund flag activated time				
			
		end
	end
	
end

function SVplayerTrack:RMReset()
	local tr_id;
	for tr_id, pt_pl in PlayerTrack do
		SVplayerTrack:Set(tr_id, "rm_killtimer", 0 ,0);  
		SVplayerTrack:Set(tr_id, "rm_kills", 0 ,0);  
		SVplayerTrack:Set(tr_id, "rm_flagstate", 0 ,0);  
		--SVplayerTrack:Set(tr_id, "rm_movecount", 0 ,0);  --maybe of use for statistics
	end
end

function SVplayerTrack:RMCheckShowMess(server_slot)
	--check if message needs to be displayed"
	local countstr="";
	local mcount=SVplayerTrack:GetBySs(server_slot, "rm_movecount");
	if mcount==1 then 
		countstr = "DOUBLE ";
	elseif mcount==2 then
		countstr = "TRIPLE ";
	end
	local flagstate=SVplayerTrack:GetBySs(server_slot, "rm_flagstate");
	if flagstate<2 then
		return;
	end
	if flagstate == 3 then  --extended rm move
		local rmkills=SVplayerTrack:GetBySs(server_slot, "rm_kills");
		if rmkills >= toNumberOrZero(getglobal("gr_rm_needed_kills")) then
			Server:BroadcastText(" $o"..server_slot:GetName().." $6added a kill to his $4GODLIKE FLAG CAPTURE $6($4"..SVplayerTrack:GetBySs(server_slot,"rm_kills").." $6kills)");
		end
	end
	if flagstate == 2 then
		local rmkills=SVplayerTrack:GetBySs(server_slot, "rm_kills");
		if rmkills >= toNumberOrZero(getglobal("gr_rm_needed_kills")) then
			Server:BroadcastText("$6 >>> $4"..countstr.."GODLIKE FLAG CAPTURE $6<<< performed by $o"..server_slot:GetName().." $6(killing $4"..SVplayerTrack:GetBySs(server_slot,"rm_kills").." $6defenders at the spot)");
			Server:BroadcastText("$6 >>> $4"..countstr.."GODLIKE FLAG CAPTURE $6<<< performed by $o"..server_slot:GetName().." $6(killing $4"..SVplayerTrack:GetBySs(server_slot,"rm_kills").." $6defenders at the spot)");
			Server:BroadcastText("$6 >>> $4"..countstr.."GODLIKE FLAG CAPTURE $6<<< performed by $o"..server_slot:GetName().." $6(killing $4"..SVplayerTrack:GetBySs(server_slot,"rm_kills").." $6defenders at the spot)");
			Server:BroadcastText("$6 >>> $4"..countstr.."GODLIKE FLAG CAPTURE $6<<< performed by $o"..server_slot:GetName().." $6(killing $4"..SVplayerTrack:GetBySs(server_slot,"rm_kills").." $6defenders at the spot)");
			SVplayerTrack:SetBySs(server_slot, "rm_flagstate", 3, 0);
			SVplayerTrack:SetBySs(server_slot, "rm_movecount", 1, 1);  --add rambo move count
		else
			SVplayerTrack:SetBySs(server_slot, "rm_flagstate", 0, 0);  --no rm, reset flag state 
		end
	end
end


function SVplayerTrack:DoPingKick()

	local Entity; 
	if GameRules then
		Entity = System:GetEntity(GameRules.idScoreboard).cnt;
	elseif ClientStuff then
		Entity = System:GetEntity(ClientStuff.idScoreboard).cnt;
	end

	local iY;
	local iLines=Entity:GetLineCount();
	
	local glMaxAveragePing = toNumberOrZero(getglobal("gr_max_average_ping"));
	local glPingWarnings = toNumberOrZero(getglobal("gr_ping_warnings"));
	local glInterval = toNumberOrZero(getglobal("gr_ping_check_interval"));
	
	if (glMaxAveragePing <= 0) then
		return;
	end
		
	for iY=0,iLines-1 do
		local pid = Entity:GetEntryXY(ScoreboardTableColumns.ClientID,iY)-1;
		
		if pid ~= -1 then
			
			local tr_id = SVplayerTrack:TrackingKey(pid);  --playertrack id
			local ss=Server:GetServerSlotBySSId(pid);  --server slot
			--local player=SVplayerTrack:GetEntityBySs(ss);
			if ss then 
				local name = ss:GetName();
				
				if tr_id and (SVcommands:ProtectedName(name)~=1) then
					
					local currentping = ss:GetPing()*2;
					local averageping = SVplayerTrack:GetBySs(ss,"averageping");
					local pingcounts = SVplayerTrack:GetBySs(ss,"pingcounts");
					local newaverage = (averageping * pingcounts + currentping )/(pingcounts + 1);
					
					if (toNumberOrZero(currentping) == 100 ) and ( toNumberOrZero(pingcounts) == 0 ) then 
						--do nothing, is a connection bug, first ping returns 100
					else
										
						SVplayerTrack:SetBySs(ss, "averageping", newaverage);
						SVplayerTrack:SetBySs(ss, "pingcounts", 1, 1);
						
						if (newaverage < glMaxAveragePing) then 
							SVplayerTrack:SetBySs(ss, "pingwarnings", 0, 0);  --reset, they need to be sequential
						elseif (SVplayerTrack:GetBySs(ss,"pingwarnings") >= glPingWarnings) then
						 	--kick, reached max warnings
						 	Server:BroadcastText("$o"..name.."$6 has been kicked for high average ping ($4"..floor(newaverage).."$6)");
							if toNumberOrZero(getglobal("gr_ping_reset_on_connect")) == 1 then
								SVplayerTrack:SetBySs(ss, "averageping" , 0);
								SVplayerTrack:SetBySs(ss, "pingcounts" , 0);
								SVplayerTrack:SetBySs(ss, "pingwarnings" , 0);
							end
							GameRules:KickSlot(ss);
						else
							SVplayerTrack:SetBySs(ss, "pingwarnings" , 1, 1);
							ss:SendText("$o"..name.." $4WARNING ("..SVplayerTrack:GetBySs(ss,"pingwarnings").."/"..glPingWarnings..") YOUR AVERAGE PING IS TOO HIGH! ($6"..floor(newaverage).."$4) (if it doesn't improve you will be kicked)",2);
						end 
					end
				end
			end
		end
	end
end

SVplayerTrack:Init();                                              
--System:LogAlways("playertracking initialised");



