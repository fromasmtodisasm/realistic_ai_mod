VehicleMountedRocket = {
	name = "VehicleMountedRocket",

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
		FireSounds = {
			"Sounds/Weapons/rl/FINAL_RL_MONO.wav",
		},
		FireSoundsStereo = {
			"Sounds/Weapons/rl/FINAL_RL_STEREO.wav",

		},
		DrySound = "Sounds/Weapons/AG36/DryFire.wav",

		LightFlash = {
			fRadius = 7,
			vDiffRGBA = {r = 1,g = 1,b = 0,a = 1,},
			vSpecRGBA = {r = .3,g = .3,b = .3,a = 1,},
			fLifeTime = .25,
		},

		SoundMinMaxVol = {255,3,200},
	},
	-- special AI firemode follows
	{
		FireSounds = {
			"Sounds/Weapons/rl/FINAL_RL_MONO.wav",
		},
		FireSoundsStereo = {
			"Sounds/Weapons/rl/FINAL_RL_STEREO.wav",

		},
		DrySound = "Sounds/Weapons/AG36/DryFire.wav",

		LightFlash = {
			fRadius = 7,
			vDiffRGBA = {r = 1,g = 1,b = 0,a = 1,},
			vSpecRGBA = {r = .3,g = .3,b = .3,a = 1,},
			fLifeTime = .25,
		},

		SoundMinMaxVol = {255,3,200},
	},

	},

	SoundEvents={
	--	animname,	frame,	soundfile
	{	"reload1",	20,			Sound:LoadSound("Sounds/Weapons/M4/M4_20.wav")},
	{	"reload1",	33,			Sound:LoadSound("Sounds/Weapons/M4/M4_33.wav")},
	{	"reload1",	47,			Sound:LoadSound("Sounds/Weapons/M4/M4_47.wav")},
	},
}

CreateBasicWeapon(VehicleMountedRocket)

function VehicleMountedRocket.Client:OnEnhanceHUD(scale,bHit)
	BasicWeapon.DoAutoCrosshair(self,scale,bHit)
end
