Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="AG36",
	ammotype="Assault",
	model="Objects/Weapons/AG36/AG36_bind.cgf",
	default_amount=30,
	ammotype2="AG36Grenade",
	default_amount2=1,	
	sound="sounds/weapons/ag36/agweapact.wav"
}

PickupAG36=CreateWeaponPickup(params);
