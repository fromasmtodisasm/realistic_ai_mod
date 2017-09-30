--------------------------------------------------
--   Created By: Petar
--   Description: This is the combat behaviour of the Cover
--------------------------
--   modified by: sten 22-10-2002
--   modified amanda 02-11-19 moved roll animations to default.lua

AIBehaviour.CoverAttack = {
	Name = "CoverAttack",
	call_alarm_muted = 1,
	rs_y = 1,
	no_MG = 1,

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
		if not entity.RunToTrigger and entity.Properties.KEYFRAME_TABLE~="VALERIE" and not entity.cnt.reloading then
			-- AI:Signal(0,1,"DIG_IN_ATTACK",entity.id)
			if entity.sees==1 then
				entity:InsertSubpipe(0,"setup_crouch")
				entity:InsertSubpipe(0,"do_it_walking")
			else
				if entity.cnt.proning and not entity.cnt.crouching then
					entity:InsertSubpipe(0,"setup_crouch")
				elseif entity.cnt.crouching then
					entity:InsertSubpipe(0,"setup_stand")
				end
			end
		end
	end,

	OnNoTarget = function(self,entity) -- Используется для переключения в hold.
		AIBehaviour.DEFAULT:OnNoTarget(entity)
		-- if (entity:GetGroupCount() > 1) then
			-- AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_LOST,"ENEMY_TARGET_LOST_GROUP",entity.id)	-- Нужно отдельно послать сигнал окружающим, чтобы искали.
		-- end
		entity.ai_flanking = nil
		entity.ai_scramble = nil
		entity:InsertSubpipe(0,"reload")
		if entity:GetGroupLeader() then
			entity:SelectPipe(0,"cover_hideform")
		end
	end,
	---------------------------------------------
	OnPlayerSeen = function(self,entity,fDistance,NotContact) -- Добавить переключение в холд при найденном якоре.
		-- Сделать такую штуку: выбежать из-за укрытия, немного пострелять, и опять в укрытие. И чтобы выбегая сразу открывал огонь.
		if entity:ShootOrNo() then return end
		if not fDistance then fDistance = entity:GetDistanceToTarget() end
		if not fDistance then fDistance = 0 NotContact=1 end
		-- local Target=AI:GetAttentionTargetOf(entity.id)
		-- Hud:AddMessage(entity:GetName()..": sees "..Target:GetName())
		-- Hud:AddMessage(entity:GetName()..": bEnemyInCombat: "..entity.bEnemyInCombat)
		if not NotContact then
			AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY_ON_ATTACK(entity) -- А межет и для мемори нужен свой такой?
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
		-- AI:Signal(SIGNALFILTER_SPECIESONLY,1,"COVER_NORMALATTACK",entity.id) -- Должен сказать своим рядом идти в атаку. Или пусть прикрывают. Типа хеадс ап.

		if entity:CheckEnemyWeaponDanger() then	return end

		if entity.critical_status and fDistance > 30 then -- Оптимизировать.
			entity:SelectPipe(0,"hide_on_critical_status")
			do return end
		end

		-- if fDistance > 80 and entity.ai_flanking then entity.ai_flanking = nil end
		-- if entity.ai_flanking or (entity.ai_scramble and fDistance <= 30) then do return end end

		if entity.ai_flanking then --Чего-то так его щёлкает между cover_scramble и HIDE_LEFT_OR_RIGHT
			entity:SelectPipe(0,"cover_scramble")
			entity.ai_scramble = 1
			entity.ai_flanking = nil
			do return end
		end
		if entity.ai_scramble and fDistance <= 30 then do return end end

		if fDistance>30 then
			entity:RunToMountedWeapon() -- Так как он кроющий, то пусть и кроет чаще...
		end

		if (fDistance <= 30) then
			entity:SelectPipe(0,"cover_scramble")
			entity.ai_scramble = 1
		elseif (fDistance <= 60) then
			AI:Signal(0,1,"HIDE_LEFT_OR_RIGHT",entity.id) -- Для атаки доделать.
		else
			AI:Signal(0,1,"COVER_STRAFE",entity.id)
		end
		entity.ThrowGrenadeOnTimer = {_time+random(1.5,5),1}
		-- if not entity:GrenadeAttack() then
			-- if not AI:IsMoving(self.id) then
				-- AIBehaviour.DEFAULT:AI_SETUP_DOWN(entity)
			-- end
		-- end
		if not AI:IsMoving(self.id) then
			AIBehaviour.DEFAULT:AI_SETUP_DOWN(entity)
		end
	end,

	OnEnemySeen = function(self,entity)
		-- called when the enemy sees a foe which is not a living player
		Hud:AddMessage(entity:GetName()..": OnEnemySeen")
		System:Log(entity:GetName()..": OnEnemySeen")
	end,
	---------------------------------------------
	OnFriendSeen = function(self,entity)
		-- called when the enemy sees a friendly target
		Hud:AddMessage(entity:GetName()..": OnFriendSeen")
		System:Log(entity:GetName()..": OnFriendSeen")
	end,

	OnSomethingSeen = function(self,entity)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
	end,

	OnDeadBodySeen = function(self,entity,sender,fDistance)
		if entity.Properties.species==sender.Properties.species and fDistance<=10 and entity.sees~=1 then
			-- Hud:AddMessage(entity:GetName()..": CoverAttack/OnDeadBodySeen: "..sender:GetName()..", fDistance: "..fDistance)
			-- System:Log(entity:GetName()..": CoverAttack/OnDeadBodySeen:"..sender:GetName()..", fDistance: "..fDistance)
			entity:InsertSubpipe(0,"retreat_on_dead_body_seen",sender.id)
		end
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact) -- Сделать такую же штуку как и у OnNoTarget, только с переключением туда. -- Сделать больше вероятность того что будет преследовать цель. -- Возможно, если услышал опасный звук то вызывается эта функция и поэтому слишком часто бросает гранаты в пустоту (не бросает пока не видит цель).
		if not fDistance then fDistance = 0 NotContact=1 end
		entity.ai_scramble = nil
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if entity.ai_flanking or entity.AI_OnDanger then do return end end
		if entity.critical_status and fDistance > 30 then
			entity:SelectPipe(0,"hide_on_critical_status")
			do return end
		end
		entity:InsertSubpipe(0,"reload")
		if entity:RunToAlarm() then do return end end
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
		if not entity.ConfirmCounter then entity.ConfirmCounter = 0 end
		local ctr = entity.ConfirmCounter
		local rnd = random(1,6)
		if (fDistance <= 5) then -- Резко выбежать.
			if (rnd > 3 and ctr<=5) then
				entity:SelectPipe(0,"confirm_targetloss")
				entity:InsertSubpipe(0,"do_it_running")
				if random(1,2)==1 then
					entity:InsertSubpipe(0,"setup_stealth")
				else
					entity:InsertSubpipe(0,"setup_stand")
				end
				entity.ConfirmCounter = ctr+1
			else
				AI:Signal(0,1,"HIDE_TACTIC",entity.id)
				entity:GrenadeAttack(3)
			end
		else
			-- rnd так и оставить, чтобы атакующие пайпы иногда продолжали работу.
			if (rnd==1 and fDistance < 60) then -- Прятаться.
				entity:SelectPipe(0,"cover_camp")
				entity:GrenadeAttack(9)
			elseif rnd==2 or (rnd==3 and ctr>2) then -- Прятаться.
				AI:Signal(0,1,"HIDE_TACTIC",entity.id)
				entity:GrenadeAttack(6)
			-- elseif (rnd==3) then -- В атаку.
				-- AI:Signal(0,1,"COVER_NORMALATTACK",entity.id)
			-- elseif (rnd==4 and ctr<=2 and fDistance <= 30) then -- Аккуратно проверить.
			elseif (rnd==3 and ctr<=2 and fDistance <= 30) then -- Аккуратно проверить.
				entity:SelectPipe(0,"confirm_targetloss")
				local rnd = random(1,3)
				if rnd==1 or fDistance <= 15 then
					entity:InsertSubpipe(0,"setup_stand")
					entity:InsertSubpipe(0,"do_it_running")
				elseif rnd==2 then
					entity:InsertSubpipe(0,"setup_stand")
					entity:InsertSubpipe(0,"do_it_walking")
				elseif rnd==3 then
					entity:InsertSubpipe(0,"setup_stealth")
					entity:InsertSubpipe(0,"do_it_walking")
				end
				entity.ConfirmCounter = ctr+1
			elseif (rnd >= 4 and ctr>2 and fDistance > 30) then -- Преследовать.
				entity:SelectPipe(0,"confirm_targetloss")
				entity:InsertSubpipe(0,"setup_stand")
				entity:InsertSubpipe(0,"do_it_running")
				entity:InsertSubpipe(0,"not_shoot")
			end
		end
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity,fDistance)
		entity.ai_flanking = nil
		-- if (_localplayer.sspecies==entity.Properties.species) then
			-- entity:InsertSubpipe(0,"devalue_target")
			-- return
		-- end
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if entity.sees~=1 then
			self:OnEnemyMemory(entity,fDistance,1)
		end
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity,fDistance) -- Сделать проверку на "воду", чтобы не выполняли пайпы поиска,подходя к границе запретной зоны.
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if fDistance > 80 or fDistance < 30 then
			entity.ai_flanking = nil
		end
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"NORMAL_THREAT_SOUND",entity.id)
		if entity.sees~=1 then
			if entity:SearchAmmunition() then do return end end
		end
		if entity.sees~=1 then
			if fDistance > 60 then
				AI:Signal(0,1,"COVER_STRAFE",entity.id)
			else
				AIBehaviour.CoverAttack:OnPlayerSeen(entity,fDistance,1)  -- Сделать чтоб не бросал гранаты в пустоту.
			end
		end
	end,

	OnClipNearlyEmpty = function(self,entity,sender)
	end,

	OnReload = function(self,entity)
		if random(1,5)==1 then
			entity:GrenadeAttack(6)
		end
	end,

	OnNoHidingPlace = function(self,entity,sender)
		if entity.not_sees_timer_start==0 and entity.sees==2 and not entity.ai_flanking and not entity.ai_scramble and not entity.AI_OnDanger and
		not entity.critical_status then
			AI:CreateGoalPipe("strafe_left_or_right")
			AI:PushGoal("strafe_left_or_right","timeout",1,0,3)
			if random(1,2)==1 then
				AI:PushGoal("strafe_left_or_right","strafe",0,15)
			else
				AI:PushGoal("strafe_left_or_right","strafe",0,-15)
			end
			AI:PushGoal("strafe_left_or_right","timeout",1,1,5)
			AI:PushGoal("strafe_left_or_right","strafe",0,0)
			entity:InsertSubpipe(0,"strafe_left_or_right")
		end
	end,
	--------------------------------------------------
	OnNoFormationPoint = function(self,entity,sender)
	end,
	--------------------------------------------------
	OnCoverRequested = function(self,entity,sender)
		-- called when the enemy is damaged
	end,

	OnKnownDamage = function(self,entity,sender) -- Срабатывает когда ИИ видит или помнит того кто стрелял.
		-- local mytarget = AI:GetAttentionTargetOf(entity.id)
		-- if mytarget then
			-- if type(mytarget)=="table" and mytarget~=sender then
				entity:SelectPipe(0,"cover_scramble")
				entity:InsertSubpipe(0,"DropBeaconTarget",sender.id)
			-- end
		-- end
		entity:InsertSubpipe(0,"pause_shooting") -- Игроку надо сделать точно так же.
		entity:InsertSubpipe(0,"setup_crouch")
	end,

	OnReceivingDamage = function(self,entity,sender)
		entity:TriggerEvent(AIEVENT_CLEAR) -- Нужно?
		entity:SelectPipe(0,"cover_scramble")
		entity:InsertSubpipe(0,"pause_shooting")
		entity:InsertSubpipe(0,"setup_crouch")
	end,

	OnBulletRain = function(self,entity,sender) -- Почему-то прячется ближе к цели, смотрит куда бежит и опускает оружие. Где-то есть insert subpipe. -- Почему-то говорит фразочки как если бы по нему попали.
		if entity.id==sender.id then do return end end -- Помогает?
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity.ai_flanking = nil
		entity.ai_scramble = nil
		entity:SelectPipe(0,"cover_incoming_fire") -- Прячется, выжидает, а потом атакует.
		local rnd=random(1,5)
		if rnd==1 or entity.critical_status then
			if not entity.critical_status or (not entity.cnt.proning and entity.critical_status) then
				entity:InsertSubpipe(0,"setup_crouch")
			end
		elseif rnd==2 then
			entity:InsertSubpipe(0,"setup_stealth")
		end
		-- entity:InsertSubpipe("DropBeaconAt",sender.id) -- Проверка.
		entity:GrenadeAttack(3)
	end,

	OnSomethingDiedNearest = function(self,entity,sender) -- Должен забывать про труп.
		if entity.Properties.species==sender.Properties.species then
			-- entity:TriggerEvent(AIEVENT_DROPBEACON)
			-- local att_target = AI:GetAttentionTargetOf(self.id)
			-- if not entity:RunToAlarm() then
			if entity.sees~=1 then
				entity:InsertSubpipe(0,"LookAtTheBodyInAction",sender.id)
			end
				-- if att_target and type(att_target)=="table" then -- Снова посмотреть на последнюю цель.
					-- entity:InsertSubpipe("DropBeaconTarget",att_target)
				-- end
			-- end
		end
	end,

	OnSomethingDiedNearest_x = function(self,entity,sender)
	end,

	OnCloseContact = function(self,entity,sender,fDistance)
		-- local info
		if (entity.Properties.species~=sender.Properties.species) then
			entity.ai_flanking = nil
		-- AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN",entity.id)
			if not entity.MeleeAttack and not entity.MeleeAttack2 then
				-- Hud:AddMessage(entity:GetName()..": CoverAttack/OnCloseContact: "..sender:GetName())
				entity:InsertSubpipe(0,"retreat_on_close",sender.id)
				-- info = "reteat"
			end
		else
			entity:InsertSubpipe(0,"devalue_target",sender.id) -- Поменять на стрейф.
			-- info = "devalue"
		end
		-- Hud:AddMessage(entity:GetName()..": OnCloseContact: "..info)
		-- System:Log(entity:GetName()..": OnCloseContact: "..info)
	end,
	--------------------------------------------------
	-- CUSTOM SIGNALS
	--------------------------------------------------
	COVER_NORMALATTACK = function(self,entity,sender)
		entity:InsertSubpipe(0,"reload")
		-- if entity.critical_status then
			-- entity:SelectPipe(0,"hide_on_critical_status")
			-- do return end
		-- end
		entity:SelectPipe(0,"cover_pindown")
	end,

	COVER_CAMP = function(self,entity,sender)
		entity:SelectPipe(0,"cover_camp_x")
	end,

	COVER_STRAFE = function(self,entity,sender)
		AI:CreateGoalPipe("cover_strafe")
		AI:PushGoal("cover_strafe","just_shoot")
		AI:PushGoal("cover_strafe","locate",0,"beacon")
		AI:PushGoal("cover_strafe","acqtarget",1,"")
		if not entity.IsIndoor then
			if random(1,3) > 1 then
				AI:PushGoal("cover_strafe","approach",0,1)
			end
			local rnd = random(-15,15)
			if rnd > -3 and rnd < 0 then rnd = -3  end
			if rnd < 3 and rnd >=0 then rnd = 3  end
			AI:PushGoal("cover_strafe","strafe",0,rnd)
			AI:PushGoal("cover_strafe","timeout",1,2,5)
		else
			AI:PushGoal("cover_strafe","approach",0,1)
			AI:PushGoal("cover_strafe","trace",1,1,1)
		end
		AI:PushGoal("cover_strafe","locate",0,"hidepoint")
		AI:PushGoal("cover_strafe","acqtarget",0,"")
		AI:PushGoal("cover_strafe","timeout",1,0,.5)
		-- Hud:AddMessage(entity:GetName()..": COVER_STRAFE/strafe: "..rnd)
		-- System:Log(entity:GetName()..": COVER_STRAFE/strafe: "..rnd)
		AI:PushGoal("cover_strafe","signal",0,1,"CHECK_FOR_FIND_A_TARGET",0)
		local att_target = AI:GetAttentionTargetOf(entity.id)
		if not att_target then -- Чтоб не стоял на одном месте если при выборе цель была потеряна.
			-- Hud:AddMessage(entity:GetName()..": COVER_STRAFE/not att_target")
			-- System:Log(entity:GetName()..": COVER_STRAFE/not att_target")
			AI:PushGoal("cover_strafe","signal",0,1,"FIND_A_TARGET",0)
			-- AI:PushGoal("cover_strafe","signal",0,1,"HIDE_LEFT_OR_RIGHT",0)
		end
		entity:SelectPipe(0,"cover_strafe")
		if entity.cnt.crouching then
			if random(1,2)==1 then
				entity:InsertSubpipe(0,"do_it_walking")
			else
				entity:InsertSubpipe(0,"setup_stand")
				entity:InsertSubpipe(0,"do_it_running")
			end
		elseif not entity.cnt.proning then
			entity:InsertSubpipe(0,"setup_stand")
			entity:InsertSubpipe(0,"do_it_running")
		elseif entity.cnt.proning then
			entity:SelectPipe(0,"cover_scramble")
			entity:InsertSubpipe(0,"setup_crouch")
		end
	end,

	HIDE_LEFT_OR_RIGHT = function(self,entity,sender) -- Что-то слишком часто стал ходить на корточках. Сделать, чтобы провека условий выполнялась в реальном времени.
		-- Hud:AddMessage(entity:GetName()..": HIDE_LEFT_OR_RIGHT START")
		-- System:Log(entity:GetName()..": HIDE_LEFT_OR_RIGHT START")
		if entity.not_sees_timer_start==0 then -- Есть цель.
			entity.target_lost_muted = 1
		else
			entity.target_lost_muted = nil
		end
		entity.farhide = nil
		AI:CreateGoalPipe("cover_hide_left_or_right")
		AI:PushGoal("cover_hide_left_or_right","just_shoot")
		if entity.not_sees_timer_start~=0 then -- Нет цели.
			AI:PushGoal("cover_hide_left_or_right","timeout",1,.5,3)
		end
		-- AI:PushGoal("cover_hide_left_or_right","locate",0,"atttarget",entity.id) -- Когда последняя цель отсутствует(OnNoTarget), это приводит к критической ошибке!
		-- AI:PushGoal("cover_hide_left_or_right","acqtarget",0,"")
		AI:PushGoal("cover_hide_left_or_right","locate",0,"beacon")
		AI:PushGoal("cover_hide_left_or_right","acqtarget",1,"")
		local look
		if entity.not_sees_timer_start==0 then -- Есть цель.
			look = 1
			if not entity.farhide then
				-- Hud:AddMessage(entity:GetName()..": HIDE_LEFT_OR_RIGHT/HM_FARTHEST_FROM_TARGET")
				-- System:Log(entity:GetName()..": HIDE_LEFT_OR_RIGHT/HM_FARTHEST_FROM_TARGET")
				entity.farhide = 1
				AI:PushGoal("cover_hide_left_or_right","hide",1,30,HM_FARTHEST_FROM_TARGET,0)
			end
			AI:PushGoal("cover_hide_left_or_right","do_it_running")
			if entity.cnt.proning or entity.cnt.crouching then
				look = 0
			else
				AI:PushGoal("cover_hide_left_or_right","not_shoot")
			end
		else
			look = 0
		end
		if not entity.ai_flanking then
			entity.ai_flanking = random(1,2)
		end
		if entity.ai_flanking==1 then
			if random(1,2)==1 then
				AI:PushGoal("cover_hide_left_or_right","hide",1,60,HM_LEFTMOST_FROM_TARGET,look)
			else
				AI:PushGoal("cover_hide_left_or_right","hide",1,60,HM_LEFT_FROM_TARGET,look)
			end
		else
			if random(1,2)==1 then
				AI:PushGoal("cover_hide_left_or_right","hide",1,60,HM_RIGHTMOST_FROM_TARGET,look)
			else
				AI:PushGoal("cover_hide_left_or_right","hide",1,60,HM_RIGHT_FROM_TARGET,look)
			end
		end
		AI:PushGoal("cover_hide_left_or_right","just_shoot")
		if entity.not_sees_timer_start~=0 then -- Нет цели.
			AI:PushGoal("cover_hide_left_or_right","do_it_walking")
			AI:PushGoal("cover_hide_left_or_right","timeout",1,.5,1)
			AI:PushGoal("cover_hide_left_or_right","look_around")
			AI:PushGoal("cover_hide_left_or_right","timeout",1,0,3)
			AI:PushGoal("cover_hide_left_or_right","locate",0,"hidepoint")
			AI:PushGoal("cover_hide_left_or_right","acqtarget",0,"") -- Если HP нет - вылет
			AI:PushGoal("cover_hide_left_or_right","timeout",1,0,3)
		else
			if look==0 then
				-- Почему-то не стрейфит.
				AI:PushGoal("cover_hide_left_or_right","timeout",1,0,3)
				if entity.ai_flanking==1 then -- Проверить.
					AI:PushGoal("cover_strafe","strafe",0,15) -- Влево.
				else
					AI:PushGoal("cover_strafe","strafe",0,-15) -- Вправо.
				end
				AI:PushGoal("cover_strafe","timeout",1,2,5)
				AI:PushGoal("cover_strafe","strafe",0,0)
			end
			AI:PushGoal("cover_hide_left_or_right","locate",0,"hidepoint")
			AI:PushGoal("cover_hide_left_or_right","acqtarget",0,"")
			AI:PushGoal("cover_hide_left_or_right","timeout",1,0,.5)
		end
		-- Hud:AddMessage(entity:GetName()..": HIDE_LEFT_OR_RIGHT END")
		-- System:Log(entity:GetName()..": HIDE_LEFT_OR_RIGHT END")
		AI:PushGoal("cover_hide_left_or_right","signal",0,1,"CHECK_FOR_FIND_A_TARGET",0)
		entity:SelectPipe(0,"cover_hide_left_or_right")
	end,

	HIDE_TACTIC = function(self,entity,sender)
		entity:SelectPipe(0,"cover_hide_tactic")
	end,

	AISF_GoOn = function(self,entity,sender)
		entity:SelectPipe(0,"cover_scramble")
	end,

	HEADS_UP_GUYS = function(self,entity,sender) -- Доделать наконец "Обрати внимание, сделано в Германии"!
		if entity.ForceSenderId then sender=System:GetEntity(entity.ForceSenderId) entity.ForceSenderId=nil end
		AIBehaviour.DEFAULT:AllWakeUp(entity)
		if entity.Properties.species==sender.Properties.species and entity~=sender
		and not entity.RunToTrigger and not entity.heads_up_guys and not entity.ai_flanking and entity.sees~=1 then -- and not entity.AI_OnDanger не нужен, потому что другой враг может быть совсем рядом.
			if not entity.rs_x then	entity.rs_x = 1	end
			entity:SelectPipe(0,"cover_beacon_pindown")
			if sender and sender.SenderId then
				if random(1,3)==1 then
					entity:InsertSubpipe(0,"acquire_beacon2",sender.id) -- Сначала смотрим на отправителя.
				end
				entity:SelectPipe(0,"check_beacon") -- Почему-то после броска гранаты всё-равно была эта пайпа.
				entity:InsertSubpipe(0,"DropBeaconAt",sender.SenderId)
				local SenderDistance = entity:GetDistanceFromPoint(sender:GetPos())
				if SenderDistance and SenderDistance > 30 then -- Чтобы лишний раз к отправителю не бегал.
					entity:InsertSubpipe(0,"go_to_sender",sender.id) -- При приблежении сделать чтобы он не спихивал последнего.
				end
			end
			entity.heads_up_guys = 1
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,10)
			AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY(entity) -- А вот отправку этого в обход условию можно было бы сделать...
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)
		end
	end,

	INCOMING_FIRE = function(self,entity,sender)
		-- do nothing on this signal
	end,

	ALARM_ON = function(self,entity,sender)
	end,

	ALERT_SIGNAL = function(self,entity,sender)
	end,

	LOOK_AT_BEACON = function(self,entity,sender) -- Переключения нет,но использование остаётся...
	end,
	--------------------------------------------------
	-- GROUP SIGNALS
	--------------------------------------------------
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