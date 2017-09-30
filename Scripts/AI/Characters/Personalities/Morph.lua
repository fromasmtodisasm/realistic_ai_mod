

AICharacter.Morph = {

	MorphIdle = {
		OnPlayerSeen    	= "MorphAttack",
		OnSomethingSeen    	= "MorphAlert",
		MORPH			= "MorphCloaked",
		HEADS_UP_GUYS		= "MorphAlert",
	},

	MorphAttack = {
		OnPlayerLookingAway	= "MorphCloaked",
		JUMP_ALLOWED		= "MutantJumping",
		MORPH			= "MorphCloaked",		
	},

	MutantJumping = {
		BACK_TO_ATTACK		= "MorphAttack",
	},


	MorphCloaked = {
		OnReceivingDamage	= "MorphAttack",
		OnCloseContact		= "MorphAttack",
		CHASE_TARGET		= "MorphAttack",
		MORPH			= "MorphCloaked",		
	},

	MorphAlert = {
		RETURN_TO_FIRST		= "FIRST",
		OnPlayerSeen    	= "MorphAttack",
		MORPH			= "MorphCloaked",				
	},

}