Script:LoadScript("scripts/materials/commoneffects.lua");
Materials["mat_bullseye"] = {
	type="bullseye",
-------------------------------------	
	PhysicsSounds=PhysicsSoundsTable.Soft,
-------------------------------------
	bullet_hit = {
		sounds = {
			--{"Sounds/bullethits/headbullet1.wav",SOUND_UNSCALABLE,220,10,80},
			--{"Sounds/bullethits/headbullet2.wav",SOUND_UNSCALABLE,220,10,80},
			--{"Sounds/bullethits/headbullet3.wav",SOUND_UNSCALABLE,220,10,80},
			{"Sounds/bullethits/headbullet11.wav",SOUND_UNSCALABLE,220,10,80},
			--{"Sounds/explosions/explosion2.wav",SOUND_UNSCALABLE,200,10,80},
		},
		
		particleEffects = {
			name = "bullet.hit_bullseye.a",
		},
	},

	pancor_bullet_hit = {
		sounds = {
			--{"Sounds/bullethits/headbullet1.wav",SOUND_UNSCALABLE,220,10,80},
			--{"Sounds/bullethits/headbullet2.wav",SOUND_UNSCALABLE,220,10,80},
			--{"Sounds/bullethits/headbullet3.wav",SOUND_UNSCALABLE,220,10,80},
			{"Sounds/bullethits/headbullet11.wav",SOUND_UNSCALABLE,220,10,80},
			--{"Sounds/explosions/explosion2.wav",SOUND_UNSCALABLE,200,10,80},
		},
		
		particleEffects = {
			name = "bullet.hit_bullseye_pancor.a",
		},
	},

	shocker_hit = {
		particleEffects = {
			name = "bullet.hit_bullseye.a",
		},
	},	
	
	
		-------------------------
	melee_punch = {
		sounds = {
			{"sounds/objectimpact/hit1.wav",SOUND_UNSCALABLE,255,5,30},
			{"sounds/objectimpact/hit2.wav",SOUND_UNSCALABLE,255,5,30},
			{"sounds/objectimpact/hit3.wav",SOUND_UNSCALABLE,255,5,30},
			{"sounds/objectimpact/hit4.wav",SOUND_UNSCALABLE,255,5,30},
			{"sounds/objectimpact/hit5.wav",SOUND_UNSCALABLE,255,5,30},
			{"sounds/objectimpact/hit6.wav",SOUND_UNSCALABLE,255,5,30},
			{"sounds/objectimpact/hit7.wav",SOUND_UNSCALABLE,255,5,30},
			{"sounds/objectimpact/hit8.wav",SOUND_UNSCALABLE,255,5,30},
			
		},
	},
	melee_slash = {
		sounds = {
			{"sounds/objectimpact/Mslash1.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/objectimpact/Mslash2.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/objectimpact/Mslash3.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/objectimpact/Mslash4.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/objectimpact/Mslash5.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/objectimpact/Mslash6.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/objectimpact/Mslash7.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/objectimpact/Mslash8.wav",SOUND_UNSCALABLE,185,5,30},
		},
		particleEffects = {
			gore = 1,	-- to be able to switch off gore -- to know what's allowed
			name = "bullet.hit_flesh.a",
		},

	},

	projectile_hit = CommonEffects.common_projectile_hit,
	mortar_hit = CommonEffects.common_mortar_hit,
	smokegrenade_hit = CommonEffects.common_smokegrenade_hit,
	flashgrenade_hit = CommonEffects.common_flashgrenade_hit,
	grenade_hit = CommonEffects.common_grenade_hit,
-------------------------------------
	gameplay_physic = {
		piercing_resistence = 15,
		friction = 0.4,
		bouncyness= -2, -- default 0
	},

	AI = {
		fImpactRadius = 5,
	},


}