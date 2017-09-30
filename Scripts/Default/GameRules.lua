-------------------------------------------------------------------
-- X-Isle Script File
-- Description: Defines the rules of the default game(Single player)
-- Created by Alberto Demichelis
--------------------------------------------------------------------
GameRules = {
	InitialPlayerProperties = {
		health = 255,			-- range: 0=dead .. 255=full health
		-- we do not have armor in FarCry right now
		-- [marco] we do,initially is set to 0 though
		armor = 0,
	},

	m_nMusicId=0,

	-- head, heart, body, arm, leg, explosion
	-- голова, сердце, тело, рука, нога, взрыв
	common_damage = {10,10,1,.3,.4,1},

	Arm2BodyDamage = .75, -- Множитель урона от попадания по руке.
	Leg2BodyDamage = 1, -- Множитель урона от попадания по ноге.
	god_mode_count=0, -- Счетчик смертей в режиме бессемертия.

	player_death_pos = {x=0,y=0,z=0,xA=0,yA=0,zA=0},

	TimeRespawn=10,
	TimeDied=0,
	bShowUnitHightlight=nil,			-- 1/nil (show a 3d object on top of every friendly unit)
	fBullseyeDamageLevel =  20,		-- amount of damage until the
	fBullseyeDamageDecay = .5,		-- X units of damage lost per second
}

-- If someone in script needs to know if we are running multiplayer or single player game.
GameRules.bMultiplayer = nil
GameRules.bSingleplayer = 1

function GameRules:GetPlayerScoreInfo(ServerSlot,Stream)
end

function GameRules:OnInit()
	Server:AddTeam("dm")
	--Initialize the debug tag point thingy
	DebugTagPointsMgr:Init(g_LevelName)
	_LastCheckPPos=nil
	self.god_mode_count=0  -- must be reset when switching to game mode in editor
	--s_deformable_terrain=1
	self.CurrentDifficultyValue = tonumber(getglobal("game_DifficultyLevel"))
	GameRules.AllEntities=System:GetEntities() -- Чтобы список сущностей с самого начала был или был, даже если нет OnUpdate(сразу после загрузки карты в редакторе).
	-- local DamageMultiplier = tonumber(getglobal("game_DamageMultiplier"))
	-- if DamageMultiplier then
		-- if (DamageMultiplier~=1 and DamageMultiplier~=.4) or self.CurrentDifficultyValue>=3 then DamageMultiplier = 1 end
		-- GameRules.OnInitDamageMultiplier = DamageMultiplier -- Чтобы игроки не мошенничали с уроном.
		-- -- Hud:AddMessage("GameRules:OnInit, GameRules.OnInitDamageMultiplier: "..GameRules.OnInitDamageMultiplier)
		-- -- System:Log("GameRules:OnInit, GameRules.OnInitDamageMultiplier: "..GameRules.OnInitDamageMultiplier)
	-- end
	Game:CreateVariable("sc",0)
	if UI then -- Только в игре.
		local CreateAssistant = tonumber(getglobal("game_CreateAssistant"))
		if CreateAssistant==1 then
			GameRules.AiPlayerSpawn = 1
			setglobal("sc",1)
		end
	end
	-- setglobal("r_Contrast",.6) -- Контраст такой, что ни светло, ни темно. Убрал, возможно, на время.
	-- setglobal("r_Contrast",.5)
	local RenderMode = tonumber(getglobal("r_RenderMode")) -- - 0 - обычные цвета, 1 - улучшенные цвета, 2 - райские цвета, 3 - холодные цвета, 4 - мультфильм.
	if UI and RenderMode==0 then
		setglobal("r_RenderMode",1) -- 2 - не надо, не серьёзно.
	elseif not UI and RenderMode~=0 then
		setglobal("r_RenderMode",0)
	end
	-- local BumpMapping = tonumber(getglobal("r_Quality_BumpMapping"))
	-- if BumpMapping==3 then
		-- setglobal("r_Quality_BumpMapping",2)
	-- end
	-- local doProjectileLight = tonumber(getglobal("cl_weapon_light"))
	-- if doProjectileLight==0 then
		-- setglobal("cl_weapon_light",1) -- Для того чтобы боты замечали цель, когда она стреляет в темноте.
	-- end
	-- setglobal("gr_realistic_reload",1)

	--	То, что далее, не уверен, что работает.
	-- setglobal("e_obj_view_dist_ratio",70) -- 100 -- Выключил, потому что лагает в редакторе и нужно видеть реальную картинку без девмода.
	setglobal("e_water_ocean_tesselation",1) -- Тесселяция воды (не та, что в Крайсисе, но линия горизонта океана изменяется). Общий цвет тоже, это видно, если включать и выключать, и смотреть с какой-нибудь высокой позиции на карте.
	-- setglobal("e_water_ocean_sun_reflection",1) -- Отражение солнца на воде. В плохую погоду всю красоту портит.
	setglobal("e_light_maps_occlusion",1)
	setglobal("e_max_shadow_map_size",512) -- Разрешение карты теней. Странно, эффекта больше 512 не даёт, а если и поставить больше, то у тени нашего персонажа начнут пропадать ноги.
	setglobal("r_ShaderTerrainSpecular",1)
	setglobal("r_selfshadow",1) -- Подвижные объекты отбрасывают тени на себя.  -- Должно было быть в настройках.
	setglobal("r_selfRefract",1)
	setglobal("r_BumpSelfShadow",1)
	setglobal("r_Dof",1)
	-- if UI then -- При загрузке в редакторе вызывает подвисание и не даёт сразу приступить к работе. А ещё на новой m4, если включить, то при загрузке будет вылетать с критической ошибкой.
		-- setglobal("r_TexNormalMapCompressed",1) -- Сжатие карт нормалей (на картинку не влияет).
	-- end
	-- setglobal("r_Texture_Anisotropic_Level",16) -- Есть в настройках.
	setglobal("e_hw_occlusion_culling_objects",1)
	-- setglobal("r_EnvLighting",1) -- В оригинале вызывает зависания. Error: CRenderer::EF_GetObject: Too many objects (> 4096)
	setglobal("r_EnvLighting",0) -- Лучше пусть всегда вырубает, если случайно включится.

	-- setglobal("e_vegetation_sprites_distance_ratio",8) -- Собственно, расстояние, на котором спрайты заменяются 3д моделями. 8 вполне хватает. Есть в настройках.

	-- setglobal("r_HDRRendering",1) -- 0 1-11
	-- setglobal("r_HDRBrightOffset",100) -- 6 0-100
	-- setglobal("r_HDRBrightThreshold",2) -- 3 0-2
	-- setglobal("r_HDRLevel",0) -- .6
	local AutoBalance = tonumber(getglobal("ai_autobalance"))
	if AutoBalance==1 then
		setglobal("ai_autobalance",0) -- У меня всё-равно по другому ИИ стреляет, а потому автобаланс сломан.
	end

	GameRules.AiPlayerFirstGoFollow = 1
