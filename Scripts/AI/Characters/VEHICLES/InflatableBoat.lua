--	
-- Character SCRIPT for inflatable boat
-- created by Kirill Bulatsev

AICharacter.InflatableBoat = {

	InflatableBoatIdle = {
		-----------------------------------
	},


	Boat_idle = {
		-----------------------------------
--		BRING_REINFORCMENT = "Boat_transport",
		GO_PATH = "Boat_path",
--		GO_ATTACK = "Boat_attack",
--		BRING_REINFORCMENT = "Boat_transport",
--		OnPlayerSeen  = "Heli_attack",
		
	},

--	Boat_transport = {
		-----------------------------------
--		reinforcment_out = "Car_goto",
--		GO_ATTACK = "Boat_attack",
--	},
	
--	Boat_goto = {
		-----------------------------------
--		next_point = "Car_idle",
--		GO_ATTACK = "Boat_attack",
--	},
	
	Boat_path = {
		GO_ATTACK = "Boat_attack",
		OnPlayerSeen  = "Boat_transport",
		-----------------------------------
--		NEXTPOINT = "Heli_path",
	},

--	Boat_attack = {
--		DRIVER_OUT = "Boat_idle",
		-----------------------------------
--		NEXTPOINT = "Heli_path",
--	},

	
}