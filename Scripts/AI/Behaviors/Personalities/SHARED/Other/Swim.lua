AIBehaviour.Swim = {
	Name = "Swim",
	NOPREVIOUS = 1,

	OnSelected = function( self,entity )
	end,

	OnSpawn = function( self,entity )
	end,

	OnActivate = function( self,entity )
	end,

	OnNoTarget = function(self,entity)
		entity:RunToMountedWeapon()
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:InsertSubpipe(0,"do_it_running")
		if fDistance<5 then
			entity:InsertSubpipe(0,"melee_attack_in_water")
		end
		entity:RunToMountedWeapon()
	end,

	OnEnemySeen = function(self,entity)
	end,

	OnFriendSeen = function(self,entity)
	end,

	OnSomethingSeen = function(self,entity)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:InsertSubpipe(0,"do_it_running")
	end,

	OnDeadBodySeen = function(self,entity,sender,fDistance)
		entity:InsertSubpipe(0,"do_it_running")
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:InsertSubpipe(0,"do_it_running")
		if fDistance<5 then
			entity:InsertSubpipe(0,"melee_attack_in_water")
		end
	end,

	OnInterestingSoundHeard = function(self,entity,fDistance)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:InsertSubpipe(0,"do_it_running")
	end,

	OnThreateningSoundHeard = function(self,entity,fDistance)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:InsertSubpipe(0,"do_it_running")
		entity:RunToMountedWeapon()
	end,

	OnReload = function(self,entity)
	end,

	OnNoHidingPlace = function(self,entity,sender)
	end,

	OnNoFormationPoint = function(self,entity,sender)
	end,

	OnCoverRequested = function(self,entity,sender)
	end,

	OnKnownDamage = function(self,entity,sender)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:InsertSubpipe(0,"do_it_running")
	end,

	OnReceivingDamage = function(self,entity,sender)
		entity:InsertSubpipe(0,"do_it_running")
	end,

	OnBulletRain = function(self,entity,sender)
		entity:InsertSubpipe(0,"do_it_running")
	end,

	OnCloseContact = function(self,entity,sender)
		if entity.Properties.species~=sender.Properties.species then
			entity:TriggerEvent(AIEVENT_DROPBEACON)
			if not entity.MeleeAttack and not entity.MeleeAttack2 then
				-- entity:InsertSubpipe(0,"AcqBeacon",sender.id)
				-- entity:InsertSubpipe(0,"retreat_on_close",sender.id)
			end
			entity:InsertSubpipe(0,"AcqBeacon",sender.id)
			entity:InsertSubpipe(0,"just_shoot")
			entity:InsertSubpipe(0,"do_it_running")
		end
	end,

	OnGrenadeSeen = function(self,entity,fDistance)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:InsertSubpipe(0,"do_it_running")
	end,

	OnGrenadeSeen_Flying = function(self,entity,sender)
		self:OnGrenadeSeen(entity)
	end,

	OnGrenadeSeen_Colliding = function(self,entity,sender)
		self:OnGrenadeSeen(entity)
	end,

	OnDeath = function(self,entity,sender)
		AIBehaviour.DEFAULT:OnDeath(entity)
	end,

	OnSomethingDiedNearest = function(self,entity,sender)
	end,

	OnSomethingDiedNearest_x = function(self,entity,sender)
	end,

	MERC_START_SWIMMING = function(self,entity,sender)
		-- Hud:AddMessage(entity:GetName()..": MERC_START_SWIMMING")
		-- System:Log(entity:GetName()..": MERC_START_SWIMMING")
		AI:CreateGoalPipe("swim_to")
		AI:PushGoal("swim_to","not_shoot")
		AI:PushGoal("swim_to","timeout",0,2)
		AI:PushGoal("swim_to","acqtarget",1,"")
		if not entity.WasInCombat then
			AI:PushGoal("swim_to","do_it_walking")
		else
			AI:PushGoal("swim_to","do_it_running")
		end
		AI:PushGoal("swim_to","pathfind",1,"")
		AI:PushGoal("swim_to","trace",1,1,0)
		AI:PushGoal("swim_to","approach",1,1) -- На всякий случай.
		AI:PushGoal("swim_to","trace",1,1,0)
		AI:PushGoal("swim_to","devalue",0)
		AI:PushGoal("swim_to","signal",1,1,"MERC_START_SWIMMING",0)

		-- AI:CreateGoalPipe("swim_inplace")
		-- AI:PushGoal("swim_inplace","not_shoot")
		-- AI:PushGoal("swim_inplace","timeout",1,.5)
		-- AI:PushGoal("swim_inplace","signal",1,1,"MERC_START_SWIMMING",0)
		AI:CreateGoalPipe("swim_inplace")
		-- AI:PushGoal("swim_inplace","not_shoot")
		AI:PushGoal("swim_inplace","timeout",1,2)
		AI:PushGoal("swim_inplace","signal",1,1,"MERC_START_SWIMMING",0)
		entity:SelectPipe(0,"swim_inplace") -- Иногда перебивается другими пайпами.
		-- entity:InsertSubpipe(0,"not_shoot")
		local SwimPoint = entity:FindThePointForSwimming()
		if SwimPoint then
			-- Hud:AddMessage(entity:GetName()..": SwimPoint")
			-- System:Log(entity:GetName()..": SwimPoint")
		else
			-- Hud:AddMessage(entity:GetName()..": Not SwimPoint")
			-- System:Log(entity:GetName()..": Not SwimPoint")
			entity.RepeatMercStartSwimmingTimerStart = _time
		end
		if SwimPoint then entity:SelectPipe(0,"swim_to",SwimPoint) end
	end,

	MERC_STOP_SWIMMING = function(self,entity,sender)
		-- entity.RunToTrigger = nil -- Тоже, спорный вопрос.
		-- entity:SelectPipe(0,"swim_inplace")
		AI:Signal(0,-1,"AFTER_SWIMMING_BEHAVIOUR",entity.id)
		-- System:Log(entity:GetName()..": AFTER_SWIMMING_BEHAVIOUR 1: "..entity.Behaviour.Name)
	end,
}