end

function GameRules:OnUpdate(DeltaTime)
	-- local dist = tonumber(getglobal("e_obj_view_dist_ratio"))
	-- Hud:AddMessage("e_obj_view_dist_ratio: "..dist)
	-- setglobal("e_obj_view_dist_ratio",210)
	-- Hud:AddMessage("GameRules:OnUpdate(DeltaTime)")
	-- local DamageMultiplier = tonumber(getglobal("game_DamageMultiplier"))
	-- if DamageMultiplier and GameRules.OnInitDamageMultiplier then
		-- if DamageMultiplier~=GameRules.OnInitDamageMultiplier then
			-- -- Hud:AddMessage("GameRules:OnUpdate, GameRules.OnInitDamageMultiplier: "..GameRules.OnInitDamageMultiplier..", DamageMultiplier: "..DamageMultiplier)
			-- -- System:Log("GameRules:OnUpdate, GameRules.OnInitDamageMultiplier: "..GameRules.OnInitDamageMultiplier..", DamageMultiplier: "..DamageMultiplier)
			-- setglobal("game_DamageMultiplier",GameRules.OnInitDamageMultiplier)
		-- end
	-- end
	if not self.GetEntitiesUpdateTimer then self.GetEntitiesUpdateTimer = _time end
	if _time > self.GetEntitiesUpdateTimer+1 then
		self.GetEntitiesUpdateTimer = nil
		GameRules.AllEntities=System:GetEntities()
		GameRules.PlayerEntitiesScreenSpace=Game:GetEntitiesScreenSpace("Bip01 Spine2")
	end
	local sc = tonumber(getglobal("sc"))
	if sc>0 and _localplayer then
		if not Game:IsMultiplayer() then -- А нужно ли здесь?
			if sc>10 then sc=10 end
			for i=1,sc do
				local AiPlayer
				local entities=System:GetEntities()
				for i,entity in entities do
					if entity.IsAiPlayer and entity.id~=_localplayer.id then -- Локального игрока с ИИ пропускаем.
						AiPlayer = 1
						break
					end
				end
				if not UI or (UI and not AiPlayer) then
					-- if not UI then
						-- if not self.SpawnPlayerCopyStartTimer then self.SpawnPlayerCopyStartTimer = _time end
						-- if _time > self.SpawnPlayerCopyStartTimer+.1 then
							-- self.SpawnPlayerCopyStartTimer = nil
							-- BasicAI:SpawnPlayerCopy() -- sc = 0
						-- end
					-- else
						BasicAI:SpawnPlayerCopy() -- sc = 0
					-- end
				elseif UI and AiPlayer then
					setglobal("sc",0)
					break
				end
			end
		else
			setglobal("sc",0)
		end
	end
	setglobal("game_Accuracy",1)
	setglobal("game_Aggression",1)
	setglobal("ai_allow_accuracy_decrease",1)
	setglobal("ai_allow_accuracy_increase",1)
	setglobal("game_DamageMultiplier",1)
	setglobal("ai_SOM_SPEED",2.2)
	setglobal("gr_realistic_reload",1)
	local Difficulty = tonumber(getglobal("game_DifficultyLevel"))
	if Difficulty<2 then
		-- setglobal("game_DamageMultiplier",.4)
		setglobal("game_DamageMultiplier",.03) -- .02 -- Сейчас это распространяется только на игрока и ему подобных на лёгкой сложности. Сейчас исключил IsAiPlayer, нужно честное определение его поведенческих качеств...
		-- setglobal("ai_SOM_SPEED",2.0) -- 1.5 -- 1.2 - это в оригинале всегда было для очень лёгкого.
		setglobal("gr_realistic_reload",0)
	-- elseif Difficulty==2 or Difficulty==3 then
		-- setglobal("ai_SOM_SPEED",1.8)
	-- else
	end
	if not UI then return end -- UI пропадает когда я четвёртую сложность ставлю. Хм.
	if not self.CurrentDifficultyValue then self.CurrentDifficultyValue = Difficulty end
	if self.CurrentDifficultyValue~=tonumber(getglobal("game_DifficultyLevel")) then
		local dv = self.CurrentDifficultyValue
		UI.PageCampaign:SetAIDifficulty(UI.PageCampaignStart.dv)
		self.CurrentDifficultyValue = tonumber(getglobal("game_DifficultyLevel"))
	end
