NPC_x = {
	MERC = "npc",
	PropertiesInstance = {
			sightrange = 110,
			soundrange = 10,	-- rememeber that sound ranges intersect and sound range for AI doubles when in
			aibehavior_behaviour = "Job_StandIdle",
			groupid = 0,
		},


	Properties = {

			KEYFRAME_TABLE = "BASE_HUMAN_MODEL",
			SOUND_TABLE = "Jack",
			bAffectSOM = 0,
			suppressedThrhld = 5.5,
			bSleepOnSpawn = 1,
			bHelmetOnStart = 0,
			bHasArmor = 1,
			fileHelmetModel = "",
			horizontal_fov = 160,
			eye_height = 2.1,
			forward_speed = 1.21,
			back_speed = 1.21,
			responsiveness = 7,
			species = 0,
			fSpeciesHostility = 2,
			fGroupHostility = 0,
			fPersistence = .5,
			AnimPack = "Basic",
			SoundPack = "Jack",
			aicharacter_character = "Scout",
			fileModel = "Objects/characters/pmodels/hero/hero.cal",
			max_health = 255,
			pathname = "",
			pathsteps = 0,
			pathstart = 0,
			ReinforcePoint = "",
			aggression = 1,	-- 0 = passive,1 = total aggression
			commrange = 30,
			attackrange = 70,
			accuracy = 1,
			equipEquipment = MainPlayerEquipPack,
			equipDropPack = MainPlayerEquipPack,
			bTrackable=1,
			special = 0,

speed_scales={
run	=3.8,
crouch	=.8,
prone	=.5,
xrun	=3.8,
xwalk	=2.8,
rrun	=3.8,
rwalk	=2.8,
},
AniRefSpeeds = {
WalkFwd = 1.5,
WalkSide = 1.5,
WalkBack = 1.5,
XWalkFwd = 1.5,
XWalkSide = 1.5,
XWalkBack = 1.5,
XRunFwd = 4.5,
XRunSide = 3.5,
XRunBack = 4.5,
RunFwd = 4.8,
RunSide = 4.8,
RunBack = 4.8,
CrouchFwd = 1.02,
CrouchSide = 1.02,
CrouchBack = 1.02,
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
		height = 1.8,
		eye_height = 1.7,
		ellipsoid_height = 1.2,
		x = .45,
		y = .45,
		z = .41, -- .6
	},
	PlayerDimCrouch = {
		height = 1.5,
		eye_height = 1,
		ellipsoid_height = .95,
		x = .45,
		y = .45,
		z = .1, -- .5
	},
	PlayerDimProne = {
		height = .4,
		eye_height = .5,
		ellipsoid_height = .35,
		x = .45,
		y = .45,
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
	  lying_gravityz = -4,
	  lying_sleep_speed = .065,
	  lying_damping = 3.5
	},
	BulletImpactParams = {
    stiffness_scale = 73,
    max_time_step = .02
},


	-- Reloading related
	GrenadeType = "ProjFlashbangGrenade",


}

-----------------------------
NPC_x.Server =
{
	Alive = {
		OnDamage = function(self,hit)
			hit.impact_force_mul = 0
			BasicAI.Server.Alive.OnDamage(self,hit)
		end,
	},
}