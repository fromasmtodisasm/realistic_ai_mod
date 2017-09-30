Script:LoadScript("scripts/materials/commoneffects.lua");
Materials["mat_waterfall"] = {
	type="waterfall",
-------------------------------------	
	bullet_hit = {
		sounds = {
			{"Sounds/bullethits/bwater1.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/bwater2.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/bwater3.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/bwater4.wav",SOUND_UNSCALABLE,200,5,60},
			
		},
		particles = {
			{--water particles
				focus = 20,
				color = {0.29,0.19,0.0},
				speed = 1.0,
				count = 3,
				size = 0.1, 
				size_speed=0.3,
				gravity={x=0,y=0,z=-0.5},
				rotation = {x=0,y=0,z=2},
				lifetime=0.7,
				tid = System:LoadTexture("textures\\clouda2.dds"),
				frames=0,
				blend_type = 0
			},
			{--water splashes
				focus =10,
				speed = 1.5,
				count = 2,
				size = 0.05, 
				size_speed=0.4,
				rotation = {x=0,y=0,z=0},
				gravity={x=0,y=0,z=-2},
				lifetime=0.4,
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