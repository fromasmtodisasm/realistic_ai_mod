--#Script:LoadScript("scripts/materials/mat_wood2.lua")

Script:LoadScript("scripts/materials/commoneffects.lua")

Materials["mat_wood2_p"] = {

	type="mat_wood2p",


	PhysicsSounds=PhysicsSoundsTable.Hard,

	bullet_drop_single = CommonEffects.common_bullet_drop_single_wood,
	bullet_drop_rapid = CommonEffects.common_bullet_drop_rapid_wood,

	bullet_hit = {
		sounds = {
			{"Sounds/BulletHits/Wbullet1.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Wbullet2.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Wbullet3.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Wbullet4.wav",SOUND_UNSCALABLE,255,3,101},
		},
		decal = {
			texture = System:LoadTexture("Textures/Decal/wood.dds"),
			scale = .04,
		},
		particleEffects = {
			name = "bullet.hit_wood.a",
		},
	},

	pancor_bullet_hit = {
		sounds = {
			{"Sounds/BulletHits/Wbullet1.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Wbullet2.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Wbullet3.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Wbullet4.wav",SOUND_UNSCALABLE,255,3,101},
		},
		decal = {
			texture = System:LoadTexture("Textures/Decal/wood.dds"),
			scale = .04,
				},
		particleEffects = {
			name = "bullet.hit_wood_pancor.a",
				},
	},



	flashgrenade_hit = CommonEffects.common_flashgrenade_hit,
	projectile_hit = 	{
		particleEffects = {
			name = "explosions.rocket.a",
		},
	    particles =
		{
			{
				focus = .5,
				color = {1,1,1},
				speed = 8, --default 5
				count = 120, --default 75
				size = .1,
				size_speed=0,
				gravity = {x = 0,y = 0,z = -8},
				rotation = {x = 0,y = 0,z = 20},
				lifetime=2.00,
				tid = System:LoadTexture("textures\\sprites\\chip.dds"),
				tail_length = 0,
				frames=1,

			},
		},
		sounds = {
			{"Sounds/BulletHits/AT_Rockets/at_rocket_01.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/AT_Rockets/at_rocket_02.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/AT_Rockets/at_rocket_03.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/AT_Rockets/at_rocket_04.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/AT_Rockets/at_rocket_05.mp3",SOUND_UNSCALABLE,255,30,1000},
		},
	},
	melee_slash = {
		sounds = {
			{"Sounds/Weapons/machete/machetewood1.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
			{"Sounds/Weapons/machete/machetewood2.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
			{"Sounds/Weapons/machete/machetewood3.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
		},
		particles =  CommonEffects.common_machete_hit_wood_part.particles,
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
		piercing_resistence = 5,
		friction = .5,
		bouncyness= .05, --default 0
	},

	AI = {
		fImpactRadius = 5,
	},

}