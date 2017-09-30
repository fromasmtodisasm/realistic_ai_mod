Script:LoadScript("scripts/default/entities/weapons/BaseProjectile.lua")
projectileDefinitionSP = {
	Param = {
		mass = 1,
		size = .15,
		heading = {},
		flags=1,
		initial_velocity = 75,
		-- initial_velocity = 36, --  default 23
		k_air_resistance = 0,
		acc_thrust = 0,
		acc_lift = 0,
		surface_idx = -1,
		-- gravity = g_Vectors.v000,
		gravity = {x=0,y=0,z=-.1},
		collider_to_ignore = nil,
		AI_Type = AIOBJECT_ATTRIBUTE,
		AI_Type_ALTERNATE = AIAnchor.AIOBJECT_DAMAGEGRENADE,
	},

	ExplosionParams = {-- Придумать что-нибудь чтобы человеки так далеко не улетали...
		pos = {},
		damage = 800, -- 800
		rmin = 5, --Defines the minimum impulse pressure range -- 5
		rmax = 20, --Defines the maximum impulse pressure range -- 20
		radius = 20, --Damage radius where point 0 is max damage. Damage falls off at 1/distance^2 -- 16
		DeafnessRadius = 30,
		DeafnessTime = 30,
		impulsive_pressure = 2000,
		shooter = nil,
		weapon = nil,
		explosion = 1,
		rmin_occlusion = .2,
		occlusion_res = 32,
		occlusion_inflate = 2,
		-- iImpactForceMulFinalTorso=300,
	},

	SmokeEffect = "Smoke.Rocket.Trail",

	_Old_Smoke = {
		focus = 0,
		gravity = {x = -5,y = 0,z = 2.50},
		rotation = {x = 0,y = 0,z = 2},
		speed = .2,
		count = 1,
		size = .15,
		size_speed=.4,
		lifetime=1.50,
		frames=1,
		color_based_blending = 3,
		tid = System:LoadTexture("textures/guncloud.dds"),
		turbulence_size = 2,
		turbulence_speed = 2.5,
	},

	EngineSound = {
		name = "Sounds/Weapons/RL/rocket_engine_start_idle.mp3",
		minDist = 5,
		maxDist = 100,
	},

	-- SoundEvent = {-- Доработать.
		-- VolumeRadius = 50,
		-- fThreat = 0,
	--},

	deform_terrain = 1,
	mark_terrain = 1,
	explodeOnContact = 1,
	dynamic_light = 3,
	-- lifetime = 0,
}

-- projectileDefinitionMP = {
	-- Param = {
		-- mass = 1,
		-- size = .15,
		-- heading = {},
		-- flags=1,
		-- initial_velocity = 75,
		-- -- initial_velocity = 25, --  default 23
		-- k_air_resistance = 0,
		-- acc_thrust = 0,
		-- acc_lift = 0,
		-- surface_idx = -1,
		-- gravity = g_Vectors.v000,
		-- collider_to_ignore = nil,
		-- AI_Type = AIOBJECT_ATTRIBUTE,
		-- AI_Type_ALTERNATE = AIAnchor.AIOBJECT_DAMAGEGRENADE,
	-- },

	-- ExplosionParams = {
		-- pos = {},
		-- damage = 1000,
		-- rmin = 1, --Defines the minimum impulse pressure range
		-- rmax = 5, --Defines the maximum impulse pressure range
		-- radius = 5, --Damage radius where point 0 is max damage. Damage falls off at 1/distance^2
		-- DeafnessRadius = 13.5, -- 8.5
		-- DeafnessTime = 8,
		-- impulsive_pressure = 2000, -- default 5
		-- shooter = nil,
		-- weapon = nil,
		-- explosion = 1,
		-- rmin_occlusion=.2,
		-- occlusion_res=32,
		-- occlusion_inflate=2,
	-- },

	-- SmokeEffect = "Smoke.Rocket.Trail",

	-- _Old_Smoke = {
		-- focus = 0,
		-- gravity = {x = -5,y = 0,z = 2.50},
		-- rotation = {x = 0,y = 0,z = 2},
		-- speed = .2,
		-- count = 1,
		-- size = .15,
		-- size_speed=.4,
		-- lifetime=1.50,
		-- frames=1,
		-- color_based_blending = 3,
		-- tid = System:LoadTexture("textures/guncloud.dds"),
		-- turbulence_size = 2,
		-- turbulence_speed = 2.5,
	-- },

	-- EngineSound = {
		-- name = "Sounds/Weapons/RL/rocket_engine_start_idle.mp3",
		-- minDist = 2,
		-- maxDist = 100,
	-- },

	-- deform_terrain = 1,
	-- mark_terrain = 1,
	-- explodeOnContact = 1,
	-- dynamic_light = 3,
-- }

-- if (Game:IsMultiplayer()) then
	-- Rocket = CreateProjectile(projectileDefinitionMP)
-- else
	Rocket = CreateProjectile(projectileDefinitionSP)
-- end