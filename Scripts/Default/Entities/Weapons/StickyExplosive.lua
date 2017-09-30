projectileDefinition = {
	Param = {
		mass = .3,
		size = 0.2,
		heading = {},
		flags = 1,
		--initial_velocity = 75,
		initial_velocity = 8, --  default 23
		k_air_resistance = 0,
		acc_thrust = 0,
		acc_lift = 0,
		surface_idx = 1,
		gravity = {x=0, y=0, z=1.5*-9.8 },
		collider_to_ignore = nil,
	},
	
	ExplosionParams = {
		pos = {},
		damage = 5000,
		rmin = 2,
		rmax = 5, 
		radius = 5, 
		DeafnessRadius = 3.5,
		DeafnessTime = 6.0,
		impulsive_pressure = 400, -- default 5
		shooter = nil,
		weapon = nil,
		explosion = 1,
		rmin_occlusion=0.2,
		occlusion_res=32,
		occlusion_inflate=2,
	},
	
	lifetime = 10000,
	mark_terrain = 1,
	force_objtype = 2,
	projectileObject = "Objects/Pickups/explosive/explosive.cgf",
	projectileObjectScale = 1.0,
}

StickyExplosive = CreateProjectile(projectileDefinition);