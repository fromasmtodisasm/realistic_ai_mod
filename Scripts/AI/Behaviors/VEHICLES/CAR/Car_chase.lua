
AIBehaviour.Car_chase = {
	Name = "Car_chase",
	

	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSpawn = function(self,entity)

	end,
	---------------------------------------------
	OnActivate = function(self,entity)

	end,

	---------------------------------------------
	OnNoTarget = function(self,entity)
		-- called when the enemy stops having an attention target
--[kirill] designers don't want the chaser to ever stop
--		entity:DropPeople()
	end,

	---------------------------------------------
	---------------------------------------------
	OnGrenadeSeen = function(self,entity)

printf("Vehicle -------------- OnGranateSeen")	
	
		entity:InsertSubpipe(0,"c_grenade_run_away")
		
	end,

	OnGrenadeSeen_Flying = function(self,entity,sender)
		self:OnGrenadeSeen(entity)
	end,

	OnGrenadeSeen_Colliding = function(self,entity,sender)
		self:OnGrenadeSeen(entity)
	end,
	
	OnGroupMemberDied = function(self,entity,sender)
--do return end
--printf("Vehicle -------------- OnDeath")	
		if (sender==entity.driver) then				-- stop if the driver is killed
			AI:Signal(0,1,"DRIVER_OUT",entity.id)
		end	
	end,	

	---------------------------------------------
	OnEnemyMemory = function(self,entity,fDistance,NotContact)
	
		entity:TriggerEvent(AIEVENT_PATHFINDON)
--printf("Vehicle -------------- RejectPlayer")	

--		entity:TriggerEvent(AIEVENT_REJECT)

	end,

	--------------------------------------------
	OnPlayerSeen = function(self,entity,fDistance,NotContact) -- Добавить: проверка вода/помещение.
		-- local target = AI:GetAttentionTargetOf(entity.id)
		-- if (target and type(target)=="table" and target.GetPos) then
			-- local water = Game:GetWaterHeight()
			-- --	local terrain = System:GetTerrainElevation(target:GetPos())
			-- --	if (terrain<water) then
			-- local tagretPos = target:GetPos()
			-- --	if ((tagretPos.z-water)<1) then
			-- System:Log("\002 OnPlayerSeen "..tagretPos.z.." water "..water)	
			-- if (tagretPos.z<water or (target.theVehicle and target.theVehicle.IsBoat)) then
				-- Hud:AddMessage(entity:GetName()..": Car_chase/OnPlayerSeen/on water")
				-- System:Log(entity:GetName()..": Car_chase/OnPlayerSeen/on water")
				-- entity:SelectPipe(0,"c_brake")
				-- entity.pausechase = 1 
			-- else
				-- Hud:AddMessage(entity:GetName()..": Car_chase/OnPlayerSeen/on land")
				-- System:Log(entity:GetName()..": Car_chase/OnPlayerSeen/on land")
			-- end	
		-- else
			-- Hud:AddMessage(entity:GetName()..": Car_chase/OnPlayerSeen/no point")
			-- System:Log(entity:GetName()..": Car_chase/OnPlayerSeen/no point")
		-- end
		entity:TriggerEvent(AIEVENT_PATHFINDOFF)
	end,

	---------------------------------------------
	-- CUSTOM
	---------------------------------------------
	---------------------------------------------
	DRIVER_IN = function(self,entity,sender)

		self:next_point(entity)
		
--entity:SelectPipe(0,"c_standingthere")		
		
	end,	
	
	--------------------------------------------
	EVERYONE_OUT = function(self,entity,sender)

		entity:SelectPipe(0,"c_brake")
--		entity:EveryoneOut()	
		VC.DropPeople(entity)		
--		AI:Signal(0,1,"next_point",entity.id)					
--entity:SelectPipe(0,"c_standingthere")		
		
	end,	
	

	--------------------------------------------
	next_point = function(self,entity,sender)	
		if entity.pausechase then do return end end
--entity:TriggerEvent(AIEVENT_PATHFINDON)
	
--		printf("---->>let's runOver!!  ")		
--		entity:SelectPipe(0,"c_runover")

		local pipeName = entity:GetName().."chase" 
		entity:SelectPipe(0,pipeName)

	end,

	---------------------------------------------
	DRIVER_OUT = function(self,entity,sender)
--printf("car patol  -------------- driver out")	
		entity:SelectPipe(0,"c_brake")
		entity:DropPeople()
	end,	

	---------------------------------------------
	GUNNER_OUT = function(self,entity,sender)
--printf("car patol  -------------- driver out")	
		entity:SelectPipe(0,"c_brake")
		entity:DropPeople()
	end,	

	OnSomethingDiedNearest = function(self,entity,sender)
	end,

	OnSomethingDiedNearest_x = function(self,entity,sender)
	end,

	OnReceivingDamage = function(self,entity,sender)
	end,

	OnBulletRain = function(self,entity,sender)
	end,

	OnCloseContact = function(self,entity,sender)
	end,

	ALARM_ON = function(self,entity,sender)
	end,

	ALERT_SIGNAL = function(self,entity,sender)
	end,

	NORMAL_THREAT_SOUND = function(self,entity,sender)
	end,

	LOOK_AT_BEACON = function(self,entity,sender)
	end,

	STOP_LOOK_AT_BEACON = function(self,entity,sender)
	end,

	INCOMING_FIRE = function(self,entity,sender)
	end,

	HEADS_UP_GUYS = function(self,entity,sender)
	end,

	GoForReinforcement = function(self,entity,sender)
	end,

	RunToAlarmSignal = function(self,entity,sender)
	end,

	FIND_A_TARGET = function(self,entity,sender)
	end,

	TARGET_LOST = function(self,entity,sender)
	end,

	SWITCH_TO_MORTARGUY = function(self,entity,sender)
	end,

	SEARCH_AMMUNITION = function(self,entity,sender)
	end,

	SELECT_IDLE = function(self,entity,sender)
	end,
}
