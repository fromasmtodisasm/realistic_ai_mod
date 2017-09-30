--------------------------------------------------
--    Created By: Petar


AIBehaviour.BigAttack = {
	Name = "BigAttack",


	---------------------------------------------
	OnKnownDamage = function(self,entity,sender)
		if entity.id==sender.id then
			entity:InsertSubpipe(0,"just_shoot")
		end
		local mytarget = AI:GetAttentionTargetOf(entity.id)
		if (mytarget) then
			if (type(mytarget)=="table") then
				if ((mytarget~=sender) and (sender==_localplayer)) then
					entity:SelectPipe(0,"retaliate_damage",sender.id)
				end
			end
		end
	end,

	OnNoTarget = function(self,entity) -- Откуда у него постоянная стрельба берётся?
		entity:SelectPipe(0,"big_roam")
		entity:InsertSubpipe(0,"not_shoot")
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		if not fDistance then fDistance = entity:GetDistanceToTarget() end
		if not fDistance then fDistance = 0 NotContact=1 end
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:SelectPipe(0,"big_pindown")
		if not NotContact then
			AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY_ON_ATTACK(entity)
		end
		if (fDistance>5) then
			self:DECIDE_TO_SHOOT_OR_NOT(entity)
		end
	end,

	OnDeadBodySeen = function(self,entity,sender,fDistance)
		if entity.Properties.species==sender.Properties.species and fDistance<=10 and entity.sees~=1 then
			entity:InsertSubpipe(0,"retreat_on_dead_body_seen",sender.id)
			self:OnSomethingDiedNearest(entity,sender)
		end
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		-- called when the enemy can no longer see its foe,but remembers where it saw it last
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:SelectPipe(0,"mutant_run_to_target")
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if entity.sees~=1 then
			if entity.sees==0 then
				entity:SelectPipe(0,"mutant_run_to_target")
			else
				entity:SelectPipe(0,"big_pindown")
			end
		end
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if entity.sees~=1 then
			-- if entity.sees==0 then
				entity:SelectPipe(0,"mutant_run_to_target")
			-- else
				-- entity:SelectPipe(0,"big_pindown")
			-- end
		end
	end,
	---------------------------------------------
	OnReload = function(self,entity)
		-- called when the enemy goes into automatic reload after its clip is empty
	end,

	OnSomethingDiedNearest = function(self,entity,sender)
		entity.rs_y = 1
		AIBehaviour.CoverAttack:OnSomethingDiedNearest(entity,sender)
	end,
	---------------------------------------------
	OnNoHidingPlace = function(self,entity,sender)
		-- called when no hiding place can be found with the specified parameters
		entity:SelectPipe(0,"big_run_to_target")
		entity:PushStuff()
	end,
	---------------------------------------------
	OnReceivingDamage = function(self,entity,sender) -- При нанесении себе урона когда нет цели прекратить стрелять или сделать небольшой стрейф.
		if entity.sees~=1 then
			entity:SelectPipe(0,"big_roam")
			entity:InsertSubpipe(0,"not_shoot")
		end
	end,
	--------------------------------------------------
	OnBulletRain = function(self,entity,sender)
		if entity.sees==0 then
			entity:SelectPipe(0,"big_roam")
			entity:InsertSubpipe(0,"not_shoot")
		end
	end,
	--------------------------------------------------
	OnCloseContact = function(self,entity,sender)
		if (entity.MELEE_ANIM_COUNT) then
			local rnd = random(1,entity.MELEE_ANIM_COUNT)
			local melee_anim_name = format("attack_melee%01d",rnd)
			entity:SelectPipe(0,"big_pindown")
			entity:InsertAnimationPipe(melee_anim_name,3)
			AI:SoundEvent(entity.id,entity:GetPos(),15,1,0,entity.id) -- Сделать нормальную дистанцию.
		else
			Hud:AddMessage("==================UNACCEPTABLE ERROR====================")
			Hud:AddMessage("Entity "..entity:GetName().." made melee attack but has no melee animations.")
			Hud:AddMessage("==================UNACCEPTABLE ERROR====================")
		end

	end,
	--------------------------------------------------

	SELECT_LEFT_RIGHT_COMEOUT = function(self,entity,sender)
--		local rnd=random(1,2)
--		if (rnd==1) then
--			entity:SelectPipe(0,"big_comeout_left")
--		else
--			entity:SelectPipe(0,"big_comeout_right")
--		end
		entity:SelectPipe(0,"big_run_to_target")
		self:DECIDE_TO_SHOOT_OR_NOT(entity)
	end,
	--------------------------------------------------

	DECIDE_TO_SHOOT_OR_NOT = function(self,entity,sender)
		local att_target = AI:GetAttentionTargetOf(entity.id)
		if not att_target or att_target==AIOBJECT_NONE then
			entity:SelectPipe(0,"big_run_to_beacon")
		else
			local rnd=random(1,6)
			if (rnd==1) then
				entity:SelectPipe(0,"big_shoot")
			elseif (rnd==2) then
				entity:PushStuff()
			end
		end
	end,

	---------------------------------------------
	RUN_TO_TARGET = function(self,entity,sender)
		-- called when no hiding place can be found with the specified parameters
		entity:SelectPipe(0,"big_run_to_target")
		entity:InsertSubpipe(0,"not_shoot")
		entity:PushStuff()
	end,

	HEADS_UP_GUYS = function(self,entity,sender)
		if entity.ForceSenderId then sender=System:GetEntity(entity.ForceSenderId) entity.ForceSenderId=nil end
		AIBehaviour.DEFAULT:AllWakeUp(entity)
		if entity.Properties.species==sender.Properties.species and entity~=sender
		and not entity.heads_up_guys and entity.sees~=1 then
			entity:SelectPipe(0,"mutant_run_to_beacon")
			if sender and sender.SenderId then
				if random(1,3)==1 then
					entity:InsertSubpipe(0,"acquire_beacon2",sender.id)
				end
				entity:SelectPipe(0,"check_beacon")
				entity:InsertSubpipe(0,"DropBeaconAt",sender.SenderId)
				local SenderDistance = entity:GetDistanceFromPoint(sender:GetPos())
				if SenderDistance and SenderDistance > 30 then
					entity:InsertSubpipe(0,"go_to_sender",sender.id)
				end
			end
			entity.heads_up_guys = 1
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,10)
			AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY(entity)
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)
		end
	end,
}