Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	ammotype="OICWGrenade",
	model="Objects/pickups/ammo/ammo_20mm.cgf",
	default_amount=5,
	sound="sounds/weapons/oicw/OICW_GRENADE_AMMO_PICKUP.wav"
}

AmmoOICWGrenade=CreateAmmoPickup(params);