end

function GameRules:OnShutdown()
end

function GameRules:OnMapChange()
    _LastCheckPPos = nil
    _LastCheckPAngles = nil
end

function GameRules:ApplyDamage(target,damage,damage_type,shooter,HitOnPlayerArmor)
	-- self.OldHealth = target.cnt.health
	-- self.OldArmor = target.cnt.armor

	local bGodMode = 0
	if god and tonumber(god)==1 and target==_localplayer then
	-- if (god and tonumber(god)==1 and target==_localplayer) or (target~=_localplayer and target.IsAiPlayer) then -- Сделать ИИ друга неубиваемым.
		bGodMode = 1
	end
	-- if shooter.IsCaged then AI:Signal(0,1,"RELEASED",shooter.id) end
	-- if (damage > 0) then
		-- --- apply damage first to armor,if it is present
		-- if (damage_type~="healthonly") then
			-- if (target.cnt.armor > 0) then
				-- target.cnt.armor = target.cnt.armor - (damage*.5)
				-- -- clamp to zero
				-- if (target.cnt.armor < 0) then
					-- damage = -target.cnt.armor
					-- target.cnt.armor = 0
				-- else
					-- damage = 0
				-- end
			-- end
		-- end
	-- end
	-- target.cnt.health = target.cnt.health - damage

	if damage > 0 then
		--- apply damage first to armor,if it is present
		if damage_type~="healthonly" then
			if target.cnt.armor > 0 and HitOnPlayerArmor then -- Это касается только игрока. Теперь его броня и здоровье разделены.
				target.cnt.armor = target.cnt.armor - (damage*.5)
				-- clamp to zero
				if target.cnt.armor < 0 then
					damage = -target.cnt.armor
					target.cnt.armor = 0
				else
					damage = 0 -- Не наносить ущерб здоровью.
				end
			end
		end
	end
	target.cnt.health = target.cnt.health - damage

	-- negative damage (medic tool) is is bounded to max_health
	if (target.cnt.health>target.cnt.max_health) then
		target.cnt.health=target.cnt.max_health
	end

	if target.cnt.health < 1 then
		if bGodMode==1 then
			GameRules.god_mode_count=GameRules.god_mode_count+1
			target.cnt.health = self.InitialPlayerProperties.health
		else
			if target.WasIsCaged then
				AI:Signal(0,1,"AfterIsCagedAttack",shooter.id)
				-- AI:Signal(SIGNALFILTER_GROUPONLY,1,"AfterIsCagedAttack",shooter.id)
				AI:Signal(SIGNALFILTER_SUPERGROUP,1,"AfterIsCagedAttack",shooter.id)
				AI:Signal(SIGNALFILTER_SPECIESONLY,1,"AfterIsCagedAttack",shooter.id)
			end
			target.cnt.health = 0
			local angles=target:GetAngles()
			--GameRules.player_death_pos.x=target:GetPos()
			local	place = target:GetPos()
			GameRules.player_death_pos.x=place.x
			GameRules.player_death_pos.y=place.y
			GameRules.player_death_pos.z=place.z
			GameRules.player_death_pos.xA=angles.x
			--GameRules.player_death_pos.yA=angles.y
			--no roll needed!!!!!
			GameRules.player_death_pos.yA=0
			GameRules.player_death_pos.zA=angles.z
			if shooter then
				if shooter.IsAiPlayer then
					-- if random(1,2)==1 then
						-- Hud:AddMessage(shooter:GetName().."$1: @HeIsDead")
					-- end
					AI:Signal(0,1,"OnNoTarget",shooter.id)
					-- shooter:TriggerEvent(AIEVENT_CLEAR)
				elseif shooter.Properties and shooter.Properties.species~=target.Properties.species then
					AI:Signal(0,1,"OnTheMurder",shooter.id)
				end
				AI:Signal(0,1,"I_KILLED_HIM",shooter.id)
				shooter.SaveIdKilled = target.id
			end
			-- if shooter and shooter.IsSpecOpsMan then
			-- end
			if target==_localplayer or target.IsAiPlayer then
				self.TimeDied=_time
				if shooter then
					System:Log(target:GetName().." $8was killed $1"..shooter:GetName())
					-- System:Log(target:GetName().." $8was killed $1"..shooter:GetName().." $1with: "..) -- Добавить чтобы показывало с чего убили.
				end
			end
			if shooter then
				target.MyKiller = shooter
			end
			target:GotoState("Dead")
		end
		--Game:ForceScoreBoard(target.id,1)
	end
