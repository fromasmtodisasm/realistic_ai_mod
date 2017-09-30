--------------------------------------------------
--    Created By: Petar
--   Description: Activates when the guy feels some movement around him,but is not necesarilly scared
--------------------------
--   last modified by: sten 23-10-2002

AIBehaviour.CoverInterested = {
	Name = "CoverInterested",

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		AIBehaviour.CoverIdle:OnPlayerSeen(entity,fDistance,1)
	end,

	OnEnemySeen = function(self,entity)
	end,

	OnFriendSeen = function(self,entity)
		-- called when the enemy sees a friendly target
	end,

	OnSomethingSeen = function(self,entity)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity.LAB = nil 
		if entity.ThreatenStatus2 and entity.ThreatenStatus2 >= 1 and entity.ThreatenStatus2 < 4 then 
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,15)
			AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"LOOK_AT_BEACON",entity.id)
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)
		end
		if not entity.ThreatenStatus2 then
			entity.ThreatenStatus2 = 1 	
			entity:InsertSubpipe(0,"cover_lookat") -- Без этой "пустышки" работает неправильно. Переключается дальше.
			-- Hud:AddMessage(entity:GetName()..": CoverIdle/OnInterestingSoundHeard/ThreatenStatus2 = nil")
		elseif entity.ThreatenStatus2==1 then
			entity.ThreatenStatus2 = 2 	
			if (entity:GetGroupCount() > 1) then
				AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_THREATENED_GROUP",entity.id)
			else
				AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_THREATENED",entity.id)
			end
			entity:SelectPipe(0,"cover_intresting")
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,30)
			AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"CLEAR_LOOK_AT_BEACON",entity.id)
			AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"LOOK_AT_BEACON",entity.id)
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)
			-- Hud:AddMessage(entity:GetName()..": CoverIdle/OnInterestingSoundHeard/ThreatenStatus2 = 1")
		elseif entity.ThreatenStatus2==2 then
			entity.ThreatenStatus2 = 3
			entity:InsertSubpipe(0,"cover_lookat")
		elseif entity.ThreatenStatus2==3 then
			entity.ThreatenStatus2 = 4
			entity:SelectPipe(0,"cover_hide")
			AI:Signal(0,1,"ALERT_SIGNAL",entity.id) 
		end
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity)
		entity.LAB = nil 
		entity.ThreatenStatus2 = 2 	
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"NORMAL_THREAT_SOUND",entity.id)
		if (entity:GetGroupCount() > 1) then
			AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_THREATENED_GROUP",entity.id)
		else
			AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_THREATENED",entity.id)
		end
		entity:SelectPipe(0,"cover_hide")
		AI:Signal(0,1,"ALERT_SIGNAL",entity.id) 
	end,

	OnClipNearlyEmpty = function(self,entity,sender)
		entity:SelectPipe(0,"cover_scramble")
	end,

	OnReload = function(self,entity)
		entity:SelectPipe(0,"cover_scramble")
	end,

	OnNoHidingPlace = function(self,entity,sender)
	end,	
	--------------------------------------------------
	OnNoFormationPoint = function(self,entity,sender)
	end,
	--------------------------------------------------
	OnCoverRequested = function(self,entity,sender)
	end,

	OnKnownDamage = function(self,entity,sender)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:SelectPipe(0,"cover_goforcover") -- Представляешь, один раз сработало! Когда я был в игноре, но пальнул по падающему каверу.
		entity:InsertSubpipe(0,"scared_shoot",sender.id)
	end,

	OnReceivingDamage = function(self,entity,sender)
		AIBehaviour.DEFAULT:OnReceivingDamage(entity,sender)
		entity:SelectPipe(0,"not_so_random_hide_from")
	end,

	OnBulletRain = function(self,entity,sender)	
		AIBehaviour.DEFAULT:OnBulletRain(entity,sender)
		entity:SelectPipe(0,"not_so_random_hide_from")
		entity:GrenadeAttack(3)
	end,

	OnSomethingDiedNearest = function(self,entity,sender)
		if not entity.rs_x then
			AIBehaviour.DEFAULT:OnSomethingDiedNearest(entity,sender)
		else
			if entity.Properties.species==sender.Properties.species then
				entity:InsertSubpipe("DropBeaconAt",sender.id)
				if not entity:RunToAlarm() then
					if random(1,2)==1 then
						AIBehaviour.CoverAttack:COVER_CAMP(entity,sender)
					else
						AIBehaviour.CoverAttack:HIDE_TACTIC(entity,sender)
					end
					if not entity:GrenadeAttack(3) then
						entity:InsertSubpipe(0,"TeamMemberDiedBeaconGoOn")
					end
				end
			end
		end
	end,

	--------------------------------------------------
	-- CUSTOM SIGNALS
	--------------------------------------------------

	Cease = function(self,entity,fDistance)
		entity:SelectPipe(0,"cover_cease_investigation") -- in PipeManagerShared.lua			 
	end,
	---------------------------------------------
	AISF_GoOn = function(self,entity,sender)
		entity:SelectPipe(0,"InvestigateSound")
	end,
	---------------------------------------------
	TRY_TO_LOCATE_SOURCE = function(self,entity,sender)
		entity:TriggerEvent(AIEVENT_CLEAR)
		entity:SelectPipe(0,"lookaround_30seconds")
	end,
	--------------------------------------------------
	-- GROUP SIGNALS
	--------------------------------------------------
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
	Soundheard = function(self,entity,sender)
		entity:StartAnimation(0,"sSoundheard",0)
	end,
	
	confused_animation = function(self,entity,sender)
		entity:StartAnimation(0,"_chinrub",0)
	end,
	
}