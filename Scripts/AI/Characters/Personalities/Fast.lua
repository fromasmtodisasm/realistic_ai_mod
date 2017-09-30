

AICharacter.Fast = {

	FastIdle = {
		OnPlayerSeen    	= "FastAttack",
		JUMP_ALLOWED		= "MutantJumping",
	},

	FastAttack = {
		JUMP_ALLOWED		= "MutantJumping",
	},

	FastSeek = {
		OnPlayerSeen		= "FastAttack",
	},

	MutantJumping = {
		JUMP_FINISHED		= "PREVIOUS",
		RELOCATE		= "FastSeek",
	},

	MutantJob_Jumper = {
		JUMP_ALLOWED		= "MutantJumping",
	},


}