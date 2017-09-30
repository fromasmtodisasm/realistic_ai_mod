MutantRear_x = {

	NoFallDamage = 1,
	refractionValue = 1,
	MeleeHitType="melee_slash",
	MUTANT = "stealth",

	PropertiesInstance = {
			sightrange = 110,
			soundrange = 10,	-- rememeber that sound ranges intersect and sound range for AI doubles when in alert
			aibehavior_behaviour = "MutantJob_Idling",
			groupid = 100,
			bHasLight = 0,
			attackrange = 300,
			accuracy = 0,
			aggression = .3,
		},

	Properties = {
		bAffectSOM = 1,
		-- fDamageMultiplier = .5,
		KEYFRAME_TABLE = "MUTANT_STEALTH",
		SOUND_TABLE = "MUTANT_FAST",
		fMeleeDamage = 80,
		fMeleeDistance = 1.2,
		bSingleMeleeKillAI = 0,
		suppressedThrhld = 5.5,
		special = 0,
		bInvulnerable = 0,
		fRushPercentage=-1,
		bSleepOnSpawn = 1,
		bAwareOfPlayerTargeting = 1,
		bHasArmor = 0,
		fileHelmetModel = "",
		bHelmetOnStart = 0,
		commrange = 30,
		cohesion = 5,
		horizontal_fov = 160,
		eye_height = 2.1,
		forward_speed = 1.09,
		back_speed = 1.09,
		max_health = 255,
		responsiveness = 7,
		species = 100,
		fSpeciesHostility = 2,
		fGroupHostility = 0,
		fPersistence = 0,
		equipEquipment = "Mp5",
		equipDropPack = "MP5_pickup",
		AnimPack = "Basic",
		SoundPack = "mutant_readability",
		aicharacter_character = "Morph",
		pathname = "none",
		pathsteps = 0,
		pathstart = 0,
		ReinforcePoint = "none",
		fileModel = "Objects/characters/Mutants/mutant_stealth/mutant_stealth_norockets.cgf",
		-- fileBackpackModel = "Objects/characters/mutants/Accessories/Mut_rockets.cgf",
		fileBackpackModel = "",
		bTrackable=1,
		bSmartMelee = 1,
		bPushPlayers = 1,
		bPushedByPlayers = 1,
		bTakeProximityDamage = 1,

		speed_scales={
			run			=3.7,
			crouch		=1,
			prone		=.5,
			xrun		=1.5,
			xwalk		=.81,
			rrun		=3.7,
			rwalk		=1,
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
			RunFwd = 4.04,
			RunSide = 4.04,
			RunBack = 4.04,
			CrouchFwd = 1.25,
			CrouchSide = 1.25,
			CrouchBack = 1.25,
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
		x = .60,			-- radius
		y = .10,
		z = .4,			-- half height
	},
	PlayerDimCrouch = {
		height = 2.2,
		eye_height = 2.1,
		ellipsoid_height = .7,
		x = .4,
		y = .10,
		z = .3,
	},
	PlayerDimProne = {
		height = .4,
		eye_height = .5,
		ellipsoid_height = .35,
		x = 1.00,
		y = .45,
		z = 4.2,
	},







	DeadBodyParams = {
		sim_type = 1,
	  max_time_step = .025,
	  gravityz = -7.5,
	  sleep_speed = .025,
	  damping = .3,
	  freefall_gravityz = -9.81,
	  freefall_damping = .1,

	  lying_mode_ncolls = 4,
	  lying_gravityz = -5,
	  lying_sleep_speed = .065,
	  lying_damping = 1,
	},
	BulletImpactParams = {
    stiffness_scale = 73,
    max_time_step = .02
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
--		{"swalkback",2,			666},
--		{"swalkback",18,		666},
--		{"swalkfwd",  3,		666},
--		{"swalkfwd", 20,		666},
--		{"cwalkfwd",	4,			666},
--		{"cwalkfwd",	21,			666},
--		{"attack_melee1",13,KEYFRAME_APPLY_MELEE},
--		{"attack_melee1",21,KEYFRAME_APPLY_MELEE},
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
			{"jump_duct_vertical",	.01,			.8},
		},
		-- forward jumps
		{
			{"jump_duct_vertical",	.01,			1},
		},
		-- right jumps
		{
			{"jump_duct_vertical",	.01,			1},
			{"jump_duct_vertical",	.01,			1},
			{"jump_duct_vertical",	.05,			1.2},
		},
		-- left jumps
		{
			{"jump_duct_vertical",	.05,			1},
			{"jump_duct_vertical",	.01,			1},
			{"jump_duct_vertical",	.05,			1.2},
		},

	},

}

