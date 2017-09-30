Script:LoadScript("scripts/materials/commoneffects.lua")
Materials["mat_metal_pipe_p"] = {
	type="mat_metal_pipe_p",

	PhysicsSounds=PhysicsSoundsTable.Hard,

	bullet_drop_single = CommonEffects.common_bullet_drop_single_metal,
	bullet_drop_rapid = CommonEffects.common_bullet_drop_rapid_metal,


	flashgrenade_hit = CommonEffects.common_flashgrenade_hit,
	projectile_hit = 	{

		particleEffects = {
			name = "explosions.rocket.a",
		},
	    particles =
		{
			{--HitMetalSparksTrail
				focus = 0,
				color = {1,1,1},
				speed = 8,
				count = 25, --default 15
				size = .045,
				size_speed=0,
				gravity={x=0,y=0,z=-5},
				lifetime=.5,
				tid = System:LoadTexture("Textures/Decal/Spark.dds"),
				tail_length = .2,
				frames=0,
				blend_type = 2
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
	mortar_hit = 		
	{
	        particles = 
		{
			{--HitMetalSparksTrail
				focus = 0,
				color = {1,1,1},
				speed = 8,
				count = 25, --default 15
				size = .045,
				size_speed=0,
				gravity={x=0,y=0,z=-5},
				lifetime=.5,
				tid = System:LoadTexture("Textures/Decal/Spark.dds"),
				tail_length = .2,
				frames=0,
				blend_type = 2
			},
		},
	},
	smokegrenade_hit = flashgrenade_hit,
	grenade_hit = {
		sounds = {
			{"Sounds/BulletHits/HandGrenade/metal_1.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/HandGrenade/metal_2.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/HandGrenade/metal_3.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/HandGrenade/metal_4.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/HandGrenade/metal_5.mp3",SOUND_UNSCALABLE,255,2,100},
		},
	},
	rock_hit = {
		sounds = {
			-- {"Sounds/BulletHits/Stone/stone_metal_thin1.mp3",SOUND_UNSCALABLE,255,2,100},
			-- {"Sounds/BulletHits/Stone/stone_metal_thin2.mp3",SOUND_UNSCALABLE,255,2,100},
			-- {"Sounds/BulletHits/Stone/stone_metal_medium1.mp3",SOUND_UNSCALABLE,255,2,100},
			-- {"Sounds/BulletHits/Stone/stone_metal_medium2.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_metal1.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_metal2.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_metal3.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_metal_car1.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_metal_car2.mp3",SOUND_UNSCALABLE,255,2,100},
		},
	},
	melee_slash = {
		sounds = {
			{"Sounds/Weapons/machete/machetepipe1.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
			{"Sounds/Weapons/machete/machetepipe2.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
		},
		particles = CommonEffects.common_machete_hit_particles.particles,
		decal = {
			texture = System:LoadTexture("Textures/Decal/metal_slash.dds"),
			scale = .1,
			random_scale = 100,
			random_rotation = .5,
		},


	},

	bullet_hit = {
		sounds = {
			-- {"Sounds/BulletHits/Metal/metal_01.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Metal/metal_02.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Metal/metal_03.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Metal/metal_04.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Metal/metal_05.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Metal/metal_06.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Metal/metal_07.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Metal/metal_08.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Metal/metal_09.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Metal/metal_10.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Metal/metal_11.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Metal/metal_12.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Metal/metal_13.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Metal/metal_14.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Metal/metal_15.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Rico/rm1.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Rico/rm2.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Rico/rm3.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Rico/rm4.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Rico/rm5.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Rico/rm6.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Rico/rm7.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Rico/rm8.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Rico/rm9.mp3",SOUND_UNSCALABLE,255,3,101},
		},
		decal = {
			texture = System:LoadTexture("Textures/Decal/metal.dds"),
			scale = .04,
		},
		particleEffects = {
			name = "bullet.hit_metal.a",
		},
	},

	pancor_bullet_hit = {
		sounds = {
			-- {"Sounds/BulletHits/Metal/metal_01.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Metal/metal_02.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Metal/metal_03.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Metal/metal_04.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Metal/metal_05.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Metal/metal_06.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Metal/metal_07.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Metal/metal_08.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Metal/metal_09.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Metal/metal_10.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Metal/metal_11.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Metal/metal_12.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Metal/metal_13.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Metal/metal_14.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Metal/metal_15.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Rico/rm1.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Rico/rm2.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Rico/rm3.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Rico/rm4.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Rico/rm5.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Rico/rm6.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Rico/rm7.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Rico/rm8.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Rico/rm9.mp3",SOUND_UNSCALABLE,255,3,101},
		},
		decal = {
			texture = System:LoadTexture("Textures/Decal/metal.dds"),
			scale = .04,
		},
		particleEffects = {
			name = "bullet.hit_metal_pancor.a",
		},
	},

	player_walk = CommonEffects.player_metal_walk,
	player_run = CommonEffects.player_metal_run,
	player_crouch = CommonEffects.player_metal_crouch,
	player_prone = CommonEffects.player_metal_prone,
	player_walk_inwater = CommonEffects.player_walk_inwater,
	player_drop = {
		sounds = {
			{"sounds/player/bodyfalls/bodyfallrock1.wav",SOUND_UNSCALABLE,210,10,150},
			{"sounds/player/bodyfalls/bodyfallrock2.wav",SOUND_UNSCALABLE,210,10,150},
		},

	},
	gameplay_physic = {
		piercing_resistence = 7,
		friction = .9,
		bouncyness= .2, --default 0
	},

	AI = {
		fImpactRadius = 5,
	},

}