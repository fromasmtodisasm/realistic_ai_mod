Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="Wrench",
	ammotype=nil,
	model="Objects/Weapons/Wrench/Wrench_bind.cgf",
	default_amount=30,
	sound="sounds/weapons/Mortar/mortar_33.wav",
	objectangles = {x = 75, y = 0, z = 90},
	objectpos = {x = 0, y = 0, z = 0},
}

PickupWrench=CreateWeaponPickup(params);
