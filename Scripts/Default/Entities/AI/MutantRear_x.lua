MutantRear_x = {

	NoFallDamage = 1,
	refractionValue = 1,
        shaderLerp = 0,
	refractionSwitchDirection = 0,	-- 1-refraction turning on 2-refraction turning off 
	


		
	MeleeHitType="melee_slash",
------------------------------------------------------------------------------------

	MUTANT = 1,
	isSelfCovered = 0,
	lastMeleeAttackTime = 0,

	PropertiesInstance = {
		sightrange = 35,
		soundrange = 10,	-- rememeber that sound ranges intersect and sound range for AI doubles when in alert
		aibehavior_behaviour = "MutantJob_Idling",
		groupid = 154,

		},

	Properties = {
		customParticle = "none",
		fDamageMultiplier = 1,
		KEYFRAME_TABLE = "MUTANT_STEALTH",
		SOUND_TABLE = "MUTANT_STEALTH",
		fMeleeDamage = 100,
		bAffectSOM = 1,
		suppressedThrhld = 5.5,
		special = 0,
	
		bSleepOnSpawn = 1,
		bHelmetOnStart = 0,
		fMeleeDistance = 3,
		bAwareOfPlayerTargeting = 1,
		bHasArmor = 1,
		fileHelmetModel = "",
--		bHasLight = 0,
		aggression = 0.3,	-- 0 = passive, 1 = total aggression
		commrange = 30.0,
--		cohesion = 5,
		attackrange = 70,
		horizontal_fov = 160,
		eye_height = 2.1,
		forward_speed = 1.66,
		back_speed = 2.5,
		max_health = 250,	
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
		aicharacter_character = "MutantRear",
		pathname = "none",
		pathsteps = 0,
		pathstart = 0,
		ReinforcePoint = "none",
		fileModel = "Objects/characters/mutants/Mutant_rear/Mutant_rear.cgf",
		fileBackpackModel = "Objects/characters/mutants/Accessories/Mut_rockets.cgf",
		bTrackable=1,

		speed_scales={
			run			=2.8,
			crouch	=.8,
			prone		=.5,
			xrun		=1.5,
			xwalk		=.81,
			rrun		=3.63,
			rwalk		=.94,
			},
		AniRefSpeeds = {
			WalkFwd = 1.09,
			WalkSide = 1.09,
			WalkBack = 1.09,
			WalkRelaxedFwd = 1.09,
			WalkRelaxedSide = 1.09,
			WalkRelaxedBack = 1.09,
			XWalkFwd = 1.09,
			XWalkSide = 1.09, 
			XWalkBack = 1.09,
			XRunFwd = 4.5,
			XRunSide = 3.5, 
			XRunBack = 4.5,
			RunFwd = 4.88,
			RunSide = 4.88,
			RunBack = 4.88,
			CrouchFwd = 1.09,
			CrouchSide = 1.09,
			CrouchBack = 1.09,
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
		ellipsoid_height = 1.1,		-- offset from ground
		x = 0.60,			-- radius
		y = 0.10,
		z = 0.4,			-- half height
	},
	PlayerDimCrouch = {
		height = 2.2,
		eye_height = 2.1,
		ellipsoid_height = 0.7,
		x = 0.4,
		y = 0.10,
		z = 0.3,
	},
	PlayerDimProne = {
		height = 0.4,
		eye_height = 0.5,
		ellipsoid_height = 0.35,
		x = 1.00,
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
--		{"swalkfwd",     3,		666},
--		{"swalkfwd",    20,		666},
--		{"cwalkfwd",	4,			666},
--		{"cwalkfwd",	21,			666},
--		{"attack_melee1", 13, KEYFRAME_APPLY_MELEE},
--		{"attack_melee1", 21, KEYFRAME_APPLY_MELEE},
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


	JumpSelectionTable = {

					--start pause		--jump duration

		-- back jumps
		{
			{"jump_duct_vertical",	0.01, 			0.8},
		},
		-- forward jumps
		{
			{"jump_duct_vertical",	0.01, 			1.0},
		},
		-- right jumps
		{
			{"jump_duct_vertical",	0.01, 			1.0},
			{"jump_duct_vertical",	0.01, 			1.0},
			{"jump_duct_vertical",	0.05, 			1.2},
		},
		-- left jumps
		{
			{"jump_duct_vertical",	0.05, 			1.0},
			{"jump_duct_vertical",	0.01, 			1.0},
			{"jump_duct_vertical",	0.05, 			1.2},
		},

	},	

}

