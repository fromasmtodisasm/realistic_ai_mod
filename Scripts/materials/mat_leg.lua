Script:LoadScript("scripts/materials/commoneffects.lua");
Materials["mat_leg"] = {
	type="leg",
-------------------------------------	
	PhysicsSounds=PhysicsSoundsTable.Soft,
-------------------------------------
	bullet_hit = {
		sounds = {
			{"Sounds/bullethits/pbullet1.wav",SOUND_UNSCALABLE,200,8,60},
			{"Sounds/bullethits/pbullet2.wav",SOUND_UNSCALABLE,200,8,60},
			{"Sounds/bullethits/pbullet3.wav",SOUND_UNSCALABLE,200,8,60},
			{"Sounds/bullethits/pbullet4.wav",SOUND_UNSCALABLE,200,8,60},
			
		},
		
		decal = { 
		
			gore = 1,	-- to be able to switch off gore -- to know what's allowed		
			texture = System:LoadTexture("Languages/Textures/Decal/hole_blood.dds",0,1),
			scale = 0.06,
			},
		
		particleEffects = {
			gore = 1,	-- to be able to switch off gore -- to know what's allowed				
			name = "bullet.hit_flesh.a",
		},
	},
	pancor_bullet_hit = {
		sounds = {
			{"Sounds/bullethits/pbullet1.wav",SOUND_UNSCALABLE,200,8,60},
			{"Sounds/bullethits/pbullet2.wav",SOUND_UNSCALABLE,200,8,60},
			{"Sounds/bullethits/pbullet3.wav",SOUND_UNSCALABLE,200,8,60},
			{"Sounds/bullethits/pbullet4.wav",SOUND_UNSCALABLE,200,8,60},
			
		},
		
		decal = { 
		
			gore = 1,	-- to be able to switch off gore -- to know what's allowed		
			texture = System:LoadTexture("Languages/Textures/Decal/hole_blood.dds",0,1),
			scale = 0.06,
			},
		
		particleEffects = {
			gore = 1,	-- to be able to switch off gore -- to know what's allowed				
			name = "bullet.hit_flesh_pancor.a",
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
			{"sounds/mutants/ab1/hit1.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/mutants/ab1/hit2.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/mutants/ab1/hit3.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/mutants/ab1/hit4.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/mutants/ab1/hit5.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/mutants/ab1/hit6.wav",SOUND_UNSCALABLE,185,5,30},
			{"sounds/mutants/ab1/hit7.wav",SOUND_UNSCALABLE,185,5,30},
			--{"sounds/objectimpact/Mslash8.wav",SOUND_UNSCALABLE,255,5,30},
			
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
		piercing_resistence = 4,
		friction = 0.1,
		bouncyness= -2, -- default 0
		important = 1,
	},

	AI = {
		fImpactRadius = 5,
	},

			
}