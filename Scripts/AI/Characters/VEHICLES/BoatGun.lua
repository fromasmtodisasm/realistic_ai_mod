-- Test Character SCRIPT

AICharacter.BoatGun = {

	BoatGunIdle = {
		-----------------------------------
	},


	Boat_idle = {
		-----------------------------------
		BRING_REINFORCMENT = "Boat_transport",
		GO_PATH = "Boat_path",
		GO_PATROL = "Boat_patrol",
		GO_ATTACK = "Boat_attack",
--		OnPlayerSeen  = "Heli_attack",
		
	},

	Boat_transport = {
		-----------------------------------
		reinforcment_out = "Boat_idle",
		GO_ATTACK = "Boat_attack",
		DRIVER_OUT = "Boat_idle",
		ON_GROUND = "Boat_idle",
	},
	
	Boat_goto = {
		-----------------------------------
		next_point = "Car_idle",
		GO_ATTACK = "Boat_attack",
		DRIVER_OUT = "Boat_idle",
		ON_GROUND = "Boat_idle",
	},
	
	Boat_path = {
		GO_ATTACK = "Boat_attack",
--		OnPlayerSeen  = "Boat_transport",
		BRING_REINFORCMENT = "Boat_transport",
		DRIVER_OUT = "Boat_idle",
		ON_GROUND = "Boat_idle",
		-----------------------------------
--		NEXTPOINT = "Heli_path",
	},

	Boat_patrol = {
		GO_ATTACK = "Boat_attack",
		OnPlayerSeen = "Boat_attack",
		BRING_REINFORCMENT = "Boat_transport",
		DRIVER_OUT = "Boat_idle",
		ON_GROUND = "Boat_idle",
		-----------------------------------
--		NEXTPOINT = "Heli_path",
	},


	Boat_attack = {
		DRIVER_OUT = "Boat_idle",
		ON_GROUND = "Boat_idle",
--		OnEnemyMemory = "Boat_transport",
--		PLAYER_LEFT_VEHICLE = "Boat_path",
		drop_people = "Boat_transport",
		-----------------------------------
--		NEXTPOINT = "Heli_path",
	},

	
}