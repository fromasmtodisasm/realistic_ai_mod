Script:LoadScript("scripts/default/entities/pickups/basepickup.lua")

local params={
	weapon="Falcon",
	ammotype="Pistol",
	model="Objects/Weapons/uspis_p226/DE_bind.cgf",
	default_amount=32,
	sound="Sounds/Weapons/DE/deweapact.wav",
}

PickupFalcon=CreateWeaponPickup(params)
