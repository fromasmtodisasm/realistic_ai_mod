Script:LoadScript("scripts/materials/commoneffects.lua");

Materials["mat_swamp"] = {
	type="swamp",
-------------------------------------
	PhysicsSounds=PhysicsSoundsTable.Soft,
-------------------------------------	
	bullet_hit = {
		sounds = {
			{"Sounds/bullethits/bgravel1.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/bgravel2.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/bgravel3.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/bgravel4.wav",SOUND_UNSCALABLE,200,5,60},
			
		},
		
		decal = { 
			texture = System:LoadTexture("Textures/Decal/ground.dds"),
			scale = 0.03,
		},

		particles = {
			{ --HitSmoke 
				focus = 1.5,
				color = {0.29,0.19,0.0},
				speed = 0.75,
				count = 4, --default 2
				size = 0.1, 
				size_speed=0.15,
				gravity=-1,
				lifetime=0.5,
				tid = System:LoadTexture("textures\\cloud1.dds"),
				frames=0,
				color_based_blending = 3
			},
		},

	},

	pancor_bullet_hit = {
		sounds = {
			{"Sounds/bullethits/bgravel1.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/bgravel2.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/bgravel3.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/bgravel4.wav",SOUND_UNSCALABLE,200,5,60},
			
		},
		
		decal = { 
			texture = System:LoadTexture("Textures/Decal/ground.dds"),
			scale = 0.03,
		},

		particles = {
			{ --HitSmoke 
				focus = 1.5,
				color = {0.29,0.19,0.0},
				speed = 0.75,
				count = 4, --default 2
				size = 0.1, 
				size_speed=0.15,
				gravity=-1,
				lifetime=0.5,
				tid = System:LoadTexture("textures\\cloud1.dds"),
				frames=0,
				color_based_blending = 3
			},
		},

	},

	projectile_hit = CommonEffects.common_projectile_hit,
	mortar_hit = CommonEffects.common_mortar_hit,
	smokegrenade_hit = CommonEffects.common_smokegrenade_hit,
	flashgrenade_hit = CommonEffects.common_flashgrenade_hit,
	grenade_hit = CommonEffects.common_grenade_hit,
	melee_slash = {
		sounds = {
			{"sounds/weapons/machete/machetesand1.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/weapons/machete/machetesand2.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/weapons/machete/machetesand3.wav",SOUND_UNSCALABLE,185,5,30},
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