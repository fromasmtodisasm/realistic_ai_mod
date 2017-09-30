MercCover_x = {

	PropertiesInstance = {
		sightrange = 35,
		soundrange = 10,	-- rememeber that sound ranges intersect and sound range for AI doubles when in alert
		aibehavior_behaviour = "Job_StandIdle",
		groupid = 154,
		fileHelmetModel = "",
		bHelmetOnStart = 0,
		specialInfo= "",
		bHasLight = 0,
		bGunReady = 0,
	},


	Properties = {
			bAwareOfPlayerTargeting = 0,
			fMeleeDistance = 2,
			fDamageMultiplier = 1,
			fRushPercentage=-1,
			customParticle = "none",
			fRocketSpeed = 10,
			fRocketDamageOverride = -1,
			bShootSmartRocketsForward = 1,
			bDumbRockets = 0,
			bSmartMelee = 0,
			bHasShield = 0,
			special = 0,
			bInvulnerable = 0,
			KEYFRAME_TABLE = "BASE_HUMAN_MODEL",
			SOUND_TABLE = "MERC_COVER",
			suppressedThrhld = 5.5,
			bAffectSOM = 1,
			bSleepOnSpawn = 1,
			
		
			bHasArmor = 1,
			dropArmor = 5,

			horizontal_fov = 160,
			eye_height = 2.1,
			forward_speed = 1.27,
			back_speed = 1.27,
			responsiveness = 7,
			species = 1,
			fSpeciesHostility = 2,
			fGroupHostility = 0,
			fPersistence = 0.5,
			AnimPack = "Basic",
			SoundPack = "dialog_template",

			aicharacter_character = "Cover",
			fileModel = "Objects/characters/mercenaries/Merc_cover/merc_cover.cgf",
			max_health = 70,
			pathname = "none",
			pathsteps = 0,
			pathstart = 0,
			ReinforcePoint = "none",
			bPushPlayers = 1,
			bPushedByPlayers = 1,

			AttachHelmetToBone = "hat_bone",

		aggression = 0.3,	-- 0 = passive, 1 = total aggression


		commrange = 30.0,
		attackrange = 70,
		accuracy = 0.6,

		equipEquipment = "none",
		equipDropPack = "none",
		bTrackable=1,
		speed_scales={
			run			=3.63,
			crouch	=.8,
			prone		=.5,
			xrun		=1.5,
			xwalk		=.81,
			rrun		=3.63,
			rwalk		=.94,
		},
		AniRefSpeeds = {
	
			WalkFwd = 1.27,
			WalkSide = 1.22,
			WalkBack = 1.29,
			WalkRelaxedFwd = 1.0487,
			WalkRelaxedSide = 1.22,
			WalkRelaxedBack = 1.0,
			XWalkFwd = 1.2,
			XWalkSide = 1.0, 
			XWalkBack = 0.94,
			XRunFwd = 4.5,
			XRunSide = 3.5, 
			XRunBack = 4.5,
			RunFwd = 2.76,
			RunSide = 3.57,
			RunBack = 2.76,
			CrouchFwd = 1.02,
			CrouchSide = 1.02,
			CrouchBack = 1.04,	
		},
	},

	PhysParams = {
		mass = 80,
		height = 1.8,
		eyeheight = 1.7,
		sphereheight = 1.2,
		radius = 0.45,
	},

--pe_player_dimensions structure
	PlayerDimNormal = {
		height = 1.8,
		eye_height = 1.7,
		ellipsoid_height = 1.2,
		x = 0.45,
		y = 0.45,
		z = 0.6,
	},
	PlayerDimCrouch = {
		height = 1.5,
		eye_height = 1.0,
		ellipsoid_height = 0.95,
		x = 0.45,
		y = 0.45,
		z = 0.5,
	},
	PlayerDimProne = {
		height = 0.4,
		eye_height = 0.5,
		ellipsoid_height = 0.35,
		x = 0.45,
		y = 0.45,
		z = 0.2,
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
		
	  water_damping = 0.1,
	  water_resistance = 1000,
	},
	BulletImpactParams = {
    stiffness_scale = 73,
    max_time_step = 0.02
  },


	-- Reloading related

	AI_DynProp = {
		air_control = 0.9, --filippo:was 0.4  -- default 0.6
		gravity = 9.81,--18.81,
		jump_gravity = 15.0,--gravity used when the player jump, if this parameter dont exist normal gravity is used also for jump.
		swimming_gravity = -1.0,
		inertia = 10.0,
		swimming_inertia = 1.0,
		nod_speed = 50.0,--filippo:was 60
		min_slide_angle = 46,
		max_climb_angle = 55,
		min_fall_angle = 70,
		max_jump_angle = 50,
	},



--	SoundEvents={
--		{"srunfwd",		7  },
--		{"srunfwd",		19 },
--		{"srunback",		5  },
--		{"srunback",		14 },
--		{"xwalkfwd", 		2  },
--		{"xwalkfwd", 		26 },
--		{"xwalkback", 		0  },
--		{"xwalkback", 		23 },
--		{"swalkback", 		0  },
--		{"swalkback", 		16 },
--		{"swalkfwd",  		2  },
--		{"swalkfwd",  		19 },
--
--		{"cwalkback",		9  },
--		{"cwalkback",		33 },
--		{"cwalkfwd",		12 },
--		{"cwalkfwd",		31 },
--
  --  		{"pwalkfwd",		3  },
	--	{"pwalkback",		3  },
--
--		{"arunback",		6  },
--		{"arunback", 		15 },
--		{"arunfwd", 		7  },
--		{"arunfwd", 		19 },
--		{"awalkback", 		1  },
--		{"awalkback", 		17 },
--		{"awalkfwd", 		1  },
--		{"awalkfwd", 		20 },
--		
--		{"_fixfence_loop",	8,	Sound:Load3DSound("SOUNDS/items/ratchet.wav",SOUND_UNSCALABLE,100,5,30)},
--		
--		{"cwalkfwd",		1,Sound:Load3DSound("SOUNDS/ai/pain/pain5.wav",SOUND_UNSCALABLE,250,150,230)},
--
--},

	GrenadeType = "ProjFlashbangGrenade",

------------------------------------------------------------------------------------

------------------------------------------------------------------------------------


}

-----------------------------------------------------------------------------------------------------
