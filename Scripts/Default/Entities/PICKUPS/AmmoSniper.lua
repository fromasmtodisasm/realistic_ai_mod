Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	ammotype="Sniper",
	model="Objects/pickups/ammo/sniperammo.cgf",
	default_amount=5,
	sound="Sounds/Weapons/aw50/AW50_AMMO_PICKUP.wav"
}

AmmoSniper=CreateAmmoPickup(params);

