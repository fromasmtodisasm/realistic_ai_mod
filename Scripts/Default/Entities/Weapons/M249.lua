M249 = {
	name			= "M249",
	object		= "Objects/Weapons/M249/M249_bind.cgf",
	character	= "Objects/Weapons/M249/M249.cgf",

	---------------------------------------------------
	PlayerSlowDown = .7,									-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	-- ActivateSound = Sound:Load3DSound("Sounds/Weapons/usrif_m4/m4_deploy.wav"),	-- sound to play when this weapon is selected
	ActivateSound = Sound:Load3DSound("Sounds/Weapons/M4/m4weapact.wav"),	-- sound to play when this weapon is selected
	---------------------------------------------------

	MaxZoomSteps =  1,
	ZoomSteps = {1.0001},--1.4
	ZoomActive = 0,
	AimMode=1,
	-- AimOffset={x=.2279, y=0, z=.075},				--Iron Sights	{left-right,forwards-backwards,up-down}
	-- AimAngleOffset={x=-1.1, y=0, z=-4.5},			--Iron Sights	{up-down,Weird,left-right}

	AimOffset={x=.2300004810094833, y=-.04999998211860657, z=.07710035890340805},	--IronSights
	AimAngleOffset={x=1.299999833106995, y=0, z=-4.470000267028809},	--IronSights

	ZoomOverlayFunc=AimModeZoomHUD.DrawHUD,
	ZoomFixedFactor=1,
	ZoomNoSway=1,			--no sway in zoom mode
	Sway = 0,

	FireParams ={													-- describes all supported firemodes
	{
		RecoilAnimPos = {x=0, y=.05, z=0},					--IronSights
		RecoilAnimAng = {x=-.5, y=0, z=0},					--IronSights
		sight_min_recoil=0,	--IronSights
		sight_max_recoil=0,	--IronSights

		-- Make sure that the last parameter in each sound (max-distance) is equal to "whizz_sound_radius"
		whizz_sound_radius=5,
		generic_whizz = 1,
		whizz_probability=1000,	-- 0-1000

		FireLoop = {
			"Sounds/Weapons/uslmg_m249saw/m249_fire_3p.wav",
			"Sounds/Weapons/uslmg_m249saw/m249_fire_3p.wav",
			"Sounds/Weapons/uslmg_m249saw/m249_fire_3p.wav",
		},
		FireLoopStereo = {
			"Sounds/Weapons/uslmg_m249saw/m249_fire_1p.wav",
			"Sounds/Weapons/uslmg_m249saw/m249_fire_1p.wav",
			"Sounds/Weapons/uslmg_m249saw/m249_fire_1p.wav",
		},
		FireLoopStereoIndoor = {
			"Sounds/Weapons/uslmg_m249saw/m249_fire_indoor_1p.wav",
			"Sounds/Weapons/uslmg_m249saw/m249_fire_indoor_1p.wav",
			"Sounds/Weapons/uslmg_m249saw/m249_fire_indoor_1p.wav",
		},
		DrySound = "Sounds/Weapons/uslmg_m249saw/m249_trigger.wav",

		LightFlash = {
			fRadius = 4,
			vDiffRGBA = {r = 1,g = 1,b = .7,a = 1,},
			vSpecRGBA = {r = 1,g = 1,b = .7,a = 1,},
			fLifeTime = .1,
		},

		ShellCases = {
			geometry=System:LoadObject("Objects/Weapons/shells/rifleshell.cgf"),
			focus = 1.5,
			color = {1,1,1},
			speed = .1,
			count = 1,
			size = 3,
			size_speed = 0,
			gravity = {x = 0,y = 0,z = -9.81},
			lifetime = 5,
			frames = 0,
			color_based_blending = 0,
			particle_type = 0,
		},

		SmokeEffect = {
			size = {.15,.07,.035,.01},
			size_speed = 1.3,
			speed = 9,
			focus = 3,
			lifetime = .25,
			sprite = System:LoadTexture("textures\\cloud1.dds"),
			stepsoffset = .3,
			steps = 4,
			gravity = 1.2,
			AirResistance = 3,
			rotation = 3,
			randomfactor = 50,
		},

		MuzzleEffect = {

			size = {.15,.003},--.15,.25,.35,.3,.2},
			size_speed = 4.3,
			speed = 0,
			focus = 20,
			lifetime = .03,

			sprite = {
					{
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzlesix3.dds"),
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzlesix4.dds"),
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzlesix5.dds"),
					}
					,
					{
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle4.dds"),
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle5.dds"),
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle6.dds"),
					}
				},

			stepsoffset = .05,
			steps = 2,
			gravity = 0,
			AirResistance = 0,
			rotation = 3,
			randomfactor = 10,
			color = {.9,.9,.9},
		},

		-- remove this if not nedded for current weapon
		MuzzleFlash = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_m4_fpv.cgf",
			bone_name = "spitfire",
			lifetime = .1,
		},
		MuzzleFlashTPV = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_m4_tpv.cgf",
			bone_name = "weapon_bone",
			lifetime = .05,
		},

		-- trace "moving bullet"
		-- remove this if not nedded for current weapon
		Trace = {
			--filippo: CGFName do not works
			geometry=System:LoadObject("Objects/Weapons/trail.cgf"),
			--CGFName = "Objects/Weapons/trail.cgf",

			focus = 5000,
			color = {1,1,1},
			speed = 925, -- 120
			count = 1,
			size = 1,
			size_speed = 0,
			gravity = {x = 0,y = 0,z = 0},
			lifetime = .04,
			frames = 0,
			color_based_blending = 3,
			particle_type = 0,
			bouncyness = 0,
		},

		SoundMinMaxVol = {255,7,2200},
	},
	},
		SoundEvents={
		--	animname,	frame,	soundfile
		{	"reload1",	1,			Sound:LoadSound("Sounds/Weapons/M4/M249_reload1.wav")},
		{	"reload1",	48,			Sound:LoadSound("Sounds/Weapons/M4/M249_reload2.wav")},
		{	"reload1",	85,			Sound:LoadSound("Sounds/Weapons/M4/M249_reload3.wav")},
		-- {	"reload1",	0,			Sound:LoadSound("Sounds/Weapons/uslmg_m249saw/m249_reload_3p.mp3")}, -- Взять ту, которая от первого лица и укоротить или ускорить.
	},
	GrenadeThrowFrame = 12,
}

CreateBasicWeapon(M249)
---------------------------------------------------------------
--ANIMTABLE
------------------
M249.anim_table={}
--AUTOMATIC FIRE
M249.anim_table[1]={
	idle={
		"Idle11",
		"Idle21",
	},
	reload={
		"Reload1",
	},
	fire={
		"Fire11",
	},
	melee={
		"Fire23",
	},
	swim={
		"swim",
	},
	activate={
		"Activate1",
	},
}