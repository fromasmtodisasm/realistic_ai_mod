----#Script:ReloadScript("scripts/materials/mat_pebble.lua")
Script:LoadScript("scripts/materials/commoneffects.lua")

Materials["mat_pebble"] = {
	type="pebble",
-------------------------------------
	PhysicsSounds=PhysicsSoundsTable.Hard,
-------------------------------------
	bullet_drop_single = CommonEffects.common_bullet_drop_single_ashphalt,
	bullet_drop_rapid = CommonEffects.common_bullet_drop_rapid_ashphalt,
-------------------------------------

-- primary explosion from rocket

	projectile_hit = CommonEffects.common_projectile_hit,
	-- mg_hit = CommonEffects.common_mg_hit,
	mortar_hit = CommonEffects.common_mortar_hit,
	smokegrenade_hit = CommonEffects.common_smokegrenade_hit,
	flashgrenade_hit = CommonEffects.common_flashgrenade_hit,
	grenade_hit = CommonEffects.common_grenade_hit,

	bullet_hit = {
		-- sounds = {
			-- {"Sounds/BulletHits/bgravel1.wav",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/bgravel2.wav",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/bgravel3.wav",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/bgravel4.wav",SOUND_UNSCALABLE,255,3,101},
		-- },
		sounds = { -- Стнадартные звуки надоели, а звук попадания по грязи похож на стандартный гравий.
			{"Sounds/BulletHits/Mud/impact_mud_1.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Mud/impact_mud_2.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Mud/impact_mud_3.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Mud/impact_mud_4.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Mud/impact_mud_5.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Mud/impact_mud_6.mp3",SOUND_UNSCALABLE,255,3,101},
		},

		decal = {
			texture = System:LoadTexture("Textures/Decal/ground.dds"),
			scale = .035,
		},

				particleEffects = {
			name = "bullet.hit_ground.a",
		},
	},

	pancor_bullet_hit = {
		sounds = {
			{"Sounds/BulletHits/bgravel1.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/bgravel2.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/bgravel3.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/bgravel4.wav",SOUND_UNSCALABLE,255,3,101},



		},

		decal = {
			texture = System:LoadTexture("Textures/Decal/ground.dds"),
			scale = .035,
		},

				particleEffects = {
			name = "bullet.hit_ground_pancor.a",
		},
	},


-------------------------------------
	player_walk = CommonEffects.player_pebble_walk,
	player_run = CommonEffects.player_pebble_run,
	player_crouch = CommonEffects.player_pebble_crouch,
	player_prone = CommonEffects.player_pebble_prone,
	player_walk_inwater = CommonEffects.player_walk_inwater,

	player_drop = {
		sounds = {
			{"sounds/player/bodyfalls/bodyfallgravel1.wav",SOUND_UNSCALABLE,210,10,150},
			{"sounds/player/bodyfalls/bodyfallgravel2.wav",SOUND_UNSCALABLE,210,10,150},
			{"sounds/player/bodyfalls/bodyfallgravel3.wav",SOUND_UNSCALABLE,210,10,150},
		},

	},
	melee_slash = {
		sounds = {
			{"Sounds/Weapons/machete/machetesand4.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},

		},
		particles =  CommonEffects.common_machete_hit_canvas_part.particles,

	},
-------------------------------------
	player_land = {
		sounds = {
			--sound,volume,{min,max}
			--NOTE volume and min max are optional
			 {"sounds/doors/dooropen.wav"},
			 {"sounds/doors/dooropen.wav"},

		},
	},
	gameplay_physic = {
		piercing_resistence = 15,
		friction = .6,
		bouncyness= .2, --default 0
	},
	---------------------------------------------
	AI = {
		fImpactRadius = 5,
	},

	--vehicle effects: particle is called when wheels are slipping,smoke in any case if the vehicle is moving.
	VehicleParticleEffect = CommonEffects.common_vehicle_particles_rocks,
	VehicleSmokeEffect = CommonEffects.common_vehicle_smoke_mud,
}