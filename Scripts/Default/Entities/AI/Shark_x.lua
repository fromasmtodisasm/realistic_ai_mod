Shark_x = {
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------


	PropertiesInstance ={
		sightrange = 80,
		soundrange = 10,	-- rememeber that sound ranges intersect and sound range for AI doubles when in alert
		groupid = 154,
		aibehavior_behaviour = "Job_PatrolPathNoIdle",
		},

	Properties = {
		fMeleeDamage = 100,
		fMeleeDistance = 4,
		KEYFRAME_TABLE = "PIG",
		SOUND_TABLE = "PIG",
		bAffectSOM = 0,
		suppressedThrhld = 5.5,
		bSleepOnSpawn = 1,
		bHelmetOnStart = 0,
		bHasArmor = 1,
--		fileHelmetModel = "",
--		bHasLight = 0,
		aggression = 0.3,	-- 0 = passive, 1 = total aggression
		commrange = 30.0,
--		cohesion = 5,
		attackrange = 70,
		horizontal_fov = 160,
		eye_height = 0.5,
		forward_speed = 3,
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
		SoundPack = "pig",
		aicharacter_character = "Screwed",
		pathname = "none",
		pathsteps = 0,
		pathstart = 0,
		ReinforcePoint = "none",
		--Objects\characters\animals\Pecari\pecari.cgf 
		fileModel = "Objects/characters/animals/GreatWhiteShark/greatwhiteshark.cg",
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
			WalkFwd = 0.65,
			WalkSide = 0.65,
			WalkBack = 0.65,
			RunFwd = 2.74,
			RunSide = 2.74,
			RunBack = 2.74,
			XWalkFwd = 0.65,
			XWalkSide = 0.65, 
			XWalkBack = 0.65,
			XRunFwd = 4.5,
			XRunSide = 3.5, 
			XRunBack = 4.5,
			CrouchFwd = 0.65,
			CrouchSide = 0.65,
			CrouchBack = 0.65,
		},
	},
	
	PhysParams = {
		mass = 2900,
		height = 1.8,
		eyeheight = 1.7,
		sphereheight = 1.2,
		radius = 0.45,
	},

--pe_player_dimensions structure
	PlayerDimNormal = {
		height = 0.6,
		eye_height = 0.3,
		ellipsoid_height = -0.6,
		x = 2.5,
		y = 1,
		z = 0.5,
	},
	PlayerDimCrouch = {
		height = 0.6,
		eye_height = 0.5,
		ellipsoid_height = .6,
		x = 2.5,
		y = 1,
		z = 1,
	},
	PlayerDimProne = {
		height = 0.6,
		eye_height = 0.5,
		ellipsoid_height = .5,
		x = 2.5,
		y = 1,
		z = 1,
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
	  lying_damping = 1.0
	},
	BulletImpactParams = {
    stiffness_scale = 73,
    max_time_step = 0.02
  },

	IsFish = 1,

	-- Reloading related

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
--		{"cwalkback",	17,			666},
--		{"cwalkback",	31,			666},
--		{"cwalkfwd",	4,			666},
--		{"cwalkfwd",	21,			666},
--	},

	GrenadeType = "ProjFlashbangGrenade",


}
-------------------------------------------------------------------------------------------------------
function Shark_x:OnInitCustom(  )


System:Log("Shark_x onInitCustom ");

	self.cnt:CounterAdd("SuppressedValue", -2.0 );

end

---------------------------------------------------------------------------------------------------------
function Shark_x:OnResetCustom()

System:Log("Shark_x onResetCustom ");

	self.cnt:CounterSetValue("SuppressedValue", 0.0 );
	self.isSelfCovered = 0;
	self.lastMeleeAttackTime = 0;
	
end
---------------------------------------------------------------------------------------------------------
