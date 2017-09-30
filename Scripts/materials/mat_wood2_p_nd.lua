--#Script:LoadScript("scripts/materials/mat_wood2.lua")

Script:LoadScript("scripts/materials/commoneffects.lua")

Materials["mat_wood2_p_nd"] = {

	type="mat_wood2p",


	PhysicsSounds=PhysicsSoundsTable.Hard,
	
	bullet_drop_single = CommonEffects.common_bullet_drop_single_wood,
	bullet_drop_rapid = CommonEffects.common_bullet_drop_rapid_wood,
	
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
	grenade_hit = {
		sounds = {
			{"Sounds/BulletHits/HandGrenade/wood1.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/HandGrenade/wood2.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/HandGrenade/wood3.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/HandGrenade/wood4.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/HandGrenade/wood5.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/HandGrenade/wood6.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/HandGrenade/wood7.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/HandGrenade/wood8.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/HandGrenade/wood9.mp3",SOUND_UNSCALABLE,255,2,100},
		},
	},
	rock_hit = {
		sounds = {
			{"Sounds/BulletHits/Stone/stone_wood_light1.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_wood1.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_wood3.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_wood4.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_wood5.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_wood7.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_wood8.mp3",SOUND_UNSCALABLE,255,2,100},
		},
	},
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
		friction = .5,
		bouncyness= .05, --default 0
	},

	AI = {
		fImpactRadius = 5,
	},
		
}