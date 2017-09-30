-- Test Character SCRIPT

AICharacter.Sniper = {

	ChasePath = {
		PathDone		= "SniperIdle",
	},
	
	ChasePathOnSeen = {
		PathDone		= "SniperIdle",
	},
	
	SniperIdle = {
		OnPlayerSeen    	= "SniperIdle",
		OnInterestingSoundHeard = "SniperIdle",
		OnThreateningSoundHeard = "SniperIdle",
		OnBulletRain		= "SniperIdle",
		OnReceivingDamage	= "SniperIdle",
		OnGroupMemberDied	= "SniperIdle",
		OnGrenadeSeen		= "SniperIdle",
		SWITCH_TO_MORTARGUY     = "SniperIdle",
		
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
		entered_vehicle = "InVehicle",
	},
	
--	SniperAttack={},
}