Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	ammotype="Pistol",
	model="Objects/pickups/ammo/ammo_pistol.cgf",
	default_amount=25,
	sound="Sounds/Weapons/DE/DE_AMMO_PICKUP.wav"
}


AmmoPistol=CreateAmmoPickup(params);

