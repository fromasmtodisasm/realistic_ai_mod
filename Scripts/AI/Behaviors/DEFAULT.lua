-- Default behaviour - implements all the system callbacks and does something
-- this is so that any enemy has a behaviour to fallback to
--------------------------
-- DO NOT MODIFY THIS BEHAVIOUR

AIBehaviour.DEFAULT = {
	Name = "DEFAULT",

	HIDE_FROM_BEACON = function(self,entity,sender)
		entity:InsertSubpipe(0,"hide_from_beacon")
	end,

	OnNoTarget = function(self,entity,sender)
		-- Hud:AddMessage(entity:GetName()..": OnNoTarget")
		System:Log(entity:GetName()..": OnNoTarget")
		entity.not_sees_timer_start = _time
		entity.allow_search = nil
		entity.allow_idle = nil
		-- if entity.id==_localplayer.id then
		if entity.IsAiPlayer then
			entity.AiPlayerAllowSearchGun = nil
			-- AI:Signal(0,1,"GO_FOLLOW",entity.id)
			-- entity.AiPlayerAllowSearchGun = 1
		end
	end,

	NOT_DANGER = function(self,entity,sender)
		entity.AI_OnDanger = nil
	end,

	LOOK_ON_ME = function(self,entity,sender) -- Для врагов, фразы вроде "Эй ты!".
		if entity.Properties.species~=sender.Properties.species then
			entity:InsertSubpipe(0,"LookAtTheBodyInAction",sender.id)
		end
	end,

	AFTER_THROW_GRENADE = function(self,entity,sender)
		if entity.IsAiPlayer then
			entity:SelectPipe(0,"after_throw_grenade_hide2")
		else -- Чтобы сразу прятались.
			if random(1,2)==1 then
				entity:SelectPipe(0,"after_throw_grenade_hide_and_random")
			else
				entity:SelectPipe(0,"after_throw_grenade_hide_and_attack")
			end
		end
	end,

	AFTER_THROW_GRENADE_LEFT_OR_RIGHT = function(self,entity,sender)
		if random(1,2)==1 then
			entity:SelectPipe(0,"after_throw_grenade_check_target_left")
		else
			entity:SelectPipe(0,"after_throw_grenade_check_target_right")
		end
	end,

	CHECK_FOR_FIND_A_TARGET = function(self,entity,sender)
		if entity==_localplayer then
			Hud:AddMessage(entity:GetName()..": 1 CHECK_FOR_FIND_A_TARGET")
			System:Log(entity:GetName()..": 1 CHECK_FOR_FIND_A_TARGET")
		end
		-- if entity.allow_search then
		-- if entity.allow_search or (entity.IsAiPlayer and entity.sees~=1) then -- Временно. Придумать как разрешать при старте уровня, когда ещё ни разу не выпало GO_FOLLOW.
		-- if entity.allow_search or entity.IsAiPlayer then -- Временно. Придумать как разрешать при старте уровня, когда ещё ни разу не выпало GO_FOLLOW.
		if entity.allow_search then -- Временно. Придумать как разрешать при старте уровня, когда ещё ни разу не выпало GO_FOLLOW.
			if entity==_localplayer then
				Hud:AddMessage(entity:GetName()..": 2 CHECK_FOR_FIND_A_TARGET/entity.allow_search")
				System:Log(entity:GetName()..": 2 CHECK_FOR_FIND_A_TARGET/entity.allow_search")
			end
			-- if entity.AI_AtWeapon then
				-- Hud:AddMessage(entity:GetName()..": CHECK_FOR_FIND_A_TARGET/RETURN_TO_NORMAL")
				-- System:Log(entity:GetName()..": CHECK_FOR_FIND_A_TARGET/RETURN_TO_NORMAL")
				-- AI:Signal(0,1,"RETURN_TO_NORMAL",entity.id)
			-- end
			AI:Signal(0,1,"FIND_A_TARGET",entity.id)
		end
	end,

	CHECK_FOR_CLOSE_FRIENDS = function(self,entity,sender)
		local Result = entity:NewCountingPlayers(30,1,0,1) -- Friends,GroupFriends,Enemies,People,Mutants,Player,Radius
		if Result.Friends>2 then
			AI:CreateGoalPipe("go_far")
			AI:PushGoal("go_far","hide",1,100,HM_FARTHEST,1) -- Искать далеко, чтобы не толпились в одной куче.
			entity:InsertSubpipe(0,"go_far")
		end
	end,

	CHECK_FOR_SELECT_IDLE = function(self,entity,sender)
		if entity.allow_idle or entity.AiPlayerNextCheck then
			-- if entity==_localplayer then
				-- Hud:AddMessage(entity:GetName()..": 1 CHECK_FOR_SELECT_IDLE")
				-- System:Log(entity:GetName()..": 1 CHECK_FOR_SELECT_IDLE")
			-- end
			if entity.IsAiPlayer then -- ПРОШЛО, но он всё-равно не следует далее!!!
				if entity==_localplayer then
					Hud:AddMessage(entity:GetName()..": 2 CHECK_FOR_SELECT_IDLE")
					System:Log(entity:GetName()..": 2 CHECK_FOR_SELECT_IDLE")
				end
				entity.FirstState=1
				entity.AiPlayerNextCheck=1
				-- entity.AiPlayerInsertFollow=1
				AI:Signal(0,1,"GO_FOLLOW",entity.id)
			else
				AI:Signal(0,1,"SELECT_IDLE",entity.id)
			end
		else
			AI:Signal(0,1,"CHECK_FOR_CLOSE_FRIENDS",entity.id)
		end
	end,

	FIND_A_TARGET = function(self,entity,sender)
		if entity.MUTANT then
			if entity.MUTANT=="predator" then
				if random(1,2)==1 then
					entity:SelectPipe(0,"predator_seeking_enemies")
				else
					entity:SelectPipe(0,"predator_seeking_enemies2")
				end
			elseif entity.MUTANT=="fast" then
				if entity.AI_CanWalk then
					entity:SelectPipe(0,"fast_seeking_enemies")
				else
					entity:SelectPipe(0,"fast_look_around")
				end
			elseif entity.MUTANT=="stealth" then
				if random(1,2)==1 then
					entity:SelectPipe(0,"predator_seeking_enemies")
				else
					entity:SelectPipe(0,"predator_seeking_enemies2")
				end
				entity:InsertSubpipe(0,"do_it_walking")
			end
			do return end
		end
		if entity.IsAiPlayer then
			-- if entity.id~=_localplayer.id then
				entity.Following=nil
				entity.AllowSayNoTarget=1
				AI:CreateGoalPipe("find_a_target")
				AI:PushGoal("find_a_target","not_shoot")
				AI:PushGoal("find_a_target","locate",0,"beacon")
				AI:PushGoal("find_a_target","acqtarget",0,"")
				AI:PushGoal("find_a_target","not_shoot")  -- Опять баг.
				-- AI:PushGoal("find_a_target","timeout",1,0,2.5)
				-- AI:PushGoal("find_a_target","signal",0,1,"FORCE_RESPONSIVENESS_3",0)
				-- AI:PushGoal("find_a_target","lookat",0,-90,90)
				-- AI:PushGoal("find_a_target","signal",0,1,"FORCE_RESPONSIVENESS_CLEAR",0)
				-- AI:PushGoal("find_a_target","timeout",1,0,2.5)
				AI:PushGoal("find_a_target","timeout",1,2,5)
				AI:PushGoal("find_a_target","signal",0,1,"FORCE_RESPONSIVENESS_3",0)
				AI:PushGoal("find_a_target","lookat",0,-90,90)
				-- AI:PushGoal("find_a_target","lookat",0,-45,45)
				AI:PushGoal("find_a_target","timeout",1,.5,2)
				AI:PushGoal("find_a_target","signal",0,1,"FORCE_RESPONSIVENESS_CLEAR",0)
				AI:PushGoal("find_a_target","timeout",1,0,1)
				AI:PushGoal("find_a_target","signal",0,1,"setup_crouch")
				AI:PushGoal("find_a_target","signal",0,1,"do_it_walking")
				AI:PushGoal("find_a_target","locate",0,"hidepoint")
				AI:PushGoal("find_a_target","acqtarget",0,"")
				-- if entity.id~=_localplayer.id and entity.allow_idle then
				-- if entity.id==_localplayer.id and entity.allow_idle then
					AI:PushGoal("find_a_target","signal",1,1,"CHECK_FOR_SELECT_IDLE",0)
				-- end
				AI:PushGoal("find_a_target","timeout",1,0,1)
				AI:PushGoal("find_a_target","just_shoot")
				AI:PushGoal("find_a_target","signal",0,1,"FORCE_RESPONSIVENESS_3",0)
				AI:PushGoal("find_a_target","lookat",0,-90,90)
				AI:PushGoal("find_a_target","timeout",1,0,2)
				AI:PushGoal("find_a_target","signal",0,1,"FORCE_RESPONSIVENESS_CLEAR",0)
				AI:PushGoal("find_a_target","not_shoot")
				AI:PushGoal("find_a_target","timeout",1,0,3)
				AI:PushGoal("find_a_target","just_shoot")
				-- AI:PushGoal("find_a_target","locate",0,"atttarget") -- Может критическую ошибку вызвать, потому, что цель потеряна.
				AI:PushGoal("find_a_target","locate",0,"beacon")
				AI:PushGoal("find_a_target","acqtarget",0,"")
				if not entity.InElevatorArea then
					AI:PushGoal("find_a_target","approach",0,.7)
				end
				AI:PushGoal("find_a_target","trace",1,1,1)
				AI:PushGoal("find_a_target","timeout",1,0,2.5)
				-- if entity.id==_localplayer.id and entity.allow_idle then
					AI:PushGoal("find_a_target","signal",1,1,"CHECK_FOR_SELECT_IDLE",0)
				-- end
				AI:PushGoal("find_a_target","hide",1,60,HM_RANDOM,1)
				-- if entity.id==_localplayer.id and entity.allow_idle then
					AI:PushGoal("find_a_target","signal",1,1,"CHECK_FOR_SELECT_IDLE",0)
				-- end
				AI:PushGoal("find_a_target","timeout",1,0,2.5)
				AI:PushGoal("find_a_target","locate",0,"hidepoint")
				AI:PushGoal("find_a_target","acqtarget",0,"")
				AI:PushGoal("find_a_target","timeout",1,0,3)
				if not entity.InElevatorArea then
					AI:PushGoal("find_a_target","approach",1,.6)
				end
				AI:PushGoal("find_a_target","locate",0,"hidepoint")
				AI:PushGoal("find_a_target","acqtarget",1,"")
				AI:PushGoal("find_a_target","timeout",1,0,3)
				AI:PushGoal("find_a_target","locate",0,"beacon")
				AI:PushGoal("find_a_target","acqtarget",0,"")
				AI:PushGoal("find_a_target","timeout",1,0,3)
				if not entity.InElevatorArea then
					AI:PushGoal("find_a_target","approach",1,.6)
				end
				AI:PushGoal("find_a_target","timeout",1,0,5)
				AI:PushGoal("find_a_target","signal",0,1,"AI_SETUP_DOWN",0)
				AI:PushGoal("find_a_target","signal",1,1,"CHECK_FOR_SELECT_IDLE",0)
			-- else
				-- entity.AllowSayNoTarget=1
				-- AI:CreateGoalPipe("find_a_target")  -- Сделать другое.
				-- AI:PushGoal("find_a_target","just_shoot")
				-- AI:PushGoal("find_a_target","locate",0,"beacon")
				-- AI:PushGoal("find_a_target","acqtarget",0,"")
				-- AI:PushGoal("find_a_target","timeout",1,2,5)
				-- AI:PushGoal("find_a_target","signal",1,1,"CHECK_FOR_SELECT_IDLE",0)
			-- end
		else -- Чего-то не то с охотой: подходит к маяку, если в руках мачете.
			AI:CreateGoalPipe("find_a_target")
			AI:PushGoal("find_a_target","not_shoot")
			AI:PushGoal("find_a_target","timeout",1,1,3)
			AI:PushGoal("find_a_target","just_shoot")
			AI:PushGoal("find_a_target","locate",0,"beacon")
			AI:PushGoal("find_a_target","acqtarget",0,"")
			AI:PushGoal("find_a_target","timeout",1,1,2.5)
			AI:PushGoal("find_a_target","signal",0,1,"FORCE_RESPONSIVENESS_3",0)
			AI:PushGoal("find_a_target","lookat",0,-90,90)
			AI:PushGoal("find_a_target","timeout",1,0,2)
			AI:PushGoal("find_a_target","signal",0,1,"FORCE_RESPONSIVENESS_CLEAR",0)
			AI:PushGoal("find_a_target","timeout",1,1,2.5)
			AI:PushGoal("find_a_target","locate",0,"hidepoint")
			AI:PushGoal("find_a_target","acqtarget",0,"")
			AI:PushGoal("find_a_target","timeout",1,1,2.5)
			AI:PushGoal("find_a_target","just_shoot")
			AI:PushGoal("find_a_target","timeout",1,1,2.5)
			AI:PushGoal("find_a_target","signal",0,1,"FORCE_RESPONSIVENESS_3",0)
			AI:PushGoal("find_a_target","lookat",0,-90,90)
			AI:PushGoal("find_a_target","timeout",1,0,2)
			AI:PushGoal("find_a_target","signal",0,1,"FORCE_RESPONSIVENESS_CLEAR",0)
			AI:PushGoal("find_a_target","timeout",1,1,3)
			-- AI:PushGoal("find_a_target","locate",0,"atttarget") -- Может критическую ошибку вызвать.
			AI:PushGoal("find_a_target","locate",0,"beacon")
			AI:PushGoal("find_a_target","acqtarget",0,"")
			AI:PushGoal("find_a_target","approach",0,.7)
			AI:PushGoal("find_a_target","trace",1,1,1)
			AI:PushGoal("find_a_target","timeout",1,0,2.5)
			AI:PushGoal("find_a_target","look_around")
			AI:PushGoal("find_a_target","timeout",1,.5,5)
			AI:PushGoal("find_a_target","hide",1,100,HM_RANDOM,1)
			AI:PushGoal("find_a_target","timeout",1,.5,2.5)
			AI:PushGoal("find_a_target","locate",0,"hidepoint")
			AI:PushGoal("find_a_target","acqtarget",0,"")
			AI:PushGoal("find_a_target","timeout",1,.5,3)
			AI:PushGoal("find_a_target","approach",1,.6)
			AI:PushGoal("find_a_target","timeout",1,0,3)
			AI:PushGoal("find_a_target","locate",0,"beacon")
			AI:PushGoal("find_a_target","acqtarget",0,"")
			AI:PushGoal("find_a_target","timeout",1,0,3)
			AI:PushGoal("find_a_target","approach",1,.6)
			AI:PushGoal("find_a_target","timeout",1,2,5)
			AI:PushGoal("find_a_target","signal",1,1,"CHECK_FOR_SELECT_IDLE",0)
			-- AI:PushGoal("find_a_target","signal",1,1,"GO_TO_INVESTIGATION_POINT",0)
		end
		entity:SelectPipe(0,"find_a_target")
		entity:InsertSubpipe(0,"do_it_walking")
		entity.NotReturnToIdleSay = 1
	end,

	-- GO_TO_INVESTIGATION_POINT = function(self,entity)
		-- local dh = AI:FindObjectOfType(entity.id,30,AIAnchor.INVESTIGATE_HERE)
		-- if (dh) then
			-- -- Hud:AddMessage(entity:GetName()..": GO_TO_INVESTIGATION_POINT")
			-- -- System:Log(entity:GetName()..": GO_TO_INVESTIGATION_POINT")
			-- entity.ForceResponsiveness = 1
			-- entity:ChangeAIParameter(AIPARAM_RESPONSIVENESS,2)
			-- AI:CreateGoalPipe("investigate_to2")
			-- AI:PushGoal("investigate_to2","pathfind",1,"")
			-- AI:PushGoal("investigate_to2","trace",0,1)
			-- AI:PushGoal("investigate_to2","lookat",1,-90,90)
			-- AI:PushGoal("investigate_to2","branch",1,-1)
			-- AI:PushGoal("investigate_to2","lookat",1,0,0)
			-- AI:PushGoal("investigate_to2","devalue",0)  -- Сделать чтобы всё-таки забывал про якорь.
			-- AI:PushGoal("investigate_to2","lookat",1,-45,45)
			-- AI:PushGoal("investigate_to2","timeout",1,.5,1.5)
			-- AI:PushGoal("investigate_to2","signal",1,1,"GO_TO_INVESTIGATION_POINT",0)
			-- entity:InsertSubpipe(0,"investigate_to2",dh)
		-- end
		-- -- entity:ChangeAIParameter(AIPARAM_RESPONSIVENESS,entity.Properties.responsiveness)
		-- -- entity.ForceResponsiveness = nil
	-- end,

	NIL_FORCE_RESPONSIVENESS = function(self,entity,sender) -- AcqTarget2
		entity.ForceResponsiveness = nil
	end,

	FORCE_RESPONSIVENESS_3 = function(self,entity)
		entity.ForceResponsiveness = 1
		entity:ChangeAIParameter(AIPARAM_RESPONSIVENESS,3)
	end,

	FORCE_RESPONSIVENESS_CLEAR = function(self,entity)
		entity.ForceResponsiveness = nil
		entity:ChangeAIParameter(AIPARAM_RESPONSIVENESS,entity.Properties.responsiveness)
	end,

	MERC_GO_ATTACK = function(self,entity,sender)
		-- local fDistance = entity:GetDistanceToTarget()
		-- if fDistance then
		-- end
		entity:SelectPipe(0,"merc_go_attack")
		if entity.IsAiPlayer then AI:Signal(0,1,"GO_FOLLOW",entity.id) end
		if random(1,5)==1 then
			entity:GrenadeAttack(3)
		end
	end,

	TARGET_LOST = function(self,entity) -- Нужно чтобы звучало, если замеченная цель не была убита.
		if entity.target_lost_muted then do return end end
		if (entity:GetGroupCount() > 1) then
			if random(1,2)==1 then
				AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_LOST,"ENEMY_TARGET_LOST_GROUP",entity.id)  -- Скорее для командира.
			else
				AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_LOST,"ENEMY_TARGET_LOST",entity.id)
			end
		else
			AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_LOST,"ENEMY_TARGET_LOST",entity.id)
		end
		-- AI:Signal(0,1,"target_lost_animation",entity.id) 	-- проверить
		-- Hud:AddMessage(entity:GetName()..": TARGET_LOST")
		-- System:Log(entity:GetName()..": TARGET_LOST")
	end,

	OnTheMurder = function(self,entity,sender)
		-- if entity.not_sees_timer_start==0 then
			self:OnNoTarget(entity)  -- Сделать Mute target lost, если вызвано отсюда.
		-- end
	end,

	OnGrenadeSeen = function(self,entity,fDistance) -- Сделать анимацию как если оружия в руках нет.
		if entity.ActivateJobAnimation or (entity:GetName()=="Valerie" and Game:GetLevelName()=="Volcano") then return end
		AI:Signal(0,-1,"GRENADE_SEEN",entity.id)
		if entity.TempAiAction=="Hiding" or entity.TempAiAction=="ForceFollow" then entity.TempAiAction = nil end
		if not fDistance then fDistance = 0 end
		if entity.Properties.bMayBeInvisible==1 and not entity.IsInvisible then
			-- entity:InsertSubpipe(0,"brief_invisibility")
			entity:InsertSubpipe(0,"predator_is_invisible")
		end
		AIBehaviour.EntityGrenadeSeen:OnGrenadeSeen(entity,fDistance)
	end,

	OnGrenadeSeen_Flying = function(self,entity,sender)
		if entity.ActivateJobAnimation or (entity:GetName()=="Valerie" and Game:GetLevelName()=="Volcano") then return end
		if entity.ReallyGrenadeSees then -- C++
			AI:Signal(0,-1,"GRENADE_SEEN",entity.id)
			entity.OnGrenadeSeen_sender = sender
			AIBehaviour.EntityGrenadeSeen:OnGrenadeSeen_Flying(entity)
		end
	end,

	OnGrenadeSeen_Colliding = function(self,entity,sender)
		if entity.ActivateJobAnimation or (entity:GetName()=="Valerie" and Game:GetLevelName()=="Volcano") then return end
		if entity.Properties.bMayBeInvisible==1 and not entity.IsInvisible then
			entity:InsertSubpipe(0,"predator_is_invisible")
		end
		entity.OnGrenadeSeen_sender = sender
		entity.ReallyGrenadeSees=1
		AIBehaviour.EntityGrenadeSeen:OnGrenadeSeen_Flying(entity)
	end,

	OnDangerousObjectSeen = function(self,entity,sender)
		Hud:AddMessage(entity:GetName()..": OnDangerousObjectSeen")
		System:Log(entity:GetName()..": OnDangerousObjectSeen")
		entity:SelectPipe(0,"grenade_run_away")
	end,

	INSERT_APPROACH = function(self,entity,sender)
		if not entity.IsSpecOpsMan then
			AI:CreateGoalPipe("ctimeout")
			AI:PushGoal("ctimeout","timeout",1,0,2)  -- Из-за этого возможно и вылетает. Cower_pindown
			-- AI:PushGoal("ctimeout","timeout",1,0,10)
			entity:InsertSubpipe(0,"ctimeout")
		end
		local rnd=random(1,4)
		if rnd==1 then -- forward (approach)
			local distance = entity:GetDistanceToTarget()
			AI:CreateGoalPipe("pindown_approach")
			if entity.sees~=1 then
				AI:PushGoal("pindown_approach","approach",0,.8)  -- cover_pindown
				if distance and distance <= 15 then
					AI:PushGoal("pindown_approach","trace",1,0,1)  -- 1,1,0 - смотреть в направлении движения. 1,0,0 - сосредоточиться на цели. 1,0,1 - на каждом каждый шагу генерируется путь в зависимости от положения цели и походу заканчивается когда сущность во что-нибудь упирается.
				else
					AI:PushGoal("pindown_approach","trace",1,1,1)
				end
				AI:PushGoal("pindown_approach","timeout",1,0,1)
				entity:InsertSubpipe(0,"pindown_approach")
			else
				if distance and distance > 30 then
					AI:PushGoal("pindown_approach","approach",0,.1)
					AI:PushGoal("pindown_approach","trace",1,0,1)
					AI:PushGoal("pindown_approach","timeout",1,0,1)
					entity:InsertSubpipe(0,"pindown_approach")
				end
				rnd=random(2,5)
			end
		end
		if rnd==2 then -- backoff
			entity:InsertSubpipe(0,"pindown_backoff")
		elseif rnd==3 then -- strafe left
			entity:InsertSubpipe(0,"pindown_strafe_left")
		elseif rnd==4 then -- strafe right
			entity:InsertSubpipe(0,"pindown_strafe_right")
		end
	end,
	
	LEFT_LEAN_ENTER = function(self,entity,sender)
		entity:SelectPipe(0,"lean_left_attack")
	end,

	RIGHT_LEAN_ENTER = function(self,entity,sender)
		entity:SelectPipe(0,"lean_right_attack")
	end,

	DIG_IN_ATTACK = function(self,entity,sender)
		entity:SelectPipe(0,"dig_in_attack")
	end,
	
	WHEN_LEFT_LEAN_ENTER = function(self,entity,sender)
		-- Hud:AddMessage(entity:GetName()..": DEFAULT/WHEN_LEFT_LEAN_ENTER")
		System:Log(entity:GetName()..": DEFAULT/WHEN_LEFT_LEAN_ENTER")
		local rnd = random(1,3)
		if rnd==1 then
			AI:Signal(0,1,"LEFT_LEAN_ENTER",entity.id)
		elseif rnd==2 then
			AI:Signal(0,1,"RANDOM_DEVIATE",entity.id)
		else
			entity.LeanLeftDelay = _time+5
		end
	end,

	WHEN_RIGHT_LEAN_ENTER = function(self,entity,sender)
		-- Hud:AddMessage(entity:GetName()..": DEFAULT/WHEN_RIGHT_LEAN_ENTER")
		System:Log(entity:GetName()..": DEFAULT/WHEN_RIGHT_LEAN_ENTER")
		local rnd = random(1,3)
		if rnd==1 then
			AI:Signal(0,1,"RIGHT_LEAN_ENTER",entity.id)
		elseif rnd==2 then
			AI:Signal(0,1,"RANDOM_DEVIATE",entity.id)
		else
			entity.LeanRightDelay = _time+5
		end		
	end,

	RANDOM_DEVIATE = function(self,entity,sender) -- Когда за укрытием.
		if not entity.IsSpecOpsMan then
			AI:CreateGoalPipe("ctimeout")
			AI:PushGoal("ctimeout","timeout",1,.1,2)  -- Из-за этого возможно и вылетает. Cover_pindown
			-- AI:PushGoal("ctimeout","timeout",1,0,10)
			entity:InsertSubpipe(0,"ctimeout")
		end
		local rnd=random(1,4)
		if rnd==1 then -- forward (approach)
			local distance = entity:GetDistanceToTarget()
			AI:CreateGoalPipe("pindown_approach")
			if entity.sees~=1 then
				AI:PushGoal("pindown_approach","approach",0,.8)  -- cover_pindown
				if distance and distance <= 15 then
					AI:PushGoal("pindown_approach","trace",1,0,1)  -- 1,1,0 - смотреть в направлении движения. 1,0,0 - сосредоточиться на цели. 1,0,1 - на каждом каждый шагу генерируется путь в зависимости от положения цели и походу заканчивается когда сущность во что-нибудь упирается.
				else
					AI:PushGoal("pindown_approach","trace",1,1,1)
				end
				AI:PushGoal("pindown_approach","timeout",1,0,1)
				entity:InsertSubpipe(0,"pindown_approach")
			else
				if distance and distance > 30 then
					AI:PushGoal("pindown_approach","approach",0,.1)
					AI:PushGoal("pindown_approach","trace",1,0,1)
					AI:PushGoal("pindown_approach","timeout",1,0,1)
					entity:InsertSubpipe(0,"pindown_approach")
				end
				rnd=random(2,5)
			end
		end
		if rnd==2 then -- backoff
			entity:InsertSubpipe(0,"pindown_backoff")
		elseif rnd==3 then -- strafe left
			entity:InsertSubpipe(0,"pindown_strafe_left")
		elseif rnd==4 then -- strafe right
			entity:InsertSubpipe(0,"pindown_strafe_right")
		end
	end,

	END_MELEE_ATTACK = function(self,entity,sender)
		if entity.fireparams.fire_mode_type~=FireMode_Melee then
			-- entity:SelectPipe(0,"just_shoot_and_search")
			entity:SelectPipe(0,"hide_on_danger")
			-- -- AI:CreateGoalPipe("melee_attack_stop")
			-- if entity.sees==1 then
				-- -- AI:PushGoal("melee_attack_stop","signal",1,1,"OnPlayerSeen",0)
				-- -- entity.EventToCall = "OnPlayerSeen"
				-- -- self:OnPlayerSeen(entity,0,1)
				-- AI:Signal(0,1,"OnPlayerSeen",entity.id)
			-- else
				-- -- AI:PushGoal("melee_attack_stop","signal",1,1,"OnEnemyMemory",0)
				-- -- entity.EventToCall = "OnEnemyMemory"
				-- -- self:OnEnemyMemory(entity,0,1)
				-- AI:Signal(0,1,"OnEnemyMemory",entity.id)
			-- end
			-- -- entity:InsertSubpipe(0,"melee_attack_stop")
			entity.MeleeAttack2=nil
		end
	end,

	OnCloseContact = function(self,entity,sender) -- Сущность ещё должна увидеть того, кто в неё упёрся, иначе не сработает.
		entity:ChangeAIParameter(AIPARAM_FOV,entity.Properties.horizontal_fov)
		-- Hud:AddMessage(entity:GetName()..": DEFAULT/OnCloseContact")
		-- local info = 0
		if entity.Properties.species~=sender.Properties.species then
			entity.ai_flanking = nil
		-- AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN",entity.id)
			if not entity.MeleeAttack and not entity.MeleeAttack2 then
				-- Hud:AddMessage(entity:GetName()..": DEFAULT/OnCloseContact")
				entity:InsertSubpipe(0,"AcqBeacon",sender.id)
				entity:InsertSubpipe(0,"retreat_on_close",sender.id)
				-- info = "reteat"
			end
		else
			if not entity.IsAiPlayer then
				entity:InsertSubpipe(0,"devalue_target",sender.id)  -- Нельзя союзнику такое делать. Пристрелит.
				-- info = "devalue"
			end
		end
		-- Hud:AddMessage(entity:GetName()..": DEFAULT/OnCloseContact: "..info)
		-- System:Log(entity:GetName()..": DEFAULT/OnCloseContact: "..info)
	end,

	DESTROY_THE_BEACON = function(self,entity,sender)
		if (entity.cnt.numofgrenades>0) then
			local rnd=random(1,4)
			if (rnd>2) then
				entity:InsertSubpipe(0,"shoot_the_beacon")
			else
				entity:InsertSubpipe(0,"bomb_the_beacon")
			end
		else
			entity:InsertSubpipe(0,"shoot_the_beacon")
		end
	end,

	MAKE_COMBAT_BREAK_ANIM = function(self,entity,sender)
		if (entity.COMBAT_IDLE_COUNT) then
			local rnd = random(0,entity.COMBAT_IDLE_COUNT)
			local idle_anim_name = format("combat_idle%02d",rnd)
			entity:InsertAnimationPipe(idle_anim_name,3)
		end
	end,

	MAKE_BELLOW_HOWL_ANIMATION = function(self,entity,sender)
		entity:InsertAnimationPipe("idle05",nil,nil,nil,nil,1)
	end,
	-- Запретить сразу стрелять.
	OnFriendInWay = function(self,entity,sender) -- Используется из CryAiSystem! Вот почему снайпера с вышек падают!
		if entity.CurrentConversation then return end
		-- Когда ИИ пытается стрелять и видит перед собой препятствие в виде союзника, он пытается отойти в сторону, чтобы случайно не попасть в своего.
		-- В этот момент не стреляют.
		-- Пример: снайпер на кране, на уровне Регулятор.
		-- Когда одновременно есть и то, и другое в первый раз держит пушку опущеной вниз, как при расслабленном состоянии. Выглядит не очень.
		entity.DoNotShootOnFriendInWayStart = _time
		if entity.MERC=="sniper" then return end
		if not entity.GoLeftOrRightOnFriendInWay or entity.GoLeftOrRightOnFriendInWay==0 then entity.GoLeftOrRightOnFriendInWay = random(-1,1) end
		AI:CreateGoalPipe("friend_circle")
		AI:PushGoal("friend_circle","strafe",1,entity.GoLeftOrRightOnFriendInWay)
		entity:InsertSubpipe(0,"friend_circle")
		-- local distance = entity:GetDistanceToTarget()
		-- if distance and distance<=30 then
		entity:InsertSubpipe(0,"do_it_running")
		self:AI_SETUP_UP(entity)
		-- end
		-- System:Log(entity:GetName()..": OnFriendInWay")
	end,

	CLEAR_LOOK_AT_BEACON = function(self,entity,sender)
		if entity.Properties.species==sender.Properties.species and not entity.RunToTrigger and not entity.ANIMAL then
		if entity:ForbiddenCharacters() then do return end end
			if entity.id~=sender.id then
				entity.LAB=nil
			end
		end
	end,

	LOOK_AT_BEACON = function(self,entity,sender) -- Передать эстафету другому, если в руках пистолет или чел снайпер. Для мутантов сделать другую реакцию. -- Мерк скаут не переключается при виде игрока.
		if entity.Properties.species==sender.Properties.species and not entity.RunToTrigger and not entity.ANIMAL then
		if entity:ForbiddenCharacters() then do return end end
			if entity.id==sender.id then -- Исправить: Проверяющий должен смотреть на цель, лишь изредка поглядывая по сторонам.
				entity.LAB = 1  -- Это для STOP_LOOK_AT_BEACON в cover_look_closer.
			end
			if entity.id~=sender.id and not entity.LAB and entity.sees~=1 then -- Я не хочу чтобы тот, кто уже разведывает то что увидел, разведывал по сигналу другого другое место.
				entity.LAB = 1
				entity.NotReturnToIdleSay = 1
				entity:GunOut()  -- Сделать чтоб пушку после небольшой задержки доставал когда ему об этом говорят друзья.
				entity:SelectPipe(0,"look_at_beacon") -- Только смотреть.
				local rnd=random(1,2)
				local rnd2=random(1,2)
				if rnd==1 then
					entity:InsertSubpipe(0,"setup_stand")
				else
					entity:InsertSubpipe(0,"setup_stealth")
				end
				if rnd2==1 then
					entity:InsertSubpipe(0,"just_shoot")
				else
					entity:InsertSubpipe(0,"not_shoot")
				end
				-- Hud:AddMessage(entity:GetName()..": LOOK_AT_BEACON")
				System:Log(entity:GetName()..": LOOK_AT_BEACON")
			end
		end
	end,

	STOP_LOOK_AT_BEACON = function(self,entity,sender) -- Что-то не стопиятся когда он один.
		if entity.Properties.species==sender.Properties.species and not entity.RunToTrigger and not entity.ANIMAL then
		if entity:ForbiddenCharacters() or entity.SendStopLAB then do return end end
			-- if not entity.LAB then entity.LAB=0  end
			-- Hud:AddMessage(entity:GetName()..": entity.LAB: "..entity.LAB)
			-- System:Log(entity:GetName()..": entity.LAB: "..entity.LAB)
			-- if entity.LAB==0 then entity.LAB = nil  end
			if entity.id==sender.id then
				-- Hud:AddMessage(entity:GetName()..": entity.NotReturnToIdleSay: "..entity.NotReturnToIdleSay)
				AI:Signal(0,1,"SELECT_IDLE",entity.id)
			else
				if entity.LAB then
					entity.SendStopLAB=1
					entity:ChangeAIParameter(AIPARAM_COMMRANGE,30)
					AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"LOOK_AT_BEACON",entity.id) -- CoverInterested
					entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)
					-- entity.LAB = nil  -- Придумать что-нибудь получше.
					AI:CreateGoalPipe("select_idle")
					AI:PushGoal("select_idle","timeout",1,1,4)
					AI:PushGoal("select_idle","signal",0,1,"SELECT_IDLE",0)
					entity:SelectPipe(0,"select_idle")
					AI:Signal(0,1,"CHECK",entity.id)
					-- Hud:AddMessage(entity:GetName()..": STOP_LOOK_AT_BEACON")
					System:Log(entity:GetName()..": STOP_LOOK_AT_BEACON")
				-- else
				end
			end
		end
	end,

	AfterIsCagedAttack = function(self,entity,sender) -- Доделать: Если до этого был в боевом состоянии, заметив не того кто в клетке то не выбирать.
		-- entity.NotReturnToIdleSay=1
		-- AI:CreateGoalPipe("select_idle")
		-- AI:PushGoal("select_idle","just_shoot")
		-- AI:PushGoal("select_idle","acqtarget",0,"")
		-- AI:PushGoal("select_idle","clear")
		-- AI:PushGoal("select_idle","timeout",1,2,6)
		-- AI:PushGoal("select_idle","clear")
		-- -- AI:PushGoal("select_idle","signal",0,1,"","SIGNALID_READIBILITY")  -- Ругательное слово.
		-- AI:PushGoal("select_idle","signal",0,1,"SELECT_IDLE",0)
		-- entity:SelectPipe(0,"select_idle")
	end,

	OnReceivingDamage = function(self,entity,sender) -- Нужно ли говорить товарищам при таком повреждении?
		entity:TriggerEvent(AIEVENT_CLEAR)
		entity:GunOut()
		entity:SelectPipe(0,"hide_on_damage")
		-- Hud:AddMessage(entity:GetName()..": OnReceivingDamage")
		-- System:Log(entity:GetName()..": OnReceivingDamage")
	end,

	OnBulletRain = function(self,entity,sender)
		entity:TriggerEvent(AIEVENT_CLEAR)
		if (entity.GetGroupCount and entity:GetGroupCount() > 1) then
			AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"GETTING_SHOT_AT_GROUP",entity.id)
		else
			AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"GETTING_SHOT_AT",entity.id)
		end
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"INCOMING_FIRE",entity.id)
		entity:SelectPipe(0,"randomhide")
		-- Hud:AddMessage(entity:GetName()..": OnBulletRain")
		-- System:Log(entity:GetName()..": OnBulletRain")
	end,

	INCOMING_FIRE = function(self,entity,sender) -- IDLE
		if entity.Properties.species==sender.Properties.species and not entity.RunToTrigger and not entity.ANIMAL then
		if entity:ForbiddenCharacters() then do return end end
			entity:MakeAlerted()
			entity:RunToAlarm()
			if entity~=sender then
				-- Hud:AddMessage(entity:GetName()..": INCOMING_FIRE")
				System:Log(entity:GetName()..": INCOMING_FIRE")
				entity:SelectPipe(0,"randomhide")  -- Заменить на что-нибудь нормальное.
				-- entity:GettingAlerted()
			end
		end
	end,

	WakeUp2 = function(self,entity,sender)
		-- entity:TriggerEvent(AIEVENT_WAKEUP)
		if not sender then entity:TriggerEvent(AIEVENT_SLEEP) return end
		local IIndoor = System:IsPointIndoors(entity:GetPos())
		local HeIndoor = System:IsPointIndoors(sender:GetPos())
		local AllowWakeUp
		-- -- if (sender.ForceIndoorWakeUp and IIndoor and not HeIndoor) then -- Если принимающий внутри, а посылающий снаружи.
		-- if (sender.ForceIndoorWakeUp) then -- Если принимающий внутри, а посылающий снаружи.
		-- -- or (sender.PropertiesInstance.groupid and entity.PropertiesInstance.groupid == sender.PropertiesInstance.groupid) then
		if sender.PropertiesInstance.groupid and entity.PropertiesInstance.groupid == sender.PropertiesInstance.groupid then
		-- or entity:GetDistanceToTarget(sender)<=30 then
		-- if IIndoor and not HeIndoor then
			AllowWakeUp = 1
			-- sender.ForceIndoorWakeUp = nil
			-- Hud:AddMessage(entity:GetName()..": AllowWakeUp, Sender: "..sender:GetName())
			-- System:Log(entity:GetName()..": AllowWakeUp, Sender: "..sender:GetName())
		end
		if IIndoor~=HeIndoor and not AllowWakeUp then entity:TriggerEvent(AIEVENT_SLEEP) return end
		if entity.OnWakeUp then return end
		entity.OnWakeUp = 1
		if entity.Event_UnHide then entity:Event_UnHide() end -- ?
		-- if not sender then
			-- System:Log(entity:GetName()..": AIEVENT_WAKEUP, Sender: Sender is nil!")
		-- else
			-- System:Log(entity:GetName()..": AIEVENT_WAKEUP, Sender: "..sender:GetName())
		-- end
	end,

	MyGroupWakeUp = function(self,entity) -- Расстояние сделать в зависимости от того кто на улице, а кто внутри помещений. Где отправитель, где принимающий.
		if entity.OnWakeUp then do return end end
		if entity:GetGroupCount() > 1 then
			entity.OnWakeUp = 1
			AI:Signal(SIGNALFILTER_SUPERGROUP,-1,"WakeUp",entity.id)
			AI:Signal(SIGNALFILTER_SUPERGROUP,-1,"WakeUp2",entity.id)  -- Все друзья по группе "пробуждаются".
			-- if entity.bEnemy_Hidden then -- Доработать.
				entity:Event_UnHide()
			-- end
		end
	end,

	AllWakeUp = function(self,entity) -- Расстояние сделать в зависимости от того кто на улице, а кто внутри помещений. Где отправитель, где принимающий.
		if entity.OnWakeUp then return end
		entity.OnWakeUp = 1
		if entity.IsIndoor then
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,5) -- 15
			AI:Signal(SIGNALFILTER_ANYONEINCOMM,-1,"WakeUp",entity.id)
			AI:Signal(SIGNALFILTER_ANYONEINCOMM,-1,"WakeUp2",entity.id)
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)
		else
			-- entity.ForceIndoorWakeUp = 1
			-- entity:ChangeAIParameter(AIPARAM_COMMRANGE,60)
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,100)
			AI:Signal(SIGNALFILTER_ANYONEINCOMM,-1,"WakeUp",entity.id)
			AI:Signal(SIGNALFILTER_ANYONEINCOMM,-1,"WakeUp2",entity.id)
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)
			-- entity.ForceIndoorWakeUp = nil
		end
		-- if entity.bEnemy_Hidden then
			entity:Event_UnHide()
		-- end
	end,

	-- reinforcements work the same for everyone

	GoForReinforcement = function(self,entity,sender) -- Почему-то нет анимаций.
		-- Hud:AddMessage(entity:GetName()..": GoForReinforcement!")
		if not entity.MUTANT and not entity.ANIMAL and not entity.RunToTrigger then
			entity.RunToTrigger = 1
			if entity.BlindAlarmNameEntity and entity.BlindAlarmNameEntity.engaged==entity.id then -- Нажать кнопку тревоги.
				entity.xalarm = 1
				AI:Signal(0,1,"GOING_TO_TRIGGER",entity.id)
				entity:SelectPipe(0,"run_to_trigger",entity.BlindAlarmName)
				-- Hud:AddMessage(entity:GetName()..": GoForReinforcement/BlindAlarm: "..entity.BlindAlarmName)
				System:Log(entity:GetName()..": GoForReinforcement/BlindAlarm: "..entity.BlindAlarmName)
			elseif entity.AlarmNameEntity and entity.AlarmNameEntity.engaged==entity.id then -- Нажать кнопку тревоги.
				entity.xalarm = 2
				AI:Signal(0,1,"GOING_TO_TRIGGER",entity.id)
				entity:SelectPipe(0,"run_to_trigger",entity.AlarmName)
				-- Hud:AddMessage(entity:GetName()..": GoForReinforcement/Alarm: "..entity.AlarmName)
				System:Log(entity:GetName()..": GoForReinforcement/Alarm: "..entity.AlarmName)
			elseif entity.NotifyAnchorEntity and entity.NotifyAnchorEntity.engaged==entity.id then -- Побежать к якорю и крикнуть о том что нужна помощь.
				entity.xalarm = 3
				-- local rnd = random(0,2)
				-- if rnd > 1 then
				-- if not entity.get_reinforcements_muted then
					entity:Readibility("GET_REINFORCEMENTS",1) 	-- Оставайтесь здесь, я позову остальных! -- Задержите его, я позову помощь!
					self:HEADS_UP_GUYS_ANY(entity)
				-- else
					-- entity.get_reinforcements_muted = nil
				-- end
				-- else
					-- entity:Readibility("CALL_ALARM",1) -- В зоне нарушитель!
				-- end
				AI:Signal(0,1,"GOING_TO_TRIGGER",entity.id)
				entity:SelectPipe(0,"delay_headsup",entity.NotifyAnchor)  -- Исправить: может крикнуть: "Медика!".
				-- self:HEADS_UP_GUYS_ANY(entity)  -- В runtoalarm
				-- Hud:AddMessage(entity:GetName()..": GoForReinforcement/NotifyAnchor: "..entity.NotifyAnchor)
				System:Log(entity:GetName()..": GoForReinforcement/NotifyAnchor: "..entity.NotifyAnchor)
			elseif entity.ReinforcePointEntity and entity.ReinforcePointEntity.engaged==entity.id then -- Побежать и позвать на помощь.
				entity.xalarm = 4
				entity:ChangeAIParameter(AIPARAM_GROUPID,999)
				entity.CurrentGroupID = 999  -- Для SetActualName.
				entity:Readibility("GET_REINFORCEMENTS",1)
				self:HEADS_UP_GUYS_ANY(entity)
				entity:TriggerEvent(AIEVENT_DROPBEACON)
				-- make myself change behaviour to ignore everything
				AI:Signal(0,1,"IGNORE_ALL_ELSE",entity.id)  -- Переделать под GOING_TO_TRIGGER
				entity:SelectPipe(0,"AIS_GoForReinforcement",entity.ReinforcePoint)
				-- Hud:AddMessage(entity:GetName()..": GoForReinforcement/ReinforcePoint: "..entity.ReinforcePoint)
				System:Log(entity:GetName()..": GoForReinforcement/ReinforcePoint: "..entity.ReinforcePoint)
			end
		end
	end,

	MAKE_OBSERVE = function(self,entity,sender) -- Пожарный случай при выходе из техники.
		System:Log(entity:GetName()..": DEFAULT/MAKE_OBSERVE")
		AIBehaviour.Job_Observe:OnSpawn(entity)
	end,

	OnSpawn = function(self,entity)
		System:Log(entity:GetName()..": DEFAULT/OnSpawn")
		AIBehaviour.Job_StandIdle:OnSpawn(entity)
	end,

	NOTIFY_FRIENDS = function(self,entity,sender) -- Используется в delay_headsup.
		self:MyGroupWakeUp(entity)  -- Пробудить всю свою группу.
		self:HEADS_UP_GUYS_GROUP(entity)  -- Сказать всей своей группе, где цель.
		if entity.IsIndoor then return end -- Нужно?
		entity:ChangeAIParameter(AIPARAM_COMMRANGE,300)  -- Не убирать!
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,-1,"WakeUp",entity.id)
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,-1,"WakeUp2",entity.id)  -- Пробудить окружающих.
		entity:ChangeAIParameter(AIPARAM_COMMRANGE,200)  -- 150
		self:HEADS_UP_GUYS_ANY(entity)  -- Сказать окружающим где цель.
		entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)
	end,

	HEADS_UP_GUYS_ANY_ON_ATTACK = function(self,entity,sender)
		if entity.IsIndoor then
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,30)
		else
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,60)
		end
		self:HEADS_UP_GUYS_ANY(entity)
		entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)
	end,

	HEADS_UP_GUYS_ANY = function(self,entity,sender) -- Не делать nil в entity.SenderId, потому что после delay_headsup забывает цель.
		local att_target = AI:GetAttentionTargetOf(entity.id)
		if att_target and type(att_target)=="table" then
			entity.SenderId = att_target.id
		end
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"HEADS_UP_GUYS",entity.id)
	end,

	HEADS_UP_GUYS_GROUP = function(self,entity,sender)
		local att_target = AI:GetAttentionTargetOf(entity.id)
		if att_target and type(att_target)=="table" then
			entity.SenderId = att_target.id
		end
		AI:Signal(SIGNALFILTER_SUPERGROUP,1,"HEADS_UP_GUYS",entity.id)
	end,

	RunToAlarmSignal = function(self,entity,sender)
		if entity.Properties.species==sender.Properties.species and not entity.RunToTrigger and not entity.ANIMAL then
		if entity:ForbiddenCharacters() then do return end end
			entity.SignalSent = 1
			if entity~=sender then
				-- entity.SignalSent = nil
				-- Hud:AddMessage(entity:GetName()..": RunToAlarmSignal")
				-- System:Log(entity:GetName()..": RunToAlarmSignal")
				entity:RunToAlarm()
			end
			-- if entity==sender then	-- проверить
				-- if entity.xalarm==1 and entity.BlindAlarmNameEntity.engaged==entity.id then entity.BlindAlarmNameEntity.engaged = nil
				-- elseif entity.xalarm==2 and entity.AlarmNameEntity.engaged==entity.id then entity.AlarmNameEntity.engaged = nil
				-- elseif entity.xalarm==3 and entity.NotifyAnchorEntity.engaged==entity.id then entity.NotifyAnchorEntity.engaged = nil
				-- elseif entity.xalarm==4 and entity.ReinforcePointEntity.engaged==entity.id then entity.ReinforcePointEntity.engaged = nil  end
				-- entity.xalarm = nil
			-- end
		end
	end,

	GETTING_ALERTED = function(self,entity,sender)
		entity:GettingAlerted()
	end,

	SAY_FIRST_HOSTILE_CONTACT = function(self,entity,sender) -- Так, как и раньше, надёжно произносят эти фразы. Заменить на подсчёт и проверку
		if entity:GetGroupCount() > 1 then
			AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"FIRST_HOSTILE_CONTACT_GROUP",entity.id)	-- И сигнал, и фраза.
		else
			AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"FIRST_HOSTILE_CONTACT",entity.id)
		end
		-- Hud:AddMessage(entity:GetName()..": entity:GetGroupCount(): "..entity:GetGroupCount())
	end,

	MAKE_REINFORCEMENT_ANIM = function(self,entity,sender)
		if (AI:FindObjectOfType(entity.id,10,AIAnchor.USE_RADIO_ANIM)) then
			local rnd=random(1,2)
			entity:InsertAnimationPipe("reinforcements_hutradio"..rnd,3)
		else
			AI:Signal(SIGNALID_READIBILITY,1,"CALL_REINFORCEMENTS",entity.id)  -- Нам требуется подкрепление!
		end
	end,

	AI_SETUP_DOWN = function(self,entity)
		if not entity.cnt.proning and not entity.cnt.crouching then
			entity:InsertSubpipe(0,"setup_crouch")
			entity:InsertSubpipe(0,"do_it_walking")
		elseif entity.cnt.crouching then
			entity:InsertSubpipe(0,"setup_prone")
			entity:InsertSubpipe(0,"do_it_walking")
		end
	end,

	AI_SETUP_UP = function(self,entity)
		if entity.cnt.proning then
			entity:InsertSubpipe(0,"setup_crouch")
			entity:InsertSubpipe(0,"do_it_walking")
		elseif entity.cnt.crouching then
			entity:InsertSubpipe(0,"setup_stand")
			entity:InsertSubpipe(0,"do_it_walking")
		end
	end,

	-- setup_stand = function(self,entity)
		-- AI:CreateGoalPipe("setup_stand_signal")
		-- AI:PushGoal("setup_stand_signal","bodypos",0,BODYPOS_STAND)
		-- entity:InsertSubpipe(0,"setup_stand_signal")
		-- entity.NewPos = 0
		-- Hud:AddMessage(entity:GetName()..": setup_stand_signal")
		-- System:Log(entity:GetName()..": setup_stand_signal")
	-- end,

	-- setup_crouch = function(self,entity)
		-- AI:CreateGoalPipe("setup_crouch_signal")
		-- AI:PushGoal("setup_crouch_signal","bodypos",0,BODYPOS_CROUCH)
		-- entity:InsertSubpipe(0,"setup_crouch_signal")
		-- entity.NewPos = 1
		-- Hud:AddMessage(entity:GetName()..": setup_crouch_signal")
		-- System:Log(entity:GetName()..": setup_crouch_signal")
	-- end,

	-- setup_prone = function(self,entity)
		-- AI:CreateGoalPipe("setup_prone_signal")
		-- AI:PushGoal("setup_prone_signal","bodypos",0,BODYPOS_PRONE)
		-- entity:InsertSubpipe(0,"setup_prone_signal")
		-- entity.NewPos = 2
		-- Hud:AddMessage(entity:GetName()..": setup_prone_signal")
		-- System:Log(entity:GetName()..": setup_prone_signal")
	-- end,

	-- setup_stealth = function(self,entity)
		-- AI:CreateGoalPipe("setup_stealth_signal")
		-- AI:PushGoal("setup_stealth_signal","bodypos",0,BODYPOS_STEALTH)
		-- entity:InsertSubpipe(0,"setup_stealth_signal")
		-- entity.NewPos = 3
		-- Hud:AddMessage(entity:GetName()..": setup_stealth_signal")
		-- System:Log(entity:GetName()..": setup_stealth_signal")
	-- end,

	-- setup_relax = function(self,entity)
		-- AI:CreateGoalPipe("setup_relax_signal")
		-- AI:PushGoal("setup_relax_signal","bodypos",0,BODYPOS_RELAX)
		-- entity:InsertSubpipe(0,"setup_relax_signal")
		-- entity.NewPos = 4
		-- Hud:AddMessage(entity:GetName()..": setup_relax_signal")
		-- System:Log(entity:GetName()..": setup_relax_signal")
	-- end,

	-- do_it_walking = function(self,entity)
		-- AI:CreateGoalPipe("do_it_walking_signal")
		-- AI:PushGoal("do_it_walking_signal","run",0,0)
		-- AI:PushGoal("do_it_walking_signal","run",0,0)
		-- entity:InsertSubpipe(0,"do_it_walking_signal")
		-- entity.NewSpeed = 1
		-- Hud:AddMessage(entity:GetName()..": do_it_walking_signal")
		-- System:Log(entity:GetName()..": do_it_walking_signal")
	-- end,

	-- do_it_running = function(self,entity)
		-- AI:CreateGoalPipe("do_it_running_signal")
		-- AI:PushGoal("do_it_running_signal","run",0,1)
		-- AI:PushGoal("do_it_running_signal","run",0,1)
		-- entity:InsertSubpipe(0,"do_it_running_signal")
		-- entity.NewSpeed = 2
		-- Hud:AddMessage(entity:GetName()..": do_it_running_signal")
		-- System:Log(entity:GetName()..": do_it_running_signal")
	-- end,

	OnDeadBodySeen = function(self,entity,sender,fDistance) -- Сделать тоже самое для опасных объектов.
		if entity.Properties.species==sender.Properties.species and not entity.rs_x then
			-- entity:TriggerEvent(AIEVENT_DROPBEACON)
			-- System:Log(entity:GetName()..": DEFAULT/OnDeadBodySeen: "..sender:GetName())
			if entity.MUTANT then entity.rs_x=1 end
			AIBehaviour.DEFAULT:OnSomethingDiedNearest(entity,sender)
		end
	end,
	-- Everyone has to be able to warn anyone around him that he died
	OnDeath = function(self,entity,sender) -- Добавил сендера (убийцу).
		entity:ChangeAIParameter(AIPARAM_COMMRANGE,40)
		if sender and sender.PracticleFireMan and entity.MUTANT and entity.MUTANT=="big" and entity.PropertiesInstance.soundrange==0  -- Для Архива, когда элита расстреливает большого мутанта.
		and entity.PropertiesInstance.sightrange==0 and entity.Properties.species==sender.Properties.species and entity.PropertiesInstance.groupid==798 then
			if Game:GetLevelName()=="Archive" then
				AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"OnLowAmmoExit",entity.id)
				-- AIBehaviour.Job_PracticeFire:OnLowAmmoExit(sender)
				return
			end
		end
		-- if not entity.MUTANT and not entity.ANIMAL then -- Доработать!!!
			-- if entity.DROP_GRENADE then -- Нужен только для спавна гранаты. А зачем так?
			-- -- if entity.cnt.numofgrenades>0 and entity.cnt.grenadetype==1 then -- Надо узнать какой тип чему соответствует.
				-- local gnd = Server:SpawnEntity("ProjFlashbangGrenade")  --  Не спавнит!
				-- if (gnd) then
					-- gnd:Launch(nil,entity,entity:GetPos(),{x=0,y=0,z=0},{x=0,y=0,z=-.001})
				-- end
			-- end
		-- end
		-- FreeSignal не делать, иначе приём сигнала срабатывет только когда их groupid не равен grupid умершего.
		entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"OnSomethingDiedNearest",entity.id)
	end,
	-- What everyone has to do when they get a notification that someone died
	OnSomethingDiedNearest = function(self,entity,sender) -- Должны быть разные реакции и разная задержка.
		if entity:ForbiddenCharacters() then do return end end -- attempt to compare number with nil
		if (not entity.MUTANT and not entity.ANIMAL) then
			-- AI:SetAllowedDeathCount(entity.Properties.nAllowedDeaths)
			if (entity.ai) then
				if entity.Properties.species==sender.Properties.species and entity.id~=sender.id and not entity.RunToTrigger then
					entity:Readibility("FRIEND_DEATH",1)  -- Добавить небольшую задержку.
					entity.deadsenderid = sender.id
					entity.rs_x = 1  -- Лучше на entity.deadsenderid не опираться.
					entity:ChangeAIParameter(AIPARAM_COMMRANGE,40)
					AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"OnSomethingDiedNearest_x",entity.id)
					entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)
					-- Hud:AddMessage(entity:GetName()..": OnSomethingDiedNearest")
					System:Log(entity:GetName()..": DEFAULT/OnSomethingDiedNearest: "..sender:GetName())
				end
			end
			-- (entity.Properties.KEYFRAME_TABLE~="MUTANT_MONKEY"
			-- or entity.Properties.KEYFRAME_TABLE~="MUTANT_ABBERATION"
			-- or entity.Properties.KEYFRAME_TABLE~="MUTANT_BIG"
			-- or entity.Properties.KEYFRAME_TABLE~="MUTANT_STEALTH"
			-- or entity.Properties.KEYFRAME_TABLE~="MUTANT_FAST"
		end
	end,

	OnSomethingDiedNearest_x = function(self,entity,sender)
		if entity:ForbiddenCharacters() then do return end end
		if (not entity.MUTANT and not entity.ANIMAL) then
			if entity.ai and entity.Properties.species==sender.Properties.species and not entity.RunToTrigger then
				entity:MakeAlerted()
				-- if entity.rs_x and not entity.rs_y then
				-- if entity.rs_x then
					entity.rs_y = 1
					entity:TriggerEvent(AIEVENT_CLEAR) -- Обязательно, а то иногда не отвлекается от своей работы.
					System:Log(entity:GetName()..": DEFAULT/OnSomethingDiedNearest_x: "..sender:GetName())
					if entity.id==sender.id then
						-- entity:InsertSubpipe("DropBeaconAt",entity.deadsenderid)
						entity:SelectPipe(0,"RecogCorpse",entity.deadsenderid)
						entity:InsertSubpipe(0,"TeamMemberDiedLook2",entity.deadsenderid)
						-- Hud:AddMessage(entity:GetName()..": RecogCorpse")
						System:Log(entity:GetName()..": RecogCorpse")
					else
						entity:SelectPipe(0,"TeamMemberDiedLook2")
						-- Hud:AddMessage(entity:GetName()..": TeamMemberDiedLook2")
						System:Log(entity:GetName()..": TeamMemberDiedLook2")
					end
				-- end
			end
		end
	end,

	NOTIFY_FRIENDS_X = function(self,entity,sender) -- Пайпа RecogCorpse.
		entity:ChangeAIParameter(AIPARAM_COMMRANGE,60)
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"DEATH_CONFIRMED",entity.id)
		entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)
	end,

	-- OnGroupMemberDiedNearest = function(self,entity,sender)
	-- end,

	OnGroupMemberDied = function(self,entity,sender)
		-- entity:MakeAlerted()
		-- entity:InsertSubpipe(0,"DRAW_GUN")
		-- entity:InsertSubpipe(0,"setup_stand")
	end,

	ChooseManner = function(self,entity,sender)
		--System:Log("### ChooseManner ###")
		local rnd = random(1,10)
		if rnd <= 4 then
			entity:InsertSubpipe(0,"LookForThreat")
		elseif rnd <= 8 then
			entity:InsertSubpipe(0,"RandomSearch")
		elseif rnd <= 10 then
			entity:InsertSubpipe(0,"ApproachDeadBeacon")
		end
	end,

	SWITCH_TO_MORTARGUY = function(self,entity,sender) -- Переделать систему.
		entity:GunOut()
		-- Hud:AddMessage(entity:GetName()..": SWITCH_TO_MORTARGUY")
		-- System:Log(entity:GetName()..": SWITCH_TO_MORTARGUY")
		entity:SelectPipe(0,"goto_mounted_weapon",entity.MountedGun)
		if entity.theVehicle then return end -- Из-за лодки.
		entity.quickly_use_MG = 1
		entity.EventToCall = "USE_MOUNTED_WEAPON"
	end,

	SEARCH_AMMUNITION = function(self,entity,sender)
		-- entity:Readibility("GETTING_A_WEAPON",1)  -- Сделать.
		entity:SelectPipe(0,"get_gun",entity.GoToPickup)
		entity:InsertSubpipe(0,"setup_stand")
		entity:InsertSubpipe(0,"do_it_running")
		entity:InsertSubpipe(0,"not_shoot")
		AI:EnablePuppetMovement(entity.id,1) -- Если была спокойная анимация и наёмник увидел цель, и попытался побежать к патронам...
	end,

	-- and everyone has to be able to respond to an invitation to join a group

	JoinGroup = function(self,entity,sender)
		entity:ChangeAIParameter(AIPARAM_GROUPID,AI:GetGroupOf(sender.id))
		entity.CurrentGroupID = AI:GetGroupOf(sender.id)  -- Для SetActualName.
		entity:SelectPipe(0,"AIS_LookForThreat")
	end,

	UNCONDITIONAL_JOIN = function(self,entity,sender)
		entity:ChangeAIParameter(AIPARAM_GROUPID,AI:GetGroupOf(sender.id))
		entity.CurrentGroupID = AI:GetGroupOf(sender.id)  -- Для SetActualName.
	end,


	ALARM_ON = function(self,entity,sender) -- Получили сигнал тревоги от кнопки,побежали к источнику! Сделать поиск цели сразу. Посылается как -1.
		if not entity.ANIMAL then
			if entity:ForbiddenCharacters() then do return end end
			if not entity.RunToTrigger then
				entity.alert_signal_sent = 1
				-- the team can split
				AI:Signal(0,-1,"WakeUp",entity.id)
				AI:Signal(0,-1,"WakeUp2",entity.id)
				AI:Signal(0,1,"REAL_ALARM_ON",entity.id)
				entity:SelectPipe(0,"investigate_alarm")
				AI:CreateGoalPipe("alarm_on_run_to_beacon")
				AI:PushGoal("alarm_on_run_to_beacon","scout_quickhide")
				AI:PushGoal("alarm_on_run_to_beacon","setup_stand")
				AI:PushGoal("alarm_on_run_to_beacon","do_it_running")
				-- AI:PushGoal("alarm_on_run_to_beacon","DropBeaconAt") -- form Нельзя формировать! Только на тот, который уже есть.
				AI:PushGoal("alarm_on_run_to_beacon","locate",0,"beacon")
				AI:PushGoal("alarm_on_run_to_beacon","not_shoot")
				AI:PushGoal("alarm_on_run_to_beacon","pathfind",1,"")
				AI:PushGoal("alarm_on_run_to_beacon","trace",1,1,0)
				AI:PushGoal("alarm_on_run_to_beacon","timeout",1,.1)
				AI:PushGoal("alarm_on_run_to_beacon","pathfind",1,"") -- Пожар.
				AI:PushGoal("alarm_on_run_to_beacon","trace",1,1,0)
				AI:PushGoal("alarm_on_run_to_beacon","just_shoot")
				AI:PushGoal("alarm_on_run_to_beacon","do_it_walking")
				entity:InsertSubpipe(0,"alarm_on_run_to_beacon",sender.id)
				-- entity:InsertSubpipe(0,"DropBeaconAt",sender.id)
				-- entity:InsertSubpipe(0,"scout_quickhide")
				-- Hud:AddMessage(entity:GetName()..": ALARM_ON, sender: "..sender:GetName())
				System:Log(entity:GetName()..": ALARM_ON, sender: "..sender:GetName())
				entity:GunOut()
			end
		end
		self:ALERT_SIGNAL(entity,sender)
	end,

	ALERT_SIGNAL = function(self,entity,sender) -- Сигнал, если кто-то нажал на кнопку тревоги. Всем остальным стоять наместе! Сделать, чтобы если подняли тревогу, то у помеченных на радаре тоже должно отразиться.
		if not entity.ANIMAL then
			if entity:ForbiddenCharacters() then do return end end
			if entity.Properties.species==sender.Properties.species then
				if not entity.alert_signal_sent and not entity.RunToTrigger and (entity~=sender) then
					entity.alert_signal_sent = 1
					entity:SelectPipe(0,"special_hold_position")  -- Сделать чтобы прятались, а потом смотрели по сторонам.
					entity:InsertSubpipe(0,"setup_stealth")
					AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"ALERT_SIGNAL",entity.id)
					entity:GettingAlerted()
					-- Hud:AddMessage(entity:GetName()..": ALERT_SIGNAL!!!")
					-- System:Log(entity:GetName()..": ALERT_SIGNAL!!!")
				end
			end
		end
	end,

	NORMAL_THREAT_SOUND = function(self,entity,sender) -- hide_on_threat_sound. Если будет продолжатья в атаке, то надо что-нибудь придумать.
		if entity.Properties.species==sender.Properties.species and not entity.RunToTrigger and not entity.ANIMAL then
			if entity:ForbiddenCharacters() then do return end end
			if not entity.THREAT_SOUND_SIGNAL_SENT then
				entity.THREAT_SOUND_SIGNAL_SENT = 1
				self:MyGroupWakeUp(entity)
				if entity~=sender and not entity.call_alarm_muted then -- Доработать, а то пробуждает союзников, но из-за entity~=sender не доходит.
					entity:MakeAlerted()
					entity:GunOut()
					entity:SelectPipe(0,"look_at_beacon2")
					entity:InsertSubpipe(0,"just_shoot")
					if not entity.cnt.proning and not entity.cnt.crouching then -- Чтобы позиция не менялась если есть одно из трёх.
						entity:InsertSubpipe(0,"setup_stand")
					end
					entity:InsertSubpipe(0,"hide_on_threat_sound")
					-- Hud:AddMessage(entity:GetName()..": NORMAL_THREAT_SOUND")
					-- System:Log(entity:GetName()..": NORMAL_THREAT_SOUND")
				end
			end
		end
	end,

	MAKE_ME_IGNORANT = function(self,entity,sender)
		AI:MakePuppetIgnorant(entity.id,1)
	end,

	MAKE_ME_UNIGNORANT = function(self,entity,sender)
		AI:MakePuppetIgnorant(entity.id,0)
	end,

	-- cool retreat tactic
	RETREAT_NOW = function(self,entity,sender)

		local retreat_spot = AI:FindObjectOfType(entity.id,100,AIAnchor.RETREAT_HERE)
		if (retreat_spot) then
			entity:SelectPipe(0,"retreat_to_spot",retreat_spot)
		else
			entity:SelectPipe(0,"retreat_back")
		end
		entity:Readibility("RETREATING_NOW",1)
	end,

	RETREAT_NOW_PHASE2 = function(self,entity,sender)

		local retreat_spot = AI:FindObjectOfType(entity.id,100,AIAnchor.RETREAT_HERE)
		if (retreat_spot) then
			entity:SelectPipe(0,"retreat_to_spot_phase2",retreat_spot)
		else
			entity:SelectPipe(0,"retreat_back_phase2")
		end

		entity:Readibility("RETREATING_NOW",1)
	end,

	PROVIDE_COVERING_FIRE = function(self,entity,sender)
		entity:SelectPipe(0,"just_shoot") -- dumb_shoot
		entity:Readibility("PROVIDING_COVER",1)
	end,

	-- cool rush tactic
	RUSH_TARGET = function(self,entity,sender) -- ИСПОЛЬЗОВАТЬ!
		entity:SelectPipe(0,"rush_player")
		entity:Readibility("AI_AGGRESSIVE_ATTENTION",1)
		-- Hud:AddMessage(entity:GetName()..": RUSH_TARGET")
		System:Log(entity:GetName()..": RUSH_TARGET")
	end,

	STOP_RUSH = function(self,entity,sender)
		entity:TriggerEvent(AIEVENT_CLEAR)
	end,

	PRE_START_SWIMMING = function(self,entity,sender) -- А если бежал к чему-то с entity.RunToTrigger?
		AI:MakePuppetIgnorant(entity.id,0)
		if entity.MUTANT or (entity.ANIMAL and entity.ANIMAL=="pig") then
			entity:InsertAnimationPipe("drown00",2,"NOW_DIE",.15,.8)
		else
			-- Hud:AddMessage(entity:GetName()..": REALLY_START_SWIMMING")
			-- System:Log(entity:GetName()..": REALLY_START_SWIMMING")
			AI:Signal(0,-1,"REALLY_START_SWIMMING",entity.id)
			entity.EventToCall = "MERC_START_SWIMMING"
			entity.cnt:HoldGun()
			entity.AI_GunOut = 1
		end
		-- entity.RunToTrigger = 1 -- Вот что с этим делать? Спорный вопрос.
	end,

	AFTER_SWIMMING_BEHAVIOUR = function(self,entity,sender)
		-- System:Log(entity:GetName()..": BEHAVIOUR: "..entity.Behaviour.Name..", DefaultBehaviour: "..entity.DefaultBehaviour)
		local IsJob = strfind(entity.Behaviour.Name,"Job_")
		local IsIdle = strfind(entity.Behaviour.Name,"Idle")
		if (IsJob or IsIdle) and not entity.WasInCombat and not entity.IsAiPlayer and not entity.IsSpecOpsMan and not entity:ForbiddenCharacters() then
			entity.NotReturnToIdleSay = 1
			entity:InsertSubpipe(0,"after_swimming_relax")
		else
			System:Log(entity:GetName()..": MERC_GO_ATTACK")
			AI:Signal(0,1,"MERC_GO_ATTACK",entity.id)
		end
	end,

	NOW_DIE = function(self,entity,sender) -- drown00
		entity:Event_Die(entity)
	end,

	SPECOPS_EXIT = function(self,entity,sender) -- Леад, фоллов, холд
		if not entity.IsSpecOpsMan then return end
		entity:SelectPipe(0,"AiPlayer_pindown")  -- Чтобы сразу атаковали, а не тупили некоторое время.
	end,

	GO_INTO_WAIT_STATE = function(self,entity,sender)
		entity:SelectPipe(0,"wait_state")
	end,

	SPECIAL_FOLLOW = function(self,entity,sender)
		-- if entity.AI_AtWeapon then
			AI:Signal(0,1,"RETURN_TO_NORMAL",entity.id)
		-- end
		entity.AI_SpecialBehaviour = "SPECIAL_FOLLOW"
		entity:SelectPipe(0,"val_follow")
		entity:Readibility("FOLLOWING_PLAYER",1)
		AI:MakePuppetIgnorant(entity.id,0)
	end,

	SPECIAL_GODUMB = function(self,entity,sender)
		-- if entity.AI_AtWeapon then
			AI:Signal(0,1,"RETURN_TO_NORMAL",entity.id)
		-- end
		if (entity.AI_DynProp) then
			entity.AI_DynProp.push_players = 0
			entity.AI_DynProp.pushable_by_players = 0
			entity.cnt:SetDynamicsProperties(entity.AI_DynProp)
		end
		entity.AI_SpecialBehaviour = "SPECIAL_GODUMB"
		entity:DoSomethingInteresting()
		AI:MakePuppetIgnorant(entity.id,1)
	end,

	SPECIAL_STOPALL = function(self,entity,sender)
		-- if entity.AI_AtWeapon then
			AI:Signal(0,1,"RETURN_TO_NORMAL",entity.id)
		-- end
		if entity.IsAiPlayer then return end
		entity.AI_SpecialBehaviour = nil
		--entity.EventToCall = "OnSpawn"
		-- Hud:AddMessage(entity:GetName()..": DEFAULT/SPECIAL_STOPALL")
		entity:SelectPipe(0,"standingthere")
		entity:InsertSubpipe(0,"just_shoot")
		-- Hud:AddMessage(entity:GetName()..": SPECIAL_STOPALL")
		AI:MakePuppetIgnorant(entity.id,0)
	end,

	SPECIAL_LEAD = function(self,entity,sender)
		-- if entity.AI_AtWeapon then
			AI:Signal(0,1,"RETURN_TO_NORMAL",entity.id)
		-- end
		entity.AI_SpecialBehaviour = "SPECIAL_LEAD"
		-- Hud:AddMessage(entity:GetName()..": DEFAULT/SPECIAL_LEAD")
		entity:SelectPipe(0,"standingthere")
		entity:InsertSubpipe(0,"just_shoot")
		entity.LEADING = nil
		entity.EventToCall = "OnCloseContact"
		entity:Readibility("LETS_CONTINUE",1)
		-- Hud:AddMessage(entity:GetName()..": SPECIAL_LEAD")
		AI:MakePuppetIgnorant(entity.id,0)
	end,

	SPECIAL_HOLD = function(self,entity,sender)
		-- if entity.AI_AtWeapon then
			AI:Signal(0,1,"RETURN_TO_NORMAL",entity.id)
		-- end
		entity.AI_SpecialBehaviour = "SPECIAL_HOLD"
		local spot = AI:FindObjectOfType(entity:GetPos(),50,AIAnchor.SPECIAL_HOLD_SPOT)
		if (spot==nil) then
			Hud:AddMessage("==========================UNACCEPTABLE ERROR====================")
			Hud:AddMessage("No SPECIAL_HOLD_SPOT anchor for entity "..entity:GetName())
			Hud:AddMessage("==========================UNACCEPTABLE ERROR====================")
		end
		entity:SelectPipe(0,"hold_spot",spot)
		AI:MakePuppetIgnorant(entity.id,0)
	end,


	CANNOT_RESUME_SPECIAL_BEHAVIOUR = function(self,entity,sender)
		if (entity.AI_SpecialBehaviour) then
			entity:Readibility("THERE_IS_STILL_SOMEONE",1)
		end
	end,

	RESUME_SPECIAL_BEHAVIOUR = function(self,entity,sender)
		if (entity.AI_SpecialBehaviour) then
			entity:TriggerEvent(AIEVENT_CLEARSOUNDEVENTS)
			AI:Signal(0,1,entity.AI_SpecialBehaviour,entity.id)
		end
	end,

	--- Everyone is now able to respond to reinforcements

	AISF_CallForHelp = function(self,entity,sender)  -- Доделать!
		local guy_should_reinforce = AI:FindObjectOfType(entity.id,10,AIAnchor.RESPOND_TO_REINFORCEMENT)  -- 5 -- Те, до кому надоел этот якорь присоединяются к группе и атакуют врага. должны
		if (guy_should_reinforce) then
			-- Hud:AddMessage(entity:GetName()..": guy_should_reinforce")
			--AI:Signal(0,1,"SWITCH_TO_RUN_TO_FRIEND",entity.id)  -- RunToFriend
			entity:MakeAlerted()
			entity:SelectPipe(0,"cover_beacon_pindown")  -- FINISH_RUN_TO_FRIEND
			entity:InsertSubpipe(0,"offer_join_team_to",sender.id)
			-- System:Log(entity:GetName()..": AISF_CallForHelp")
		end
	end,



	APPLY_IMPULSE_TO_ENVIRONMENT = function(self,entity,sender)
		entity:InsertAnimationPipe("kick_barrel")
		entity.ImpulseParameters.pos = entity:GetPos()
		entity.ImpulseParameters.pos.z = entity.ImpulseParameters.pos.z-1
		entity:ApplyImpulseToEnvironment(entity.ImpulseParameters)
	end,


	OnVehicleDanger = function(self,entity,sender)
		entity:InsertSubpipe(0,"backoff_from_lastop",sender.id)
	end,

	HIDE_END_EFFECT = function(self,entity,sender)
		entity:StartAnimation(0,"rollfwd",4)
	end,

	Smoking = function(self,entity,sender)
		entity.EventToCall = "OnSpawn"
	end,

	YOU_ARE_BEING_WATCHED = function(self,entity,sender)

	end,

	SELECT_IDLE = function(self,entity,sender)
		-- if not entity.NoRTIAnim then entity.NoRTIAnim = 0  end
		-- if not entity.NotReturnToIdleSay then entity.NotReturnToIdleSay = 0  end
		-- Hud:AddMessage(entity:GetName()..": entity.NotReturnToIdleSay: "..entity.NotReturnToIdleSay.." entity.NoRTIAnim: "..entity.NoRTIAnim)
		-- System:Log(entity:GetName()..": entity.NotReturnToIdleSay: "..entity.NotReturnToIdleSay.." entity.NoRTIAnim: "..entity.NoRTIAnim)
		-- if entity.NoRTIAnim==0 then entity.NoRTIAnim = nil  end
		-- if entity.NotReturnToIdleSay==0 then entity.NotReturnToIdleSay = nil  end
		if entity.NoRTIAnim or entity.MUTANT or entity.IsSpecOpsMan then
			-- entity.NoRTIAnim = nil
			AI:Signal(0,1,"RETURN_TO_FIRST",entity.id)
			do return end
		end
		entity:SelectPipe(0,"disturbance_let_it_go")  -- RETURN_TO_IDLE  RETURN_TO_FIRST.
		local weapon = entity.cnt.weapon
		if weapon and weapon.name~="Falcon" and entity.PropertiesInstance.bGunReady==0 then
			if entity.fireparams and entity.fireparams.fire_mode_type and entity.fireparams.fire_mode_type==FireMode_Melee then return end
			entity:InsertSubpipe(0,"HOLSTER_GUN")
		end
	end,

	RETURN_TO_IDLE = function(self,entity,sender)
		entity:TriggerEvent(AIEVENT_CLEAR)
		if entity.allow_idle then entity.allow_idle = nil do return end end
		if entity.NotReturnToIdleSay then entity.NotReturnToIdleSay = nil do return end end
		if not entity.WasInCombat then
			if (entity:GetGroupCount() > 1) then
				if random(1,2)==1 then
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_NORMAL,"INTERESTED_TO_IDLE_GROUP",entity.id)
				else
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_NORMAL,"INTERESTED_TO_IDLE",entity.id)
				end
			else
				AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_NORMAL,"INTERESTED_TO_IDLE",entity.id)
			end
		end
	end,

	RETURN_TO_FIRST = function(self,entity,sender)
		entity.FirstState=1  -- Чтобы обнулить права на поиск и возвращение в спокойное состояние.
		entity.EventToCall = "OnSpawn"  -- Выполнить событие, которое располагается в состоянии, на которое сейчас произойдёт переключение (FIRST, работа).
	end,

	OFFER_JOIN_TEAM  = function(self,entity,sender)
		if (entity~=sender) then
			if (AI:GetGroupOf(entity.id)~=AI:GetGroupOf(sender.id)) then
				entity:ChangeAIParameter(AIPARAM_GROUPID,AI:GetGroupOf(sender.id))
				entity.CurrentGroupID = AI:GetGroupOf(sender.id)  -- Для SetActualName.
			end
		end
	end,


	SELECT_RED = function(self,entity,sender)
		-- team leader instructs group to split
		if (sender) then
			if not sender.redteammembers then sender.redteammembers = 0 end -- Вообще, такие переменные нужно сохранять.
			sender.redteammembers = sender.redteammembers + 1
		end
		entity:MakeAlerted()
		entity:SelectPipe(0,"look_at_beacon")

	end,

	SELECT_BLACK = function(self,entity,sender)
		-- team leader instructs group to split
		if sender then
			if not sender.blackteammembers then sender.blackteammembers = 0 end -- Вообще, такие переменные нужно сохранять.
			sender.blackteammembers = sender.blackteammembers + 1
		end
		entity:MakeAlerted()
		entity:SelectPipe(0,"look_at_beacon")
	end,

	SHARED_RELOAD = function(self,entity,sender)
		if (entity.cnt) then
			if (entity.cnt.ammo_in_clip) then
				-- if entity.IsAiPlayer then
					-- Hud:AddMessage(entity:GetName()..": SHARED_RELOAD 1")
					-- System:Log(entity:GetName()..": SHARED_RELOAD 1")
				-- end
				if (entity.cnt.ammo_in_clip > 5 and not entity.ForceReload) then
					do return end
				end
				-- if entity.IsAiPlayer then
					-- Hud:AddMessage(entity:GetName()..": SHARED_RELOAD 2")
					-- System:Log(entity:GetName()..": SHARED_RELOAD 2")
				-- end
			end
		end
		AI:CreateGoalPipe("reload_timeout")
		AI:PushGoal("reload_timeout","timeout",1,entity:GetAnimationLength("reload"))
		entity:InsertSubpipe(0,"reload_timeout")
		entity:StartAnimation(0,"reload",4)
