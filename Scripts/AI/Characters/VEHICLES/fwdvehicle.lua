-- Test Character SCRIPT

AICharacter.FWDVehicle = {

	FWDVehicleIdle = {
		-----------------------------------
	},


	Car_idle = {
		-----------------------------------
		BRING_REINFORCMENT = "Car_transport",
		GO_PATH = "Car_path",
		GO_PATROL = "Car_patrol",		
		GO_CHASE = "Car_chase",
--		OnPlayerSeen  = "Heli_attack",
		
	},

	Car_transport = {
		-----------------------------------
		reinforcment_out = "Car_goto",
		DRIVER_OUT = "Car_idle",
	},
	
	Car_goto = {
		-----------------------------------
		next_point = "Car_idle",
		DRIVER_OUT = "Car_idle",
	},
	
	Car_path = {
		-----------------------------------
--			stopped = "Car_idle",
			GO_CHASE = "Car_chase",
			BRING_REINFORCMENT = "Car_transport",
			DRIVER_OUT = "Car_idle",
			GUNNER_OUT = "Car_idle",
			EVERYONE_OUT = "Car_idle",
		
--		NEXTPOINT = "Heli_path",
	},

	Car_patrol = {
		-----------------------------------
		stopped = "Car_idle",
		DRIVER_OUT = "Car_idle",
		GO_CHASE = "Car_chase",
	},

	Car_chase = {
		-----------------------------------
		DRIVER_OUT = "Car_idle",
		GUNNER_OUT = "Car_idle",
	},
}