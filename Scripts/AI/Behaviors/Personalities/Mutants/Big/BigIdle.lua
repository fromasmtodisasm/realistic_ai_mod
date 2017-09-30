-- Created By: Petar
AIBehaviour.BigIdle = {
	Name = "BigIdle",

	OnNoTarget = function(self,entity)
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		AI:Signal(0,1,"SAY_FIRST_HOSTILE_CONTACT",entity.id)
		-- called when the enemy sees a living player
		entity:SelectPipe(0,"big_pindown")
		if fDistance>30 then
			entity:PushStuff()
		end
		if fDistance>30 then
			entity:InsertSubpipe(0,"mutant_shared_bellowhowl2")	-- bellow and howl
		else
			entity:InsertSubpipe(0,"big_shoot")
		end
		AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY(entity)
		if entity:GetGroupCount() > 1 then
			AIBehaviour.DEFAULT:HEADS_UP_GUYS_GROUP(entity)
		end
		entity:InsertSubpipe(0,"setup_stand")
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:MakeAlerted()
	end,
	---------------------------------------------
	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		-- called when the enemy can no longer see its foe,but remembers where it saw it last
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:SelectPipe(0,"mutant_walk_to_target")
		entity:MakeAlerted()
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity)
		self:OnInterestingSoundHeard(entity)
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
		entity:MakeAlerted()
		entity:SelectPipe(0,"big_roam")
		entity:InsertSubpipe(0,"not_shoot")
	end,
	--------------------------------------------------
	OnBulletRain = function(self,entity,sender)
		self:OnReceivingDamage(entity)
	end,
	--------------------------------------------------
	PLAY_SHOOT_ANIMATION = function(self,entity,sender)
		--entity:InsertSubpipe(0,"big_new_shoot")
		entity:InsertAnimationPipe("fire_special00")
	end,

	SHOOT_TYPE = function(self,entity,sender)
		local Current_Weapon = entity.cnt.weapon
		if Current_Weapon and Current_Weapon.name=="COVERRL" then
			entity:SelectPipe(0,"big_single_shoot")
		else
			entity:SelectPipe(0,"big_auto_shoot")
		end
	end,

	HEADS_UP_GUYS = function(self,entity,sender) -- Толстяки, по сути, остались теми же самыми прикрывающими наёмниками, только они с другими намерениями и гораздо более мощным вооружением.
		if entity.ForceSenderId then sender=System:GetEntity(entity.ForceSenderId) entity.ForceSenderId=nil end	AIBehaviour.DEFAULT:AllWakeUp(entity)
		if entity.Properties.species==sender.Properties.species then
			entity:MakeAlerted()
			if entity.id~=sender.id then
				entity:SelectPipe(0,"mutant_run_to_beacon")
				entity:InsertSubpipe(0,"go_to_sender",sender.id)
				if sender.SenderId then
					entity:SelectPipe(0,"check_beacon")
					entity:InsertSubpipe(0,"DropBeaconAt",sender.SenderId)
				end
			end
		end
	end,

	HIT_THE_SPOT = function(self,entity,sender) -- Сделать чтобы во время этой анимации он не мог стрелять.
		entity:SelectPipe(0,"big_pindown")
		entity:InsertAnimationPipe("weakspot_reaction",nil,nil,nil,nil,1)
		-- self:GetAnimationLength(anim_name)
	end,

}