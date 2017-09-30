--------------------------------------------------
--    Created By: Petar


AIBehaviour.ScrewedIdle = {
	Name = "ScrewedIdle",


	---------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )
		-- called when the enemy sees a living player


		entity:SelectPipe(0,"mutant_screwed_attack");


		if (AI:GetGroupCount(entity.id) > 1) then	
			AI:Signal(SIGNALID_READIBILITY, AIREADIBILITY_SEEN, "FIRST_HOSTILE_CONTACT_GROUP",entity.id);	
			AI:Signal(SIGNALFILTER_SUPERGROUP, 1, "HEADS_UP_GUYS",entity.id);
			AI:Signal(SIGNALFILTER_SUPERGROUP, 1, "wakeup",entity.id);
			entity:InsertSubpipe(0,"mutant_shared_bellowhowl");
			entity:InsertSubpipe(0,"DropBeaconAt");
		else
			AI:Signal(SIGNALID_READIBILITY, AIREADIBILITY_SEEN, "FIRST_HOSTILE_CONTACT",entity.id);	
		end


		-- bellow and howl

		
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
	HEADS_UP_GUYS = function ( self, entity, sender)
		if (entity.id ~= sender.id) then
			entity:SelectPipe(0,"mutant_screwed_attack");
			entity:InsertSubpipe(0,"run_to_beacon");
			entity:InsertSubpipe(0,"random_timeout");
		end
	end,

}