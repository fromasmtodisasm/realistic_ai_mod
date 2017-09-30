Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="Shotgun",
	ammotype="Shotgun",
	model="Objects/Weapons/Pancor/Pancor_bind.cgf",
	default_amount=10,
	sound="Sounds/Weapons/Pancor/jackwaepact.wav",
}


PickupShotgun=CreateWeaponPickup(params);
