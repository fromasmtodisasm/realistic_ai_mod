--------------------------------------------------
--    Created By: Petar


AIBehaviour.KriegerIdle = {
	Name = "KriegerIdle",


	---------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )
		-- called when the enemy sees a living player

		entity:SelectPipe(0,"krieger_fast_shoot");
	end,
	---------------------------------------------
	OnSomethingSeen = function( self, entity, fDistance )
		-- called when the enemy thinks he sees something

		entity:SelectPipe(0,"fast_investigate");
		--entity:InsertAnimationPipe("surprise01");
		entity:InsertSubpipe(0,"setup_combat");
		entity.cnt:HoldGun();
		
	end,
	---------------------------------------------
	OnEnemyMemory = function( self, entity )
		-- called when the enemy can no longer see its foe, but remembers where it saw it last
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function( self, entity )
		-- called when the enemy hears an interesting sound
		entity:SelectPipe(0,"fast_investigate");
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function( self, entity )
		-- called when the enemy hears a scary sound
		entity:SelectPipe(0,"fast_investigate");
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



	JUMP_FINISHED = function (self, entity, sender)
		entity:SelectPipe(0,"krieger_fast_shoot");
	end,

	SELECT_HIDE_METHOD = function (self, entity, sender)
		local rnd = random(1,2);
		if (rnd == 1) then 
			entity:InsertSubpipe(0,"krieger_hide_left");
		else
			entity:InsertSubpipe(0,"krieger_hide_right");
		end
		
	end,



}