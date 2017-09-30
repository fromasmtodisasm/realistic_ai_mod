--------------------------------------------------
--    Created By: Petar


AIBehaviour.ModMorphAttack = {
	Name = "ModMorphAttack",

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

		entity:SelectPipe(0,"morpher_attack_wrapper");
		entity:InsertSubpipe(0,"DropBeaconAt");
	end,
	---------------------------------------------
	OnPlayerLookingAway =  function( self, entity, fDistance )
		entity:GoRefractive();
--		AI:Cloak(entity.id);
		entity:SelectPipe(0,"morpher_invisible_attack");
	end,

	---------------------------------------------
	OnEnemyMemory = function( self, entity )
		-- called when the enemy can no longer see its foe, but remembers where it saw it last
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function( self, entity )
		-- called when the enemy hears an interesting sound
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function( self, entity )
		-- called when the enemy hears a scary sound
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
		entity:InsertSubpipe(0,"mutant_run_towards_target");
	end,	
	---------------------------------------------
	OnReceivingDamage = function ( self, entity, sender)
		entity:MutantJump(AIAnchor.MUTANT_AIRDUCT);
--		entity:InsertSubpipe(0,"setup_crouch");
	end,
	--------------------------------------------------
	OnBulletRain = function ( self, entity, sender)
		-- called when the enemy detects bullet trails around him
	end,
	--------------------------------------------------
	OnCloseContact = function ( self, entity, sender)
		entity:GoVisible();
		entity:SelectPipe(0,"morpher_attack_wrapper");
		if (entity.MELEE_ANIM_COUNT) then
			local rnd = random(1,entity.MELEE_ANIM_COUNT);
			local melee_anim_name = format("attack_melee%01d",rnd);
			entity:InsertAnimationPipe(melee_anim_name,3);
		else
			Hud:AddMessage("==================UNACCEPTABLE ERROR====================");
			Hud:AddMessage("Entity "..entity:GetName().." made melee attack but has no melee animations.");
			Hud:AddMessage("==================UNACCEPTABLE ERROR====================");
		end
	end,
	--------------------------------------------------

	
	SELECT_MORPH_ATTACK = function ( self, entity, sender)
		local rnd=random(1,3);
		if (rnd==1) then 
			entity:InsertSubpipe(0,"morpher_attack_left");
		elseif (rnd==2) then 
			entity:InsertSubpipe(0,"morpher_attack_right");
		else
			entity:InsertSubpipe(0,"morpher_attack_retreat");
		end
	end,
	--------------------------------------------------

}