Script:LoadScript("scripts/materials/commoneffects.lua")
Materials["mat_mud"] = {
	type="mud",

	PhysicsSounds=PhysicsSoundsTable.Soft,

	bullet_hit = {
		sounds = {
			{"Sounds/BulletHits/pbullet1.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/pbullet2.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/pbullet3.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/pbullet4.wav",SOUND_UNSCALABLE,255,3,101},
		},

		decal = {
			texture = System:LoadTexture("Textures/Decal/ground.dds"),
			scale = .03,
		},

		particles = {
			{--HitSmoke
				focus = 1.5,
				color = {.29,.19,0},
				speed = .75,
				count = 4, --default 2
				size = .1,
				size_speed=.15,
				gravity=-1,
				lifetime=.5,
				tid = System:LoadTexture("textures\\dust_smoke6.DDS"),
				frames=0,

			},
		},
	},
	pancor_bullet_hit = {
		sounds = {
			{"Sounds/BulletHits/pbullet1.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/pbullet2.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/pbullet3.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/pbullet4.wav",SOUND_UNSCALABLE,255,3,101},
			},

		decal = {
			texture = System:LoadTexture("Textures/Decal/ground.dds"),
			scale = .03,
		},

		particles = {
				{--HitSmoke
				focus = 1.5,
				color = {.29,.19,0},
				speed = .75,
				count = 4, --default 2
				size = .1,
				size_speed=.15,
				gravity=-1,
				lifetime=.5,
				tid = System:LoadTexture("textures\\dust_smoke6.DDS"),
				frames=0,

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
			{"Sounds/Weapons/machete/machetesand4.wav",SOUND_UNSCALABLE,185,5,30},

		},
		particles =  CommonEffects.common_machete_hit_canvas_part.particles,
	},

	player_walk = CommonEffects.player_pebble_walk,
	player_run = CommonEffects.player_pebble_run,
	player_crouch = CommonEffects.player_pebble_crouch,
	player_prone = CommonEffects.player_pebble_prone,
	player_walk_inwater = CommonEffects.player_walk_inwater,

	player_drop = {
		sounds = {
			{"sounds/player/bodyfalls/bodyfallmud1.wav",SOUND_UNSCALABLE,210,10,150},
		},

	},

	player_land = {
		sounds = {
			--sound,volume,{min,max}
			--NOTE volume and min max are optional
			 {"sounds/doors/dooropen.wav",SOUND_UNSCALABLE,200,1,20},
			 {"sounds/doors/dooropen.wav",SOUND_UNSCALABLE,200,1,20},

		},
	},
	gameplay_physic = {
		piercing_resistence = 15,
		friction = 1.2,
		bouncyness= -2, -- default 0
	},

	AI = {
		fImpactRadius = 5,
	},

	--vehicle effects: particle is called when wheels are slipping,smoke in any case if the vehicle is moving.
	VehicleParticleEffect = CommonEffects.common_vehicle_particles_rocks,
	VehicleSmokeEffect = CommonEffects.common_vehicle_smoke_mud,
}