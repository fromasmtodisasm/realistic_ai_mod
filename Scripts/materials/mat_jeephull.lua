Script:LoadScript("scripts/materials/commoneffects.lua");
--This material is for the collision object (hullproxy2), therefore the friction is set to zero.
Materials["mat_jeephull"] = {
	type="jeephull",
-------------------------------------
	gameplay_physic = {
		piercing_resistence = 15,
		bouncyness=0, -- default 0
		friction = 0,
	},

	melee_slash = {
		sounds = {
			{"sounds/weapons/machete/machetepipe1.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
			{"sounds/weapons/machete/machetepipe2.wav",SOUND_UNSCALABLE,185,5,30,{fRadius=10,fInterest=1,fThreat=0,},},
			 },
		particles = CommonEffects.common_machete_hit_particles.particles,

	},

	projectile_hit = CommonEffects.common_projectile_hit,
	mortar_hit = CommonEffects.common_mortar_hit,
	smokegrenade_hit = CommonEffects.common_smokegrenade_hit,
	flashgrenade_hit = CommonEffects.common_flashgrenade_hit,
	grenade_hit = CommonEffects.common_grenade_hit,
	
	AI = {
		fImpactRadius = 5,
	},

}