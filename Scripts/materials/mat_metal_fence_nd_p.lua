Script:LoadScript("scripts/materials/commoneffects.lua")
Materials["mat_metal_fence_nd_p"] = {
	type="mat_metal_fence_nd_p",

	PhysicsSounds=PhysicsSoundsTable.Hard,

	bullet_drop_single = CommonEffects.common_bullet_drop_single_metal,
	bullet_drop_rapid = CommonEffects.common_bullet_drop_rapid_metal,

	bullet_hit = {
		sounds = {
			{"Sounds/BulletHits/bullet_chainlink1.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/bullet_chainlink2.wav",SOUND_UNSCALABLE,255,3,101},
		},

		particleEffects = {
			name = "bullet.hit_metal.a",
		},
	},

	pancor_bullet_hit = {
		sounds = {
			{"Sounds/BulletHits/bullet_chainlink1.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/bullet_chainlink2.wav",SOUND_UNSCALABLE,255,3,101},
		},
		particleEffects = {
			name = "bullet.hit_metal_pancor.a",
		},
	},

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
	-- rock_hit = {
		-- sounds = {
			-- {"Sounds/BulletHits/Stone/stone_wood_light1.mp3",SOUND_UNSCALABLE,255,2,100},
			-- {"Sounds/BulletHits/Stone/stone_wood1.mp3",SOUND_UNSCALABLE,255,2,100},
			-- {"Sounds/BulletHits/Stone/stone_wood2.mp3",SOUND_UNSCALABLE,255,2,100},
			-- {"Sounds/BulletHits/Stone/stone_wood3.mp3",SOUND_UNSCALABLE,255,2,100},
			-- {"Sounds/BulletHits/Stone/stone_wood4.mp3",SOUND_UNSCALABLE,255,2,100},
			-- {"Sounds/BulletHits/Stone/stone_wood5.mp3",SOUND_UNSCALABLE,255,2,100},
			-- {"Sounds/BulletHits/Stone/stone_wood6.mp3",SOUND_UNSCALABLE,255,2,100},
			-- {"Sounds/BulletHits/Stone/stone_wood7.mp3",SOUND_UNSCALABLE,255,2,100},
			-- {"Sounds/BulletHits/Stone/stone_wood8.mp3",SOUND_UNSCALABLE,255,2,100},
		-- },
	-- },
	melee_slash = {
		sounds = {
			{"Sounds/BulletHits/bullet_chainlink1.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/bullet_chainlink2.wav",SOUND_UNSCALABLE,255,3,101},
		},
		particles = CommonEffects.common_machete_hit_particles.particles,
--		decal = {
--			texture = System:LoadTexture("Textures/Decal/metal_slash.dds"),
--			scale = .1,
--			random_scale = 100,
--			random_rotation = .5,
--		},


	},

	player_walk = CommonEffects.player_metal_walk,
	player_run = CommonEffects.player_metal_run,
	player_crouch = CommonEffects.player_metal_crouch,
	player_prone = CommonEffects.player_metal_prone,
	player_walk_inwater = CommonEffects.player_walk_inwater,

	player_drop = {
		sounds = {
			{"Sounds/BulletHits/chain_link1.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/chain_link2.wav",SOUND_UNSCALABLE,255,3,101},
		},

	},
	gameplay_physic = {
		piercing_resistence = 0,
		friction = 1,
		bouncyness= .2, --default 0
	},

	AI = {
		fImpactRadius = 5,
	},

}