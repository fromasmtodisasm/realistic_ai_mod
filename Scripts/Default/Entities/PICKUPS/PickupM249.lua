Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="M249",
	ammotype="Assault",
	model="Objects/Weapons/M249/M249_bind.cgf",
	default_amount = 100,
	sound="Sounds/Weapons/M4/m4weapact.wav",
}

PickupM249=CreateWeaponPickup(params);
