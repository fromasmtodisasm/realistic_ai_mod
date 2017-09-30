--------------------------------------------------
--   Description: has heared an interesting sound
--------------------------
--

AIBehaviour.SwatThreatened = {
	Name = "SwatThreatened",


	-- SYSTEM EVENTS --
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
		-- reviewed
		AI:Signal(SIGNALID_READIBILITY, 2, "FIRST_HOSTILE_CONTACT",entity.id);	
		if (fDistance<15) then
			AI:Signal(SIGNALFILTER_GROUPONLY, 1, "ENEMY_CLOSE",entity.id);
		end

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
	OnEnemyMemory = function( self, entity )
--		System:LogToConsole("["..entity:GetName().."]+SwatThreatened++++++++++ OnEnemyMemory");
		entity:SelectPipe(0,"swat_huntLostPlayer");
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function( self, entity )
		entity:SelectPipe(0,"swat_approach_threat"); 
	 	entity:InsertSubpipe(0,"DropBeaconTarget"); 
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function( self, entity )
		entity:SelectPipe(0,"swat_approach_threat");
		entity:InsertSubpipe(0,"DropBeaconTarget"); 
	end,
	---------------------------------------------
	OnReload = function( self, entity )
		-- called when the enemy goes into automatic reload after its clip is empty
	end,
	---------------------------------------------
	OnNoHidingPlace = function( self, entity, sender )
		-- called when no hiding place can be found with the specified parameters
--		System:LogToConsole("["..entity:GetName().."]+SwatThreatened++++++++++ OnNoHidingPlace");
		entity:SelectPipe(0,"swat_noHide");
	end,	
	---------------------------------------------
	OnReceivingDamage = function ( self, entity, sender)
		-- called when the enemy is damaged
		AI:Signal(SIGNALFILTER_GROUPONLY, 1, "INCOMING_FIRE",entity.id);

		-- DO NOT TOUCH THIS READIBILITY SIGNAL	------------------------
		AI:Signal(SIGNALID_READIBILITY, 1, "GETTING_SHOT_AT",entity.id);
		----------------------------------------------------------------

		entity:MakeAlerted();
	--	entity:SelectPipe(0,"randomhide");
	end,
	--------------------------------------------------
	OnBulletRain = function ( self, entity, sender)
		-- called when detect weapon fire around AI
	
		AI:Signal(SIGNALFILTER_GROUPONLY, 1, "INCOMING_FIRE",entity.id);
		
		entity:MakeAlerted();
	--	entity:SelectPipe(0,"randomhide");
	end,
	--------------------------------------------------
	OnGrenadeSeen = function( self, entity, fDistance )
		-- called when the enemy sees a grenade
		AI:Signal(SIGNALID_READIBILITY, 2, "GRENADE_SEEN",entity.id);
	--	entity:InsertSubpipe(0,"grenade_run_away");
	end,
	--------------------------------------------------	
	OnCoverRequested = function ( self, entity, sender)
		-- called when cover is requested
	end,
	--------------------------------------------------	
	SCOUT_HIDE_LEFT_OR_RIGHT = function ( self, entity, sender)
		local rnd = random(1,2);
		if (rnd == 1) then
			--System:LogToConsole("+++++++++++++++++++++++++++IDLE scout_hide_left");
			entity:InsertSubpipe(0,"scout_hide_left");
		else
			--System:LogToConsole("+++++++++++++++++++++++++++IDLE scout_hide_right");
			entity:InsertSubpipe(0,"scout_hide_right");
		end
		
	end, 
	--------------------------------------------------
	-- CUSTOM SIGNALS
	--------------------------------------------------
	Cease = function( self, entity, fDistance )
		entity:SelectPipe(0,"swat_cease_approach"); 	 
	end,
	---------------------------------------------
	--------------------------------------------------
	----------------- GROUP SIGNALS ------------------
	--------------------------------------------------
	OnGroupMemberDied = function( self, entity, sender)
		-- call default handling
	 	if (entity ~= sender) then
	 		entity:SelectPipe(0,"swat_goforcover");
	 	end
	end,
	--------------------------------------------------
	OnGroupMemberDiedNearest = function ( self, entity, sender)
		-- call default handling
		entity:SelectPipe(0,"swat_cover");
	end,
	---------------------------------------------
	INCOMING_FIRE = function (self, entity, sender)
		if (entity ~= sender) then
			entity:SelectPipe(0,"randomhide");
		end
	end,
	-------------------------------------------------	
	----------------- SWAT SIGNALS ------------------
	ENEMY_CLOSE  = function (self, entity, sender)
		AI:Signal(0,1,"swat_attack",entity.id);
	end,
	-------------------------------------------------	
	SELECT_GROUPREADY = function ( self, entity, sender)
		entity:SelectPipe(0,"swat_groupwait");
	end,
	--------------------------------------------------	
	SELECT_GROUPADVANCE = function ( self, entity, sender)
		entity:SelectPipe(0,"swat_advance");
		-- entity:InsertSubpipe(0,"DropBeaconAt");
	end,
	-------------------------------------------------
	ENEMY_SPOTTED = function (self, entity, sender)
--		System:LogToConsole("++++++++++++++threatened "..entity:GetName().." received ENEMY_SPOTTED");
		if (entity ~= sender) then 
			entity:SelectPipe(0,"AcqBeacon");
			AI:Signal(0,1,"SELECT_GROUPREADY",entity.id);
		end
	end,
	------------------------------------------------------------------------
}