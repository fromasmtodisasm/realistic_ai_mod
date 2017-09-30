Script:LoadScript("scripts/materials/commoneffects.lua")
	
Materials["mat_light_holes"] = {
	type="light_holes",
-------------------------------------	
	projectile_hit = CommonEffects.common_projectile_hit,
	-- mg_hit = CommonEffects.common_mg_hit,
	mortar_hit = CommonEffects.common_mortar_hit,
	smokegrenade_hit = CommonEffects.common_smokegrenade_hit,
	flashgrenade_hit = CommonEffects.common_flashgrenade_hit,
	grenade_hit = CommonEffects.common_grenade_hit,

	bullet_hit = {
		-- sounds = {
			-- {"Sounds/BulletHits/bsand1.wav",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/bsand2.wav",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/bsand3.wav",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/bsand4.wav",SOUND_UNSCALABLE,255,3,101},
		-- },
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
			object = System:LoadObject("Objects/Indoor/lights/decal/ray.cgf"),
			texture = System:LoadTexture("Textures/Decal/lighthole.dds"),
			lifetime = 1000,
			scale = .1,
			},
		particles = 
			{
				{--HotSpot
				focus = 90,
				speed = 0,
				count = 2,
				size = .02,
				size_speed=.01,
				gravity={x=0,y=0,z=0},
				lifetime=.2,
				tid = System:LoadTexture("Textures/Decal/Spark.dds"),
				frames=0,
				blend_type = 1,
				draw_last = 1,
				},
			
			},

		},
-------------------------------------
	player_land = {
		sounds = {
			--sound,volume,{min,max}
			--NOTE volume and min max are optional
			 {"sounds/doors/dooropen.wav",SOUND_UNSCALABLE,180,5,20},
			 {"sounds/doors/dooropen.wav",SOUND_UNSCALABLE,180,5,20},
			
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