--		if (entity:GetGroupCount() > 1) then
--			AI:Signal(SIGNALID_READIBILITY,1,"RELOADING",entity.id)
--		end
		entity.ForceReload = 1 -- Из-за разных проверок на количество патронов тут и там, - в БП релоаде, - проигрывается анимация перезярядки, но перезарядки нет, зато исключение, - форс релоад, - есть тут и там.
		BasicPlayer.Reload(entity)
	end,

	SHARED_GRANATE_THROW_ANIM = function(self,entity,sender)
		-- Hud:AddMessage(entity:GetName()..": SHARED_GRANATE_THROW_ANIM")
		-- System:Log(entity:GetName()..": SHARED_GRANATE_THROW_ANIM")
		AI:EnablePuppetMovement(entity.id,0,4)
		entity:StartAnimation(0,"grenade",4)
		local anim_dur = entity:GetAnimationLength("grenade")
		entity:TriggerEvent(AIEVENT_ONBODYSENSOR,anim_dur)
		entity.TimeToThrowGrenade=1 -- По истечении этих секунд заспавнится граната. C++
		-- entity:InsertAnimationPipe("grenade",4,"ThrowGrenade")
		entity.ThrowGrenadeTime = _time+entity.TimeToThrowGrenade
	end,

	STOP_THROW = function(self,entity,sender)
		entity.AiThrowGrenade=nil
	end,

	ThrowGrenade = function(self,entity,sender) -- Бросить гранату, только спавн, без анимации, без задержки во времени.
		Hud:AddMessage(entity:GetName()..": ThrowGrenade")
		System:Log(entity:GetName()..": ThrowGrenade")
		entity.AI_Throw_Grenade=1 -- Сделал сместо сигнала C++. Просто, сразу спавн.
	end,

	DisableMovement = function(self,entity,sender)
		AI:EnablePuppetMovement(entity.id,0) -- Чего то так не останавливает.
		-- Hud:AddMessage(entity:GetName()..": 0")
	end,

	EnableMovement = function(self,entity,sender)
		AI:EnablePuppetMovement(entity.id,1)
		-- Hud:AddMessage(entity:GetName()..": 1")
	end,


	THROW_FLARE = function(self,entity,sender)
 		if (sender.id==entity.id) then
			entity:InsertSubpipe(0,"throw_flare")
 		end
	end,

	THROW_SMOKE = function(self,entity,sender)
		entity:GrenadeAttack(3)
	end,

	THROW_HANDGRENADE = function(self,entity,sender)
		entity:GrenadeAttack(2)
	end,

	THROW_FLASHBANG = function(self,entity,sender)
		entity:GrenadeAttack(5)
	end,

	THROW_SAFETYPE = function(self,entity,sender)
		entity:GrenadeAttack(6)
	end,

	SWITCH_GRENADE_TYPE = function(self,entity,sender)
		BasicPlayer.SelectGrenade(entity,"HandGrenade")
	end,

	SHARED_PLAYLEFTROLL = function(self,entity,sender)
		entity:StartAnimation(0,"rollleft",3)
	end,

	SHARED_PLAYRIGHTROLL = function(self,entity,sender)
		entity:StartAnimation(0,"rollright",3)
	end,


	SHARED_TAKEOUTPIN = function(self,entity,sender)
		entity:StartAnimation(0,"signal_inposition",3)
	end,

	------------------------------ Animation -------------------------------
	death_recognition = function(self,entity,sender)
		local rnd = random(1,3)
		if (rnd==1) then
			entity:StartAnimation(0,"death_recognition1")
		elseif (rnd==2) then
			entity:StartAnimation(0,"death_recognition2")
		elseif (rnd==3) then
			entity:StartAnimation(0,"death_recognition3")
		end
	end,

	PlayRollLeftAnim = function(self,entity,sender)
		entity:StartAnimation(0,"rollleft",3)
	end,

	PlayRollRightAnim = function(self,entity,sender)
		entity:StartAnimation(0,"rollright",3)
	end,

	SHARED_ENTER_ME_VEHICLE = function(self,entity,sender,MountedGunUser) -- Копия в InVehicle.lua.
		-- Hud:AddMessage(entity:GetName()..": Vehicle 1: "..sender:GetName())
		-- System:Log(entity:GetName()..": Vehicle 1: "..sender:GetName())
		if not entity.RunToTrigger and not entity.ANIMAL then -- entity.RunToTrigger = 1 без оптимизации не ставить, иначе второй раз садиться не будут. Ещё, необходимо подстроить под союзников.
			if not entity.ai then return nil end
			local vehicle = sender
			-- Hud:AddMessage(entity:GetName()..": Vehicle 2: "..vehicle:GetName())
			-- System:Log(entity:GetName()..": Vehicle 2: "..vehicle:GetName())
			if vehicle then
				-- Hud:AddMessage(entity:GetName()..": Vehicle 3: "..vehicle:GetName())
				-- System:Log(entity:GetName()..": Vehicle 3: "..vehicle:GetName())
				-- System:Log(entity:GetName()..": sender 1: "..vehicle:GetName())
				-- not enter hevicle if there is a human driver inside
				-- if vehicle.driverT and vehicle.driverT.entity and not vehicle.driverT.entity.ai then return end
				if vehicle.driverT and vehicle.driverT.entity and vehicle.driverT.entity.Properties and vehicle.driverT.entity.Properties.species~=entity.Properties.species then return nil end
				if vehicle.gunnerT and vehicle.gunnerT.entity and vehicle.gunnerT.entity.Properties and vehicle.gunnerT.entity.Properties.species~=entity.Properties.species then return nil end
				self:SPECIAL_STOPALL(entity,sender) -- Ниже вставлять нельзя. Иногда проскакивает при попытке сесть в транспорт, иногда, получается остаётся standingthere.
				-- System:Log(entity:GetName()..": sender 2: "..sender:GetName())
				-- Hud:AddMessage(entity:GetName()..": Vehicle 4: "..vehicle:GetName())
				-- System:Log(entity:GetName()..": Vehicle 4: "..vehicle:GetName())
				if vehicle.AddDriver and vehicle:AddDriver(entity)==1 then				-- try to be driver -- Может через OR сделать?
					-- System:Log(entity:GetName()..": sender 3: "..sender:GetName())
					entity.RunToTrigger = 1
					AI:Signal(0,1,"entered_vehicle",entity.id)
					return 1
				end
				-- Hud:AddMessage(entity:GetName()..": Vehicle 5: "..vehicle:GetName())
				-- System:Log(entity:GetName()..": Vehicle 5: "..vehicle:GetName())
				if MountedGunUser then entity.VehicleMountedGunUser = 1 end
				if vehicle.AddGunner and vehicle:AddGunner(entity)==1 then		-- if not driver - try to be gunner
					-- System:Log(entity:GetName()..": sender 4: "..sender:GetName())
					entity.RunToTrigger = 1
					AI:Signal(0,1,"entered_vehicle",entity.id)
					return 1
				end
				-- Hud:AddMessage(entity:GetName()..": Vehicle 6: "..vehicle:GetName())
				-- System:Log(entity:GetName()..": Vehicle 6: "..vehicle:GetName())
				if MountedGunUser then entity.VehicleMountedGunUser = nil end
				if vehicle.AddPassenger and vehicle:AddPassenger(entity)==1 then				-- if not gunner - try to be passenger
					-- System:Log(entity:GetName()..": sender 5: "..sender:GetName())
					entity.RunToTrigger = 1
					AI:Signal(0,1,"entered_vehicle",entity.id)
					return 1
				end
			end
		end
	end,
	
	FORCE_GET_IN_VEHICLE = function(self,entity,sender)
		if entity.theVehicle then
			Hud:AddMessage(entity:GetName()..": DEFAULT/FORCE_GET_IN_VEHICLE/InitEntering"..entity.theVehicle:GetName())
			System:Log(entity:GetName()..": DEFAULT/FORCE_GET_IN_VEHICLE/InitEntering"..entity.theVehicle:GetName())
			entity.theVehicle:InitEntering()
		end
	end,

	at_boatenterspot = function(self,entity,sender)
		if entity.theVehicle then
			entity.theVehicle:DoEnter(entity)
			System:Log(">>>>>>>>>>> DEFAULT  at_boatenterspot "..entity:GetName().."  "..entity.theVehicle:GetName())
		else
			System:Log(">>>>>>>>>>> DEFAULT  at_boatenterspot "..entity:GetName().."  ERROR: NO VEHICLE!!!")
		end
		-- end
		-- entity:StartAnimation(0,"arm_on_shoulder",1,.4)
	end,


	OnNoAmmo = function(self,entity,sender) -- Использовать.
		Hud:AddMessage(entity:GetName()..": DEFAULT/OnNoAmmo")
		System:Log(entity:GetName()..": DEFAULT/OnNoAmmo")
