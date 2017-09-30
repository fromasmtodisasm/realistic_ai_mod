-- Created By: Petar
AIBehaviour.FastAttack = {
	Name = "FastAttack",

	OnNoTarget = function(self,entity)
		AIBehaviour.DEFAULT:OnNoTarget(entity)
		entity:InsertSubpipe(0,"reload")
		entity:MutantJump()
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if entity.AI_CanWalk then
			entity:SelectPipe(0,"fast_shoot_approach")
		else
			entity:SelectPipe(0,"fast_shoot")
		end
	end,

	OnPlayerAiming = function(self,entity,sender)
		-- Hud:AddMessage(entity:GetName()..": OnPlayerAiming")
		-- System:Log(entity:GetName()..": OnPlayerAiming")
		if not entity:MutantJump(AIAnchor.MUTANT_JUMP_TARGET,30,2+1) then
			if entity.AI_CanWalk then
				local rnd = random(1,3)
				if rnd==1 then
					entity:SelectPipe(0,"fast_shoot_approach")
					entity:InsertSubpipe(0,"fast_hide2")
					--	entity:InsertSubpipe(0,"minimize_exposure")
				elseif rnd==2 then
					entity:SelectPipe(0,"fast_hide")
				else
					entity:SelectPipe(0,"fast_hide2")
				end
			else
				entity:SelectPipe(0,"fast_shoot") -- Уж слишком часто на шотах подвисают... Сделать чтоб через минуту пругал в другое место.
			end
		end
	end,

	OnSomethingSeen = function(self,entity)
		AIBehaviour.FastAlert:OnSomethingSeen(entity)
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		self:OnPlayerAiming(entity)
	end,

	OnInterestingSoundHeard = function(self,entity)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		self:OnPlayerAiming(entity)
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity)
		if entity.sees~=1 then
			entity:TriggerEvent(AIEVENT_DROPBEACON)
			self:OnPlayerAiming(entity)
		end
	end,

	OnReload = function(self,entity)
		if entity.sees~=1 then
			entity:MutantJump()
		end
	end,

	OnNoHidingPlace = function(self,entity,sender)
		self:OnReload(entity)
	end,

	OnKnownDamage = function(self,entity,sender)
		-- AIBehaviour.FastAlert:OnKnownDamage(entity,sender) -- FastAlert - nil
		entity:InsertSubpipe(0,"DropBeaconTarget",sender.id)
		if not entity:MutantJump() then
			if entity.AI_CanWalk then
				entity:SelectPipe(0,"on_damage_scared")
			else
				entity:SelectPipe(0,"fast_alert_look_around")
			end
		end
	end,

	OnReceivingDamage = function(self,entity,sender)
		AIBehaviour.FastIdle:OnReceivingDamage(entity)
	end,

	OnBulletRain = function(self,entity,sender)
		AIBehaviour.FastIdle:OnBulletRain(entity,sender)
	end,

	OnSomethingDiedNearest = function(self,entity,sender)
		AIBehaviour.FastIdle:OnSomethingDiedNearest(entity,sender)
	end,

	OnCloseContact = function(self,entity,sender)
		entity:InsertSubpipe(0,"AcqBeacon",sender.id)
		local rnd=random(1,5)
		entity:InsertMeleePipe("attack_melee"..rnd)
		local dur = entity:GetAnimationLength("attack_melee"..rnd)
		AI:EnablePuppetMovement(entity.id,0,dur+.3)
		entity:TriggerEvent(AIEVENT_ONBODYSENSOR,dur+.3)
		AI:SoundEvent(entity.id,entity:GetPos(),15,1,0,entity.id) -- Сделать нормальную дистанцию.
	end,

	SWITCH_TO_SHOOT = function(self,entity,sender)
		entity:SelectPipe(0,"fast_shoot")
	end,
}