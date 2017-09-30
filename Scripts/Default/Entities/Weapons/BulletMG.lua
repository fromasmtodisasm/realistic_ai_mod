Script:LoadScript("scripts/default/entities/weapons/BaseProjectile.lua")
projectileDefinitionSP = {
	Param = {
		mass = 1,
		size = .0762,
		heading = {},
		flags=1,
		initial_velocity = 499,
		-- initial_velocity = 36, --  default 23
		k_air_resistance = 0,
		acc_thrust = 0,
		acc_lift = 0,
		surface_idx = -1,
		gravity = g_Vectors.v000,
		-- gravity = {x=0,y=0,z=-.1},
		collider_to_ignore = nil,
		-- AI_Type = AIOBJECT_ATTRIBUTE,
		-- AI_Type_ALTERNATE = AIAnchor.AIOBJECT_DAMAGEGRENADE,
	},

	-- ExplosionParams = {
		-- pos = {},
		-- damage = 70,
		-- rmin = 5, --Defines the minimum impulse pressure range -- 5
		-- rmax = 20, --Defines the maximum impulse pressure range -- 20
		-- radius = 7, --Damage radius where point 0 is max damage. Damage falls off at 1/distance^2 -- 16
		-- DeafnessRadius = 15,
		-- DeafnessTime = 30,
		-- impulsive_pressure = 50,
		-- shooter = nil,
		-- weapon = nil,
		-- explosion = 1,
		-- rmin_occlusion = .2,
		-- occlusion_res = 32,
		-- occlusion_inflate = 2,
		-- -- iImpactForceMulFinalTorso=300,
	--},
	
	ExplosionParams = {
		pos = {},
		damage = 30,
		rmin = 1, --Defines the minimum impulse pressure range -- 5
		rmax = 5, --Defines the maximum impulse pressure range -- 20
		radius = 1, --Damage radius where point 0 is max damage. Damage falls off at 1/distance^2 -- 16
		DeafnessRadius = 4,
		DeafnessTime = 3,
		impulsive_pressure = 10,
		shooter = nil,
		weapon = nil,
		explosion = 1,
		rmin_occlusion = .2,
		occlusion_res = 32,
		occlusion_inflate = 2,
		-- iImpactForceMulFinalTorso=300,
	},

	-- EngineSound = {
		-- name = "Sounds/Weapons/RL/rocketloop3.wav",
		-- minDist = 5,
		-- maxDist = 100000,
	--},
	
	MG_Explosive = 1,

	dynamic_light = .5,
	lifetime = 10000,
	projectileObject = "Objects/Weapons/trail_mounted.cgf",
}

BulletMG = CreateProjectile(projectileDefinitionSP)