Script:LoadScript("scripts/default/entities/weapons/BaseProjectile.lua")

projectileDefinition = {

	LaunchHelper =  "spitfire_RL",

	Param = {
		mass = 1,
		size = .15,
		heading = {},
		flags=1,
		initial_velocity = 90,
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

	ExplosionParams = {
		pos = {},
		damage = 1150,
		rmin = 12,
		rmax = 24,
		radius = 22,
		DeafnessRadius = 34,
		DeafnessTime = 35,
		impulsive_pressure = 2000,
		shooter = nil,
		weapon = nil,
		explosion = 1,
		rmin_occlusion = .2,
		occlusion_res = 32,
		occlusion_inflate = 2,
	},

	Smoke = {
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

	mark_terrain = 1,
	deform_terrain = 1,
	explodeOnContact = 1,
	dynamic_light = 7,
}

VehicleRocket = CreateProjectile(projectileDefinition)