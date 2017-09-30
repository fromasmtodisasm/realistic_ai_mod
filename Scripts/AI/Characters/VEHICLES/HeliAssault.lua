-- Test Character SCRIPT

AICharacter.HeliAssault = {

	HeliAssaultIdle = {
		-----------------------------------
	},


	Heli_idle = {
		-----------------------------------
		BRING_REINFORCMENT = "Heli_transport",
		GO_PATH = "Heli_path",
		GO_PATROL = "Heli_patrol",
		GO_ATTACK = "Heli_attack",
		ATTACK_RESTORE = "Heli_attack",
		PATH_RESTORE = "Heli_path",
		PATROL_RESTORE = "Heli_patrol",		
		REINFORCMENT_RESTORE = "Heli_transport",
		
--		OnPlayerSeen  = "Heli_attack",
	},

	Heli_transport = {
		-----------------------------------
		READY_TO_GO = "Heli_attack",
	},
	

	Heli_goto = {
		-----------------------------------
		NEXTPOINT = "Heli_idle",
		NEXTPOINT_ATTACK = "Heli_attack",		
	},

	Heli_attack = {
		-----------------------------------	
		GO_2_BASE = "Heli_goto",
		BRING_REINFORCMENT = "Heli_transport",
		GO_PATH = "Heli_path",
	},
	
	Heli_path = {
		-----------------------------------
--		NEXTPOINT = "Heli_path",
		BRING_REINFORCMENT = "Heli_transport",
		GO_ATTACK = "Heli_attack",
		GO_2_BASE = "Heli_goto",
	},

	Heli_patrol = {
		-----------------------------------
--		NEXTPOINT = "Heli_path",
		BRING_REINFORCMENT = "Heli_transport",
		GO_ATTACK = "Heli_attack",
		OnPlayerSeen = "Heli_attack",
	},
	
	
}