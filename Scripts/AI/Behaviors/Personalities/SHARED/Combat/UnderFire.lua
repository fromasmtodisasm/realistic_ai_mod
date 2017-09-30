--------------------------------------------------
--    Created By: Petar
--   Description: 	This gets called when the guy knows something has happened (he is getting shot at, does not know by whom), or he is hit. Basically
--  			he doesnt know what to do, so he just kinda sticks to cover and tries to find out who is shooting him
--------------------------
--

AIBehaviour.UnderFire = {
	Name = "UnderFire",
	NOPREVIOUS = 1,

	OnNoTarget = function( self, entity )
		-- called when the enemy stops having an attention target
	end,
	---------------------------------------------
	OnGroupMemberDied = function( self, entity )
		-- called when a member of the group dies
	end,
	---------------------------------------------
	OnGroupMemberDiedNearest= function( self, entity )
		-- called when a member of the group dies
	end,
	---------------------------------------------		
	OnPlayerSeen = function( self, entity, fDistance )
		entity:TriggerEvent(AIEVENT_CLEAR);
	end,
	---------------------------------------------		
	OnInterestingSoundHeard = function( self, entity, fDistance )
		entity:TriggerEvent(AIEVENT_CLEAR);
	end,
	---------------------------------------------		
	OnThreateningSoundHeard = function( self, entity, fDistance )
		entity:TriggerEvent(AIEVENT_CLEAR);
	end,

	---------------------------------------------
	OnKnownDamage = function ( self, entity, sender)
		-- called when the enemy is damaged

		if (AI:GetGroupCount(entity.id) > 1) then
			AI:Signal(SIGNALFILTER_GROUPONLY, 1, "HEADS_UP_GUYS",entity.id);
		end

		entity:SelectPipe(0,"search_for_target");
		entity:InsertSubpipe(0,"not_so_random_hide_from",sender.id);
		entity:InsertSubpipe(0,"scared_shoot",sender.id);
		entity:InsertSubpipe(0,"DropBeaconAt",sender.id);
	end,
	--------------------------------------------------
	OnBulletRain = function ( self, entity, sender)
		-- called when the enemy detects bullet trails around him
	end,
	--------------------------------------------------
	OnGrenadeSeen = function( self, entity, fDistance )
		-- called when the enemy sees a grenade
		entity:SelectPipe(0,"grenade_run_away");
	end,
	--------------------------------------------------
	TRY_TO_LOCATE_SOURCE = function (self, entity, sender)
		entity:SelectPipe(0,"lookaround_30seconds");
	end,
}