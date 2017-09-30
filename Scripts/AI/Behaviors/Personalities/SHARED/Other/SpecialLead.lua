--------------------------------------------------
--    Created By: Petar
--   Description: <short_description>
--------------------------
--

AIBehaviour.SpecialLead = {
	Name = "SpecialLead",

	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSelected = function(self,entity)
	end,
	---------------------------------------------
	OnSpawn = function(self,entity)
		-- called when enemy spawned or reset
	end,
	---------------------------------------------
	OnActivate = function(self,entity)
	end,
	---------------------------------------------
	OnNoTarget = function(self,entity)
		-- called when the enemy stops having an attention target
		-- entity:Event_Lead()
	end,
	---------------------------------------------
	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		-- Hud:AddMessage(entity:GetName()..": OnPlayerSeen")
		-- System:Log(entity:GetName()..": OnPlayerSeen")
		entity:TriggerEvent(AIEVENT_CLEAR)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		AI:Signal(SIGNALID_READIBILITY,1,"WE_HAVE_BEEN_DISCOVERED",entity.id)
		entity.LEADING = nil
		AI:Signal(0,1,"SPECOPS_EXIT",entity.id)
	end,

	---------------------------------------------
	OnCloseContact = function(self,entity,sender)
		if not entity.LEADING then
			if entity.Properties.LEADING_COUNT==-1 then	entity.Properties.LEADING_COUNT=0 end
			local tgPoint = entity:GetName().."_LEAD"..entity.Properties.LEADING_COUNT
			if Game:GetTagPoint(tgPoint) then
				entity.LEADING = 1
				entity:SelectPipe(0,"val_lead_to",tgPoint)
				AI:Signal(SIGNALID_READIBILITY,1,"SPECIAL_LEAD_TO_NEXT_WAYPOINT",entity.id)
				-- Hud:AddMessage(entity:GetName().." find lead point "..tgPoint)
				-- System:Log(entity:GetName().." find lead point "..tgPoint)
			else
				Hud:AddMessage("$4ERROR: "..entity:GetName().." cannot find lead point "..tgPoint)
				System:Log("ERROR: "..entity:GetName().." cannot find lead point "..tgPoint)
				self:INCREASE_LEAD_COUNT(entity,sender)
			end
		end
	end,
	---------------------------------------------
	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		-- called when the enemy can no longer see its foe,but remembers where it saw it last
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity)
		-- called when the enemy hears an interesting sound
		AI:Signal(0,1,"SPECOPS_EXIT",entity.id)
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity)
		-- called when the enemy hears a scary sound
		entity:TriggerEvent(AIEVENT_CLEAR)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		-- AI:Signal(SIGNALID_READIBILITY,1,"WE_HAVE_BEEN_DISCOVERED",entity.id)
		entity.LEADING = nil
		AI:Signal(0,1,"SPECOPS_EXIT",entity.id)
	end,
	---------------------------------------------
	OnReload = function(self,entity)
		-- called when the enemy goes into automatic reload after its clip is empty
	end,
	---------------------------------------------
	OnGroupMemberDied = function(self,entity)
		-- called when a member of the group dies
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
	OnReceivingDamage = function(self,entity,sender)
		-- called when the enemy is damaged
		AI:Signal(0,1,"SPECOPS_EXIT",entity.id)
	end,
	--------------------------------------------------
	OnBulletRain = function(self,entity,sender)
		-- called when the enemy detects bullet trails around him
		AI:Signal(0,1,"SPECOPS_EXIT",entity.id)
	end,
	--------------------------------------------------

	---------------------------------------------
	YOU_CAN_APPROACH_TO_NEXT = function(self,entity,sender)
		if entity.AI_AtWeapon then
			AI:Signal(0,1,"RETURN_TO_NORMAL",self.id)
		end
		-- the team leader wants everyone to keep formation
		entity.LEADING=nil
		entity:SelectPipe(0,"standingthere")
		-- Hud:AddMessage(entity:GetName()..":YOU_CAN_APPROACH_TO_NEXT2")
		local name = AI:FindObjectOfType(entity.id,5,AIAnchor.SPECIAL_ENABLE_TRIGGER)
		if name then
			self:INCREASE_LEAD_COUNT(entity,sender)
		end
		AI:Signal(SIGNALID_READIBILITY,1,"SPECIAL_GOT_TO_WAYPOINT",entity.id)
		entity:InsertSubpipe(0,"setup_stand")
		entity:InsertSubpipe(0,"just_shoot")
	end,

	INCREASE_LEAD_COUNT = function(self,entity,sender)
		entity.Properties.LEADING_COUNT=entity.Properties.LEADING_COUNT+1
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