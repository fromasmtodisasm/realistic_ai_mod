--------------------------------------------------
--    Created By: Petar
--   Description: Enemy should not be disturbed by anything while running for reinforcements
--------------------------
--

AIBehaviour.SharedReinforce = {
	Name = "SharedReinforce",
	NOPREVIOUS = 1,

	---------------------------------------------
	OnNoTarget = function(self,entity)
		-- called when the enemy stops having an attention target
	end,
	---------------------------------------------
	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		-- called when the enemy sees a living player
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if fDistance < 15 then
			AI:Signal(0,1,"EXIT_RUNTOALARM",entity.id)
		end
	end,
	---------------------------------------------
	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		-- called when the enemy can no longer see its foe,but remembers where it saw it last
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity,fDistance)
		-- called when the enemy hears an interesting sound
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if fDistance < 15 then
			AI:Signal(0,1,"EXIT_RUNTOALARM",entity.id)
		end
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity)
		-- called when the enemy hears a scary sound
		entity:TriggerEvent(AIEVENT_DROPBEACON)
	end,
	---------------------------------------------
	OnReload = function(self,entity)
		-- called when the enemy goes into automatic reload after its clip is empty
	end,
	---------------------------------------------
	OnDeath = function(self,entity)
		-- called when the enemy goes into automatic reload after its clip is empty
	end,
	---------------------------------------------
	OnGroupMemberDied = function(self,entity,sender)
		-- call the default to do stuff that everyone should do
	end,
	--------------------------------------------------
	OnGroupMemberDiedNearest = function(self,entity,sender)
		-- call the default to do stuff that everyone should do
	end,
	---------------------------------------------
	OnNoHidingPlace = function(self,entity,sender)
		-- called when no hiding place can be found with the specified parameters
	end,	
	--------------------------------------------------
	OnNoFormationPoint = function(self,entity,sender)
		-- called when the enemy found no formation point
	end,
	---------------------------------------------
	OnKnownDamage = function(self,entity,sender)
		if (entity.dmg_percent<.5) then
			AI:Signal(0,1,"RETURN_TO_PREVIOUS",entity.id)
		end
		entity:InsertSubpipe(0,"scared_shoot",sender.id)
	end,
	--------------------------------------------------
	OnReceivingDamage = function(self,entity,sender)
		AIBehaviour.SharedReinforce:OnKnownDamage(entity,sender)
	end,
	--------------------------------------------------
	OnBulletRain = function(self,entity,sender)
		-- called when the enemy detects bullet trails around him
	end,
	--------------------------------------------------

	--------------------------------------------------
	COVER_NORMALATTACK = function(self,entity,sender)
		-- dont handle this signal
	end,
	--------------------------------------------------
	COVER_RELAX = function(self,entity,sender)
		-- dont handle this signal
	end,
	--------------------------------------------------
	AISF_GoOn = function(self,entity,sender)
		-- dont handle this signal
	end,
	--------------------------------------------------
	--------------------------------------------------
	RETURN_COVERING_FIRE = function(self,entity,sender)
	end,
	--------------------------------------------------
	RETREAT_NOW_PHASE2 = function(self,entity,sender)
	end,
	---------------------------------------------
	RETURN_TO_PREVIOUS = function(self,entity,sender)
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"RunToAlarmSignal",entity.id)
		entity.RunToTrigger = nil 
		AI:Signal(0,1,"OnReload",entity.id)
	end,

	STILL_WAITING = function(self,entity,sender)
		entity:InsertSubpipe(0,"waiting...")
	end,

	EXIT_WAIT_STATE = function(self,entity,sender)
		entity.EventToCall="OnJobContinue" 
	end,


	--------------------------------------------------
	HEADS_UP_GUYS = function(self,entity,sender)
		-- dont handle this signal
		-- entity.RunToTrigger = 1 
	end,
	---------------------------------------------
	INCOMING_FIRE = function(self,entity,sender)
		-- dont handle this signal
	end,


	-- GROUP SIGNALS
	---------------------------------------------	
	KEEP_FORMATION = function(self,entity,sender)
		-- the team leader wants everyone to keep formation
	end,
	---------------------------------------------	
	BREAK_FORMATION = function(self,entity,sender)
		-- the team can split
	end,
	---------------------------------------------	
	SINGLE_GO = function(self,entity,sender)
		-- the team leader has instructed this group member to approach the enemy
	end,
	---------------------------------------------	
	GROUP_COVER = function(self,entity,sender)
		-- the team leader has instructed this group member to cover his friends
	end,
	---------------------------------------------	
	IN_POSITION = function(self,entity,sender)
		-- some member of the group is safely in position
	end,
	---------------------------------------------	
	GROUP_SPLIT = function(self,entity,sender)
		-- team leader instructs group to split
	end,
	---------------------------------------------	
	PHASE_RED_ATTACK = function(self,entity,sender)
		-- team leader instructs red team to attack
	end,
	---------------------------------------------	
	PHASE_BLACK_ATTACK = function(self,entity,sender)
		-- team leader instructs black team to attack
	end,
	---------------------------------------------	
	GROUP_MERGE = function(self,entity,sender)
		-- team leader instructs groups to merge into a team again
	end,
	---------------------------------------------	
	CLOSE_IN_PHASE = function(self,entity,sender)
		-- team leader instructs groups to initiate part one of assault fire maneuver
	end,
	---------------------------------------------	
	ASSAULT_PHASE = function(self,entity,sender)
		-- team leader instructs groups to initiate part one of assault fire maneuver
	end,
	---------------------------------------------	
	GROUP_NEUTRALISED = function(self,entity,sender)
		-- team leader instructs groups to initiate part one of assault fire maneuver
	end,
}