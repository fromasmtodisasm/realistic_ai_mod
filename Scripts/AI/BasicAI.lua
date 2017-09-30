Script:ReloadScript("Scripts/Default/Entities/AI/AISounds/sound_tables.lua")
Script:ReloadScript("Scripts/Default/Entities/AI/AISounds/keyframes.lua")
Script:ReloadScript("Scripts/Default/Entities/AI/AISounds/jumps.lua")

BasicAI = {
	ai=1, -- entity.ai, либо self.ai.
	lastMeleeAttackTime = 0,
	isBlinded = 0,
	iLastWaterSurfaceParticleSpawnedTime = _time,
	Energy = 100,
	MaxEnergy = 100,
	EnergyChanged = nil,

	sound_jump = 0,
	sound_death = 0,
	sound_land = 0,
	sound_pain = 0,

	vLastPos = {x=0,y=0,z=0},
	fLastRefractValue = 0,
	bSplashProcessed = nil,
	WeaponState = nil,

	-- Reloading related
	C_Reloading = nil,			-- Just to check when ammo = 0 if we already started client side FX
	C_LastReloadTriggered = 0,

	-- More complex server variables to keep reload procedure running for the right amount of time
	S_LastReloadTriggered = 0,
	S_Reloaded = 0,
	S_Reloading = nil,

	S_FireModeChangeSeqTriggered = 0,
	C_FireModeChangeSeqTriggered = 0,

	S_WeaponActivated = 0,
	C_WeaponActivated = 0,

	S_LastGrenadeThrow = 0,
	C_LastGrenadeThrow = 0,

	soundtimer = 0,

	Behaviour = {
	},

	temp_ModelName = "",

}

function BasicAI:OnPropertyChange()
	-- System:Log(self:GetName()..": prev: "..self.temp_ModelName..", new: "..self.Properties.fileModel)

	if self.Properties.fileModel~=self.temp_ModelName then
		--self:CreateLivingEntity(self.PhysParams)
		local FileModel = self.Properties.fileModel
		if strfind(strlower(FileModel),"mutant_aberration1_noweapon") then -- Карта CrytekTroopers.
			FileModel = "Objects/characters/Mutants/mutant_big/mutant_big_noweapon.cgf"
		end
		self:LoadCharacter(FileModel,0)
		self.temp_ModelName = self.Properties.fileModel
		local nMaterialID=Game:GetMaterialIDByName("mat_meat")
		self:PhysicalizeCharacter(self.PhysParams.mass,nMaterialID,self.BulletImpactParams.stiffness_scale,0)
		self:SetCharacterPhysicParams(0,"",PHYSICPARAM_SIMULATION,self.BulletImpactParams)
	end
end

function BasicAI:StopConversation()
	if (self.CurrentConversation) then
		self.CurrentConversation:Stop(self)
		self:StopDialog()
		self.CurrentConversation = nil
	end
end

function BasicAI:PutHelmetOn(helmet_cgf)
	if (helmet_cgf~="") then self:LoadObject(helmet_cgf,0,0)
		if (self.Properties.AttachHelmetToBone) then
			self:AttachObjectToBone(0,self.Properties.AttachHelmetToBone,0,1)
		else
			self:AttachObjectToBone(0,"hat_bone",0,1)
		end
		local helmet="Objects\\characters\\mercenaries\\accessories\\helmet_nightvis.cgf"
		local helmet2="Objects\\characters\\mercenaries\\accessories\\goggles.cgf"
		if helmet_cgf==helmet then
			self.CryVision=1  -- С ПНВ с тепловизором.
		elseif helmet_cgf==helmet2 then
			-- Hud:AddMessage(self:GetName()..": helmet_cgf: "..helmet_cgf.." helmet2: "..helmet2) -- Такое иногда на пользовательских картах вроде missile_attack используется. )
			self.NightVision=1  -- Просто ПНВ.
		end
		-- Hud:AddMessage(self:GetName()..": helmet_cgf: "..helmet_cgf.." helmet: "..helmet)
		-- System:Log(self:GetName()..": helmet_cgf: "..helmet_cgf.." helmet: "..helmet)
	end
end

function BasicAI:TeleportTo(Player)
	if not Player then return nil end
	local Pos = new(Player:GetPos())
	local Angles = new(Player:GetAngles())
	local Direction = new(Player:GetDirectionVector())
	-- System:Log(Player:GetName()..": Pos x: "..Pos.x..", y: "..Pos.y..", z: "..Pos.z)
	-- System:Log(Player:GetName()..": Angles x: "..Angles.x..", y: "..Angles.y..", z: "..Angles.z)
	-- System:Log(Player:GetName()..": Direction x: "..Direction.x..", y: "..Direction.y..", z: "..Direction.z)
	local Indoor = System:IsPointIndoors(Pos) -- Позиция именно игрока.
	Pos.x = Pos.x-Direction.x -- Заспавнить позади игрока.
	Pos.y = Pos.y-Direction.y
	local Elevation=System:GetTerrainElevation(Pos)
	local WaterHeight = Game:GetWaterHeight()
	local UnderWater = Player.cnt.underwater
	if not Indoor and Elevation<WaterHeight then
		if UnderWater<=0 then
			Elevation = WaterHeight -- Либо на уровне воды.
		else
			Elevation = Pos.z -- Либо на уровне с игроком под водой.
		end
	end
	-- local Velocity = Player:GetVelocity()
	if not Indoor and Pos.z>Elevation and Player.cnt.flying then -- Если игрок летит, то лучше появиться на уровне земли.
		Pos.z = Elevation
	else -- Добавить проверку RayWorldIntersection по оси Z вниз.
		-- Pos.z = Pos.z+.5+Direction.z
		Pos.z = Pos.z+.8
	end
	Angles.z=Angles.z+180 -- Развернуть на 180.
	self:SetPos(Pos)
	self:SetAngles(Angles)
	if Player.cnt.proning then -- Авось заработает.
		self:InsertSubpipe(0,"setup_prone")
	elseif Player.cnt.crouching then
		self:InsertSubpipe(0,"setup_crouch")
	end
	return 1
end

function BasicAI:SpawnPlayerCopy() -- Если спавнится в GameRules прямо во время инициализации, то остаётся до перезапуска, иначе, как мне и надо, исчезает.
	local NewPlayer = Server:SpawnEntity("MercCover") -- А CreateAI может быть чем-нибудь полезен?
	if NewPlayer then -- Ничего не забыл?
		local Player = _localplayer
		if not NewPlayer:TeleportTo(Player) then Server:RemoveEntity(NewPlayer.id) return end -- Проверено.
		-- local name
		-- if NameGenerator then
			-- name = NameGenerator:GetHumanName()
		-- end
		-- NewPlayer:SetName(Player:GetName().."$1_AI")
		NewPlayer:SetName("$4[$1John$4]$1")
		-- NewPlayer:SetName("$1 @John ")
		NewPlayer.MERC = "player"
		NewPlayer.IsAiPlayer = 1
		NewPlayer.PropertiesInstance = Player.PropertiesInstance
		NewPlayer.Properties = Player.Properties
		NewPlayer.PhysParams = Player.PhysParams
		NewPlayer.PlayerDimNormal = Player.PlayerDimNormal
		NewPlayer.PlayerDimCrouch = Player.PlayerDimCrouch
		NewPlayer.PlayerDimProne = Player.PlayerDimProne
		NewPlayer.DeadBodyParams = Player.DeadBodyParams
		NewPlayer.AI_DynProp = Player.AI_DynProp
		NewPlayer.AniRefSpeeds = Player.AniRefSpeeds
		NewPlayer.BulletImpactParams = Player.BulletImpactParams
		NewPlayer:Server_OnInit()
		-- NewPlayer:SetName("$1"..NewPlayer.AI_NAME.."_AI")
		-- NewPlayer.AI_NAME = name
		NewPlayer.AI_NAME = "John"
		-- NewPlayer:Client_OnInit()
		-- NewPlayer:OnReset()
		-- NewPlayer.DoNotAvoidCollisionsOnTheMoveForward = 1 -- Проверить.
		NewPlayer.Ammo = Player.Ammo
		NewPlayer.cnt:SetSmoothInput(3,15,1,5) -- 3,15,5,15 -- input_accel, input_stop_accel, input_accel_indoor, input_stop_accel_indoor
		local WeaponsSlots = NewPlayer.cnt:GetWeaponsSlots()
		if WeaponsSlots then
			for i,New_Weapon in WeaponsSlots do
				if New_Weapon~=0 then
					NewPlayer.cnt:MakeWeaponAvailable(WeaponClassesEx[New_Weapon.name].id,0)
				end
			end
		end
		WeaponsSlots = Player.cnt:GetWeaponsSlots()
		if WeaponsSlots then
			for i,New_Weapon in WeaponsSlots do
				if New_Weapon~=0 then
					BasicPlayer.ScriptInitWeapon(NewPlayer,New_Weapon.name,nil,1)
				end
			end
		end
		local CurrentWeaponId = Player.cnt:GetCurrWeaponId()
		if CurrentWeaponId then
			NewPlayer.cnt:SetCurrWeapon(CurrentWeaponId)
		elseif not NewPlayer.cnt.Weapon then
			NewPlayer.cnt:SelectFirstWeapon()
		end
		-- if Player.cnt.proning then
			-- NewPlayer:InsertSubpipe(0,"setup_prone")
			-- Hud:AddMessage(NewPlayer:GetName()..": PRONE")
		-- elseif Player.cnt.crouching then
			-- NewPlayer:InsertSubpipe(0,"DropBeaconTarget",Player.id)
			-- Hud:AddMessage(NewPlayer:GetName()..": CROUCH")
		-- end
		setglobal("sc",0)
		NewPlayer.FirstFollow = 1
	end
	return 1
end

function BasicAI:ResetValues()
	self.dmg_percent = 1 self.POTSHOTS = 0 self.EXPRESSIONS_ALLOWED = 1 self.not_sees_timer_start = 0 self.sees = 0
	local NilTable = { -- Так удобнее опустошать нужные переменные.
		"critical_status","bEnemy_Hidden","PLAYER_ALREADY_SEEN","DODGING_ALREADY","AI_PlayerEngaged","AlarmName","NotifyAnchor","FIND_CAR","RunToTrigger",
		"friendscount","groupfriendscount","tempplayer","dc","rs_x","rs_y","deadsenderid","SenderId","MountedGun","MountedGunEntity","FoundWeapon",
		"FoundWeaponEntity","FoundAmmo","FoundAmmoEntity","AI_AtWeapon","DamageStatus","NoRTIAnim","NotifyAnchorEntity","AlarmNameEntity","ctr","enemyscount",
		"BlindAlarmNameEntity","ReinforcePointEntity","SignalSent","xalarm","OldDriving","ConfirmCounter","NoTargetCount","poscount","NotReturnToIdleSay",
		"target_lost_muted","call_alarm_muted","get_reinforcements_muted","LAB","THREAT_SOUND_SIGNAL_SENT","SniperSetupStand","OnWakeUp","ThreatenStatus",
		"ThreatenStatus2","ThreatenStatus3","ThreatenStatus4","ThreatenStatus5","ThreatenStatus6","ThreatenStatus7","allow_search","allow_idle",
		"heads_up_guys","runga","temp_no_MG","no_MG","counter_dead","GoToPickup","GoToWeapon","GoToAmmo","ai_scramble","AI_OnDanger","scared_signal",
		"OnBulletRainCounter","ShootPosName","IsInvisible","AmbientLightAmount","LightAmount","TotalLightScale","TargetAmbientLightAmount",
		"TargetLightAmount","TargetTotalLightScale","TargetMaxTotalLightScale","OnPlayerSeenMemory","AllowVisible","IsIndoor","ReallySee","IsCagedSee",
		"IsCaged","WasTarget","OriginalHorizontalFov","CurrentHorizontalFov","FlashLightOn","CryVision","NightVision","CurrentSightRange","WasIsCaged",
		"NextCheckFlashLightTime","FirstCheck","MyCurrentPos","NotSelectAlert","FastNotDoIdle","FirstState","GetInMGTimeOut","IsAiPlayer","AiPlayerNextCheck",
		"PracticleFireMan","WasInCombat","NotAllowMeleeShoot","SetTestWeapon","SaveBigLightScaleTime","AiPlayerAllowSearchGun","NoWeaponInHands",
		"OnGrenadeSeen_sender","OnGrenadeSeen_senderid","ReallyGrenadeSees","CurrentGroupID","CurrentSpecies","ThreatenSoundTargetID",
		"ThreatenSoundDistanceToTarget","SayFirstContact","SayFirstThreateningSound","IsSpecOpsMan","SetAlerted","SetTheAngleAsAPlayer","ForceResponsiveness",
		"SetRandomMaxResponsiveness","ToWeaponAdded","SendStopLAB","SaveAtt","AttEntity","AllowMoveBack","MoveBack","ThrowGrenadeTime",
		"AllowUseMeleeOnNoAmmoInWeapons","AiPlayerDoNotShoot","DoNotShootOnFriendInWayStart","GoLeftOrRightOnFriendInWay","DoNotShootOnFriendsOnTarget",
		"DoNotShootOnFriendsOnClose","FoundHealth","FoundHealthEntity","GoToHealth","VehicleMountedGunUser","NotUseTimerStart","HeCame",
		"OnConversationFinishedStart","SetWeaponTable","AiForcedShootingStart","SomethingKilled","SomethingHurted","TimeToThrowGrenade",
		"DoNotShootAGrenadeLauncherIfNoGoalStart","FirstFollow","SearchAmmunitionTimeOut","RepeatSentWakeUp","RepeatMercStartSwimmingTimerStart",
		"bEnemy_Hidden2","GoFollowRepeatStart","NeedThisSoundTimeInMS","ThisSoundTimeInMS","SayDialogWordStart","ThrowGrenadeOnTimer",
	}
	for i,val in NilTable do -- val - текст.
		for j,val2 in self do
			if j==val then -- j - название переменной.
				self[j] = nil
				-- System:Log("NIL j: "..j)
			end
		end
	end
end

function BasicAI:OnReset()
	if not self.ResetValues then return end -- Когда в редакторе включаю ИИ игрока и вызывается OnReset...
	-- Hud:AddMessage(self:GetName()..": SpecOnReset 3")
	-- System:Log(self:GetName()..": SpecOnReset 3")
	-- self:TriggerEvent(AIEVENT_CLEAR)
	-- if self==_localplayer then -- Проверить.
		-- Hud:AddMessage(self:GetName()..": BasicAI/AIPALYER!!!")
		-- System:Log(self:GetName()..": BasicAI/AIPALYER!!!")

		-- if Player and Player.OnReset then
			-- Player.OnReset(self) -- self пропадает.
		-- end
	-- end

	-- self:TriggerEvent(AIEVENT_CLEAR)
	-- if Player and Player.Client then -- Проверить.
		-- Hud:AddMessage(self:GetName()..": BasicAI/Player")
		-- System:Log(self:GetName()..": BasicAI/Player")
	-- end

	-- if self.IsAiPlayer then
		-- Hud:AddMessage(self:GetName()..": BasicAI/AIPALYER!!! 222")
		-- System:Log(self:GetName()..": BasicAI/AIPALYER!!! 222")
	-- end
	-- Hud:AddMessage(self:GetName().." Basic ai reset")
	-- printf(self:GetName()..": Basic ai reset")
	self:ResetValues()

	local PackTable = EquipPacks[self.Properties.equipEquipment]
	if PackTable then
		for i,value in PackTable do
			value.IsDropped = nil
		end
	end
	local PackTable = EquipPacks[self.Properties.equipDropPack]
	if PackTable then
		for i,value in PackTable do
			value.IsDropped = nil
		end
	end

	self:NetPresent(1)
	self:SetScriptUpdateRate(self.UpdateTime)

	if (AI_ANIM_KEYFRAMES[self.Properties.KEYFRAME_TABLE]) then
		self.SoundEvents = AI_ANIM_KEYFRAMES[self.Properties.KEYFRAME_TABLE].SoundEvents
	end

	if (self.Properties.JUMP_TABLE) then
		if (AI_JUMP_KEYFRAMES[self.Properties.JUMP_TABLE]) then
			self.JumpSelectionTable = AI_JUMP_KEYFRAMES[self.Properties.JUMP_TABLE]
		end
	end

	if self.OnResetCustom then self:OnResetCustom()	end

	self:StopConversation()

	if (self.Properties.ImpulseParameters) then
		for name,value in self.Properties.ImpulseParameters do
			self.ImpulseParameters[name] = value
		end
	end

	BasicPlayer.OnReset(self)

	if (self.AI_DynProp) then
		if ((self.Properties.bPushPlayers) and (self.Properties.bPushedByPlayers)) then
			self.AI_DynProp.push_players = self.Properties.bPushPlayers
			self.AI_DynProp.pushable_by_players = self.Properties.bPushedByPlayers
		end
		self.cnt:SetDynamicsProperties(self.AI_DynProp)
	end

	self.isBlinded = 0
	self.CurrentConversation = nil
	self.cnt:CounterSetValue("Boredom",0)
	self.lastMeleeAttackTime = 0
	self.cnt:SetAISpeedMult(self.Properties.speed_scales)

	--randomize only if the AI is using a voicepack.
	self.Properties.SoundPack = SPRandomizer:GetHumanPack(self,self.Properties.SoundPack)
	-- System:Log(sprintf("%s using %s sound pack",self:GetName(),self.Properties.SoundPack))

	AI:RegisterWithAI(self.id,AIOBJECT_PUPPET,self.Properties,self.PropertiesInstance)
	-- self.cnt.health = self.Properties.max_health * getglobal("game_Health")
	self.cnt.health = self.Properties.max_health

	BasicPlayer.InitAllWeapons(self)

	if self.Properties.bSleepOnSpawn==1 then self.OnWakeUp = nil self:TriggerEvent(AIEVENT_SLEEP) end

	BasicPlayer.HelmetOff(self)

	if (self.PropertiesInstance.bHelmetOnStart) then
		if (self.PropertiesInstance.bHelmetOnStart==1) then
			self:PutHelmetOn(self.PropertiesInstance.fileHelmetModel)
			BasicPlayer.HelmetOn(self)
		end
	else
		if (self.Properties.bHelmetOnStart==1) then
			self:PutHelmetOn(self.Properties.fileHelmetModel)
			BasicPlayer.HelmetOn(self)
		end
	end

	if (self.PropertiesInstance.bHasLight==1) then
		self.cnt:GiveFlashLight(1)
		self.cnt:SwitchFlashLight(1)
	else
		self.cnt:SwitchFlashLight(0)
	end

	if (self.Properties.bHasShield) then
		if (self.Properties.bHasShield==1) then
			self.AttachedShield = self:LoadObject("Objects\\characters\\mercenaries\\accessories\\shield.cgf",1,1)
			self:AttachObjectToBone(1,"Bip01 L Hand")
		end
	end

	if (self.Behaviour["OnSpawn"]) then
		self.Behaviour:OnSpawn(self)
	else
		if (AIBehaviour[self.DefaultBehaviour]) then
			if (AIBehaviour[self.DefaultBehaviour].OnSpawn) then
				AIBehaviour[self.DefaultBehaviour]:OnSpawn(self)
			end
		end
	end

	self.bGunReady = self.PropertiesInstance.bGunReady -- Нужно, так как пока не знаю как достать в CryGame.dll.

	self.aibehavior_behaviour = self.PropertiesInstance.aibehavior_behaviour
	-- if self.aibehavior_behaviour=="MutantCaged" then
		-- Hud:AddMessage(self:GetName().." BasicAI/OnReset/aibehavior: "..self.aibehavior_behaviour)
		-- System:Log(self:GetName().." BasicAI/OnReset/aibehavior: "..self.aibehavior_behaviour)
		-- -- AI:RegisterWithAI(self.id,AIOBJECT_PUPPET,self.Properties,self.PropertiesInstance)
		-- AI:RegisterWithAI(self.id,AIOBJECT_NONE,self.Properties,self.PropertiesInstance)
	-- end

	-- -- Изменено: Теперь в редакторе отображется настоящее имя ИИ, а не имя из списка.
	-- -- if (self.AI_NAME) then
		-- -- self:SetAIName(self.AI_NAME)
	-- -- else
			-- self:SetAIName(self:GetName()
	-- -- end
	self.CurrentGroupID=self.PropertiesInstance.groupid
	self.CurrentSpecies=self.Properties.species
	local NameColor
	if (self.CurrentSpecies==1) then -- Наёмники.
		NameColor = "$5"
	elseif (self.CurrentSpecies==100) then -- Мутанты.
		NameColor = "$8"
	elseif (self.CurrentSpecies==0) then -- Игрок.
		NameColor = "$7"
	else
		NameColor = "$9"
	end
	self:SetAIName(NameColor..self:GetName().." $1"..self.CurrentGroupID.." "..self.CurrentSpecies)  -- Должно постоянно обновляться.

	if self.Properties.fileModel=="Objects/characters/SpecOps/Den/merc_sniper.cgf" -- Для сущностей не из библиотеки /, для сущностей из библиотеки \\.
	or self.Properties.fileModel=="Objects\\characters\\SpecOps\\Den\\merc_sniper.cgf" then
		self.IsSpecOpsMan="Den"
	elseif self.Properties.fileModel=="Objects/characters/SpecOps/Dooch/merc_offcomm.cgf"
	or self.Properties.fileModel=="Objects\\characters\\SpecOps\\Dooch\\merc_offcomm.cgf" then
		self.IsSpecOpsMan="Dooch"
	elseif self.Properties.fileModel=="Objects/characters/SpecOps/Lock/merc_cover.cgf"
	or self.Properties.fileModel=="Objects\\characters\\SpecOps\\Lock\\merc_cover.cgf" then
		self.IsSpecOpsMan="Lock"
	end

	-- if self.IsAiPlayer or self.IsSpecOpsMan then
	if self.IsSpecOpsMan then
		System:Log(self:GetName()..": IsSpecOpsMan Wake Up!")
		self:TriggerEvent(AIEVENT_WAKEUP)
	end

	self.melee_damage = self.Properties.fMeleeDamage

	if (self.PropertiesInstance.fScale) then
		self:SetStatObjScale(self.PropertiesInstance.fScale)
	end

	if (AI_SOUND_TABLES[self.Properties.SOUND_TABLE]) then
		self.painSounds = AI_SOUND_TABLES[self.Properties.SOUND_TABLE].painSounds
		self.deathSounds = AI_SOUND_TABLES[self.Properties.SOUND_TABLE].deathSounds
		self.chattersounds = AI_SOUND_TABLES[self.Properties.SOUND_TABLE].chattersounds
		self.breathSounds = AI_SOUND_TABLES[self.Properties.SOUND_TABLE].breathSounds
		--jump&land sounds
		self.jumpsounds = AI_SOUND_TABLES[self.Properties.SOUND_TABLE].jumpsounds
		self.landsounds = AI_SOUND_TABLES[self.Properties.SOUND_TABLE].landsounds
		--custom footstep sounds
		self.footstepsounds = AI_SOUND_TABLES[self.Properties.SOUND_TABLE].footstepsounds
		if (self.footstepsounds) then
			self.footsteparray = {0,0,0}
			self.footstepcount = 1
		end
	end

	AI:DeCloak(self.id)

	-- count melee animations and special fire animations for this enemy - if applicable
	self.MELEE_ANIM_COUNT = self:DiscoverAnimationCount("attack_melee",1,1)
	self.SPECIAL_FIRE_COUNT = self:DiscoverAnimationCount("fire_special",2,0)
	self.COMBAT_IDLE_COUNT = self:DiscoverAnimationCount("combat_idle",2,0)
	self.BLINDED_ANIM_COUNT = self:DiscoverAnimationCount("blind",2,0)
	self.DRAW_GUN_ANIM_COUNT = self:DiscoverAnimationCount("draw",2,1)
	self.HOLSTER_GUN_ANIM_COUNT = self:DiscoverAnimationCount("holster",2,1)

	self.Properties.LEADING_COUNT = -1
	self.LEADING = nil

	-- now the same for special fire animations

	BasicAI.SetSmoothMovement(self)

	self.NextChatterSound = 0

	self.LastJumpSound = nil
	self.LastLandSound = nil
	if self.MUTANT then self.PropertiesInstance.bGunReady = 1 end
	self.Properties.fDamageMultiplier = 1
	local ThisIsBig = strfind(strlower(self.Properties.fileModel),"mutant_big")
	if ThisIsBig then self.Properties.fDamageMultiplier = .1 end-- В некоторых дополнениях, вроде "Антитеррора" с мутантами толстяки погибают от одной пули.
	self.Properties.max_health = 255

	self:InitAIRelaxed()
	self:MakeIdle() -- Тест.

	-- Hud:AddMessage(self:GetName()..": SpecOnReset 4")
	-- System:Log(self:GetName()..": SpecOnReset 4")
end

function BasicAI:Add2Weapon(AddWeaponOnID)
	local Current_Weapon = self.cnt.weapon
	local Weapons=0
	local WeaponsSlots = self.cnt:GetWeaponsSlots()
	for i,New_Weapon in WeaponsSlots do
		if New_Weapon~=0 then
			local WeaponState = self.WeaponState
			local WeaponInfo = WeaponState[WeaponClassesEx[New_Weapon.name].id]
			local New_FireParams
			local New_FireModeType -- Режим огня.
			if WeaponInfo then
				New_FireParams = New_Weapon.FireParams[WeaponInfo.FireMode+1]
				New_FireModeType = New_FireParams.fire_mode_type
			end
			Weapons=Weapons+1
			if New_FireModeType==FireMode_Melee then
				Weapons=Weapons-1
			end
		end
	end
	local RandomWeaponID -- Файл WeaponSystem.lua.
	if self.MERC and self.MERC=="sniper" or (Current_Weapon and (Current_Weapon.name=="RL" or Current_Weapon.name=="SniperRifle")) then
		-- Если у снайпера имееся всего одна пушка, то нужно дать ему ещё одну.
		if Weapons==1 then
			local AddMp5
			if self.TotalLightScale and self.TotalLightScale<=.05 then
				AddMp5=1 -- Чтобы можно было стрелять из темноты, чтобы никто не заметил.
			end
			-- По нормальному, сюда подходят AG36, OICW и M4, но из-за своей скудной распространённости первых двух на начальном этапе, остановимся на простом оружии. Но, ночные миссии... там такое оружие уже обычно присутствует, так что можно и добавить.
			if Current_Weapon.name=="RL" then
				local rnd = random(1,3)
				if rnd==1 then
					RandomWeaponID=19 -- P90
				elseif rnd==2 and AddMp5 then
					RandomWeaponID=12 -- MP5
				else
					RandomWeaponID=20 -- M4
				end
			else
				local rnd = random(1,4)
				if rnd==1 then
					RandomWeaponID=10 -- Falcon
				elseif rnd==2 then
					RandomWeaponID=19 -- P90
				elseif rnd==3 and AddMp5 then
					RandomWeaponID=12 -- MP5
				else
					RandomWeaponID=20 -- M4
				end
			end
		end
	-- elseif self.MERC then
		-- if Weapons<=3 then
			-- RandomWeaponID = 13 -- Machete -- Автор какой-нибудь карты мог специально не давать ничего в руки, хм.
		-- end
	end
	if AddWeaponOnID then
		RandomWeaponID = AddWeaponOnID
	end
	if not RandomWeaponID then return end
	for j, weapon in WeaponClassesEx do
		if weapon.id==RandomWeaponID then
			-- BasicPlayer.AddItemInWeaponPack(self,"Weapon",j)  -- Из-за этого вообще перестаёт добавляться оружие.
			self.cnt:MakeWeaponAvailable(weapon.id,1)
			self.cnt:SetCurrWeapon(weapon.id)
			-- self.cnt:SetCurrWeapon(Current_Weapon.id)
			-- if self.MERC=="sniper" then
				-- self.cnt:SelectNextWeapon()
			-- else
				self.cnt:SelectFirstWeapon()
			-- end
		end
	end
	-- local GunOut = self.AI_GunOut -- Должно быть именно так. Найти другое решение.
	-- if not GunOut then
		-- self.cnt:HolsterGun()
		-- self.AI_GunOut = nil
	-- else
		-- self.cnt:HoldGun()
		-- self.AI_GunOut = 1
	-- end
	self.ToWeaponAdded=1
end
-- function BasicAI:AddSniper2Gun()
	-- local Current_Weapon = self.cnt.weapon
	-- if self.MERC and self.MERC=="sniper" or (Current_Weapon and (Current_Weapon.name=="RL" or Current_Weapon.name=="SniperRifle")) then
		-- -- Если у снайпера имееся всего одна пушка, то нужно дать ему ещё одну.
		-- local Weapons=0
		-- local WeaponsSlots = self.cnt:GetWeaponsSlots()
		-- for i, val in WeaponsSlots do
			-- if val~=0 then
				-- Weapons=Weapons+1
			-- end
		-- end
		-- if Weapons==1 then
			-- local rnd
			-- local AddMp5
			-- if self.TotalLightScale and self.TotalLightScale<=.05 then
				-- AddMp5=1 -- Чтобы можно было стрелять из темноты, чтобы никто не заметил.
			-- end
			-- if Current_Weapon.name=="RL" then
				-- rnd = random(1,3)
				-- if rnd==1 then
					-- rnd=19 -- P90
				-- elseif rnd==2 and AddMp5 then
					-- rnd=12 -- MP5
				-- else
					-- rnd=20 -- M4
				-- end
			-- else
				-- rnd = random(1,4)
				-- if rnd==1 then
					-- rnd=10 -- Falcon
				-- elseif rnd==2 then
					-- rnd=19 -- P90
				-- elseif rnd==3 and AddMp5 then
					-- rnd=12 -- MP5
				-- else
					-- rnd=20 -- M4
				-- end
			-- end
			-- for j, weapon in WeaponClassesEx do
				-- -- По нормальному, сюда подходят AG36, OICW и M4, но из-за своей скудной распространённости первых двух, остановимся на простом оружии. Но, ночные миссии... там такое оружие уже обычно присутствует, так что есть шанс...
				-- if weapon.id==rnd then
					-- -- BasicPlayer.AddItemInWeaponPack(self,"Weapon",j)  -- Из-за этого вообще перестаёт добавляться оружие.
					-- self.cnt:MakeWeaponAvailable(weapon.id,1)
					-- self.cnt:SetCurrWeapon(weapon.id)
					-- -- self.cnt:SetCurrWeapon(Current_Weapon.id)
					-- self.cnt:SelectNextWeapon()
				-- end
			-- end
		-- end
	-- end
-- end

function BasicAI:DiscoverAnimationCount(base_name,num_digits,start_value)

	local formatstring = base_name.."%0"..num_digits.."d"

	local num_found = 0
	local count = start_value
	local formatted_name = format(formatstring,count)
	while (self:GetAnimationLength(formatted_name)~=0) do
		num_found = num_found + 1
		count = count+1
		formatted_name = format(formatstring,count)
	end

	if (num_found>0) then
		return num_found
	else
		return nil
	end
end

function BasicAI:SetActualName()
	-- self:GetName() -- Реальное имя.
	-- self:GetAIName() -- Отображаемое.
	local NameColor
	if (self.CurrentSpecies==1) then -- Наёмники.
		NameColor = "$5"
	elseif (self.CurrentSpecies==100) then -- Мутанты.
		NameColor = "$8"
	elseif (self.CurrentSpecies==0) then -- Игрок.
		NameColor = "$7"
	else
		NameColor = "$9"
	end
	local Name = NameColor..self:GetName().." $1"..self.CurrentGroupID.." "..self.CurrentSpecies
	if self:GetAIName()~=Name then
		self:SetAIName(Name)
	end
end

function BasicAI:FriendGroup()
	-- В результате многочисленных опытов установлено, что:
	-- 1. Если свой species~=species игрока, свой groupid==groupid игрока, то не слышит игрока. - 5
	-- 2. Если свой species~=species игрока, свой groupid~=groupid игрока, то слышит игрока. - 6
	-- 3. Если свой species==species игрока, свой groupid==groupid игрока, то не слышит игрока. - 7
	-- 4. Если свой species==species игрока, свой groupid~=groupid игрока, то слышит игрока.
	-- 5. Если свой species~=species источника, свой groupid==groupid источника, то не слышат друг друга. - 1
	-- 6. Если свой species~=species источника, свой groupid~=groupid источника, то слышат друг друга. - 2
	-- 7. Если свой species==species источника, свой groupid==groupid источника, то не слышат друг друга. - 3
	-- 8. Если свой species==species источника, свой groupid~=groupid источника, то не слышат друг друга.
	if _localplayer and _localplayer.Properties and self.Properties.species==_localplayer.Properties.species then
		if self.CurrentGroupID~=_localplayer.Properties.groupid then
			self:ChangeAIParameter(AIPARAM_GROUPID,_localplayer.Properties.groupid)  -- Чтобы друзья игрока не слышали игрока.
			self.CurrentGroupID = _localplayer.Properties.groupid  -- Для SetActualName.
		end
	end
end

function BasicAI:DoChatter() -- C++
	-- -- HACK: the isplaying function returns nil if the sound
	-- -- is not playing,not 0,so this condition below actually never passes
	-- -- but if done correctly,for some reason the AI chatter will create millions
	-- -- of 3d AI chatter sounds and eventually
	-- -- crash the game running out of memory - never enable it!

	-- -- [Petar] Please next time when you spend time fixing something,make sure that it is fixed at the end of that time.
	-- -- This is now fixed.

	-- --filippo:play chatter sound every ~1-2 seconds,the is already a random chance in playonesound func.
	-- if (self.NextChatterSound) and (self.NextChatterSound > _time) then
		-- return
	-- end
	-- self.NextChatterSound = _time + random(100,200)*.01

	-- if (Sound:IsPlaying(self.chattering_on)==nil) then
		-- self.chattering_on = nil
	-- end

	-- if (self.chattering_on==nil and self.chattersounds) then
		-- --local rnd=random(1,10)
		-- --if (rnd>8) then
			-- self.chattering_on = BasicPlayer.PlayOneSound(self,self.chattersounds,50,1) --20)

			-- --if (self.chattering_on) then
			-- --	Hud:AddMessage(self:GetName().." doing chatter sounds")
			-- --end
		-- --end
	-- end
end

function BasicAI:Event_Activate(params)
	if self.cnt.health > 0 then
		-- if self.bEnemy_Hidden then -- Убрал потому что не всегда могут быть спрятаны правильно.
			self:Event_UnHide()
		-- end
		self:EnableUpdate(1)
		self:TriggerEvent(AIEVENT_WAKEUP)
		if self.Behaviour.OnActivate then
			self.Behaviour:OnActivate(self)
		elseif self.DefaultBehaviour and AIBehaviour[self.DefaultBehaviour].OnActivate then
			AIBehaviour[self.DefaultBehaviour]:OnActivate(self)
		end
	end
	BroadcastEvent(self,"Activate")
end

function BasicAI:Event_DeActivate(params)
	if (self.Behaviour.OnDeactivate) then
		self.Behaviour:OnDeactivate(self)
	elseif (AIBehaviour[self.DefaultBehaviour].OnDeactivate) then
		AIBehaviour[self.DefaultBehaviour]:OnDeactivate(self)
	end
	self.OnWakeUp = nil
	self:TriggerEvent(AIEVENT_SLEEP)
	BroadcastEvent(self,"DEActivate")
end

function BasicAI:Event_Hide(params) -- Исправить: Всё-равно активны.
	if self.cnt.health > 0 then
		self.bEnemy_Hidden = 1
		self:DrawCharacter(0,0)
		self.SaveAffectSOM = self.Properties.bAffectSOM
		self.Properties.bAffectSOM = 0
		self:TriggerEvent(AIEVENT_WAKEUP)
		self:TriggerEvent(AIEVENT_DISABLE)
		self:EnablePhysics(0)
		BroadcastEvent(self,"Hide")
		return 1
	end
	return nil
end

function BasicAI:Event_UnHide(params)
	if self.cnt.health > 0 then
		self.bEnemy_Hidden = nil
		self.bEnemy_Hidden2 = nil
		self:DrawCharacter(0,1)
		self.Properties.bAffectSOM = 1
		if self.SaveAffectSOM then self.Properties.bAffectSOM=self.SaveAffectSOM end
		self:TriggerEvent(AIEVENT_ENABLE)
		self:EnablePhysics(1)
		BroadcastEvent(self,"UnHide")
		return 1
	end
	return nil
end

function BasicAI:Event_Die(params)
	if (self.cnt.health > 0) then
		local	hit = {
			dir = {x=0,y=0,z=1},
			damage = 10000,
			target = self,
			shooter = self,
			landed = 1,
			impact_force_mul_final=5,
			impact_force_mul=5,
			damage_type = "normal",
			}
		self:Damage(hit)
	end
	BroadcastEvent(self,"Die")
end

function BasicAI:Event_Ressurect(params) -- При открытии двери и выполнении этой функции в оригинале иногда крашит. Проверить.
	if self.cnt.health <= 0 then
		self.bEnemy_Hidden = nil -- На всякий случай.
		self.bEnemy_Hidden2 = nil
		self.wasreset = nil
		self.bAllWeaponsInititalized = nil
		self:OnReset()
		self:TriggerEvent(AIEVENT_WAKEUP)
		self:TriggerEvent(AIEVENT_ENABLE)
		self:DrawCharacter(0,1)  -- Проверить.
		self:EnablePhysics(1)
		self.IsDedbody = nil
		self:ChangeAIParameter(AIPARAM_COMMRANGE,self.Properties.commrange) -- Так, на всякий пожарный.
		local Pos = new(self:GetPos())
		Pos.z=Pos.z+1 -- Чтобы под землю не проваливались когда просто возрождаются.
		self:SetPos(Pos)
	end
	BroadcastEvent(self,"Ressurect")
end

function BasicAI:Event_Follow(params)
	AI:Signal(0,1,"RETURN_TO_NORMAL",self.id)
	self:RestoreDynamicProperties()
	AI:MakePuppetIgnorant(self.id,0)
	AI:Signal(0,0,"SPECIAL_FOLLOW",self.id)
	BroadcastEvent(self,"Follow")
end

function BasicAI:Event_StopSpecial(params)
	AI:Signal(0,1,"RETURN_TO_NORMAL",self.id)
	self:RestoreDynamicProperties()
	AI:MakePuppetIgnorant(self.id,0)
	AI:Signal(0,0,"SPECIAL_STOPALL",self.id)
	BroadcastEvent(self,"StopSpecial")
end

function BasicAI:Event_DisablePhysics(params)
	self:EnablePhysics(0)
	BroadcastEvent(self,"DisablePhysics")
end

function BasicAI:Event_EnablePhysics(params)
	self:EnablePhysics(1)
	BroadcastEvent(self,"EnablePhysics")
end

function BasicAI:Event_SPECIAL_ANIM_START(params)
	BroadcastEvent(self,"SPECIAL_ANIM_START")
end

function BasicAI:Event_HoldSpot(params)
	AI:Signal(0,1,"RETURN_TO_NORMAL",self.id)
	self:RestoreDynamicProperties()
	AI:MakePuppetIgnorant(self.id,0)
	AI:Signal(0,0,"SPECIAL_HOLD",self.id)
	BroadcastEvent(self,"HoldSpot")
end

function BasicAI:Event_Lead(params)
	AI:Signal(0,1,"RETURN_TO_NORMAL",self.id)
	self:RestoreDynamicProperties()
	AI:MakePuppetIgnorant(self.id,0)
	AI:Signal(0,0,"SPECIAL_LEAD",self.id)
	BroadcastEvent(self,"Lead")
end

function BasicAI:Event_GoDumb(params)
	AI:Signal(0,1,"RETURN_TO_NORMAL",self.id)
	AI:MakePuppetIgnorant(self.id,0)
	AI:Signal(0,0,"SPECIAL_GODUMB",self.id)
	--self:SelectPipe(0,"dumb_wrapper")
	BroadcastEvent(self,"GoDumb")
end

function BasicAI:RestoreDynamicProperties()
	if (self.AI_DynProp) then
		if ((self.Properties.bPushPlayers) and (self.Properties.bPushedByPlayers)) then
			self.AI_DynProp.push_players = self.Properties.bPushPlayers
			self.AI_DynProp.pushable_by_players = self.Properties.bPushedByPlayers
		end
		self.cnt:SetDynamicsProperties(self.AI_DynProp)
	end
end

function BasicAI:Event_HalfHealthLeft(params)
	BroadcastEvent(self,"HalfHealthLeft")
end

function BasicAI:Event_Relocate(params)
	local point = Game:GetTagPoint(self:GetName().."_RELOCATE")
	if (point) then
		self:SetPos({x=point.x,y=point.y,z=point.z})
	else
		System:Warning("Entity "..self:GetName().." received a relocate event but has no relocate tagpoint")
	end
	BroadcastEvent(self,"Relocate")
end

-----------------------------
function BasicAI:Event_OnDeath(params)
	BroadcastEvent(self,"OnDeath")
end
-----------------------------
function BasicAI:Event_MakeVulnerable(params)
	self.Properties.bInvulnerable = 0
	BroadcastEvent(self,"MakeVulnerable")
end
-----------------------------
function BasicAI:Event_LastGroupMemberDied(params)
	BroadcastEvent(self,"LastGroupMemberDied")
end

function BasicAI:RegisterStates()
	self:RegisterState("Alive")
	self:RegisterState("Dead")
end

function BasicAI:Server_OnInit()
	if self.OnInitCustom then self:OnInitCustom() end

	local FileModel = self.Properties.fileModel
	if strfind(strlower(FileModel),"mutant_aberration1_noweapon") then -- Карта CrytekTroopers.
		FileModel = "Objects/characters/Mutants/mutant_big/mutant_big_noweapon.cgf"
	end
	self:LoadCharacter(FileModel,0)

	self.temp_ModelName = self.Properties.fileModel

--	self:LoadObject("Objects/characters/mercenaries/accessories/helmet.cgf",0,1)

	BasicPlayer.Server_OnInit(self)

	if (NameGenerator) then
		self.AI_NAME = NameGenerator:GetHumanName()
	end

	self:OnReset()

	self.cnt:CounterAdd("Boredom",.1)
	self.cnt:CounterSetEvent("Boredom",1,"OnBored")
end


function BasicAI:Client_OnInit()

	local FileModel = self.Properties.fileModel
	if strfind(strlower(FileModel),"mutant_aberration1_noweapon") then -- Карта CrytekTroopers.
		FileModel = "Objects/characters/Mutants/mutant_big/mutant_big_noweapon.cgf"
	end
	self:LoadCharacter(FileModel,0)

	BasicPlayer.Client_OnInit(self)

	if (self.Properties.bHasLight==1) then
		self.cnt.light = 1
	end
end


function BasicAI:Client_OnShutDown()
	BasicPlayer.OnShutDown(self)
	-- Free resources
end



--
--

--
--DMG_HEAD		1
--DMG_TORSO		2
--DMG_ARM		3
--DMG_LEG		4
--DMG_DEFAULT		2






function BasicAI:OnSaveOverall(stm)
	BasicPlayer.OnSaveOverall(self,stm)
end

--------------------------------------

function BasicAI:OnLoadOverall(stm)
	BasicPlayer.OnLoadOverall(self,stm)
end

function BasicAI:OnSave(stm)
	BasicPlayer.OnSave(self,stm)
	if self.Properties.LEADING_COUNT then
		stm:WriteInt(self.Properties.LEADING_COUNT)
	end

	if (self.AI_SpecialBehaviour) then
		stm:WriteString(self.AI_SpecialBehaviour)
	else
		stm:WriteString("NA")
	end

	stm:WriteBool(self.bEnemy_Hidden)  -- Оказывается, имеет большое значение, какой это тип переменной.
	stm:WriteBool(self.SaveAffectSOM)
end

function BasicAI:OnLoad(stm)
	BasicPlayer.OnLoad(self,stm)
	self.Properties.LEADING_COUNT = stm:ReadInt()

	-- by request of Sten, special AI are regenerated when loaded
	if (self.Properties.special==1) then
		self.cnt.health = self.Properties.max_health
	end

	local special_behaviour = stm:ReadString()

	if (special_behaviour~="NA") then
		self.AI_SpecialBehaviour = special_behaviour
		self:TriggerEvent(AIEVENT_CLEARSOUNDEVENTS)
		AI:Signal(0,1,self.AI_SpecialBehaviour,self.id)
	end

	BasicAI.SetSmoothMovement(self)

	self:DrawCharacter(0,1)  -- Исправление неправильно спрятанных ии.
	self.SaveAffectSOM = stm:ReadBool()
	if self.SaveAffectSOM and self.SaveAffectSOM>1 then self.SaveAffectSOM = nil end -- Оно там неправильно "выщитывает" если булевая переменная, её значение при сохраненении было пустым.

	self.bEnemy_Hidden = stm:ReadBool()
	if self.bEnemy_Hidden~=1 then -- К этому это тоже относится...
		self.bEnemy_Hidden = nil
	else -- ==1 обязательно!
		if self.Event_Hide then self:Event_Hide() end -- При загрузке была ошибка.
	end

	GameRules.AiPlayerFirstGoFollow = 1
end

function BasicAI:OnLoadRELEASE(stm)
	BasicPlayer.OnLoad(self,stm)
	self.Properties.LEADING_COUNT = stm:ReadInt()

	-- by request of Sten,special AI are regenerated when loaded
	if (self.Properties.special==1) then
		self.cnt.health = self.Properties.max_health
	end

	local special_behaviour = stm:ReadString()

	if (special_behaviour~="NA") then
		self.AI_SpecialBehaviour = special_behaviour
		self:TriggerEvent(AIEVENT_CLEARSOUNDEVENTS)
		AI:Signal(0,1,self.AI_SpecialBehaviour,self.id)
	end

	BasicAI.SetSmoothMovement(self)
end

function BasicAI:CheckFlashLight(NotInvestigate)
	local weapon = self.cnt.weapon
	if self.Properties.special==1 or (self.PropertiesInstance.bHasLight and self.PropertiesInstance.bHasLight==1) or self.MUTANT or self.ANIMAL
	or self.Properties.aicharacter_character=="Sniper" or self.CurrentConversation or (weapon and (weapon.name=="RL" or weapon.name=="SniperRifle")) then
		return
	end
	local name = AI:FindObjectOfType(self.id,2,AIAnchor.AIANCHOR_FLASHLIGHT)
	if name and not NotInvestigate then
		self:InsertSubpipe(0,"flashlight_investigate",name)
		return
	end
	if not self.TotalLightScale then return end
	local LightScale
	if self.IsIndoor then
		LightScale=.05
	else
		LightScale=.7 -- .4 - Rebellion
	end
	local ForceFlashLightOn
	if self.IsIndoor then
		-- Если вдруг случится резкая разница в количестве света.
		if self.TotalLightScale>=.6 then
			self.SaveBigLightScaleTime = _time
		elseif self.TotalLightScale <= LightScale and self.SaveBigLightScaleTime then
			if _time>self.SaveBigLightScaleTime+1 and _time<self.SaveBigLightScaleTime+1+.3 then
				ForceFlashLightOn=1
			end
		end
	end

	if (self.NextCheckFlashLightTime and _time>self.NextCheckFlashLightTime+tonumber(5)*60) or ForceFlashLightOn then
		self.NextCheckFlashLightTime=nil
	end
	if not self.NextCheckFlashLightTime then
		-- System:Log(self:GetName()..": LightScale: "..LightScale..", TotalLightScale: "..self.TotalLightScale)
		local LogOn
		if UI then LogOn=1 end
		if self.TotalLightScale <= LightScale or ForceFlashLightOn then
			-- if not self.cnt.SwitchFlashLight then -- Так почему-то не определяет.
			if not self.FlashLightOn or ForceFlashLightOn then
			-- if self.FlashLightActive==0 or ForceFlashLightOn then
				self.FlashLightOn=1
				if self.IsIndoor and self.FirstCheck then -- Только ли внутри говорить?
					if ForceFlashLightOn then -- Исправить: крикнул "Ничего не вижу" сразу после активации. self.FirstCheck может помочь.
						self:Readibility("ROOM_DARK_2",1)
						System:Log(self:GetName()..": ROOM_DARK_2")
					else
						self:Readibility("ROOM_DARK_1",1)
						System:Log(self:GetName()..": ROOM_DARK_1")
					end
				end
				if random(1,2)==1 then
					-- if self.cnt.has_flashlight==0 then
						self.cnt:GiveFlashLight(1)
					-- end
					self.cnt:SwitchFlashLight(1)
					if LogOn then
						System:Log(self:GetName()..": FLASHLIGHT ON")
					end
				end
			end
		-- elseif self.TotalLightScale > .9 then -- .75
		else
			if self.FlashLightOn then
			-- if self.FlashLightActive==1 then
				self.FlashLightOn=nil
				self.cnt:SwitchFlashLight(0)
				if LogOn then
					System:Log(self:GetName().." FLASHLIGHT OFF")
				end
			end
		end
	end
	if not self.FirstCheck then -- Чтобы не глючило в редакторе.
		self.FirstCheck=1
	else
		if not self.NextCheckFlashLightTime then self.NextCheckFlashLightTime=_time  end -- Успевает спалиться в игре игроком.
	end
end

function BasicAI:SeenTimer()
	local att_target = AI:GetAttentionTargetOf(self.id)
	-- if self.IsAiPlayer and self==_localplayer then
		-- if att_target then
			-- if type(att_target)=="number" then
				-- Hud:AddMessage(self:GetName()..": att_target: "..att_target..", type: "..type(att_target))
			-- else
				-- Hud:AddMessage(self:GetName()..": att_target: "..att_target:GetName()..", type: "..type(att_target))
			-- end
		-- else
			-- Hud:AddMessage(self:GetName()..": att_target: nil")
		-- end
	-- end
	if not att_target or (type(att_target)=="number" and att_target==200) then
		if not self.not_sees_timer_start2 then self.not_sees_timer_start2=_time end
		-- Hud:AddMessage(self:GetName()..": self.not_sees_timer_start2: "..self.not_sees_timer_start2)
	else
		self.not_sees_timer_start2=nil
	end
	if self.not_sees_timer_start~=0 or (self.IsAiPlayer and self.not_sees_timer_start2) then -- СЛИШКОМ РАНО GO_FOLLOW СРАБАТЫВАЕТ. Когда цель только-только была потеряна.
		self.heads_up_guys = nil
		local TargetLost
		if self.IsAiPlayer then
			-- if self==_localplayer then
				-- Hud:AddMessage(self:GetName()..": if self.IsAiPlayer 1")
				-- System:Log(self:GetName()..": if self.IsAiPlayer 1")
			-- end
			if not self.not_sees_timer_start2 then return end
			-- if self==_localplayer then
				-- Hud:AddMessage(self:GetName()..": if self.IsAiPlayer 2")
				-- System:Log(self:GetName()..": if self.IsAiPlayer 2")
			-- end
			-- -- Hud:AddMessage(self:GetName()..": Timer Start: "..self.not_sees_timer_start2..", Time: ".._time)
			-- -- -- if self~=_localplayer then
				-- -- if _time>self.not_sees_timer_start+1 and _time<self.not_sees_timer_start+1+.3 then
					-- -- System:Log(self:GetName()..": SeenTimer/1 sekynda")
					-- -- self.allow_search = 1
					-- -- self.allow_idle = 1
					-- -- self.AiPlayerAllowSearchGun=nil
					-- -- AI:Signal(0,1,"NOT_DANGER",self.id)
				-- -- elseif _time>self.not_sees_timer_start+10 and _time<self.not_sees_timer_start+10+.3 then
					-- -- System:Log(self:GetName()..": SeenTimer/10 sekynd")
					-- -- AI:Signal(0,1,"RETURN_TO_NORMAL",self.id)
					-- -- self.heads_up_guys = nil
					-- -- self.no_MG = nil
					-- -- if self.SaveIdSeen~=self.SaveIdKilled then -- Болтать только если последняя увиденная им цель не была им убита. Добавив возможность видеть трупы нужно сделать чтобы отмечалось, что последняя цель убита.
						-- -- AI:Signal(0,1,"TARGET_LOST",self.id)
					-- -- end
					-- -- if self.Properties.horizontal_fov then
						-- -- self:ChangeAIParameter(AIPARAM_FOV,self.Properties.horizontal_fov)
						-- -- self.CurrentHorizontalFov=self.Properties.horizontal_fov  -- Лучше переделать эту перемменную, под максимально возможный FOV.
					-- -- end
					-- -- AI:Signal(0,1,"NOT_DANGER",self.id)
				-- -- elseif _time>self.not_sees_timer_start+20 and _time<self.not_sees_timer_start+20+.3 then
					-- -- System:Log(self:GetName()..": SeenTimer/20 sekynd")
					-- -- AI:Signal(0,1,"RETURN_TO_NORMAL",self.id)
					-- -- -- if _time>self.not_sees_timer_start+3*60 then -- Иногда получается так, что функция "без цели" уже была вызвана, но поведение выбрано другое. Это крайнее исправление.
						-- -- -- self:TriggerEvent(AIEVENT_CLEAR)  -- Проверить, когда ищет оружие.
					-- -- -- end
					-- -- self.allow_search = 1 -- Иногда проскакивало.
					-- -- self.allow_idle = 1
					-- -- -- self.not_sees_timer_start = 0
					-- -- -- self.AiPlayerAllowSearchGun=1
					-- -- AI:Signal(0,1,"NOT_DANGER",self.id)
					-- -- AI:Signal(0,1,"GO_FOLLOW",self.id)
				-- -- elseif _time>self.not_sees_timer_start+30 and _time<self.not_sees_timer_start+30+.3 then
					-- -- System:Log(self:GetName()..": SeenTimer/30 sekynd")
					-- -- AI:Signal(0,1,"RETURN_TO_NORMAL",self.id)
					-- -- AI:Signal(0,1,"NOT_DANGER",self.id)
					-- -- AI:Signal(0,1,"GO_FOLLOW",self.id)
				-- -- elseif _time>self.not_sees_timer_start+40 then
					-- -- System:Log(self:GetName()..": SeenTimer/40 sekynd")
					-- -- AI:Signal(0,1,"RETURN_TO_NORMAL",self.id)
					-- -- self.not_sees_timer_start = 0
					-- -- AI:Signal(0,1,"NOT_DANGER",self.id)
					-- -- AI:Signal(0,1,"GO_FOLLOW",self.id)
				-- -- end
			-- -- -- else
				-- -- -- if _time>self.not_sees_timer_start+1*60 and _time<self.not_sees_timer_start+1*60+.3 then
					-- -- -- System:Log(self:GetName()..": SeenTimer/1 minyta")
					-- -- -- self.allow_search = 1
				-- -- -- elseif _time>self.not_sees_timer_start+2*60 then
					-- -- -- System:Log(self:GetName()..": SeenTimer/2 minyti")
					-- -- -- self.allow_search = 1  -- Иногда проскакивало.
					-- -- -- self.allow_idle = 1
					-- -- -- self.not_sees_timer_start = 0
				-- -- -- end
			-- -- -- end

				-- -- if _time>self.not_sees_timer_start+1 and _time<self.not_sees_timer_start+1+.3 then
					-- -- System:Log(self:GetName()..": SeenTimer/1 sekynda")
					-- -- self.allow_search = 1
					-- -- self.allow_idle = 1
					-- -- self.AiPlayerAllowSearchGun=nil
					-- -- self.heads_up_guys = nil
					-- -- self.no_MG = nil
					-- -- AI:Signal(0,1,"RETURN_TO_NORMAL",self.id)
					-- -- AI:Signal(0,1,"NOT_DANGER",self.id)
					-- -- if self.Properties.horizontal_fov then
						-- -- self:ChangeAIParameter(AIPARAM_FOV,self.Properties.horizontal_fov)
						-- -- self.CurrentHorizontalFov=self.Properties.horizontal_fov  -- Лучше переделать эту перемменную, под максимально возможный FOV.
					-- -- end
					-- -- AI:Signal(0,1,"GO_FOLLOW",self.id)
				-- -- elseif _time>self.not_sees_timer_start+10 and _time<self.not_sees_timer_start+10+.3 then
					-- -- System:Log(self:GetName()..": SeenTimer/10 sekynd")
					-- -- if self.SaveIdSeen~=self.SaveIdKilled then -- Болтать только если последняя увиденная им цель не была им убита. Добавив возможность видеть трупы нужно сделать чтобы отмечалось, что последняя цель убита.
						-- -- AI:Signal(0,1,"TARGET_LOST",self.id)
					-- -- end
					-- -- AI:Signal(0,1,"GO_FOLLOW",self.id)
					-- -- self.not_sees_timer_start = 0
				-- -- end

				-- -- if _time>self.not_sees_timer_start+1 and _time<self.not_sees_timer_start+1+.3 then
					-- -- System:Log(self:GetName()..": SeenTimer/1 sekynda")
					-- -- self.allow_search = 1
					-- -- -- self.allow_idle = 1
					-- -- self.AiPlayerAllowSearchGun=nil
					-- -- AI:Signal(0,1,"NOT_DANGER",self.id)
				-- -- elseif _time>self.not_sees_timer_start+10 and _time<self.not_sees_timer_start+10+.3 then
					-- -- System:Log(self:GetName()..": SeenTimer/10 sekynd")
					-- -- AI:Signal(0,1,"RETURN_TO_NORMAL",self.id)
					-- -- self.heads_up_guys = nil
					-- -- self.no_MG = nil
					-- -- if self.SaveIdSeen~=self.SaveIdKilled then -- Болтать только если последняя увиденная им цель не была им убита. Добавив возможность видеть трупы нужно сделать чтобы отмечалось, что последняя цель убита.
						-- -- AI:Signal(0,1,"TARGET_LOST",self.id)
					-- -- end
					-- -- if self.Properties.horizontal_fov then
						-- -- self:ChangeAIParameter(AIPARAM_FOV,self.Properties.horizontal_fov)
						-- -- self.CurrentHorizontalFov=self.Properties.horizontal_fov  -- Лучше переделать эту перемменную, под максимально возможный FOV.
					-- -- end
				-- -- elseif _time>self.not_sees_timer_start+20 then
					-- -- System:Log(self:GetName()..": SeenTimer/20 sekynd")
					-- -- AI:Signal(0,1,"RETURN_TO_NORMAL",self.id)
					-- -- -- if _time>self.not_sees_timer_start+3*60 then -- Иногда получается так, что функция "без цели" уже была вызвана, но поведение выбрано другое. Это крайнее исправление.
						-- -- -- self:TriggerEvent(AIEVENT_CLEAR)  -- Проверить, когда ищет оружие.
					-- -- -- end
					-- -- self.allow_search = 1 -- Иногда проскакивало.
					-- -- self.allow_idle = 1
					-- -- self.not_sees_timer_start = 0
					-- -- -- self.AiPlayerAllowSearchGun=1
					-- -- AI:Signal(0,1,"NOT_DANGER",self.id)
					-- -- AI:Signal(0,1,"GO_FOLLOW",self.id)
				-- -- end

				-- if _time>self.not_sees_timer_start2+1 and _time<self.not_sees_timer_start2+1+.3 then
					-- System:Log(self:GetName()..": SeenTimer/1 sekynda")
					-- self.allow_search = 1
					-- -- self.allow_idle = 1
					-- self.AiPlayerAllowSearchGun=nil
					-- AI:Signal(0,1,"NOT_DANGER",self.id)
				-- elseif _time>self.not_sees_timer_start2+10 and _time<self.not_sees_timer_start2+10+.3 then
					-- System:Log(self:GetName()..": SeenTimer/10 sekynd")
					-- -- AI:Signal(0,1,"RETURN_TO_NORMAL",self.id)
					-- -- self.heads_up_guys = nil
					-- self.no_MG = nil
					-- if self.SaveIdSeen~=self.SaveIdKilled then -- Болтать только если последняя увиденная им цель не была им убита. Добавив возможность видеть трупы нужно сделать чтобы отмечалось, что последняя цель убита.
						-- AI:Signal(0,1,"TARGET_LOST",self.id)
					-- end
					-- AI:Signal(0,1,"NOT_DANGER",self.id)
					-- if self.Properties.horizontal_fov then
						-- self:ChangeAIParameter(AIPARAM_FOV,self.Properties.horizontal_fov)
						-- self.CurrentHorizontalFov=self.Properties.horizontal_fov  -- Лучше переделать эту перемменную, под максимально возможный FOV.
					-- end
				-- elseif _time>self.not_sees_timer_start2+20 and _time<self.not_sees_timer_start2+20+.3 then
					-- System:Log(self:GetName()..": SeenTimer/20 sekynd")
					-- -- AI:Signal(0,1,"RETURN_TO_NORMAL",self.id)
					-- -- if _time>self.not_sees_timer_start2+3*60 then -- Иногда получается так, что функция "без цели" уже была вызвана, но поведение выбрано другое. Это крайнее исправление.
						-- -- self:TriggerEvent(AIEVENT_CLEAR)  -- Проверить, когда ищет оружие.
					-- -- end
					-- self.allow_search = 1 -- Иногда проскакивало.
					-- self.allow_idle = 1
					-- -- self.AiPlayerAllowSearchGun=1
					-- AI:Signal(0,1,"NOT_DANGER",self.id)
				-- elseif _time>self.not_sees_timer_start2+21 and _time<self.not_sees_timer_start2+21+.3 then
					-- AI:Signal(0,1,"RETURN_TO_NORMAL",self.id)
					-- AI:Signal(0,1,"GO_FOLLOW",self.id)
					-- -- Hud:AddMessage(self:GetName()..": GO_FOLLOW 1")
					-- -- System:Log(self:GetName()..": GO_FOLLOW 1")
				-- -- elseif _time>self.not_sees_timer_start2+22 then -- Тут ещё первый not_sees есть...
				-- elseif _time>self.not_sees_timer_start2+22 and _time<self.not_sees_timer_start2+22+.3 then
					-- AI:Signal(0,1,"RETURN_TO_NORMAL",self.id)
					-- -- System:Log(self:GetName()..": SeenTimer > 20 sekynd")
					-- -- -- Hud:AddMessage(self:GetName()..": GO_FOLLOW")
					-- -- if not self.FollowThrough then
						-- -- self.FollowThrough = 0
						-- self.AllowSayNoTarget = nil
						-- AI:Signal(0,1,"GO_FOLLOW",self.id)
						-- -- Hud:AddMessage(self:GetName()..": GO_FOLLOW")
						-- System:Log(self:GetName()..": GO_FOLLOW")
					-- -- end
					-- -- self.FollowThrough = self.FollowThrough+1
					-- -- if self.FollowThrough >= 5 then self.FollowThrough = nil end
				-- elseif _time>self.not_sees_timer_start2+23 and self.sees==1 then
					-- self.sees=0
					-- AI:Signal(0,1,"GO_FOLLOW",self.id)
					-- -- Hud:AddMessage(self:GetName()..": GO_FOLLOW 2!!!!!!")
					-- System:Log(self:GetName()..": GO_FOLLOW 2!!!!!!")
				-- end


				if _time>self.not_sees_timer_start2+1 and _time<self.not_sees_timer_start2+1+.3 then
					-- Hud:AddMessage(self:GetName()..": SeenTimer/1 sekynda")
					System:Log(self:GetName()..": SeenTimer/1 sekynda")
					-- self.allow_search = 1
					-- self.allow_idle = 1 -- Должно быть именно здесь. Счёт таймера иногда вдруг перывается, но одна секунда успевает выполниться.
					self.AiPlayerAllowSearchGun = nil
					AI:Signal(0,1,"NOT_DANGER",self.id)
					self.no_MG = nil
					if self.SaveIdSeen~=self.SaveIdKilled then -- Болтать только если последняя увиденная им цель не была им убита. Добавив возможность видеть трупы нужно сделать чтобы отмечалось, что последняя цель убита.
						AI:Signal(0,1,"TARGET_LOST",self.id)
					end
					if self.Properties.horizontal_fov then
						self:ChangeAIParameter(AIPARAM_FOV,self.Properties.horizontal_fov)
						self.CurrentHorizontalFov=self.Properties.horizontal_fov  -- Лучше переделать эту перемменную, под максимально возможный FOV.
					end
				elseif _time>self.not_sees_timer_start2+10 and _time<self.not_sees_timer_start2+10+.3 then
					-- Hud:AddMessage(self:GetName()..": SeenTimer/10 sekynd (GO_FOLLOW)")
					-- System:Log(self:GetName()..": SeenTimer/10 sekynd (GO_FOLLOW)")
					System:Log(self:GetName()..": SeenTimer/10 sekynd")
					AI:Signal(0,1,"RETURN_TO_NORMAL",self.id)
					-- AI:Signal(0,1,"GO_FOLLOW",self.id)
					self.AllowSayNoTarget = nil
					self.allow_search = 1
					-- self.allow_idle = 1
					-- AI:Signal(0,1,"GO_FOLLOW",self.id)
					-- Hud:AddMessage(self:GetName()..": GO_FOLLOW")
					-- System:Log(self:GetName()..": GO_FOLLOW")
				-- elseif _time>self.not_sees_timer_start2+5 and self.sees==1 then
				elseif _time>self.not_sees_timer_start2+15 and (_time<self.not_sees_timer_start2+15+.3 or self.sees==1) then
				-- elseif _time>self.not_sees_timer_start2+5 and self.sees~=0 then
					-- Hud:AddMessage(self:GetName()..": SeenTimer/15 sekynd (GO_FOLLOW 2 !!!!!!!)")
					System:Log(self:GetName()..": SeenTimer/15 sekynd (GO_FOLLOW 2 !!!!!!!)")
					self.sees = 0
					-- self.allow_search = 1 -- Проверка!
					self.allow_idle = 1
					self.AiPlayerAllowSearchGun = 1
					AI:Signal(0,1,"GO_FOLLOW",self.id)
					-- Hud:AddMessage(self:GetName()..": GO_FOLLOW 2!!!!!!")
					-- System:Log(self:GetName()..": GO_FOLLOW 2!!!!!!")
				end
		elseif self.IsSpecOpsMan then -- Пушку, они должны искать пушку.
			if _time>self.not_sees_timer_start+.2*60 and _time<self.not_sees_timer_start+.2*60+.3 then
				AI:Signal(0,1,"RETURN_TO_NORMAL",self.id)
				-- self.heads_up_guys = nil
				self.no_MG = nil
				if self.SayFirstContact and self.SaveIdSeen~=self.SaveIdKilled then
					AI:Signal(0,1,"TARGET_LOST",self.id)
				end
				if self.Properties.horizontal_fov then
					self:ChangeAIParameter(AIPARAM_FOV,self.Properties.horizontal_fov)
					self.CurrentHorizontalFov=self.Properties.horizontal_fov
				end
				-- self:Event_Lead()
			elseif _time>self.not_sees_timer_start+1*60 then -- В минутах.
				AI:Signal(0,1,"RETURN_TO_NORMAL",self.id)
				self.allow_search = 1
				self.allow_idle = 1  -- INTERESTED_TO_IDLE будет здесь.
				self.not_sees_timer_start = 0
				self.SayFirstContact = nil
				self.SayFirstThreateningSound = nil
				AI:Signal(0,1,"NOT_DANGER",self.id)
				-- self:Event_Lead()
			end
		else
			if _time>self.not_sees_timer_start+.5*60 and _time<self.not_sees_timer_start+.5*60+.3 then
				System:Log(self:GetName()..": SeenTimer/.5 minyt")
				AI:Signal(0,1,"RETURN_TO_NORMAL",self.id)
				-- self.heads_up_guys = nil
				self.no_MG = nil
				-- if not self.SaveIdSeen or (self.SaveIdSeen~=self.SaveIdKilled) then
				if (not self.SaveIdSeen or self.SaveIdSeen~=self.SaveIdKilled) and self.WasInCombat then
					-- if not self.SaveIdSeen then self.SaveIdSeen="nil" end
					-- if not self.SaveIdKilled then self.SaveIdKilled="nil" end
					-- Hud:AddMessage(self:GetName()..": self.SaveIdSeen: "..self.SaveIdSeen..", self.SaveIdKilled: "..self.SaveIdKilled)
					-- if self.SaveIdSeen=="nil" then self.SaveIdSeen=nil end
					-- if self.SaveIdKilled=="nil" then self.SaveIdKilled=nil end
					AI:Signal(0,1,"TARGET_LOST",self.id)
				end
				if self.Properties.horizontal_fov then
					self:ChangeAIParameter(AIPARAM_FOV,self.Properties.horizontal_fov)
					self.CurrentHorizontalFov=self.Properties.horizontal_fov
				end
			elseif _time>self.not_sees_timer_start+1*60 and _time<self.not_sees_timer_start+1*60+.3 then -- В минутах.
				System:Log(self:GetName()..": SeenTimer/1 minyta")
				AI:Signal(0,1,"RETURN_TO_NORMAL",self.id)
				self.allow_search = 1
				AI:Signal(0,1,"NOT_DANGER",self.id)
			elseif _time>self.not_sees_timer_start+5*60 then
				System:Log(self:GetName()..": SeenTimer/5 minyt")
				self.allow_idle = 1
				self.not_sees_timer_start = 0
			end
		end
	elseif self.FirstState or self.Behaviour.Name and strfind(self.Behaviour.Name,"Idle") then
		self.allow_search = nil
		self.allow_idle = nil
		self.FirstState = nil
	end
end

function BasicAI:MakeMissionConversation(InPlace)
	if self.Properties.special==1 or self.MUTANT or self.ANIMAL then return nil end
	local FindObjectRadius = 6 -- 3
	local CommrangeRadius = 8
	if not self.IsIndoor then FindObjectRadius=10 CommrangeRadius=15 end
	if InPlace then
		local name = AI:FindObjectOfType(self.id,FindObjectRadius,AIAnchor.MISSION_TALK_INPLACE)
		if not name then name = AI:FindObjectOfType(self.id,FindObjectRadius,AIAnchor.AIANCHOR_MISSION_TALK) end
		if name then
			if not self.CurrentConversation and not self.RunToTrigger and not self.SetAlerted and not self.WasInCombat then
				self.CurrentConversation = AI_ConvManager:GetRandomCriticalConversation(name,1)
				if self.CurrentConversation then
					-- System:Log(self:GetName()..": REQUEST")
					self.CurrentConversation:Join(self)
					self:ChangeAIParameter(AIPARAM_COMMRANGE,CommrangeRadius)
					AI:Signal(SIGNALFILTER_ANYONEINCOMM,0,"PRE_CONVERSATION_REQUEST",self.id)
					self:ChangeAIParameter(AIPARAM_COMMRANGE,self.Properties.commrange)
					return 1
				end
			end
		end
	else
		local name = AI:FindObjectOfType(self.id,FindObjectRadius,AIAnchor.MISSION_TALK_INPLACE)
		if name then
			if not self.CurrentConversation then
				self.CurrentConversation = AI_ConvManager:GetRandomCriticalConversation(name,1)
				if self.CurrentConversation then
					self.CurrentConversation:Join(self)
					self:ChangeAIParameter(AIPARAM_COMMRANGE,CommrangeRadius)
					AI:Signal(SIGNALFILTER_ANYONEINCOMM,0,"PRE_CONVERSATION_REQUEST",self.id)
					return 1
				end
			end
		end
		name = AI:FindObjectOfType(self.id,FindObjectRadius,AIAnchor.AIANCHOR_MISSION_TALK)
		if name then
			if not self.CurrentConversation then
				self.CurrentConversation = AI_ConvManager:GetRandomCriticalConversation(name)
				if self.CurrentConversation then
					self.CurrentConversation:Join(self)
					self:ChangeAIParameter(AIPARAM_COMMRANGE,CommrangeRadius)
					-- if self.CurrentConversation.IN_PLACE then
					AI:Signal(SIGNALFILTER_ANYONEINCOMM,0,"PRE_CONVERSATION_REQUEST",self.id)
					self:ChangeAIParameter(AIPARAM_COMMRANGE,self.Properties.commrange)
					return 1
				end
			end
		end
	end
	return nil
end

function BasicAI:MakeRandomConversation(InPlace)
	if self.Properties.special==1  or self.MUTANT or self.ANIMAL then return nil end
	local FindObjectRadius = 6 -- 3
	local CommrangeRadius = 8
	if not self.IsIndoor then FindObjectRadius=10 CommrangeRadius=15 end
	if InPlace and not self.RunToTrigger and not self.SetAlerted then
		if not self.CurrentConversation then
			self.CurrentConversation = AI_ConvManager:GetRandomIdleConversation(1)
			if self.CurrentConversation then
				self.CurrentConversation:Join(self)
				self:ChangeAIParameter(AIPARAM_COMMRANGE,CommrangeRadius)
				AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"PRE_CONVERSATION_REQUEST",self.id)
				self:ChangeAIParameter(AIPARAM_COMMRANGE,self.Properties.commrange)
				return 1
			end
		end
	else
		local name = AI:FindObjectOfType(self.id,FindObjectRadius,AIAnchor.AIANCHOR_RANDOM_TALK) -- 3
		if name then
			if not self.CurrentConversation then
				self.CurrentConversation = AI_ConvManager:GetRandomIdleConversation()
				if self.CurrentConversation then
					self.CurrentConversation:Join(self)
					self:ChangeAIParameter(AIPARAM_COMMRANGE,CommrangeRadius)
					AI:Signal(SIGNALFILTER_ANYONEINCOMM,0,"PRE_CONVERSATION_REQUEST",self.id)
					self:ChangeAIParameter(AIPARAM_COMMRANGE,self.Properties.commrange)
					return 1
				end
			end
		end
	end
	return nil
end

function BasicAI:CreateTagPoint(name,entity)
	if not Game.CreateTagPoint then return nil end
	local GetPoint = Game:GetTagPoint(name)
	local AlreadyCreated
	if GetPoint then
		AlreadyCreated = 1
	else
		if not entity then entity = self end
		Game:CreateTagPoint(name,entity:GetPos(),entity:GetAngles()) -- Возвращает еденицу.
		GetPoint = Game:GetTagPoint(name)
	end
	if GetPoint then
		-- System:Log(entity:GetName()..": CreateTagPoint: "..name..", GetPoint: "..GetPoint.x..", "..GetPoint.y..", "..GetPoint.z)
		if AlreadyCreated then
			return 2
		else
			return 1
		end
	end
	return nil
end

function BasicAI:RemoveTagPoint(name)
	return Game:RemoveTagPoint(name)
end

function BasicAI:ComeToMe(entity) -- Join и Continue
	if self:CreateTagPoint(self:GetName().."_CONVERSATION")~=2 then
		-- System:Log(self:GetName()..": ComeToMe! CreateTagPoint!")
	end
	self:SelectPipe(0,"stand_timer2",entity.id) -- После одной из загрузок entity почему-то было nil.
	self:InsertSubpipe(0,"simple_approach_to2",entity.id)
end

function BasicAI:Say(phrase,AIConvTable) -- Обычные разговоры о том, о сём...
	-- if phrase then
		-- -- System:Log(self:GetName()..": Saying: "..phrase.soundFile)
		-- -- self:SayDialog(phrase.soundFile,phrase.Volume,phrase.min,phrase.max,SOUND_RADIUS,AIConvTable)
		-- if tonumber(getglobal("s_EnableSoundFX"))==1 then -- EAX
			-- self:SayDialog(phrase.soundFile,phrase.Volume,phrase.min,phrase.max,SOUND_RADIUS,AIConvTable)
		-- else
			-- self:SayDialog(phrase.soundFile,0,phrase.min,phrase.max,SOUND_RADIUS,AIConvTable)
			-- BasicPlayer.SayWord(self,phrase.soundFile,0,phrase.Volume,phrase.min,phrase.max)
		-- end
		-- local SoundEventRadius=(phrase.min+phrase.max)/2
		-- local Pos = self:GetBonePos("Bip01 Head")
		-- AI:SoundEvent(self.id,Pos,SoundEventRadius,0,1,self.id)
		-- -- Hud:AddMessage(self:GetName()..": PlaySound: "..phrase.soundFile..", SoundEventRadius: "..SoundEventRadius)
		-- -- System:Log(self:GetName()..": PlaySound: "..phrase.soundFile..", SoundEventRadius: "..SoundEventRadius)
	-- end
end


function BasicAI:SayDialogAi(phrase,AIConvTable)
	-- self.PlayTestSound = 1 -- Тестовый звук. Результат в self.SoundMS. С++
	if phrase then
		-- System:Log(self:GetName()..": Saying: "..phrase.soundFile)
		-- -- self:SayDialog(phrase.soundFile,phrase.Volume,phrase.min,phrase.max,SOUND_RADIUS,AIConvTable)
		-- -- if tonumber(getglobal("s_EnableSoundFX"))==1 then -- EAX
			-- -- self:SayDialog(phrase.soundFile,phrase.Volume,phrase.min,phrase.max,SOUND_RADIUS,AIConvTable)
		-- -- else
			-- -- self:SayDialog(phrase.soundFile,0,phrase.min,phrase.max,SOUND_RADIUS,AIConvTable)
			BasicPlayer.SayDialogWord(self,phrase.soundFile,0,phrase.Volume,phrase.min,phrase.max)
		-- -- end
		local SoundEventRadius=(phrase.min+phrase.max)/2
		local Pos = self:GetBonePos("Bip01 Head")
		AI:SoundEvent(self.id,Pos,SoundEventRadius,0,1,self.id)
		-- -- Hud:AddMessage(self:GetName()..": PlaySound: "..phrase.soundFile..", SoundEventRadius: "..SoundEventRadius)
		-- -- System:Log(self:GetName()..": PlaySound: "..phrase.soundFile..", SoundEventRadius: "..SoundEventRadius)
	end
end

function BasicAI:Readibility(signal,bSkipGroupCheck)
	if not bSkipGroupCheck then
		if self:GetGroupCount() > 1 then
			AI:Signal(SIGNALID_READIBILITY,1,signal.."_GROUP",self.id)
		else
			AI:Signal(SIGNALID_READIBILITY,1,signal,self.id)
		end
	else
		AI:Signal(SIGNALID_READIBILITY,1,signal,self.id)
	end
end

function BasicAI:StopSounds()
	Sound:StopSound(self.chattering_on)
	Sound:StopSound(self.LastLandSound)
	Sound:StopSound(self.LastJumpSound)
	if (self.footsteparray) then
		for i,footstep in self.footsteparray do
			Sound:StopSound(footstep)
		end
	end
end

function BasicAI:Event_AcceptSound(sender)
	if (sender) then
		if (sender.type=="SoundSpot") then
			self.ACCEPTED_SOUND = {}
			self.ACCEPTED_SOUND.soundFile = sender.Properties.sndSource
			self.ACCEPTED_SOUND.Volume = sender.Properties.iVolume
			self.ACCEPTED_SOUND.min = sender.Properties.InnerRadius
			self.ACCEPTED_SOUND.max = sender.Properties.OuterRadius
			self:Say(self.ACCEPTED_SOUND)
		else
			--System:Log("\001 NOT A SOUND "..sender.type)
		end
	end
	BroadcastEvent(self,"AcceptSOund")
end

function BasicAI:RushTactic(probability)
	if (self.Properties.fRushPercentage) then
		if (self.Properties.fRushPercentage>0) then
			local percent = self.cnt.health / self.Properties.max_health
			if (percent<self.Properties.fRushPercentage) then
				local rnd=random(1,10)
				if (rnd>probability) then
					AI:Signal(SIGNALFILTER_SUPERGROUP,1,"RUSH_TARGET",self.id)
					-- AI:Signal(SIGNALID_READIBILITY,1,"LO_RUSH_TACTIC",self.id)
				end
			end
		end
	end
end

-- function BasicAI:S_OnUpdate(DeltaTime)
	-- self:SetScriptUpdateRate(0)
	-- Hud:AddMessage(self:GetName()..": Update")
-- end


BasicAI.Server =
{
	OnInit = BasicAI.Server_OnInit,
	OnShutdown = function(self)
	end,
	Alive = {
--		OnTimer = BasicPlayer.Server_OnTimer,
		OnUpdate = BasicPlayer.Server_OnTimer,
		-- OnUpdate = function(self)
			-- BasicAI.S_OnUpdate(self)
			-- BasicPlayer.Server_OnTimer(self)
		-- end,
		OnBeginState = function(self)
		end,
		OnEndState = function(self)
		end,
--		OnUpdate = BasicAI.OnUpdate,
		OnEvent = BasicPlayer.Server_OnEvent,
		OnDamage = function(self,hit)
			if not self.Behaviour then return end -- Когда в редакторе включаю ИИ игрока и вызывается OnDamage...
			if self.Properties.fDamageMultiplier then
				hit.damage = hit.damage * self.Properties.fDamageMultiplier
			end
			if self.Properties.bInvulnerable~=1 or self.IsAiPlayer then
				BasicPlayer.Server_OnDamage(self,hit)
			end

			if self.Behaviour.OnKnownDamage and hit.shooter then
				self.Behaviour:OnKnownDamage(self,hit.shooter)
			else
				AI:Signal(0,1,"OnReceivingDamage",self.id)
			end

			if self.LastDamageDoneByPlayer then
				if hit.damage_type=="normal" and hit.explosion==nil and hit.fire==nil and hit.drowning==nil then
					AI:RegisterPlayerHit()
				end
			end
			self.dmg_percent = self.cnt.health / self.Properties.max_health
			if self.dmg_percent<.5 then
				self:Event_HalfHealthLeft()
			end
			if self.dmg_percent<=.3 and not self.critical_status then
				self.critical_status = 1
				if self.IsAiPlayer then
					if self:GetDistanceFromPoint(_localplayer:GetPos()) <= 30+random(0,30) and self.dmg_percent > 0 then
						local Chat
						local rnd = random(1,14)
						if rnd==1 then
							Chat = "@IGotShot"
						elseif rnd==2 then
							Chat = "@IAmGoingToDie"
						elseif rnd==3 then
							Chat = "@IUrgentlyNeedAFirstAidKit"
						elseif rnd==4 then
							Chat = "@UrgentlyNeedAFirstAidKit"
						elseif rnd==5 then
							Chat = "@NeedAFirstAidKit"
						elseif rnd==6 then
							Chat = "@FirstAidKit"
						elseif rnd==7 then
							Chat = "@OhHowItHurts"
						elseif rnd==8 then
							Chat = "@IAmBleeding"
						elseif rnd==9 then
							Chat = "@IAmWounded"
						elseif rnd==10 then
							Chat = "@HelpMe"
						elseif rnd==11 then
							Chat = "@Help"
						elseif rnd==12 then
							Chat = "@AhhItHurts"
						elseif rnd==13 then
							Chat = "@ItHurts"
						elseif rnd==14 then
							Chat = "@VeryPainful"
						end
						Hud:AddMessage(self:GetName().."$1: "..Chat)
					end
				end
			elseif self.dmg_percent>.3 and self.critical_status then
				self.critical_status = nil
			end
			self:RushTactic(5)
			self:ChangeAIParameter(AIPARAM_FOV,self.Properties.horizontal_fov)
			self.CurrentHorizontalFov=self.Properties.horizontal_fov
		end,
		OnContact = function(self,contact)
			-- if contact.ai then return end
			BasicPlayer.PlayerContact(self,contact,1)  -- Чтобы ИИ мог оружие с физикой поднимать.
		end,
	},
	Dead = {
		OnBeginState = function(self)
			-- if self.TimeToThrowGrenade then -- Если хотел бросить гранату, но не успел... Забей на эту херню! Он итак, чаще всего, создаёт гранату после смерти!
				-- -- BasicPlayer.SelectGrenade(self,GrenadesClasses[self.cnt.grenadetype])
				-- local SpawnedGrenadeName
				-- for i,val in GrenadesClasses do
					-- if i==self.cnt.grenadetype then
						-- Hud:AddMessage(self:GetName()..": i: "..i..", val: "..val)
						-- System:Log(self:GetName()..": i: "..i..", val: "..val)
						-- SpawnedGrenadeName = val -- Присвоить название типа гранаты, которую нужно создать.
						-- break
					-- end
				-- end
				-- local Grenade = Server:SpawnEntity(SpawnedGrenadeName)
				-- if Grenade and self.cnt.numofgrenades>0 then
					-- self.TimeToThrowGrenade = nil -- Предотвратить выбрасывание обычной гранаты.
					-- self.ThrowGrenadeTime = nil
					-- self.cnt.numofgrenades = self.cnt.numofgrenades-1 -- Уменьшить на одну ещё до сброса гранат с трупа.
					-- Hud:AddMessage(self:GetName()..": Grenade:Launch")
					-- System:Log(self:GetName()..": Grenade:Launch")
					-- Grenade:Launch(nil,self,self:GetPos(),{x=0,y=0,z=0},{x=0,y=0,z=-.001})
				-- end
			-- end
			if self.IsAiPlayer then
				if self~=_localplayer and UI and BasicPlayer.IsAlive(_localplayer) then
					-- Прикольный код из миссии "Болото". Чтобы не было злоупотреблений.
					-- if god then -- Ну я же тестирую...
						-- god=nil
					-- end
					-- local pos=new(self:GetPos())
					-- local ang=new(self:GetAngles())
					-- _localplayer:SetPos(pos) -- Это выглядит некрасиво, и вдвойне не красиво когда игрок до этого умер.
					-- _localplayer:SetAngles(ang)
					Hud:AddMessage("@YourFriendDied")
					_localplayer.timetodie=2
				end
			end
			self:StopConversation()

			local dir = self.deathImpuls
			NormalizeVector(dir)
			if ((dir.z<.15) and (dir.z>-.2)) then
				dir.z = .15
			end
			--self:AddImpulse(1,self:GetCenterOfMassPos(),dir,self.deathImpulseTorso)
			self:AddImpulse(1,{0,0,0},dir,self.deathImpulseTorso)

			-- -- used for Autobalancing
			-- if (self.LastDamageDoneByPlayer) then
				-- self:TriggerEvent(AIEVENT_DROPBEACON)
				-- self:TriggerEvent(AIEVENT_AGENTDIED,1)
			-- else
				self:TriggerEvent(AIEVENT_AGENTDIED)
			-- end

			self.LAST_SHOOTER = nil

			AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"RESUME_SPECIAL_BEHAVIOUR",self.id)

			self:Event_OnDeath()

			if (AI:FindObjectOfType(self.id,40,AIAnchor.RETREAT_WHEN_HALVED)) then
				AI:Signal(SIGNALFILTER_HALFOFGROUP,1,"RETREAT_NOW",self.id)
			end

			-- call the behaviour one last time :(
			if self.Behaviour.OnDeath then
				self.Behaviour:OnDeath(self,self.MyKiller)
			else
				if AIBehaviour[self.DefaultBehaviour] then
					if AIBehaviour[self.DefaultBehaviour].OnDeath then
						AIBehaviour[self.DefaultBehaviour]:OnDeath(self,self.MyKiller)
					else
						AIBehaviour.DEFAULT:OnDeath(self,self.MyKiller)
					end
				end
			end

			AI:DeCloak(self.id)

			if self.ResetStealth and self.MUTANT=="stealth" then self:ResetStealth() end

			if (self.AI_ParticleHandle) then
				Particle:Detach(self.id,self.AI_ParticleHandle)
			end

			if self:GetGroupCount()==0 then
				self:Event_LastGroupMemberDied()
			end

			self:RushTactic(8)

			-- BasicAI.Drop(self,self.Properties.equipDropPack)
			BasicAI.Drop(self)
--			self:Drop(self.Properties.equipDropPack)
			self:SetTimer(self.UpdateTime)
			self:NetPresent(nil)
		end,
		OnEvent = BasicPlayer.Server_OnEventDead,
		OnDamage = function(self,hit)
			BasicPlayer.Server_OnDamageDead(self,hit)
		end,
		OnEndState = function(self)
		end,
	},
}

BasicAI.Client =
{
	OnInit = BasicAI.Client_OnInit,
--	OnShutdown = Player.Client_OnShutDown,
	Alive = {
--		OnTimer = BasicPlayer.Client_OnTimer,
		-- CI BASICAI -- Mixer: MOVED TO HUGE IMPROVE PERFORMANCE
		OnUpdate = function(self)
			BasicPlayer.Client_OnTimer(self)
			if self.chattersounds then
				if self.NextChatterSound > _time then return end
				self.NextChatterSound = _time + random(100,200)*.01
				if self.chattering_on and not Sound:IsPlaying(self.chattering_on) then
					self.chattering_on = nil
				end
				if not self.chattering_on then
					local AiSoundEvent
					if not self.IsCaged then AiSoundEvent = 1 end
					local NewToneChatter
					if self.MUTANT or self.ANIMAL then NewToneChatter = 1 end -- Будет ли меняться тон голоса или нет.
					self.chattering_on = BasicPlayer.PlayOneSound(self,self.chattersounds,50,AiSoundEvent,1,NewToneChatter)
				end
			end
		end,
		OnBeginState = function(self)
--			if (self==_localplayer) then
--				Input:SetActionMap("default")
				self.AnimationSystemEnabled = 1
				self:EnablePhysics(1)
--			end

			-- init local stuff on client
			BasicPlayer.OnBeginAliveState(self)

		end,
		OnEndState = function(self)
		end,

		-- Just temporary
		-- Needed cause the BasicWeapon client update wouldn't be called otherwise.
		-- Since the ending of the client side reloading state is detected there,the
		-- client would never stop reloading,so no more client side effects (sounds,trails)
		-- would be played. Keep until these things are removed from the OnUpdate()
--		OnUpdate = function(self,DeltaTime)
--			BasicPlayer.Client_OnUpdate(self,DeltaTime)
--		end,

		OnDamage = function(self,hit)
			if self.OnDamageCustom then	self:OnDamageCustom() end
 			BasicPlayer.Client_OnDamage(self,hit)
--			AI:Signal(SIGNALID_READIBILITY,1,"PAIN",self.id)
--			BasicPlayer.SetDeathImpulse(self,hit)
		end,
		OnEvent = BasicPlayer.Client_OnEvent,
		OnContact = function(self,contact)
			-- if contact.ai then return end
			BasicPlayer.PlayerContact(self,contact)  -- Чтобы ИИ мог оружие с физикой поднимать.
		end,
	},
	Dead = {
		OnBeginState = function(self)
			BasicPlayer.MakeDeadbody(self)
			self:SetScriptUpdateRate(0)  -- Дубль два? http://verysoft.narod.ru/fcbugfix.htm
			-- if (screenshotmode) then self.IsDedbody = 0  end -- Проверить!
			self.cnt.health=0 		-- server might not send this info

			--stop chatter/jump/land sounds when die
			BasicAI.StopSounds(self)

			-- stop any readibility
			self:StopDialog()

			-- setup local stuff on client
			BasicPlayer.OnBeginDeadState(self)

			if self.OnDamageCustom then	self:OnDamageCustom() end

			-- [marco] reward the player when he makes something cool with a gun
			-- first of all check if it was really the player to kill the AI
			if (0 and self.shooter and self.shooter==_localplayer) then
			-- if (self.shooter and self.shooter==_localplayer) then

				-- check for a headshot
				if self.HeadShot then
					--System:Log("headshot")

					if (not self.shooter.numshots) then
						--System:Log("numshots 0")
						self.shooter.numshots=0
					else
						self.shooter.numshots=self.shooter.numshots+1
						if (self.shooter.numshots>20) then
							self.shooter.numshots=0
						end
						--System:Log("numshots.."..self.shooter.numshots)
					end

					if (self.sndHeadShotComment and self.shooter.numshots==0) then
						Sound:PlaySound(self.sndHeadShotComment)
					end
				end
				coomentedout=[[
				else
				-- check for a long distance shot
					local vPos1=new(self.shooter:GetPos())
					--System:Log("pos1="..vPos1.x..","..vPos1.y..","..vPos1.z)
					local vPos2=new(self:GetPos())
					--System:Log("pos2="..vPos2.x..","..vPos2.y..","..vPos2.z)
					local diff=DifferenceVectors(vPos1,vPos2)
					--System:Log("diff="..diff.x..","..diff.y..","..diff.z)
					local distfromshooter=LengthSqVector(diff)
					--System:Log("DISTANCE="..distfromshooter)
					if (distfromshooter>100*100) then
						--System:Log("VERY LONG DISTANCE SHOT,200+ METERS!")
						if (self.sndFarDistanceShotComment) then
							Sound:PlaySound(self.sndFarDistanceShotComment)
						end
					else
						if (distfromshooter>60*60) then
							--System:Log("LONG DISTANCE SHOT,120+ METERS!")
							if (self.sndLongDistanceShotComment) then
								Sound:PlaySound(self.sndLongDistanceShotComment)
							end
						end
					end
				end
				]]
			end

			-- Release trigger when dying
			local Weapon = self.cnt.weapon
			if Weapon then -- Или это виновато в зависании звука?
				local WeaponStateData = GetPlayerWeaponInfo(self)
				local FireModeNum = WeaponStateData.FireMode
				local CurFireParams = Weapon.FireParams[FireModeNum]
				-- if (CurFireParams.FireOnRelease~=1) then -- Ошибка! CurFireParams = nil, особенно если погиб от взрыва!
				if CurFireParams and CurFireParams.FireOnRelease~=1 then
					local Params = {}
					Params["shooter"] = self
					Params["fire_event_type"] = 2
					BasicWeapon.Client_OnFire(Weapon,Params)
				end
				-- Hud:AddMessage(self:GetName()..": BasicAI OnStopFiring1")
				-- System:Log(self:GetName()..": BasicAI OnStopFiring1")
			end
			-- Может ответ в зависании звука кроется здесь?
			if (self.cnt.health < 1) then
				--self.WeaponState = nil
				--System:Log("------------------------------------> Cleared Sounds !")
				--System:Log("------------------------------------> StopFireLoop Called !")
				local CurWeaponInfo = self.weapon_info
				if (CurWeaponInfo) then
					local CurFireMode = CurWeaponInfo.FireMode
					local CurWeapon = self.cnt.weapon
					local CurFireParams
					if (CurWeapon) then
						CurFireParams = CurWeapon.FireParams[CurFireMode]
					end
					local SoundData = CurWeaponInfo.SndInstances[CurFireMode]
					BasicWeapon.StopFireLoop(CurWeapon,self,CurFireParams,SoundData)
				end
				-- Hud:AddMessage(self:GetName()..": BasicAI OnStopFiring2")
				-- System:Log(self:GetName()..": BasicAI OnStopFiring2")
			end
			self:SetTimer(self.UpdateTime)
			self:SetScriptUpdateRate(0)
			-- BasicPlayer.RegisterAsDeadBody(self)
		end,
		OnUpdate = BasicPlayer.Client_DeadOnUpdate,
		OnEndState = function(self)
		end,
		OnTimer = BasicPlayer.Client_OnTimerDead,

		-- [marco] only event to be updated when the AI is dead is the
		-- eventonwater, as the dead AI can slide and fall into water
		OnEvent = function(self,EventId,Params)
			--System:Log("Event called")
			if (EventId==ScriptEvent_EnterWater) then
				--System:Log("Event enter water detected")
				BasicPlayer.OnEnterWater(self,Params)
			end
		end

	},
}

function BasicAI:Drop()
	-- spawn pickups
	-- They are always spawned at different positions. Otherwise they collide immediately with each
	-- other and don't fall down anymore.
	local Velocity = self:GetVelocity()
	local Direction = self:GetDirectionVector()
	local DeadGuyPos = new(self:GetPos())
	local DeadGuyPosOffsetZ1 = new(DeadGuyPos) -- А как всем троим разом?
	local DeadGuyPosOffsetZ2 = new(DeadGuyPos)
	local DeadGuyPosOffsetZ3 = new(DeadGuyPos)
	DeadGuyPosOffsetZ1.z = DeadGuyPos.z + 1.2
	DeadGuyPosOffsetZ2.z = DeadGuyPos.z + 1 -- Аптечки и другое.
	-- DeadGuyPosOffsetZ3.z = DeadGuyPos.z + 1.8 -- Гранаты.
	-- DeadGuyPosOffsetZ3 = DeadGuyPosOffsetZ2 -- Пока так.
	-- local PlusMinus = 0
	-- while PlusMinus==0 do
		-- PlusMinus = random(-1,1)
	-- end
	local OffsetZ3Y = .1 -- Смещение относительно середины. В принципе оно может быть любым.
	if random(1,2)==1 then
		OffsetZ3Y = -.2
	end
	DeadGuyPosOffsetZ3.x = DeadGuyPos.x-Direction.x*.185 -- Заспавнить позади сущности. Цифры - ближе(-) или дальше(+) от центра.
	DeadGuyPosOffsetZ3.y = (DeadGuyPos.y-Direction.y*.185)+OffsetZ3Y
	DeadGuyPosOffsetZ3.z = DeadGuyPos.z + .95 -- Гранаты.
	-- Mixer: Friends stuck fix
	AI:FreeSignal(1,"RESUME_SPECIAL_BEHAVIOUR",DeadGuyPos,9999) -- Может переделать? Есть ещё один такой же сигнал, его тоже надо переделать.
	-- drop armor
	-- if self.Properties.dropArmor and self.Properties.dropArmor > 0 then
		-- local NewEntity = Server:SpawnEntity("Armor",{x=DeadGuyPosOffsetZ1.x,y=DeadGuyPosOffsetZ1.y,z=DeadGuyPosOffsetZ1.z+.07})
		-- if NewEntity then
			-- NewEntity.Properties.Amount = self.Properties.dropArmor
			-- NewEntity:SetAngles({x=0,y=0,z=self:GetAngles().z})
			-- NewEntity:EnableSave(0)
			-- NewEntity:Physicalize(self)
			-- NewEntity:SetName("Armor_dropped1")
			-- -- NewEntity.Properties.Animation.AvailableWeapon = 1  -- Доделать. Animation-nil
			-- AI:RegisterWithAI(NewEntity.id,AIOBJECT_ARMOR)
		-- end
	-- end
	local Weapon = self.cnt.weapon
	local WeaponsSlots = self.cnt:GetWeaponsSlots()
	if WeaponsSlots then
		for i,New_Weapon in WeaponsSlots do -- i - с каким элементом идёт работа. Число.
			if New_Weapon~=0 then
				local PhysClassID = Game:GetEntityClassIDByClassName("Pickup"..New_Weapon.name.."_p")
				local ClassID = Game:GetEntityClassIDByClassName("Pickup"..New_Weapon.name)
				if PhysClassID and not Game:IsMultiplayer() then
					-- Hud:AddMessage(self:GetName()..": 1 Spawn weapon p: "..New_Weapon.name)
					local NewEntity = Server:SpawnEntity("Pickup"..New_Weapon.name.."_p",DeadGuyPosOffsetZ1)
					-- Hud:AddMessage(self:GetName()..": 2 Spawn weapon p: "..New_Weapon.name)
					if NewEntity and NewEntity.physpickup then
						local AmmoPrimary = 0 -- random(0,NewEntity.Properties.Animation.fAmmo_Primary)
						local AmmoSecondary = 0 -- random(0,NewEntity.Properties.Animation.fAmmo_Secondary)
						local WeaponState = self.WeaponState
						local WeaponInfo = WeaponState[WeaponClassesEx[New_Weapon.name].id]
						if WeaponInfo then
							if NewEntity.Properties.Animation.fAmmo_Primary>0 then
								AmmoPrimary = WeaponInfo.AmmoInClip[1]
							end
							if NewEntity.Properties.Animation.fAmmo_Secondary>0 then
								local New_FireParams = New_Weapon.FireParams
								if New_FireParams[2]
								and New_FireParams[2].AmmoType~=New_FireParams[1].AmmoType then
									AmmoSecondary = WeaponInfo.AmmoInClip[2]
								end
								if New_FireParams[3]
								and New_FireParams[3].AmmoType~=New_FireParams[2].AmmoType
								and New_FireParams[3].AmmoType~=New_FireParams[1].AmmoType then
									AmmoSecondary = WeaponInfo.AmmoInClip[3]
								end
								if New_FireParams[4]
								and New_FireParams[4].AmmoType~=New_FireParams[3].AmmoType
								and New_FireParams[4].AmmoType~=New_FireParams[2].AmmoType
								and New_FireParams[4].AmmoType~=New_FireParams[1].AmmoType then
									AmmoSecondary = WeaponInfo.AmmoInClip[4]
								end
							end
						end
						NewEntity.Properties.Animation.fAmmo_Primary = AmmoPrimary
						NewEntity.Properties.Animation.fAmmo_Secondary = AmmoSecondary
						NewEntity:SetName(New_Weapon.name.."_dropped2")
						NewEntity.Properties.Animation.AvailableWeapon = 1
						AI:RegisterWithAI(NewEntity.id,AIOBJECT_WEAPON)
						if self.GunTableOfRandomTrace and self.GunTableOfRandomTrace[WeaponClassesEx[New_Weapon.name].id]
						and self.GunTableOfRandomTrace[WeaponClassesEx[New_Weapon.name].id].Color and not NewEntity.RandomColor then
							NewEntity.RandomColor = self.GunTableOfRandomTrace[WeaponClassesEx[New_Weapon.name].id].Color
						end
						NewEntity:SetViewDistRatio(255)
						NewEntity.pp_lastdrop = _time + .8

						-- local Velocity = self:GetVelocity()
						-- local Direction = self:GetDirectionVector()
						-- CopyVector(BasicWeapon.temp_v1,Direction)
						-- local dir = BasicWeapon.temp_v1
						-- local dest = BasicWeapon.temp_v2
						-- local pos = SumVectors(self:GetPos(),{x=0,y=0,z=1.5})
						-- dest.x = pos.x + dir.x * 1.5
						-- dest.y = pos.y + dir.y * 1.5
						-- dest.z = pos.z + dir.z * 1.5
						-- local hits = System:RayWorldIntersection(pos,dest,1,ent_terrain+ent_static+ent_rigid+ent_sleeping_rigid,self.id)
						-- if (hits and getn(hits)>0) then
							-- local temp = hits[1].pos
							-- dest.x = temp.x - dir.x * .15
							-- dest.y = temp.y - dir.y * .15
							-- dest.z = temp.z - dir.z * .15
						-- end
						local Ang = self:GetAngles()
						Ang.z = Ang.z-90
						NewEntity:SetAngles(Ang)
						local Pos = self:GetPos()
						local BonePos = self:GetBonePos("weapon_bone")
						NewEntity:SetPos(BonePos)
						NewEntity:AddImpulse(-1,Velocity,Direction,50)
					end
				elseif ClassID then
					-- Hud:AddMessage(self:GetName()..": 1 Spawn weapon: "..New_Weapon.name)
					local NewEntity = Server:SpawnEntity("Pickup"..New_Weapon.name,DeadGuyPosOffsetZ2)
					-- Hud:AddMessage(self:GetName()..": 2 Spawn weapon: "..New_Weapon.name)
					if NewEntity then
						NewEntity:Physicalize(self)
						NewEntity:SetName(New_Weapon.name.."_dropped3")
						-- NewEntity.Properties.Animation.AvailableWeapon = 1
						AI:RegisterWithAI(NewEntity.id,AIOBJECT_WEAPON)
						if self.GunTableOfRandomTrace and self.GunTableOfRandomTrace[WeaponClassesEx[New_Weapon.name].id]
						and self.GunTableOfRandomTrace[WeaponClassesEx[New_Weapon.name].id].Color and not NewEntity.RandomColor then
							NewEntity.RandomColor = self.GunTableOfRandomTrace[WeaponClassesEx[New_Weapon.name].id].Color
						end
					else
						System:Log(self:GetName()..": Failure dropping the entity: "..New_Weapon.name)
					end
				end
			end
		end
	end

	local PackTable = EquipPacks[self.Properties.equipEquipment]
	self:DropItems(PackTable,DeadGuyPosOffsetZ2)
	PackTable = EquipPacks[self.Properties.equipDropPack]
	self:DropItems(PackTable,DeadGuyPosOffsetZ2)
	if self.MERC then
		local GrenadeTable = {"HandGrenade","FlashbangGrenade","SmokeGrenade"} -- Только для этих трёх, чтобы код лишний раз не копировать.
		if Game:IsMultiplayer() then
			for i,val in GrenadeTable do -- Создаёт гранаты. Ровно столько, сколько есть.
				-- System:Log(self:GetName()..": GrenadeTable: "..val.."s"..", i: "..i..", self.Ammo[val]: "..self.Ammo[val])
				if self.Ammo[val]>0 then
					for j=1,self.Ammo[val] do
						local NewEntity = Server:SpawnEntity("Ammo"..val.."s",DeadGuyPosOffsetZ3)
						if NewEntity then
							-- System:Log(self:GetName()..": Spawn grenade: "..val.."s"..", j: "..j)
							NewEntity:Physicalize(self)
							NewEntity:SetName("Ammo"..val.."s".."_dropped5")
							NewEntity.Properties.Amount = 1 -- На всякий случай.
							-- local AddRandomDirection = new(Direction)
							-- AddRandomDirection.x = AddRandomDirection.x+(random(0,2)-1)
							-- AddRandomDirection.y = AddRandomDirection.y+(random(0,2)-1)
							-- AddRandomDirection.z = AddRandomDirection.z+(random(0,2)-1)
							NewEntity:AddImpulse(-1,Velocity,Direction,20)
						end
					end
				end
			end
		else
			for i,val in GrenadeTable do -- Создаёт гранаты. Ровно столько, сколько есть.
				-- System:Log(self:GetName()..": GrenadeTable: "..val.."s"..", i: "..i..", self.Ammo[val]: "..self.Ammo[val])
				if self.Ammo[val]>0 then
					for j=1,self.Ammo[val] do
						local NewEntity = Server:SpawnEntity("Pickup"..val.."s_p",DeadGuyPosOffsetZ3)
						if NewEntity and NewEntity.physpickup then
							NewEntity:SetName("Ammo"..val.."s".."_dropped5")
							NewEntity.Properties.Animation.fAmmo_Primary = 1 -- На всякий случай.
							NewEntity.Properties.Animation.AvailableWeapon = 1
							-- AI:RegisterWithAI(NewEntity.id,AIOBJECT_WEAPON)
							AI:RegisterWithAI(NewEntity.id,AIOBJECT_AMMO)
							NewEntity:SetViewDistRatio(255)
							NewEntity.pp_lastdrop = _time + .8
							-- local AddRandomDirection = new(Direction)
							-- AddRandomDirection.x = AddRandomDirection.x+(random(0,2)-1)
							-- AddRandomDirection.y = AddRandomDirection.y+(random(0,2)-1)
							-- AddRandomDirection.z = AddRandomDirection.z+(random(0,2)-1)
							NewEntity:AddImpulse(-1,Velocity,Direction,.5) -- .1 при весе 600 грамм.
						end
					end
				end
			end
		end
	end

	local HealthTable = {"merc_offcomm.cgf","merc_defcomm.cgf","lead_scientist.cgf","lab_assistant.cgf",} -- ,"evil_worker.cgf"
	-- local HealthTable = {0,0,"lead_scientist.cgf","lab_assistant.cgf","TLAttack2Attack","TLAttack2Idle","TLDefenseIdle"} -- Что-то по поведению не определяет.
	for i,val in HealthTable do -- Создаёт аптечки у указанных моделек.
		if strfind(strlower(self.Properties.fileModel),val) then
		-- if val~=0 and strfind(strlower(self.Properties.fileModel),val) or (self.Behaviour.Name and strfind(strlower(self.Behaviour.Name),val)) then
			local NewEntity = Server:SpawnEntity("Health",DeadGuyPosOffsetZ2)
			if NewEntity then
				-- System:Log(self:GetName()..": Spawn health")
				NewEntity:Physicalize(self)
				NewEntity:SetName("Health_dropped6")
				NewEntity.Properties.Amount=100
				if i==4 then
					NewEntity.Properties.Amount=50
				-- elseif i==5 then
					-- NewEntity.Properties.Amount=20
				end
				AI:RegisterWithAI(NewEntity.id,AIOBJECT_HEALTH)
			end
			break
		end
	end
end

function BasicAI:DropItems(PackTable,Pos)
	if PackTable then
		for i,value in PackTable do
			-- if not value.Type then value.Type="nil" end
			-- if not value.Name then value.Name="nil" end
			-- System:Log(self:GetName()..": value.Name: "..value.Name..",value.Type: "..value.Type)
			-- if value.Type=="nil" then value.Type=nil end
			-- if value.Name=="nil" then value.Name=nil end
			-- if value.Type=="Item" then
			if value.Type=="Item" and value.Name then
				local SkipWeapon
				local SkipAmmo
				-- System:Log(self:GetName()..": Name: "..value.Name)
				for i,val in WeaponClassesEx do
					-- System:Log(self:GetName()..": Name: "..value.Name)
					if value.Name=="Pickup"..i then
						-- System:Log(self:GetName()..": Skip weapon: "..value.Name)
						SkipWeapon = 1
						break
					end

				end
				for i,val in MaxAmmo do
					if value.Name=="Ammo"..i then
						-- System:Log(self:GetName()..": Skip ammo: "..value.Name)
						SkipAmmo = 1
						break
					end
				end
				-- if value.IsDropped then
					-- System:Log("Item is dropped: "..value.Name)
				-- end
				-- local Gadgets -- Добавить сюда карточки когда будут подбираться.
				-- Server:SpawnEntity("PickupFlashlight",Pos) -- Доработать создание фонариков!
				-- if (self.cnt.has_flashlight==1 and value.Name=="PickupFlashlight")
				-- or (self.cnt.has_binoculars==1 and value.Name=="PickupBinoculars")
				-- or (self.items and self.items.heatvisiongoggles==1 and value.Name=="PickupHeatVisionGoggles") then
					-- Gadgets = 1 -- В случае если одна из этих вещей была получена позже. Чего то совсем не выдаёт.
				-- end
				-- if ((value.Type~=Game:GetEntityClassIDByClassName(value.Name.."_p") and not SkipWeapon and value.Name~="PickupG11" and value.Name~="PickupCOVERRL")
				if ((value.Type~=Game:GetEntityClassIDByClassName(value.Name.."_p") and not SkipWeapon and not SkipAmmo
				and value.Name~="AmmoHandGrenades" and value.Name~="Armor" and value.Name~="Health" and value.Name~="PickupG11") -- Что за таинственный G11?
				or Gadgets) and not value.IsDropped then
					value.IsDropped = 1
					local NewEntity = Server:SpawnEntity(value.Name,Pos)
					if NewEntity then
						-- System:Log(self:GetName()..": Spawn: "..value.Name)
						NewEntity:Physicalize(self) -- self - игнорируемый.
						NewEntity:SetName(value.Name.."_dropped4")
						-- NewEntity.Properties.Animation.AvailableWeapon = 1
						-- AI:RegisterWithAI(NewEntity.id,AIOBJECT_WEAPON)
					else
						System:Log("Failure dropping the entity: "..value.Name)
					end
				end
			end
		end
	end
end

function BasicAI:InsertMeleePipe(anim_name)
	local anim_time = self:GetAnimationLength(anim_name)
	anim_time = anim_time / 2
	AI:CreateGoalPipe("melee_animation_delay")
	AI:PushGoal("melee_animation_delay","not_shoot")
	AI:PushGoal("melee_animation_delay","timeout",1,anim_time)
	AI:PushGoal("melee_animation_delay","signal",1,1,"APPLY_MELEE_DAMAGE",0)
--	AI:PushGoal("melee_animation_delay","timeout",1,anim_time)
	AI:PushGoal("melee_animation_delay","signal",1,1,"RESET_MELEE_DAMAGE",0)
	if (self:InsertSubpipe(0,"melee_animation_delay")) then
		self:StartAnimation(0,anim_name,4)
	end
end

function BasicAI:InsertAnimationPipe(anim_name,layer_override,signal_at_end,fBlendTime,multiplier,DoNotMove)

	if not fBlendTime then
		fBlendTime = .33
	end

	if not multiplier then
		multiplier = 1
	end
	local Duration = self:GetAnimationLength(anim_name)*multiplier
	AI:CreateGoalPipe("temp_animation_delay")
	AI:PushGoal("temp_animation_delay","timeout",1,Duration)
	if (signal_at_end) then
		AI:PushGoal("temp_animation_delay","signal",1,-1,signal_at_end,0)
	end

	if (self:InsertSubpipe(0,"temp_animation_delay")) then
		if (layer_override) then
			self:StartAnimation(0,anim_name,layer_override,fBlendTime)
		else
			self:StartAnimation(0,anim_name,4,fBlendTime)
		end
	end

	if DoNotMove then -- Не двигаться, пока не пройдёт анимация.
		AI:EnablePuppetMovement(self.id,0,Duration) -- Только остонавливает, но крутиться разрешает.
		self.CurrentInsertAnimDurationStart = Duration+_time
	end
end

function BasicAI:MakeRandomIdleAnimation()
	-- pick random idle animation
	local MyAnim = IdleManager:GetIdleAnimation(self)
	if MyAnim then
		if not self.CurrentInsertAnimDurationStart then
			self:InsertAnimationPipe(MyAnim.Name,nil,nil,nil,nil,1)
		end
	else
		System:Warning("[AI] [ART ERROR][DESIGN ERRoR] Model "..self.Properties.fileModel.." used,assigned a job BUT HAS NO idleXX animations.")
	end
end

function BasicAI:DoSomethingInteresting()

	if self.Properties.bAffectSOM==0 and self.Properties.special==0 then do return end end

	local specialTextAnchor = AI:FindObjectOfType(self.id,5,AIAnchor.DO_SOMETHING_SPECIAL)

	local boredAnchor = AI_BoredManager:FindSomethingToDO(self,10)
	if (boredAnchor) then
		AI:Signal(0,1,boredAnchor.signal,self.id)
		self.EventToCall = "OnSpawn"
		return 1
	end
end

function BasicAI:MakeIdle()
	-- Make this guy idle
	self:ChangeAIParameter(AIPARAM_SIGHTRANGE,self.PropertiesInstance.sightrange)
	-- self:ChangeAIParameter(AIPARAM_SOUNDRANGE,self.PropertiesInstance.soundrange)
	-- local Skip
	-- if self.PropertiesInstance.soundrange==0 then
		-- if self.MUTANT=="big" and self.PropertiesInstance.sightrange==0 and self.PropertiesInstance.groupid==798 and Game:GetLevelName()=="Archive" then
			-- -- Skip = 1
		-- end
	-- end
	-- if self.PropertiesInstance.soundrange==0 then
		-- Skip = 1 -- Временно.
	-- end
	-- if not Skip then -- Нуль у толстяка, которого с минигана убивают.
		-- self:ChangeAIParameter(AIPARAM_SOUNDRANGE,1) -- 5
		-- self.PropertiesInstance.soundrange = 1 -- Для выхода из работы.
	-- end
	self:ChangeAIParameter(AIPARAM_FOV,self.Properties.horizontal_fov)
	self.CurrentHorizontalFov=self.Properties.horizontal_fov
	self.ForceResponsiveness = 1
	self:ChangeAIParameter(AIPARAM_RESPONSIVENESS,self.Properties.responsiveness) 		-- focus attention
	-- self:ChangeAIParameter(AIPARAM_COMMRANGE,self.Properties.commrange+100) 	-- Add 100 m to communications range
	self.SetAlerted = nil
end

function BasicAI:MakeAlerted()
	if self.SetAlerted then return end
	self.SetAlerted = 1
	self.cnt.AnimationSystemEnabled = 1  -- Поможет от незавершённых анимаций идла?
	self:SetAnimationSpeed(1)
	self:StartAnimation(0,"NULL",4)  -- А может это? Что значит 4?
	self:StopConversation()
	-- Make this guy alerted
	-- self:ChangeAIParameter(AIPARAM_SIGHTRANGE,NewSightRange) 	-- Add 100% to sight range -- *2 --*2.5
	-- if self.PropertiesInstance.soundrange > 0 then
		-- self:ChangeAIParameter(AIPARAM_SOUNDRANGE,self.PropertiesInstance.soundrange+5) 	-- Add 10 m to sound range -- 10
	-- end
	-- local Skip
	-- if self.PropertiesInstance.soundrange==0 then
		-- if self.MUTANT=="big" and self.PropertiesInstance.sightrange==0 and self.PropertiesInstance.groupid==798 and Game:GetLevelName()=="Archive" then
			-- -- Skip = 1
		-- end
	-- end
	-- if self.PropertiesInstance.soundrange==0 then
		-- Skip = 1 -- Временно.
	-- end
	-- if not Skip then
		-- self:ChangeAIParameter(AIPARAM_SOUNDRANGE,10) -- 20 - много. -- 15
		-- self.PropertiesInstance.soundrange = 10
	-- end
	self:ChangeAIParameter(AIPARAM_FOV,self.Properties.horizontal_fov+20) 		-- focus attention
	self.CurrentHorizontalFov=self.Properties.horizontal_fov+20
	self:ChangeAIParameter(AIPARAM_RESPONSIVENESS,10)
	self.ForceResponsiveness = nil
	-- self:ChangeAIParameter(AIPARAM_COMMRANGE,self.Properties.commrange+100) 	-- Add 100 m to communications range
	self:GunOut()
end

function BasicAI:GunOut()
	local weapon = self.cnt:GetCurrWeapon()
	-- if weapon and not self.AI_GunOut and self.PropertiesInstance.bGunReady==0 then
	if weapon and not self.AI_GunOut then
		-- if self.PropertiesInstance.bGunReady==0 then
			if self.DRAW_GUN_ANIM_COUNT then
				local rnd=random(1,self.DRAW_GUN_ANIM_COUNT)
				local anim_name = format("draw%02d",rnd)
				self:StartAnimation(0,anim_name,2)
				local anim_dur = self:GetAnimationLength(anim_name)
				self:TriggerEvent(AIEVENT_ONBODYSENSOR,anim_dur)
				AI:EnablePuppetMovement(self.id,0,anim_dur)
				self.AI_GunOut = 1
			end
		-- end
	end
	-- if self.AI_GunOut and self.sees==1 then -- Вообще нужно сделать это зависимым от анимации. Сделал. Теперь стрельба блокируется когда уружие уже в руках и персонаж "поднимает" его.
		-- self:TriggerEvent(AIEVENT_ONBODYSENSOR,random(1,2))
	-- end
end

function BasicAI:GettingAlerted() -- Получили сигнал тревоги! Что же делать?
	if self.Properties.special > 0 or self.MUTANT or self.ANIMAL then return 0 end -- Если мы такие уникальные, то ничего не делать!
	if self:ForbiddenCharacters() then return 0 end
	self:MakeAlerted()
	local flare_name = AI:FindObjectOfType(self.id,10,AIAnchor.AIANCHOR_THROW_FLARE)  -- Кидаем гранату на якорь! Доделать!
	if (flare_name) then
		AI:Signal(0,2,"THROW_FLARE",self.id)
		BasicPlayer.SelectGrenade(self,"FlareGrenade")
		-- Hud:AddMessage(self:GetName()..": GettingAlerted/AIANCHOR_THROW_FLARE")
		System:Log(self:GetName()..": GettingAlerted/AIANCHOR_THROW_FLARE")
	end

	if not self.temp_no_MG then
		if self:RunToMountedWeapon() then return 1 end -- Теперь бежим к стационарным орудиям!
	end
	self.temp_no_MG = nil

	local DistanceToTarget = self:GetDistanceToTarget()
	if not DistanceToTarget or DistanceToTarget>5 then
		if self:SearchAmmunition(1,1) then return 1 end
	end
	return 0
end

-- function BasicAI:SpecOpsAmmunition() -- Работает, но я не знаю как из скрипта миссии правильно вызвать. Новая версия в скрипте любой миссии кампании.
	-- local dooch_warrior=System:GetEntityByName("Dooch")
	-- local lock_warrior=System:GetEntityByName("Lock")
	-- local den_warrior=System:GetEntityByName("Den")
	-- local List={0,0,0,0}
	-- List={dooch_warrior,lock_warrior,den_warrior,_localplayer}
	-- for number,entity in List do
		-- if entity~=0 then
			-- for name,amout in MaxAmmo do
				-- if entity.Ammo[name]~=amout then
					-- entity.Ammo[name]=amout
					-- entity.Ammo["FlareGrenade"] = 0 -- Светящиеся, которые не доработаны. Их убираем.
					-- Hud:AddMessage(entity:GetName().."$1: "..name..": "..entity.Ammo[name])
					-- System:Log(entity:GetName().."$1: "..name..": "..entity.Ammo[name])
					-- entity.cnt.health=255
					-- entity.cnt.armor=255
				-- end
			-- end
		-- end
	-- end
-- end

function BasicAI:CheckEnemyWeaponDanger()
	local att_target = AI:GetAttentionTargetOf(self.id)
	if att_target and type(att_target)=="table" and self.Properties.species~=att_target.Properties.species then -- Иногда и своих "боялись", когда у них был включен acqtarget на своих.
		local EnemyWeapon = att_target.cnt.weapon
		if not EnemyWeapon then return nil end
		local EnemyWeaponDistance = att_target.fireparams.distance
		EnemyWeaponName=EnemyWeapon.name
		local fDistance = self:GetDistanceFromPoint(att_target:GetPos())
		local Current_Weapon = self.cnt.weapon
		local Current_Distance  -- Максимальная дистанция стрельбы.
		if self.fireparams then
			Current_Distance = self.fireparams.distance
		end
		local Current_FireModeType = self.fireparams.fire_mode_type
		if not self.RunToTrigger and (not Current_Weapon or (self.AttackingASmallDistance and (Current_FireModeType~=FireMode_Melee) or (Current_FireModeType==FireMode_Melee and fDistance>30 and self.sees~=1))) then -- Можно сделать чтобы при self.AttackingASmallDistance сближались.
			self:TriggerEvent(AIEVENT_DROPBEACON)
			self:SelectPipe(0,"hide_on_danger2")
			self.AI_OnDanger = 1
			return 2
		end
		-- if Current_Weapon and Current_Distance and EnemyWeaponDistance and Current_Distance<EnemyWeaponDistance and fDistance>=Current_Distance then
			-- System:Log(self:GetName()..": CheckEnemyWeaponDanger. Enemy has a ranged weapon: "..EnemyWeaponName.." ("..EnemyWeaponDistance.."), my weapon: "..Current_Weapon.name.." ("..Current_Distance..").")
			-- self:TriggerEvent(AIEVENT_DROPBEACON)
			-- if fDistance <= 50 then
				-- self:SelectPipe(0,"hide_on_danger")
				-- self.AI_OnDanger = 1
				-- return 1
			-- else
				-- self:SelectPipe(0,"hide_on_danger2")
				-- self.AI_OnDanger = 1
				-- return 2
			-- end
		-- end
		if self.IsAiPlayer then return nil end
		if fDistance <= 50 and (EnemyWeaponName=="VehicleMountedRocketMG" or EnemyWeaponName=="VehicleMountedMG" or EnemyWeaponName=="VehicleMountedAutoMG" or EnemyWeaponName=="VehicleMountedRocket" or EnemyWeaponName=="MG" or EnemyWeaponName=="MutantMG" or EnemyWeaponName=="COVERRL"
		or EnemyWeaponName=="M249" or EnemyWeaponName=="Shotgun" or EnemyWeaponName=="MutantShotgun" or EnemyWeaponName=="MountedMiniGun" or EnemyWeaponName=="MountedMortar") then
			System:Log(self:GetName()..": CheckEnemyWeaponDanger <= 50/weapon: "..EnemyWeaponName)
			self:TriggerEvent(AIEVENT_DROPBEACON)
			self:SelectPipe(0,"hide_on_danger")
			self.AI_OnDanger = 1
			return 1
		elseif fDistance > 50 and (EnemyWeaponName=="VehicleMountedRocketMG" or EnemyWeaponName=="VehicleMountedMG" or EnemyWeaponName=="VehicleMountedAutoMG" or EnemyWeaponName=="VehicleMountedRocket" or EnemyWeaponName=="MG" or EnemyWeaponName=="MutantMG" or EnemyWeaponName=="COVERRL"
		or EnemyWeaponName=="RL" or EnemyWeaponName=="SniperRifle" or EnemyWeaponName=="MountedMiniGun" or EnemyWeaponName=="MountedMortar") then
			System:Log(self:GetName()..": CheckEnemyWeaponDanger > 50/weapon: "..EnemyWeaponName)
			self:TriggerEvent(AIEVENT_DROPBEACON)
			self:SelectPipe(0,"hide_on_danger2")
			self.AI_OnDanger = 1
			return 2
		end
	end
	self.AI_OnDanger = nil
	return nil
end

function BasicAI:CheckTargetParams() -- Вдруг пригодится.
	local Params={}
	local att_target = AI:GetAttentionTargetOf(self.id)
	if att_target and type(att_target)=="table" then
		Params.DistanceToEnemy = self:GetDistanceFromPoint(att_target:GetPos())
		local Weapon = att_target.cnt:GetCurrWeapon()
		Params.EnemyWeapon = Weapon
		Params.EnemyWeaponName = Weapon.name
	end
	return Params
end

function BasicAI:GrenadeAttack(GrenadeType) -- Добавить: Кидать только если цель над уровнем земли ниже/чуть выше, чем я. Проверять наличие взрывающихся объектов, их имён и совпадение с объектами, находящимеся рядом с ИИ. Меньше дыма в помещениях и ещё меньше гранат, особенно у реара.
	-- Rock - Привлекает внимание. Тип 1.
	-- HandGrenade - Хорошо так бабахает! Тип 2.
	-- SmokeGrenade - Дымит. Тип 3.
	-- FlareGrenade - Должно освещать тёмные места. Но боты бросают немного дыма. Тип 4.
	-- FlashbangGrenade - Слепит. Тип 5.
	-- if random(1,10) > 4 or self.AI_AtWeapon or self.ThrowGrenadeTime or self.cnt.proning or self.cnt.crouching or self.cnt.underwater>0 then return nil end
	local Difficulty = tonumber(getglobal("game_DifficultyLevel"))
	if self.AI_AtWeapon or self.ThrowGrenadeTime or self.cnt.proning or (self.cnt.crouching and random(1,10) > 4) or self.cnt.underwater>0
	or self.TimeToThrowGrenade
	or (Difficulty<2 and random(1,10) > 4 and not self.IsAiPlayer and not self.IsSpecOpsMan and not self:ForbiddenCharacters()) then return nil end
	-- if self.AI_AtWeapon or self.ThrowGrenadeTime or self.cnt.proning or (((not self.cnt.proning and not self.cnt.crouching) or self.cnt.crouching) and random(1,10) > 4) or self.cnt.underwater>0 then return nil end
	local att_target = AI:GetAttentionTargetOf(self.id)
	if att_target and type(att_target)=="table" then
		self:TriggerEvent(AIEVENT_DROPBEACON)
		dist = self:GetDistanceFromPoint(att_target:GetPos())
	end
	-- dist = self:GetDistanceToTarget() -- Если есть видимая цель, то пусть переставит маяк!
	if not dist then
		-- Hud:AddMessage(self:GetName()..": GrenadeAttack/NO POINT TO THROW GRENADES!!!")
		-- System:Log(self:GetName()..": GrenadeAttack/NO POINT TO THROW GRENADES!!!")
		return nil
	end
	-- BasicPlayer.SelectGrenade(self,"HandGrenade")
	local Result
	if not GrenadeType then GrenadeType = 2 end
	if GrenadeType==9 then -- HandGrenade, FlashbangGrenade, SmokeGrenade
		local rnd=random(1,3)
		if rnd==1 then
			GrenadeType = 2  -- HandGrenade
		elseif rnd==2 then
			GrenadeType = 5  -- FlashbangGrenade
		else
			GrenadeType = 3  -- SmokeGrenade
		end
	end
	if GrenadeType==8 then
		if random(1,2)==1 then
			GrenadeType = 2  -- HandGrenade
		else
			GrenadeType = 3  -- SmokeGrenade
		end
	end
	if GrenadeType==7 then
		if random(1,2)==1 then
			GrenadeType = 2  -- HandGrenade
		else
			GrenadeType = 5  -- FlashbangGrenade
		end
	end
	if GrenadeType==6 then
		if random(1,2)==1 then
			GrenadeType = 3  -- SmokeGrenade
		else
			GrenadeType = 5  -- FlashbangGrenade
		end
	end
	if GrenadeType==5 then -- FlashbangGrenade -- Сделать чтобы отворачивались.
		-- if self.cnt.grenadetype~=GrenadeType then
			-- BasicPlayer.SelectGrenade(self,GrenadesClasses[GrenadeType])
		-- end
		if dist <= 8 or dist >= 50 then
			return nil
		end
		if self.IsIndoor then
			radius = 15
		else
			radius = 30
		end
		Result = self:NewCountingPlayers(radius,1) -- Friends,GroupFriends,Enemies,People,Mutants,Player,Radius
		if Result.Friends then
			return nil
		end
	end
	if GrenadeType==4 then -- FlareGrenade -- Иногда почему-то выбираются сами.
		-- if self.cnt.grenadetype~=GrenadeType then
			-- BasicPlayer.SelectGrenade(self,GrenadesClasses[GrenadeType])
		-- end
		if dist <= 8 then
			return nil
		end
	end
	if GrenadeType==3 then -- SmokeGrenade -- Если игрок нас ещё не видел, то смысл кидать эти гранаты? Сделать проверку. Я так понял, что либо кидай дым, либо перезаряжай пушку? Понизить вероятность броска при OnBulletRain.
		-- if self.cnt.grenadetype~=GrenadeType then
			-- BasicPlayer.SelectGrenade(self,GrenadesClasses[GrenadeType])
		-- end
		if dist <= 8 or dist >= 100 then
			return nil
		end
		Result = self:NewCountingPlayers(15,1)
		if Result.Friends and Result.Friends > 2 then
			return nil
		end
	end
	if GrenadeType==2 then -- HandGrenade
		-- if self.cnt.grenadetype~=GrenadeType then
			-- BasicPlayer.SelectGrenade(self,GrenadesClasses[GrenadeType])
		-- end
		if self.IsIndoor and random(1,10) > 1 then -- Внутри помещений бросать гранаты ой как не безопасно... Как отрикошетят ещё!
			return nil
		end
		-- if dist <= 8 or dist > 30 then
		if (dist <= 12 and not self.IsIndoor) or (dist <= 20 and self.IsIndoor) or dist > 30 then -- Добавить: при расстоянии меньше 20 после броска прятаться.
			return nil
		end
		Result = self:NewCountingPlayers(8,1) -- Friends,GroupFriends,Enemies,People,Mutants,Player,Radius
		if Result.Friends and Result.Friends > 2 then -- Result то всегда есть, а вот Result.Friends не всегда. Не забывай!
			return nil
		end
		if self.IsIndoor then
			radius = 10
		else
			radius = 15
		end
		Result = self:NewCountingPlayers(radius,1,1)
		if Result.Friends then
			return nil
		end
	end
	-- if GrenadeType==1 then -- Rock
		-- if self.cnt.grenadetype~=GrenadeType then
			-- BasicPlayer.SelectGrenade(self,GrenadesClasses[GrenadeType])
		-- end
		-- if dist <= 6 then
			-- return nil
		-- end
	-- end

	if self.cnt.grenadetype~=GrenadeType then
		BasicPlayer.SelectGrenade(self,GrenadesClasses[GrenadeType]) -- Попробовать как-нибудь entity.cnt.grenadetype. Оно реально работает!
	end
	if self.cnt.numofgrenades and self.cnt.numofgrenades>0 then -- Иногда кидают не доработанные гранаты, которые очень похожи на дымовые и искрятся. Ещё существуют флаеры, задействовать их ночью.
		-- if self.cnt.numofgrenades > 3 then -- Иногда бросает последнюю гранату, ещё не засчитало, что она брошена и он включает анимацию к следующей, а её-то уже и нет...
			-- -- self.cnt.numofgrenades = 3
			-- self.cnt.numofgrenades = random(0,3) -- Можно в ресет забить.
		-- end
		if self.cnt.numofgrenades > 2 and self.cnt.grenadetype==2 then -- Надо сделать чтобы в общем было три гранаты, а не в каждом виде. Тогда, к примеру, может получиться две дымовых и одна осколочная.
			self.cnt.numofgrenades = random(0,2)
		elseif self.cnt.numofgrenades > 1 then
			self.cnt.numofgrenades = random(0,1)
		end
		if self.IsSpecOpsMan then self.cnt.numofgrenades = 3 end -- Для веселья.
		if self.cnt.grenadetype==1 or self.cnt.grenadetype==4 or self.cnt.numofgrenades==0 then return nil end -- Запретил потому что когда кончаются нормальные гранты, автоматом переключаются на камни или глючные флаеры.
		-- Hud:AddMessage(self:GetName()..": Throw grenade: "..GrenadesClasses[self.cnt.grenadetype].."("..self.cnt.grenadetype.."), NumOfGrenades: "..self.cnt.numofgrenades..", DistanceToTarget: "..dist)
		System:Log(self:GetName()..": Throw grenade: "..GrenadesClasses[self.cnt.grenadetype].."("..self.cnt.grenadetype.."), NumOfGrenades: "..self.cnt.numofgrenades..", DistanceToTarget: "..dist)
		-- AI:CreateGoalPipe("throw_grenade")  -- Иногда смотрит в одну сторону (не маяк), а кидает в другую (маяк). -- Почему-то иногда при броске гранаты есть анимация, но нет брошеной гранаты.
		-- AI:PushGoal("throw_grenade","clear")
		-- AI:PushGoal("throw_grenade","ignoreall",1,1)
		-- AI:PushGoal("throw_grenade","not_shoot")
		-- AI:PushGoal("throw_grenade","setup_stand")
		-- -- AI:PushGoal("throw_grenade","timeout",1,.2)
		-- AI:PushGoal("throw_grenade","locate",1,"beacon")  -- Чтобы кидал по маяку, а не по текущему положению игрока.
		-- AI:PushGoal("throw_grenade","acqtarget",1,"")
		-- AI:PushGoal("throw_grenade","signal",1,1,"SHARED_GRANATE_THROW_ANIM",0)
		-- AI:PushGoal("throw_grenade","timeout",1,.2)
		-- if GrenadeType==2 then -- Добавить больше фраз.
			-- AI:PushGoal("throw_grenade","signal",1,1,"FIRE_IN_THE_HOLE",SIGNALID_READIBILITY)  -- "Бросаю гранату!".
		-- end
		-- AI:PushGoal("throw_grenade","timeout",1,.8)
		-- AI:PushGoal("throw_grenade","signal",1,-10,"grenate",0)  -- Спавнит гранату, не убирать!
		-- AI:PushGoal("throw_grenade","just_shoot")
		-- AI:PushGoal("throw_grenade","ignoreall",-1,0)  -- Да ёмаё!!! Иногда не могут выйти из игнора! А может от того, что ослепли?
		-- AI:PushGoal("throw_grenade","grenade_run_away")
		-- self:InsertSubpipe(0,"throw_grenade")
		-- if self.cnt.weapon then -- Ненужно больше.
			-- -- BasicWeapon.Client:OnStopFiring(self.cnt.weapon,self)
			-- -- BasicWeapon.StopFireLoop(self,self.fireparams,self.sounddata) -- Помогает?
			-- BasicWeapon.Client.OnStopFiring(self.cnt.weapon,self)
		-- end
		if self.IsAiPlayer and self:GetDistanceFromPoint(_localplayer:GetPos())<= 30 then
			local rnd
			local Chat
			if self.cnt.grenadetype==2 then
				rnd = random(1,8)
				if rnd==1 then
					Chat = "@GivingAFrag"
				elseif rnd==2 then
					Chat = "@Grenades"
				elseif rnd==3 then
					Chat = "@Frag"
				elseif rnd==4 then
					Chat = "@Shards"
				elseif rnd==5 then
					Chat = "@NowExplode"
				elseif rnd==6 then
					Chat = "@Run"
				elseif rnd==7 then
					Chat = "@WatchOut"
				elseif rnd==8 then
					Chat = "@GetDown"
				end
			elseif self.cnt.grenadetype==3 then
				rnd = random(1,4)
				if rnd==1 then
					Chat = "@ThrowASmoke"
				elseif rnd==2 then
					Chat = "@ThrowSmoke"
				elseif rnd==3 then
					Chat = "@Smoke"
				elseif rnd==4 then
					Chat = "@Smoke2"
				end
			elseif self.cnt.grenadetype==5 then
				rnd = random(1,6)
				if rnd==1 then
					Chat = "@GivingStun"
				elseif rnd==2 then
					Chat = "@GivingLight"
				elseif rnd==3 then
					Chat = "@Stun"
				elseif rnd==4 then
					Chat = "@Light"
				elseif rnd==5 then
					Chat = "@Blinding"
				elseif rnd==6 then
					Chat = "@Blinding2"
				end
			end
			if Chat then
				Hud:AddMessage(self:GetName()..": "..Chat)
			end
		end
		AI:CreateGoalPipe("throw_grenade")  -- Иногда смотрит в одну сторону (не маяк), а кидает в другую (маяк). -- Почему-то иногда при броске гранаты есть анимация, но нет брошеной гранаты.
		AI:PushGoal("throw_grenade","ignoreall",-1,1) -- Игнорирование необходимо включать сразу чтобы не было критических зависаний игры когда бросающего убьют и при этом он в данный момент видел цель.
		AI:PushGoal("throw_grenade","locate",1,"beacon")  -- Чтобы кидал по маяку, а не по текущему положению игрока (за стеной).
		AI:PushGoal("throw_grenade","acqtarget",1,"")
		AI:PushGoal("throw_grenade","locate",1,"atttarget")  -- Чтобы по игроку, если всё-таки видит его.
		AI:PushGoal("throw_grenade","acqtarget",1,"")
		AI:PushGoal("throw_grenade","signal",1,1,"SHARED_GRANATE_THROW_ANIM",0)
		AI:PushGoal("throw_grenade","timeout",1,.2)
		if GrenadeType==2 then -- Добавить больше фраз.
			AI:PushGoal("throw_grenade","signal",1,1,"FIRE_IN_THE_HOLE",SIGNALID_READIBILITY)  -- Фраза "Бросаю гранату!".
		end
		AI:PushGoal("throw_grenade","timeout",1,.8)
		-- AI:PushGoal("throw_grenade","signal",1,-10,"grenate",0)  -- Спавнит гранату с помощью сигнала. C++ "-10" - id. Чем больше сигналов поступает, тем меньше шансов бросить гранату.
		AI:PushGoal("throw_grenade","just_shoot")
		-- AI:PushGoal("throw_grenade","grenade_run_away")
		AI:PushGoal("throw_grenade","ignoreall",-1,0)
		AI:PushGoal("throw_grenade","signal",1,1,"AFTER_THROW_GRENADE",0)
		-- if self.IsAiPlayer then
			-- AI:PushGoal("throw_grenade","after_throw_grenade_hide")
		-- else -- Чтобы сразу прятались.
			-- if random(1,2)==1 then
				-- AI:PushGoal("throw_grenade","after_throw_grenade_hide_and_random")
			-- else
				-- AI:PushGoal("throw_grenade","after_throw_grenade_hide_and_attack")
			-- end
		-- end
		self:TriggerEvent(AIEVENT_CLEAR)
		-- AI:MakePuppetIgnorant(self.id,1)
		self:InsertSubpipe(0,"not_shoot")
		self:InsertSubpipe(0,"setup_stand") -- А есть какая-нибудь другая анимация броска для других положений?
		self:InsertSubpipe(0,"throw_grenade")
		return 1
	end
	return nil
end

function BasicAI:ForbiddenCharacters() -- Доделать.
	if self.Properties.special and self.Properties.special > 0 then
		-- Hud:AddMessage(self:GetName()..": ForbiddenCharacters/special: "..self.Properties.special)
		-- System:Log(self:GetName()..": ForbiddenCharacters/special: "..self.Properties.special)
		return 1
	end
	return nil
end


function BasicAI:ShootOrNo()
	-- Когда друзья следуют за игроком, им так и хочется его пристрелить. Это исправление.
	if self.Properties.species==_localplayer.Properties.species then
		local att_target = AI:GetAttentionTargetOf(self.id)
		if att_target and type(att_target)=="table" then
			if att_target==_localplayer then
				-- Hud:AddMessage(self:GetName()..": LocalPlayerSeen "..self.Properties.species.." ".._localplayer.Properties.species)
				-- System:Log(self:GetName()..": LocalPlayerSeen "..self.Properties.species.." ".._localplayer.Properties.species)
				self:InsertSubpipe(0,"not_shoot")
				self:TriggerEvent(AIEVENT_CLEAR)  -- Чтобы не было стрельбы в игрока при использовании acqtarget.
				return 1
			end
		end
	end
	return nil
end

function BasicAI:CountingPlayers(radius,ontarget)
	if not radius or radius==0 then
		if not self.rta then
			System:Log(self:GetName()..": BasicAI/CountingPlayers: NO RADIUS!!!")
		end
		self.rta = nil
		radius = self.Properties.commrange
	end
	if ontarget and ontarget > 0 then
		local att_target = AI:GetAttentionTargetOf(self.id)
		if att_target and type(att_target)=="table" then
			pos = new(att_target:GetPos())
		end
	else
		pos = new(self:GetPos())
	end
	-- local ang = new(self:GetAngles())
	local players = {}
	self.friendscount = nil
	self.groupfriendscount = nil
	self.enemyscount = nil
	Game:GetPlayerEntitiesInRadius(pos,radius,players)
	-- Hud:AddMessage(self:GetName()..": "..radius.." = "..radius)
	-- System:Log(self:GetName()..": "..radius.." = "..radius)
	-- Hud:AddMessage(self:GetName()..": players: "..tostring(players))
	-- Hud:AddMessage(self:GetName()..": Number of Players: "..count(players))
	-- Hud:AddMessage(self:GetName()..": pos: "..format(" pos=%.03f,%.03f,%.03f",pos.x,pos.y,pos.z))
	-- Hud:AddMessage(self:GetName()..": ang: "..format(" ang=%.03f,%.03f,%.03f",ang.x,ang.y,ang.z))
	-- local szTeam=Game:GetEntityTeam(self.id)
	-- Hud:AddMessage(self:GetName()..": GetEntity: "..tostring(szTeam))
	-- local szTeam=System:GetEntity(self.id)
	-- Hud:AddMessage(self:GetName()..": GetEntity: "..tostring(szTeam))
	if (players and type(players)=="table") then
		self.friendscount = 0
		self.groupfriendscount = 0
		self.enemyscount = 0
		for i,cell in players do
			self.tempplayer = cell.pEntity
			if self.tempplayer then -- Если кто-то рядом есть...
				if self.id~=self.tempplayer.id then
					if self.Properties.species==self.tempplayer.Properties.species then
						self.friendscount = self.friendscount+1  -- Подсчитать количество друзей.
						if self.PropertiesInstance.groupid==self.tempplayer.PropertiesInstance.groupid then
							self.groupfriendscount = self.groupfriendscount+1  -- Подсчитать количество друзей из группы.
						end
					else
						self.enemyscount = self.enemyscount+1  -- Подсчитать количество врагов.
					end
				end
			end
		end
		System:Log(self:GetName()..": f/gf: "..self.friendscount.."/"..self.groupfriendscount..", e: "..self.enemyscount..", r: "..radius)
		if self.friendscount==0 then self.friendscount = nil  end
		if self.groupfriendscount==0 then self.groupfriendscount = nil  end
		if self.enemyscount==0 then self.enemyscount = nil  end
		self.tempplayer = nil
	end
end

function BasicAI:GetGroupCount() -- В AI:GetGroupCount() побочный есть эффект: функция учитывает почти все сущности с таким же групповым id, то есть даже не игроков.
	local Entities
	if GameRules.AllEntities then
		Entities = GameRules.AllEntities -- Все сущности.
	end
	if not Entities then
		Entities = System:GetEntities() -- Это используется только в первую секунду.
	end
	local GroupFriends=0
	for i,entity in Entities do
		if entity and entity.type=="Player" and BasicPlayer.IsAlive(entity) then -- Если сущность - игрок и игрок жив.
			if self.Properties.species==entity.Properties.species then
				if self.PropertiesInstance.groupid==entity.PropertiesInstance.groupid then
					GroupFriends = GroupFriends+1  -- Подсчитать количество друзей из группы. Себя тоже.
				end
			end
		end
	end
	-- Hud:AddMessage(self:GetName()..": GroupFriends: "..GroupFriends)
	return GroupFriends
end

function BasicAI:GetGroupLeader()
	local Entities
	if GameRules.AllEntities then
		Entities = GameRules.AllEntities
	end
	if not Entities then
		Entities = System:GetEntities()
	end
	local Leader
	for i,entity in Entities do
		if entity and entity.type=="Player" and BasicPlayer.IsAlive(entity) then
			if self.Properties.species==entity.Properties.species then
				if self.PropertiesInstance.groupid==entity.PropertiesInstance.groupid then
					if entity.Behaviour and (entity.Behaviour.Name=="TLDefenseIdle" or entity.Behaviour.Name=="TLAttack2Idle" or entity.Behaviour.Name=="TLAttack2Attack") then
						Leader = entity
						break
					end
				end
			end
		end
	end
	-- Hud:AddMessage(self:GetName()..": GroupFriends: "..GroupFriends)
	return Leader
end

function BasicAI:NewCountingPlayers(Radius,ReturnType,OnTarget,NoNil)
	if not Radius or Radius==0 then
		-- if (not Radius and not ReturnType) then
			-- System:Log(self:GetName()..": BasicAI/NewCountingPlayers: NO RADIUS!!!. Use commrange.")
		-- end
		Radius = self.Properties.commrange
	end
	local pos
	if OnTarget and OnTarget > 0 then
		local att_target = AI:GetAttentionTargetOf(self.id)
		if att_target and type(att_target)=="table" then
			pos = new(att_target:GetPos())
		end
	else
		pos = new(self:GetPos())
	end
	local players = {}
	local Friends=0
	local GroupFriends=0
	local Enemies=0
	local People=0
	local Mutants=0
	local Player=0
	Game:GetPlayerEntitiesInRadius(pos,Radius,players)
	if (players and type(players)=="table") then
		for i, val in players do
			local entity = val.pEntity
			if entity then -- Если кто-то рядом есть...
				if self.id~=entity.id then -- Себя не учитывать.
					if entity.Properties.species==100 or entity.MUTANT then
						Mutants=Mutants+1 -- Подсчитать количество мутантов.
					else
						if entity==_localplayer then
							Player=Player+1 -- Наличие игрока.
						end
						People=People+1 -- Подсчитать количество людей.
					end
					if self.Properties.species==entity.Properties.species then
						Friends = Friends+1  -- Подсчитать количество друзей.
						if self.PropertiesInstance.groupid==entity.PropertiesInstance.groupid then
							GroupFriends = GroupFriends+1  -- Подсчитать количество друзей из группы.
						end
					else
						Enemies = Enemies+1  -- Подсчитать количество врагов.
					end
				end
			end
		end
		-- System:Log(self:GetName()..": Fd/GpFd: "..Friends.."/"..GroupFriends..", Ee: "..Enemies..", Pe: "..People..", Mt: "..Mutants..", Pr: "..Player..", Rs: "..Radius)
	end
	if not NoNil then
		-- Чтобы глобально ничего не менять и случайно не портить код. Я лучше опустошу переменные. Кроме исключений... Ещё, это удобно для лога.
		if Friends==0 then Friends=nil end
		if GroupFriends==0 then GroupFriends=nil end
		if Enemies==0 then Enemies=nil end
		if People==0 then People=nil end
		if Mutants==0 then Mutants=nil end
		if Player==0 then Player=nil end
	end
	local ReturnInfo
	if not ReturnType or ReturnType==0 then
		ReturnInfo={Friends,GroupFriends,Enemies,People,Mutants,Player,Radius}
		-- System:Log(self:GetName()..": TEST f/gf: "..ReturnInfo[1].."/"..ReturnInfo[2]..", e: "..ReturnInfo[3]..", p: "..ReturnInfo[4]..", m: "..ReturnInfo[5]..", p: "..ReturnInfo[6]..", r: "..ReturnInfo[7])
	else
		ReturnInfo={Friends=Friends,GroupFriends=GroupFriends,Enemies=Enemies,People=People,Mutants=Mutants,Player=Player,Radius=Radius}
		-- System:Log(self:GetName()..": TEST f/gf: "..ReturnInfo.Friends.."/"..ReturnInfo.GroupFriends..", e: "..ReturnInfo.Enemies..", p: "..ReturnInfo.People..", m: "..ReturnInfo.Mutants..", p: "..ReturnPlayer..", r: "..ReturnInfo.Radius)
	end
	return ReturnInfo
end

function BasicAI:RunToAlarm() -- Хитрый враг оказался на базе? Добавить: Побольше задержек, если сигнал получен со стороны, чтобы не сразу реагировали как получат команду.
	if self.Properties.special==1 or self.MUTANT or self.ANIMAL then return nil  end
	if self:ForbiddenCharacters() then return nil  end
	if self.RunToTrigger then return nil  end
	-- System:Log(self:GetName()..": RunToAlarm")
	AIBehaviour.DEFAULT:MyGroupWakeUp(self)
	local fDistance = self:GetDistanceToTarget() -- Нужно self?
	self.rta = 1

	-- AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY(self)  -- Должно быть не во всех случаях.

	if self.IsIndoor then
		SearchRadius = 30
	else
		SearchRadius = 100
	end
	self.AlarmName = AI:FindObjectOfType(self.id,SearchRadius,AIAnchor.AIANCHOR_PUSH_ALARM)
	self.BlindAlarmName = AI:FindObjectOfType(self.id,SearchRadius,AIAnchor.BLIND_ALARM)
	self.NotifyAnchor = AI:FindObjectOfType(self.id,SearchRadius,AIAnchor.AIANCHOR_NOTIFY_GROUP_DELAY)
	self.ReinforcePoint = AI:FindObjectOfType(self.id,SearchRadius,AIAnchor.AIANCHOR_REINFORCEPOINT)
	self.AlarmNameEntity = System:GetEntityByName(self.AlarmName)
	self.BlindAlarmNameEntity = System:GetEntityByName(self.BlindAlarmName)
	self.NotifyAnchorEntity = System:GetEntityByName(self.NotifyAnchor)
	self.ReinforcePointEntity = System:GetEntityByName(self.ReinforcePoint)

	local Result = self:NewCountingPlayers(30,1) -- Friends,GroupFriends,Enemies,People,Mutants,Player,Radius
	if Result.Friends and Result.Enemies then -- Есть и друзья, и враги.
		if not self.SignalSent then
			-- if random(1,2)==1 and not self.call_alarm_muted and (self.BlindAlarmNameEntity or self.AlarmNameEntity) and Result.Friends > 2 then
			if not self.call_alarm_muted and (self.BlindAlarmNameEntity or self.AlarmNameEntity) and Result.Friends > 2 then
				self.call_alarm_muted = 1
				self:Readibility("CALL_ALARM_GROUP",1)  -- В зоне нарушитель! Исправить: может сказать "поднять тревогу", а сам может побежать и включить.
				AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY(self)
			end
			AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"RunToAlarmSignal",self.id)  -- Передать другим сигнал RunToAlarm. entity~=sender
		end
	end

	-- if self.BlindAlarmNameEntity and self.AlarmNameEntity.engaged==-1 then
		-- self.temp_no_MG = 1  -- Временно не использовать стационарные орудия, сначала сигнализация!
	-- end

	if self:GettingAlerted()==1 then return 1 end

	if fDistance and fDistance < 15 then
		-- Hud:AddMessage(self:GetName()..": RunToAlarm/fDistance < 15")
		-- System:Log(self:GetName()..": RunToAlarm/fDistance < 15")
	return nil end
	
	if self.BlindAlarmNameEntity and self.AlarmNameEntity.engaged==-1 then -- Срочно поднять тревогу.
		self.BlindAlarmNameEntity.engaged = self.id
		-- self.runga = 1  -- Отложить GettingAlerted на выполнение после...
		-- Hud:AddMessage(self:GetName()..": RunToAlarm/self.BlindAlarmNameEntity.engaged = self.id: "..self.BlindAlarmNameEntity.engaged)
		System:Log(self:GetName()..": RunToAlarm/self.BlindAlarmNameEntity.engaged = self.id: "..self.BlindAlarmNameEntity.engaged)
		AI:Signal(0,1,"GoForReinforcement",self.id)
		return 1
	end

	-- self.temp_no_MG = nil
	-- if self:RunToMountedWeapon() then return 1  end

	-- if not fDistance and not Result.Enemies then
		-- -- Добавить: "Где он?".
	-- end
	-- if Result.Friends>2 and Result.Enemies then
		-- -- Добавить: "Нас больше!".
	-- end

	Result = self:NewCountingPlayers(60,1)
	local GoForReinforcement
	if Result.Friends and Result.Enemies then
		if Result.Friends<=Result.Enemies then
			GoForReinforcement = 1
			-- Hud:AddMessage(self:GetName()..": RunToAlarm/Result.Friends<=Result.Enemies")
			System:Log(self:GetName()..": RunToAlarm/Result.Friends<=Result.Enemies")
		end
	end
	-- if self.AlarmNameEntity then 
		-- Hud:AddMessage(self:GetName()..": RunToAlarm/self.AlarmNameEntity")
		-- if self.AlarmNameEntity.engaged==-1 then
			-- Hud:AddMessage(self:GetName()..": RunToAlarm/self.AlarmNameEntity 2")
		-- end
	-- end
	if self.AlarmNameEntity and self.AlarmNameEntity.engaged==-1 then -- Поднять тревогу.
		if Result.Friends then
			if Result.Friends<=10 then -- 4 -- Чем больше число, тем больше шансов что они намеренно поднимут тревогу. Сделать сравнение с изначальным числом друзей.
				GoForReinforcement = 1
				-- Hud:AddMessage(self:GetName()..": RunToAlarm/self.AlarmNameEntity/Result.Friends<=10")
				System:Log(self:GetName()..": RunToAlarm/self.AlarmNameEntity/Result.Friends<=10")
			end
		end
		if fDistance then
			if Result.Friends then -- Сначала найдены друзья на расстоянии 60 метров (commrange*2).
				local Radius = fDistance+1
				Result = self:NewCountingPlayers(Radius,1)
				if not Result.Friends or (Result.Friends and Result.Friends <= 2) or (Result.Friends and Result.Enemies and Result.Friends <= Result.Enemies) then
					GoForReinforcement = 1
					-- Hud:AddMessage(self:GetName()..": RunToAlarm/self.AlarmNameEntity/2")
					System:Log(self:GetName()..": RunToAlarm/self.AlarmNameEntity/2")
				end
			end
		end
		-- if fDistance and fDistance <= 30 then -- Исправить! И "замутить" голос когда союзников не осталось.
			-- GoForReinforcement = nil
		-- -- if self.not_sees_timer_start~=0 then
			-- System:Log(self:GetName()..": RunToAlarm/self.AlarmNameEntity/fDistance <= 30. Send RunToAlarmSignal!")
			-- AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"RunToAlarmSignal",self.id)  -- Что то не передаёт  -- Спам
		-- end
		if GoForReinforcement then
			-- GoForReinforcement = nil
			self.AlarmNameEntity.engaged = self.id
			AI:Signal(0,1,"GoForReinforcement",self.id)
			return 1
		end
	end
	Result = self:NewCountingPlayers(60,1)
	if self.NotifyAnchorEntity and self.AlarmNameEntity.engaged==-1 then -- Побежать к якорю и крикнуть друзьям о том что нужна помощь.
		if Result.Friends then
			if Result.Friends<=10 then -- 6 -- Сделать сравнение с изначальным числом друзей.
				GoForReinforcement = 1
				-- Hud:AddMessage(self:GetName()..": RunToAlarm/NotifyAnchorEntity/Result.Friends<=6")
				System:Log(self:GetName()..": RunToAlarm/NotifyAnchorEntity/Result.Friends<=6")
			end
			-- if Result.Friends==1 then
				-- self.get_reinforcements_muted = 1
			-- end
		end
		-- if Result.Friends and Result.GroupFriends then
			-- if ((Result.Friends-Result.GroupFriends)<=2) and (Result.GroupFriends<=2) then
				-- GoForReinforcement = 1
			-- end
		-- end
		if GoForReinforcement then
			-- GoForReinforcement = nil
			self.NotifyAnchorEntity.engaged = self.id
			AI:Signal(0,1,"GoForReinforcement",self.id)
			return 1
		end
	end
	if self.ReinforcePointEntity and self.AlarmNameEntity.engaged==-1 then -- Побежать и позвать на помощь.
		-- Hud:AddMessage(self:GetName()..": RunToAlarm/ReinforcePointEntity")
		System:Log(self:GetName()..": RunToAlarm/ReinforcePointEntity")
		self.ReinforcePointEntity.engaged = self.id
		AI:Signal(0,1,"GoForReinforcement",self.id)
		return 1
	end
	-- if not self.no_MG then -- Без этого слишком часто садятся за пушки в атаке. -- Переделать под случайное или под подсчёт.
	-- if not self.no_MG or random(1,10)<=3 then
	if not self.no_MG then
		if self:RunToMountedWeapon() then return 1 end
	end
	return nil
end

function BasicAI:SetAccuracy() -- Надо сделать чтобы всё менялось когда это требуется, а не было всегда.
	-- if self.AllowFire then
		-- Hud:AddMessage(self:GetName()..": self.AllowFire")
	-- end
	-- if self.AimLook then
		-- Hud:AddMessage(self:GetName()..": self.AimLook")
	-- end
	local FogStart = System:GetFogStart()
	local FogEnd = System:GetFogEnd()
	-- local MediumFog = (FogStart+FogEnd)/1.4 -- По нормальному, на 2 для вычисления среднего.
	local MediumFog = FogEnd+10
	-- System:Log(self:GetName()..": FogStart: "..FogStart..", FogEnd: "..FogEnd..", MediumFog: "..MediumFog)
	-- if self.AI_AtWeapon then
		-- self:ChangeAIParameter(AIPARAM_ACCURACY,.3)
		-- self:ChangeAIParameter(AIPARAM_AGGRESION,0)
		-- -- Hud:AddMessage(self:GetName()..": self.AI_AtWeapon")
		-- -- System:Log(self:GetName()..": self.AI_AtWeapon")
		-- return
	-- end
	-- if self.PracticleFireMan then -- Добавить: разрешить ему стрелять по старому, а то в одну точку бьёт... AIPARAM_ATTACKRANGE не убирать!
		-- self:ChangeAIParameter(AIPARAM_ACCURACY,1)
		-- self:ChangeAIParameter(AIPARAM_AGGRESION,.5)
		-- self:ChangeAIParameter(AIPARAM_ATTACKRANGE,10000)
		-- self:ChangeAIParameter(AIPARAM_SIGHTRANGE,110)
		-- return
	-- end
	local Weapon = self.cnt.weapon
	if not Weapon then self:ChangeAIParameter(AIPARAM_ATTACKRANGE,self.Properties.attackrange) end
	local fDistance = self:GetDistanceToTarget()
	-- if not fDistance then self:ChangeAIParameter(AIPARAM_ATTACKRANGE,self.Properties.attackrange) return end
	if not self.CurrentSightRange then if self.PropertiesInstance.sightrange then self.CurrentSightRange=self.PropertiesInstance.sightrange end end
	if not self.CurrentSightRange then return end
	local Current_Distance  -- Максимальная дистанция стрельбы.
	if self.fireparams then
		Current_Distance = self.fireparams.distance
	end
	-- local MaxRange = self.CurrentSightRange
	-- if MaxRange > MediumFog then MaxRange = MediumFog  end
	local MaxRange = 80  -- Максимальная дистанция, докуда достреливает оружие.
	local MaxAttackRange = 10000 -- 350
	if Current_Distance then
		MaxRange = Current_Distance -- Для рассчёта агрессии.
		if Weapon and self.fireparams.fire_mode_type~=FireMode_Melee then
			if Weapon.name~="RL" then
				MaxAttackRange = Current_Distance+random(0,50)
			end
		else
			MaxAttackRange = Current_Distance+3 -- 3, чтоб с разбегу ка-ак за-аехать...
		end
	end
	self.AttackingASmallDistance = nil
	-- if not self.theVehicle then
		self:ChangeAIParameter(AIPARAM_ATTACKRANGE,MaxAttackRange)  -- Чтобы не тратили зря патроны, пули всё-равно не долетают.
		if fDistance and fDistance>MaxAttackRange then self.AttackingASmallDistance = 1 end -- А можно ведь заставить сближаться...
		-- if not fDistance then fDistance="nil" end
		-- System:Log(self:GetName()..": Current_Distance: "..Current_Distance..", MaxAttackRange: "..MaxAttackRange..", fDistance: "..fDistance)
		-- if fDistance=="nil" then	fDistance=nil end
	-- end
	-- local RandomSkills = tonumber(getglobal("ai_random_skills"))
	-- if (not self.SetShootingSkillMaxRange or self.SetShootingSkillMaxRange==MaxRange) and RandomSkills==1 then
		-- self.SetShootingSkillMaxRange = random(40,200) -- Чем больше значение, тем на большее расстояние ИИ стреляет агрессивно и метко.
		-- Hud:AddMessage(self:GetName()..": ShootingSkillMaxRange: "..self.SetShootingSkillMaxRange)
		-- System:Log(self:GetName()..": ShootingSkillMaxRange: "..self.SetShootingSkillMaxRange)
	-- elseif (not RandomSkills or RandomSkills==0) and self.SetShootingSkillMaxRange then
		-- self.SetShootingSkillMaxRange = nil
	-- end
	-- if self.SetShootingSkillMaxRange then
		-- MaxRange = self.SetShootingSkillMaxRange
	-- end
	local NewParam = 1
	local NewAggresion = 1
	-- local inversion
	if fDistance then -- А зачем эта проверка если всё-равно функция возвращяется когда дистанция не определена?
		NewParam = fDistance/MaxRange
		if NewParam > 1 then NewParam = 1 end
		-- local NewAccuracy = NewParam
		NewAggresion = NewParam
		-- if (Weapon.name=="Falcon" and self.fireparams.fire_mode_type~=FireMode_Melee) or Weapon.name=="Shotgun" or Weapon.name=="MutantShotgun" or Weapon.name=="SniperRifle" or Weapon.name=="RL" then
		if self.fireparams then
			if self.fireparams.fire_mode_type==FireMode_Melee or self.fireparams.fire_mode_type==FireMode_Projectile or self.fireparams.BulletRejectType==BULLET_REJECT_TYPE_SINGLE then
				-- Hud:AddMessage(self:GetName()..": +NewAggresion: "..NewAggresion)
				-- System:Log(self:GetName()..": +NewAggresion: "..NewAggresion)
				NewAggresion = 1.4-NewAggresion  -- Часто нажимать на курок в ближнем бою с данным видом оружия.
				-- -- inversion=1
				-- Hud:AddMessage(self:GetName()..": -NewAggresion: "..NewAggresion)
				-- System:Log(self:GetName()..": -NewAggresion: "..NewAggresion)
			else
				if NewAggresion > .7 and self.fireparams.fire_mode_type~=FireMode_Melee then NewAggresion = .7 end
			end
		end
	end
	local NewSightRange = 110
	local MinNewSightRange = 50 -- Это и ещё две для спокойного состояния.
	local AddNewSightRange = random(0,100) -- 50+0,60 = 50,110;
	local MaxNewSightRange = MinNewSightRange+AddNewSightRange
	local NewResponsiveness = 7.5
	local MaxResponsiveness = 40 -- 40 - 100% меткость.
	local RandomSkills = tonumber(getglobal("ai_permanent_skill"))
	if not self.SetRandomMaxResponsiveness and RandomSkills==1 and not self.IsSpecOpsMan then
		self.SetRandomMaxResponsiveness = random(10,MaxResponsiveness) -- Чем больше значение, тем на быстрее ИИ наводится на цель (аим).
		Hud:AddMessage(self:GetName()..": RandomMaxResponsiveness: "..self.SetRandomMaxResponsiveness)
		System:Log(self:GetName()..": RandomMaxResponsiveness: "..self.SetRandomMaxResponsiveness)
	elseif (not RandomSkills or RandomSkills==0) and self.SetRandomMaxResponsiveness then
		self.SetRandomMaxResponsiveness = nil
	end
	if self.SetRandomMaxResponsiveness then
		MaxResponsiveness = self.SetRandomMaxResponsiveness
	else
		MaxResponsiveness = random(10,MaxResponsiveness)
	end
	if self.SetAlerted then -- Тут прикол в том, что теперь они хуже видят, если цель хуже освещёна.
		-- NewSightRange = self.PropertiesInstance.sightrange*2.5 -- 275
		-- NewSightRange = 275
		local IronSight
		if self.sees==1 or self.AimLook then -- Если видит цель, то пока не потеряет, оно должно быть на максимуме.
			NewSightRange = 275
			IronSight = 1
		else -- Иначе, такая игра видит-не видит на расстоянии. Возможно, тогда можно будет до трёхсот поднять, так как там ещё есть зона "еле-еле видимости"...
			if self.sees==2 and self.WasInCombat then -- self.WasInCombat желательно заменить на какой-нибудь "только что имел визуальный контакт".
				-- NewSightRange = 137.5+random(0,137.5)
				NewSightRange = 200+random(0,75)
			else
				NewSightRange = 110+random(0,165)
			end
		end
		if Weapon and (Weapon.name=="SniperRifle" or Weapon.name=="RL") then
			-- NewSightRange = self.PropertiesInstance.sightrange*10 -- 1100, старые: *5 -- 550
			-- NewSightRange = 1100
			-- if self.sees==1 or self.AimLook then -- self.AimLook - анимация поднятого оружия есть или нет.
				-- NewSightRange = 1100
			-- -- else
				-- -- NewSightRange = 275+random(0,825) --
			-- end
			if self.AimLook then -- self.AimLook - анимация поднятого оружия есть или нет.
				if self.sees==1 then
					NewSightRange = 1100
				elseif self.sees==2 then
					NewSightRange = 110+random(0,990)
				end
			end
		elseif Weapon and (Weapon.name=="AG36" or Weapon.name=="OICW") then
			-- NewSightRange = self.PropertiesInstance.sightrange*5 -- 550, старые: *3.5 -- 385
			-- NewSightRange = 550
			-- if self.sees==1 or self.AimLook then
				-- NewSightRange = 550
			-- -- else
				-- -- NewSightRange = 275+random(0,275)
			-- end
			if self.AimLook then -- self.AimLook - анимация поднятого оружия есть или нет.
				if self.sees==1 then
					NewSightRange = 550
				elseif self.sees==2 then
					NewSightRange = 110+random(0,440)
				end
			end
		end
		if self.AimLook and not IronSight then -- Сужение поля зрения будет немного косячным и одновременно будет нужный эффект, так как оно всё-равно расширится до первоначальных и будет илюзия поиска цели через прицел.
			self:ChangeAIParameter(AIPARAM_FOV,45)
			self.CurrentHorizontalFov=45
		end
		-- if not self.SeesTimeStart and self.sees==1 then self.SeesTimeStart=_time end -- Должно сгладить прицеливание, чтобы было как можно меньше резких наведений.
		-- if self.sees==1 and self.SeesTimeStart and _time>self.SeesTimeStart+.3 then
		if self.sees==1 then
			NewResponsiveness = MaxResponsiveness
		else
			NewResponsiveness = 10
			self.SeesTimeStart = nil
		end
	-- else
		-- NewSightRange = self.PropertiesInstance.sightrange -- 110
		-- NewResponsiveness = self.Properties.responsiveness -- 7.5
		MaxNewSightRange = nil
	else
		NewSightRange = MaxNewSightRange
	end
	-- if NewAccuracy < .2 then NewAccuracy = .2  end
	-- if not AI:IsMoving(self.id) then -- Если не двигается, то можно повысить меткость.
		-- if Weapon.name=="OICW" or Weapon.name=="AG36" then
			-- NewAccuracy=NewAccuracy*.1 -- Чтобы люди с этим оружием стреляли более метко. NewAccuracy*коэффициент = при максимуме, 1==коэффициент
			-- -- NewAggresion=1-NewAggresion
		-- elseif Weapon.name=="SniperRifle" or Weapon.name=="RL" then
			-- NewAccuracy=NewAccuracy*.5
		-- -- else
			-- -- NewAccuracy=NewAccuracy*.7
		-- end
	-- end
	-- if self.TargetTotalLightScale then -- Чтобы в темноте точность понижалась.
		-- local TTLS = self.TargetTotalLightScale+.1
		-- if inversion then
			-- if TTLS < .7 then TTLS = .7 end
		-- else
			-- if TTLS < .5 then TTLS = .5 end
		-- end
		-- NewAccuracy = NewAccuracy+(1-TTLS)
		-- -- Больше света, больше self.TargetTotalLightScale
		-- -- Меньше ACCURACY, метче стреляет.
	-- end
	if self.TargetTotalLightScale and NewResponsiveness>self.Properties.responsiveness and self.sees==1 then -- Чтобы в темноте точность понижалась.
		if NewParam then
			NewResponsiveness = NewResponsiveness-NewParam*MaxResponsiveness -- ПРОВЕРИТЬ ЕЩЁ РАЗ
			-- Hud:AddMessage(self:GetName()..": NewResponsiveness 0: "..NewResponsiveness)
			-- System:Log(self:GetName()..": NewResponsiveness 0: "..NewResponsiveness)
		end
		local TTLS = self.TargetTotalLightScale+.1
		-- if inversion then
			-- if TTLS < .7 then TTLS = .7 end
		-- else
			-- if TTLS < .5 then TTLS = .5 end
		-- end
		NewResponsiveness = NewResponsiveness-(MaxResponsiveness-TTLS*MaxResponsiveness)
		-- Больше света, больше self.TargetTotalLightScale
		-- Добавить ещё проверку на угол наведения.
	end
	if (self.IsSpecOpsMan=="Den" and Weapon.name=="SniperRifle") or (self.fireparams and self.fireparams.fire_mode_type==FireMode_Melee) then
		-- -- NewAccuracy = 0
		NewAggresion = 1
	end
	-- if Weapon.name=="RL" then
		-- NewAggresion = 1
	-- end
	if self.AI_AtWeapon then
		-- NewAccuracy = .3
		NewAggresion = 0
	end
	-- NewAccuracy = 0
	-- -- if NewAccuracy < 0 then NewAccuracy = 0  end
	-- -- if NewAccuracy > 1 then NewAccuracy = 1  end
	-- self:ChangeAIParameter(AIPARAM_ACCURACY,NewAccuracy)  -- 0 - абсолютная точность, 1 - часто промахивается, т. е. чем больше значение, тем больше мажет.
	if NewAggresion then
		if NewAggresion < 0 then NewAggresion = 0 end
		if NewAggresion > 1 then NewAggresion = 1 end
		self:ChangeAIParameter(AIPARAM_AGGRESION,NewAggresion)  -- 0, .1 - длинные очереди с долгими паузами между стрельбой, .9, 1 - короткие очереди с недолгими паузами. Второе подходит для стрельбы из автоматического оружия на дальние дистанции.
		-- self:ChangeAIParameter(AIPARAM_AGGRESION,.9)  -- Тест анимации после стрельбы.
		-- Hud:AddMessage(self:GetName()..": NewAggresion: "..NewAggresion)
		-- System:Log(self:GetName()..": NewAggresion: "..NewAggresion)
	end
	-- Hud:AddMessage(self:GetName()..": Weapon: "..Weapon.name..", NewParam: "..NewParam..", NewAccuracy: "..NewAccuracy..", NewAggresion: "..NewAggresion)
	-- System:Log(self:GetName()..": Weapon: "..Weapon.name..", NewParam: "..NewParam..", NewAccuracy: "..NewAccuracy..", NewAggresion: "..NewAggresion)
	-- self:ChangeAIParameter(AIPARAM_ACCURACY,self.PropertiesInstance.accuracy)  -- Возвращает исходное значение точности.
	-- self:ChangeAIParameter(AIPARAM_AGGRESION,self.PropertiesInstance.aggresion)  -- Возвращает исходное значение агрессии.
	
	local Difficulty = tonumber(getglobal("game_DifficultyLevel"))
	if Difficulty<=1 and not self.IsAiPlayer then -- Уменьшить максимальную дальность видимости на лёгком режиме.
		NewSightRange = NewSightRange*.7
	end
	if NewSightRange>MediumFog then
		NewSightRange=MediumFog
	end
	-- if NewSightRange<110 and MediumFog>=110 then
		-- NewSightRange=110
	-- end
	if MaxNewSightRange then
		if NewSightRange<MaxNewSightRange and MediumFog>=MaxNewSightRange then
			NewSightRange=MaxNewSightRange
		end
	else
		if NewSightRange<110 and MediumFog>=110 then
			NewSightRange=110
		end
	end
	if self.TempIsBlinded then NewSightRange=0 end
	-- Hud:AddMessage(self:GetName()..": NewSightRange: "..NewSightRange)
	-- System:Log(self:GetName()..": NewSightRange: "..NewSightRange)
	if self.CurrentSightRange~=NewSightRange then
		self.CurrentSightRange=NewSightRange
		self:ChangeAIParameter(AIPARAM_SIGHTRANGE,NewSightRange)
	end
	if not self.ForceResponsiveness then -- Заменяет ForceResponsiveness.
		if self.SetAlerted then
			if self.sees==1 then
				if NewResponsiveness < 10 then NewResponsiveness = 10 end
			else
				if NewResponsiveness < 7.5 then NewResponsiveness = 7.5 end
			end
			if NewResponsiveness > MaxResponsiveness then NewResponsiveness = MaxResponsiveness end
		end
		if self.PrevTempIsBlinded and not self.TempIsBlinded then
			NewResponsiveness=10
			-- Hud:AddMessage(self:GetName()..": PrevTempIsBlinded")
			self.PrevTempIsBlinded=nil
		end
		if self.TempIsBlinded then NewResponsiveness=0 end -- Ослеплён фонариком.
		if not self.TurningOnCollision then -- C++
			-- Hud:AddMessage(self:GetName()..": NewResponsiveness: "..NewResponsiveness)
			-- System:Log(self:GetName()..": NewResponsiveness: "..NewResponsiveness)
			self:ChangeAIParameter(AIPARAM_RESPONSIVENESS,NewResponsiveness)
		end
	end
	
	if self.PracticleFireMan then -- Добавить: разрешить ему стрелять по старому, а то в одну точку бьёт... AIPARAM_ATTACKRANGE не убирать!
		self:ChangeAIParameter(AIPARAM_ACCURACY,1)
		self:ChangeAIParameter(AIPARAM_AGGRESION,.5)
		self:ChangeAIParameter(AIPARAM_ATTACKRANGE,10000)
		if self.PropertiesInstance.bHelmetOnStart==1 then
			-- if self.PropertiesInstance.fileHelmetModel=="Objects/characters/mercenaries/accessories/earprotector.cgf" then
			self:ChangeAIParameter(AIPARAM_SOUNDRANGE,1)
		end
		return -- Вниз перенёс потому что нужно регулировать дальность зрения.
	end
	if strfind(self.Behaviour.Name,"Job_Sleep") then return end
	local Skip
	-- if self.PropertiesInstance.soundrange==0 then
		-- if self.MUTANT=="big" and self.PropertiesInstance.sightrange==0 and self.PropertiesInstance.groupid==798 and Game:GetLevelName()=="Archive" then
			-- -- Skip = 1
		-- end
	-- end
	if self.PropertiesInstance.soundrange==0 then
		Skip = 1 -- Временно.
	end
	if not Skip then
		if self.SetAlerted or self.IsAiPlayer or self.IsSpecOpsMan then
			-- if self.sees~=1 then
				-- self:ChangeAIParameter(AIPARAM_SOUNDRANGE,15)
			-- else
				self:ChangeAIParameter(AIPARAM_SOUNDRANGE,10)
			-- end
		else
			self:ChangeAIParameter(AIPARAM_SOUNDRANGE,1)
		end
	end
end

function BasicAI:RunToMountedWeapon()
	local DistanceToEnemy
	local Target
	local att_target = AI:GetAttentionTargetOf(self.id)
	if att_target and type(att_target)=="table" then
		DistanceToEnemy = self:GetDistanceFromPoint(att_target:GetPos())
		Target = att_target
	end
	-- if not Target then
		-- System:Log(self:GetName()..": NO Target")
	-- else
		-- System:Log(self:GetName()..": Target: "..Target:GetName())
	-- end
	-- Специальные тоже должны уметь пользоваться оружием.
	-- if self.RunToTrigger or (DistanceToEnemy and DistanceToEnemy <=15) then -- Передать эстафету другому, если сам не прошёл проверку)) -- Здесь тоже.
	-- if self.RunToTrigger or (DistanceToEnemy and DistanceToEnemy <=5) then
	if self.RunToTrigger or self.theVehicle then return nil	end
	local SearchRadius
	if self.IsIndoor then
		SearchRadius = 10
	else
		SearchRadius = 25
	end
	local Result = self:NewCountingPlayers(60,1,nil,1)
	-- self.MountedGun = AI:FindObjectOfType(self.id,SearchRadius,AIOBJECT_MOUNTEDWEAPON,1)  -- Если возможно, сделать проверку на высоту. Флаг = 1 - если объект в зоне видимости.
	-- if not self.MountedGun then
		self.MountedGun = AI:FindObjectOfType(self.id,SearchRadius,AIOBJECT_MOUNTEDWEAPON) -- Для спекопсов. Можно искать AIOBJECT_WAYPOINT.
	-- end
	self.MountedGunEntity = System:GetEntityByName(self.MountedGun)
	if self.MountedGunEntity then
		local DistanceToMG = self:GetDistanceFromPoint(self.MountedGunEntity:GetPos())
		local EnemyDistanceToMG
		if Target then
			EnemyDistanceToMG = Target:GetDistanceFromPoint(self.MountedGunEntity:GetPos())
		end
		-- if not DistanceToEnemy then DistanceToEnemy="nil" end -- Такие же услоаия добавить и для всего остального.
		-- if not EnemyDistanceToMG then EnemyDistanceToMG="nil" end
		-- System:Log(self:GetName().." MG: "..self.MountedGun..", DistanceToEnemy: "..DistanceToEnemy..", DistanceToMG: "..DistanceToMG..", EnemyDistanceToMG: "..EnemyDistanceToMG)
		-- if DistanceToEnemy=="nil" then DistanceToEnemy=nil end
		-- if EnemyDistanceToMG=="nil" then EnemyDistanceToMG=nil end
		-- if DistanceToEnemy>EnemyDistanceToMG then -- Больше ли дистанция до врага, чем дистанция врага до оружия.
			-- System:Log(self:GetName().." DistanceToEnemy>EnemyDistanceToMG")
		-- end
		-- if DistanceToEnemy<EnemyDistanceToMG then -- Меньше ли дистанция до врага, чем дистанция врага до оружия.
			-- System:Log(self:GetName().." DistanceToEnemy<EnemyDistanceToMG")
		-- end
		-- if DistanceToEnemy>DistanceToMG then -- Больше ли дистанция до врага, чем дистанция до оружия.
			-- System:Log(self:GetName().." DistanceToEnemy>DistanceToMG")
		-- end
		-- if DistanceToEnemy<DistanceToMG then -- Меньше ли дистанция до врага, чем дистанция до оружия.
			-- System:Log(self:GetName().." DistanceToEnemy<DistanceToMG")
		-- end
		-- if DistanceToMG>EnemyDistanceToMG then -- Больше ли дистанция до оружия, чем дистанция врага до оружия.
			-- System:Log(self:GetName().." DistanceToMG>EnemyDistanceToMG")
		-- end
		-- if DistanceToMG<EnemyDistanceToMG then -- Меньше ли дистанция до оружия, чем дистанция врага до оружия.
			-- System:Log(self:GetName().." DistanceToMG<EnemyDistanceToMG")
		-- end
		if (not self.cnt.weapon or self.fireparams.fire_mode_type==FireMode_Melee)
		or DistanceToMG<=5
		or (not Target and Result.Friends>2)
		or (Target and ((not Target.cnt.weapon or Target.fireparams.fire_mode_type==FireMode_Melee)
		or (DistanceToEnemy>EnemyDistanceToMG and DistanceToEnemy*.4>DistanceToMG and DistanceToMG<EnemyDistanceToMG) -- За пулемётом, перед пулемётом враг.
		or (DistanceToEnemy<EnemyDistanceToMG and DistanceToEnemy*.3>DistanceToMG and DistanceToMG<EnemyDistanceToMG))) then -- Перед пулемётом, перед пулемётом и перед ним враг.
			if not self.MountedGunEntity.user and self.MountedGunEntity.engaged==0 and self.MountedGunEntity:GetState()=="Idle" then
				-- Hud:AddMessage(self:GetName()..": Found MG: "..self.MountedGun)
				System:Log(self:GetName()..": Found MG: "..self.MountedGun)
				self.RunToTrigger = 1
				self.MountedGunEntity.engaged = 1 -- Может сущность сюда вписывать?
				AI:Signal(0,1,"SWITCH_TO_MORTARGUY",self.id)
				-- if DistanceToEnemy and DistanceToEnemy<=10 then -- Так, на всякий пожарный. НЕЛЬЗЯ!
					-- self:InsertSubpipe(0,"just_shoot")
				-- else
					self:InsertSubpipe(0,"not_shoot")
				-- end
				return 1
			end
		end
	end
	if self.Behaviour.Name and not strfind(self.Behaviour.Name,"MountedGuy") then -- Если так и не перешёл в состояние гана, то тогда забудь про него.
		if self.MountedGunEntity then
			self.MountedGunEntity.engaged = 0 self.MountedGunEntity = nil self.MountedGun = nil
		end
	end
	-- if DistanceToEnemy and DistanceToEnemy <=15 then
		-- return nil
	-- end
	local fDistance
	local Vehicle
	local Entities
	if GameRules.AllEntities then
		Entities = GameRules.AllEntities
	end
	if Entities then
		for i,entity in Entities do
			if entity.GetName then
				if entity.type=="Vehicle" and entity.AddGunner and entity.Properties.bLockUser~=1 then
					local fDistance2 = self:GetDistanceFromPoint(entity:GetPos())
					if (not fDistance or fDistance>fDistance2) and entity.GetState and entity:GetState()~="Dead" then
						fDistance = fDistance2
						Vehicle = entity
					end
				end
			end
		end
	end
	local NotUse
	if self.NotUseTimerStart then
		if _time<=self.NotUseTimerStart+20 then -- На замену задержке как при поиске якоря, которая не даёт использовать якорь сразу же после его использования.
			NotUse = 1
		else
			self.NotUseTimerStart = nil
		end
	end
	if Vehicle and Vehicle.NotUseTimerStart then
		if _time<=Vehicle.NotUseTimerStart+20 then -- Тоже самое, только касается самой машины.
			NotUse = 1
		else
			Vehicle.NotUseTimerStart = nil
		end
	end
	local OnRangeAllowUse
	if Vehicle then
		local EnemyDistanceToMG
		if Target then
			EnemyDistanceToMG = Target:GetDistanceFromPoint(Vehicle:GetPos())
		end
		if (not self.cnt.weapon or self.fireparams.fire_mode_type==FireMode_Melee)
		or (not Target and Result.Friends>2)
		or (Target and ((not Target.cnt.weapon or Target.fireparams.fire_mode_type==FireMode_Melee)
		or (DistanceToEnemy>EnemyDistanceToMG and DistanceToEnemy*.4>fDistance and fDistance<EnemyDistanceToMG) -- За машиной, перед машиной враг.
		or (DistanceToEnemy<EnemyDistanceToMG and DistanceToEnemy*.2>fDistance and fDistance<EnemyDistanceToMG))) then -- Перед машиной, перед машиной и перед ним враг.
			OnRangeAllowUse = 1
		end
	end
	if (fDistance and fDistance>SearchRadius) or NotUse or not OnRangeAllowUse then
		fDistance = nil
		Vehicle = nil
	end
	if Vehicle then
		if Vehicle.driverT and Vehicle.driverT.entity and Vehicle.driverT.entity.Properties and Vehicle.driverT.entity.Properties.species~=self.Properties.species then return end
		if Vehicle.gunnerT and Vehicle.gunnerT.entity and Vehicle.gunnerT.entity.Properties and Vehicle.gunnerT.entity.Properties.species~=self.Properties.species then return end
		-- self.VehicleMountedGunUser = 1
		-- -- Hud:AddMessage(self:GetName()..": SPECIAL_STOPALL 1")
		-- AIBehaviour.DEFAULT:SPECIAL_STOPALL(self) -- Не помню почему вставлял именно сюда, но это имеет отрицательный эффект. Челы слишком часто начинают стоять на одном месте (standingthere) когда рядом есть стационарный пулемёт.
		-- -- AI:Signal(0,-1,"entered_vehicle",self.id)
		if Vehicle:AddGunner(self)==1 then
			self.VehicleMountedGunUser = 1
			AIBehaviour.DEFAULT:SPECIAL_STOPALL(self)
			self.RunToTrigger = 1
			-- AI:Signal(0,-1,"entered_vehicle",self.id) -- Не убирать, нужно чтобы персонаж отключался в этом состоянии.
			-- AI:Signal(0,1,"SWITCH_TO_MORTARGUY",self.id)
			System:Log(self:GetName()..": Found vehicle: "..Vehicle:GetName())
			return 1
		end
		-- AI:Signal(0,-1,"exited_vehicle2",self.id)
	end
	self.VehicleMountedGunUser = nil
	return nil
end

function BasicAI:RunToVehicle()
	if self.RunToTrigger or self.theVehicle then return nil	end
	local SearchRadius
	if self.IsIndoor then
		SearchRadius = 30
	else
		SearchRadius = 100
	end
	local fDistance
	local Vehicle
	local Entities
	if GameRules.AllEntities then
		Entities = GameRules.AllEntities
	end
	if Entities then
		for i,entity in Entities do
			if entity.GetName then
				if entity.type=="Vehicle" and entity.Properties.bLockUser~=1 and ((not self.IHaveAiFriend and entity.AddDriver)
				or (self.IHaveAiFriend and ((entity.AddDriver and entity.AddGunner) or (entity.AddDriver and entity.AddPassenger)))) then
					local fDistance2 = self:GetDistanceFromPoint(entity:GetPos())
					if (not fDistance or fDistance>fDistance2) and entity.GetState and entity:GetState()~="Dead" then
						fDistance = fDistance2
						Vehicle = entity
					end
				end
			end
		end
	end
	local NotUse
	if self.NotUseTimerStart then
		if _time<=self.NotUseTimerStart+20 then -- На замену задержке как при поиске якоря, которая не даёт использовать якорь сразу же после его использования.
			NotUse = 1
		else
			self.NotUseTimerStart = nil
		end
	end
	if Vehicle and Vehicle.NotUseTimerStart then
		if _time<=Vehicle.NotUseTimerStart+20 then -- Тоже самое, только касается самой машины.
			NotUse = 1
		else
			Vehicle.NotUseTimerStart = nil
		end
	end
	if (fDistance and fDistance>SearchRadius) or NotUse then
		fDistance = nil
		Vehicle = nil
	end
	if Vehicle then
		if Vehicle.driverT and Vehicle.driverT.entity and Vehicle.driverT.entity.Properties and Vehicle.driverT.entity.Properties.species~=self.Properties.species then return end
		if Vehicle.gunnerT and Vehicle.gunnerT.entity and Vehicle.gunnerT.entity.Properties and Vehicle.gunnerT.entity.Properties.species~=self.Properties.species then return end
		-- Hud:AddMessage(self:GetName()..": SPECIAL_STOPALL 2")
		AIBehaviour.DEFAULT:SPECIAL_STOPALL(self)
		if Vehicle then
			Hud:AddMessage(self:GetName()..": Vehicle 0: "..Vehicle:GetName())
			System:Log(self:GetName()..": Vehicle 0: "..Vehicle:GetName())
		end
		if AIBehaviour.DEFAULT:SHARED_ENTER_ME_VEHICLE(self,Vehicle,1)==1 then
			self.RunToTrigger = 1
			Hud:AddMessage(self:GetName()..": Found vehicle 2: "..Vehicle:GetName())
			System:Log(self:GetName()..": Found vehicle 2: "..Vehicle:GetName())
			return 1
		end
	end
	return nil
end

-- function BasicAI:AddSoundTarget() -- C++  Без id бесполезно вообще делать.
	-- Hud:AddMessage(self:GetName()..": AddSoundTarget")
	-- System:Log(self:GetName()..": AddSoundTarget")
	-- if not self.ThreadSoundTable then self.ThreadSoundTable = {} end
	-- local MaxCycle = 10
	-- local TSTargetID
	-- local TSDistanceToTarget
	-- for i=1,MaxCycle do
		-- local OldTable = {}
		-- OldTable[i+1] = self.ThreadSoundTable[i]
		-- self.ThreadSoundTable=OldTable
		-- self.ThreadSoundTable[1]={self.ThreatenSoundTargetID,self.ThreatenSoundDistanceToTarget}
		-- -- for i,val in self.ThreadSoundTable do
		-- -- local MaxDistancePriority=i[2]
		-- -- end
		-- System:Log(self:GetName()..": ThreadSoundTable ID: "..self.ThreadSoundTable[i][1]..", ThreadSoundTable Distance: "..self.ThreadSoundTable[i][2])
	-- end

	-- -- if not self.ThreadSoundTable then self.ThreadSoundTable = {} end
	-- -- local MaxCycle = 10
	-- -- local TSTargetID
	-- -- local TSDistanceToTarget
	-- -- for i=1,10 do
		-- -- local OldTable = {}
		-- -- OldTable[i+1] = self.ThreadSoundTable[i]
		-- -- self.ThreadSoundTable=OldTable
		-- -- self.ThreadSoundTable[1]={self.ThreatenSoundDistanceToTarget,i}
		-- -- for i,val in self.ThreadSoundTable do
		-- -- -- local MaxDistancePriority=i[2]
			-- -- System:Log(self:GetName()..": ThreadSoundTable Distance: "..self.ThreadSoundTable[i][1].. " "..self.ThreadSoundTable[i][2])
		-- -- end
	-- -- end

	-- if not self.ThreadSoundTable then self.ThreadSoundTable = {} end
	-- local OldTable = {}
	-- for i,val in OldTable do
		-- OldTable[i+1] = self.ThreadSoundTable[i]
	-- end
		-- self.ThreadSoundTable = OldTable
	-- for i,val in self.ThreadSoundTable do
		-- System:Log(self:GetName()..": ThreadSoundTable Distance: "..self.ThreadSoundTable[i][1].. " "..self.ThreadSoundTable[i][2])
		-- -- break
	-- end
	-- self.ThreadSoundTable[1]={self.ThreatenSoundDistanceToTarget,"ODIN"}
	-- if not OldTable[1] then OldTable[1]=self.ThreadSoundTable[1] end
	-- -- for i=1,10 do
		-- -- for i,val in self.ThreadSoundTable do
		-- -- -- local MaxDistancePriority=i[2]
			-- -- System:Log(self:GetName()..": ThreadSoundTable Distance: "..self.ThreadSoundTable[i][1].. " "..self.ThreadSoundTable[i][2])
		-- -- end
	-- -- end
-- end

function BasicAI:FastChangeAiFireMode() -- Помогает только с первым, пулемётным режимом, а как быть с ракетами?
	local Current_Weapon = self.cnt.weapon
	local Current_AiMode
	local Current_FireModeNumber = self.firemodenum -- Номер режима стрельбы.
	if self.fireparams then
		Current_AiMode = self.fireparams.ai_mode
	end
	local WeaponsSlots = self.cnt:GetWeaponsSlots()
	if WeaponsSlots then
		for i,New_Weapon in WeaponsSlots do
			if New_Weapon~=0 then
				for m,FireMode in New_Weapon.FireParams do
					local WeaponState = self.WeaponState
					local WeaponInfo = WeaponState[WeaponClassesEx[New_Weapon.name].id]
					local New_FireParams
					local New_AiMode
					local New_FireModeNumber = m
					if WeaponInfo then
						New_FireParams = New_Weapon.FireParams[New_FireModeNumber]
						New_AiMode = New_FireParams.ai_mode
					end
					if Current_Weapon and Current_Weapon.name==New_Weapon.name and Current_FireModeNumber~=New_FireModeNumber and Current_AiMode==0 and New_AiMode==1 then
						System:Log(self:GetName()..": Fast set the AI mode fire. Weapon: "..Current_Weapon.name..", Old FM number: "..Current_FireModeNumber..", New FM number: "..New_FireModeNumber)
						local SaveFM = {Current_FireModeNumber}
						if self.cnt.SwitchFireMode then
							self.cnt:SwitchFireMode(New_FireModeNumber-1)
						end
						self.SetWeaponTable = {New_Weapon.name,New_FireModeNumber,Current_Weapon.name,SaveFM[1]}
						do return end
					end
				end
			end
		end
	end
end

function BasicAI:ForcedShooting() -- Но не всегда же стрелять как бешенный?
	if not self.cnt.weapon then return end
	if self.cnt.weapon.name=="Falcon" then return end -- Временно исключил пистолет из списка, так как при установке уровня сложности, в котором задействована принудительная стрельба, стрелок наоборот "Зависает" и, в итоге, вообще не стреляет с пистолета. Видимо это связано с тем, что стрельба ведётся многократными нажатиями на спусковой крючёк, а не его зажатием. Проверить. Хотя с той же снайперкой зависаний особо и нет... У снайперки не патрон, а снаряд! А он исключен из списка!
	local att_target = AI:GetAttentionTargetOf(self.id)
	if att_target and type(att_target)=="table" then
		if att_target.type=="Player" and self.Properties.species~=att_target.Properties.species then
			local fDistance = self:GetDistanceFromPoint(att_target:GetPos())
			self.AiForcedShootingStart = {_time,fDistance,self.sees}
		end
	end
	if self.AiForcedShootingStart and self.AiForcedShootingStart[3]==1 and self.fireparams.fire_mode_type~=FireMode_Projectile and not self.cnt.flying
	and (self.cnt.ammo_in_clip>0 or self.fireparams.AmmoType=="Unlimited") and not self.cnt.reloading and not self.ThrowGrenadeTime and not self.cnt.proning
	and not self.DoNotShootOnFriendInWayStart and not self.GoLeftOrRightOnFriendInWay and not self.DoNotShootOnFriendsOnTarget
	and self.AI_GunOut and not self.AiPlayerDoNotShoot
	-- and (((not self.IsAiPlayer or self~=_localplayer) and ((_time<=self.AiForcedShootingStart[1]+2 and (self.AiForcedShootingStart[2]<=60 or self.AI_AtWeapon)) -- +2 секунды стрелять, но не более (пока помнит цель в c++). -- 30
	and ((not self.IsAiPlayer and ((_time<=self.AiForcedShootingStart[1]+2 and (self.AiForcedShootingStart[2]<=60 or self.AI_AtWeapon)) -- +2 секунды стрелять, но не более (пока помнит цель в c++). -- 30
	or (((_time>self.AiForcedShootingStart[1]+.5 and _time<=self.AiForcedShootingStart[1]+1)
	or (_time>=self.AiForcedShootingStart[1]+1.5 and _time<=self.AiForcedShootingStart[1]+2)) and self.AiForcedShootingStart[2]<=100) -- Стрелять подавляющими очередями. -- 60
	or _time<=self.AiForcedShootingStart[1]+.2)) -- Для всех остальных случаев +.2 секунды. Ведь не может же человек так сразу реагировать...
	or (self.IsAiPlayer and ((_time<=self.AiForcedShootingStart[1]+1 and self.AiForcedShootingStart[2]<=30)
	or (_time<=self.AiForcedShootingStart[1]+2 and self.AI_AtWeapon)
	or (_time>self.AiForcedShootingStart[1]+.5 and _time<=self.AiForcedShootingStart[1]+1 and self.AiForcedShootingStart[2]<=60 and self.sees==1)))) then
		-- Hud:AddMessage(self:GetName()..": AiForcedShootingStart")
		-- System:Log(self:GetName()..": AiForcedShootingStart")
		if self.IsAiPlayer and self==_localplayer then
			AI:FireOverride(self.id)
		else
			AI:ForcedShooting(self.id) -- Можно сделать, чтобы расстреливали весь магазин и медленно смотрели в стороны... Но это когда своих научатся определять в пустоте...
		end
	elseif self.AiForcedShootingStart and _time>self.AiForcedShootingStart[1]+2 then
		-- Hud:AddMessage(self:GetName()..": AiForcedShootingStop")
		-- System:Log(self:GetName()..": AiForcedShootingStop")
		self.AiForcedShootingStart=nil
		BasicWeapon.Client.OnStopFiring(self.cnt.weapon,self)
	end
end

function BasicAI:UpdateStance() -- C++
end

function BasicAI:AiUpdate() -- C++
	self:UpdateSwimming() -- Плавание.
	self:FastChangeAiFireMode() -- Необходимо очень быстро установить ИИ режим у оружия, если таковой имеется, чтобы ИИ не успел использовать не предназначеный для него (связано с пропажей патронов).
	if self.CurrentConversation or self.OnConversationFinishedStart then -- Мне не нужно чтобы оружие у разговаривающих в руках появлялось и исчезало.
		if self.AI_GunOut then
			self.cnt:HoldGun()
		else
			self.cnt:HolsterGun()
		end
	end
	if self.CurrentInsertAnimDurationStart and _time>self.CurrentInsertAnimDurationStart then self.CurrentInsertAnimDurationStart=nil end -- Я пока не знаю как узнать играет ли сейчас какая-нибудь анимация, поэтому сделал предположительное время.
	local Difficulty = tonumber(getglobal("game_DifficultyLevel"))
	if Difficulty>=2 or self.IsAiPlayer or self.IsSpecOpsMan or self:ForbiddenCharacters() then
		self:ForcedShooting() -- Принудительная стрельба.
	end
	-- if self.AllowVisible then
		-- System:Log(self:GetName()..": AllowVisible: "..self.AllowVisible)
	-- else
		-- System:Log(self:GetName()..": NO AllowVisible")
	-- end
	-- if self.CurrentHorizontalFov then
		-- System:Log(self:GetName()..": CurrentHorizontalFov: "..self.CurrentHorizontalFov)
	-- else
		-- System:Log(self:GetName()..": NO CurrentHorizontalFov")
	-- end
	local att_target = AI:GetAttentionTargetOf(self.id)
	local Current_Weapon = self.cnt.weapon
	if Current_Weapon and Current_Weapon.name~="SniperRifle" and self.fireparams.fire_mode_type==FireMode_Projectile and type(att_target)=="number" then
		self.DoNotShootAGrenadeLauncherIfNoGoalStart = _time -- Круто, теперь гранатомётчик никогда не будет стрелять в "не туда", если видит другой снаряд.
		-- Hud:AddMessage(self:GetName().."$1: att_target: "..type(att_target))
		-- System:Log(self:GetName().."$1: att_target: "..type(att_target))
		-- self:TriggerEvent(AIEVENT_CLEAR)
		-- self:InsertSubpipe(0,"devalue_target")
	elseif self.DoNotShootAGrenadeLauncherIfNoGoalStart and _time>self.DoNotShootAGrenadeLauncherIfNoGoalStart+1 then
		self.DoNotShootAGrenadeLauncherIfNoGoalStart = nil
	end
end

function BasicAI:BasicPlayerTimer()
	self:SetAccuracy() -- Установить меткость. -- Не менять порядок между этим и SeenTimer.
	self:SeenTimer() -- Проверка на возможность уйти в спокойное состояние.
	-- self:AiCheckCollisions() -- Через C++
	self:FriendGroup() -- Настроить группу союзника.
	self:SetActualName() -- Показывает настоящее имя.
	self:CheckFlashLight(1) -- Включить фонарик или нет?
	self:WeaponManager() -- Управление оружием.
	self:OnDeadBodySeenUpdate() -- "Вижу труп".
	self:GoBack() -- Отойти назад если цель скрылась и была выше ИИ.
	if self.IsAiPlayer then
		self:CheckPlayerCopyParams()
		self:CheckAiPlayerParams()
	end
	self:Other() -- Для всякого разного.
	self:OnCloseContactUpdate() -- Ручное обновление функции OnCloseContact, ибо стандартное не как мне надо настроено.
end

function BasicAI:OnCloseContactUpdate()
	-- if not self.OnCloseContactStart then self.OnCloseContactStart=_time end
	-- if _time<=self.OnCloseContactStart+.3 then return end
	-- self.OnCloseContactStart = nil
	local Entities
	if GameRules.AllEntities then
		Entities = GameRules.AllEntities -- В режиме редактора не обновляется, не забывай.
	end
	local fDistance
	local MaxDistance = 2
	if self.sees~=0 and self.WasInCombat then
		MaxDistance = 3
	end
	local Entity
	if Entities then
		for i,entity in Entities do
			if entity.type=="Player" and self.id~=entity.id and BasicPlayer.IsAlive(entity) and not entity.ANIMAL then
				local fDistance2 = self:GetDistanceFromPoint(entity:GetPos())
				if not fDistance or fDistance>fDistance2 then
					fDistance = fDistance2
					if fDistance<=MaxDistance then
						Entity = entity
					end
				end
			end
		end
	end
	if Entity then
		-- System:Log(self:GetName()..": OnCloseContactUpdate: "..Entity:GetName())
		local att_target = AI:GetAttentionTargetOf(self.id)
		if self.Properties.species~=Entity.Properties.species and (not att_target or (att_target and type(att_target)=="table" and Entity~=att_target)) then
			-- for i=1,100 do
				self:ChangeAIParameter(AIPARAM_SIGHTRANGE,0) -- Оно потом сразу восстанавливается.
				self.CurrentSightRange = 0
				self.ForceResponsiveness = 1
				self:ChangeAIParameter(AIPARAM_RESPONSIVENESS,10)
				AI:CreateGoalPipe("AcqTarget2")
				AI:PushGoal("AcqTarget2","form",0,"beacon")
				AI:PushGoal("AcqTarget2","locate",0,"beacon")
				AI:PushGoal("AcqTarget2","acqtarget",1,"")
				AI:PushGoal("AcqTarget2","signal",0,-1,"NIL_FORCE_RESPONSIVENESS",0)
				self:InsertSubpipe(0,"AcqTarget2",Entity.id)
			-- end
			-- System:Log(self:GetName()..": BasicAI/OnCloseContact: "..Entity:GetName())
		end
		-- if self.Behaviour.OnCloseContact then
			-- self.Behaviour:OnCloseContact(self,Entity,fDistance)
		-- else
			-- if AIBehaviour[self.DefaultBehaviour] then
				-- if AIBehaviour[self.DefaultBehaviour].OnCloseContact then
					-- AIBehaviour[self.DefaultBehaviour]:OnCloseContact(self,Entity,fDistance)
				-- else
					-- AIBehaviour.DEFAULT:OnCloseContact(self,Entity,fDistance)
				-- end
			-- end
		-- end
	end
end

function BasicAI:OnDeadBodySeenUpdate() -- Добавить: чем темнее, тем меньше расстояние.
	if not BasicPlayer.IsAlive(_localplayer) then return end -- Когда игрока убивают, то ясно, что он был обнаружен и только что, как правило, громко убит где-то совсем рядом, а значит говорить "Что здесь произошло?" - не в тему.
	-- if not self.OnDeadBodySeenUpdateTimer then self.OnDeadBodySeenUpdateTimer = _time end
	-- if _time <= self.OnDeadBodySeenUpdateTimer+5 then return else self.OnDeadBodySeenUpdateTimer = nil end -- При System:GetEntities(), на больших картах где есть огромное количество сущностей стабильно лагало, сейчас подлагивает.
	local ObjectName = AI:FindObjectOfType(self.id,60,AIOBJECT_PUPPET,1+2)
	if not ObjectName then
		ObjectName = AI:FindObjectOfType(self.id,60,AIOBJECT_PLAYER,1+2)
	end
	local Entity
	if ObjectName then
		local fDistance
		-- Hud:AddMessage(self:GetName().." ObjectName: "..ObjectName)
		-- System:Log(self:GetName().." ObjectName: "..ObjectName)
		-- Entity = System:GetEntityByName(ObjectName)
		-- if not Entity then -- Когда сущность "погибает", она перестаёт искаться.
			-- local Entities = System:GetEntities() -- И никакой поиск объектов не нужен. Хотя, провеку на коллизии как реализовать?
			-- for i,Entity2 in Entities do
				-- local ThisIsIt = strfind(ObjectName,Entity2:GetName())
				-- if Entity2.type=="Player" and ThisIsIt then
					-- Entity = Entity2
					-- break
				-- end
			-- end
		-- end
		-- if not Entity then
			-- local Entities = {}
			-- Game:GetPlayerEntitiesInRadius(self:GetPos(),60,Entities) -- Эта штука не учитывает трупы.
			-- for i,Entity2 in Entities do
				-- Entity2 = Entity2.pEntity
				-- local ThisIsIt = strfind(ObjectName,Entity2:GetName())
				-- if Entity2.type=="Player" and ThisIsIt then
					-- Entity = Entity2
					-- break
				-- end
			-- end
		-- end
		if not Entity then
			local Entities
			if GameRules.AllEntities then
				Entities = GameRules.AllEntities
			end
			-- if Entities then
				-- for i,Entity2 in Entities do
					-- if Entity2.type=="Player" and Entity2.GetName then
						-- -- local ThisIsIt = strfind(ObjectName,Entity2:GetName()) -- Из-за этого критически вылетает. (
						-- if ThisIsIt then
							-- System:Log(self:GetName()..": Entity2: "..Entity2:GetName()..", ObjectName: "..ObjectName)
							-- Entity = Entity2
							-- break
						-- end
					-- end
				-- end
			-- end
			if Entities then
				for i,entity in Entities do
					if entity.GetName then
						if entity.type=="Player" and self.id~=entity.id and not BasicPlayer.IsAlive(entity) and not entity.ANIMAL
						and entity.Properties.species==self.Properties.species then
							local Skip
							if self.PracticleFireMan and entity.MUTANT and entity.MUTANT=="big" and entity.PropertiesInstance.soundrange==0
							and entity.PropertiesInstance.sightrange==0 and self.Properties.species==entity.Properties.species
							and entity.PropertiesInstance.groupid==798 then
								if Game:GetLevelName()=="Archive" then
									Skip = 1
								end
							end
							-- local pos = self:GetPos()
							-- local angle = self:GetAngles()
							-- local newangle = angle
							-- -- self.cnt:GetFirePosAngles(pos,angle)
							-- local hits = System:RayWorldIntersection(pos,angle,1,ent_static+ent_sleeping_rigid+ent_rigid+ent_living+ent_independent,self.id)
							-- local hits = System:RayWorldIntersection(pos,angle,1,ent_all,self.id)
							-- if getn(hits)>0 then
							if not Skip then
								local fDistance2 = self:GetDistanceFromPoint(entity:GetPos())
								if not fDistance or fDistance>fDistance2 then
									fDistance = fDistance2
									Entity = entity
								end
							end
						end
					end
				end
			end
		end
		-- if Entity and fDistance<=30 then -- and Entity.id~=self.id - мало ли.
		if Entity and ((not self.IsIndoor and fDistance<=30) or (self.IsIndoor and fDistance<=10)) then -- Временно!!! Пока не найду способ проверки на видимость трупа...
			-- Hud:AddMessage(self:GetName()..": Entity: "..Entity:GetName())
			-- System:Log(self:GetName()..": Entity: "..Entity:GetName())
				-- if self.Properties.species==Entity.Properties.species then
				-- local IsJob = strfind(self.Behaviour.Name,"Job_")
				-- local IsIdle = strfind(self.Behaviour.Name,"Idle")
				-- or (self.Properties.species~=Entity.Properties.species and (IsJob or IsIdle or not self.WasInCombat)) then
				if not self.DeadBodySeenStart then self.DeadBodySeenStart=_time end
				if self.DeadBodySeenStart then
					-- if _time>self.DeadBodySeenStart+2 or ((not IsJob and not IsIdle) or self.WasInCombat) then
					if _time>self.DeadBodySeenStart+2 or self.WasInCombat then
						local fDistance = self:GetDistanceFromPoint(Entity:GetPos())
						if self.Behaviour.OnDeadBodySeen then
							self.Behaviour:OnDeadBodySeen(self,Entity,fDistance)
						else
							if AIBehaviour[self.DefaultBehaviour] then
								if AIBehaviour[self.DefaultBehaviour].OnDeadBodySeen then
									AIBehaviour[self.DefaultBehaviour]:OnDeadBodySeen(self,Entity,fDistance)
								else
									AIBehaviour.DEFAULT:OnDeadBodySeen(self,Entity,fDistance)
								end
							end
						end
					else -- только в атаке вроде как должно отсутствовать.
						if AI:IsMoving(self.id) then -- and self.sees==0
							AI:EnablePuppetMovement(self.id,0,1)
						end
						self:InsertSubpipe(0,"LookAtTheBody2",Entity.id) -- Сначала посмотрит на труп, а уже потом отреагирует.
					end
				end
		elseif self.DeadBodySeenStart then
			self.DeadBodySeenStart = nil
		end
	end
end

function BasicAI:Other()
	-- self.att_target = AI:GetAttentionTargetOf(self.id) -- Работает?
	if self.MUTANT and not self.IsMutant then -- Сделать по нормальному. C++
		self.IsMutant=1
	elseif not self.MUTANT and self.IsMutant then
		self.IsMutant=nil
	end
	if self.ANIMAL and not self.IsAnimal then -- Сделать по нормальному. C++
		self.IsAnimal=1
	elseif not self.ANIMAL and self.IsAnimal then
		self.IsAnimal=nil
	end

	if self.ANIMAL and self.Properties.bAffectSOM==1 then self.Properties.bAffectSOM=0 end -- Свиьни в спекопсе иногда "видят" игрока игрока. Это влияет на шкалу.

	self.PrevMovingStatus=self.cnt.moving
	local fDistance
	local att_target = AI:GetAttentionTargetOf(self.id)
	if att_target and type(att_target)=="table" then
		fDistance = self:GetDistanceFromPoint(att_target:GetPos())
		if self.SaveIdSeen~=att_target.id then
			self.SaveIdSeen = att_target.id -- Сохранить индетификатор последней увиденной цели. Кстати, ведь можно сохранить все увиденные цели!!!
		end
	-- else
		-- if self.sees==1 then -- Исправление.
			-- if not self.not_sees_timer_start==0 then
				-- self.sees=2
			-- else
				-- self.sees=0
			-- end
		-- end
	end
	-- if self.PrintLog~=self.cnt then
		-- self.PrintLog=self.cnt
		-- for i,logg in self.cnt do
			-- System:Log(self:GetName()..": CNT: "..i)
		-- end
	-- end
	-- if self.MUTANT and self.MUTANT=="predator" and not self.ThisMutantJump then
	-- AI:MakePuppetIgnorant(self.id,0) -- Не помогает.
	-- end
	if self.ThrowGrenadeTime and _time>self.ThrowGrenadeTime then self.ThrowGrenadeTime = nil end
	-- if self.MERC and self.MERC=="sniper" or (Current_Weapon and (Current_Weapon.name=="RL" or Current_Weapon.name=="SniperRifle")) then
	-- end

	if self.Properties.bMayBeInvisible and UI then
		if not self.OnInitMayBeInvisible then
			local MayBeInvisible = tonumber(getglobal("game_PredatorsMayBeInvisible"))
			if MayBeInvisible then self.OnInitMayBeInvisible = MayBeInvisible end
			-- System:Log(self:GetName()..": BAI MayBeInvisible: "..MayBeInvisible)
		end
		if self.OnInitMayBeInvisible and self.OnInitMayBeInvisible~=-1 and self.Properties.bMayBeInvisible~=self.OnInitMayBeInvisible then
			self.Properties.bMayBeInvisible = self.OnInitMayBeInvisible
			-- System:Log(self:GetName()..": BAI self.Properties.bMayBeInvisible: "..self.Properties.bMayBeInvisible)
		end
	end

	if self.DoNotShootOnFriendInWayStart then -- Не стрелять сразу после избегания друзей.
		local NotShootTime = 3 -- 5
		if fDistance and fDistance <= 30 then NotShootTime = 1.5 end -- 3
		if _time>self.DoNotShootOnFriendInWayStart+NotShootTime then self.DoNotShootOnFriendInWayStart = nil self.GoLeftOrRightOnFriendInWay = nil self:InsertSubpipe(0,"just_shoot") end -- Джаст шот чтобы убрать дамб шот, если он вдруг есть.
	end
	local Result = self:NewCountingPlayers(1.5,1,1,nil) -- 3 -- Не стрелять когда рядом с врагом друг. Двух-трёх метров достаточно.
	-- if Result.Friends then self.DoNotShootOnFriendsOnTarget = 1 elseif self.DoNotShootOnFriendsOnTarget then self.DoNotShootOnFriendsOnTarget = nil	self:InsertSubpipe(0,"just_shoot") end
	if Result.Friends and not self.DoNotShootOnFriendsOnTarget then
		self.DoNotShootOnFriendsOnTarget = _time
		-- self:InsertSubpipe(0,"just_shoot") -- Я хз, но вызывает лаговатую ходьбу при ходбе в релаксе и стрельбу в своих при использовании AIEVENT_CLEAR.
	elseif self.DoNotShootOnFriendsOnTarget and _time>self.DoNotShootOnFriendsOnTarget+1 then
		self.DoNotShootOnFriendsOnTarget = nil
	end
	local Result2 = self:NewCountingPlayers(1.5,1,nil,nil) -- 2 -- Не стрелять когда совсем рядом есть друг. Надо сделать определение позиции.
	-- if Result2.Friends and not self.theVehicle then
		-- -- self.DoNotShootOnFriendsOnClose = 1
		-- self.GoLeftOrRightOnFriendInWay = nil
		-- AIBehaviour.DEFAULT:OnFriendInWay(self)
	-- -- elseif self.DoNotShootOnFriendsOnClose then
		-- -- self.DoNotShootOnFriendsOnClose = nil
		-- -- self:InsertSubpipe(0,"just_shoot")
	-- end
	if Result2.Friends and not self.theVehicle and self.WasInCombat and self.sees~=0 then
		-- self.GoLeftOrRightOnFriendInWay = nil
		-- AIBehaviour.DEFAULT:OnFriendInWay(self) -- Временно отключил!!! В основоном из-за AiPalyer'а с другом....
	end

	local NeedHealth
	-- if self.cnt.health~=self.Properties.max_health then
	if self.cnt.health<=255 then
		NeedHealth = 1
		-- Hud:AddMessage(self:GetName()..": NeedHealth = 1")
	end
	local NeedArmor
	if not NeedHealth and self.cnt.armor and self.cnt.max_armor and self.cnt.armor~=self.cnt.max_armor then -- Если аптечка не нужна, то тогда ищу броню... Только для ИИ игрока.
		NeedArmor = 1
		-- Hud:AddMessage(self:GetName()..": NeedArmor = 1")
	end
	-- Hud:AddMessage(self:GetName()..": self.cnt.armor: "..self.cnt.armor..", self.cnt.max_armor: "..self.cnt.max_armor)
	-- System:Log(self:GetName()..": self.cnt.health: "..self.cnt.health)
	-- if self.WasInCombat and self.allow_search and not self.MUTANT and not self.ANIMAL
	if self.WasInCombat and not self.MUTANT and not self.ANIMAL
	and not self.IsSpecOpsMan and self.Properties.bInvulnerable~=1 and not self.RunToTrigger and not self.AI_AtWeapon and not self.theVehicle
	-- and self.sees~=1 and (NeedHealth or NeedArmor) then
	-- and self.sees~=1 and (NeedHealth or NeedArmor) and (self.allow_search or self.sees==2)  then -- Добавить: сделать чтобы ИИ игрок искал это даже когда ещё не был в бою.
	and self.sees~=1 and (NeedHealth or NeedArmor) then -- Добавить: сделать чтобы ИИ игрок искал это даже когда ещё не был в бою.
		if self:FindHealth(NeedArmor) then -- Поиск аптечки/брони.
			self.GoToPickup = self.FoundHealth
			self.GoToHealth = 1
			self.RunToTrigger = 1
			AI:Signal(0,1,"SEARCH_AMMUNITION",self.id)
		end
	end

	-- if self.sees==2 then
		-- if not self.ForceNoTargetTimerStart then
			-- self.ForceNoTargetTimerStart = _time
		-- end
	-- elseif self.ForceNoTargetTimerStart then
		-- self.ForceNoTargetTimerStart = nil
	-- end
	-- if self.ForceNoTargetTimerStart and _time>self.ForceNoTargetTimerStart+30 then
		-- AI:Signal(0,1,"OnNoTarget",self.id) -- Должно принудительно вызывать OnNoTarget, если этого не произошло раньше.
		-- self.ForceNoTargetTimerStart = nil
	-- end

	local Special
	if self.MERC=="cover" and self.Properties.species==1 and strlower(self:GetName())=="crowe2" and Game:GetLevelName()=="Training" then
		Special = 1
	end

	-- local IsJob = strfind(self.Behaviour.Name,"Job_")
	
	-- local Trigger = self.RunToTrigger
	
	local PracticleFireMan = self.PracticleFireMan
	
	local DistanceToPlayer
	if _localplayer then -- Как-то потребовало.
		DistanceToPlayer = self:GetDistanceToTarget(_localplayer)
	end
	local FPS = tonumber(getglobal("FPS"))
	-- if not self.theVehicle and not self.IsAiPlayer and not self.IsSpecOpsMan and self.Properties.special~=1 and (DistanceToPlayer>2000 or (FPS and FPS<24 and DistanceToPlayer>1500) or (FPS and FPS<=18 and DistanceToPlayer>1000) or (FPS and FPS<=10 and DistanceToPlayer>500) or (FPS and FPS<=5)) then
	-- if not self.theVehicle and not self.IsAiPlayer and not self.IsSpecOpsMan and self.Properties.special~=1 and (DistanceToPlayer>1500 or (FPS and FPS<24)) then
	-- if not self.theVehicle and not self.IsAiPlayer and not self.IsSpecOpsMan and self.Properties.special~=1 and self.sees==0 and DistanceToPlayer and DistanceToPlayer>500 and FPS and FPS<24 and ((self.not_sees_timer_start==0 or _time>=self.not_sees_timer_start+6*60 and self.WasInCombat) or FPS<=3) then
	-- if not self.theVehicle and not self.IsAiPlayer and not self.IsSpecOpsMan and self.Properties.special~=1 and self.sees==0 and (not DistanceToPlayer or DistanceToPlayer>300) and FPS and FPS<24 and ((self.not_sees_timer_start==0 or _time>=self.not_sees_timer_start+6*60 and self.WasInCombat) or FPS<=10) then
	if not self.theVehicle and not self.AI_AtWeapon and not self.IsAiPlayer and not self.IsSpecOpsMan and self.Properties.special~=1
	and not self.bEnemy_Hidden and not self.bEnemy_Hidden2 and not Special and not IsJob and not Trigger and not PracticleFireMan
	-- and FPS and (not DistanceToPlayer or ((self.sees==0 and FPS<24 and DistanceToPlayer>300) or (self.sees~=1 and FPS<=10))) then
	and FPS and (not DistanceToPlayer or ((self.sees==0 and FPS<30 and DistanceToPlayer>300) or (self.sees~=1 and FPS<=24))) then -- Предпоследнее.
	-- and FPS and (not DistanceToPlayer or ((self.sees==0 and FPS<40 and DistanceToPlayer>200) or (self.sees~=1 and FPS<40))) then
		-- Hud:AddMessage(self:GetName()..": SLEEP")
		self.OnWakeUp = nil
		self:TriggerEvent(AIEVENT_SLEEP) -- Надоело лагание из-за того, что активируется почти вся карта (island of the ill).
	end
	
	-- if not self.theVehicle and not self.IsAiPlayer and not self.IsSpecOpsMan and self.Properties.special~=1 and not self.bEnemy_Hidden and FPS and DistanceToPlayer then
	if not self.theVehicle and not self.IsAiPlayer and not self.IsSpecOpsMan and self.Properties.special~=1 and not self.bEnemy_Hidden and FPS
	and DistanceToPlayer and self.cnt.health > 0 and not Special and not IsJob and not Trigger and not PracticleFireMan then
		
		-- Hud:AddMessage(self:GetName()..": DistanceToPlayer: "..DistanceToPlayer)
		-- if not self.bEnemy_Hidden2 and self.sees==0 and (not DistanceToPlayer or DistanceToPlayer>500) and FPS and FPS<=10
		local AllowActivateOnScopeOnSeenEntity
		if GameRules.PlayerEntitiesScreenSpace then
			for i,entity in GameRules.PlayerEntitiesScreenSpace do
				-- if entity.DistFromCenter<30 then
				local ent = entity.pEntity
				if ent==self then
					if entity.pEntity.type=="Player" and ent.cnt.health>0 then
						AllowActivateOnScopeOnSeenEntity = 1
						-- Hud:AddMessage(_localplayer:GetName()..": aim target: "..ent:GetName())
						-- System:Log(_localplayer:GetName()..": aim target: "..ent:GetName())
					end
				end
			end
		end
		-- if not self.bEnemy_Hidden2 and self.sees==0 and DistanceToPlayer>255 and FPS<=24 -- Оказывается, бинокль показывет совсем другие значения дальности.
		-- and (self.not_sees_timer_start==0 or _time>=self.not_sees_timer_start+6*60) -- Доработать теперь это.
		-- -- and not ClientStuff.vlayers:IsActive("WeaponScope") and not ClientStuff.vlayers:IsActive("Binoculars") and not AllowActivateOnScopeOnSeenEntity then
		-- and not AllowActivateOnScopeOnSeenEntity then
			-- if self:Event_Hide() then Hud:AddMessage(self:GetName()..": Event_Hide") self.bEnemy_Hidden2 = 1 end
			-- -- if self:Event_Hide() then self.bEnemy_Hidden2 = 1 end
		-- -- elseif self.bEnemy_Hidden2 and (FPS>24 and (DistanceToPlayer<=255 or (AllowActivateOnScopeOnSeenEntity and (ClientStuff.vlayers:IsActive("WeaponScope") or ClientStuff.vlayers:IsActive("Binoculars"))))) then
		-- elseif self.bEnemy_Hidden2 and (DistanceToPlayer<=100 or FPS>=60 or (AllowActivateOnScopeOnSeenEntity and (DistanceToPlayer<=255 or FPS>24))) then
			-- if self:Event_UnHide() then Hud:AddMessage(self:GetName()..": Event_UnHide") self.bEnemy_Hidden2 = nil end
		-- end
		-- if not self.bEnemy_Hidden2 and not self.RunToTrigger and self.sees~=1 and DistanceToPlayer>100 and FPS<=24 and not AllowActivateOnScopeOnSeenEntity

		-- if self.bEnemy_Hidden2 then
			-- self:TriggerEvent(AIEVENT_DISABLE)
			-- self:Event_Hide()
			-- Hud:AddMessage(self:GetName()..": RE Hide")
		-- end

		-- if not self.bEnemy_Hidden2 and self.sees~=1 and DistanceToPlayer>50 and FPS<=40 and not AllowActivateOnScopeOnSeenEntity
		-- and ((not ClientStuff.vlayers:IsActive("WeaponScope") and not ClientStuff.vlayers:IsActive("Binoculars")) or DistanceToPlayer>255) then -- Оказывается, бинокль показывет совсем другие значения дальности.
			-- if self:Event_Hide() then Hud:AddMessage(self:GetName()..": Event_Hide") self.bEnemy_Hidden2 = 1 end
		-- elseif self.bEnemy_Hidden2 and (self.sees==1 or (DistanceToPlayer<=50 or FPS>=60 or (AllowActivateOnScopeOnSeenEntity and (DistanceToPlayer<=255 and FPS>=60))
		-- or (AllowActivateOnScopeOnSeenEntity and DistanceToPlayer<=255)
		-- or ((ClientStuff.vlayers:IsActive("WeaponScope") or ClientStuff.vlayers:IsActive("Binoculars")) and DistanceToPlayer<=255 and AllowActivateOnScopeOnSeenEntity))) then
			-- if self:Event_UnHide() then Hud:AddMessage(self:GetName()..": Event_UnHide") self.bEnemy_Hidden2 = nil end
		-- end

		-- if not self.bEnemy_Hidden2 and self.sees==0 and DistanceToPlayer>50 and FPS<=40 and not AllowActivateOnScopeOnSeenEntity
		-- and ((not ClientStuff.vlayers:IsActive("WeaponScope") and not ClientStuff.vlayers:IsActive("Binoculars")) or DistanceToPlayer>255) then -- Оказывается, бинокль показывет совсем другие значения дальности.
			-- -- if self:Event_Hide() then Hud:AddMessage(self:GetName()..": Event_Hide") self.bEnemy_Hidden2 = 1 end
			-- if self:Event_Hide() then self.bEnemy_Hidden2 = 1 end
		-- elseif self.bEnemy_Hidden2 and (self.sees~=0 or (DistanceToPlayer<=50 or FPS>=60 or (AllowActivateOnScopeOnSeenEntity and (DistanceToPlayer<=255 and FPS>=60))
		-- or (AllowActivateOnScopeOnSeenEntity and DistanceToPlayer<=500)
		-- or ((ClientStuff.vlayers:IsActive("WeaponScope") or ClientStuff.vlayers:IsActive("Binoculars")) and DistanceToPlayer<=255 and AllowActivateOnScopeOnSeenEntity))) then
			-- -- if self:Event_UnHide() then Hud:AddMessage(self:GetName()..": Event_UnHide") self.bEnemy_Hidden2 = nil end
			-- if self:Event_UnHide() then self.bEnemy_Hidden2 = nil end
		-- end

		-- Непонятки со всей этой фигнёй...
		if not self.bEnemy_Hidden2 and self.sees==0 and DistanceToPlayer>50 and FPS<=40 and not AllowActivateOnScopeOnSeenEntity -- Предпоследнее.
		-- if not self.bEnemy_Hidden2 and self.sees==0 and DistanceToPlayer>50 and FPS<60 and (not AllowActivateOnScopeOnSeenEntity or DistanceToPlayer>255)
		and ((not ClientStuff.vlayers:IsActive("WeaponScope") and not ClientStuff.vlayers:IsActive("Binoculars")) or DistanceToPlayer>255) then -- Оказывается, бинокль показывет совсем другие значения дальности.
			-- Hud:AddMessage(self:GetName()..": DISABLE")
			self:TriggerEvent(AIEVENT_DISABLE)
			self.bEnemy_Hidden2 = 1
		elseif self.bEnemy_Hidden2 and (self.sees~=0 or (DistanceToPlayer<=50 or FPS>=60 or (AllowActivateOnScopeOnSeenEntity and (DistanceToPlayer<=255 and FPS>=60)) -- Предпоследнее.
		-- elseif self.bEnemy_Hidden2 and (self.sees~=0 or (DistanceToPlayer<=50 or FPS>60 or (AllowActivateOnScopeOnSeenEntity and DistanceToPlayer<=500 and FPS>=60)
		-- elseif self.bEnemy_Hidden2 and (self.sees~=0 or (DistanceToPlayer<=50 or FPS>=60 -- or (AllowActivateOnScopeOnSeenEntity and DistanceToPlayer<=500 and FPS>=60)
		or (AllowActivateOnScopeOnSeenEntity and DistanceToPlayer<=500)
		-- or (AllowActivateOnScopeOnSeenEntity and DistanceToPlayer<=255 and FPS>=40)
		or ((ClientStuff.vlayers:IsActive("WeaponScope") or ClientStuff.vlayers:IsActive("Binoculars")) and DistanceToPlayer<=255 and AllowActivateOnScopeOnSeenEntity))) then
			-- Hud:AddMessage(self:GetName()..": ENABLE")
			self:TriggerEvent(AIEVENT_ENABLE)
			self.bEnemy_Hidden2 = nil
		end

		-- if not self.bEnemy_Hidden2 then
			-- if self:Event_Hide() then Hud:AddMessage(self:GetName()..": Event_Hide") self.bEnemy_Hidden2 = 1 end
		-- end
	end
	-- if self.sees==1 and self.bEnemy_Hidden2 then
		-- Hud:AddMessage(self:GetName()..": SeenInHidden")
	-- end
	-- Hud:AddMessage(self:GetName()..": UPDATE")

	if self.IsAiPlayer then self:TriggerEvent(AIEVENT_WAKEUP) end

	if self.theVehicle and self.theVehicle.cnt then -- Добавить проверку на патроны когда удастя исправить глюк с пропаданием магазинов в машине при повторных посадках ИИ.
		if self.theVehicle.cnt.engineHealthReadOnly<=30 and not self.theVehicle.InTheCarPlayer then -- Выйти из машины, если она сильно повреждена.
			local IPassenger
			for idx=1,self.theVehicle.passengerLimit do
				if self.theVehicle.passengersTT[idx].entity==self and self.theVehicle.passengersTT[idx].state~=4 then
					IPassenger = 1
					break
				end
			end
			if (self.theVehicle.driverT and self.theVehicle.driverT.entity==self and self.theVehicle.driverT.state~=4)
			or (self.theVehicle.gunnerT and self.theVehicle.gunnerT.entity==self and self.theVehicle.gunnerT.state~=4)
			or IPassenger then
				AI:Signal(0,1,"RETURN_TO_NORMAL",self.id)
				VC.DropPeople(self.theVehicle)
				if self.theVehicle then -- error: attempt to index field `theVehicle' (a nil value)
					-- Hud:AddMessage(self:GetName()..": Get out of the damaged car: "..self.theVehicle:GetName())
					System:Log(self:GetName()..": Get out of the damaged car: "..self.theVehicle:GetName())
				end
			end
		end
	end

	if self.ladder then -- Слабый импульс в сторону куда смотрит. Это так, чтоб хоть как-то двигались...
		-- System:Log(self:GetName()..": Ladder: "..self.ladder:GetName())
		local Direction = self:GetDirectionVector()
		-- System:Log(self:GetName()..": Direction x: "..Direction.x..", y: "..Direction.y..", z: "..Direction.z)
		self:AddImpulseObj(Direction,50)
		-- self:AddImpulseObj({0,0,1},100)
	end

	-- if self.Properties.bHasShield and self.Properties.bHasShield==1then
		-- if self.AI_AtWeapon or self.theVehicle then
			-- if self.AttachedShield then
				-- self:DetachObjectToBone("Bip01 L Hand",self.AttachedShield)
			-- end
		-- else
			-- if not self.AttachedShield then
				-- self.AttachedShield = self:LoadObject("Objects\\characters\\mercenaries\\accessories\\shield.cgf",1,1)
				-- self:AttachObjectToBone(1,"Bip01 L Hand")
			-- end
		-- end
	-- end

	if self.OnConversationFinishedStart and _time>self.OnConversationFinishedStart+2 then self.OnConversationFinishedStart=nil end -- Задержка сразу после окончания разговора.

	if self.Behaviour.Name and strfind(self.Behaviour.Name,"MountedGuy") and self.MountedGunEntity and self.MountedGunEntity.engaged==1 -- Не поверишь, но self.Behaviour.Name может быть nil. )
	and not self.AI_AtWeapon then -- Постоянно посылать этот сигнал, пока не сядет за пушку.
		-- if fDistance and fDistance<=30 then -- Из-за этого тормозит лишний раз.
			-- self:InsertSubpipe(0,"just_shoot")
		-- else
			-- self:InsertSubpipe(0,"not_shoot")
		-- end
		AI:Signal(0,1,"USE_MOUNTED_WEAPON",self.id)
	end
	local Current_Weapon = self.cnt.weapon
	if self.MERC=="sniper" and Current_Weapon and (Current_Weapon.name=="RL" or Current_Weapon.name=="SniperRifle")	and self.WasInCombat
	and (self.sees~=0 or self.not_sees_timer_start~=0) then -- В бою постоянно отключать снайперу возможность перемещаться. Но если это не снайпер, а cover, как в большинстве случаев, то что тогда?
		AI:EnablePuppetMovement(self.id,0,1) -- Не могу выяснить, что заставляет его иногда перемещаться, а следовательно прыгать и падать или, просто, падать.
	end

	self.PrevTempIsBlinded=self.TempIsBlinded
	if self.TempIsBlinded and _time>self.TempIsBlinded+1 then self.TempIsBlinded=nil self:InsertSubpipe(0,"just_shoot") end -- Сколько времени быть ослеплённым от фонарика. Перенести в c++.

	if self.CurrentConversation then -- Стереть выбранный разговор, если людей на него так и не хватило. Это чтобы выбирался какой-нибудь другой.
		if not self.WaitParticipantsStart then
			self.WaitParticipantsStart = _time
		else
			if _time>self.WaitParticipantsStart+1 then
				if self.CurrentConversation.Joined<self.CurrentConversation.Participants then
					-- Hud:AddMessage(self:GetName()..": Join: "..self.CurrentConversation.Joined..", Participants: "..self.CurrentConversation.Participants)
					self.CurrentConversation = nil
				end
			end
		end
	elseif self.WaitParticipantsStart then
		self.WaitParticipantsStart = nil
	end

	-- if self.AllowUseMeleeOnNoAmmoInWeapons then
		-- Hud:AddMessage(self:GetName()..": self.AllowUseMeleeOnNoAmmoInWeapons 1")
	-- else
		-- Hud:AddMessage(self:GetName()..": self.AllowUseMeleeOnNoAmmoInWeapons 0")
	-- end
	if self.Behaviour.Name=="SearchAmmunition" and self.sees==1 and fDistance and fDistance<=30 and not self.AllowUseMeleeOnNoAmmoInWeapons then
		-- AIBehaviour.SearchAmmunition:OnPlayerSeen(self,fDistance,1)
		AI:Signal(0,1,"EXIT_SEARCH_AMMUNITION",self.id)
	end
	local Pos = new(self:GetPos())
	if self.BehaviourPrevPos and self.BehaviourPrevPos==Pos then -- Может ещё отсчёт времени добавить?
		if self.Behaviour.Name=="SearchAmmunition" then
			AI:Signal(0,1,"EXIT_SEARCH_AMMUNITION",self.id) -- Это если пытается добраться до искомой вещи, но вот уже секунду стоит на месте. Например, когда пути туда нет.
		elseif self.Behaviour.Name=="MountedGuy" then
			AI:Signal(0,1,"RETURN_TO_NORMAL",self.id) -- А это если не может дойти до стационарного пулемёта.
		end
	end
	self.BehaviourPrevPos = Pos

	local PercentHealth = self.cnt.health/self.Properties.max_health
	local PercentArmor
	if self.cnt.armor then -- ИИ игрок.
		PercentArmor = self.cnt.armor/255
	end
	if PercentHealth>.8 or (PercentArmor and PercentArmor>.5 and PercentHealth>.5) and self.critical_status then
		self.critical_status = nil -- Убирать критический статус когда здоровье восстановлено.
	end

	if self.ThrowGrenadeOnTimer and _time>self.ThrowGrenadeOnTimer[1] then -- Время, через которое нужно бросить гранату.
		if not self.ThrowGrenadeOnTimer[2] or self.ThrowGrenadeOnTimer[2]==self.sees then -- Статус видимости цели.
			-- Hud:AddMessage(self:GetName()..": GrenadeAttack!")
			-- System:Log(self:GetName()..": GrenadeAttack!")
			self:GrenadeAttack(self.ThrowGrenadeOnTimer[3]) -- Какую гранату бросить.
			self.ThrowGrenadeOnTimer = nil
		else
			-- Hud:AddMessage(self:GetName()..": NO GrenadeAttack!")
			-- System:Log(self:GetName()..": NO GrenadeAttack!")
			self.ThrowGrenadeOnTimer = nil -- Чтобы предотвратить лишние срабатывания когда видимость будет равна указанной.
		end
	end
end

function BasicAI:WeaponManager()
	self.NotAllowMeleeShoot = nil -- Должно быть до первого return'а.
	-- if self.AI_AtWeapon or self.theVehicle then return end -- Это нужно чтобы при активации солдата, если он садится в технику или за миниган, у него не появлялось никакого своего оружия. Хотя на некоторых машинах это, наверно, возможно.
	if not self.ToWeaponAdded then -- В случае, если миссия идёт не сначала, добавил сюда. В OnReset нет смысла добавлять.
		self:Add2Weapon()
	end
	local Current_Weapon = self.cnt.weapon
	-- Hud:AddMessage(self:GetName()..": Current_Weapon: "..Current_Weapon.name)
	-- System:Log(self:GetName()..": Current_Weapon: "..Current_Weapon.name)
	local Current_FireParams
	local Current_AmmoType  -- Тип патронов.
	local Current_Ammo  -- Их количество в запасе.
	local Current_AmmoInClip = self.cnt.ammo_in_clip -- Текущее количество патронов в магазине текущего оружия.
	local Current_BulletsPerClip  -- Максимальное количество патронов, которое может быть в магазине.
	local Current_Distance  -- Максимальная дистанция стрельбы.
	local Current_FireModeType  -- Режим огня.
	local Current_AiMode
	local Current_FireModeNumber = self.firemodenum -- Номер режима стрельбы.
	local Current_BulletRejectType -- Одиночный или автоматический режим огня.
	if self.fireparams then
		Current_FireParams = self.fireparams
		Current_AmmoType = Current_FireParams.AmmoType
		Current_Ammo = self.Ammo[Current_AmmoType]
		Current_BulletsPerClip = Current_FireParams.bullets_per_clip
		Current_Distance = Current_FireParams.distance
		Current_FireModeType = Current_FireParams.fire_mode_type
		Current_AiMode = Current_FireParams.ai_mode
		Current_BulletRejectType = Current_FireParams.BulletRejectType
	end
	local MLD = .4  -- Multiplier Limiting Distance .1
	local FM_MLD = .02  -- Fire Mode Multiplier Limiting Distance
	local DistanceToTarget = self:GetDistanceToTarget()
	local Target
	local att_target = AI:GetAttentionTargetOf(self.id)
	if att_target and type(att_target)=="table" then -- Не извлекать отсюда дистанцию, в машинах работает неправильно.
		Target = att_target
	end

	-- if Current_Distance and Current_FireModeType then
		-- if Current_FireModeType==FireMode_Melee then
			-- -- Current_Distance = Current_Distance+1
		-- end
	-- end
	-- if not self.SetTestWeapon then
		-- BasicPlayer.ScriptInitWeapon(self,val.Name)
		-- self.cnt:MakeWeaponAvailable(20,1)
		-- self.cnt:SetCurrWeapon(20)

		-- BasicPlayer.AddItemInWeaponPack(self,"Weapon","P90")
		-- BasicPlayer.RemoveItemInWeaponPack(self,"Weapon","Falcon")
		-- self.SetTestWeapon=1
	-- end
	-- if DistanceToTarget then
		-- System:Log(self:GetName()..": Current_Distance: "..Current_Distance..", DistanceToTarget: "..DistanceToTarget)
	-- end
	-- self.cnt:SelectNextWeapon()
	-- local MyPack=EquipPacks[self.Properties.equipEquipment]
	-- Попробовать извлечение id и инфо по имени.
	local WeaponsSlots = self.cnt:GetWeaponsSlots()  -- Как сюда добавить оружие вне первых 4 слотов и как добавить подобранное оружие? Всё, эту проблему решил.
	-- local MyPack = EquipPacks[self.Properties.equipEquipment]

	-- local LocalWeaponPackTable={}
	-- for i=1,100 do
		-- if MyPack and MyPack[i] then
			-- local Type = MyPack[i].Type
			-- local Name = MyPack[i].Name
			-- if Type and Name then
				-- LocalWeaponPackTable[i]={Type,Name}
			-- end
			-- -- if Type and Name then
				-- -- System:Log(self:GetName()..": SAVED WEAPON PACK "..Type.." in weapon pack: "..Name)
			-- -- end
		-- end
	-- end

	-- for i,val in LocalWeaponPackTable do
		-- for j,weapon in WeaponClassesEx do -- То есть, благодаря этому теперь возможно узнать id оружия и дать его в руки.
			-- if val[2]==j then
				-- System:Log("Current items in pack: "..val[2].." "..weapon.id)
				-- -- self.cnt:MakeWeaponAvailable(weapon.id,1)
				-- -- Game:AddWeapon(val[2])
				-- -- BasicPlayer.ScriptInitWeapon(self,val[2])
				-- -- self.cnt:SetCurrWeapon(weapon.id)
				-- break
				-- -- LocalWeaponPackTable[i]
			-- end
		-- end
	-- end
	-- local LocalWeaponPackTable={} -- Ага, теперь осталось достать саму сущность по id и всё будет круто. Вот это последнее.
	-- for i=1,100 do
		-- if MyPack and MyPack[i] then
			-- for g,val in MyPack[i] do -- g - "Type", "Name"
				-- -- System:Log("Current items in pack: "..val.." "..g..")
				-- for j,weapon in WeaponClassesEx do -- То есть, благодаря этому теперь возможно узнать id оружия и дать его в руки.
					-- if val==j then -- Имена.
						-- -- System:Log("Current items in pack: "..val.."("..weapon.id..")")
						-- -- self.cnt:MakeWeaponAvailable(weapon.id,1)
						-- -- Game:AddWeapon(val[2])
						-- -- BasicPlayer.ScriptInitWeapon(self,val[2])
						-- -- self.cnt:SetCurrWeapon(weapon.id)
						-- local WeaponInfo = self.WeaponState[weapon.id]
						-- LocalWeaponPackTable[i]={weapon.id, val, WeaponInfo}
						-- break
					-- end
				-- end
			-- end
		-- end
	-- end

	-- if WeaponsSlots then
		-- for i,New_Weapon in WeaponsSlots do
			-- -- if WeaponClassesEx[New_Weapon.name].id~=weapon.id then

			-- -- end
		-- end
	-- end

	-- for i,val in WeaponClassesEx do -- i - Имя.
		-- if i==self.weapon then
			-- System:Log("weapon="..i)
			-- self.weaponid=val.id
			-- break
		-- end
	-- end
	local WeaponsCount=self:NewCountWeaponsInSlots(nil,1,nil,1) -- Без ближнего и бесконечного оружия.
	local WeaponsCountNotAllFM=self:NewCountWeaponsInSlots(1,nil,1) -- Без рук и только первые режимы.
	-- local WeaponsNoHandsCount=self:CountWeaponsInSlots(nil,1) -- Без рук.
	-- local WeaponsCountNoMelee=self:CountWeaponsInSlots(1,nil,1,1) -- Ближнее оружие убрано из подсчёта.
	local DropMelee
	if WeaponsCountNotAllFM.MixedException==4 then -- Не надо делать больше четырёх, ибо, если я дал в редакторе больше, то пусть держит это всё при себе.
		DropMelee = 1
	end
	-- if WeaponsCount==WeaponsCount.MixedException then -- Это чтобы снайперу ещё и мачете достался.
		-- self.ToWeaponAdded=nil
		-- self:Add2Weapon(13)
	-- end
	-- System:Log(self:GetName()..": WeaponsCount: "..WeaponsCount..", WeaponsCount.NoHands: "..WeaponsCount.NoHands..", WeaponsCount.MixedException: "..WeaponsCount.MixedException)
	if (Current_Weapon and Current_Weapon.name=="RL") or (self.PropertiesInstance.bClosedWalls and self.PropertiesInstance.bClosedWalls~=0) then
		self.SniperNotSitDownOnUseRL = 1
	else
		self.SniperNotSitDownOnUseRL = nil
	end
	if WeaponsSlots then
		local ThisIsBig = strfind(strlower(self.Properties.fileModel),"mutant_big") -- Нужен именно тот, который с хоть каким-нибудь оружием, а не безоружная модель.
		if ThisIsBig then -- Дать толстяку родное ему оружие. Надо переделать, тупо убирать всё и давать нужное... или вынести в отдельную функцию и использовать для кого-нибудь тоже.
			local WeaponsNames = {"COVERRL","MutantShotgun","MutantMG"}
			local count
			for i,New_WeaponName in WeaponsNames do
				count = i
			end
			for i,New_WeaponName in WeaponsNames do
				local Haved
				for j,New_Weapon in WeaponsSlots do
					if New_Weapon~=0 then
						if New_Weapon.name==New_WeaponName then
							Haved=1
						end
						local Haved2
						for f,New_WeaponName2 in WeaponsNames do
							if New_Weapon.name==New_WeaponName2 then
								Haved2=1
							end
							if not Haved2 and f==count then
								-- Hud:AddMessage(self:GetName()..": MakeWeaponAvailable: "..New_Weapon.name)
								-- System:Log(self:GetName()..": MakeWeaponAvailable: "..New_Weapon.name)
								self.cnt:MakeWeaponAvailable(WeaponClassesEx[New_Weapon.name].id,0) -- Убрать все лишние пушки.
							end
						end
					end
				end
				if not Haved then
					BasicPlayer.ScriptInitWeapon(self,New_WeaponName,nil,1)
					-- System:Log(self:GetName()..": ScriptInitWeapon: "..New_WeaponName)
					self.cnt:SelectFirstWeapon()
					for k,val in MaxAmmo do
						if self.Ammo[k]~=val then
							self.Ammo[k]=val
						end
					end
				end
			end
		end
		-- local FullNoAmmoCount = 0
		-- self.AllowUseMeleeOnNoAmmoInWeapons = nil
		-- for i,New_Weapon in WeaponsSlots do -- Переделать под подсчёт всех режимов огня.
			-- if New_Weapon~=0 then
				-- if self.ANIMAL then -- Бредовая эта идея, животным оружие давать(devils_coast).
					-- self.cnt:MakeWeaponAvailable(WeaponClassesEx[New_Weapon.name].id,0)
					-- -- Hud:AddMessage(self:GetName()..": self.ANIMAL")
				-- end
				-- local WeaponState = self.WeaponState
				-- local WeaponInfo = WeaponState[WeaponClassesEx[New_Weapon.name].id]
				-- local New_Ammo
				-- local New_AmmoInClip
				-- local New_FireModeType
				-- if WeaponInfo then
					-- local New_FireParams = New_Weapon.FireParams[WeaponInfo.FireMode+1]
					-- local New_AmmoType = New_FireParams.AmmoType
					-- New_Ammo = self.Ammo[New_AmmoType]
					-- New_AmmoInClip = WeaponInfo.AmmoInClip[self.firemodenum]
					-- New_FireModeType = New_FireParams.fire_mode_type
				-- end
				-- if New_AmmoInClip and New_AmmoInClip <= 0 and New_Ammo and New_Ammo <=0 then
					-- if New_FireModeType~=FireMode_Melee then
						-- FullNoAmmoCount = FullNoAmmoCount+1
					-- end
				-- end
				-- if FullNoAmmoCount==WeaponsCount.MixedException then
					-- self.AllowUseMeleeOnNoAmmoInWeapons = 1
					-- -- Hud:AddMessage(self:GetName()..": self.AllowUseMeleeOnNoAmmoInWeapons")
					-- -- System:Log(self:GetName()..": self.AllowUseMeleeOnNoAmmoInWeapons")
				-- end
			-- end
		-- end
		local FullNoAmmoCount = 0
		self.AllowUseMeleeOnNoAmmoInWeapons = nil
		for i,New_Weapon in WeaponsSlots do
			if New_Weapon~=0 then
				if self.ANIMAL then -- Бредовая эта идея, животным оружие давать(devils_coast).
					self.cnt:MakeWeaponAvailable(WeaponClassesEx[New_Weapon.name].id,0)
					-- Hud:AddMessage(self:GetName()..": self.ANIMAL")
				end
				for n,FireMode in New_Weapon.FireParams do
					local WeaponState = self.WeaponState
					local WeaponInfo = WeaponState[WeaponClassesEx[New_Weapon.name].id]
					local New_AmmoType
					local New_Ammo
					local New_AmmoInClip
					local New_FireModeType
					local New_FireModeNumber = n
					if WeaponInfo then
						local FireModeParams = New_Weapon.FireParams[New_FireModeNumber]
						New_AmmoType = FireModeParams.AmmoType
						New_Ammo = self.Ammo[New_AmmoType]
						New_AmmoInClip = WeaponInfo.AmmoInClip[New_FireModeNumber]
						New_FireModeType = FireModeParams.fire_mode_type
					end
					-- if (New_AmmoInClip and New_AmmoInClip <= 0 and New_Ammo and New_Ammo <=0) or New_AmmoType=="Unlimited" then
					if (New_AmmoInClip and New_AmmoInClip <= 0 and New_Ammo and New_Ammo <=0) then -- Пока пусть остаётся так.
						if New_FireModeType~=FireMode_Melee then
							FullNoAmmoCount = FullNoAmmoCount+1
						end
					end
					if FullNoAmmoCount==WeaponsCount.MixedException then
						self.AllowUseMeleeOnNoAmmoInWeapons = 1
						-- Hud:AddMessage(self:GetName()..": self.AllowUseMeleeOnNoAmmoInWeapons")
						-- System:Log(self:GetName()..": self.AllowUseMeleeOnNoAmmoInWeapons")
					end
				end
			end
		end
		-- Hud:AddMessage(self:GetName()..": FullNoAmmoCount: "..FullNoAmmoCount..", WeaponsCount.MixedException: "..WeaponsCount.MixedException..", WeaponsCount.NoHands: "..WeaponsCount.NoHands)
		-- System:Log(self:GetName()..": FullNoAmmoCount: "..FullNoAmmoCount..", WeaponsCount.MixedException: "..WeaponsCount.MixedException..", WeaponsCount.NoHands: "..WeaponsCount.NoHands)
		-- local LocalWeaponsCount=0
		for i,New_Weapon in WeaponsSlots do -- i - с каким элементом идёт работа. Число. -- for i,fireMode in weaponTable.FireParams do - проверка количества патронов в режимах.
			if New_Weapon~=0 then
				-- LocalWeaponsCount=LocalWeaponsCount+1
				-- System:Log(self:GetName()..": I: "..i.." WeaponsCount:"..WeaponsCount)
				for m,FireMode in New_Weapon.FireParams do
					local WeaponState = self.WeaponState
					local WeaponInfo = WeaponState[WeaponClassesEx[New_Weapon.name].id]
					local New_FireParams
					local New_AmmoType -- Тип патронов.
					local New_Ammo -- Их количество в запасе.
					local New_AmmoInClip -- Текущее количество патронов в магазине.
					local New_BulletsPerClip  -- Максимальное количество патронов, которое может быть в магазине.
					local New_Distance -- Максимальная дистанция стрельбы.
					local New_FireModeType -- Режим огня.
					local New_AiMode
					local New_FireModeNumber = m -- Номер режима стрельбы.
					local New_BulletRejectType -- Одиночный или автоматический режим огня.
					if WeaponInfo then
						New_FireParams = New_Weapon.FireParams[New_FireModeNumber] -- WeaponInfo.FireMode+1
						New_AmmoType = New_FireParams.AmmoType
						New_Ammo = self.Ammo[New_AmmoType]
						New_AmmoInClip = WeaponInfo.AmmoInClip[New_FireModeNumber] -- Проблемс с firemodenum: self.firemodenum - это для пушки в руках. Так, при ресете показывает точное число. В общем, сделал постоянную синхронизацию, должно помочь. SyncAmmoInClip
						New_BulletsPerClip = New_FireParams.bullets_per_clip
						New_Distance = New_FireParams.distance
						New_FireModeType = New_FireParams.fire_mode_type
						New_AiMode = New_FireParams.ai_mode
						New_BulletRejectType = New_FireParams.BulletRejectType
					end
					-- if New_Distance and New_FireModeType then
						-- if New_FireModeType==FireMode_Melee then
							-- -- New_Distance = New_Distance+1
						-- end
					-- end
					-- if not Current_AmmoType then Current_AmmoType="nil" end
					-- if not Current_Ammo then Current_Ammo="nil" end -- У AmmoType=="Unlimited" отсутствует.
					-- if not Current_BulletsPerClip then Current_BulletsPerClip="nil" end
					-- if not Current_Distance then Current_Distance="nil" end
					-- if not New_Ammo then New_Ammo="nil" end
					-- if not New_AmmoInClip then New_AmmoInClip="nil" end
					-- if not New_Distance then New_Distance="nil" end
					-- if not Current_Weapon then Current_Weapon="nil" end
					-- if not New_AmmoType then New_AmmoType="nil" end
					-- System:Log(self:GetName()..": Current_AmmoType: "..Current_AmmoType..", New_AmmoType: "..New_AmmoType..", Current_Ammo: "
					-- ..Current_Ammo..", New_Ammo: "..New_Ammo..", Current_AmmoInClip: "..Current_AmmoInClip..", New_AmmoInClip: "..New_AmmoInClip
					-- ..", Current_BulletsPerClip: "..Current_BulletsPerClip..", New_BulletsPerClip: "..New_BulletsPerClip..", Current_Distance: "
					-- ..Current_Distance..", New_Distance: "..New_Distance..", Current Weapon: "..Current_Weapon.name..", New Weapon: "..New_Weapon.name)
					-- if Current_AmmoType=="nil" then Current_AmmoType=nil end
					-- if Current_Ammo=="nil" then Current_Ammo=nil end
					-- if Current_BulletsPerClip=="nil" then Current_BulletsPerClip=nil end
					-- if Current_Distance=="nil" then Current_Distance=nil end
					-- if New_Ammo=="nil" then New_Ammo=nil end
					-- if New_AmmoInClip=="nil" then New_AmmoInClip=nil end
					-- if New_Distance=="nil" then New_Distance=nil end
					-- if Current_Weapon=="nil" then Current_Weapon=nil end
					-- if New_AmmoType=="nil" then New_AmmoType=nil end
					if self.SetWeaponTable then
						-- System:Log(self:GetName()..": SetWeaponTable. Current Weapon: "..Current_Weapon.name..", Table Weapon: "..self.SetWeaponTable[1]..", Current FM number: "..Current_FireModeNumber..", Table FM number: "..self.SetWeaponTable[2])
						if not Current_Weapon or (Current_Weapon.name==self.SetWeaponTable[1]) then
							if Current_FireModeNumber~=self.SetWeaponTable[2] then
								-- System:Log(self:GetName()..": SetWeaponTable. Current Weapon: "..Current_Weapon.name..", Table Weapon: "..self.SetWeaponTable[1]..", Current FM number: "..Current_FireModeNumber..", Table FM number: "..self.SetWeaponTable[2])
								if self.cnt.SwitchFireMode then
									self.cnt:SwitchFireMode(self.SetWeaponTable[2]-1) -- Хорошо, здесь минуснул (при значении 3 выбирает 4 режим), а в c++ по логике нужно плюсануть (показывает что там вообще 2, но селектит 3 при New_FireModeNumber-1)... Как оно работает?
								end
								do break end
							else
								-- System:Log(self:GetName()..": SetWeaponTable = nil. Current Weapon: "..Current_Weapon.name..", Table Weapon: "..self.SetWeaponTable[1]..", Current FM number: "..Current_FireModeNumber..", Table FM number: "..self.SetWeaponTable[2])
								System:Log(self:GetName()..": Old Weapon: "..self.SetWeaponTable[3]..", New Weapon: "..Current_Weapon.name..", Old FM: "..self.SetWeaponTable[4]..", New FM: "..Current_FireModeNumber)
								self.SetWeaponTable = nil -- Пока оружие реально не поменяется, цикл работать не будет.
							end
						else
							-- System:Log(self:GetName()..": SetWeaponTable Break. Current Weapon: "..Current_Weapon.name..", Table Weapon: "..self.SetWeaponTable[1]..", Current FM number: "..Current_FireModeNumber..", Table FM number: "..self.SetWeaponTable[2])
							do break end
						end
					end
					if not self.cnt.reloading then
						-- Hud:AddMessage(self:GetName()..": self.cnt.reloading")
						local TheNewWeaponsAreAmmo -- В новом оружии имеются хоть какие-нибудь патроны.
						if (New_AmmoInClip and New_AmmoInClip>0) or (New_Ammo and New_Ammo>0) or (New_AmmoType and New_AmmoType=="Unlimited") then
							TheNewWeaponsAreAmmo = 1
						end
						local AllowChangeWeaponOrFireMode
						-- if (Current_Weapon.name~=New_Weapon.name or (Current_FireModeNumber~=New_FireModeNumber and Current_AiMode==New_AiMode and (not self.current_mounted_weapon or not self.current_mounted_weapon.isBound))) then
						if not Current_Weapon or (Current_Weapon.name~=New_Weapon.name or (Current_FireModeNumber~=New_FireModeNumber and Current_AiMode==New_AiMode)) then
							AllowChangeWeaponOrFireMode = 1
							-- if self:GetName()=="MercCover6" then
								-- System:Log(self:GetName()..": AllowChangeWeaponOrFireMode")
							-- end
						end
						local InMountedWeapon
						if self.AI_AtWeapon or self.theVehicle then
							InMountedWeapon = 1
							-- if self:GetName()=="MercCover6" then
								-- System:Log(self:GetName()..": InMountedWeapon")
							-- end
						end
						local OneWeaponInVehicle
						if (not InMountedWeapon or (InMountedWeapon and Current_Weapon and Current_Weapon.name==New_Weapon.name and (not self.current_mounted_weapon or not self.current_mounted_weapon.isBound))) and AllowChangeWeaponOrFireMode then
							OneWeaponInVehicle = 1
							-- if self:GetName()=="MercCover6" then
								-- System:Log(self:GetName()..": OneWeaponInVehicle")
							-- end
						end
						if InMountedWeapon and (self.current_mounted_weapon or (self.theVehicle and (self.theVehicle.gunnerT and self.theVehicle.gunnerT.entity==self and self.theVehicle.gunnerT.state==2))) then
							MLD=FM_MLD
						end
						local SetWeapon
						local SetFireMode
						-- Добавить ещё условие когда у другой пушки в общем больше патронов.
						-- Добавить: с РЛ должен экономить ракеты.
						local AddMeleeDistance = 0
						if Current_FireModeType==FireMode_Melee then -- Надо сделать чела с мачете более "продвинутым".
							AddMeleeDistance = 3 -- 2 маловато будет.
							if DistanceToTarget and DistanceToTarget<=Current_Distance+AddMeleeDistance then
								-- self:InsertSubpipe(0,"dumb_shoot")
								self:InsertSubpipe(0,"just_shoot")
								-- self:TriggerEvent(AIEVENT_CLEAR)
							else
								self.NotAllowMeleeShoot=AddMeleeDistance -- То есть как если просто 1 поставить чтобы заполнить.
								-- not_shoot убрал из-за того что скорость всего увеличивается как при увеличении responsiveness.
								-- self:InsertSubpipe(0,"not_shoot")  -- Чтобы в редакторе не устраивал махач. Работает если при выходе из режима проверки цель была дальше указанной дистанции огня. Доработать.
							end
							if not self.AI_GunOut then
								self.cnt:HoldGun()
								self.AI_GunOut = 1
							end
						end
						if self.ForceReload then self.ForceReload=nil end
						-- if not self.MUTANT and (self.WasInCombat and ((not Current_Weapon or (self.allow_idle and not self.IsAiPlayer) or (self.AiPlayerAllowSearchGun and self.IsAiPlayer and self.sees==0)) or (Current_FireModeType==FireMode_Melee and ((self.sees~=1 or (self.sees==1 and DistanceToTarget and DistanceToTarget>10)))))) then
						-- if not self.MUTANT and self.WasInCombat and ((not Current_Weapon or (self.allow_idle and not self.IsAiPlayer) or (self.AiPlayerAllowSearchGun and self.IsAiPlayer and self.sees==0)) or (Current_FireModeType==FireMode_Melee and ((self.sees~=1 and (not DistanceToTarget or (DistanceToTarget and DistanceToTarget>5))) or (self.sees==1 and DistanceToTarget and DistanceToTarget>5)))) then
						-- if not self.MUTANT and self.WasInCombat and ((not Current_Weapon or (self.AiPlayerAllowSearchGun and self.IsAiPlayer and self.sees==0)) or (Current_FireModeType==FireMode_Melee and ((self.sees~=1 and (not DistanceToTarget or (DistanceToTarget and DistanceToTarget>5))) or (self.sees==1 and DistanceToTarget and DistanceToTarget>5)))) then

						if not self.MUTANT and self.WasInCombat and (not Current_Weapon or (Current_FireModeType==FireMode_Melee
						and (self.sees~=1 or not DistanceToTarget or DistanceToTarget>5)) or (self.AiPlayerAllowSearchGun and self.IsAiPlayer and self.sees~=1)) then
							-- if self.IsAiPlayer then
								-- Hud:AddMessage(self:GetName()..": BasicAI/WeaponManager/SearchAmmunition")
								-- System:Log(self:GetName()..": BasicAI/WeaponManager/SearchAmmunition")
							-- end
							self:SearchAmmunition(1,1,1)
						end
						if self.WasInCombat and not Current_Weapon and not self.RunToTrigger then -- Доработать.
							self:InsertSubpipe(0,"hide_on_no_weapon_or_no_ammo")
						end
						if self.SelectOnRange and _time>self.SelectOnRange+2 then self.SelectOnRange=nil end -- 2 секунды достаточно для нормального начала перезарядки.
						if Current_Weapon and OneWeaponInVehicle then
							-- System:Log(self:GetName()..": Current_Weapon and OneWeaponInVehicle")
							-- if Current_Weapon and Current_Weapon.name~=New_Weapon.name and Current_FireModeType~=FireMode_Melee and Current_AmmoType~="Unlimited" and Current_AmmoInClip <= 0 and New_AmmoInClip and New_AmmoInClip>0 and self.sees==1 and not New_FireParams.DontUseWeaponOnMelee and not self.MeleeAttack and not self.SelectOnRange and not self.PracticleFireMan then
							-- if Current_FireModeType~=FireMode_Melee and New_FireModeType~=FireMode_Melee and Current_AmmoType~="Unlimited" and (Current_Ammo and (Current_Ammo<=0 and Current_AmmoInClip<=0) or (Current_Ammo>=0 and Current_AmmoInClip<=0)) and ((New_AmmoInClip and New_AmmoInClip>0) or (New_AmmoType and New_AmmoType=="Unlimited" and self.AllowUseMeleeOnNoAmmoInWeapons)) and self.sees==1 and not New_FireParams.DontUseWeaponOnMelee and not self.MeleeAttack and not self.SelectOnRange and not self.PracticleFireMan then
							-- if Current_FireModeType~=FireMode_Melee and New_FireModeType~=FireMode_Melee and New_FireModeType~=FireMode_Projectile and Current_AmmoType~="Unlimited" and (Current_Ammo and (Current_Ammo<=0 and Current_AmmoInClip<=0) or (Current_Ammo>=0 and Current_AmmoInClip<=0)) and ((New_AmmoInClip and New_AmmoInClip>0) or (New_AmmoType and New_AmmoType=="Unlimited" and self.AllowUseMeleeOnNoAmmoInWeapons)) and self.sees==1 and not New_FireParams.DontUseWeaponOnMelee and not self.MeleeAttack and not self.SelectOnRange and not self.PracticleFireMan then
							if Current_FireModeType~=FireMode_Melee and New_FireModeType~=FireMode_Melee and Current_AmmoType~="Unlimited" and (Current_Ammo and ((Current_Ammo<=0 and Current_AmmoInClip<=0) or (Current_Ammo>0 and Current_AmmoInClip<=0))) and ((New_AmmoInClip and New_AmmoInClip>0) or (New_AmmoType and New_AmmoType=="Unlimited" and self.AllowUseMeleeOnNoAmmoInWeapons)) and self.sees~=0 and (not New_FireParams.DontUseWeaponOnMelee or not DistanceToTarget or DistanceToTarget>New_FireParams.DontUseWeaponOnMelee) and not self.MeleeAttack and not self.SelectOnRange and not self.PracticleFireMan then -- Никаких не проджектилов! Current_FireModeType~=New_FireModeType не ставить!
								-- Патроны в магазине закончились, но есть цель и нужно быстро переключиться на другое оружие, у которого в магазине есть патроны.
								-- if self.SelectOnRange then -- Чтобы не было цикла между этим условием и перекючением на более дальнобойнее расстояние.
									-- -- self.SelectOnRange=self.SelectOnRange+1
									-- -- self:InsertSubpipe(0,"reload")  -- Временное исправление цикла. Из-за него нет анимации перезарядки.
									-- if self.SelectOnRange <=30 then
										-- break
									-- end
								-- end
								System:Log(self:GetName()..": Cartridges in the store is over, but there are other weapons in the store and visible goal. Old weapon: "..Current_Weapon.name..", New weapon: "..New_Weapon.name)
								SetWeapon = 1
							-- elseif Current_Weapon.name~=New_Weapon.name and (Current_Weapon.name=="RL" or Current_Weapon.name=="COVERRL") and TheNewWeaponsAreAmmo and self.not_sees_timer_start~=0 and self.allow_search then
							elseif Current_FireModeType==FireMode_Projectile and New_FireModeType~=FireMode_Projectile and self.not_sees_timer_start~=0 and Current_Weapon.name~="SniperRifle" then
								-- Лучше взять в руки другое оружие пока всё спокойно.
								System:Log(self:GetName()..": Change weapon not another until all is calm (RL). Old weapon: "..Current_Weapon.name..", New weapon: "..New_Weapon.name)
								SetWeapon = 1
							-- -- elseif Current_Weapon.name~=New_Weapon.name and DistanceToTarget and ((Current_Weapon.name=="RL" and DistanceToTarget<=20) or (Current_Weapon.name=="COVERRL" and DistanceToTarget<=10)) then
							-- elseif Current_FireModeType==FireMode_Projectile and New_FireModeType~=FireMode_Projectile and DistanceToTarget and DistanceToTarget<=25 and not Current_FireParams.DontUseWeaponOnMelee and Current_Weapon.name~="SniperRifle" then
							-- elseif Current_FireModeType==FireMode_Projectile and not New_FireParams.DontUseWeaponOnMelee and DistanceToTarget and DistanceToTarget<=22 and Current_Weapon.name~="SniperRifle" then
							-- elseif Current_FireModeType==FireMode_Projectile and New_FireModeType~=FireMode_Projectile and DistanceToTarget and DistanceToTarget<=22 and Current_Weapon.name~="SniperRifle" then -- Что со снайпой делать?
							elseif DistanceToTarget and Current_FireParams.DontUseWeaponOnMelee and DistanceToTarget<=Current_FireParams.DontUseWeaponOnMelee and (not New_FireParams.DontUseWeaponOnMelee or DistanceToTarget>New_FireParams.DontUseWeaponOnMelee) then
								-- Не использовать вблизи снаряды.
								System:Log(self:GetName()..": Do not use near projectiles. Old weapon: "..Current_Weapon.name..", New weapon: "..New_Weapon.name)
								-- if Current_Weapon.name=="RL" then
									-- -- Current_FireParams.DontUseWeaponOnMelee= 20
									-- Current_FireParams.DontUseWeaponOnMelee = 20
								-- elseif New_Weapon.name=="VehicleMountedRocketMG" or New_Weapon.name=="VehicleMountedMG" or New_Weapon.name=="VehicleMountedAutoMG" or New_Weapon.name=="VehicleMountedRocket" then
									-- Current_FireParams.DontUseWeaponOnMelee = 22
								-- else
									-- Current_FireParams.DontUseWeaponOnMelee = 10
								-- end
								SetWeapon = 1
							-- -- elseif New_AmmoInClip and New_AmmoInClip < New_BulletsPerClip*.3 and New_Ammo and New_Ammo > New_BulletsPerClip and self.not_sees_timer_start~=0 and self.WasInCombat and New_Weapon.name~="RL" and New_Weapon.name~="COVERRL" and New_Weapon.name~="SniperRifle" and ((Current_Weapon.name==New_Weapon.name and Current_FireModeType~=FireMode_Melee) or (Current_Weapon.name~=New_Weapon.name and New_FireModeType~=FireMode_Melee)) and New_AmmoType and New_AmmoType~="Unlimited" then
							-- elseif New_AmmoInClip and New_AmmoInClip < New_BulletsPerClip*.3 and New_Ammo and New_Ammo > New_BulletsPerClip and self.not_sees_timer_start~=0 and self.WasInCombat and New_Weapon.name~="RL" and New_Weapon.name~="COVERRL" and New_Weapon.name~="SniperRifle" and ((Current_Weapon.name==New_Weapon.name and Current_FireModeType~=FireMode_Melee) or (Current_Weapon.name~=New_Weapon.name and New_FireModeType~=FireMode_Melee)) and New_AmmoType and New_AmmoType~="Unlimited" then
								-- -- Перезарядка всего не заряженного оружия пока всё спокойно.
								-- System:Log(self:GetName()..": Reload all weapons because few rounds. Old weapon: "..Current_Weapon.name..", New weapon: "..New_Weapon.name..", Current_AmmoInClip: "..Current_AmmoInClip..", New_AmmoInClip: "..New_AmmoInClip.." < New_BulletsPerClip*.3: "..New_BulletsPerClip*.3..", New_Ammo: "..New_Ammo.." > New_BulletsPerClip: "..New_BulletsPerClip)
								-- if Current_Weapon.name~=New_Weapon.name then
									-- -- System:Log(self:GetName()..": Reload all weapons Current_Weapon.name~=New_Weapon.name")
									-- SetWeapon = 1
									-- -- self.cnt:SetCurrWeapon(WeaponClassesEx[New_Weapon.name].id)
								-- end
								-- self.ForceReload=1
								-- self:InsertSubpipe(0,"reload")
								-- -- break
																							-- Current_FireModeType~=New_FireModeType не ставить, если нужно избежать оружия с таким же режимом огня. Лучше Current_FireModeType~=FireMode_Melee, чем в том случае, так как у огнестрельных пушек режим огня совпадает.
							elseif New_FireModeType~=FireMode_Melee and Current_AmmoInClip <= 0 and New_AmmoInClip and New_AmmoInClip<=0 and Current_Ammo and Current_Ammo <=0 and New_Ammo and New_Ammo>0 and Current_AmmoType~="Unlimited" then
								-- Запасные патроны остались у другого не заряженного оружия.
								System:Log(self:GetName()..": Switch weapons with spare cartridges. Old weapon: "..Current_Weapon.name..", New weapon: "..New_Weapon.name)
								SetWeapon = 1
								-- self:InsertSubpipe(0,"reload") -- Убрал, тест.
							elseif Current_FireModeType~=FireMode_Melee and New_FireModeType==FireMode_Melee and ((New_Distance and DistanceToTarget and DistanceToTarget<=New_Distance+AddMeleeDistance) or self.cnt.underwater>0) and self.WasInCombat and (Target and (not Target.MUTANT or (Target.MUTANT and self.AllowUseMeleeOnNoAmmoInWeapons))) then
								-- Перейти в режим ближнего боя.
								-- Hud:AddMessage(self:GetName()..": Switch to melee. Old weapon: "..Current_Weapon.name..", New weapon: "..New_Weapon.name)
								System:Log(self:GetName()..": Switch to melee. Old weapon: "..Current_Weapon.name..", New weapon: "..New_Weapon.name)
								self.MeleeAttack=1
								if not self.RunToTrigger and not self.AI_OnDanger then
									self:InsertSubpipe(0,"melee_attack_on_close")
								end
								SetWeapon = 1
							elseif Current_FireModeType==FireMode_Melee and New_FireModeType~=FireMode_Melee and TheNewWeaponsAreAmmo and DistanceToTarget and New_Distance and Current_Distance and DistanceToTarget>Current_Distance+AddMeleeDistance and self.cnt.underwater<=0 and (not New_FireParams.DontUseWeaponOnMelee or DistanceToTarget>New_FireParams.DontUseWeaponOnMelee) then -- Current_Weapon.name~=New_Weapon.name
								-- Выйти из режима ближнего боя, так как есть более дальнобойное оружие.
								-- Hud:AddMessage(self:GetName()..": Exit melee, as there is a long-range weapon. Old weapon: "..Current_Weapon.name..", New weapon: "..New_Weapon.name)
								System:Log(self:GetName()..": Exit melee, as there is a long-range weapon. Old weapon: "..Current_Weapon.name..", New weapon: "..New_Weapon.name)
								self.MeleeAttack=nil
								self.MeleeAttack2=nil
								SetWeapon = 1
							elseif TheNewWeaponsAreAmmo and DistanceToTarget and Current_AmmoType~="Unlimited" and New_AmmoInClip and Current_AmmoInClip<New_AmmoInClip and Current_BulletsPerClip and New_BulletsPerClip and Current_BulletsPerClip<New_BulletsPerClip and self.WasInCombat and self.sees~=1 and DistanceToTarget<=30 then
								-- Сменить на оружие с большим вмещаемым количеством патронов. Тест.
								System:Log(self:GetName()..": Change to a weapon with a large number of cartridges can accommodate. Old weapon: "..Current_Weapon.name.." ("..Current_AmmoInClip.."/"..Current_BulletsPerClip.."), New weapon: "..New_Weapon.name.." ("..New_AmmoInClip.."/"..New_BulletsPerClip..")")
								SetWeapon = 1
							-- elseif Current_FireModeNumber~=New_FireModeNumber and TheNewWeaponsAreAmmo and DistanceToTarget and Current_Distance and New_Distance and not New_FireParams.DontUseWeaponOnMelee and not self.PracticleFireMan and not self.allow_search and self.cnt.underwater<=0 and DistanceToTarget>Current_Distance*FM_MLD and Current_Distance*FM_MLD<New_Distance*FM_MLD and not self.MeleeAttack then -- Current_AmmoInClip < Current_BulletsPerClip*.33
							-- elseif Current_FireModeNumber~=New_FireModeNumber and TheNewWeaponsAreAmmo and DistanceToTarget and Current_Distance and New_Distance and not New_FireParams.DontUseWeaponOnMelee and not self.PracticleFireMan and not self.allow_search and self.cnt.underwater<=0 and DistanceToTarget<=Current_Distance*FM_MLD and DistanceToTarget<=New_Distance*FM_MLD and Current_Distance*FM_MLD>New_Distance*FM_MLD and (Current_FireModeType~=FireMode_Projectile or (Current_FireModeType==FireMode_Projectile and New_FireModeType~=FireMode_Projectile and DistanceToTarget<=30)) then
							elseif Current_FireModeNumber~=New_FireModeNumber and Current_AiMode==New_AiMode and Current_FireModeNumber~=1 and Current_BulletRejectType==BULLET_REJECT_TYPE_SINGLE and New_BulletRejectType==BULLET_REJECT_TYPE_RAPID and self.WasInCombat and self.sees==1 and DistanceToTarget and DistanceToTarget<=30 then
								-- Переключить в автоматический режим огня. Тест.
								System:Log(self:GetName()..": Switch to automatic mode of fire. Weapon: "..Current_Weapon.name..", Old FM number: "..Current_FireModeNumber.." ("..Current_AmmoInClip.."/"..Current_BulletsPerClip.."), New FM number: "..New_FireModeNumber.." ("..New_AmmoInClip.."/"..New_BulletsPerClip..")")
								SetWeapon = 1
							elseif Current_FireModeType==FireMode_Melee and not self.RunToTrigger and self.MERC and (self.MERC~="sniper" or (self.MERC=="sniper" and not self.GoToAmmo and not self.GoToWeapon and not self.GoToHealth)) and self.WasInCombat and (not DistanceToTarget or (Current_Distance and DistanceToTarget>Current_Distance)) then
								-- Сближаться с целю, оружие имеет режим ближнего боя.
								-- Hud:AddMessage(self:GetName()..": Converge with aim, weapon has a melee mode.")
								-- System:Log(self:GetName()..": Converge with aim, weapon has a melee mode.")
								self.MeleeAttack2=1
								self:TriggerEvent(AIEVENT_DROPBEACON) -- Обязательно.
								if not self.AI_OnDanger or (DistanceToTarget and DistanceToTarget<=30) then
									self.AI_OnDanger = nil
									self:InsertSubpipe(0,"melee_attack_on_close") -- Если была пушка, то начинает глючить.
								else
									self:SelectPipe(0,"hide_on_danger2")
								end
								-- Без бреака.
							end
							if not SetWeapon and TheNewWeaponsAreAmmo and DistanceToTarget and Current_Distance and New_Distance
							and not self.PracticleFireMan and not self.allow_search and self.cnt.underwater<=0 and not self.MeleeAttack
							and (not New_FireParams.DontUseWeaponOnMelee or DistanceToTarget>New_FireParams.DontUseWeaponOnMelee) then
								-- System:Log(self:GetName()..": Range. Old weapon: "..Current_Weapon.name.." ("..Current_Distance*MLD.."), New weapon: "..New_Weapon.name.." ("..New_Distance*MLD.."), DistanceToTarget: "..DistanceToTarget)
								-- and (Current_AmmoInClip <= 0 or Current_AmmoType=="Unlimited")
								-- self.fireparams.fire_mode_type==FireMode_Projectile or self.fireparams.BulletRejectType==BULLET_REJECT_TYPE_SINGLE
								-- if (DistanceToTarget>(Current_Distance+AddMeleeDistance)*MLD and (Current_Distance+AddMeleeDistance)*MLD<New_Distance*MLD) then -- Current_AmmoInClip < Current_BulletsPerClip*.33
								if (DistanceToTarget>(Current_Distance+AddMeleeDistance)*MLD and (Current_Distance+AddMeleeDistance)*MLD<New_Distance*MLD)
								and (New_Weapon.name~="Shotgun" or DistanceToTarget>New_Distance*.4)
								and (New_Weapon.name~="MutantShotgun" or DistanceToTarget>New_Distance*.1)
								and (New_Weapon.name~="MutantMG" or DistanceToTarget>New_Distance*.03)
								and (New_Weapon.name~="Falcon" or DistanceToTarget>New_Distance*.1) then
									-- Если текущее оружие не достаёт до цели, то выбрать более дальнобойное.
									System:Log(self:GetName()..": Choose your weapon with a long range. Old weapon: "..Current_Weapon.name.." ("..Current_Distance*MLD.."), New weapon: "..New_Weapon.name.." ("..New_Distance*MLD.."), DistanceToTarget: "..DistanceToTarget)
									self.MeleeAttack=nil
									self.MeleeAttack2=nil
									self.SelectOnRange = _time -- Поправляет ситуацию с зацикливанием выбора пушек. Лучше не убирать, пока нормальный способ не придумается.
									SetWeapon = 1
								-- (Current_AmmoInClip<=0 or ((Current_Weapon.name=="RL" and DistanceToTarget<=20) or (Current_Weapon.name=="COVERRL" and DistanceToTarget<=10) or (Current_Weapon.name=="SniperRifle" and DistanceToTarget<=5) or (Current_Weapon.name=="SniperRifle" and DistanceToTarget<=20 and Current_AmmoInClip < Current_BulletsPerClip*.33))) and (New_Weapon.name~="Shotgun" or (New_Weapon.name=="Shotgun" and DistanceToTarget<=(New_Distance-40)*MLD)) and (New_Weapon.name~="MutantShotgun" or (New_Weapon.name=="MutantShotgun" and DistanceToTarget<=(New_Distance-60)*MLD)) and (New_Weapon.name~="Falcon" or (New_Weapon.name=="Falcon" and DistanceToTarget<=(New_Distance-40)*MLD)) then -- Current_BulletsPerClip*.33
								elseif (DistanceToTarget<=Current_Distance*MLD and DistanceToTarget<=New_Distance*MLD and Current_Distance*MLD>New_Distance*MLD)
								and (((Current_AmmoInClip<=0 or Current_AmmoType=="Unlimited")
								-- or ((Current_Weapon.name=="RL" and DistanceToTarget<=20)
								-- or (Current_Weapon.name=="COVERRL" and DistanceToTarget<=10)
								-- or (Current_Weapon.name=="SniperRifle" and (DistanceToTarget<=5 or (DistanceToTarget<=20 and Current_AmmoInClip < Current_BulletsPerClip*.33)))))
								or (Current_Weapon.name=="SniperRifle" and (DistanceToTarget<=5 or (DistanceToTarget<=20 and Current_AmmoInClip < Current_BulletsPerClip*.33))))
								and (New_Weapon.name~="Shotgun" or DistanceToTarget<=New_Distance*.4)
								and (New_Weapon.name~="MutantShotgun" or DistanceToTarget<=New_Distance*.1)
								and (New_Weapon.name~="MutantMG" or DistanceToTarget<=New_Distance*.03)
								and (New_Weapon.name~="Falcon" or DistanceToTarget<=New_Distance*.1)) then
									-- Менее дальнобойное оружие более эффективно вблизи.
									System:Log(self:GetName()..": Choose your weapon with a shorter range. Old weapon: "..Current_Weapon.name.." ("..Current_Distance*MLD.."), New weapon: "..New_Weapon.name.." ("..New_Distance*MLD.."), DistanceToTarget: "..DistanceToTarget)
									self.SelectOnRange = _time
									SetWeapon = 1
								end
							end
						end
						if not InMountedWeapon then
							if self.AllowUseMeleeOnNoAmmoInWeapons and (not self.MUTANT or self.MUTANT~="big") and self.WasInCombat and not SetWeapon then -- У melee оружия нет патронов. Обязательно должно быть отдельным блоком. NIL AllowUseMeleeOnNoAmmoInWeapons не ставить, иначе может не выбрать руки.
								if Current_FireModeType==FireMode_Melee then
									-- Патронов больше нигде нет и выбрано оружие ближнего боя.
									-- Hud:AddMessage(self:GetName()..": Cartridges are not present, the current melee weapon: "..Current_Weapon.name)
									-- System:Log(self:GetName()..": Cartridges are not present, the current melee weapon: "..Current_Weapon.name)
									if not self.RunToTrigger and self.sees~=1 then
										self:InsertSubpipe(0,"hide_on_no_weapon_or_no_ammo")
									end
								else
									if New_FireModeType==FireMode_Melee then
										-- Если везде закончились патроны и есть оружие ближнего боя.
										if Current_Weapon then
											-- Hud:AddMessage(self:GetName()..": Ammo is no more, go to melee. Old weapon: "..Current_Weapon.name..", New weapon: "..New_Weapon.name)
											System:Log(self:GetName()..": Ammo is no more, go to melee. Old weapon: "..Current_Weapon.name..", New weapon: "..New_Weapon.name)
										end
										SetWeapon = 1
									else
										-- Патронов больше нигде нет.
										-- Hud:AddMessage(self:GetName()..": Cartridges are not present!")
										-- System:Log(self:GetName()..": Cartridges are not present!")
										if not self:SearchAmmunition(1,1) and not self.RunToTrigger then
											self:InsertSubpipe(0,"hide_on_no_weapon_or_no_ammo")
										end
									end
								end
							end
							if New_Weapon.name~="Hands" and DropMelee and New_FireModeType==FireMode_Melee and New_FireModeNumber==1 and not self.AllowUseMeleeOnNoAmmoInWeapons then
								-- Выбросить оружие ближнего боя.
								System:Log(self:GetName()..": Throw a melee weapon. Weapon: "..New_Weapon.name..", Id: "..WeaponClassesEx[New_Weapon.name].id)
								New_Weapon.pp_lastdrop = _time + .8
								self.cnt:DropWeapon(WeaponClassesEx[New_Weapon.name].id)
								do break end
							end
							if New_Weapon.name=="Falcon" and DropMelee and New_AmmoInClip and New_AmmoInClip <= 0 and New_Ammo and New_Ammo <=0 then
								-- Выбросить пистолет, если он будет забивать место. Временное условие.
								System:Log(self:GetName()..": Throw Falcon. Weapon: "..New_Weapon.name..", Id: "..WeaponClassesEx[New_Weapon.name].id)
								New_Weapon.pp_lastdrop = _time + .8
								self.cnt:DropWeapon(WeaponClassesEx[New_Weapon.name].id)
								do break end
							end
						end
						if SetWeapon then
							if not Current_Weapon or Current_Weapon.name~=New_Weapon.name then
								self.cnt:SetCurrWeapon(WeaponClassesEx[New_Weapon.name].id)
							end
							self.SetWeaponTable = {New_Weapon.name,New_FireModeNumber,Current_Weapon.name,Current_FireModeNumber}
							do break end
						end
					end
				end
			end
		end
	end
end

function BasicAI:GoBack() -- Стартовая позиция должна быть близко и если впереди помеха, и сзади помехи нет, тогда отходить.
	if (not self.MERC and not self.MUTANT) or (self.MERC and self.MERC=="sniper") or (self.MUTANT and self.MUTANT=="fast" and not self.AI_CanWalk) or
	self.ANIMAL or self.RunToTrigger or self.ai_flanking or self.ai_scramble or self.AI_OnDanger or self.critical_status or self.Following then return end
	local att_target = AI:GetAttentionTargetOf(self.id)
	if att_target and type(att_target)=="table" then
		if self.Properties.species~=att_target.Properties.species then
			self.SaveAtt = {att_target:GetName()}
		end
	end
	local AttEntityPos
	local AttEntityDistace
	if self.SaveAtt and self.SaveAtt[1] then
		-- if not self.MoveBack then
			self.AttEntity = System:GetEntityByName(self.SaveAtt[1]) -- Зафиксировать данные.
		-- end
		if self.AttEntity then
			AttEntityPos = new(self.AttEntity:GetPos())
			AttEntityDistace = self:GetDistanceFromPoint(AttEntityPos)
		end
	end
	if self.not_sees_timer_start~=0 and self.SaveAtt then
		self.SaveAtt=nil
		self.AttEntity=nil
		self.AllowMoveBack=nil
		self.MoveBack=nil
	end
	if not self.cnt.moving and not self.AllowMoveBack and AttEntityDistace and AttEntityDistace<=20 and self.AttEntity and not self.AttEntity.ladder
	then -- Что-то с лестницей не выходит.
		self.AllowMoveBack=1
	end
	if (self.sees~=1 and self.AttEntity and AttEntityPos and AttEntityPos.z-1 > self:GetPos().z and ((not self.IsIndoor and AttEntityDistace and
	AttEntityDistace<=50) or (self.IsIndoor and AttEntityDistace and AttEntityDistace<=20)) and self.AllowMoveBack) or (self.sees==1 and self.AttEntity and
	AttEntityPos and AttEntityPos.z-1 > self:GetPos().z and AttEntityDistace and AttEntityDistace<=30 and self.MUTANT and self.MUTANT=="predator" and
	self.AllowMoveBack and not self.ThisMutantJump) then
		self.MoveBack=1
		AI:CreateGoalPipe("GoBack_retreat_on_close")
		AI:PushGoal("GoBack_retreat_on_close","just_shoot")
		AI:PushGoal("GoBack_retreat_on_close","setup_stand")
		AI:PushGoal("GoBack_retreat_on_close","do_it_running")
		AI:PushGoal("GoBack_retreat_on_close","locate",0,"atttarget")
		AI:PushGoal("GoBack_retreat_on_close","acqtarget",0,"")
		AI:PushGoal("GoBack_retreat_on_close","backoff",0,100)
		if random(1,2)==1 then
			AI:PushGoal("GoBack_retreat_on_close","strafe",0,15)
		else
			AI:PushGoal("GoBack_retreat_on_close","strafe",0,-15)
		end
		AI:PushGoal("GoBack_retreat_on_close","timeout",1,1)
		self:InsertSubpipe(0,"GoBack_retreat_on_close",self.AttEntity.id) -- Лучше всего согдавать тэг точку и говорить идти туда.
		if random(1,10)==1 and self.MUTANT and self.MUTANT=="predator" then
			AI:Signal(0,1,"SEEK_JUMP_ANCHOR",self.id)
		end
		-- Hud:AddMessage(self:GetName()..": Target: "..self.AttEntity:GetName().."$1, AttEntityDistace: "..AttEntityDistace)
	elseif self.AllowMoveBack then
		self.AttEntity=nil
		self.AllowMoveBack=nil
		self.MoveBack=nil
	end
end

function BasicAI:CheckAiPlayerParams()
	if _localplayer and self.id==_localplayer.id and (GameRules.AiPlayerFirstGoFollow or self.RepeatFollow) then -- При старте уровня. Послать ИИ этот сигнал 5 раз. Это для надёжности.
		if not self.RepeatFollow then self.RepeatFollow=0 end
		GameRules.AiPlayerFirstGoFollow = nil
		self.FirstFollow = 1
		self.RepeatFollow = self.RepeatFollow+1
		if self.RepeatFollow>5 then self.RepeatFollow=nil end
		AI:Signal(0,1,"GO_FOLLOW",self.id)
		-- Hud:AddMessage(self:GetName()..": GO_FOLLOW 3")
		-- System:Log(self:GetName()..": GO_FOLLOW 3")
	end
	-- -- if att_target and type(att_target)=="table" then
	-- -- self.allow_idle and self.sees==0 and self.not_sees_timer_start==0
	-- if self.not_sees_timer_start2 and _time>self.not_sees_timer_start2+20 then
	-- -- if not att_target and self.allow_idle then
		-- -- if not self.GoFollowRepeatStart then self.GoFollowRepeatStart=_time end
		-- -- local Count=0
		-- -- local GoFollow = 1
		-- -- while _time==Count do
			-- -- Count=Count+5
			-- -- if self.GoFollowRepeatStart+100<_time then self.GoFollowRepeatStart=_time end
			-- -- if Count>100 then Count=-5 end
			-- -- GoFollow = nil
		-- -- end
		-- -- if GoFollow then
			-- -- Hud:AddMessage(self:GetName()..": GoFollow")
			-- AI:Signal(0,1,"GO_FOLLOW",self.id)
		-- -- end
	-- -- elseif self.GoFollowRepeatStart then
		-- -- self.GoFollowRepeatStart = nil
	-- end
	if self.AiPlayerIncomingFireStart then
		if _time>=self.AiPlayerIncomingFireStart+random(5,30) then
			self.AiPlayerIncomingFireStart = nil
		end
	end
end

function BasicAI:CheckPlayerCopyParams() -- Сделать OnSave.
	local Player = _localplayer
	if self.theVehicle or not Player then return end -- В машине ничего такого не выполнять.
	local Distance = self:GetDistanceFromPoint(Player:GetPos())
	-- if self.not_sees_timer_start~=0 then
	if self.id~=Player.id then
		if self.AiAction or self.TempAiAction=="Follow" or self.TempAiAction=="ForceFollow" then
			if self.ReturnForceFollow then
				if self.TempAiAction=="Follow" then
					if self.sees==0 then
						self.ReturnForceFollow = nil
						self.TempAiAction="ForceFollow"
					end
				elseif self.TempAiAction~="ForceFollow" then
					self.ReturnForceFollow = nil
				end
			end
			if not self.RunToTrigger and not self.theVehicle then
				-- self.MemoryAiAction
				if self.AiAction=="Attack" then
					if self.sees==2 then
						self:SelectPipe(0,"AiPlayer_rush")
						Hud:AddMessage(self:GetName()..": $1"..self.AiAction.."...")
						System:Log(self:GetName()..": $1"..self.AiAction.."...")
						self.TempAiAction=self.AiAction
						self.AiAction=nil
					end
				end
				if self.AiAction=="Stop" then
					if self.sees~=1 then
						self:SelectPipe(0,"AiPlayer_stop")
						Hud:AddMessage(self:GetName()..": $1"..self.AiAction.."...")
						System:Log(self:GetName()..": $1"..self.AiAction.."...")
						self.TempAiAction="Stopping"
						self.AiAction=nil
					end
				end
				if self.AiAction=="Wait" then
					if self.sees~=1 then
						self:SelectPipe(0,"AiPlayer_wait")
						Hud:AddMessage(self:GetName()..": $1"..self.AiAction.."...")
						System:Log(self:GetName()..": $1"..self.AiAction.."...")
						self.TempAiAction="Stopping"
						self.AiAction=nil
					end
				end
				if self.AiAction=="Hide" then
					if self.sees~=1 then
						self:SelectPipe(0,"AiPlayer_hide")
						Hud:AddMessage(self:GetName()..": $1"..self.AiAction.."...")
						System:Log(self:GetName()..": $1"..self.AiAction.."...")
						self.TempAiAction="Stopping"
						self.AiAction=nil
					end
				end
				if self.AiAction=="HideAndStop" then
					if self.sees~=1 then
						self:SelectPipe(0,"AiPlayer_hide_and_stop")
						Hud:AddMessage(self:GetName()..": $1"..self.AiAction.."...")
						System:Log(self:GetName()..": $1"..self.AiAction.."...")
						self.TempAiAction="Stopping"
						self.AiAction=nil
					end
				end
				if self.AiAction=="HideAndWait" then
					if self.sees~=1 then
						self:SelectPipe(0,"AiPlayer_hide_and_wait")
						Hud:AddMessage(self:GetName()..": $1"..self.AiAction.."...")
						System:Log(self:GetName()..": $1"..self.AiAction.."...")
						self.TempAiAction="Stopping"
						self.AiAction=nil
					end
				end
				if self.AiAction=="Move" then
					AI:Signal(0,1,"GO_FOLLOW",self.id)
					-- Hud:AddMessage(self:GetName()..": GO_FOLLOW 4")
					-- System:Log(self:GetName()..": GO_FOLLOW 4")
					Hud:AddMessage(self:GetName()..": $1"..self.AiAction.."...")
					System:Log(self:GetName()..": $1"..self.AiAction.."...")
					self.TempAiAction=nil
					self.AiAction=nil
				end
				if self.Following or (self.AiCloseContactStart and _time>self.AiCloseContactStart) then
					self.AiCloseContactStart = nil
				end
				-- if self.TempAiAction then
					-- Hud:AddMessage(self:GetName()..": $1"..self.sees..", self.TempAiAction: "..self.TempAiAction)
				-- end
				if self.AiAction=="Follow" or self.AiAction=="ForceFollow"
				or ((self.TempAiAction=="Follow" or self.TempAiAction=="ForceFollow") and not self.Following and not self.AiCloseContactStart) then
					if ((not self.TempAiAction or self.TempAiAction=="ForceFollow") and self.sees~=1) or (self.TempAiAction=="Follow" and self.sees==0) then
						self.Following=1
						self:SelectPipe(0,"AiPlayer_follow")
						self:InsertSubpipe(0,"setup_stand")
						self:InsertSubpipe(0,"do_it_running")
						if self.AiAction then
							Hud:AddMessage(self:GetName()..": $1"..self.AiAction.."...")
							System:Log(self:GetName()..": $1"..self.AiAction.."...")
						elseif self.TempAiAction then
							Hud:AddMessage(self:GetName()..": $1"..self.TempAiAction.."...")
							System:Log(self:GetName()..": $1"..self.TempAiAction.."...")
						end
						if self.AiAction then
							self.TempAiAction=self.AiAction
							self.AiAction=nil
						end
					end
				end
				if self.AiAction=="Back" then
					if self.sees==0 then
						self:SelectPipe(0,"AiPlayer_follow")
						self:InsertSubpipe(0,"setup_stand")
						self:InsertSubpipe(0,"do_it_running")
						Hud:AddMessage(self:GetName()..": $1"..self.AiAction.."...")
						System:Log(self:GetName()..": $1"..self.AiAction.."...")
						self.TempAiAction=self.AiAction
						self.AiAction=nil
					end
				end
				if self.AiAction=="Respawn" then
					-- if self.sees==0 or self.not_sees_timer_start~=0 then
					if self.sees~=1 then -- А верхнее можно сделать когда режим разработчика отключен.
						if not Player.theVehicle then
							if self:TeleportTo(Player) then
								AI:Signal(0,1,"GO_FOLLOW",self.id)
								-- Hud:AddMessage(self:GetName()..": GO_FOLLOW 5")
								-- System:Log(self:GetName()..": GO_FOLLOW 5")
								Hud:AddMessage(self:GetName()..": $1"..self.AiAction.."...")
								System:Log(self:GetName()..": $1"..self.AiAction.."...")
							end
						end
						self.TempAiAction=nil
						self.AiAction=nil
					end
				end
				if self.AiAction=="Search" then
					if self.sees==0 then
						AI:Signal(0,1,"FIND_A_TARGET",self.id)
						Hud:AddMessage(self:GetName()..": $1"..self.AiAction.."...")
						System:Log(self:GetName()..": $1"..self.AiAction.."...")
						self.TempAiAction=self.AiAction
						self.AiAction=nil
					end
				end
				if self.AiAction=="Hold" then
					self:SelectPipe(0,"AiPlayer_hold_timeout")
					self:InsertSubpipe(0,"just_shoot")
					Hud:AddMessage(self:GetName()..": $1"..self.AiAction.."...")
					System:Log(self:GetName()..": $1"..self.AiAction.."...")
					self.TempAiAction=self.AiAction
					self.AiAction=nil
				end
				if self.AiAction=="Suppress" then
					if self.sees~=0 and not self.AiPlayerDoNotShoot then
						self:SelectPipe(0,"AiPlayer_hold_timeout")
						self:InsertSubpipe(0,"dumb_shoot")
						Hud:AddMessage(self:GetName()..": $1"..self.AiAction.."...")
						System:Log(self:GetName()..": $1"..self.AiAction.."...")
						self.TempAiAction=self.AiAction
						self.AiAction=nil
					end
				end
			end
		end
		-- Hud:AddMessage(self:GetName()..": name: "..self.Behaviour.Name) -- Можно достать параметры непосредственно из самого поведения.
		local MaxDistance
		local TeleportMaxDistance
		if not self.WasInCombat then
			if self.IsIndoor then
				MaxDistance = 2
			else
				MaxDistance = 5
			end
			TeleportMaxDistance = 60
		else
			if self.IsIndoor then
				MaxDistance = 30
				TeleportMaxDistance = 60
			else
				MaxDistance = 50 -- Добавить: Если не начал следовать при большем расстоянии и таймер не начал счёт, и нет врагов, то принудительно ещё раз забыть про цель.
				TeleportMaxDistance = 100
			end
		end
		if Distance>MaxDistance and not self.TempAiAction then
			-- if not self.Following then
			if not self.Following and self.sees==0 then
				AI:Signal(0,1,"GO_FOLLOW",self.id) -- Не убирать!
				-- Hud:AddMessage(self:GetName()..": GO_FOLLOW 6")
				-- System:Log(self:GetName()..": GO_FOLLOW 6")
			end
			if Distance>TeleportMaxDistance and ((self.not_sees_timer_start~=0 and self.WasInCombat) or not self.WasInCombat) and not self.RunToTrigger then
			-- and not self.Behaviour.Stopped then
				if not Player.theVehicle then
					if self:TeleportTo(Player) then
						System:Log(self:GetName().." TELEPORT")
					end
				end
			end
		-- else
			-- if self.Following then
				-- -- self:TriggerEvent(AIEVENT_CLEAR)
			-- end
		end
	end
	if self.id~=Player.id and self.cnt.flying and not self.IsIndoor then
		-- Если вдруг наш друг провалится под землю.
		local Pos = new(self:GetPos())
		local Elevation=System:GetTerrainElevation(Pos)
		if Pos.z<Elevation-1 then
			if not Player.theVehicle then
				if self:TeleportTo(Player) then
					System:Log(self:GetName().." RESET MY POS")
				end
			end
		end
	end
end

function BasicAI:SearchAmmunition(FindWeapon,SearchAmmo,MeleeOnly)
	if self.MUTANT or self.ANIMAL or self.RunToTrigger then return nil end -- Вызывается в после гранатном состоянии.
	if self.AI_AtWeapon or self.theVehicle or self.cnt.reloading then return nil end
	-- Возможно, будут пытаться добраться до закрытых помещений. Добавить проверку где находится оружие: в воде, в помещении, снаружи, в подводном помещении.
	-- Сделать чтобы если все слоты заполнены и не найдены боеприпасы, выбрасывалось оружие и искалось другое(или искались пароны а потом пушка к ним).
	-- System:Log(self:GetName().." BasicAI/SearchAmmunition")
	-- Фиг его знает, как заставить выбросить пушку.
	-- weapon
	-- if BasicWeapon.
	-- self.OnEvent(self,ScriptEvent_DropItem)
	-- weapon.OnEvent(self,ScriptEvent_DropItem)
	-- BasicWeapon.Server.Drop(self)
	-- self.GoToAmmo=nil
	-- self.GoToWeapon=nil
	self.RunToTrigger = 1
	if not FindWeapon and not SearchAmmo then FindWeapon=1 SearchAmmo=1 end
	local weapon = self.cnt.weapon
	if weapon and self.fireparams.fire_mode_type~=FireMode_Melee and (SearchAmmo and SearchAmmo>0) then
		if self:FindAmmo(MeleeOnly) then
			self.GoToPickup=self.FoundAmmo
			self.GoToAmmo=1
			AI:Signal(0,1,"SEARCH_AMMUNITION",self.id)
			return 1
		end
	end
	if not weapon or self.fireparams.fire_mode_type==FireMode_Melee or (FindWeapon and FindWeapon>0) then
		if self:FindHandWeapons(MeleeOnly) then
			self.GoToPickup=self.FoundWeapon
			self.GoToWeapon=1
			AI:Signal(0,1,"SEARCH_AMMUNITION",self.id)
			return 1
		end
	end
	self.RunToTrigger = nil
	return nil
end

function BasicAI:FindHandWeapons(MeleeOnly)
	if self:CountWeaponsInSlots() >= 4 then return nil end
	if self.IsIndoor then
		SearchRadius = 80 -- 30
	else
		SearchRadius = 100
	end
	if MeleeOnly and self.sees==2 then SearchRadius = 5	end
	if self.FoundWeaponEntity and self.FoundWeaponEntity.weapon and self.FoundWeapon and not self:CheckHaveOrNo() then
		local GetState = self.FoundWeaponEntity:GetState()
		if (self.FoundWeaponEntity.Properties.Animation and self.FoundWeaponEntity.Properties.Animation.AvailableWeapon) or (GetState and (GetState=="Active" or GetState=="Dropped")) then
			-- Hud:AddMessage(self:GetName()..": found weapon(x2): "..self.FoundWeaponEntity.weapon.."("..self.FoundWeapon..")")
			System:Log(self:GetName()..": found weapon(x2): "..self.FoundWeaponEntity.weapon.."("..self.FoundWeapon..")")
			return 1
		end
	end
	self.FoundWeapon = AI:FindObjectOfType(self.id,SearchRadius,AIOBJECT_WEAPON)
	self.FoundWeaponEntity = System:GetEntityByName(self.FoundWeapon)
	if self.FoundWeaponEntity and self.FoundWeaponEntity.weapon and not self:CheckHaveOrNo() then
		local GetState = self.FoundWeaponEntity:GetState()
		if (self.FoundWeaponEntity.Properties.Animation and self.FoundWeaponEntity.Properties.Animation.AvailableWeapon) or GetState=="Active" or GetState=="Dropped" then
			-- Hud:AddMessage(self:GetName()..": found weapon: "..self.FoundWeaponEntity.weapon.."("..self.FoundWeapon..")".." "..GetState)
			System:Log(self:GetName()..": found weapon: "..self.FoundWeaponEntity.weapon.."("..self.FoundWeapon..")".." "..GetState)  -- Исправить: weapon - nil в self.FoundWeaponEntity
			-- NotAllFireModes,NoMeleeCount,NoHandsCount,NoUnlimitedCount,NoProjectilesCount
			local WeaponsCount=self:NewCountWeaponsInSlots(nil,1) -- Без ближнего оружия.
			if not self.cnt.weapon or self.AllowUseMeleeOnNoAmmoInWeapons or WeaponsCount.MixedException<=0 then
			-- if not self.cnt.weapon or WeaponsCount.MixedException<=0 then
				self.NoWeaponInHands=1 -- В будущем выйти из поиска, если вдруг было подобрано оружие, но до этого в руках ничего не было.
				if random(1,2)==1 then
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_NONE,"NO_WEAPONS",self.id)
				else
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_NONE,"GET_WEAPON",self.id)
				end
				-- Hud:AddMessage(self:GetName()..": self.NoWeaponInHands=1")
			else
				self.NoWeaponInHands=nil
				-- if random(1,2)==1 then -- Рандом через SoundPack не сделал потому-то нужна стабильность в произношении.
					-- AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_NONE,"GET_WEAPON",self.id)  -- Хм, слишком часто оповещает о том что нет пушки или патронов, добавил рандом.
				-- end
				-- Hud:AddMessage(self:GetName()..": self.NoWeaponInHands=nil")
			end
			return 1
		end
	end
	return nil
end

function BasicAI:FindAmmo()
	if self.IsIndoor then
		SearchRadius = 80 -- 30
	else
		SearchRadius = 100
	end
	if MeleeOnly and self.sees==2 then SearchRadius = 5	end
	if self.FoundAmmoEntity and self.FoundAmmo and not self:CheckHaveOrNo(1) then
		local GetState = self.FoundAmmoEntity:GetState()
		if GetState=="Active" or GetState=="Dropped" then
			-- Hud:AddMessage(self:GetName()..": found ammo(x2): "..self.FoundAmmoEntity.ammo_type.."("..self.FoundAmmo..")")
			System:Log(self:GetName()..": found ammo(x2): "..self.FoundAmmoEntity.ammo_type.."("..self.FoundAmmo..")")
			return 1
		end
	end
	self.FoundAmmo = AI:FindObjectOfType(self.id,SearchRadius,AIOBJECT_AMMO)
	self.FoundAmmoEntity = System:GetEntityByName(self.FoundAmmo)
	if self.FoundAmmoEntity and not self:CheckHaveOrNo(1) then
		local GetState = self.FoundAmmoEntity:GetState()
		if GetState=="Active" or GetState=="Dropped" then
			-- Hud:AddMessage(self:GetName()..": found ammo: "..self.FoundAmmoEntity.ammo_type.."("..self.FoundAmmo..")".." "..GetState)
			System:Log(self:GetName()..": found ammo: "..self.FoundAmmoEntity.ammo_type.."("..self.FoundAmmo..")".." "..GetState)
			local Current_FireParams
			local Current_AmmoType  -- Тип патронов.
			local Current_Ammo  -- Их количество в запасе.
			local Current_AmmoInClip = self.cnt.ammo_in_clip -- Текущее количество патронов в магазине текущего оружия.
			local Current_BulletsPerClip  -- Максимальное количество патронов, которое может быть в магазине.
			if self.fireparams then
				Current_FireParams = self.fireparams
				Current_AmmoType = Current_FireParams.AmmoType
				Current_Ammo = self.Ammo[Current_AmmoType]
				Current_BulletsPerClip = Current_FireParams.bullets_per_clip
			end
			if Current_Ammo<=Current_BulletsPerClip and Current_AmmoType~="Unlimited" then
				AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_NONE,"GET_AMMO",self.id)
				-- Hud:AddMessage(self:GetName()..": GET_AMMO")
			end
			return 1
		end
	end
	return nil
end

function BasicAI:FindHealth(Armor)
	if Armor and self~=_localplayer then Armor=nil end
	if self.IsIndoor then
		SearchRadius = 80 -- 30
	else
		SearchRadius = 100
	end
	if not self.allow_search then
		if self.sees~=1 then
			SearchRadius = 5 -- В бою искать только то, что близко.
			-- Hud:AddMessage(self:GetName()..": Find melee health/armor!")
			-- System:Log(self:GetName()..": Find melee health/armor!")
		else
			return nil
		end
	end
	if Armor then
		self.FoundHealth = AI:FindObjectOfType(self.id,SearchRadius,AIOBJECT_ARMOR)
	else
		self.FoundHealth = AI:FindObjectOfType(self.id,SearchRadius,AIOBJECT_HEALTH)
	end
	self.FoundHealthEntity = System:GetEntityByName(self.FoundHealth)
	if self.FoundHealthEntity then
		local GetState = self.FoundHealthEntity:GetState()
		if GetState=="Active" or GetState=="Dropped" then
			if Armor then
				-- Hud:AddMessage(self:GetName()..": found armor: "..self.FoundHealthEntity.pickuptype.."("..self.FoundHealth..")".." "..GetState)
				System:Log(self:GetName()..": found armor: "..self.FoundHealthEntity.pickuptype.."("..self.FoundHealth..")".." "..GetState)
			else
				-- Hud:AddMessage(self:GetName()..": found health: "..self.FoundHealthEntity.pickuptype.."("..self.FoundHealth..")".." "..GetState)
				System:Log(self:GetName()..": found health: "..self.FoundHealthEntity.pickuptype.."("..self.FoundHealth..")".." "..GetState)
			end
			return 1
		end
	end
	return nil
end

function BasicAI:CheckHaveOrNo(CheckAmmo) -- Был в руках мачете, но он почему то решил взять мачете, которое выкинул я.
	local WeaponsSlots = self.cnt:GetWeaponsSlots()
	if not CheckAmmo then -- Проверка наличия оружия.
		if WeaponsSlots then
			for i,New_Weapon in WeaponsSlots do
				if New_Weapon~=0 then
					if self.FoundWeaponEntity.weapon==New_Weapon.name then
						-- System:Log(self:GetName()..": WEAPON 1: "..self.FoundWeaponEntity.weapon.."("..self.FoundWeapon..")")
						return 1
					end
				end
			end
		end
		-- local MyPack = EquipPacks[self.Properties.equipEquipment]
		-- for i=1,100 do
			-- if MyPack and MyPack[i] then
				-- if self.FoundWeaponEntity.weapon==MyPack[i].Name then
					-- -- System:Log(self:GetName()..": WEAPON 2: "..self.FoundWeaponEntity.weapon.."("..self.FoundWeapon..")")
					-- return 1
				-- end
			-- end
		-- end
	else -- Проверка наличия патронов -- Добавить ещё поиск гранат.
		-- local Current_Weapon = self.cnt.weapon
		-- local Current_AmmoType  -- Тип патронов.
		-- local Current_Ammo  -- Их количество в запасе.
		-- local Current_AmmoInClip = self.cnt.ammo_in_clip -- Текущее количество патронов в магазине текущего оружия.
		-- local Current_BulletsPerClip  -- Максимальное количество патронов, которое может быть в магазине.
		-- local Current_Distance  -- Максимальная дистанция стрельбы.
		-- local Current_FireModeType  -- Режим огня.
		-- if self.fireparams then
			-- Current_AmmoType = self.fireparams.AmmoType
			-- Current_Ammo = self.Ammo[Current_AmmoType]
			-- Current_BulletsPerClip = self.fireparams.bullets_per_clip
			-- Current_Distance = self.fireparams.distance
			-- Current_FireModeType = self.fireparams.fire_mode_type
		-- end
		local Total = self:CountWeaponsInSlots()
		local WeaponsCount=0
		local NotReturn
		if WeaponsSlots then
			for i,New_Weapon in WeaponsSlots do
				if New_Weapon~=0 then
					local WeaponState = self.WeaponState
					local WeaponInfo = WeaponState[WeaponClassesEx[New_Weapon.name].id]
					local New_FireParams
					-- local New_AmmoType -- Тип патронов.
					local New_Ammo -- Их количество в запасе.
					-- local New_AmmoInClip -- Текущее количество патронов в магазине.
					local New_BulletsPerClip = New_Weapon.FireParams[1].bullets_per_clip  -- Максимальное количество патронов, которое может быть в магазине.
					-- local New_Distance -- Максимальная дистанция стрельбы.
					-- local New_FireModeType -- Режим огня.
					if WeaponInfo then
						New_FireParams = New_Weapon.FireParams[WeaponInfo.FireMode+1]
						New_AmmoType = New_FireParams.AmmoType
						New_Ammo = self.Ammo[New_AmmoType]
						-- New_AmmoInClip = WeaponInfo.AmmoInClip[self.firemodenum]
						-- New_Distance = New_FireParams.distance
						-- New_FireModeType = New_FireParams.fire_mode_type
					end
					if self.FoundAmmoEntity.ammo_type==New_AmmoType then
						local Max
						for i,val in MaxAmmo do
							if i==New_AmmoType then
								Max = val
							end
						end
						if New_Ammo and New_BulletsPerClip and New_Ammo>=Max-New_BulletsPerClip then -- Если кое-какое количество есть, то перезарядить.
							self:InsertSubpipe(0,"reload")
							-- Hud:AddMessage(self:GetName()..": AMMO: "..self.FoundAmmoEntity.ammo_type.."("..self.FoundAmmo..")"..", New_Ammo: "..New_Ammo.." >= "..Max-New_BulletsPerClip)
							-- System:Log(self:GetName()..": AMMO: "..self.FoundAmmoEntity.ammo_type.."("..self.FoundAmmo..")"..", New_Ammo: "..New_Ammo.." >= "..Max-New_BulletsPerClip)
							return 1
						else
							NotReturn=1
						end
					end
					WeaponsCount=WeaponsCount+1
					if WeaponsCount>=Total and not NotReturn then
						return 1
					end
				end
			end
		end
	end
	return nil
end

-- function BasicAI:AiCheckCollisions() -- Кручу-верчу, от стен отвернуть хочу. -- Сделал через CryGame.dll, там лучше работает.
	-- local pos = self:GetPos()
	-- local angle = self:GetAngles()
	-- local newangle = angle
	-- -- self.cnt:GetFirePosAngles(pos,angle)
	-- local hits = System:RayWorldIntersection(pos,angle,1,ent_static+ent_sleeping_rigid+ent_rigid+ent_living+ent_independent,self.id)
	-- -- local hits = System:RayWorldIntersection(pos,angle,1,ent_all,self.id)
	-- if getn(hits)>0 then
		-- if not self.TurnLeftOrRight or self.TurnLeftOrRight==0 then self.TurnLeftOrRight=random(-1,1) end
		-- newangle.x = newangle.x
		-- newangle.y = newangle.y
		-- newangle.z = newangle.z+self.TurnLeftOrRight  -- Где найти постоянный Update для функции?
		-- self:SetAngles(newangle)
		-- return
	-- else
		-- self.TurnLeftOrRight=nil
	-- end
	-- -- ANGLE: X - по вертикали, Y - вокруг оси, Z - по горизонтали.
	-- -- Hud:AddMessage(self:GetName()..": HITS: "..getn(hits).."  POS X: "..pos.x..", Y: "..pos.y..", Z: "..pos.z.."  ANGLE X: "..angle.x..", Y: "..angle.y..", Z: "..angle.z)  -- Вылетает при логгировании, почти сразу.
	-- -- System:Log(self:GetName()..": HITS: "..getn(hits).."  POS X: "..pos.x..", Y: "..pos.y..", Z: "..pos.z.."  ANGLE X: "..angle.x..", Y: "..angle.y..", Z: "..angle.z)
	-- -- System:Log(self:GetName()..": HITS: "..getn(hits))
-- end

function BasicAI:CountWeaponsInSlots(NoMeleeWeapon,NoHands,AllFireModes,NoUnlimited) -- А не проще ли таблицей отдавать?
	return BasicPlayer.CountWeaponsInSlots(self,NoMeleeWeapon,NoHands,AllFireModes,NoUnlimited)
end

function BasicAI:NewCountWeaponsInSlots(NotAllFireModes,NoMeleeCount,NoHandsCount,NoUnlimitedCount,NoProjectilesCount)
	return BasicPlayer.NewCountWeaponsInSlots(self,NotAllFireModes,NoMeleeCount,NoHandsCount,NoUnlimitedCount,NoProjectilesCount)
end

function BasicAI:GetDistanceToTarget(att_target)
	return BasicPlayer.GetDistanceToTarget(self,att_target)
end

function BasicAI:MutantJump(AnchorType,fDistance,flags)
	-- Как работают флаги:
	-- #define AIFAF_VISIBLE_FROM_REQUESTER 1 //! Requires whoever is requesting the anchor to also have a line of sight to it. Когда нет препятствий, видит якорь.
	-- #define AIFAF_VISIBLE_TARGET	2 //! Requires that there is a line of sight between target and anchor.

	if (AnchorType==nil) then
		AnchorType = AIAnchor.MUTANT_JUMP_TARGET
	end

	if (fDistance==nil) then
		fDistance = 30
	end

	if (self.cnt.flying) then
		do return end
	end

	if (self.AI_SpecialPoints==nil) then
		self.AI_SpecialPoints = 0
	end

	local jmp_name = self:GetName().."_JUMP"..self.AI_SpecialPoints
	local TagPoint = Game:GetTagPoint(jmp_name)
	if (TagPoint) then
		AI:CreateGoalPipe("jump_to")
		AI:PushGoal("jump_to","ignoreall",0,1)
		AI:PushGoal("jump_to","clear",0)
		AI:PushGoal("jump_to","not_shoot")
		AI:PushGoal("jump_to","jump",1,0,0,0,self.Properties.fJumpAngle)  -- actual jump executed here
		AI:PushGoal("jump_to","ignoreall",0,0)

		AI:Signal(0,1,"JUMP_ALLOWED",self.id)
		self:SelectPipe(0,"jump_wrapper")
		self:InsertSubpipe(0,"jump_to",jmp_name)
		self.AI_SpecialPoints=self.AI_SpecialPoints+1
		self.ThisMutantJump=1
		return 1
	end

	local jmp_point
	if AnchorType==AIAnchor.MUTANT_JUMP_TARGET then
		jmp_point = AI:FindObjectOfType(self.id,fDistance,AIAnchor.MUTANT_JUMP_TARGET_WALKING,flags)  -- Четвёртый параметр (flags) возвращает позицию найденного объекта.
	end
	if not jmp_point then
		-- local att_target = AI:GetAttentionTargetOf(self.id)
		-- if att_target and type(att_target)=="table" then
			-- distancetotarget = self:GetDistanceFromPoint(att_target:GetPos())
			-- -- if distancetotarget <= 10 then return nil end
			-- local jmp_point2 = AI:FindObjectOfType(self.id,fDistance,AnchorType,flags)
			-- -- local jmp_point_entity = System:GetEntityByName(jmp_point2)
			-- local jmp_point_distance = self:GetDistanceFromPoint(jmp_point2) -- Почему то копирует дистанию до цели. Нужно правильно вытащить дистацию до якоря.
			-- -- if distancetotarget < fDistance then
			-- if distancetotarget > jmp_point_distance then
			-- -- if distancetotarget > jmp_point_distance and distancetotarget > fDistance then
				-- local att_target_entity = System:GetEntityByName(att_target)
				-- jmp_point = AI:FindObjectOfType(att_target_entity,fDistance,AnchorType,flags)
				-- Hud:AddMessage(self:GetName()..": jmp_point: "..jmp_point..", AnchorType: "..AnchorType..", Distance to target: "..distancetotarget..", anchor Distance: "..fDistance..", jmp_point_distance: "..jmp_point_distance)
				-- System:Log(self:GetName()..": jmp_point: "..jmp_point..", AnchorType: "..AnchorType..", Distance to target: "..distancetotarget..", anchor Distance: "..fDistance..", jmp_point_distance: "..jmp_point_distance)
			-- else
				-- Hud:AddMessage(self:GetName()..": not jump! jmp_point_distance: "..jmp_point_distance..", distancetotarget: "..distancetotarget)
				-- System:Log(self:GetName()..": not jump! jmp_point_distance: "..jmp_point_distance..", distancetotarget: "..distancetotarget)
				-- return nil
				-- -- jmp_point = jmp_point2
			-- end
		-- end
		if not jmp_point then
			jmp_point = AI:FindObjectOfType(self.id,fDistance,AnchorType,flags)
		end
		if jmp_point then
			self.AI_CanWalk = nil
		end
	else
		self.AI_CanWalk = 1
	end
	-- local entity = System:GetEntityByName(jmp_point) -- Тьфу, сущность из якорей не извлекается.
	-- local fDistance = self:GetDistanceFromPoint(entity:GetPos())
	-- if fDistance<=5 then jmp_point=nil end -- Это должно было быть как: если якорь очень близко, то не прыгать. Надо переделать искать самые дальние.
	if jmp_point then
		if AnchorType==212 or AnchorType==213 then
			AI:CreateGoalPipe("jump_on_anchor")
			AI:PushGoal("jump_on_anchor","signal",1,1,"JUMP_ALLOWED",0)
			AI:PushGoal("jump_on_anchor","ignoreall",0,1)
			AI:PushGoal("jump_on_anchor","not_shoot")
			AI:PushGoal("jump_on_anchor","jump",1,0,0,0,self.Properties.fJumpAngle)
			AI:PushGoal("jump_on_anchor","ignoreall",0,0)
			AI:PushGoal("jump_on_anchor","signal",1,1,"JUMP_FINISHED",0)
			AI:PushGoal("jump_on_anchor","clear")
			AI:PushGoal("jump_on_anchor","just_shoot")
			self:SelectPipe(0,"jump_on_anchor",jmp_point)
		else
			AI:CreateGoalPipe("jump_on_anchor")
			AI:PushGoal("jump_on_anchor","ignoreall",0,1)
			AI:PushGoal("jump_on_anchor","signal",1,1,"JUMP_ALLOWED",0)
			if AnchorType==215 then
				AI:PushGoal("jump_on_anchor","acqtarget",1,"")
				AI:PushGoal("jump_on_anchor","timeout",1,.2)
			end
			AI:PushGoal("jump_on_anchor","not_shoot")
			AI:PushGoal("jump_on_anchor","jump",1,0,0,0,self.Properties.fJumpAngle)
			AI:PushGoal("jump_on_anchor","devalue_target")
			-- AI:PushGoal("jump_on_anchor","clear")
			AI:PushGoal("jump_on_anchor","ignoreall",0,0)
			AI:PushGoal("jump_on_anchor","signal",1,1,"JUMP_FINISHED",0)
			AI:PushGoal("jump_on_anchor","signal",1,1,"PREDATOR_ATTACK",0)
			self:SelectPipe(0,"jump_on_anchor",jmp_point)
			self:InsertSubpipe(0,"setup_stand")
			self:InsertSubpipe(0,"do_it_running")
		end
		self.ThisMutantJump=1
		-- Hud:AddMessage(self:GetName()..": jmp_point: "..jmp_point..", AnchorType: "..AnchorType)
		-- System:Log(self:GetName()..": jmp_point: "..jmp_point..", AnchorType: "..AnchorType)
		return 1
	end
	return nil
end

function BasicAI:PushStuff()

	local push_point = AI:GetAnchor(self.id,AIAnchor.PUSH_THIS_WAY,10)
--	local push_point = AI:FindObjectOfType(self.id,10,AIAnchor.PUSH_THIS_WAY)
	if (push_point) then
		self:InsertSubpipe(0,"mutant_push_stuff_at",push_point)
	end

end

function BasicAI:FindThePointForSwimming()
	local ObjectList={
		AIAnchor.SWIM_HERE,
		AIAnchor.FISH_HERE,
		AIAnchor.AIANCHOR_SMOKE,
		AIAnchor.BLIND_ALARM,
		AIAnchor.AIANCHOR_PUSHBUTTON,
		AIAnchor.z_CARENTER_GUNNER,
		AIAnchor.z_CARENTER_DRIVER,
		AIAnchor.RETREAT_HERE,
		AIAnchor.AIANCHOR_REINFORCEPOINT,
		AIAnchor.AIANCHOR_NOTIFY_GROUP_DELAY,
		AIAnchor.RESPOND_TO_REINFORCEMENT,
		-- AIAnchor.INVESTIGATE_HERE,
	}
	local SearchRadius = 300
	for i,val in ObjectList do -- "val" выдаёт id экшена у якоря (Anchor.lua).
		if val==123 or val==160 then SearchRadius = 150 end
		local FoundObject = AI:FindObjectOfType(self.id,SearchRadius,val)
		if FoundObject then return FoundObject end
	end
	SearchRadius = 10000
	local Entities = {}
	Game:GetPlayerEntitiesInRadius(self:GetPos(),SearchRadius,Entities) -- ДОДЕЛАТЬ! Не находит игрока.
	for i,val in Entities do
		local entity = val.pEntity -- local не было. Проверить на баги.
		if entity.id~=self.id and entity.Properties.species==self.Properties.species
		and (entity~=_localplayer or (entity~=_localplayer and Hud)) and not entity.cnt:IsSwimming() and not entity.cnt.flying then
			-- System:Log(self:GetName()..": Entity: "..entity:GetName())
			return entity.id
		end
	end
	-- local fDistance
	-- local Entities
	-- if GameRules.AllEntities then
		-- Entities = GameRules.AllEntities
	-- end
	-- if Entities then
		-- local entity2
		-- for i,entity in Entities do
			-- if entity.type~="Player" then
				-- local fDistance2 = self:GetDistanceFromPoint(entity:GetPos())
				-- if not fDistance or fDistance>fDistance2 then
					-- -- System:Log(self:GetName()..": Entity: "..entity:GetName()..", Type: "..entity.type..", Id: "..entity.id)
					-- fDistance = fDistance2
					-- entity2 = entity
				-- end
			-- end
		-- end
		-- if entity2 then -- Как-то глючно ищет(оказывается, только в режиме игры) и даже если находит, то не плывёт на эту цель.
			-- -- System:Log(self:GetName()..": Entity: "..entity2:GetName()..", Type: "..entity2.type..", Id: "..entity2.id)
			-- return entity.id
		-- end
	-- end

	local fDistance
	local Entities
	if GameRules.AllEntities then
		Entities = GameRules.AllEntities
	end
	if Entities then
		local entity2
		for i,entity in Entities do
			if entity.GetName then
				-- if entity.type=="Vehicle" then
				-- if entity.type~="Player" and not Game:IsPointInWater(entity:GetPos()) then
					-- local fDistance2 = self:GetDistanceToTarget(entity)
					-- if fDistance2 and (not fDistance or fDistance>fDistance2) then
						-- fDistance = fDistance2
						-- entity2 = entity
						-- Hud:AddMessage(self:GetName()..": Entity: "..entity2:GetName()..", Type: "..entity2.type..", Id: "..entity2.id..", fDistance: "..fDistance.." > fDistance2: "..fDistance2)
						-- System:Log(self:GetName()..": Entity: "..entity2:GetName()..", Type: "..entity2.type..", Id: "..entity2.id..", fDistance: "..fDistance.." > fDistance2: "..fDistance2)
					-- end
				-- end
				if entity.type~="Player" and not Game:IsPointInWater(entity:GetPos()) then
					local fDistance2 = self:GetDistanceToTarget(entity)
					-- local fDistance2 = self:GetDistanceFromPoint(entity:GetPos())
					if not fDistance or fDistance>fDistance2 then
						fDistance = fDistance2
						entity2 = entity
						-- if not fDistance then fDistance="nil" end
						-- if not fDistance2 then fDistance2="nil" end
						-- System:Log(self:GetName()..": Entity: "..entity2:GetName()..", Type: "..entity2.type..", Id: "..entity2.id..", fDistance: "..fDistance..", fDistance2: "..fDistance2)
						-- if fDistance=="nil" then fDistance=nil end
						-- if fDistance2=="nil" then fDistance2=nil end
					end
				end
			end
		end
		if entity2 then
			-- Hud:AddMessage(self:GetName()..": Entity 2: "..entity2:GetName()..", Type: "..entity2.type..", Id: "..entity2.id)
			System:Log(self:GetName()..": Entity 2: "..entity2:GetName()..", Type: "..entity2.type..", Id: "..entity2.id)
			return entity2.id -- Добавить таким сущностям 20 секундное игнорирование на поиск.
		end
	end

	Game:GetPlayerEntitiesInRadius(self:GetPos(),SearchRadius,Entities) -- Снова искать людей. Только не своих, а чужаков.
	for i,val in Entities do
		local entity = val.pEntity -- local не было. Проверить на баги.
		if entity.id~=self.id and entity.Properties.species~=self.Properties.species
		and (entity~=_localplayer or (entity~=_localplayer and Hud)) and not entity.cnt:IsSwimming() and not entity.cnt.flying then
			System:Log(self:GetName()..": Entity 3: "..entity:GetName())
			return entity.id
		end
	end
	return nil
end

function BasicAI:UpdateSwimming()
	local Pos = self:GetPos()
	-- local WaterHeight = Game:GetWaterHeight()
	-- local TerrainElevation = System:GetTerrainElevation(Pos)
	local IsPointInWater = Game:IsPointInWater(Pos)
	local IsSwimming = self.cnt:IsSwimming()
	-- if self.IsIndoor then
		-- System:Log(self:GetName()..": self.IsIndoor")
	-- end
	if IsSwimming and self.Behaviour.Name~="Swim" then
		AI:Signal(0,-1,"PRE_START_SWIMMING",self.id)
	elseif self.Behaviour.Name=="Swim" then
		-- local Pos = new(self:GetPos())
		-- if self.SwimPrevPos and self.SwimPrevPos==Pos then -- Доработать.
			-- Hud:AddMessage(self:GetName()..": RE MERC_START_SWIMMING")
			-- System:Log(self:GetName()..": RE MERC_START_SWIMMING")
			-- AI:Signal(0,1,"MERC_START_SWIMMING",self.id)
		-- end
		-- self.SwimPrevPos = Pos
		if self.RepeatMercStartSwimmingTimerStart and _time>self.RepeatMercStartSwimmingTimerStart+1 then
			self.RepeatMercStartSwimmingTimerStart = nil
			AI:Signal(0,1,"MERC_START_SWIMMING",self.id)
		end
		if not IsPointInWater or (not IsSwimming and self.sees~=0) then
			AI:Signal(0,1,"MERC_STOP_SWIMMING",self.id)
		end
	end
end

function BasicAI:InitAIRelaxed()
	--self.cnt:DrawThirdPersonWeapon(0)
	-- if (self.fireparams) then
		-- if (self.fireparams.type) and (self.fireparams.type==2) then
			-- self.PropertiesInstance.bGunReady = 1
		-- end
	-- end  -- pistols are always ready
	local weapon = self.cnt.weapon
	if weapon then
		local FireModeType = self.fireparams.fire_mode_type
		if weapon.name=="Falcon" or (FireModeType and FireModeType==FireMode_Melee) then
			self.PropertiesInstance.bGunReady = 1
		end
	-- else
		--System:Log("\001 currently selected Weapon is NULL ")
	end
	-- if self.PropertiesInstance.bGunReady==0 then
	if self.PropertiesInstance.bGunReady==0 and not self.AI_GunOut then -- Последнее для случаев с invesigate и для Вэл.
		self.cnt:HolsterGun()
		self.AI_GunOut = nil
		-- self.cnt:DrawThirdPersonWeapon(0)
	else
		self.cnt:HoldGun()
		self.AI_GunOut = 1
		-- self.cnt:DrawThirdPersonWeapon(1)
	end
	self.RunToTrigger = nil
end

function BasicAI:InitAICombat() -- Это, кажется, было для снайпера.
	--self.cnt:DrawThirdPersonWeapon(0)
	self.cnt:HoldGun()
	self.AI_GunOut = 1
	self.RunToTrigger = nil
end

function BasicAI:DoJump(Params)
	if (Params==1) then
		--Hud:AddMessage("land")
		if (Sound:IsPlaying(self.LastLandSound)==nil) then
			self.LastLandSound = nil
		end
		if (self.landsounds and self.LastLandSound==nil) then
			self.LastLandSound = BasicPlayer.PlayOneSound(self,self.landsounds,101,1)
		end
	else
		--Hud:AddMessage("jump")
		if (Sound:IsPlaying(self.LastJumpSound)==nil) then
			self.LastJumpSound = nil
		end
		if (self.jumpsounds and self.LastJumpSound==nil) then
			self.LastJumpSound = BasicPlayer.PlayOneSound(self,self.jumpsounds,101,1)
		end
	end
end

function BasicAI:DoJump2(PowerPulse,ForwardPulse) -- C++ Когда игра закрывается, в логе пишет что функция не найдена. Сделать проверку на наличие.
	if not self.PrevMovingStatus then -- Чтобы солдаты подпрыгивали только когда начинают двигаться (вперёд).
		self:AddImpulseObj({x=0,y=0,z=1},PowerPulse)  -- Сетевые боты миксера так прыгают.
		-- Hud:AddMessage(self:GetName()..": I jump!")
		-- System:Log(self:GetName()..": I jump!")
		if self.ActiveTimeStart and _time>self.ActiveTimeStart+1 then -- Чтобы не было критической ошибки в случае массового пробуждения с подпрыгиванием.
			if ForwardPulse and ForwardPulse>0 then
				-- local Direction = new(self:GetDirectionVector()) -- Гениус! Млин!
				local Direction = self:GetDirectionVector()
				-- System:Log(self:GetName()..": Direction x: "..Direction.x..", y: "..Direction.y..", z: "..Direction.z)
				self:AddImpulseObj(Direction,ForwardPulse) -- Как же слить воедино два импульса?
			end
		end
	end
end

-- function BasicAI:DoJump2(PowerPulse,AddDirection) -- C++ Когда игра закрывается, в логе пишет что функция не найдена. Сделать проверку на наличие.
	-- if not self.PrevMovingStatus then -- Чтобы солдаты подпрыгивали только когда начинают двигаться (вперёд).
		-- if self.ActiveTimeStart and _time>self.ActiveTimeStart+1 then -- Чтобы не было критической ошибки в случае массового пробуждения с подпрыгиванием.
			-- local Direction = {x=0,y=0,z=1}
			-- if AddDirection and AddDirection>0 then
				-- Direction = self:GetDirectionVector()
				-- Direction.z = 1
				-- -- mergef(Direction,self:GetDirectionVector())
				-- System:Log(self:GetName()..": Direction x: "..Direction.x..", y: "..Direction.y..", z: "..Direction.z)
			-- end
		-- end
		-- self:AddImpulseObj(Direction,PowerPulse)  -- Сетевые боты миксера так прыгают.
	-- end
-- end

function BasicAI:DoCustomStep(material,pos)

	if (self.footstepsounds==nil) then return nil  end

	if (LengthSqVector(self:GetVelocity())<1) then return nil  end

	if (not Game:IsPointInWater(pos)) then

		local footstepcount = self.footstepcount

		--stop the previous sound if exist.
		Sound:StopSound(self.footsteparray[footstepcount])
		self.footsteparray[footstepcount] = BasicPlayer.PlayOneSound(self,self.footstepsounds,101,1)

		footstepcount = footstepcount + 1

		--loop cycle through the foot step array
		if (footstepcount > count(self.footsteparray)) then footstepcount = 1  end

		self.footstepcount = footstepcount

		--System:Log(sprintf("foot step iterator : %i",self.footstepcount))

		return 1
	end

	return nil
end

function BasicAI:SetSmoothMovement()
	-- smooth AI movement input (acceleration,deceleration,indoor_acceleration,indoor_deceleration)
	if self.MUTANT and self.MUTANT=="predator" then
		self.cnt:SetSmoothInput(3,15,6,18)
	else
		self.cnt:SetSmoothInput(3,15,5,15)  -- Первые два для игрока и ИИ, третий и четвёртый только для ИИ. Игрок итак хорошо перемещается в помещениях.
	end
end

function CreateAI(child)
	local newt={}
	mergef(newt,BasicAI,1)
	mergef(newt,child,1)
	newt.PropertiesInstance.bHelmetProtection = 1
	return newt
end