end

function GameRules:OnDamage(hit)
    local theTarget = hit.target
    local theShooter = hit.shooter
    --System.LogToConsole("--> GameRules:OnDamage shooter=="..hit.shooter.GetID())

	-- mat_head
	-- mat_heart
	-- mat_arm
	-- mat_leg
	-- mat_flesh
	-- mat_armor
	-- mat_helmet

	-- if theTarget==_localplayer and  then return end -- Не убивать в редакторе в режиме редактирования. Доработать, добавить так же в OnMiscDamage.

	if (theTarget) then
		if (theTarget.type=="Player") then

			local bShooterIsPlayer
			local bShooterIsAI

			if theShooter then
				if theShooter.ai then
					bShooterIsAI=1
				else
					bShooterIsPlayer=1
				end
			end

			-- used for Autobalancing
			theTarget.LastDamageDoneByPlayer=bShooterIsPlayer

			-- local DmgM = 1
			-- local DamageMultiplier = tonumber(getglobal("game_DamageMultiplier"))
			-- if DamageMultiplier then
				-- -- if DamageMultiplier<.1 then
					-- -- DamageMultiplier = .1
					-- -- setglobal("game_DamageMultiplier",DamageMultiplier)
				-- -- elseif DamageMultiplier>1 then
					-- -- DamageMultiplier = 1
					-- -- setglobal("game_DamageMultiplier",DamageMultiplier)
				-- -- end
				-- if DamageMultiplier~=1 and DamageMultiplier~=.4 then
					-- DamageMultiplier = 1
					-- setglobal("game_DamageMultiplier",DamageMultiplier)
				-- end
				-- DmgM = DamageMultiplier
			-- end


			local DmgM = 1
			local HeadDamage = 1
			-- if theTarget==_localplayer or theTarget.IsAiPlayer or theTarget.IsSpecOpsMan
			if (theTarget==_localplayer and not theTarget.IsAiPlayer)
			or (theTarget.ForbiddenCharacters and theTarget:ForbiddenCharacters()) then
				local DamageMultiplier = tonumber(getglobal("game_DamageMultiplier"))
				if DamageMultiplier then
					DmgM = DamageMultiplier
					-- if theTarget~=_localplayer then
						-- HeadDamage = .1
					-- end
				end
			end

			if DmgM<.4 and (hit.projectile or hit.melee or hit.explosion) then DmgM=.4 end

			local dmgTable = GameRules.common_damage
			if hit.explosion then
				theTarget.ReceivedDamage=1  -- Нужно как-то сделать чтобы зависело от силы взрыва.
				local expl=theTarget:IsAffectedByExplosion()
				if expl<=0 then return end
				hit.damage = expl*hit.damage*dmgTable[6]
				-- local DmgM2 = 1
				-- if DmgM then
					-- DmgM2 = DmgM
					-- -- if DmgM2<.6 then DmgM2=.6 end
				-- end
				-- hit.damage = expl*hit.damage*dmgTable[6]/DmgM2
				-- System:Log(theTarget:GetName()..": DmgM2: "..DmgM2..", hit.damage: "..hit.damage)
				hit.damage_type = "normal"
			end
			local HitOnPlayerArmor
			if hit.target_material then
				theTarget.ReceivedDamage=1
				local targetMatType = hit.target_material.type
				local dmgf = 1
				-- proceed protection gear
				if (targetMatType=="helmet") then
					if (theTarget.hasHelmet==0) then
						hit.target_material = Game:GetMaterialBySurfaceID(Game:GetMaterialIDByName("mat_head"))
						targetMatType = hit.target_material.type
					else
						BasicPlayer.HelmetHitProceed(theTarget,hit.dir,hit.damage)
						dmgf = .01
					end
				elseif (targetMatType=="armor") then
					HitOnPlayerArmor = 1
					if (theTarget.Properties.bHasArmor==0) then
						hit.target_material = Game:GetMaterialBySurfaceID(Game:GetMaterialIDByName("mat_flesh"))
						targetMatType = hit.target_material.type
					else
