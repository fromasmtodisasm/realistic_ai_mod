NTW20 = {
	name			= "NTW20",
	object		= "Objects/Weapons/NTW20/NTW20_bind.cgf",
	character	= "Objects/Weapons/NTW20/NTW20.cid",
	
	PlayerSlowDown = 1,									-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	ActivateSound = Sound:Load3DSound("Sounds/Weapons/M4/m4weapact.wav"),	-- sound to play when this weapon is selected
	---------------------------------------------------
	AimMode=1,
	
	ZoomNoSway=1,			--no sway in zoom mode
	ZoomOverlayFunc=AimModeZoomHUD.DrawHUD,
	---------------------------------------------------
	ZoomFixedFactor=1,
	FireParams ={													-- describes all supported firemodes
	{
		HasCrosshair=1,
		AmmoType="Unlimited",
		ammo=120,
		min_recoil=0,
		max_recoil=0,
		reload_time=.1, -- default 2.8
		fire_rate=.082,
		distance=1600,
		damage=20, -- default =7
		damage_drop_per_meter=.004,
		bullet_per_shot=1,
		bullets_per_clip=300,
		FModeActivationTime = 2,
		iImpactForceMul = 50,
		iImpactForceMulFinal = 140,
		no_ammo=1,
		
		FireLoop="Sounds/Weapons/mounted/mountedlp.wav",
		TrailOff="Sounds/Weapons/mounted/mountedtail.wav",
		
		DrySound = "Sounds/Weapons/DE/dryfire.wav",
		
		LightFlash = {
			fRadius = 4,
			vDiffRGBA = {r = 1,g = 1,b = 0,a = 1,},
			vSpecRGBA = {r = .3,g = .3,b = .3,a = 1,},
			fLifeTime = .1,
		},
	
		TrailParticle = {
			focus = 1.5,
			color = {1,1,.1},
			speed = .1,
			count = 1,
			size = .005,size_speed=.02,
			gravity=0,
			lifetime=.4,
			tid = System:LoadTexture("alpha_trail3.tga"),
			frames=0,
			color_based_blending = 0,
			dir_vec_scale=100,
			particle_type=4,
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

		-- remove this if not nedded for current weapon
		MuzzleFlash = {
		geometry=System:LoadObject("Objects/Weapons/muzzleflash/muzzleflashbig.cgf"),
			focus = 5000,
			color = {1,1,1},
			speed = 0,
			count = 1,
			size = 1,
			size_speed = 0,
			gravity = {x = 0,y = 0,z = 0},
			lifetime = .002,
			frames = 0,
			color_based_blending = 3,
			particle_type = bor(8,32),
		},

		-- trace "moving bullet"	
		-- remove this if not nedded for current weapon
		Trace = {
			geometry=System:LoadObject("Objects/Weapons/trail.cgf"),
			focus = 5000,
			color = {1,1,1},
			speed = 120,
			count = 1,
			size = 1,
			size_speed = 0,
			gravity = {x = 0,y = 0,z = 0},
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

CreateBasicWeapon(NTW20)

---------------------------------------------------------------
--ANIMTABLE
------------------
NTW20.anim_table={}
--AUTOMATIC FIRE
NTW20.anim_table[1]={
	idle={
		"Idle11",
	},
	--reload={
		--"Reload1",	
	--},
	fire={
		"Fire11",
	},
	--melee={
		--"Fire23",
	--},
	--grenade={
		--"Grenade11",	
	--},
	--swim={
		--"swim",
	--},
	activate={
		"Activate1",
	},
	--modeactivate={},
}