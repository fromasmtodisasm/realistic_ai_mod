--------------------------------------------------
--   Created By: amanda
--   Description: run to alarm anchor
--------------------------

AIBehaviour.RunToAlarm = {
	Name = "RunToAlarm",
	NOPREVIOUS = 1,
	
	---------------------------------------------
	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if fDistance < 15 then
			AI:Signal(0,1,"EXIT_RUNTOALARM",entity.id)
		end
	end,
	---------------------------------------------
	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		-- called when the enemy can no longer see its foe,but remembers where it saw it last
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity,fDistance)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if fDistance < 15 then
			AI:Signal(0,1,"EXIT_RUNTOALARM",entity.id)
		end
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity,fDistance)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
	end,
	--------------------------------------------------
	OnKnownDamage = function(self,entity,sender)
		if (entity.dmg_percent<.5) then
			AI:Signal(0,1,"EXIT_RUNTOALARM",entity.id)
		end
		if sender then -- Он оказывается ещё и пустым может быть.
			entity:InsertSubpipe(0,"scared_shoot",sender.id)
		end
	end,
	--------------------------------------------------
	OnReceivingDamage = function(self,entity,sender)
		AIBehaviour.RunToAlarm:OnKnownDamage(entity)
	end,
	--------------------------------------------------
	OnBulletRain = function(self,entity,sender)	
	end,

	OnSomethingDiedNearest = function(self,entity,sender)
	end,

	OnSomethingDiedNearest_x = function(self,entity,sender) -- Проверить уровень тревоги! Проверить расстояние до трупа, если distance < x, то передать эстафету.
	end,

	EXIT_RUNTOALARM = function(self,entity,sender)
		if self.BlindAlarmNameEntity and self.BlindAlarmNameEntity.engaged==self.id then
			self.BlindAlarmNameEntity.engaged = -1  self.BlindAlarmNameEntity = nil  self.BlindAlarmName = nil 
		end
		if self.AlarmNameEntity and self.AlarmNameEntity.engaged==self.id then
			self.AlarmNameEntity.engaged = -1  self.AlarmNameEntity = nil  self.AlarmName = nil 
		end
		if self.NotifyAnchorEntity and self.NotifyAnchorEntity.engaged==self.id then
			self.NotifyAnchorEntity.engaged = -1  self.NotifyAnchorEntity = nil  self.NotifyAnchor = nil 
		end
		-- if self.BlindAlarmNameEntity and self.BlindAlarmNameEntity.engaged==self.id then
			-- self.BlindAlarmNameEntity.engaged = -1  -- А что, если другие после будут пытаться снова активировать эту сигнализацию?
		-- end
		-- if self.AlarmNameEntity and self.AlarmNameEntity.engaged==self.id then
			-- self.AlarmNameEntity.engaged = -1 
		-- end
		-- if self.NotifyAnchorEntity and self.NotifyAnchorEntity.engaged==self.id then
			-- self.NotifyAnchorEntity.engaged = -1 
		-- end
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"RunToAlarmSignal",entity.id) -- Всем. -- После очистки id.
		entity.RunToTrigger = nil 
		-- entity.temp_no_MG = nil 
		-- if entity.runga==1 then
			-- entity.runga = nil 
			-- -- entity.DistanceToPlayer = nil 
			-- -- if entity:GettingAlerted()==0 then
				-- -- entity:SelectPipe(0,"check_beacon")
			-- -- end
			if not entity:RunToAlarm() then -- Себе. -- Снова аларм! Мало ли что...
				entity:SelectPipe(0,"check_beacon")
			end
		-- end
		-- AI:MakePuppetIgnorant(entity.id,0) -- Используется.
	end,

	--------------------------------------------------
	-- GROUP SIGNALS
	--------------------------------------------------
	HEADS_UP_GUYS = function(self,entity,sender)
		-- dont handle this signal
		-- entity.RunToTrigger = 1 
	end,
	---------------------------------------------
	INCOMING_FIRE = function(self,entity,sender)
		-- dont handle this signal
	end,
	---------------------------------------------	
	KEEP_FORMATION = function(self,entity,sender)
		-- the team leader wants everyone to keep formation
	end,
	---------------------------------------------	
	BREAK_FORMATION = function(self,entity,sender)
		-- the team can split
	end,
	---------------------------------------------	
	SINGLE_GO = function(self,entity,sender)
		-- the team leader has instructed this group member to approach the enemy
	end,
	---------------------------------------------	
	GROUP_COVER = function(self,entity,sender)
		-- the team leader has instructed this group member to cover his friends
	end,
	---------------------------------------------	
	IN_POSITION = function(self,entity,sender)
		-- some member of the group is safely in position
	end,
	---------------------------------------------	
	GROUP_SPLIT = function(self,entity,sender)
		-- team leader instructs group to split
	end,
	---------------------------------------------	
	PHASE_RED_ATTACK = function(self,entity,sender)
		-- team leader instructs red team to attack
	end,
	---------------------------------------------	
	PHASE_BLACK_ATTACK = function(self,entity,sender)
		-- team leader instructs black team to attack
	end,
	---------------------------------------------	
	GROUP_MERGE = function(self,entity,sender)
		-- team leader instructs groups to merge into a team again
	end,
	---------------------------------------------	
	CLOSE_IN_PHASE = function(self,entity,sender)
		-- team leader instructs groups to initiate part one of assault fire maneuver
	end,
	---------------------------------------------	
	ASSAULT_PHASE = function(self,entity,sender)
		-- team leader instructs groups to initiate part one of assault fire maneuver
	end,
	---------------------------------------------	
	GROUP_NEUTRALISED = function(self,entity,sender)
		-- team leader instructs groups to initiate part one of assault fire maneuver
	end,
}