AIBehaviour.ChimpAlert = {
	Name = "ChimpAlert",

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		AIBehaviour.ChimpIdle:OnPlayerSeen(entity,fDistance,1)
	end,

	OnSomethingSeen = function(self,entity,fDistance)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:InsertSubpipe(0,"predator_is_invisible")
	end,
	
	OnDeadBodySeen = function(self,entity,sender,fDistance)
		if entity.Properties.species==sender.Properties.species and fDistance<=10 and entity.sees~=1 then
			entity:InsertSubpipe(0,"retreat_on_dead_body_seen",sender.id)
			self:OnSomethingDiedNearest(entity,sender)
		end
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
	end,

	OnInterestingSoundHeard = function(self,entity,fDistance)
		AIBehaviour.ChimpIdle:SWITCH_TO_ATTACK(entity)
		entity:InsertSubpipe(0,"predator_is_invisible")
	end,

	OnThreateningSoundHeard = function(self,entity,fDistance)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:SelectPipe(0,"predator_just_attack")
		AI:Signal(0,1,"ANY_MORE_TO_RELEASE",entity.id)
		entity:InsertSubpipe(0,"predator_is_invisible")
	end,

	-- OnGrenadeSeen = function(self,entity,fDistance)
		-- AIBehaviour.ChimpIdle:OnGrenadeSeen(entity)
		-- entity:InsertSubpipe(0,"predator_is_invisible")
	-- end,
	
	-- OnGrenadeSeen_Flying = function(self,entity,sender)
		-- self:OnGrenadeSeen(entity)
	-- end,

	-- OnGrenadeSeen_Colliding = function(self,entity,sender)
		-- self:OnGrenadeSeen(entity)
	-- end,

	OnNoHidingPlace = function(self,entity,sender)
		entity:InsertSubpipe(0,"predator_is_invisible")
	end,

	OnKnownDamage = function(self,entity,sender)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		self:HIDE_LEFT_OR_RIGHT(entity)
		-- if entity:GetDistanceFromPoint(sender:GetPos()) <= 30 then
			-- entity:InsertSubpipe(0,"predator_hide_wait_attack")
		-- end
		entity:InsertSubpipe(0,"predator_is_invisible")
	end,

	OnReceivingDamage = function(self,entity,sender)
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"PREDATOR_SCARED",entity.id)
	end,

	OnBulletRain = function(self,entity,sender)
		self:OnReceivingDamage(entity,sender)
	end,

	OnDeath = function(self,entity,sender)
		AIBehaviour.ChimpIdle:OnDeath(entity,sender)
	end,

	OnSomethingDiedNearest = function(self,entity,sender)
		entity:ChangeAIParameter(AIPARAM_COMMRANGE,30)
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"PREDATOR_SCARED",entity.id)
		entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)
	end,
	
	OnCloseContact = function(self,entity,sender)
		AIBehaviour.ChimpIdle:PREDATOR_MELEE(entity,sender)
		entity:InsertSubpipe(0,"predator_is_invisible")
	end,
	
	PREDATOR_SCARED = function(self,entity,sender)
		-- Hud:AddMessage(entity:GetName()..": PREDATOR_SCARED2")
		-- System:Log(entity:GetName()..": PREDATOR_SCARED2")
		entity:TriggerEvent(AIEVENT_CLEAR)
		entity:SelectPipe(0,"predator_scared_in_action")
		if entity~=sender then
			entity:InsertSubpipe("DropBeaconAt",sender.id)
		end
		entity:InsertSubpipe(0,"predator_is_invisible")
	end,

	HIDE_LEFT_OR_RIGHT = function(self,entity,sender)
		AI:CreateGoalPipe("predator_hide_left_or_right")
		AI:PushGoal("predator_hide_left_or_right","locate",0,"beacon")
		AI:PushGoal("predator_hide_left_or_right","acqtarget",0,"")
		AI:PushGoal("predator_hide_left_or_right","timeout",1,0,1)
		distance = entity:GetDistanceToTarget()
		if distance and distance > 30 then
			look = 1 
		else
			look = 0 
		end
		if not entity.ai_flanking then
			AI:PushGoal("predator_hide_left_or_right","hide",1,30,HM_FARTHEST_FROM_TARGET,look)
		end
		if not entity.ai_flanking then
			entity.ai_flanking = random(1,2)
		end
		if entity.ai_flanking==1 then
			if random(1,2)==1 then
				AI:PushGoal("predator_hide_left_or_right","hide",1,60,HM_LEFTMOST_FROM_TARGET,look)
			else
				AI:PushGoal("predator_hide_left_or_right","hide",1,60,HM_LEFT_FROM_TARGET,look)
			end
		else
			if random(1,2)==1 then
				AI:PushGoal("predator_hide_left_or_right","hide",1,60,HM_RIGHTMOST_FROM_TARGET,look)
			else
				AI:PushGoal("predator_hide_left_or_right","hide",1,60,HM_RIGHT_FROM_TARGET,look)
			end
		end
		look = nil 
		AI:PushGoal("predator_hide_left_or_right","signal",0,1,"CHECK_FOR_FIND_A_TARGET",0)
		entity:SelectPipe(0,"predator_hide_left_or_right")
	end,
}