Shocker = {
	name			= "Shocker",
	object		= "Objects/Weapons/Shocker/Shocker_bind.cgf",
	character	= "Objects/Weapons/Shocker/Shocker.cgf",
	
	-- factor to slow down the player when he holds that weapon
	PlayerSlowDown = 1,	
	---------------------------------------------------
	NoZoom=1,
	---------------------------------------------------
	-- describes all supported firemodes
	FireParams ={													
	{

		MuzzleFlash = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_shocker_fpv.cgf",
			bone_name = "spitfire1",
			lifetime = .15,
		},

		type = 3,		-- used for choosing animation - is a melee weapon

		FireSounds = {
			"Sounds/Weapons/Shocker/fire1.wav",
			"Sounds/Weapons/Shocker/fire2.wav",
			"Sounds/Weapons/Shocker/fire3.wav",
		},
		DrySound = "Sounds/Weapons/Shocker/dryfire.wav",
		ReloadSound = "Sounds/Weapons/Shocker/reload.wav",
		ExitEffect = "misc.shocker.b",

		SoundMinMaxVol = {100,1,20},
		
		mat_effect = "nothing",
	
		LightFlash = {
			fRadius = 1.5, -- 3
			vDiffRGBA = {r = 1,g = 1,b = .7,a = 1,},
			vSpecRGBA = {r = 1,g = 1,b = .7,a = 1,},
			fLifeTime = .1,
		},
	},
	},

	SoundEvents={
		--	animname,	frame,	soundfile
	},
}

CreateBasicWeapon(Shocker)

---------------------------------------------------------------
--ANIMTABLE
------------------
Shocker.anim_table={}
--AUTOMATIC FIRE
Shocker.anim_table[1]={
	idle={
		"Idle11",
		"Idle21",
	},
	fidget={
		"fidget11",
		"fidget21",
	},
	fire={
		"Fire11",
		"Fire21",
	},
	swim={
		"swim"
	},
	activate={
		"Activate1",
	},
}