--------------------------------------------------
--   Created By: Petar
--   Description: Cover goes into this behaviour when there is no more cover,so he holds his ground
--------------------------

AIBehaviour.CoverHold = {
	Name = "CoverHold",
	rs_y = 1,
	no_MG = 1,

	KEEP_FORMATION = function(self,entity,sender)
		if entity.sees==0 then
			entity:SelectPipe(0,"cover_hideform")
		end
	end,

	OnLeftLean = function(self,entity,sender)
		if not entity.RunToTrigger and entity.not_sees_timer_start==0 and entity.Properties.KEYFRAME_TABLE~="VALERIE" and not entity.cnt.reloading then
			AI:Signal(0,1,"WHEN_LEFT_LEAN_ENTER",entity.id)
		end
	end,

	OnRightLean = function(self,entity,sender)
		if not entity.RunToTrigger and entity.not_sees_timer_start==0 and entity.Properties.KEYFRAME_TABLE~="VALERIE" and not entity.cnt.reloading then
			AI:Signal(0,1,"WHEN_RIGHT_LEAN_ENTER",entity.id)
		end
	end,

	OnLowHideSpot = function(self,entity,sender)
		if not entity.RunToTrigger and entity.not_sees_timer_start==0 and entity.Properties.KEYFRAME_TABLE~="VALERIE" and not entity.cnt.reloading then
			AI:Signal(0,1,"DIG_IN_ATTACK",entity.id)
		end
	end,

	-- OnNoTarget = function(self,entity)
		-- AIBehaviour.DEFAULT:OnNoTarget(entity)
		-- -- local dist = AI:FindObjectOfType(entity:GetPos(),10,AIAnchor.HOLD_THIS_POSITION) -- Решить вопрос со всеми холдами.
		-- -- if (dist) then
			-- -- AI:Signal(0,1,"HOLD_POSITION",entity.id)
			-- -- entity:SelectPipe(0,"special_hold_position")
			-- -- entity:InsertSubpipe(0,"setup_stealth") 
			-- -- entity:InsertSubpipe(0,"just_shoot") -- dumb_shoot
		-- -- else
			-- -- local rnd = random(1,2)
			-- -- if rnd==1 then 
				-- -- entity:SelectPipe(0,"confirm_targetloss") -- За кем? Заменить!
				-- -- entity:InsertSubpipe(0,"do_it_running")
			-- -- else
				-- -- AI:Signal(0,1,"COVER_NORMALATTACK",entity.id) -- Кого атаковать? -- Без переключения. 
			-- -- end
			-- -- AI:Signal(0,1,"ATTACK",entity.id) -- Переключает.
		-- -- end
	-- end,

	OnNoTarget = function(self,entity) -- Используется для переключения в hold.
		AIBehaviour.DEFAULT:OnNoTarget(entity)
		entity:InsertSubpipe(0,"reload")
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		if entity:ShootOrNo() then return end
		if not fDistance then fDistance = entity:GetDistanceToTarget() end
		if not fDistance then fDistance = 0 NotContact=1 end
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if not NotContact then
			AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY_ON_ATTACK(entity)
			if (entity:GetGroupCount() > 1) then
				if random(1,2)==1 then
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN_GROUP",entity.id)
				else
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN",entity.id)
				end
			else
				AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN",entity.id)
			end
		end

		if entity:CheckEnemyWeaponDanger() then	return end

		if entity.critical_status and fDistance > 30 then
			entity:SelectPipe(0,"hide_on_critical_status")
			do return end 
		end

		local rnd = random(1,10)
		if (rnd < 2) then 
			NOCOVER:SelectAttack(entity) -- Ищет якоря "стоять" или "сидеть" в пределах 10 метров.
		else
			local holdpos = AI:FindObjectOfType(entity:GetPos(),fDistance/2,AIAnchor.HOLD_THIS_POSITION)
			if holdpos then
				AI:Signal(0,1,"HOLD_POSITION",entity.id) -- HoldPosition.
				entity:SelectPipe(0,"special_hold_position",holdpos) 
				if fDistance > 30 then -- Проверить.
					entity:InsertSubpipe(0,"setup_stand")
					entity:InsertSubpipe(0,"go_to_protect_spot")
				else
					entity:InsertSubpipe(0,"setup_stealth") -- Нужно ли?
				end
			else
				local rnd = random(1,2)
				if (rnd==1) then 
					entity:SelectPipe(0,"cover_hide_left")
				else
					entity:SelectPipe(0,"cover_hide_right")
				end
				local rnd1 = random(8,12)
				local rnd2 = random(45,55)
				if fDistance <= rnd1 and entity.cnt.crouching then
					entity:InsertSubpipe(0,"setup_stand")
					entity:InsertSubpipe(0,"just_shoot") -- dumb_shoot	
				elseif fDistance <= rnd2 and ((not entity.cnt.proning and not entity.cnt.crouching) or entity.cnt.proning) then
					entity:InsertSubpipe(0,"setup_crouch")
					entity:InsertSubpipe(0,"just_shoot") -- dumb_shoot	
				elseif (not entity.cnt.proning and not entity.cnt.crouching) or entity.cnt.proning then
					entity:InsertSubpipe(0,"setup_prone")
					entity:InsertSubpipe(0,"just_shoot")	
				end
			end		
		end
		-- entity:GrenadeAttack()
		entity.ThrowGrenadeOnTimer = {_time+random(1.5,5)}
	end,
	
	OnEnemySeen = function(self,entity)
		-- called when the enemy sees a foe which is not a living player
	end,
	---------------------------------------------
	OnFriendSeen = function(self,entity)
		-- called when the enemy sees a friendly target
	end,

	OnSomethingSeen = function(self,entity)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
	end,

	OnDeadBodySeen = function(self,entity,sender,fDistance)
		AIBehaviour.CoverAttack:OnDeadBodySeen(entity,sender,fDistance)
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if not fDistance then fDistance = 0 NotContact=1 end
		if entity.AI_OnDanger then do return end end
		if entity.critical_status and fDistance and fDistance > 30 then
			entity:SelectPipe(0,"hide_on_critical_status")
			do return end
		end
		entity:InsertSubpipe(0,"reload")
		if not NotContact then
			if (entity:GetGroupCount() > 1) then
				if random(1,2)==1 then
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN_GROUP",entity.id)
				else
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN",entity.id)
				end
			else
				AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN",entity.id)
			end
		end
		if entity.cnt.proning then
			entity:InsertSubpipe(0,"setup_crouch")
			entity:InsertSubpipe(0,"just_shoot") -- dumb_shoot	
		elseif entity.cnt.proning or entity.cnt.crouching then
			entity:InsertSubpipe(0,"delay_setup_stand")
		end
		entity:GrenadeAttack(5)
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity,fDistance)
		-- if (_localplayer.sspecies==entity.Properties.species) then
			-- entity:InsertSubpipe(0,"devalue_target")
			-- return
		-- end
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		AIBehaviour.CoverHold:OnPlayerSeen(entity,fDistance,1)
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity,fDistance) -- Добавить спешиал холд позишн.
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"NORMAL_THREAT_SOUND",entity.id)
		-- entity:RunToAlarm()
		AIBehaviour.CoverHold:OnPlayerSeen(entity,fDistance,1)
	end,

	OnClipNearlyEmpty = function(self,entity,sender)
		entity:SelectPipe(0,"cover_scramble_beacon")
		entity:InsertSubpipe(0,"just_shoot") -- dumb_shoot
	end,

	OnReload = function(self,entity)
		if not entity.cnt.proning and not entity.cnt.crouching then
			entity:InsertSubpipe(0,"setup_crouch")
		end
		-- entity:GrenadeAttack()
	end,

	OnNoHidingPlace = function(self,entity,sender) --
		NOCOVER:SelectAttack(entity) --Ищет якоря "стоять" или "сидеть" в пределах 10 метров.
		-- AI:Signal(0,1,"COVER_STRAFE",entity.id)
	end,
	--------------------------------------------------
	OnNoFormationPoint = function(self,entity,sender)
	end,
	--------------------------------------------------
	OnCoverRequested = function(self,entity,sender)
		-- called when the enemy is damaged
	end,
	
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

	OnSomethingDiedNearest_x = function(self,entity,sender)
	end,
	--------------------------------------------------
	-- CUSTOM SIGNALS
	--------------------------------------------------
	COVER_NORMALATTACK = function(self,entity,sender)
		entity:SelectPipe(0,"cover_pindown")
	end,
	---------------------------------------------
	HEADS_UP_GUYS = function(self,entity,sender)
		if entity.ForceSenderId then sender=System:GetEntity(entity.ForceSenderId) entity.ForceSenderId=nil end
		AIBehaviour.DEFAULT:AllWakeUp(entity)
		if entity.Properties.species==sender.Properties.species and entity~=sender
		and not entity.RunToTrigger and not entity.heads_up_guys and not entity.ai_flanking and entity.sees~=1 then
			if sender and sender.SenderId then
				if random(1,3)==1 then
					entity:InsertSubpipe(0,"acquire_beacon2",sender.id)
				end
				-- local SenderDistance = entity:GetDistanceFromPoint(sender:GetPos())
				-- if SenderDistance and SenderDistance > 10 then
					entity:InsertSubpipe(0,"DropBeaconAt",sender.SenderId)
				-- end
			end
			entity.heads_up_guys = 1 
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,10)
			AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY(entity)
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)
		end
	end,

	INCOMING_FIRE = function(self,entity,sender)
	end,

	ALARM_ON = function(self,entity,sender)
	end,

	ALERT_SIGNAL = function(self,entity,sender)
	end,
	
	LOOK_AT_BEACON = function(self,entity,sender)
	end,

	LOOK_FOR_TARGET = function(self,entity,sender)
		-- do nothing on this signal
		entity:InsertSubpipe(0,"look_around")
	end,	

	---------------------------------------------	
	PHASE_BLACK_ATTACK = function(self,entity,sender)
		-- team leader instructs black team to attack
		entity.Covering = nil 
		entity:SelectPipe(0,"black_cover_pindown")
	end,

	---------------------------------------------	
	PHASE_RED_ATTACK = function(self,entity,sender)
		-- team leader instructs red team to attack
		entity.Covering = nil 
		entity:SelectPipe(0,"red_cover_pindown")
	end,
	
	ALARM_ON = function(self,entity,sender)
	end,

	ALERT_SIGNAL = function(self,entity,sender)
	end,

}