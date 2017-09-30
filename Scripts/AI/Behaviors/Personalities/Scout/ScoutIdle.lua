--------------------------------------------------
--    Created By: Petar
--   Description: This behaviour describes the SCOUT personality in idle mode
--------------------------
--

AIBehaviour.ScoutIdle = {
	Name = "ScoutIdle",

	OnSpawn = function(self,entity)
		System:Log(entity:GetName()..": ScoutIdle/OnSpawn")
		-- Вызывается, когда враг появляется или перезагружается.
	end,
	
	OnActivate = function(self,entity) -- Сделать по активации тревожное состояние.
		-- called when enemy receives an activate event (from a trigger,for example)
	end,

	OnNoTarget = function(self,entity) -- Не убирать!
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if not fDistance then fDistance = entity:GetDistanceToTarget() end
		if not fDistance then fDistance = 0 NotContact=1 end
		if not NotContact then
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
		if not entity.cnt.proning and not entity.cnt.crouching then
			entity:InsertSubpipe(0,"setup_stand")
		end
	end,

	OnEnemySeen = function(self,entity)
		-- called when the enemy sees a foe which is not a living player
	end,

	---------------------------------------------
	OnFriendSeen = function(self,entity)
		-- called when the enemy sees a friendly target
	end,

	OnSomethingSeen = function(self,entity)
		if (entity:GetGroupCount() > 1) then
			AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_ALERT_SEEN_GROUP",entity.id)
		else
			AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_ALERT_SEEN",entity.id)
		end
		entity:SelectPipe(0,"scout_look_closer")
		entity:InsertSubpipe(0,"setup_stealth")
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:InsertSubpipe(0,"DRAW_GUN") -- Нельзя ставить MakeAlerted().
		entity:ChangeAIParameter(AIPARAM_COMMRANGE,15)
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"LOOK_AT_BEACON",entity.id)
		entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
	end,

	OnInterestingSoundHeard = function(self,entity,fDistance)
		if entity.ThreatenStatus and entity.ThreatenStatus >= 1 and entity.ThreatenStatus < 5 then
			entity:TriggerEvent(AIEVENT_DROPBEACON)
			entity:GunOut() -- Неправильно вытаскивает.
			entity:InsertSubpipe(0,"DRAW_GUN") 
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,15)
			AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"LOOK_AT_BEACON",entity.id)
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)
		end
		if not entity.ThreatenStatus then
			entity.ThreatenStatus = 1 	
			entity:InsertSubpipe(0,"cover_lookat") 
		elseif entity.ThreatenStatus==1 then
			entity.ThreatenStatus = 2 	
			if (entity:GetGroupCount() > 1) then
				AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_ALERT_HEARD_GROUP",entity.id)
			else
				AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_ALERT_HEARD",entity.id)
			end
			entity:SelectPipe(0,"scout_look_closer") -- LOOK_AT_BEACON вверху
			-- entity:InsertSubpipe(0,"setup_stealth") 
		elseif entity.ThreatenStatus==2 then
			entity.ThreatenStatus = 3 	
			if (entity:GetGroupCount() > 1) then
				AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_THREATENED_GROUP",entity.id)
			else
				AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_THREATENED",entity.id)
			end
			-- entity:SelectPipe(0,"scout_hide")
			entity:SelectPipe(0,"scout_look_closer")
			entity.LAB = nil
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,30)
			AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"CLEAR_LOOK_AT_BEACON",entity.id)
			AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"LOOK_AT_BEACON",entity.id)
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)
		elseif entity.ThreatenStatus==3 then
			entity.LAB = nil
			entity.ThreatenStatus = 4
			entity:InsertSubpipe(0,"cover_lookat")
		elseif entity.ThreatenStatus==4 then
			entity.ThreatenStatus = 5
			entity:SelectPipe(0,"scout_hunt_beacon")
			AI:Signal(0,1,"ALERT_SIGNAL",entity.id) 
		end
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity,fDistance)
		entity.LAB = nil 
		entity.ThreatenStatus = 3 
		entity:MakeAlerted()
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"NORMAL_THREAT_SOUND",entity.id)
		entity:SelectPipe(0,"scout_threatening_sound")
		-- entity:InsertSubpipe(0,"scout_find_threat")
		entity:InsertSubpipe(0,"setup_stand")
		if fDistance>60 then
			entity:SelectPipe(0,"scout_scramble")
			entity:InsertSubpipe(0,"do_it_running")
		end
		AI:Signal(0,1,"ALERT_SIGNAL",entity.id)
	end,

	OnClipNearlyEmpty = function(self,entity,sender)
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
		AIBehaviour.CoverIdle:OnKnownDamage(entity,sender)
	end,
	
	OnSomethingDiedNearest = function(self,entity,sender)
		if not entity.rs_x then
			AIBehaviour.DEFAULT:OnSomethingDiedNearest(entity,sender)
		else
			if entity.Properties.species==sender.Properties.species then
				entity:InsertSubpipe("DropBeaconAt",sender.id)
				entity:SelectPipe(0,"randomhide")
				entity:RunToAlarm()
				-- entity.EventToCall = "OnPlayerSeen"  -- Проверить!
			end
		end
	end,

	THREAT_TOO_CLOSE = function(self,entity,sender)
		-- the team can split
		entity:MakeAlerted()
		entity:SelectPipe(0,"scout_threatening_sound")
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:InsertSubpipe(0,"scout_find_threat")
		entity:InsertSubpipe(0,"setup_stand")
		entity:InsertSubpipe(0,"DRAW_GUN")
	end,
	
	-- INTERESTED = function(self,entity,sender)
		-- AIBehaviour.ScoutHunt:OnInterestingSoundHeard(entity)
	-- end,

	SCOUT_HUNT = function(self,entity,sender)
		entity:SelectPipe(0,"scout_hunt") -- Не менять.
	end,

	CHECK = function(self,entity,sender)
		local rnd = random(1,6) -- Шанс.
		if rnd==1 then
			entity:SelectPipe(0,"scout_check_target_left")
		elseif rnd==2 then
			entity:SelectPipe(0,"scout_check_target_right")
		end
	end,

	-------------------------------------------------	
	-- GROUP SIGNALS
	---------------------------------------------	
	HEADS_UP_GUYS = function(self,entity,sender)
		if entity.ForceSenderId then sender=System:GetEntity(entity.ForceSenderId) entity.ForceSenderId=nil end
		AIBehaviour.DEFAULT:AllWakeUp(entity)
		if entity.Properties.species==sender.Properties.species then
			entity:MakeAlerted()
			if not entity.RunToTrigger then
				if entity.id~=sender.id then
					entity:SelectPipe(0,"scout_hunt_beacon") -- Охотиться на маяк.
					entity:InsertSubpipe(0,"go_to_sender",sender.id)
					if sender.SenderId then
						entity:SelectPipe(0,"check_beacon")
						entity:InsertSubpipe(0,"DropBeaconAt",sender.SenderId)
					end
					entity:GettingAlerted()
				end
			end
		end
	end,

	SCOUT_NORMALATTACK = function(self,entity,sender)
		entity.AI_Flanking = nil
		AI:Signal(0,1,"CHECK_FOR_FIND_A_TARGET",entity.id)
		AI:CreateGoalPipe("scout_strafe")
		AI:PushGoal("scout_strafe","do_it_running")
		AI:PushGoal("scout_strafe","just_shoot")
		local rnd = random(0,2)
		if (rnd > 1.5) then
			AI:PushGoal("scout_strafe","approach",0,2)
		end
		rnd = random(-5,5)
		if (rnd <= -1.5 or rnd >= 1.5) then
		-- local rnd3 = random(0,2)
			-- if (rnd3 > 1) then
				AI:PushGoal("scout_strafe","strafe",1,rnd)
			-- else
				-- AI:PushGoal("scout_strafe","backoff",1,rnd)
			-- end
		end
		AI:PushGoal("scout_strafe","timeout",1,.2)
		if entity.sees~=1 then
			entity:InsertSubpipe(0,"not_shoot")
		else
			entity:InsertSubpipe(0,"just_shoot")
		end
		entity:SelectPipe(0,"scout_comeout")
		entity:InsertSubpipe(0,"scout_strafe")
		local att_target = AI:GetAttentionTargetOf(entity.id)
		if (att_target) then
			if (type(att_target)=="table") then
				if (entity:GetDistanceFromPoint(att_target:GetPos()) <= 10) then
					if random(1,2)==1 then
						entity:SelectPipe(0,"scout_attack_far_left")
					else
						entity:SelectPipe(0,"scout_attack_far_right")
					end
				elseif (entity:GetDistanceFromPoint(att_target:GetPos()) <= 20) then
					local rnd = random(1,20)
					if (rnd<10) then
						if random(1,2)==1 then
							entity:SelectPipe(0,"scout_attack_far_left")
						else
							entity:SelectPipe(0,"scout_attack_far_right")
						end
					-- elseif (rnd<20) then
						-- entity:SelectPipe(0,"scout_comeout")
					end
				else
					local rnd = random(1,40)
					if (rnd<10) then
						if random(1,2)==1 then
							entity:SelectPipe(0,"scout_attack_far_left")
						else
							entity:SelectPipe(0,"scout_attack_far_right")
						end
					-- elseif (rnd<20) then
						-- entity:SelectPipe(0,"scout_comeout")
					elseif (rnd<30) then
						entity.AI_Flanking = 1
						entity:SelectPipe(0,"scout_attack_left")
					else
						entity.AI_Flanking = 1
						entity:SelectPipe(0,"scout_attack_right")
					end
				end
			end
		end
	end,

	KEEP_FORMATION = function(self,entity,sender)
		-- the team leader wants everyone to keep formation
	end,
	---------------------------------------------	
	MOVE_IN_FORMATION = function(self,entity,sender)
		-- the team leader wants everyone to move in formation
		entity:Readibility("ORDER_RECEIVED",1)
		entity:SelectPipe(0,"MoveFormation")
	end,
	
	RETURN_TO_FIRST = function(self,entity,sender)
		entity.ThreatenStatus = 3 
		entity.ThreatenStatus2 = 1 
		entity.ThreatenStatus3 = 1 
		entity.ThreatenStatus4 = 1 	
		entity.ThreatenStatus5 = 1 
		entity.no_MG = nil 
		entity.THREAT_SOUND_SIGNAL_SENT = nil 
		entity.FirstState=1 
		entity.EventToCall = "OnSpawn" 	
	end,
}