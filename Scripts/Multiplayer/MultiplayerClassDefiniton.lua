
-- class definition for class based mods
--
-- this info is used in GameRuleClassLib.lua and in the in game menu

local MCD_Scale=1.4;
local RunSpeedMult=1.15;--patch2 : runspeed 15% faster
local staminaRunMult=0.7;--patch2 : 30% less use of stamina when run

MultiplayerClassDefiniton=
{
	PlayerClasses={			-- for class based mods
	
		Grunt=
		{
			model="Objects/characters/mercenaries/Merc_cover/merc_cover_MP.cgf",
			health		= 130,
			armor		= 50,
			max_armor	= 50,
			weapon1={"Machete",},
			weapon2={"Falcon",},
			weapon3={"P90","Shotgun",},
			weapon4={"AG36","OICW","M249",},
			primaryWeaponSlot=4,
			
			grenades="HandGrenade",

			items = {
				--"PickupHeatVisionGoggles",
			},
	
			move_params = {
				speed_run=MCD_Scale*3.5*RunSpeedMult,
				speed_walk=MCD_Scale*3.0,
				speed_swim=MCD_Scale*2.8,
				speed_crouch=MCD_Scale*1.6,
				speed_prone=MCD_Scale*0.6,
				jump_force=3.3,
				lean_angle=14.0,
				bob_pitch=0.015,
				bob_roll=0.035,
				bob_lenght=5.5*MCD_Scale,
				bob_weapon=0.005/MCD_Scale,
			},
			
			StaminaTable = {
				sprintScale	= 1.4,
				sprintSwimScale = 1.4,
				decoyRun	= 30*staminaRunMult,
				decoyJump	= 10,
				restoreRun	= 1.5,
				restoreWalk	= 8,
				restoreIdle	= 10,
		
				breathDecoyUnderwater	= 3,
				breathDecoyAim		= 10,
				breathRestore		= 80,
			},
			
			InitialAmmo=
			{
				Pistol=90,			-- Falcon
				Shotgun=30,			-- Shotgun
				SMG=150,				-- P90
				Assault=200,		-- M4,OICW,AG36
				HandGrenade=2,	-- HandGrenade
				AG36Grenade=3,	-- AG36 second firemod
				OICWGrenade=3,	-- OICW second firemod
			},
			AmmoPickup=
			{
				Pistol=45,	    -- Falcon
				Shotgun=30,			-- Shotgun
				SMG=100,				-- P90
				Assault=125,		-- M4,OICW,AG36
				HandGrenade=2,	-- HandGrenade
				AG36Grenade=2,	-- AG36 second firemod
				OICWGrenade=2,	-- OICW second firemod
			},
			DropAmmoPickup=
			{
				Pistol=25,			-- Falcon
				Shotgun=15,			-- Shotgun
				SMG=75,					-- P90
				Assault=100,		-- M4,OICW,AG36
				HandGrenade=0,	-- HandGrenade
				AG36Grenade=1,	-- AG36 second firemod
				OICWGrenade=1,	-- OICW second firemod
			},
			MaxAmmo=
			{
				Pistol=90,	    -- Falcon
				Shotgun=50,			-- Shotgun
				SMG=200,				-- P90
				Assault=250,		-- M4,OICW,AG36
				HandGrenade=5,	-- HandGrenade
				AG36Grenade=3,	-- AG36 second firemod
				OICWGrenade=3,	-- OICW second firemod
			},
		},
		
		Sniper=
		{
			model="Objects/characters/mercenaries/merc_sniper/merc_sniper_MP.cgf",
			health		=130,
			armor		=12,
			max_armor	= 12,
			weapon1={"Machete",},
			weapon2={"Falcon",},
			weapon3={"SniperRifle","RL",},
			weapon4={},
			primaryWeaponSlot=3,
			grenades="SmokeGrenade",
			
			items = {
				"PickupBinoculars",
				--"PickupHeatVisionGoggles",
			},
			
			move_params = {
				speed_run=MCD_Scale*3.8*RunSpeedMult,
				speed_walk=MCD_Scale*3.3,
				speed_swim=MCD_Scale*2.8,
				speed_crouch=MCD_Scale*1.6,
				speed_prone=MCD_Scale*0.6,
				jump_force=4.3,
				lean_angle=14.0,
				bob_pitch=0.015,
				bob_roll=0.035,
				bob_lenght=5.5*MCD_Scale,
				bob_weapon=0.005/MCD_Scale,
			},
	
			StaminaTable = {
				sprintScale	= 1.4,
				sprintSwimScale = 1.4,
				decoyRun	= 30*staminaRunMult,
				decoyJump	= 10,
				restoreRun	= 1.5,
				restoreWalk	= 8,
				restoreIdle	= 10,
		
				breathDecoyUnderwater	= 3,
				breathDecoyAim		= 10,
				breathRestore		= 80,
			},
			InitialAmmo=
			{
				Pistol=90,		-- Falcon
				Rocket= 10,		-- RL
				Sniper= 20,		-- SniperRifle
				SmokeGrenade=1,		-- SmokeGrenade
			},
			AmmoPickup=
			{
				Pistol=45,		-- Falcon
				Rocket= 5,		-- RL
				Sniper=10,		-- SniperRifle
				SmokeGrenade=1,		-- SmokeGrenade
			},
			DropAmmoPickup=
			{
				Pistol=45,		-- Falcon
				Rocket= 5,		-- RL
				Sniper= 10,		-- SniperRifle
				SmokeGrenade=0,		-- SmokeGrenade
			},
			MaxAmmo=
			{
				Pistol=90,		-- Falcon
				Rocket=10,		-- RL
				Sniper=30,		-- SniperRifle
				SmokeGrenade=2,		-- SmokeGrenade
			},
		},
		
		Support=
		{
			model="Objects/characters/workers/evil_worker/evil_worker_MP.cgf",
			health		= 225,
			armor		= 25,
			max_armor	= 25,
			weapon1={"Falcon",},			
			weapon2={"MedicTool", "M4",},
			weapon3={"ScoutTool",},
			weapon4={"EngineerTool", },	-- Wrench building and repairing / scouttool for blowing things up
			primaryWeaponSlot=1,
			grenades="SmokeGrenade",

			items = {
				--"PickupHeatVisionGoggles",
			},
			
			move_params = {
				speed_run=MCD_Scale*3.8*RunSpeedMult,
				speed_walk=MCD_Scale*3.2,
				speed_swim=MCD_Scale*2.8,
				speed_crouch=MCD_Scale*1.4,
				speed_prone=MCD_Scale*0.6,
				jump_force=4.3,
				lean_angle=14.0,
				bob_pitch=0.015,
				bob_roll=0.035,
				bob_lenght=5.5*MCD_Scale,
				bob_weapon=0.005/MCD_Scale,
			},
	
			StaminaTable = {
				sprintScale	= 1.4,
				sprintSwimScale = 1.4,
				decoyRun	= 30*staminaRunMult,
				decoyJump	= 10,
				restoreRun	= 1.5,
				restoreWalk	= 8,
				restoreIdle	= 10,
		
				breathDecoyUnderwater	= 3,
				breathDecoyAim		= 10,
				breathRestore		= 80,
			},
			InitialAmmo=
			{
				Pistol=90,			-- Falcon
				Assault=200,		-- Shotgun
				HealthPack=3,		-- Healthpacks
				SMG=175,
				SmokeGrenade=1,		-- SmokeGrenade	
				StickyExplosive=3,-- ScoutTool		
			},
			AmmoPickup=
			{
				Pistol=45,		-- Falcon
				Assault=50,		-- Shotgun
				HealthPack=2,		-- Healthpacks
				SMG=100,
				SmokeGrenade=1,		-- SmokeGrenade	
				StickyExplosive=3,-- ScoutTool		
			},
			DropAmmoPickup=
			{
				Pistol=30,		-- Falcon
				Assault=50,		-- Shotgun
				HealthPack=2,		-- Healthpacks
				SMG=60,
				SmokeGrenade=0,		-- SmokeGrenade	
				StickyExplosive=0,-- ScoutTool		
			},
			MaxAmmo=
			{
				Pistol=90,		-- Falcon
				Assault=250,		-- Shotgun
				HealthPack=6,		-- MedicTool
				SMG=250,
				SmokeGrenade=2,		-- SmokeGrenade	
				StickyExplosive=3,-- ScoutTool		
			},
		},
	},
	-----------------------------------------------------------------

	DefaultMultiPlayer=				-- team or non team mods
	{
		health		= 130, 			
		armor		= 0,
		max_armor	= 100,

		move_params = {
			speed_run=MCD_Scale*4.2*RunSpeedMult,
			speed_walk=MCD_Scale*3.5,
			speed_swim=MCD_Scale*2.8,
			speed_crouch=MCD_Scale*1.6,
                        speed_prone=MCD_Scale*0.6,
			jump_force=MCD_Scale*66.3,
			lean_angle=14.0,
			bob_pitch=0.015,
			bob_roll=0.035,
			bob_lenght=5.5*MCD_Scale,
			bob_weapon=0.005/MCD_Scale,
		},
		
		StaminaTable = {
			sprintScale	= 1.4,
			sprintSwimScale = 1.4,
			decoyRun	= 30*staminaRunMult,
			decoyJump	= 10,
			restoreRun	= 1.5,
			restoreWalk	= 8,
			restoreIdle	= 10,
	
			breathDecoyUnderwater	= 4,
			breathDecoyAim		= 10,
			breathRestore		= 80,
		},
	},
};