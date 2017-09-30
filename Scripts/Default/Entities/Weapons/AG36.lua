function GetScopeTex()
	local cur_r_TexResolution = tonumber(getglobal("r_TexResolution"))
	if (cur_r_TexResolution >= 2) then -- lower res texture for low texture quality setting
		return System:LoadImage("Textures/Hud/crosshair/g36_zoom_low.tga")
	else
		return System:LoadImage("Textures/Hud/crosshair/g36_zoom.tga")
	end
end


AG36SP = {
	name			= "AG36",
	object		= "Objects/Weapons/gerrif_g36ugl/ag36_bind.cgf",
	character	= "Objects/Weapons/gerrif_g36ugl/ag36.cgf",

	-- if the weapon supports zooming then enter this...
	ZoomActive = 0,												-- initially always 0
	MaxZoomSteps = 2,
	ZoomSteps = {2,4},
	AimMode = 2,											--IronSights
	AimOffset={x=.175, y=.2, z=.05},						--IronSights
	---------------------------------------------------
	PlayerSlowDown = .8,									-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	-- ActivateSound = Sound:LoadSound("Sounds/Weapons/usrif_g36c/g36c_deploy_1p.mp3",0,150),	-- sound to play when this weapon is selected
	ActivateSound = Sound:LoadSound("Sounds/Weapons/AG36/agweapact.wav",0,150),	-- sound to play when this weapon is selected
	---------------------------------------------------
	Sway=2,
	---------------------------------------------------
	DrawFlare=1,
	---------------------------------------------------

	FireParams ={													-- describes all supported 	firemodes
	{
		-- Make sure that the last parameter in each sound (max-distance) is equal to "whizz_sound_radius"
		whizz_sound_radius=5,
		generic_whizz = 1,
		whizz_probability=1000,	-- 0-1000

		FireLoop = {
			"Sounds/Weapons/gerrif_g36/g36_3p.wav",
			"Sounds/Weapons/gerrif_g36/g36_3p.wav",
			"Sounds/Weapons/gerrif_g36/g36_3p.wav",
		},
		FireLoopStereo = {
			"Sounds/Weapons/gerrif_g36/g36_1p.wav",
			"Sounds/Weapons/gerrif_g36/g36_1p.wav",
			"Sounds/Weapons/gerrif_g36/g36_1p.wav",
		},
		FireLoopStereoIndoor = {
			"Sounds/Weapons/gerrif_g36/g36_indoor_1p.wav",
			"Sounds/Weapons/gerrif_g36/g36_indoor_1p.wav",
			"Sounds/Weapons/gerrif_g36/g36_indoor_1p.wav",
		},
		DrySound = "Sounds/Weapons/gerrif_g36/g36_trigger.wav",
		FireModeChangeSound = "Sounds/Weapons/usrif_g36c/g36c_fire_rate_switch.wav",

		ScopeTexId = GetScopeTex(),

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

		SmokeEffect = {
			size = {.15,.07,.035,.01},
			size_speed = 1.3,
			speed = 9,
			focus = 3,
			lifetime = .25,
			sprite = System:LoadTexture("textures\\cloud1.dds"),
			stepsoffset = .3,
			steps = 4,
			gravity = 1.2,
			AirResistance = 3,
			rotation = 3,
			randomfactor = 50,
		},

		MuzzleEffect = {
			size = {.175,.01,.02,.03,.015},--.15,.25,.35,.3,.2},
			size_speed = 3.3,
			speed = 0,
			focus = 20,
			lifetime = .03,
			sprite = {
					{
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzlehoriz.dds")
					}
					,
					{
						--System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle4.dds"),
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle5.dds"),
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle6.dds"),
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle7.dds"),
					}
				},
			stepsoffset = .1,
			steps = 5,
			gravity = 0,
			AirResistance = 0,
			rotation = 3,
			randomfactor = 60,
			color = {.5,.5,.5},
		},

		-- remove this if not nedded for current weapon
		MuzzleFlash = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_ag36_fpv.cgf",
			bone_name = "spitfire",
			lifetime = .15,
		},
		MuzzleFlashTPV = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_ag36_tpv.cgf",
			bone_name = "weapon_bone",
			lifetime = .05,
		},

		-- trace "moving bullet"
		-- remove this if not nedded for current weapon
		Trace = {
			geometry=System:LoadObject("Objects/Weapons/trail.cgf"),
			focus = 5000,
			color = {1,1,1},
			speed = 920, -- 120
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

		LightFlash = {
			fRadius = 4,
			vDiffRGBA = {r = 1,g = 1,b = .7,a = 1,},
			vSpecRGBA = {r = 1,g = 1,b = .7,a = 1,},
			fLifeTime = .1,
		},
	},
