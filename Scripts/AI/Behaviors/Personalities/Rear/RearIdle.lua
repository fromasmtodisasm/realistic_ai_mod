--------------------------------------------------
--   Created By: Petar
--   Description: Rear Idle Behaviour
--------------------------


AIBehaviour.RearIdle = {
	Name = "RearIdle",




	---------------------------------------------		
	OnPlayerSeen = function( self, entity, fDistance )
		-- called when the enemy sees a living player
		if (fDistance < 15) then
			AI:Signal(0,1,"ON_ENEMY_TOOCLOSE",entity.id);
			entity:SelectPipe(0,"rear_target2close");
		else
			AI:Signal(0,1,"ON_ENEMY_TARGET",entity.id);
			entity:SelectPipe(0,"rear_scramble");
		end

		if (entity.RunToTrigger == nil) then
			entity:RunToAlarm();
		end
		
		if (AI:GetGroupCount(entity.id) > 1) then
			AI:Signal(SIGNALFILTER_SUPERGROUP, 1, "wakeup",entity.id);
			AI:Signal(SIGNALID_READIBILITY, AIREADIBILITY_SEEN, "FIRST_HOSTILE_CONTACT_GROUP",entity.id);	
			AI:Signal(SIGNALFILTER_SUPERGROUP, 1, "HEADS_UP_GUYS",entity.id);
			entity:InsertSubpipe(0,"DropBeaconAt"); -- in PipeManagerShared.lua
		else
			AI:Signal(SIGNALID_READIBILITY, AIREADIBILITY_SEEN, "FIRST_HOSTILE_CONTACT",entity.id);
		end
		
	end,

	---------------------------------------------
	OnSomethingSeen = function( self, entity )

		-- DO NOT TOUCH THIS READIBILITY SIGNAL	---------------------------
		if (AI:GetGroupCount(entity.id) > 1) then
			AI:Signal(SIGNALID_READIBILITY, AIREADIBILITY_INTERESTED, "IDLE_TO_INTERESTED_GROUP",entity.id);
		else
			AI:Signal(SIGNALID_READIBILITY, AIREADIBILITY_INTERESTED, "IDLE_TO_INTERESTED",entity.id);
		end
		-------------------------------------------------------------------
		entity:MakeAlerted();
	 	entity:SelectPipe(0,"rear_interested"); 
		entity:InsertSubpipe(0,"get_curious"); 
	 	entity:InsertSubpipe(0,"setup_combat"); 
	 	entity:InsertSubpipe(0,"DropBeaconAt"); 
	 	entity:InsertSubpipe(0,"DRAW_GUN"); 
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
	 	entity:SelectPipe(0,"rear_interested"); 
	 	entity:InsertSubpipe(0,"setup_combat"); 
	 	entity:InsertSubpipe(0,"DropBeaconAt"); 
	 	entity:InsertSubpipe(0,"DRAW_GUN"); 
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function( self, entity )
		entity:MakeAlerted();
		entity:SelectPipe(0,"rear_interested"); 
		entity:InsertSubpipe(0,"shoot_cover"); 
	 	entity:InsertSubpipe(0,"setup_combat"); 
		entity:InsertSubpipe(0,"DropBeaconAt"); 
	 	entity:InsertSubpipe(0,"DRAW_GUN"); 
		entity:Blind_RunToAlarm();
	end,
	---------------------------------------------
	OnBulletRain = function ( self, entity, sender)	
		-- called when detect weapon fire around AI
	
		AI:Signal(SIGNALFILTER_GROUPONLY, 1, "INCOMING_FIRE",entity.id);
		
		entity:MakeAlerted();
		entity:SelectPipe(0,"randomhide");
		entity:InsertSubpipe(0,"DRAW_GUN");
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
	--------------------------------------------------
	OnGrenadeSeen = function( self, entity, fDistance )
		-- called when the enemy sees a grenade
		--System:LogToConsole("+++++++++++++++++++++++++++OnGrenadeSeen");
		entity:InsertSubpipe(0,"grenade_run_away");
	end,
	--------------------------------------------------
	-- CUSTOM SIGNALS
	--------------------------------------------------
	DEATH_CONFIRMED = function (self, entity, sender)
		--System:LogToConsole(entity:GetName().." recieved DEATH_CONFIRMED command in CoverAlert");
		entity:SelectPipe(0,"ChooseManner");
	end,
	--------------------------------------------------
	TRY_TO_LOCATE_SOURCE = function (self, entity, sender)
		-- called from "randomhide"
		entity:SelectPipe(0,"rear_lookaround_threatened");
	end,
	---------------------------------------------
	ChooseManner = function (self, entity, sender)
		--System:LogToConsole("### ChooseManner ###");
		local XRandom = random(1,3);
		if (XRandom == 1) then
			entity:InsertSubpipe(0,"LookForThreat");			
		elseif (XRandom == 2) then
			entity:InsertSubpipe(0,"RandomSearch");			
		elseif (XRandom == 3) then
			entity:InsertSubpipe(0,"ApproachDeadBeacon");
		end
	end,
	---------------------------------------------
	OnGroupMemberDied = function( self, entity, sender)
		-- called when a member of the group dies
		--System:LogToConsole(entity:GetName().." recieved OnGroupMemberDied signal in RearIdle");

		entity:MakeAlerted();
		
		if (sender.Properties.groupid == entity.Properties.groupid) then
		 	if (entity ~= sender) then
		 		entity:SelectPipe(0,"TeamMemberDiedLook");
		 	end
		else
		 	entity:SelectPipe(0,"randomhide");
		end
	end,
	--------------------------------------------------
	OnGroupMemberDiedNearest = function ( self, entity, sender)
		--System:LogToConsole(entity:GetName().." recieved OnGroupMemberDiedNearest signal in CoverIdle");

		entity:MakeAlerted();

		-- DO NOT TOUCH THIS READIBILITY SIGNAL	---------------------------
		AI:Signal(SIGNALID_READIBILITY, 1, "FRIEND_DEATH",entity.id);
		-------------------------------------------------------------------
		
		-- bounce the dead friend notification to the group (you are going to investigate it)
		AI:Signal(SIGNALFILTER_SPECIESONLY, 1, "OnGroupMemberDied",entity.id);

		-- investigate corpse
		entity:SelectPipe(0,"RecogCorpse",sender.id);
	end,
	--------------------------------------------------
	----------------- GROUP SIGNALS ------------------
	--------------------------------------------------
	HEADS_UP_GUYS = function (self, entity, sender)
		if (entity ~= sender) then
			entity:MakeAlerted();
			entity:SelectPipe(0,"rear_headup");
			if (entity.AI_GunOut==nil) then	
				entity:InsertSubpipe(0,"DRAW_GUN");
			end
		end
		entity.RunToTrigger = 1;
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
	OnCoverRequested = function ( self, entity, sender)
		-- called when cover is requested
	end,
	------------------------------------------------------------------------
	------------------------------ Animation -------------------------------
	PlayGetDownAnim = function (self, entity, sender)
		entity:StartAnimation(0,"pgetdown",0);
	end,
	------------------------------------------------------------------------
	PlayGetUpAnim = function (self, entity, sender)
		entity:StartAnimation(0,"pgetup",0);
	end,
	------------------------------------------------------------------------
}