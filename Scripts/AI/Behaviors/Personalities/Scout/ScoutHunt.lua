--------------------------------------------------
--    Created By: Petar
--   Description: the scout is hunting the poor bastard
--------------------------
--

AIBehaviour.ScoutHunt = {
	Name = "ScoutHunt",

	OnNoTarget = function( self, entity )
		-- called when the enemy stops having an attention target
		entity:SelectPipe(0,"disturbance_let_it_go");
		entity:InsertSubpipe(0,"HOLSTER_GUN");
		entity:InsertSubpipe(0,"approach_beacon");
		entity:InsertSubpipe(0,"random_timeout");
		entity:InsertSubpipe(0,"setup_stealth");
	end,
	---------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )
		entity:MakeAlerted();

		entity:Readibility("FIRST_HOSTILE_CONTACT");

		if (AI:GetGroupCount(entity.id) > 1) then
			-- only send this signal if you are not alone

			if (fDistance<15) then
				entity:SelectPipe(0,"scout_tooclose_attack_beacon");
			else
				entity:SelectPipe(0,"scout_scramble_beacon");
			end

			if (entity:NotifyGroup()==nil) then
				AI:Signal(SIGNALFILTER_SUPERGROUP, 1, "wakeup",entity.id);
				AI:Signal(SIGNALFILTER_SUPERGROUP, 1, "HEADS_UP_GUYS",entity.id);
			end

		else
			-- you are on your own
			if (fDistance<15) then
				entity:SelectPipe(0,"scout_tooclose_attack");
			else
				entity:SelectPipe(0,"scout_scramble");
			end
		end

		if (entity.RunToTrigger == nil) then
			entity:RunToAlarm();
		end

	end,
	---------------------------------------------
	OnEnemyMemory = function( self, entity )
		-- called when the enemy can no longer see its foe, but remembers where it saw it last
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function( self, entity )
		entity:MakeAlerted();
		entity:SelectPipe(0,"scout_hunt");
		entity:InsertSubpipe(0,"DropBeaconAt");
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function( self, entity )
		--System:LogToConsole("+++++++++++++++++++HUNT threatening sound");
		entity:SelectPipe(0,"scout_hunt");
		--entity:InsertSubpipe(0,"scout_quickhide");
		entity:InsertSubpipe(0,"scout_dropebeacon_and_target");
		entity:Blind_RunToAlarm();

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
	IN_POSITION = function (self, entity, sender)
		-- some member of the group is safely in position
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

}