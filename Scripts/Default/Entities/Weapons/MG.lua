MG = {
	name = "MG",

	PlayerSlowDown = 1,									-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	ActivateSound = Sound:Load3DSound("Sounds/Weapons/M4/m4weapact.wav"),	-- sound to play when this weapon is selected
	AimMode=1,

	ZoomNoSway=1,			--no sway in zoom mode
	ZoomOverlayFunc=AimModeZoomHUD.DrawHUD,
	---------------------------------------------------
	ZoomFixedFactor=1,
	FireParams ={													-- describes all supported firemodes
	{
		-- Make sure that the last parameter in each sound (max-distance) is equal to "whizz_sound_radius"
		whizz_sound_radius=5,
		generic_whizz = 1,
		whizz_probability=50,	-- 0-1000

		-- FireLoop="Sounds/Weapons/mounted/vulcan_mono.wav",
		-- FireLoopStereo="Sounds/Weapons/mounted/vulcan.wav",
		-- TrailOff="Sounds/Weapons/mounted/FINAL_M249_MONO_TAIL.wav",
		-- TrailOffStereo="Sounds/Weapons/mounted/FINAL_M249_STEREO_TAIL.wav",

		FireLoop = "Sounds/Weapons/mounted/fire_mono.mp3", -- От третьего лица.
		FireLoopStereo = "Sounds/Weapons/mounted/fire_stereo.mp3", -- От первого лица.
		TrailOff = "Sounds/Weapons/mounted/fire_end_mono.mp3",
		TrailOffStereo = "Sounds/Weapons/mounted/fire_end_stereo.mp3",

		DrySound = "Sounds/Weapons/DE/dryfire.wav",

		LightFlash = {
			fRadius = 7,
			vDiffRGBA = {r = 1,g = 1,b = 0,a = 1,},
			vSpecRGBA = {r = .3,g = .3,b = .3,a = 1,},
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
			size = {.25,.17,.135,.1},
			size_speed = 1.3,
			speed = 20,
			focus = 2,
			lifetime = .15,
			sprite = System:LoadTexture("textures\\cloud1.dds"),
			stepsoffset = .3,
			steps = 4,
			gravity = 1.2,
			AirResistance = 3,
			rotation = 3,
			randomfactor = 50,
		},

		MuzzleEffect = {
			size = {.2},--.07},
			size_speed = 5,
			speed = 0,
			focus = 20,
			lifetime = .03,
			sprite = System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle1.dds"),
			stepsoffset = .07,
			steps = 1, --10,
			gravity = 0,
			AirResistance = 0,
			rotation = 30,
			randomfactor = 25,
			--color = {.5,.5,.5},
		},

		-- remove this if not nedded for current weapon
		MuzzleFlash = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_MG_fpv.cgf",
			bone_name = "spitfire",
			lifetime = .15,
		},
		MuzzleFlashTPV = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_MG_tpv.cgf",
			bone_name = "spitfire",
			lifetime = .05,
		},

		-- trace "moving bullet"
		-- remove this if not nedded for current weapon
		Trace = {
			geometry=System:LoadObject("Objects/Weapons/trail_mounted.cgf"),
			focus = 5000,
			color = {1,1,1},
			speed = 869, -- Не хило так... https://ru.wikipedia.org/wiki/M134_Minigun .
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
		SoundMinMaxVol = {255,20,2200},
	},
	},

	SoundEvents={
	--	animname,	frame,	soundfile
	{	"reload1",	20,			Sound:LoadSound("Sounds/Weapons/M4/M4_20.wav")},
	{	"reload1",	33,			Sound:LoadSound("Sounds/Weapons/M4/M4_33.wav")},
	{	"reload1",	47,			Sound:LoadSound("Sounds/Weapons/M4/M4_47.wav")},
	},
}

CreateBasicWeapon(MG)