Script:LoadScript("scripts/materials/commoneffects.lua");
--#Script:ReloadScript("scripts/materials/mat_leaves.lua")
Materials["mat_leaves"] = {

	type = "mat_leaves",

-------------------------------------	
	PhysicsSounds=PhysicsSoundsTable.Soft,
-------------------------------------
	bullet_hit = {
		sounds = {
			{"Sounds/Bullethits/bleaves1.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/bleaves2.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/bleaves3.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/bleaves4.wav",SOUND_UNSCALABLE,200,5,60},
			
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
		particleEffects = {
			name = "bullet.hit_leaf.a",
		},
		
	},


	--projectile_hit = CommonEffects.common_projectile_hit,
	mortar_hit = CommonEffects.common_mortar_hit,
	smokegrenade_hit = CommonEffects.common_smokegrenade_hit,
	flashgrenade_hit = CommonEffects.common_flashgrenade_hit,
	grenade_hit = CommonEffects.common_grenade_hit,
	melee_slash = {
		sounds = {
			{"Sounds/Bullethits/bleaves1.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/bleaves2.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/bleaves3.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/bleaves4.wav",SOUND_UNSCALABLE,200,5,60},
			
		},
		particleEffects = {
			name = "bullet.hit_leaf.a",
		},
	},
-------------------------------------
	player_walk_by = {
		sounds = {
			{"sounds/player/footsteps/leaves/step1.wav",SOUND_UNSCALABLE,140,10,60},
			{"sounds/player/footsteps/leaves/step2.wav",SOUND_UNSCALABLE,140,10,60},
			{"sounds/player/footsteps/leaves/step3.wav",SOUND_UNSCALABLE,140,10,60},
			{"sounds/player/footsteps/leaves/step4.wav",SOUND_UNSCALABLE,140,10,60},
		},
	},

	player_walk = {
		sounds = {
			{"sounds/player/footsteps/leaves/step1.wav",SOUND_UNSCALABLE,140,10,60},
			{"sounds/player/footsteps/leaves/step2.wav",SOUND_UNSCALABLE,140,10,60},
			{"sounds/player/footsteps/leaves/step3.wav",SOUND_UNSCALABLE,140,10,60},
			{"sounds/player/footsteps/leaves/step4.wav",SOUND_UNSCALABLE,140,10,60},
		},
	},
	player_run = {
		sounds = {
			{"sounds/player/footsteps/leaves/step1.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/leaves/step2.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/leaves/step3.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/leaves/step4.wav",SOUND_UNSCALABLE,200,10,60},
		},
	},
	player_crouch = {
		sounds = {
			{"sounds/player/footsteps/leaves/step1.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/leaves/step2.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/leaves/step3.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/leaves/step4.wav",SOUND_UNSCALABLE,120,10,60},
		},
	},
	player_prone = {
		sounds = {
			{"sounds/player/footsteps/leaves/step1.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/leaves/step2.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/leaves/step3.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/leaves/step4.wav",SOUND_UNSCALABLE,120,10,60},
		},
	},
	player_walk_inwater = CommonEffects.player_walk_inwater,
	
	player_drop = {
		sounds = {
			{"sounds/player/bodyfalls/bodyfallgrass1.wav",SOUND_UNSCALABLE,210,10,150},
			{"sounds/player/bodyfalls/bodyfallgrass2.wav",SOUND_UNSCALABLE,210,10,150},
		},

	},
	gameplay_physic = {
		piercing_resistence = 2,
		friction = 0.5,
		bouncyness= 0, --default 0
		no_collide=1,
	},

	AI = {
		fImpactRadius = 5,
	},
			
}