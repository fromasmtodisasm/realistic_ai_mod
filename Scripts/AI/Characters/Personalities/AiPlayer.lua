-- COVER CHARACTER SCRIPT
AICharacter.AiPlayer = {

	DigIn = {
		OnCloseContact			= "AiPlayerIdle",
		OnReload 				= "AiPlayerIdle",
		OnReceivingDamage 		= "AiPlayerIdle",
		TO_PREVIOUS 			= "AiPlayerIdle",
	},

	RunToAlarm = {
		REAL_ALARM_ON 			= "PREVIOUS",
		OnReceivingDamage		= "UnderFire",
	},

	LeanFire = {
		OnCloseContact			= "AiPlayerIdle",
		OnReload 				= "AiPlayerIdle",
		OnReceivingDamage	 	= "AiPlayerIdle",
		TO_PREVIOUS 			= "AiPlayerIdle",
	},

	SpecialLead = {
		OnPlayerSeen			= "AiPlayerIdle",
		OnThreateningSoundHeard = "AiPlayerIdle",
		OnInterestingSoundHeard = "AiPlayerIdle",
		SPECOPS_EXIT			= "AiPlayerIdle",
	},

	SpecialFollow = {
		OnPlayerSeen			= "AiPlayerIdle",
		-- OnThreateningSoundHeard  = "AiPlayerIdle",
		OnReceivingDamage	 	= "AiPlayerIdle",
		SPECOPS_EXIT			= "AiPlayerIdle",
	},

	SpecialHold = {
		OnPlayerSeen			= "AiPlayerIdle",
		SPECOPS_EXIT			= "AiPlayerIdle",
	},

	UnderFire = {
		OnPlayerSeen			= "AiPlayerIdle",
		OnThreateningSoundHeard = "AiPlayerIdle",
	},

	MountedGuy = {
		-- RETURN_TO_NORMAL		= "AiPlayerIdle",
		REAL_RETURN_TO_NORMAL	= "AiPlayerIdle",
		CONVERSATION_FINISHED   = "MountedGuy",
	},

	AiPlayerIdle = {
	},

	UseElevator = {
		PathDone			= "AiPlayerIdle",
	},
	UseFlyingFox = {
		PathDone			= "AiPlayerIdle",
	},
}