--						dmgf = 1
						dmgf = 0 -- Вот это и есть причина непробиваемости человеков с бронежилетом.
					end
				elseif (targetMatType=="bullseye") then
					dmgf = 0
					-- do damage decay stuff
					if (theTarget.bullseyeTime==nil) then
						theTarget.bullseyeTime = _time
					end

					-- calculate the amount of time passed
					local timeSpan = _time - theTarget.bullseyeTime
					local bullseyeDamage = 0

					if (theTarget.bullseyeDamage) then
						bullseyeDamage = theTarget.bullseyeDamage
					end

					-- subtract the damage decay
					bullseyeDamage = bullseyeDamage - GameRules.fBullseyeDamageDecay * timeSpan

					-- clamp to 0
					if (bullseyeDamage < 0) then
						bullseyeDamage = 0
					end

					-- add current damage (use flesh damage factor -> dmgTable[3])
					bullseyeDamage = bullseyeDamage + hit.damage * dmgTable[3]

					-- decide if damagelevel is high enough
					if (bullseyeDamage > GameRules.fBullseyeDamageLevel) then
						theTarget.bullseyeDamage = nil
						theTarget.bullseyeTime = nil
						AI:Signal(0,1,"HIT_THE_SPOT",theTarget.id)
					else
						theTarget.bullseyeDamage = bullseyeDamage
						theTarget.bullseyeTime = _time
					end
				else
					if (targetMatType=="head") then
						dmgf = dmgTable[1]*DmgM*HeadDamage
					elseif (targetMatType=="heart") then
						dmgf = dmgTable[2]*DmgM*HeadDamage
					elseif (targetMatType=="flesh") then
						dmgf = dmgTable[3]*DmgM*HeadDamage
					elseif (targetMatType=="arm") then
						dmgf = dmgTable[4]*DmgM
						theTarget.cnt.armhealth = theTarget.cnt.armhealth - hit.damage*dmgf*DmgM
						if (theTarget.cnt.armhealth<0) then
							theTarget.cnt.armhealth = 0
						end
						dmgf = dmgf * GameRules.Arm2BodyDamage*DmgM
						dmgPrc = theTarget.cnt:GetArmDamage()
						--System.LogToConsole("Arm HIT "..dmgPrc)
						if dmgPrc>50 then
							theTarget.cnt.dmgFireAccuracy = 100 - (dmgPrc-50)/2 -- Нужно ли и работает ли как надо?
						end
						local att_target = AI:GetAttentionTargetOf(theTarget.id)
						if att_target and type(att_target)=="table" then
							if theTarget.MERC and att_target~=theShooter and random(1,3)==1 then
								AIBehaviour.DEFAULT:AI_SETUP_DOWN(theTarget)
							end
						end
					elseif (targetMatType=="leg") then
						dmgf = dmgTable[5]*DmgM
						theTarget.cnt.leghealth = theTarget.cnt.leghealth - hit.damage*dmgf*DmgM
						if (theTarget.cnt.leghealth<0) then
							theTarget.cnt.leghealth = 0
						end
						dmgf = dmgf * GameRules.Leg2BodyDamage*DmgM
						local att_target = AI:GetAttentionTargetOf(theTarget.id)
						if att_target and type(att_target)=="table" then
							if theTarget.MERC and att_target~=theShooter and random(1,3)==1 then
								-- theTarget:InsertSubpipe(0,"setup_prone") -- Чтобы иногда просмативали территорию на уровне ног.
								AIBehaviour.DEFAULT:AI_SETUP_DOWN(theTarget)
							end
						end
					end
				end
				-- if theShooter then
					-- if not self.OldArmor then self.OldArmor = "nil" end
					-- if not self.OldHealth then self.OldHealth = "nil" end
					-- local dist = floor(theShooter:GetDistanceFromPoint(theTarget.pos))
					-- local text = "$9SHOOTER: $4"..theShooter:GetName()..", $9TARGET: $4"..theTarget:GetName()..", $8MATERIAL: "..targetMatType..", DIST: "..dist..", HEALTH: "..theTarget.cnt.health..", ARMOR:"..theTarget.cnt.armor..",\n DmgF: "..dmgf.."$8, DAMAGE: "..hit.damage.."$8, DAMAGE*DmgF: "..hit.damage*dmgf..", DmgM: "..DmgM..", OldHealth: "..self.OldHealth..", OldArmor: "..self.OldArmor
					-- Hud:AddMessage(text)
					-- System:Log(text)
				-- end
				-- System.LogToConsole("onDamage mat: "..targetMatType.." A "..theTarget.cnt.armhealth.." L "..theTarget.cnt.leghealth.." df "..dmgf.." H "..hit.damage)
				-- System:Log("--> Inflicted Damage: "..(hit.damage*dmgf).." health "..theTarget.cnt.health)

				GameRules:ApplyDamage(theTarget,hit.damage*dmgf,hit.damage_type,theShooter,HitOnPlayerArmor)
			else
				if hit.landed==1 then
					GameRules:ApplyDamage(theTarget,hit.damage,hit.damage_type,theShooter)
				else
					System:Log("OnDamage: no material assigned for body: "..theTarget:GetName())
				end
			end
		end
	end


