--------------------------------------------------
--    Created By: Petar


AIBehaviour.ChimpSurround = {
	Name = "ChimpSurround",


	---------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )
		-- called when the enemy sees a living player
		entity:SelectPipe(0,"abberation_hang_back");
		entity:InsertSubpipe(0,"DropBeaconAt");
	
	end,
	---------------------------------------------
	OnEnemyMemory = function( self, entity )
		-- called when the enemy can no longer see its foe, but remembers where it saw it last
		entity:SelectPipe(0,"run_to_beacon");
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function( self, entity )
		-- called when the enemy hears an interesting sound
		entity:InsertSubpipe(0,"DropBeaconAt");
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function( self, entity )
		-- called when the enemy hears a scary sound
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
		entity:InsertSubpipe(0,"chimp_hurt");
	end,
	--------------------------------------------------
	OnBulletRain = function ( self, entity, sender)
		-- called when the enemy detects bullet trails around him
	end,
	--------------------------------------------------
	OnCloseContact = function ( self, entity, sender)
		local rnd=random(1,5);
		entity:SelectPipe(0,"abberation_melee");
		entity:InsertMeleePipe("attack_melee"..rnd);
	end,
	--------------------------------------------------


	SELECT_MOVEMENT = function ( self, entity, sender)
		local rnd = random(1,4);
		if (rnd==1) then 
			entity:InsertSubpipe(0,"abberation_hang_left");
		elseif (rnd == 2) then 
			entity:InsertSubpipe(0,"abberation_hang_right");
		elseif (rnd == 3) then
			entity:InsertSubpipe(0,"abberation_hang_away");
		else
			entity:InsertSubpipe(0,"abberation_wait_back");
		end

	end,

	--------------------------------------------------
	--------------------------------------------------
	SWITCH_TO_ABBERATION_ATTACK = function ( self, entity, sender)
		entity:SelectPipe(0,"abberation_attack");
	end,
	--------------------------------------------------


}