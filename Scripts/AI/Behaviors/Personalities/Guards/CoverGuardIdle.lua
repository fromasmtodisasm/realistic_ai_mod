--------------------------------------------------
--   Created By: petar
--   Description: the idle behaviour for the guard
--------------------------
--   modified by: sten 23-10-2002

AIBehaviour.CoverGuardIdle = {
	Name = "CoverGuardIdle",
	


	OnPlayerSeen = function( self, entity, fDistance )
		-- called when the enemy sees a living player
		-- REVIEWED
		if (AI:GetGroupCount(entity.id) > 1) then	
			AI:Signal(SIGNALID_READIBILITY, AIREADIBILITY_SEEN, "FIRST_HOSTILE_CONTACT_GROUP",entity.id);	
		else
			AI:Signal(SIGNALID_READIBILITY, AIREADIBILITY_SEEN, "FIRST_HOSTILE_CONTACT",entity.id);	
		end
		
		
		if (AI:GetGroupCount(entity.id) > 1) then
			-- only send this signal if you are not alone
			entity:SelectPipe(0,"cover_scramble_beacon");

			if (entity:NotifyGroup()==nil) then
				AI:Signal(SIGNALFILTER_SUPERGROUP, 1, "HEADS_UP_GUYS",entity.id);
				AI:Signal(SIGNALFILTER_SUPERGROUP, 1, "wakeup",entity.id);
			end

		else
			-- you are on your own
			entity:SelectPipe(0,"cover_pindown");
		end


--		if (entity.RunToTrigger == nil) then
--			entity:RunToAlarm();
--		end

		

	end,
	---------------------------------------------
	OnSomethingSeen = function( self, entity )
		-- called when the enemy sees a foe which is not a living player

		-- DO NOT TOUCH THIS READIBILITY SIGNAL	---------------------------
		if (AI:GetGroupCount(entity.id) > 1) then
			AI:Signal(SIGNALID_READIBILITY, AIREADIBILITY_INTERESTING, "IDLE_TO_INTERESTED_GROUP",entity.id);
		else
			AI:Signal(SIGNALID_READIBILITY, AIREADIBILITY_INTERESTING, "IDLE_TO_INTERESTED",entity.id);
		end
		-------------------------------------------------------------------

		entity:SelectPipe(0,"cover_look_closer");
		entity:InsertSubpipe(0,"setup_stealth"); 
		entity:InsertSubpipe(0,"DRAW_GUN"); 

		-- you are going to CoverInterested
	end,
	---------------------------------------------
	OnEnemySeen = function( self, entity )
		-- called when the enemy sees a foe which is not a living player
	end,
	---------------------------------------------
	OnEnemyMemory = function( self, entity )
		-- called when the enemy can no longer see its foe, but remembers where it saw it last
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function( self, entity )
		-- DO NOT TOUCH THIS READIBILITY SIGNAL	---------------------------
		if (AI:GetGroupCount(entity.id) > 1) then
			AI:Signal(SIGNALID_READIBILITY, AIREADIBILITY_NORMAL, "IDLE_TO_INTERESTED_GROUP",entity.id);
		else
			AI:Signal(SIGNALID_READIBILITY, AIREADIBILITY_NORMAL, "IDLE_TO_INTERESTED",entity.id);
		end
		-------------------------------------------------------------------


		entity:SelectPipe(0,"cover_look_closer");
		entity:InsertSubpipe(0,"setup_stealth"); 
		entity:InsertSubpipe(0,"DRAW_GUN"); 
	
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function( self, entity, fDistance )
		-- called when the enemy hears a scary sound



		-- DO NOT TOUCH THIS READIBILITY SIGNAL	---------------------------
		AI:Signal(SIGNALID_READIBILITY, AIREADIBILITY_NORMAL, "IDLE_TO_THREATENED",entity.id);
		-------------------------------------------------------------------

		local dist = AI:GetAnchor(entity.id,AIAnchor.HOLD_THIS_POSITION,40);

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

			AI:Signal(0,1,"NORMAL_THREAT_SOUND",entity.id);

			entity:SelectPipe(0,"cover_investigate_threat"); 

			if (fDistance > 20) then 
				entity:InsertSubpipe(0,"do_it_running");
			else
				entity:InsertSubpipe(0,"do_it_walking");
			end
			entity:InsertSubpipe(0,"cover_threatened"); 

		end

	end,
	--------------------------------------------------
	OnCoverRequested = function ( self, entity, sender)
		-- called when the enemy is damaged
	end,
	---------------------------------------------
	OnReceivingDamage = function ( self, entity, sender)
		-- called when the enemy is damaged
		AI:Signal(SIGNALFILTER_GROUPONLY, 1, "INCOMING_FIRE",entity.id);

		-- DO NOT TOUCH THIS READIBILITY SIGNAL	------------------------
		AI:Signal(SIGNALID_READIBILITY, 1, "GETTING_SHOT_AT",entity.id);
		----------------------------------------------------------------

		entity:MakeAlerted();
		entity:SelectPipe(0,"randomhide");
		entity:InsertSubpipe(0,"DRAW_GUN");
	end,
	---------------------------------------------
	OnReload = function( self, entity )
		-- called when the enemy goes into automatic reload after its clip is empty
		entity:SelectPipe(0,"cover_scramble");
	end,
	--------------------------------------------------
	OnBulletRain = function ( self, entity, sender)
		-- called when detect weapon fire around AI
	
		AI:Signal(SIGNALFILTER_GROUPONLY, 1, "INCOMING_FIRE",entity.id);
		
		entity:MakeAlerted();
		entity:SelectPipe(0,"randomhide");
		entity:InsertSubpipe(0,"DRAW_GUN");
	end,
	--------------------------------------------------
	OnGrenadeSeen = function( self, entity, fDistance )
		-- called when the enemy sees a grenade
		
		-- DO NOT TOUCH THIS READIBILITY SIGNAL	---------------------------
		AI:Signal(SIGNALID_READIBILITY, 1, "GRENADE_SEEN",entity.id);
		-------------------------------------------------------------------
		entity:InsertSubpipe(0,"cover_grenade_run_away");

	end,
	--------------------------------------------------
	-- CUSTOM SIGNALS
	--------------------------------------------------

	--------------------------------------------------
	OnGroupMemberDied = function( self, entity, sender)
				
--		if (entity.RunToTrigger == nil) then
--			local runAlarm = self:RUN_TO_TRIGGER(entity);
--		end
		
		-- call the default to do stuff that everyone should do	
--		if (runAlarm == nil) then
			AIBehaviour.DEFAULT:OnGroupMemberDied(entity,sender);
		
			-- do cover stuff
			if (sender.groupid == entity.groupid) then
			 	if (entity ~= sender) then
			 		entity:SelectPipe(0,"TeamMemberDiedLook");
			 	end
			else
		 		entity:SelectPipe(0,"randomhide");
			end
--		end
	end,
	--------------------------------------------------
	OnGroupMemberDiedNearest = function ( self, entity, sender)
		-- call the default to do stuff that everyone should do
--		if (entity.RunToTrigger == nil) then
--			local runAlarm = self:RUN_TO_TRIGGER(entity);
--		end
		
--		if (runAlarm == nil) then
			AIBehaviour.DEFAULT:OnGroupMemberDiedNearest(entity,sender);

			-- do cover stuff here
			-- investigate corpse
			entity:SelectPipe(0,"RecogCorpse",sender.id);
--		end
	end,
	--------------------------------------------------
	COVER_NORMALATTACK = function (self, entity, sender)
		entity:SelectPipe(0,"cover_pindown");
	end,
	--------------------------------------------------
	COVER_RELAX = function (self, entity, sender)
		entity:SelectPipe(0,"standingthere");
	end,
	--------------------------------------------------
	AISF_GoOn = function (self, entity, sender)
		entity:SelectPipe(0,"standingthere");
	end,
	--------------------------------------------------

	---------------------------------------------	
	ALARM_ON = function (self, entity, sender)
		-- the team can split
		entity:SelectPipe(0,"investigate_alarm");		
		entity:InsertSubpipe(0,"run_to_beacon");		
		entity:InsertSubpipe(0,"DropBeaconAt",sender.id);		
	end,

	INVESTIGATE_TARGET = function (self, entity, sender)
		entity:SelectPipe(0,"cover_investigate_threat");		
	end,
	---------------------------------------------
	-- GROUP SIGNALS
	--------------------------------------------------
	HEADS_UP_GUYS = function (self, entity, sender)
		if (entity ~= sender) then
			entity:MakeAlerted();
			entity:SelectPipe(0,"cover_beacon_pindown");
			entity:InsertSubpipe(0,"DRAW_GUN");
		end
		entity.RunToTrigger = 1;
	end,
	---------------------------------------------
	INCOMING_FIRE = function (self, entity, sender)
		if (entity ~= sender) then
			entity:ChangeAIParameter(AIPARAM_SIGHTRANGE,entity.PropertiesInstance.sightrange*1.5);
			entity:SelectPipe(0,"randomhide");
			entity:InsertSubpipe(0,"DRAW_GUN");
		end
	end,
	---------------------------------------------
	KEEP_FORMATION = function (self, entity, sender)

		entity:SelectPipe(0,"cover_hideform");
		entity:InsertSubpipe(0,"acquire_beacon");
		if (entity.AI_GunOut == nil) then 
			entity:InsertSubpipe(0,"DRAW_GUN");
		end
	end,
	---------------------------------------------	
	MOVE_IN_FORMATION = function (self, entity, sender)
		-- the team leader wants everyone to move in formation
		-- DO NOT TOUCH THIS READIBILITY SIGNAL	---------------------------
		AI:Signal(SIGNALID_READIBILITY, 1, "ORDER_RECEIVED",entity.id);
		-------------------------------------------------------------------


		entity:SelectPipe(0,"MoveFormation");
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