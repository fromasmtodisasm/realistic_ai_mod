-- Rear Character SCRIPT

AICharacter.Rear = {

	UnderFire = {
		OnPlayerSeen		 = "RearIdle",
		OnThreateningSoundHeard  = "RearIdle",

	},

	MountedGuy = {
		-- RETURN_TO_NORMAL	 = "RearIdle",
		-- RETURN_TO_NORMAL		= "RearAttack",
		REAL_RETURN_TO_NORMAL	= "RearAttack",
		CONVERSATION_FINISHED   = "MountedGuy",
	},

	-- RunToFriend= {
		-- OnPlayerSeen		 = "RearAlert",
	--},

	SpecialLead = {
		OnPlayerSeen		 = "RearAttack",
		OnThreateningSoundHeard  = "RearAttack",
		OnInterestingSoundHeard  = "RearAttack",
	},

	SpecialFollow = {
		OnPlayerSeen		 = "RearAttack",
		OnThreateningSoundHeard  = "RearAttack",
	},

	RearIdle = {
		OnPlayerSeen 				= "RearAttack",
		NORMAL_THREAT_SOUND 		= "RearAlert",
		ALERT_SIGNAL				= "RearAlert",
		INCOMING_FIRE				= "UnderFire",
		OnReceivingDamage			= "RearAlert",
		-- LOOK_AT_BEACON				= "RearAlert",
		OnSomethingDiedNearest		= "RearAlert",
		OnSomethingDiedNearest_x 	= "RearAlert",
		HEADS_UP_GUYS				= "RearAlert",

		TakePiss			= "Idle_TakePiss",
		Smoking			= "Idle_Smoking",
		BackToJob		= "FIRST",
		
		CheckApparatus		= "Job_CheckApparatus",
		PushButton		="Job_PushButtons",
		PullLever			="Job_PullLever",

		-- idles
		LookWall			="Idle_StandLook",
		SitDown			= "Idle_SitDown",
		-----------------------------------------
	},

	RearAlert = {
		OnPlayerSeen 		= "RearAttack",
		REAR_NORMALATTACK 	= "RearAttack",
	},

	
	RearAttack = {
	},

	UseFlyingFox = {
		PathDone			= "RearIdle",
	},
	ChasePathOnSeen = {
		PathDone			= "RearIdle",
	},	
	ChasePath = {
		PathDone			= "RearIdle",
	},	
	
	RunToAlarm = {
		REAL_ALARM_ON = "PREVIOUS",
	},
}