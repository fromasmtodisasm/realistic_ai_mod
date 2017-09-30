Script:LoadScript("scripts/default/entities/weapons/BaseProjectile.lua");

projectileDefinition = {

	LaunchHelper =  "spitfire_RL",

	Param = {
		mass = 1,
		size = 0.15,
		heading = {},
		flags=1,
		--initial_velocity = 75,
		initial_velocity = 50, --  default 23
		k_air_resistance = 0,
		acc_thrust = 0,
		acc_lift = 0,
		surface_idx = -1,
		gravity = g_Vectors.v000,
		collider_to_ignore = nil,
	},
	
	ExplosionParams = {
		pos = {},
		damage = 1050,
		rmin = 2.5,
		rmax = 8.5, -- default 10.5
		radius = 8.5, -- default 10
		DeafnessRadius = 8.5,
		DeafnessTime = 8.0,
		impulsive_pressure = 2000, -- default 5
		shooter = nil,
		weapon = nil,
		explosion = 1,
		rmin_occlusion=0.2,
		occlusion_res=32,
		occlusion_inflate=2,
	},
	
	Smoke = {
		focus = 0,
		gravity = {x = -5, y = 0.0, z = 2.50},
		rotation = {x = 0.0, y = 0.0, z = 2.0},
		speed = 0.2,
		count = 1,
		size = 0.15, 
		size_speed=0.4,
		lifetime=1.50,
		frames=1,
		color_based_blending = 3,
		tid = System:LoadTexture("textures/guncloud.dds"),
		turbulence_size = 2,
		turbulence_speed = 2.5,
	
	},
	
	EngineSound = {
		name = "Sounds/Weapons/RL/rocketloop3.wav",
		minDist = 5,
		maxDist = 750,
	},

	mark_terrain = 1,
	deform_terrain = 1,
	explodeOnContact = 1,
	dynamic_light = 7,
}

VehicleRocket = CreateProjectile(projectileDefinition);
