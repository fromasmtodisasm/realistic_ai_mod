Script:LoadScript("scripts/materials/commoneffects.lua");
--#Script:LoadScript("scripts/materials/mat_metal_plate.lua")

Materials["mat_metal_plate_p"] = {

	type="rock",
-------------------------------------
	PhysicsSounds=PhysicsSoundsTable.Hard,
-------------------------------------	
	bullet_drop_single = CommonEffects.common_bullet_drop_single_metal,
	bullet_drop_rapid = CommonEffects.common_bullet_drop_rapid_metal,
-------------------------------------	
	bullet_hit = {
		sounds = {
			{"Sounds/bullethits/Mbullet1.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/Mbullet2.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/Mbullet3.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/Mbullet4.wav",SOUND_UNSCALABLE,200,5,60},
			
		},
		
		decal = { 
			texture = System:LoadTexture("Textures/Decal/metal.dds"),
			scale = 0.04,
		},
		
		particleEffects = {
			name = "bullet.hit_metal.a",
		},

	},
	pancor_bullet_hit = {
		sounds = {
			{"Sounds/bullethits/Mbullet1.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/Mbullet2.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/Mbullet3.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/Mbullet4.wav",SOUND_UNSCALABLE,200,5,60},
			
		},
		
		decal = { 
			texture = System:LoadTexture("Textures/Decal/metal.dds"),
			scale = 0.04,
		},
		
		particleEffects = {
			name = "bullet.hit_metal_pancor.a",
		},

	},



	flashgrenade_hit = 		
	{
	        particles = 
		{
			{ --HitMetalSparksTrail
				focus = 0.0,
				color = {1,1,1},
				speed = 8.0,
				count = 25, --default 15
				size = 0.045, 
				size_speed=0,
				gravity={x=0,y=0,z=-5},
				lifetime=0.5,
				tid = System:LoadTexture("Textures/Decal/Spark.dds"),
				tail_length = 0.2,
				frames=0,
				blend_type = 2
			},
		},
	},
	projectile_hit = 	{
	        particles = 
		{
			{ --HitMetalSparksTrail
				focus = 0.0,
				color = {1,1,1},
				speed = 8.0,
				count = 25, --default 15
				size = 0.045, 
				size_speed=0,
				gravity={x=0,y=0,z=-5},
				lifetime=0.5,
				tid = System:LoadTexture("Textures/Decal/Spark.dds"),
				tail_length = 0.2,
				frames=0,
				blend_type = 2
			},
		},
	},
	mortar_hit = flashgrenade_hit,
	smokegrenade_hit = flashgrenade_hit,
	grenade_hit = flashgrenade_hit,
	melee_slash = {
		sounds = {
			{"sounds/weapons/machete/macheteplate2.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
			{"sounds/weapons/machete/macheteplate3.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
			{"sounds/weapons/machete/macheteplate4.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
			{"sounds/weapons/machete/macheteplate5.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
		},
		particles = CommonEffects.common_machete_hit_particles.particles,
		decal = { 
			texture = System:LoadTexture("Textures/Decal/metal_slash.dds"),
			scale = 0.1,
			random_scale = 100,
			random_rotation = 0.5,
		},

	},
-------------------------------------
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
		friction = 0.8,
		bouncyness= 0.2, --default 0
	},

	AI = {
		fImpactRadius = 5,
	},
			
}