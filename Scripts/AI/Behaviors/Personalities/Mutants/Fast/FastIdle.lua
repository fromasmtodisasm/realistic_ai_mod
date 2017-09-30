-- Created By: Petar
AIBehaviour.FastIdle = {
	Name = "FastIdle",

	-- OnNoTarget = function(self,entity)
		-- entity.NotSelectAlert=1 
		-- entity:MutantJump(AIAnchor.MUTANT_JUMP_TARGET_WALKING,30,2+1)
	-- end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		entity.FastNotDoIdle=1 
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:MakeAlerted()
		entity:SelectPipe(0,"fast_shoot")
	end,
	---------------------------------------------
	OnSomethingSeen = function(self,entity,fDistance)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if entity.AI_CanWalk then
			entity:SelectPipe(0,"fast_walk_to_target")
			--entity:InsertAnimationPipe("surprise01")
			entity:InsertSubpipe(0,"setup_combat")
			entity.cnt:HoldGun()
		else
			entity:SelectPipe(0,"fast_shoot")
		end
	end,

	OnPlayerAiming = function(self,entity,sender)
		entity.FastNotDoIdle=1 
		entity:MutantJump()
	end,
	
	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		-- called when the enemy can no longer see its foe,but remembers where it saw it last
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity,fDistance)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:MakeAlerted()
		entity:InsertAnimationPipe("surprise01")
		if entity.AI_CanWalk then
			entity:SelectPipe(0,"fast_walk_to_target")
		else
			entity:SelectPipe(0,"fast_shoot")
		end
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity,fDistance)
		entity.FastNotDoIdle=1 
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:MakeAlerted()
		if not entity:MutantJump() then
			if entity.AI_CanWalk then
				if fDistance>60 then
					entity:InsertAnimationPipe("surprise01")
				end
				entity:SelectPipe(0,"fast_run_to_target")
			else
				entity:SelectPipe(0,"fast_alert_look_around")
			end
		end
	end,
	---------------------------------------------
	OnReload = function(self,entity)
		-- called when the enemy goes into automatic reload after its clip is empty
	end,

	OnNoHidingPlace = function(self,entity,sender)
		entity.NotSelectAlert=1 
		entity:MutantJump()
	end,

	OnGrenadeSeen = function(self,entity,fDistance)
		if not fDistance then fDistance=0 end
		entity.FastNotDoIdle=1 
		if not entity:MutantJump() then -- Если не прыгнул..
			if entity.AI_CanWalk then -- если можно ходить...
				AIBehaviour.DEFAULT:OnGrenadeSeen(entity,fDistance) -- Работает ли?
			else -- А что делать если нельзя? Погибать?
				entity:SelectPipe(0,"fast_scared_approaching") -- ?
			end
		end
	end,
	
	OnGrenadeSeen_Flying = function(self,entity,sender)
		self:OnGrenadeSeen(entity)
	end,

	OnGrenadeSeen_Colliding = function(self,entity,sender)
		self:OnGrenadeSeen(entity)
	end,
	
	OnReceivingDamage = function(self,entity,sender)
		entity.FastNotDoIdle=1 
		entity:MakeAlerted()
		if not entity:MutantJump() then
			if entity.AI_CanWalk then
				entity:SelectPipe(0,"fast_scared_approaching")
				entity:InsertSubpipe(0,"do_it_running")
			else
				entity:SelectPipe(0,"fast_alert_look_around")
			end
		end
	end,

	OnBulletRain = function(self,entity,sender)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		self:OnReceivingDamage(entity,sender)
	end,

	OnSomethingDiedNearest = function(self,entity,sender)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		self:OnReceivingDamage(entity,sender)
	end,

	-- MAKE_BELLOW_HOWL_ANIMATION = function(self,entity,sender)
		-- entity:InsertAnimationPipe("idle05")
	-- end,

	JUMP_ON_ANCHOR = function(self,entity,sender)
		entity:MutantJump()
	end,

	JUMP_FINISHED = function(self,entity,sender)
		if entity.cnt.AnimationSystemEnabled~=1 then
			entity.cnt.AnimationSystemEnabled = 1
			entity:SetAnimationSpeed(1)
			entity:StartAnimation(0,"NULL",4)
		end
		entity.ThisMutantJump=nil
		if entity.NotSelectAlert and not entity.FastNotDoIdle then
			AI:Signal(0,1,"SELECT_IDLE",entity.id)
		else
			AI:Signal(0,1,"SELECT_ALERT",entity.id)
			if entity.AI_CanWalk then -- На установку этого флажка тоже нужно сделать проверку на позицию: действительно прыгнул или подумал что прыгнул.
				entity:SelectPipe(0,"fast_scared_approaching")
				entity:InsertSubpipe(0,"do_it_running")
			else
				entity:SelectPipe(0,"fast_alert_look_around")
			end
		end
		entity.NotSelectAlert=nil 
	end,
	
	RETURN_TO_FIRST = function(self,entity,sender) 
		entity.FastNotDoIdle=nil 
		entity.FirstState=1 
		entity.EventToCall = "OnSpawn" 	
	end,
}