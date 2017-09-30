Script:LoadScript("scripts/materials/commoneffects.lua");
Materials["mat_gel"] = {
	type="gel",
-------------------------------------	
	PhysicsSounds=PhysicsSoundsTable.Soft,
-------------------------------------
	bullet_hit = {
		sounds = {
			{"Sounds/bullethits/pbullet1.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/pbullet2.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/pbullet3.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/pbullet4.wav",SOUND_UNSCALABLE,200,5,60},
			
		},
		
		decal = { 
			texture = System:LoadTexture("Textures/Decal/ground.dds"),
			scale = 0.03,
		},

		particles = {
			{ --HitSmoke 
				focus = 1.5,
				color = {0.29,0.19,0.0},
				speed = 0.75,
				count = 4, --default 2
				size = 0.1, 
				size_speed=0.15,
				gravity=-1,
				lifetime=0.5,
				tid = System:LoadTexture("textures\\cloud1.dds"),
				frames=0,
				color_based_blending = 3
			},
		},

	},

	pancor_bullet_hit = {
		sounds = {
			{"Sounds/bullethits/pbullet1.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/pbullet2.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/pbullet3.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/pbullet4.wav",SOUND_UNSCALABLE,200,5,60},
			
		},
		
		decal = { 
			texture = System:LoadTexture("Textures/Decal/ground.dds"),
			scale = 0.03,
		},

		particles = {
			{ --HitSmoke 
				focus = 1.5,
				color = {0.29,0.19,0.0},
				speed = 0.75,
				count = 1, --default 2
				size = 0.1, 
				size_speed=0.15,
				gravity=-1,
				lifetime=0.5,
				tid = System:LoadTexture("textures\\cloud1.dds"),
				frames=0,
				color_based_blending = 3
			},
		},

	},

	melee_slash = {
		sounds = {
			{"Sounds/bullethits/pbullet1.wav",SOUND_UNSCALABLE,200,5,60,{fRadius=10,fInterest=1,fThreat=0,},}, 
			{"Sounds/bullethits/pbullet2.wav",SOUND_UNSCALABLE,200,5,60,{fRadius=10,fInterest=1,fThreat=0,},}, 
			{"Sounds/bullethits/pbullet3.wav",SOUND_UNSCALABLE,200,5,60,{fRadius=10,fInterest=1,fThreat=0,},}, 
			{"Sounds/bullethits/pbullet4.wav",SOUND_UNSCALABLE,200,5,60,{fRadius=10,fInterest=1,fThreat=0,},}, 
		},

		particles =  CommonEffects.common_machete_hit_canvas_part.particles,

	}, 

	projectile_hit = CommonEffects.common_projectile_hit,
	mortar_hit = CommonEffects.common_mortar_hit,
	smokegrenade_hit = CommonEffects.common_smokegrenade_hit,
	flashgrenade_hit = CommonEffects.common_flashgrenade_hit,
	grenade_hit = CommonEffects.common_grenade_hit,
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
	player_walk_inwater = CommonEffects.player_walk_inwater,
	
	player_drop = {
		sounds = {
			{"sounds/player/bodyfalls/bodyfallmud1.wav",SOUND_UNSCALABLE,210,10,150},
		},

	},
	gameplay_physic = {
		piercing_resistence = 15,
		friction = 0.8,
	},

	AI = {
		fImpactRadius = 2,
	},
			
}