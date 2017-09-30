Script:LoadScript("scripts/default/entities/pickups/basepickup.lua")
-- Improved by Mixer http://verysoft.narod.ru/fctweaks.htm
local params={
weapon="Shocker",
ammotype=nil,
objectangles = {x=80,y=0,z=0},
objectpos = {x=0,y=0,z=-.03},
model="Objects/Weapons/Shocker/Shocker_bind.cgf",
default_amount=30,
sound="Sounds/Weapons/Mortar/mortar_33.wav",
}

PickupShocker=CreateWeaponPickup(params)
