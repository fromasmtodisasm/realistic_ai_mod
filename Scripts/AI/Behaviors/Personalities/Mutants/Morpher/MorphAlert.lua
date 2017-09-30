
--    Created By: Petar


AIBehaviour.MorphAlert = {
	Name = "MorphAlert",

	OnNoTarget = function(self,entity,sender)
		AIBehaviour.DEFAULT:OnNoTarget(entity)
		-- AI:Signal(0,1,"FIND_A_TARGET",entity.id)
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		AIBehaviour.MorphIdle:OnPlayerSeen(entity,fDistance,1)
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		-- called when the enemy can no longer see its foe,but remembers where it saw it last
	end,

	OnInterestingSoundHeard = function(self,entity)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:MakeAlerted()
		entity:SelectPipe(0,"morpher_attack_wrapper2")
		-- Hud:AddMessage(entity:GetName()..": OnInterestingSoundHeard")
	end,

	OnThreateningSoundHeard = function(self,entity)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:MakeAlerted()
		entity:SelectPipe(0,"morpher_attack_wrapper2")
		-- Hud:AddMessage(entity:GetName()..": OnThreateningSoundHeard")
	end,

	OnReload = function(self,entity)
		-- called when the enemy goes into automatic reload after its clip is empty
	end,

	OnGroupMemberDied = function(self,entity)
		-- called when a member of the group dies
	end,

	OnNoHidingPlace = function(self,entity,sender)
		-- called when no hiding place can be found with the specified parameters
	end,

	OnReceivingDamage = function(self,entity,sender)
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

	DECIDE_IF_INVESTIGATING_MORE = function(self,entity,sender)
		entity:SelectPipe(0,"stealth_hunt")
	end,


}