--------------------------------------------------
--    Created By: Petar
--   Description: behaviour when the AI has been alerted to something
--------------------------
--

AIBehaviour.ScoutAlert = {
	Name = "ScoutAlert",

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		AIBehaviour.ScoutIdle:OnPlayerSeen(entity,fDistance,1)
	end,
	---------------------------------------------
	OnEnemyMemory = function(self,entity,fDistance,NotContact)
	end,

	OnSomethingSeen = function(self,entity)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		-- entity:SelectPipe(0,"cover_beacon_pindown") -- Здесь должно быть FINISH_RUN_TO_FRIEND
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity)
		entity.counter_dead = 3 
		entity.rs_x = 1 
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if not entity.ThreatenStatus2 then
			entity.ThreatenStatus2 = 1 	
		else
			AI:Signal(0,1,"SAY_FIRST_HOSTILE_CONTACT",entity.id)
			entity:RunToAlarm()
			AI:Signal(0,1,"SCOUT_HUNT",entity.id)
		end
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity,fDistance)
		entity.counter_dead = 3 
		entity.rs_x = 1 
		entity:TriggerEvent(AIEVENT_CLEAR)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"NORMAL_THREAT_SOUND",entity.id)
		entity.ThreatenStatus2 = 1 
		if not entity.ThreatenStatus3 then
			entity.ThreatenStatus3 = 1 	
		else
			entity:RunToAlarm()
			AI:Signal(0,1,"SAY_FIRST_HOSTILE_CONTACT",entity.id)
			if (fDistance > 30) then 
				AI:Signal(0,1,"SCOUT_NORMALATTACK",entity.id)
			else
				AI:Signal(0,1,"SCOUT_HUNT",entity.id)
			end
		end
	end,

	OnReload = function(self,entity)
		-- called when the enemy goes into automatic reload after its clip is empty
	end,

	OnNoHidingPlace = function(self,entity,sender)
		-- called when no hiding place can be found with the specified parameters
	end,	

	OnNoFormationPoint = function(self,entity,sender)
		-- called when the enemy found no formation point
	end,
	
	OnCoverRequested = function(self,entity,sender)
		-- called when the enemy is damaged
	end,

	OnKnownDamage = function(self,entity,sender)
		AIBehaviour.CoverAlert:OnKnownDamage(entity,sender)
		entity:SelectPipe(0,"scout_scramble")
	end,

	OnReceivingDamage = function(self,entity,sender)
		AIBehaviour.CoverAlert:OnReceivingDamage(entity,sender)
	end,

	OnBulletRain = function(self,entity,sender)
		AIBehaviour.CoverAlert:OnBulletRain(entity,sender)
	end,

	OnSomethingDiedNearest = function(self,entity,sender)
		entity.ThreatenStatus2 = 1 
		entity.ThreatenStatus3 = 1 
		if not entity.rs_x then
			AIBehaviour.DEFAULT:OnSomethingDiedNearest(entity,sender)
		else
			if entity.Properties.species==sender.Properties.species then
				if not entity.counter_dead then entity.counter_dead = 1  end
				entity.counter_dead = entity.counter_dead+1 
				if not entity:RunToAlarm() then
					if entity.counter_dead==2 then
						entity:SelectPipe(0,"LookAtTheBody",sender.id)
					elseif entity.counter_dead >= 3 then
						entity:SelectPipe(0,"randomhide")
						if not entity:GrenadeAttack(3) then
							if entity.counter_dead==3 then
								entity:InsertSubpipe(0,"TeamMemberDiedLook2")
							end
						end
					end
				end
			end
		end
	end,

	KEEP_ALERTED = function(self,entity,sender)
	end,

	DEATH_CONFIRMED = function(self,entity,sender)
		if entity.Properties.species==sender.Properties.species then
			if entity==sender then 
				if not entity:RunToAlarm() then
					local Result = entity:NewCountingPlayers(30,0,0,1)
					if Result[1]>1 then
						local Result = entity:NewCountingPlayers(100,0,0,1)
						if Result[5]>1 and Result[5]>Result[6] then
							AI:Signal(SIGNALID_READIBILITY,2,"SEARCHING_MUTANTS",entity.id)
						else
							if Result[6]>0 then
								if random(1,2)==1 then
									entity:Readibility("SEARCHING_GENERIC_X",1) -- "Найти его!".
								else
									entity:Readibility("SEARCHING_PLAYER",1)
								end
							else
								entity:Readibility("SEARCHING_GENERIC_X",1)
							end
						end
						System:Log(entity:GetName()..": SEARCHING_GENERIC")
					end
				end
			end
			if entity~=sender then
				System:Log(entity:GetName()..": DEATH_CONFIRMED!!")
				entity:SelectPipe(0,"ChooseManner")
			end
		end
	end,

	DEATH_CONFIRMED_X = function(self,entity,sender)
		if entity.dc then
			entity.dc = nil 
			entity:SelectPipe(0,"ChooseManner")
			do return end
		end
		entity.dc = 1 
		entity:CountingPlayers(30)
		if entity.friendscount then
			entity:Readibility("FRIEND_DEATH_GROUP",1)
			System:Log(entity:GetName()..": FRIEND_DEATH_GROUP!!")
		end
	end,

	-- GROUP SIGNALS
	---------------------------------------------	
	INCOMING_FIRE = function(self,entity,sender)
		if (entity~=sender) then
			entity:SelectPipe(0,"randomhide")
		end
	end,
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