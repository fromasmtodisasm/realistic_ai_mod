Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	weapon="RL",
	ammotype="Rocket",
	model="Objects/Weapons/RL/RL_bind.cgf",
	default_amount=4,
	sound="sounds/weapons/Mortar/mortar_33.wav",
}

PickupRL=CreateWeaponPickup(params);
