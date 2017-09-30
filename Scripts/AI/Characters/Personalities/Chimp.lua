

AICharacter.Chimp = {

	ChimpIdle = {
		OnPlayerSeen    	= "ChimpAttack",
		OnThreateningSoundHeard	= "ChimpIdle",
		OnInterestingSoundHeard	= "ChimpIdle",
		--HEADS_UP_GUYS    	= "ChimpSurround",
	},

	ChimpAttack = {
		JUMP_ALLOWED		= "MutantJumping",
	},

	MutantJumping = {
		JUMP_FINISHED		= "PREVIOUS",
--		BACK_TO_ATTACK		= "ChimpAttack",
		SWITCH_TO_ATTACK	= "ChimpAttack",
	},

	ChimpSurround = {
		JUMP_ALLOWED		= "MutantJumping",
		SWITCH_TO_ATTACK	= "ChimpAttack",
	},

	MutantCaged = {
		RELEASED		= "ChimpIdle",
	},



}