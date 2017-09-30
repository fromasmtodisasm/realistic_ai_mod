Script:LoadScript("scripts/default/entities/pickups/basepickup.lua")

local params={
	weapon="M4",
	ammotype="Assault",
	model="Objects/Weapons/usrif_m4iron/M4_bind.cgf",
	-- model="Objects/Weapons/usrif_m4iron/M4_bind.cgf",
	default_amount=30,
	sound="Sounds/Weapons/M4/m4weapact.wav",
}

PickupM4=CreateWeaponPickup(params)
