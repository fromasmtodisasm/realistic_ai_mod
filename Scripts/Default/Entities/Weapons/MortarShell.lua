Script:LoadScript("scripts/default/entities/weapons/BaseProjectile.lua");

projectileDefinition = {
	Param = {
		mass = 1,
		size = 0.15,
		heading = {},
		flags=1,
		initial_velocity = 140,
		k_air_resistance = 0,
		acc_thrust = 0,
		acc_lift = 0,
		surface_idx = -1,
		gravity = {x=0, y=0, z=4*-9.8 },
		collider_to_ignore = nil,
		AI_Type = AIOBJECT_ATTRIBUTE,
	},

	ExplosionParams = {
		pos = {},
		damage = 1000,
		rmin = 4.5,
		rmax = 4.5, -- default = 10.5 
		radius = 4.5, -- default = 8
		DeafnessRadius = 10.5,
		DeafnessTime = 12.0,
		impulsive_pressure = 1000, -- default 5
		shooter = nil,
		weapon = nil,
		explosion = 1,
		rmin_occlusion=0.2,
		occlusion_res=32,
		inflate=2,
	},
	
	Smoke = {
		focus = 5,
		speed = 0.3,
		rotation = { X=0,Y=0,Z=2},
		count = 1,
		size = 0.2, size_speed=2,
		lifetime=2.0,
		frames=1,
		tid = System:LoadTexture("textures/dust_smoke2.DDS"),
	},
	
	EngineSound = {
		name = "Sounds/Weapons/RL/grenadewind3.wav",
		minDist = 5,
		maxDist = 100000,
	},
	
	explodeOnContact = 1,
	useAIProjectileShoot = 1,
}

MortarShell = CreateProjectile(projectileDefinition);