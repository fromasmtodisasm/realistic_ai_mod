--------------------------------------------------
--    Created By: Petar
--   Description: <short_description>
--------------------------
--

AIBehaviour.TLAttack2Attack = {
	Name = "TLAttack2Attack",
	redpos = 0,
	blackpos = 0,

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
	---------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )
		-- called when the enemy sees a living player
		local count = AI:GetGroupCount(entity.Properties.groupid);
		if (count > 1) then
			entity:InsertSubpipe(0,"update_beacon");
		end
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

		local count = AI:GetGroupCount(entity.id);
		if (count>2) then
			entity.redteammembers = 0;
			entity.blackteammembers = 0;
			entity.redpos = 0;
	 		entity.blackpos = 0;
			entity:SelectPipe(0,"re_split_team");
		else

			AI:Signal(SIGNALFILTER_SUPERGROUP,1,"GROUP_MERGE",entity.id);
			entity:SelectPipe(0,"fire_minimize");
		end
	end,
	---------------------------------------------
	OnNoHidingPlace = function( self, entity, sender )
		-- called when no hiding place can be found with the specified parameters
	end,	
	---------------------------------------------
	OnReceivingDamage = function ( self, entity, sender)
		-- called when the enemy is damaged
		entity:InsertSubpipe(0,"leader_quickhide");
	end,
	---------------------------------------------
	OnCoverRequested = function ( self, entity, sender)
		-- called when the enemy is damaged
	end,
	---------------------------------------------
	OnDeath = function ( self, entity, sender)
		-- called when the enemy is damaged
		AIBehaviour.DEFAULT:OnDeath(entity,sender);
		AI:Signal(SIGNALFILTER_SUPERGROUP,1,"GROUP_MERGE",entity.id);
	end,


		---------------------------------------------	
	START_ATTACK = function (self, entity, sender)
		-- the team leader wants everyone to keep formation
		entity:SelectPipe(0,"coordinate_red_attack");
	end,

	RELAX = function (self, entity, sender)
		-- the team leader wants everyone to keep formation
		entity:SelectPipe(0,"fire_minimize");
	end,

	REDTEAM_INCREASED = function (self, entity, sender)
		-- the team leader wants everyone to keep formation
		entity.redteammembers = entity.redteammembers + 1;
	end,

	BLACKTEAM_INCREASED = function (self, entity, sender)
		-- the team leader wants everyone to keep formation
		entity.blackteammembers = entity.blackteammembers + 1;
	end,


	-- GROUP SIGNALS
	MEMBER_CONTACT = function(self, entity, sender)
		-- someone has contact with our target
		local sighted = AI:GetAttentionTargetOf(sender.id);
		if (sighted and type(sighted)=="table") then
			entity:InsertSubpipe(0,"respond_to_sighting",sighted.id);
		end
	end,
	---------------------------------------------	
	PLAY_SURRENDER = function (self, entity, sender)
		-- the team leader wants everyone to keep formation
		entity:StartAnimation(0,"surrender",1);
	end,
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
		entity.redpos = entity.redpos+1;
		System:LogToConsole("Reds in position ".. entity.redpos.." and members "..entity.redteammembers);
		if (entity.redpos == entity.redteammembers) then
			entity:SelectPipe(0,"coordinate_black_attack");
			entity.blackpos = 0;
		end
	end,
	---------------------------------------------	
	BLACK_IN_POSITION = function (self, entity, sender)
		-- some member of the group is safely in position
		entity.blackpos = entity.blackpos+1;
		System:LogToConsole("Blacks in position ".. entity.blackpos.." and members "..entity.blackteammembers);
		if (entity.blackpos == entity.blackteammembers) then
			entity:SelectPipe(0,"coordinate_red_attack");
			entity.redpos = 0;
		end
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