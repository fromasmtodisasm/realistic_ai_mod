ScoutTool = {
	-- DESCRIPTION
	-- Scout class specific tool
	name			= "ScoutTool",
	object		= "Objects/Weapons/scouttool/scouttool_active.cgf",
	character	= "Objects/Weapons/scouttool/scouttool.cgf",

	PlayerSlowDown = 1.0,									-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	NoZoom=1,
	---------------------------------------------------
	switch_on_empty_ammo = 1,

	FireParams ={													-- describes all supported firemodes
	{
		FModeActivationTime=1,
		HasCrosshair=nil,
		AmmoType="StickyExplosive",
		projectile_class="StickyExplosive",
		ammo=50,
		reload_time=2.5,
		fire_rate=1.0,
		fire_activation=FireActivation_OnPress,
		bullet_per_shot=1,
		bullets_per_clip=1,
		
		FireSounds = {
			"sounds/items/throw.wav",
		},
		
		SoundMinMaxVol = { 255, 5, 200 },
	},
	},
	
	SoundEvents={
		--	animname,	frame,	soundfile												---
	},

	GrenadeThrowFrame = 12,
}

CreateBasicWeapon(ScoutTool);

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
