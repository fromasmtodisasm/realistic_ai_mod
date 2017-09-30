--#Script:LoadScript("scripts/materials/mat_wood2.lua")

Script:LoadScript("scripts/materials/commoneffects.lua");

Materials["mat_wood2_p_nd"] = {

	type="mat_wood2p",

-------------------------------------
	PhysicsSounds=PhysicsSoundsTable.Hard,
-------------------------------------	
	bullet_drop_single = CommonEffects.common_bullet_drop_single_wood,
	bullet_drop_rapid = CommonEffects.common_bullet_drop_rapid_wood,
-------------------------------------	
	bullet_hit = {
	},

	pancor_bullet_hit = {
	},


	flashgrenade_hit = 		
	{
	},
	projectile_hit = 	{
	},
	melee_slash = {
	},
	mortar_hit = CommonEffects.common_mortar_hit,
	smokegrenade_hit = CommonEffects.common_smokegrenade_hit,

	grenade_hit = CommonEffects.common_grenade_hit,

-------------------------------------
	player_walk = CommonEffects.player_wood_walk,
	player_run = CommonEffects.player_wood_run,
	player_crouch = CommonEffects.player_wood_crouch,
	player_prone = CommonEffects.player_wood_prone,
	player_walk_inwater = CommonEffects.player_walk_inwater,
	
	player_drop = {
		sounds = {
			{"sounds/player/bodyfalls/bodyfallwood1.wav",SOUND_UNSCALABLE,210,10,150},
		},

	},
	gameplay_physic = {
		piercing_resistence = nil,
		friction = 0.5,
		bouncyness= 0.05, --default 0
	},

	AI = {
		fImpactRadius = 5,
	},
		
}