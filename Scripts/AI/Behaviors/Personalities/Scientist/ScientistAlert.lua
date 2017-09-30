--------------------------------------------------
--    Created By: Amanda
--   Description: behaviour when the AI has been alerted to something
--------------------------
--

AIBehaviour.ScientistAlert = {
	Name = "ScientistAlert",

	-- SYSTEM EVENTS			-----
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
		-- attack player only if they are too close to get away otherwise
		-- seek reinforcement point or hide farthest from target.
		System:LogToConsole("[".. entity:GetName().."] ScientistAlert++++++player seen reinforce point["..entity.Properties.ReinforcePoint .."]");

		AI:Signal(SIGNALID_READIBILITY, 2, "FIRST_HOSTILE_CONTACT",entity.id);	
		AI:Signal(SIGNALFILTER_GROUPONLY, 1, "HEADS_UP_GUYS",entity.id);
		
		if ((entity.Properties.ReinforcePoint == nil) or (entity.Properties.ReinforcePoint =="none")) then

			-- you are on your own
			if (fDistance<5) then
				System:LogToConsole("[".. entity:GetName().."] player seen++++++too close defend");
				entity:SelectPipe(0,"scientist_tooclose_defend");
			else
				System:LogToConsole("[".. entity:GetName().."] player seen++++++scientist_runAway");
				entity:SelectPipe(0,"scientist_runAway");
			end
			
		else			
			-- only send this signal if you have a reinforcepoint defined
--			if (fDistance<10) then
--				System:LogToConsole("[".. entity:GetName().."] player seen++++++scientist_tooclose_defend_reinforcePoint");
--				entity:SelectPipe(0,"scientist_tooclose_defend_reinforcePoint",entity.Properties.ReinforcePoint);
--			else
--				System:LogToConsole("[".. entity:GetName().."] player seen++++++scientist_reinforcePoint");
 				entity:SelectPipe(0,"scientist_reinforcePoint",entity.Properties.ReinforcePoint);
--			end
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

	KEEP_ALERTED = function ( self, entity, sender)
	end, 

	---------------------------------------------
	DEATH_CONFIRMED = function (self, entity, sender)
		--System:LogToConsole(entity:GetName().." recieved DEATH_CONFIRMED command in CoverAlert");
		entity:SelectPipe(0,"ChooseManner");
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
}