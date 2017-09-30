--------------------------------------------------
--   Created By: Petar
--   Description: This behaviour activates as a response to an island-wide alarm call, or in response to a group death
--------------------------------------------------
--   last modified by: sten 23-10-2002

AIBehaviour.CoverAlert = {
	Name = "CoverAlert",


	---------------------------------------------
	OnKnownDamage = function ( self, entity, sender)
		entity:Readibility("GETTING_SHOT_AT",1);
		entity:SelectPipe(0,"not_so_random_hide_from",sender.id);
	end,
		
	---------------------------------------------
	OnNoTarget = function( self, entity )
		-- called when the enemy stops having an attention target
		entity:SelectPipe(0,"search_for_target");
	end,
	---------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )
		-- called when the enemy sees a living player
		-- REVIEWED

		entity:TriggerEvent(AIEVENT_DROPBEACON);

		entity:Readibility("ENEMY_TARGET_REGAIN");
		if (AI:GetGroupCount(entity.id) > 1) then
			-- only send this signal if you are not alone
			AI:Signal(SIGNALFILTER_SUPERGROUP, 1, "wakeup",entity.id);
			AI:Signal(SIGNALFILTER_SUPERGROUP, 1, "HEADS_UP_GUYS",entity.id);
	
			entity:SelectPipe(0,"cover_scramble_beacon");
		else


			-- you are on your own
			entity:SelectPipe(0,"cover_scramble");
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
		-- called when the enemy hears an interesting sound
		entity:SelectPipe(0,"cover_look_closer");
		entity:TriggerEvent(AIEVENT_DROPBEACON); 
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function( self, entity, fDistance )
		entity:MakeAlerted();

		entity:SelectPipe(0,"cover_investigate_threat"); 



		if (fDistance > 20) then 
			entity:InsertSubpipe(0,"do_it_running");
		else
			entity:InsertSubpipe(0,"do_it_walking");
		end

		entity:InsertSubpipe(0,"cover_threatened"); 
	end,
	---------------------------------------------
	OnReload = function( self, entity )
		-- called when the enemy goes into automatic reload after its clip is empty
		entity:SelectPipe(0,"cover_scramble");
	end,
	---------------------------------------------
	OnNoHidingPlace = function( self, entity, sender )
	end,	
	--------------------------------------------------
	OnNoFormationPoint = function ( self, entity, sender)
		-- called when the enemy found no formation point
	end,
	---------------------------------------------
	OnReceivingDamage = function ( self, entity, sender)
		-- called when the enemy is damaged
		AI:Signal(SIGNALFILTER_GROUPONLY, 1, "INCOMING_FIRE",entity.id);
		entity:Readibility("GETTING_SHOT_AT",1);
		entity:SelectPipe(0,"getting_shot_at");
	end,
	--------------------------------------------------
	OnBulletRain = function ( self, entity, sender)
		-- called when the enemy detects bullet trails around him
	end,
	--------------------------------------------------
	-- CUSTOM SIGNALS
	--------------------------------------------------

	INVESTIGATE_TARGET = function (self, entity, sender)
		entity:SelectPipe(0,"cover_investigate_threat");		
	end,
	---------------------------------------------	


	OnGroupMemberDied = function( self, entity, sender)
		-- called when a member of the group dies
		
		 if (sender.groupid == entity.groupid) then
		 	if (entity ~= sender) then
		 		entity:SelectPipe(0,"TeamMemberDiedLook");
		 	end
		 else
		 	entity:SelectPipe(0,"randomhide");
		 end
	end,
	--------------------------------------------------
	OnGroupMemberDiedNearest = function ( self, entity, sender)

		AIBehaviour.DEFAULT:OnGroupMemberDiedNearest(entity,sender);

		entity:SelectPipe(0,"TeamMemberDiedBeaconGoOn",sender.id);
	end,
	---------------------------------------------
	Cease = function( self, entity, fDistance )
		entity:SelectPipe(0,"cover_cease_approach"); -- in PipeManagerShared.lua			 
	end,
	---------------------------------------------
	TRY_TO_LOCATE_SOURCE = function (self, entity, sender)
		entity:SelectPipe(0,"lookaround_30seconds");
	end,
	---------------------------------------------
	DEATH_CONFIRMED = function (self, entity, sender)

		entity:SelectPipe(0,"ChooseManner");
	end,
	---------------------------------------------
	ChooseManner = function (self, entity, sender)

		local XRandom = random(1,3);
		if (XRandom == 1) then
			entity:InsertSubpipe(0,"LookForThreat");			
		elseif (XRandom == 2) then
			entity:InsertSubpipe(0,"RandomSearch");			
		elseif (XRandom == 3) then
			entity:InsertSubpipe(0,"ApproachDeadBeacon");
		end
	end,
	--------------------------------------------------
	-- GROUP SIGNALS
	--------------------------------------------------
	INCOMING_FIRE = function (self, entity, sender)
		if (entity ~= sender) then
			entity:SelectPipe(0,"randomhide");
		end
	end,
	---------------------------------------------	
	KEEP_FORMATION = function (self, entity, sender)
		-- the team leader wants everyone to keep formation
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
	------------------------------ Animation -------------------------------
	target_lost_animation = function (self, entity, sender)
		entity:StartAnimation(0,"enemy_target_lost",0);
	end,
	------------------------------------------------------------------------
	confused_animation = function (self, entity, sender)
		entity:StartAnimation(0,"_headscratch1",0);
	end,
	------------------------------------------------------------------------
}