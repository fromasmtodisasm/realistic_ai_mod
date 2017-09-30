Pig_x = {
	ANIMAL = "pig",
	PropertiesInstance ={
		sightrange = 110,
		soundrange = 10,	-- rememeber that sound ranges intersect and sound range for AI doubles when in alert
		groupid = 998,
		aibehavior_behaviour = "Pig",
		},

	Properties = {

		KEYFRAME_TABLE = "PIG",
		SOUND_TABLE = "PIG",
		bAffectSOM = 0,
		suppressedThrhld = 5.5,
		bSleepOnSpawn = 1,
		bHelmetOnStart = 0,
		bHasArmor = 1,
--		fileHelmetModel = "",
--		bHasLight = 0,
		aggression = .3,	-- 0 = passive,1 = total aggression
		commrange = 30,
--		cohesion = 5,
		attackrange = 70,
		horizontal_fov = 160,
		eye_height = 2.1,
		forward_speed = 3,
		back_speed = 2.5,
		max_health = 70,
		accuracy = .6,
		responsiveness = 7,
		species = 1,
		fSpeciesHostility = 2,
		fGroupHostility = 0,
		fPersistence = 0,
		equipEquipment = "none",
		equipDropPack = "none",
		AnimPack = "Basic",
		SoundPack = "pig",
		aicharacter_character = "Pig",
		pathname = "none",
		pathsteps = 0,
		pathstart = 0,
		ReinforcePoint = "none",
		--Objects\characters\animals\Pecari\pecari.cgf 
		fileModel = "Objects/characters/animals/Pecari/pecari.cgf ",
		bTrackable=0,

		speed_scales={
			run			=4.24,
			crouch	=1,
			prone		=1,
			xrun		=1,
			xwalk		=1,
			rrun		=4.24,
			rwalk		=1,
			},
		AniRefSpeeds = {
			WalkFwd = .65,
			WalkSide = .65,
			WalkBack = .65,
			RunFwd = 2.74,
			RunSide = 2.74,
			RunBack = 2.74,
			XWalkFwd = .65,
			XWalkSide = .65,
			XWalkBack = .65,
			XRunFwd = 4.5,
			XRunSide = 3.5,
			XRunBack = 4.5,
			CrouchFwd = .65,
			CrouchSide = .65,
			CrouchBack = .65,
		},
	},
	
	PhysParams = {
		mass = 80,
		height = 1.8,
		eyeheight = 1.7,
		sphereheight = 1.2,
		radius = .45,
	},

--pe_player_dimensions structure
	PlayerDimNormal = {
		height = .6,
		eye_height = .5,
		ellipsoid_height = .6,
		x = .55,
		y = .8,
		z = .2,
	},
	PlayerDimCrouch = {
		height = .6,
		eye_height = .5,
		ellipsoid_height = .6,
		x = .55,
		y = .8,
		z = .2,
	},
	PlayerDimProne = {
		height = .6,
		eye_height = .5,
		ellipsoid_height = .5,
		x = .55,
		y = .8,
		z = .2,
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
	  lying_damping = 1
	},
	BulletImpactParams = {
    stiffness_scale = 73,
    max_time_step = .02
},

	-- Reloading related

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
--		{"cwalkback",	17,			666},
--		{"cwalkback",	31,			666},
--		{"cwalkfwd",	4,			666},
--		{"cwalkfwd",	21,			666},
--	},

	GrenadeType = "ProjFlashbangGrenade",


}
-------------------------------
function Pig_x:OnInitCustom()


System:Log("Pig_x onInitCustom ")

	self.cnt:CounterAdd("SuppressedValue",-2)

end

---------------------------------
function Pig_x:OnResetCustom()

System:Log("Pig_x onResetCustom ")

	self.cnt:CounterSetValue("SuppressedValue",0)
	self.isSelfCovered = 0 
	self.lastMeleeAttackTime = 0 
	
end
---------------------------------
