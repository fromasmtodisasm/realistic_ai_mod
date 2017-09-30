-- some defines for the music-moods: time in seconds how long it takes to switch the mood if an specific mood event arrives continuesly
MM_COMBAT_TIMEOUT=1;	-- Combat
MM_SNEAKING_TIMEOUT=3;	-- Sneaking (crouching, proning, moving slow, not seen by AI)
MM_SNIPER_TIMEOUT=2;	-- Sniper (looking through sniper-scope)
MM_OBSERVE_TIMEOUT=2;	-- Observe (using binocular)
MM_SUSPENSE_TIMEOUT=2;	-- Suspense (AI near)
MM_ALERT_TIMEOUT=2.5;	-- AI is alerted
MM_NEARSUSPENSE_TIMEOUT=2;	-- AI is very near

BULLET_REJECT_TYPE_NONE=0;
BULLET_REJECT_TYPE_SINGLE=1;
BULLET_REJECT_TYPE_RAPID=2;

function Init()
	System:LoadFont("radiosta");
	System:LoadFont("hud");
	Script:ReloadScript("scripts/common.lua");
	Script:ReloadScript("scripts/Map.lua");
	Script:ReloadScript("scripts/StateMachine.lua");
	Script:ReloadScript("SCRIPTS/Default/Inventory.lua");
	Script:ReloadScript("scripts/EntityGroupMgr.lua");
	Script:ReloadScript("scripts/methoddispatcher.lua");
	Script:ReloadScript("scripts/saveutils.lua" );
	Script:ReloadScript("scripts/sounds/PresetDB.lua" );
	Script:ReloadScript("scripts/sounds/EAXPresetDB.lua" );
	Script:ReloadScript("scripts/Multiplayer/AvailableMods.lua");			-- AvailableMODList

	if NewUbisoftClient then
		System:Log("UBI.com present");
		Script:ReloadScript("scripts/Multiplayer/Ubisoft.lua" );
	else
		System:Log("UBI.com not present");
	end
	
	Script:ReloadScript("scripts/Multiplayer/Connecting.lua" );
	Script:ReloadScript("scripts/Multiplayer/MapCycle.lua");
	Script:ReloadScript("scripts/Multiplayer/QueryHandler.lua");

	-- vehicles common stuff
	Script:ReloadScript("scripts/Default/Entities/vehicles/VehicleCommon.lua");
	-- hellicopters common stuff
	Script:ReloadScript("scripts/Default/Entities/AI/HeliCommon.lua");


--	Script:LoadScript( "scripts/default/hud/nightvision.lua" );
--	NightVision.OnInit( NightVision );
--	Script:LoadScript( "scripts/default/hud/heatvision.lua" );
--	HeatVision.OnInit( HeatVision );
	Script:ReloadScript("Scripts/Default/Entities/Weapons/FTBSniping.lua" );
	FTBSniping.OnInit( FTBSniping );
	Script:ReloadScript("Scripts/Default/Entities/Weapons/BiPod.lua" );
	Script:ReloadScript( "Scripts/Default/Entities/Player/BasicPlayer.lua" );
	Script:ReloadScript( "SCRIPTS/Default/Entities/AI/BasicAI.lua");

	Script:ReloadScript( "SCRIPTS/BALANCING.lua");

	Script:ReloadScript("scripts/Default/Entities/Weapons/BasicWeapon.lua");
	Script:ReloadScript("scripts/Default/Entities/Weapons/MountedWeaponBase.lua");

	--Script:LoadScript("Scripts/AI/Behaviors/AIBehaviour.lua");
	--Script:LoadScript("Scripts/AI/Characters/AICharacter.lua");
	--Script:LoadScript( "Scripts/Default/Entities/Pickups/BasicPickup.lua" );

	-----------------------------------------------------------------
	-- loading of the game mission list
	------------------------------------------------------------
	Script:ReloadScript("scripts/defiant.lua");
	Script:ReloadScript("scripts/DebugTagPointsMgr.lua");

	Script:ReloadScript("scripts/Multiplayer/MultiplayerUtils.lua");
	Script:ReloadScript("scripts/Multiplayer/CreateVariables.lua");
	Script:ReloadScript("scripts/Multiplayer/MPStatistics.lua");
	Script:ReloadScript("scripts/Multiplayer/ModelList.lua");
	
	--explosion effects
