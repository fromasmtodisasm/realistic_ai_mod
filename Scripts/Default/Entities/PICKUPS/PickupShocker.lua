Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="Shocker",
	ammotype=nil,
	model="Objects/Weapons/Shocker/Shocker_bind.cgf",
	default_amount=30,
	sound="sounds/weapons/Mortar/mortar_33.wav",
}

PickupShocker=CreateWeaponPickup(params);
