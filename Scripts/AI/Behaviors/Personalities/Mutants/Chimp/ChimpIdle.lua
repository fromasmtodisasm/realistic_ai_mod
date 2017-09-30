--------------------------------------------------
--    Created By: Petar


AIBehaviour.ChimpIdle = {
	Name = "ChimpIdle",


	
	---------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )
		-- called when the enemy sees a living player


		entity:SelectPipe(0,"abberation_attack");

		if (AI:GetGroupCount(entity.id) > 1) then	
			AI:Signal(SIGNALID_READIBILITY, AIREADIBILITY_SEEN, "FIRST_HOSTILE_CONTACT_GROUP",entity.id);	
			AI:Signal(SIGNALFILTER_SUPERGROUP, 1, "HEADS_UP_GUYS",entity.id);
			AI:Signal(SIGNALFILTER_SUPERGROUP, 1, "wakeup",entity.id);
		else
			AI:Signal(SIGNALID_READIBILITY, AIREADIBILITY_SEEN, "FIRST_HOSTILE_CONTACT",entity.id);	
		end

		local SetAngle = entity.Properties.fJumpAngle;
		entity.Properties.fJumpAngle = 38;
		entity.TEMP_RESULT = entity:MutantJump(AIAnchor.MUTANT_JUMP_SMALL,20);
		entity.Properties.fJumpAngle=SetAngle;
		
		-- bellow and howl
		if (entity.TEMP_RESULT == nil) then
			entity:InsertSubpipe(0,"jump_decision");
		end
		entity:InsertSubpipe(0,"DropBeaconAt");
		
	end,
	---------------------------------------------
	OnEnemyMemory = function( self, entity )
		-- called when the enemy can no longer see its foe, but remembers where it saw it last
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function( self, entity )
		-- called when the enemy hears an interesting sound
		entity:Readibility("IDLE_TO_INTERESTED");
		entity:SelectPipe(0,"mutant_walk_to_target");
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function( self, entity )
		-- called when the enemy hears a scary sound
		entity:Readibility("IDLE_TO_THREATENED",1);
		entity:SelectPipe(0,"abberation_attack");
		entity:InsertSubpipe(0,"DropBeaconAt");
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
		-- called when the enemy is damaged
		entity:SelectPipe(0,"abberation_scared");
	end,
	--------------------------------------------------
	OnBulletRain = function ( self, entity, sender)
		-- called when the enemy detects bullet trails around him
	end,
	--------------------------------------------------
	MAKE_BELLOW_HOWL_ANIMATION = function ( self, entity, sender)
		entity:InsertAnimationPipe("idle05");
	end,
	--------------------------------------------------
	OnDeath = function ( self, entity, sender)
		-- get someone else to attack the player
		AI:Signal(SIGNALFILTER_NEARESTGROUP,1,"SWITCH_TO_ATTACK",entity.id);
	end,

	--------------------------------------------------
	HEADS_UP_GUYS = function ( self, entity, sender)
		if (entity.id ~= sender.id) then
			entity:SelectPipe(0,"run_to_beacon");
			local SetAngle = entity.Properties.fJumpAngle;
			entity.Properties.fJumpAngle = 45;
			entity:MutantJump(AIAnchor.MUTANT_JUMP_SMALL,20);
			entity.Properties.fJumpAngle=SetAngle;
		end
		entity.EventToCall = "OnPlayerSeen";
	end,

	MAKE_COMBAT_BREAK_ANIM = function ( self, entity, sender)
		
		if (entity.COMBAT_IDLE_COUNT) then
			local rnd = random(0,entity.COMBAT_IDLE_COUNT);
			local idle_anim_name = format("combat_idle%02d",rnd);
			entity:InsertAnimationPipe(idle_anim_name,3);
		else
			Hud:AddMessage("============ UNACCEPTABLE ERROR ===================");
			Hud:AddMessage("[ASSETERROR] No combat idles for "..entity:GetName());
			Hud:AddMessage("============ UNACCEPTABLE ERROR ===================");
		end

	end,

	--------------------------------------------------
	SEEK_JUMP_ANCHOR = function ( self, entity, sender)
		local att_target = AI:GetAttentionTargetOf(entity.id);
		if (att_target) then 
			if (type(att_target) == "table") then
				if (att_target == _localplayer) then 
					entity:MutantJump(AIOBJECT_PLAYER,13);
				else
					entity:MutantJump(AIOBJECT_PUPPET,10);
				end
			end
		end
	end,
	--------------------------------------------------
	JUMP_FINISHED = function ( self, entity, sender)
		entity:SelectPipe(0,"abberation_attack");
	end,


	SWITCH_TO_ATTACK = function ( self, entity, sender)
		entity:SelectPipe(0,"abberation_attack");
	end,


	--------------------------------------------------
	ANY_MORE_TO_RELEASE = function ( self, entity, sender)
		local release_friends = AI:FindObjectOfType(entity.id,50,AIAnchor.MUTANT_LOCK);
		if (release_friends) then 
			entity:SelectPipe(0,"bust_lock_at",release_friends);			
		else
			entity:SelectPipe(0,"abberation_attack");
		end
	end,
}