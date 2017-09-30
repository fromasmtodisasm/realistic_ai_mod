
--    Created By: Petar


AIBehaviour.MorphIdle = {
	Name = "MorphIdle",


	OnNoTarget = function(self,entity)
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if not fDistance then fDistance = entity:GetDistanceToTarget() end
		if not fDistance then fDistance = 0 NotContact=1 end
		entity:SelectPipe(0,"morpher_attack_wrapper2")
		AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY(entity)
		if entity:GetGroupCount() > 1 then
			AIBehaviour.DEFAULT:HEADS_UP_GUYS_GROUP(entity)
		end
		entity:MakeAlerted()
	end,
	---------------------------------------------
	OnSomethingSeen = function(self,entity,fDistance)
		-- called when the enemy sees a living player
		local rnd=random(1,5)
		if (rnd==1) then
			entity:MutantJump(AIAnchor.MUTANT_AIRDUCT)
--			entity:InsertSubpipe(0,"setup_crouch")
		else
			entity:SelectPipe(0,"stealth_investigate")
		end
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:InsertSubpipe(0,"DRAW_GUN")
	end,
	---------------------------------------------
	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		-- called when the enemy can no longer see its foe,but remembers where it saw it last
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		-- entity:TriggerEvent(AIEVENT_CLEAR) -- Вызывает эту же функцию в следующем состоянии.
		-- entity:InsertSubpipe(0,"cover_lookat")
		if random(1,2)==1 then
			entity:InsertSubpipe(0,"mutant_walk_to_target2")
		else
			entity:InsertSubpipe(0,"mutant_run_towards_target2")
			entity:MakeAlerted()
		end
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		-- entity:TriggerEvent(AIEVENT_CLEAR)
		-- entity:InsertSubpipe(0,"cover_lookat")
		entity:MakeAlerted()
		entity:InsertSubpipe(0,"mutant_run_towards_target2")
	end,
	---------------------------------------------
	OnReload = function(self,entity)
		-- called when the enemy goes into automatic reload after its clip is empty
	end,
	---------------------------------------------
	OnGroupMemberDied = function(self,entity)
		-- called when a member of the group dies
	end,
	---------------------------------------------
	OnNoHidingPlace = function(self,entity,sender)
		-- called when no hiding place can be found with the specified parameters
	end,
	---------------------------------------------
	OnReceivingDamage = function(self,entity,sender)
		-- called when the enemy is damaged
	end,

	OnBulletRain = function(self,entity,sender)
		-- called when the enemy detects bullet trails around him
	end,


	JUMP_FINISHED = function(self,entity,sender)

		entity:SelectPipe(0,"mutant_walk_to_beacon")
		entity:InsertSubpipe(0,"setup_stand")
	end,


	MORPH = function(self,entity,sender)
		entity:GoVisible()
--		AI:Cloak(entity.id)
	end,

	UNMORPH = function(self,entity,sender)
		AI:DeCloak(entity.id)
	end,


	HEADS_UP_GUYS = function(self,entity,sender)
		if entity.ForceSenderId then sender=System:GetEntity(entity.ForceSenderId) entity.ForceSenderId=nil end
		if entity~=sender then
			entity:SelectPipe(0,"mutant_run_to_beacon")
		end
	end,


	GO_REFRACTIVE = function(self,entity,sender)
	end,

	GO_VISIBLE = function(self,entity,sender)
	end,

}