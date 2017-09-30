Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	ammotype="SmokeGrenade",
	model="Objects/pickups/grenade/grenade_smoke_pickup.cgf",
	default_amount=3,
	sound="sounds/items/grenade_pickup.wav"
}


AmmoSmokeGrenades=CreateAmmoPickup(params);


