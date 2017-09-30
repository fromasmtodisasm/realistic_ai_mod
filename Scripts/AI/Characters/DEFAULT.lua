-- COVER CHARACTER SCRIPT

AICharacter.DEFAULT = {

	NoBehaviorFound = {



		GOING_TO_TRIGGER = "RunToAlarm",

		-----------------------------------
		-- Vehicles related
		entered_vehicle = "InVehicle",

		CONVERSATION_REQUEST = "Idle_Talk",
		CONVERSATION_FINISHED = "FIRST",


		SWITCH_TO_MORTARGUY = "MountedGuy",

		IGNORE_ALL_ELSE         = "SharedReinforce",
		SWITCH_TO_RUN_TO_FRIEND = "RunToFriend",

		BackToJob			= "FIRST",

		GO_INTO_WAIT_STATE  = "SharedReinforce",

		SPECIAL_LEAD 	= "SpecialLead",
		SPECIAL_FOLLOW 	= "SpecialFollow",
		SPECIAL_DUMB	= "SpecialDumb",
		SPECIAL_HOLD	= "SpecialHold",
		SPECIAL_STOPALL	= "FIRST",

		START_SWIMMING  = "Swim",
		STOP_SWIMMING  = "PREVIOUS",

		RUSH_TARGET = "SpecialDumb",
		STOP_RUSH = "PREVIOUS",


		RETREAT_NOW	= "SharedRetreat",
		RETREAT_NOW_PHASE2	= "SharedRetreat",

		START_CLIMBING = "ClimbLadder",
		STOP_CLIMBING  = "PREVIOUS",



	},
	-----------------------------------
	-- Vehicles related
	InVehicle = {	
		exited_vehicle_investigate = "Job_Investigate",
		exited_vehicle = "FIRST",
		do_exit_vehicle= "FIRST",
	},

	RunToAlarm = {
		EXIT_RUNTOALARM = "PREVIOUS",
	},

	RunToFriend = {
		OnPlayerSeen = "PREVIOUS",
		OnThreateningSoundHeard = "PREVIOUS",
		RETREAT_NOW	= "SharedRetreat",
		RETREAT_NOW_PHASE2	= "SharedRetreat",
		SWITCH_TO_MORTARGUY = "MountedGuy",
		FINISH_RUN_TO_FRIEND = "PREVIOUS",
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


	SharedRetreat = 
	{
		STOP_RETREATING = "PREVIOUS",
	},

	SharedReinforce = 
	{
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