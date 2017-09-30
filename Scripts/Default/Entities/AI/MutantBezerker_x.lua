MutantBezerker_x = {
	NoFallDamage = 1,
------------------------------------------------------------------------------------

		
	MeleeHitType="melee_slash",
------------------------------------------------------------------------------------

	MUTANT = 1,

	PropertiesInstance = {
		sightrange = 80,
		soundrange = 10,	-- rememeber that sound ranges intersect and sound range for AI doubles when in alert
		aibehavior_behaviour = "BezerkerIdle",
		groupid = 154,
		},

	Properties = {
		fMeleeDamage = 100,
		fMeleeDistance = 4,
		fDamageMultiplier = 1,
		KEYFRAME_TABLE = "MUTANT_ABBERATION",
		SOUND_TABLE = "MUTANT_BESERKER",
		bAffectSOM = 1,
		suppressedThrhld = 5.5,
		bSleepOnSpawn = 1,
		bHelmetOnStart = 0,
		bHasArmor = 1,
		fileHelmetModel = "",
--		bHasLight = 0,
		aggression = 0.3,	-- 0 = passive, 1 = total aggression
		commrange = 30.0,
--		cohesion = 5,
		attackrange = 70,
		horizontal_fov = 160,
		eye_height = 2.1,
		forward_speed = 2.1,
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
		SoundPack = "mutant_ab1",

		aicharacter_character = "Bezerker",
		pathname = "none",
		pathsteps = 0,
		pathstart = 0,
		ReinforcePoint = "none",
		--Objects\characters\Mutants\mutant_aberration1\mutant_aberration1.cgf 
		fileModel = "Objects/characters/Mutants/mutant_aberration1/mutant_aberration1.cgf",
		bTrackable=1,

		speed_scales={
			run			=2.95,
			crouch	=.8,
			prone		=.5,
			xrun		=1.5,
			xwalk		=.81,
			rrun		=3.63,
			rwalk		=.94,
			},
		AniRefSpeeds = {
			WalkFwd = 1.68,
			WalkSide = 1.68,
			WalkBack = 1.68,
			WalkRelaxedFwd = 1.68,
			WalkRelaxedSide = 1.68,
			WalkRelaxedBack = 1.68,
			
			RunFwd = 3.65,
			RunSide = 3.65,
			RunBack = 3.65,
			XWalkFwd = 1.68,
			XWalkSide = 1.68, 
			XWalkBack = 1.68,
			XRunFwd = 4.5,
			XRunSide = 3.5, 
			XRunBack = 4.5,
			CrouchFwd = 1.68,
			CrouchSide = 1.68,
			CrouchBack = 1.68,
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
		height = 1.5,
		eye_height = 1.3,
		ellipsoid_height = 1.2,
		x = 0.55,
		y = 0.55,
		z = 0.6,
	},
	PlayerDimCrouch = {
		height = 1.5,
		eye_height = 1.0,
		ellipsoid_height = 0.95,
		x = 0.55,
		y = 0.55,
		z = 0.5,
	},
	PlayerDimProne = {
		height = 0.4,
		eye_height = 0.5,
		ellipsoid_height = 0.35,
		x = 0.55,
		y = 0.55,
		z = 0.2,
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

	-- Reloading related



	GrenadeType = "ProjFlashbangGrenade",


}
-------------------------------------------------------------------------------------------------------
function MutantBezerker_x:OnInitCustom(  )


System:Log("MutantBezerker_x onInitCustom ");

	self.cnt:CounterAdd("SuppressedValue", -2.0 );

end

---------------------------------------------------------------------------------------------------------
function MutantBezerker_x:OnResetCustom()

System:Log("MutantBezerker_x onResetCustom ");

	self.cnt:CounterSetValue("SuppressedValue", 0.0 );
	self.isSelfCovered = 0;
	self.lastMeleeAttackTime = 0;
	
end
---------------------------------------------------------------------------------------------------------
