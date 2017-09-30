Script:LoadScript("scripts/default/entities/weapons/BaseProjectile.lua");
projectileDefinitionSP = {
	Param = {
		mass = 1,
		size = 0.15,
		heading = {},
		flags=particle_single_contact+particle_no_spin,
		initial_velocity = 53,
		k_air_resistance = 0,
		acc_thrust = 0,
		acc_lift = 0,
		surface_idx = -1,
		gravity = {x=0, y=0, z=4*-9.8 },
		collider_to_ignore = nil,
	},

	ExplosionParams = {
		pos = {},
		damage = 190,--230,
		rmin = 1.5,
		rmax = 6.5,--5, 
		radius = 6.5,--5,
		DeafnessRadius = 10.5,
		DeafnessTime = 6.0,
		impulsive_pressure = 1000, 
		shooter = nil,
		weapon = nil,
		explosion = 1,
		rmin_occlusion=0.2,
		occlusion_res=32,
		inflate=2,
	},
	
	--in multiplayer, if this table exist will be merged with the table above.
	ExplosionParams_Mp = {
		damage = 190,
		rmin = 1.0,
		rmax = 4.0,
		radius = 4.0,
	},
	
	old_Smoke = {
		focus = 0,
		color = {1,1,1},
		speed = 0.2,
		count = 1,
		size = 0.2, size_speed=0.0,
		lifetime=1,
		frames=1,
		color_based_blending = 3,
		tid = System:LoadTexture("textures/cloud.dds"),
	},
	SmokeEffectEmitter = "Smoke.AG36.Trail",

	matEffect = "ag36_explosion",
	mark_terrain = 1,
	fDeformRadius = 1.0,
	explodeOnContact = 1,
}

projectileDefinitionMP = {
	Param = {
		mass = 1,
		size = 0.15,
		heading = {},
		flags=particle_single_contact+particle_no_spin,
		initial_velocity = 28.5,  --40
		k_air_resistance = 0,
		acc_thrust = 0,
		acc_lift = 0,
		surface_idx = -1,
		gravity = {x=0, y=0, z=1.5*-9.8 },
		collider_to_ignore = nil,
	},

	ExplosionParams = {
		pos = {},
		damage = 190,--230,
		rmin = 1.5,
		rmax = 6.5,--5, 
		radius = 6.5,--5,
		DeafnessRadius = 10.5,
		DeafnessTime = 6.0,
		impulsive_pressure = 1000, 
		shooter = nil,
		weapon = nil,
		explosion = 1,
		rmin_occlusion=0.2,
		occlusion_res=32,
		inflate=2,
	},
	
	--in multiplayer, if this table exist will be merged with the table above.
	ExplosionParams_Mp = {
		damage = 200, --190
		rmin = 1.0,
		rmax = 5.0, --4.0
		radius = 5.0, --4.0
	},
	
	old_Smoke = {
		focus = 0,
		color = {1,1,1},
		speed = 0.2,
		count = 1,
		size = 0.2, size_speed=0.0,
		lifetime=1,
		frames=1,
		color_based_blending = 3,
		tid = System:LoadTexture("textures/cloud.dds"),
	},
	SmokeEffectEmitter = "Smoke.AG36.Trail",

	matEffect = "ag36_explosion",
	mark_terrain = 1,
	fDeformRadius = 1.0,
	explodeOnContact = 1,
}

if (Game:IsMultiplayer()) then
	AG36Grenade = CreateProjectile(projectileDefinitionMP);
else
	AG36Grenade = CreateProjectile(projectileDefinitionSP);
end


