AICharacter.Fast = {

	FastIdle = {
		OnPlayerSeen				= "FastAttack",
		SELECT_ALERT				= "FastAlert",
		OnSomethingSeen				= "FastAlert",
		OnThreateningSoundHeard		= "FastAlert",
		OnReceivingDamage			= "FastAlert",
		OnSomethingDiedNearest		= "FastAlert",
		OnGrenadeSeen				= "FastAlert",
		OnBulletRain				= "FastAlert",
		JUMP_ALLOWED				= "MutantJumping",
	},

	FastAlert = {
		OnPlayerSeen				= "FastAttack",
		JUMP_ALLOWED				= "MutantJumping",
	},

	FastAttack = {
		JUMP_ALLOWED		= "MutantJumping",
	},

	FastSeek = {
		OnPlayerSeen		= "FastAttack",
	},

	MutantJumping = {
		JUMP_FINISHED		= "PREVIOUS",
		RELOCATE			= "FastSeek",
	},

	MutantJob_Jumper = {
		JUMP_ALLOWED		= "MutantJumping",
	},


}