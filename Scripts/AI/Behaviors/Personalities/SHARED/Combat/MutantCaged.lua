--------------------------------------------------
--   Created By: amanda
--   Description: run to alarm anchor
--------------------------

AIBehaviour.MutantCaged = {
	Name = "MutantCaged",
	NOPREVIOUS = 1,
	
	---------------------------------------------
	OnSpawn = function(self,entity)
		entity:SelectPipe(0,"mutant_caged_idle")
		entity:ChangeAIParameter(AIPARAM_SPECIES,1) -- Когда 100, тогда мутанты между собой не дерутся, когда 1, тогда у тех кто в клетках не возникает желания бить наёмников.
		self.CurrentSpecies = 1  -- Для SetActualName.
		entity:InsertSubpipe(0,"predator_is_visible")
		entity.IsCaged=1 
		entity.SaveMeleeDistance=entity.Properties.fMeleeDistance 
		entity.SaveMeleeDamage=entity.Properties.fMeleeDamage 
		if random(1,5)==1 then
			entity.Properties.fMeleeDistance=random(1,2) -- Значения в рандоме всё-равно округляются до целых в меньшую сторону.
		else
			entity.Properties.fMeleeDistance=1 
		end
		-- System:Log(entity:GetName()..": PREDATOR_MELEE: "..entity.Properties.fMeleeDistance)
		entity.Properties.fMeleeDamage=entity.Properties.fMeleeDamage/2 
	end,
	---------------------------------------------
	OnActivate = function(self,entity)
		AI:Signal(0,1,"RELEASED",entity.id)
	end,
	---------------------------------------------
	OnNoTarget = function(self,entity)
		entity:SelectPipe(0,"mutant_caged_idle")
		entity:InsertSubpipe(0,"predator_is_visible")
	end,
	---------------------------------------------
	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		entity:SelectPipe(0,"mutant_caged_upset")
	end,
	---------------------------------------------
	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		-- called when the enemy can no longer see its foe,but remembers where it saw it last
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity)
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity)
		entity:SelectPipe(0,"mutant_caged_upset")
		entity:InsertSubpipe(0,"predator_is_invisible")
	end,

	OnKnownDamage = function(self,entity,sender)
		AI:Signal(0,1,"RELEASED",entity.id)
		entity:SelectPipe(0,"retaliate_damage",sender.id)
		entity:InsertSubpipe(0,"predator_is_invisible")
		entity:InsertSubpipe(0,"do_it_running")
	end,

	OnReceivingDamage = function(self,entity,sender)
		entity:InsertSubpipe(0,"predator_is_invisible")
		entity:SelectPipe(0,"mutant_caged_upset")
		AI:Signal(0,1,"RELEASED",entity.id)
	end,
	--------------------------------------------------
	OnBulletRain = function(self,entity,sender)
		entity:InsertSubpipe(0,"predator_is_invisible")
		entity:SelectPipe(0,"mutant_caged_upset")
	end,
	
	OnCloseContact = function(self,entity,sender)
		if sender.MUTANT then return end
		entity:InsertSubpipe(0,"predator_is_invisible")
		entity:InsertSubpipe(0,"do_it_running")
		rnd = random(1,entity.MELEE_ANIM_COUNT) -- Рандомная анимация ударов.
		local melee_anim_name = format("attack_melee%01d",rnd)
		entity:InsertSubpipe(0,"abberation_melee")
		entity:InsertAnimationPipe(melee_anim_name,3,nil,0)
		AI:SoundEvent(entity.id,entity:GetPos(),15,1,0,entity.id) -- Сделать нормальную дистанцию.
		AI:Signal(0,1,"RELEASED",entity.id)
	end,
	
	-- PREDATOR_MELEE = function(self,entity,sender) -- Не убирать.
	-- end,
	
	OnGrenadeSeen = function(self,entity,fDistance)
		entity:SelectPipe(0,"predator_avoiding_grenade")
		entity:InsertSubpipe(0,"predator_is_invisible")
		entity:InsertSubpipe(0,"do_it_running")
	end,

	OnGrenadeSeen_Flying = function(self,entity,sender)
		self:OnGrenadeSeen(entity)
	end,

	OnGrenadeSeen_Colliding = function(self,entity,sender)
		self:OnGrenadeSeen(entity)
	end,

	OnSomethingDiedNearest = function(self,entity,sender) -- Добавить: бесится и прыгает в разные стороны.
		entity:SelectPipe(0,"mutant_caged_upset")
	end,

	--------------------------------------------------
	MUTANT_RELAXED_ANIM = function(self,entity,sender)
		entity:MakeRandomIdleAnimation() 		-- make idle animation
	end,

	RELEASED = function(self,entity,sender)
		entity.Properties.fMeleeDistance=entity.SaveMeleeDistance 
		entity.Properties.fMeleeDamage=entity.SaveMeleeDamage 
		entity:ChangeAIParameter(AIPARAM_GROUPID,AI:GetGroupOf(sender.id))
		entity.CurrentGroupID = AI:GetGroupOf(sender.id) -- Для SetActualName.
		if sender.MUTANT then
			entity:ChangeAIParameter(AIPARAM_SPECIES,sender.Properties.species)
			self.CurrentSpecies = sender.Properties.species  -- Для SetActualName.
		else
			entity:ChangeAIParameter(AIPARAM_SPECIES,100)
			self.CurrentSpecies = 1  -- Для SetActualName.
		end
		entity.IsCaged=nil 
		entity.WasIsCaged=1 
		-- Hud:AddMessage(entity:GetName()..": RELEASED "..AI:GetGroupOf(entity.id).." "..AI:GetGroupOf(sender.id))
		-- System:Log(entity:GetName()..": RELEASED "..AI:GetGroupOf(entity.id).." "..AI:GetGroupOf(sender.id))
		entity:TriggerEvent(AIEVENT_CLEAR)
		AI:Signal(0,1,"FIND_A_TARGET",entity.id) -- Сделать чтобы сразу побежали искать мясо, а не стояли и ждали.
	end,

	--------------------------------------------------
	MUTANT_UPSET_ANIM = function(self,entity,sender)
		entity:InsertSubpipe(0,"do_it_running")
		if (entity.COMBAT_IDLE_COUNT) then
			local rnd = random(0,entity.COMBAT_IDLE_COUNT)
			local idle_anim_name = format("combat_idle%02d",rnd)
			entity:InsertAnimationPipe(idle_anim_name,4)
		else
			Hud:AddMessage("============UNACCEPTABLE ERROR===================")
			Hud:AddMessage("[ASSETERROR] No combat idles for "..entity:GetName())
			Hud:AddMessage("============UNACCEPTABLE ERROR===================")
		end
	end,


	-- GROUP SIGNALS
	--------------------------------------------------
	HEADS_UP_GUYS = function(self,entity,sender)
	end,
	---------------------------------------------
	INCOMING_FIRE = function(self,entity,sender)
	end,
}