

AICharacter.Krieger = {

	KriegerIdle = {
		OnPlayerSeen    	= "KriegerAttack",
		JUMP_ALLOWED		= "MutantJumping",
	},

	KriegerAttack = {
		JUMP_ALLOWED		= "MutantJumping",
	},

	MutantJumping = {
		JUMP_FINISHED		= "PREVIOUS",
		RELOCATE		= "KriegerAttack",
	},

	MutantJob_Jumper = {
		JUMP_ALLOWED		= "MutantJumping",
	},


}