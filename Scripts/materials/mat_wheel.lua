Script:LoadScript("scripts/materials/commoneffects.lua")

Materials["mat_wheel"] = {
	type="wheel",
-------------------------------------
	PhysicsSounds=PhysicsSoundsTable.Soft,
-------------------------------------
	bullet_hit = {
		sounds = {
			{"Sounds/BulletHits/pbullet1.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/pbullet2.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/pbullet3.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/pbullet4.wav",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Rubber/rubber_01.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Rubber/rubber_02.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Rubber/rubber_03.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Rubber/rubber_04.mp3",SOUND_UNSCALABLE,255,3,101},
		},
		particleEffects = {
			name = "bullet.hit_default.a",
		},
	},
	pancor_bullet_hit = {
		sounds = {
			{"Sounds/BulletHits/pbullet1.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/pbullet2.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/pbullet3.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/pbullet4.wav",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Rubber/rubber_01.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Rubber/rubber_02.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Rubber/rubber_03.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Rubber/rubber_04.mp3",SOUND_UNSCALABLE,255,3,101},
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
	-- mg_hit = CommonEffects.common_mg_hit,
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
		bouncyness=.4, -- default .1
		friction = 10,
	},

	AI = {
		fImpactRadius = 5,
	},

}