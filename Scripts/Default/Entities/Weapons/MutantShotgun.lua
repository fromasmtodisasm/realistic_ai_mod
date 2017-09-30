MutantShotgun = {
	name		= "MutantShotgun",
	object	= "Objects/Weapons/MutantShotgun/MutantShotgun_bind.cgf",
	-- character	= nil,

	PlayerSlowDown = .8,									-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	ActivateSound = Sound:LoadSound("Sounds/Weapons/Pancor/jackwaepact.wav",0,100),	-- sound to play when this weapon is selected
	---------------------------------------------------
	NoZoom=1,
	---------------------------------------------------
	FireParams ={													-- describes all supported firemodes
	{
		-- Make sure that the last parameter in each sound (max-distance) is equal to "whizz_sound_radius"
		whizz_sound_radius=5,
		generic_whizz = 1,
		whizz_probability=-1,	-- 0-1000

		FireSounds = {
			"Sounds/Weapons/pancor/mutantshotgun.wav",

		},
		DrySound = "Sounds/Weapons/Pancor/DryFire.wav",
		ReloadSound = "Sounds/Weapons/Pancor/jackrload.wav",

		LightFlash = {
			fRadius = 4,
			vDiffRGBA = {r = 1, g = 1, b = 0, a = 1,},
			vSpecRGBA = {r = .3, g = .3, b = .3, a = 1,},
			fLifeTime = .1,
		},

		-- ExitEffect = "bullet.mutant_shotgun.a", -- Эффект не понятный какой-то.
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

CreateBasicWeapon(MutantShotgun)

---------------------------------------------------------------
--ANIMTABLE
------------------
MutantShotgun.anim_table={}
--AUTOMATIC FIRE
MutantShotgun.anim_table[1]={
	idle={
		"Idle11",
		"Idle21",
	},
	reload={
		"Reload1",
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