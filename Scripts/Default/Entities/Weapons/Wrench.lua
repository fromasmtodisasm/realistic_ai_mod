-- Wrench weapon
-- Fixed by Mixer
Wrench = {
	name		= "Wrench",
	object		= "Objects/Weapons/wrench/wrench_bind.cgf",
	character	= "Objects/Weapons/wrench/wrench.cgf",
	
	-- factor to slow down the player when he holds that weapon
	PlayerSlowDown = .9,	
	NoZoom=1,
	-- describes all supported firemodes
	FireParams ={													
	{
		type = 3,
		FireSounds = {
			"Sounds/Weapons/Machete/fire1.wav",		-- todo
			"Sounds/Weapons/Machete/fire2.wav",		-- todo
			"Sounds/Weapons/Machete/fire3.wav",		-- todo
		},
		SoundMinMaxVol = {100,1,20},
	},
	},

--	SoundEvents={
		--	animname,	frame,	soundfile
--		{	"swim",		1,			Sound:LoadSound("Sounds/player/water/underwaterswim2.wav",0,255)},
--	},
}

CreateBasicWeapon(Wrench)

---------------------------------------------------------------
--ANIMTABLE
------------------
--SINGLE FIRE
Wrench.anim_table={}
Wrench.anim_table[1]={
	idle={
		"Idle11",
		"Idle21",
	},
	fidget={
		"fidget11",
	},
	fire={
		"Fire11",
		"Fire21",
	},
	swim={
		"swim"
	},
	activate={
		"Activate1"
	},
}