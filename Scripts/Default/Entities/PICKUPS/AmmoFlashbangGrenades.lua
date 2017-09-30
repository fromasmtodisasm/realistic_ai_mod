Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local params={
	ammotype="FlashbangGrenade",
	model="Objects/pickups/grenade/grenade_flash_pickup.cgf",
	default_amount=3,
	sound="sounds/items/grenade_pickup.wav"
}


AmmoFlashbangGrenades=CreateAmmoPickup(params);


