-- Created By: Petar
AIBehaviour.ChimpAttack = {
	Name = "ChimpAttack",

	OnNoTarget = function(self,entity)
		AIBehaviour.DEFAULT:OnNoTarget(entity)
		entity:ChangeAIParameter(AIPARAM_FOV,entity.Properties.horizontal_fov)
		AI:Signal(0,1,"ANY_MORE_TO_RELEASE",entity.id)
		AI:Signal(0,1,"FIND_A_TARGET",entity.id)
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if not fDistance then fDistance = entity:GetDistanceToTarget() end
		if not fDistance then fDistance = 0 NotContact=1 end
		if not NotContact then
			AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY(entity)
		end
		-- entity:ChangeAIParameter(AIPARAM_FOV,30) -- Вызывает глюк с видимостью.
		-- entity:SelectPipe(0,"predator_attack_pathfind") -- Убрал временно.
		-- if fDistance <= 30 then
			-- entity:SelectPipe(0,"predator_just_attack")
		-- elseif fDistance <= random(31,60) then
			-- if random(1,5)==1 then
				-- entity:SelectPipe(0,"predator_hiding")
			-- end
		-- end
		entity:SelectPipe(0,"predator_attack_pathfind")
		if fDistance <= 30 then
			entity:SelectPipe(0,"predator_just_attack")
		end
	end,

	OnSomethingSeen = function(self,entity)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
	end,
	
	OnDeadBodySeen = function(self,entity,sender,fDistance)
		local Result = entity:NewCountingPlayers(30,1,nil,1)
		if entity.Properties.species==sender.Properties.species and fDistance<=10 and entity.sees~=1 and Result.Friends<=3 then
			-- Hud:AddMessage(entity:GetName()..": OnDeadBodySeen")
			entity:InsertSubpipe(0,"retreat_on_dead_body_seen",sender.id)
			self:OnSomethingDiedNearest(entity,sender)
		end
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:ChangeAIParameter(AIPARAM_FOV,entity.Properties.horizontal_fov)
	end,

	OnInterestingSoundHeard = function(self,entity)
		entity:InsertSubpipe(0,"do_it_running") -- Иногда почему-то начинают только ходить (может после флэшек). Тогда пусть это выглядит естественно.
		if entity.sees~=1 then
			entity:TriggerEvent(AIEVENT_DROPBEACON)
			if entity.NoSoundOnSeek and _time < entity.NoSoundOnSeek+1 then entity.NoSoundOnSeek=nil return end -- Испарвляет цикл. Не знаю почему, но у мутанта обостряется слух на не существующие звуки после потери цели и он начинает постоянно выбирать две пайпы.
			-- entity:SelectPipe(0,"predator_just_attack")
			entity:SelectPipe(0,"predator_attack_pathfind")
		end
	end,

	OnThreateningSoundHeard = function(self,entity)
		entity:InsertSubpipe(0,"do_it_running") -- Иногда почему-то начинают только ходить (может после флэшек). Тогда пусть это выглядит естественно.
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		-- local Result = entity:NewCountingPlayers(30,1,nil,1)
		-- if entity.sees==0 or (entity.sees~=1 and Result.Friends<=2) then -- ~=1
		if entity.sees~=1 then -- ~=1
			entity:SelectPipe(0,"predator_attack_pathfind")
			AI:Signal(0,1,"ANY_MORE_TO_RELEASE",entity.id)
		end
	end,

	OnReload = function(self,entity)
	end,

	-- OnGrenadeSeen = function(self,entity,fDistance)
		-- AIBehaviour.ChimpIdle:OnGrenadeSeen(entity)
	-- end,
	
	-- OnGrenadeSeen_Flying = function(self,entity,sender)
		-- self:OnGrenadeSeen(entity)
	-- end,

	-- OnGrenadeSeen_Colliding = function(self,entity,sender)
		-- self:OnGrenadeSeen(entity)
	-- end,

	OnNoHidingPlace = function(self,entity,sender)
	end,

	OnKnownDamage = function(self,entity,sender)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:SelectPipe(0,"predator_hide_wait_attack")
		if random(1,5)==1 then
			entity:SelectPipe(0,"predator_scared_in_action")
		elseif entity:GetDistanceFromPoint(sender:GetPos()) <= 30 then -- Сделать так везде.
			entity:SelectPipe(0,"predator_just_attack")
		end
		entity:InsertSubpipe(0,"DropBeaconTarget",sender.id)
		entity:ChangeAIParameter(AIPARAM_FOV,entity.Properties.horizontal_fov)
	end,

	OnReceivingDamage = function(self,entity,sender)
		if entity.sees~=1 then
			entity:SelectPipe(0,"predator_just_attack")
			if random(1,5)==1 then
				entity:SelectPipe(0,"predator_scared_in_action")
			end
		end
		-- entity:InsertSubpipe(0,"chimp_hurt")
		entity:ChangeAIParameter(AIPARAM_FOV,entity.Properties.horizontal_fov)
	end,

	OnBulletRain = function(self,entity,sender)
		self:OnReceivingDamage(entity,sender)
	end,

	OnDeath = function(self,entity,sender)
		AIBehaviour.ChimpIdle:OnDeath(entity,sender)
	end,

	OnSomethingDiedNearest = function(self,entity,sender)
		AIBehaviour.ChimpAlert:OnSomethingDiedNearest(entity,sender)
	end,
	
	OnSomethingDiedNearest_x = function(self,entity,sender)
	end,
	
	OnCloseContact = function(self,entity,sender)
		if entity.Properties.species==sender.Properties.species then return end
		-- Hud:AddMessage(entity:GetName()..": OnCloseContact")
		-- System:Log(entity:GetName()..": OnCloseContact")
		if entity.sees~=1 then
			entity:InsertSubpipe(0,"AcqBeacon",sender.id) -- Чтобы посмотрел назад если вдруг почувствует кого-нибудь.
		end
		AIBehaviour.ChimpIdle:PREDATOR_MELEE(entity,sender)
	end,

	PREDATOR_SCARED = function(self,entity,sender)
		-- Hud:AddMessage(entity:GetName()..": PREDATOR_SCARED3")
		-- System:Log(entity:GetName()..": PREDATOR_SCARED3")
		if entity.not_sees_timer_start~=0 then
			entity.not_sees_timer_start = 0 
			entity:SelectPipe(0,"predator_scared_in_action")
		-- else
			-- entity:SelectPipe(0,"predator_just_attack")
		end
		-- entity:TriggerEvent(AIEVENT_CLEAR)
		-- if entity~=sender then
			-- entity:InsertSubpipe("DropBeaconAt",sender.id)
		-- end
	end,

	HEADS_UP_GUYS = function(self,entity,sender) -- Доделать.
		-- if entity.Properties.species==sender.Properties.species then
			-- Hud:AddMessage(entity:GetName()..": HEADS_UP_GUYS")
			-- System:Log(entity:GetName()..": HEADS_UP_GUYS")
		-- end
	end,
}