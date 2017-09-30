-------------------------------------------------------------------------
--	Helper functions for GameRules with PlayerClass support implementation
--
--	created by MartinM
-------------------------------------------------------------------------

Script:LoadScript("SCRIPTS/MULTIPLAYER/GameRulesTeamLib.lua");				-- we derive from this
Script:LoadScript("SCRIPTS/MULTIPLAYER/MultiplayerClassDefiniton.lua");		-- global MultiplayerClassDefiniton
Script:LoadScript("Scripts/Multiplayer/SVplayerTrack.lua");
Script:LoadScript("Scripts/Multiplayer/SVcommands.lua");

GameRules.bSuppressDropWeapon=1;		-- nil is the default (checked in BasicWeapon.Server:Drop())

GameRules.InitialPlayerStatistics["nBuildingBuilt"]=0;				-- this entry can be used by MPStatistics:AddStatisticsDataEntity();
GameRules.InitialPlayerStatistics["nBuildingDestroyed"]=0;		-- this entry can be used by MPStatistics:AddStatisticsDataEntity();
GameRules.InitialPlayerStatistics["nBuildingRepaired"]=0;		-- this entry can be used by MPStatistics:AddStatisticsDataEntity();
GameRules.InitialPlayerStatistics["nHealed"]=0;								-- this entry can be used by MPStatistics:AddStatisticsDataEntity();

---------------------------------------------------------------
---------------------------------------------------------------
-- is called by ClassAmmoPickup
-- it now also passes whether this is a drop pack (from a dead player) or a regular pickup
-- \return nil if this is not working (e.g. ammo already at max), 1 otherwise
function GameRules:OnClassAmmoPickup( playerentity, isDropPack)
	if not playerentity.sCurrentPlayerClass then
		return;
	end
	
	local class=MultiplayerClassDefiniton.PlayerClasses[playerentity.sCurrentPlayerClass];
	
	if not class then
		return;											-- this ammo is only for player classes
	end

	-- reactivate scouttool and medictool weapons if necessary
	if (playerentity.currentEquipment) then
		for i, item in playerentity.currentEquipment do
			if (item.Type == "Weapon") then
				local weaponClass = getglobal(item.Name);
				if (weaponClass and weaponClass.switch_on_empty_ammo) then
					local weaponid = Game:GetWeaponClassIDByName(item.Name);
					if (weaponid~=nil) then
						playerentity.cnt:MakeWeaponAvailable(weaponid, 1);
					end
				end
			end
		end
	end
	
	local bChange=nil;
	
	-- select the correct pack
	local activeAmmoTable = nil;
	if (isDropPack ~= nil) then
		activeAmmoTable = class.DropAmmoPickup;
	else
		activeAmmoTable = class.AmmoPickup;
	end

	for i,val in activeAmmoTable do
		local old=playerentity:GetAmmoAmount(i);
		local amount = old + val;

		if amount>class.MaxAmmo[i] then					-- limit to max Ammo
			amount=class.MaxAmmo[i];
		end
		
		if amount~=playerentity:GetAmmoAmount(i) then
			bChange=1;
		end
	end

	if not bChange then 
		return;											-- pack was not neccessary
	end
	
	-- apply pack
	for i,val in activeAmmoTable do
		local old=playerentity:GetAmmoAmount(i);
		local amount = old + val;

		if amount>class.MaxAmmo[i] then					-- limit to max Ammo
			amount=class.MaxAmmo[i];
		end

		local toadd=amount-old;

		playerentity:AddAmmo(i,toadd);
	end
	
	return 1;											-- remove pack, it was used
end





-------------------------------------------------------------------------------
-- stats for respawning
function GameRules:GetInitialPlayerProperties(server_slot)
--	if not server_slot.InitialPlayerProperties then
--		server_slot:SendText("set your player class",3)
--	end

	return server_slot.InitialPlayerProperties;
end


-- ChangePlayerClass
-- e.g. CPC Sniper 2 1 1 1			to pick sniper class with weapon1[2] weapon2[1] weapon3[1] weapon4[1]
-- #Client:SendCommand("CPC Sniper 1 2 3 4")
-- #Client:SendCommand("CPC Mechanic 1 2 3 4")
GameRules.ClientCommandTable["CPC"]=function(String,server_slot,toktable)

	-- changed because class may not have the full weapon set
	-- for example, snipers only have 3 weapons
	if count(toktable) > 2 then

		local pclass=MultiplayerClassDefiniton.PlayerClasses[toktable[2]];
		
		if pclass~=nil then