--GRENADE-----------------------------
	{
		FireLoop = {
			"Sounds/Weapons/usrgl_m203/m203_fire_3p.wav",
		},
		FireLoopStereo = {
			"Sounds/Weapons/usrgl_m203/m203_fire_1p.wav",
		},
		FireLoopStereoIndoor = {
			"Sounds/Weapons/usrgl_m203/m203_fire_1p_flare.wav", -- Якобы внутри.
		},
		DrySound = "Sounds/Weapons/gerrif_g36/g36_trigger.wav",
		FireModeChangeSound = "Sounds/Weapons/usrif_g36c/g36c_fire_rate_switch.wav",

		SoundMinMaxVol = {255,1,100},

		LightFlash = {
			fRadius = 4,
			vDiffRGBA = {r = 1,g = 1,b = .7,a = 1,},
			vSpecRGBA = {r = 1,g = 1,b = .7,a = 1,},
			fLifeTime = .1,
		},
	},
	},

		SoundEvents={
		--	animname,	frame,	soundfil{	"reload1",	15,			Sound.LoadSound("Sounds/Weapons/ag36/ag36b_15.wav")},
		{	"reload1",	23,			Sound:LoadSound("Sounds/Weapons/ag36/Ag36b_23.wav",0,150)},
		{	"reload1",	38,			Sound:LoadSound("Sounds/Weapons/ag36/Ag36b_38.wav",0,150)},
		{	"reload1",	54,			Sound:LoadSound("Sounds/Weapons/ag36/Ag36b_54.wav",0,150)},
		-- {	"reload1",	0,			Sound:LoadSound("Sounds/Weapons/gerrif_g36/g36_reload_3p.mp3",0,150)}, -- Укоротить.
		{	"reload2",	0,			Sound:LoadSound("Sounds/Weapons/usrif_m203/m203_torifle_deploy_1p.wav",0,150)},
		-- {	"reload2",	37,			Sound:LoadSound("Sounds/Weapons/ag36/ag36g_37.wav",0,150)},
--		{	"swim",		1,			Sound:LoadSound("Sounds/player/water/underwaterswim2.wav",0,255)},

	},
}


