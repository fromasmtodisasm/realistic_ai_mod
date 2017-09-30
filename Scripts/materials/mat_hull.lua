Script:LoadScript("scripts/materials/commoneffects.lua");
Materials["mat_hull"] = {
	type="hull",
-------------------------------------	
	PhysicsSounds=PhysicsSoundsTable.Hard,
-------------------------------------
	bullet_hit = {
		sounds = {
			{"Sounds/bullethits/Mbullet1.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/Mbullet2.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/Mbullet3.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/Mbullet4.wav",SOUND_UNSCALABLE,200,5,60},
			
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
				tid = System:LoadTexture("textures\\clouda2.dds"),
				frames=0,

			},
		},

	},

	pancor_bullet_hit = {
		sounds = {
			{"Sounds/bullethits/Mbullet1.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/Mbullet2.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/Mbullet3.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/Mbullet4.wav",SOUND_UNSCALABLE,200,5,60},
			
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
-------------------------------------
	gameplay_physic = {
		piercing_resistence = 15,
		bouncyness=0,
		friction = 1.0,
	},

	AI = {
		fImpactRadius = 5,
	},
			
}