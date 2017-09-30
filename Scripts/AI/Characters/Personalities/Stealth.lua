

AICharacter.Stealth = {

	StealthIdle = {

		OnSomethingSeen    	= "StealthAlert",
		OnPlayerSeen    	= "StealthAlert",
	},

	StealthAttack = {
		
	},

	StealthAlert = {
		RETURN_TO_FIRST		= "FIRST",
		OnPlayerSeen    	= "StealthAttack",
		
	},

}