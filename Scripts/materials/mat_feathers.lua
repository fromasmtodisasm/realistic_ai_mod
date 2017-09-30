Script:LoadScript("scripts/materials/commoneffects.lua");
Materials["mat_feathers"] = {
	type="feathers",
-------------------------------------	
	PhysicsSounds=PhysicsSoundsTable.Soft,
-------------------------------------
	bullet_hit = {
		sounds = {
			{"Sounds/bullethits/pbullet1.wav",SOUND_UNSCALABLE,200,5,60},
		},
		particleEffects = {
			gore = 1,	-- to be able to switch off gore -- to know what's allowed
			name = "bullet.hit_flesh.feathers",
		},
	},

	pancor_bullet_hit = {
		sounds = {
			{"Sounds/bullethits/pbullet1.wav",SOUND_UNSCALABLE,200,5,60},
			   },
		particleEffects = {
			gore = 1,	-- to be able to switch off gore -- to know what's allowed
			name = "bullet.hit_flesh.feathers",
		},
	},

	melee_slash = {
		sounds = {
			{"Sounds/bullethits/pbullet1.wav",SOUND_UNSCALABLE,200,5,60},
		},
		particleEffects = {
			gore = 1,	-- to be able to switch off gore -- to know what's allowed
			name = "bullet.hit_flesh.feathers",
		},
	},


	projectile_hit = CommonEffects.common_projectile_hit,
	mortar_hit = CommonEffects.common_mortar_hit,
	smokegrenade_hit = CommonEffects.common_smokegrenade_hit,
	flashgrenade_hit = CommonEffects.common_flashgrenade_hit,
	grenade_hit = CommonEffects.common_grenade_hit,
	
-------------------------------------
	gameplay_physic = {
		piercing_resistence = 15,
		friction = 1.5,
	},

	AI = {
		fImpactRadius = 5,
	},


}