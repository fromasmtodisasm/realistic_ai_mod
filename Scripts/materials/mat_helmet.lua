Script:LoadScript("scripts/materials/commoneffects.lua");
Materials["mat_helmet"] = {
	type="helmet",
-------------------------------------	
	PhysicsSounds=PhysicsSoundsTable.Hard,
-------------------------------------
	projectile_hit = CommonEffects.common_projectile_hit,
	mortar_hit = CommonEffects.common_mortar_hit,
	smokegrenade_hit = CommonEffects.common_smokegrenade_hit,
	flashgrenade_hit = CommonEffects.common_flashgrenade_hit,
	grenade_hit = CommonEffects.common_grenade_hit,

	bullet_hit = {
		sounds = {
			{"Sounds/bullethits/bpipe1.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/bpipe2.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/bpipe3.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/bpipe4.wav",SOUND_UNSCALABLE,200,5,60},
			
		},
		particleEffects = {
			name = "bullet.hit_metal.a",
		},
	},
	pancor_bullet_hit = {
		sounds = {
			{"Sounds/bullethits/bpipe1.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/bpipe2.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/bpipe3.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/bullethits/bpipe4.wav",SOUND_UNSCALABLE,200,5,60},
			
		},
		particleEffects = {
			name = "bullet.hit_metal_pancor.a",
		},

	},
	melee_slash = {
		sounds = {
			{"sounds/weapons/machete/macheteplate2.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
			{"sounds/weapons/machete/macheteplate3.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
			{"sounds/weapons/machete/macheteplate4.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
			{"sounds/weapons/machete/macheteplate5.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
			 },
		particles = CommonEffects.common_machete_hit_particles.particles,
	},
	gameplay_physic = {
		piercing_resistence = 15,
		friction = 0.75,
		bouncyness= 0.4, --default 0
	},


	AI = {
		fImpactRadius = 5,
	},
			
}