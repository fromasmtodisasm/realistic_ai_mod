NPC_x = {
------------------------------------------------------------------------------------

------------------------------------------------------------------------------------


	PropertiesInstance = {
			sightrange = 80,
			soundrange = 10,	-- rememeber that sound ranges intersect and sound range for AI doubles when in 
			aibehavior_behaviour = "get_in_the_vehicle",
			groupid = 154,

		},


	Properties = {

			KEYFRAME_TABLE = "NPC",
			SOUND_TABLE = "NPC",
			bAffectSOM = 1,
			suppressedThrhld = 5.5,
			bSleepOnSpawn = 1,
			bHelmetOnStart = 0,
			bHasArmor = 1,
			fileHelmetModel = "",
			horizontal_fov = 160,
			eye_height = 2.1,
			forward_speed = 3,
			back_speed = 2.5,
			responsiveness = 7,
			species = 1,
			fSpeciesHostility = 2,
			fGroupHostility = 0,
			fPersistence = 0,
			AnimPack = "Basic",
			SoundPack = "dialog_template",
			aicharacter_character = "Cover",
			fileModel = "Objects/characters/npcs/val/scientist.cgf",
			max_health = 999,
			pathname = "none",
			pathsteps = 0,
			pathstart = 0,
			ReinforcePoint = "none",
			aggression = 0.3,	-- 0 = passive, 1 = total aggression
			commrange = 30.0,
	--		cohesion = 5,
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
			WalkRelaxedFwd = 1.27,
			WalkRelaxedSide = 1.22,
			WalkRelaxedBack = 1.29,
			XWalkFwd = 1.2,
			XWalkSide = 1.0, 
			XWalkBack = 0.94,
			XRunFwd = 4.5,
			XRunSide = 3.5, 
			XRunBack = 4.5,
			RunFwd = 4.62,
			RunSide = 3.57,
			RunBack = 3.6,
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
		sim_type = 1,
	  max_time_step = 0.025,
	  gravityz = -7.5,
	  sleep_speed = 0.025,
	  damping = 0.3,
	  freefall_gravityz = -9.81,
	  freefall_damping = 0.1,

	  lying_mode_ncolls = 4,
	  lying_gravityz = -4.0,
	  lying_sleep_speed = 0.065,
	  lying_damping = 3.5
	},
	BulletImpactParams = {
    stiffness_scale = 73,
    max_time_step = 0.02
  },


	-- Reloading related

--	SoundEvents={
--		{"srunfwd",	0,			666},
--		{"srunfwd",	10,			666},
--		{"srunfwd",	20,			666},
--		{"srunback",	5,			666},
--		{"srunback",	13,			666},
--		{"sstealthfwd", 6,			666},
--		{"sstealthfwd", 28,		666},
--		{"sstealthback", 3,		666},
--		{"sstealthback", 26,		666},
--		{"swalkback",   2,			666},
--		{"swalkback",   18,		666},
--		{"swalkfwd",     3,		666},
--		{"swalkfwd",    20,		666},
--		{"cwalkback",	17,			666},
--		{"cwalkback",	31,			666},
--		{"cwalkfwd",	4,			666},
--		{"cwalkfwd",	21,			666},
--		{"pwalkfwd",	3,			0},
--	},

	GrenadeType = "ProjFlashbangGrenade",


}

-----------------------------------------------------------------------------------------------------
NPC_x.Server =
{
	Alive = {
		OnDamage = function (self, hit)
			hit.impact_force_mul = 0;
			BasicAI.Server.Alive.OnDamage(self, hit);
		end,
	},
}