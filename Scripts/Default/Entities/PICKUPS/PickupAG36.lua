Script:LoadScript("scripts/default/entities/pickups/basepickup.lua")

local params={
	weapon="AG36",
	ammotype="Assault",
	model="Objects/Weapons/gerrif_g36ugl/ag36_bind.cgf",
	default_amount=30,
	ammotype2="AG36Grenade",
	default_amount2=1,	
	sound="Sounds/Weapons/ag36/agweapact.wav"
}

PickupAG36=CreateWeaponPickup(params)
