--------------------------------------------------
--    Created By: Petar
--   Description: <short_description>
--------------------------
--

AIBehaviour.Valerie = {
	Name = "Valerie",

	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSelected = function( self, entity )	
	end,
	---------------------------------------------
	OnSpawn = function( self, entity )
		-- called when enemy spawned or reset
		entity.AI_Val_Active = nil;
		AI:CreateGoalPipe("plea_for_help");
		AI:PushGoal("plea_for_help","signal",0,1,"PLEA_HELP",0);
		AI:PushGoal("plea_for_help","timeout",1,3,7);
	end,

	PLEA_HELP = function( self, entity,sender )
		local rnd = random(1,10);
		if (rnd>8) then 
			Hud:AddMessage("VALERIE: Bust me outta here, you STUD! ");
		elseif (rnd>6) then 
			Hud:AddMessage("VALERIE: I have a cookie here for the one who frees me ");
		elseif (rnd>4) then 
			Hud:AddMessage("VALERIE: TAKE ME, TAKE ME AS SOON AS YOU FREE ME!! ");
		elseif (rnd>2) then 
			Hud:AddMessage("VALERIE: There is a proximity trigger somewhere, FIND IT! ");
		else
			Hud:AddMessage("VALERIE: Rescue me darling ");
		end
		
	end,
	---------------------------------------------
	---------------------------------------------
	OnActivate = function( self, entity )
		-- called when enemy receives an activate event (from a trigger, for example)
		entity.AI_Val_Active = 1;
		Hud:AddMessage("VALERIE: Well done. I am feeling free now... ");
		entity:TriggerEvent(AIEVENT_CLEAR);
	end,
	---------------------------------------------
	OnNoTarget = function( self, entity )
		-- called when the enemy stops having an attention target
	end,
	---------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )
		-- called when the enemy sees a living player
		if (entity.AI_Val_Active) then
			if (fDistance > 3) then
				entity:SelectPipe(0,"simple_follow_target");
			else
				entity:SelectPipe(0,"random_timeout");
			end
		else
			entity:SelectPipe(0,"plea_for_help");
		end
	end,
	---------------------------------------------
	OnGrenadeSeen = function( self, entity, fDistance )
		-- called when the enemy sees a grenade
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
	end,
	---------------------------------------------
	OnNoHidingPlace = function( self, entity, sender )
		-- called when no hiding place can be found with the specified parameters
		Hud:AddMessage("VALERIE:Protect me, master, then own me!! ");
		AI:Signal(SIGNALID_READIBILITY, 2, "VALERIE_PROTECT_ME",entity.id);
		entity:SelectPipe(0,"random_timeout");
	end,	
	--------------------------------------------------
	OnNoFormationPoint = function ( self, entity, sender)
		-- called when the enemy found no formation point
	end,
	---------------------------------------------
	OnReceivingDamage = function ( self, entity, sender)
		-- called when the enemy is damaged
		if (entity.AI_Val_Active) then
			entity:SelectPipe(0,"minimize_exposure");
		end
	end,
	---------------------------------------------
	OnCoverRequested = function ( self, entity, sender)
		-- called when the enemy is damaged
	end,
	--------------------------------------------------
	OnBulletRain = function ( self, entity, sender)
		-- called when the enemy detects bullet trails around him
	end,
	--------------------------------------------------

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
}