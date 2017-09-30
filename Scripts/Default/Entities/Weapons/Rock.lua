Script:LoadScript("scripts/default/entities/weapons/BaseHandGrenade.lua");
Script:LoadScript("scripts/default/entities/weapons/AIWeapons.lua");

local param={
	AIBouncingSound = {
		SoundRadius  = AIWeaponProperties.Rock.VolumeRadius,
		Interest = AIWeaponProperties.Rock.fInterest,
		Threat = AIWeaponProperties.Rock.fThreat,
	},

	AITargetType = AIOBJECT_ATTRIBUTE,
	AITargetType_ALTERNATE = 0,

	no_explosion=1,
	damage_on_player_contact = 1,
	no_trail=1,
	lifetime=5000,
	hit_effect = "rock_hit",
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
		min_bounce_vel = 10,
		collider_to_ignore = nil,
	},
	model="objects/natural/rocks/throwrock.cgf",
	model_nooffset = 1,
};

Rock=CreateHandGrenade(param);
