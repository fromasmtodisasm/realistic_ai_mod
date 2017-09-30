VehicleMountedAutoMG = {
	name = "VehicleMountedAutoMG",

	PlayerSlowDown = 1,									-- factor to slow down the player when he holds that weapon
--	character	= "Objects/Vehicles/Mounted_gun/m2.cga",
	---------------------------------------------------
	ActivateSound = Sound:Load3DSound("Sounds/Weapons/M4/m4weapact.wav"),	-- sound to play when this weapon is selected
	AimMode=1,

	ZoomNoSway=1,			--no sway in zoom mode
	ZoomOverlayFunc=AimModeZoomHUD.DrawHUD,
	---------------------------------------------------
	ZoomFixedFactor=1,
	FireParams ={													-- describes all supported firemodes
	{
		whizz_sound_radius=5,
		generic_whizz = 1,
		whizz_probability=1000,
		-- FireLoop="Sounds/Weapons/mounted/FINAL_M249_STEREO_MONO.wav",
		-- FireLoopStereo="Sounds/Weapons/mounted/FINAL_M249_STEREO_LOOP.wav",
		-- TrailOff="Sounds/Weapons/mounted/FINAL_M249_MONO_TAIL.wav",
		-- TrailOffStereo="Sounds/Weapons/mounted/FINAL_M249_STEREO_TAIL.wav",
		FireLoop = {
			"Sounds/Weapons/hmg_m2hb/m2hb_fire_3p.wav",
			"Sounds/Weapons/hmg_m2hb/m2hb_fire_3p.wav",
			"Sounds/Weapons/hmg_m2hb/m2hb_fire_3p.wav",
		},
		FireLoopStereo = {
			"Sounds/Weapons/hmg_m2hb/m2hb_fire_1p.wav",
			"Sounds/Weapons/hmg_m2hb/m2hb_fire_1p.wav",
			"Sounds/Weapons/hmg_m2hb/m2hb_fire_1p.wav",
		},
		DrySound = "Sounds/Weapons/hmg_m2hb/50cal_trigger.mp3",

		LightFlash = {
			fRadius = 7,
			vDiffRGBA = {r = 1,g = 1,b = 0,a = 1,},
			vSpecRGBA = {r = .3,g = .3,b = .3,a = 1,},
			fLifeTime = .1,
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

		--------------------
		--particle weaponfx
		SmokeEffect = {
			size = {.25,.17,.135,.1},
			size_speed = 1.3,
			speed = 20,
			focus = 2,
			lifetime = .2,
			sprite = System:LoadTexture("textures\\cloud1.dds"),
			stepsoffset = .3,
			steps = 4,
			gravity = 1.2,
			AirResistance = 3,
			rotation = 3,
			randomfactor = 50,
		},

		MuzzleEffect = {
			size = {.2},
			size_speed = 5,
			speed = 0,
			focus = 20,
			lifetime = .03,
			sprite = System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle1.dds"),
			stepsoffset = .1,
			steps = 1,--10,
			gravity = 0,
			AirResistance = 0,
			rotation = 30,
			randomfactor = 25,
			--color = {.5,.5,.5},
		},
		--------------------

		-- remove this if not nedded for current weapon
		MuzzleFlash = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_MG_fpv.cgf",
			bone_name = "spitfire",
			lifetime = .15,
		},
		MuzzleFlashTPV = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_MG_tpv.cgf",
			bone_name = "spitfire",
			lifetime = .05,
		},

		-- trace "moving bullet"
		-- remove this if not nedded for current weapon
		Trace = {
			geometry=System:LoadObject("Objects/Weapons/trail_mounted.cgf"),
			focus = 5000,
			color = {1,1,1},
			speed = 855,
			count = 1,
			size = 1,
			size_speed = 0,
			gravity = {x = 0,y = 0,z = 0},
			lifetime = .04,
			frames = 0,
			color_based_blending = 3,
			particle_type = 0,
			bouncyness = 0,
		},

		SoundMinMaxVol = {255,12,2200},
	},
	-- special AI firemode follows
	{
		whizz_sound_radius=5,
		generic_whizz = 1,
		whizz_probability=1000,
		FireLoop = {
			"Sounds/Weapons/hmg_m2hb/m2hb_fire_3p.wav",
			"Sounds/Weapons/hmg_m2hb/m2hb_fire_3p.wav",
			"Sounds/Weapons/hmg_m2hb/m2hb_fire_3p.wav",
		},
		FireLoopStereo = {
			"Sounds/Weapons/hmg_m2hb/m2hb_fire_1p.wav",
			"Sounds/Weapons/hmg_m2hb/m2hb_fire_1p.wav",
			"Sounds/Weapons/hmg_m2hb/m2hb_fire_1p.wav",
		},
		DrySound = "Sounds/Weapons/hmg_m2hb/50cal_trigger.mp3",

		LightFlash = {
			fRadius = 7,
			vDiffRGBA = {r = 1,g = 1,b = 0,a = 1,},
			vSpecRGBA = {r = .3,g = .3,b = .3,a = 1,},
			fLifeTime = .1,
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

		--------------------
		--particle weaponfx
		SmokeEffect = {
			size = {.25,.17,.135,.1},
			size_speed = 1.3,
			speed = 20,
			focus = 2,
			lifetime = .2,
			sprite = System:LoadTexture("textures\\cloud1.dds"),
			stepsoffset = .3,
			steps = 4,
			gravity = 1.2,
			AirResistance = 3,
			rotation = 3,
			randomfactor = 50,
		},

		MuzzleEffect = {
			size = {.2},
			size_speed = 5,
			speed = 0,
			focus = 20,
			lifetime = .03,
			sprite = System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle1.dds"),
			stepsoffset = .1,
			steps = 1,--10,
			gravity = 0,
			AirResistance = 0,
			rotation = 30,
			randomfactor = 25,
			--color = {.5,.5,.5},
		},
		--------------------

		-- remove this if not nedded for current weapon
		MuzzleFlash = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_MG_fpv.cgf",
			bone_name = "spitfire",
			lifetime = .15,
		},
		MuzzleFlashTPV = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_MG_tpv.cgf",
			bone_name = "spitfire",
			lifetime = .05,
		},

		-- trace "moving bullet"
		-- remove this if not nedded for current weapon
		Trace = {
			geometry=System:LoadObject("Objects/Weapons/trail_mounted.cgf"),
			focus = 5000,
			color = {1,1,1},
			speed = 855,
			count = 1,
			size = 1,
			size_speed = 0,
			gravity = {x = 0,y = 0,z = 0},
			lifetime = .04,
			frames = 0,
			color_based_blending = 3,
			particle_type = 0,
			bouncyness = 0,
		},

		SoundMinMaxVol = {255,12,2200},
	},
	},


	SoundEvents={
	--	animname,	frame,	soundfile
	{	"reload1",	20,			Sound:LoadSound("Sounds/Weapons/M4/M4_20.wav")},
	{	"reload1",	33,			Sound:LoadSound("Sounds/Weapons/M4/M4_33.wav")},
	{	"reload1",	47,			Sound:LoadSound("Sounds/Weapons/M4/M4_47.wav")},
	},


	CrosshairParticles = {
		focus = 0,
		speed = 0,
		count = 1,
		size = .15,
		size_speed=0,
		gravity={x=0,y=0,z=-0},
		rotation={x=0,y=0,z=0},
		lifetime=0,
		tid = System:LoadTexture("textures\\cloud.dds"),
		start_color = {1,.2,.2},
		end_color = {1,.2,.2},
		blend_type = 2,
		frames=0,
		draw_last=1,
	},

	cross3D = 1
}

CreateBasicWeapon(VehicleMountedAutoMG)

function VehicleMountedAutoMG.Client:OnEnhanceHUD(scale,bHit)
	BasicWeapon.DoAutoCrosshair(self,scale,bHit)
end
