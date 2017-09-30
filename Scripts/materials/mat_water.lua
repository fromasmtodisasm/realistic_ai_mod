Script:LoadScript("scripts/materials/commoneffects.lua")
Materials["mat_water"] = {
	type="water",
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
		particleEffects = {
			name = "bullet.hit_water.a",
		},
	},

	pancor_bullet_hit = {
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
		particleEffects = {
			name = "bullet.hit_water_pancor.a",
		},
	},




	grenade_splash = {
		--sounds = {
			--{"Sounds/Weapons/grenade/splash1.wav",SOUND_UNSCALABLE,150,3,100},
		--},
		particles = {

			{--ExplosionSplashes =
				focus = 7,
				color = {1,1,1},
				speed = 8, -- default 10
				rotation = {x=0,y=0,z=0},
				count = 20, -- default 20
				size = .03,size_speed = .36, -- default size .03 size_speed 1
				gravity = {x = 0,y = 0,z = -25},-- default z = -15
				lifetime = .55, -- default .7
				blend_type = 0,
				frames = 1,
				tid = System:LoadTexture("textures/dirt2.dds"),
				},

	 		{--WaterRipples
				focus = 0,
				color = {1,1,1},
				speed = 0,
				count = 3,
				size = .2,size_speed=4, -- default size_speed = 2
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
			{"Sounds/Weapons/grenade/splash1.wav",SOUND_UNSCALABLE,150,3,100},
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