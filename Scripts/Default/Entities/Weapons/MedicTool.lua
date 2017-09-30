MedicTool = {
	name			= "MedicTool",
	object		= "Objects/Weapons/health_pack/healthpack_bind.cgf",
	character	= "Objects/Weapons/health_pack/health_pack.cgf",
	
	PlayerSlowDown = 1,	
		-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	AimMode=1,
	--NoZoom=1,
	ZoomOverlayFunc=AimModeZoomHUD.DrawHUD,
	
	MaxZoomSteps =  1,
	ZoomSteps = {1.2},
	-- normal crosshair-size
	---------------------------------------------------
	--ActivateSound = Sound.Load3DSound("Sounds/Weapons/Machete/Macheteweapact.wav"),	
	-- sound to play when this weapon is selected
	---------------------------------------------------
	switch_on_empty_ammo = 1,
	---------------------------------------------------
	NoZoom=1,
	
	special_bone_to_bind = "Bip01 L Hand",--usually the weapon model is attached to "weapon_bone" bone,
					       --but some weapons should need a different bone,like this one.
					       --if "special_bone_to_bind" doesnt exist "weapon_bone" will be taken.
	
	FireParams ={													
		-- describes all supported firemodes
	{
		type = 5,	
		FireSounds = {
			"sounds/items/throw.wav",
		},


		SoundMinMaxVol = {100,1,20},
	},
	
	},

--	SoundEvents={
		--	animname,	frame,	soundfile
--		{	"swim",		1,			Sound:LoadSound("Sounds/player/water/underwaterswim2.wav",0,255)},
--	},

	Recoil = 1,
}

CreateBasicWeapon(MedicTool)

---------------------------------------------------------------
--ANIMTABLE
------------------
--SINGLE FIRE
MedicTool.anim_table={}
MedicTool.anim_table[1]={
	idle={
		"Idle11",
		"Idle21",
	},
	fire={
		"Fire11",
	},
	activate={
		"Activate1"
	},
}