

AICharacter.ModMorph = {

	ModMorphIdle = {
		OnPlayerLookingAway    	= "ModMorphCloaked",
		OnReceivingDamage    	= "ModMorphAttack",
		OnCloseContact    	= "ModMorphAttack",
		MORPH			= "ModMorphCloaked",
		HEADS_UP_GUYS		= "ModMorphAttack",
	},

	ModMorphAttack = {
		OnPlayerLookingAway	= "ModMorphCloaked",
		JUMP_ALLOWED		= "ModMutantJumping",
		MORPH			= "ModMorphCloaked",		
	},

	MutantJumping = {
		BACK_TO_ATTACK		= "ModMorphAttack",
	},


	ModMorphCloaked = {
		OnReceivingDamage	= "ModMorphAttack",
		OnCloseContact		= "ModMorphAttack",
		CHASE_TARGET		= "ModMorphAttack",
		MORPH			= "ModMorphCloaked",		
	},

	ModMorphAlert = {
		RETURN_TO_FIRST		= "FIRST",
		OnPlayerSeen    	= "ModMorphAttack",
		MORPH			= "ModMorphCloaked",				
	},

}