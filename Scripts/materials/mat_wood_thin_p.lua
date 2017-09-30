Script:LoadScript("scripts/materials/commoneffects.lua");



Materials["mat_wood_thin_p"] = {

	type="mat_wood_thin_p",

-------------------------------------
	PhysicsSounds=PhysicsSoundsTable.Hard,
-------------------------------------	
	bullet_drop_single = CommonEffects.common_bullet_drop_single_wood,
	bullet_drop_rapid = CommonEffects.common_bullet_drop_rapid_wood,
-------------------------------------	
	bullet_hit = {
		sounds = {
			{"Sounds/Bullethits/Wthin1.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/Wthin2.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/Wthin3.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/Wthin4.wav",SOUND_UNSCALABLE,200,5,60},
		},
		
		decal = { 
			texture = System:LoadTexture("Textures/Decal/wood.dds"),
			scale = 0.04,
		},
		particleEffects = {
			name = "bullet.hit_wood.a",
				}, 
	},

	pancor_bullet_hit = {
		sounds = {
			{"Sounds/Bullethits/Wthin1.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/Wthin2.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/Wthin3.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/Wthin4.wav",SOUND_UNSCALABLE,200,5,60},
				},
		
		decal = { 
			texture = System:LoadTexture("Textures/Decal/wood.dds"),
			scale = 0.04,
				},
		particleEffects = {
			name = "bullet.hit_wood_pancor.a",
				}, 
	},


	flashgrenade_hit = 		
	{
	        particles = 
		{
			{ 
				focus = 0.5,
				color = {1,1,1},
				speed = 8.0, --default 5.0
				count = 120, --default 75
				size = 0.1, 
				size_speed=0,
				gravity = {x = 0.0, y = 0.0, z = -8},
				rotation = {x = 0.0, y = 0.0, z = 20},
				lifetime=2.00,
				tid = System:LoadTexture("textures\\sprites\\chip.dds"),
				tail_length = 0.0,
				frames=1,

			},
		},
	},
	projectile_hit = 	{
	
		particleEffects = {
			name = "explosions.rocket.a",
		},	
	
	        particles = 
		{
			{ 
				focus = 0.5,
				color = {1,1,1},
				speed = 8.0, --default 5.0
				count = 120, --default 75
				size = 0.1, 
				size_speed=0,
				gravity = {x = 0.0, y = 0.0, z = -8},
				rotation = {x = 0.0, y = 0.0, z = 20},
				lifetime=2.00,
				tid = System:LoadTexture("textures\\sprites\\chip.dds"),
				tail_length = 0.0,
				frames=1,

			},
		},
	},
	mortar_hit = CommonEffects.common_mortar_hit,
	smokegrenade_hit = CommonEffects.common_smokegrenade_hit,
	grenade_hit = CommonEffects.common_grenade_hit,
	melee_slash = {
		sounds = {
			{"sounds/weapons/machete/machetewood1.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
			{"sounds/weapons/machete/machetewood2.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
			{"sounds/weapons/machete/machetewood3.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
		},
		particles =  CommonEffects.common_machete_hit_wood_part.particles,
	},
-------------------------------------
	player_walk = CommonEffects.player_wood_walk,
	player_run = CommonEffects.player_wood_run,
	player_crouch = CommonEffects.player_wood_crouch,
	player_prone = CommonEffects.player_wood_prone,
	player_walk_inwater = CommonEffects.player_walk_inwater,
	
	player_drop = {
		sounds = {
			{"sounds/player/bodyfalls/bodyfallwood1.wav",SOUND_UNSCALABLE,210,10,150},
		},

	},
	gameplay_physic = {
		piercing_resistence = 4,
		friction = 0.5,
		bouncyness= 0.05, --default 0
	},

	AI = {
		fImpactRadius = 5,
	},
		
}