-- Test Character SCRIPT

AICharacter.Sniper = {

	ChasePath = {
		PathDone		= "SniperIdle",
	},

	ChasePathOnSeen = {
		PathDone		= "SniperIdle",
	},

	SniperIdle = {
		OnPlayerSeen    		= "SniperAttack",
		OnThreateningSoundHeard = "SniperAlert",
		NORMAL_THREAT_SOUND 	= "SniperAlert",
		OnBulletRain			= "SniperAlert",
		OnSomethingSeen			= "SniperAlert",
		ALERT_SIGNAL			= "SniperAlert",
		LOOK_AT_BEACON			= "SniperAlert",
		OnSomethingDiedNearest	= "SniperAlert",
		OnSomethingDiedNearest_x = "SniperAlert",
		INCOMING_FIRE			= "UnderFire",
		HEADS_UP_GUYS 			= "SniperAlert",
		OnReceivingDamage			= "SniperAlert",
		-- Job related
		TakePiss			=	"Idle_TakePiss",
		Smoking				=	"Idle_Smoking",
		BackToJob			=	"FIRST",
		LookInTheBinoculars	=	"Idle_Binoculars",
		CheckApparatus		=	"Job_CheckApparatus",
		PushButton			=	"Job_PushButtons",
		PullLever			=	"Job_PullLever",

		-- idles
		LookWall			=	"Idle_StandLook",
		SitDown				=	"Idle_SitDown",
	},

	SniperAlert = {
		OnPlayerSeen    		= "SniperAttack",
	},

	SniperAttack = {
	},

	SniperE3 = {
	},
}