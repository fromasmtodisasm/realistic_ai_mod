function GetScopeTex()
	local cur_r_TexResolution = tonumber( getglobal( "r_TexResolution" ) );
	if( cur_r_TexResolution >= 2 ) then -- lower res texture for low texture quality setting
		return System:LoadImage("Textures/Hud/crosshair/OICW_Scope_low.dds");
	else
		return System:LoadImage("Textures/Hud/crosshair/OICW_Scope.dds");
	end
end


OICW = {
	name			= "OICW",
	object		= "Objects/Weapons/oicw/oicw_bind.cgf",
	character	= "Objects/Weapons/oicw/oicw.cgf",

	-- if the weapon supports zooming then add this...
	ZoomActive = 0,												-- initially always 0
	MaxZoomSteps = 1,
	ZoomSteps = { 3 },
	---------------------------------------------------
	PlayerSlowDown = 0.8,									-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	ActivateSound = Sound:LoadSound("Sounds/Weapons/oicw/oicwact.wav",0,155),	-- sound to play when this weapon is selected
	ZoomNoSway=1,
	---------------------------------------------------
	DrawFlare=1,
	---------------------------------------------------
	FireParams ={													-- describes all supported firemodes
	{
		FModeActivationTime=1,
		HasCrosshair=1,
		AmmoType="Assault",
		reload_time=2.02, -- default 2.55
		fire_rate=0.05,
		distance=1600,
		damage=15, -- Default = 9
		damage_drop_per_meter=.007,
		bullet_per_shot=1,
		bullets_per_clip=40,
		iImpactForceMul = 20,
		iImpactForceMulFinal = 100,
		fire_activation=bor(FireActivation_OnPress,FireActivation_OnHold),

		-- recoil values
		min_recoil=0,
		max_recoil=0.8,	-- its only a small recoil as more people seem to like it that way

		BulletRejectType=BULLET_REJECT_TYPE_RAPID,

		-- make sure that the last parameter in each sound (max-distance) is equal to "whizz_sound_radius"
		whizz_sound_radius=8,
		whizz_probability=250,	-- 0-1000
		whizz_sound={
			Sound:Load3DSound("Sounds/weapons/bullets/whiz1.wav",SOUND_UNSCALABLE,100,1,8),
			Sound:Load3DSound("Sounds/weapons/bullets/whiz2.wav",SOUND_UNSCALABLE,100,1,8),
			Sound:Load3DSound("Sounds/weapons/bullets/whiz3.wav",SOUND_UNSCALABLE,100,1,8),
			Sound:Load3DSound("Sounds/weapons/bullets/whiz4.wav",SOUND_UNSCALABLE,100,1,8),
		},

		FireLoop="Sounds/Weapons/oicw/FINAL_OICW_MONO_LOOP.wav",
		FireLoopStereo="Sounds/Weapons/oicw/FINAL_OICW_STEREO_LOOP.wav",
		TrailOff="Sounds/Weapons/oicw/FINAL_OICW_MONO_TAIL.wav",
		TrailOffStereo="Sounds/Weapons/oicw/FINAL_OICW_STEREO_TAIL.wav",
		DrySound = "Sounds/Weapons/oicw/DryFire.wav",

		ScopeTexId = GetScopeTex(),

		LightFlash = {
			fRadius = 3.0,
			vDiffRGBA = { r = 1.0, g = 1.0, b = 0.7, a = 1.0, },
			vSpecRGBA = { r = 1.0, g = 1.0, b = 0.7, a = 1.0, },
			fLifeTime = 0.1,
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

		SmokeEffect = {
			size = {0.15,0.07,0.035,0.01},
			size_speed = 1.3,
			speed = 9.0,
			focus = 3,
			lifetime = 0.25,
			sprite = System:LoadTexture("textures\\cloud1.dds"),
			stepsoffset = 0.3,
			steps = 4,
			gravity = 1.2,
			AirResistance = 3,
			rotation = 3,
			randomfactor = 50,
		},

		MuzzleEffect = {

			size = {0.175},
			size_speed = 4.3,
			speed = 0.0,
			focus = 20,
			lifetime = 0.03,

			sprite = {
					{
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzleoicw.dds"),
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzleoicw2.dds")
					}
				},

			stepsoffset = 0.05,
			steps = 1,
			gravity = 0.0,
			AirResistance = 0,
			rotation = 3,
			randomfactor = 20,
			color = {0.9,0.9,0.9},
		},

		-- remove this if not nedded for current weapon
		MuzzleFlash = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_OICW_fpv.cgf",
			bone_name = "spitfire",
			lifetime = 0.125,
		},
		MuzzleFlashTPV = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_OICW_tpv.cgf",
			bone_name = "weapon_bone",
			lifetime = 0.05,
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
			bouncyness = 0,
		},

		SoundMinMaxVol = { 255, 4, 2600 },
	},
	{
		no_zoom = 1,
		FModeActivationTime=1,
		HasCrosshair=1,
		AmmoType="OICWGrenade",
		projectile_class="OICWGrenade",
		ammo=500,
		reload_time=2.5,
		fire_rate=1.0,
		fire_activation=FireActivation_OnPress,
		bullet_per_shot=1,
		bullets_per_clip=5,

		FireSounds = {
			"Sounds/Weapons/OICW/FINAL_OICW_MONO_GRENADE.wav",
			"Sounds/Weapons/OICW/FINAL_OICW_MONO_GRENADE.wav",
			"Sounds/Weapons/OICW/FINAL_OICW_MONO_GRENADE.wav",
		},
		FireSoundsStereo = {
			"Sounds/Weapons/OICW/FINAL_OICW_STEREO_GRENADE.wav",
			"Sounds/Weapons/OICW/FINAL_OICW_STEREO_GRENADE.wav",
			"Sounds/Weapons/OICW/FINAL_OICW_STEREO_GRENADE.wav",
		},
		DrySound = "Sounds/Weapons/AG36/DryFire.wav",

		LightFlash = {
			fRadius = 3.0,
			vDiffRGBA = { r = 1.0, g = 1.0, b = 0.7, a = 1.0, },
			vSpecRGBA = { r = 1.0, g = 1.0, b = 0.7, a = 1.0, },
			fLifeTime = 0.1,
		},

		SoundMinMaxVol = { 255, 4, 2600 },
	}

	},

		SoundEvents={
		--	animname,	frame,	soundfile												---
		{	"reload1",	14,			Sound:LoadSound("Sounds/Weapons/OICW/oicwB_14.wav",0,155)},
		{	"reload1",	32,			Sound:LoadSound("Sounds/Weapons/OICW/oicwB_32.wav",0,155)},
		{	"reload2",	32,			Sound:LoadSound("Sounds/Weapons/OICW/oicwG_32.wav",0,155)},
		{	"reload2",	48,			Sound:LoadSound("Sounds/Weapons/OICW/oicwG_48.wav",0,155)},
--		{	"swim",		1,				Sound:LoadSound("Sounds/player/water/underwaterswim2.wav",0,255)},

	},
}

CreateBasicWeapon(OICW);

---------------------------------------------------------------
--ANIMTABLE
------------------
OICW.anim_table={}
--AUTOMATIC FIRE
OICW.anim_table[1]={
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

--AUTOMATIC FIRE
OICW.anim_table[2]={
	idle={
		"Idle21",
		"Idle22",
	},
	reload={
		"Reload2",
	},
	fire={
		"Fire12",
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