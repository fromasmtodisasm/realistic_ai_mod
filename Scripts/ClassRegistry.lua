-- defines entity classes of players in this game
--
-- _CLASS_ID is used for C++ (don't change those)
-- defines entity classes of players in this game
--
-- _CLASS_ID is used for C++ (don't change those)

EntityClassRegistry = 
{
-- entity_type,name,ID,script_file
--
	{"Player",		"Player",PLAYER_CLASS_ID,"Player/player.lua"},							--  1
	
	{"",					"FlagEntity",20,"Others/FlagEntity.lua"},										-- 20
	{"",					"TestCloth",21,"Others/Cloth.lua"},													-- 21
	{"",					"UnitHighlight",22,"Multiplayer/UnitHighlight.lua"},				-- 22
	{"",					"Health",23,"Pickups/health.lua"},													-- 23
	{"",					"Armor",24,"Pickups/armor.lua"},														-- 24
	{"",					"ClassAmmoPickup",25,"Pickups/ClassAmmoPickup.lua"}, 				-- 25
	{"",					"PickupFlashlight",26,"Pickups/PickupFlashlight.lua"}, 			-- 26
	
	-- weaponpickups
	{"Pickup",		"PickupFalcon",27,"Pickups/PickupFalcon.lua"}, 							-- 27
	{"Pickup",		"PickupAG36",28,"Pickups/PickupAG36.lua"}, 									-- 28
	{"Pickup",		"PickupMP5",29,"Pickups/PickupMP5.lua"}, 										-- 29
	{"Pickup",		"PickupMachete",30,"Pickups/PickupMachete.lua"}, 						-- 30
	{"Pickup",		"PickupShotgun",31,"Pickups/PickupShotgun.lua"}, 						-- 31 
	{"Pickup",		"PickupSniperRifle",32,"Pickups/PickupSniperRifle.lua"}, 		-- 32
	{"Pickup",		"PickupOICW",33,"Pickups/PickupOICW.lua"}, 									-- 33
	{"Pickup",		"PickupRL",34,"Pickups/PickupRL.lua"}, 											-- 34
	{"Pickup",		"PickupP90",35,"Pickups/PickupP90.lua"}, 										-- 35
	{"Pickup",		"PickupM4",36,"Pickups/PickupM4.lua"}, 											-- 36
	{"Pickup",		"PickupShocker",37,"Pickups/PickupShocker.lua"}, 						-- 37
	{"Pickup",		"PickupWrench",38,"Pickups/PickupWrench.lua"}, 							-- 38
	{"Pickup",		"PickupM249",39,"Pickups/PickupM249.lua"}, 									-- 39
	
	-- projectiles
	{"Projectile","Rocket",50,"Weapons/Rocket.lua"},													-- 50
	{"Projectile","Grenade",51,"Weapons/Grenade.lua"},												-- 51 - might be legacy - HandGrenade is used as replacement
	{"Projectile","OICWGrenade",52,"Weapons/OICWGrenade.lua"},								-- 52
	{"Projectile","SmokeGrenade",53,"Weapons/SmokeGrenade.lua"},							-- 53
	{"Projectile","HandGrenade",54,"Weapons/HandGrenade.lua"},								-- 54
	{"Projectile","FlareGrenade",55,"Weapons/FlareGrenade.lua"},							-- 55
	{"Projectile","FlashbangGrenade",56,"Weapons/FlashbangGrenade.lua"},			-- 56
	{"Projectile","GlowStick",57,"Weapons/GlowStick.lua"},										-- 57
	{"Projectile","Rock",58,"Weapons/Rock.lua"},															-- 58
	{"Projectile","MutantRocket",59,"Weapons/MutantRocket.lua"},							-- 59
	{"Projectile","MortarShell",60,"Weapons/MortarShell.lua"},								-- 60
	{"Projectile","AG36Grenade",61,"Weapons/AG36Grenade.lua"},								-- 61
	{"Projectile","StickyExplosive",62,"Weapons/StickyExplosive.lua"},				-- 62
	{"Projectile","VehicleRocket",63,"Weapons/VehicleRocket.lua"},						-- 63
	
	-- players
	{"Player",		"MercCover",	71,"AI/MercCover.lua"},												-- 71
	{"Player",		"MercScout",	72,"AI/MercScout.lua"},												-- 72
	{"Player",		"MercRear",	73,"AI/MercRear.lua"},													-- 73
	{"Player",		"NPC",		74,"AI/NPC.lua"},																	-- 74
	{"Player",		"Grunt",	75,"AI/Grunt.lua"},																-- 75
	{"Player",		"MutantCover",	76,"AI/MutantCover.lua"},										-- 76
	{"Player",		"MutantRear",	77,"AI/MutantRear.lua"},											-- 77
	{"Player",		"MutantBezerker",78,"AI/MutantBezerker.lua"},								-- 78
	{"Player",		"MutantMonkey",	79,"AI/MutantMonkey.lua"},									-- 79
	{"Player",		"Pig",		80,"AI/Pig.lua"},																	-- 80
	{"Player",		"MutantScout",	81,"AI/MutantScout.lua"},										-- 81
	{"Player",		"Worm",		82,"AI/Worm.lua"},																-- 82
	{"Player",		"MercSniper",	83,"AI/MercSniper.lua"},											-- 83
	{"Player",		"Shark",	84,"AI/Shark.lua"},																-- 84

	-- vehicles related - wreck pieces, windows ---------------------------------
	
	{"",					"Piece",88,"Others/piece.lua"},															-- 88
	{"",					"BreakableObject",89,"Others/BreakableObject.lua"},					-- 89
	
	-- vehicles -----------------------------------------------------------------
	
	{"Vehicle",		"Boat",		90,"Vehicles/boat.lua"},													-- 90
	{"Vehicle",		"FWDVehicle",	91,"Vehicles/fwdvehicle.lua"},								-- 91 
	{"Vehicle",		"Buggy",	92,"Vehicles/Buggy.lua"},													-- 92 
	{"Vehicle",		"InflatableBoat",	93,"Vehicles/inflatableboat.lua"},				-- 93 
	{"Vehicle",		"Bigtrack",	94,"Vehicles/Bigtrack.lua"},										-- 94
	{"Vehicle",		"Paraglider",	95,"Vehicles/Paraglider.lua"},								-- 95 
	{"Vehicle",		"Forklift",	96,"Vehicles/Forklift.lua"},										-- 96
	{"Vehicle",		"BoatPatrol",99,"Vehicles/BoatPatrol.lua"},									-- 99

	-----------------------------------------------------------------------------

	{"",				"AdvCamSystem",ADVCAMSYSTEM_CLASS_ID,""},											-- 97
	{"",				"Spectator",SPECTATOR_CLASS_ID,"Player/Spectator.lua"},				-- 98
	

	-- All Other classes -----------------------------------------------------------

	{ "",	"CargoChopper",	101,	"AI/CargoChopper.lua" },
	{ "",	"Gunship",	102,	"AI/Gunship.lua" },
	{ "",	"SoundSupressor",	103,	"AI/SoundSupressor.lua" },
	{ "",	"CreatureGenerator",	104,	"AI/CreatureGenerator.lua" },
	{ "",	"MountedWeaponMG",	105,	"Weapons/MountedWeaponMG.lua" },
	{ "",	"MountedWeaponMortar",	106,	"Weapons/MountedWeaponMortar.lua" },
	{ "",	"MountedWeaponVehicle",	107,	"Weapons/MountedWeaponVehicle.lua" },
	{ "",	"Birds",	108,	"Boids/Birds.lua" },
	{ "",	"Fish",	109,	"Boids/Fish.lua" },
	{ "",	"Bugs",	110,	"Boids/Bugs.lua" },
	{ "",	"AutomaticDoor",	111,	"Doors/AutomaticDoor.lua" },
	{ "",	"AutomaticDoor1Piece",	112,	"Doors/AutomaticDoor1Piece.lua" },
	{ "",	"Door",	113,	"Doors/Door.lua" },
	{ "",	"AutomaticElevator",	114,	"Elevators/AutomaticElevator.lua" },
	{ "",	"Ladder",	115,	"Elevators/ladder.lua" },
	{ "",	"FlyingFox",	116,	"Elevators/FlyingFox.lua" },
	{ "",	"CameraSource",	117,	"Others/CameraSource.lua" },
	{ "",	"CameraTargetPoint",	118,	"Others/CameraTargetPoint.lua" },
	{ "",	"DynamicLight",	119,	"Lights/DynamicLight.lua" },
	{ "",	"FrogMine",	120,	"Mines/FrogMine.lua" },
	{ "",	"ProximityMine",	121,	"Mines/ProximityMine.lua" },
	{ "",	"AreaMine",	122,	"Mines/AreaMine.lua" },
	{ "",	"CAHFlag",	123,	"Multiplayer/CAHFlag.lua" },
	{ "",	"CTFFlag",	124,	"Multiplayer/CTFFlag.lua" },
	{ "",	"HealingPoint",	125,	"Multiplayer/HealingPoint.lua" },
	{ "",	"ASSAULTCheckPoint",	126,	"Multiplayer/ASSAULTCheckPoint.lua" },
	{ "",	"BuildPoint",	127,	"Multiplayer/BuildPoint.lua" },
	{ "",	"Phoenix",	128,	"Multiplayer/Phoenix.lua" },
	{ "",	"CurrentMission",	129,	"Multiplayer/CurrentMission.lua" },
	{ "",	"AnimObject",	130,	"Others/AnimObject.lua" },
	{ "",	"RigidBody",	131,	"Others/RigidBody.lua" },
	{ "",	"Rotator",	132,	"Others/Rotator.lua" },
	{ "",	"DestroyableObject",	133,	"Others/DestroyableObject.lua" },
	{ "",	"Rope",	134,	"Others/rope.lua" },
	{ "",	"Radio",	135,	"Others/Radio.lua" },
	{ "",	"TV",	136,	"Others/TV.lua" },
	{ "",	"RaisingWater",	137,	"Others/RaisingWater.lua" },
	{ "",	"BuildableObject",	138,	"Others/BuildableObject.lua" },
	{ "",	"Capture",	139,	"Others/capture.lua" },
	{ "",	"GameEvent",	140,	"Others/GameEvent.lua" },
	{ "",	"SwivilChair",	141,	"Others/SwivilChair.lua" },
	{ "",	"AICrate",	142,	"Others/AICrate.lua" },
	{ "",	"HeliStatic",	143,	"Others/HeliStatic.lua" },
	{ "",	"DeadBody",	144,	"Others/DeadBody.lua" },
	{ "",	"DamageArea",	145,	"Others/DamageArea.lua" },
	{ "",	"BasicEntity",	146,	"Others/BasicEntity.lua" },
	{ "",	"ChainSwing",	147,	"Others/chain.lua" },
	{ "",	"SwingingObject",	148,	"Others/SwingingObject.lua" },
	{ "",	"ProximityDamage",	149,	"Others/ProximityDamage.lua" },
	{ "",	"ShootTarget",	150,	"Others/ShootTarget.lua" },
	{ "",	"Pusher",	151,	"Others/Pusher.lua" },
	{ "",	"ParticleSpray",	152,	"Particle/ParticleSpray.lua" },
	{ "",	"ParticleEffect",	153,	"Particle/ParticleEffect.lua" },
	{ "",	"AmmoPistol",	154,	"Pickups/AmmoPistol.lua" },
	{ "",	"AmmoAssault",	155,	"Pickups/AmmoAssault.lua" },
	{ "",	"AmmoShotgun",	156,	"Pickups/AmmoShotgun.lua" },
	{ "",	"AmmoSMG",	157,	"Pickups/AmmoSMG.lua" },
	{ "",	"AmmoSniper",	158,	"Pickups/AmmoSniper.lua" },
	{ "",	"AmmoRocket",	159,	"Pickups/AmmoRocket.lua" },
	{ "",	"AmmoHandGrenades",	160,	"Pickups/AmmoHandGrenades.lua" },
	{ "",	"AmmoFlashbangGrenades",	161,	"Pickups/AmmoFlashbangGrenades.lua" },
	{ "",	"AmmoSmokeGrenades",	162,	"Pickups/AmmoSmokeGrenades.lua" },
	{ "",	"AmmoAG36Grenade",	163,	"Pickups/AmmoAG36Grenade.lua" },
	{ "",	"AmmoOICWGrenade",	164,	"Pickups/AmmoOICWGrenade.lua" },
	{ "",	"KeyCard0",	165,	"Pickups/KeyCard0.lua" },
	{ "",	"KeyCard1",	199,	"Pickups/KeyCard1.lua" },
	{ "",	"KeyCard2",	200,	"Pickups/KeyCard2.lua" },

	{ "",	"PickupExplo",	166,	"Pickups/PickupExplo.lua" },
	{ "",	"PickupBinoculars",	167,	"Pickups/PickupBinoculars.lua" },
	{ "",	"PickupCompass",	168,	"Pickups/PickupCompass.lua" },
	{ "",	"PickupHeatVisionGoggles",	169,	"Pickups/PickupHeatVisionGoggles.lua" },
	{ "",	"PickupGeneric",	170,	"Pickups/PickupGeneric.lua" },
	{ "",	"Checkpoint",	171,	"Pickups/Checkpoint.lua" },
	{ "",	"Fog",	172,	"Render/Fog.lua" },
	{ "",	"Storm",	173,	"Render/Storm.lua" },
	{ "",	"ViewDist",	174,	"Render/ViewDist.lua" },
	{ "",	"EnvColor",	175,	"Render/EnvColor.lua" },
	{ "",	"BFly",	176,	"Render/BFly.lua" },
	{ "",	"Grasshopper",	177,	"Render/Grasshopper.lua" },
	{ "",	"RandomAmbientSound",	178,	"Sound/RandomAmbientSound.lua" },
	{ "",	"SoundSpot",	179,	"Sound/SoundSpot.lua" },
	{ "",	"SoundExclusive",	180,	"Sound/SoundExclusive.lua" },
	{ "",	"RandomAmbientSoundPreset",	181,	"Sound/RandomAmbientSoundPreset.lua" },
	{ "",	"SoundExclusivePreset",	182,	"Sound/SoundExclusivePreset.lua" },
	{ "",	"MusicThemeSelector",	183,	"Sound/MusicThemeSelector.lua" },
	{ "",	"MusicMoodSelector",	184,	"Sound/MusicMoodSelector.lua" },
	{ "",	"EAXArea",	185,	"Sound/EAXArea.lua" },
	{ "",	"EAXPresetArea",	186,	"Sound/EAXPresetArea.lua" },
	{ "",	"MissionHint",	187,	"Sound/MissionHint.lua" },
	{ "",	"ProximityTrigger",	188,	"Triggers/ProximityTrigger.lua" },
	{ "",	"VisibilityTrigger",	189,	"Triggers/VisibilityTrigger.lua" },
	{ "",	"AreaTrigger",	190,	"Triggers/AreaTrigger.lua" },
	{ "",	"PlaceableExplo",	191,	"Triggers/PlaceableExplo.lua" },
	{ "",	"PlaceableGeneric",	192,	"Triggers/PlaceableGeneric.lua" },
	{ "",	"DelayTrigger",	193,	"Triggers/DelayTrigger.lua" },
	{ "",	"BoatTrampolineTrigger",	194,	"Triggers/BoatTrampolineTrigger.lua" },
	{ "",	"ImpulseTrigger",	195,	"Triggers/ImpulseTrigger.lua" },
	{ "",	"AITrigger",	196,	"Triggers/AITrigger.lua" },
	{ "",	"MultipleTrigger",	197,	"Triggers/MultipleTrigger.lua" },
	{ "",	"AISphere",	198,	"AI/AISphere.lua" },
	{ "",	"Watch",	201,	"Others/Watch.lua" },
	{ "",	"SaveableBasicEntity",	202,	"Others/SaveableBasicEntity.lua" },
	{ "",	"ProximityKeyTrigger",	203,	"Triggers/ProximityKeyTrigger.lua" },
	{ "",	"AISpeed",	204,	"AI/AISpeed.lua" },
	{ "",	"Synched2DTable",	SYNCHED2DTABLE_CLASS_ID,	"multiplayer/Synched2DTable.lua" },							-- 205 used to syncronize scoreboard in multiplayer
};