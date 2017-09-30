Script:LoadScript("scripts/materials/commoneffects.lua")

Materials["mat_sand_wet"] = {
	type="sand_wet",
-------------------------------------
	PhysicsSounds=PhysicsSoundsTable.Soft,
-------------------------------------
	bullet_drop_single = CommonEffects.common_bullet_drop_single_ashphalt,
	bullet_drop_rapid = CommonEffects.common_bullet_drop_rapid_ashphalt,
-------------------------------------
	bullet_hit = {
		sounds = { -- Типа мокрый.
			{"Sounds/BulletHits/Dirt_sand/dirt_01.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/dirt_02.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/dirt_03.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/dirt_04.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/dirt_05.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/dirt_06.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/dirt_07.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/dirt_08.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/dirt_09.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/dirt_10.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/dirt_11.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/dirt_12.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/dirt_13.mp3",SOUND_UNSCALABLE,255,3,101},
		},
		decal = {
			texture = System:LoadTexture("Textures/Decal/sand.dds"),
			scale = .04,
		},
		particleEffects = {
			name = "bullet.hit_sand.a",
		},
	},

	pancor_bullet_hit = {
		sounds = {
			{"Sounds/BulletHits/Dirt_sand/dirt_01.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/dirt_02.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/dirt_03.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/dirt_04.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/dirt_05.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/dirt_06.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/dirt_07.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/dirt_08.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/dirt_09.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/dirt_10.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/dirt_11.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/dirt_12.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Dirt_sand/dirt_13.mp3",SOUND_UNSCALABLE,255,3,101},
		},
		decal = {
			texture = System:LoadTexture("Textures/Decal/sand.dds"),
			scale = .03,
			},

		particleEffects = {
			name = "bullet.hit_sand_pancor.a",


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
			{"Sounds/BulletHits/Stone/stone_sand1.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_sand2.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_sand3.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_sand4.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_sand5.mp3",SOUND_UNSCALABLE,255,2,100},
		},
	},
	melee_slash = {
		sounds = {
			{"Sounds/Weapons/machete/machetesand4.wav",SOUND_UNSCALABLE,185,5,30},
			--{"Sounds/Weapons/machete/machetesand2.wav",SOUND_UNSCALABLE,255,5,30},
			--{"Sounds/Weapons/machete/machetesand3.wav",SOUND_UNSCALABLE,255,5,30},
		},
		particles =  CommonEffects.common_machete_hit_canvas_part.particles,

	},
-------------------------------------
	player_walk = {
		sounds = {
			{"sounds/player/footsteps/sand_wet/step1.wav",SOUND_UNSCALABLE,140,10,60},
			{"sounds/player/footsteps/sand_wet/step2.wav",SOUND_UNSCALABLE,140,10,60},
			{"sounds/player/footsteps/sand_wet/step3.wav",SOUND_UNSCALABLE,140,10,60},
			{"sounds/player/footsteps/sand_wet/step4.wav",SOUND_UNSCALABLE,140,10,60},
		},
	},
	player_run = {
		sounds = {
			{"sounds/player/footsteps/sand_wet/step1.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/sand_wet/step2.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/sand_wet/step3.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/sand_wet/step4.wav",SOUND_UNSCALABLE,200,10,60},
		},
	},
	player_crouch = {
		sounds = {
			{"sounds/player/footsteps/sand_wet/step1.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/sand_wet/step2.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/sand_wet/step3.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/sand_wet/step4.wav",SOUND_UNSCALABLE,120,10,60},
		},
	},
	player_prone = {
		sounds = {
			{"sounds/player/footsteps/sand_wet/step1.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/sand_wet/step2.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/sand_wet/step3.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/sand_wet/step4.wav",SOUND_UNSCALABLE,120,10,60},
		},
	},
	player_walk_inwater = CommonEffects.player_walk_inwater,

	player_drop = {
		sounds = {
			{"sounds/player/bodyfalls/bodyfalldirt1.wav",SOUND_UNSCALABLE,210,10,150},
			{"sounds/player/bodyfalls/bodyfalldirt2.wav",SOUND_UNSCALABLE,210,10,150},
			{"sounds/player/bodyfalls/bodyfalldirt3.wav",SOUND_UNSCALABLE,210,10,150},
		},

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
		friction = .5,
		bouncyness= -2, --default 0
	},

	AI = {
		fImpactRadius = 5,
	},

}