-- COVER CHARACTER SCRIPT

AICharacter.Cover = {

	DigIn = {
		OnCloseContact			= "CoverAttack",
		OnReload 				= "CoverAttack",
		OnReceivingDamage 		= "CoverAttack",
		TO_PREVIOUS 			= "CoverAttack",
		KEEP_FORMATION			= "CoverForm",
		SELECT_RED				= "CoverRedIdle",
		SELECT_BLACK			= "CoverBlackIdle",
		GROUP_MERGE				= "CoverAlert",
	},

	RunToAlarm = {
		REAL_ALARM_ON 			= "PREVIOUS",
		OnReceivingDamage		= "UnderFire",
		SELECT_RED				= "CoverRedIdle",
		SELECT_BLACK			= "CoverBlackIdle",
	},

	LeanFire = {
		OnCloseContact			= "CoverAttack",
		-- OnReload				= "PREVIOUS",
		-- OnReceivingDamage		= "PREVIOUS",
		-- TO_PREVIOUS 			= "PREVIOUS",
		OnReload 				= "CoverAttack",
		OnReceivingDamage	 	= "CoverAttack",
		TO_PREVIOUS 			= "CoverAttack",
		KEEP_FORMATION			= "CoverForm",
		SELECT_RED				= "CoverRedIdle",
		SELECT_BLACK			= "CoverBlackIdle",
		GROUP_MERGE				= "CoverAlert",
	},

	SpecialLead = {
		OnPlayerSeen			= "CoverAttack",
		OnThreateningSoundHeard = "CoverAttack",
		OnInterestingSoundHeard = "CoverAttack",
	},

	SpecialFollow = {
		OnPlayerSeen			= "CoverAttack",
		-- OnThreateningSoundHeard  = "CoverAttack",
		OnReceivingDamage	 	= "CoverAttack",
	},

	SpecialHold = {
		OnPlayerSeen			= "CoverAttack",
	},

	UnderFire = {
		OnPlayerSeen			= "CoverAttack",
		OnThreateningSoundHeard = "CoverAttack",
		SELECT_RED				= "CoverRedIdle",
		SELECT_BLACK			= "CoverBlackIdle",
	},

	MountedGuy = {
		-- RETURN_TO_NORMAL		= "CoverAttack",
		REAL_RETURN_TO_NORMAL	= "CoverAttack",
		SELECT_RED				= "CoverRedIdle",
		SELECT_BLACK			= "CoverBlackIdle",
		CONVERSATION_FINISHED   = "MountedGuy",
	},

	-- RunToFriend	= {-- Переход в алерт.
		-- OnPlayerSeen			= "CoverAlert",
		-- OnSomethingDiedNearest	= "CoverAlert",
		-- OnSomethingDiedNearest_x= "CoverAlert",
		-- SELECT_RED				= "CoverRedIdle",
		-- SELECT_BLACK			= "CoverBlackIdle",
		-- GROUP_MERGE				= "CoverAlert",
		-- FINISH_RUN_TO_FRIEND    = "CoverAlert",
	--},

	HoldPosition = {
		OnPlayerSeen    		= "CoverAttack",
		OnSomethingSeen		= "CoverInterested",
		THREAT_TOO_CLOSE	= "CoverThreatened",
		OnBulletRain		= "UnderFire",
		OnReceivingDamage	= "UnderFire",
		-- OnGrenadeSeen		= "CoverAlert",
		-- INCOMING_FIRE		= "CoverAlert",
		-- HEADS_UP_GUYS		= "RunToFriend",
		-----------------------------------
		KEEP_FORMATION		= "CoverForm",
		OnNoFormationPoint 	= "CoverWait",
		SELECT_RED			= "CoverRedIdle",
		SELECT_BLACK		= "CoverBlackIdle",
		-----------------------------------
		-- Job related
	},

	CoverIdle = {
		OnPlayerSeen   	 			= "CoverAttack",
		-- INTERESTED 				= "CoverInterested",
		HOLD_POSITION				= "HoldPosition",-- Не CoverHold!
		OnThreateningSoundHeard		= "CoverThreatened",
		COVER_NORMALATTACK			= "CoverAttack",
		HEADS_UP_GUYS				= "CoverAlert",
		ALERT_SIGNAL				= "CoverAlert",
		LOOK_AT_BEACON				= "CoverInterested",
		OnSomethingDiedNearest		= "CoverAlert",
		OnSomethingDiedNearest_x 	= "CoverAlert",
		INCOMING_FIRE				= "UnderFire",
		OnReceivingDamage			= "CoverAlert",
		KEEP_FORMATION				= "CoverForm",
		OnNoFormationPoint 			= "CoverWait",
		SELECT_RED					= "CoverRedIdle",
		SELECT_BLACK				= "CoverBlackIdle",

	},

	CoverInterested = {
		OnPlayerSeen    		= "CoverAttack",
		-- OnThreateningSoundHeard = "CoverThreatened",
		ALERT_SIGNAL					= "CoverAlert",
		OnBulletRain			= "CoverAlert",
		OnReceivingDamage		= "CoverAlert",
		-- OnGrenadeSeen			= "CoverAlert",
		-- HEADS_UP_GUYS			= "RunToFriend",
		INCOMING_FIRE			= "CoverAlert",
		SELECT_RED				= "CoverRedIdle",
		SELECT_BLACK			= "CoverBlackIdle",
		back_to					= "FIRST",
		ON_PREVIOUS				= "PREVIOUS",
		KEEP_FORMATION			= "CoverForm",
		OnNoFormationPoint 		= "CoverWait",
		OnSomethingDiedNearest 	= "CoverAlert",
		OnSomethingDiedNearest_x = "CoverAlert",

	},

	CoverThreatened = {
		OnPlayerSeen    			= "CoverAttack",
		ALERT_SIGNAL				= "CoverAlert",
		SELECT_RED					= "CoverRedIdle",
		SELECT_BLACK				= "CoverBlackIdle",
		-- OnGrenadeSeen				= "CoverAlert",
		INCOMING_FIRE				= "CoverAlert",
		LOOK_AT_BEACON				= "CoverAlert",
		-- OnNoTarget					= "CoverAlert",-- не ставить
		back_to						= "FIRST",
		KEEP_FORMATION				= "CoverForm",
		OnNoFormationPoint 			= "CoverWait",
		OnSomethingDiedNearest		= "CoverAlert",
		OnSomethingDiedNearest_x	= "CoverAlert",

	},

	CoverAlert = {
		OnPlayerSeen    	= "CoverAttack",
		-- OnInterstingSoundHeard  = "CoverThreatened",
		-- OnInterstingSoundHeard  = "CoverAttack",
		-- OnThreateningSoundHeard  = "CoverAttack",
		COVER_NORMALATTACK   	= "CoverAttack",
		SELECT_RED			= "CoverRedIdle",
		SELECT_BLACK		= "CoverBlackIdle",
		KEEP_FORMATION		= "CoverForm",
		OnNoFormationPoint 	= "CoverWait",

	},

	CoverAttack = {
		KEEP_FORMATION	= "CoverForm",
		OnNoFormationPoint = "CoverWait",
		SELECT_RED		= "CoverRedIdle",
		SELECT_BLACK	= "CoverBlackIdle",
		FIND_A_TARGET = "CoverHold",
		-- OnNoHidingPlace = "CoverHold",

	},

	CoverHold = {-- Если стоять на месте,то стоять! Сделать поменьше переходов в атаку.
		OnInterestingSoundHeard = "PREVIOUS",
		OnReceivingDamage	= "PREVIOUS",--"CoverAttack",
		-- OnReload			= "PREVIOUS",--"CoverAttack",
		LOOK_FOR_TARGET		= "PREVIOUS",--"CoverAttack",
		ATTACK				= "CoverAttack",
		KEEP_FORMATION		= "CoverForm",
		OnNoFormationPoint 	= "CoverWait",
		SELECT_RED			= "CoverRedIdle",
		SELECT_BLACK		= "CoverBlackIdle",
		GROUP_MERGE			= "CoverAlert",
	},

	CoverTEAMHold = {
		SELECT_RED		= "CoverRedIdle",
		SELECT_BLACK		= "CoverBlackIdle",
		PHASE_RED_ATTACK	= "CoverRedIdle",
		PHASE_BLACK_ATTACK	= "CoverBlackIdle",
		GROUP_MERGE		= "CoverAlert",
	},

	CoverEnvelop = {
	},

	CoverForm = {
		OnNoFormationPoint = "CoverWait",
		BREAK_FORMATION  = "CoverIdle",
		HOLD_POSITION   = "CoverHold",
		DIG_IN_ATTACK	= "DigIn",

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

	-- Swim = {
	--},

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