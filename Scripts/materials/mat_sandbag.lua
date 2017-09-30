Script:LoadScript("scripts/materials/commoneffects.lua");
	
local WalkParticles = 
	{
		{--dust
			focus = 0,
			speed = 0.25,
			start_color = {0.89,0.69,0.4},
			end_color = {1,1,1},
			count = 7, --default 5
			size = 0.3, 
			size_speed=0.2,
			rotation = {x = 0.0, y = 0.0, z = 4},
			gravity = {x = 0.0, y = 0.0, z = 0},
			lifetime=2,
			blend_type = 0,
			tid = System:LoadTexture("textures\\clouda2.dds"),
			frames=0,
		},

	}
Materials["mat_sandbag"] = {
	type="sandbag",
-------------------------------------	
	PhysicsSounds=PhysicsSoundsTable.Soft,
-------------------------------------	
	projectile_hit = CommonEffects.common_projectile_hit,
	mortar_hit = CommonEffects.common_mortar_hit,
	smokegrenade_hit = CommonEffects.common_smokegrenade_hit,
	flashgrenade_hit = CommonEffects.common_flashgrenade_hit,
	grenade_hit = CommonEffects.common_grenade_hit,

	bullet_hit = {
		sounds = {
			{"Sounds/Bullethits/bsand1.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/bsand2.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/bsand3.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/bsand4.wav",SOUND_UNSCALABLE,200,5,60},
			},
		decal = { 
			texture = System:LoadTexture("Textures/Decal/ground.dds"),
			scale = 0.03,
		},

		particleEffects = {
			name = "bullet.hit_sand.a",
			},
		},

	pancor_bullet_hit = {
		sounds = {
			{"Sounds/Bullethits/bsand1.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/bsand2.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/bsand3.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/bsand4.wav",SOUND_UNSCALABLE,200,5,60},
			},
		decal = { 
			texture = System:LoadTexture("Textures/Decal/ground.dds"),
			scale = 0.02,
		},

		particleEffects = {
			name = "bullet.hit_sand_pancor.a",
			},
		},

	melee_slash = {
		sounds = {
			{"sounds/weapons/machete/machetesand4.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
			--{"sounds/weapons/machete/machetesand2.wav",SOUND_UNSCALABLE,255,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
			--{"sounds/weapons/machete/machetesand3.wav",SOUND_UNSCALABLE,255,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
		},
		particles = 
			{
				{ --HitSparksTrail
				focus = 0.0,
				color = {1,1,1},
				speed = 2.0,
				count = 5,
				size = 0.010, 
				size_speed=0,
				gravity={x=0,y=0,z=-5},
				lifetime=0.1,
				tid = System:LoadTexture("Textures/Decal/Spark.dds"),
				tail_length = 0.3,
				frames=0,
				blend_type = 2
				},
				{ --HitStonesDark
				focus = 1,
				speed = 2,
				start_color = {1,1,1},
				end_color = {1,1,1}, 
				count = 8, --default 3
				size = 0.01, 
				size_speed=0,
				gravity = {x = 0.0, y = 0.0, z = -3},
				rotation = {x = 0.0, y = 0.0, z = 15},
				lifetime=0.75,
				frames=1,
				blend_type = 0,
				bouncyness = 0.5,
				tid = System:LoadTexture("textures\\Sprites\\stone1.dds"),
				},
				{ --HitStonesLight
				focus = 1,
				speed = 2,
				start_color = {1,1,1},
				end_color = {1,1,1}, 
				count = 6, --default 2
				size = 0.01, 
				size_speed=0,
				gravity = {x = 0.0, y = 0.0, z = -3},
				rotation = {x = 0.0, y = 0.0, z = 50},
				lifetime=0.750,
				frames=1,
				blend_type = 0,
				bouncyness = 0.5,
				tid = System:LoadTexture("textures\\Sprites\\stone2.dds"),
				},				
			{--hitsmoke
 				focus = 0,
				start_color = {0.89,0.69,0.4},
				end_color = {1,1,1},
				speed = 0.1,
				count = 5, --default 3
				size = 0.01, 
				size_speed=0.01,
				gravity = {x = 0.0, y = 0.0, z = 0.1},
				rotation = {x = 0.0, y = 0.0, z = 2},
				lifetime=1.25,
				tid = System:LoadTexture("textures/clouda2.dds"),
				frames=0,
				blend_type = 0,
			},	
		},
	},


-------------------------------------
	
	player_walk = {
		sounds = {
			{"sounds/player/footsteps/pebble/step1.wav",SOUND_UNSCALABLE,140,10,60},
			{"sounds/player/footsteps/pebble/step2.wav",SOUND_UNSCALABLE,140,10,60},
			{"sounds/player/footsteps/pebble/step3.wav",SOUND_UNSCALABLE,140,10,60},
			{"sounds/player/footsteps/pebble/step4.wav",SOUND_UNSCALABLE,140,10,60},
		},
		particles = WalkParticles,
	},
	player_run = {
		sounds = {
			{"sounds/player/footsteps/pebble/step1.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/pebble/step2.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/pebble/step3.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/pebble/step4.wav",SOUND_UNSCALABLE,200,10,60},
		},
		particles = WalkParticles,
	},
	player_crouch = {
		sounds = {
			{"sounds/player/footsteps/pebble/step1.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/pebble/step2.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/pebble/step3.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/pebble/step4.wav",SOUND_UNSCALABLE,120,10,60},
		},
		particles = WalkParticles,
	},
	player_prone = {
		sounds = {
			{"sounds/player/footsteps/pebble/step1.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/pebble/step2.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/pebble/step3.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/pebble/step4.wav",SOUND_UNSCALABLE,120,10,60},
		},
		particles = WalkParticles,
	},
	player_walk_inwater = CommonEffects.player_walk_inwater,
-------------------------------------
	player_land = {
		sounds = {
			--sound , volume , {min, max}
			--NOTE volume and min max are optional
			 {"sounds/doors/dooropen.wav"},
			 {"sounds/doors/dooropen.wav"},
			
		},
	},
	gameplay_physic = {
		piercing_resistence = 15,
		friction = 1,
		bouncyness= -2, -- default 0
	},

	AI = {
		fImpactRadius = 5,
	},
			
}