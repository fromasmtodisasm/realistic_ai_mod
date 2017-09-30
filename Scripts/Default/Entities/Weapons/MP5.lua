MP5 = {
	-- DESCRIPTION:
	-- No Single shot
	-- Small recoil,does not travel far (300m),quiet
	-- good stealth gun
	name			= "MP5",
	object		= "Objects/Weapons/MP5/MP5_bind.cgf",
	character	= "Objects/Weapons/MP5/MP5.cgf",

	---------------------------------------------------
	PlayerSlowDown = .85,			-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	-- ActivateSound = Sound:LoadSound("Sounds/Weapons/usrif_m203/deploy_1p.mp3",0,100),	-- sound to play when this weapon is selected
	ActivateSound = Sound:LoadSound("Sounds/Weapons/MP5/mp5weapact.wav",0,100),	-- sound to play when this weapon is selected
	---------------------------------------------------

	-- if the weapon supports zooming then enter this...
	MaxZoomSteps =  1,
	ZoomSteps = {1.0001},-- 1.4
	ZoomActive = 0,
	AimMode=1,
	AimOffset={x=.1333988457918167, y=-.05000001192092896, z=.03859970718622208},	--IronSights
	AimAngleOffset={x=-1.779999017715454, y=0, z=-.1100011318922043},	--IronSights

	ZoomOverlayFunc=AimModeZoomHUD.DrawHUD,
	ZoomFixedFactor=1,
	ZoomNoSway=1, --no sway in zoom mode
	Sway = 0,
	---------------------------------------------------

	FireParams = {													-- describes all supported 	firemodes
	{
		RecoilAnimPos = {x=0, y=.05, z=0},					--IronSights
		RecoilAnimAng = {x=-.4, y=0, z=0},					--IronSights

		-- Make sure that the last parameter in each sound (max-distance) is equal to "whizz_sound_radius"
		whizz_sound_radius=5,
		generic_whizz = 1,
		whizz_probability=1000,	-- 0-1000

		sight_min_recoil=0,	--IronSights
		sight_max_recoil=0,	--IronSights

		FireLoop="Sounds/Weapons/mp5/FINAL_MP5_MONO_LOOP.wav",
		FireLoopStereo="Sounds/Weapons/mp5/FINAL_MP5_STEREO_LOOP.wav",
		TrailOff="Sounds/Weapons/mp5/FINAL_MP5_MONO_TAIL.wav",
		TrailOffStereo="Sounds/Weapons/mp5/FINAL_MP5_STEREO_TAIL.wav",
		DrySound ="Sounds/Weapons/MP5/DryFire.wav",

		SmokeEffect = {
			size = {.15,.07,.035,.01},
			size_speed = 1.3,
			speed = 3,
			focus = 2,
			lifetime = .3,
			sprite = System:LoadTexture("textures\\cloud1.dds"),
			stepsoffset = .3,
			steps = 4,
			gravity = 1.2,
			AirResistance = 3,
			rotation = 3,
			randomfactor = 50,
		},

		ShellCases = {
			--filippo:mp5 do not use rifle shells :)
			geometry=System:LoadObject("Objects/Weapons/shells/smgshell.cgf"),
			--geometry=System:LoadObject("Objects/Weapons/shells/rifleshell.cgf"),

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

		-- trace "moving bullet"
		Trace = {
			geometry=System:LoadObject("Objects/Weapons/trail.cgf"),
			focus = 5000,
			color = {1,1,1},
			speed = 400, -- 120
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

		SoundMinMaxVol = {100,1,100},

		-- LightFlash = {
			-- fRadius = 4,
			-- vDiffRGBA = {r = 1,g = 1,b = .7,a = 1,},
			-- vSpecRGBA = {r = 1,g = 1,b = .7,a = 1,},
			-- fLifeTime = .1,
		--},

		},
	--SINGLE SHOT--------------------------------
		{
		RecoilAnimPos = {x=0, y=.04, z=0},					--IronSights
		RecoilAnimAng = {x=-.4, y=0, z=0},					--IronSights

		-- Make sure that the last parameter in each sound (max-distance) is equal to "whizz_sound_radius"
		whizz_sound_radius=5,
		generic_whizz = 1,
		whizz_probability=1000,

		sight_min_recoil=0,	--IronSights
		sight_max_recoil=0,	--IronSights

		FireSounds = {"Sounds/Weapons/mp5/FINAL_MP5_MONO_SINGLE.wav"},
		FireSoundsStereo = {"Sounds/Weapons/mp5/FINAL_MP5_STEREO_SINGLE.wav"},
		DrySound = "Sounds/Weapons/DE/dryfire.wav",

		-- LightFlash = {
			-- fRadius = 4,
			-- vDiffRGBA = {r = 1,g = 1,b = .7,a = 1,},
			-- vSpecRGBA = {r = 1,g = 1,b = .7,a = 1,},
			-- fLifeTime = .1,
		--},

		SmokeEffect = {
			size = {.15,.07,.035,.01},
			size_speed = 1.3,
			speed = 3,
			focus = 2,
			lifetime = .3,
			sprite = System:LoadTexture("textures\\cloud1.dds"),
			stepsoffset = .3,
			steps = 4,
			gravity = 1.2,
			AirResistance = 3,
			rotation = 3,
			randomfactor = 50,
		},

		ShellCases = {
			--filippo: CGFName do not works
			geometry=System:LoadObject("Objects/Weapons/shells/smgshell.cgf"),
			--CGFName = "Objects/Weapons/shells/rifleshell.cgf",

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

		-- trace "moving bullet"
		Trace = {
			geometry=System:LoadObject("Objects/Weapons/trail.cgf"),
			focus = 5000,
			color = {1,1,1},
			speed = 400, -- 120
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

		SoundMinMaxVol = {100,1,100},
		},

	},

		SoundEvents={
		--	animname,	frame,	soundfil
		{	"reload1",	17,			Sound:LoadSound("Sounds/Weapons/MP5/mp5_18.wav",0,100)},
		{	"reload1",	32,			Sound:LoadSound("Sounds/Weapons/MP5/mp5_41.wav",0,100)},
		{	"reload1",	48,			Sound:LoadSound("Sounds/Weapons/MP5/mp5_57.wav",0,100)},
--		{	"swim",		1,			Sound:LoadSound("Sounds/player/water/underwaterswim2.wav",0,255)},
	},
}

CreateBasicWeapon(MP5)

---------------------------------------------------------------
--ANIMTABLE
------------------
MP5.anim_table={}
--AUTOMATIC FIRE
MP5.anim_table[1]={
	idle={
		"Idle11",
		"Idle21",
	},
	reload={
		"Reload1",
	},
	fidget={
		"fidget11",
		"fidget21",
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
}

--SINGLE FIRE
MP5.anim_table[2]=MP5.anim_table[1]
