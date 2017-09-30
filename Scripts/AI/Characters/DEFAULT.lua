-- COVER CHARACTER SCRIPT

AICharacter.DEFAULT = {

	NoBehaviorFound = {
		GOING_TO_TRIGGER = "RunToAlarm",
		-----------------------------------
		-- Vehicles related
		entered_vehicle			= "InVehicle",
		CONVERSATION_REQUEST 	= "Idle_Talk",
		CONVERSATION_FINISHED	= "FIRST",
		CROWE_ONE				= "Job_CroweOne",
		IGNORE_ALL_ELSE         = "SharedReinforce",
		BackToJob				= "FIRST",
		GO_INTO_WAIT_STATE  	= "SharedReinforce",
		SPECIAL_LEAD 			= "SpecialLead",
		SPECIAL_FOLLOW 			= "SpecialFollow",
		SPECIAL_DUMB			= "SpecialDumb",
		SPECIAL_HOLD			= "SpecialHold",
		SPECIAL_STOPALL			= "FIRST",
		RUSH_TARGET 			= "SpecialDumb",
		STOP_RUSH 				= "PREVIOUS",
		RETREAT_NOW				= "SharedRetreat",
		RETREAT_NOW_PHASE2		= "SharedRetreat",
		RETURN_TO_FIRST			= "FIRST",
		SWITCH_TO_MORTARGUY		= "MountedGuy",
		START_CLIMBING 			= "ClimbLadder",
		STOP_CLIMBING 			= "PREVIOUS",
		REALLY_START_SWIMMING 	= "Swim",
		SEARCH_AMMUNITION 		= "SearchAmmunition",
		DIG_IN_ATTACK			= "DigIn",
		LEFT_LEAN_ENTER			= "LeanFire",
		RIGHT_LEAN_ENTER		= "LeanFire",
		JUMP_ALLOWED			= "MutantJumping",
		-- OnGrenadeSeen		= "EntityGrenadeSeen", -- Переключиться - переключился в дефолте, но пайпу не выбрал.
		-- OnGrenadeSeen_Flying	= "EntityGrenadeSeen",
		GRENADE_SEEN			= "EntityGrenadeSeen",
		-- OnGrenadeSeen_Colliding	= "EntityGrenadeSeen",
		-- SPECOPS_EXIT			= "AiPlayerIdle",
	},
	-----------------------------------
	-- Vehicles related
	InVehicle = {
		-- exited_vehicle_investigate = "FIRST", -- Пусть так и остаётся, это в MountedGuy может быть PREVIOUS.
		-- exited_vehicle = "FIRST",
		really_exited_vehicle = "FIRST", -- Чтобы EventToCall срабатывал.
		SWITCH_TO_MORTARGUY		= "MountedGuy",
	},

	Swim = {
		MERC_STOP_SWIMMING	 	= "PREVIOUS",
	},

	EntityGrenadeSeen = {
		GRENADE_EXIT = "PREVIOUS",
		-- GRENADE_EXIT = "FIRST",
	},

	MutantJumping = {
		JUMP_FINISHED		= "PREVIOUS",
	},

	MountedGuy = {
		REAL_RETURN_TO_NORMAL	= "PREVIOUS",
		entered_vehicle			= "InVehicle",
		-- exited_vehicle = "PREVIOUS",
		really_exited_vehicle = "PREVIOUS", -- Чтобы EventToCall срабатывал.
		
	},

	SearchAmmunition = {
		EXIT_SEARCH_AMMUNITION	= "PREVIOUS",
	},

	RunToAlarm = {
		EXIT_RUNTOALARM = "PREVIOUS",
	},

	DigIn = {
		OnReload		= "PREVIOUS",
		OnReceivingDamage	= "PREVIOUS",
		TO_PREVIOUS 		= "PREVIOUS",
		RETREAT_NOW	= "SharedRetreat",
		RETREAT_NOW_PHASE2	= "SharedRetreat",

	},

--	Idle_Smoking = {
--		BackToJob			= "FIRST",
--	},


	SharedRetreat = {
		STOP_RETREATING = "PREVIOUS",
	},

	SharedReinforce = {
		JoinGroup	= "PREVIOUS",
		OFFER_JOIN_TEAM	= "PREVIOUS",
		RETURN_TO_PREVIOUS = "PREVIOUS",
		EXIT_WAIT_STATE = "FIRST",
	},

	LeanFire = {
		OnReload		= "PREVIOUS",
		OnReceivingDamage	= "PREVIOUS",
		TO_PREVIOUS 		= "PREVIOUS",
		KEEP_FORMATION 		= "PREVIOUS",
		IGNORE_ALL_ELSE         = "SharedReinforce",
		RETREAT_NOW	= "SharedRetreat",
		RETREAT_NOW_PHASE2	= "SharedRetreat",
	},
}