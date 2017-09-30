--------------------------------------------------
--    Created By: Amanda
--   Description: This behaviour describes the SCOUT personality in idle mode
--------------------------
--

AIBehaviour.ScientistIdle = {
	Name = "ScientistIdle",


	---------------------------------------------
	OnNoTarget = function(self,entity)
		-- called when the enemy stops having an attention target
	end,
	---------------------------------------------
	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		-- attack player only if they are too close to get away otherwise
		-- seek reinforcement point or hide farthest from target.
		AI:Signal(SIGNALID_READIBILITY,2,"ACT_SCARED",entity.id)	

		if (entity.SIGNAL_SENT==nil) then
			if (entity:GetGroupCount() > 1) then
				AI:Signal(0,1,"NOTIFY_GROUP_SIGNAL",entity.id)
			end
		end
		
		entity:SelectPipe(0,"scientist_cower")
		entity:InsertSubpipe(0,"scientist_runAway")
		entity:TriggerEvent(AIEVENT_DROPBEACON)
	end,
	---------------------------------------------
	OnEnemyMemory = function(self,entity,fDistance,NotContact)
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity)
		
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity)
		-- DO NOT TOUCH THIS READIBILITY SIGNAL	---------------------------
		AI:Signal(SIGNALID_READIBILITY,1,"IDLE_TO_THREATENED",entity.id)
		-------------------------------------------------------------------	
		entity:MakeAlerted()
	end,
	---------------------------------------------
	OnReload = function(self,entity)
		-- called when the enemy goes into automatic reload after its clip is empty
	end,
	---------------------------------------------
	OnNoHidingPlace = function(self,entity,sender)
		-- called when no hiding place can be found with the specified parameters
	end,	
	---------------------------------------------
	OnReceivingDamage = function(self,entity,sender)
		-- called when the enemy is damaged
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"INCOMING_FIRE",entity.id)

		-- DO NOT TOUCH THIS READIBILITY SIGNAL	------------------------
		AI:Signal(SIGNALID_READIBILITY,1,"GETTING_SHOT_AT",entity.id)
		----------------------------------------------------------------

		entity:MakeAlerted()
		entity:SelectPipe(0,"scientist_runAway")
	end,
	--------------------------------------------------
	OnBulletRain = function(self,entity,sender)
		-- called when detect weapon fire around AI
	
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"INCOMING_FIRE",entity.id)
		
		entity:MakeAlerted()
		entity:SelectPipe(0,"scientist_runAway")
	end,
	---------------------------------------------
	OnCoverRequested = function(self,entity,sender)
		-- called when cover is requested
	end,	
	---------------------------------------------
	INCOMING_FIRE = function(self,entity,sender)
		if (entity~=sender) then
			entity:MakeAlerted()
			entity:SelectPipe(0,"scientist_randomhide")
		end
	end,
	---------------------------------------------
	HEADS_UP_GUYS = function(self,entity,sender)
		if entity.ForceSenderId then sender=System:GetEntity(entity.ForceSenderId) entity.ForceSenderId=nil end
		if entity.Properties.species==sender.Properties.species then
			if entity.id~=sender.id then
				entity:MakeAlerted()
			end
		end
	end,
}