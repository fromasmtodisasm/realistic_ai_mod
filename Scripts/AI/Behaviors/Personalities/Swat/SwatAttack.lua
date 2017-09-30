--------------------------------------------------
--    Created By: Amanda
--   Description: Attack behaviour for the indoor swat personality
--------------------------
--

AIBehaviour.SwatAttack = {
	Name = "SwatAttack",
	Direction = 0,

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
--		System:LogToConsole("["..entity:GetName().."]+SwatAttack++++++++ATTACK OnPlayerSeen: fDistance ["..fDistance .."]");
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
--		System:LogToConsole("["..entity:GetName().."]+SwatAttack+++++++++++. OnEnemySeen");
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
--		System:LogToConsole("["..entity:GetName().."]+SwatAttack++++++++++++ATTACK OnEnemyMemory");
		entity:SelectPipe(0,"swat_huntLostPlayer");
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
	OnClipNearlyEmpty = function(self,entity )
		entity:SelectPipe(0,"swat_coverattack");
	end,
	---------------------------------------------
	OnGroupMemberDied = function( self, entity )
		-- dont handle this
	end,
	---------------------------------------------
	OnGroupMemberDiedNearest = function( self, entity )
		-- dont handle this
	end,
	---------------------------------------------
	OnNoHidingPlace = function( self, entity, sender )
		-- called when no hiding place can be found with the specified parameters
--		System:LogToConsole("["..entity:GetName().."]+SwatAttack+++++++++OnNoHidingPlace");
		entity:SelectPipe(0,"swat_noHide");
	end,	
	---------------------------------------------
	OnReceivingDamage = function ( self, entity, sender)

		-- DO NOT TOUCH THIS READIBILITY SIGNAL	------------------------
		AI:Signal(SIGNALID_READIBILITY, 1, "GETTING_SHOT_AT",entity.id);
		----------------------------------------------------------------

		entity:SelectPipe(0,"swat_coverattack");
		entity:InsertSubpipe(0,"dont_shoot");
	end,
	--------------------------------------------------
	OnBulletRain = function (self,entity, sender)
	end,
	---------------------------------------------
	OnCoverRequested = function ( self, entity, sender)
		-- called when the enemy is damaged
	end,
	---------------------------------------------
	OnGrenadeSeen = function( self, entity, fDistance )
		-- called when the enemy sees a grenade
		--System:LogToConsole("+++++++++++++++++++++++++++OnGrenadeSeen");
		AI:Signal(SIGNALID_READIBILITY, 2, "GRENADE_SEEN",entity.id);
		entity:InsertSubpipe(0,"grenade_run_away");
	end,
	--------------------------------------------------
	-- CUSTOM
	---------------------------------------------------------
--	GoOn = function ( self, entity, sender)
--		-- called when the enemy is damaged
--		entity:SelectPipe(0,"swat_coverattack");
--	end,
	
	swat_attack = function ( self, entity, sender)
	
		local combatAnchor = AI_CombatManager:FindAnchor(entity,AI_CombatManager.AICOMBAT_SWAT,3);
		if (combatAnchor) then
--			System:LogToConsole("["..entity:GetName().."]+SwatAttack++++++++signal [".. combatAnchor.signal.."]");
			entity:SelectPipe(0,combatAnchor.signal,combatAnchor.found);
		else
--			System:LogToConsole("["..entity:GetName().."]+SwatAttack+++++++signal no anchor");
			entity:SelectPipe(0,"swat_comeout");
		end
	end,
	---------------------------------------------
	START_HUNTING = function ( self, entity, sender)
	end,
	---------------------------------------------
	INCOMING_FIRE = function (self, entity, sender)
	end,
	---------------------------------------------
	HEADS_UP_GUYS = function (self, entity, sender)
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
	------------------------------------------------------------------------

}