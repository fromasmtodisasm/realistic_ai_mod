AIBehaviour.SniperIdle = {
	Name = "SniperIdle",

	OnSpawn = function(self,entity) -- Не срабатывает.
		-- called when enemy spawned or reset
		-- entity.RunToTrigger = 1 
		-- entity.MERC = "sniper"
		-- entity:SelectPipe(0,"sniper_getdown")
		-- System:Log(entity:GetName()..": SniperIdle/OnSpawn/entity.MERC: "..entity.MERC)
	end,
	
	OnActivate = function(self,entity)
		-- called when enemy receives an activate event (from a trigger,for example)
	end,

	OnNoTarget = function(self,entity) -- Должен тоже что-то делать когда потерял цель.
		entity.MERC = "sniper"
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY(entity) -- Нужно?
		entity.MERC = "sniper" -- Это если мерк не снайпер.
		if (not entity.cnt.weapon or entity.AllowUseMeleeOnNoAmmoInWeapons) and not entity.RunToTrigger then
			entity:SearchAmmunition(1,1)
		end
		entity.RunToTrigger = 1 
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		AI:Signal(0,1,"SAY_FIRST_HOSTILE_CONTACT",entity.id)
		entity:MakeAlerted()
		entity:InsertSubpipe(0,"just_shoot")
		entity:InsertSubpipe(0,"setup_stand")
		entity.SniperSetupStand=nil
		AIBehaviour.SniperAttack:OnPlayerSeen(entity,fDistance,1) -- Голоса THREATEN перекрывали FIRST_HOSTILE_CONTACT.
	end,

	OnEnemySeen = function(self,entity)
	end,

	OnFriendSeen = function(self,entity)
	end,

	OnSomethingSeen = function(self,entity,fDistance)
		entity.MERC = "sniper"
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if (entity:GetGroupCount() > 1) then
			AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_ALERT_SEEN_GROUP",entity.id)
		else
			AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_ALERT_SEEN",entity.id)
		end
		entity:InsertSubpipe(0,"setup_stealth") 
		entity:InsertSubpipe(0,"DRAW_GUN")
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity,fDistance)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:MakeAlerted()
		if (entity:GetGroupCount() > 1) then
			AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_ALERT_HEARD_GROUP",entity.id)
		else
			AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_ALERT_HEARD",entity.id)
		end
		entity:SelectPipe(0,"sniper_interesting_sound")
		if not entity.ThreatenStatus then
			entity.ThreatenStatus = 1 	
			entity:InsertSubpipe(0,"cover_lookat") 
		else
			AI:Signal(0,1,"ALERT_SIGNAL",entity.id)
		end
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:MakeAlerted()
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"NORMAL_THREAT_SOUND",entity.id)
		entity.ThreatenStatus = 1 
		if (entity:GetGroupCount() > 1) then
			AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_THREATENED_GROUP",entity.id)
		else
			AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_THREATENED",entity.id)
		end
		entity:SelectPipe(0,"sniper_threatening")
		entity:InsertSubpipe(0,"setup_stand")
	end,

	OnClipNearlyEmpty = function(self,entity,sender)
	end,

	OnReload = function(self,entity)
	end,

	OnNoHidingPlace = function(self,entity,sender)
	end,	

	OnNoFormationPoint = function(self,entity,sender)
	end,
	
	OnKnownDamage = function(self,entity,sender)
		AIBehaviour.CoverIdle:OnKnownDamage(entity,sender)
		entity:SelectPipe(0,"sniper_threatening")
		entity:InsertSubpipe(0,"setup_crouch")
		entity:MakeAlerted()
	end,

	OnReceivingDamage = function(self,entity,sender)
		entity:MakeAlerted()
		AIBehaviour.SniperAlert:OnReceivingDamage(entity)
	end,

	OnBulletRain = function(self,entity,sender)
		AIBehaviour.SniperIdle:OnReceivingDamage(entity,sender)
	end,

	OnSomethingDiedNearest = function(self,entity,sender)
		-- Hud:AddMessage(entity:GetName()..": SniperIdle/OnSomethingDiedNearest")
		-- System:Log(entity:GetName()..": SniperIdle/OnSomethingDiedNearest")
		entity:MakeAlerted()
		AIBehaviour.SniperAlert:OnSomethingDiedNearest(entity,sender)
	end,

	HEADS_UP_GUYS = function(self,entity,sender)
		if entity.Properties.species==sender.Properties.species and	entity.id~=sender.id then
			entity:MakeAlerted()
			entity:SelectPipe(0,"lookat_beacon")
			entity:GettingAlerted()
			AIBehaviour.DEFAULT:MyGroupWakeUp(entity)
			AIBehaviour.DEFAULT:AllWakeUp(entity)
			AIBehaviour.DEFAULT:HEADS_UP_GUYS_GROUP(entity)
		end
	end,

	ALARM_ON = function(self,entity,sender)
		-- the team can split
		AIBehaviour.SniperIdle:ALERT_SIGNAL(entity,sender)
	end,

	ALERT_SIGNAL = function(self,entity,sender) -- Позырь, чего там?!
		if entity:ForbiddenCharacters() then do return end end
		if entity.Properties.species==sender.Properties.species then
			if not entity.alert_signal_sent then
				entity.alert_signal_sent = 1 
				entity:MakeAlerted()
				entity:SelectPipe(0,"sniper_threatening")
				entity:InsertSubpipe(0,"setup_stand")
				entity:InsertSubpipe(0,"DropBeaconAt",sender.id)		
				AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"ALERT_SIGNAL",entity.id)
			end
		end
	end,
	
	NORMAL_THREAT_SOUND = function(self,entity,sender) -- Вставить пайпу чтобы смотрел по сторонам.
		if entity.Properties.species==sender.Properties.species then
			if entity~=sender then
				if not entity.THREAT_SOUND_SIGNAL_SENT then
					entity.THREAT_SOUND_SIGNAL_SENT = 1 
					-- entity:ChangeAIParameter(AIPARAM_COMMRANGE,50)
					entity:MakeAlerted()
					AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"NORMAL_THREAT_SOUND",entity.id) 
					entity:SelectPipe(0,"sniper_threatening")
					entity:InsertSubpipe(0,"setup_stand")
					-- entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)
					-- Hud:AddMessage("Sniper NORMAL_THREAT_SOUND "..entity:GetName())
					System:Log("Sniper NORMAL_THREAT_SOUND "..entity:GetName())
				end
			end
		end
	end,

	INCOMING_FIRE = function(self,entity,sender)
		if (entity~=sender) then
			entity:MakeAlerted()
			entity:InsertSubpipe(0,"DropBeaconAt",sender.id)
		end
	end,
}