--	if (theTarget) then
--		if (theTarget.type=="Player") then

--        	local zone = theTarget.cnt.GetBoneHitZone(hit.ipart)
--        	if zone==0 then zone = 2 end
            --System.LogToConsole("health1: "..theTarget.cnt.health.." part: "..zone)
--            local dmgf = GameRules.bodydamage[zone]
--            if theTarget.ai then
--                dmgf = GameRules.aidamage[zone]
--            end
--        	theTarget.cnt.health = theTarget.cnt.health - hit.damage*dmgf
            --System.LogToConsole("health2: "..theTarget.cnt.health)

	--		if (theTarget.cnt.health < 1) then
--				theTarget.cnt.health = 0
--				theTarget.GotoState("Dead")
--				Game.ForceScoreBoard(theTarget.id,1)
--			end
--		end
--	end
end



function GameRules:RespawnPlayer(server_slot,player)

	if (player.type=="Player") then
		--set the default stats
		player.cnt.max_health=self.InitialPlayerProperties.health
		player.cnt.health=self.InitialPlayerProperties.health
		player.cnt.armor=self.InitialPlayerProperties.armor
		player.cnt.alive=1
		player:EnablePhysics(1)

		-- [marco] make certain player elements persistent between levels
		-- here it's ok because in multiplayer we never save between levels,
		-- so this function will do nothing,and this is the final place where
		-- player stats are set before starting the game
		if (tonumber(getglobal("g_LevelStated"))==0) then
			player.cnt:LoadPlayerElements()
		end

		-- [marco] set global EAX preset
		Sound:SetEaxEnvironment(EAXPresetDB["noreflectmoistair"],SOUND_OUTDOOR)

		Game:ShowIngameDialog(-1,"","",12,"Respawning at last checkpoint",5)
	end

	--local RespawnPoint = Game.GetRandomRespawnPoint()

	--local pos = {x = RespawnPoint.x,y = RespawnPoint.y,z = RespawnPoint.z}
	--local dir = {x = RespawnPoint.xA,y = RespawnPoint.yA,z = RespawnPoint.zA}

	--player.SetPos(pos)
	--player.SetAngles(dir)
	player:SetName(server_slot:GetName())

	if (_LastCheckPPos) then
		player:SetPos(_LastCheckPPos)
		player:SetAngles(_LastCheckPAngles)
	else
		local RespawnPoint = Server:GetFirstRespawnPoint()
		-- FIXME ... this is a bit ugly,but somehow we don't have a spawn point
		if (not RespawnPoint) then
			RespawnPoint = {x=0,y=0,z=0,xA=0,yA=0,zA=0}
		end
		player:SetPos({x = RespawnPoint.x,y = RespawnPoint.y,z = RespawnPoint.z})
		player:SetAngles({x = RespawnPoint.xA,y = RespawnPoint.yA,z = RespawnPoint.zA})
	end

