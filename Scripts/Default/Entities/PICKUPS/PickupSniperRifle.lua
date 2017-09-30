Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="SniperRifle",
	ammotype="Sniper",
	model="Objects/Weapons/AW50/AW50_bind.cgf",
	default_amount=5,
	sound="Sounds/Weapons/AW50/aw50weapact.wav"
}

PickupSniperRifle=CreateWeaponPickup(params);
