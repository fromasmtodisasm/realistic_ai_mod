-- created by petar
--------------------------
AIBehaviour.Job_PracticeFire = {
	Name = "Job_PracticeFire",
	JOB = 1,

	OnSpawn = function(self,entity)
		if not entity.PracticleFireMan then entity:InitAIRelaxed() end -- По возвращении из-за этого релакса снова доставал пушку.
		entity.PracticleFireMan = 1

		local shoot_target = entity:GetName().."_SHOOT"
		-- try to get tagpoint of the same name as yourself first
		local TargetPoint = Game:GetTagPoint(shoot_target)
 		if not TargetPoint then
			-- try to fish for a observation anhor within 2 meter from yourself
			shoot_target = AI:FindObjectOfType(entity.id,100,AIAnchor.SHOOTING_TARGET)
		end
		if shoot_target then
			-- AI:CreateGoalPipe("practice_shot")
			-- AI:PushGoal("practice_shot","acqtarget",1,shoot_target)
			-- entity:SelectPipe(0,"practice_shot",shoot_target)

			AI:CreateGoalPipe("practice_shot")
			AI:PushGoal("practice_shot","form",1,"beacon")
			AI:PushGoal("practice_shot","acqtarget",0,"")
			AI:PushGoal("practice_shot","not_shoot")
			AI:PushGoal("practice_shot","signal",1,1,"PRACTICLE_CHECK_WEAPON_AMMO",0)
			AI:PushGoal("practice_shot","timeout",1,.5)
			AI:PushGoal("practice_shot","signal",1,1,"DO_SOMETHING_SPECIAL",0)
			AI:PushGoal("practice_shot","just_shoot")
			AI:PushGoal("practice_shot","timeout",1,.5,1.5)
			AI:PushGoal("practice_shot","dumb_shoot")
			AI:PushGoal("practice_shot","timeout",1,2,4)
			entity:SelectPipe(0,"practice_shot",shoot_target)
			entity:GunOut()
		else
			System:Warning("[AI] Entity "..entity:GetName().." has practice fire job assigned to it but no shooting target.")
			self:OnLowAmmoExit(entity,1)
		end
		entity:InsertSubpipe(0,"do_it_walking")

		entity.ShootPosName = entity:GetName().."_SHOOTPOS"
		local PosTagPoint = Game:GetTagPoint(entity.ShootPosName)
		if not PosTagPoint and Game.CreateTagPoint then -- Если точка не найдена, то создать её самому.
			-- Game:CreateTagPoint(entity.ShootPosName,entity:GetPos(),entity:GetAngles()) -- Возвращает еденицу.
			entity:CreateTagPoint(entity.ShootPosName)
		end
		PosTagPoint = Game:GetTagPoint(entity.ShootPosName)
		-- if PosTagPoint then
		local NotAllow
		if strfind(strlower(entity:GetName()),strlower("MortarGuy")) and entity.PropertiesInstance.groupid==7171 then -- Временно.
			-- Hud:AddMessage(entity:GetName()..": NotAllow")
			NotAllow = 1
		end
		if PosTagPoint and not NotAllow then
			local Pos = entity:GetPos()
			-- System:Log(entity:GetName()..": PosTagPoint: "..PosTagPoint.x..", "..PosTagPoint.y..", "..PosTagPoint.z..", entity: "..Pos.x..", "..Pos.y..", "..Pos.z)
			AI:CreateGoalPipe("practice_pos")
			-- AI:PushGoal("practice_pos","timeout",1,.5)
			AI:PushGoal("practice_pos","setup_idle")
			AI:PushGoal("practice_pos","just_shoot")
			AI:PushGoal("practice_pos","pathfind",1,"")
			AI:PushGoal("practice_pos","trace",1,1)
			AI:PushGoal("practice_pos","setup_stand")
			entity:InsertSubpipe(0,"practice_pos",entity.ShootPosName)
		end
		-- if entity.PropertiesInstance.bHelmetOnStart==1 then
			-- -- if entity.PropertiesInstance.fileHelmetModel=="Objects/characters/mercenaries/accessories/earprotector.cgf" then
			-- -- if entity.PropertiesInstance.soundrange~=1 then
				-- entity:ChangeAIParameter(AIPARAM_SOUNDRANGE,1)
			-- -- end
		-- end
	end,

	PRACTICLE_CHECK_WEAPON_AMMO = function(self,entity)
		local Current_AmmoType  -- Тип патронов.
		local Current_Ammo  -- Их количество в запасе.
		local Current_FireModeType  -- Режим огня.
		if entity.fireparams then
			Current_AmmoType = entity.fireparams.AmmoType
			Current_Ammo = entity.Ammo[Current_AmmoType]
			Current_FireModeType = entity.fireparams.fire_mode_type
		end
		if Current_FireModeType~=FireMode_Melee and Current_FireModeType~="Unlimited" then
			for i,val in MaxAmmo do
				if i==Current_AmmoType then
					-- Hud:AddMessage(entity:GetName()..": Current_AmmoType: "..Current_AmmoType..", Current_Ammo: "..Current_Ammo..", MaxAmmo: "..val)
					if Current_Ammo<=val/2 then
						self:OnLowAmmoExit(entity)
						break
					end
				end
			end
		elseif Current_FireModeType==FireMode_Melee then
			self:OnLowAmmoExit(entity)
		end
	end,

	OnNoTarget = function(self,entity)
		if not entity.NoTargetCount then entity.NoTargetCount = 0  end
		entity.NoTargetCount = entity.NoTargetCount + 1 -- Еденица при первом спавне.
		if entity.NoTargetCount <= 2 then
			AIBehaviour.Job_PracticeFire:OnSpawn(entity)
		end
		if entity.NoTargetCount==3 then
			if entity.ShootPosName and Game:GetTagPoint(entity.ShootPosName) then
				entity:SelectPipe(0,"cover_intresting2")
			else
				AIBehaviour.Job_PracticeFire:OnSpawn(entity)
			end
		end
		if entity.NoTargetCount >= 4 then
			entity:RunToAlarm()
		end
	end,

	OnActivate = function(self,entity)
		self:OnSpawn(entity)
	end,

	DO_SOMETHING_SPECIAL = function(self,entity,sender) -- Если поставить рядом с пулемётом(якорь),то стрелять будет из него. Доделать!
		local mounted = AI:FindObjectOfType(entity.id,5,AIOBJECT_MOUNTEDWEAPON)
		if (mounted) then
			entity.gun = System:GetEntityByName(mounted)
			if entity.gun.user then
				do return end
			end
			if entity.gun then
				entity.gun:SetGunner(entity)
			end
		end
		-- entity:RunToMountedWeapon()
	end,

	OnLowAmmoExit = function(self,entity,Straightway) -- Если половина боезапаса истрачена, то прекратить практику. Странно, весь инсёрт происходит снизу-вверх. В первый раз такое вижу.
		entity:TriggerEvent(AIEVENT_CLEAR)
		-- AI:Signal(0,1,"OnJobExit",entity.id)
		-- AIBehaviour.Job_Observe:OnSpawn(entity)
		local dh=entity:GetName().."_OBSERVE"
		local TagPoint = Game:GetTagPoint(dh)
 		if not TagPoint then
			dh = AI:FindObjectOfType(entity.id,20,AIAnchor.AIANCHOR_OBSERVE)
		end
		entity:SelectPipe(0,"observe_direction",dh)
		if TagPoint or dh then
			entity:InsertSubpipe(0,"patrol_approach_to",dh)
		end
		local weapon = entity.cnt.weapon
		if weapon and weapon.name~="Falcon" and entity.fireparams.fire_mode_type~=FireMode_Melee and entity.PropertiesInstance.bGunReady==0 and entity.AI_GunOut then
			if entity.fireparams and entity.fireparams.fire_mode_type and entity.fireparams.fire_mode_type==FireMode_Melee then return end
			entity:InsertSubpipe(0,"HOLSTER_GUN")
		end
		entity:InsertSubpipe(0,"setup_idle")	-- get in correct stance
		AI:CreateGoalPipe("time_out")
		if not Straightway then
			AI:PushGoal("time_out","timeout",1,1,2)
		else
			AI:PushGoal("time_out","not_shoot")
		end
		AI:PushGoal("time_out","signal",1,1,"OnJobExit",0)
		entity:InsertSubpipe(0,"time_out")
	end,

	OnJobExit = function(self,entity,sender)
		if entity.gun and entity.gun.AbortUse then
			entity.gun:AbortUse(entity)
		end
		entity.PracticleFireMan = nil
		-- AI:Signal(0,1,"RETURN_TO_NORMAL",entity.id)
		-- entity:ChangeAIParameter(AIPARAM_SOUNDRANGE,entity.PropertiesInstance.soundrange)
	end,

	OnSomethingSeen = function(self,entity)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:SelectPipe(0,"just_shoot")
		entity:InsertSubpipe(0,"setup_stealth")
	end,

	OnInterestingSoundHeard = function(self,entity,fDistance) -- Чего-то не дропает на интересный звук, а подходит к цели. (
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		entity:SelectPipe(0,"not_shoot")
		entity:InsertSubpipe(0,"setup_stealth")
	end,

	OnThreateningSoundHeard = function(self,entity,fDistance)
		if fDistance > 15 and fDistance < 60 then -- Добавить счётчик.
			entity:InsertSubpipe(0,"not_shoot")
			entity:InsertSubpipe(0,"sound_delay")
			entity:InsertSubpipe(0,"setup_stealth")
		elseif fDistance <= 15 then
			entity:SelectPipe(0,"just_shoot") -- Сделать чтобы прятался.
			entity:InsertSubpipe(0,"setup_stand")
		end
	end,

	OnReload = function(self,entity,sender)
	end,

	ALARM_ON = function(self,entity,sender)
		entity:InsertSubpipe(0,"not_shoot")
		entity:InsertSubpipe(0,"sound_delay")
		AIBehaviour.DEFAULT:ALARM_ON(entity,sender)
		-- Hud:AddMessage(entity:GetName()..": Job_PracticeFire/ALARM_ON")
		-- System:Log(entity:GetName()..": Job_PracticeFire/ALARM_ON")
	end,

	ALERT_SIGNAL = function(self,entity,sender) -- Нужно ли?
		-- entity:InsertSubpipe(0,"not_shoot")
		-- entity:InsertSubpipe(0,"setup_stealth")
		-- entity:InsertSubpipe(0,"sound_delay")
		-- AIBehaviour.DEFAULT:ALERT_SIGNAL(entity,sender)
		-- Hud:AddMessage(entity:GetName()..": Job_PracticeFire/ALERT_SIGNAL")
		-- System:Log(entity:GetName()..": Job_PracticeFire/ALERT_SIGNAL")
	end,

	NORMAL_THREAT_SOUND = function(self,entity,sender)
		-- entity:InsertSubpipe(0,"not_shoot")
		-- entity:InsertSubpipe(0,"sound_delay")
		-- AIBehaviour.DEFAULT:NORMAL_THREAT_SOUND(entity,sender)
	end,

	LOOK_AT_BEACON = function(self,entity,sender)
		-- entity:InsertSubpipe(0,"just_shoot")
		-- AIBehaviour.DEFAULT:LOOK_AT_BEACON(entity,sender)
	end,

	STOP_LOOK_AT_BEACON = function(self,entity,sender)
		AIBehaviour.Job_PracticeFire:OnSpawn(entity)
	end,

	GoForReinforcement = function(self,entity,sender)
	end,

	RunToAlarmSignal = function(self,entity,sender)
	end,

	OnSomethingDiedNearest = function(self,entity,sender)
	end,

	OnCloseContact = function(self,entity,sender)
	end,

	INCOMING_FIRE = function(self,entity,sender) -- Добавить проверку на расстояние.
	end,

	HEADS_UP_GUYS = function(self,entity,sender) -- Добавить проверку на расстояние.
	end,
}