--		entity.cnt:SelectNextWeapon()
	end,

	------------------------------------------------------
	-- ANIMATION CONTROL FOR GETTING DOWN AND UP BETWEEN STANCES
	DEFAULT_CURRENT_TO_CROUCH = function(self,entity,sender)
		-- this doesn't have an animation from any stance
	end,
	------------------------------------------------------
	DEFAULT_CURRENT_TO_PRONE = function(self,entity,sender)
		-- this doesn't have an animation from crouch
		if ((entity.cnt.crouching==nil) and (entity.cnt.proning==nil)) then
			-- the guy was standing,so play animation getdown
			entity:StartAnimation(0,"pgetdown")
		end
	end,
	------------------------------------------------------
	DEFAULT_CURRENT_TO_STAND = function(self,entity,sender)
		-- this doesn't have an animation from crouch
		if (entity.cnt.proning) then
			entity:StartAnimation(0,"pgetup")
		end
	end,
	------------------------------------------------------
	DEFAULT_GO_KNEEL = function(self,entity,sender)
		-- this doesn't have an animation from any stance
	--	if ((entity.cnt.crouching==nil) and (entity.cnt.proning==nil)) then
			-- the guy was standing,so play animation to kneeldown

			entity:StartAnimation(0,"kneel_start",2)
			entity:StartAnimation(0,"kneel_idle_loop")
	--	end
	end,
	------------------------------------------------------
	DEFAULT_UNKNEEL = function(self,entity,sender)
		-- this doesn't have an animation from any stance
	--	if ((entity.cnt.crouching==nil) and (entity.cnt.proning==nil)) then
			entity:StartAnimation(0,"sidle")
			entity:StartAnimation(0,"kneel_end",2)
	--	end
	end,
	------------------------------------------------------

	GO_REFRACTIVE  = function(self,entity,sender)
		entity:GoRefractive()
	end,
	------------------------------------------------------
	GO_VISIBLE  = function(self,entity,sender)
		entity:GoVisible()
	end,

	------------------------------------------------------
	-- special Harry-urgent-needed-blind-behaviour-hack --
	------------------------------------------------------
	LIGHTS_OFF = function(self,entity,sender)
		entity:ChangeAIParameter(AIPARAM_SIGHTRANGE,.1)
	end,
	------------------------------------------------------
	LIGHTS_ON = function(self,entity,sender)
		entity:ChangeAIParameter(AIPARAM_SIGHTRANGE,entity.PropertiesInstance.sightrange)
	end,

	APPLY_MELEE_DAMAGE = function(self,entity,sender)
