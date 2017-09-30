
-- class definition for class based mods
--
-- this info is used in GameRuleClassLib.lua and in the in game menu

local gr_runspeed_factor=1;
local gr_stamina_use_run=1;
local gr_walkspeed_factor=1;
local gr_swimspeed_factor=1;
local gr_crouchspeed_factor=1;
local gr_pronespeed_factor=1;
local gr_jumpforce_factor=1;

if toNumberOrZero(getglobal("gr_runspeed_factor"))>0 then
	gr_runspeed_factor=tonumber(getglobal("gr_runspeed_factor"));
end
if toNumberOrZero(getglobal("gr_stamina_use_run"))>0 then 
	gr_stamina_use_run=tonumber(getglobal("gr_stamina_use_run"));
end
if toNumberOrZero(getglobal("gr_walkspeed_factor"))>0 then 
	gr_walkspeed_factor=tonumber(getglobal("gr_walkspeed_factor"));
end
if toNumberOrZero(getglobal("gr_swimspeed_factor"))>0 then 
	gr_swimspeed_factor=tonumber(getglobal("gr_swimspeed_factor"));
end
if toNumberOrZero(getglobal("gr_crouchspeed_factor"))>0 then 
	gr_crouchspeed_factor=tonumber(getglobal("gr_crouchspeed_factor"));
end
if toNumberOrZero(getglobal("gr_pronespeed_factor"))>0 then 
	gr_pronespeed_factor=tonumber(getglobal("gr_pronespeed_factor"));
end
if toNumberOrZero(getglobal("gr_jumpforce_factor"))>0 then 
	gr_jumpforce_factor=tonumber(getglobal("gr_jumpforce_factor"));
end
local MCD_Scale=1.4;
local RunSpeedMult=1.15*gr_runspeed_factor;   --patch2 : runspeed 15% faster
local staminaRunMult=0.35*gr_stamina_use_run;  --patch2 : 30% less use of stamina when run

-- local variables for controlling loadouts
local initial_ag36_nades=tonumber(getglobal("gr_initial_ag36_nades"));
local pickup_ag36_nades=tonumber(getglobal("gr_pickup_ag36_nades"));
local droppickup_ag36_nades=tonumber(getglobal("gr_droppickup_ag36_nades"));
local max_ag36_nades=tonumber(getglobal("gr_max_ag36_nades"));

local initial_oicw_nades=tonumber(getglobal("gr_initial_oicw_nades"));
local pickup_oicw_nades=tonumber(getglobal("gr_pickup_oicw_nades"));
local droppickup_oicw_nades=tonumber(getglobal("gr_droppickup_oicw_nades"));
local max_oicw_nades=tonumber(getglobal("gr_max_oicw_nades"));

local initial_rockets=tonumber(getglobal("gr_initial_rockets"));
local pickup_rockets=tonumber(getglobal("gr_pickup_rockets"));
local droppickup_rockets=tonumber(getglobal("gr_droppickup_rockets"));
local max_rockets=tonumber(getglobal("gr_max_rockets"));

local initial_sticky_explosives=tonumber(getglobal("gr_initial_sticky_explosives"));
local pickup_sticky_explosives=tonumber(getglobal("gr_pickup_sticky_explosives"));
local droppickup_sticky_explosives=tonumber(getglobal("gr_droppickup_sticky_explosives"));
local max_sticky_explosives=tonumber(getglobal("gr_max_sticky_explosives"));

local initial_sniper_ammo=tonumber(getglobal("gr_initial_sniper_ammo"));
local pickup_sniper_ammo=tonumber(getglobal("gr_pickup_sniper_ammo"));
local droppickup_sniper_ammo=tonumber(getglobal("gr_droppickup_sniper_ammo"));
local max_sniper_ammo=tonumber(getglobal("gr_max_sniper_ammo"));

local sn_init_fb=0;
local sn_pickup_fb=0;
local sn_droppickup_fb=0;
local sn_max_fb=0;
local sn_init_sg=1;
local sn_pickup_sg=0;
local sn_droppickup_sg=2;
local sn_max_sg=2;

local sc_init_fb=0;
local sc_pickup_fb=0;
local sc_droppickup_fb=0;
local sc_max_fb=0;
local sc_init_hg=5;
local sc_pickup_hg=0;
local sc_droppickup_hg=2;
local sc_max_hg=5;

local eg_init_fb=0;
local eg_pickup_fb=0;
local eg_droppickup_fb=0;
local eg_max_fb=0;
local eg_init_sg=2;
local eg_pickup_sg=0;
local eg_droppickup_sg=2;
local eg_max_sg=2;
-- end local variables for controlling loadouts

