MutantShotgun = {
	name		= "MutantShotgun",
	object	= "Objects/Weapons/MutantShotgun/MutantShotgun_bind.cgf",
	
	PlayerSlowDown = 0.8,									-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	ActivateSound = Sound:LoadSound("Sounds/Weapons/Pancor/jackwaepact.wav",0,100),	-- sound to play when this weapon is selected
	---------------------------------------------------
	NoZoom=1,
	---------------------------------------------------
	FireParams ={													-- describes all supported firemodes
	{
		HasCrosshair=1,
		AmmoType="Shotgun",
		ammo=40,
		reload_time=0.3, -- default 3.25
		fire_rate=0.7,
		fire_activation=FireActivation_OnPress,
		distance=100,
		damage=20, -- default 30
		damage_drop_per_meter=.080,
		bullet_per_shot=5,
		bullets_per_clip=10,
		FModeActivationTime = 1.0,
		iImpactForceMul = 25, -- 5 bullets divided by 10
		iImpactForceMulFinal = 100, -- 5 bullets divided by 10	
		
		BulletRejectType=BULLET_REJECT_TYPE_SINGLE,
		
		-- make sure that the last parameter in each sound (max-distance) is equal to "whizz_sound_radius"
		whizz_sound_radius=8,
		whizz_probability=350,	-- 0-1000
		whizz_sound={
			Sound:Load3DSound("Sounds/weapons/bullets/whiz1.wav",SOUND_UNSCALABLE,55,1,8),
			Sound:Load3DSound("Sounds/weapons/bullets/whiz2.wav",SOUND_UNSCALABLE,55,1,8),
			Sound:Load3DSound("Sounds/weapons/bullets/whiz3.wav",SOUND_UNSCALABLE,55,1,8),
			Sound:Load3DSound("Sounds/weapons/bullets/whiz4.wav",SOUND_UNSCALABLE,55,1,8),
		},
		
		FireSounds = {
			"Sounds/Weapons/pancor/mutantshotgun.wav",
			
		},
		DrySound = "Sounds/Weapons/Pancor/DryFire.wav",
		ReloadSound = "Sounds/Weapons/Pancor/jackrload.wav",

		LightFlash = {
			fRadius = 5.0,
			vDiffRGBA = { r = 1.0, g = 1.0, b = 0.0, a = 1.0, },
			vSpecRGBA = { r = 0.3, g = 0.3, b = 0.3, a = 1.0, },
			fLifeTime = 0.75,
		},

		ExitEffect = "bullet.mutant_shotgun.a",
		MuzzleFlashTPV = {
				geometry_name = "Objects/Weapons/Muzzle_flash/mf_Pancor_tpv.cgf",
				bone_name = "weapon_bone",
				lifetime = 0.05,
		},

		SoundMinMaxVol = { 225, 5, 2600 },
	},
	},

		SoundEvents={
		--	animname,	frame,	soundfile												---
		{	"reload1",	29,			Sound:LoadSound("Sounds/Weapons/Pancor/pancor_29.wav",0,100)},
		{	"reload1",	45,			Sound:LoadSound("Sounds/Weapons/Pancor/pancor_49.wav",0,100)},
--		{	"swim",		1,			Sound:LoadSound("Sounds/player/water/underwaterswim2.wav",0,255)},
		
	},
}

CreateBasicWeapon(MutantShotgun);

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