Script:LoadScript("scripts/materials/commoneffects.lua");

Materials["mat_wheel"] = {
	type="wheel",
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
		particleEffects = {
			name = "bullet.hit_default.a",
		},
	},
	pancor_bullet_hit = {
		sounds = {
			{"Sounds/bullethits/pbullet1.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/pbullet2.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/pbullet3.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/pbullet4.wav",SOUND_UNSCALABLE,200,5,60},
			
		},
		particleEffects = {
			name = "bullet.hit_default.a",
		},
	},
	melee_slash = {
		sounds = {
			{"sounds/player/footsteps/metal/step1.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/player/footsteps/metal/step2.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/player/footsteps/metal/step3.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/player/footsteps/metal/step4.wav",SOUND_UNSCALABLE,185,5,30},
		},
		particleEffects = {
			name = "bullet.hit_default.a",
		},
	},
	projectile_hit = CommonEffects.common_projectile_hit,
	mortar_hit = CommonEffects.common_mortar_hit,
	smokegrenade_hit = CommonEffects.common_smokegrenade_hit,
	flashgrenade_hit = CommonEffects.common_flashgrenade_hit,
	grenade_hit = CommonEffects.common_grenade_hit,

-------------------------------------
	player_walk = {
		sounds = {
			{"sounds/player/footsteps/rock/step1.wav",SOUND_UNSCALABLE,140,10,60},
			{"sounds/player/footsteps/rock/step2.wav",SOUND_UNSCALABLE,140,10,60},
			{"sounds/player/footsteps/rock/step3.wav",SOUND_UNSCALABLE,140,10,60},
			{"sounds/player/footsteps/rock/step4.wav",SOUND_UNSCALABLE,140,10,60},
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
			{"sounds/player/footsteps/rock/step1.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/rock/step2.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/rock/step3.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/rock/step4.wav",SOUND_UNSCALABLE,120,10,60},
		},
	},
	player_prone = {
		sounds = {
			{"sounds/player/footsteps/rock/step1.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/rock/step2.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/rock/step3.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/rock/step4.wav",SOUND_UNSCALABLE,120,10,60},
		},
	},
	player_walk_inwater = CommonEffects.player_walk_inwater,
	
	gameplay_physic = {
		piercing_resistence = 15,
		bouncyness=0.4, -- default 0.1
		friction = 10.0,
	},

	AI = {
		fImpactRadius = 5,
	},
			
}