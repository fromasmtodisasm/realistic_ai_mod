Script:LoadScript("scripts/materials/commoneffects.lua");
Materials["mat_armor"] = {
	type="armor",
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
		
		particleEffects = {
			name = "bullet.hit_metal_pancor.a",
		},
	},

	
		-------------------------
	melee_punch = {
		sounds = {
			{"sounds/objectimpact/hit1.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/objectimpact/hit2.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/objectimpact/hit3.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/objectimpact/hit4.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/objectimpact/hit5.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/objectimpact/hit6.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/objectimpact/hit7.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/objectimpact/hit8.wav",SOUND_UNSCALABLE,185,5,30},
			
		},
	},
	melee_slash = {
		sounds = {
			{"sounds/mutants/ab1/hit1.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/mutants/ab1/hit2.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/mutants/ab1/hit3.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/mutants/ab1/hit4.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/mutants/ab1/hit5.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/mutants/ab1/hit6.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/mutants/ab1/hit7.wav",SOUND_UNSCALABLE,185,5,30},
			--{"sounds/objectimpact/Mslash8.wav",SOUND_UNSCALABLE,255,5,30},
			
		},
		particles = CommonEffects.common_machete_hit_particles.particles,
	},

	projectile_hit = CommonEffects.common_projectile_hit,
	mortar_hit = CommonEffects.common_mortar_hit,
	smokegrenade_hit = CommonEffects.common_smokegrenade_hit,
	flashgrenade_hit = CommonEffects.common_flashgrenade_hit,
	grenade_hit = CommonEffects.common_grenade_hit,
-------------------------------------
	player_walk = {
		sounds = {
			{"sounds/player/footsteps/rock/step1.wav",SOUND_UNSCALABLE,220,3,20},
			{"sounds/player/footsteps/rock/step2.wav",SOUND_UNSCALABLE,220,3,20},
			{"sounds/player/footsteps/rock/step3.wav",SOUND_UNSCALABLE,220,3,20},
			{"sounds/player/footsteps/rock/step4.wav",SOUND_UNSCALABLE,220,3,20},
		},
	},
	player_run = {
		sounds = {
			{"sounds/player/footsteps/rock/step1.wav",SOUND_UNSCALABLE,220,3,20},
			{"sounds/player/footsteps/rock/step2.wav",SOUND_UNSCALABLE,220,3,20},
			{"sounds/player/footsteps/rock/step3.wav",SOUND_UNSCALABLE,220,3,20},
			{"sounds/player/footsteps/rock/step4.wav",SOUND_UNSCALABLE,220,3,20},
		},
	},
	player_crouch = {
		sounds = {
			{"sounds/player/footsteps/rock/step1.wav",SOUND_UNSCALABLE,220,3,20},
			{"sounds/player/footsteps/rock/step2.wav",SOUND_UNSCALABLE,220,3,20},
			{"sounds/player/footsteps/rock/step3.wav",SOUND_UNSCALABLE,220,3,20},
			{"sounds/player/footsteps/rock/step4.wav",SOUND_UNSCALABLE,220,3,20},
		},
	},
	player_prone = {
		sounds = {
			{"sounds/player/footsteps/rock/step1.wav",SOUND_UNSCALABLE,220,3,20},
			{"sounds/player/footsteps/rock/step2.wav",SOUND_UNSCALABLE,220,3,20},
			{"sounds/player/footsteps/rock/step3.wav",SOUND_UNSCALABLE,220,3,20},
			{"sounds/player/footsteps/rock/step4.wav",SOUND_UNSCALABLE,220,3,20},
		},
	},
	gameplay_physic = {
		piercing_resistence = 15,
		friction = 0.6,
		bouncyness= -2, -- default 0
	},

	AI = {
		fImpactRadius = 5,
	},

			
}