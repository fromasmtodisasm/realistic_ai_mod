--------------------------------------------------
--    Created By: Petar
--   Description: <short_description>
--------------------------
--

AIBehaviour.TLAttack2Idle = {
	Name = "TLAttack2Idle",

	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSelected = function( self, entity )	
	end,
	---------------------------------------------
	OnSpawn = function( self, entity )
		-- called when enemy spawned or reset
	end,
	---------------------------------------------
	OnActivate = function( self, entity )
		-- called when enemy receives an activate event (from a trigger, for example)
	end,
	---------------------------------------------
	OnNoTarget = function( self, entity )
		-- called when the enemy stops having an attention target
	end,

	INIT_TEAM_COUNTERS = function( self, entity, sender )
		entity.PLAYER_ALREADY_SEEN = nil;
		--System:LogToConsole("\001 INITIALIZING TEAM COUNTERS +++++++++++++++++++++++++++++++++++++++++++++++++++++");
		entity.redpos = 0;
		entity.blackpos = 0;
		entity.blackteammembers = 0;
		entity.redteammembers = 0;
	end,	
	---------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )

		if (AI:GetGroupCount(entity.id)<3) then 
			entity:SelectPipe(0,"fire_minimize");
			entity:InsertSubpipe(0,"setup_combat");
			entity:InsertSubpipe(0,"DRAW_GUN");
			entity:InsertSubpipe(0,"DropBeaconAt");
			return
		end

		if (entity.PLAYER_ALREADY_SEEN==nil) then 
			entity.PLAYER_ALREADY_SEEN = 1;
			AI:Signal(SIGNALFILTER_SUPERGROUP,1,"HEADS_UP_GUYS",entity.id);
			entity:SelectPipe(0,"split_team");
			entity:InsertSubpipe(0,"DropBeaconAt");
			--entity:InsertSubpipe(0,"offer_join_team");
			entity:InsertSubpipe(0,"DRAW_GUN");
			-- called when the enemy sees a living player
	
			if (entity.RunToTrigger == nil) then
				entity:RunToAlarm();
			end
		end
	end,

	---------------------------------------------
	OnSomethingSeen = function( self, entity, fDistance )
		-- called when the enemy sees a living player
	end,

	---------------------------------------------
	OnEnemySeen = function( self, entity )
		-- called when the enemy sees a foe which is not a living player
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
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function( self, entity )
		-- called when the enemy hears an interesting sound
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function( self, entity,fDistance )
		-- called when the enemy hears a scary sound
		entity:MakeAlerted();
		--self:OnPlayerSeen(entity,fDistance)
		if (entity.PLAYER_ALREADY_SEEN==nil) then 
			entity:SelectPipe(0,"minimize_exposure");
			--AI:Signal(SIGNALFILTER_SUPERGROUP,1,"HIDE_FROM_BEACON",entity.id);
		else
			self:OnPlayerSeen(entity,fDistance)
		end
		entity:TriggerEvent(AIEVENT_DROPBEACON);
	end,
	---------------------------------------------
	OnReload = function( self, entity )
		-- called when the enemy goes into automatic reload after its clip is empty
	end,
	---------------------------------------------
	OnGroupMemberDied = function( self, entity ,sender)
		-- called when a member of the group dies


		if (entity.PLAYER_ALREADY_SEEN==nil) then 
			AI:Signal(SIGNALFILTER_SUPERGROUP,1,"HIDE_FROM_BEACON",entity.id);
			entity:SelectPipe(0,"minimize_exposure");
			entity:InsertSubpipe(0,"hide_from_beacon");
			entity:InsertSubpipe(0,"setup_combat");
		else
			local count = AI:GetGroupCount(entity.Properties.groupid);
			if (count>2) then
				entity.redteammembers = 0;
				entity.blackteammembers = 0;
				entity.redpos = 0;
		 		entity.blackpos = 0;
				entity:SelectPipe(0,"re_split_team");
			else
				AI:Signal(SIGNALFILTER_SUPERGROUP,1,"GROUP_MERGE",entity.id);
			end
		end
	end,
	---------------------------------------------
	OnNoHidingPlace = function( self, entity, sender )
		-- called when no hiding place can be found with the specified parameters
	end,	
	---------------------------------------------
	OnReceivingDamage = function ( self, entity, sender)
		entity:InsertSubpipe(0,"leader_quickhide");
		-- called when the enemy is damaged
	end,
	---------------------------------------------
	OnCoverRequested = function ( self, entity, sender)
		-- called when the enemy is damaged
	end,
	---------------------------------------------
	OnDeath = function ( self, entity, sender)

		AIBehaviour.DEFAULT:OnDeath(entity,sender);
		-- called when the enemy is damaged
		AI:Signal(SIGNALFILTER_SUPERGROUP,1,"GROUP_MERGE",entity.id);
	end,
	---------------------------------------------
	AISF_CallForHelp = function ( self, entity, sender)
		entity:SelectPipe(0,"AIS_GoToTag",sender.id);
	end,
	---------------------------------------------

	REDTEAM_INCREASED = function (self, entity, sender)
		-- the team leader wants everyone to keep formation
		entity.redteammembers = entity.redteammembers + 1;
	end,

	BLACKTEAM_INCREASED = function (self, entity, sender)
		-- the team leader wants everyone to keep formation
		entity.blackteammembers = entity.blackteammembers + 1;
	end,


	MEMBER_CONTACT = function(self, entity, sender)
		-- someone has contact with our target
	end,

	MOVE_IN_FORMATION = function(self, entity, sender)
	end,

	---------------------------------------------	
	START_ATTACK = function (self, entity, sender)
		-- the team leader wants everyone to keep formation
		entity:SelectPipe(0,"coordinate_red_attack");
	end,

	---------------------------------------------	
	SELECT_RED = function (self, entity, sender)
	end,
	---------------------------------------------	
	SELECT_BLACK = function (self, entity, sender)
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
	RED_IN_POSITION = function (self, entity, sender)
		-- some member of the group is safely in position
		entity:SelectPipe(0,"coordinate_black_attack");
	end,
	--------------------------------------------------------------------------
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


	---------------------------------------------	
	HEADS_UP_GUYS = function (self, entity, sender)
		-- the team leader wants everyone to keep formation
		if (entity~=sender) then 
			entity:MakeAlerted();
			entity:SelectPipe(0,"split_team");
			if (entity.AI_GunOut==nil) then		
				entity:InsertSubpipe(0,"DRAW_GUN");
			end	
		end
	end,
}