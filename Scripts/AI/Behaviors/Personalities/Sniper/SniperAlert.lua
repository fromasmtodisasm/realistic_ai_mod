AIBehaviour.SniperAlert = {
	Name = "SniperAlert",

	OnActivate = function(self,entity)
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		AI:Signal(0,1,"SAY_FIRST_HOSTILE_CONTACT",entity.id)
		entity:InsertSubpipe(0,"setup_stand")
		entity:SelectPipe(0,"sniper_shoot")
		AIBehaviour.SniperAttack:OnPlayerSeen(entity,fDistance,1)
	end,

	OnEnemySeen = function(self,entity)
	end,

	OnFriendSeen = function(self,entity)
	end,

	OnSomethingSeen = function(self,entity,fDistance)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if not entity.ThreatenStatus2 then
			entity.ThreatenStatus2 = 1 	
			if (entity:GetGroupCount() > 1) then
				AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_THREATENED_GROUP",entity.id)
			else
				AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_THREATENED",entity.id)
			end
		else
			AI:Signal(0,1,"OnPlayerSeen",entity.id)
		end
	end,

	OnThreateningSoundHeard = function(self,entity)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"NORMAL_THREAT_SOUND",entity.id)
		entity.ThreatenStatus2 = 1 	
		entity:SelectPipe(0,"sniper_threatening")
		entity:InsertSubpipe(0,"setup_stand")
	end,	

	OnNoFormationPoint = function(self,entity,sender)
		-- called when the enemy found no formation point
	end,
	
	OnCoverRequested = function(self,entity,sender)
		-- called when the enemy is damaged
	end,

	OnKnownDamage = function(self,entity,sender)
		entity:InsertSubpipe(0,"retaliate_damage",sender.id)
		entity:InsertSubpipe(0,"scared_shoot",sender.id)
	end,

	OnReceivingDamage = function(self,entity,sender)
		entity:TriggerEvent(AIEVENT_CLEAR)
		if (entity:GetGroupCount() > 1) then
			AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"GETTING_SHOT_AT_GROUP",entity.id)
		else
			AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"GETTING_SHOT_AT",entity.id)
		end
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"INCOMING_FIRE",entity.id)
		entity:SelectPipe(0,"sniper_alarmed")
		entity:InsertSubpipe(0,"setup_prone")
	end,

	OnBulletRain = function(self,entity,sender)
		AIBehaviour.SniperAlert:OnReceivingDamage(entity,sender)
	end,

	OnSomethingDiedNearest = function(self,entity,sender) -- Переделать.
		entity:InsertSubpipe("DropBeaconAt",sender.id)
		entity:SelectPipe(0,"sniper_threatening")
		entity:InsertSubpipe(0,"sniper_alarmed")
		entity:InsertSubpipe(0,"lookat_beacon",sender.id)
	end,
	
	SNIPER_WAIT = function(self,entity,sender)
		entity:SelectPipe(0,"sniper_wait")
		entity:InsertSubpipe(0,"setup_stand")
	end,
	
	INCOMING_FIRE = function(self,entity,sender)
		if (entity~=sender) then
			entity:InsertSubpipe(0,"DropBeaconAt",sender.id)
		end
	end,
	
	ALARM_ON = function(self,entity,sender)
		-- the team can split
		AIBehaviour.SniperIdle:ALERT_SIGNAL(entity,sender)
	end,

	ALERT_SIGNAL = function(self,entity,sender)
		if entity:ForbiddenCharacters() then do return end end
		if entity.Properties.species==sender.Properties.species then
			if not entity.alert_signal_sent then
				entity.alert_signal_sent = 1 
				AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"ALERT_SIGNAL",entity.id)
			end
		end
	end,
	
	NORMAL_THREAT_SOUND = function(self,entity,sender)
		if entity.Properties.species==sender.Properties.species then
			if entity~=sender then
				if not entity.THREAT_SOUND_SIGNAL_SENT then
					entity.THREAT_SOUND_SIGNAL_SENT = 1 
					AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"NORMAL_THREAT_SOUND",entity.id) 
				end
			end
		end
	end,
}