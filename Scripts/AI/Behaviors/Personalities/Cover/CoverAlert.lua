--------------------------------------------------
--   Created By: Petar
--   Description: This behaviour activates as a response to an island-wide alarm call,or in response to a group death
--------------------------------------------------
--   last modified by: sten 23-10-2002

AIBehaviour.CoverAlert = {
	Name = "CoverAlert",

	OnNoTarget = function(self,entity)
		AIBehaviour.DEFAULT:OnNoTarget(entity)
		entity:InsertSubpipe(0,"reload")
	end,
	---------------------------------------------
	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		AIBehaviour.CoverIdle:OnPlayerSeen(entity,fDistance,1)
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
		-- if (_localplayer.sspecies==entity.Properties.species) then
			-- entity:InsertSubpipe(0,"devalue_target")
			-- return
		-- end
		entity.counter_dead = 3  -- Добавить и для других состояний.
		entity.rs_x = 1 
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if not entity.ThreatenStatus5 then
			entity.ThreatenStatus5 = 1 
		else
			AI:Signal(0,1,"SAY_FIRST_HOSTILE_CONTACT",entity.id)
			entity:RunToAlarm()
			AI:Signal(0,1,"COVER_NORMALATTACK",entity.id)
			-- entity:SelectPipe(0,"cover_look_closer")
		end
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity,fDistance)
		-- Hud:AddMessage(entity:GetName()..": CoverAlert/OnThreateningSoundHeard")
		entity.ThreatenStatus5 = 1 
		entity.counter_dead = 3 
		entity.rs_x = 1 
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"NORMAL_THREAT_SOUND",entity.id)
		if not entity.ThreatenStatus6 then
			entity.ThreatenStatus6 = 1 
			entity:InsertSubpipe(0,"cover_lookat")
		else
			entity:RunToAlarm()
			if (fDistance > 30) then
				AI:Signal(0,1,"SAY_FIRST_HOSTILE_CONTACT",entity.id)
				AI:Signal(0,1,"COVER_NORMALATTACK",entity.id)
			else
				if (entity:GetGroupCount() > 1) then
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_THREATENED_GROUP",entity.id)
				else
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_INTERESTING,"IDLE_TO_THREATENED",entity.id)
				end
				AI:Signal(0,1,"INVESTIGATE_TARGET",entity.id)
				if (fDistance <= 10) then -- Проверить.
					entity:InsertSubpipe(0,"not_so_random_hide_from")
				end
			end
		end
	end,

	OnClipNearlyEmpty = function(self,entity,sender)
		entity:SelectPipe(0,"cover_scramble")
	end,

	OnReload = function(self,entity)
		entity:SelectPipe(0,"cover_scramble")
	end,

	OnNoHidingPlace = function(self,entity,sender)
	end,

	OnNoFormationPoint = function(self,entity,sender)
		-- called when the enemy found no formation point
	end,

	OnCoverRequested = function(self,entity,sender)
		-- called when the enemy is damaged
	end,

	OnKnownDamage = function(self,entity,sender) -- А если очень близко?
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:SelectPipe(0,"cover_scramble")
		-- entity:InsertSubpipe(0,"DropBeaconTarget",sender.id)
		entity:InsertSubpipe(0,"scared_shoot",sender.id)
	end,

	OnReceivingDamage = function(self,entity,sender)
		AIBehaviour.DEFAULT:OnReceivingDamage(entity,sender)
		entity:SelectPipe(0,"getting_shot_at")
	end,

	OnBulletRain = function(self,entity,sender)	-- Нужно чтобы сразу прятались
		AIBehaviour.DEFAULT:OnBulletRain(entity,sender)
		entity:SelectPipe(0,"getting_shot_at")
		entity:GrenadeAttack(6)
	end,

	OnSomethingDiedNearest = function(self,entity,sender)
		entity.ThreatenStatus5 = 1 
		entity.ThreatenStatus6 = 1 
		if not entity.rs_x then
			AIBehaviour.DEFAULT:OnSomethingDiedNearest(entity,sender)
		else
			if entity.Properties.species==sender.Properties.species then
				if not entity.counter_dead then entity.counter_dead = 1  end
				entity.counter_dead = entity.counter_dead+1 
				if not entity:RunToAlarm() then
					if entity.counter_dead==2 then -- Добавить голос: "Что за?"
						-----------------------------------------------
						-- -- entity:TriggerEvent(AIEVENT_CLEAR) -- С этим обновляется и маяк.
						-- AI:CreateGoalPipe("pipename") -- Сочетание
						-- AI:PushGoal("pipename","form",1,"beacon") -- этого
						-- AI:PushGoal("pipename","acqtarget",1,"") -- этого
						-- entity:SelectPipe(0,"pipename",sender.id) -- и этого даёт интересный результат! Чел постоянно смотрит на цель, с корректировкой по вертикалям, как на игрока!
						-----------------------------------------------
						entity:SelectPipe(0,"LookAtTheBody",sender.id)
					elseif entity.counter_dead >= 3 then
						if random(1,2)==1 then
							AIBehaviour.CoverAttack:COVER_CAMP(entity,sender)
						else
							AIBehaviour.CoverAttack:HIDE_TACTIC(entity,sender)
						end
						if not entity:GrenadeAttack(3) then
							if entity.counter_dead==3 then
								entity:TriggerEvent(AIEVENT_CLEAR)
								entity:InsertSubpipe(0,"TeamMemberDiedLook2")
							elseif entity.counter_dead > 3 then
								entity:InsertSubpipe(0,"LookAtTheBody",sender.id)
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

	COVER_NORMALATTACK = function(self,entity,sender)
		entity:SelectPipe(0,"cover_pindown")
		entity:InsertSubpipe(0,"reload")
	end,

	Cease = function(self,entity,fDistance)
		entity:SelectPipe(0,"cover_cease_approach") -- in PipeManagerShared.lua
	end,
	---------------------------------------------
	TRY_TO_LOCATE_SOURCE = function(self,entity,sender)
		entity:TriggerEvent(AIEVENT_CLEAR)
		entity:SelectPipe(0,"lookaround_30seconds")
	end,

	DEATH_CONFIRMED = function(self,entity,sender) -- Во время боя срабатывание реког корпс убрать. 2
		if entity.Properties.species==sender.Properties.species then
			-- entity:RunToAlarm()
			if entity==sender then 
				-- if entity.friendscount and entity.friendscount <= 5 then
					-- if not entity:RunToAlarm() then
						-- AI:Signal(0,1,"FIND_A_TARGET",entity.id)
					-- end
					-- do return end
				-- end
				-- if entity.friendscount and entity.dc then
				if not entity:RunToAlarm() then
					local Result = entity:NewCountingPlayers(30,0,0,1)
					if Result[1]>1 then
						local Result = entity:NewCountingPlayers(100,0,0,1)
						if Result[5]>1 and Result[5]>Result[6] then
							AI:Signal(SIGNALID_READIBILITY,2,"SEARCHING_MUTANTS",entity.id) -- Добавить ещё проверку на то, кто убил его.
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
				-- entity:RunToAlarm()
			end
			-- if entity~=sender and not entity.dc then
			if entity~=sender then
				System:Log(entity:GetName()..": DEATH_CONFIRMED!")
				-- if entity.friendscount <= 5 then
					-- if not entity:RunToAlarm() then
						entity:SelectPipe(0,"ChooseManner")
					-- end
				-- end
			end
		end
	end,

	DEATH_CONFIRMED_X = function(self,entity,sender) -- Вызывается из пайпы RecogCorpse. 1,3
		if entity.dc then
			entity.dc = nil 
			-- if not entity:RunToAlarm() then
				entity:SelectPipe(0,"ChooseManner")
			-- end
			do return end
		end
		entity.dc = 1 
		entity:CountingPlayers(30)
		if entity.friendscount then
			entity:Readibility("FRIEND_DEATH_GROUP",1) -- "Его подстрелили!".
			-- Hud:AddMessage(entity:GetName()..": FRIEND_DEATH_GROUP!!")
			System:Log(entity:GetName()..": FRIEND_DEATH_GROUP!!")
		end
	end,
	--------------------------------------------------
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
	target_lost_animation = function(self,entity,sender) -- Они рабочие!
		entity:StartAnimation(0,"enemy_target_lost",0)
	end,
	
	confused_animation = function(self,entity,sender)
		entity:StartAnimation(0,"_headscratch1",0)
	end,
	
}