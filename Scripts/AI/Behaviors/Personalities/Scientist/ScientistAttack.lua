--------------------------------------------------
--    Created By: Amanda
--   Description: Attack behaviour for the Scientist personality
--------------------------
--

AIBehaviour.ScientistAttack = {
	Name = "ScientistAttack",
	Direction = 0,

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
		-- called when enemy receives an activate event (from a trigger,for example)
	end,
	---------------------------------------------
	OnNoTarget = function(self,entity)
		-- called when the enemy stops having an attention target
	end,
	---------------------------------------------
	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		-- attack player only if they are too close to get away otherwise
		-- seek reinforcement point or hide farthest from target.
		System:Log("[".. entity:GetName().."] ScientistAttack++++++player seen reinforce point["..entity.Properties.ReinforcePoint .."]")

		AI:Signal(0,1,"SAY_FIRST_HOSTILE_CONTACT",entity.id)

		if (entity.SIGNAL_SENT==nil) then
			if (entity:GetGroupCount() > 1) then
				AI:Signal(0,1,"NOTIFY_GROUP_SIGNAL",entity.id)
			end
		end

		if ((entity.Properties.ReinforcePoint==nil) or (entity.Properties.ReinforcePoint=="none")) then

			-- you are on your own
			if (fDistance<5) then
				System:Log("[".. entity:GetName().."] player seen++++++too close defend")
				entity:SelectPipe(0,"scientist_tooclose_defend")
			else
				System:Log("[".. entity:GetName().."] player seen++++++scientist_runAway")
				entity:SelectPipe(0,"scientist_runAway")
			end

		else
			-- only send this signal if you have a ReinforcePoint defined
--			if (fDistance<10) then
--				System:Log("[".. entity:GetName().."] player seen++++++scientist_tooclose_defend_ReinforcePoint")
--				entity:SelectPipe(0,"scientist_tooclose_defend_ReinforcePoint",entity.Properties.ReinforcePoint)
--			else
--				System:Log("[".. entity:GetName().."] player seen++++++scientist_ReinforcePoint")
				entity:SelectPipe(0,"scientist_ReinforcePoint",entity.Properties.ReinforcePoint)
--			end
		end
	end,
	---------------------------------------------
	OnEnemySeen = function(self,entity)
		-- called when the enemy sees a foe which is not a living player
	end,
	---------------------------------------------
	OnFriendSeen = function(self,entity)
		-- called when the enemy sees a friendly target
	end,

	OnDeadBodySeen = function(self,entity,sender,fDistance)
		if entity.Properties.species==sender.Properties.species and fDistance<=10 and entity.sees~=1 then
			entity:InsertSubpipe(0,"retreat_on_dead_body_seen",sender.id)
		end
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		-- called when the enemy can no longer see its foe,but remembers where it saw it last
		--System:Log("++++++++++++++++++++++++++ATTACK OnEnemyMemory")
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity)
		-- called when the enemy hears an interesting sound
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity)
		-- called when the enemy hears a scary sound
	end,
	---------------------------------------------
	OnReload = function(self,entity)
		-- called when the enemy goes into automatic reload after its clip is empty
	end,
	---------------------------------------------
	OnClipNearlyEmpty = function(self,entity)
		entity:SelectPipe(0,"scientist_hideNow")
	end,
	---------------------------------------------
	OnGroupMemberDied = function(self,entity)
		-- dont handle this
	end,
	---------------------------------------------
	OnGroupMemberDiedNearest = function(self,entity)
		-- dont handle this
	end,
	OnSomethingDiedNearest_x = function(self,entity,sender)
	end,
	OnNoHidingPlace = function(self,entity,sender)
		-- called when no hiding place can be found with the specified parameters
		AI:Signal(0,1,"SCOUT_NORMALATTACK",entity.id)
	end,
	---------------------------------------------
	OnReceivingDamage = function(self,entity,sender)

		-- DO NOT TOUCH THIS READIBILITY SIGNAL	------------------------
		AI:Signal(SIGNALID_READIBILITY,1,"GETTING_SHOT_AT",entity.id)
		----------------------------------------------------------------

		entity:SelectPipe(0,"scientist_hideNow")
	end,
	--------------------------------------------------
	OnBulletRain = function(self,entity,sender)
	end,
	---------------------------------------------
	OnCoverRequested = function(self,entity,sender)
		-- called when the enemy is damaged
	end,

	-- CUSTOM
	---------------------------------------------------------
	SCIENTIST_CLOSEATTACK = function(self,entity,sender)
 		local hasGun = entity.cnt.weapon
		if (hasGun) then
			entity:InsertSubpipe("scientist_defend",0)
		end
	end,

	SCIENTIST_NORMALATTACK = function(self,entity,sender)
--		System:Log("\001++++++++++++++++++++++++++SCIENTIST_NORMALATTACK")
		local combatAnchor = AI_CombatManager:FindAnchor(entity,AI_CombatManager.AICOMBAT_SCIENTIST,10)
		if (combatAnchor) then
			if (entity.AlarmPulled and (entity.AlarmPulled==1)
				and((combatAnchor=="") or (combatAnchor==""))) then
				entity:SelectPipe(0,"scientist_cower")
			else
			--entity:InsertSubpipe(0,combatAnchor.signal,combatAnchor.found)
				entity:SelectPipe(0,combatAnchor.signal,combatAnchor.found)
			end

		else
			entity:SelectPipe(0,"scientist_cower")
		end
	end,
	---------------------------------------------
	HEADS_UP_GUYS = function(self,entity,sender)

	end,
}