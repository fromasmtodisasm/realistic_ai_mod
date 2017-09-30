Script:LoadScript("scripts/materials/commoneffects.lua");
Materials["mat_fish"] = {
	type="fish",
-------------------------------------	
	PhysicsSounds=PhysicsSoundsTable.Soft,
-------------------------------------
	bullet_hit = {
		sounds = {
			{"Sounds/bullethits/pbullet1.wav",SOUND_UNSCALABLE,200,5,60},
		},
		
		particleEffects = {
			gore = 1,
			name = "bullet.hit_flesh.a",
		},

	},
	pancor_bullet_hit = {
		sounds = {
			{"Sounds/bullethits/headbullet11.wav",SOUND_UNSCALABLE,220,10,80},
		},
		particleEffects = {
			gore = 1,
			name = "bullet.hit_flesh_pancor.a",
					},
	},
	melee_slash = {
		particleEffects = {
			gore = 1,
			name = "bullet.hit_flesh.a",
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
		friction = 0.3,
		bouncyness= -2, -- default 0
	},

	AI = {
		fImpactRadius = 5,
	},


}