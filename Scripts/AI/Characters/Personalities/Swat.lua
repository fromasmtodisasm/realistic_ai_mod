--Swat indoor character
--More intelligent, will retreat to better position when pressed. 
--In response to general alert will systematicaly advance, ie one person moves forward covered by person behind,
-- they signal that the point is clear and then back person moves up to next hide.  Uses "cover" anchor / hide points. 

AICharacter.Swat = {


	UnderFire = {
		OnPlayerSeen		= "SwatIdle",
		OnThreateningSoundHeard = "SwatIdle",
	},

	SwatIdle = {
		--OnPlayerSeen	    	= "SwatGroupAdvance",
		OnGroupMemberDied	= "SwatAlert",
		OnBulletRain		= "UnderFire",
		OnReceivingDamage	= "UnderFire",
		OnGrenadeSeen		= "UnderFire",
		-------------------------------------------
--		OnInterestingSoundHeard	= "SwatInterested",
		OnThreateningSoundHeard	= "SwatThreatened",
		-------------------------------------------
		SELECT_GROUPADVANCE	= "SwatGroupAdvance",
		SELECT_GROUPREADY	= "SwatGroupReady",
		ENEMY_CLOSE		= "SwatAttack",
		-------------------------------------------
		-- Job related
		BackToJob		= "FIRST",
		PushButton		="Job_PushButtons",
		PullLever			="Job_PullLever",
				
		-- idles
		TakePiss			= "Idle_TakePiss",
		Smoking			= "Idle_IndoorSmoke",
		LookWall			="Idle_StandLook",
		SitDown			= "Idle_SitDown",	
	},
	
--	SwatInterested = {
--		OnThreateningSoundHeard = "SwatThreatened",
--		--------------------------------------
--		SELECT_GROUPADVANCE	= "SwatGroupAdvance",
--		SELECT_GROUPREADY	= "SwatGroupReady",
--		ENEMY_CLOSE		= "SwatAttack",
--		--------------------------------------
--		back_to			= "FIRST",
--		
--	},
	
	SwatThreatened = {
		--------------------------------------
		SELECT_GROUPADVANCE	= "SwatGroupAdvance",
		SELECT_GROUPREADY	= "SwatGroupReady",
		ENEMY_CLOSE		= "SwatAttack",
		--------------------------------------
		back_to			= "FIRST",
	},

	SwatAlert = {
		OnPlayerSeen	    	= "SwatAttack",
		HEADS_UP_GUYS		= "SwatHunt",
		IGNORE_ALL_ELSE        	 = "CoverReinforce",
		OnInterestingSoundHeard	= "SwatThreatened",
		OnThreateningSoundHeard	= "SwatThreatened",
	},	

	SwatAttack = {
	},

	CoverReinforce = {	
		JoinGroup		= "SwatIdle",
		OFFER_JOIN_TEAM		= "SwatIdle",
	},
	
	ChasePath = {
		PathDone		= "SwatIdle",
	},
	ChasePathOnSeen = {
		PathDone		= "SwatIdle",
	},	
	
	------------------------------------------------------
	SwatGroupReady = {
		SELECT_GROUPADVANCE	= "SwatGroupAdvance",
		SELECT_GROUPWAIT	= "SwatGroupWait",
		ENEMY_CLOSE		= "SwatAttack",
		OnGroupMemberDied	= "SwatGroupReady",
		OnGroupMemberDiedNearest 	= "SwatGroupAdvance",
	},
	
	SwatGroupWait = {
		SELECT_GROUPADVANCE	= "SwatGroupAdvance",
		SELECT_GROUPREADY	= "SwatGroupReady",
		ENEMY_CLOSE		= "SwatAttack",
		OnGroupMemberDied	= "SwatGroupReady",
		OnGroupMemberDiedNearest= "SwatGroupAdvance",
	},
	
	SwatGroupAdvance = {
		SELECT_BACKREADY	= "SwatGroupReady",	
		ENEMY_CLOSE		= "SwatAttack",
		OnGroupMemberDied	= "SwatGroupReady",
		OnGroupMemberDiedNearest	= "SwatGroupAdvance",
	},
}