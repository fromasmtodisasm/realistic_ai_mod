

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
		JUMP_FINISHED		= "ModMorphAttack",
	},


	ModMorphCloaked = {
		OnReceivingDamage	= "ModMorphAttack",
		OnCloseContact		= "ModMorphAttack",
		CHASE_TARGET		= "ModMorphAttack",
		MORPH			= "ModMorphCloaked",		
	},

	ModMorphAlert = {

		OnPlayerSeen    	= "ModMorphAttack",
		MORPH			= "ModMorphCloaked",				
	},

}