--			System:Log("InitalPlayerStats set to "..pclass.model);
			server_slot.InitialPlayerProperties={};
			server_slot.InitialPlayerProperties.StaminaTable=pclass.StaminaTable;
			server_slot.InitialPlayerProperties.move_params=pclass.move_params;
			server_slot.InitialPlayerProperties.health=pclass.health;
			server_slot.InitialPlayerProperties.armor=pclass.armor;
			server_slot.InitialPlayerProperties.model=pclass.model;
			server_slot.InitialPlayerProperties.DynProp=pclass.DynProp;
			server_slot.InitialPlayerProperties.fallscale=pclass.fallscale;

				
			local weapon1=tonumber(toktable[3]);
			local weapon2=tonumber(toktable[4]);
			local weapon3=tonumber(toktable[5]);
			local weapon4=tonumber(toktable[6]);
			
			if (weapon1) and (weapon1<1 or weapon1>tonumber(count(pclass.weapon1))) then weapon1=1; end
			if (weapon2) and (weapon2<1 or weapon2>tonumber(count(pclass.weapon2))) then weapon2=1; end
			if (weapon3) and (weapon3<1 or weapon3>tonumber(count(pclass.weapon3))) then weapon3=1; end
			if (weapon4) and (weapon4<1 or weapon4>tonumber(count(pclass.weapon4))) then weapon4=1; end

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
			
			-- assign a primary weapon if we have specified one
			if (pclass.primaryWeaponSlot ~= nil) then
				mypack[pclass.primaryWeaponSlot].Primary = 1;
			end

			mypack.Ammo=pclass.InitialAmmo;

			-- add items to equipment pack
			if (pclass.items ~= nil) then
				for i, item in pclass.items do
					mypack[no] = { Type="Item", Name = item, };
					no = no + 1;
				end
			end

			local PlayerEntity=GetSlotPlayer(server_slot);
			local packname;

			-- simple solution to associate a serverslot with a equipmentpack
			if not server_slot.uniqueServerSlotName then
				server_slot.uniqueServerSlotName = "NetPlayerPack" .. count(EquipPacks);
			end
			packname = server_slot.uniqueServerSlotName;

			EquipPacks[ packname ] = mypack; 

			server_slot.InitialPlayerProperties.equipEquipment=packname;
			server_slot.InitialPlayerProperties.sPlayerClass=toktable[2];
			
			local team = Game:GetEntityTeam(PlayerEntity.id);

			if team~="spectators" then
				local iCurstate=GameRules:GetGameState();
				if iCurstate~=CGS_INPROGRESS then
					GameRules:ChangeTeam(server_slot,team,1);					-- apply class right now
				end
			end
		end
			
	end
end;


 -- RetrievePlayerCounts
 -- Client sends this command to request the number of players in each team and class
 --
 -- 	#Client:SendCommand("RPC");
 -- 
 -- Server should reply with the number of players in each team, and if classes are available, the number of players in each class for each team
 -- 	#ServerSlot:SendCommand("RPC TeamCount Class1Count Class2Count TeamCount Class1Count Class2Count");
 -- 	#ServerSlot:SendCommand("RPC 10 8 2 12 6 6");
 --
GameRules.ClientCommandTable["RPC"]=function(String,ServerSlot,TokTable)

	if (count(TokTable) ~= 1) then
		return;
	end

	local szReplyString = TokTable[1];
	
	-- Retrieve the number of players in each class
	-- Should be tracked during player join/part
	local ServerSlotMap = Server:GetServerSlotMap();
	local TeamName = {"red", "blue",};

	for Team=1, 2 do
	
		szReplyString = szReplyString.." "..tostring(GameRules:GetTeamMemberCountRL(TeamName[Team]));
		
		for szClassName, ClassTable in MultiplayerClassDefiniton.PlayerClasses do
		
			local iClassCount = 0;

			for iSlotIndex, Slot in ServerSlotMap do

				local PlayerEntity = System:GetEntity(Slot:GetPlayerId());
				local PlayerTeam = Game:GetEntityTeam(Slot:GetPlayerId());
				
				if (PlayerTeam == TeamName[Team]) then
			  	if PlayerEntity and PlayerEntity.type=="Player" and PlayerTeam ~= "spectators" then
						local sCurrentClass = PlayerEntity.sCurrentPlayerClass;
					
						if (sCurrentClass and (strlower(sCurrentClass) == strlower(szClassName))) then
							iClassCount = iClassCount + 1;
						end
					end
				end
			end
				
			szReplyString = szReplyString.." "..tostring(iClassCount);
		end
	end

	szReplyString = szReplyString.." "..tostring(GameRules:GetTeamMemberCountRL("spectators"));

	ServerSlot:SendCommand(szReplyString);
end

-------------------------------------------------------------------------------
-- Get Player Class
-- Client sends this command to receive it's current situation: class and weapons
-- 
-- #Client:SendCommand("GPC");
--
-- Server should reply with the class, and the weapons
--
-- 	#ServerSlot:SendCommand("GPC Sniper 1 1 2);
--
GameRules.ClientCommandTable["GPC"]=function(String,ServerSlot,TokTable)

	if (count(TokTable) ~= 1) then
		return;
	end
       				local szEntity = System:GetEntity(ServerSlot:GetPlayerId());
				local szTeam = Game:GetEntityTeam(ServerSlot:GetPlayerId());

	local szPlayerClass = ServerSlot.InitialPlayerProperties.sPlayerClass;
	local WeaponPack = EquipPacks[ServerSlot.InitialPlayerProperties.equipEquipment];
	local Class = MultiplayerClassDefiniton.PlayerClasses[szPlayerClass];

	local szReplyString = TokTable[1].." "..szTeam.." "..szPlayerClass;

	for i = 1, 4 do
		if (WeaponPack[i]) then

			local szCurrentWeaponName = WeaponPack[i].Name;
			local WeaponTable = Class["weapon"..i];
			local iWeapon = 0;
		
			for j, szWeaponName in WeaponTable do
				if (szWeaponName == szCurrentWeaponName) then
					iWeapon = j;
					break;
				end
			end

			if (iWeapon > 0) then
				szReplyString = szReplyString.." "..iWeapon;
			end
		end
	end


	ServerSlot:SendCommand(szReplyString);
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


-------------------------------------------------------------------------------
-- first time connect, mod can decide how to add the new client to the
-- game (spectator or not, etc). needs to spawn new entity.

GameRules._OnClientConnect=GameRules.OnClientConnect;
function GameRules:OnClientConnect( server_slot, requested_classid )
	self:_OnClientConnect(server_slot, requested_classid);

	self:OnClientCmd(server_slot,"CPC Grunt 1 1 1 1");		-- default class
end