end

function GameRules:OnClientConnect(server_slot,requested_classid)
	--create a new player entity
--	local RespawnPoint = Server:GetRandomRespawnPoint()
	local RespawnPoint = Server:GetFirstRespawnPoint()
	-- FIXME ... this is a bit ugly,but somehow we don't have a spawn point
	if not RespawnPoint then
		RespawnPoint = {x=0,y=0,z=0,xA=0,yA=0,zA=0}
	end

	local dir = {x = RespawnPoint.xA,y = RespawnPoint.yA,z = RespawnPoint.zA}
	local newPlayer=Server:SpawnEntity(requested_classid,RespawnPoint)
	if newPlayer then newPlayer:SetAngles(dir) end

--	System:Log("FirstRespawnPoint player pos x="..RespawnPoint.x.." y="..RespawnPoint.y.." z="..RespawnPoint.z)
--	System:Log("FirstRespawnPoint player angles x="..dir.x.." y="..dir.y.." z="..dir.z)

	--delete the old player entity
	if (server_slot:GetPlayerId()~=0) then
		Server:RemoveEntity(server_slot.GetPlayerId())
	end

	--bind the new created player to the serverslot
	server_slot:SetPlayerId(newPlayer.id)

	--inform player about current game state (TODO: put in proper state & time)
	server_slot:SetGameState(0,0)

	--set the player at the respawn point and set the starting health and stuff
	GameRules:RespawnPlayer(server_slot,newPlayer)
	Game:ForceScoreBoard(newPlayer.id,nil)
	server_slot.first_request=nil
end

function GameRules:OnClientDisconnect(server_slot)
	--remove the player from the team
	--remove the entity
	if (server_slot:GetPlayerId()~=0) then
		Server:RemoveEntity(server_slot:GetPlayerId())
		server_slot:SetPlayerId(0) -- set an invalid player id
	end
end

