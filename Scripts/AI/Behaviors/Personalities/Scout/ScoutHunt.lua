--------------------------------------------------
--    Created By: Petar
--   Description: the scout is hunting the poor bastard
--------------------------
--

-- Добавить больше возможностей по обходу игрока.
AIBehaviour.ScoutHunt = {
	Name = "ScoutHunt",
	target_lost_muted = 1,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		if not fDistance then fDistance = entity:GetDistanceToTarget() end
		if not fDistance then fDistance = 0 NotContact=1 end
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		-- Сделать чтобы звучало когда ещё ни разу не было контакта.
		if not entity.WasInCombat and not NotContact then -- Это уж совсем на один раз.
			AI:Signal(0,1,"SAY_FIRST_HOSTILE_CONTACT",entity.id)
		end
		entity:MakeAlerted()

		if not entity:RunToAlarm() then
			if (entity:GetGroupCount() > 1) then
				if (fDistance<30) then
					entity:SelectPipe(0,"scout_tooclose_attack_beacon")
				else
					entity:SelectPipe(0,"scout_scramble_beacon")
				end
			else
				if (fDistance<15) then
					entity:SelectPipe(0,"scout_tooclose_attack")
				else
					entity:SelectPipe(0,"scout_scramble")
				end
			end
		end
	end,

	OnSomethingSeen = function(self,entity)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity,fDistance)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if not entity.ThreatenStatus4 then
			entity.ThreatenStatus4 = 1 	
		else
			if not entity.sound111 then -- Временно.
				entity.sound111 = 1 
				if (entity:GetGroupCount() > 1) then
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_ALERT_HEARD_GROUP",entity.id)
				else
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_ALERT_HEARD",entity.id)
				end
			end
			if fDistance > 15 and entity:GetGroupCount() > 1 then
				entity:SelectPipe(0,"scout_group_hunt")
			elseif fDistance > 15 then
				entity:SelectPipe(0,"scout_hunt_beacon")
			else
				entity:SelectPipe(0,"scout_hide")
			end
		end
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity,fDistance)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"NORMAL_THREAT_SOUND",entity.id)
		if not entity.ThreatenStatus5 then
			entity.ThreatenStatus5 = 1 	
		else
			if (fDistance > 30) then
				local rnd = random(1,10)
				if (rnd > 5) then 
					entity:SelectPipe(0,"look_at_beacon5")
					entity:InsertSubpipe(0,"scout_hide")
				else
					entity:SelectPipe(0,"scout_threatening_sound")
				end
			else
				if (fDistance <= 30) then
					entity:SelectPipe(0,"scout_approach")
				else
					entity:SelectPipe(0,"scout_hunt_beacon")
				end
			end
		end
	end,
	---------------------------------------------
	OnClipNearlyEmpty = function(self,entity,sender)
	end,

	OnReload = function(self,entity)
	end,

	---------------------------------------------
	OnNoHidingPlace = function(self,entity,sender)
		-- called when no hiding place can be found with the specified parameters
	end,	
	---------------------------------------------
	OnKnownDamage = function(self,entity,sender)
		AIBehaviour.CoverAttack:OnKnownDamage(entity,sender)
	end,

	OnReceivingDamage = function(self,entity,sender)
		AIBehaviour.CoverAttack:OnReceivingDamage(entity,sender)
	end,
	
	OnBulletRain = function(self,entity,sender)
		AIBehaviour.CoverAttack:OnBulletRain(entity,sender)
	end,

	OnSomethingDiedNearest = function(self,entity,sender)
		AIBehaviour.CoverAttack:OnSomethingDiedNearest(entity,sender)
	end,

	KEEP_ALERTED = function(self,entity,sender)
		-- called when the enemy is damaged
	end,

	ATTACK_ENEMY = function(self,entity,sender) -- scout_approach
		entity:InsertSubpipe(0,"scout_attack")
	end,

	SCOUT_HIDE_LEFT_OR_RIGHT = function(self,entity,sender)
		-- called when the enemy is damaged
		local rnd = random(1,2)
		if (rnd==1) then
			--System:Log("scout_hide_left")
			entity:InsertSubpipe(0,"scout_hide_left") --нет таких пайп
		else
			--System:Log("scout_hide_right")
			entity:InsertSubpipe(0,"scout_hide_right")
		end
	end,

	SCOUT_GOTO_ALERT = function(self,entity,sender)
		-- called when have no more cover between AI and target after hunt
		--entity:SelectPipe(0,"standingthere")
		entity:InsertSubpipe(0,"scout_hide_left")
	end,


	-- GROUP SIGNALS
	INCOMING_FIRE = function(self,entity,sender)
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
	IN_POSITION = function(self,entity,sender)
		-- some member of the group is safely in position
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

}