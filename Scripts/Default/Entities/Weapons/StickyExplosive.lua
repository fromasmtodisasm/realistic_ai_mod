projectileDefinition = {
	fDeformRadius = 8, 
	Param = {
		mass = .3,
		size = .2,
		heading = {},
		flags = 1,
		--initial_velocity = 75,
		initial_velocity = 8, --  default 23
		k_air_resistance = 0,
		acc_thrust = 0,
		acc_lift = 0,
		surface_idx = 1,
		gravity = {x=0,y=0,z=1.5*-9.8},
		collider_to_ignore = nil,
	},
	
	ExplosionParams = {
		pos = {},
		damage = 15000,
		rmin = 15,
		rmax = 45,
		radius = 45,
		DeafnessRadius = 60,
		DeafnessTime = 60,
		impulsive_pressure = 8000,
		shooter = nil,
		weapon = nil,
		explosion = 1,
		rmin_occlusion=.2,
		occlusion_res=32,
		occlusion_inflate=2,
	},
	deform_terrain=1,
	lifetime = 10000,
	mark_terrain = 1,
	force_objtype = 2,
	projectileObject = "Objects/Pickups/explosive/explosive.cgf",
	projectileObjectScale = 1,
}

StickyExplosive = CreateProjectile(projectileDefinition)