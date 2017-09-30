AIBehaviour.SniperAttack = {
	Name = "SniperAttack",
	
	OnLeftLean = function(self,entity,sender)
		if not entity.RunToTrigger and entity.not_sees_timer_start==0 and entity.Properties.KEYFRAME_TABLE~="VALERIE" and not entity.cnt.reloading then
			entity.LeanLeftDelay = _time+5
		end
	end,

	OnRightLean = function(self,entity,sender)
		if not entity.RunToTrigger and entity.not_sees_timer_start==0 and entity.Properties.KEYFRAME_TABLE~="VALERIE" and not entity.cnt.reloading then
			entity.LeanRightDelay = _time+5
		end
	end,

	OnActivate = function(self,entity)

	end,

	OnNoTarget = function(self,entity)
		-- Hud:AddMessage(entity:GetName()..": OnNoTarget")
		AIBehaviour.DEFAULT:OnNoTarget(entity)
		entity:InsertSubpipe(0,"reload")
		entity:InsertSubpipe(0,"setup_stand")
		entity:InsertSubpipe(0,"basic_lookingaround")
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		if not fDistance then fDistance = entity:GetDistanceToTarget() end
		if not fDistance then fDistance = 0 NotContact=1 end
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		-- Hud:AddMessage(entity:GetName()..": OnPlayerSeen")
		if not NotContact then
			AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY_ON_ATTACK(entity)
			-- if (entity:GetGroupCount() > 1) then
				-- AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN_GROUP",entity.id)
			-- else
				AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN",entity.id)
			-- end
		end
		entity:SelectPipe(0,"sniper_shoot")
		local pos = entity:GetBonePos("weapon_bone")
		local angle = entity:GetAngles()
		local hits
		if pos then
			hits = System:RayWorldIntersection(pos,angle,1,ent_all,entity.id)
		end
		if entity.SniperNotSitDownOnUseRL or getn(hits)==1 then
			entity:InsertSubpipe(0,"just_shoot")
		else
			entity:InsertSubpipe(0,"dumb_shoot")
		end
		if not entity.SniperSetupStand and not entity.cnt.proning and not entity.cnt.crouching then
			entity.SniperSetupStand=1 
			entity:InsertSubpipe(0,"setup_stand")
		end
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact) -- Сделать чтобы смотрел в то место где видел цель. Либо тэг поинтом, либо сущностью с регом для ИИ.
		-- Hud:AddMessage(entity:GetName()..": OnEnemyMemory")
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		-- if (entity:GetGroupCount() > 1) then
			-- AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN_GROUP",entity.id)
		-- else
			-- AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN",entity.id)
		-- end
		if not entity.poscount then entity.poscount = 0  end
		entity.poscount = entity.poscount + 11 
		entity:SelectPipe(0,"just_shoot") -- sniper_shoot не ставить! Выбирается по истечении таймаута.
		if entity.PropertiesInstance.bClosedWalls==0 then
			AI:CreateGoalPipe("time_out")
			AI:PushGoal("time_out","timeout",1,1,20)
			entity:InsertSubpipe(0,"time_out")
		end
		entity:InsertSubpipe(0,"reload")
		if entity.cnt.proning then
			if entity.SniperNotSitDownOnUseRL then
				entity:InsertSubpipe(0,"setup_stealth")
			else
				entity:InsertSubpipe(0,"setup_crouch")
			end
		elseif entity.cnt.crouching then
			if entity.SniperNotSitDownOnUseRL then
				entity:InsertSubpipe(0,"setup_stealth")
			else
				entity:InsertSubpipe(0,"setup_stand")
			end
		end
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity)	
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"NORMAL_THREAT_SOUND",entity.id)
	end,
	
	OnNoFormationPoint = function(self,entity,sender)
	end,
	
	OnCoverRequested = function(self,entity,sender)
	end,
	
	OnClipNearlyEmpty = function(self,entity,sender)
	end,

	OnReload = function(self,entity)
		if not entity.cnt.proning and not entity.cnt.crouching then
			entity:InsertSubpipe(0,"setup_crouch")
		end
	end,

	OnKnownDamage = function(self,entity,sender)
		entity:InsertSubpipe(0,"prone_time_out")
		entity:InsertSubpipe(0,"retaliate_damage",sender.id)
	end,

	OnReceivingDamage = function(self,entity,sender)
		entity:InsertSubpipe(0,"prone_time_out")
	end,

	OnBulletRain = function(self,entity,sender)
		AIBehaviour.SniperAttack:OnReceivingDamage(entity,sender)	
	end,

	OnSomethingDiedNearest = function(self,entity,sender) -- Доделать.
	end,

	OnSomethingDiedNearest_x = function(self,entity,sender)
	end,

	HEADS_UP_GUYS = function(self,entity,sender) -- Доделать.
		AIBehaviour.DEFAULT:AllWakeUp(entity)
	end,
	
	SNIPER_CHANGE_STACE = function(self,entity,fDistance)	
		if not fDistance then fDistance = entity:GetDistanceToTarget() end
		if not fDistance then fDistance = 0 NotContact=1 end
		if not entity.SniperSetupStand and not entity.cnt.proning and not entity.cnt.crouching then
			entity.SniperSetupStand = 1 
			entity:InsertSubpipe(0,"setup_stand")
		end
		entity:SelectPipe(0,"sniper_shoot")
		local pos = entity:GetBonePos("weapon_bone")
		local angle = entity:GetAngles()
		-- entity.cnt:GetFirePosAngles(pos,angle)
		local hits
		if pos then
			hits = System:RayWorldIntersection(pos,angle,1,ent_all,entity.id)
			-- Hud:AddMessage(entity:GetName()..": HITS: "..getn(hits))
		end
		if entity.SniperNotSitDownOnUseRL or getn(hits)==1 then
			entity:InsertSubpipe(0,"just_shoot")
		else
			entity:InsertSubpipe(0,"dumb_shoot")
		end
		local point = AI:GetAnchor(entity.id,AIAnchor.AIANCHOR_SHOOTSPOTSTAND,10)
		if (point) then
			entity:InsertSubpipe(0,"setup_stand")
		else
			point = AI:GetAnchor(entity.id,AIAnchor.AIANCHOR_SHOOTSPOTCROUCH,10)
			if (point) then
				entity:InsertSubpipe(0,"setup_crouch")
				do return end 
			end
			if not entity.poscount then entity.poscount = 0  end
			entity.poscount = entity.poscount+1 
			-- Hud:AddMessage(entity:GetName()..": poscount "..entity.poscount)
			if entity.poscount <= 10 then do return end  else entity.poscount = 0  end
			rnd = random(1,10)
			if fDistance <= 8 then -- attempt to compare number with nil
				if rnd <= 3 then
					entity:InsertSubpipe(0,"setup_crouch")
				elseif rnd <= 5 then
					entity:InsertSubpipe(0,"setup_prone")
				else
					entity:InsertSubpipe(0,"setup_stealth")
				end
			elseif fDistance <= 50 then 
				if entity.SniperNotSitDownOnUseRL then
					entity:InsertSubpipe(0,"setup_stealth")
				else
					if rnd > 3 then
						entity:InsertSubpipe(0,"setup_crouch")
					else
						entity:InsertSubpipe(0,"setup_prone")
					end
				end
			elseif fDistance > 50 then
				if entity.SniperNotSitDownOnUseRL~=0 then
					entity:InsertSubpipe(0,"setup_stealth")
				else
					if rnd > 3 then
						entity:InsertSubpipe(0,"setup_prone")
					else
						entity:InsertSubpipe(0,"setup_crouch")
					end
				end
			end
		end
	end,
}