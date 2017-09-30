Script:LoadScript("scripts/default/entities/weapons/BaseProjectile.lua")
projectileDefinitionSP = {
	Param = {
		mass = 1,
		size = .0556,
		heading = {},
		flags=1,
		initial_velocity = 350,
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

	ExplosionParams = {
		shooter = nil,
		weapon = nil,
	},

	-- EngineSound = {
		-- name = "Sounds/Weapons/RL/rocketloop3.wav",
		-- minDist = 5,
		-- maxDist = 100000,
	--},

	dynamic_light = .2,
	lifetime = 10000,
	projectileObject = "Objects/Weapons/trail.cgf", -- Скорость трассеров снижать.
}

Bullet = CreateProjectile(projectileDefinitionSP)