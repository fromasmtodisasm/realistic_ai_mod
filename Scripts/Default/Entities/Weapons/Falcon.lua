Falcon = {
	-- DESCRIPTION
	-- Default weapon,loud and does not travel far but does the job
	name			= "Falcon",
	object		= "Objects/Weapons/uspis_p226/de_bind.cgf",
	character	= "Objects/Weapons/uspis_p226/de.cgf",

	PlayerSlowDown = 1, -- Коэффициент замедления игрока, когда он держит оружие в руках.
	-- ---------------------------------------------------
	ActivateSound = Sound:LoadSound("Sounds/Weapons/DE/deweapact.wav",0,120),	-- sound to play when this weapon is selected
	-- ---------------------------------------------------

	MaxZoomSteps =  1, -- Один шаг приближения.
	ZoomSteps = {1.0001},--{1.2}, 1.0001 - стоит, чтобы отдаление оружия было плавным.
	ZoomActive = 0,
	AimMode = 1, -- Имеет ли оружие свой рисуемый HUD прицел. 1 - нет, 0 - да.
	-- AimOffset={x=.1990, y=0, z=.065},		--IronSights	{left-right,forwards-backwards,up-down}
	-- AimAngleOffset={x=-1, y=-4, z=-2.4},		--IronSights 	{up-down,Weird,left-right}

	AimOffset={x=.2037000358104706, y=-.0899999737739563, z=.05299995094537735},	--IronSights			Without straightening: {x=.2015, y=0, z=.056},
	AimAngleOffset={x=-1.519999265670776, y=-4.530012130737305, z=-1.410000085830689},	--IronSights				Without straightening:  {x=-.68, y=0, z=-1.45},

	ZoomOverlayFunc=AimModeZoomHUD.DrawHUD,
	ZoomFixedFactor=1,
	ZoomNoSway=1,			--no sway in zoom mode
	Sway = 0, -- 0 - Без раскачки.

	FireParams ={													-- describes all supported firemodes
	{
		type = 2,					-- used for choosing animation - is pistol
		RecoilAnimPos = {x=0, y=.08, z=0},					--IronSights
		RecoilAnimAng = {x=-1, y=0, z=0},					--IronSights
		sight_min_recoil=0,	--IronSights
		sight_max_recoil=0,	--IronSights

		-- Make sure that the last parameter in each sound (max-distance) is equal to "whizz_sound_radius"
		whizz_sound_radius=5,
		generic_whizz = 1,
		whizz_probability=1000,	-- 0-1000
		-- whizz_sound={
			-- Sound:Load3DSound("Sounds/Weapons/bullets/whiz1.wav",SOUND_UNSCALABLE,100,1,8),
			-- Sound:Load3DSound("Sounds/Weapons/bullets/whiz2.wav",SOUND_UNSCALABLE,100,1,8),
			-- Sound:Load3DSound("Sounds/Weapons/bullets/whiz3.wav",SOUND_UNSCALABLE,100,1,8),
			-- Sound:Load3DSound("Sounds/Weapons/bullets/whiz4.wav",SOUND_UNSCALABLE,100,1,8),
		-- },

		-- FireSounds = {
			-- "Sounds/Weapons/DE/FINAL_MONO_DEFIRE1.wav",
			-- "Sounds/Weapons/DE/FINAL_MONO_DEFIRE2.wav",
			-- "Sounds/Weapons/DE/FINAL_MONO_DEFIRE3.wav",
		-- },
		-- FireSoundsStereo = {
			-- "Sounds/Weapons/DE/FINAL_STEREO_DEFIRE1.wav",
			-- "Sounds/Weapons/DE/FINAL_STEREO_DEFIRE2.wav",
			-- "Sounds/Weapons/DE/FINAL_STEREO_DEFIRE3.wav",
		-- },

		FireLoop = {
			"Sounds/Weapons/uspis_p226/p226_fire_3p.wav",
			"Sounds/Weapons/uspis_p226/p226_fire_3p.wav",
			"Sounds/Weapons/uspis_p226/p226_fire_3p.wav",
		},
		FireLoopStereo = {
			"Sounds/Weapons/uspis_p226/p226_fire_1p_outdoor.wav",
			"Sounds/Weapons/uspis_p226/p226_fire_1p_outdoor.wav",
			"Sounds/Weapons/uspis_p226/p226_fire_1p_outdoor.wav",
		},
		FireLoopStereoIndoor = {
			"Sounds/Weapons/uspis_p226/p226_fire_1p_indoor.wav",
			"Sounds/Weapons/uspis_p226/p226_fire_1p_indoor.wav",
			"Sounds/Weapons/uspis_p226/p226_fire_1p_indoor.wav",
		},

		DrySound = "Sounds/Weapons/uspis_p226/trigger_click.wav",

		ShellCases = {
			geometry=System:LoadObject("Objects/Weapons/shells/smgshell.cgf"),
			focus = 1.5,
			color = {1,1,1},
			speed = .1,
			count = 1,
			size = 4,
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
			lifetime = .5,
			sprite = System:LoadTexture("textures\\cloud1.dds"),
			stepsoffset = .3,
			steps = 4,
			gravity = 1.2,
			AirResistance = 3,
			rotation = 3,
			randomfactor = 50,
		},

		MuzzleEffect = {
			size = {.1},--.15,.25,.35,.3,.2},
			size_speed = 4.3,
			speed = 0,
			focus = 20,
			lifetime = .03,
			sprite = System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle1.dds"),
			stepsoffset = .15,
			steps = 1,
			gravity = 0,
			AirResistance = 0,
			rotation = 30,
			randomfactor = 10,
		},

		-- remove this if not nedded for current weapon
		MuzzleFlash = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_DE_fpv.cgf",
			bone_name = "spitfire",
			lifetime = .07,
		},
		MuzzleFlashTPV = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_DE_tpv.cgf",
			bone_name = "weapon_bone",
			lifetime = .05,
		},

		-- trace "moving bullet"
		-- remove this if not nedded for current weapon
		Trace = {
			geometry=System:LoadObject("Objects/Weapons/trail.cgf"),
			focus = 5000,
			color = {1,1,1},
			speed = 395, -- 110
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

		LightFlash = {
			fRadius = 4,
			vDiffRGBA = {r = 1,g = 1,b = .7,a = 1,},
			vSpecRGBA = {r = 1,g = 1,b = .7,a = 1,},
			fLifeTime = .1,
		},

	},
	{
		type = 3,			-- used for choosing animation - is a melee weapon
		-- Сделать режим тихим для ии.
		specific = "Machete", -- Специфичное для режима расстояние на котором ИИ услышит выстрелы.

		FireSounds = {
			"Sounds/Weapons/machete/fire1.wav",
			"Sounds/Weapons/machete/fire2.wav",
			"Sounds/Weapons/machete/fire3.wav",
		},

		SoundMinMaxVol = {100,1,20},
	},
	},

	SoundEvents={
		--	animname,	frame,	soundfile												---
		{	"reload1",	10,			Sound:LoadSound("Sounds/Weapons/DE/DEclipout_10.wav",0,100)},
		{	"reload1",	25,			Sound:LoadSound("Sounds/Weapons/DE/DEclipin_25.wav",0,100)},
		-- {	"reload1",	38,			Sound:LoadSound("Sounds/Weapons/DE/DEclipslap_38.wav",0,100)},
		{	"reload1",	36,			Sound:LoadSound("Sounds/Weapons/uspis_p226/bolt_click.wav",0,100)},
		-- {	"reload1",	0,			Sound:LoadSound("Sounds/Weapons/uspis_p226/l9_reload_1p.wav",0,100)},
--		{	"swim",		1,			Sound:LoadSound("Sounds/player/water/underwaterswim2.wav",0,255)},
	},
}

CreateBasicWeapon(Falcon)

---------------------------------------------------------------
--ANIMTABLE
------------------
Falcon.anim_table={}
--SINGLE SHOT
Falcon.anim_table[1]={
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
		"Fire12",
	},
	melee={
		"Melee"
	},
	swim={
		"swim"
	},
	activate={
		"Activate1"
	},
}

Falcon.anim_table[2]={-- Исключить ИИ.
	idle={
		"Idle11",
		"Idle21",
	},
	fidget={
		"fidget11",
		"fidget21",
	},
	fire={
		"Melee",
	},
	swim={
		"swim"
	},
	activate={
		"Activate1"
	},
}