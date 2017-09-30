Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	ammotype="Assault",
	model="Objects/pickups/ammo/ammo.cgf",
	default_amount=25,
	sound="Sounds/Weapons/M4/M4_33.wav"
}

AmmoAssault=CreateAmmoPickup(params);

