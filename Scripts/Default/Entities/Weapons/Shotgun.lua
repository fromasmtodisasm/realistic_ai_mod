Shotgun = {
	name			= "Shotgun",
	object		= "Objects/Weapons/pancor/pancor_bind.cgf",
	character	= "Objects/Weapons/pancor/pancor.cgf",
	
	PlayerSlowDown = .75,									-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	ActivateSound = Sound:LoadSound("Sounds/Weapons/Pancor/jackwaepact.wav",0,100),	-- sound to play when this weapon is selected
	---------------------------------------------------

	MaxZoomSteps =  1,
	ZoomSteps = {1.0001},-- 1.4
	ZoomActive = 0,
	AimMode=1,
	AimOffset={x=.2115998566150665, y=.1279999315738678, z=.07440003752708435},	--IronSights	{left-right,forwards-backwards,up-down}
	AimAngleOffset={x=-.06000114232301712, y=0, z=-3.460000276565552},	--IronSights	{up-down,Weird,left-right}
	ZoomNoSway=1,			--no sway in zoom mode
	-- NoZoom=1,

	ZoomOverlayFunc=AimModeZoomHUD.DrawHUD,
	Sway = 0,
	---------------------------------------------------

	FireParams ={													-- describes all supported firemodes
	{
		RecoilAnimPos = {x=0, y=.07, z=0},					--IronSights
		RecoilAnimAng = {x=-1.2, y=0, z=0},					--IronSights
		sight_min_recoil=0,	--IronSights
		sight_max_recoil=0,	--IronSights

		-- Make sure that the last parameter in each sound (max-distance) is equal to "whizz_sound_radius"
		whizz_sound_radius=5,
		generic_whizz = 1,
		whizz_probability=-1,	-- 0-1000
		
		FireSounds = {
			"Sounds/Weapons/Pancor/FINAL_PANCOR1_MONO.wav",
			"Sounds/Weapons/Pancor/FINAL_PANCOR2_MONO.wav",
			"Sounds/Weapons/Pancor/FINAL_PANCOR3_MONO.wav",
		},
		FireSoundsStereo = {
			"Sounds/Weapons/pancor/FINAL_PANCOR1_STEREO.wav",
			"Sounds/Weapons/pancor/FINAL_PANCOR2_STEREO.wav",
			"Sounds/Weapons/pancor/FINAL_PANCOR3_STEREO.wav",
		},
		DrySound = "Sounds/Weapons/Pancor/DryFire.wav",
		ReloadSound = "Sounds/Weapons/Pancor/jackrload.wav",

		LightFlash = {
			fRadius = 4,
			vDiffRGBA = {r = 1,g = 1,b = .7,a = 1,},
			vSpecRGBA = {r = 1,g = 1,b = .7,a = 1,},
			fLifeTime = .1,
		},
		
		SmokeEffect = {
			size = {.6,.3,.15,.07,.035,.035},
			size_speed = .7,
			speed = 9,
			focus = 3,
			lifetime = .9,
			sprite = System:LoadTexture("textures\\cloud1.dds"),
			stepsoffset = .3,
			steps = 6,
			gravity = .6,
			AirResistance = 2,
			rotation = 3,
			randomfactor = 50,
		},
		
		MuzzleEffect = {
			size = {.175},
			size_speed = 3.3,
			speed = 0,
			focus = 20,
			lifetime = .03,
			sprite = System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle1.dds"),
			stepsoffset = .05,
			steps = 1,
			gravity = 0,
			AirResistance = 0,
			rotation = 30,
			randomfactor = 10,
		},

		-- remove this if not nedded for current weapon
		MuzzleFlash = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_Pancor_fpv.cgf",
			bone_name = "spitfire",
			lifetime = .1,
		},
		MuzzleFlashTPV = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_Pancor_tpv.cgf",
			bone_name = "weapon_bone",
			lifetime = .05,
		},
		
		SoundMinMaxVol = {255,7,2200},
	},
	},

		SoundEvents={
		--	animname,	frame,	soundfile												---
		{	"reload1",	29,			Sound:LoadSound("Sounds/Weapons/Pancor/pancor_29.wav",0,100)},
		{	"reload1",	45,			Sound:LoadSound("Sounds/Weapons/Pancor/pancor_49.wav",0,100)},
--		{	"swim",		1,			Sound:LoadSound("Sounds/player/water/underwaterswim2.wav",0,255)},
	},
}

CreateBasicWeapon(Shotgun)

---------------------------------------------------------------
--ANIMTABLE
------------------
Shotgun.anim_table={}
--AUTOMATIC FIRE
Shotgun.anim_table[1]={
	idle={
		"Idle11",
		"Idle21",
	},
	reload={
		"Reload1",	
	},
	fidget={
		"fidget11",
	},
	fire={
		"Fire11",
		"Fire21",
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
	--modeactivate={},
}