--#Script:ReloadScript("scripts/materials/mat_grass.lua")
Script:LoadScript("scripts/materials/commoneffects.lua")
Materials["mat_grass"] = {
	type="grass",
-------------------------------------
	PhysicsSounds=PhysicsSoundsTable.Soft,
-------------------------------------
	bullet_hit = {
		-- sounds = {
			-- {"Sounds/BulletHits/bgrass1.wav",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/bgrass2.wav",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/bgrass3.wav",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/bgrass4.wav",SOUND_UNSCALABLE,255,3,101},
		-- },
		sounds = {
			{"Sounds/BulletHits/Grass/1.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/2.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/3.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/4.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/5.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/6.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/7.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/8.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/9.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/10.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/11.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/12.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/13.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/14.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/15.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/16.mp3",SOUND_UNSCALABLE,255,3,101},
		},
		decal = {
			texture = System:LoadTexture("Textures/Decal/ground.dds"),
			scale = .03,
		},

		particleEffects = {
			name = "bullet.hit_leaf.a",
		},
	},

	pancor_bullet_hit = {
		sounds = {
			{"Sounds/BulletHits/Grass/1.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/2.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/3.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/4.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/5.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/6.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/7.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/8.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/9.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/10.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/11.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/12.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/13.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/14.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/15.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/16.mp3",SOUND_UNSCALABLE,255,3,101},
		},
		decal = {
			texture = System:LoadTexture("Textures/Decal/ground.dds"),
			scale = .03,
		},

		particleEffects = {
			name = "bullet.hit_leaf.a",
		},
	},

	projectile_hit = CommonEffects.common_projectile_hit,
	-- mg_hit = CommonEffects.common_mg_hit,
	mortar_hit = CommonEffects.common_mortar_hit,
	smokegrenade_hit = CommonEffects.common_smokegrenade_hit,
	flashgrenade_hit = CommonEffects.common_flashgrenade_hit,
	grenade_hit = CommonEffects.common_grenade_hit,
	rock_hit = {
		sounds = {
			{"Sounds/BulletHits/Stone/stone_grass1.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_grass2.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_grass5.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_grass6.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_grass8.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_grass12.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_grass13.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_grass14.mp3",SOUND_UNSCALABLE,255,2,100},
		},
	},
	melee_slash = {
		sounds = {
			{"Sounds/Weapons/machete/machetesand4.wav",SOUND_UNSCALABLE,255,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
		},
		particleEffects = {
			name = "bullet.hit_leaf.a",
		},

	},
-------------------------------------
	player_walk = CommonEffects.player_grass_walk,
	player_run = CommonEffects.player_grass_run,
	player_crouch = CommonEffects.player_grass_crouch,
	player_prone = CommonEffects.player_grass_prone,
	player_walk_inwater = CommonEffects.player_walk_inwater,

-------------------------------------
	player_drop = {
		sounds = {
			{"sounds/player/bodyfalls/bodyfallgrass1.wav",SOUND_UNSCALABLE,210,10,150},
			{"sounds/player/bodyfalls/bodyfallgrass2.wav",SOUND_UNSCALABLE,210,10,150},
		},
	},
-------------------------------------

	gameplay_physic = {
		piercing_resistence = 2,
		friction = .6,
		bouncyness= -2, -- default 0
		no_collide=1,
	},

---------------------------------------------
	AI = {
		fImpactRadius = 5,
	},

	--vehicle effects: particle is called when wheels are slipping,smoke in any case if the vehicle is moving.
	VehicleParticleEffect = CommonEffects.common_vehicle_particles_grass,
	--VehicleSmokeEffect = CommonEffects.common_vehicle_smoke_grass,
}