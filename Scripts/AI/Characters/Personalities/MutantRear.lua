-- MutantRear Character SCRIPT

AICharacter.MutantRear = {

	UnderFire = {
		OnPlayerSeen	= "MutantRearIdle",
		OnThreateningSoundHeard = "MutantRearIdle",
		OnGrenadeSeen		= "MutantRearAttack",
	},

	MutantRearIdle = {
		-- ON_ENEMY_TOOCLOSE	= "MutantRearScramble",
		-- ON_ENEMY_TARGET	= "MutantRearAttack",
		OnPlayerSeen 		= "MutantRearAttack",
		OnInterestingSoundHeard = "MutantRearInterested",
		OnThreateningSoundHeard = "MutantRearThreatened",
		OnReceivingDamage	= "MutantRearAlert",
		OnGrenadeSeen		= "MutantRearAlert",
		OnBulletRain		= "MutantRearAlert",
		HEADS_UP_GUYS		= "MutantRearAlert",
		INCOMING_FIRE		= "MutantRearAlert",
		
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

	MutantRearAlert = {
		OnPlayerSeen 		= "MutantRearAttack",
		OnInterestingSoundHeard = "MutantRearThreatened",
		OnThreateningSoundHeard = "MutantRearThreatened",
		back_to			= "FIRST",
		-----------------------------------------
	},
	
	MutantRearInterested = {
		OnPlayerSeen 		= "MutantRearAttack",
		OnGrenadeSeen		= "MutantRearThreatened",
		OnThreateningSoundHeard = "MutantRearThreatened",
		OnGroupMemberDied	= "MutantRearThreatened",
		OnGroupMemberDiedNearest= "MutantRearThreatened",
		OnReceivingDamage	= "MutantRearThreatened",
		OnBulletRain		= "MutantRearThreatened",
		HEADS_UP_GUYS		= "MutantRearThreatened",
		INCOMING_FIRE		= "MutantRearThreatened",
		back_to			= "FIRST",
		-----------------------------------------
	},
	
	MutantRearThreatened = {
		OnPlayerSeen 		= "MutantRearAttack",
		back_to			= "FIRST",
		-----------------------------------------
	},

	MutantRearScramble = {
		REAR_NORMALATTACK 	= "MutantRearAttack",
		OnGrenadeSeen		= "MutantRearAttack",
	},

	MutantRearAttack = {
	--	OnReceivingDamage = "MutantRearScramble",
	--	OnEnemyMemory	  = "MutantRearScramble",
	--	GO_REFRACTIVE	  = "MutantRearInvisible",
	},

	MutantRearInvisible = {
		GO_VISIBLE	  = "MutantRearAttack",
		OnReceivingDamage = "MutantRearAttack",
	},
	ChasePath = {
		PathDone			= "MutantRearIdle",
	},
	ChasePathOnSeen = {
		PathDone			= "MutantRearIdle",
	},
	RunPath = {
		PathDone			= "MutantRearIdle",
	},
	UseFlyingFox = {
		PathDone			= "MutantRearIdle",
	},
	
}