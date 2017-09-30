Script:LoadScript("scripts/materials/commoneffects.lua")
Materials["mat_feathers"] = {
	type="feathers",
-------------------------------------	
	PhysicsSounds=PhysicsSoundsTable.Soft,
-------------------------------------
	bullet_hit = {
		sounds = {
			{"Sounds/BulletHits/pbullet1.wav",SOUND_UNSCALABLE,255,3,101},
		},
		particleEffects = {
			gore = 1,	-- to be able to switch off gore -- to know what's allowed
			name = "bullet.hit_flesh.feathers",
		},
	},

	pancor_bullet_hit = {
		sounds = {
			{"Sounds/BulletHits/pbullet1.wav",SOUND_UNSCALABLE,255,3,101},
			},
		particleEffects = {
			gore = 1,	-- to be able to switch off gore -- to know what's allowed
			name = "bullet.hit_flesh.feathers",
		},
	},

	melee_slash = {
		sounds = {
			{"Sounds/BulletHits/pbullet1.wav",SOUND_UNSCALABLE,255,3,101},
		},
		particleEffects = {
			gore = 1,	-- to be able to switch off gore -- to know what's allowed
			name = "bullet.hit_flesh.feathers",
		},
	},


	projectile_hit = CommonEffects.common_projectile_hit,
	mg_hit = {
		sounds = {
			{"Sounds/BulletHits/MiniGun/minigun_flesh_01.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/MiniGun/minigun_flesh_03.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/MiniGun/minigun_flesh_04.mp3",SOUND_UNSCALABLE,255,2,100},
		},
		particleEffects = {
			gore = 1,	-- to be able to switch off gore -- to know what's allowed
			name = "bullet.hit_flesh.feathers",
		},
	},
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