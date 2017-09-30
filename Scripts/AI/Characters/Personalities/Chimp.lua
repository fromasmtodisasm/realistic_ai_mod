

AICharacter.Chimp = {

	ChimpIdle = {
		OnPlayerSeen    			= "ChimpAttack",
		OnThreateningSoundHeard		= "ChimpAlert",
		OnGrenadeSeen				= "ChimpAlert",
		OnReceivingDamage			= "ChimpAlert",
		OnSomethingDiedNearest		= "ChimpAlert",
		OnSomethingDiedNearest_x	= "ChimpAlert",
		HEADS_UP_GUYS				= "ChimpAlert",
		PREDATOR_SCARED				= "ChimpAlert",
		ANY_MORE_TO_RELEASE			= "ChimpAlert",
		SWITCH_TO_ATTACK			= "ChimpAttack",
		--HEADS_UP_GUYS    			= "ChimpSurround",
	},

	ChimpAlert = {
		HEADS_UP_GUYS				= "ChimpAttack",
		PREDATOR_SCARED				= "ChimpAttack",
		OnPlayerSeen    			= "ChimpAttack",	
		SWITCH_TO_ATTACK			= "ChimpAttack",
	},

	ChimpAttack = {
		JUMP_ALLOWED		= "MutantJumping",
	},

	MutantJumping = {
		JUMP_FINISHED		= "PREVIOUS",
	},

	ChimpSurround = {
		JUMP_ALLOWED		= "MutantJumping",
		SWITCH_TO_ATTACK	= "ChimpAttack",
	},

	MutantCaged = {
		RELEASED		= "ChimpAlert",
	},
}