MutantMG = {
	name			= "MutantMG",
	-- object		= nil,
	-- character	= nil,

	MaxZoomSteps =  1,
	ZoomSteps = {1.4},
	ZoomActive = 0,
	AimMode=1,

	ZoomOverlayFunc=AimModeZoomHUD.DrawHUD,
	ZoomFixedFactor=1,
	ZoomNoSway=1, --no sway in zoom mode

	PlayerSlowDown = .7,									-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	-- ActivateSound = Sound:Load3DSound("Sounds/Weapons/usrif_m4/m4_deploy.wav"),	-- sound to play when this weapon is selected
	ActivateSound = Sound:Load3DSound("Sounds/Weapons/M4/m4weapact.wav"),	-- sound to play when this weapon is selected
	---------------------------------------------------
	ZoomFixedFactor=1,
	FireParams ={													-- describes all supported firemodes
	{
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
			vDiffRGBA = {r = 1, g = 1, b = 0, a = 1,},
			vSpecRGBA = {r = .3, g = .3, b = .3, a = 1,},
			fLifeTime = .1,
		},

		ShellCases = {
			geometry=System:LoadObject("Objects/Weapons/shells/rifleshell.cgf"),
			focus = 1.5,
			color = {1, 1, 1},
			speed = .1,
			count = 1,
			size = 3,
			size_speed = 0,
			gravity = {x = 0, y = 0, z = -9.81},
			lifetime = 5,
			frames = 0,
			color_based_blending = 0,
			particle_type = 0,
		},

		-- remove this if not nedded for current weapon
		MuzzleFlashTPV = {
				geometry_name = "Objects/Weapons/Muzzle_flash/mf_coverrl_tpv.cgf",
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
			color = {1, 1, 1},
			speed = 925, -- 120
			count = 1,
			size = 1,
			size_speed = 0,
			gravity = {x = 0, y = 0, z = 0},
			lifetime = .04,
			frames = 0,
			color_based_blending = 3,
			particle_type = 0,
		},
		SoundMinMaxVol = {255,7,2200},
	},
	},

		SoundEvents={
		--	animname,	frame,	soundfile
		{	"reload1",	20,			Sound:LoadSound("Sounds/Weapons/M4/M4_20.wav")},
		{	"reload1",	33,			Sound:LoadSound("Sounds/Weapons/M4/M4_33.wav")},
		{	"reload1",	47,			Sound:LoadSound("Sounds/Weapons/M4/M4_47.wav")},
	},
	GrenadeThrowFrame = 12,

}

CreateBasicWeapon(MutantMG)
---------------------------------------------------------------
--ANIMTABLE
------------------
MutantMG.anim_table={}
--AUTOMATIC FIRE
MutantMG.anim_table[1]={
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