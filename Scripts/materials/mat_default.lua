
Script:LoadScript("scripts/materials/commoneffects.lua")

Materials["mat_default"] = {
	type="default",

	PhysicsSounds=PhysicsSoundsTable.Hard,

	bullet_drop_single = CommonEffects.common_bullet_drop_single,
	bullet_drop_rapid = CommonEffects.common_bullet_drop_rapid,

--	bullet_hit = CommonEffects.common_bullet_hit,
------------------------------------
--	new effect by MK !!!!
	bullet_hit = {

		particleEffects = {
			name = "bullet.hit_default.a",
		},
	},
	pancor_bullet_hit = {

		particleEffects = {
			name = "bullet.hit_default.a",
		},
	},
	shocker_hit = {
		particleEffects = {
			name = "bullet.hit_default.a",
		},
	},

	melee_slash = {
		particleEffects = {
			name = "bullet.hit_default.a",
				},
	},

	building = {
		sounds = {
			{"SOUNDS/items/ratchet.wav",SOUND_UNSCALABLE,255,5,20},
		},
	},

	projectile_hit = CommonEffects.common_projectile_hit,
	-- mg_hit = CommonEffects.common_mg_hit,
	mortar_hit = CommonEffects.common_mortar_hit,
	smokegrenade_hit = CommonEffects.common_smokegrenade_hit,
	flashgrenade_hit = CommonEffects.common_flashgrenade_hit,
	grenade_hit = CommonEffects.common_grenade_hit,
	ag36_explosion = {
		particleEffects = {
			name = "explosions.ag36.a",
			scale = 1,
		},
		sounds = {
			{"Sounds/BulletHits/HandGrenade/40mm_grenade_01.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/40mm_grenade_02.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/40mm_grenade_03.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/40mm_grenade_04.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/40mm_grenade_05.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/40mm_grenade_06.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/40mm_grenade_07.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/40mm_grenade_08.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/40mm_grenade_09.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/40mm_grenade_10.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/40mm_grenade_11.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/40mm_grenade_12.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/40mm_grenade_13.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/40mm_grenade_14.mp3",SOUND_UNSCALABLE,255,30,1000},
		},
	},
	small_explosion = {
		particleEffects = {
			name = "explosions.OICW_bullet_hit.OICW_explosion",
			scale = 1,
		},
		sounds = {
			{"Sounds/BulletHits/HandGrenade/40mm_grenade_01.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/40mm_grenade_02.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/40mm_grenade_03.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/40mm_grenade_04.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/40mm_grenade_05.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/40mm_grenade_06.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/40mm_grenade_07.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/40mm_grenade_08.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/40mm_grenade_09.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/40mm_grenade_10.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/40mm_grenade_11.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/40mm_grenade_12.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/40mm_grenade_13.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/40mm_grenade_14.mp3",SOUND_UNSCALABLE,255,30,1000},
		},
	},
	medium_explosion = {
		particleEffects = {
			name = "explosions.rocket.a",
			scale = .65,
		},
		sounds = {
			{"Sounds/BulletHits/AT_Rockets/at_rocket_01.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/AT_Rockets/at_rocket_02.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/AT_Rockets/at_rocket_03.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/AT_Rockets/at_rocket_04.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/AT_Rockets/at_rocket_05.mp3",SOUND_UNSCALABLE,255,30,1000},
		},
	},

	grenade_explosion_air = {
		particleEffects = {
			name = "explosions.Grenade_air.explosion",
			scale = 1,
		},
		sounds = {
			{"Sounds/BulletHits/HandGrenade/handgrenade_01.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/handgrenade_02.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/handgrenade_03.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/handgrenade_04.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/handgrenade_05.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/handgrenade_06.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/handgrenade_07.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/handgrenade_08.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/handgrenade_09.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/handgrenade_10.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/handgrenade_11.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/handgrenade_12.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/handgrenade_13.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/handgrenade_14.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/handgrenade_15.mp3",SOUND_UNSCALABLE,255,30,1000},
		},
	},
	grenade_explosion = {
		particleEffects = {
			name = "explosions.Grenade_terrain.explosion",
			scale = .7,
		},
		sounds = {
			{"Sounds/BulletHits/HandGrenade/handgrenade_01.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/handgrenade_02.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/handgrenade_03.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/handgrenade_04.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/handgrenade_05.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/handgrenade_06.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/handgrenade_07.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/handgrenade_08.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/handgrenade_09.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/handgrenade_10.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/handgrenade_11.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/handgrenade_12.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/handgrenade_13.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/handgrenade_14.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/HandGrenade/handgrenade_15.mp3",SOUND_UNSCALABLE,255,30,1000},
		},
	},
	rock_hit = {
		sounds = {
			-- {"SOUNDS/objectimpact/rock.wav",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_dirt1.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_dirt2.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_dirt3.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_dirt4.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_dirt5.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_dirt8.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_dirt9.mp3",SOUND_UNSCALABLE,255,2,100},
		},
	},

	flashbang_explode = {
		sounds = {
			{"Sounds/Weapons/flashbang.wav",SOUND_UNSCALABLE,255,2,100},
		},
	},


	player_walk = {
		sounds = {
			{"sounds/player/footsteps/step1.wav",SOUND_UNSCALABLE,123,1,20},
			{"sounds/player/footsteps/step2.wav",SOUND_UNSCALABLE,123,1,20},
			{"sounds/player/footsteps/step3.wav",SOUND_UNSCALABLE,123,1,20},
			{"sounds/player/footsteps/step4.wav",SOUND_UNSCALABLE,123,1,20},
		},
	},
	player_run = {
		sounds = {
			{"sounds/player/footsteps/step1.wav",SOUND_UNSCALABLE,123,1,20},
			{"sounds/player/footsteps/step2.wav",SOUND_UNSCALABLE,123,1,20},
			{"sounds/player/footsteps/step3.wav",SOUND_UNSCALABLE,123,1,20},
			{"sounds/player/footsteps/step4.wav",SOUND_UNSCALABLE,123,1,20},
		},
	},
	player_crouch = {
		sounds = {
			{"sounds/player/footsteps/step1.wav",SOUND_UNSCALABLE,123,1,20},
			{"sounds/player/footsteps/step2.wav",SOUND_UNSCALABLE,123,1,20},
			{"sounds/player/footsteps/step3.wav",SOUND_UNSCALABLE,123,1,20},
			{"sounds/player/footsteps/step4.wav",SOUND_UNSCALABLE,123,1,20},
		},
	},
	player_prone = {
		sounds = {
			{"sounds/player/footsteps/step1.wav",SOUND_UNSCALABLE,123,1,20},
			{"sounds/player/footsteps/step2.wav",SOUND_UNSCALABLE,123,1,20},
			{"sounds/player/footsteps/step3.wav",SOUND_UNSCALABLE,123,1,20},
			{"sounds/player/footsteps/step4.wav",SOUND_UNSCALABLE,123,1,20},
		},
	},
	player_walk_inwater = CommonEffects.player_walk_inwater,

	player_land = {
		sounds = {
			--sound,flags(put 0),volume,min,max
			--NOTE volume and min max are optional
			 {"sounds/doors/dooropen.wav"},
			 {"sounds/doors/dooropen.wav"},

		},
	},
	gameplay_physic = {
		piercing_resistence = 15,
		bouncyness= 0,
		friction = 1,
	},

---------------------------------------------
	AI = {
		fImpactRadius = 5,
	},

	--vehicle effects: particle is called when wheels are slipping,smoke in any case if the vehicle is moving.
	--VehicleParticleEffect = CommonEffects.common_vehicle_particles_rocks,
	VehicleSmokeEffect = CommonEffects.common_vehicle_smoke_mud,
}