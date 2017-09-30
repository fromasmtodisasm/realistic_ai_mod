ScoutTool = {
	-- DESCRIPTION
	-- Scout class specific tool
	name			= "ScoutTool",
	object		= "Objects/Weapons/explosive/explosive_bind.cgf",
	character	= "Objects/Weapons/explosive/explosive.cgf",

	PlayerSlowDown = 1,									-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	NoZoom=1,
	---------------------------------------------------
	switch_on_empty_ammo = 1,

	special_bone_to_bind = "Bip01 L Hand",--usually the weapon model is attached to "weapon_bone" bone,
					       --but some weapons should need a different bone,like this one.
					       --if "special_bone_to_bind" doesnt exist "weapon_bone" will be taken.

	FireParams ={													-- describes all supported firemodes
	{
		type = 5,
		FireSounds = {
			"sounds/items/throw.wav",
		},

		SoundMinMaxVol = {100,1,20},
	},
	},

	SoundEvents={
		--	animname,	frame,	soundfile												---
	},

	GrenadeThrowFrame = 12,
}

CreateBasicWeapon(ScoutTool)

---------------------------------------------------------------
--ANIMTABLE
------------------
ScoutTool.anim_table={}

ScoutTool.anim_table[1]={
	idle={
		"Idle11",
	},
	fire={
		"Fire11",
	},
	reload={
		"Activate1",
	},
	swim={
		"swim"
	},
	activate={
		"Activate1"
	},
}
