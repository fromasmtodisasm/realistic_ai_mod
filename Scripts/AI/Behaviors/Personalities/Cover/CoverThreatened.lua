--------------------------------------------------
--    Created By: Petar
--   Description: This behaviour is called after the guy hears a scary sound. He is aggitated and know that there
--			is imminent danger.
--------------------------
--   modified by: sten 23-10-2002

AIBehaviour.CoverThreatened = {
	Name = "CoverThreatened",

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		AIBehaviour.CoverIdle:OnPlayerSeen(entity,fDistance,1)
	end,
	---------------------------------------------
	OnEnemySeen = function(self,entity)
	end,
	---------------------------------------------
	OnFriendSeen = function(self,entity)
		-- called when the enemy sees a friendly target
	end,

	OnSomethingSeen = function(self,entity)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		-- called when the enemy can no longer see its foe,but remembers where it saw it last
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity,fDistance)
		-- if (_localplayer.sspecies==entity.Properties.species) then
			-- entity:InsertSubpipe(0,"devalue_target")
			-- return
		-- end
		if not entity.ThreatenStatus3 then
			entity.ThreatenStatus3 = 1 	
			entity:TriggerEvent(AIEVENT_DROPBEACON)
			if (entity:GetGroupCount() > 1) then
				AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_THREATENED_GROUP",entity.id)
			else
				AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_THREATENED",entity.id)
			end
			AI:Signal(0,1,"INVESTIGATE_TARGET",entity.id)
			if (fDistance <= 10) then -- Проверить.
				entity:InsertSubpipe(0,"not_so_random_hide_from")
			end
		else
			entity:SelectPipe(0,"cover_hide")
			AI:Signal(0,1,"ALERT_SIGNAL",entity.id)
		end
	end,
	
	OnThreateningSoundHeard = function(self,entity,fDistance)
		-- Hud:AddMessage(entity:GetName()..": CoverThreatened/OnThreateningSoundHeard")
		entity.ThreatenStatus3 = 1 	
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"NORMAL_THREAT_SOUND",entity.id)
		if not entity.ThreatenStatus4 then
			entity.ThreatenStatus4 = 1 
			entity:InsertSubpipe(0,"cover_lookat")
		elseif entity.ThreatenStatus4==1 then
			entity.ThreatenStatus4 = 2 
			if (fDistance > 100) then
				local rnd = random(1,10)
				if (rnd > 3) then 
					entity:SelectPipe(0,"look_at_beacon4")
					entity:InsertSubpipe(0,"cover_hide")
				else
					entity:SelectPipe(0,"cover_investigate_threat2")
				end
			else
				if (entity:GetGroupCount() > 1) then
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_THREATENED_GROUP",entity.id)
				else
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_THREATENED",entity.id)
				end
				entity:SelectPipe(0,"cover_investigate_threat2")
				if (fDistance <= 30) then
					entity:InsertSubpipe(0,"cover_hide")
				end
			end
		else
			AI:Signal(0,1,"ALERT_SIGNAL",entity.id)
		end
	end,

	OnClipNearlyEmpty = function(self,entity,sender)
		entity:SelectPipe(0,"cover_scramble")
	end,

	OnReload = function(self,entity)
		entity:SelectPipe(0,"cover_scramble")
	end,

	OnNoHidingPlace = function(self,entity,sender)
		-- called when no hiding place can be found with the specified parameters

		-- entity:SelectPipe(0,"ApproachSound")
	end,	
	--------------------------------------------------
	OnNoFormationPoint = function(self,entity,sender)
		-- called when the enemy found no formation point
	end,
	--------------------------------------------------
	OnCoverRequested = function(self,entity,sender)
		-- called when the enemy is damaged
	end,

	OnKnownDamage = function(self,entity,sender)
		AIBehaviour.CoverInterested:OnKnownDamage(entity,sender)
	end,

	OnReceivingDamage = function(self,entity,sender)
		AIBehaviour.CoverInterested:OnReceivingDamage(entity,sender)
	end,

	OnBulletRain = function(self,entity,sender)	
		AIBehaviour.CoverInterested:OnBulletRain(entity,sender)
		entity:GrenadeAttack(3)
	end,

	OnSomethingDiedNearest = function(self,entity,sender)
		AIBehaviour.CoverInterested:OnSomethingDiedNearest(entity,sender)
	end,
	
	--------------------------------------------------
	-- CUSTOM SIGNALS
	--------------------------------------------------
	COVER_NORMALATTACK = function(self,entity,sender)
		entity:SelectPipe(0,"cover_pindown")
		entity:InsertSubpipe(0,"reload")
	end,

	Cease = function(self,entity,fDistance)
		entity:SelectPipe(0,"cover_cease_approach") -- in PipeManagerShared.lua			 
	end,
	--------------------------------------------------
	AISF_GoOn = function(self,entity,sender)
		entity:SelectPipe(0,"ApproachSound")
	end,
	--------------------------------------------------
	TRY_TO_LOCATE_SOURCE = function(self,entity,sender)
		entity:TriggerEvent(AIEVENT_CLEAR)
		entity:SelectPipe(0,"lookaround_30seconds")
	end,

	---------------------------------------------
	-- GROUP SIGNALS
	--------------------------------------------------
	INCOMING_FIRE = function(self,entity,sender)
		if (entity~=sender) then
			entity:SelectPipe(0,"randomhide")
		end
	end,
	---------------------------------------------		
	KEEP_FORMATION = function(self,entity,sender)
		if entity.sees==0 then
			entity:SelectPipe(0,"cover_hideform")
		end
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
	
	------------------------------ Animation -------------------------------
	target_lost_animation = function(self,entity,sender)
		entity:StartAnimation(0,"enemy_target_lost",0)
	end,
	
	confused_animation = function(self,entity,sender)
		entity:StartAnimation(0,"_headscratch1",0)
	end,
	
}