AIBehaviour.SpecOpsManIdle = {
	Name = "SpecOpsManIdle",
	-- ОП-ПА! А отдельные модельки-то оказывется не нужны! И как теперь автоматически определять специальных челов?
	OnLeftLean = function(self,entity,sender)
		if not entity.RunToTrigger and entity.not_sees_timer_start==0 and entity.IsSpecOpsMan~="Den" and not entity.cnt.reloading then
			AI:Signal(0,1,"WHEN_LEFT_LEAN_ENTER",entity.id)
		end
	end,

	OnRightLean = function(self,entity,sender)
		if not entity.RunToTrigger and entity.not_sees_timer_start==0 and entity.IsSpecOpsMan~="Den" and not entity.cnt.reloading then
			AI:Signal(0,1,"WHEN_RIGHT_LEAN_ENTER",entity.id)
		end
	end,

	OnLowHideSpot = function(self,entity,sender)
		if entity.sees==1 then
			entity:InsertSubpipe(0,"setup_crouch")
			entity:InsertSubpipe(0,"do_it_walking")
		elseif entity.IsSpecOpsMan=="Den" then
			AIBehaviour.DEFAULT:AI_SETUP_UP(entity)
		end
	end,

	OnNoTarget = function(self,entity)
		AIBehaviour.DEFAULT:OnNoTarget(entity)
		entity.ai_flanking = nil 
		entity.ai_scramble = nil 
		entity.ConfirmCounter = nil 
		entity:InsertSubpipe(0,"reload")
		AIBehaviour.DEFAULT:AI_SETUP_UP(entity)
	end,

	OnSpawn = function(self,entity) -- Снова не пашет, по крайней мере при начале игры. -- MountedGuy.lua RETURN_TO_NORMAL
		-- Hud:AddMessage(entity:GetName()..": OnSpawn")
		-- System:Log(entity:GetName()..": OnSpawn")
		-- entity:MakeAlerted()
		-- entity.IsSpecOpsMan="Lock"
		-- if entity.Properties.fileModel=="Objects\\characters\\SpecOps\\Den\\merc_sniper.cgf" then
			-- entity.IsSpecOpsMan="Den"
		-- elseif entity.Properties.fileModel=="Objects\\characters\\SpecOps\\Dooch\\merc_offcomm.cgf" then
			-- entity.IsSpecOpsMan="Dooch"
		-- elseif entity.Properties.fileModel=="Objects\\characters\\SpecOps\\Lock\\merc_cover.cgf" then
			-- entity.IsSpecOpsMan="Lock"
		-- end
		-- entity:SelectPipe(0,"not_shoot") -- Можно сделать что-нибудь другое.
		AI:Signal(0,1,"FIND_A_TARGET",entity.id)
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		entity:MakeAlerted()
		local att_target = AI:GetAttentionTargetOf(entity.id)
		if att_target and type(att_target)=="table" then
			if att_target==_localplayer then
				entity:InsertSubpipe(0,"not_shoot")
				entity:TriggerEvent(AIEVENT_CLEAR) -- Чтобы не было стрельбы в игрока при использовании acqtarget.
				return
			else
				entity:InsertSubpipe(0,"just_shoot")
			end
		end
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if not fDistance then fDistance = entity:GetDistanceToTarget() end
		if not fDistance then fDistance = 0 NotContact=1 end
		if not NotContact then
			AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY_ON_ATTACK(entity)
			if not entity.SayFirstContact then
				AI:Signal(0,1,"SAY_FIRST_HOSTILE_CONTACT",entity.id)
				entity.SayFirstContact=1
			else
				if (entity:GetGroupCount() > 1) then
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN_GROUP",entity.id)
				else
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN",entity.id)
				end
			end
		end
		AI:Signal(0,1,"FORCE_RESPONSIVENESS_CLEAR",entity.id)
		if not entity.cnt.proning and not entity.cnt.crouching then -- entity.cnt.standing - не существует.
			entity:InsertSubpipe(0,"setup_stand")
			-- Hud:AddMessage(entity:GetName()..": setup_stand")
		end
		-- if random(1,10)<=3 then
			if entity:RunToMountedWeapon() then return end
		-- end
		if entity:CheckEnemyWeaponDanger() then	return end
		if entity.critical_status and fDistance > 15 then
			entity:SelectPipe(0,"hide_on_critical_status")
			do return end
		end
		if fDistance > 80 and entity.ai_flanking then entity.ai_flanking = nil  end
		if entity.ai_flanking or (entity.ai_scramble and fDistance <= 30) then do return end end

		if (fDistance <= 30) then
			entity:SelectPipe(0,"SpecOps_scramble")
			entity.ai_scramble = 1 
			if entity.IsSpecOpsMan=="Den" then
				AIBehaviour.DEFAULT:AI_SETUP_DOWN(entity)
			end
		elseif (fDistance <= 80) then
			AI:Signal(0,1,"HIDE_LEFT_OR_RIGHT",entity.id)
		else
			AI:Signal(0,1,"COVER_STRAFE",entity.id)
			if random(1,10)==1 and entity.IsSpecOpsMan=="Den" then
				AIBehaviour.DEFAULT:AI_SETUP_DOWN(entity)
			end
		end
		if random(1,5)==1 and entity.IsSpecOpsMan=="Lock" then
			entity:InsertSubpipe(0,"setup_crouch")
		end
		if random(1,10)==1 and entity.IsSpecOpsMan=="Den" then -- Это Ден, интеллигентный циник. Никогда не снимает очки, потому что бережёт глаза. Любит природу и открытые пространства. Снайпер.
			entity:GrenadeAttack(9)
		elseif random(1,10)==1 and entity.IsSpecOpsMan=="Lock" then -- Это Лок. Ему всё равно куда и чем стрелять, потому что он это наверняка убьёт. В принципе, очень весёлый и добрый человек.
			entity:GrenadeAttack(8)
		elseif entity.IsSpecOpsMan=="Dooch" then -- Это Дуч, славный малый. Паталогически обожает взрывы. Кажется, у него даже под подушкой всегда лежит граната. Просто, на всякий случай.
			entity:GrenadeAttack() -- Может сделать гранаты бесконечными ему? Сделал! Гранатки теперь у них у всех бесконечные!
		end
		-- А это я, меня зовут Мерк и я начальник этого стада. На вашем месте, я бы никогда, слышите, НИКОГДА не разговаривал бы с моими людьми таким тоном.
		-- Мы самое грубое и беспринципное подразделение спецназа - "Бычий череп".
		-- Если у вас проблемы, обращайтесь к друзьям.
		-- Если у вас неприятности, обращайтесь к полиции.
		-- К нам не обращайтесь. Мы сами придём.
	end,

	OnEnemySeen = function(self,entity)
		-- called when the enemy sees a foe which is not a living player
		Hud:AddMessage(entity:GetName()..": OnEnemySeen")
		System:Log(entity:GetName()..": OnEnemySeen")
	end,

	OnFriendSeen = function(self,entity)
		-- called when the enemy sees a friendly target
		Hud:AddMessage(entity:GetName()..": OnFriendSeen")
		System:Log(entity:GetName()..": OnFriendSeen")
	end,

	OnSomethingSeen = function(self,entity,fDistance)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if not entity.SayFirstContact then
			if (entity:GetGroupCount() > 1) then
				if entity.WasInCombat and random(1,2)==1 and entity.IsSpecOpsMan=="Den" then -- Недобитый враг?
					if fDistance>40 then
						AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_ALERT_SEEN_2_DEN",entity.id)
					else
						AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"AI_AGGRESSIVE_ATTENTION",entity.id) -- Эй ты!
						AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"LOOK_ON_ME",entity.id)
					end
				else
					if fDistance>40 then
						AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_ALERT_SEEN_GROUP",entity.id)
					else
						AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"AI_AGGRESSIVE_ATTENTION",entity.id) -- Эй ты!
						AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"LOOK_ON_ME",entity.id)
					end
				end
			else
				AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_ALERT_SEEN",entity.id)
			end
			entity:SelectPipe(0,"SpecOps_look_closer")
			entity:InsertSubpipe(0,"setup_stealth")
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,15)
			AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"LOOK_AT_BEACON",entity.id)
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)	
		end
	end,

	OnDeadBodySeen = function(self,entity,sender,fDistance)
		if entity.Properties.species==sender.Properties.species and fDistance<=10 and entity.sees~=1 then
			entity:InsertSubpipe(0,"retreat_on_dead_body_seen",sender.id)
		end
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		entity:TriggerEvent(AIEVENT_CLEAR)
		if not fDistance then fDistance = 0 NotContact=1 end
		entity.ai_scramble = nil 
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if entity.ai_flanking or entity.AI_OnDanger then do return end end
		if entity.critical_status and fDistance > 30 then
			entity:SelectPipe(0,"hide_on_critical_status")
			do return end
		end
		entity:InsertSubpipe(0,"reload")
		if not NotContact then
			if entity.IsSpecOpsMan=="Den" then
				if (entity:GetGroupCount() > 1) then
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN_MEMORY_GROUP",entity.id)
				else
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN_MEMORY",entity.id)
				end
			else
				if (entity:GetGroupCount() > 1) then
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN_GROUP",entity.id)
				else
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN",entity.id)
				end
			end
		end
		if not entity.ConfirmCounter then entity.ConfirmCounter = 0  end
		local ctr = entity.ConfirmCounter 
		local rnd = random(1,10)
		if (fDistance <= 5) then -- Резко выбежать.
			if (rnd > 5 and ctr<=5) then
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
			if (rnd==1 and fDistance < 60) then -- Обойти.
				-- entity:SelectPipe(0,"cover_camp")
				AI:Signal(0,1,"HIDE_LEFT_OR_RIGHT",entity.id)
				if entity.IsSpecOpsMan=="Den" then
					entity:GrenadeAttack(6)
				elseif entity.IsSpecOpsMan=="Lock" then
					entity:GrenadeAttack(8)
				elseif entity.IsSpecOpsMan=="Dooch" then
					entity:GrenadeAttack()
				end
			elseif rnd==2 or (rnd==3 and ctr>2) then -- Атаковать.
				-- AI:Signal(0,1,"HIDE_TACTIC",entity.id)
				AI:Signal(0,1,"COVER_STRAFE",entity.id)
				entity:GrenadeAttack(3)
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
			elseif rnd==4 then
				entity:InsertSubpipe(0,"AiPlayer_hide_farthest")
			elseif rnd >= 5 then
				entity:SelectPipe(0,"confirm_targetloss")
				entity:InsertSubpipe(0,"setup_stand")
				entity:InsertSubpipe(0,"do_it_running")
				entity:InsertSubpipe(0,"not_shoot")
			end
		end
		if entity.IsSpecOpsMan=="Den" then
			AIBehaviour.DEFAULT:AI_SETUP_DOWN(entity)
		end
	end,

	OnInterestingSoundHeard = function(self,entity,fDistance) -- Добавить: Если небыло боя и услышал звук, то должен разведать и после сказать INTERESTED_TO_IDLE, как при интересном звуке у наёмников.
		-- entity:MakeAlerted()
		entity.ai_flanking = nil 
		entity.ai_scramble = nil 
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if entity.AI_OnDanger then do return end end
		if entity.critical_status and fDistance > 30 then
			entity:SelectPipe(0,"hide_on_critical_status")
			do return end
		end
		entity:InsertSubpipe(0,"reload")
		if not entity.SayFirstContact then
			if random(1,2)==1 then -- 1 Проверяет как наёмники.
				if (entity:GetGroupCount() > 1) then
					if random(1,2)==1 then
						AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_ALERT_HEARD_GROUP",entity.id)
					else
						AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_ALERT_HEARD",entity.id)
					end
				else
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_ALERT_HEARD",entity.id)
				end
				entity:SelectPipe(0,"SpecOps_look_closer")
				entity:InsertSubpipe(0,"setup_stealth")
				entity:ChangeAIParameter(AIPARAM_COMMRANGE,15)
				AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"LOOK_AT_BEACON",entity.id)
				entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)
			else -- Все разбегаются по укрытиям.
				if (entity:GetGroupCount() > 1) then
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_ALERT_HEARD_2_GROUP",entity.id)
				else
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_ALERT_HEARD_2",entity.id)
				end
				entity:SelectPipe(0,"SpecOps_incoming_fire")
				entity:InsertSubpipe(0,"setup_stand")
				entity:ChangeAIParameter(AIPARAM_COMMRANGE,30)
				AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"ON_MELEE_ENEMY_ATTACK",entity.id)
				entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)		
				if random(1,5)==1 then
					if entity.IsSpecOpsMan=="Den" then
						entity:GrenadeAttack(3)
					elseif entity.IsSpecOpsMan=="Lock" then
						entity:GrenadeAttack(5)
					elseif entity.IsSpecOpsMan=="Dooch" then
						entity:GrenadeAttack()
					end
				end				
			end
		else
			if entity.sees~=1 then
				if random(1,2)==1 then
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"IDLE_TO_THREATENED",entity.id)
					entity:SelectPipe(0,"confirm_targetloss")
					local rnd = random(1,3)
					if rnd==1 or fDistance <= 15 then
						entity:InsertSubpipe(0,"setup_stand")
						entity:InsertSubpipe(0,"do_it_running")
						if random(1,5)==1 then
							if entity.IsSpecOpsMan=="Den" then
								entity:GrenadeAttack(3)
							elseif entity.IsSpecOpsMan=="Lock" then
								entity:GrenadeAttack(5)
							elseif entity.IsSpecOpsMan=="Dooch" then
								entity:GrenadeAttack()
							end
						end
					elseif rnd==2 then
						entity:InsertSubpipe(0,"setup_stand")
						entity:InsertSubpipe(0,"do_it_walking")
						if (entity:GetGroupCount() > 1) then
							AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"IDLE_TO_THREATENED_GROUP",entity.id) -- Фразы "Медленные".
						end
					elseif rnd==3 then
						entity:InsertSubpipe(0,"setup_stealth")
						entity:InsertSubpipe(0,"do_it_walking")
						if (entity:GetGroupCount() > 1) then
							AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"IDLE_TO_THREATENED_GROUP",entity.id)
						end
					end
				else
					entity:SelectPipe(0,"SpecOps_scramble") -- А сюда что из слов добавить?
				end
			end
		end
	end,

	OnThreateningSoundHeard = function(self,entity,fDistance)
		entity:MakeAlerted()
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if fDistance > 80 or fDistance < 30 then
			entity.ai_flanking = nil 
		end
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"NORMAL_THREAT_SOUND",entity.id)
		if entity.sees~=1 then
			if not entity.SayFirstThreateningSound and not entity.SayFirstContact and fDistance<60 then
				if (entity:GetGroupCount() > 1) then
					if random(1,2)==1 then
						AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"CALL_ALARM_GROUP",entity.id)
					else
						AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"IDLE_TO_THREATENED",entity.id)
					end
				else
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"IDLE_TO_THREATENED",entity.id)
				end
				entity.SayFirstThreateningSound=1
			elseif entity.not_sees_timer_start~=0 and entity.SayFirstContact then
				-- if fDistance<60 and random(1,2)==1 then
				if fDistance<60 then
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"IDLE_TO_THREATENED",entity.id)
				end
				if random(1,10)==1 then
					entity:GrenadeAttack()
				end
			end
			if fDistance > 30 then
				AI:Signal(0,1,"COVER_STRAFE",entity.id)
			else
				self:OnPlayerSeen(entity,fDistance,1)
			end
			if random(1,5)==1 then
				AI:CreateGoalPipe("look_around")
				AI:PushGoal("look_around","signal",0,1,"FORCE_RESPONSIVENESS_1",0)
				AI:PushGoal("look_around","lookat",1,-180,180)
				AI:PushGoal("look_around","timeout",1,0,2)
				AI:PushGoal("look_around","acqtarget",1,"")
				AI:PushGoal("look_around","signal",0,1,"FORCE_RESPONSIVENESS_CLEAR",0)
				entity:InsertSubpipe(0,"look_around")
			end
		end
		entity:RunToMountedWeapon()
	end,

	OnClipNearlyEmpty = function(self,entity,sender)
		if random(1,10)==1 and entity.sees==1 then
			entity:GrenadeAttack()
		end
	end,

	OnReload = function(self,entity)
		if random(1,10)==1 and entity.sees~=1 then
			entity:GrenadeAttack(3)
		end
	end,

	OnNoHidingPlace = function(self,entity,sender)
		if entity.sees==1 and entity.IsSpecOpsMan=="Den" then
			AIBehaviour.DEFAULT:AI_SETUP_DOWN(entity)
		end
	end,
	--------------------------------------------------
	OnNoFormationPoint = function(self,entity,sender)
	end,
	--------------------------------------------------
	OnCoverRequested = function(self,entity,sender)
		-- called when the enemy is damaged
	end,

	OnKnownDamage = function(self,entity,sender) -- Добавить: "Ты что, меня убить вздумал?"
		entity:MakeAlerted()
		entity:SelectPipe(0,"SpecOps_scramble")
		entity:InsertSubpipe(0,"DropBeaconTarget",sender.id)
		AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"GETTING_SHOT_AT_KNOWN",entity.id)
	end,

	OnReceivingDamage = function(self,entity,sender)
		entity:MakeAlerted()
		entity:TriggerEvent(AIEVENT_CLEAR)
		entity:SelectPipe(0,"SpecOps_scramble") -- Заменить.
	end,

	OnBulletRain = function(self,entity,sender) -- Почему-то прячется ближе к цели, смотрит куда бежит и опускает оружие. Где-то есть insert subpipe. -- Почему-то говорит фразочки как если бы по нему попали.
		entity:MakeAlerted()
		entity.ai_flanking = nil 
		entity.ai_scramble = nil 
		-- entity:TriggerEvent(AIEVENT_CLEAR)
		if entity==sender then return end -- Работает?
		if entity.sees==2 then
			if (entity:GetGroupCount() > 1) then
				AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"GETTING_SHOT_AT_GROUP",entity.id)
			else
				AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"GETTING_SHOT_AT",entity.id)
			end
		end
		-- entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:SelectPipe(0,"SpecOps_incoming_fire") -- Прячется, выжидает, а потом атакует. Заменить.
		if random(1,10)==1 then
			entity:InsertSubpipe(0,"setup_crouch")
		end
		if random(1,10)==1 and entity.sees~=1 then
			entity:GrenadeAttack(3)
		end
	end,

	OnSomethingDiedNearest = function(self,entity,sender) -- Должен забывать про труп.
		entity:MakeAlerted()
		if entity.sees~=1 then
			entity:InsertSubpipe(0,"LookAtTheBodyInAction",sender.id)
			if not entity.cnt.proning and not entity.cnt.crouching then
				entity:InsertSubpipe(0,"setup_crouch")
			end
		end
	end,

	I_KILLED_HIM = function(self,entity,sender)
		if random(1,2)==1 then
			AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_LOST,"ENEMEY_KILLED",entity.id)
		end
	end,

	OnSomethingDiedNearest_x = function(self,entity,sender)
	end,

	OnCloseContact = function(self,entity,sender)
		if sender and entity.Properties.species~=sender.Properties.species then
			AI:CreateGoalPipe("SpecOps_retreat_on_close")
			AI:PushGoal("SpecOps_retreat_on_close","just_shoot")
			AI:PushGoal("SpecOps_retreat_on_close","setup_stand")
			AI:PushGoal("SpecOps_retreat_on_close","do_it_running")
			AI:PushGoal("SpecOps_retreat_on_close","locate",0,"atttarget")
			AI:PushGoal("SpecOps_retreat_on_close","acqtarget",0,"")
			AI:PushGoal("SpecOps_retreat_on_close","backoff",0,10)
			AI:PushGoal("SpecOps_retreat_on_close","timeout",1,1,3)
			AI:PushGoal("SpecOps_retreat_on_close","just_shoot")
			AI:PushGoal("SpecOps_retreat_on_close","hide",1,15,HM_NEAREST)
			entity:InsertSubpipe(0,"SpecOps_retreat_on_close",sender.id)
		end
	end,
	--------------------------------------------------
	-- CUSTOM SIGNALS
	--------------------------------------------------

	SCOUTING_SOUND = function(self,entity)
		AI:CreateGoalPipe("AiPlayer_ScoutingSound")
		local rnd = random(1,2)
		if rnd==1 then -- Идти прямо к цели.
			AI:PushGoal("AiPlayer_ScoutingSound","hide",1,10,HM_NEAREST,0)
			AI:PushGoal("AiPlayer_ScoutingSound","pathfind",1,"")
			AI:PushGoal("AiPlayer_ScoutingSound","trace",1,1,0)
			AI:PushGoal("AiPlayer_ScoutingSound","signal",0,1,"STEALTH_ATTACK",0)
		elseif rnd==2 then -- Смотреть по сторонам.
			AI:PushGoal("AiPlayer_ScoutingSound","lookat",1,-90,90)
			AI:PushGoal("AiPlayer_ScoutingSound","timeout",1,.5,1.5)
			AI:PushGoal("AiPlayer_ScoutingSound","lookat",1,-145,145)
			AI:PushGoal("AiPlayer_ScoutingSound","timeout",1,.5,1.5)
			AI:PushGoal("AiPlayer_ScoutingSound","locate",0,"hidepoint")
			AI:PushGoal("AiPlayer_ScoutingSound","acqtarget",0,"")
			AI:PushGoal("AiPlayer_ScoutingSound","timeout",1,.5,5)
			AI:PushGoal("AiPlayer_ScoutingSound","locate",0,"hidepoint")
			AI:PushGoal("AiPlayer_ScoutingSound","acqtarget",0,"")
			AI:PushGoal("AiPlayer_ScoutingSound","timeout",1,.5,5)
			AI:PushGoal("AiPlayer_ScoutingSound","locate",0,"hidepoint")
			AI:PushGoal("AiPlayer_ScoutingSound","acqtarget",0,"")
			AI:PushGoal("AiPlayer_ScoutingSound","timeout",1,.5,5)
			AI:PushGoal("AiPlayer_ScoutingSound","locate",0,"hidepoint")
			AI:PushGoal("AiPlayer_ScoutingSound","acqtarget",0,"")
			AI:PushGoal("AiPlayer_ScoutingSound","timeout",1,.5,5)
			AI:PushGoal("AiPlayer_ScoutingSound","pathfind",1,"")
			AI:PushGoal("AiPlayer_ScoutingSound","trace",1,1,0)
			AI:PushGoal("AiPlayer_ScoutingSound","signal",0,1,"STEALTH_ATTACK",0)
		else -- Сменить позицию и атаковать.
			AI:PushGoal("AiPlayer_ScoutingSound","hide",1,60,HM_RANDOM,1)
			AI:PushGoal("AiPlayer_ScoutingSound","timeout",1,1,5)
			AI:PushGoal("AiPlayer_ScoutingSound","locate",0,"hidepoint")
			AI:PushGoal("AiPlayer_ScoutingSound","acqtarget",1,"")
			AI:PushGoal("AiPlayer_ScoutingSound","locate",0,"beacon")
			AI:PushGoal("AiPlayer_ScoutingSound","acqtarget",1,"")
			AI:PushGoal("AiPlayer_ScoutingSound","pathfind",1,"")
			AI:PushGoal("AiPlayer_ScoutingSound","trace",1,1,0)
			AI:PushGoal("AiPlayer_ScoutingSound","signal",0,1,"AIPLAYER_ATTACK",0)
		end
		entity:SelectPipe(0,"AiPlayer_ScoutingSound")
		if not entity.cnt.proning and not entity.cnt.crouching then
			entity:InsertSubpipe(0,"setup_crouch")
		elseif entity.cnt.crouching then
			entity:InsertSubpipe(0,"setup_prone")
		end
	end,

	STEALTH_ATTACK = function(self,entity)
		AI:CreateGoalPipe("AiPlayer_stealth_attack")
		AI:PushGoal("AiPlayer_stealth_attack","locate",0,"beacon") -- atttarget
		AI:PushGoal("AiPlayer_stealth_attack","acqtarget",1,"")
		AI:PushGoal("AiPlayer_stealth_attack","timeout",1,1,5)
		AI:PushGoal("AiPlayer_stealth_attack","hide",1,30,HM_NEAREST,0)
		AI:PushGoal("AiPlayer_stealth_attack","hide",1,300,HM_NEAREST,1)
		AI:PushGoal("AiPlayer_stealth_attack","timeout",1,.5,1.5)
		AI:PushGoal("AiPlayer_stealth_attack","locate",0,"hidepoint")
		AI:PushGoal("AiPlayer_stealth_attack","acqtarget",1,"")
		AI:PushGoal("AiPlayer_stealth_attack","timeout",1,.5,1.5)
		AI:PushGoal("AiPlayer_stealth_attack","locate",0,"hidepoint")
		AI:PushGoal("AiPlayer_stealth_attack","acqtarget",1,"")
		AI:PushGoal("AiPlayer_stealth_attack","timeout",1,.5,1.5)
		AI:PushGoal("AiPlayer_stealth_attack","hide",1,300,HM_NEAREST_TO_TARGET,1)
		AI:PushGoal("AiPlayer_stealth_attack","signal",0,1,"AIPLAYER_ATTACK",0)
		-- AIBehaviour.DEFAULT:AI_SETUP_DOWN(entity)
		entity:SelectPipe(0,"AiPlayer_stealth_attack")
		entity:InsertSubpipe(0,"do_it_running")
		entity:InsertSubpipe(0,"just_shoot")
	end,

	AIPLAYER_ATTACK = function(self,entity,sender)
		entity:InsertSubpipe(0,"reload")
		-- if entity.critical_status then
			-- entity:SelectPipe(0,"hide_on_critical_status")
			-- do return end
		-- end
		entity:SelectPipe(0,"AiPlayer_pindown")
	end,
	
	ON_MELEE_ENEMY_ATTACK = function(self,entity,sender)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:SelectPipe(0,"SpecOps_incoming_fire")
		entity:InsertSubpipe(0,"setup_stand")
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
			local rnd
			if entity.IsSpecOpsMan~="Dooch" then
				rnd = random(-15,15)
			else
				rnd = random(-5,5)
			end
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
			entity:SelectPipe(0,"SpecOps_scramble")
			entity:InsertSubpipe(0,"setup_crouch")
		end
	end,
	
	SELECT_LEFT_OR_RIGHT = function(self,entity,sender)
		AI:CreateGoalPipe("left_or_right")
		if random(1,2)==1 then
			AI:PushGoal("left_or_right","hide",1,15,HM_LEFTMOST_FROM_TARGET,0)
		else
			AI:PushGoal("left_or_right","hide",1,15,HM_RIGHTMOST_FROM_TARGET,0)
		end
		entity:InsertSubpipe(0,"left_or_right")
	end,

	HIDE_LEFT_OR_RIGHT = function(self,entity,sender) -- За укрытием дожен вставать.
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
		AI:PushGoal("cover_hide_left_or_right","locate",0,"beacon")
		AI:PushGoal("cover_hide_left_or_right","acqtarget",0,"")
		if entity.not_sees_timer_start==0 then -- Есть цель.
			look = 1 
			if not entity.farhide then
				-- Hud:AddMessage(entity:GetName()..": HIDE_LEFT_OR_RIGHT/HM_FARTHEST_FROM_TARGET")
				-- System:Log(entity:GetName()..": HIDE_LEFT_OR_RIGHT/HM_FARTHEST_FROM_TARGET")
				entity.farhide = 1 
				AI:PushGoal("cover_hide_left_or_right","hide",1,15,HM_FARTHEST_FROM_TARGET,0)
				AI:PushGoal("cover_hide_left_or_right","hide",1,15,HM_FARTHEST_FROM_TARGET,1)
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
			AI:PushGoal("cover_hide_left_or_right","acqtarget",0,"")
			AI:PushGoal("cover_hide_left_or_right","timeout",1,0,3)
		else
			if look==0 then
				AI:PushGoal("cover_hide_left_or_right","timeout",1,0,3)
				if ai_flanking==1 then
					AI:PushGoal("cover_strafe","strafe",0,15)
				else
					AI:PushGoal("cover_strafe","strafe",0,-15)
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
		look = nil 
		entity:SelectPipe(0,"cover_hide_left_or_right")
	end,

	HIDE_TACTIC = function(self,entity,sender)
		entity:SelectPipe(0,"cover_hide_tactic")
	end,

	AISF_GoOn = function(self,entity,sender)
		entity:SelectPipe(0,"SpecOps_scramble")
	end,

	HEADS_UP_GUYS = function(self,entity,sender)
		if entity.ForceSenderId then sender=System:GetEntity(entity.ForceSenderId) entity.ForceSenderId=nil end
		entity:MakeAlerted()
		AIBehaviour.DEFAULT:AllWakeUp(entity)
		if entity.Properties.species==sender.Properties.species and entity~=sender
		and not entity.RunToTrigger and not entity.heads_up_guys and not entity.ai_flanking and entity.sees~=1 then
			if not entity.rs_x then	entity.rs_x = 1	end
			if random(1,3)==1 then
				entity:InsertSubpipe(0,"acquire_beacon2",sender.id)
			end
			entity:SelectPipe(0,"AiPlayer_beacon_pindown")
			if sender and sender.SenderId then
				entity:SelectPipe(0,"AiPlayer_check_beacon")
				entity:InsertSubpipe(0,"DropBeaconAt",sender.SenderId)
			end
			entity.heads_up_guys = 1  -- Нужно?
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,10)
			AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY(entity)
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

	-- LOOK_AT_BEACON = function(self,entity,sender)
		-- entity:MakeAlerted()
	-- end,
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