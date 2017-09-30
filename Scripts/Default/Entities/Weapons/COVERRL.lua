COVERRL = {
	name		= "COVERRL",
	object	= "Objects/Weapons/coverrl/coverrl_bind.cgf",
	
	TargetLocker=1,
	---------------------------------------------------
	PlayerSlowDown = 1,									-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	NoZoom=1,
	
	FireParams ={													-- describes all supported firemodes
	--FIRE MODE 1
	{
		FireSounds = {
			"Sounds/Weapons/pancor/mutantrocket.wav",
		},
		DrySound = "Sounds/Weapons/AG36/DryFire.wav",
		ExitEffect = "bullet.mutant_rocket.a",
		MuzzleFlashTPV = {
				geometry_name = "Objects/Weapons/Muzzle_flash/mf_coverrl_tpv.cgf",
				bone_name = "weapon_bone",
				lifetime = .05,
		},
		
		-- LightFlash = {
			-- fRadius = 4,
			-- vDiffRGBA = {r = 1,g = 1,b = 0,a = 1,},
			-- vSpecRGBA = {r = .3,g = .3,b = .3,a = 1,},
			-- fLifeTime = .25,
		--},

		SoundMinMaxVol = {255,3,200},
	},
	},

	SoundEvents={
		--	animname,	frame,	soundfile	
		{	"reload1",	18,			Sound:LoadSound("Sounds/Weapons/RL/rl_18.wav",0,80)},
		{	"reload1",	78,			Sound:LoadSound("Sounds/Weapons/RL/rl_78.wav",0,80)},
	},

	-- FirstInstance = Sound:Load3DSound("Sounds/Weapons/RL/aa_missile_idle.mp3",SOUND_UNSCALABLE),	
}

CreateBasicWeapon(COVERRL)

---------------------------------------------------------------
--ANIMTABLE
------------------
COVERRL.anim_table={}
COVERRL.anim_table[1]={
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
	swim={
		"swim",
	},
	activate={
		"Activate1",
	},
}