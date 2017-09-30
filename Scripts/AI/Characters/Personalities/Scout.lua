-- Test Character SCRIPT

AICharacter.Scout = {


	UnderFire = {
		OnPlayerSeen		 = "ScoutIdle",
		OnThreateningSoundHeard  = "ScoutIdle",
		RETURN_TO_FIRST		 = "FIRST",
		SELECT_RED		= "ScoutRedIdle",
		SELECT_BLACK		= "ScoutBlackIdle",

	},

	MountedGuy = {
		RETURN_TO_NORMAL	 = "ScoutIdle",
		SELECT_RED		= "ScoutRedIdle",
		SELECT_BLACK		= "ScoutBlackIdle",
		CONVERSATION_FINISHED   = "MountedGuy",

	},


	RunToAlarm = {
		ALARM_ON = "PREVIOUS",
		SELECT_RED		= "ScoutRedIdle",
		SELECT_BLACK		= "ScoutBlackIdle",

	},
	

	RunToFriend= {
		OnPlayerSeen		 = "ScoutAlert",
		SELECT_RED		= "ScoutRedIdle",
		SELECT_BLACK		= "ScoutBlackIdle",
		FINISH_RUN_TO_FRIEND	= "ScoutAlert",

	},

	RunToTrigger = {
		OnPlayerSeen		 = "ScoutIdle",
		OnThreateningSoundHeard  	= "ScoutIdle",
		SELECT_RED		= "ScoutRedIdle",
		SELECT_BLACK		= "ScoutBlackIdle",

	},

	SpecialLead = {
		OnPlayerSeen		 = "ScoutAttack",
		OnThreateningSoundHeard  = "ScoutAttack",
		OnInterestingSoundHeard  = "ScoutAttack",

	},

	SpecialFollow = {
		OnPlayerSeen		 = "ScoutAttack",
		OnThreateningSoundHeard  = "ScoutAttack",

	},

	HoldPosition = {
		OnPlayerSeen    	= "ScoutAttack",
		OnSomethingSeen		= "ScoutHunt",
		THREAT_TOO_CLOSE	= "ScoutHunt",
		
		OnBulletRain		= "UnderFire",
		OnReceivingDamage	= "UnderFire",

		OnGrenadeSeen		= "ScoutAlert",
		HEADS_UP_GUYS		= "RunToFriend",
		-----------------------------------
		SELECT_RED		= "ScoutRedIdle",
		SELECT_BLACK		= "ScoutBlackIdle",
		-----------------------------------
		-- Job related
	
	},


	ScoutIdle = {

		OnPlayerSeen	    	= "ScoutAttack",
		OnGroupMemberDied	= "ScoutAlert",
		HEADS_UP_GUYS		= "RunToFriend",
		OnSomethingSeen		= "ScoutHunt",
		--------------------------------------
		OnBulletRain		= "UnderFire",
		OnReceivingDamage	= "UnderFire",
		OnGrenadeSeen		= "ScoutAlert",
		----------------------------------------
		OnInterestingSoundHeard	= "ScoutHunt",

		HOLD_POSITION		= "HoldPosition",
		NORMAL_THREAT_SOUND 	= "ScoutHunt",
--		OnThreateningSoundHeard	= "ScoutHunt",
		-------------------------------------------
		SELECT_RED		= "ScoutRedIdle",
		SELECT_BLACK		= "ScoutBlackIdle",
		-----------------------------------
	},


	ScoutAttack = {
		OnNoTarget	    	= "ScoutAlert",
		JoinGroup		= "ScoutIdle",			
		SELECT_RED		= "ScoutRedIdle",
		SELECT_BLACK		= "ScoutBlackIdle",
		RETURN_TO_FIRST		= "FIRST",


	},

	ScoutRedIdle = {
		GROUP_MERGE		= "ScoutAlert",
	},

	ScoutBlackIdle = {
		GROUP_MERGE		= "ScoutAlert",
	},


	ScoutAlert = {
		OnPlayerSeen	    	= "ScoutAttack",
		HEADS_UP_GUYS		= "RunToFriend",
		SELECT_RED		= "ScoutRedIdle",
		SELECT_BLACK		= "ScoutBlackIdle",
		OnInterestingSoundHeard	= "ScoutHunt",
		OnThreateningSoundHeard	= "ScoutHunt",
		RETURN_TO_FIRST		= "FIRST",
	},	

	ScoutHunt = {
		OnPlayerSeen		= "ScoutAttack",
		SCOUT_GOTO_ALERT	= "ScoutAlert",
		SELECT_RED		= "ScoutRedIdle",
		SELECT_BLACK		= "ScoutBlackIdle",
		RETURN_TO_FIRST		= "FIRST",
	},

	
	ChasePath = {
		PathDone			= "ScoutIdle",
	},
	ChasePathOnSeen = {
		PathDone			= "ScoutIdle",
	},
	UseFlyingFox = {
		PathDone			= "ScoutIdle",
	},
}