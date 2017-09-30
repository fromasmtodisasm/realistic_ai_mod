AICharacter.Stealth = {
	StealthIdle = {
		OnSomethingSeen    	= "StealthAlert",
		OnPlayerSeen    	= "StealthAlert",
		OnPlayerSeen    	= "StealthAlert",
	},
	StealthAttack = {

	},
	StealthAlert = {
		OnPlayerSeen    	= "StealthAttack",
	},
}