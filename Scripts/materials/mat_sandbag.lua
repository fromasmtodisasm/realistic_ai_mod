Script:LoadScript("scripts/materials/commoneffects.lua")
	
local WalkParticles = 
	{
		{--dust
			focus = 0,
			speed = .25,
			start_color = {.89,.69,.4},
			end_color = {1,1,1},
			count = 7, --default 5
			size = .3,
			size_speed=.2,
			rotation = {x = 0,y = 0,z = 4},
			gravity = {x = 0,y = 0,z = 0},
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
	-- mg_hit = CommonEffects.common_mg_hit,
	mortar_hit = CommonEffects.common_mortar_hit,
	smokegrenade_hit = CommonEffects.common_smokegrenade_hit,
	flashgrenade_hit = CommonEffects.common_flashgrenade_hit,
	grenade_hit = CommonEffects.common_grenade_hit,
	rock_hit = {
		sounds = {
			{"Sounds/BulletHits/Stone/stone_sand1.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_sand2.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_sand3.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_sand4.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_sand5.mp3",SOUND_UNSCALABLE,255,2,100},
		},
	},
	bullet_hit = {
		sounds = {
			{"Sounds/BulletHits/Dirt_sand/sand_01.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/sand_02.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/sand_03.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/sand_04.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/sand_05.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/sand_06.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/sand_07.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/sand_08.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/sand_09.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/sand_10.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/sand_11.mp3",SOUND_UNSCALABLE,255,3,101},
		},
		decal = {
			texture = System:LoadTexture("Textures/Decal/ground.dds"),
			scale = .03,
		},

		particleEffects = {
			name = "bullet.hit_sand.a",
			},
		},

	pancor_bullet_hit = {
		sounds = {
			{"Sounds/BulletHits/Dirt_sand/sand_01.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/sand_02.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/sand_03.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/sand_04.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/sand_05.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/sand_06.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/sand_07.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/sand_08.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/sand_09.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/sand_10.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/sand_11.mp3",SOUND_UNSCALABLE,255,3,101},
		},
		decal = {
			texture = System:LoadTexture("Textures/Decal/ground.dds"),
			scale = .02,
		},

		particleEffects = {
			name = "bullet.hit_sand_pancor.a",
			},
		},

	melee_slash = {
		sounds = {
			{"Sounds/Weapons/machete/machetesand4.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
			--{"Sounds/Weapons/machete/machetesand2.wav",SOUND_UNSCALABLE,255,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
			--{"Sounds/Weapons/machete/machetesand3.wav",SOUND_UNSCALABLE,255,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
		},
		particles = 
			{
				{--HitSparksTrail
				focus = 0,
				color = {1,1,1},
				speed = 2,
				count = 5,
				size = .010,
				size_speed=0,
				gravity={x=0,y=0,z=-5},
				lifetime=.1,
				tid = System:LoadTexture("Textures/Decal/Spark.dds"),
				tail_length = .3,
				frames=0,
				blend_type = 2
				},
				{--HitStonesDark
				focus = 1,
				speed = 2,
				start_color = {1,1,1},
				end_color = {1,1,1},
				count = 8, --default 3
				size = .01,
				size_speed=0,
				gravity = {x = 0,y = 0,z = -3},
				rotation = {x = 0,y = 0,z = 15},
				lifetime=.75,
				frames=1,
				blend_type = 0,
				bouncyness = .5,
				tid = System:LoadTexture("textures\\Sprites\\stone1.dds"),
				},
				{--HitStonesLight
				focus = 1,
				speed = 2,
				start_color = {1,1,1},
				end_color = {1,1,1},
				count = 6, --default 2
				size = .01,
				size_speed=0,
				gravity = {x = 0,y = 0,z = -3},
				rotation = {x = 0,y = 0,z = 50},
				lifetime=.750,
				frames=1,
				blend_type = 0,
				bouncyness = .5,
				tid = System:LoadTexture("textures\\Sprites\\stone2.dds"),
				},				
			{--hitsmoke
 				focus = 0,
				start_color = {.89,.69,.4},
				end_color = {1,1,1},
				speed = .1,
				count = 5, --default 3
				size = .01,
				size_speed=.01,
				gravity = {x = 0,y = 0,z = .1},
				rotation = {x = 0,y = 0,z = 2},
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
			--sound,volume,{min,max}
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