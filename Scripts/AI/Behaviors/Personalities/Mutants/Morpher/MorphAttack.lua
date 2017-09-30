
--    Created By: Petar


AIBehaviour.MorphAttack = {
	Name = "MorphAttack",

	OnNoTarget = function(self,entity,sender)
		AIBehaviour.DEFAULT:OnNoTarget(entity)
		-- AI:Signal(0,1,"FIND_A_TARGET",entity.id)
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		if not fDistance then fDistance = entity:GetDistanceToTarget() end
		if not fDistance then fDistance = 0 NotContact=1 end
		if not NotContact then
			AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY_ON_ATTACK(entity)
		end
		entity:SelectPipe(0,"morpher_attack_wrapper")
	end,

	OnPlayerLookingAway =  function(self,entity,fDistance) -- Работает!
		entity:GoRefractive()
--		AI:Cloak(entity.id)
		entity:SelectPipe(0,"morpher_invisible_attack")
		-- Hud:AddMessage(entity:GetName()..": OnPlayerLookingAway")
		System:Log(entity:GetName()..": OnPlayerLookingAway")
	end,

	OnDeadBodySeen = function(self,entity,sender,fDistance)
		if entity.Properties.species==sender.Properties.species and fDistance<=10 and entity.sees~=1 then
			entity:InsertSubpipe(0,"retreat_on_dead_body_seen",sender.id)
			-- self:OnSomethingDiedNearest(entity,sender)
		end
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		-- called when the enemy can no longer see its foe,but remembers where it saw it last
	end,

	OnInterestingSoundHeard = function(self,entity)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		-- called when the enemy hears an interesting sound
	end,

	OnThreateningSoundHeard = function(self,entity)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		-- called when the enemy hears a scary sound
	end,

	OnReload = function(self,entity)
		-- called when the enemy goes into automatic reload after its clip is empty
	end,

	OnGroupMemberDied = function(self,entity)
		-- called when a member of the group dies
	end,

	OnSomethingDiedNearest_x = function(self,entity,sender)
	end,

	OnNoHidingPlace = function(self,entity,sender)
		-- called when no hiding place can be found with the specified parameters
		entity:InsertSubpipe(0,"mutant_run_towards_target")
	end,

	OnKnownDamage = function(self,entity,sender)
		entity:InsertSubpipe(0,"DropBeaconTarget",sender.id)
	end,

	OnReceivingDamage = function(self,entity,sender)
		entity:MutantJump(AIAnchor.MUTANT_AIRDUCT)
--		entity:InsertSubpipe(0,"setup_crouch")
	end,

	OnBulletRain = function(self,entity,sender)
		-- called when the enemy detects bullet trails around him
	end,

	OnCloseContact = function(self,entity,sender)
		entity:GoVisible()
		entity:SelectPipe(0,"morpher_attack_wrapper")
		if (entity.MELEE_ANIM_COUNT) then
			local rnd = random(1,entity.MELEE_ANIM_COUNT)
			local melee_anim_name = format("attack_melee%01d",rnd)
			entity:InsertAnimationPipe(melee_anim_name,3)
			AI:SoundEvent(entity.id,entity:GetPos(),15,1,0,entity.id) -- Сделать нормальную дистанцию.
		else
			Hud:AddMessage("==================UNACCEPTABLE ERROR====================")
			Hud:AddMessage("Entity "..entity:GetName().." made melee attack but has no melee animations.")
			Hud:AddMessage("==================UNACCEPTABLE ERROR====================")
		end
	end,



	SELECT_MORPH_ATTACK = function(self,entity,sender)
		local rnd=random(1,3)
		if rnd==1 then
			entity:InsertSubpipe(0,"morpher_attack_left")
		elseif rnd==2 then
			entity:InsertSubpipe(0,"morpher_attack_right")
		else
			entity:InsertSubpipe(0,"morpher_attack_retreat")
		end
	end,

	SELECT_MORPH_ATTACK2 = function(self,entity,sender)
		if random(1,2)==1 then
			entity:InsertSubpipe(0,"morpher_attack_left")
		else
			entity:InsertSubpipe(0,"morpher_attack_right")
		end
	end,


}