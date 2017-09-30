--------------------------------------------------
--    Created By: Amanda
--   Description: swats strategicaly moving into area by moving from secure points under cover
--------------------------
--

AIBehaviour.SwatHunt = {
	Name = "SwatHunt",

	-- SYSTEM EVENTS	-----
	---------------------------------------------
	OnSpawn = function( self, entity )
		entity:SelectPipe(0,"standingthere");
	end,
	---------------------------------------------
	OnActivate = function( self, entity )
		-- called when enemy receives an activate event (from a trigger, for example)
	end,
	---------------------------------------------
	OnNoTarget = function( self, entity )
		-- called when the enemy stops having an attention target
	end,
	---------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )
		-- called when the enemy sees a living player
		if (AI:GetGroupCount(entity.Properties.groupid) > 1) then
			-- only send this signal if you are not alone
			AI:Signal(SIGNALFILTER_GROUPONLY, 1, "ENEMY_SPOTTED",entity.id);
			AI:Signal(0,1,"SELECT_GROUPADVANCE",entity.id);
			entity:SelectPipe(0,"DropBeaconAt");
		else
			entity:SelectPipe(0,"swat_singleadvance");
		end
	end,
	---------------------------------------------
	OnEnemySeen = function( self, entity )
		-- called when the enemy sees a foe which is not a living player
		System:LogToConsole("["..entity:GetName().."]+SwatHunt++++++++++++. OnEnemySeen");
	end,
	---------------------------------------------
	OnFriendSeen = function( self, entity )
		-- called when the enemy sees a friendly target
	end,
	---------------------------------------------
	OnDeadBodySeen = function( self, entity )
		-- called when the enemy a dead body
	end,
	---------------------------------------------
	OnEnemyMemory = function( self, entity )
		-- called when the enemy can no longer see its foe, but remembers where it saw it last
--		System:LogToConsole("["..entity:GetName().."]+SwatHunt++++++++++++ OnEnemyMemory");
		entity:SelectPipe(0,"swat_huntLostPlayer");
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function( self, entity )
		--System:LogToConsole("+++++++++++++++++++HUNT interesting sound");
		--System:LogToConsole("inserting subpipe now ---------------------------");
		entity:SelectPipe(0,"swat_investigate");
	--	entity:InsertSubpipe(0,"scout_dropebeacon_and_target");
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function( self, entity )
		--System:LogToConsole("+++++++++++++++++++HUNT threatening sound");
		entity:SelectPipe(0,"swat_investigate");
		--entity:InsertSubpipe(0,"scout_quickhide");
	--	entity:InsertSubpipe(0,"scout_dropebeacon_and_target");

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
		entity:SelectPipe(0,"swat_noHide");
	end,	
	---------------------------------------------
	OnReceivingDamage = function ( self, entity, sender)
		-- called when the enemy is damaged
	end,
	---------------------------------------------
	OnCoverRequested = function ( self, entity, sender)
		-- called when the enemy is damaged
	end,

	KEEP_ALERTED = function ( self, entity, sender)
		-- called when the enemy is damaged
	end, 

	SCOUT_HIDE_LEFT_OR_RIGHT = function ( self, entity, sender)
		-- called when the enemy is damaged
		local rnd = random(1,2);
		if (rnd == 1) then
			--System:LogToConsole("scout_hide_left");
			entity:InsertSubpipe(0,"scout_hide_left");
		else
			--System:LogToConsole("scout_hide_right");
			entity:InsertSubpipe(0,"scout_hide_right");
		end
		
	end, 

	SCOUT_GOTO_ALERT = function ( self, entity, sender)
		-- called when have no more cover between AI and target after hunt
		--entity:SelectPipe(0,"standingthere");
		entity:InsertSubpipe(0,"scout_hide_left");
	end, 


	-- GROUP SIGNALS
	---------------------------------------------	
	KEEP_FORMATION = function (self, entity, sender)
		-- the team leader wants everyone to keep formation
	end,
	---------------------------------------------	
	BREAK_FORMATION = function (self, entity, sender)
		-- the team can split
	end,
	---------------------------------------------	
	SINGLE_GO = function (self, entity, sender)
		-- the team leader has instructed this group member to approach the enemy
	end,
	---------------------------------------------	
	GROUP_COVER = function (self, entity, sender)
		-- the team leader has instructed this group member to cover his friends
	end,
	---------------------------------------------	
	IN_POSITION = function (self, entity, sender)
		-- some member of the group is safely in position
	end,
	---------------------------------------------	
	GROUP_SPLIT = function (self, entity, sender)
		-- team leader instructs group to split
	end,
	---------------------------------------------	
	PHASE_RED_ATTACK = function (self, entity, sender)
		-- team leader instructs red team to attack
	end,
	---------------------------------------------	
	PHASE_BLACK_ATTACK = function (self, entity, sender)
		-- team leader instructs black team to attack
	end,
	---------------------------------------------	
	GROUP_MERGE = function (self, entity, sender)
		-- team leader instructs groups to merge into a team again
	end,
	---------------------------------------------	
	CLOSE_IN_PHASE = function (self, entity, sender)
		-- team leader instructs groups to initiate part one of assault fire maneuver
	end,
	---------------------------------------------	
	ASSAULT_PHASE = function (self, entity, sender)
		-- team leader instructs groups to initiate part one of assault fire maneuver
	end,
	---------------------------------------------	
	GROUP_NEUTRALISED = function (self, entity, sender)
		-- team leader instructs groups to initiate part one of assault fire maneuver
	end,
}