Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="Falcon",
	ammotype="Pistol",
	model="Objects/Weapons/DE/DE_bind.cgf",
	default_amount=32,
	sound="sounds/weapons/DE/deweapact.wav",
}

PickupFalcon=CreateWeaponPickup(params);
