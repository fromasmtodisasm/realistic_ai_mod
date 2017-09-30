
AICharacter.CoverGuard = {

	DigIn = {	
		OnReload		= "PREVIOUS",
		OnReceivingDamage	= "PREVIOUS",
		TO_PREVIOUS 		= "PREVIOUS",
		KEEP_FORMATION		= "CoverForm",
		SELECT_RED		= "CoverRedIdle",
		SELECT_BLACK		= "CoverBlackIdle",
		GROUP_MERGE	= "CoverAlert",

	},

	LeanFire = {	
		OnReload		= "PREVIOUS",
		OnReceivingDamage	= "PREVIOUS",
		TO_PREVIOUS 		= "PREVIOUS",
		KEEP_FORMATION		= "CoverForm",
		SELECT_RED		= "CoverRedIdle",
		SELECT_BLACK		= "CoverBlackIdle",
		GROUP_MERGE	= "CoverAlert",

	},


	UnderFire = {
		OnPlayerSeen		 = "CoverGuardIdle",
		OnThreateningSoundHeard  = "CoverGuardIdle",
		RETURN_TO_FIRST		 = "FIRST",
		SELECT_RED		= "CoverRedIdle",
		SELECT_BLACK		= "CoverBlackIdle",

	},

	MountedGuy = {
		RETURN_TO_NORMAL	 = "CoverGuardIdle",
		OnNoTarget		 = "CoverGuardIdle",
		SELECT_RED		= "CoverRedIdle",
		SELECT_BLACK		= "CoverBlackIdle",
	},


	RunToFriend= {
		OnPlayerSeen		 = "CoverAlert",
		SELECT_RED		= "CoverRedIdle",
		SELECT_BLACK		= "CoverBlackIdle",
		GROUP_MERGE	= "CoverAlert",
	},


	HoldPosition = {
		OnPlayerSeen    	= "CoverAttack",
		OnInterestingSoundHeard = "CoverInterested",
		OnSomethingSeen		= "CoverInterested",
		THREAT_TOO_CLOSE	= "CoverThreatened",
		
		OnBulletRain		= "UnderFire",
		OnReceivingDamage	= "UnderFire",

		OnGroupMemberDied	= "CoverAlert",
		OnGrenadeSeen		= "CoverAlert",
		INCOMING_FIRE		= "CoverAlert",
		HEADS_UP_GUYS		= "RunToFriend",
		-----------------------------------
		KEEP_FORMATION		= "CoverForm",
		OnNoFormationPoint 	= "CoverWait",
		SELECT_RED		= "CoverRedIdle",
		SELECT_BLACK		= "CoverBlackIdle",
		-----------------------------------
		-- Job related
		TakePiss			= "Idle_TakePiss",
		Smoking			= "Idle_Smoking",
		BackToJob		= "FIRST",
		
		CheckApparatus		= "Job_CheckApparatus",
		PushButton		="Job_PushButtons",
		PullLever			="Job_PullLever",
				
		-- idles
		LookWall			="Idle_StandLook",
		SitDown			= "Idle_SitDown",
		
	},


	CoverGuardIdle = {
		OnPlayerSeen    	= "CoverAttack",
		OnInterestingSoundHeard = "CoverInterested",
		OnSomethingSeen		= "CoverInterested",

		HOLD_POSITION		= "HoldPosition",
		NORMAL_THREAT_SOUND 	= "CoverThreatened",
--		OnThreateningSoundHeard = "CoverThreatened",

		OnBulletRain		= "UnderFire",
		OnReceivingDamage	= "UnderFire",

		OnGroupMemberDied	= "CoverAlert",
		OnGrenadeSeen		= "CoverAlert",
		INCOMING_FIRE		= "CoverAlert",
		HEADS_UP_GUYS		= "RunToFriend",

		ALARM_ON		= "RunToFriend",

		-----------------------------------
		KEEP_FORMATION		= "CoverForm",
		OnNoFormationPoint 	= "CoverWait",
		SELECT_RED		= "CoverRedIdle",
		SELECT_BLACK		= "CoverBlackIdle",
		-----------------------------------
		-- Job related
		TakePiss			= "Idle_TakePiss",
		Smoking			= "Idle_Smoking",
		BackToJob		= "FIRST",
		
		CheckApparatus		= "Job_CheckApparatus",
		PushButton		="Job_PushButtons",
		PullLever			="Job_PullLever",
				
		-- idles
		LookWall			="Idle_StandLook",
		SitDown			= "Idle_SitDown",
		-----------------------------------
		-- Vehicles related
--		entered_vehicle = "InVehicle",
		
	},

	CoverInterested = {	
		OnPlayerSeen    	= "CoverAttack",
		OnThreateningSoundHeard = "CoverThreatened",
		OnBulletRain		= "CoverAlert",
		OnReceivingDamage	= "CoverAlert",
		OnGroupMemberDied	= "CoverAlert",
		OnGrenadeSeen		= "CoverAlert",
		HEADS_UP_GUYS		= "RunToFriend",
		-- INCOMING_FIRE	= "CoverAlert",

		SELECT_RED		= "CoverRedIdle",
		SELECT_BLACK		= "CoverBlackIdle",
		
		back_to			= "FIRST",
		RETURN_TO_FIRST		= "FIRST",



		-----------------------------------
		-- Vehicles related
--		entered_vehicle = "InVehicle",

	},

	CoverThreatened = {
		OnPlayerSeen    	= "CoverAttack",
		SELECT_RED		= "CoverRedIdle",
		SELECT_BLACK		= "CoverBlackIdle",
		OnGrenadeSeen		= "CoverAlert",
		HEADS_UP_GUYS		= "RunToFriend",
		-- INCOMING_FIRE	= "CoverAlert",

		
		OnNoTarget		= "CoverAlert",
		back_to			= "FIRST",
		
		-----------------------------------
		-- Vehicles related
--		entered_vehicle = "InVehicle",

	
	},

	CoverAlert = {
		OnPlayerSeen    	= "CoverAttack",
		OnInterstingSoundHeard  = "CoverThreatened",
		OnThreateningSoundHeard  = "CoverThreatened",

		SELECT_RED		= "CoverRedIdle",
		SELECT_BLACK		= "CoverBlackIdle",
		
		

		-----------------------------------
		-- Vehicles related
--		entered_vehicle = "InVehicle",
		
		-- pre combat

		
	},

	CoverAttack = {
		KEEP_FORMATION	= "CoverForm",
		OnNoFormationPoint = "CoverWait",
		SELECT_RED	= "CoverRedIdle",
		SELECT_BLACK	= "CoverBlackIdle",


		OnNoHidingPlace = "CoverHold",
		OnNoTarget		= "CoverAlert",
		
		
		-----------------------------------
		-- Vehicles related
--		entered_vehicle = "InVehicle",
		

		OnLowHideSpot	= "DigIn",
		LEFT_LEAN_ENTER		= "LeanFire",
		RIGHT_LEAN_ENTER	= "LeanFire",

		

	},

	CoverHold = {
		OnNoTarget		= "PREVIOUS", --"CoverAlert",
		OnReceivingDamage	= "PREVIOUS", --"CoverAttack",
		OnReload		= "PREVIOUS", --"CoverAttack",
		LOOK_FOR_TARGET		= "PREVIOUS", --"CoverAttack",
		KEEP_FORMATION		= "CoverForm",

		SELECT_RED		= "CoverRedIdle",
		SELECT_BLACK		= "CoverBlackIdle",
		GROUP_MERGE	= "CoverAlert",

	},


	CoverTEAMHold = {
		SELECT_RED		= "CoverRedIdle",
		SELECT_BLACK		= "CoverBlackIdle",

		PHASE_RED_ATTACK	= "CoverRedIdle",
		PHASE_BLACK_ATTACK	= "CoverBlackIdle",
		GROUP_MERGE		= "CoverAlert",
	},

	
	CoverForm = {
		OnNoFormationPoint = "CoverWait",
		BREAK_FORMATION  = "CoverGuardIdle",

		HOLD_POSITION   = "CoverHold",
		OnLowHideSpot	= "DigIn",
	
		-----------------------------------
		-- Vehicles related
--		entered_vehicle = "InVehicle",
		
	},

	CoverWait = {
		OnGroupMemberDied = "CoverForm",
		BREAK_FORMATION  = "CoverGuardIdle",
	},

	CoverRedIdle = {
		GROUP_MERGE	= "CoverAlert",
		RED_COVER	= "CoverTEAMHold",
	},

	CoverBlackIdle = {
		GROUP_MERGE	= "CoverAlert",
		BLACK_COVER	= "CoverTEAMHold",
	},
	-- IDLES
	Idle_TakePiss = {
	--	BackToJob			= "FIRST",
		
	},
	
	
	-- JOBS
	Job_PatrolLinear = {
	},
	
	Job_PatrolCircle = {
	},
	
	Job_PatrolNode = {
	},
	
	Job_Observe = {
	},
	
	Job_StandIdle = {
	},
	
	Job_StandIdleFormation = {
	},
	
	Job_FixCar = {
	},
	
	Job_FixFence = {
	},
	
	UseElevator = {
		PathDone			= "CoverGuardIdle",
	},
	UseFlyingFox = {
		PathDone			= "CoverGuardIdle",
	},	

}