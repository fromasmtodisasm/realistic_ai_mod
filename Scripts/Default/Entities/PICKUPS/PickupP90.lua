Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="P90",
	ammotype="SMG",
	model="Objects/Weapons/P90/P90_bind.cgf",
	default_amount=50,
	sound="Sounds/Weapons/P90/P90weapact.wav",
}

PickupP90=CreateWeaponPickup(params);
