Script:LoadScript("scripts/default/entities/pickups/basepickup.lua")

local params={
	ammotype="AG36Grenade",
	model="objects/pickups/ammo/ammo_40mm.cgf",
	default_amount=5,
	sound="Sounds/Weapons/ag36/AG36_AMMO_GRENADE_PICKUP.wav"
}

AmmoAG36Grenade=CreateAmmoPickup(params)

