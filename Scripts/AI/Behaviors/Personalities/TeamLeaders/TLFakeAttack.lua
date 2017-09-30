--------------------------------------------------
--    Created By: Petar
--   Description: <short_description>
--------------------------
--

AIBehaviour.TLFakeAttack = {
	Name = "TLFakeAttack",
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
		System:LogToConsole("-------------------------- ACTIVATE -------------------------");
		AI:CreateGoalPipe(entity.Properties.pathname.."AIS_ChasePath");
		AI:PushGoal(entity.Properties.pathname.."AIS_ChasePath","run",1,1);
		AI:PushGoal(entity.Properties.pathname.."AIS_ChasePath","bodypos",1,0);
		AI:PushGoal(entity.Properties.pathname.."AIS_ChasePath","firecmd",1,1);
		AI:PushGoal(entity.Properties.pathname.."AIS_ChasePath","pathfind",1,entity.Properties.pathname);
		AI:PushGoal(entity.Properties.pathname.."AIS_ChasePath","trace",1,1);
		AI:PushGoal(entity.Properties.pathname.."AIS_ChasePath","signal",0,1,"TAKEUP_POSITIONS",0);	
		
		entity:SelectPipe(0,entity.Properties.pathname.."AIS_ChasePath");		
	end,
	---------------------------------------------
	OnNoTarget = function( self, entity )
		-- called when the enemy stops having an attention target
	end,
	---------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )

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
		local grpcnt = AI:GetGroupCount(entity.Properties.groupid);
		if (grpcnt < 3) then
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
	end,
	---------------------------------------------
	OnCoverRequested = function ( self, entity, sender)
		-- called when the enemy is damaged
	end,
	---------------------------------------------
	OnDeath = function ( self, entity)
		-- called when the enemy is damaged
	end,
	---------------------------------------------
	KeepToSameCover = function ( self, entity, sender)
		-- called when the enemy is damaged
	end,

	MINIMIZE_YOURSELF = function (self, entity, sender)
		-- the team leader wants everyone to keep formation
		System:LogToConsole("-------------------------- CHANGED -------------------------");
		entity:SelectPipe(0,"fire_minimize");
	end,

	TAKEUP_POSITIONS = function (self, entity, sender)
		-- the team leader wants everyone to keep formation
		System:LogToConsole("-------------------------- TAKEUP -------------------------");
		entity:SelectPipe(0,"fake_takeUpPositions");
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
}