--	Script:LoadScript("scripts/materials/commoneffects.lua");

	-- dynamically apply physics and automatic settings based on sys_spec
	ApplySysSpecSettings();
end

function ApplySysSpecSettings()
  	local sysspec = getglobal( "sys_spec" );
	if( sysspec ) then
		local quality = tonumber( sysspec );
	  	ApplyPhysicsQuality( quality );
	  	ApplyAutomaticSettings( quality );
	end
end

function ApplyPhysicsQuality( qual )
  	if( qual >= 2 ) then
    	setglobal( "physics_quality", 2 );
	    setglobal( "p_max_contacts", 150 );
	    setglobal( "p_max_MC_iters", 6000 );
	    setglobal( "p_max_MC_iters_hopeless", 6000 );
	    setglobal( "p_max_LCPCG_iters", 5 );
	    setglobal( "p_max_LCPCG_subiters", 70 );
	    setglobal( "p_max_LCPCG_subiters_final", 180 );
		setglobal( "p_max_LCPCG_microiters", 14000 );
	    setglobal( "p_max_LCPCG_microiters_final", 30000 );
	    setglobal( "p_max_substeps", 5 );
	    setglobal( "p_max_contact_gap", 0.01 );
  	elseif( qual == 1 ) then
    	setglobal( "physics_quality", 1 );
	    setglobal( "p_max_contacts", 90 );
	    setglobal( "p_max_MC_iters", 4000 );
	    setglobal( "p_max_MC_iters_hopeless", 4000 );
	    setglobal( "p_max_LCPCG_iters", 4 );
	    setglobal( "p_max_LCPCG_subiters", 50 );
	    setglobal( "p_max_LCPCG_subiters_final", 130 );
		setglobal( "p_max_LCPCG_microiters", 10000 );
	    setglobal( "p_max_LCPCG_microiters_final", 20000 );
	    setglobal( "p_max_substeps", 4 );
	    setglobal( "p_max_contact_gap", 0.01 );
  	else
    	setglobal( "physics_quality", 0 );
	    setglobal( "p_max_contacts", 90 );
	    setglobal( "p_max_MC_iters", 2800 );
	    setglobal( "p_max_MC_iters_hopeless", 2800 );
	    setglobal( "p_max_LCPCG_iters", 0 );
	    setglobal( "p_max_LCPCG_subiters", 0 );
	    setglobal( "p_max_LCPCG_subiters_final", 0 );
	    setglobal( "p_max_substeps", 3 );
	    setglobal( "p_max_contact_gap", 0.015 );
	end
    System:LogToConsole( "Physics quality settings set to : "..qual );
end

function ApplyAutomaticSettings( qual )
  	if( qual == 0 ) then
    	setglobal( "ai_update_interval", 0.2 );
	    setglobal( "w_underwaterbubbles", 0 );
	    setglobal( "ai_max_vis_rays_per_frame", 50 );
	    System:LogToConsole( "Automatic settings set to low spec..." );
	elseif( qual == 1 ) then
    	setglobal( "ai_update_interval", 0.1 );
	    setglobal( "w_underwaterbubbles", 1 );
	    setglobal( "ai_max_vis_rays_per_frame", 100 );
	    System:LogToConsole( "Automatic settings set to medium spec..." );
	elseif( qual == 2 ) then
    	setglobal( "ai_update_interval", 0.1 );
	    setglobal( "w_underwaterbubbles", 1 );
	    setglobal( "ai_max_vis_rays_per_frame", 150 );
	    System:LogToConsole( "Automatic settings set to high spec..." );
  	else
    	setglobal( "ai_update_interval", 0.1 );
	    setglobal( "w_underwaterbubbles", 1 );
	    setglobal( "ai_max_vis_rays_per_frame", 300 );
	    System:LogToConsole( "Automatic settings set to very high spec..." );
	end
end

function Shutdown()
	Game:SaveConfiguration();
end


