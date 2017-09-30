--------------------------------------------------
--    Created By: Petar


AIBehaviour.MorphIdle = {
	Name = "MorphIdle",


	---------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )

		entity:SelectPipe(0,"morpher_attack_wrapper");

		if (entity.AI_GunOut == nil) then
			entity:InsertSubpipe(0,"DRAW_GUN");
		end

		if (entity:NotifyGroup()==nil) then
			AI:Signal(SIGNALFILTER_SUPERGROUP, 1, "HEADS_UP_GUYS",entity.id);
			AI:Signal(SIGNALFILTER_SUPERGROUP, 1, "wakeup",entity.id);
			
		end

		entity:InsertSubpipe(0,"DropBeaconAt");


	end,
	---------------------------------------------
	OnSomethingSeen = function( self, entity, fDistance )
		-- called when the enemy sees a living player
		local rnd=random(1,5);
		if (rnd==1) then
			entity:MutantJump(AIAnchor.MUTANT_AIRDUCT);
--			entity:InsertSubpipe(0,"setup_crouch");
		else
			entity:SelectPipe(0,"stealth_investigate");
		end
		entity:InsertSubpipe(0,"DropBeaconAt");
		entity:InsertSubpipe(0,"DRAW_GUN");


	end,
	---------------------------------------------
	OnEnemyMemory = function( self, entity )
		-- called when the enemy can no longer see its foe, but remembers where it saw it last
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function( self, entity )
		-- called when the enemy hears an interesting sound
		entity:InsertSubpipe(0,"mutant_run_towards_target");
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function( self, entity )
		-- called when the enemy hears a scary sound
		entity:InsertSubpipe(0,"mutant_run_towards_target");
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
	JUMP_FINISHED = function ( self, entity, sender)

		entity:SelectPipe(0,"mutant_walk_to_beacon");
		entity:InsertSubpipe(0,"setup_combat");
	end,

	--------------------------------------------------
	MORPH = function ( self, entity, sender)
		entity:GoVisible();
--		AI:Cloak(entity.id);
	end,
	--------------------------------------------------
	UNMORPH = function ( self, entity, sender)
		AI:DeCloak(entity.id);
	end,

	--------------------------------------------------
	HEADS_UP_GUYS = function ( self, entity, sender)
		entity:SelectPipe(0,"mutant_run_to_beacon");
	end,

	--------------------------------------------------
	GO_REFRACTIVE = function ( self, entity, sender)
	end,
	--------------------------------------------------
	GO_VISIBLE = function ( self, entity, sender)
	end,

}