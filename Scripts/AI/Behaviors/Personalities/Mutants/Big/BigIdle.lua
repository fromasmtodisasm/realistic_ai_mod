--------------------------------------------------
--    Created By: Petar


AIBehaviour.BigIdle = {
	Name = "BigIdle",


	---------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )
		-- called when the enemy sees a living player


		entity:SelectPipe(0,"big_pindown");
		

		if (fDistance>10) then
			entity:InsertSubpipe(0,"big_shoot");		
		end

		entity:PushStuff();


		if (AI:GetGroupCount(entity.id) > 1) then	

			-- bellow and howl
			entity:InsertSubpipe(0,"mutant_shared_bellowhowl");

			AI:Signal(SIGNALID_READIBILITY, AIREADIBILITY_SEEN, "FIRST_HOSTILE_CONTACT_GROUP",entity.id);	

			if (entity:NotifyGroup()==nil) then
				AI:Signal(SIGNALFILTER_SUPERGROUP, 1, "HEADS_UP_GUYS",entity.id);
				AI:Signal(SIGNALFILTER_SUPERGROUP, 1, "wakeup",entity.id);
			end
	
		else
			AI:Signal(SIGNALID_READIBILITY, AIREADIBILITY_SEEN, "FIRST_HOSTILE_CONTACT",entity.id);	
		end

		entity:InsertSubpipe(0,"setup_combat");	
		entity:TriggerEvent(AIEVENT_DROPBEACON);			
		
	end,
	---------------------------------------------
	OnEnemyMemory = function( self, entity )
		-- called when the enemy can no longer see its foe, but remembers where it saw it last
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function( self, entity )
		-- called when the enemy hears an interesting sound
		entity:SelectPipe(0,"mutant_walk_to_target");
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function( self, entity )
		-- called when the enemy hears a scary sound
		entity:SelectPipe(0,"mutant_walk_to_target");
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
	---------------------------------------------
	OnGrenadeSeen = function ( self, entity, sender)

		-- DO NOT TOUCH THIS READIBILITY SIGNAL	---------------------------
		AI:Signal(SIGNALID_READIBILITY, 1, "GRENADE_SEEN",entity.id);
		-------------------------------------------------------------------
		entity:InsertSubpipe(0,"cover_grenade_run_away");
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
	PLAY_SHOOT_ANIMATION = function ( self, entity, sender)
		--entity:InsertSubpipe(0,"big_new_shoot");
		entity:InsertAnimationPipe("fire_special00");
	end,

	HEADS_UP_GUYS = function (self, entity, sender)
		if (entity ~= sender) then
			entity:MakeAlerted();
			entity:SelectPipe(0,"mutant_run_to_beacon");
		end
		entity.RunToTrigger = 1;
	end,

	HIT_THE_SPOT = function ( self, entity, sender)
		entity:SelectPipe(0,"big_pindown");
		entity:TriggerEvent(AIEVENT_ONBODYSENSOR, entity:GetAnimationLength("idle07"));
		entity:InsertAnimationPipe("weakspot_reaction");
	end,

}