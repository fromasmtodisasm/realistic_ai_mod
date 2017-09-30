projectileDefinition = {
	Param = {
		mass = 4,
		size = 0.2,
		heading = {},
		flags = bor(particle_no_path_alignment, particle_no_roll, particle_traceable),
		--initial_velocity = 75,
		initial_velocity = 6, --  default 23
		k_air_resistance = 0,
		acc_thrust = 0,
		acc_lift = 0,
		surface_idx = Game:GetMaterialIDByName("mat_sticky"),
		gravity = {x=0, y=0, z=-9.81 },
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
	projectileObject = "Objects/weapons/scouttool/scouttool_active.cgf",
	projectileObjectScale = 1.0,
}

StickyExplosive = CreateProjectile(projectileDefinition);