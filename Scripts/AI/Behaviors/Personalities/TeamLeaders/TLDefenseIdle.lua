--------------------------------------------------
--    Created By: Petar
--   Description: <short_description>
--------------------------
--

AIBehaviour.TLDefenseIdle = {
	Name = "TLDefenseIdle",
	switched = 0,

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
		local groupCount=AI:GetGroupCount(entity.id);

		-- dont say anything if no group left alive
		if (groupCount > 2) then
			AI:Signal(SIGNALID_READIBILITY, 1, "LO_DEFENSIVE",entity.id);	
		end

		local protection = AI:FindObjectOfType(entity:GetPos(),20,AIAnchor.AIANCHOR_PROTECT_THIS_POINT);
--		if (protection==nil) then
--			Hud:AddMessage("[AIWARNING] Defensive leader "..entity:GetName().." has no spot to protect");
--			--do return end;
--		end
--
		
		entity:SelectPipe(0,"defense_keepcovered");
		if (entity.AI_PlayerEngaged ==nil ) then 		
			if (protection) then
				entity:InsertSubpipe(0,"defend_point",protection);
			else
				entity:InsertSubpipe(0,"defend_point");
			end
			entity:InsertSubpipe(0,"setup_combat");
			entity:InsertSubpipe(0,"DRAW_GUN");
		end

		entity.AI_PlayerEngaged = 1;		
	end,
	OnEnemyMemory = function( self, entity )
		-- called when the enemy can no longer see its foe, but remembers where it saw it last
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function( self, entity )
		-- called when the enemy hears an interesting sound
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function( self, entity, fDistance )
		-- called when the enemy hears a scary sound
		self:OnPlayerSeen(entity,fDistance);
	end,
	---------------------------------------------
	OnReload = function( self, entity )
		-- called when the enemy goes into automatic reload after its clip is empty
		entity:InsertSubpipe(0,"take_cover");
	end,
	---------------------------------------------
	OnGroupMemberDied = function( self, entity )
		-- called when a member of the group dies
		entity:MakeAlerted();
		self:OnPlayerSeen(entity,0);
	end,
	---------------------------------------------
	OnNoHidingPlace = function( self, entity, sender )
		-- called when no hiding place can be found with the specified parameters
	end,	
	---------------------------------------------
	OnReceivingDamage = function ( self, entity, sender)
		-- called when the enemy is damaged
		entity:InsertSubpipe(0,"take_cover");
	end,
	---------------------------------------------
	OnCoverRequested = function ( self, entity, sender)
		-- called when the enemy is damaged
	end,
	---------------------------------------------
	OnDeath = function ( self, entity)
		AIBehaviour.DEFAULT:OnDeath(entity,sender);
		-- called when the enemy is damaged
		AI:Signal(SIGNALFILTER_SUPERGROUP,1,"BREAK_FORMATION",entity.id);
	end,
	---------------------------------------------
	KeepToSameCover = function ( self, entity, sender)
		-- called when the enemy is damaged
		entity:SelectPipe(0,"defense_keepcovered");
		
	end,


	-- GROUP SIGNALS
	---------------------------------------------	
	KEEP_FORMATION = function (self, entity, sender)
		-- the team leader wants everyone to keep formation
		entity:SelectPipe(0,"standfire");
	end,

	---------------------------------------------	
	HEADS_UP_GUYS = function (self, entity, sender)
		-- the team leader wants everyone to keep formation
		self:OnPlayerSeen(entity,0);
	end,


}