-- AG36MP = {
	-- name			= "AG36",
	-- object		= "Objects/Weapons/gerrif_g36ugl/ag36_bind.cgf",
	-- character	= "Objects/Weapons/gerrif_g36ugl/ag36.cgf",

	-- fireCanceled = 0,

	-- -- if the weapon supports zooming then enter this...
	-- ZoomActive = 0,												-- initially always 0
	-- MaxZoomSteps = 2,
	-- ZoomSteps = {2,4},
	-- AimMode = 2,											--IronSights
	-- AimOffset={x=.175, y=.2, z=.05},						--IronSights
	-- ---------------------------------------------------
	-- PlayerSlowDown = .75,									-- factor to slow down the player when he holds that weapon
	-- ---------------------------------------------------
	-- ActivateSound = Sound:LoadSound("Sounds/Weapons/AG36/agweapact.wav",0,150),	-- sound to play when this weapon is selected
	-- ---------------------------------------------------
	-- ZoomNoSway=1,
	-- ---------------------------------------------------
	-- DrawFlare=1,
	-- ---------------------------------------------------
	-- FireParams ={													-- describes all supported firemodes
	-- {
		-- FModeActivationTime = 1,

		-- HasCrosshair=1,
		-- AmmoType="Assault",
		-- reload_time= 2.6,
		-- fire_rate= .1,
		-- distance= 1200,
		-- damage= 12,
		-- damage_drop_per_meter = .011,
		-- bullet_per_shot= 1,
		-- bullets_per_clip=30,
		-- iImpactForceMul = 20,
		-- iImpactForceMulFinal = 100,
		-- fire_activation=bor(FireActivation_OnPress,FireActivation_OnHold),

		-- -- recoil values
		-- min_recoil=0,
		-- max_recoil=.8,	-- its only a small recoil as more people seem to like it that way

		-- BulletRejectType=BULLET_REJECT_TYPE_RAPID,

		-- -- make sure that the last parameter in each sound (max-distance) is equal to "whizz_sound_radius"
		-- whizz_sound_radius=5,
		-- whizz_probability=1000,	-- 0-1000
		-- whizz_sound={
			-- Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_01.mp3",SOUND_UNSCALABLE,255,2,10,129),
			-- Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_02.mp3",SOUND_UNSCALABLE,255,2,10,129),
			-- Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_03.mp3",SOUND_UNSCALABLE,255,2,10,129),
			-- Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_04.mp3",SOUND_UNSCALABLE,255,2,10,129),
			-- Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_05.mp3",SOUND_UNSCALABLE,255,2,10,129),
			-- Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_06.mp3",SOUND_UNSCALABLE,255,2,10,129),
			-- Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_07.mp3",SOUND_UNSCALABLE,255,2,10,129),
			-- Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_08.mp3",SOUND_UNSCALABLE,255,2,10,129),
			-- Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_09.mp3",SOUND_UNSCALABLE,255,2,10,129),
			-- Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_10.mp3",SOUND_UNSCALABLE,255,2,10,129),
			-- Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_11.mp3",SOUND_UNSCALABLE,255,2,10,129),
			-- Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_12.mp3",SOUND_UNSCALABLE,255,2,10,129),
			-- Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_13.mp3",SOUND_UNSCALABLE,255,2,10,129),
			-- Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_14.mp3",SOUND_UNSCALABLE,255,2,10,129),
			-- Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_15.mp3",SOUND_UNSCALABLE,255,2,10,129),
			-- Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_16.mp3",SOUND_UNSCALABLE,255,2,10,129),
			-- Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_17.mp3",SOUND_UNSCALABLE,255,2,10,129),
			-- Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_18.mp3",SOUND_UNSCALABLE,255,2,10,129),
			-- Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_19.mp3",SOUND_UNSCALABLE,255,2,10,129),
			-- Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_20.mp3",SOUND_UNSCALABLE,255,2,10,129),
			-- Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_21.mp3",SOUND_UNSCALABLE,255,2,10,129),
			-- Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_22.mp3",SOUND_UNSCALABLE,255,2,10,129),
			-- Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_23.mp3",SOUND_UNSCALABLE,255,2,10,129),
		-- },

		-- FireLoop="Sounds/Weapons/ag36/FINAL_AG36_MONO_LOOP.wav",
		-- FireLoopStereo="Sounds/Weapons/ag36/FINAL_AG36_STEREO_LOOP.wav",
		-- TrailOff="Sounds/Weapons/ag36/FINAL_AG36_MONO_TAIL.wav",
		-- TrailOffStereo="Sounds/Weapons/ag36/FINAL_AG36_STEREO_TAIL.wav",
		-- DrySound = "Sounds/Weapons/AG36/DryFire.wav",

		-- ScopeTexId = GetScopeTex(),

		-- ShellCases = {
			-- geometry=System:LoadObject("Objects/Weapons/shells/rifleshell.cgf"),
			-- focus = 1.5,
			-- color = {1,1,1},
			-- speed = .1,
			-- count = 1,
			-- size = 3,
			-- size_speed = 0,
			-- gravity = {x = 0,y = 0,z = -9.81},
			-- lifetime = 5,
			-- frames = 0,
			-- color_based_blending = 0,
			-- particle_type = 0,
		-- },

		-- SmokeEffect = {
			-- size = {.15,.07,.035,.01},
			-- size_speed = 1.3,
			-- speed = 9,
			-- focus = 3,
			-- lifetime = .25,
			-- sprite = System:LoadTexture("textures\\cloud1.dds"),
			-- stepsoffset = .3,
			-- steps = 4,
			-- gravity = 1.2,
			-- AirResistance = 3,
			-- rotation = 3,
			-- randomfactor = 50,
		-- },

		-- MuzzleEffect = {
			-- size = {.175,.01,.02,.03,.015},--.15,.25,.35,.3,.2},
			-- size_speed = 3.3,
			-- speed = 0,
			-- focus = 20,
			-- lifetime = .03,
			-- sprite = {
					-- {
						-- System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzlehoriz.dds")
					-- }
					-- ,
					-- {
						-- --System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle4.dds"),
						-- System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle5.dds"),
						-- System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle6.dds"),
						-- System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle7.dds"),
					-- }
				-- },
			-- stepsoffset = .1,
			-- steps = 5,
			-- gravity = 0,
			-- AirResistance = 0,
			-- rotation = 3,
			-- randomfactor = 60,
			-- color = {.5,.5,.5},
		-- },

		-- -- remove this if not nedded for current weapon
		-- MuzzleFlash = {
			-- geometry_name = "Objects/Weapons/Muzzle_flash/mf_ag36_fpv.cgf",
			-- bone_name = "spitfire",
			-- lifetime = .15,
		-- },
		-- MuzzleFlashTPV = {
			-- geometry_name = "Objects/Weapons/Muzzle_flash/mf_ag36_tpv.cgf",
			-- bone_name = "weapon_bone",
			-- lifetime = .05,
		-- },

		-- -- trace "moving bullet"
		-- -- remove this if not nedded for current weapon
		-- Trace = {
			-- geometry=System:LoadObject("Objects/Weapons/trail.cgf"),
			-- focus = 5000,
			-- color = {1,1,1},
			-- speed = 920, -- 120
			-- count = 1,
			-- size = 1,
			-- size_speed = 0,
			-- gravity = {x = 0,y = 0,z = 0},
			-- lifetime = .04,
			-- frames = 0,
			-- color_based_blending = 3,
			-- particle_type = 0,
		-- },

		-- SoundMinMaxVol = {255,7,2200},

		-- LightFlash = {
			-- fRadius = 4,
			-- vDiffRGBA = {r = 1,g = 1,b = .7,a = 1,},
			-- vSpecRGBA = {r = 1,g = 1,b = .7,a = 1,},
			-- fLifeTime = .1,
		-- },
	-- },
-- --GRENADE-----------------------------
	-- {
		-- no_zoom = 1,
		-- FModeActivationTime=1,
		-- --HasCrosshair=1,
		-- AmmoType="AG36Grenade",
			-- min_recoil=4,
			-- max_recoil=4,
		-- projectile_class="AG36Grenade",
		-- reload_time=2.5,
		-- fire_rate=1,
		-- fire_activation=FireActivation_OnPress,
		-- bullet_per_shot=1,
		-- bullets_per_clip=1,


		-- ScopeTexId = GetScopeTex(),

		-- FireSounds = {
			-- "Sounds/Weapons/ag36/FINAL_GRENADE_MONO.wav",
		-- },
		-- FireSoundsStereo = {
			-- "Sounds/Weapons/ag36/FINAL_GRENADE_STEREO.wav",
		-- },
		-- DrySound = "Sounds/Weapons/AG36/DryFire.wav",

		-- SoundMinMaxVol = {255,1,100},

		-- LightFlash = {
			-- fRadius = 4,
			-- vDiffRGBA = {r = 1,g = 1,b = .7,a = 1,},
			-- vSpecRGBA = {r = 1,g = 1,b = .7,a = 1,},
			-- fLifeTime = .1,
		-- },
	-- },

	-- },




		-- SoundEvents={
		-- --	animname,	frame,	soundfil{	"reload1",	15,			Sound.LoadSound("Sounds/Weapons/ag36/ag36b_15.wav")},
		-- {	"reload1",	23,			Sound:LoadSound("Sounds/Weapons/ag36/Ag36b_23.wav",0,150)},
		-- {	"reload1",	38,			Sound:LoadSound("Sounds/Weapons/ag36/Ag36b_38.wav",0,150)},
		-- {	"reload1",	54,			Sound:LoadSound("Sounds/Weapons/ag36/Ag36b_54.wav",0,150)},
		-- {	"reload2",	13,			Sound:LoadSound("Sounds/Weapons/ag36/ag36g_13.wav",0,150)},
		-- {	"reload2",	37,			Sound:LoadSound("Sounds/Weapons/ag36/ag36g_37.wav",0,150)},
-- --		{	"swim",		1,			Sound:LoadSound("Sounds/player/water/underwaterswim2.wav",0,255)},

	-- },

	-- TargetHelperImage = System:LoadImage("Textures/Hud/crosshair/g36.tga"),
	-- NoTargetImage = System:LoadImage("Textures/Hud/crosshair/noTarget.dds"),
