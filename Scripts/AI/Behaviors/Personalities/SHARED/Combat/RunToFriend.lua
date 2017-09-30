--------------------------------------------------
--   Created By: petar
--   Description: this is used to run to help a mate who called for help
--------------------------

AIBehaviour.RunToFriend = {
	Name = "RunToFriend",
	NOPREVIOUS = 1,
	
	---------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )
		entity:TriggerEvent(AIEVENT_CLEAR);
	end,
	---------------------------------------------
	OnEnemyMemory = function( self, entity )
		-- called when the enemy can no longer see its foe, but remembers where it saw it last
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function( self, entity )
		--entity:InsertSubpipe(0,"check_it_out");
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function( self, entity )
		entity:TriggerEvent(AIEVENT_CLEAR);
	end,
	---------------------------------------------
	OnReceivingDamage = function ( self, entity, sender)
	end,
	--------------------------------------------------
	OnBulletRain = function ( self, entity, sender)	
	end,
	--------------------------------------------------
	OnGrenadeSeen = function( self, entity, fDistance )
	end,
	

	OnGroupMemberDied = function( self, entity, sender)
	end,
	--------------------------------------------------
	OnGroupMemberDiedNearest = function ( self, entity, sender)
	end,
	--------------------------------------------------
	-- GROUP SIGNALS
	--------------------------------------------------
	HEADS_UP_GUYS = function (self, entity, sender)
	end,
	---------------------------------------------
	INCOMING_FIRE = function (self, entity, sender)
	end,
	---------------------------------------------
	MOVE_IN_FORMATION = function (self, entity, sender)
	end,

	FINISH_RUN_TO_FRIEND = function (self, entity, sender)
		entity:TriggerEvent(AIEVENT_CLEAR);
	end,

	
}