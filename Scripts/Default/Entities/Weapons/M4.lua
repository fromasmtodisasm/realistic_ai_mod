M4 = {
	-- DESCRIPTION:
	-- Single shot is powerful,with a more recoil
	-- Auto is not as powerful,less recoil and does not travel as far
	-- Its a louder than the MP-5 but also more powerful
	-- good all round gun

	name		= "M4",
	object		= "Objects/Weapons/usrif_m4iron/M4_bind.cgf", -- От третьего лица.
	character	= "Objects/Weapons/usrif_m4iron/M4.cgf",

	PlayerSlowDown = .9,		-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	-- ActivateSound = Sound:LoadSound("Sounds/Weapons/usrif_m4/m4_deploy.wav",0,100),	-- sound to play when this weapon is selected
	ActivateSound = Sound:LoadSound("Sounds/Weapons/M4/m4weapact.wav",0,100),	-- sound to play when this weapon is selected
	---------------------------------------------------

	MaxZoomSteps =  1,
	ZoomSteps = {1.0001},--1.8
	ZoomActive = 0,
	AimMode=1,
	-- Первое - уменьшение, второе - увеличение.
	-- AimOffset={x=.15826, y=0, z=.056},				--IronSights			{left-right,forwards-backwards,up-down}
	-- AimAngleOffset={x=-1.5, y=0, z=-3.0064},			--IronSights			{up-down,Weird,left-right}
	
	AimOffset={x=.1610988527536392, y=-.01900001242756844, z=.04719953238964081},	--IronSights			{left-right,forwards-backwards,up-down}
	AimAngleOffset={x=1.159999966621399, y=0, z=-2.829990863800049},	--IronSights			{up-down,Weird,left-right}
	Correction=0,

	ZoomOverlayFunc=AimModeZoomHUD.DrawHUD,
	ZoomFixedFactor=1,
	ZoomNoSway=1,			--no sway in zoom mode
	Sway = 0,

	FireParams ={													-- describes all supported firemodes
	{
		RecoilAnimPos = {x=0, y=.04, z=0},					--IronSights
		RecoilAnimAng = {x=-.3, y=0, z=0},					--IronSights

		-- Make sure that the last parameter in each sound (max-distance) is equal to "whizz_sound_radius"
		whizz_sound_radius=5,
		generic_whizz = 1,
		whizz_sound_radius=5,
		whizz_probability=1000,	-- 0-1000

		-- FireLoop = "Sounds/Weapons/usrif_m4/m4_fire_02.wav",
		FireLoop = { -- Пока таблицы только для пушек с цельными звуками стрельбы и её оканчания.
			"Sounds/Weapons/usrif_m4/m4_fire.wav",
			"Sounds/Weapons/usrif_m4/m4_fire_02.wav",
			"Sounds/Weapons/usrif_m4/m4_fire_03.wav",
		},
		-- FireLoopStereo = "Sounds/Weapons/usrif_m4/m4_fire_outdoor.wav",
		FireLoopStereo = { -- Лучше делать именно в табличном виде и копировать один файл по несколько раз, чтобы не выдавало ошибку об ограничении в 15'ти прикреплённых к игроку, одного и того же звука.
			"Sounds/Weapons/usrif_m4/m4_fire_outdoor.wav",
			"Sounds/Weapons/usrif_m4/m4_fire_outdoor.wav",
			"Sounds/Weapons/usrif_m4/m4_fire_outdoor.wav",
		},
		FireLoopStereoIndoor = {
			"Sounds/Weapons/usrif_m4/m4_fire_indoor.wav",
			"Sounds/Weapons/usrif_m4/m4_fire_indoor.wav",
			"Sounds/Weapons/usrif_m4/m4_fire_indoor.wav",
		},
		DrySound = "Sounds/Weapons/usrif_m4/ar15_trigger.wav",
		FireModeChangeSound = "Sounds/Weapons/usrif_m4/m4_fire_rate_switch.wav",

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

			size = {.125,.0015},--.15,.25,.35,.3,.2},
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
			-- geometry_name = "Objects/Weapons/Muzzle_flash/mf_m4_fpv.cgf",
			-- bone_name = "spitfire",
			-- lifetime = .1,
			geometry_name = "Objects/Weapons/MUZZLEFLASH/muzzleflash.cgf",				--IronSights
			bone_name = "spitfire",
			lifetime = .02,															--IronSights
		},
		MuzzleFlashTPV = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_m4_tpv.cgf",
			bone_name = "weapon_bone",
			lifetime = .05,
		},

		-- trace "moving bullet"
		-- remove this if not nedded for current weapon
		Trace = {
			geometry=System:LoadObject("Objects/Weapons/trail.cgf"),
			focus = 5000,
			color = {1,1,1},
			speed = 750, -- 130, 750 - начальная (у ак 700).
			count = 1,
			size = 1,
			size_speed = 0,
			gravity = {x = 0,y = 0,z = 0},
			lifetime = .04,
			frames = 0,
			color_based_blending = 3,
			particle_type = bor(8,32),
			bouncyness = 0,
		},

		SoundMinMaxVol = {255,7,2200},
	},
	--SINGLE SHOT--------------------------------
	{
		RecoilAnimPos = {x=0, y=.05, z=0},					--IronSights
		RecoilAnimAng = {x=-.4, y=0, z=0},					--IronSights

		-- Make sure that the last parameter in each sound (max-distance) is equal to "whizz_sound_radius"
		whizz_sound_radius=5,
		generic_whizz = 1,
		whizz_probability=1000,	-- 0-1000

		FireLoop = {
			"Sounds/Weapons/usrif_m4/m4_fire.wav",
			"Sounds/Weapons/usrif_m4/m4_fire_02.wav",
			"Sounds/Weapons/usrif_m4/m4_fire_03.wav",
		},
		FireLoopStereo = { -- Здесь не обязательно копировать, это одиночные. Можно и в старой форме записи держать.
			"Sounds/Weapons/usrif_m4/m4_fire_outdoor.wav",
		},
		FireLoopStereoIndoor = {
			"Sounds/Weapons/usrif_m4/m4_fire_indoor.wav",
		},
		DrySound = "Sounds/Weapons/usrif_m4/ar15_trigger.wav",
		FireModeChangeSound = "Sounds/Weapons/usrif_m4/m4_fire_rate_switch.wav",

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

		LightFlash = {
			fRadius = 4,
			vDiffRGBA = {r = 1,g = 1,b = .7,a = 1,},
			vSpecRGBA = {r = 1,g = 1,b = .7,a = 1,},
			fLifeTime = .1,
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

			size = {.125,.0015},--.15,.25,.35,.3,.2},
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

		MuzzleFlash = {
			-- geometry_name = "Objects/Weapons/Muzzle_flash/mf_m4_fpv.cgf",
			-- bone_name = "spitfire",
			-- lifetime = .1,
			geometry_name = "Objects/Weapons/MUZZLEFLASH/muzzleflash.cgf",				--IronSights
			bone_name = "spitfire",
			lifetime = .03,															--IronSights
		},
		MuzzleFlashTPV = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_m4_tpv.cgf",
			bone_name = "weapon_bone",
			lifetime = .05,
		},

		-- trace "moving bullet"
		-- remove this if not nedded for current weapon
		Trace = {
			CGFName = "Objects/Weapons/trail.cgf",
			focus = 5000,
			color = {1,1,1},
			speed = 750, -- 130
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
		{	"reload1",	20,			Sound:LoadSound("Sounds/Weapons/M4/M4_20.wav",0,100)},
		{	"reload1",	33,			Sound:LoadSound("Sounds/Weapons/M4/M4_33.wav",0,100)},
		{	"reload1",	58,			Sound:LoadSound("Sounds/Weapons/M4/M4_47.wav",0,100)},
		{	"reload2",	20,			Sound:LoadSound("Sounds/Weapons/M4/M4_20.wav",0,100)},
		{	"reload2",	33,			Sound:LoadSound("Sounds/Weapons/M4/M4_33.wav",0,100)},
		{	"reload2",	47,			Sound:LoadSound("Sounds/Weapons/M4/M4_47.wav",0,100)},
--		{	"swim",		1,			Sound:LoadSound("Sounds/player/water/underwaterswim2.wav",0,255)},
	},
}

CreateBasicWeapon(M4)

---------------------------------------------------------------
--ANIMTABLE
------------------
--AUTOMATIC FIRE
M4.anim_table={}
M4.anim_table[1]={
	idle={
		"Idle11",
		"Idle12",
	},
	reload={
		"Reload1",
		"Reload2",
	},
	fidget={--
		"fidget11",
	},
	fire={
		"Fire11",
		"Fire21",
		-- "Fire23",
	},
	swim={
		"swim"
	},
	activate={
		"Activate1"
	},
}
------------------
--SINGLE SHOT
M4.anim_table[2]=M4.anim_table[1]