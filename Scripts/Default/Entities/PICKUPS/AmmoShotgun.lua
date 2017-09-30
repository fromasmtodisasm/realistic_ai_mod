Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	ammotype="Shotgun",
	model="Objects/pickups/ammo/shotgunammo.cgf",
	default_amount=20,
	sound="sounds/Weapons/Pancor/pancor_49.wav"
}

AmmoShotgun=CreateAmmoPickup(params);

