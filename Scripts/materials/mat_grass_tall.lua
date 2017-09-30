
Script:LoadScript("scripts/materials/commoneffects.lua");

Materials["mat_grass_tall"] = {
	type="grass_tall",
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
			{"Sounds/Bullethits/bleaves1.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/bleaves2.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/bleaves3.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/bleaves4.wav",SOUND_UNSCALABLE,200,5,60},
			
			
		},
		
		decal = { 
			texture = System:LoadTexture("Textures/Decal/ground.dds"),
			scale = 0.03,
		},

		
		particleEffects = {
			name = "bullet.hit_leaf.a",
		},
		
	},

	pancor_bullet_hit = {
		sounds = {
			{"Sounds/Bullethits/bleaves1.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/bleaves2.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/bleaves3.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/bleaves4.wav",SOUND_UNSCALABLE,200,5,60},
			
			
		},
		
		decal = { 
			texture = System:LoadTexture("Textures/Decal/ground.dds"),
			scale = 0.03,
		},

		
		particleEffects = {
			name = "bullet.hit_leaf.a",
		},
		
	},

	mortar_hit = CommonEffects.common_mortar_hit,
	smokegrenade_hit = CommonEffects.common_smokegrenade_hit,
	flashgrenade_hit = CommonEffects.common_flashgrenade_hit,
	melee_slash = {
		sounds = {
			--{"sounds/player/footsteps/metal/step1.wav",SOUND_UNSCALABLE,185,5,30},
			--{"sounds/player/footsteps/metal/step2.wav",SOUND_UNSCALABLE,185,5,30},
			--{"sounds/player/footsteps/metal/step3.wav",SOUND_UNSCALABLE,185,5,30},
			--{"sounds/player/footsteps/metal/step4.wav",SOUND_UNSCALABLE,185,5,30},
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
	
	player_drop = {
		sounds = {
			{"sounds/player/bodyfalls/bodyfallgrass1.wav",SOUND_UNSCALABLE,210,10,150},
			{"sounds/player/bodyfalls/bodyfallgrass2.wav",SOUND_UNSCALABLE,210,10,150},
		},

	},
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
		piercing_resistence = 2,
		friction = 0.6,
		bouncyness= -2, -- default 0
		no_collide=1,
	},

	AI = {
		fImpactRadius = 5,
	},
			
}