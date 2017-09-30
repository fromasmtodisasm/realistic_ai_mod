Script:LoadScript("scripts/materials/commoneffects.lua")

Materials["mat_swamp"] = {
	type="swamp",
-------------------------------------
	PhysicsSounds=PhysicsSoundsTable.Soft,
-------------------------------------	
	bullet_hit = {
		sounds = {
			{"Sounds/BulletHits/Mud/impact_mud_1.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Mud/impact_mud_2.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Mud/impact_mud_3.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Mud/impact_mud_4.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Mud/impact_mud_5.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Mud/impact_mud_6.mp3",SOUND_UNSCALABLE,255,3,101},
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
				tid = System:LoadTexture("textures\\cloud1.dds"),
				frames=0,
				color_based_blending = 3
			},
		},

	},

	pancor_bullet_hit = {
		sounds = {
			{"Sounds/BulletHits/Mud/impact_mud_1.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Mud/impact_mud_2.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Mud/impact_mud_3.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Mud/impact_mud_4.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Mud/impact_mud_5.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Mud/impact_mud_6.mp3",SOUND_UNSCALABLE,255,3,101},
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
				tid = System:LoadTexture("textures\\cloud1.dds"),
				frames=0,
				color_based_blending = 3
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
			{"Sounds/Weapons/machete/machetesand1.wav",SOUND_UNSCALABLE,185,5,30},
			{"Sounds/Weapons/machete/machetesand2.wav",SOUND_UNSCALABLE,185,5,30},
			{"Sounds/Weapons/machete/machetesand3.wav",SOUND_UNSCALABLE,185,5,30},
		},
	particles =  CommonEffects.common_machete_hit_canvas_part.particles,

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
	gameplay_physic = {
		piercing_resistence = 15,
		friction = 1.5,
	},

	AI = {
		fImpactRadius = 5,
	},
			
}