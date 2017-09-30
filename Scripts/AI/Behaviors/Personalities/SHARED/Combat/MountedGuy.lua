--------------------------------------------------
--    Created By: Petar
--   Description: 	This gets called when the guy knows something has happened (he is getting shot at,does not know by whom),or he is hit. Basically
--  			he doesnt know what to do,so he just kinda sticks to cover and tries to find out who is shooting him
--------------------------
--

AIBehaviour.MountedGuy = {
	Name = "MountedGuy",
	NOPREVIOUS = 1, -- Чтобы пропускало это состояние мимо если будет необходимость вернуться к предыдущему состоянию.

	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSelected = function(self,entity)
	end,
	---------------------------------------------
	OnActivate = function(self,entity)
		-- called when enemy receives an activate event (from a trigger,for example)
	end,
	--------------------------------------------
	OnNoTarget = function(self,entity)
		AIBehaviour.DEFAULT:OnNoTarget(entity)
		if not entity.AI_AtWeapon then do return end end
		-- Hud:AddMessage(entity:GetName()..": MountedGuy/OnNoTarget")
		-- System:Log(entity:GetName()..": MountedGuy/OnNoTarget")
		entity:ChangeAIParameter(AIPARAM_FOV,entity.Properties.horizontal_fov)
		entity.CurrentHorizontalFov=entity.Properties.horizontal_fov
		-- entity:SelectPipe(0,"not_shoot")
		entity:SelectPipe(0,"turn")
		entity.ForceResponsiveness = 1
		entity:ChangeAIParameter(AIPARAM_RESPONSIVENESS,1.4) -- Не меньше 1.2, чтобы не глючило, и ёщё более не меньше 1.4, чтобы выглядело естественно.
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact) -- Слишком резко на меня повернулся когда увидел.
		if not fDistance then fDistance = entity:GetDistanceToTarget() end
		if not fDistance then fDistance = 0 NotContact=1 end
		if not entity.AI_AtWeapon then
			entity:ChangeAIParameter(AIPARAM_FOV,0) -- Ненадолго поможет...
			entity.CurrentHorizontalFov=0
			if fDistance<=30 then
				-- entity:InsertSubpipe(0,"just_shoot")
			-- else
				-- entity:InsertSubpipe(0,"not_shoot")
			end
			-- if (not entity.theVehicle and fDistance < 20) or (entity.theVehicle and fDistance < 12) then  -- Чтобы вернуться в нормальное состояние, когда заметит игрока слижком близко, пока бежит до орудия.
			if fDistance <= 10 then
				AI:Signal(0,1,"RETURN_TO_NORMAL",entity.id)
			end
			do return end
		end
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		-- entity.ForceResponsiveness = nil -- Та ну его нафиг, слишко много глюков.
		entity.ForceResponsiveness = 1
		entity:ChangeAIParameter(AIPARAM_RESPONSIVENESS,10) -- Десяти вполне хватает.
		if (fDistance>7) then
			entity:ChangeAIParameter(AIPARAM_FOV,10)
			entity.CurrentHorizontalFov=10
			entity:SelectPipe(0,"just_shoot")
			if not NotContact and not entity.IShoot then -- Если не стреляет.
				AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY_ON_ATTACK(entity)
				if (entity:GetGroupCount() > 1) then
					if random(1,2)==1 then
						AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN_GROUP",entity.id)
					else
						AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN",entity.id)
					end
				else
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN",entity.id)
				end
			end
		else
			AI:Signal(0,1,"RETURN_TO_NORMAL",entity.id)
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
	---------------------------------------------
	OnSomethingSeen = function(self,entity)
		-- entity:TriggerEvent(AIEVENT_CLEAR) -- CLEAR очищает цель пока бежит до орудия, а мне это не нужно.
	end,

	OnDeadBodySeen = function(self,entity,sender,fDistance)
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		if not fDistance then fDistance = 0 NotContact=1 end
		if not entity.AI_AtWeapon then
			-- entity:InsertSubpipe(0,"not_shoot")
			do return end
		end
		if not NotContact then
			if (entity:GetGroupCount() > 1) then
				if random(1,2)==1 then
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN_GROUP",entity.id)
				else
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN",entity.id)
				end
			else
				AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN",entity.id)
			end
		end
		entity:TriggerEvent(AIEVENT_CLEAR) -- Не убирать. Маяк он не забудет, зато OnNoTarget вызовет. И крутиться ему не надо, хотя...
		entity:ChangeAIParameter(AIPARAM_FOV,entity.Properties.horizontal_fov)
		entity.CurrentHorizontalFov=entity.Properties.horizontal_fov
		-- entity:SelectPipe(0,"not_shoot")
		entity.ForceResponsiveness = 1
		entity:ChangeAIParameter(AIPARAM_RESPONSIVENESS,10)
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity,fDistance)
		if not entity.AI_AtWeapon then do return end end
		entity.ForceResponsiveness = 1
		entity:ChangeAIParameter(AIPARAM_RESPONSIVENESS,10)
		if (fDistance > 7) then
			-- entity:SelectPipe(0,"dumb_shoot")
			entity:ChangeAIParameter(AIPARAM_FOV,entity.Properties.horizontal_fov)
			entity.CurrentHorizontalFov=entity.Properties.horizontal_fov
			entity:SelectPipe(0,"just_shoot")
		else
			AI:Signal(0,1,"RETURN_TO_NORMAL",entity.id)
		end
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity,fDistance)
		if not entity.AI_AtWeapon then do return end end
		entity.ForceResponsiveness = 1
		entity:ChangeAIParameter(AIPARAM_RESPONSIVENESS,10)
		if (fDistance > 7) then
			entity:SelectPipe(0,"just_shoot")
		else
			AI:Signal(0,1,"RETURN_TO_NORMAL",entity.id)
		end
	end,
	---------------------------------------------
	OnReload = function(self,entity)
		-- called when the enemy goes into automatic reload after its clip is empty
	end,
	-- ---------------------------------------------
	-- OnGroupMemberDied = function(self,entity)
		-- -- called when a member of the group dies
	-- end,
	-- ---------------------------------------------
	-- OnGroupMemberDiedNearest = function(self,entity)
		-- -- called when a member of the group dies
	-- end,
	-- ---------------------------------------------
	OnNoHidingPlace = function(self,entity,sender)
		-- called when no hiding place can be found with the specified parameters
	end,
	--------------------------------------------------
	OnNoFormationPoint = function(self,entity,sender)
		-- called when the enemy found no formation point
	end,

	OnCoverRequested = function(self,entity,sender)
		-- called when the enemy is damaged
	end,

	OnKnownDamage = function(self,entity,sender)
		-- -- Hud:AddMessage(entity:GetName()..": MountedGuy/OnKnownDamage")
		-- -- System:Log(entity:GetName()..": MountedGuy/OnKnownDamage")
		-- if not entity.AI_AtWeapon then AI:Signal(0,1,"RETURN_TO_NORMAL",entity.id)
			-- entity:SelectPipe(0,"randomhide_trace")
			-- entity:InsertSubpipe(0,"DropBeaconTarget",sender.id)
			-- do return end
		-- end
		-- if (entity.dmg_percent>.5) then
			-- local mytarget = AI:GetAttentionTargetOf(entity.id)
			-- if (mytarget) then
				-- if (type(mytarget)=="table") then
					-- if (mytarget~=sender) then
						-- -- entity:SelectPipe(0,"retaliate_damage",sender.id)
						-- entity:InsertSubpipe(0,"DropBeaconTarget",sender.id)
						-- -- entity:InsertSubpipe(0,"dumb_shoot")
					-- end
				-- end
			-- end
		-- else
			AI:Signal(0,1,"RETURN_TO_NORMAL",entity.id)
			entity:SelectPipe(0,"randomhide_trace")
			entity:InsertSubpipe(0,"DropBeaconTarget",sender.id) -- Пусть лучше смотрит на врага, чем бросает гранату вслепую.
			entity:InsertSubpipe(0,"take_cover")
		-- end
	end,

	OnReceivingDamage = function(self,entity,sender)
		-- Hud:AddMessage(entity:GetName()..": MountedGuy/OnReceivingDamage")
		-- System:Log(entity:GetName()..": MountedGuy/OnReceivingDamage")
		AI:Signal(0,1,"RETURN_TO_NORMAL",entity.id)
		entity:SelectPipe(0,"randomhide_trace")
		entity:InsertSubpipe(0,"DropBeaconTarget")
		entity:GrenadeAttack(3)
		entity:InsertSubpipe(0,"take_cover")
	end,

	--------------------------------------------------
	OnBulletRain = function(self,entity,sender)
		-- if entity.AI_AtWeapon then
			-- entity:SelectPipe(0,"just_shoot")
		-- end
		entity.ForceResponsiveness = 1
		entity:ChangeAIParameter(AIPARAM_RESPONSIVENESS,10)
		if not entity.OnBulletRainCounter then entity.OnBulletRainCounter = 0  end
		entity.OnBulletRainCounter = entity.OnBulletRainCounter+1
		if entity.dmg_percent<=.5 or entity.OnBulletRainCounter > 10 then
			self:OnReceivingDamage(entity,sender)
		end
	end,

	OnCloseContact = function(self,entity,sender) -- Бывает и такое...
		if entity.Properties.species~=sender.Properties.species then
			AI:Signal(0,1,"RETURN_TO_NORMAL",entity.id)
		end
		AIBehaviour.DEFAULT:OnCloseContact(entity,sender)
	end,

	OnGrenadeSeen = function(self,entity,fDistance)
		if entity.IShoot then return end
		entity.ForceResponsiveness = 1
		entity:ChangeAIParameter(AIPARAM_RESPONSIVENESS,10)
		if not fDistance or fDistance > 15 then do return end end
		-- -- Hud:AddMessage(entity:GetName()..": MountedGuy/OnGrenadeSeen!!!")
		-- if entity.current_mounted_weapon then
			-- entity.current_mounted_weapon:AbortUse()
		-- end
		-- entity:Readibility("GRENADE_SEEN",1)
		-- entity:InsertSubpipe(0,"grenade_run_away2")
		-- AI:Signal(0,1,"RETURN_TO_NORMAL",entity.id)
		-- Hud:AddMessage(entity:GetName()..": MountedGuy/OnGrenadeSeen!!!")
		AI:Signal(0,1,"RETURN_TO_NORMAL",entity.id)
		entity:Readibility("GRENADE_SEEN",1)
		entity:InsertSubpipe(0,"grenade_run_away2")
	end,

	OnGrenadeSeen_Flying = function(self,entity,sender)
		self:OnGrenadeSeen(entity)
	end,

	OnGrenadeSeen_Colliding = function(self,entity,sender)
		self:OnGrenadeSeen(entity)
	end,


	OnDeath = function(self,entity,sender)
		if entity.MountedGunEntity and entity.MountedGunEntity.engaged > 0 then entity.MountedGunEntity.engaged = 0  end
		AIBehaviour.DEFAULT:OnDeath(entity)
	end,

	OnSomethingDiedNearest = function(self,entity,sender)
		entity.ForceResponsiveness = 1
		entity:ChangeAIParameter(AIPARAM_RESPONSIVENESS,10)
		if entity.not_sees_timer_start~=0 then
			entity:SelectPipe(0,"TeamMemberDiedLook2") -- Сделать что-нибудь другое.
			AI:Signal(0,1,"RETURN_TO_NORMAL",entity.id)
		end
	end,

	OnSomethingDiedNearest_x = function(self,entity,sender) -- Проверить уровень тревоги!
	end,

	-- USE_MOUNTED_WEAPON = function(self,entity,sender)
	 	-- Hud:AddMessage(entity:GetName()..": SWITCH_TO_MORTARGUY")
		-- entity:GunOut()
		-- entity.quickly_use_MG = 1
		-- AI:Signal(0,1,"USE_MOUNTED_WEAPON",entity.id)  -- Чтобы сразу сел, если рядом окажется.
		-- entity.quickly_use_MG = nil
		-- entity:CountingPlayers(30) -- Заменить.
		-- if entity.friendscount and entity.friendscount > 4 then -- Друзья прикроют.
			-- entity.TempHF=1  -- Доделать.
			-- entity:ChangeAIParameter(AIPARAM_FOV,30)
			-- entity.CurrentHorizontalFov=30
		-- end
		-- entity:SelectPipe(0,"goto_mounted_weapon",entity.MountedGun)
		-- entity:InsertSubpipe(0,"not_shoot")
		-- entity:InsertSubpipe(0,"setup_stand")
		-- entity:InsertSubpipe(0,"do_it_running")
	-- end,
	-- Сделать чтобы прятал пушку за спину перед посадкой. Надо бы чтобы немного стоял, стрелял при наличии пушки и только потом бежал и садился за пулемёт.
	-- У мерка с щитом в руках щит прятать.
	USE_MOUNTED_WEAPON = function(self,entity,sender) -- Исправить: иногда не садится но считает что уже сидит. Иногда просто не хотят бежать к пушке. Что-то с пайпой не так.
		-- Hud:AddMessage(entity:GetName()..": MountedGuy/USE_MOUNTED_WEAPON")
		if not entity.GetInMGTimeOut then entity.GetInMGTimeOut=_time end
		local radius
		if entity.quickly_use_MG then
			entity.quickly_use_MG = nil
			radius = 5
		else
			radius = 3
		end
		if entity.IsSpecOpsMan then -- Иначе толком не добегают.
			radius = 10
		end
		local engaged = AI:FindObjectOfType(entity:GetPos(),radius,AIOBJECT_MOUNTEDWEAPON) -- Переделать под простое определение расстояния.
		-- local MyPos=entity:GetPos() -- Почему-то позиции копируются. Хз.
		-- local GunPos=entity.MountedGunEntity:GetPos() -- Почему-то позиции копируются.
		-- -- if (GunPos.x<=MyPos.x+radius and GunPos.x>=MyPos.x) and (GunPos.y<=MyPos.y+radius and GunPos.y>=MyPos.y) then
			-- Hud:AddMessage(entity:GetName()..": GunPos.x: "..GunPos.x..", MyPos.x: "..MyPos.x..", GunPos.y: "..GunPos.y..", MyPos.y: "..MyPos.y..", GunPos.z: "..GunPos.z..", MyPos.z: "..MyPos.z)
			-- System:Log(entity:GetName()..": GunPos.x: "..GunPos.x..", MyPos.x: "..MyPos.x..", GunPos.y: "..GunPos.y..", MyPos.y: "..MyPos.y..", GunPos.z: "..GunPos.z..", MyPos.z: "..MyPos.z)
		-- -- end
		if engaged then
			local gun = System:GetEntityByName(engaged)
			-- local gundistance = entity:GetDistanceFromPoint(engaged) -- Это если пушка вдруг окажется пушкой от улетающего вертолёта... Добавить проверку на "стационарность".
			-- if not gun.user and gundistance < 60 then -- Оказывается не пашет пока не будет найден обьект в пределах radius.
			if not gun.user then -- Добавить: Сделать проверку на сущность. MountedGunEntity.engaged
				gun:SetGunner(entity)
				entity.ForceResponsiveness = 1
				-- entity:ChangeAIParameter(AIPARAM_RESPONSIVENESS,10)
				entity:ChangeAIParameter(AIPARAM_RESPONSIVENESS,1.4)
				-- Hud:AddMessage(entity:GetName()..": USE_MOUNTED_WEAPON: "..entity.MountedGun)
				entity:SelectPipe(0,"use_mounted_weapon")
				do return end
			end
			AI:Signal(0,1,"RETURN_TO_NORMAL",entity.id) -- Если на пушке будет пользователь, то вернуться в нормальное состояние.
			do return end
		end
		if _time>entity.GetInMGTimeOut+40 then AI:Signal(0,1,"RETURN_TO_NORMAL",entity.id) return end -- Обычно посадка на стационарные орудия занимает меньше и половины минуты.
		-- Hud:AddMessage(entity:GetName()..": GOTO_MOUNTED_WEAPON: "..entity.MountedGun)
		-- entity:SelectPipe(0,"goto_mounted_weapon",entity.MountedGun)
		-- entity:InsertSubpipe(0,"just_shoot") -- Может быть баг из-за этих трёх пайп?
		-- entity:InsertSubpipe(0,"setup_stand")
		-- entity:InsertSubpipe(0,"do_it_running")
	end,

	RETURN_TO_NORMAL = function(self,entity,sender) -- Возвращение нормальных параметров после использования стационарного орудия. Так же вызызывается через CryGame.dll при превышении лимита углов.
		AI:MakePuppetIgnorant(entity.id,0) -- Проверить на машинах. А так, поставил если вдруг сейчас включено игнорирование, которое при посадке в машину.
		-- entity:ChangeAIParameter(AIPARAM_ACCURACY,entity.PropertiesInstance.accuracy)
		-- entity:ChangeAIParameter(AIPARAM_AGGRESION,entity.PropertiesInstance.aggresion)
		entity:ChangeAIParameter(AIPARAM_FOV,entity.Properties.horizontal_fov)
		entity.CurrentHorizontalFov=entity.Properties.horizontal_fov
		-- entity:ChangeAIParameter(AIPARAM_RESPONSIVENESS,entity.Properties.responsiveness)
		if entity.MountedGunEntity and entity.MountedGunEntity.engaged > 0 then
			entity.MountedGunEntity.engaged = 0 entity.MountedGunEntity = nil entity.MountedGun = nil
		end
		entity.RunToTrigger = nil
		entity.OnBulletRainCounter = nil
		entity.ForceResponsiveness = nil
		entity.GetInMGTimeOut = nil
		entity.AI_AtWeapon = nil
		if entity.theVehicle then
			-- Hud:AddMessage(entity:GetName()..": RETURN_TO_NORMAL")
			-- AI:Signal(0,1,"entered_vehicle",entity.id) -- Вернуть, когда сделается InitLeaving.
			-- VC.ReleaseUser(entity.theVehicle,entity.theVehicle.gunnerT) -- Пока сделал такой быстрый выход из-за того, что враги очень глючно выходят при InitLeaving.
			-- entity:TriggerEvent(AIEVENT_DISABLE) -- Выключение обязательно, бот включится после выхода из машины.
			VC.InitLeaving(entity.theVehicle,entity.theVehicle.gunnerT) -- Выход с анимацией.
			-- entity.VehicleMountedGunUser = nil
			-- entity.NotUseTimerStart = _time
			do return end
		end
		AI:Signal(0,1,"REAL_RETURN_TO_NORMAL",entity.id) -- Сделать проверку на патроны.
		-- Hud:AddMessage(entity:GetName()..": RETURN_TO_NORMAL: "..entity.MountedGun)
		-- if entity.AI_AtWeapon then
			if entity.current_mounted_weapon then
				entity.current_mounted_weapon:AbortUse()
			end
		-- end
		entity:InsertSubpipe(0,"setup_stand")
		if entity.MERC=="sniper" then
			if entity.WasInCombat then
				if entity.sees~=1 then
					entity.EventToCall = "OnEnemyMemory"
				else
					entity.EventToCall = "OnPlayerSeen"
				end
			else
				-- entity.EventToCall = "OnSpawn"
				entity.EventToCall = "OnEnemyMemory"
			end
		elseif entity.IsSpecOpsMan or entity.IsAiPlayer then
			entity:SelectPipe(0,"check_beacon")
			if entity.WasInCombat then
				if entity.sees==0 then
					AI:Signal(0,1,"FIND_A_TARGET",entity.id)
				elseif entity.sees==1 then
					entity.EventToCall = "OnPlayerSeen"
				else
					entity.EventToCall = "OnEnemyMemory"
				end
			else
				entity.EventToCall = "OnSpawn"  -- FIND_A_TARGET, либо GO_FOLLOW у IsAiPlayer.
			end
		else
			entity:SelectPipe(0,"check_beacon")
			if not entity:RunToAlarm() then
				if entity.sees==0 then
					AI:Signal(0,1,"FIND_A_TARGET",entity.id)
				elseif entity.sees==1 then
					entity.EventToCall = "OnPlayerSeen"
				else
					entity.EventToCall = "OnEnemyMemory"
				end
			end
		end
	end,
	
	GO_FOLLOW = function(self,entity,sender)
		if entity.IsAiPlayer then
			AI:Signal(0,1,"RETURN_TO_NORMAL",entity.id)
		end
	end,
	--------------------------------------------------
	-- GROUP SIGNALS
	--------------------------------------------------

	ALARM_ON = function(self,entity,sender) --доделать
	end,

	ALERT_SIGNAL = function(self,entity,sender)
	end,

	NORMAL_THREAT_SOUND = function(self,entity,sender)
	end,

	GoForReinforcement = function(self,entity,sender)
	end,

	RunToAlarmSignal = function(self,entity,sender)
	end,

	LOOK_AT_BEACON = function(self,entity,sender)
		if entity.sees~=1 then
			entity:InsertSubpipe(0,"DropBeaconAt",sender.SenderId)
		end
	end,

	STOP_LOOK_AT_BEACON = function(self,entity,sender)
	end,

	HEADS_UP_GUYS = function(self,entity,sender)
		if entity.ForceSenderId then sender=System:GetEntity(entity.ForceSenderId) entity.ForceSenderId=nil end
		AIBehaviour.DEFAULT:AllWakeUp(entity)
		if entity.Properties.species==sender.Properties.species and entity~=sender and not entity.heads_up_guys and entity.sees~=1 then
			if not entity.rs_x then	entity.rs_x = 1	end
			entity:InsertSubpipe(0,"acquire_beacon2",sender.id) -- Сначала смотрим на отправителя.
			if sender and sender.SenderId then
				entity:InsertSubpipe(0,"DropBeaconAt",sender.SenderId)
			end
			entity.heads_up_guys = 1
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,10)
			AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY(entity)
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)
		end
	end,
	---------------------------------------------
	INCOMING_FIRE = function(self,entity,sender)
		-- dont handle this signal
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

	do_exit_vehicle = function(self,entity,sender)
		-- System:Log(entity:GetName()..": MountedGuy/do_exit_vehicle")
		AI:Signal(0,1,"exited_vehicle",entity.id) -- Должен быть именно сигнал, а не ссылка.
	end,

	do_exit_vehicle2 = function(self,entity,sender)
		-- System:Log(entity:GetName()..": MountedGuy/do_exit_vehicle2")
		AI:Signal(0,1,"exited_vehicle",entity.id)
	end,

	exited_vehicle = function(self,entity,sender)
		AI:Signal(0,1,"really_exited_vehicle",entity.id)
		-- System:Log(entity:GetName()..": MountedGuy/exited_vehicle")
		entity.TempTheVehicle = nil
		AIBehaviour.InVehicle:exited_vehicle(entity)
		-- System:Log(entity:GetName()..": entity.EventToCall: "..entity.EventToCall)
		if not entity.EventToCall or entity.EventToCall=="OnSpawn" and not entity.IsSpecOpsMan and not entity.IsAiPlayer then
			entity.EventToCall = "OnPlayerSeen" -- "По памяти" не ставить...
			AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY_ON_ATTACK(entity)
		end
	end,

	exited_vehicle_investigate = function(self,entity,sender)
		-- System:Log(entity:GetName()..": MountedGuy/exited_vehicle_investigate")
		AI:Signal(0,1,"exited_vehicle",entity.id) -- Специально.
	end,

	disable_me = function(self,entity,sender)
		AIBehaviour.InVehicle:disable_me(entity)
	end,

	do_exit_hely = function(self,entity,sender)
		AIBehaviour.InVehicle:do_exit_hely(entity)
	end,
}