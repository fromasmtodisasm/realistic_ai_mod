--Script:LoadScript("SCRIPTS/Default/Entities/Weapons/WeaponsParams.lua");

WeaponClassesEx = {
	--Hands = { 
	--	id			= 9,
	--	script	= "Weapons/Hands.lua",
	--},
	Falcon = { 
		id			= 10,
		script	= "Weapons/Falcon.lua",
	},
	AG36 = { 
		id			= 11,
		script	= "Weapons/AG36.lua",
	},
	MP5 = { 
		id			= 12,
		script	= "Weapons/MP5.lua",
	},
	Machete = { 
		id			= 13,
		script	= "Weapons/Machete.lua",
	},
	Shotgun = { 
		id			= 14,
		script	= "Weapons/Shotgun.lua",
	},
	SniperRifle = { 
		id			= 15,
		script	= "Weapons/SniperRifle.lua",
	},
	OICW = { 
		id			= 16,
		script	= "Weapons/OICW.lua",
	},
	--NTW20 = { 
	--	id			= 17,
	--	script	= "Weapons/NTW20.lua",
	--},
	RL = { 
		id			= 18,
		script	= "Weapons/RL.lua",
	},
	P90 = { 
		id			= 19,
		script	= "Weapons/P90.lua",
	},
	M4 = { 
		id			= 20,
		script	= "Weapons/M4.lua",
	},
	Shocker = { 
		id			= 21,
		script	= "Weapons/Shocker.lua",
	},
	M249 = { 
		id			= 22,
		script	= "Weapons/M249.lua",
	},
	Mortar = { 
		id			= 23,
		script	= "Weapons/Mortar.lua",
	},
	COVERRL = { 
		id			= 24,
		script	= "Weapons/COVERRL.lua",
	},
	MG = { 
		id			= 25,
		script	= "Weapons/MG.lua",
	},
	MutantShotgun = { 
		id			= 26,
		script	= "Weapons/MutantShotgun.lua",
	},
	EngineerTool = { 
		id			= 27,
		script	= "Weapons/EngineerTool.lua",
	},
	MedicTool = { 
		id			= 28,
		script	= "Weapons/MedicTool.lua",
	},
	Wrench = { 
		id			= 29,
		script	= "Weapons/Wrench.lua",
	},
	ScoutTool = { 
		id			= 30,
		script	= "Weapons/ScoutTool.lua",
	},
	VehicleMountedMG = {
		id			= 31,
		script	= "Weapons/VehicleMountedMG.lua",
	},
	VehicleMountedRocketMG = {
		id			= 32,
		script	= "Weapons/VehicleMountedRocketMG.lua",
	},
	VehicleMountedRocket = {
		id			= 33,
		script	= "Weapons/VehicleMountedRocket.lua",
	},
	VehicleMountedAutoMG = {
		id			= 34,
		script	= "Weapons/VehicleMountedAutoMG.lua",
	},
	MutantMG = {
		id			= 35,
		script	= "Weapons/MutantMG.lua",
	},
}

Projectiles={
	Rocket={
		model="objects/weapons/Rockets/rocket.cgf",
	},
	Grenade={
		model="objects/weapons/Rockets/rocket.cgf",
	},
	OICWGrenade={
		model="objects/weapons/Rockets/rocket.cgf",
	},
	SmokeGrenade={
		model="objects/weapons/Grenades/Grenade.cgf",
	},
	HandGrenade={
		model="objects/weapons/Grenades/Grenade.cgf",
	},
	FlareGrenade={
		model="objects/weapons/Grenades/Grenade.cgf",
	},
	FlashbangGrenade={
		model="objects/weapons/Grenades/Grenade.cgf",
	},
	GlowStick={
		model="objects/weapons/Grenades/Grenade.cgf",
	},
 	Rock={
		model="objects/natural/rocks/throwrock.cgf",
	},
 	MutantRocket={
		model="objects/natural/rocks/throwrock.cgf",
	},
	MortarShell={
		model="objects/weapons/Rockets/rocket.cgf",
	},
	AG36Grenade={
		model="objects/weapons/Rockets/rocket.cgf",
	},
	StickyExplosive={
		model="Objects/Pickups/explosive/explosive_nocount.cgf",  -- not used
	},
	VehicleRocket={
		model="objects/weapons/Rockets/rocket.cgf",
	},
};

-- 
GrenadesClasses = {
	"Rock",
	"HandGrenade",
	"SmokeGrenade",
	"FlareGrenade",
	"FlashbangGrenade",
	"GlowStick",
};


-- Names of weapons which are loaded, filled by AddAndSpawnWeapon()
WeaponsLoaded = { };


-- Equipment packs
MainPlayerEquipPack = nil;
if (EquipPacks == nil) then
	EquipPacks = { };
end