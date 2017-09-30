Script:LoadScript("scripts/materials/commoneffects.lua");

--#Script:ReloadScript("scripts/materials/mat_rock.lua") --for copying/pasting into the console!!!
	

Materials["mat_rock"] = {
	type="rock",
-------------------------------------
	PhysicsSounds=PhysicsSoundsTable.Hard,
-------------------------------------	
	bullet_drop_single = CommonEffects.common_bullet_drop_single_ashphalt,
	bullet_drop_rapid = CommonEffects.common_bullet_drop_rapid_ashphalt,
-------------------------------------	

	projectile_hit = CommonEffects.common_projectile_hit,
	mortar_hit = CommonEffects.common_mortar_hit,
	smokegrenade_hit = CommonEffects.common_smokegrenade_hit,
	flashgrenade_hit = CommonEffects.common_flashgrenade_hit,
	grenade_hit = CommonEffects.common_grenade_hit,

	bullet_hit = {
		sounds = {
			{"Sounds/bullethits/brock1.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/brock2.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/brock3.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/brock4.wav",SOUND_UNSCALABLE,200,5,60},
				},
		decal = { 
			texture = System:LoadTexture("Textures/Decal/rock.dds"),
			scale = 0.05,
			random_scale = 100,
			random_rotation = 359,
				},
		
		particleEffects = {
			name = "bullet.hit_rock.a",
				},
		},
	pancor_bullet_hit = {
		sounds = {
			{"Sounds/bullethits/brock1.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/brock2.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/brock3.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/brock4.wav",SOUND_UNSCALABLE,200,5,60},
			},
		decal = { 
			texture = System:LoadTexture("Textures/Decal/rock.dds"),
			scale = 0.03,
			random_scale = 100,
			random_rotation = 359,
			},
		
		particleEffects = {
			name = "bullet.hit_rock_pancor.a",
			},
			
		},



-------------------------------------
	player_walk = CommonEffects.player_conc_walk,
	player_run = CommonEffects.player_conc_run,
	player_crouch = CommonEffects.player_conc_crouch,
	player_prone = CommonEffects.player_conc_prone,
	player_walk_inwater = CommonEffects.player_walk_inwater,
	
	player_drop = {
		sounds = {
			{"sounds/player/bodyfalls/bodyfallrock1.wav",SOUND_UNSCALABLE,210,10,150},
			{"sounds/player/bodyfalls/bodyfallrock2.wav",SOUND_UNSCALABLE,210,10,150},
		},

	},
	melee_slash = {
		sounds = {
			{"sounds/weapons/machete/macheteconc1.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
			{"sounds/weapons/machete/macheteconc2.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
			{"sounds/weapons/machete/macheteconc3.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
		},
		particleEffects = {
			name = "bullet.hit_rock.a",
				},
	},
-------------------------------------
	player_land = {
		sounds = {
			--sound , volume , {min, max}
			--NOTE volume and min max are optional
			 {"sounds/doors/dooropen.wav",SOUND_UNSCALABLE,150,4,20},
			 {"sounds/doors/dooropen.wav",SOUND_UNSCALABLE,150,4,20},
			
		},
	},
	gameplay_physic = {
		piercing_resistence = 15,
		friction = 0.7,
		bouncyness= 0.2, -- default 0
	},
	---------------------------------------------
	AI = {
		fImpactRadius = 5,
	},		
	
	--vehicle effects: particle is called when wheels are slipping, smoke in any case if the vehicle is moving.
	VehicleParticleEffect = CommonEffects.common_vehicle_particles_rocks,
	VehicleSmokeEffect = CommonEffects.common_vehicle_smoke_mud,	
}