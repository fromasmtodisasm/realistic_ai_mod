MUTANT_FAST_GRAV_MULT = 3;

MutantScout_x = {

	NoFallDamage = 1,
------------------------------------------------------------------------------------

		
	MeleeHitType="melee_slash",
------------------------------------------------------------------------------------
	bNoImpulseOnDamage = 1,
	MUTANT = 1,	

	PropertiesInstance = {	
		sightrange = 35,
		soundrange = 10,	-- rememeber that sound ranges intersect and sound range for AI doubles when in alert
		aibehavior_behaviour = "MutantJob_Idling",
		groupid = 154,

		},


	Properties = {
		special = 0,
		fJumpAngle = 45,
		JUMP_TABLE = "MUTANT_FAST",
		KEYFRAME_TABLE = "MUTANT_FAST",
		SOUND_TABLE = "MUTANT_FAST",
		fDamageMultiplier = 1,
		gravity_multiplier = MUTANT_FAST_GRAV_MULT,
		fileHelmetModel = "",
		fMeleeDamage = 100,
		bAffectSOM = 1,
		suppressedThrhld = 5.5,
		bSleepOnSpawn = 1,
		bHelmetOnStart = 0,
		bAwareOfPlayerTargeting = 1,
		bHasArmor = 1,
--		bHasLight = 0,
		aggression = 0.3,	-- 0 = passive, 1 = total aggression
		commrange = 30.0,
--		cohesion = 5,
		attackrange = 70,
		horizontal_fov = 160,
		eye_height = 2.1,
		forward_speed = 1.66,
		back_speed = 2.5,
		max_health = 70,
		accuracy = 0.6,
		responsiveness = 7,
		species = 100,
		fSpeciesHostility = 2,
		fGroupHostility = 0,
		fPersistence = 0,
		equipEquipment = "none",
		equipDropPack = "none",
		AnimPack = "Basic",
		SoundPack = "dialog_template",
		aicharacter_character = "MutantScout",
		pathname = "none",
		pathsteps = 0,
		pathstart = 0,
		ReinforcePoint = "none",
		fileModel = "Objects/characters/mutants/Mutant_scout/Mutant_scout.cgf",		
		bTrackable=1,

		speed_scales={
			run			=3.78,
			crouch	=.8,
			prone		=.5,
			xrun		=1.5,
			xwalk		=.81,
			rrun		=3.63,
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
		mass = 80,
		height = 2.8,
		eyeheight = 2.7,
		sphereheight = 1.2,
		radius = 3.45,
	},

--pe_player_dimensions structure
	PlayerDimNormal = {
		height = 2.2,
		eye_height = 2.1,
		ellipsoid_height = 1.3,
		x = 0.5,
		y = 0.0,
		z = .6,
	},
	PlayerDimCrouch = {
		height = 2.2,
		eye_height = 2.1,
		ellipsoid_height = 1.3,
		x = 0.5,
		y = 0.8,
		z = 0.3,
	},
	PlayerDimProne = {
		height = 0.4,
		eye_height = 0.5,
		ellipsoid_height = 0.35,
		x = 0.5,
		y = 0.45,
		z = 0.2,
	},


	AI_DynProp = {
		air_control = 0.4,  -- default 0.6
		gravity = MUTANT_FAST_GRAV_MULT*9.81,
		swimming_gravity = -1.0,
		inertia = 10.0,
		swimming_inertia = 1.0,
		nod_speed = 60.0,
		min_slide_angle = 46,
		max_climb_angle = 60,
		min_fall_angle = 70,
		max_jump_angle = 55,
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
	},
	BulletImpactParams = {
    stiffness_scale = 73,
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
--		{"srunfwd",	0,			666},
--		{"srunfwd",	10,			666},
--		{"srunfwd",	20,			666},
--		{"srunback",	5,			666},
--		{"srunback",	13,			666},
--		{"swalkback",   2,			666},
--		{"swalkback",   18,		666},
---		{"swalkfwd",     3,		666},
--		{"swalkfwd",    20,		666},
--		{"attack_melee1", 11, KEYFRAME_APPLY_MELEE},
--		{"attack_melee2", 11, KEYFRAME_APPLY_MELEE},
--		{"attack_melee2", 17, KEYFRAME_APPLY_MELEE},
--		{"attack_melee3", 22, KEYFRAME_APPLY_MELEE},
--		{"attack_melee4", 19, KEYFRAME_APPLY_MELEE},
--		{"attack_melee4", 36, KEYFRAME_APPLY_MELEE},
--		{"attack_melee_special1", 28, KEYFRAME_APPLY_MELEE},
--	},

	GrenadeType = "ProjFlashbangGrenade",






}

-----------------------------------------------------------------------------------------------------