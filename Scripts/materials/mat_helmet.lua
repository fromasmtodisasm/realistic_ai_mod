Script:LoadScript("scripts/materials/commoneffects.lua")
Materials["mat_helmet"] = {
	type="helmet",
-------------------------------------
	PhysicsSounds=PhysicsSoundsTable.Hard,
-------------------------------------
	projectile_hit = CommonEffects.common_projectile_hit,
	mg_hit = {
		sounds = {
			{"Sounds/BulletHits/MiniGun/minigun_metal_01.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/MiniGun/minigun_metal_02.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/MiniGun/minigun_metal_03.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/MiniGun/minigun_metal_04.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/MiniGun/minigun_metal_05.mp3",SOUND_UNSCALABLE,255,3,101},
		},
		particleEffects = {
			name = "bullet.hit_metal.a",
		},
	},
	mortar_hit = CommonEffects.common_mortar_hit,
	smokegrenade_hit = CommonEffects.common_smokegrenade_hit,
	flashgrenade_hit = CommonEffects.common_flashgrenade_hit,
	grenade_hit = CommonEffects.common_grenade_hit,

	bullet_hit = {
		sounds = {
			{"Sounds/BulletHits/bpipe1.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/bpipe2.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/bpipe3.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/bpipe4.wav",SOUND_UNSCALABLE,255,3,101},
		},
		particleEffects = {
			name = "bullet.hit_metal.a",
		},
	},
	pancor_bullet_hit = {
		sounds = {
			{"Sounds/BulletHits/bpipe1.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/bpipe2.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/bpipe3.wav",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/bpipe4.wav",SOUND_UNSCALABLE,255,3,101},
		},
		particleEffects = {
			name = "bullet.hit_metal_pancor.a",
		},

	},
	melee_slash = {
		sounds = {
			{"Sounds/Weapons/machete/macheteplate2.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
			{"Sounds/Weapons/machete/macheteplate3.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
			{"Sounds/Weapons/machete/macheteplate4.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
			{"Sounds/Weapons/machete/macheteplate5.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
			},
		particles = CommonEffects.common_machete_hit_particles.particles,
	},
	gameplay_physic = {
		piercing_resistence = 15,
		friction = .75,
		bouncyness= .4, --default 0
	},


	AI = {
		fImpactRadius = 5,
	},

}