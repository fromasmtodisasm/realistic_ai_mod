Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="MP5",
	ammotype="SMG",
	model="Objects/Weapons/MP5/MP5_bind.cgf",
	default_amount=30,
	sound="Sounds/Weapons/MP5/mp5weapact.wav",
}

PickupMP5=CreateWeaponPickup(params);
