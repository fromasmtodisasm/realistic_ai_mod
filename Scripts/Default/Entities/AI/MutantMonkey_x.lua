ABBERATION_GRAV_MULT = 3;
MutantMonkey_x = {

	NoFallDamage = 1,
------------------------------------------------------------------------------------

		
	MeleeHitType="melee_slash",
------------------------------------------------------------------------------------

	MUTANT = 1,
	NEVER_FIRE = 1,
	isSelfCovered = 0,
	lastMeleeAttackTime = 0,

	PropertiesInstance = {
		sightrange = 35,
		soundrange = 10,	-- rememeber that sound ranges intersect and sound range for AI doubles when in alert
		groupid = 154,
		aibehavior_behaviour = "Job_Observe",
		},

	Properties = {
		special = 0,
		fJumpAngle = 20,
		gravity_multiplier = ABBERATION_GRAV_MULT,
		bSingleMeleeKillAI = 0,
		fDamageMultiplier = 1,
		JUMP_TABLE = "BIG_ABBERATION",
		KEYFRAME_TABLE = "MUTANT_MONKEY",
		SOUND_TABLE = "MUTANT_MONKEY",
		fMeleeDamage = 100,
		fMeleeDistance = 3,
		suppressedThrhld = 5.5,
		bAffectSOM = 1,
		bSleepOnSpawn = 1,
		bHelmetOnStart = 0,
		bHasArmor = 1,
		fileHelmetModel = "",
--		bHasLight = 0,
		aggression = 0.2,	-- 0 = passive, 1 = total aggression
		commrange = 30.0,
--		cohesion = 5,
		attackrange = 70,
		horizontal_fov = 160,
		eye_height = 1.1,
		forward_speed = 1.54,
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
		SoundPack = "mutant_ab2",
		aicharacter_character = "Abberation",
		pathname = "none",
		pathsteps = 0,
		pathstart = 0,
		ReinforcePoint = "none",
		--Objects\characters\Mutants\mutant_aberration2\Mutant_Aberration2.cgf
		fileModel = "Objects/characters/Mutants/mutant_aberration2/Mutant_Aberration2.cgf",				
		bTrackable=1,
		ImpulseParameters = {
			rmin = 1,
			rmax = 1,
			impulsive_pressure = 200,
			rmin_occlusion =0,
			occlusion_res =0,
			occlusion_inflate = 0,
		},

		speed_scales={
			run			=2.48,
			crouch	=.8,
			prone		=.5,
			xrun		=1.5,
			xwalk		=.81,
			rrun		=3.63,
			rwalk		=.94,
			},
		AniRefSpeeds = {
			RunFwd = 5.39,
			RunBack = 5.39,
			RunSide = 5.39,
			WalkFwd = 0.66,
			WalkBack = 0.66,
			WalkSide = 0.66,
			WalkRelaxedFwd = 0.66,
			WalkRelaxedSide = 0.66,
			WalkRelaxedBack = 0.66,
			XWalkFwd = 0.66,
			XWalkSide = 0.66, 
			XWalkBack = 0.66,
			XRunFwd = 4.5,
			XRunSide = 3.5, 
			XRunBack = 4.5,
			CrouchFwd = 0.66,
			CrouchSide = 0.66,
			CrouchBack = 0.66,	
		},
	},
	
	PhysParams = {
		mass = 80,
		height = 2.8,
		eyeheight = 2.7,
		sphereheight = 1.2,
		radius = 0.45,
	},


--pe_player_dimensions structure
	PlayerDimNormal = {
		height = 1,
		eye_height = .9,
		ellipsoid_height = .875,
--		x = 0.5,
		x = 0.45,
		y = 0.10,
		z = 0.35,
	},
	PlayerDimCrouch = {
		height = 1,
		eye_height = .9,
		ellipsoid_height = .9,
--		x = .5,
		x = .45,	
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
--		{"attack_melee1", 8, KEYFRAME_APPLY_MELEE},
--		{"attack_melee2", 8, KEYFRAME_APPLY_MELEE},
--		{"attack_melee3", 8, KEYFRAME_APPLY_MELEE},
--	},

	GrenadeType = "ProjFlashbangGrenade",



	AI_DynProp = {
		air_control = 0.4,  -- default 0.6
		gravity = ABBERATION_GRAV_MULT*9.81,
		swimming_gravity = -1.0,
		inertia = 10.0,
		swimming_inertia = 1.0,
		nod_speed = 60.0,
		min_slide_angle = 46,
		max_climb_angle = 60,
		min_fall_angle = 70,
		max_jump_angle = 55,
	},


	ImpulseParameters = {
		rmin = 1,
		rmax = 1,
		impulsive_pressure = 200,
		rmin_occlusion =0,
		occlusion_res =0,
		occlusion_inflate = 0,
	},



}

-------------------------------------------------------------------------------------------------------
function MutantMonkey_x:OnInitCustom(  )


System:Log("MutantMonkey_x onInitCustom ");

	self.cnt:CounterAdd("SuppressedValue", -2.0 );

end

---------------------------------------------------------------------------------------------------------
function MutantMonkey_x:OnResetCustom()

System:Log("MutantMonkey_x onResetCustom ");

	self.cnt:CounterSetValue("SuppressedValue", 0.0 );
	self.isSelfCovered = 0;
	self.lastMeleeAttackTime = 0;
	
end
---------------------------------------------------------------------------------------------------------