function DebugDumpPlayer( playerent )
	if not playerent then
		System:Log("  nil");
		return;
	end

	if playerent.type~="Player" then
		return;
	end

	local pos=playerent:GetPos();
	local angles=playerent:GetAngles();

	System:Log("{");
	System:Log("  pos=("..tostring(pos.x)..","..tostring(pos.y)..","..tostring(pos.z)..")");
	System:Log("  angles=("..tostring(angles.x)..","..tostring(angles.y)..","..tostring(angles.z)..")");
	System:Log("  id="..tostring(playerent.id));
	System:Log("  name="..tostring(playerent:GetName()));
	System:Log("  team="..tostring(Game:GetEntityTeam(playerent.id)));
	System:Log("  health="..tostring(playerent.cnt.health).."/"..tostring(playerent.cnt.max_health));
	System:Log("  invulnerabilityTimer="..tostring(playerent.invulnerabilityTimer));
	System:Log("  GetState()="..tostring(playerent:GetState()));
	System:Log("}");
end



function DebugDump()
	System:Log("-------------------------------------------------");
	System:Log("- DebugDump -------------------------------------");
	System:Log("-------------------------------------------------");

	System:Log("_localplayer=");
	DebugDumpPlayer(_localplayer);

	System:Log("-------------------------------------------------");
	local ents=System:GetEntities();
	for idx,ent in ents do
		if ent and ent.type=="Player" then
			System:Log("entity player=");
			DebugDumpPlayer(ent);
		end
	end

	System:Log("-------------------------------------------------");
	if Server then
		local slots = Server:GetServerSlotMap();
		for i, slot in slots do
		    local ent = System:GetEntity(slot:GetPlayerId());
			System:Log("serverslot "..tostring(i).." player=");
			DebugDumpPlayer(ent);
	    end
	else
		System:Log("Server=nil");
 	end

 	System:Log("-------------------------------------------------");
 	System:Log("gr_InvulnerabilityTimer="..tostring(gr_InvulnerabilityTimer));

 	System:Log("-------------------------------------------------");

	System:Log("g_GameType="..tostring(getglobal("g_GameType")));
	System:Log("GameRules "..tostring(getglobal("GameRules")));
	System:Log("ClientStuff "..tostring(getglobal("ClientStuff")));

	if getglobal("GameRules") then
		if getglobal("GameRules").GetState then
			System:Log("GameRules state="..tostring(getglobal("GameRules"):GetState()));
		else
			System:Log("GameRules:GetState() failed");
		end
	else
		System:Log("GameRules=nil");
 	end
end

--  deactivated because it's not needed right now
---------------------------------------------------------------------------------
-- is called by C/C++ when we successfully loaded the gamerules file but before the GameRules:OnInit() was called
--function OnAfterLoadGameRules( newGameType )
--
--	if newGameType=="" or newGameType=="Default" then
--		MultiplayerUtils:OnSinglePlayer();
--	else
--		MultiplayerUtils:OnMultiplayer();
--	end
--end


function Game:SetSensitivity(sens)
	if (sens and tonumber(sens)) then
		sens = tonumber(sens);
		
		if (sens < 1.0) then
			sens = 1.0;
		end
		
		if (Input) then
			Input:SetMouseSensitivity(sens);
		end
	elseif (Input) then
		System:Log("\001sensitivity = "..Input:GetMouseSensitivity());
	end
end

function SProfile_run(szName)
	if (SProfile_exists(szName)) then
		if (SProfile_load(szName)) then
			Game:LoadLevelMPServer(getglobal('gr_NextMap'));
			
			return 1;
		end
	end
	
	System:Log("\001failed to load profile '"..szName.."'.");

	return nil;
end

function SProfile_load(szName)
	if (Script:LoadScript('profiles/server/'..tostring(szName)..'_server.cfg', 1, 0)) then
		return 1;
	elseif (Script:LoadScript(tostring(szName), 1, 0)) then
		return 1;
	end
	
	System:Log("\001failed to load profile '"..szName.."'.");
	
	return nil;
end

function SProfile_exists(name)
	local fil = openfile('profiles/server/'..tostring(name)..'_server.cfg', "rb");
	
	if fil then
		closefile(fil);
		return 1;	
	end
	
	fil = openfile(tostring(name), "rb");

	if fil then
		closefile(fil);
		return 1;	
	end
	
	return nil;	
end