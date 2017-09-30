Script:LoadScript("scripts/materials/commoneffects.lua");
Materials["mat_glass_window"] = {
	type="glass_window",
-------------------------------------	
	PhysicsSounds=PhysicsSoundsTable.Hard,
-------------------------------------
	bullet_hit = {
		sounds = {
			{"Sounds/Bullethits/bglass1.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/bglass2.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/bglass3.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/bglass4.wav",SOUND_UNSCALABLE,200,5,60},
			
			
		},
		decal = { 
			texture = System:LoadTexture("Textures/Decal/glass.dds"),
			scale = 0.25,
		},
		particleEffects = {
			name = "bullet.hit_glass.a",
		},
	},

	pancor_bullet_hit = {
		sounds = {
			{"Sounds/Bullethits/bglass1.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/bglass2.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/bglass3.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/bglass4.wav",SOUND_UNSCALABLE,200,5,60},
			
			
		},
		decal = { 
			texture = System:LoadTexture("Textures/Decal/glass.dds"),
			scale = 0.25,
		},
		particleEffects = {
			name = "bullet.hit_glass.a",
		},
	},
	gameplay_physic = {
		piercing_resistence = 0,
		friction = 0.6,
		bouncyness= 0.3, --default 0
	}		,

	projectile_hit = CommonEffects.common_projectile_hit,
	mortar_hit = CommonEffects.common_mortar_hit,
	smokegrenade_hit = CommonEffects.common_smokegrenade_hit,
	flashgrenade_hit = CommonEffects.common_flashgrenade_hit,
	grenade_hit = CommonEffects.common_grenade_hit,

	melee_slash = {
		sounds = {
			{"Sounds/Bullethits/bglass4.wav",SOUND_UNSCALABLE,200,5,60,{fRadius=10,fInterest=1,fThreat=0,},},
		},

		particleEffects = {
			name = "bullet.hit_glass.a",
		},
	},
	player_walk = {
		sounds = {
			{"sounds/player/footsteps/sand_dry/step1.wav",SOUND_UNSCALABLE,140,10,60},
			{"sounds/player/footsteps/sand_dry/step2.wav",SOUND_UNSCALABLE,140,10,60},
			{"sounds/player/footsteps/sand_dry/step3.wav",SOUND_UNSCALABLE,140,10,60},
			{"sounds/player/footsteps/sand_dry/step4.wav",SOUND_UNSCALABLE,140,10,60},
		},
	},
	player_run = {
		sounds = {
			{"sounds/player/footsteps/sand_dry/step1.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/sand_dry/step2.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/sand_dry/step3.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/sand_dry/step4.wav",SOUND_UNSCALABLE,200,10,60},
		},
	},
	player_crouch = {
		sounds = {
			{"sounds/player/footsteps/sand_dry/step1.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/sand_dry/step2.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/sand_dry/step3.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/sand_dry/step4.wav",SOUND_UNSCALABLE,120,10,60},
		},
	},
	player_prone = {
		sounds = {
			{"sounds/player/footsteps/sand_dry/step1.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/sand_dry/step2.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/sand_dry/step3.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/sand_dry/step4.wav",SOUND_UNSCALABLE,120,10,60},
		},
	},
	player_walk_inwater = CommonEffects.player_walk_inwater,
	AI = {
		fImpactRadius = 8,
	},
	
	object_impact = {
		sounds = {
			{"Sounds/ObjectImpact/metalhit.wav",SOUND_UNSCALABLE,100,4,100},
		},
	}
}