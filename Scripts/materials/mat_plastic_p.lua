Script:LoadScript("scripts/materials/commoneffects.lua");
Materials["mat_plastic_p"] = {
	type="plastic_p",
-------------------------------------
	PhysicsSounds=PhysicsSoundsTable.Hard,
-------------------------------------	
	bullet_drop_single = CommonEffects.common_bullet_drop_single_ashphalt,
	bullet_drop_rapid = CommonEffects.common_bullet_drop_rapid_ashphalt,
-------------------------------------	
	bullet_hit = {
		sounds = {
			{"Sounds/bullethits/pbullet1.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/pbullet2.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/pbullet3.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/pbullet4.wav",SOUND_UNSCALABLE,200,5,60},
			
		},

		
		decal = { 
			texture = System:LoadTexture("Textures/Decal/Default.dds"),
			scale = 0.05,
		},
		particles = {
			{ --HitSmoke 
				focus = 1.5,
				color = {1,1,1},
				speed = 0.25,
				count = 5, 
				size = 0.06, 
				size_speed=0.2,
				gravity=-1,
				lifetime=0.6,
				tid = System:LoadTexture("textures\\clouda2.dds"),
				frames=0,

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
			texture = System:LoadTexture("Textures/Decal/Default.dds"),
			scale = 0.02,
		},
		
		particles = {
			{ --HitSmoke 
				focus = 1.5,
				color = {1,1,1},
				speed = 0.25,
				count = 5, 
				size = 0.06, 
				size_speed=0.2,
				gravity=-1,
				lifetime=0.6,
				tid = System:LoadTexture("textures\\clouda2.dds"),
				frames=0,

			},
		},
	},


	projectile_hit = CommonEffects.common_projectile_hit,
	mortar_hit = CommonEffects.common_mortar_hit,
	smokegrenade_hit = CommonEffects.common_smokegrenade_hit,
	flashgrenade_hit = CommonEffects.common_flashgrenade_hit,
	grenade_hit = CommonEffects.common_grenade_hit,
	melee_slash = {
		sounds = {
			{"Sounds/bullethits/pbullet1.wav",SOUND_UNSCALABLE,200,5,60,{fRadius=10,fInterest=1,fThreat=0,},}, 
			{"Sounds/bullethits/pbullet2.wav",SOUND_UNSCALABLE,200,5,60,{fRadius=10,fInterest=1,fThreat=0,},}, 
			{"Sounds/bullethits/pbullet3.wav",SOUND_UNSCALABLE,200,5,60,{fRadius=10,fInterest=1,fThreat=0,},}, 
			{"Sounds/bullethits/pbullet4.wav",SOUND_UNSCALABLE,200,5,60,{fRadius=10,fInterest=1,fThreat=0,},}, 
			},
		particles = {
			{ --HitSmoke 
				focus = 1.5,
				color = {1,1,1},
				speed = 0.25,
				count = 5, 
				size = 0.06, 
				size_speed=0.2,
				gravity=-1,
				lifetime=0.6,
				tid = System:LoadTexture("textures\\clouda2.dds"),
				frames=0,

			},

		},
	},
-------------------------------------
	player_walk = {
		sounds = {
			{"sounds/player/footsteps/rock/step1.wav",SOUND_UNSCALABLE,200,10,100},
			{"sounds/player/footsteps/rock/step2.wav",SOUND_UNSCALABLE,200,10,100},
			{"sounds/player/footsteps/rock/step3.wav",SOUND_UNSCALABLE,200,10,100},
			{"sounds/player/footsteps/rock/step4.wav",SOUND_UNSCALABLE,200,10,100},
		},
	},
	player_run = {
		sounds = {
			{"sounds/player/footsteps/rock/step1.wav",SOUND_UNSCALABLE,200,10,100},
			{"sounds/player/footsteps/rock/step2.wav",SOUND_UNSCALABLE,200,10,100},
			{"sounds/player/footsteps/rock/step3.wav",SOUND_UNSCALABLE,200,10,100},
			{"sounds/player/footsteps/rock/step4.wav",SOUND_UNSCALABLE,200,10,100},
		},
	},
	player_crouch = {
		sounds = {
			{"sounds/player/footsteps/rock/step1.wav",SOUND_UNSCALABLE,200,10,100},
			{"sounds/player/footsteps/rock/step2.wav",SOUND_UNSCALABLE,200,10,100},
			{"sounds/player/footsteps/rock/step3.wav",SOUND_UNSCALABLE,200,10,100},
			{"sounds/player/footsteps/rock/step4.wav",SOUND_UNSCALABLE,200,10,100},
		},
	},
	player_prone = {
		sounds = {
			{"sounds/player/footsteps/rock/step1.wav",SOUND_UNSCALABLE,200,10,100},
			{"sounds/player/footsteps/rock/step2.wav",SOUND_UNSCALABLE,200,10,100},
			{"sounds/player/footsteps/rock/step3.wav",SOUND_UNSCALABLE,200,10,100},
			{"sounds/player/footsteps/rock/step4.wav",SOUND_UNSCALABLE,200,10,100},
		},
	},
	player_walk_inwater = CommonEffects.player_walk_inwater,
	gameplay_physic = {
		piercing_resistence = nil,
		friction = 0.6,
		bouncyness= 0.2, --default 0
	},

	AI = {
		fImpactRadius = 5,
	},
			
}