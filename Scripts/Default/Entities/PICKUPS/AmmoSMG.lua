Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	ammotype="SMG",
	model="Objects/pickups/ammo/ammo_smg.cgf",
	default_amount=20,
	sound="sounds/Weapons/m4/M4_AMMO_PICKUP.wav"
}

AmmoSMG=CreateAmmoPickup(params);

