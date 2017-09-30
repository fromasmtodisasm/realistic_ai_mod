P90 = {
	name			= "P90",
	object		= "Objects/Weapons/P90/P90_bind.cgf",
	character	= "Objects/Weapons/P90/P90.cgf",

	---------------------------------------------------
	PlayerSlowDown = .88,									-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	-- ActivateSound = Sound:LoadSound("Sounds/Weapons/usrif_m203/deploy_1p.mp3",0,100),	-- sound to play when this weapon is selected
	ActivateSound = Sound:LoadSound("Sounds/Weapons/P90/P90weapact.wav",0,100),	-- sound to play when this weapon is selected
	---------------------------------------------------
	DrawFlare=1, -- Отсвечивание прицела.
	MaxZoomSteps =  1,
	ZoomSteps = {1.0001},-- 1.4
	ZoomActive = 0,
	AimMode = 2,										--IronSights
	-- AimOffset={x=.1930001825094223, y=.1320004165172577, z=.04220016300678253},	--IronSights
	-- AimAngleOffset={x=1.439998865127564, y=.3399999439716339, z=-1.939998626708984},	--IronSights

	AimOffset={x=.1807999759912491, y=.4909975528717041, z=.03360001742839813},	--IronSights
	AimAngleOffset={x=1.789998531341553, y=.3399999439716339, z=-2.449998140335083},	--IronSights

	-- ZoomOverlayFunc=AimModeZoomHUD.DrawHUD,
	-- ZoomFixedFactor=1,
	-- ZoomNoSway=1,			--no sway in zoom mode
	-- Sway = 0,
	---------------------------------------------------
	FireParams =
	{													-- describes all supported 	firemodes
	{
		-- Make sure that the last parameter in each sound (max-distance) is equal to "whizz_sound_radius"
		whizz_sound_radius=5,
		generic_whizz = 1,
		whizz_probability=1000,	-- 0-1000

		FireLoop = {
			"Sounds/Weapons/eurif_fnp90/fnp90_fire_3p.mp3",
			"Sounds/Weapons/eurif_fnp90/fnp90_fire_3p.mp3",
			"Sounds/Weapons/eurif_fnp90/fnp90_fire_3p.mp3",
		},
		FireLoopStereo = {
			"Sounds/Weapons/eurif_fnp90/fnp90_fire_1p.mp3",
			"Sounds/Weapons/eurif_fnp90/fnp90_fire_1p.mp3",
			"Sounds/Weapons/eurif_fnp90/fnp90_fire_1p.mp3",
		},
		-- TrailOff="Sounds/Weapons/p90/FINAL_P90_MONO_TAIL.wav",
		-- TrailOffStereo="Sounds/Weapons/p90/FINAL_P90_STEREO_TAIL.wav",
		DrySound = "Sounds/Weapons/P90/DryFire.wav",

		LightFlash = {
			fRadius = 4,
			vDiffRGBA = {r = 1,g = 1,b = .7,a = 1,},
			vSpecRGBA = {r = 1,g = 1,b = .7,a = 1,},
			fLifeTime = .1,
		},

		ShellCases = {
			geometry=System:LoadObject("Objects/Weapons/shells/rifleshell.cgf"),
			focus = 1.5,
			color = {1,1,1},
			speed = .1,
			count = 1,
			size = 2,
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
			size = {.08,.007},
			size_speed = 1.3,
			speed = 0,
			focus = 20,
			lifetime = .03,
			sprite = {
					{
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzleP90.dds"),
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzleP902.dds"),
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzleP903.dds"),
					},
					{
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle4.dds"),
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle5.dds"),
						System:LoadTexture("Textures\\WeaponMuzzleFlash\\muzzle6.dds"),
					},
				},

			stepsoffset = .01,
			steps = 2,
			gravity = 0,
			AirResistance = 0,
			rotation = 3,
			randomfactor = 10,

			color = {.7,.9,1},
		},

		-- remove this if not nedded for current weapon
		MuzzleFlash = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_P90_fpv.cgf",
			bone_name = "spitfire",
			lifetime = .135,
		},
		MuzzleFlashTPV = {
			geometry_name = "Objects/Weapons/Muzzle_flash/mf_p90_tpv.cgf",
			bone_name = "weapon_bone",
			lifetime = .05,
		},

		-- trace "moving bullet"
		Trace = {
			geometry=System:LoadObject("Objects/Weapons/trail.cgf"),
			focus = 5000,
			color = {1,1,1},
			speed = 716,  -- 120
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

		SoundMinMaxVol = {255,7,2200},
	}	},

		SoundEvents={
		--	animname,	frame,	soundfile
		{	"reload1",	12,			Sound:LoadSound("Sounds/Weapons/P90/p90_1.wav",0,100)},
		{	"reload1",	40,			Sound:LoadSound("Sounds/Weapons/P90/p90_2.wav",0,100)},
		{	"reload1",	49,			Sound:LoadSound("Sounds/Weapons/P90/p90_3.wav",0,100)},
--		{	"swim",		1,				Sound:LoadSound("Sounds/player/water/underwaterswim2.wav",0,255)},
	},
}

function P90:DrawZoomOverlay( ZoomStep )
	if ( P90.ZoomBackgroundTID ) then
		-- [tiago] note image inversion, in order to achieve one-one texel to pixel mapping we must correct texture coordinates
		-- also, texture wrap should be set to clamping mode... i hacked texture coordinates a bit to go around incorrect texture wrapping mode...
		local fTexelW=1.0/512.0;
		local fTexelH=1.0/512.0;

		System:DrawImageColorCoords( P90.ZoomBackgroundTID, 400, 300, -400, -300, 4, 1, 1, 1, 1, fTexelW, fTexelH, 1-fTexelW, 1-fTexelH);
		System:DrawImageColorCoords( P90.ZoomBackgroundTID, 400, 300, 400, -300, 4, 1, 1, 1, 1, fTexelW, fTexelH, 1-fTexelW, 1-fTexelH);
		System:DrawImageColorCoords( P90.ZoomBackgroundTID, 400, 300, -400, 300, 4, 1, 1, 1, 1, fTexelW, fTexelH, 1-fTexelW, 1-fTexelH);
		System:DrawImageColorCoords( P90.ZoomBackgroundTID, 400, 300, 400, 300, 4, 1, 1, 1, 1, fTexelW, fTexelH, 1-fTexelW, 1-fTexelH);
	end
end

CreateBasicWeapon(P90)


-- override functions
function P90.Client:OnInit()
	P90.ZoomBackgroundTID=System:LoadImage("Textures/Hud/P90_Scope/P90_Scope");
	self.ZoomOverlayFunc = P90.DrawZoomOverlay;
	BasicWeapon.Client.OnInit(self);
end

---------------------------------------------------------------
--ANIMTABLE
------------------
P90.anim_table={}
--AUTOMATIC FIRE
P90.anim_table[1]={
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
		"Fire31",
	},
	swim={
		"swim",
	},
	activate={
		"Activate1",
	},
}