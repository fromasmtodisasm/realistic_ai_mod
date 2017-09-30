Script:LoadScript("scripts/materials/commoneffects.lua")
Materials["mat_concrete"] = {
	type="concrete",

	PhysicsSounds=PhysicsSoundsTable.Hard,
	
	bullet_drop_single = CommonEffects.common_bullet_drop_single_ashphalt,
	bullet_drop_rapid = CommonEffects.common_bullet_drop_rapid_ashphalt,
	
	bullet_hit = {
		sounds = {
			{"Sounds/BulletHits/Concrete/762_01.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_02.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_03.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_04.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Concrete/762_05.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Concrete/762_06.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_07.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_08.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Concrete/762_09.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_10.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_11.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_12.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_13.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_14.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_15.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_16.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_17.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_18.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_19.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_20.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_21.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_22.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_23.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_24.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_25.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_10.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_11.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_12.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_13.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_14.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_15.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_16.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_17.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_18.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_19.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_20.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_21.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_22.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_23.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_24.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_25.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_26.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_27.mp3",SOUND_UNSCALABLE,255,3,101},
		},
		decal = {
			texture = System:LoadTexture("Textures/Decal/concrete.dds"),
			scale = .045,
			random_scale = 44
		},
		
		particleEffects = {
			name = "bullet.hit_concrete.a",
		},
	},

	pancor_bullet_hit = {
		sounds = {
			{"Sounds/BulletHits/Concrete/762_01.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_02.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_03.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_04.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Concrete/762_05.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Concrete/762_06.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_07.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_08.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Concrete/762_09.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_10.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_11.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_12.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_13.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_14.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_15.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_16.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_17.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_18.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_19.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_20.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_21.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_22.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_23.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_24.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/762_25.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_10.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_11.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_12.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_13.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_14.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_15.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_16.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_17.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_18.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_19.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_20.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_21.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_22.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_23.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_24.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_25.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_26.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Concrete/impact_27.mp3",SOUND_UNSCALABLE,255,3,101},
		},
		decal = {
			texture = System:LoadTexture("Textures/Decal/concrete.dds"),
			scale = .045,
			random_scale = 44
		},
		
		particleEffects = {
			name = "bullet.hit_concrete_pancor.a",
		},
	},


	-- primary explosion from rocket
	projectile_hit = {
		particleEffects = {
			name = "explosions.rocket_nofire.a",
		},
		sounds = {
			{"Sounds/BulletHits/AT_Rockets/at_rocket_01.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/AT_Rockets/at_rocket_02.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/AT_Rockets/at_rocket_03.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/AT_Rockets/at_rocket_04.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/AT_Rockets/at_rocket_05.mp3",SOUND_UNSCALABLE,255,30,1000},
		},
	},
	mg_hit = {
		sounds = {
			{"Sounds/BulletHits/MiniGun/minigun_concrete_01.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/MiniGun/minigun_concrete_02.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/MiniGun/minigun_concrete_03.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/MiniGun/minigun_concrete_04.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/MiniGun/minigun_concrete_05.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/MiniGun/minigun_concrete_06.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/MiniGun/minigun_concrete_07.mp3",SOUND_UNSCALABLE,255,3,101},
		},
		decal = {
			texture = System:LoadTexture("Textures/Decal/concrete.dds"),
			scale = .045,
			random_scale = 44
		},
		
		particleEffects = {
			name = "bullet.hit_concrete.a",
		},
	},
	mortar_hit = CommonEffects.common_mortar_hit,
	smokegrenade_hit = CommonEffects.common_smokegrenade_hit,
	flashgrenade_hit = CommonEffects.common_flashgrenade_hit,
	grenade_hit = {
		sounds = {
			{"Sounds/BulletHits/HandGrenade/concrete1.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/HandGrenade/concrete2.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/HandGrenade/concrete3.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/HandGrenade/concrete4.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/HandGrenade/concrete5.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/HandGrenade/concrete6.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/HandGrenade/concrete7.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/HandGrenade/concrete8.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/HandGrenade/concrete9.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/HandGrenade/concrete10.mp3",SOUND_UNSCALABLE,255,2,100},
		},
	},
	rock_hit = {
		sounds = {
			{"Sounds/BulletHits/Stone/stone_concrete1.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_concrete2.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_concrete7.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_concrete8.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_concrete9.mp3",SOUND_UNSCALABLE,255,2,100},
		},
	},
	melee_slash = {
		sounds = {
			{"Sounds/Weapons/machete/macheteconc1.wav",SOUND_UNSCALABLE,185,5,30,
			  {fRadius=10,fInterest=1,fThreat=0,},
			},
			{"Sounds/Weapons/machete/macheteconc2.wav",SOUND_UNSCALABLE,185,5,30,
			  {fRadius=10,fInterest=1,fThreat=0,},
			},
			{"Sounds/Weapons/machete/macheteconc3.wav",SOUND_UNSCALABLE,185,5,30,
			  {fRadius=10,fInterest=1,fThreat=0,},
			},
		},
		particleEffects = {
			name = "bullet.hit_rock.a",
				},

	},

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
	gameplay_physic = {
		piercing_resistence = 15,
		friction = 1,
		bouncyness= .2, --default 0
	},

	AI = {
		fImpactRadius = 5,
	},
			
	--vehicle effects: particle is called when wheels are slipping,smoke in any case if the vehicle is moving.
	VehicleParticleEffect = CommonEffects.common_vehicle_smoke_concrete,
	--VehicleSmokeEffect = CommonEffects.common_vehicle_smoke_concrete,
}