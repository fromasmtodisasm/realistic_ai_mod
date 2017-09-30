MutantMG = {
	name			= "MutantMG",
	
	MaxZoomSteps =  1,
	ZoomSteps = { 1.4 },
	ZoomActive = 0,
	AimMode=1,
	
	ZoomOverlayFunc=AimModeZoomHUD.DrawHUD,
	ZoomFixedFactor=1,
	ZoomNoSway=1, --no sway in zoom mode
	
	PlayerSlowDown = 0.7,									-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	ActivateSound = Sound:Load3DSound("Sounds/Weapons/M4/m4weapact.wav"),	-- sound to play when this weapon is selected
	---------------------------------------------------
	ZoomFixedFactor=1,
	FireParams ={													-- describes all supported firemodes
	{
		HasCrosshair=1,
		AmmoType="Assault",
		ammo=120,
		reload_time= 3.3,
		fire_rate= 0.082,
		distance= 1600,
		damage= 20,
		damage_drop_per_meter= 0.004,
		bullet_per_shot= 1,
		bullets_per_clip=300,
		FModeActivationTime = 2.0,
		iImpactForceMul = 50,
		iImpactForceMulFinal = 140,
		
		-- make sure that the last parameter in each sound (max-distance) is equal to "whizz_sound_radius"
		whizz_sound_radius=6,
		whizz_probability=250,	-- 0-1000
		whizz_sound={
			Sound:Load3DSound("Sounds/weapons/bullets/whiz1.wav",SOUND_UNSCALABLE,100,1,6),
			Sound:Load3DSound("Sounds/weapons/bullets/whiz2.wav",SOUND_UNSCALABLE,100,1,6),
			Sound:Load3DSound("Sounds/weapons/bullets/whiz3.wav",SOUND_UNSCALABLE,100,1,6),
			Sound:Load3DSound("Sounds/weapons/bullets/whiz4.wav",SOUND_UNSCALABLE,100,1,6),
		},
		
		FireLoop="Sounds/Weapons/m4/m4loop.wav",
		FireLoopStereo="Sounds/Weapons/mounted/FINAL_M249_STEREO_LOOP.wav",
		TrailOff="Sounds/Weapons/m4/m4tail.wav",
		TrailOffStereo="Sounds/Weapons/mounted/FINAL_M249_STEREO_TAIL.wav",
		
		DrySound = "Sounds/Weapons/DE/dryfire.wav",
		
		--LightFlash = {
		--	fRadius = 5.0,
		--	vDiffRGBA = { r = 1.0, g = 1.0, b = 0.0, a = 1.0, },
		--	vSpecRGBA = { r = 0.3, g = 0.3, b = 0.3, a = 1.0, },
		--	fLifeTime = 0.75,
		--},
	
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
		MuzzleFlashTPV = {
				geometry_name = "Objects/Weapons/Muzzle_flash/mf_coverrl_tpv.cgf",
				bone_name = "weapon_bone",
				lifetime = 0.05,
		},

		-- trace "moving bullet"	
		-- remove this if not nedded for current weapon
		Trace = {
			--filippo: CGFName do not works
			geometry=System:LoadObject("Objects/Weapons/trail.cgf"),
			--CGFName = "Objects/Weapons/trail.cgf",
			
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

		SoundMinMaxVol = { 175, 15, 300 },

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

CreateBasicWeapon(MutantMG);
---------------------------------------------------------------
--ANIMTABLE
------------------
MutantMG.anim_table={}
--AUTOMATIC FIRE
MutantMG.anim_table[1]={
	idle={
		"Idle11",
		"Idle21",
	},
	reload={
		"Reload1",	
	},
	fire={
		"Fire11",
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