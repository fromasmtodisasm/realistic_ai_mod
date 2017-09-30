NTW20 = {
	name			= "NTW20",
	object		= "Objects/Weapons/NTW20/NTW20_bind.cgf",
	character	= "Objects/Weapons/NTW20/NTW20.cid",
	
	PlayerSlowDown = 1.0,									-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	ActivateSound = Sound:Load3DSound("Sounds/Weapons/M4/m4weapact.wav"),	-- sound to play when this weapon is selected
	---------------------------------------------------
	AimMode=1,
	
	ZoomNoSway=1, 			--no sway in zoom mode
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
		reload_time=0.1, -- default 2.8
		fire_rate=0.082,
		distance=1600,
		damage=20, -- default =7
		damage_drop_per_meter=.004,
		bullet_per_shot=1,
		bullets_per_clip=300,
		FModeActivationTime = 2.0,
		iImpactForceMul = 50,
		iImpactForceMulFinal = 140,
		no_ammo=1,
		
		FireLoop="Sounds/Weapons/mounted/mountedlp.wav",
		TrailOff="Sounds/Weapons/mounted/mountedtail.wav",
		
		DrySound = "Sounds/Weapons/DE/dryfire.wav",
		
		LightFlash = {
			fRadius = 5.0,
			vDiffRGBA = { r = 1.0, g = 1.0, b = 0.0, a = 1.0, },
			vSpecRGBA = { r = 0.3, g = 0.3, b = 0.3, a = 1.0, },
			fLifeTime = 0.75,
		},
	
		TrailParticle = {
			focus = 1.5,
			color = {1,1,0.1},
			speed = 0.1,
			count = 1,
			size = 0.005, size_speed=0.02,
			gravity=0,
			lifetime=0.4,
			tid = System:LoadTexture("alpha_trail3.tga"),
			frames=0,
			color_based_blending = 0,
			dir_vec_scale=100,
			particle_type=4,
		},
		
		ShellCases = {
			geometry=System:LoadObject("Objects/Weapons/shells/rifleshell.cgf"),
			focus = 1.5,
			color = { 1, 1, 1},
			speed = 0.1,
			count = 1,
			size = 3.0, 
			size_speed = 0.0,
			gravity = { x = 0.0, y = 0.0, z = -9.81 },
			lifetime = 5.0,
			frames = 0,
			color_based_blending = 0,
			particle_type = 0,
		},

		-- remove this if not nedded for current weapon
		MuzzleFlash = {
		geometry=System:LoadObject("Objects/Weapons/muzzleflash/muzzleflashbig.cgf"),
			focus = 5000,
			color = { 1, 1, 1},
			speed = 0.0,
			count = 1,
			size = 1.0, 
			size_speed = 0.0,
			gravity = { x = 0.0, y = 0.0, z = 0.0 },
			lifetime = 0.002,
			frames = 0,
			color_based_blending = 3,
			particle_type = bor(8,32),
		},

		-- trace "moving bullet"	
		-- remove this if not nedded for current weapon
		Trace = {
			geometry=System:LoadObject("Objects/Weapons/trail.cgf"),
			focus = 5000,
			color = { 1, 1, 1},
			speed = 120.0,
			count = 1,
			size = 1.0, 
			size_speed = 0.0,
			gravity = { x = 0.0, y = 0.0, z = 0.0 },
			lifetime = 0.04,
			frames = 0,
			color_based_blending = 3,
			particle_type = 0,
		},

		SoundMinMaxVol = { 175, 4, 100000 },
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

CreateBasicWeapon(NTW20);

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