function GameRules:OnClientRequestRespawn(server_slot,requested_classid)
	-- Авто возрожение убрал потому, что если игрок сохранится через консоль командой /save_game и погибнет, то он возродится на той же, но уже зачищенной от врагов локации с полным боекомплектом.
	--System:Log("Clicked!")
	if _localplayer.AllowAutoLoadSave then _localplayer.AllowAutoLoadSave=nil end
	if self.TimeRespawn==0 or (_time-self.TimeDied<self.TimeRespawn) then
		local intensity = (_time-self.TimeDied)*.1
		Sound:SetGroupScale(SOUNDSCALE_DEAFNESS,1-intensity) -- Постепенно оглушить.
		Hud:OnMiscDamage(1) -- 1 - Лучше видно.
		Hud:SetScreenDamageColor(intensity,0,0) -- Постепенно залить красным.
		-- System:Log("intensity="..intensity..", time=".._time)
		-- System:Log("time=".._time-self.TimeDied)
		return
	end
	Hud:OnMiscDamage(10000) -- Постоянно наносит урон и оставляет экран затемнённым.
	Hud:SetScreenDamageColor(0,0,0) -- Чёрный.

	-- be sure this is removed when the client connects or the
	-- save menu appears
	-- System:SetScreenFx("ScreenFade",0)
	--hack to slow down the respawn (should this be inside the if-then below?)
	-- if Game:ShowSaveGameMenu() then
	if UI then
		-- Sound:SetGroupScale(SOUNDSCALE_DEAFNESS,1) -- Есть в ClientStuff:OnPauseGame().
		--System:Log('Game:ToggleMenu()')
		_localplayer.AllowAutoLoadSave = 1
		if Game:ShowSaveGameMenu() then
			Game:SendMessage("Switch")
		else
			Game:SendMessage("Switch") -- Заменить на другое. Если не присутствует хоть одно сохранение, то переключить на меню с выбором уровня.
		end
		return
	-- else
--		System:Log("Game:ShowSaveGameMenu() returned nil")
	end

	do return end -- Не возрождаться.

	setglobal("hud_fadeamount",1)

	if (server_slot.first_request) then
		local player
		--for now I don't respawn the entity
		--create a new player entity
		local RespawnPoint = Server:GetRandomRespawnPoint()
		if (tonumber(gr_RespawnAtDeathPos)==1) then
			if (GameRules.player_death_pos) then
				RespawnPoint=GameRules.player_death_pos
			end
		end
		local dir = {x = RespawnPoint.xA,y = RespawnPoint.yA,z = RespawnPoint.zA}
		local newPlayer=Server:SpawnEntity(requested_classid,RespawnPoint)
		newPlayer:SetAngles(dir)

--		System:Log("player pos x="..RespawnPoint.x.." y="..RespawnPoint.y.." z="..RespawnPoint.z)
--		System:Log("player angles x="..dir.x.." y="..dir.y.." z="..dir.z)

		if (server_slot:GetPlayerId()~=0) then
			Server:RemoveEntity(server_slot:GetPlayerId())
		end

		GameRules:RespawnPlayer(server_slot,newPlayer)
		server_slot:SetPlayerId(newPlayer.id)
		Game:ForceScoreBoard(newPlayer.id,nil)
	else
		server_slot.first_request=1
	end
end

-- player requests to be killed (typed in the "kill" console command)
function GameRules:OnKill(server_slot)
    local id = server_slot:GetPlayerId()
    if id~=0 then
        local ent = System:GetEntity(id)
        self:OnDamage({target = ent,shooter = ent,damage = 1000,ipart = 0,target_material=Materials.mat_default})
    end
end

function GameRules:OnClientJoinTeamRequest(server_slot,team_name)
	if (server_slot:GetPlayerId()~=0) then
		local requested_classid=1
		local player=System:GetEntity(server_slot:GetPlayerId())
		if (team_name~=player:GetTeam()) then
			if (team_name=="spectators") then
				requested_classid=SPECTATOR_CLASS_ID
			end
			local newEntity=Server:SpawnEntity(requested_classid)
			Server:RemoveEntity(player.id)
			server_slot:SetPlayerId(newEntity.id)
			newEntity:SetTeam(team_name)
		end
	end
end

function GameRules:OnCallVote(server_slot,command,arg1)
	System:Log("vote called: "..command.." "..arg1)
	-- TODO: clone voting system from ffa rules.
end

-- return 1=if interaction is accepted,otherwise nil
function GameRules:IsInteractionPossible(actor,entity,AllowAi)
	-- prevent a player who is in a vehicle from interacting with the entity
	if (actor.theVehicle) then
		return nil
	end
	-- prevent ai from using entities that are marked for player only use
	if (entity.Properties.bPlayerOnly and entity.Properties.bPlayerOnly==1 and actor.ai and not AllowAi) then
		return nil
	end
	-- prevent all ai from picking up things
	if (actor.ai and not AllowAi) then
		return nil
	end
	-- prevent corpses from interacting with something
	if (actor.cnt and (actor.cnt.health==nil or actor.cnt.health < 1)) then
		return nil
	end
	return 1
end