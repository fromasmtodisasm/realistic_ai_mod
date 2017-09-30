MutantCover_x = {

	NoFallDamage = 1,
------------------------------------------------------------------------------------

		
	MeleeHitType="melee_slash",
------------------------------------------------------------------------------------

	MUTANT = 1,
	ROCKET_ORIGIN_KEYFRAME = KEYFRAME_FIRE_RIGHTHAND,
	isSelfCovered = 0,
	lastMeleeAttackTime = 0,

	PropertiesInstance = {
		sightrange = 35,
		soundrange = 10,	-- rememeber that sound ranges intersect and sound range for AI doubles when in alert
		groupid = 154,
		aibehavior_behaviour = "MutantJob_Idling",
		fScale=1,
		},

	Properties = {
		customParticle = "none",
		bDumbRockets = 0,
		bSingleMeleeKillAI = 0,
		fDamageMultiplier = 1,
		KEYFRAME_TABLE = "MUTANT_BIG",
		SOUND_TABLE = "MUTANT_BIG",
		bShootSmartRocketsForward = 1,
		fMeleeDamage = 100,
		bAffectSOM = 1,	
		suppressedThrhld = 5.5,
		fMeleeDistance = 4,	
		bSleepOnSpawn = 1,
		bHelmetOnStart = 0,
		bHasArmor = 1,
		fileHelmetModel = "",
--		bHasLight = 0,
		aggression = 0.3,	-- 0 = passive, 1 = total aggression
		commrange = 30.0,
--		cohesion = 5,
		attackrange = 70,
		horizontal_fov = 160,
		eye_height = 2.1,
		forward_speed = 1.83,
		back_speed = 2.5,
		max_health = 250,	
		accuracy = 0.6,
		responsiveness = 7,
		species = 100,
		special = 0,

		fSpeciesHostility = 2,
		fGroupHostility = 0,
		fPersistence = 0,
		equipEquipment = "none",
		equipDropPack = "none",
		AnimPack = "Basic",
		SoundPack = "dialog_template",

		aicharacter_character = "MutantCover",
		pathname = "none",
		pathsteps = 0,
		pathstart = 0,
		ReinforcePoint = "none",
		fileModel = "Objects/characters/mutants/Mutant_cover/Mutant_cover.cgf",				
		bTrackable=1,

		speed_scales={
			run			=1.83,
			crouch	=.8,
			prone		=.5,
			xrun		=1.83,
			xwalk		=.81,
			rrun		=1.83,
			rwalk		=.94,
			},
		AniRefSpeeds = {
			WalkFwd = 1.8,
			WalkSide = 1.8,
			WalkBack = 1.8,
			WalkRelaxedFwd = 1.27,
			WalkRelaxedSide = 1.22,
			WalkRelaxedBack = 1.29,
			XWalkFwd = 1.8,
			XWalkSide = 1.8, 
			XWalkBack = 1.8,
			XRunFwd = 4.5,
			XRunSide = 3.5, 
			XRunBack = 4.5,
			RunFwd = 3.2,
			RunSide = 3.2,
			RunBack = 3.2,
			CrouchFwd = 1.8,
			CrouchSide = 1.8,
			CrouchBack = 1.8,
		},
	},

	PhysParams = {
		mass = 400,
		height = 2.8,
		eyeheight = 2.7,
		sphereheight = 1.2,
		radius = 3.45,
	},


--pe_player_dimensions structure
	PlayerDimNormal = {
		height = 2.2,
		eye_height = 2.1,
		ellipsoid_height = 1.7,
		x = 0.710,
		y = 0.10,
		z = 0.7,
	},
	PlayerDimCrouch = {
		height = 2.2,
		eye_height = 2.1,
		ellipsoid_height = 1.9,
		x = .710,
		y = 0.10,
		z = 0.7,
	},
	PlayerDimProne = {
		height = 0.4,
		eye_height = 0.5,
		ellipsoid_height = 0.35,
		x = 0.45,
		y = 0.45,
		z = 4.2,
	},
	


	DeadBodyParams = {
		sim_type = 1,
	  max_time_step = 0.025,
	  gravityz = -7.5,
	  sleep_speed = 0.025,
	  damping = 0.3,
	  freefall_gravityz = -9.81,
	  freefall_damping = 0.1,

	  lying_mode_ncolls = 4,
	  lying_gravityz = -5.0,
	  lying_sleep_speed = 0.065,
	  lying_damping = 1.0,

    water_damping = 0.5,
    water_resistance = 1000,
	},
	BulletImpactParams = {
    stiffness_scale = 40,
    impulse_scale = 5,
    max_time_step = 0.02
  },

	Ammo = {
		Pistol = 0,
		Assault = 0,
		Sniper = 0,
		Minigun = 0,
		Shotgun = 0,
		MortarShells = 0,
		Grenades = 0,
		HandGrenades = 0,
		Rocket = 0,
		Battery = 0,
	},

--	SoundEvents={
--		{"srunfwd",	0,			},
--		{"srunfwd",	10,			},
--		{"srunfwd",	20,			},
--		{"srunback",	5,			},
--		{"srunback",	13,			},
--		{"swalkback",   2,			},
--		{"swalkback",   18,			},
--		{"swalkfwd",     3,			},
--		{"swalkfwd",    20,			},
----		amin name		frame		soundfile
--		
--		{"attack_melee1",	4,	--Sound:Load3DSound("SOUNDS/mutants/cover/cover_melee1swipeF4.wav",SOUND_UNSCALABLE,175,2,20)},
--		{"attack_melee1",	10,		KEYFRAME_APPLY_MELEE},
--
--		{"attack_melee1",	1,	Sound:Load3DSound("SOUNDS/mutants/cover/exert_6.wav",SOUND_UNSCALABLE,175,2,20)},
--		{"attack_melee2",	13,	--Sound:Load3DSound("SOUNDS/mutants/cover/cover_melee2swipeF13.wav",SOUND_UNSCALABLE,175,2,20)},
--		{"attack_melee2",	16,		KEYFRAME_APPLY_MELEE},
--		{"attack_melee2",	1,	Sound:Load3DSound("SOUNDS/mutants/cover/exert_1.wav",SOUND_UNSCALABLE,175,2,20)},
--		{"attack_melee3",	10,	--Sound:Load3DSound("SOUNDS/mutants/cover/cover_melee3swipeF10.wav",SOUND_UNSCALABLE,175,2,20)},
--		{"attack_melee3",	1,	Sound:Load3DSound("SOUNDS/mutants/cover/exert_2.wav",SOUND_UNSCALABLE,175,2,20)},
--		{"attack_melee3",	16,		KEYFRAME_APPLY_MELEE},
--		{"attack_melee4",	10,	--Sound:Load3DSound("SOUNDS/mutants/cover/cover_melee4swipeF10.wav",SOUND_UNSCALABLE,175,2,20)},
--		{"attack_melee4",	1,	Sound:Load3DSound("SOUNDS/mutants/cover/exert_4.wav",SOUND_UNSCALABLE,175,2,20)},
--		{"attack_melee4",	12,		KEYFRAME_APPLY_MELEE},
--		{"attack_melee5",	10,	--Sound:Load3DSound("SOUNDS/mutants/cover/cover_melee4swipeF10.wav",SOUND_UNSCALABLE,175,2,20)},
--		{"attack_melee5",	1,	Sound:Load3DSound("SOUNDS/mutants/cover/exert_7.wav",SOUND_UNSCALABLE,175,2,20)},
--		{"attack_melee5",	16,		KEYFRAME_APPLY_MELEE},
--		{"idle01",	1,	Sound:Load3DSound("SOUNDS/mutants/cover/growl2.wav",SOUND_UNSCALABLE,175,2,20)},
--		
--	},

	GrenadeType = "ProjFlashbangGrenade",

	ImpulseParameters = {
		rmin = 1,
		rmax = 1,
		impulsive_pressure = 300,
		rmin_occlusion =0,
		occlusion_res =0,
		occlusion_inflate = 0,
	},


}

-------------------------------------------------------------------------------------------------------
function MutantCover_x:OnInitCustom(  )


System:Log("MutantCover_x onInitCustom ");

	self.cnt:CounterAdd("SuppressedValue", -2.0 );

end

---------------------------------------------------------------------------------------------------------
function MutantCover_x:OnResetCustom()

System:Log("MutantCover_x onResetCustom ");

	self.cnt:CounterSetValue("SuppressedValue", 0.0 );
	self.isSelfCovered = 0;
	self.lastMeleeAttackTime = 0;
	
end
---------------------------------------------------------------------------------------------------------

