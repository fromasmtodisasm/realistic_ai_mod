Script:LoadScript("scripts/default/entities/weapons/BaseHandGrenade.lua")
local param={
	deform_terrain=1,
	AISoundRadius  = 30,
	AITargetType = 200,
	explode_on_hold=1,
	ExplosionParams = {
		pos = {},
		damage = 110,
		radius = 25,
		rmin = .8,
		rmax = 6, -- default = 10.5
		radius = 6, -- default = 10.5
		DeafnessRadius = 15, -- 10
		DeafnessTime = 30,
		impulsive_pressure = 120,
		shooter = nil,
		weapon = nil,
		rmin_occlusion=.2,
		occlusion_res=32,
		occlusion_inflate=2,
	},
}
ProjFlashbangGrenade=CreateHandGrenade(param)