Script:LoadScript("scripts/materials/commoneffects.lua")
Materials["mat_waterfall"] = {
	type="waterfall",
-------------------------------------	
	bullet_hit = {
		sounds = {
			-- {"Sounds/BulletHits/bwater1.wav",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/bwater2.wav",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/bwater3.wav",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/bwater4.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Water/water_impact_1.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Water/water_impact_2.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Water/water_impact_3.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Water/water_impact_4.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Water/water_impact_5.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Water/water_impact_6.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Water/water_impact_7.mp3",SOUND_UNSCALABLE,255,3,101},
		},
		particles = {
			{--water particles
				focus = 20,
				color = {.29,.19,0},
				speed = 1,
				count = 3,
				size = .1,
				size_speed=.3,
				gravity={x=0,y=0,z=-.5},
				rotation = {x=0,y=0,z=2},
				lifetime=.7,
				tid = System:LoadTexture("textures\\clouda2.dds"),
				frames=0,
				blend_type = 0
			},
			{--water splashes
				focus =10,
				speed = 1.5,
				count = 2,
				size = .05,
				size_speed=.4,
				rotation = {x=0,y=0,z=0},
				gravity={x=0,y=0,z=-2},
				lifetime=.4,
				tid = System:LoadTexture("textures\\splash1.dds"),
				frames=0,
				blend_type = 0
			},
		},
	},
	melee_slash = {
		sounds = {
			{"sounds/player/footsteps/metal/step1.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/player/footsteps/metal/step2.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/player/footsteps/metal/step3.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/player/footsteps/metal/step4.wav",SOUND_UNSCALABLE,185,5,30},
		},
	},

	player_walk = {
		sounds = {
			{"sounds/player/footsteps/water/step1.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/water/step2.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/water/step3.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/water/step4.wav",SOUND_UNSCALABLE,200,10,60},
		},
	},
	player_run = {
		sounds = {
			{"sounds/player/footsteps/water/step1.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/water/step2.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/water/step3.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/water/step4.wav",SOUND_UNSCALABLE,200,10,60},
		},
	},
	player_crouch = {
		sounds = {
			{"sounds/player/footsteps/water/step1.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/water/step2.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/water/step3.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/water/step4.wav",SOUND_UNSCALABLE,200,10,60},
		},
	},
	player_prone = {
		sounds = {
			{"sounds/player/footsteps/water/step1.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/water/step2.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/water/step3.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/water/step4.wav",SOUND_UNSCALABLE,200,10,60},
		},
	},
	player_walk_inwater = CommonEffects.player_walk_inwater,
	gameplay_physic = {
		piercing_resistence = 15,
		friction = 1,
	},

	AI = {
		fImpactRadius = 3,
	},
			
}