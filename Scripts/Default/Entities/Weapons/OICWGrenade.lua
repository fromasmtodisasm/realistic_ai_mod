Script:LoadScript("scripts/default/entities/weapons/BaseProjectile.lua")
projectileDefinitionSP = {
	Param = {
		mass = .5,
		size = .05,
		heading = {},
		flags=particle_single_contact+particle_no_spin,
		initial_velocity = 130, --  default 23 -- 80
		k_air_resistance = 0,
		acc_thrust = 0,
		acc_lift = 0,
		surface_idx = -1,
		gravity = {x=0,y=0,z=-9.8},
		collider_to_ignore = nil,
		nosmoke = 1,
	},
	
	ExplosionParams = {
		pos = {},
		damage = 700,
		rmin = 1,
		rmax = 12,
		radius = 12,
		DeafnessRadius = 15,
		DeafnessTime = 15,
		impulsive_pressure = 1000,
		shooter = nil,
		weapon = nil,
		explosion = 1,
		rmin_occlusion=.2,
		occlusion_res=32,
		occlusion_inflate=2,
	},
	
	old_Smoke = {
		focus = 0,
		gravity = {x = -5,y = 0,z = 2.50},
		rotation = {x = 0,y = 0,z = 2},
		speed = .2,
		count = 1,
		size = .05,
		size_speed=.2,
		lifetime=1.50,
		frames=1,
		color_based_blending = 3,
		tid = System:LoadTexture("textures/guncloud.dds"),
		turbulence_size = 2,
		turbulence_speed = 2.5,
	},
	SmokeEffectEmitter = "Smoke.OICW.Trail",
	matEffect = "small_explosion",
	deform_terrain = 1,
	mark_terrain = 1,
	fDeformRadius = 1,	
	explodeOnContact = 1,
	-- UseAIProjectileShoot = 1,
}

-- projectileDefinitionMP = {
	-- Param = {
		-- mass = .5,
		-- size = .05,
		-- heading = {},
		-- flags=particle_single_contact+particle_no_spin,
		-- initial_velocity = 65, --80
		-- k_air_resistance = 0,
		-- acc_thrust = 0,
		-- acc_lift = 0,
		-- surface_idx = -1,
		-- gravity = {x=0,y=0,z=3*-9.8},
		-- collider_to_ignore = nil,
		-- nosmoke = 1,
	-- },
	
	-- ExplosionParams = {
		-- pos = {},
		-- damage = 350, --200,
		-- rmin = 1, --1
		-- rmax = 7, --5 
		-- radius = 7, --5
		-- DeafnessRadius = 3.5,
		-- DeafnessTime = 6,
		-- impulsive_pressure = 1000,
		-- shooter = nil,
		-- weapon = nil,
		-- explosion = 1,
		-- rmin_occlusion=.2,
		-- occlusion_res=32,
		-- occlusion_inflate=2,
	-- },
	
	-- old_Smoke = {
		-- focus = 0,
		-- gravity = {x = -5,y = 0,z = 2.50},
		-- rotation = {x = 0,y = 0,z = 2},
		-- speed = .2,
		-- count = 1,
		-- size = .05,
		-- size_speed=.2,
		-- lifetime=1.50,
		-- frames=1,
		-- color_based_blending = 3,
		-- tid = System:LoadTexture("textures/guncloud.dds"),
		-- turbulence_size = 2,
		-- turbulence_speed = 2.5,
	-- },
	-- SmokeEffectEmitter = "Smoke.OICW.Trail",
	
	-- matEffect = "small_explosion",
	-- deform_terrain = 1,
	-- mark_terrain = 1,
	-- fDeformRadius = 1,	
	-- explodeOnContact = 1,
	-- -- UseAIProjectileShoot = 1,
-- }

-- if (Game:IsMultiplayer()) then
	-- OICWGrenade = CreateProjectile(projectileDefinitionMP)
-- else
	OICWGrenade = CreateProjectile(projectileDefinitionSP)
-- end