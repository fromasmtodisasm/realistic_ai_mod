COVERRL = {
	name		= "COVERRL",
	object	= "Objects/Weapons/coverrl/coverrl_bind.cgf",
	
	TargetLocker=1,
	---------------------------------------------------
	PlayerSlowDown = 1.0,									-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	NoZoom=1,
	
	FireParams ={													-- describes all supported firemodes
	--FIRE MODE 1
	{
		HasCrosshair=1,
		AmmoType="Rocket",
		projectile_class="MutantRocket",
		ammo=130,
		reload_time=0.3, -- default 3.82
		fire_rate=0.3,
		fire_activation=FireActivation_OnPress,
		bullet_per_shot=1,
		bullets_per_clip=100,
		fire_mode_type = FireMode_Projectile,
		FModeActivationTime = 0.0,
		iImpactForceMul = 10,
		
		FireSounds = {
			"Sounds/Weapons/pancor/mutantrocket.wav",
		},
		DrySound = "Sounds/Weapons/AG36/DryFire.wav",
		ExitEffect = "bullet.mutant_rocket.a",
		MuzzleFlashTPV = {
				geometry_name = "Objects/Weapons/Muzzle_flash/mf_coverrl_tpv.cgf",
				bone_name = "weapon_bone",
				lifetime = 0.05,
		},
		
		LightFlash = {
			fRadius = 5.0,
			vDiffRGBA = { r = 1.0, g = 1.0, b = 0.0, a = 1.0, },
			vSpecRGBA = { r = 0.3, g = 0.3, b = 0.3, a = 1.0, },
			fLifeTime = 0.25,
		},

		SoundMinMaxVol = { 255, 5, 2600 },
	},
	},

	SoundEvents={
		--	animname,	frame,	soundfile	
		{	"reload1",	18,			Sound:LoadSound("Sounds/Weapons/RL/rl_18.wav",0,80)},
		{	"reload1",	78,			Sound:LoadSound("Sounds/Weapons/RL/rl_78.wav",0,80)},
	},

	FirstInstance = Sound:Load3DSound("Sounds/Weapons/RL/rocketloop3.wav",SOUND_UNSCALABLE),	
}

CreateBasicWeapon(COVERRL);

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