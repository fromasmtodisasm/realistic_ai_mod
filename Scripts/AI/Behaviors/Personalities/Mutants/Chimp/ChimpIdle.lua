-- Created By: Petar
AIBehaviour.ChimpIdle = {
	Name = "ChimpIdle",
	OnSpawn = function(self,entity)
	end,

	OnNoTarget = function(self,entity)
		-- AI:Signal(0,1,"ANY_MORE_TO_RELEASE",entity.id)
		self:ANY_MORE_TO_RELEASE(entity)
		entity:InsertSubpipe(0,"predator_is_visible")
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		-- Hud:AddMessage(entity:GetName()..": Name: "..AIBehaviour.ChimpIdle.Name) -- Хорошо, а как пропустить "ChimpIdle" и перейти сразу к "Name"?
		entity.scared_signal = 1
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:SelectPipe(0,"predator_just_attack")
		entity:InsertSubpipe(0,"predator_is_invisible")
		AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY(entity)
		if entity:GetGroupCount() > 1 then
			AIBehaviour.DEFAULT:HEADS_UP_GUYS_GROUP(entity)
		end
		-- local SetAngle = entity.Properties.fJumpAngle
		-- entity.Properties.fJumpAngle = 38
		-- entity.TEMP_RESULT = entity:MutantJump(AIAnchor.MUTANT_JUMP_SMALL,20)
		-- entity.Properties.fJumpAngle=SetAngle

		-- -- bellow and howl
		-- if (entity.TEMP_RESULT==nil) then
			-- entity:InsertSubpipe(0,"jump_decision")
		-- end
	end,

	OnSomethingSeen = function(self,entity,fDistance)
		if random(1,5)==1 then
			entity:SelectPipe(0,"predator_interested")
		else
			entity:SelectPipe(0,"predator_wait_for_target")
		end
		entity:InsertSubpipe(0,"brief_invisibility")
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
	end,

	OnInterestingSoundHeard = function(self,entity,fDistance)
		if random(1,5)==1 then
			entity:SelectPipe(0,"predator_wait_for_target")
		else
			entity:SelectPipe(0,"predator_interested")
		end
		entity:InsertSubpipe(0,"brief_invisibility")
	end,

	OnThreateningSoundHeard = function(self,entity,fDistance)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if random(1,5)==1 then
			entity:SelectPipe(0,"predator_hide_wait_serach")
		else
			entity:SelectPipe(0,"predator_threatening")
		end
		if fDistance>60 then
			entity:InsertSubpipe(0,"brief_invisibility")
		else
			entity:InsertSubpipe(0,"predator_is_invisible")
		end
	end,

	OnNoHidingPlace = function(self,entity,sender)
	end,

	-- OnGrenadeSeen = function(self,entity,fDistance)
		-- entity:SelectPipe(0,"predator_avoiding_grenade")
		-- entity:InsertSubpipe(0,"brief_invisibility")
	-- end,
	
	-- OnGrenadeSeen_Flying = function(self,entity,sender)
		-- self:OnGrenadeSeen(entity)
	-- end,

	-- OnGrenadeSeen_Colliding = function(self,entity,sender)
		-- self:OnGrenadeSeen(entity)
	-- end,

	OnReceivingDamage = function(self,entity,sender)
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"PREDATOR_SCARED",entity.id)
		entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)
	end,

	OnBulletRain = function(self,entity,sender)
		entity:ChangeAIParameter(AIPARAM_COMMRANGE,5)
		self:OnReceivingDamage(entity)
	end,

	-- MAKE_BELLOW_HOWL_ANIMATION = function(self,entity,sender)
		-- entity:InsertAnimationPipe("idle05")
	-- end,

	OnCloseContact = function(self,entity,sender) -- Вроде как в состоянии атаки, а использует функцию отсюда...
		-- Hud:AddMessage(entity:GetName()..": OnCloseContact")
		-- System:Log(entity:GetName()..": OnCloseContact")
		-- entity:InsertSubpipe(0,"AcqBeacon",sender.id) -- Не, такое в idle ставить нельзя, иначе будет быстро прыгать))
		-- if entity.Properties.species~=sender.Properties.species then
			-- AI:MakePuppetIgnorant(entity.id,0)
		-- end
		entity:ChangeAIParameter(AIPARAM_FOV,entity.Properties.horizontal_fov)
	end,

	OnDeath = function(self,entity,sender)
		AIBehaviour.DEFAULT:OnDeath(entity,sender)
		self:OnSomethingDiedNearest(entity,sender)
	end,

	OnSomethingDiedNearest = function(self,entity,sender)
		entity:ChangeAIParameter(AIPARAM_COMMRANGE,15)
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"PREDATOR_SCARED",entity.id)
		entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)
	end,

	HEADS_UP_GUYS = function(self,entity,sender)
		if entity.ForceSenderId then sender=System:GetEntity(entity.ForceSenderId) entity.ForceSenderId=nil end
		AIBehaviour.DEFAULT:AllWakeUp(entity)
		if entity~=sender then
			-- entity:SelectPipe(0,"run_to_beacon")
			entity:SelectPipe(0,"predator_attack_pathfind")
			-- local SetAngle = entity.Properties.fJumpAngle
			-- entity.Properties.fJumpAngle = 45
			-- entity:MutantJump(AIAnchor.MUTANT_JUMP_SMALL,20)
			-- entity.Properties.fJumpAngle=SetAngle
		end
		entity:InsertSubpipe(0,"predator_is_invisible")
		-- entity.EventToCall = "OnPlayerSeen"  -- Взывает уже сразу после переключения в другое состояние.
	end,

	MAKE_COMBAT_BREAK_ANIM = function(self,entity,sender)
		if (entity.COMBAT_IDLE_COUNT) then
			local rnd = random(0,entity.COMBAT_IDLE_COUNT)
			local idle_anim_name = format("combat_idle%02d",rnd)
			entity:InsertAnimationPipe(idle_anim_name,3)
		else
			Hud:AddMessage("============UNACCEPTABLE ERROR===================")
			Hud:AddMessage("[ASSETERROR] No combat idles for "..entity:GetName())
			Hud:AddMessage("============UNACCEPTABLE ERROR===================")
		end
	end,

	SEEK_JUMP_ANCHOR = function(self,entity,sender) -- Доделать.
		-- -- local att_target = AI:GetAttentionTargetOf(entity.id)
		-- -- if (att_target) then
			-- -- if (type(att_target)=="table") then
				-- -- if (att_target==_localplayer) then
					-- -- entity:MutantJump(AIOBJECT_PLAYER,13)
				-- -- else
					-- -- entity:MutantJump(AIOBJECT_PUPPET,10)
				-- -- end
			-- -- end
		-- -- end
		-- local SetAngle = entity.Properties.fJumpAngle
		-- -- entity.Properties.fJumpAngle = 38  -- 45
		-- entity.Properties.fJumpAngle = 45
		-- entity.TEMP_RESULT = entity:MutantJump(AIAnchor.MUTANT_JUMP_SMALL,20)
		-- entity.Properties.fJumpAngle=SetAngle
		-- if not entity.TEMP_RESULT then
			-- AI:Signal(0,-1,"JUMP_ON_TARGET",entity.id)
		-- end
		AI:Signal(0,-1,"JUMP_ON_TARGET",entity.id)
	end,

	-- jump_on_target = function(self,entity,sender)

	-- end,

	JUMP_ALLOWED = function(self,entity,sender)
		entity.ThisMutantJump=1
		entity.MyCurrentPos=new(entity:GetPos())
		-- AI:MakePuppetIgnorant(entity.id,0) -- А здесь сразу перед вылетом, на всякий пожарный.
	end,

	JUMP_ON_TARGET = function(self,entity,sender)
		local att_target = AI:GetAttentionTargetOf(entity.id)
		if (att_target) and type(att_target)=="table" then
			local distance = entity:GetDistanceFromPoint(att_target:GetPos())
			-- if distance > random(40,70) then -- От этого зависит на каком расстоянии начинает активно преследовать цель прыжками.
				-- do return end
			-- end
			AI:CreateGoalPipe("jump_on_target")
			AI:PushGoal("jump_on_target","signal",1,-1,"JUMP_ALLOWED",0)
			AI:PushGoal("jump_on_target","ignoreall",0,1) -- Больше шансов что мутант решит прыгать если цель вдруг окажется за преградой.
			if distance > 20 then
				-- -- AI:PushGoal("jump_on_target","ignoreall",0,1)
				-- -- AI:PushGoal("jump_on_target","locate",0,"beacon")
				-- -- AI:PushGoal("jump_on_target","timeout",1,.5)
				-- -- entity.ForceResponsiveness = 1
				-- -- entity:ChangeAIParameter(AIPARAM_RESPONSIVENESS,100)
				-- -- AI:PushGoal("jump_on_target","acqtarget",1,"")
				-- -- entity:ChangeAIParameter(AIPARAM_RESPONSIVENESS,entity.Properties.responsiveness)
				-- -- entity.ForceResponsiveness = nil
				-- -- AI:PushGoal("jump_on_target","timeout",1,.2)
				AI:PushGoal("jump_on_target","timeout",1,1)
			-- else
				-- AI:PushGoal("jump_on_target","acqtarget",0,"")
			end
			AI:PushGoal("jump_on_target","just_shoot")
			AI:PushGoal("jump_on_target","jump",1,0,0,0,entity.Properties.fJumpAngle)
			AI:PushGoal("jump_on_target","ignoreall",0,0) -- Не всегда выходит из игнора, как ни крути. Rich.
			AI:PushGoal("jump_on_target","clear")
			AI:PushGoal("jump_on_target","signal",1,-1,"JUMP_FINISHED",0)
			AI:PushGoal("jump_on_target","signal",1,-1,"PREDATOR_ATTACK",0)
			-- AI:PushGoal("jump_on_target","signal",1,-1,"PREDATOR_MELEE",0)
			-- if distance > 20 then
				-- entity:SelectPipe(0,"jump_on_target")
			-- elseif distance > entity.Properties.fMeleeDistance+3 then
			if entity.Properties.fMeleeDistance and distance and distance > entity.Properties.fMeleeDistance+2 then
				entity:SelectPipe(0,"jump_on_target",att_target.id)
			else
				self:PREDATOR_MELEE(entity)
			end
			-- Hud:AddMessage(entity:GetName()..": JUMP_ON_TARGET")
			-- System:Log(entity:GetName()..": JUMP_ON_TARGET")
			entity:InsertSubpipe(0,"setup_stand")
			entity:InsertSubpipe(0,"do_it_running")
		else
			self:PREDATOR_ATTACK(entity) -- Если цель была уничтожена...
		end
	end,

	JUMP_FINISHED = function(self,entity,sender)
		entity.ThisMutantJump=nil
		AI:MakePuppetIgnorant(entity.id,0) -- Спасательный круг.
		if entity.cnt.AnimationSystemEnabled~=1 then -- Бывали случаи...
			entity.cnt.AnimationSystemEnabled = 1
			entity:SetAnimationSpeed(1)
			entity:StartAnimation(0,"NULL",4)
		end
		entity:SelectPipe(0,"predator_after_jump_attack")
		if entity.MyCurrentPos==entity:GetPos() then -- Ещё одна проблема заключается в том, что мутант думает что уже находится там, куда должен прыгнуть даже если прыжок не состоялся.
			-- Hud:AddMessage(entity:GetName()..": NOT JUMPING!")
			System:Log(entity:GetName()..": NOT JUMPING!")
			entity.MyCurrentPos=nil
			entity:SelectPipe(0,"predator_attack_pathfind")
		end
		-- self:PREDATOR_ATTACK(entity) -- Слишком большая задержка.
	end,

	PREDATOR_MELEE = function(self,entity,sender) -- Добавить: если несколько раз не попал, то нужно отойти назад и снова атаковать.
		-- local distance = entity:GetDistanceToTarget()
		if entity.IsCaget then AI:Signal(0,-1,"RELEASED",entity.id) end
		local distance
		local att_target = AI:GetAttentionTargetOf(entity.id)
		if att_target and type(att_target)=="table" then
			if att_target.MUTANT or att_target.IsCaged then -- А может проверку на species а не MUTANT сделать?
				entity:TriggerEvent(AIEVENT_CLEAR)
				entity:SelectPipe(0,"predator_seeking_enemies")
				return
			end
			distance = entity:GetDistanceFromPoint(att_target:GetPos())
		end
		entity.HeMeleeAttack=1 -- C++ чтобы не отбегал от цели когда вплотную подошёл.
		if not distance or not entity.Properties.fMeleeDistance or (entity.Properties.fMeleeDistance and distance and distance > entity.Properties.fMeleeDistance+2.5) or entity.not_sees_timer_start~=0 then
			entity.HeMeleeAttack=nil -- C++
			entity.not_sees_timer_start = 0
			entity:TriggerEvent(AIEVENT_CLEAR)
			self:PREDATOR_ATTACK(entity)
			do return end
		end
		-- Hud:AddMessage(entity:GetName()..": PREDATOR_MELEE")
		-- System:Log(entity:GetName()..": PREDATOR_MELEE")
		entity:SelectPipe(0,"predator_melee")
		entity:InsertSubpipe(0,"setup_stand")
		entity:InsertSubpipe(0,"do_it_running")
		entity.SaveMelee = entity.Properties.fMeleeDistance
		entity.Properties.fMeleeDistance = distance
		if (entity.MELEE_ANIM_COUNT) then
			local rnd = random(1,entity.MELEE_ANIM_COUNT)
			local melee_anim_name = format("attack_melee%01d",rnd)
			-- entity:InsertSubpipe(0,"jump_decision")
			entity:InsertAnimationPipe(melee_anim_name,3,"RETURN_CORRECT_DIST",0)
			AI:SoundEvent(entity.id,entity:GetPos(),15,1,0,entity.id) -- Сделать нормальную дистанцию.
		else
			Hud:AddMessage("==================UNACCEPTABLE ERROR====================")
			Hud:AddMessage("Entity "..entity:GetName().." made melee attack but has no melee animations.")
			Hud:AddMessage("==================UNACCEPTABLE ERROR====================")
		end
		-- entity.Properties.fMeleeDistance = SaveMelee
		-- entity:TriggerEvent(AIEVENT_CLEAR) -- Вызывает глюк "быстрых ударов".
	end,

	SWITCH_TO_ATTACK = function(self,entity,sender)
		entity:SelectPipe(0,"predator_just_attack")
		entity:InsertSubpipe(0,"predator_is_invisible")
	end,

	RETURN_CORRECT_DIST = function(self,entity,sender)
		entity.Properties.fMeleeDistance = entity.SaveMelee
	end,

	PREDATOR_ATTACK = function(self,entity,sender)
		-- entity:TriggerEvent(AIEVENT_DROPBEACON)
		-- Hud:AddMessage(entity:GetName()..": PREDATOR_ATTACK")
		-- System:Log(entity:GetName()..": PREDATOR_ATTACK")
		-- entity:TriggerEvent(AIEVENT_DROPBEACON)
		-- if entity.not_sees_timer_start~=0 then
			-- AI:Signal(0,-1,"FIND_A_TARGET",entity.id)
			-- entity:TriggerEvent(AIEVENT_CLEAR)
			-- do return end
		-- end
		-- entity:SelectPipe(0,"predator_just_attack")
		-- entity:SelectPipe(0,"predator_seeking_enemies")
		-- entity:InsertSubpipe(0,"DropBeaconTarget")
		entity:InsertSubpipe(0,"predator_is_invisible")
		local att_target = AI:GetAttentionTargetOf(entity.id)
		if att_target and type(att_target)=="table" then
			local distance = entity:GetDistanceFromPoint(att_target:GetPos())
			if distance > 3 then
				entity:SelectPipe(0,"predator_just_attack")
			else
				self:PREDATOR_MELEE(entity)
			end
		else -- На секуду показало на радаре что он даже видел меня, хотя я на самом деле под землёй (devmode).
			-- Hud:AddMessage(entity:GetName()..": no target!")
			-- System:Log(entity:GetName()..": no target!")
			entity:TriggerEvent(AIEVENT_DROPBEACON)
			-- AI:Signal(0,-1,"FIND_A_TARGET",entity.id)
			if random(1,2)==1 then
				entity:SelectPipe(0,"predator_seeking_enemies") -- Лучше чтобы пайпу всё-таки селектило, так как для начала мне нужно чтобы он подошёл к цели.
			else
				entity:SelectPipe(0,"predator_seeking_enemies2")
			end
			AI:CreateGoalPipe("go_to_target")
			AI:PushGoal("go_to_target","pathfind",1,"")
			AI:PushGoal("go_to_target","trace",1,1,1)
			-- AI:PushGoal("go_to_target","clear") -- Должно очистить и в атаке переключить на OnNoTarget, где находится FIND_A_TARGET
			entity:InsertSubpipe(0,"go_to_target")
			entity.NoSoundOnSeek=_time -- Исправление цикла с постоянным выбором из двух пайп.
		end
	end,

	PREDATOR_SCARED = function(self,entity,sender)
		-- Hud:AddMessage(entity:GetName()..": PREDATOR_SCARED")
		-- System:Log(entity:GetName()..": PREDATOR_SCARED")
		if not entity.scared_signal then
			entity.scared_signal = 1
			entity:SelectPipe(0,"predator_scared")
			if entity~=sender then
				entity:InsertSubpipe("DropBeaconAt",sender.id)
			end
		else
			self:PREDATOR_ATTACK(entity)
		end
		entity:InsertSubpipe(0,"predator_is_invisible")
	end,

	ANY_MORE_TO_RELEASE = function(self,entity,sender)
		local release_friends = AI:FindObjectOfType(entity.id,50,AIAnchor.MUTANT_LOCK)
		if (release_friends) then
			entity:InsertSubpipe(0,"predator_is_invisible")
			AIBehaviour.DEFAULT:OnNoTarget(entity) -- Чтобы такие мутанты могли вернуться в состояние бездействия.
			entity:SelectPipe(0,"bust_lock_at",release_friends)
			-- entity:InsertSubpipe(0,"predator_is_invisible")
		-- else
			-- entity:SelectPipe(0,"predator_just_attack")
		end
	end,

	RETURN_TO_FIRST = function(self,entity,sender)
		entity.scared_signal = nil
		entity:InsertSubpipe(0,"predator_is_visible")
		entity.FirstState=1
		entity.EventToCall = "OnSpawn"
		self:ANY_MORE_TO_RELEASE(entity)
	end,
}