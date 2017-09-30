Script:LoadScript("scripts/materials/commoneffects.lua");

Materials["mat_obstruct"] = {
	type="obstruct",
	bullet_hit = {
		},

	pancor_bullet_hit = {
		},

	melee_slash = {

	},

		
	particles = {
	},

	--projectile_hit = CommonEffects.common_projectile_hit,
	--mortar_hit = CommonEffects.common_mortar_hit,
	--smokegrenade_hit = CommonEffects.common_smokegrenade_hit,
	--flashgrenade_hit = CommonEffects.common_flashgrenade_hit,
	--grenade_hit = CommonEffects.common_grenade_hit,

-------------------------------------
	gameplay_physic = {
		piercing_resistence = 2,
		friction = 1.5,
	},

	AI = {
		fImpactRadius = 5,
	},
			
}