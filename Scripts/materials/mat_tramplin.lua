Script:LoadScript("scripts/materials/commoneffects.lua");
--#Script:LoadScript("scripts/materials/mat_metal_plate.lua")

Materials["mat_tramplin"] = {

	type="tramplin",
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
				count = 15,
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
				count = 15,
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
			{"sounds/player/footsteps/metal/step1.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/player/footsteps/metal/step2.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/player/footsteps/metal/step3.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/player/footsteps/metal/step4.wav",SOUND_UNSCALABLE,185,5,30},
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
	player_walk = {
		sounds = {
			{"sounds/player/footsteps/rock/step1.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/rock/step2.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/rock/step3.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/rock/step4.wav",SOUND_UNSCALABLE,200,10,60},
		},
	},
	player_run = {
		sounds = {
			{"sounds/player/footsteps/rock/step1.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/rock/step2.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/rock/step3.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/rock/step4.wav",SOUND_UNSCALABLE,200,10,60},
		},
	},
	player_crouch = {
		sounds = {
			{"sounds/player/footsteps/rock/step1.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/rock/step2.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/rock/step3.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/rock/step4.wav",SOUND_UNSCALABLE,200,10,60},
		},
	},
	player_prone = {
		sounds = {
			{"sounds/player/footsteps/rock/step1.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/rock/step2.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/rock/step3.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/rock/step4.wav",SOUND_UNSCALABLE,200,10,60},
		},
	},
	gameplay_physic = {
		piercing_resistence = 15,
		friction = -100.5,
	},

	AI = {
		fImpactRadius = 5,
	},
			
}