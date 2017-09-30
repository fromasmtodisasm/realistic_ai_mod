AIBehaviour.Job_CroweOne = {
	Name = "Job_CroweOne",

	OnSpawn = function(self,entity)
		-- entity:InitAIRelaxed()
		-- AI:CreateGoalPipe("crowe_special_talk")
		-- AI:PushGoal("crowe_special_talk","not_shoot")
		-- AI:PushGoal("crowe_special_talk","timeout",1,.5)
		-- AI:PushGoal("crowe_special_talk","signal",1,1,"DO_SOMETHING_IDLE",0)
		-- AI:PushGoal("crowe_special_talk","timeout",1,100)
		-- entity:SelectPipe(0,"crowe_special_talk")
		-- entity:InsertSubpipe(0,"setup_idle")
		self:OnJobContinue(entity)
	end,

	OnJobContinue = function(self,entity,sender)
		-- entity.cnt:HoldGun()
		-- entity.AI_GunOut = 1
		local dh=entity:GetName().."_CROWETARGET"
		-- try to get tagpoint of the same name as yourself first
		local TagPoint = Game:GetTagPoint(dh)
 		if not TagPoint then
			-- try to fish for a observation anhor within 2 meter from yourself
			Hud:AddMessage("CROWE DIDN'T FIND WHERE TO GO. PUT TAGPOINT <name>_CROWETARGET")
			AIBehaviour.Job_PracticeFire:OnLowAmmoExit(entity,1)
		end
		entity:SelectPipe(0,"observe_direction",dh)
		if TagPoint then
			entity:InsertSubpipe(0,"patrol_approach_to",dh)
		end
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		-- Hud:AddMessage(entity:GetName()..": Job_CroweOn/OnPlayerSeen")
		-- System:Log(entity:GetName()..": Job_CroweOn/OnPlayerSeen")
		-- entity:StartAnimation(0,"NULL",4)
		-- entity.cnt:HoldGun()
		-- entity.AI_GunOut = 1
		local dh=entity:GetName().."_CROWETARGET"
		-- try to get tagpoint of the same name as yourself first
		local TagPoint = Game:GetTagPoint(dh)
 		if not TagPoint then
			-- try to fish for a observation anhor within 2 meter from yourself
			Hud:AddMessage("CROWE DIDN'T FIND WHERE TO GO. PUT TAGPOINT <name>_CROWETARGET")
			AIBehaviour.Job_PracticeFire:OnLowAmmoExit(entity,1)
			-- entity.EventToCall = "OnPlayerSeen"
		else
			entity:GunOut()
			entity:SelectPipe(0,"patrol_run_to",dh)
		end
	end,

	OnInterestingSoundHeard = function(self,entity,fDistance)
		self:OnPlayerSeen(entity,fDistance,1)
	end,

	OnThreateningSoundHeard = function(self,entity,fDistance)
		self:OnPlayerSeen(entity,fDistance,1)
	end,

	HEADS_UP_GUYS = function(self,entity,sender)
		self:OnPlayerSeen(entity,0,1)
	end,

	OnBulletRain = function(self,entity,sender)
		self:OnPlayerSeen(entity,0,1)
	end,

	OnReceivingDamage = function(self,entity,sender) -- Нужно ли говорить товарищам при таком повреждении?
		self:OnPlayerSeen(entity,0,1)
	end,

	OnSomethingDiedNearest = function(self,entity,sender)
		self:OnPlayerSeen(entity,0,1)
	end,

	OnSomethingDiedNearest_x = function(self,entity,sender)
		self:OnPlayerSeen(entity,0,1)
	end,

	OnCloseContact = function(self,entity,sender)
		self:OnPlayerSeen(entity,0,1)
	end,

	ALARM_ON = function(self,entity,sender)
		self:OnPlayerSeen(entity,0,1)
	end,

	ALERT_SIGNAL = function(self,entity,sender)
		self:OnPlayerSeen(entity,0,1)
	end,

	NORMAL_THREAT_SOUND = function(self,entity,sender)
		self:OnPlayerSeen(entity,0,1)
	end,

	LOOK_AT_BEACON = function(self,entity,sender)
		self:OnPlayerSeen(entity,0,1)
	end,

	STOP_LOOK_AT_BEACON = function(self,entity,sender)
		self:OnPlayerSeen(entity,0,1)
	end,

	INCOMING_FIRE = function(self,entity,sender)
		self:OnPlayerSeen(entity,0,1)
	end,

	GoForReinforcement = function(self,entity,sender)
		self:OnPlayerSeen(entity,0,1)
	end,

	RunToAlarmSignal = function(self,entity,sender)
		self:OnPlayerSeen(entity,0,1)
	end,

	FIND_A_TARGET = function(self,entity,sender)
		self:OnPlayerSeen(entity,0,1)
	end,

	TARGET_LOST = function(self,entity,sender)
		self:OnPlayerSeen(entity,0,1)
	end,

	SWITCH_TO_MORTARGUY = function(self,entity,sender)
		self:OnPlayerSeen(entity,0,1)
	end,

	SEARCH_AMMUNITION = function(self,entity,sender)
		self:OnPlayerSeen(entity,0,1)
	end,

	PRE_GRENADE_EXIT = function(self,entity,sender)
		self:OnPlayerSeen(entity,0,1)
	end,

	GRENADE_EXIT = function(self,entity,sender)
		self:OnPlayerSeen(entity,0,1)
	end,
}