--		if (entity.cnt.melee_attack==nil) then
--			entity.cnt.melee_attack = 1
--			local target = AI:GetAttentionTargetOf(entity.id)
--			if (type(target)=="table") then
--				entity.cnt.melee_target = target
--			else
--				entity.cnt.melee_target = nil
--			end
--			if (entity.ImpulseParameters) then
--				entity.ImpulseParameters.pos = entity:GetPos()
--				local power = entity.ImpulseParameters.impulsive_pressure
--				entity.ImpulseParameters.impulsive_pressure=2000
--				entity:ApplyImpulseToEnvironment(entity.ImpulseParameters)
--				entity.ImpulseParameters.impulsive_pressure=power
--			end
--		end
	end,

	RESET_MELEE_DAMAGE = function(self,entity,sender)
--		if (entity.cnt.melee_attack) then
--			entity.cnt.melee_attack = nil
--		end
	end,

	MUTANT_SELECT_IDLE = function(self,entity,sender) -- переделать
		entity:SelectPipe(0,"mutant_idling")
	end,

	MUTANT_PLAY_IDLE_ANIMATION = function(self,entity,sender)
		local rnd = random(1,15)

		if (rnd>13) then
			entity:SelectPipe(0,"mutant_random_walk")
		elseif (rnd>10) then
			entity:SelectPipe(0,"mutant_random_look")
		else
			local MyAnim = Mutant_IdleManager:GetIdle(entity)
			if (MyAnim) then
				entity:InsertAnimationPipe(MyAnim.Name)
			end
		end
	end,

	HIDE_GUN = function(self,entity)
		entity.cnt:DrawThirdPersonWeapon(0)
	end,

	UNHIDE_GUN = function(self,entity)
		entity.cnt:DrawThirdPersonWeapon(1)
	end,


	SHARED_DRAW_GUN_ANIM = function(self,entity)
		if entity.cnt.weapon then
			if not entity.AI_GunOut then
				if entity.DRAW_GUN_ANIM_COUNT then
					local rnd=random(1,entity.DRAW_GUN_ANIM_COUNT)
					local anim_name = format("draw%02d",rnd)
					-- entity:StartAnimation(0,anim_name,2)
					entity:InsertAnimationPipe(anim_name,2)
					local anim_dur = entity:GetAnimationLength(anim_name)
					entity:TriggerEvent(AIEVENT_ONBODYSENSOR,anim_dur) -- Не стрелять некоторое время.
					AI:EnablePuppetMovement(entity.id,0,anim_dur)
					entity.AI_GunOut = 1
					-- Hud:AddMessage(entity:GetName()..":AI_GunOut = 1")
				end
			end
		end
	end,

	SHARED_HOLSTER_GUN_ANIM = function(self,entity)
		if entity.cnt.weapon then
			if entity.AI_GunOut then
				if entity.HOLSTER_GUN_ANIM_COUNT then
					local rnd=random(1,entity.HOLSTER_GUN_ANIM_COUNT)
					local anim_name = format("holster%02d",rnd)
					-- entity:StartAnimation(0,anim_name,2)
					entity:InsertAnimationPipe(anim_name,2)
					local anim_dur = entity:GetAnimationLength(anim_name)
					AI:EnablePuppetMovement(entity.id,0,anim_dur)
				end
			end
		end
		entity.AI_GunOut = nil
	end,

	SHARED_REBIND_GUN_TO_HANDS = function(self,entity)
		--entity.cnt:HoldGun()
		--AI:MakePuppetIgnorant(entity.id,0)
		entity.AI_GunOut = 1
	end,

	SHARED_REBIND_GUN_TO_BACK = function(self,entity)
		--entity.cnt:HolsterGun()
		--AI:MakePuppetIgnorant(entity.id,0)
		entity.AI_GunOut = nil
	end,


	DO_THREATENED_ANIMATION = function(self,entity,sender) -- Анимация,когда боец,садится на корточки и осматривается по сторонам.
		local rnd = random(1,3)
		entity:InsertAnimationPipe("_surprise0"..rnd,3)
		local anim_dur = entity:GetAnimationLength("_surprise0"..rnd)
		entity:TriggerEvent(AIEVENT_ONBODYSENSOR,anim_dur)
		AI:EnablePuppetMovement(entity.id,0,anim_dur)
	end,

	SHARED_PLAY_CURIOUS_ANIMATION = function(self,entity,sender)

		local rnd = random(1,2)
		entity:InsertAnimationPipe("_curious"..rnd)
	end,

	FLASHLIGHT_ON = function(self,entity,sender)
		entity.cnt:SwitchFlashLight(1)
		entity:ChangeAIParameter(AIPARAM_SIGHTRANGE,entity.PropertiesInstance.sightrange*3)
		entity:ChangeAIParameter(AIPARAM_FOV,60)
		entity.CurrentHorizontalFov=60
	end,

	FLASHLIGHT_OFF  = function(self,entity,sender)
		entity.cnt:SwitchFlashLight(0)
		entity:ChangeAIParameter(AIPARAM_SIGHTRANGE,entity.PropertiesInstance.sightrange)
		entity:ChangeAIParameter(AIPARAM_FOV,entity.Properties.horizontal_fov)
	end,

	DO_SOMETHING_IDLE = function(self,entity,sender)
		entity:CheckFlashLight()
		if not entity.OnConversationFinishedStart then
			if random(1,20)==1 then
				if entity:MakeMissionConversation(1) then -- Находясь там, где и находятся.
					do return end
				end
			else
				if entity:MakeMissionConversation() then
					do return end
				end
			end
		end
		if entity:MakeRandomConversation() then		-- try talking to someone -- Отключу по якорю, итак шибко общаются. Вернул, по entity:MakeRandomConversation(1) не на всех уровнях в тему и разговаривают очень громко.
			do return end
		end
		if entity:DoSomethingInteresting() then		-- piss, smoke or whatever
			do return end
		end
		-- always make at least an animation :)
		entity:MakeRandomIdleAnimation()  		-- make idle animation
		-- if random(1,20)==1 then
			-- if entity:MakeMissionConversation(1) then
				-- do return end
			-- end
		-- end
		-- if random(1,20)==1 then
			-- if entity:MakeRandomConversation(1) then
				-- do return end
			-- end
		-- end
	end,

	GO_IDLE = function(self,entity) -- talk_patrol_approach_to
		entity.OnConversationFinishedStart = nil
		AIBehaviour.Job_StandIdle:OnSpawn(entity)
		if entity.Behaviour["OnJobContinue"] then
			entity.Behaviour:OnJobContinue(entity)
		end
	end,
	
	CROWE_ONE = function(self,entity) -- Job_CroweOne
		entity.EventToCall = "OnPlayerSeen"
	end,

	CONVERSATION_START = function(self,entity,sender) -- ComeToMe/simple_approach_to2
		if entity.CurrentConversation and not entity.RunToTrigger and not entity.SetAlerted and not entity.WasInCombat and entity.sees==0
		and entity.not_sees_timer_start==0 then
			entity.CurrentConversation:Start(entity)
		end
	end,

	PRE_CONVERSATION_REQUEST = function(self,entity,sender)
		if not entity.CurrentConversation and not entity.RunToTrigger and not entity.SetAlerted and not entity.MUTANT and not entity.ANIMAL
		and not entity.WasInCombat and sender and entity~=sender and entity.Properties.species==sender.Properties.species
		and entity.sees==0 and entity.not_sees_timer_start==0 and sender.CurrentConversation and sender.CurrentConversation.Join then
			sender.CurrentConversation:Join(entity)
		end
	end,

	MAKE_RANDOM_IDLE_ANIMATION = function(self,entity,sender)
		if not AI:IsMoving(entity.id) and random(1,2) then
			entity:MakeRandomIdleAnimation()
		end
	end,

	RANDOM_IDLE_SOUND = function(self,entity,sender)
		if entity.CurrentConversation then return end
		-- Hud:AddMessage("GOLOS "..entity:GetName())
		-- System:Log("GOLOS "..entity:GetName())
		entity:Readibility("RANDOM_IDLE_SOUND",1)
		AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_NONE,"RANDOM_IDLE_SOUND",entity.id)
	end,

	MAKE_STUNNED_ANIMATION = function(self,entity,sender)
		if (entity.BLINDED_ANIM_COUNT) then
			local rnd = random(0,entity.BLINDED_ANIM_COUNT)
			local anim_name = format("blind%02d",rnd)
			entity:InsertAnimationPipe(anim_name,4)
			local dur = entity:GetAnimationLength(anim_name)
			AI:EnablePuppetMovement(entity.id,0,dur+3) 	-- added the timeouts in the pipe
			entity:TriggerEvent(AIEVENT_ONBODYSENSOR,dur+3)
		else
			Hud:AddMessage("==================UNACCEPTABLE ERROR====================")
			Hud:AddMessage("Entity "..entity:GetName().." tried to make blinded anim,but no blindXX anims for his character.")
			Hud:AddMessage("==================UNACCEPTABLE ERROR====================")
		end
	end,

	FLASHBANG_GRENADE_EFFECT = function(self,entity,sender)
		if (entity.ai) then
			entity:InsertSubpipe(0,"stunned")
			entity:Readibility("FLASHBANG_GRENADE_EFFECT",1)
		end
	end,

	MAKE_ALARM = function(self,entity,sender)
		entity:RunToAlarm()
	end,

	SHARED_BLINDED = function(self,entity,sender) -- C++ Когда слепит фонарём. Сделал доступным sender, но иногда, во избежание критической ошибки, может посылаться без него.
		-- Hud:AddMessage(entity:GetName()..": SHARED_BLINDED "..sender:GetName())
		-- if entity.Properties.species~=sender.Properties.species and entity.WasInCombat then
		if entity.WasInCombat then -- А то можно иногда увидеть как один ИИ слепит другого в мирное время.
			if not entity.TempIsBlinded then
				entity.TempIsBlinded=_time
				entity:MakeAlerted()
				if not entity.IsAiPlayer and not entity.IsSpecOpsMan and entity.Properties.special~=1 then -- Чтобы своего случайно не подстрелил. Например, меня в лифте.
					entity:InsertSubpipe(0,"dumb_shoot")
				end
				-- entity:Readibility("FLASHBANG_GRENADE_EFFECT",1)  -- Доделать.
			end
			-- Hud:AddMessage(entity:GetName()..": SHARED_BLINDED "..sender:GetName())
			-- System:Log(entity:GetName()..": SHARED_BLINDED "..sender:GetName())
		end
	end,

	SHARED_UNBLINDED = function(self,entity,sender) -- После выхода из состояния слепоты.
		entity:StartAnimation(0,"NULL",4)  -- Обнуляет действие анимации ослепления.
		-- Hud:AddMessage(entity:GetName()..": SHARED_UNBLINDED")
		-- System:Log(entity:GetName()..": SHARED_UNBLINDED")
	end,

	SHARED_PLAY_GETDOWN_ANIM = function(self,entity,sender)
		local rnd= random(1,2)
		entity:InsertAnimationPipe("duck"..rnd.."_down",3)
	end,

	SHARED_PLAY_GETUP_ANIM = function(self,entity,sender)
		local rnd= random(1,2)
		entity:InsertAnimationPipe("duck"..rnd.."_up",3)
	end,

	SHARED_PLAY_DAMAGEAREA_ANIM = function(self,entity,sender)
		local rnd= random(1,2)
		entity:InsertAnimationPipe("duck"..rnd.."_up",3)
	end,

	exited_vehicle = function(self,entity,sender)
		AI:Signal(0,1,"really_exited_vehicle",entity.id)
--		AI:Signal(SIGNALID_READIBILITY,2,"AI_AGGRESSIVE",entity.id)
--		entity.EventToCall = "OnSpawn"
		AI:Signal(0,1,"OnSpawn",entity.id)
		Hud:AddMessage(entity:GetName()..": DEFAULT/exited_vehicle/OnSpawn")
	end,

	select_gunner_pipe = function(self,entity,sender)
		entity:SelectPipe(0,"h_gunner_fire")
	end,

}