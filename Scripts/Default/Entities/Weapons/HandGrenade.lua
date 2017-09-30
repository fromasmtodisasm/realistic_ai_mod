
Script:LoadScript("scripts/default/entities/weapons/BaseHandGrenade.lua");
Script:LoadScript("scripts/default/entities/weapons/AIWeapons.lua");

local param={
	deform_terrain=1,
	model="objects/Pickups/grenade/grenade_frag_pickup.cgf",
	AIBouncingSound = {
		SoundRadius  = AIWeaponProperties.GrenadeBounce.VolumeRadius,
		Interest = AIWeaponProperties.GrenadeBounce.fInterest,
		Threat = AIWeaponProperties.GrenadeBounce.fThreat,
	},
	AIExplodingSound = {
		SoundRadius  = AIWeaponProperties.HandGrenade.VolumeRadius,
		Interest = AIWeaponProperties.HandGrenade.fInterest,
		Threat = AIWeaponProperties.HandGrenade.fThreat,
	},
	AITargetType = AIOBJECT_ATTRIBUTE,
	AITargetType_ALTERNATE = AIAnchor.AIOBJECT_DAMAGEGRENADE,

	hit_effect = "grenade_hit",
	explode_effect = "grenade_explosion",	
	damage_on_player_contact = 1,
	--exploding_sound={
	--	sound="Sounds/Weapons/grenade/grenade.wav",
	--	flags=SOUND_UNSCALABLE,
	--	volume=255,
	--	min=20,
	--	max=1000,
	--},

	explode_on_hold=1,
	explode_underwater = 1,
	
	ExplosionParams = {
		pos = {},
		damage = 500,
		rmin = 4, -- in physical pressure calculations, if something is closer than rmin, it's treated as if it were at rmin
		rmax = 6, --
		radius = 6, -- in physics impulsive_pressure means pressure at this radius
		DeafnessRadius = 8.0,
		DeafnessTime = 10.0,
		impulsive_pressure = 1500,
		shooter = nil,
		weapon = nil,
		rmin_occlusion=0.2,
		occlusion_res=32,
		occlusion_inflate=2,
    iImpactForceMulFinalTorso=100,
	},
};

HandGrenade=CreateHandGrenade(param);
