Script:LoadScript("scripts/materials/commoneffects.lua")
Materials["mat_fish"] = {
	type="fish",
-------------------------------------	
	PhysicsSounds=PhysicsSoundsTable.Soft,
-------------------------------------
	bullet_hit = {
		sounds = {
			{"Sounds/BulletHits/pbullet1.wav",SOUND_UNSCALABLE,255,3,101},
		},
		
		particleEffects = {
			gore = 1,
			name = "bullet.hit_flesh.a",
		},

	},
	pancor_bullet_hit = {
		sounds = {
			{"Sounds/BulletHits/headbullet11.wav",SOUND_UNSCALABLE,255,2,100},
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
	mg_hit = {
		sounds = {
			{"Sounds/BulletHits/MiniGun/minigun_flesh_01.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/MiniGun/minigun_flesh_03.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/MiniGun/minigun_flesh_04.mp3",SOUND_UNSCALABLE,255,2,100},
		},
		decal = {
			gore = 1,	-- to be able to switch off gore -- to know what's allowed
			texture = System:LoadTexture("Languages/Textures/Decal/hole_blood.dds",0,1),
			scale = .06,
		},
		particleEffects = {
			gore = 1,	-- to be able to switch off gore -- to know what's allowed
			name = "bullet.hit_flesh.a",
		},
	},
	mortar_hit = CommonEffects.common_mortar_hit,
	smokegrenade_hit = CommonEffects.common_smokegrenade_hit,
	flashgrenade_hit = CommonEffects.common_flashgrenade_hit,
	grenade_hit = CommonEffects.common_grenade_hit,
-------------------------------------
	gameplay_physic = {
		piercing_resistence = 15,
		friction = .3,
		bouncyness= -2, -- default 0
	},

	AI = {
		fImpactRadius = 5,
	},


}