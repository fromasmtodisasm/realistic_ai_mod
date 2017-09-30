Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	ammotype="HandGrenade",
	model="Objects/pickups/grenade/grenade_frag_pickup.cgf",
	default_amount=3,
	sound="sounds/items/grenade_pickup.wav"
}


AmmoHandGrenades=CreateAmmoPickup(params);


