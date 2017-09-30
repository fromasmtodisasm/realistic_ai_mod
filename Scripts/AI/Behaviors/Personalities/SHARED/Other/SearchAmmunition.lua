AIBehaviour.SearchAmmunition = {
	Name = "SearchAmmunition",
	NOPREVIOUS = 1,
	ALLOW_JUMP = 1, -- Может и поможет.

	OnSelected = function(self,entity)
	end,

	OnActivate = function(self,entity)
	end,

	OnNoTarget = function(self,entity)
		AIBehaviour.DEFAULT:OnNoTarget(entity)
		if entity.cnt.proning then
			entity:InsertSubpipe(0,"setup_crouch")
		elseif entity.cnt.crouching then
			entity:InsertSubpipe(0,"setup_stand")
		end
		entity:ChangeAIParameter(AIPARAM_FOV,entity.Properties.horizontal_fov)
		entity.CurrentHorizontalFov=entity.Properties.horizontal_fov
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		local att_target = AI:GetAttentionTargetOf(entity.id)
		if att_target and type(att_target)=="table" then
			if entity.IsAiPlayer and att_target==_localplayer then
				-- Hud:AddMessage(entity:GetName()..": AIPlayerIdle/LocalPlayerSeen")
				-- System:Log(entity:GetName()..": AIPlayerIdle/LocalPlayerSeen")
				entity:InsertSubpipe(0,"not_shoot")
				entity:TriggerEvent(AIEVENT_CLEAR) -- Чтобы не было стрельбы в игрока при использовании acqtarget.
				return
			end
		end
		local dist=30
		local look=0
		if entity.IsAiPlayer then
			AIBehaviour.DEFAULT:AI_SETUP_DOWN(entity)
			dist=60
			look=1
		end
		local weapon = entity.cnt.weapon
		local Current_FireModeType  -- Режим огня.
		if self.fireparams then
			Current_FireModeType = self.fireparams.fire_mode_type
		end
		AI:CreateGoalPipe("AiPlayer_stealth_getgun")
		AI:PushGoal("AiPlayer_stealth_getgun","hide",1,dist,HM_FARTHEST,look)
		AI:PushGoal("AiPlayer_stealth_getgun","timeout",1,1,5)
		-- AI:PushGoal("AiPlayer_stealth_getgun","locate",0,"atttarget")
		-- AI:PushGoal("AiPlayer_stealth_getgun","acqtarget",0,"")
		AI:PushGoal("AiPlayer_stealth_getgun","locate",0,"beacon")
		AI:PushGoal("AiPlayer_stealth_getgun","acqtarget",0,"")
		entity:InsertSubpipe(0,"AiPlayer_stealth_getgun")
		if fDistance<=dist or not entity.AllowUseMeleeOnNoAmmoInWeapons or (weapon and entity.cnt.ammo_in_clip > 0 and Current_FireModeType
		and Current_FireModeType~=FireMode_Melee) then -- А если был с руками но есть другие пушки с патронами? -- error: attempt to compare number with nil
			SeenTarget = 1
			AI:Signal(0,1,"EXIT_SEARCH_AMMUNITION",entity.id)
			do return end
		end
		entity:GrenadeAttack(9)
		if not entity.IsAiPlayer and not entity.IsSpecOpsMan then
			entity:ChangeAIParameter(AIPARAM_FOV,10)
			entity.CurrentHorizontalFov=10
		end
	end,

	OnEnemySeen = function(self,entity)
		-- called when the enemy sees a foe which is not a living player
	end,

	OnFriendSeen = function(self,entity)
		-- called when the enemy sees a friendly target
	end,

	OnSomethingSeen = function(self,entity)
		if entity.IsAiPlayer then
			if not entity.cnt.proning and not entity.cnt.crouching then
				entity:InsertSubpipe(0,"setup_crouch")
			elseif entity.cnt.crouching then
				entity:InsertSubpipe(0,"setup_prone")
			end
			AI:CreateGoalPipe("AiPlayer_stealth_getgun")
			AI:PushGoal("AiPlayer_stealth_getgun","hide",1,60,HM_NEAREST,1)
			AI:PushGoal("AiPlayer_stealth_getgun","timeout",1,1,5)
			entity:InsertSubpipe(0,"AiPlayer_stealth_getgun")
		end
	end,

	OnDeadBodySeen = function(self,entity,sender,fDistance)
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		if entity.cnt.proning then
			entity:InsertSubpipe(0,"setup_crouch")
		end
		entity:ChangeAIParameter(AIPARAM_FOV,entity.Properties.horizontal_fov)
		entity.CurrentHorizontalFov=entity.Properties.horizontal_fov
	end,

	OnInterestingSoundHeard = function(self,entity,fDistance)
		if entity.IsAiPlayer then
			if not entity.cnt.proning and not entity.cnt.crouching then
				entity:InsertSubpipe(0,"setup_crouch")
			elseif entity.cnt.crouching then
				entity:InsertSubpipe(0,"setup_prone")
			end
			AI:CreateGoalPipe("AiPlayer_stealth_getgun")
			AI:PushGoal("AiPlayer_stealth_getgun","timeout",1,1,5)
			AI:PushGoal("AiPlayer_stealth_getgun","lookat",1,-145,145)
			AI:PushGoal("AiPlayer_stealth_getgun","timeout",1,0,25)
			entity:InsertSubpipe(0,"AiPlayer_stealth_getgun")
		end
		local weapon = entity.cnt.weapon
		local Current_FireModeType  -- Режим огня.
		if self.fireparams then
			Current_FireModeType = self.fireparams.fire_mode_type
		end
		if (fDistance <= 10 and Current_FireModeType==FireMode_Melee) or (weapon and entity.cnt.ammo_in_clip > 0 and Current_FireModeType~=FireMode_Melee)
		or (not weapon and entity.IsAiPlayer) then
			AI:Signal(0,1,"EXIT_SEARCH_AMMUNITION",entity.id)
		end
	end,

	OnThreateningSoundHeard = function(self,entity,fDistance)
		if fDistance<60 then
			AIBehaviour.DEFAULT:AI_SETUP_DOWN(entity)
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
		AI:Signal(0,1,"EXIT_SEARCH_AMMUNITION",entity.id)
		entity:SelectPipe(0,"randomhide_trace")
		entity:InsertSubpipe(0,"DropBeaconTarget",sender.id)
		entity:InsertSubpipe(0,"take_cover")
		entity:InsertSubpipe(0,"scared_shoot",sender.id)
	end,

	OnReceivingDamage = function(self,entity,sender)
		AI:Signal(0,1,"EXIT_SEARCH_AMMUNITION",entity.id)
		entity:SelectPipe(0,"randomhide_trace")
		entity:InsertSubpipe(0,"DropBeaconTarget")
		entity:GrenadeAttack(3)
		entity:InsertSubpipe(0,"take_cover")
	end,

	OnBulletRain = function(self,entity,sender)
		if entity.dmg_percent<=.5 then
			self:OnReceivingDamage(entity,sender)
		end
		entity:GrenadeAttack(3)
	end,

	OnCloseContact = function(self,entity,sender) -- Сделать чтобы не входил в цикл "искать/не искать" при этом.
		if entity.IsAiPlayer then return end
		if entity.Properties.species~=sender.Properties.species then
			AI:Signal(0,1,"EXIT_SEARCH_AMMUNITION",entity.id)
		end
		AIBehaviour.DEFAULT:OnCloseContact(entity,sender)
	end,

	OnGrenadeSeen = function(self,entity,fDistance)
		if not fDistance then do return end end
		if fDistance > 15 then do return end end
		AI:Signal(0,1,"EXIT_SEARCH_AMMUNITION",entity.id)
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
		AIBehaviour.DEFAULT:OnDeath(entity)
	end,

	OnSomethingDiedNearest = function(self,entity,sender)
	end,

	OnSomethingDiedNearest_x = function(self,entity,sender)
	end,

	PICK_UP_WEAPON = function(self,entity,sender) -- Переделать всю систему поиска. Если не двигается в течении некоторого времени - выйти.
		if not entity.GoToWeapon then entity.GoToWeapon="nil" end -- А чего бы и это всё в таблицу не загнать?
		if not entity.FoundWeapon then entity.FoundWeapon="nil" end
		if not entity.GoToAmmo then entity.GoToAmmo="nil" end
		if not entity.FoundAmmo then entity.FoundAmmo="nil" end
		if not entity.GoToHealth then entity.GoToHealth="nil" end
		if not entity.FoundHealth then entity.FoundHealth="nil" end
		-- Hud:AddMessage(entity:GetName()..": PICK_UP_WEAPON: "..entity.GoToWeapon.." "..entity.FoundWeapon.." "..entity.GoToAmmo.." "..entity.FoundAmmo.." "..entity.GoToHealth.." "..entity.FoundHealth)
		System:Log(entity:GetName()..": PICK_UP_WEAPON: "..entity.GoToWeapon.." "..entity.FoundWeapon.." "..entity.GoToAmmo.." "..entity.FoundAmmo.." "..entity.GoToHealth.." "..entity.FoundHealth)
		if entity.GoToWeapon=="nil" then entity.GoToWeapon=nil end
		if entity.FoundWeapon=="nil" then entity.FoundWeapon=nil end
		if entity.GoToAmmo=="nil" then entity.GoToAmmo=nil end
		if entity.FoundAmmo=="nil" then entity.FoundAmmo=nil end
		if entity.GoToHealth=="nil" then entity.GoToHealth=nil end
		if entity.FoundHealth=="nil" then entity.FoundHealth=nil end

		if entity.FoundAmmoEntity and entity.GoToAmmo then
			local GetState = entity.FoundAmmoEntity:GetState()
			--if not entity.FoundAmmoEntity.ForceExitSearchAmmo then entity.FoundAmmoEntity.ForceExitSearchAmmo="nil" end
			--Hud:AddMessage(entity:GetName()..": PICK_UP_WEAPON AMMO "..entity.FoundAmmoEntity.ammo_type.."("..entity.FoundAmmo..")".." "..GetState..", force exit: "..entity.FoundAmmoEntity.ForceExitSearchAmmo)
			--if entity.FoundAmmoEntity.ForceExitSearchAmmo=="nil" then entity.FoundAmmoEntity.ForceExitSearchAmmo=nil end
			--if GetState=="Inactive" or entity.FoundAmmoEntity.ForceExitSearchAmmo then -- Второе - исправляет попытку взять патроны, кторые при самом старте были подобраны кем-то и из-за этого entity.FoundAmmoEntity почему-то перестала обновляться.
			if GetState=="Inactive" then
				-- Hud:AddMessage(entity:GetName()..": PICK_UP_WEAPON, no/picked ammo! "..entity.FoundAmmoEntity.ammo_type.."("..entity.FoundAmmo..")".." "..GetState)
				System:Log(entity:GetName()..": PICK_UP_WEAPON, no/picked ammo! "..entity.FoundAmmoEntity.ammo_type.."("..entity.FoundAmmo..")".." "..GetState)
				AI:Signal(0,1,"EXIT_SEARCH_AMMUNITION",entity.id)
			end
		end
		if not entity.SearchAmmunitionTimeOut then entity.SearchAmmunitionTimeOut=_time end
		if (entity.GoToWeapon and not entity.FoundWeapon) or (entity.GoToAmmo and not entity.FoundAmmo)
		or (entity.GoToHealth and not entity.FoundHealth) or (entity.GoToHealth and entity.cnt.health>=entity.Properties.max_health)
		or (not entity.GoToWeapon and not entity.GoToAmmo and not entity.FoundAmmo and not entity.GoToHealth) -- Когда не ищем пушку и нет патронов, выходим.
		or (not entity.GoToAmmo and not entity.GoToWeapon and not entity.FoundWeapon and not entity.GoToHealth) -- На всякий случай.
		or (_time>entity.SearchAmmunitionTimeOut+60) then -- Лучше проверить на застревание.
			AI:Signal(0,1,"EXIT_SEARCH_AMMUNITION",entity.id)
			do return end
		end

		if entity.FoundHealthEntity and entity.GoToHealth then
			local GetState = entity.FoundHealthEntity:GetState()
			if GetState=="Inactive" then
				System:Log(entity:GetName()..": PICK_UP_WEAPON, no/picked health/armor! "..entity.FoundHealthEntity.pickuptype.."("..entity.FoundHealth..")".." "..GetState)
				AI:Signal(0,1,"EXIT_SEARCH_AMMUNITION",entity.id)
			end
		end

		if entity.FoundWeaponEntity and entity.GoToWeapon then -- Прикольная иногда ситуация выходит: на одну пушку претендуют два чела, и второй, не успевший её подобрать, гоняется за первым. )) Как такое произошло? Один пытался за карту уплыть.
			local GetState
			if entity.FoundWeaponEntity.GetState then -- Должно исправить GetState nil
				GetState = entity.FoundWeaponEntity:GetState()
			end
			if entity:CountWeaponsInSlots() >= 4 or not GetState or (entity.NoWeaponInHands and entity.cnt.weapon) then
				AI:Signal(0,1,"EXIT_SEARCH_AMMUNITION",entity.id)
				do return end
			end
			if GetState=="Inactive" or ((entity.FoundWeaponEntity.Properties.Animation and not entity.FoundWeaponEntity.Properties.Animation.AvailableWeapon) and (GetState=="Default" or GetState=="Activated")) then
				entity.AI_GunOut = 1
				-- Hud:AddMessage(entity:GetName()..": PICK_UP_WEAPON, no/picked weapon! "..entity.FoundWeaponEntity.weapon.."("..entity.FoundWeapon..")".." "..GetState)
				System:Log(entity:GetName()..": PICK_UP_WEAPON, no/picked weapon! "..entity.FoundWeaponEntity.weapon.."("..entity.FoundWeapon..")".." "..GetState)
				AI:Signal(0,1,"EXIT_SEARCH_AMMUNITION",entity.id)
			end
		end
	end,

	EXIT_SEARCH_AMMUNITION = function(self,entity,sender) -- Сделать чтобы прятался если вышел, так и не взяв пушку.
		-- Hud:AddMessage(entity:GetName()..": EXIT_SEARCH_AMMUNITION")
		System:Log(entity:GetName()..": EXIT_SEARCH_AMMUNITION")
		entity.FoundAmmo = nil
		entity.FoundWeapon = nil
		entity.FoundHealth = nil
		entity.FoundAmmoEntity = nil
		entity.FoundWeaponEntity = nil
		entity.FoundHealthEntity = nil
		entity.GoToWeapon = nil
		entity.GoToAmmo = nil
		entity.GoToHealth = nil
		entity.GoToPickup = nil
		entity:ChangeAIParameter(AIPARAM_FOV,entity.Properties.horizontal_fov)
		entity.CurrentHorizontalFov=entity.Properties.horizontal_fov
		entity:SelectPipe(0,"check_beacon") -- Выходить стали кривовато, остаётся пайпа get_gun.
		if entity.IsAiPlayer then
			entity.RunToTrigger = nil
			if SeenTarget then
				SeenTarget = nil -- Это необходимо.
				-- Hud:AddMessage(entity:GetName()..": SearchAmmunition/SeenTarget")
				-- System:Log(entity:GetName()..": SearchAmmunition/SeenTarget")
				AIBehaviour.AIPlayerIdle:OnPlayerSeen(entity) -- Дистанция сама проставится.
			else
				-- Hud:AddMessage(entity:GetName()..": SearchAmmunition/SeenTarget ELSE")
				-- System:Log(entity:GetName()..": SearchAmmunition/SeenTarget ELSE")
				-- entity.EventToCall = "GO_FOLLOW"
				entity.EventToCall = "AFTER_GET_AMMO_GO_FOLLOW" -- Доделать чтобы всегда сразу бежал на радар или на другой подарок.
			end
			do return end
		end
		-- System:Log(entity:GetName()..": entity.MERC: "..entity.MERC)
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
		elseif entity.IsSpecOpsMan then
			entity.RunToTrigger = nil
			if entity.WasInCombat then
				entity.EventToCall = "OnPlayerSeen"
			else
				entity.EventToCall = "OnSpawn"
			end
		else
			entity.RunToTrigger = nil
			entity:RunToAlarm()
		end
	end,

	ALARM_ON = function(self,entity,sender)
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
	end,

	STOP_LOOK_AT_BEACON = function(self,entity,sender)
	end,

	HEADS_UP_GUYS = function(self,entity,sender)
		-- dont handle this signal
	end,

	INCOMING_FIRE = function(self,entity,sender)
		-- dont handle this signal
	end,

	KEEP_FORMATION = function(self,entity,sender)
		-- the team leader wants everyone to keep formation
	end,

	BREAK_FORMATION = function(self,entity,sender)
		-- the team can split
	end,

	SINGLE_GO = function(self,entity,sender)
		-- the team leader has instructed this group member to approach the enemy
	end,

	GROUP_COVER = function(self,entity,sender)
		-- the team leader has instructed this group member to cover his friends
	end,

	IN_POSITION = function(self,entity,sender)
		-- some member of the group is safely in position
	end,

	GROUP_SPLIT = function(self,entity,sender)
		-- team leader instructs group to split
	end,

	PHASE_RED_ATTACK = function(self,entity,sender)
		-- team leader instructs red team to attack
	end,

	PHASE_BLACK_ATTACK = function(self,entity,sender)
		-- team leader instructs black team to attack
	end,

	GROUP_MERGE = function(self,entity,sender)
		-- team leader instructs groups to merge into a team again
	end,

	CLOSE_IN_PHASE = function(self,entity,sender)
		-- team leader instructs groups to initiate part one of assault fire maneuver
	end,

	ASSAULT_PHASE = function(self,entity,sender)
		-- team leader instructs groups to initiate part one of assault fire maneuver
	end,

	GROUP_NEUTRALISED = function(self,entity,sender)
		-- team leader instructs groups to initiate part one of assault fire maneuver
	end,
}