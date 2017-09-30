-- COVER CHARACTER SCRIPT
AICharacter.SpecOpsMan = {
	DigIn = {
		OnCloseContact			= "SpecOpsManIdle",
		OnReload 				= "SpecOpsManIdle",
		OnReceivingDamage 		= "SpecOpsManIdle",
		TO_PREVIOUS 			= "SpecOpsManIdle",
	},

	RunToAlarm = {
		REAL_ALARM_ON 			= "PREVIOUS",
		OnReceivingDamage		= "UnderFire",
	},

	LeanFire = {
		OnCloseContact			= "SpecOpsManIdle",
		OnReload 				= "SpecOpsManIdle",
		OnReceivingDamage	 	= "SpecOpsManIdle",
		TO_PREVIOUS 			= "SpecOpsManIdle",
	},

	SpecialLead = {
		-- OnPlayerSeen			= "SpecOpsManIdle",
		-- OnThreateningSoundHeard = "SpecOpsManIdle",
		-- OnInterestingSoundHeard = "SpecOpsManIdle",
		SPECOPS_EXIT = "SpecOpsManIdle",
	},

	SpecialFollow = {
		-- OnPlayerSeen			= "SpecOpsManIdle",
		-- OnThreateningSoundHeard = "SpecOpsManIdle",
		-- OnReceivingDamage	 	= "SpecOpsManIdle",
		SPECOPS_EXIT = "SpecOpsManIdle",
	},

	SpecialHold = {
		OnPlayerSeen			= "SpecOpsManIdle",
		SPECOPS_EXIT = "SpecOpsManIdle",
	},

	UnderFire = {
		OnPlayerSeen			= "SpecOpsManIdle",
		OnThreateningSoundHeard = "SpecOpsManIdle",
	},

	MountedGuy = {
		-- RETURN_TO_NORMAL		= "SpecOpsManIdle",
		REAL_RETURN_TO_NORMAL	= "SpecOpsManIdle",
		CONVERSATION_FINISHED   = "MountedGuy",
	},

	SpecOpsManIdle = {
	},

	UseElevator = {
		PathDone			= "SpecOpsManIdle",
	},
	UseFlyingFox = {
		PathDone			= "SpecOpsManIdle",
	},
}