if toNumberOrZero(getglobal("gr_sniper_flashbang"))==1 then
	snipergrenade="FlashbangGrenade";
	sn_init_fb=2;
	sn_pickup_fb=0;
	sn_droppickup_fb=2;
	sn_max_fb=2;
	sn_init_sg=0;
	sn_pickup_sg=0;
	sn_droppickup_sg=0;
	sn_max_sg=0;
end

if toNumberOrZero(getglobal("gr_grunt_flashbang"))==1 then
	scoutgrenade="FlashbangGrenade";
	sc_init_fb=2;
	sc_pickup_fb=0;
	sc_droppickup_fb=2;
	sc_max_fb=3;
	sc_init_hg=0;
	sc_pickup_hg=0;
	sc_droppickup_hg=0;
	sc_max_hg=0;
end

if toNumberOrZero(getglobal("gr_engineer_flashbang"))==1 then
	engineergrenade="FlashbangGrenade";
	eg_init_fb=2;
	eg_pickup_fb=0;
	eg_droppickup_fb=2;
	eg_max_fb=2;
	eg_init_sg=0;
	eg_pickup_sg=0;
	eg_droppickup_sg=0;
	eg_max_sg=0;
end


MultiplayerClassDefiniton=
{
	PlayerClasses={			-- for class based mods
	
		Grunt=
		{
			model="Objects/characters/mercenaries/Merc_cover/merc_cover_MP.cgf",
			health		= 130,
			armor		= 90, --50
			max_armor	= 90, --50
			fallscale = 0.96,
			weapon1={"Machete",},
			weapon2={"Falcon",},
			weapon3={"P90","Shotgun",},
			weapon4={"AG36","OICW","M249",},
			primaryWeaponSlot=4,
			
			grenades=scoutgrenade,

			items = {
				--"PickupHeatVisionGoggles",
			},
	
			move_params = {
				speed_run=MCD_Scale*3.5*RunSpeedMult,
				speed_walk=MCD_Scale*3.0*gr_walkspeed_factor,
				speed_swim=MCD_Scale*2.8*gr_swimspeed_factor,
				speed_crouch=MCD_Scale*1.6*gr_crouchspeed_factor,
				speed_prone=MCD_Scale*0.6*gr_pronespeed_factor,
				jump_force=3.3*gr_jumpforce_factor,
				lean_angle=14.0,
				bob_pitch=0.015,
				bob_roll=0.035,
				bob_lenght=5.5*MCD_Scale,
				bob_weapon=0.005/MCD_Scale,
			},
			
			StaminaTable = {
				sprintScale	= 1.4,
				sprintSwimScale = 1.4,
				decoyRun	= 30*staminaRunMult, --21
				decoyJump	= 15, --10
				restoreRun	= 2, --1
				restoreWalk	= 10, --8
				restoreIdle	= 12, --10
		
				breathDecoyUnderwater	= 3,
				breathDecoyAim		= 10,
				breathRestore		= 80,
			},

			DynProp = {
				air_control = 0.9, --0.9
				gravity = 9.81,--9.81,
				jump_gravity = 15.0,--15.0
				swimming_gravity = -1.0,-- -1.0
				inertia = 10.0, -- 10.0
				swimming_inertia = 1.0, -- 1.0
				nod_speed = 50.0,--50.0
				min_slide_angle = 46, -- 46
				max_climb_angle = 55, -- 55
				min_fall_angle = 70, -- 70
				max_jump_angle = 50, -- 50
			},
			
			InitialAmmo=
			{
				Pistol=63,			-- Falcon
				Shotgun=30,			-- Shotgun
				SMG=150,				-- P90
				Assault=300,		-- SAW,OICW,AG36
				HandGrenade=sc_init_hg,	-- HandGrenade
				FlashbangGrenade=sc_init_fb,
				AG36Grenade=initial_ag36_nades,	-- AG36 second firemod
				OICWGrenade=initial_oicw_nades,	-- OICW second firemod
			},
			AmmoPickup=
			{
				Pistol=27,	    -- Falcon
				Shotgun=30,			-- Shotgun
				SMG=100,				-- P90
				Assault=125,		-- SAW,OICW,AG36
				HandGrenade=sc_pickup_hg,	-- HandGrenade
				FlashbangGrenade=sc_pickup_fb,
				AG36Grenade=pickup_ag36_nades,	-- AG36 second firemod
				OICWGrenade=pickup_oicw_nades,	-- OICW second firemod
			},
			DropAmmoPickup=
			{
				Pistol=27,			-- Falcon
				Shotgun=20,			-- Shotgun
				SMG=100,					-- P90
				Assault=100,		-- SAW,OICW,AG36
				HandGrenade=sc_droppickup_hg,	-- HandGrenade
				FlashbangGrenade=sc_droppickup_fb,
				AG36Grenade=droppickup_ag36_nades,	-- AG36 second firemod
				OICWGrenade=droppickup_oicw_nades,	-- OICW second firemod
			},
			MaxAmmo=
			{
				Pistol=54,	    -- Falcon
				Shotgun=60,			-- Shotgun
				SMG=250,				-- P90
				Assault=300,		-- SAW,OICW,AG36
				HandGrenade=sc_max_hg,	-- HandGrenade
				FlashbangGrenade=sc_max_fb,
				AG36Grenade=max_ag36_nades,	-- AG36 second firemod
				OICWGrenade=max_oicw_nades,	-- OICW second firemod
			},
		},
		
		Sniper=
		{
			model="Objects/characters/mercenaries/merc_sniper/merc_sniper_MP.cgf",
			health		=130,
			armor		=12,
			max_armor	= 12,
			fallscale = 0.92,
			weapon1={"Machete","Shocker",},
			weapon2={"Falcon","MP5",},
			weapon3={"SniperRifle", "RL",},
			weapon4={},
			primaryWeaponSlot=2,
			grenades=snipergrenade,
			
			items = {
				"PickupBinoculars",
				--"PickupHeatVisionGoggles",
			},
			
			move_params = {
				speed_run=MCD_Scale*3.8*RunSpeedMult,
				speed_walk=MCD_Scale*3.3*gr_walkspeed_factor,
				speed_swim=MCD_Scale*2.8*gr_swimspeed_factor,
				speed_crouch=MCD_Scale*1.6*gr_crouchspeed_factor,
				speed_prone=MCD_Scale*0.6*gr_pronespeed_factor,
				jump_force=4.3*gr_jumpforce_factor,
				lean_angle=14.0,
				bob_pitch=0.015,
				bob_roll=0.035,
				bob_lenght=5.5*MCD_Scale,
				bob_weapon=0.005/MCD_Scale,
			},
	
			StaminaTable = {
				sprintScale	= 1.4,
				sprintSwimScale = 1.4,
				decoyRun	= 24*staminaRunMult,  --21
				decoyJump	= 15, --10
				restoreRun	= 2, --1
				restoreWalk	= 10, --8
				restoreIdle	= 12, --10
		
				breathDecoyUnderwater	= 3,
				breathDecoyAim		= 10,
				breathRestore		= 80,
			},
			DynProp = {
				air_control = 0.9, --0.9
				gravity = 9.81,--9.81,
				jump_gravity = 15.0,--15.0
				swimming_gravity = -1.0,-- -1.0
				inertia = 10.0, -- 10.0
				swimming_inertia = 1.0, -- 1.0
				nod_speed = 50.0,--50.0
				min_slide_angle = 46, -- 46
				max_climb_angle = 55, -- 55
				min_fall_angle = 70, -- 70
				max_jump_angle = 50, -- 50
			},
			InitialAmmo=
			{
				Pistol=63,		-- Falcon
				SMG=210,      --MP5
				Rocket= initial_rockets, -- RL
				Sniper= initial_sniper_ammo,		-- SniperRifle
				SmokeGrenade=sn_init_sg,		-- SmokeGrenade
				FlashbangGrenade=sn_init_fb,
			},
			AmmoPickup=
			{
				Pistol=27,		-- Falcon
				SMG=90,       --MP5 
				Rocket= pickup_rockets,		-- RL
				Sniper=pickup_sniper_ammo,		-- SniperRifle
				SmokeGrenade=sn_pickup_sg,		-- SmokeGrenade
				FlashbangGrenade=sn_pickup_fb,
			},
			DropAmmoPickup=
			{
				Pistol=27,		-- Falcon
				SMG=90,       --MP5
				Rocket= droppickup_rockets,		-- RL
				Sniper= droppickup_sniper_ammo,		-- SniperRifle
				SmokeGrenade=sn_droppickup_sg,		-- SmokeGrenade
				FlashbangGrenade=sn_droppickup_fb,
			},
			MaxAmmo=
			{
				Pistol=54,		-- Falcon
				SMG=180,      --MP5
				Rocket=max_rockets,		-- RL
				Sniper=max_sniper_ammo,		-- SniperRifle
				SmokeGrenade=sn_max_sg,		-- SmokeGrenade
				FlashbangGrenade=sn_max_fb,
			},
		},
		
		Support=
		{
			model="Objects/characters/workers/evil_worker/evil_worker_MP.cgf",
			health		= 130,
			armor		= 40,
			max_armor	= 40,
			fallscale = 0.94,
			weapon1={"Falcon",},			
			weapon2={"M4", "MP5",},
			weapon3={"ScoutTool","MedicTool",},
			weapon4={"EngineerTool", },	-- Wrench building and repairing / scouttool for blowing things up
			primaryWeaponSlot=2,
			grenades=engineergrenade,

			items = {
				--"PickupHeatVisionGoggles",
			},
			
			move_params = {
				speed_run=MCD_Scale*3.8*RunSpeedMult,
				speed_walk=MCD_Scale*3.2*gr_walkspeed_factor,
				speed_swim=MCD_Scale*2.8*gr_swimspeed_factor,
				speed_crouch=MCD_Scale*1.4*gr_crouchspeed_factor,
				speed_prone=MCD_Scale*0.6*gr_pronespeed_factor,
				jump_force=4.3*gr_jumpforce_factor,
				lean_angle=14.0,
				bob_pitch=0.015,
				bob_roll=0.035,
				bob_lenght=5.5*MCD_Scale,
				bob_weapon=0.005/MCD_Scale,
			},
	
			StaminaTable = {
				sprintScale	= 1.4,
				sprintSwimScale = 1.4,
				decoyRun	= 27*staminaRunMult, --21
				decoyJump	= 15, --10
				restoreRun	= 2, --1
				restoreWalk	= 10, --8
				restoreIdle	= 12, --10
		
				breathDecoyUnderwater	= 3,
				breathDecoyAim		= 10,
				breathRestore		= 80,
			},
			DynProp = {
				air_control = 0.9, --0.9
				gravity = 9.81,--9.81,
				jump_gravity = 15.0,--15.0
				swimming_gravity = -1.0,-- -1.0
				inertia = 10.0, -- 10.0
				swimming_inertia = 1.0, -- 1.0
				nod_speed = 50.0,--50.0
				min_slide_angle = 46, -- 46
				max_climb_angle = 55, -- 55
				min_fall_angle = 70, -- 70
				max_jump_angle = 50, -- 50
			},
			InitialAmmo=
			{
				Pistol=63,			-- Falcon
				Assault=180,		--M4 
				HealthPack=3,		-- Healthpacks
				SMG=180,        --MP5
				SmokeGrenade=eg_init_sg,		-- SmokeGrenade	
				FlashbangGrenade=eg_init_fb,
				StickyExplosive=initial_sticky_explosives,-- ScoutTool		
			},
			AmmoPickup=
			{
				Pistol=27,		-- Falcon
				Assault=90,		-- M4
				HealthPack=2,		-- Healthpacks
				SMG=90,
				SmokeGrenade=eg_pickup_sg,		-- SmokeGrenade	
				FlashbangGrenade=eg_pickup_fb,
				StickyExplosive=pickup_sticky_explosives,-- ScoutTool		
			},
			DropAmmoPickup=
			{
				Pistol=27,		-- Falcon
				Assault=90,		-- Shotgun
				HealthPack=2,		-- Healthpacks
				SMG=90,
				SmokeGrenade=eg_droppickup_sg,		-- SmokeGrenade	
				FlashbangGrenade=eg_droppickup_fb,
				StickyExplosive=droppickup_sticky_explosives,-- ScoutTool		
			},
			MaxAmmo=
			{
				Pistol=54,		-- Falcon
				Assault=180,		-- M4
				HealthPack=5,		-- MedicTool
				SMG=180,
				SmokeGrenade=eg_max_sg,		-- SmokeGrenade	
				FlashbangGrenade=eg_max_fb,
				StickyExplosive=max_sticky_explosives,-- ScoutTool		
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
			speed_walk=MCD_Scale*3.5*gr_walkspeed_factor,
			speed_swim=MCD_Scale*2.8*gr_swimspeed_factor,
			speed_crouch=MCD_Scale*1.6*gr_crouchspeed_factor,
                        speed_prone=MCD_Scale*0.6*gr_pronespeed_factor,
			jump_force=MCD_Scale*66.3*gr_jumpforce_factor,
			lean_angle=14.0,
			bob_pitch=0.015,
			bob_roll=0.035,
			bob_lenght=5.5*MCD_Scale,
			bob_weapon=0.005/MCD_Scale,
		},
		
		StaminaTable = {
			sprintScale	= 1.4,
			sprintSwimScale = 1.4,
			decoyRun	= 27*staminaRunMult,
			decoyJump	= 17.5,
			restoreRun	= 2,
			restoreWalk	= 10,
			restoreIdle	= 12,
	
			breathDecoyUnderwater	= 4,
			breathDecoyAim		= 10,
			breathRestore		= 80,
		},
			DynProp = {
				air_control = 0.9, --0.9
				gravity = 9.81,--9.81,
				jump_gravity = 15.0,--15.0
				swimming_gravity = -1.0,-- -1.0
				inertia = 10.0, -- 10.0
				swimming_inertia = 1.0, -- 1.0
				nod_speed = 50.0,--50.0
				min_slide_angle = 46, -- 46
				max_climb_angle = 55, -- 55
				min_fall_angle = 70, -- 70
				max_jump_angle = 50, -- 50
			},
	},
};
