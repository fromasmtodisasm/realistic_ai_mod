-- Test Character SCRIPT

AICharacter.Scout = {


	UnderFire = {
		OnPlayerSeen		 = "ScoutIdle",
		OnThreateningSoundHeard  = "ScoutIdle",
		SELECT_RED		= "ScoutRedIdle",
		SELECT_BLACK		= "ScoutBlackIdle",

	},

	MountedGuy = {
		-- RETURN_TO_NORMAL	 = "ScoutIdle",
		-- RETURN_TO_NORMAL		= "ScoutAttack",
		REAL_RETURN_TO_NORMAL	= "ScoutAttack",
		SELECT_RED		= "ScoutRedIdle",
		SELECT_BLACK		= "ScoutBlackIdle",
		CONVERSATION_FINISHED   = "MountedGuy",

	},


	RunToAlarm = {
		REAL_ALARM_ON = "PREVIOUS",
		-- OnReceivingDamage		= "UnderFire",
		SELECT_RED		= "ScoutRedIdle",
		SELECT_BLACK		= "ScoutBlackIdle",
	},
	

	-- RunToFriend= {
		-- OnPlayerSeen		 = "ScoutAlert",
		-- SELECT_RED		= "ScoutRedIdle",
		-- SELECT_BLACK		= "ScoutBlackIdle",
		-- FINISH_RUN_TO_FRIEND	= "ScoutAlert",
	--},

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

		-- OnGrenadeSeen		= "ScoutAlert",
		-- HEADS_UP_GUYS		= "RunToFriend",
		-----------------------------------
		SELECT_RED		= "ScoutRedIdle",
		SELECT_BLACK		= "ScoutBlackIdle",
		-----------------------------------
		-- Job related
	
	},


	ScoutIdle = {
		OnPlayerSeen	    		= "ScoutAttack",
		-- HEADS_UP_GUYS				= "RunToFriend",
		HEADS_UP_GUYS				= "ScoutAlert",
		ALERT_SIGNAL				= "ScoutAlert",
		OnBulletRain				= "UnderFire",
		OnReceivingDamage			= "ScoutAlert",
		-- OnGrenadeSeen				= "ScoutAlert",
		HOLD_POSITION				= "ScoutAlert",
		ALERT_SIGNAL				= "ScoutAlert",
		NORMAL_THREAT_SOUND 		= "ScoutAlert",
		-- LOOK_AT_BEACON				= "ScoutAlert",
		OnSomethingSeen				= "ScoutAlert",
		OnSomethingDiedNearest		= "ScoutAlert",		
		OnSomethingDiedNearest_x	= "ScoutAlert",
		INCOMING_FIRE				= "UnderFire",
		SELECT_RED					= "ScoutRedIdle",
		SELECT_BLACK				= "ScoutBlackIdle",
	},

	ScoutAttack = {
		OnNoTarget	    	= "ScoutAlert",
		START_HUNTING	    	= "ScoutHunt",
		JoinGroup			= "ScoutIdle",			
		SELECT_RED			= "ScoutRedIdle",
		SELECT_BLACK		= "ScoutBlackIdle",
	},

	ScoutRedIdle = {
		GROUP_MERGE		= "ScoutAlert",
	},

	ScoutBlackIdle = {
		GROUP_MERGE		= "ScoutAlert",
	},


	ScoutAlert = {
		OnPlayerSeen	    	= "ScoutAttack",
		-- HEADS_UP_GUYS			= "RunToFriend",
		SELECT_RED				= "ScoutRedIdle",
		SELECT_BLACK			= "ScoutBlackIdle",
		SCOUT_NORMALATTACK		= "ScoutHunt",
		SCOUT_HUNT 				= "ScoutAttack",
	},	

	ScoutHunt = {
		OnPlayerSeen				= "ScoutAttack",
		-- ATTACK_ENEMY				= "ScoutAttack",
		-- OnGrenadeSeen				= "ScoutAlert",
		INCOMING_FIRE				= "ScoutAlert",
		SELECT_RED					= "ScoutRedIdle",
		SELECT_BLACK				= "ScoutBlackIdle",
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