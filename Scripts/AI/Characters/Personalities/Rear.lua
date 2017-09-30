-- Rear Character SCRIPT

AICharacter.Rear = {

	UnderFire = {
		OnPlayerSeen		 = "RearIdle",
		OnThreateningSoundHeard  = "RearIdle",
		RETURN_TO_FIRST		 = "FIRST",
	},

	MountedGuy = {
		RETURN_TO_NORMAL	 = "RearIdle",
		CONVERSATION_FINISHED   = "MountedGuy",
	},

	RunToFriend= {
		OnPlayerSeen		 = "RearAlert",
	},

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

		OnPlayerSeen 		= "RearAttack",
		OnInterestingSoundHeard = "RearAlert",
		OnSomethingSeen		= "RearAlert",
		OnGrenadeSeen		= "RearAlert",
		OnThreateningSoundHeard = "RearAlert",

		OnReceivingDamage	= "UnderFire",
		OnBulletRain		= "UnderFire",

		HEADS_UP_GUYS		= "RunToFriend",
		INCOMING_FIRE		= "RearAlert",
		
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
		RETURN_TO_FIRST		= "FIRST",
		-----------------------------------------
	},

	
	RearAttack = {
		OnNoTarget		= "RearAlert",
--		OnLowHideSpot	= "DigIn",
--		LEFT_LEAN_ENTER		= "LeanFire",
--		RIGHT_LEAN_ENTER	= "LeanFire",

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
}