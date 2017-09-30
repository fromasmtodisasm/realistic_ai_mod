Script:LoadScript("scripts/default/entities/weapons/BaseHandGrenade.lua");

local param={
	no_explosion=1,
	no_trail=1,
	explode_on_contact=1,
	lifetime=5000,
	Param = {
		flags = 0,
		mass = .3,
		size = 0.2,
		heading = {},
		initial_velocity = 25, -- default 19
		k_air_resistance = 0.5,
		acc_thrust = 0,
		acc_lift = 0,
		surface_idx = -1,
		gravity = {x=0, y=0, z=-13 },
		min_bounce_vel = 3.5,
		collider_to_ignore = nil,
	},
	model="objects/natural/rocks/throwrock.cgf",
	AISoundRadius = 10,
	AIInterest = 2.0,
	AIThreat = 0,
};

ProjRock=CreateHandGrenade(param);
