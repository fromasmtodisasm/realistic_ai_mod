Script:LoadScript("scripts/default/entities/pickups/basepickup.lua")

local params={
	ammotype="Rocket",
	model="Objects/pickups/ammo/rockets.cgf",
	default_amount=6,
	sound="Sounds/Weapons/Mortar/mortar_33.wav"
}

AmmoRocket=CreateAmmoPickup(params)

