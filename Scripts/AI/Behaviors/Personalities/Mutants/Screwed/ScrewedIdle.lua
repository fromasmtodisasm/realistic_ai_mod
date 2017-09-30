--------------------------------------------------
--    Created By: Petar

-- Этот-то оказывается, тоже используется.

AIBehaviour.ScrewedIdle = {
	Name = "ScrewedIdle",

	OnNoTarget = function(self,entity)
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:SelectPipe(0,"mutant_screwed_attack")

		if (entity:GetGroupCount() > 1) then	
			entity:InsertSubpipe(0,"mutant_shared_bellowhowl")
			if (entity.SIGNAL_SENT==nil) then
				AI:Signal(0,1,"NOTIFY_GROUP_SIGNAL",entity.id)
			end
		end
		AI:Signal(0,1,"SAY_FIRST_HOSTILE_CONTACT",entity.id)
	end,
	---------------------------------------------
	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		-- called when the enemy can no longer see its foe,but remembers where it saw it last
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity)
		-- called when the enemy hears an interesting sound
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity)
		-- called when the enemy hears a scary sound
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
	--------------------------------------------------
	OnBulletRain = function(self,entity,sender)
		-- called when the enemy detects bullet trails around him
	end,
	--------------------------------------------------
	HEADS_UP_GUYS = function(self,entity,sender)
		if entity.ForceSenderId then sender=System:GetEntity(entity.ForceSenderId) entity.ForceSenderId=nil end
		if (entity.id~=sender.id) then
			entity:SelectPipe(0,"mutant_screwed_attack")
			entity:InsertSubpipe(0,"run_to_beacon")
			entity:InsertSubpipe(0,"random_timeout")
		end
	end,

}