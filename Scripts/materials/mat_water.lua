Script:LoadScript("scripts/materials/commoneffects.lua");
Materials["mat_water"] = {
	type="water",
-------------------------------------	
	bullet_hit = {
		sounds = {
			{"Sounds/bullethits/bwater1.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/bwater2.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/bwater3.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/bwater4.wav",SOUND_UNSCALABLE,200,5,60},
			
		},
		
		particleEffects = {
			name = "bullet.hit_water.a",
		},
	},

	pancor_bullet_hit = {
		sounds = {
			{"Sounds/bullethits/bwater1.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/bwater2.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/bwater3.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/bwater4.wav",SOUND_UNSCALABLE,200,5,60},
			
				},
		
		particleEffects = {
			name = "bullet.hit_water_pancor.a",
		},
	},

		
		

	grenade_splash = {
		--sounds = {
			--{"Sounds/weapons/grenade/splash1.wav",SOUND_UNSCALABLE,150,3,100},
		--},
		particles = {

			{--ExplosionSplashes = 
				focus = 7,
				color = {1,1,1},
				speed = 8, -- default 10
				rotation = {x=0,y=0,z=0},
				count = 20, -- default 20
				size = 0.03, size_speed = 0.36, -- default size 0.03 size_speed 1
				gravity = {x = 0.0, y = 0.0, z = -25.0}, -- default z = -15
				lifetime = 0.55, -- default 0.7
				blend_type = 0,
				frames = 1,
				tid = System:LoadTexture("textures/dirt2.dds"),
				},
		
	 		{--WaterRipples
				focus = 0.0,
				color = {1,1,1},
				speed = 0.0,
				count = 3,
				size = 0.2, size_speed=4, -- default size_speed = 2
				gravity=0,
				lifetime=6, -- default 2 
				tid = System:LoadTexture("textures\\ripple.dds"),
				frames=0,
				blend_type = 0,
				particle_type = 1,
			},
		},
	},

	projectile_hit = CommonEffects.water_projectile_hit,
	melee_slash = {
		sounds = {
			{"Sounds/weapons/grenade/splash1.wav",SOUND_UNSCALABLE,150,3,100},
			--{"sounds/player/footsteps/metal/step2.wav",SOUND_UNSCALABLE,185,5,30},
			--{"sounds/player/footsteps/metal/step3.wav",SOUND_UNSCALABLE,185,5,30},
			--{"sounds/player/footsteps/metal/step4.wav",SOUND_UNSCALABLE,185,5,30},
		},
		particleEffects = {
			name = "bullet.hit_water.a",
		},
	},

	grenade_explosion = {
		sounds = {
			{"Sounds/explosions/explosion4.wav",0,175,20,10000},
		},
		particleEffects = {
			name = "explosions.Grenade_water.ripples",
		},
	},
	grenade_hit = CommonEffects.water_splash,

	rock_hit = CommonEffects.water_splash,

--	player_walk = {
--		sounds = {
--			{"sounds/player/footsteps/water/step1.wav",SOUND_UNSCALABLE,200,10,60},
--			{"sounds/player/footsteps/water/step2.wav",SOUND_UNSCALABLE,200,10,60},
--			{"sounds/player/footsteps/water/step3.wav",SOUND_UNSCALABLE,200,10,60},
--			{"sounds/player/footsteps/water/step4.wav",SOUND_UNSCALABLE,200,10,60},
--		},

--	},
	
	player_drop = {
		sounds = {
			{"sounds/player/bodyfalls/bodysplash.wav",SOUND_UNSCALABLE,210,10,150},
		},

	},
	
	
	gameplay_physic = {
		piercing_resistence = 15,
		friction = 1,
	},

	AI = {
		fImpactRadius = 5,
	},
			
}