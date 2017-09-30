-- Модифицировал E1LOCK
ABBERATION_GRAV_MULT = 3  -- Множитель гравитации.
MutantMonkey_x = {
	NoFallDamage = 1, -- Не получать повреждения при падении с большой высоты.
	MeleeHitType="melee_slash",-- Тип ближнего удара.
	MUTANT = "predator",
	-- DoNotAvoidCollisionsOnTheMoveForward = 1, -- Не избегать столкновений при движении вперёд. Бывает, мутант не может пройти сквозь дверной проём потому, что его носит из стороны в сторону.
	NEVER_FIRE = 1, -- Никогда не стелять.
	refractionValue = 1,

	PropertiesInstance = {
			sightrange = 110,
			soundrange = 10,
			aibehavior_behaviour = "MutantJob_Idling",
			groupid = 100,
			specialInfo= "",
			attackrange = 30,
			accuracy = .7,
			aggression = 0,
	},

	Properties = {
			bMayBeInvisible = 1, -- Может ли становиться невидимым? 1-да,0-нет.
			aicharacter_character = "Chimp",
			equipEquipment = "none",
			equipDropPack = "none",
			bAwareOfPlayerTargeting = 1,
			fMeleeDamage = 300, -- Урон, наносимый этим юнитом урон в ближнем бою. -- 255
			fMeleeDistance = .5, -- Определяет дистанцию ближнего боя мутанта.
			-- fDamageMultiplier = 1,
			fJumpAngle = 20, -- Угол прыжка. --38
			gravity_multiplier = ABBERATION_GRAV_MULT, -- Модификатор гравитации (вынесен наверх)
			bSingleMeleeKillAI = 0, -- ИИ погибают от одного удара этой сущности (наносится 10000 едениц урона).
			JUMP_TABLE = "SMALL_ABBERATION",
			KEYFRAME_TABLE = "MUTANT_MONKEY",
			SOUND_TABLE = "MUTANT_MONKEY",
			fRushPercentage=-1,
			bSmartMelee = 1,
			bInvulnerable = 0,
			suppressedThrhld = 5.5,
			bAffectSOM = 1,
			bSleepOnSpawn = 1,
			bHasArmor = 0,
			horizontal_fov = 160,
			eye_height = 1.1,
			forward_speed = 1.59,
			back_speed = 1.59,
			responsiveness = 7,
			fSpeciesHostility = 2,
			fGroupHostility = 0,
			fPersistence = 0,
			AnimPack = "Basic",
			SoundPack = "",
			fileModel = "Objects/characters/Mutants/Mutant_Aberration3/mutant_aberration3.cgf",
			max_health = 255,
			pathname = "none",
			pathsteps = 0,
			pathstart = 0,
			ReinforcePoint = "none",
			bPushPlayers = 1,
			bPushedByPlayers = 1,
			commrange = 40,
			species = 100,
			special = 0,
			bTrackable = 1,
			bTakeProximityDamage = 1,
		speed_scales={
			run			= 3.29,
			crouch		= 1,
			prone		= 1,
			xrun		= 3.29,
			xwalk		= 1,
			rrun		= 3.29,
			rwalk		= 1,
			},
		AniRefSpeeds = {
			RunFwd = 5.23,
			RunBack = 5.23,
			RunSide = 5.23,
			WalkFwd = 1.59,
			WalkBack = 1.59,
			WalkSide = 1.59,
			WalkRelaxedFwd = 1.59,
			WalkRelaxedSide = 1.59,
			WalkRelaxedBack = 1.59,
			XWalkFwd = 1.59,
			XWalkSide = 1.59,
			XWalkBack = 1.59,
			XRunFwd = 4.5,
			XRunSide = 3.5,
			XRunBack = 4.5,
			CrouchFwd = 1.59,
			CrouchSide = 1.59,
			CrouchBack = 1.59,
		},
	},

	PhysParams = {
		mass = 120,
		height = 2.8,
		eyeheight = 2.7,
		sphereheight = 1.2,
		radius = .45,
	},
	PlayerDimNormal = {
		height = 1,
		eye_height = .9,
		ellipsoid_height = .875,
--		x = .5,
		x = .45,
		y = .10,
		z = .35,
	},
	PlayerDimCrouch = {
		height = 1,
		eye_height = .9,
		ellipsoid_height = .9,
--		x = .5,
		x = .45,
		y = .10,
		z = .7,
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
	GrenadeType = "ProjFlashbangGrenade",
	AI_DynProp = {
		air_control = .4, -- default .6
		gravity = ABBERATION_GRAV_MULT*9.81,
		swimming_gravity = -.5,
		inertia = 10,
		swimming_inertia = .5,
		nod_speed = 60,
		min_slide_angle = 46,
		max_climb_angle = 60,
		min_fall_angle = 70,
		max_jump_angle = 55,
	},
	ImpulseParameters = {
		rmin = 2,
		rmax = 3,
		impulsive_pressure = 100,
		rmin_occlusion = 0,
		occlusion_res = 0,
		occlusion_inflate = 0,
	},
}
-------------------------------
--function MutantMonkey_x:OnInitCustom()


--System:Log("MutantMonkey_x onInitCustom ")

--	self.cnt:CounterAdd("SuppressedValue",-2)

--end

---------------------------------
--function MutantMonkey_x:OnResetCustom()

--System:Log("MutantMonkey_x onResetCustom ")

--	self.cnt:CounterSetValue("SuppressedValue",0)
--	self.isSelfCovered = 0
--	self.lastMeleeAttackTime = 0

--end
---------------------------------