-- }

AG36 = AG36SP

-- if (Game:IsMultiplayer()) then
	-- AG36 = AG36MP
-- end


CreateBasicWeapon(AG36)

function AG36.Client:OnEnhanceHUD(scale,bHit)
--function AG36.Client:OnEnhanceHUD()

	if (_localplayer.cnt.firemode==1) then
		System:DrawImageColor(self.TargetHelperImage,400 - 15,300 - 15,30,30,4,1,0,0,1)
		BasicWeapon.Client.OnEnhanceHUD(self)
	else
		local posX = 400
		local posY = 300
		BasicWeapon.Client.OnEnhanceHUD(self,scale,bHit,posX,posY)
	end
end


---------------------------------------------------------------
--ANIMTABLE
------------------
--AUTOMATIC FIRE
AG36.anim_table={}
AG36.anim_table[1]={
	idle={
		"Idle11",
		"Idle21",
	},
	reload={
		"Reload1",
	},
	fidget={
		"fidget11",
	},
	fire={
		"Fire11",
		"Fire21",
	},
	melee={
		"Fire13",
		"Fire23",
	},
	swim={
		"swim"
	},
	activate={
		"Activate1"
	},
}
------------------
--GRENADE LAUNCHER
AG36.anim_table[2]={
	idle={
		"Idle11",
		"Idle21",
	},
	reload={
		"Reload2",
	},
	fidget={
		"fidget11",
	},
	fire={
		"Fire12",
	},
	melee={
		"Fire13",
		"Fire23",
	},
	swim={
		"swim"
	},
	activate={
		"Activate2"
	},
}
