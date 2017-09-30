Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="OICW",
	ammotype="Assault",
	model="Objects/Weapons/OICW/OICW_bind.cgf",
	default_amount=40,
	ammotype2="OICWGrenade",
	default_amount2=2,	
	sound="Sounds/Weapons/OICW/oicwact.wav",
}

PickupOICW=CreateWeaponPickup(params);
