--------------------------------------------------
--   Created By: petar
--   Description: the idle behaviour for the cover
--------------------------
--   modified by: sten 23-10-2002
AIBehaviour.CoverIdle = {
	Name = "CoverIdle",

	OnSpawn = function(self,entity)
		-- Вызывается,когда враг появляется или перезагружается.
	end,

	OnActivate = function(self,entity) -- Сделать по активации тревожное состояние. Не забыть про бег.
		-- called when enemy receives an activate event (from a trigger,for example)
	end,

	OnNoTarget = function(self,entity) -- Не убирать!
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact) -- После плавания вечно 	AI:Signal(0,1,"SAY_FIRST_HOSTILE_CONTACT",entity.id)
		entity:TriggerEvent(AIEVENT_DROPBEACON) -- Оставить маяк.
		if not fDistance then fDistance = entity:GetDistanceToTarget() end
		if not fDistance then fDistance = 0 NotContact=1 end
		if not NotContact then
			AI:Signal(0,1,"SAY_FIRST_HOSTILE_CONTACT",entity.id)
		end
		entity:MakeAlerted()
		if not entity:RunToAlarm() then
			if (fDistance > 30) then
				AI:Signal(0,1,"COVER_NORMALATTACK",entity.id)
			else
				entity:SelectPipe(0,"cover_scramble")
			end
			if not entity.cnt.proning and not entity.cnt.crouching then
				entity:InsertSubpipe(0,"setup_stand") -- Специально, потому что может быть поза "скрытно".
			end
		end
	end,

	OnEnemySeen = function(self,entity)
		Hud:AddMessage(entity:GetName()..": OnEnemySeen")
		System:Log(entity:GetName()..": OnEnemySeen")
	end,

	---------------------------------------------
	OnFriendSeen = function(self,entity)
		-- called when the enemy sees a friendly target
		Hud:AddMessage(entity:GetName()..": OnFriendSeen")
		System:Log(entity:GetName()..": OnFriendSeen")
	end,

	OnSomethingSeen = function(self,entity) -- Постоянно вызывается пока видит игрока.
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		-- -- Нужна общая переменная,сообщающая о том,что бой уже был или враг уже был замечен.
		-- if entity.ThreatenStatus7 then -- Если вернулся в IDLE,то при вызове сразу атаковать.
			-- Hud:AddMessage(entity:GetName()..": OnPlayerSeen")
			-- -- entity.EventToCall = "OnPlayerSeen"
			-- AI:Signal(0,1,"OnPlayerSeen",entity.id)
		-- end
		-- -- entity.ThreatenStatus7 = 1
		if (entity:GetGroupCount() > 1) then
			AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_ALERT_SEEN_GROUP",entity.id)
		else
			AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_ALERT_SEEN",entity.id)
		end
		entity:SelectPipe(0,"cover_look_closer")
		entity:InsertSubpipe(0,"setup_stealth")
		entity:InsertSubpipe(0,"DRAW_GUN") -- Нельзя ставить MakeAlerted или GunOut,иначе начинается многоголосие.
		entity:ChangeAIParameter(AIPARAM_COMMRANGE,15)
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"LOOK_AT_BEACON",entity.id) -- Сигнал также принимает тот,кто его отправил. -- CoverInterested
		entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)
		-- Hud:AddMessage(entity:GetName()..": OnSomethingSeen")
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity,fDistance) -- Снова перестали слышать гранаты.
		-- if (_localplayer.sspecies==entity.Properties.species) then
			-- entity:InsertSubpipe(0,"devalue_target")
			-- return
		-- end

		-- if (_localplayer.sspecies==entity.Properties.species) then
		-- -- local send1 = sender.cnt
		-- -- Hud:AddMessage(entity:GetName().." "..sender)
		-- -- if (send1.Properties.species==entity.Properties.species) then
			-- entity:InsertSubpipe(0,"devalue_target")
			-- return
		-- end
		-- Hud:AddMessage(entity:GetName()..": _localplayer.sspecies: ".._localplayer.sspecies)

		if not entity.ThreatenStatus then
			entity.ThreatenStatus = 1
			entity:InsertSubpipe(0,"cover_lookat")
			-- Hud:AddMessage(entity:GetName()..": CoverIdle/OnInterestingSoundHeard/ThreatenStatus = nil")
		else
			entity:TriggerEvent(AIEVENT_DROPBEACON)
			entity:GunOut()
			if (entity:GetGroupCount() > 1) then
				AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_ALERT_HEARD_GROUP",entity.id)
			else
				AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_ALERT_HEARD",entity.id)
			end
			entity:SelectPipe(0,"cover_look_closer")
			entity:InsertSubpipe(0,"setup_stealth")
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,15)
			AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"LOOK_AT_BEACON",entity.id) -- CoverInterested
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)
			-- Hud:AddMessage(entity:GetName()..": CoverIdle/OnInterestingSoundHeard/ThreatenStatus = 1")
			-- AI:Signal(0,1,"INTERESTED",entity.id)
			-- Hud:AddMessage(entity:GetName()..": CoverIdle/OnInterestingSoundHeard/ThreatenStatus")
			-- System:Log(entity:GetName()..": Cover INTERESTED")
		end
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity,fDistance) -- Что то здесь делает так, что когда чел без пушки, он бежит с анимацией рук как мне надо - без пушки.
		-- Hud:AddMessage(entity:GetName()..": CoverIdle/OnThreateningSoundHeard")
		entity:MakeAlerted()
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:GunOut()
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"NORMAL_THREAT_SOUND",entity.id) -- Cообщить себе и не осведомлённым друзьям об угрожающем звуке.
		if (entity:GetGroupCount() > 1) then
			AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_THREATENED_GROUP",entity.id)
		else
			AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_THREATENED",entity.id)
		end
		local weapon = entity.cnt.weapon
		local FireModeType
		if entity.fireparams then
			FireModeType = entity.fireparams.fire_mode_type
		end
		if fDistance > 60 and weapon and weapon.name~="Falcon" and FireModeType and FireModeType~=FireMode_Melee and random(1,3)==1 and not entity.IsIndoor then -- Это со стороны выглядит глупо, с пистолетом в руках выполнять эту анимацию.
			AI:Signal(0,1,"DO_THREATENED_ANIMATION",entity.id)
		end
		local holdpos = AI:FindObjectOfType(entity:GetPos(),fDistance/2,AIAnchor.HOLD_THIS_POSITION)
		if holdpos then
			AI:Signal(0,1,"HOLD_POSITION",entity.id)
			entity:SelectPipe(0,"special_hold_position",holdpos)
			if fDistance > 30 then
				entity:InsertSubpipe(0,"setup_stand")
				entity:InsertSubpipe(0,"go_to_protect_spot")
			else
				entity:InsertSubpipe(0,"setup_stealth")
			end
		else
			-- local timeout = fDistance*chance  -- Слишком мало или слишком долго.
			local timeout = 60  -- 12
			AI:CreateGoalPipe("cover_hide_wait_attack") -- Почему-то самый ближний из трёх просто стоит на месте, а вот остальные прячутся правильно.
			AI:PushGoal("cover_hide_wait_attack","just_shoot")
			AI:PushGoal("cover_hide_wait_attack","setup_crouch")
			AI:PushGoal("cover_hide_wait_attack","lookat",1,-90,90)
			AI:PushGoal("cover_hide_wait_attack","timeout",1,.5,2)
			AI:PushGoal("cover_hide_wait_attack","setup_stand")
			AI:PushGoal("cover_hide_wait_attack","do_it_running")
			AI:PushGoal("cover_hide_wait_attack","hide",1,30,HM_NEAREST,0)
			AI:PushGoal("cover_hide_wait_attack","not_shoot")
			-- AI:PushGoal("cover_hide_wait_attack","hide",1,80,HM_NEAREST_TO_LASTOPRESULT,1)
			AI:PushGoal("cover_hide_wait_attack","hide",1,30,HM_FARHREST,0)
			AI:PushGoal("cover_hide_wait_attack","hide",1,60,HM_FARHREST_TO_TARGET,1)
			AI:PushGoal("cover_hide_wait_attack","locate",0,"beacon")
			AI:PushGoal("cover_hide_wait_attack","acqtarget",0,"")
			AI:PushGoal("cover_hide_wait_attack","hide",1,10,HM_NEAREST,0)
			AI:PushGoal("cover_hide_wait_attack","timeout",1,0,timeout) -- Сделать чтобы смотрел по сторонам.
			AI:PushGoal("cover_hide_wait_attack","hide",1,60,HM_NEAREST_TO_TARGET,1)
			AI:PushGoal("cover_hide_wait_attack","do_it_walking")
			AI:PushGoal("cover_hide_wait_attack","signal",0,1,"COVER_NORMALATTACK")
			if (fDistance > 30) then
				local rnd = random(1,20)
				if (fDistance > 60) then
					entity:SelectPipe(0,"cover_hide_wait_attack") -- Создать пайпу -- Сделать что-то типа "примерно знает где цель", то есть подкрадывается прячась, а потом, кода почти подошёл забывает и просто ищет.
					entity:InsertSubpipe(0,"take_cover3")
				else
					if (rnd > 17) then
						entity:SelectPipe(0,"look_at_beacon3")
						entity:InsertSubpipe(0,"cover_hide")
					elseif (rnd > 14) then
						entity:SelectPipe(0,"advanced_lookingaround")
						entity:InsertSubpipe(0,"just_shoot")
						entity:InsertSubpipe(0,"setup_stand")
					else
						entity:SelectPipe(0,"cover_hide_wait_attack")
						entity:InsertSubpipe(0,"take_cover3")
					end
				end
			else
				entity:SelectPipe(0,"cover_hide_wait_attack")
			end
		end
	end,

	OnClipNearlyEmpty = function(self,entity,sender)
	end,

	OnReload = function(self,entity)
	end,

	OnNoHidingPlace = function(self,entity,sender)
	end,

	OnNoFormationPoint = function(self,entity,sender) -- Работает.
		-- Hud:AddMessage(entity:GetName()..": OnNoFormationPoint")
		-- System:Log(entity:GetName()..": OnNoFormationPoint")
	end,

	OnKnownDamage = function(self,entity,sender) -- Всё таки такое бывает. Очень редко, но бывает. Например, когда персонаж садится в машину и остаётся спокойное состояние.
		entity:MakeAlerted() -- Нужно?
		-- Hud:AddMessage(entity:GetName()..": CoverIdle/OnKnownDamage")
		-- System:Log(entity:GetName()..": CoverIdle/OnKnownDamage")
		entity:SelectPipe(0,"cover_scramble")
		-- entity:InsertSubpipe(0,"DropBeaconTarget",sender.id)
		entity:InsertSubpipe(0,"scared_shoot",sender.id)
	end,

	OnReceivingDamage = function(self,entity,sender) -- Исправить: Из-за чего-то сразу переключается в cover_investigate_threat, так и не спрятавшись.
		AIBehaviour.DEFAULT:OnReceivingDamage(entity,sender)
	end,

	OnBulletRain = function(self,entity,sender)
		AIBehaviour.DEFAULT:OnBulletRain(entity,sender)
		entity:GrenadeAttack(3)
	end,

	OnSomethingDiedNearest = function(self,entity,sender)
		entity:MakeAlerted()
		if not entity.rs_x then
			AIBehaviour.DEFAULT:OnSomethingDiedNearest(entity,sender)
		else
			if entity.Properties.species==sender.Properties.species then
				entity:InsertSubpipe("DropBeaconAt",sender.id)
				if not entity:RunToAlarm() then
					entity:SelectPipe(0,"TeamMemberDied")
					entity:GrenadeAttack(6)
				end
			end
		end
	end,

	OnCloseContact = function(self,entity,sender) -- ЭЙ!
		-- Hud:AddMessage(entity:GetName()..": CoverIdle/OnCloseContact")
		if (entity.Properties.species~=sender.Properties.species) then
			entity:InsertSubpipe(0,"DropBeaconTarget",sender.id)
		end
	end,
	--------------------------------------------------
	-- CUSTOM SIGNALS
	--------------------------------------------------

	COVER_NORMALATTACK = function(self,entity,sender)
		entity:SelectPipe(0,"cover_pindown")
	end,

	--------------------------------------------------
	COVER_RELAX = function(self,entity,sender)
		Hud:AddMessage(entity:GetName()..": CoverIdle/COVER_RELAX")
		entity:SelectPipe(0,"standingthere")
		entity:InsertSubpipe(0,"just_shoot")
	end,
	--------------------------------------------------
	AISF_GoOn = function(self,entity,sender)
		Hud:AddMessage(entity:GetName()..": CoverIdle/AISF_GoOn")
		entity:SelectPipe(0,"standingthere")
		entity:InsertSubpipe(0,"just_shoot")
	end,

	INVESTIGATE_TARGET = function(self,entity,sender)
		entity:SelectPipe(0,"cover_investigate_threat")
	end,

	-- INTERESTED = function(self,entity,sender)
		-- AIBehaviour.CoverInterested:OnInterestingSoundHeard(entity)
	-- end,

	---------------------------------------------
	-- GROUP SIGNALS
	--------------------------------------------------

	OnCoverRequested = function(self,entity,sender) -- Групповой сигнал,посылаемый из пайпы request_cover!
		-- Hud:AddMessage(entity:GetName()..": OnCoverRequested")
		-- System:Log(entity:GetName()..": OnCoverRequested")
	end,
	-- Что-то с задержкой сигнал передаётся некоторым, стоящим рядом. Проверить на группе.
	HEADS_UP_GUYS = function(self,entity,sender) -- Сделать чтоб пушку после небольшой задержки доставал если сигнал пришёл от друзей. Из других состояний нужно чтобы сначала посмотрел на сигнализирующего, а потом уже на цель. Увеличит дальность посыла.
		if entity.ForceSenderId then sender=System:GetEntity(entity.ForceSenderId) entity.ForceSenderId=nil end
		AIBehaviour.DEFAULT:AllWakeUp(entity)
		if entity.Properties.species==sender.Properties.species then -- Вполне возможно сделать что будет делать тоже самое, только на сигна от врагов.
			entity:MakeAlerted()
			entity:InsertSubpipe(0,"setup_stand") -- А то иногда проскакивает.
			if not entity.RunToTrigger then
				-- if entity.id==sender.id then
					-- System:Log(entity:GetName()..": HEADS_UP_GUYS/entity.id==sender.id, entity.id: "..entity.id)
				-- end
				-- if entity.id~=sender.id then
					-- System:Log(entity:GetName()..": HEADS_UP_GUYS/entity.id~=sender.id, entity.id: "..entity.id..", sender.id: "..sender.id)
				-- end
				if entity.id~=sender.id then -- Иногда сразу получает тот-же сигнал от другого лица, поэтому пайпы перекрываются..
					-- entity:SelectPipe(0,"cover_beacon_pindown")
					-- entity:InsertSubpipe(0,"go_to_sender",sender.id) -- Потестить и добавить проверку на расстояние. Если расстояние до друга > commrange*2 тогда да, до друга бежать.
					-- if sender.SenderId then
						-- entity:SelectPipe(0,"check_beacon")
						-- entity:InsertSubpipe(0,"DropBeaconAt",sender.SenderId)
					-- end
					-- entity:GettingAlerted()
					entity:SelectPipe(0,"cover_beacon_pindown")
					-- entity:InsertSubpipe(0,"acquire_beacon_timedelay")
					-- entity:InsertSubpipe(0,"getting_alerted")
					-- entity:InsertSubpipe(0,"heads_up_delay",sender.id)
					-- entity:InsertSubpipe(0,"acquire_beacon2",sender.id) -- Сначала смотрим на отправителя
					entity:InsertSubpipe(0,"go_to_sender",sender.id) -- Потестить и добавить проверку на расстояние. Если расстояние до друга > commrange*2 тогда да, до друга бежать.
					if sender.SenderId then
						entity:SelectPipe(0,"check_beacon")
						entity:InsertSubpipe(0,"DropBeaconAt",sender.SenderId)
					end
					entity:GettingAlerted()
				end
			end
		end
	end,

	KEEP_FORMATION = function(self,entity,sender)
		entity:Readibility("ORDER_RECEIVED",1)
		entity:SelectPipe(0,"cover_hideform")
		entity:InsertSubpipe(0,"acquire_beacon")
		entity:MakeAlerted()
	end,
	---------------------------------------------
	MOVE_IN_FORMATION = function(self,entity,sender)
		-- the team leader wants everyone to move in formation
		entity:Readibility("ORDER_RECEIVED",1)
		entity:SelectPipe(0,"MoveFormation")
	end,
	---------------------------------------------
	THREAT_TOO_CLOSE = function(self,entity,sender) -- Угроза близко, проверить.
		-- the team can split
		entity:MakeAlerted()
		entity:SelectPipe(0,"cover_investigate_threat")
		entity:InsertSubpipe(0,"do_it_running")
		-- entity:InsertSubpipe(0,"cover_threatened")
		-- Hud:AddMessage(entity:GetName()..": THREAT_TOO_CLOSE")
		System:Log(entity:GetName()..": THREAT_TOO_CLOSE")
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

	RETURN_TO_FIRST = function(self,entity,sender)
		-- При повторном контакте везде должны снова говорить что заметили игрока.
		entity.ThreatenStatus = 1
		entity.ThreatenStatus2 = 1
		entity.ThreatenStatus3 = 1
		entity.ThreatenStatus4 = 1  -- 2
		entity.ConfirmCounter = nil
		entity.NotReturnToIdleSay = nil
		entity.no_MG = nil
		entity.THREAT_SOUND_SIGNAL_SENT = nil
		entity.FirstState=1
		entity.EventToCall = "OnSpawn" -- А это срабатывает здесь?
	end,
}