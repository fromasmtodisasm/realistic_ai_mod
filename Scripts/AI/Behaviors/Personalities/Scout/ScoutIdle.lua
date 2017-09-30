--------------------------------------------------
--    Created By: Petar
--   Description: This behaviour describes the SCOUT personality in idle mode
--------------------------
--

AIBehaviour.ScoutIdle = {
	Name = "ScoutIdle",





	---------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )
		-- reviewed

		entity:Readibility("FIRST_HOSTILE_CONTACT");
		if (AI:GetGroupCount(entity.id) > 1) then
			-- only send this signal if you are not alone
			if (entity:NotifyGroup()==nil) then	
				AI:Signal(SIGNALFILTER_SUPERGROUP, 1, "wakeup",entity.id);
				AI:Signal(SIGNALFILTER_SUPERGROUP, 1, "HEADS_UP_GUYS",entity.id);
			end

			if (fDistance<15) then
				entity:SelectPipe(0,"scout_tooclose_attack_beacon");
			else
				entity:SelectPipe(0,"scout_scramble_beacon");
			end

		else
			-- you are on your own
			if (fDistance<15) then
				entity:SelectPipe(0,"scout_tooclose_attack");
			else
				entity:SelectPipe(0,"scout_scramble");
			end
		end
		entity:InsertSubpipe(0,"DRAW_GUN");
	end,
	---------------------------------------------
	OnSomethingSeen = function(self, entity)

		entity:Readibility("IDLE_TO_INTERESTED");
		entity:SelectPipe(0,"scout_hunt_beacon");
		entity:InsertSubpipe(0,"DropBeaconAt");
		entity:InsertSubpipe(0,"DRAW_GUN");
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function( self, entity )

		entity:Readibility("IDLE_TO_INTERESTED");		
		entity:MakeAlerted();
		entity:SelectPipe(0,"scout_interesting_sound");
		entity:InsertSubpipe(0,"DropBeaconAt");
		entity:InsertSubpipe(0,"DRAW_GUN");
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function( self, entity, fDistance )

		entity:Readibility("IDLE_TO_THREATENED",1);

		local dist = AI:FindObjectOfType(entity:GetPos(),fDistance, AIAnchor.HOLD_THIS_POSITION);
		if (dist) then
			entity:MakeAlerted();

			AI:Signal(0,1,"HOLD_POSITION",entity.id);
			entity:SelectPipe(0,"special_hold_position");
			if (entity.AI_GunOut) then
				entity:InsertSubpipe(0,"setup_stealth"); 
				entity:InsertSubpipe(0,"DRAW_GUN"); 
			end
		else
	
			entity:MakeAlerted();
			entity:SelectPipe(0,"scout_threatening_sound");
			entity:InsertSubpipe(0,"DropBeaconAt");
			entity:InsertSubpipe(0,"scout_find_threat");
			entity:InsertSubpipe(0,"setup_combat");
			entity:InsertSubpipe(0,"DRAW_GUN");
			AI:Signal(0,1,"NORMAL_THREAT_SOUND",entity.id);
		end
	

		entity:GettingAlerted();
		entity:Blind_RunToAlarm();



	end,
	---------------------------------------------
	OnGroupMemberDied = function( self, entity, sender)
		-- call default handling
		AIBehaviour.DEFAULT:OnGroupMemberDied(entity,sender);
		entity:MakeAlerted();
		
		if (sender.groupid == entity.groupid) then
		 	if (entity ~= sender) then
		 		entity:SelectPipe(0,"TeamMemberDiedLook");
		 	end
		end
	end,
	--------------------------------------------------
	OnGroupMemberDiedNearest = function ( self, entity, sender)
		-- call default handling
		AIBehaviour.DEFAULT:OnGroupMemberDiedNearest(entity,sender);

		-- do scout stuff
		-- investigate corpse
		entity:SelectPipe(0,"RecogCorpse",sender.id);
	end,
	---------------------------------------------
	OnReceivingDamage = function ( self, entity, sender)
		-- called when the enemy is damaged
		AI:Signal(SIGNALFILTER_GROUPONLY, 1, "INCOMING_FIRE",entity.id);

		entity:Readibility("GETTING_SHOT_AT",1);
		entity:MakeAlerted();
		entity:SelectPipe(0,"randomhide");
		entity:InsertSubpipe(0,"DRAW_GUN");
	end,
	--------------------------------------------------
	OnBulletRain = function ( self, entity, sender)
		-- called when detect weapon fire around AI
	
		AI:Signal(SIGNALFILTER_GROUPONLY, 1, "INCOMING_FIRE",entity.id);
		
		entity:MakeAlerted();
		entity:SelectPipe(0,"randomhide");
		entity:InsertSubpipe(0,"DRAW_GUN");
	end,
	---------------------------------------------
	OnCoverRequested = function ( self, entity, sender)
		-- called when cover is requested
	end,
	--------------------------------------------------
	OnGrenadeSeen = function( self, entity, fDistance )
		-- called when the enemy sees a grenade
		entity:Readibility("GRENADE_SEEN",1);
		entity:InsertSubpipe(0,"grenade_run_away");
	end,
	---------------------------------------------
	INCOMING_FIRE = function (self, entity, sender)
		if (entity ~= sender) then
			entity:SelectPipe(0,"randomhide");
			if (entity.AI_GunOut==nil) then 
				entity:InsertSubpipe(0,"DRAW_GUN");	
			end
		end
	end,
	---------------------------------------------
	HEADS_UP_GUYS = function (self, entity, sender)
		if (entity ~= sender) then 
			entity:MakeAlerted();
			entity:SelectPipe(0,"scout_hunt_beacon");
			entity:InsertSubpipe(0,"DRAW_GUN");
		end
		entity.RunToTrigger = 1;
	end,
	

	---------------------------------------------	
	THREAT_TOO_CLOSE = function (self, entity, sender)
		-- the team can split
		entity:MakeAlerted();
		entity:SelectPipe(0,"scout_threatening_sound");
		entity:InsertSubpipe(0,"DropBeaconAt");
		entity:InsertSubpipe(0,"scout_find_threat");
		entity:InsertSubpipe(0,"setup_combat");
		entity:InsertSubpipe(0,"DRAW_GUN");

	end,

	-------------------------------------------------	
	-- GROUP SIGNALS
	---------------------------------------------	
	KEEP_FORMATION = function (self, entity, sender)
		-- the team leader wants everyone to keep formation
	end,
	---------------------------------------------	
	MOVE_IN_FORMATION = function (self, entity, sender)
		-- the team leader wants everyone to move in formation
		entity:Readibility("ORDER_RECEIVED",1);
		entity:SelectPipe(0,"MoveFormation");
	end,
}