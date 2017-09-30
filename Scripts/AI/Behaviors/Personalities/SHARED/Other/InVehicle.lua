
--    Created By: Petar
--   Description: 	This gets called when the guy knows something has happened (he is getting shot at,does not know by whom),or he is hit. Basically
--  			he doesnt know what to do,so he just kinda sticks to cover and tries to find out who is shooting him

AIBehaviour.InVehicle = {
	Name = "InVehicle",
	NOPREVIOUS = 1,
	ManInVehicle = 1,
	-- SYSTEM EVENTS

	OnSelected = function(self,entity)
	end,

	OnSpawn = function(self,entity)

	end,

	OnActivate = function(self,entity)
		-- called when enemy receives an activate event (from a trigger,for example)
	end,

	OnNoTarget = function(self,entity)
		AIBehaviour.DEFAULT:OnNoTarget(entity)
		AI:Signal(SIGNALFILTER_GROUPONLY,1,"GunnerLostTarget",entity.id)
		if entity.theVehicle and entity.theVehicle.gunnerT and entity.theVehicle.gunnerT.entity	and	entity.theVehicle.gunnerT.entity==entity
		and entity.theVehicle.gunnerT.state==2 then -- Это всё так, временно.
			-- Hud:AddMessage(entity:GetName()..": turn")
			entity:ChangeAIParameter(AIPARAM_FOV,entity.Properties.horizontal_fov)
			entity.CurrentHorizontalFov=entity.Properties.horizontal_fov
			entity:SelectPipe(0,"turn")
			entity.ForceResponsiveness = 1
			entity:ChangeAIParameter(AIPARAM_RESPONSIVENESS,1.4)
		end
		-- if entity.IsAiPlayer then
			-- if entity.theVehicle and entity.theVehicle.driverT and entity.theVehicle.driverT.entity	and	entity.theVehicle.driverT.entity==entity
			-- and entity.theVehicle.driverT.state==2 then
				-- Hud:AddMessage(entity.theVehicle:GetName()..": entity.theVehicle")
				-- System:Log(entity.theVehicle:GetName()..": entity.theVehicle")
				-- local pipeName = entity.theVehicle:GetName().."path"
				-- AI:CreateGoalPipe(pipeName)
				-- AI:PushGoal(pipeName,"ignoreall",0,1)  -- Меня не видит.
				-- AI:PushGoal(pipeName,"setup_crouch") -- Обновлять путь во время движения.
				-- AI:PushGoal(pipeName,"strafe",0,0) 	-- Прекратить торможение.
				-- AI:PushGoal(pipeName,"acqtarget",0,"")
				-- AI:PushGoal(pipeName,"approach",1,20)

				-- -- AI:PushGoal(pipeName,"form",1,"beacon")
				-- -- AI:PushGoal(pipeName,"pathfind",1,"")
				-- -- AI:PushGoal(pipeName,"trace",1,1,1)

				-- local RadarObjectivePoint
				-- if Hud and Hud.RadarObjectiveName then
					-- RadarObjectivePoint = Game:GetTagPoint(Hud.RadarObjectiveName)
				-- end
				-- if RadarObjectivePoint then
					-- Hud:AddMessage(entity.theVehicle:GetName()..": RadarObjectivePoint: "..Hud.RadarObjectiveName)
					-- System:Log(entity.theVehicle:GetName()..": RadarObjectivePoint: "..Hud.RadarObjectiveName)
					-- entity.theVehicle:SelectPipe(0,pipeName,Hud.RadarObjectiveName)
				-- end
			-- end
		-- end
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if not fDistance then fDistance = entity:GetDistanceToTarget() end
		if not fDistance then fDistance = 0 NotContact=1 end
		-- if entity.theVehicle and entity.theVehicle.Properties.bIsKiller==1 then
		if entity.HelicopterIs and entity.theVehicle and entity.theVehicle.gunnerT and entity.theVehicle.gunnerT.entity
		and	entity.theVehicle.gunnerT.entity==entity and not NotContact then
			-- Hud:AddMessage(entity:GetName()..": OnPlayerSeen")
			AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"VEHICLE_SIGHTING_PLAYER",entity.id)
		end
		printf("InVehicle   ---  on player seen -----------------------------------")
		AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY_ON_ATTACK(entity)
		if entity.theVehicle and entity.theVehicle.gunnerT and entity.theVehicle.gunnerT.entity	and	entity.theVehicle.gunnerT.entity==entity
		and entity.theVehicle.gunnerT.state==2 then
			entity:SelectPipe(0,"h_gunner_fire")
			entity:ChangeAIParameter(AIPARAM_FOV,10)
			entity.CurrentHorizontalFov=10
			entity.ForceResponsiveness = 1
			entity:ChangeAIParameter(AIPARAM_RESPONSIVENESS,10)
		end
	end,

	OnEnemySeen = function(self,entity)
		-- called when the enemy sees a foe which is not a living player
	end,

	OnFriendSeen = function(self,entity)
		-- called when the enemy sees a friendly target
	end,

	OnDeadBodySeen = function(self,entity,sender,fDistance)
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if not fDistance then fDistance = 0 NotContact=1 end
		if entity.HelicopterIs and entity.theVehicle and entity.theVehicle.gunnerT and entity.theVehicle.gunnerT.entity
		and	entity.theVehicle.gunnerT.entity==entity and not NotContact then
			AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN",entity.id)
		end
		if entity.theVehicle and entity.theVehicle.gunnerT and entity.theVehicle.gunnerT.entity	and	entity.theVehicle.gunnerT.entity==entity
		and entity.theVehicle.gunnerT.state==2 then
			entity:SelectPipe(0,"h_gunner_fire")
			entity:ChangeAIParameter(AIPARAM_FOV,entity.Properties.horizontal_fov)
			entity.CurrentHorizontalFov=entity.Properties.horizontal_fov
			entity.ForceResponsiveness = 1
			entity:ChangeAIParameter(AIPARAM_RESPONSIVENESS,10)
		end
	end,

	OnInterestingSoundHeard = function(self,entity)
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if entity.theVehicle and entity.theVehicle.gunnerT and entity.theVehicle.gunnerT.entity	and	entity.theVehicle.gunnerT.entity==entity
		and entity.theVehicle.gunnerT.state==2 then
			entity:SelectPipe(0,"h_gunner_fire")
			entity:ChangeAIParameter(AIPARAM_FOV,entity.Properties.horizontal_fov)
			entity.CurrentHorizontalFov=entity.Properties.horizontal_fov
			entity.ForceResponsiveness = 1
			entity:ChangeAIParameter(AIPARAM_RESPONSIVENESS,10)
		end
	end,

	OnThreateningSoundHeard = function(self,entity)
		-- called when the enemy hears a scary sound
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if entity.theVehicle and entity.theVehicle.gunnerT and entity.theVehicle.gunnerT.entity	and	entity.theVehicle.gunnerT.entity==entity
		and entity.theVehicle.gunnerT.state==2 then
			entity:SelectPipe(0,"h_gunner_fire")
			entity.ForceResponsiveness = 1
			entity:ChangeAIParameter(AIPARAM_RESPONSIVENESS,10)
		end
	end,

	OnReload = function(self,entity)
		-- called when the enemy goes into automatic reload after its clip is empty
	end,

	OnGroupMemberDied = function(self,entity)
		-- called when a member of the group dies
	end,

	OnGroupMemberDiedNearest = function(self,entity,sender)
	end,

	OnNoHidingPlace = function(self,entity,sender)
		-- called when no hiding place can be found with the specified parameters
	end,

	OnNoFormationPoint = function(self,entity,sender)
		-- called when the enemy found no formation point
	end,

	OnReceivingDamage = function(self,entity,sender)
		-- called when the enemy is damaged
	end,

	OnCoverRequested = function(self,entity,sender)
		-- called when the enemy is damaged
	end,

	OnBulletRain = function(self,entity,sender) -- Если стрелять по уже обломкам от машины, то выдаёт ошибку, что этой функции нет.
		if entity.theVehicle and entity.theVehicle.gunnerT and entity.theVehicle.gunnerT.entity	and	entity.theVehicle.gunnerT.entity==entity
		and entity.theVehicle.gunnerT.state==2 then
			entity:SelectPipe(0,"h_gunner_fire")
			entity.ForceResponsiveness = 1
			entity:ChangeAIParameter(AIPARAM_RESPONSIVENESS,10)
		end
	end,

	OnDeath = function(self,entity)
		AIBehaviour.DEFAULT:OnDeath(entity)
		-- if driver killed - make all the passengers unignorant,get out/stop entering
		if (entity.theVehicle)	then
			local tbl = VC.FindUserTable(entity.theVehicle,entity)
			if (tbl and tbl.type==PVS_DRIVER) then
				AI:Signal(SIGNALFILTER_GROUPONLY,-1,"MAKE_ME_UNIGNORANT",entity.id)
			end
		end
	end,

	OnGrenadeSeen = function(self,entity,sender)
		if entity.theVehicle and entity.theVehicle.gunnerT and entity.theVehicle.gunnerT.entity	and	entity.theVehicle.gunnerT.entity==entity
		and entity.theVehicle.gunnerT.state==2 then
			entity:SelectPipe(0,"h_gunner_fire")
			entity.ForceResponsiveness = 1
			entity:ChangeAIParameter(AIPARAM_RESPONSIVENESS,10)
		end
	end,

	OnGrenadeSeen_Flying = function(self,entity,sender)
		self:OnGrenadeSeen(entity)
	end,

	OnGrenadeSeen_Colliding = function(self,entity,sender)
		self:OnGrenadeSeen(entity)
	end,

	do_exit_vehicle = function(self,entity,sender)
		-- System:Log(entity:GetName()..": InVehicle/do_exit_vehicle")
		if entity.InBoat then
			entity:SelectPipe(0,"b_user_getout",entity:GetName().."_land")
			if entity.WasInCombat and entity.sees==0 then
				entity:InsertSubpipe(0,"do_it_running")
			else
				entity:InsertSubpipe(0,"do_it_walking")
			end
		else
			self:exited_vehicle2(entity)
		end
	end,

	exited_vehicle2 = function(self,entity,sender)
		-- System:Log(entity:GetName()..": InVehicle/exited_vehicle2") -- Добавить entity.TempTheVehicle и вертолётам тоже. и проверить наличие c_driver после вертов.
		if (entity.TempTheVehicle and entity.TempTheVehicle.Properties and entity.TempTheVehicle.Properties.bSetInvestigate==1) or entity.PropertiesInstance.aibehavior_behaviour=="Job_Investigate" then
			AI:Signal(0,-1,"exited_vehicle_investigate",entity.id)
		else
			AI:Signal(0,-1,"exited_vehicle",entity.id)
		end
		entity.TempTheVehicle = nil
	end,

	exited_vehicle = function(self,entity,sender) -- Проверить работу у всех кто был в машине, если поиск, то сделать как и в exited_vehicle_investigate
		AI:Signal(0,1,"really_exited_vehicle",entity.id)
		-- System:Log(entity:GetName()..": InVehicle/exited_vehicle")
		if entity.WasInCombat or entity.SomethingHurted or entity.SomethingKilled or entity.not_sees_timer_start~=0 or entity.sees~=0 then
			entity:GunOut()
			if entity.SomethingKilled then
				AI:Signal(SIGNALID_READIBILITY,1,"AI_AGGRESSIVE_MACHO",entity.id)
			elseif entity.SomethingHurted then
				AI:Signal(SIGNALID_READIBILITY,1,"AI_AGGRESSIVE_FEAR",entity.id)
			end
			entity:SelectPipe(0,"check_beacon")
			if not entity:RunToAlarm() then
				if entity.sees==0 then
					AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY(entity)
					AI:Signal(0,1,"FIND_A_TARGET",entity.id)
					-- Hud:AddMessage(entity:GetName()..": FIND_A_TARGET")
				-- elseif entity.sees==1 then
				else
					AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY_ON_ATTACK(entity)
					entity.EventToCall = "OnPlayerSeen"
					-- Hud:AddMessage(entity:GetName()..": OnPlayerSeen")
				-- else
					-- AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY(entity)
					-- entity.EventToCall = "OnEnemyMemory" -- По памяти лучше не делать, ибо если это самое первое состояние, то сигнал не сработает.
					-- -- Hud:AddMessage(entity:GetName()..": OnEnemyMemory")
				end
			end
		else
			entity.EventToCall = "OnSpawn"
			-- System:Log(entity:GetName()..": InVehicle/OnSpawn")
		end
	end,

	exited_vehicle_investigate = function(self,entity,sender)
		AI:Signal(0,1,"really_exited_vehicle",entity.id)
		entity:GunOut()
		-- Hud:AddMessage(entity:GetName()..": exited_vehicle_investigate")
		-- System:Log(entity:GetName()..": exited_vehicle_investigate")
		-- entity:TriggerEvent(AIEVENT_CLEAR)
		if entity.sees==0 and not entity.SomethingKilled and not entity.SomethingHurted and entity.not_sees_timer_start==0 then
			entity.EventToCall = "OnSpawn"
			-- Hud:AddMessage(entity:GetName()..": OnSpawn")
			local Result = entity:NewCountingPlayers(30,0,0,1)
			if Result[1]>1 then
				Result = entity:NewCountingPlayers(200,0,0,1)
				if Result[5]>0 and Result[5]>Result[6] then
					AI:Signal(SIGNALID_READIBILITY,1,"SEARCHING_MUTANTS",entity.id)
					System:Log(entity:GetName()..": InVehicle/exited_vehicle_investigate/SEARCHING_MUTANTS")
				else
					AI:Signal(SIGNALID_READIBILITY,1,"SEARCHING_PLAYER",entity.id)
					System:Log(entity:GetName()..": InVehicle/exited_vehicle_investigate/SEARCHING_PLAYER")
				end
			end
		else
			if entity.SomethingKilled then
				AI:Signal(SIGNALID_READIBILITY,1,"AI_AGGRESSIVE_MACHO",entity.id)
			elseif entity.SomethingHurted then
				AI:Signal(SIGNALID_READIBILITY,1,"AI_AGGRESSIVE_FEAR",entity.id)
			end
			-- if entity.sees==1 then
				entity.EventToCall = "OnPlayerSeen" -- Не сработало. (
				AI:Signal(0,1,"AFTER_THROW_GRENADE",entity.id) -- Потому добавил это.
				-- Hud:AddMessage(entity:GetName()..": OnPlayerSeen")
			-- else
				-- entity.EventToCall = "OnEnemyMemory"
				-- Hud:AddMessage(entity:GetName()..": OnEnemyMemory")
			-- end
			-- AI:Signal(SIGNALID_READIBILITY,1,"AI_AGGRESSIVE_MACHO",entity.id)
		end
	end,

	do_exit_hely = function(self,entity,sender)

--		entity:TriggerEvent(AIEVENT_ENABLE)
--		entity:SelectPipe(0,"reevaluate")
--System:Log("puppet -------------------------------- exited_vehicle ")
--		entity:SelectPipe(0,"standingthere")

		if (entity.theVehicle and entity.theVehicle.Properties.pointReinforce) then
			entity:SelectPipe(0,"h_user_getout",entity.theVehicle.Properties.pointReinforce)
--System:Log("\001 do_exit_hely  --------------------------------   "..entity.theVehicle.Properties.pointReinforce)
		else
			entity:SelectPipe(0,"h_user_getout")
		end

--		Previous()
	end,

	-- SHARED_ENTER_ME_VEHICLE = function(self,entity,sender)
	-- -- in vehicle already - don't do anything
	-- end,

	disable_me = function(self,entity,sender)
		entity:TriggerEvent(AIEVENT_DISABLE)
		entity.EntityInVehicleDisabled=1
	end,

	-- no need to run away from cars
	OnVehicleDanger = function(self,entity,sender)
	end,

	OnCloseContact = function(self,entity,sender)
	end,

	LOOK_AT_BEACON = function(self,entity,sender)
	end,

	STOP_LOOK_AT_BEACON = function(self,entity,sender)
	end,

	INCOMING_FIRE = function(self,entity,sender)
	end,

	GoForReinforcement = function(self,entity,sender)
	end,

	HEADS_UP_GUYS = function(self,entity,sender)
		if entity.ForceSenderId then sender=System:GetEntity(entity.ForceSenderId) entity.ForceSenderId=nil end
		-- Hud:AddMessage(entity:GetName()..": HEADS_UP_GUYS")
		-- AIBehaviour.MountedGuy:HEADS_UP_GUYS(entity,sender)
		AIBehaviour.DEFAULT:AllWakeUp(entity)
		if entity.Properties.species==sender.Properties.species and entity~=sender and not entity.heads_up_guys and entity.sees~=1 then
			-- Hud:AddMessage(entity:GetName()..": HEADS_UP_GUYS")
			if not entity.rs_x then	entity.rs_x = 1	end
			if sender and sender.SenderId then
				entity:InsertSubpipe(0,"acquire_beacon2",sender.SenderId)
				-- entity:InsertSubpipe(0,"DropBeaconAt",sender.SenderId)
			end
			entity.heads_up_guys = 1
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,10)
			AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY(entity)
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)
		end
	end,

	RunToAlarmSignal = function(self,entity,sender)
	end,

	OnSomethingDiedNearest = function(self,entity,sender)
		if entity.theVehicle and entity.theVehicle.gunnerT and entity.theVehicle.gunnerT.entity	and	entity.theVehicle.gunnerT.entity==entity
		and entity.theVehicle.gunnerT.state==2 then
			entity:SelectPipe(0,"h_gunner_fire")
			entity.ForceResponsiveness = 1
			entity:ChangeAIParameter(AIPARAM_RESPONSIVENESS,10)
		end
	end,

	OnSomethingDiedNearest_x = function(self,entity,sender)
	end,

	SWITCH_TO_MORTARGUY = function(self,entity,sender)
		entity:SelectPipe(0,"just_shoot")
		entity:InsertSubpipe(0,"AcqBeacon")
	end,

	SEARCH_AMMUNITION = function(self,entity,sender)
	end,

	-- RETURN_TO_NORMAL = function(self,entity,sender)
		-- if entity.IsAiPlayer then
			-- -- if entity.theVehicle and entity.theVehicle.gunnerT and entity.theVehicle.gunnerT.entity	and	entity.theVehicle.gunnerT.entity==entity
			-- -- and entity.theVehicle.gunnerT.state==2 then
				-- AIBehaviour.MountedGuy:RETURN_TO_NORMAL(entity)
			-- -- end
		-- end
	-- end,

	-- GO_FOLLOW = function(self,entity,sender)
		-- AIBehaviour.MountedGuy:RETURN_TO_NORMAL(entity)
	-- end,

	ALARM_ON = function(self,entity,sender)
	end,

	ALERT_SIGNAL = function(self,entity,sender)
	end,

	NORMAL_THREAT_SOUND = function(self,entity,sender)
	end,

	SPECIAL_GODUMB = function(self,entity,sender)
	end,

	SPECIAL_STOPALL = function(self,entity,sender)
	end,

	SPECIAL_LEAD = function(self,entity,sender)
	end,

	SPECIAL_HOLD = function(self,entity,sender)
	end,

	CANNOT_RESUME_SPECIAL_BEHAVIOUR = function(self,entity,sender)
	end,

	RESUME_SPECIAL_BEHAVIOUR = function(self,entity,sender)
	end,

	SHARED_ENTER_ME_VEHICLE = function(self,entity,sender,MountedGunUser) -- Копия в InVehicle.lua.
		-- Hud:AddMessage(entity:GetName()..": Vehicle 1: "..sender:GetName())
		-- System:Log(entity:GetName()..": Vehicle 1: "..sender:GetName())
		if not entity.RunToTrigger and not entity.ANIMAL then -- entity.RunToTrigger = 1 без оптимизации не ставить, иначе второй раз садиться не будут. Ещё, необходимо подстроить под союзников.
			if not entity.ai then return nil end
			local vehicle = sender
			-- Hud:AddMessage(entity:GetName()..": Vehicle 2: "..vehicle:GetName())
			-- System:Log(entity:GetName()..": Vehicle 2: "..vehicle:GetName())
			if vehicle then
				-- Hud:AddMessage(entity:GetName()..": Vehicle 3: "..vehicle:GetName())
				-- System:Log(entity:GetName()..": Vehicle 3: "..vehicle:GetName())
				-- System:Log(entity:GetName()..": sender 1: "..vehicle:GetName())
				-- not enter hevicle if there is a human driver inside
				-- if vehicle.driverT and vehicle.driverT.entity and not vehicle.driverT.entity.ai then return end
				if vehicle.driverT and vehicle.driverT.entity and vehicle.driverT.entity.Properties and vehicle.driverT.entity.Properties.species~=entity.Properties.species then return nil end
				if vehicle.gunnerT and vehicle.gunnerT.entity and vehicle.gunnerT.entity.Properties and vehicle.gunnerT.entity.Properties.species~=entity.Properties.species then return nil end
				-- Hud:AddMessage(entity:GetName()..": SPECIAL_STOPALL 3")
				self:SPECIAL_STOPALL(entity,sender) -- Ниже вставлять нельзя. Иногда проскакивает при попытке сесть в транспорт, иногда, получается остаётся standingthere.
				-- System:Log(entity:GetName()..": sender 2: "..sender:GetName())
				-- Hud:AddMessage(entity:GetName()..": Vehicle 4: "..vehicle:GetName())
				-- System:Log(entity:GetName()..": Vehicle 4: "..vehicle:GetName())
				if vehicle.AddDriver and vehicle:AddDriver(entity)==1 then				-- try to be driver -- Может через OR сделать?
					-- System:Log(entity:GetName()..": sender 3: "..sender:GetName())
					entity.RunToTrigger = 1
					AI:Signal(0,1,"entered_vehicle",entity.id)
					return 1
				end
				-- Hud:AddMessage(entity:GetName()..": Vehicle 5: "..vehicle:GetName())
				-- System:Log(entity:GetName()..": Vehicle 5: "..vehicle:GetName())
				if MountedGunUser then entity.VehicleMountedGunUser = 1 end
				if vehicle.AddGunner and vehicle:AddGunner(entity)==1 then		-- if not driver - try to be gunner
					-- System:Log(entity:GetName()..": sender 4: "..sender:GetName())
					entity.RunToTrigger = 1
					AI:Signal(0,1,"entered_vehicle",entity.id)
					return 1
				end
				-- Hud:AddMessage(entity:GetName()..": Vehicle 6: "..vehicle:GetName())
				-- System:Log(entity:GetName()..": Vehicle 6: "..vehicle:GetName())
				if MountedGunUser then entity.VehicleMountedGunUser = nil end
				if vehicle.AddPassenger and vehicle:AddPassenger(entity)==1 then				-- if not gunner - try to be passenger
					-- System:Log(entity:GetName()..": sender 5: "..sender:GetName())
					entity.RunToTrigger = 1
					AI:Signal(0,1,"entered_vehicle",entity.id)
					return 1
				end
			end
		end
	end,
}