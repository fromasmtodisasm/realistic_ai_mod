-- Test Character SCRIPT

AICharacter.HeliCargo = {

	HeliCargoIdle = {
		-----------------------------------
	},


	Heli_idle = {
		-----------------------------------
		BRING_REINFORCMENT = "Heli_transport",
		GO_PATH = "Heli_path",
--		OnPlayerSeen  = "Heli_attack",

		PATH_RESTORE = "Heli_path",
		PATROL_RESTORE = "Heli_patrol",		
		REINFORCMENT_RESTORE = "Heli_transport",
		READY_TO_GO	= "Heli_goto",
		
		SWITCH_TO_TRANSPORT  = "Heli_transport",
		
	},

	Heli_transport = {
		-----------------------------------
		READY_TO_GO	= "Heli_goto",
	},
	
	Heli_goto = {
		-----------------------------------
		NEXTPOINT = "Heli_idle",
	},
	
	Heli_path = {
		-----------------------------------
		BRING_REINFORCMENT = "Heli_transport",
		GO_2_BASE = "Heli_goto",
--		NEXTPOINT = "Heli_path",
	},
	
	
}