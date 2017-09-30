--------------------------------------------------
--   Created By: Sten
--   Description: Rear Alert
--------------------------

AIBehaviour.RearAlert = {
	Name = "RearAlert",

	OnNoTarget = function(self,entity)
		AIBehaviour.DEFAULT:OnNoTarget(entity)
		entity:InsertSubpipe(0,"reload")
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		AIBehaviour.RearIdle:OnPlayerSeen(entity,fDistance,1)
	end,

	OnEnemySeen = function(self,entity)
		-- called when the enemy sees a foe which is not a living player
	end,
	---------------------------------------------
	OnFriendSeen = function(self,entity)
		-- called when the enemy sees a friendly target
	end,

	OnSomethingSeen = function(self,entity)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		-- entity:SelectPipe(0,"cover_beacon_pindown")
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		-- called when the enemy can no longer see its foe,but remembers where it saw it last
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
			AI:Signal(0,1,"REAR_NORMALATTACK",entity.id)
			entity:InsertSubpipe(0,"DropBeaconTarget") -- in PipeManagerShared.lua
		end
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity,fDistance)
		entity.ThreatenStatus2 = 1
		entity.counter_dead = 3
		entity.rs_x = 1
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"NORMAL_THREAT_SOUND",entity.id)
		if not entity.ThreatenStatus3 then
			entity.ThreatenStatus3 = 1
			entity:InsertSubpipe(0,"cover_lookat")
		else
			entity:RunToAlarm()
			AI:Signal(0,1,"SAY_FIRST_HOSTILE_CONTACT",entity.id)
			if (fDistance > 30) then -- Добавить чтобы прятался.
				AI:Signal(0,1,"REAR_NORMALATTACK",entity.id)
			else
				AI:Signal(0,1,"REAR_PROTECT_AND_NORMALATTACK",entity.id)
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
		entity:SelectPipe(0,"rear_scramble")
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
						entity:SelectPipe(0,"rear_goforcover")
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

	--------------------------------------------------
	-- CUSTOM SIGNALS
	--------------------------------------------------
	Cease = function(self,entity,fDistance)
		entity:SelectPipe(0,"rear_cease_investigation") -- in PipeManagerShared.lua
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
	--------------------------------------------------
	----------------- GROUP SIGNALS ------------------
	--------------------------------------------------

	REAR_NORMALATTACK = function(self,entity,sender)
		-- entity.ThrowGrenade = nil  -- Нужно ли?
		entity:SelectPipe(0,"rear_comeout")
	end,

	REAR_PROTECT_AND_NORMALATTACK = function(self,entity,sender)
		entity:SelectPipe(0,"protect_spot",entity:GetName().."_PROTECT")
	end,
	---------------------------------------------
	INCOMING_FIRE = function(self,entity,sender)
		if (entity~=sender) then
			entity:SelectPipe(0,"randomhide")
		end
	end,


	------------------------------ Animation -------------------------------
	target_lost_animation = function(self,entity,sender)
		entity:StartAnimation(0,"sSoundheard",0)
	end,

	confused_animation = function(self,entity,sender)
		entity:StartAnimation(0,"_chinrub",0)
	end,

	--------------------------------------------------
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