MutantCover_x = {
	NoFallDamage = 1,
	MeleeHitType="melee_slash",
	MUTANT = "big",
	ROCKET_ORIGIN_KEYFRAME = KEYFRAME_FIRE_RIGHTHAND,
	isSelfCovered = 0,
	lastMeleeAttackTime = 0,

	PropertiesInstance = {
			sightrange = 110,
			soundrange = 10,
			groupid = 100,
			aibehavior_behaviour = "MutantJob_Idling",
			fScale=1,
			attackrange = 300,
			accuracy = 0,
			aggression = .3,
		},

	Properties = {
		customParticle = "none", -- Можно указать свой эффект при выстреле ракетой.
		fDamageMultiplier = .1,
		KEYFRAME_TABLE = "MUTANT_BIG",
		SOUND_TABLE = "MUTANT_BIG",
		bAwareOfPlayerTargeting = 1,
		fRushPercentage=-1,
		fRocketSpeed = 100, -- Скорость ракеты.
		fRocketDamageOverride = -1, -- При значении больше нуля указывает повреждения, наносимые ракетой.
		bShootSmartRocketsForward = 1, -- При установке на нуль мутант выпускает ракету "через верх".
		bDumbRockets = 0, -- При установке не нуль мутант стреляет самонаводящейся ракетой. Надо доработать.
		fMeleeDamage = 500,
		fMeleeDistance = 2,
		bSingleMeleeKillAI = 0,
		bAffectSOM = 1,
		suppressedThrhld = 5.5,
		bSleepOnSpawn = 1,
		bHasArmor = 1,
		fileHelmetModel = "",
		bHelmetOnStart = 1,
		commrange = 30,
		horizontal_fov = 160,
		eye_height = 2.1,
		forward_speed = 1.83,
		back_speed = 1.83,
		max_health = 255,
		responsiveness = 7,
		species = 100,
		special = 0,
		fSpeciesHostility = 2,
		fGroupHostility = 0,
		fPersistence = 0,
		equipEquipment = "CoverRL",
		equipDropPack = "none",
		AnimPack = "Basic",
		SoundPack = "mutantvoice",
		aicharacter_character = "Big",
		pathname = "none",
		pathsteps = 0,
		pathstart = 0,
		ReinforcePoint = "none",
		fileModel = "Objects/characters/mutants/mutant_big/mutant_big.cgf",
		bTrackable=1,
		bSmartMelee = 1,
		bInvulnerable = 0,
		bPushPlayers = 1,
		bPushedByPlayers = 0,
		bTakeProximityDamage = 1,

		speed_scales={
			run			=1.83,
			crouch		=.8,
			prone		=.5,
			xrun		=1.5,
			xwalk		=.81,
			rrun		=1.83,
			rwalk		=.94,
			},
		AniRefSpeeds = {
			WalkFwd = 1.83,
			WalkSide = 1.83,
			WalkBack = 1.83,
			WalkRelaxedFwd = 1.83,
			WalkRelaxedSide = 1.83,
			WalkRelaxedBack = 1.83,
			XWalkFwd = 1.83,
			XWalkSide = 1.83,
			XWalkBack = 1.83,
			XRunFwd = 4.5,
			XRunSide = 3.5,
			XRunBack = 4.5,
			RunFwd = 3.36,
			RunSide = 3.36,
			RunBack = 3.36,
			CrouchFwd = 1.83,
			CrouchSide = 1.83,
			CrouchBack = 1.83,
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
		-- height = 2.2,
		-- eye_height = 2.1,
		-- ellipsoid_height = 1.7,
		-- x = .710,
		-- y = .10,
		-- z = .7,
		height = 2.2,
		eye_height = 2.1,
		ellipsoid_height = 1.7,
		x = .710,
		y = .10,
		z = 1.7, -- .7 -- 1.7 - Чтобы мог преодалевать препятсвия в виде косяков.
	},
	PlayerDimCrouch = {
		height = 2.2,
		eye_height = 2.1,
		ellipsoid_height = 1.9,
		x = .710,
		y = .10,
		z = 1.7, -- .7
	},
	PlayerDimProne = {
		height = .4,
		eye_height = .5,
		ellipsoid_height = .35,
		x = .45,
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

    water_damping = .5,
    water_resistance = 1000,
	},
	BulletImpactParams = {
    stiffness_scale = 40,
    impulse_scale = 5,
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
--		{"srunfwd",	0,			},
--		{"srunfwd",	10,			},
--		{"srunfwd",	20,			},
--		{"srunback",	5,			},
--		{"srunback",	13,			},
--		{"swalkback",2,			},
--		{"swalkback",18,			},
--		{"swalkfwd",  3,			},
--		{"swalkfwd", 20,			},
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

-------------------------------
function MutantCover_x:OnInitCustom()


System:Log("MutantCover_x onInitCustom ")

	self.cnt:CounterAdd("SuppressedValue",-2)

end

---------------------------------
function MutantCover_x:OnResetCustom()

System:Log("MutantCover_x onResetCustom ")

	self.cnt:CounterSetValue("SuppressedValue",0)
	self.isSelfCovered = 0 
	self.lastMeleeAttackTime = 0 

end
---------------------------------

