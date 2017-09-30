-- COVER CHARACTER SCRIPT

AICharacter.Cover = {

	DigIn = {	
		OnCloseContact		= "CoverAttack",	
		OnReload		= "PREVIOUS",
		OnReceivingDamage	= "PREVIOUS",
		TO_PREVIOUS 		= "PREVIOUS",
		KEEP_FORMATION		= "CoverForm",
		SELECT_RED		= "CoverRedIdle",
		SELECT_BLACK		= "CoverBlackIdle",
		GROUP_MERGE	= "CoverAlert",

	},

	RunToAlarm = {
		ALARM_ON = "PREVIOUS",
		SELECT_RED		= "CoverRedIdle",
		SELECT_BLACK		= "CoverBlackIdle",

	},

	LeanFire = {
		OnCloseContact		= "CoverAttack",	
		OnReload		= "PREVIOUS",
		OnReceivingDamage	= "PREVIOUS",
		TO_PREVIOUS 		= "PREVIOUS",
		KEEP_FORMATION		= "CoverForm",
		SELECT_RED		= "CoverRedIdle",
		SELECT_BLACK		= "CoverBlackIdle",
		GROUP_MERGE	= "CoverAlert",

	},

	SpecialLead = {
		OnPlayerSeen		 = "CoverAttack",
		OnThreateningSoundHeard  = "CoverAttack",
		OnInterestingSoundHeard  = "CoverAttack",

	},

	SpecialFollow = {		
		OnPlayerSeen		 = "CoverAttack",
		--OnThreateningSoundHeard  = "CoverAttack",
		OnReceivingDamage	  = "CoverAttack",
	},

	SpecialHold = {
		OnPlayerSeen		 = "CoverAttack",
	},




	UnderFire = {
		OnPlayerSeen		 = "CoverIdle",
		OnThreateningSoundHeard  = "CoverIdle",
		RETURN_TO_FIRST		 = "FIRST",
		SELECT_RED		= "CoverRedIdle",
		SELECT_BLACK		= "CoverBlackIdle",

	},

	MountedGuy = {
		RETURN_TO_NORMAL	 = "CoverIdle",
		SELECT_RED		= "CoverRedIdle",
		SELECT_BLACK		= "CoverBlackIdle",
		CONVERSATION_FINISHED   = "MountedGuy",
	},


	RunToFriend= {
		OnPlayerSeen		 = "CoverAlert",
		SELECT_RED		= "CoverRedIdle",
		SELECT_BLACK		= "CoverBlackIdle",
		GROUP_MERGE	= "CoverAlert",
		FINISH_RUN_TO_FRIEND    = "CoverAlert",
	},


	HoldPosition = {
		OnPlayerSeen    	= "CoverAttack",
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
	
		
	},


	CoverIdle = {
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
		-----------------------------------
		KEEP_FORMATION		= "CoverForm",
		OnNoFormationPoint 	= "CoverWait",
		SELECT_RED		= "CoverRedIdle",
		SELECT_BLACK		= "CoverBlackIdle",

	
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

		KEEP_FORMATION		= "CoverForm",
		OnNoFormationPoint 	= "CoverWait",


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

		KEEP_FORMATION		= "CoverForm",
		OnNoFormationPoint 	= "CoverWait",

		
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
		
		
		KEEP_FORMATION		= "CoverForm",
		OnNoFormationPoint 	= "CoverWait",


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
		OnClipNearlyEmpty	= "CoverAttack",
		KEEP_FORMATION		= "CoverForm",
		OnNoFormationPoint 	= "CoverWait",


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
		BREAK_FORMATION  = "CoverIdle",

		HOLD_POSITION   = "CoverHold",
		OnLowHideSpot	= "DigIn",
	
		-----------------------------------
		-- Vehicles related
--		entered_vehicle = "InVehicle",
		
	},

	CoverWait = {
		OnGroupMemberDied = "CoverForm",
		BREAK_FORMATION  = "CoverIdle",
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
		PathDone			= "CoverIdle",
	},
	UseFlyingFox = {
		PathDone			= "CoverIdle",
	},	

}