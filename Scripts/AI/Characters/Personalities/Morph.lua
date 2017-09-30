AICharacter.Morph = {
	MorphIdle = {
		OnPlayerSeen    	= "MorphAttack",
		OnSomethingSeen    	= "MorphAlert",
		OnThreateningSoundHeard    	= "MorphAlert",
		MORPH				= "MorphCloaked",
		HEADS_UP_GUYS		= "MorphAlert",
	},
	MorphAttack = {
		OnPlayerLookingAway	= "MorphCloaked",
		JUMP_ALLOWED		= "MutantJumping",
		MORPH				= "MorphCloaked",
	},
	MutantJumping = {
		JUMP_FINISHED		= "MorphAttack",
	},
	MorphCloaked = {
		OnReceivingDamage	= "MorphAttack",
		OnCloseContact		= "MorphAttack",
		CHASE_TARGET		= "MorphAttack",
		MORPH				= "MorphCloaked",
	},
	MorphAlert = {
		OnPlayerSeen    	= "MorphAttack",
		MORPH				= "MorphCloaked",
	},
}