--------------------------------------------------
--    Created By: Petar


AIBehaviour.FastAttack = {
	Name = "FastAttack",

	---------------------------------------------
	OnKnownDamage = function ( self, entity, sender)
		local mytarget = AI:GetAttentionTargetOf(entity.id);
		if (mytarget) then 
			if (type(mytarget)=="table") then 
				if ((mytarget ~= sender) and (sender==_localplayer)) then 
					entity:SelectPipe(0,"retaliate_damage",sender.id);
				end
			end
		end
	end,


	---------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )
		-- called when the enemy sees a living player
		
	end,
	---------------------------------------------
	OnPlayerAiming = function ( self, entity, sender)
		if (entity:MutantJump(AIAnchor.MUTANT_JUMP_TARGET,30,2+1) == nil) then 
			if (entity.AI_CanWalk) then
				local rnd = random(1,10);
				if (rnd>5) then 
					entity:SelectPipe(0,"fast_shoot_approach");
				--	entity:InsertSubpipe(0,"minimize_exposure");
				end
			end
		end
	end,
	---------------------------------------------
	OnEnemyMemory = function( self, entity )
		-- called when the enemy can no longer see its foe, but remembers where it saw it last
		if (entity:MutantJump(AIAnchor.MUTANT_JUMP_TARGET,30,2+1) == nil) then
			if (entity.AI_CanWalk) then
				entity:SelectPipe(0,"fast_shoot");
				entity:SelectPipe(0,"fast_shoot_approach");
			end
		end
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function( self, entity )
		-- called when the enemy hears an interesting sound
		if (entity.AI_CanWalk) then
			entity:SelectPipe(0,"fast_shoot");
			entity:SelectPipe(0,"fast_shoot_approach");
		end
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function( self, entity )
		-- called when the enemy hears a scary sound
		if (entity.AI_CanWalk) then
			entity:SelectPipe(0,"fast_shoot");
			entity:SelectPipe(0,"fast_shoot_approach");
		end
	end,
	---------------------------------------------
	OnReload = function( self, entity )
		-- called when the enemy goes into automatic reload after its clip is empty
	end,
	---------------------------------------------
	OnGroupMemberDied = function( self, entity )
		-- called when a member of the group dies
	end,
	---------------------------------------------
	OnNoHidingPlace = function( self, entity, sender )
		-- called when no hiding place can be found with the specified parameters
	end,	
	---------------------------------------------
	OnReceivingDamage = function ( self, entity, sender)
	end,
	--------------------------------------------------
	OnBulletRain = function ( self, entity, sender)
		-- called when the enemy detects bullet trails around him
	end,
	--------------------------------------------------
	OnCloseContact = function ( self, entity, sender)
		local rnd=random(1,5);
		entity:InsertMeleePipe("attack_melee"..rnd);
		local dur = entity:GetAnimationLength("attack_melee"..rnd);
		AI:EnablePuppetMovement(entity.id,0,dur+0.3);
		entity:TriggerEvent(AIEVENT_ONBODYSENSOR,dur+0.3);
	end,
	--------------------------------------------------

	SWITCH_TO_SHOOT = function ( self, entity, sender)
		entity:SelectPipe(0,"fast_shoot");
	end,
	--------------------------------------------------

	
	JUMP_FINISHED = function (self, entity, sender)
		if (self.Walking) then
			entity:SelectPipe(0,"fast_shoot_approach");
		else
			entity:SelectPipe(0,"fast_shoot");
		end
	end,
}