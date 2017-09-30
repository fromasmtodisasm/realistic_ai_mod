Worm_x = {
------------

------------


	PropertiesInstance ={
		sightrange = 110,
		soundrange = 10,	-- rememeber that sound ranges intersect and sound range for AI doubles when in alert
		groupid = 100,
		aibehavior_behaviour = "MutantJob_Idling",
		},

	Properties = {
		KEYFRAME_TABLE = "WORM",
		SOUND_TABLE = "WORM",
		fMeleeDamage = 100,
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
		fileModel = "Objects/characters/mutants/mutant_slug/mutant_slug.cgf",
		bTrackable=0,

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
			WalkFwd = .67,
			WalkSide = .67,
			WalkBack = .67,
			RunFwd = 1.93,
			RunSide = 1.93,
			RunBack = 1.93,
			XWalkFwd = 1.2,
			XWalkSide = 1,
			XWalkBack = .94,
			XRunFwd = 4.5,
			XRunSide = 3.5,
			XRunBack = 4.5,
			CrouchFwd = 1.02,
			CrouchSide = 1.02,
			CrouchBack = 1.04,
		},
	},
	
	PhysParams = {
		mass = 20,
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
		x = .35,
		y = .8,
		z = .2,
	},
	PlayerDimCrouch = {
		height = .6,
		eye_height = .5,
		ellipsoid_height = .6,
		x = .35,
		y = .8,
		z = .2,
	},
	PlayerDimProne = {
		height = .6,
		eye_height = .5,
		ellipsoid_height = .5,
		x = .35,
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
--		{"swalkfwd",  3,		666},
--		{"swalkfwd", 20,		666},
--		{"awalkfwd",  3,		666},
--		{"awalkfwd", 20,		666},
--		{"attack_melee1",8,KEYFRAME_APPLY_MELEE},
--	},

	GrenadeType = "ProjFlashbangGrenade",


}
-------------------------------
function Worm_x:OnInitCustom()


end

---------------------------------
function Worm_x:OnResetCustom()

	
end
---------------------------------
