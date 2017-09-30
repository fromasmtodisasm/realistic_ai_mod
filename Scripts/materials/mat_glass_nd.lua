Script:LoadScript("scripts/materials/commoneffects.lua")
Materials["mat_glass_nd"] = {
	type="glass_nd",

-------------------------------------	
	PhysicsSounds=PhysicsSoundsTable.Hard,
-------------------------------------
	bullet_hit = {
		sounds = {
			{"Sounds/BulletHits/bglass1.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/bglass2.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/bglass3.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/bglass4.wav",SOUND_UNSCALABLE,255,3,101},
			
			
		},
		particleEffects = {
			name = "bullet.hit_glass.a",
		},
	},
	pancor_bullet_hit = {
		sounds = {
			{"Sounds/BulletHits/bglass1.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/bglass2.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/bglass3.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/bglass4.wav",SOUND_UNSCALABLE,255,3,101},
			
			
		},
		particleEffects = {
			name = "bullet.hit_glass.a",
		},

	},


	gameplay_physic = {
		piercing_resistence = 0, -- 15 Кажется, это стёкла в бункере.
		friction = .6,
		bouncyness= .3, --default 0
	}		,

	projectile_hit = CommonEffects.common_projectile_hit,
	mg_hit = {
		sounds = {
			{"Sounds/BulletHits/MiniGun/minigun_glass_01.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/MiniGun/minigun_glass_02.mp3",SOUND_UNSCALABLE,255,2,100},
		},
		particleEffects = {
			name = "bullet.hit_glass.a",
		},
	},
	mortar_hit = CommonEffects.common_mortar_hit,
	smokegrenade_hit = CommonEffects.common_smokegrenade_hit,
	flashgrenade_hit = CommonEffects.common_flashgrenade_hit,
	grenade_hit = CommonEffects.common_grenade_hit,

	melee_slash = {
		sounds = {
			{"Sounds/BulletHits/bglass4.wav",SOUND_UNSCALABLE,200,5,60,{fRadius=10,fInterest=1,fThreat=0,},},
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