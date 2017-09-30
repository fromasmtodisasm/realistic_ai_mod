Script:LoadScript("scripts/materials/commoneffects.lua")
Materials["mat_canvas"] = {
	type="canvas",

-------------------------------------
	PhysicsSounds=PhysicsSoundsTable.Hard,
-------------------------------------
	bullet_drop_single = CommonEffects.common_bullet_drop_single_ashphalt,
	bullet_drop_rapid = CommonEffects.common_bullet_drop_rapid_ashphalt,
-------------------------------------
	bullet_hit = {
		sounds = {
			-- {"Sounds/BulletHits/Wood/wood_01.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Wood/wood_02.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Wood/wood_03.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Wood/wood_04.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Wood/wood_05.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Wood/wood_06.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Wood/wood_07.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Wood/wood_08.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Wood/wood_09.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Wood/wood_10.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Wood/wood_11.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Wood/wood_12.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Wood/wood_13.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Wood/wood_14.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Wood/wood_15.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Wood/wood_16.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Wood/wood_17.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Wood/wood_18.mp3",SOUND_UNSCALABLE,255,3,101},
		},

		decal = {
			texture = System:LoadTexture("Textures/Decal/Default.tga"),
			scale = .025,
		},
		particles = {
			{--HitSmoke
				focus = 1.5,
				color = {.29,.19,0},
				speed = .25,
				count = 3,
				size = .05,
				size_speed=.15,
				gravity=-1,
				lifetime=.5,
				tid = System:LoadTexture("textures\\cloud1.dds"),
				frames=0,
				color_based_blending = 3
			},
		},
	},

	projectile_hit = CommonEffects.common_projectile_hit,
	-- mg_hit = CommonEffects.common_mg_hit,
	mortar_hit = CommonEffects.common_mortar_hit,
	smokegrenade_hit = CommonEffects.common_smokegrenade_hit,
	flashgrenade_hit = CommonEffects.common_flashgrenade_hit,
	grenade_hit = CommonEffects.common_grenade_hit,
	melee_slash = {
		sounds = {
			{"Sounds/Weapons/machete/machetewood1.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
			{"Sounds/Weapons/machete/machetewood2.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
			{"Sounds/Weapons/machete/machetewood3.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
		},
		particles =  CommonEffects.common_machete_hit_canvas_part.particles,

	},

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
		piercing_resistence = 7, -- 10 -- Палатки и некоторые бараки.
		friction = .6,
		bouncyness= .2, --default 0
	},

	AI = {
		fImpactRadius = 1,
	},

}