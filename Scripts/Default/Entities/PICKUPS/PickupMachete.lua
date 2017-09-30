Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="Machete",
	ammotype=nil,
	model="Objects/Weapons/Machete/Machete_bind.cgf",
	default_amount=30,
	sound="sounds/weapons/Machete/MACHETE_PICKUP.wav",
	objectangles = {x = 75, y = 0, z = 90},
	objectpos = {x = 0, y = 0, z = 0},
}

PickupMachete=CreateWeaponPickup(params);
