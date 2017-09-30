AIBehaviour.AIPlayerIdle = {
	Name = "AIPlayerIdle",

	OnLeftLean = function(self,entity,sender)
		-- if not entity.RunToTrigger and entity.not_sees_timer_start==0 and entity.Properties.KEYFRAME_TABLE~="VALERIE" then
			-- AI:Signal(0,1,"LEFT_LEAN_ENTER",entity.id)
		-- end
		entity.LeanLeftDelay = _time+5
		-- Hud:AddMessage(entity:GetName()..": LeanLeftDelay")
		entity:ChangeAIParameter(AIPARAM_FOV,entity.Properties.horizontal_fov)
	end,

	OnRightLean = function(self,entity,sender)
		-- if not entity.RunToTrigger and entity.not_sees_timer_start==0 and entity.Properties.KEYFRAME_TABLE~="VALERIE" then
			-- AI:Signal(0,1,"RIGHT_LEAN_ENTER",entity.id)
		-- end
		entity.LeanRightDelay = _time+5
		-- Hud:AddMessage(entity:GetName()..": LeanRightDelay")
		entity:ChangeAIParameter(AIPARAM_FOV,entity.Properties.horizontal_fov)
	end,

	OnLowHideSpot = function(self,entity,sender)
		-- if not entity.RunToTrigger and entity.Properties.KEYFRAME_TABLE~="VALERIE" then
			-- AI:Signal(0,1,"DIG_IN_ATTACK",entity.id)
			if entity.sees==1 and not entity.cnt.proning and not entity.cnt.crouching then
				entity:InsertSubpipe(0,"setup_crouch")
				entity:InsertSubpipe(0,"do_it_walking")
			elseif not entity.cnt.proning then
				AIBehaviour.DEFAULT:AI_SETUP_UP(entity)
			end
		-- end
		entity:ChangeAIParameter(AIPARAM_FOV,entity.Properties.horizontal_fov)
	end,

	OnNoTarget = function(self,entity) -- Должен чаще смотреть по сторонам.
		entity:ChangeAIParameter(AIPARAM_FOV,entity.Properties.horizontal_fov)
		if entity.SaveIdSeen then
			local TagretEntity = System:GetEntity(entity.SaveIdSeen)
			if entity.SaveIdSeen~=entity.SaveIdKilled and entity:GetDistanceFromPoint(_localplayer:GetPos()) <= 30+random(0,30) then
				-- Hud:AddMessage(entity:GetName().."$1: @ItSeems "..TagretEntity.AI_NAME.."$1 @StillAlive")
				local Chat
				if BasicPlayer.IsAlive(TagretEntity) then
					Chat = "@HeIsStillAlive"
					Hud:AddMessage(entity:GetName().."$1: @HeIsStillAlive")
				else
					if random(1,2)==1 then
						Chat = "@HeIsStillAlive2"
					else
						Chat = "@HeWasAlreadyDead"
					end
					Hud:AddMessage(entity:GetName().."$1: @ItSeems "..Chat)
				end
			-- else
				-- Hud:AddMessage(entity:GetName().."$1: @HeIsDead")
			end
		-- else
			-- if entity.WasInCombat then
			-- Hud:AddMessage(entity:GetName().."$1: @NoGoals")
			-- end
		end
		-- entity.AiPlayerAllowSearchGun = nil
		-- Hud:AddMessage(entity:GetName()..": AIPlayerIdle/OnNoTarget")
		-- System:Log(entity:GetName()..": AIPlayerIdle/OnNoTarget")
		AIBehaviour.DEFAULT:OnNoTarget(entity)
		-- entity.AiPlayerAllowSearchGun = nil
		entity.ai_flanking = nil
		entity.ai_scramble = nil
		-- entity.sees=0
		if entity.TempAiAction=="Attack" then entity.TempAiAction = nil end
		if entity.TempAiAction=="Suppress" then
			entity:InsertSubpipe(0,"just_shoot")
		end
		-- entity:InsertSubpipe(0,"reload")
		if entity.cnt.proning then
			entity:InsertSubpipe(0,"setup_crouch")
			entity:InsertSubpipe(0,"do_it_walking")
		elseif entity.cnt.crouching then
			entity:InsertSubpipe(0,"setup_stand")
			entity:InsertSubpipe(0,"do_it_running")
		end
	end,

	OnSpawn = function(self,entity) -- В игре при старте не срабатывет.
		-- entity:SearchAmmunition()
		-- entity:MakeAlerted()
		entity.IsAiPlayer=1
		AI:Signal(0,1,"GO_FOLLOW",entity.id)
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		local Player=_localplayer
		local att_target = AI:GetAttentionTargetOf(entity.id)
		if att_target and type(att_target)=="table" then
			if att_target==Player or (att_target.ANIMAL and att_target.ANIMAL=="pig") then
				-- Hud:AddMessage(entity:GetName()..": AIPlayerIdle/LocalPlayerSeen")
				-- System:Log(entity:GetName()..": AIPlayerIdle/LocalPlayerSeen")
				entity:InsertSubpipe(0,"not_shoot")
				entity:TriggerEvent(AIEVENT_CLEAR) -- Чтобы не было стрельбы в игрока при использовании acqtarget.
				return
			end
		end
		entity:ChangeAIParameter(AIPARAM_FOV,10)
		entity:MakeAlerted()
		-- Hud:AddMessage(entity:GetName()..": AIPlayerIdle/OnPlayerSeen")
		-- System:Log(entity:GetName()..": AIPlayerIdle/OnPlayerSeen")
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if not fDistance then fDistance = entity:GetDistanceToTarget() end
		if not fDistance then fDistance = 0 NotContact=1 end
		if entity.TempAiAction=="Hold" or entity.TempAiAction=="Suppress" then
			entity:SelectPipe(0,"AiPlayer_hold_timeout")
			entity:InsertSubpipe(0,"just_shoot")
		end
		local SelectAttack
		if att_target and type(att_target)=="table" then
			-- if not att_target.WasInCombat or att_target.sees==0 and not att_target.RunToTrigger then
			local Result = entity:NewCountingPlayers(60,1,nil,1)
			if not att_target.WasInCombat and att_target.sees~=1 and not att_target.RunToTrigger and Result.Friends<=5 then
				if not entity.SaveIdSeen or entity.SaveIdSeen~=att_target.id and entity:GetDistanceFromPoint(_localplayer:GetPos()) <= 30+random(0,30) then
					Hud:AddMessage(entity:GetName().."$1: @Hey "..Player:GetName().."$1! @ISeeTheEnemy")
				end
				entity.AiPlayerDoNotShoot = 1
				entity:InsertSubpipe(0,"just_shoot")
				-- if entity.TempAiAction=="Follow" or entity.TempAiAction=="ForceFollow" and entity.Following then
				if entity.TempAiAction=="Follow" or entity.TempAiAction=="ForceFollow" and entity.Following then
					-- if not AI:IsMoving(entity.id) then
						-- entity:InsertSubpipe(0,"AcqTarget",att_target.id)
					-- end
					return
				end
				if entity.TempAiAction~="Hold" and entity.TempAiAction~="Suppress" then
					entity:SelectPipe(0,"AiPlayer_hide_on_seen_target")
				end
				if not entity.cnt.proning and not entity.cnt.crouching then
					entity:InsertSubpipe(0,"setup_crouch")
					entity:InsertSubpipe(0,"do_it_walking")
				elseif entity.cnt.crouching then
					entity:InsertSubpipe(0,"setup_prone")
					entity:InsertSubpipe(0,"do_it_walking")
				end
				entity.Following=nil
				return
			else
				if att_target.sees==2 and fDistance <= 60 then
					local WeaponsSlots = entity.cnt:GetWeaponsSlots()
					if WeaponsSlots then
						for i,New_Weapon in WeaponsSlots do
							if New_Weapon~=0 and New_Weapon.name=="MP5" then
								local WeaponState = entity.WeaponState
								local WeaponInfo = WeaponState[WeaponClassesEx[New_Weapon.name].id]
								local New_Ammo
								local New_AmmoInClip
								if WeaponInfo then
									local FireModeParams = New_Weapon.FireParams[WeaponInfo.FireMode+1]
									local New_AmmoType = FireModeParams.AmmoType
									New_Ammo = entity.Ammo[New_AmmoType]
									New_AmmoInClip = WeaponInfo.AmmoInClip[entity.firemodenum]
								end
								if (New_AmmoInClip and New_AmmoInClip > 0) or (New_Ammo and New_Ammo > 0) then
									-- Hud:AddMessage(entity:GetName()..": SET MP5")
									entity.SetWeaponTable = nil
									entity.cnt:SetCurrWeapon(WeaponClassesEx[New_Weapon.name].id)
								end
							end
						end
					end
				end
				if entity.AiPlayerDoNotShoot then
					SelectAttack = 1
				end
				entity.AiPlayerDoNotShoot = nil
			end
		end
		if not NotContact then
			AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY_ON_ATTACK(entity)
			-- if not entity.SayFirstContact then
			if entity.sees==0 then
				AI:Signal(0,1,"SAY_FIRST_HOSTILE_CONTACT",entity.id)
				entity.SayFirstContact=1
			else
				if (entity:GetGroupCount() > 1) then
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN_GROUP",entity.id)
				else
					AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN",entity.id)
				end
			end
		end
		AI:Signal(0,1,"FORCE_RESPONSIVENESS_CLEAR",entity.id)
		if entity.TempAiAction=="Hold" or entity.TempAiAction=="Suppress" then return end
		if entity.TempAiAction=="Stopping" then entity.TempAiAction = nil end
		if entity.Following or SelectAttack then
			if fDistance <= 30 or (att_target and type(att_target)=="table" and att_target.sees~=1) then
				entity:SelectPipe(0,"AiPlayer_scramble")
			else
				AI:Signal(0,1,"AIPLAYER_ATTACK",entity.id)
			end
			entity.Following = nil -- Внизу специально.
		end
		if entity.TempAiAction=="Attack" then
			entity.TempAiAction = nil
			AI:Signal(0,1,"AIPLAYER_ATTACK",entity.id)
			return
		end
		if fDistance > 30 and random(1,10)<=3 then -- 60
			if entity:RunToMountedWeapon() then return end
		end
		if entity:CheckEnemyWeaponDanger() then	return end

		if entity.critical_status and fDistance > 15 then
			entity:SelectPipe(0,"AiPlayer_hide_on_critical_status")
			do return end
		end
		if fDistance > 80 and entity.ai_flanking then entity.ai_flanking = nil  end
		if entity.ai_flanking or (entity.ai_scramble and fDistance <= 60) then do return end end
		if fDistance <= 30 then
			entity:SelectPipe(0,"AiPlayer_scramble2")
			entity.ai_scramble = 1
		elseif fDistance <= 60 then -- На return выше не забывай поглядывать если цифру меняешь.
			entity:SelectPipe(0,"AiPlayer_scramble")
			entity.ai_scramble = 1
			-- AIBehaviour.DEFAULT:AI_SETUP_DOWN(entity)
			if not entity.cnt.proning and not entity.cnt.crouching then
				entity:InsertSubpipe(0,"setup_crouch")
				entity:InsertSubpipe(0,"do_it_walking")
			elseif entity.cnt.crouching then
				entity:InsertSubpipe(0,"setup_prone")
				entity:InsertSubpipe(0,"do_it_walking")
			end
		elseif fDistance <= 110 then
			AI:Signal(0,1,"HIDE_LEFT_OR_RIGHT",entity.id)
		else
			AI:Signal(0,1,"COVER_STRAFE",entity.id)
			-- if random(1,10)==1 then
				-- AIBehaviour.DEFAULT:AI_SETUP_DOWN(entity)
			-- end
			if not entity.cnt.proning and not entity.cnt.crouching then
				entity:InsertSubpipe(0,"setup_crouch")
				entity:InsertSubpipe(0,"do_it_walking")
			elseif entity.cnt.crouching then
				entity:InsertSubpipe(0,"setup_prone")
				entity:InsertSubpipe(0,"do_it_walking")
			end
		end
		-- if random(1,10)==1 then
			-- entity:GrenadeAttack()
		-- end
		entity.ThrowGrenadeOnTimer = {_time+random(3,5),1}
		if not entity.cnt.proning and not entity.cnt.crouching then
			entity:InsertSubpipe(0,"setup_crouch")
		elseif entity.cnt.crouching then
			entity:InsertSubpipe(0,"setup_prone")
		end
		-- Hud:AddMessage(entity:GetName()..": AIPlayerIdle/OnPlayerSeen 2")
		-- System:Log(entity:GetName()..": AIPlayerIdle/OnPlayerSeen 2")
	end,

	OnEnemySeen = function(self,entity)
		-- called when the enemy sees a foe which is not a living player
		Hud:AddMessage(entity:GetName()..": OnEnemySeen")
		System:Log(entity:GetName()..": OnEnemySeen")
	end,

	OnFriendSeen = function(self,entity)
		-- called when the enemy sees a friendly target
		Hud:AddMessage(entity:GetName()..": OnFriendSeen")
		System:Log(entity:GetName()..": OnFriendSeen")
	end,

	OnSomethingSeen = function(self,entity)
		local att_target = AI:GetAttentionTargetOf(entity.id)
		if att_target and type(att_target)=="table" then
			if att_target==_localplayer or (att_target.ANIMAL and att_target.ANIMAL=="pig") then
				-- Hud:AddMessage(entity:GetName()..": AIPlayerIdle/LocalPlayerSeen")
				-- System:Log(entity:GetName()..": AIPlayerIdle/LocalPlayerSeen")
				entity:InsertSubpipe(0,"not_shoot")
				entity:TriggerEvent(AIEVENT_CLEAR) -- Чтобы не было стрельбы в игрока при использовании acqtarget.
				return
			end
		end
		-- Hud:AddMessage(entity:GetName()..": AIPlayerIdle/OnSomethingSeen")
		-- System:Log(entity:GetName()..": AIPlayerIdle/OnSomethingSeen")
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if entity.TempAiAction=="Follow" or entity.TempAiAction=="ForceFollow" then return end
		-- AIBehaviour.DEFAULT:AI_SETUP_DOWN(entity)
		if not entity.cnt.proning and not entity.cnt.crouching then
			entity:InsertSubpipe(0,"setup_crouch")
			entity:InsertSubpipe(0,"do_it_walking")
		elseif entity.cnt.crouching then
			entity:InsertSubpipe(0,"setup_prone")
			entity:InsertSubpipe(0,"do_it_walking")
		end
	end,

	OnDeadBodySeen = function(self,entity,sender,fDistance)
		if entity.Properties.species==sender.Properties.species and fDistance<=10 and entity.sees~=1 then
			entity:InsertSubpipe(0,"retreat_on_dead_body_seen",sender.id)
		end
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		entity:ChangeAIParameter(AIPARAM_FOV,entity.Properties.horizontal_fov)
		if entity.TempAiAction=="Stopping" or entity.TempAiAction=="ForceFollow" or entity.AiPlayerDoNotShoot then entity:TriggerEvent(AIEVENT_DROPBEACON) return end
		if entity.TempAiAction=="Hold" or entity.TempAiAction=="Suppress" then
			entity:TriggerEvent(AIEVENT_DROPBEACON)
			if entity.TempAiAction=="Hold" then
				entity:SelectPipe(0,"AiPlayer_hold")
				entity:InsertSubpipe(0,"just_shoot")
			else
				entity:SelectPipe(0,"AiPlayer_hold_timeout")
				entity:InsertSubpipe(0,"dumb_shoot")
			end
			return
		end
		-- Hud:AddMessage(entity:GetName()..": AIPlayerIdle/OnEnemyMemory")
		-- System:Log(entity:GetName()..": AIPlayerIdle/OnEnemyMemory")
		entity:TriggerEvent(AIEVENT_CLEAR)
		if not fDistance then fDistance = 0 NotContact=1 end
		entity.ai_scramble = nil
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if entity.ai_flanking or entity.AI_OnDanger then do return end end
		if entity.critical_status and fDistance > 30 then
			entity.Following = nil
			entity:SelectPipe(0,"AiPlayer_hide_on_critical_status")
			do return end
		end
		entity.Following = nil
		entity:InsertSubpipe(0,"reload")
		if not NotContact then
			AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN",entity.id)
		end
		local rnd = random(1,10)
		if fDistance <= 5 then -- Это потому что вызывается когда цели нет и дистанци равна 0.
			if rnd <= 3 then
				entity:SelectPipe(0,"confirm_targetloss")
				AI:CreateGoalPipe("quickhide")
				AI:PushGoal("quickhide","hide",1,5,HM_FARTHEST,0)
				AI:PushGoal("quickhide","timeout",1,.5)
				if not entity.cnt.proning and not entity.cnt.crouching then
					entity:InsertSubpipe(0,"do_it_running")
				else
					entity:InsertSubpipe(0,"do_it_walking")
				end
				entity:InsertSubpipe(0,"quickhide")
			else
				AI:Signal(0,1,"HIDE_TACTIC",entity.id)
				if random(1,2)==1 then -- Случайности временны. Спасение от заедания.
					entity:GrenadeAttack(3)
				end
				-- Hud:AddMessage(entity:GetName()..": entity:GrenadeAttack(3) 1")
				-- System:Log(entity:GetName()..": entity:GrenadeAttack(3) 1")
			end
		else
			-- rnd так и оставить, чтобы атакующие пайпы иногда продолжали работу.
			if rnd==1 and fDistance < 60 then -- Прятаться.
				entity:SelectPipe(0,"AiPlayer_camp")
				if random(1,2)==1 then -- Случайности временны. Спасение от заедания.
					entity:GrenadeAttack(6)
				end
			elseif rnd==2 then
				AI:Signal(0,1,"HIDE_TACTIC",entity.id)
				if random(1,2)==1 then
					entity:GrenadeAttack(3)
				end
			elseif rnd==3 then
				-- entity:SelectPipe(0,"confirm_targetloss")
				-- entity:InsertSubpipe(0,"do_it_walking")
				entity:SelectPipe(0,"AiPlayer_hide_farthest")
				if random(1,2)==1 then -- Случайности временны. Спасение от заедания.
					entity:GrenadeAttack(5)
				end
			elseif rnd==5 then
				entity:SelectPipe(0,"AiPlayer_hide_farthest")
				if random(1,2)==1 then
					entity:GrenadeAttack(3)
				end
			-- elseif rnd==6 then
				-- AI:Signal(0,1,"HIDE_LEFT_OR_RIGHT",entity.id)
				-- entity:GrenadeAttack(3)
			end
		end
		-- if random(1,2)==1 then
			-- if entity.cnt.proning then
				-- entity:InsertSubpipe(0,"setup_crouch")
			-- elseif entity.cnt.crouching then
				-- entity:InsertSubpipe(0,"setup_stand")
			-- else
				-- entity:InsertSubpipe(0,"setup_crouch")
			-- end
		-- else
			if not entity.cnt.proning and not entity.cnt.crouching then
				entity:InsertSubpipe(0,"setup_crouch")
			elseif entity.cnt.crouching then
				entity:InsertSubpipe(0,"setup_prone")
			end
		-- end
	end,

	OnInterestingSoundHeard = function(self,entity,fDistance)
		entity:ChangeAIParameter(AIPARAM_FOV,entity.Properties.horizontal_fov)
		if entity.TempAiAction=="Follow" or entity.TempAiAction=="ForceFollow" or entity.TempAiAction=="Hold" or entity.TempAiAction=="Suppress" then
			entity:TriggerEvent(AIEVENT_DROPBEACON)
			if not AI:IsMoving(entity.id) then
				entity:InsertSubpipe(0,"AcqBeacon")
			end
			return
		end
		if entity.sees==0 and entity.not_sees_timer_start~=0 then
			if entity:GetDistanceFromPoint(_localplayer:GetPos()) <= 30+random(0,30) then
				local Chat
				local rnd = random(1,8)
				if rnd==1 then
					Chat = "@IHeardSomething"
				elseif rnd==2 then
					Chat = "@HearThat"
				elseif rnd==3 then
					Chat = "@Hush"
				elseif rnd==4 then
					Chat = "@StopQuiet"
				elseif rnd==5 then
					Chat = "@Freeze"
				elseif rnd==6 then
					Chat = "@Quiet"
				elseif rnd==7 then
					Chat = "@Stop"
				elseif rnd==8 then
					Chat = "@Shhh"
				end
				Hud:AddMessage(entity:GetName().."$1: "..Chat)
			end
		end
		if entity.TempAiAction=="Stopping" then -- для вэйта разделить или пайпу проверить, последний сигнал
			entity:TriggerEvent(AIEVENT_DROPBEACON)
			if not entity.cnt.proning and not entity.cnt.crouching then
				entity:InsertSubpipe(0,"setup_crouch")
				entity:InsertSubpipe(0,"do_it_walking")
			elseif entity.cnt.crouching then
				entity:InsertSubpipe(0,"setup_prone")
				entity:InsertSubpipe(0,"do_it_walking")
			end
			entity:InsertSubpipe(0,"AcqBeacon")
			return
		end
		-- entity:MakeAlerted()
		-- Hud:AddMessage(entity:GetName()..": AIPlayerIdle/OnInterestingSoundHeard")
		-- System:Log(entity:GetName()..": AIPlayerIdle/OnInterestingSoundHeard")
		entity.ai_flanking = nil
		entity.ai_scramble = nil
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if entity.AI_OnDanger then do return end end
		if entity.critical_status and fDistance > 30 then
			entity.Following = nil
			entity:SelectPipe(0,"AiPlayer_hide_on_critical_status")
			do return end
		end
		entity.Following = nil
		entity:InsertSubpipe(0,"reload")
		-- if entity:RunToAlarm() then do return end end
		-- if entity~=_localplayer then
			if entity.sees~=1 then
				local rnd = random(1,2)
				if rnd==1 then
					AI:Signal(0,1,"SCOUTING_SOUND",entity.id)
				else
					AI:CreateGoalPipe("AiPlayer_wait_on_intersting")
					AI:PushGoal("AiPlayer_wait_on_intersting","locate",0,"beacon")
					AI:PushGoal("AiPlayer_wait_on_intersting","acqtarget",0,"")
					AI:PushGoal("AiPlayer_wait_on_intersting","timeout",1,1,60)
					AI:PushGoal("AiPlayer_wait_on_intersting","signal",0,1,"SCOUTING_SOUND",0) -- Почти никогда не доходит до этого.
					entity:SelectPipe(0,"AiPlayer_wait_on_intersting")
				end
			end
			-- AI:PushGoal("AiPlayer_wait_on_intersting","signal",0,1,"SELECT_IDLE",0)
			-- AIBehaviour.DEFAULT:AI_SETUP_DOWN(entity)
			if not entity.cnt.proning and not entity.cnt.crouching then
				entity:InsertSubpipe(0,"setup_crouch")
				-- entity:InsertSubpipe(0,"do_it_walking")
			elseif entity.cnt.crouching then
				entity:InsertSubpipe(0,"setup_prone")
				-- entity:InsertSubpipe(0,"do_it_walking")
			end
			entity:InsertSubpipe(0,"do_it_walking")
			entity:InsertSubpipe(0,"just_shoot")
		-- else
		-- end
		-- if entity.sees~=1 then
			-- self:OnEnemyMemory(entity,fDistance,1)
		-- end
	end,

	OnThreateningSoundHeard = function(self,entity,fDistance)
		entity:MakeAlerted()
		if entity.TempAiAction=="Follow" or entity.TempAiAction=="ForceFollow" or entity.TempAiAction=="Hold" or entity.TempAiAction=="Suppress" then
			entity:TriggerEvent(AIEVENT_DROPBEACON)
			if not AI:IsMoving(entity.id) then
				entity:InsertSubpipe(0,"AcqBeacon")
			end
			return
		end
		if entity.sees==0 and entity.not_sees_timer_start==0 then
			if entity:GetDistanceFromPoint(_localplayer:GetPos()) <= 30+random(0,30) then
				local Chat
				local rnd = random(1,4)
				if rnd==1 then
					Chat = "@TheSoundOfWeapons"
				elseif rnd==2 then
					Chat = "@Stop"
				elseif rnd==3 then
					Chat = "@SomewhereShoot"
				elseif rnd==4 then
					Chat = "@DoYouHear"
				end
				Hud:AddMessage(entity:GetName().."$1: "..Chat)
			end
		end
		if entity.TempAiAction=="Stopping" then
			entity:TriggerEvent(AIEVENT_DROPBEACON)
			if not entity.cnt.proning and not entity.cnt.crouching then
				entity:InsertSubpipe(0,"setup_crouch")
			end
			entity:InsertSubpipe(0,"AcqBeacon")
			return
		end
		-- Hud:AddMessage(entity:GetName()..": AIPlayerIdle/OnThreateningSoundHeard")
		-- System:Log(entity:GetName()..": AIPlayerIdle/OnThreateningSoundHeard")
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		if fDistance > 80 or fDistance < 30 then
			entity.ai_flanking = nil
		end
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"NORMAL_THREAT_SOUND",entity.id)
		-- if entity.sees~=1 then
			-- if entity:SearchAmmunition() then do return end end
			-- if entity:RunToMountedWeapon() then do return end end -- Доделать под Аи Игрока
		-- end
		if entity.sees~=1 then
			entity.Following = nil
			-- if entity~=_localplayer then
				AI:CreateGoalPipe("AiPlayer_scouting_threaten_sound")
				-- if fDistance<=30 then
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","just_shoot")
					-- -- if fDistance<=15 then -- Доработать позу.
						-- -- if random(1,2)==1 and not entity.cnt.proning and not entity.cnt.crouching then
							-- -- AI:PushGoal("AiPlayer_scouting_threaten_sound","setup_crouch")
						-- -- end
						-- -- AI:PushGoal("AiPlayer_scouting_threaten_sound","do_it_walking")
					-- -- else
						-- -- AI:PushGoal("AiPlayer_scouting_threaten_sound","setup_stand")
						-- -- AI:PushGoal("AiPlayer_scouting_threaten_sound","do_it_running")
					-- -- end
					-- if fDistance<=15 then -- Доработать позу.
						-- if random(1,2)==1 and not entity.cnt.proning and not entity.cnt.crouching then
							-- AI:PushGoal("AiPlayer_scouting_threaten_sound","setup_crouch")
						-- end
					-- else
						-- AI:PushGoal("AiPlayer_scouting_threaten_sound","setup_stand")
					-- end
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","do_it_walking")
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","locate",0,"beacon")
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","acqtarget",0,"")
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","approach",0,.5)
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","trace",1,1,1)
					-- if not entity.cnt.proning and not entity.cnt.crouching then
						-- AI:PushGoal("AiPlayer_scouting_threaten_sound","not_shoot")
					-- end
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","hide",0,30,HM_NEAREST_TO_TARGET,1)
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","just_shoot")
					-- if not entity.cnt.proning and not entity.cnt.crouching then
						-- AI:PushGoal("AiPlayer_scouting_threaten_sound","setup_crouch")
					-- elseif entity.cnt.crouching then
						-- AI:PushGoal("AiPlayer_scouting_threaten_sound","setup_prone")
					-- end
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","timeout",1,0,5)
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","just_shoot")
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","locate",0,"hidepoint")
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","acqtarget",1,"")
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","timeout",1,0,2)
					-- if not entity.cnt.proning and not entity.cnt.crouching then
						-- AI:PushGoal("AiPlayer_scouting_threaten_sound","not_shoot")
					-- end
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","setup_crouch")
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","hide",1,60,HM_RANDOM,1)
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","just_shoot")
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","locate",0,"hidepoint")
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","acqtarget",1,"")
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","timeout",1,0,2.5)
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","locate",0,"beacon")
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","acqtarget",0,"")
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","approach",0,.6)
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","trace",1,1,1)
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","locate",0,"hidepoint")
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","acqtarget",1,"")
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","timeout",1,0,3)
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","locate",0,"beacon")
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","acqtarget",0,"")
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","timeout",1,0,3)
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","pathfind",1,"")
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","trace",1,1,1)
					-- if not entity.cnt.proning and not entity.cnt.crouching then
						-- AI:PushGoal("AiPlayer_scouting_threaten_sound","not_shoot")
					-- end
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","hide",1,60,HM_NEAREST_TO_TARGET,1)
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","signal",1,1,"AIPLAYER_ATTACK",0)
					-- entity:SelectPipe(0,"AiPlayer_scouting_threaten_sound")
				-- elseif fDistance <= 60 then
				-- if fDistance <= 60 then -- Убрал с else для проверки.
					AI:PushGoal("AiPlayer_scouting_threaten_sound","not_shoot")
					-- if not entity.cnt.proning and not entity.cnt.crouching then
						-- AI:PushGoal("AiPlayer_scouting_threaten_sound","setup_crouch")
					-- end
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","setup_prone")
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","signal",0,1,"AI_SETUP_DOWN",0)
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","setup_stand")
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","do_it_running")
					AI:PushGoal("AiPlayer_scouting_threaten_sound","locate",0,"beacon")
					AI:PushGoal("AiPlayer_scouting_threaten_sound","acqtarget",0,"")
					AI:PushGoal("AiPlayer_scouting_threaten_sound","timeout",1,.5)
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","setup_crouch")
					AI:PushGoal("AiPlayer_scouting_threaten_sound","setup_crouch")
					AI:PushGoal("AiPlayer_scouting_threaten_sound","do_it_walking")
					AI:PushGoal("AiPlayer_scouting_threaten_sound","approach",0,.9)
					AI:PushGoal("AiPlayer_scouting_threaten_sound","trace",1,0,0)
					AI:PushGoal("AiPlayer_scouting_threaten_sound","setup_crouch")
					AI:PushGoal("AiPlayer_scouting_threaten_sound","hide",1,30,HM_NEAREST,0) -- 0
					AI:PushGoal("AiPlayer_scouting_threaten_sound","just_shoot")
					-- if not entity.cnt.proning and not entity.cnt.crouching then
						-- AI:PushGoal("AiPlayer_scouting_threaten_sound","setup_crouch")
						AI:PushGoal("AiPlayer_scouting_threaten_sound","timeout",1,1,2)
					-- elseif entity.cnt.crouching then
						AI:PushGoal("AiPlayer_scouting_threaten_sound","setup_prone")
					-- end
					-- AI:PushGoal("AiPlayer_scouting_threaten_sound","signal",0,1,"AI_SETUP_DOWN",0)
					AI:PushGoal("AiPlayer_scouting_threaten_sound","timeout",1,1,5)
					AI:PushGoal("AiPlayer_scouting_threaten_sound","signal",1,1,"AIPLAYER_ATTACK",0)
					entity:SelectPipe(0,"AiPlayer_scouting_threaten_sound")
				-- else
					-- self:OnPlayerSeen(entity,fDistance,1)
				-- end
			-- else
				-- if fDistance > 60 then
					-- AI:Signal(0,1,"COVER_STRAFE",entity.id)
				-- else
					-- self:OnPlayerSeen(entity,fDistance,1)
				-- end
			-- end
			if random(1,2)==1 then
				AI:CreateGoalPipe("look_around")
				AI:PushGoal("look_around","signal",0,1,"FORCE_RESPONSIVENESS_3",0)
				AI:PushGoal("look_around","lookat",0,-380,380)
				AI:PushGoal("look_around","timeout",1,0,2)
				AI:PushGoal("look_around","signal",0,1,"FORCE_RESPONSIVENESS_CLEAR",0)
				AI:PushGoal("look_around","acqtarget",1,"")
				entity:InsertSubpipe(0,"look_around")
			end
		end
	end,

	OnClipNearlyEmpty = function(self,entity,sender)
		if entity.TempAiAction=="Follow" or entity.TempAiAction=="ForceFollow" then return end
		-- AIBehaviour.DEFAULT:AI_SETUP_DOWN(entity)
		if not entity.cnt.proning and not entity.cnt.crouching then
			entity:InsertSubpipe(0,"setup_crouch")
			entity:InsertSubpipe(0,"do_it_walking")
		elseif entity.cnt.crouching then
			entity:InsertSubpipe(0,"setup_prone")
			entity:InsertSubpipe(0,"do_it_walking")
		end
	end,

	OnReload = function(self,entity)
		entity:ChangeAIParameter(AIPARAM_FOV,entity.Properties.horizontal_fov)
		if entity.TempAiAction=="Stopping" or ((entity.TempAiAction=="Follow" or entity.TempAiAction=="ForceFollow") and AI:IsMoving(entity.id)) then return end
		entity.Following = nil
		if random(1,5)==1 and entity.sees~=1 then
			entity:GrenadeAttack(3)
		end
		if not entity.cnt.proning and not entity.cnt.crouching then
			entity:InsertSubpipe(0,"setup_crouch")
			entity:InsertSubpipe(0,"do_it_walking")
		elseif entity.cnt.crouching then
			entity:InsertSubpipe(0,"setup_prone")
			entity:InsertSubpipe(0,"do_it_walking")
		end
	end,

	OnNoHidingPlace = function(self,entity,sender)
		if entity.sees==1 then
			-- AIBehaviour.DEFAULT:AI_SETUP_DOWN(entity)
			if not entity.cnt.proning and not entity.cnt.crouching then
				entity:InsertSubpipe(0,"setup_crouch")
				entity:InsertSubpipe(0,"do_it_walking")
			elseif entity.cnt.crouching then
				entity:InsertSubpipe(0,"setup_prone")
				entity:InsertSubpipe(0,"do_it_walking")
			end
		end
	end,

	OnNoFormationPoint = function(self,entity,sender)
	end,

	OnCoverRequested = function(self,entity,sender)
	end,

	OnKnownDamage = function(self,entity,sender) -- Срабатывает когда ИИ видит или помнит того кто стрелял.
		entity:ChangeAIParameter(AIPARAM_FOV,entity.Properties.horizontal_fov)
		if entity.TempAiAction=="Stopping" or entity.TempAiAction=="Hold" or entity.TempAiAction=="Suppress" then entity.TempAiAction = nil end
		entity.Following = nil
		entity:MakeAlerted()
		-- Hud:AddMessage(entity:GetName()..": AIPlayerIdle/OnKnownDamage")
		-- System:Log(entity:GetName()..": AIPlayerIdle/OnKnownDamage")
		-- local mytarget = AI:GetAttentionTargetOf(entity.id)
		-- if mytarget then
			-- if type(mytarget)=="table" and mytarget~=sender then
				entity:SelectPipe(0,"AiPlayer_scramble")
				entity:InsertSubpipe(0,"DropBeaconTarget",sender.id)
			-- end
		-- end
		-- entity:InsertSubpipe(0,"pause_shooting")
		-- AIBehaviour.DEFAULT:AI_SETUP_DOWN(entity)
		if not entity.cnt.proning and not entity.cnt.crouching then
			entity:InsertSubpipe(0,"setup_crouch")
			entity:InsertSubpipe(0,"do_it_walking")
		elseif entity.cnt.crouching then
			entity:InsertSubpipe(0,"setup_prone")
			entity:InsertSubpipe(0,"do_it_walking")
		end
	end,

	OnReceivingDamage = function(self,entity,sender)
		entity:ChangeAIParameter(AIPARAM_FOV,entity.Properties.horizontal_fov)
		entity.Following = nil
		if entity.TempAiAction=="ForceFollow" then entity.TempAiAction="Follow" entity.ReturnForceFollow = 1 end
		if entity.TempAiAction=="Stopping" or entity.TempAiAction=="Hold" or entity.TempAiAction=="Suppress" then entity.TempAiAction = nil end
		entity:MakeAlerted()
		-- Hud:AddMessage(entity:GetName()..": AIPlayerIdle/OnReceivingDamage")
		-- System:Log(entity:GetName()..": AIPlayerIdle/OnReceivingDamage")
		-- entity:TriggerEvent(AIEVENT_CLEAR)
		entity:SelectPipe(0,"AiPlayer_scramble")
		-- entity:InsertSubpipe(0,"pause_shooting")
		-- AIBehaviour.DEFAULT:AI_SETUP_DOWN(entity)
		if not entity.cnt.proning and not entity.cnt.crouching then
			entity:InsertSubpipe(0,"setup_crouch")
			entity:InsertSubpipe(0,"do_it_walking")
		elseif entity.cnt.crouching then
			entity:InsertSubpipe(0,"setup_prone")
			entity:InsertSubpipe(0,"do_it_walking")
		end
	end,

	OnBulletRain = function(self,entity,sender) -- Почему-то прячется ближе к цели, смотрит куда бежит и опускает оружие. Где-то есть insert subpipe. -- Почему-то говорит фразочки как если бы по нему попали.
		entity:ChangeAIParameter(AIPARAM_FOV,entity.Properties.horizontal_fov)
		entity.Following = nil
		if entity.TempAiAction=="ForceFollow" then entity.TempAiAction="Follow" entity.ReturnForceFollow = 1 end
		if entity.TempAiAction=="Stopping" then entity.TempAiAction = nil end
		entity:MakeAlerted()
		-- entity:TriggerEvent(AIEVENT_CLEAR)
		-- Hud:AddMessage(entity:GetName()..": AIPlayerIdle/OnBulletRain")
		-- System:Log(entity:GetName()..": AIPlayerIdle/OnBulletRain")
		entity:TriggerEvent(AIEVENT_DROPBEACON)
		-- AIBehaviour.DEFAULT:AI_SETUP_DOWN(entity)
		if not entity.cnt.proning and not entity.cnt.crouching then
			entity:InsertSubpipe(0,"setup_crouch")
			entity:InsertSubpipe(0,"do_it_walking")
		elseif entity.cnt.crouching then
			entity:InsertSubpipe(0,"setup_prone")
			entity:InsertSubpipe(0,"do_it_walking")
		end
		local rnd=random(1,10)
		if rnd==1 and entity.sees~=1 then
			entity:GrenadeAttack(3)
		end
		if entity.TempAiAction=="Hold" or entity.TempAiAction=="Suppress" then return end
		-- local fDistance = entity:GetDistanceToTarget()
		entity:SelectPipe(0,"AiPlayer_incoming_fire") -- Прячется, выжидает, а потом атакует.
		-- entity:InsertSubpipe("DropBeaconAt",sender.id) -- Проверка.
		-- if not entity.cnt.proning and not entity.cnt.crouching then
			-- entity:InsertSubpipe(0,"setup_crouch")
			-- entity:InsertSubpipe(0,"do_it_walking")
		-- elseif entity.cnt.crouching then
			-- entity:InsertSubpipe(0,"setup_prone")
			-- entity:InsertSubpipe(0,"do_it_walking")
		-- end
		entity.AiPlayerIncomingFireStart = _time
	end,

	OnSomethingDiedNearest = function(self,entity,sender) -- Должен забывать про труп.
		entity:MakeAlerted()
		if entity.TempAiAction=="Stopping" or ((entity.TempAiAction=="Follow" or entity.TempAiAction=="ForceFollow" or entity.TempAiAction=="Hold" or entity.TempAiAction=="Suppress")
		and not AI:IsMoving(entity.id)) then
			entity:InsertSubpipe(0,"LookAtTheBodyInAction",sender.id)
			if not entity.cnt.proning and not entity.cnt.crouching then
				entity:InsertSubpipe(0,"setup_crouch")
			end
			return
		end
		-- Hud:AddMessage(entity:GetName()..": AIPlayerIdle/OnSomethingDiedNearest")
		-- System:Log(entity:GetName()..": AIPlayerIdle/OnSomethingDiedNearest")
		-- if entity.Properties.species==sender.Properties.species then
			-- entity:TriggerEvent(AIEVENT_DROPBEACON)
			-- local att_target = AI:GetAttentionTargetOf(entity.id)
			-- if not entity:RunToAlarm() then
			if entity.sees~=1 and entity.sees~=2 then
				entity:InsertSubpipe(0,"LookAtTheBodyInAction",sender.id)
				if not entity.cnt.proning and not entity.cnt.crouching then
					entity:InsertSubpipe(0,"setup_crouch")
				end
			end
				-- if att_target and type(att_target)=="table" then -- Снова посмотреть на последнюю цель.
					-- entity:InsertSubpipe("DropBeaconTarget",att_target)
				-- end
			-- end
		-- end
	end,

	OnSomethingDiedNearest_x = function(self,entity,sender)
	end,

	OnCloseContact = function(self,entity,sender)
		entity:ChangeAIParameter(AIPARAM_FOV,entity.Properties.horizontal_fov)
		-- local info = "0"
		local Player = _localplayer
		if entity.Properties.species~=sender.Properties.species then
			if entity.TempAiAction~="Follow" and entity.TempAiAction~="ForceFollow" then entity.TempAiAction = nil end
			-- AI:Signal(SIGNALID_READIBILITY,AIREADIBILITY_SEEN,"THREATEN",entity.id)
			AI:CreateGoalPipe("AiPlayer_retreat_on_close")
			AI:PushGoal("AiPlayer_retreat_on_close","just_shoot")
			AI:PushGoal("AiPlayer_retreat_on_close","setup_stand")
			AI:PushGoal("AiPlayer_retreat_on_close","do_it_running")
			AI:PushGoal("AiPlayer_retreat_on_close","locate",0,"atttarget")
			AI:PushGoal("AiPlayer_retreat_on_close","acqtarget",0,"")
			AI:PushGoal("AiPlayer_retreat_on_close","backoff",0,10)
			AI:PushGoal("AiPlayer_retreat_on_close","timeout",1,1,3)
			AI:PushGoal("AiPlayer_retreat_on_close","just_shoot")
			AI:PushGoal("AiPlayer_retreat_on_close","hide",1,15,HM_NEAREST)
			entity:InsertSubpipe(0,"AiPlayer_retreat_on_close",sender.id)
			-- info = "reteat"
		elseif not entity.RunToTrigger and entity.TempAiAction~="Stopping" and entity.TempAiAction~="Search" then
			-- -- entity:InsertSubpipe(0,"devalue_target",sender.id) -- Нельзя союзнику такое делать. Пристрелит.
			entity.AiCloseContactStart=_time+.3 -- .2 - уже не глючит, .3 - на всякий случай.
			if (entity.sees==0 and (entity.Following or (entity.TempAiAction=="Back" and sender==Player))) or Player.InElevatorArea then
				if entity.TempAiAction=="Back" then entity.TempAiAction = nil end
				AI:Signal(0,1,"GO_FOLLOW",entity.id) -- Не всегда в тему.
				-- info = "GO_FOLLOW"
			elseif entity.sees==0 then
				if sender.cnt.proning then
					entity:InsertSubpipe(0,"setup_prone")
					entity:InsertSubpipe(0,"do_it_walking")
				elseif sender.cnt.crouching then
					entity:InsertSubpipe(0,"setup_crouch")
					entity:InsertSubpipe(0,"do_it_walking")
				else
					entity:InsertSubpipe(0,"setup_stand")
					if sender.cnt.moving or sender.cnt.running then
						entity:InsertSubpipe(0,"do_it_running")
					else
						entity:InsertSubpipe(0,"do_it_walking")
					end
				end
			elseif entity.sees~=0 then
				if sender.cnt.proning and not entity.cnt.proning then
					entity:InsertSubpipe(0,"setup_prone")
					entity:InsertSubpipe(0,"do_it_walking")
				elseif sender.cnt.crouching and not entity.cnt.proning and not entity.cnt.crouching then
					entity:InsertSubpipe(0,"setup_crouch")
					entity:InsertSubpipe(0,"do_it_walking")
				end
			end
			if entity.sees==0 and entity.not_sees_timer_start==0 then -- Когда всё стихло и подбежал к игроку, тогда и бежать за оружием.
				-- entity.AiPlayerAllowSearchGun = 1 -- Проверка!
			end
		end
		-- Hud:AddMessage(entity:GetName()..": AIPlayerIdle/OnCloseContact: "..info)
		-- System:Log(entity:GetName()..": AIPlayerIdle/OnCloseContact: "..info)
	end,
	--------------------------------------------------
	-- CUSTOM SIGNALS
	--------------------------------------------------
	GO_FOLLOW = function(self,entity,sender)
		entity:ChangeAIParameter(AIPARAM_FOV,entity.Properties.horizontal_fov)
		local Player = _localplayer
		if not Player then return end
		-- Hud:AddMessage(entity:GetName()..": GO_FOLLOW!!!")
		-- System:Log(entity:GetName()..": GO_FOLLOW!!!")
		if entity.TempAiAction=="Stopping" or entity.TempAiAction=="Search" or entity.TempAiAction=="Hold" or entity.TempAiAction=="Suppress" then return end
		if entity.RunToTrigger then return end
		-- Hud:AddMessage(entity:GetName()..": GO_FOLLOW!!!")
		-- System:Log(entity:GetName()..": GO_FOLLOW!!!")
		if entity.id~=Player.id then -- ИИ.
			-- Hud:AddMessage(entity:GetName()..": GO_FOLLOW/AiPlayer/AI")
			-- System:Log(entity:GetName()..": GO_FOLLOW/AiPlayer/AI")
			local fDistance = entity:GetDistanceFromPoint(Player:GetPos())
			-- Hud:AddMessage(entity:GetName()..": fDistance: "..fDistance)
			-- System:Log(entity:GetName()..": fDistance: "..fDistance)
			local MaxDistance
			-- if not entity.WasInCombat then
				-- if entity.IsIndoor then
					MaxDistance=2
				-- else
					-- MaxDistance=5
				-- end
			-- else
				-- if entity.IsIndoor then
					-- MaxDistance=10
				-- else
					-- MaxDistance=30
				-- end
			-- end
			if entity.TempAiAction=="Follow" or entity.TempAiAction=="ForceFollow" then
				if fDistance<=MaxDistance then
					entity.Following=nil
					if not AI:IsMoving(entity.id) then
						AI:CreateGoalPipe("AiPlayer_look")
						AI:PushGoal("AiPlayer_look","timeout",1,1)
						AI:PushGoal("AiPlayer_look","lookat",1,-90,90)
						AI:PushGoal("AiPlayer_look","timeout",1,1)
						-- AI:PushGoal("AiPlayer_look","locate",0,"beacon")
						-- AI:PushGoal("AiPlayer_look","acqtarget",1,"")
						-- AI:PushGoal("AiPlayer_look","timeout",1,0,9)
						entity:SelectPipe(0,"AiPlayer_look")
						-- entity:InsertSubpipe(0,"AcqTarget",Player.id)
					else
						entity:SelectPipe(0,"AiPlayer_look_on_local_player")
						-- entity:InsertSubpipe(0,"AcqTarget",Player.id)
					end
				else
					entity.Following=1
					entity:SelectPipe(0,"AiPlayer_follow")
					-- entity:InsertSubpipe(0,"AcqTarget",Player.id)
					entity:InsertSubpipe(0,"DropBeaconTarget",Player.id)
					-- Hud:AddMessage(entity:GetName()..": $1"..entity.AiAction.."...")
					-- System:Log(entity:GetName()..": $1"..entity.AiAction.."...")
				end
				return
			end
			if entity.sees==1 then
				entity.Following=nil
				entity:SelectPipe(0,"AiPlayer_scramble") -- Лучше так, всё равно потом в атаку пойдёт.
				-- Hud:AddMessage(entity:GetName()..": GO_FOLLOW/AiPlayer_scramble")
				-- System:Log(entity:GetName()..": GO_FOLLOW/AiPlayer_scramble")
				-- entity:TriggerEvent(AIEVENT_CLEAR)
				-- entity.sees = 0 -- Чтобы не застревал.
				-- self:OnPlayerSeen(entity,fDistance,1)
			else
				-- if entity.sees==2 and not Player.InElevatorArea then
				if entity.sees==2 and (not Player.InElevatorArea or not entity.allow_idle) then
					entity.Following=nil
					entity:SelectPipe(0,"AiPlayer_scramble")
					self:OnEnemyMemory(entity,0,1)
					-- entity:TriggerEvent(AIEVENT_CLEAR)
					-- entity.sees = 0
					-- entity.sees = 1 -- Проверка.
					-- Hud:AddMessage(entity:GetName()..": AIPlayerIdle/OnEnemyMemory 2")
					-- System:Log(entity:GetName()..": AIPlayerIdle/OnEnemyMemory 2")
					if not entity.allow_idle then
						-- Hud:AddMessage(entity:GetName()..": AIPlayerIdle/not entity.allow_idle")
						System:Log(entity:GetName()..": AIPlayerIdle/not entity.allow_idle")
					end
				else
					if Player.InElevatorArea and entity.InElevatorArea and fDistance<=3 then
						entity:TriggerEvent(AIEVENT_CLEAR)
						-- entity:SelectPipe(0,"AiPlayer_look_on_local_player",Player.id)
						entity.Following=nil
						entity:SelectPipe(0,"AiPlayer_look_on_local_player")
						-- entity:InsertSubpipe(0,"DropBeaconTarget",Player.id)
						-- -- Hud:AddMessage(entity:GetName()..": GO_FOLLOW/ELEVATOR/FIND_A_TARGET")
						-- -- System:Log(entity:GetName()..": GO_FOLLOW/ELEVATOR/FIND_A_TARGET")
					elseif fDistance<=MaxDistance and not Player.InElevatorArea and not entity.InElevatorArea then
						entity.Following=nil
						if entity.FirstFollow or not entity:SearchAmmunition(1,1) then
							entity.FirstFollow = nil
							AI:Signal(0,1,"FIND_A_TARGET",entity.id)
							-- if fDistance<=2 and not entity.SetTheAngleAsAPlayer then -- Можно формировать тэг точу и по ней разворачивать.
								-- -- entity:SetAngles(Player:GetAngles()) -- Слишком быстро, это ничего не даёт.
								-- entity.SetTheAngleAsAPlayer = 1
							-- end
						end
						-- Hud:AddMessage(entity:GetName()..": GO_FOLLOW/FIND_A_TARGET")
						-- System:Log(entity:GetName()..": GO_FOLLOW/FIND_A_TARGET")
					else
						if entity.sees==0 and entity.not_sees_timer_start==0 and entity.AllowSayNoTarget
						and entity:GetDistanceFromPoint(_localplayer:GetPos()) <= 30+random(0,30) then
							entity.AllowSayNoTarget = nil
							local Chat
							local rnd = random(1,4)
							if rnd==1 then
								Chat = "@NoGoals"
							elseif rnd==2 then
								Chat = "@NoGoals2"
							elseif rnd==3 then
								Chat = "@WithoutGoals"
							elseif rnd==4 then
								Chat = "@OkayNoneOfTheTargets"
							end
							Hud:AddMessage(entity:GetName().."$1: "..Chat)
						end
						-- entity.SetTheAngleAsAPlayer = nil
						-- Hud:AddMessage(entity:GetName()..": GO_FOLLOW/AiPlayer_follow")
						-- System:Log(entity:GetName()..": GO_FOLLOW/AiPlayer_follow")
						entity.Following=1 -- В C++ тоже.
						-- if not entity.AiPlayerInsertFollow then
							entity:SelectPipe(0,"AiPlayer_follow") -- А может по id направить?
						-- else
							-- entity:InsertSubpipe(0,"AiPlayer_follow")
						-- end
						-- entity.AiPlayerInsertFollow=nil
						if entity.cnt.proning then
							entity:InsertSubpipe(0,"setup_crouch")
						elseif entity.cnt.crouching then
							entity:InsertSubpipe(0,"setup_stand")
						end
					end
				end
			end
		else -- Игрок.
			-- Hud:AddMessage(entity:GetName()..": GO_FOLLOW/AiPlayer/PLAYER")
			-- System:Log(entity:GetName()..": GO_FOLLOW/AiPlayer/PLAYER")
			if entity.sees==1 then
				entity.Following=nil
				entity:SelectPipe(0,"AiPlayer_scramble")
				-- entity.sees = 0
				entity:TriggerEvent(AIEVENT_CLEAR) -- Проверка.
				Hud:AddMessage(entity:GetName()..": GO_FOLLOW/PLAYER/sees 1")
				System:Log(entity:GetName()..": GO_FOLLOW/PLAYER/sees 1")
			else
				-- if entity.sees==2 and not Player.InElevatorArea) then
				if entity.sees==2 and (not Player.InElevatorArea or not entity.allow_idle) then
					Hud:AddMessage(entity:GetName()..": GO_FOLLOW/PLAYER/sees 2")
					System:Log(entity:GetName()..": GO_FOLLOW/PLAYER/sees 2")
					entity.Following=nil
					entity:SelectPipe(0,"AiPlayer_scramble")
					self:OnEnemyMemory(entity,0,1)
					-- entity:TriggerEvent(AIEVENT_CLEAR)
					-- entity.sees = 0 -- Теперь постоянно пишет, что он без целей когда 20 секунд прошло.
					-- entity.sees = 1
					-- Hud:AddMessage(entity:GetName()..": AIPlayerIdle/OnEnemyMemory 3")
					-- System:Log(entity:GetName()..": AIPlayerIdle/OnEnemyMemory 3")
					if not entity.allow_idle then
						Hud:AddMessage(entity:GetName()..": AIPlayerIdle/not entity.allow_idle")
						System:Log(entity:GetName()..": AIPlayerIdle/not entity.allow_idle")
					end
				else
					Hud:AddMessage(entity:GetName()..": GO_FOLLOW/PLAYER/sees 0")
					System:Log(entity:GetName()..": GO_FOLLOW/PLAYER/sees 0")
					-- if Player.InElevatorArea and entity.InElevatorArea and fDistance<=3 then
						-- entity:TriggerEvent(AIEVENT_CLEAR)
						-- entity.Following=nil
						-- entity:SelectPipe(0,"AiPlayer_look_on_local_player")
					-- elseif not Player.InElevatorArea and not entity.InElevatorArea then
						-- entity.Following=nil
						-- if entity.FirstFollow or not entity:SearchAmmunition(1,1) then
							-- entity.FirstFollow = nil
							-- AI:Signal(0,1,"FIND_A_TARGET",entity.id)
						-- end
					-- else
						if entity.sees==0 and entity.not_sees_timer_start==0 and entity.AllowSayNoTarget and not entity.RepeatFollow then
							entity.AllowSayNoTarget = nil
							local Chat
							local rnd = random(1,4)
							if rnd==1 then
								Chat = "@NoGoals"
							elseif rnd==2 then
								Chat = "@NoGoals2"
							elseif rnd==3 then
								Chat = "@WithoutGoals"
							elseif rnd==4 then
								Chat = "@OkayNoneOfTheTargets"
							end
							Hud:AddMessage(entity:GetName().."$1: "..Chat)
						end
						-- Hud:AddMessage(entity:GetName()..": GO_FOLLOW/AiPlayer_follow")
						-- System:Log(entity:GetName()..": GO_FOLLOW/AiPlayer_follow")
						entity.Following=1 -- В C++ тоже.
						-- AI:CreateGoalPipe("AiPlayer_GoToRadarObjective")
						-- AI:PushGoal("AiPlayer_GoToRadarObjective","setup_stand")
						-- AI:PushGoal("AiPlayer_GoToRadarObjective","do_it_walking")
						-- AI:PushGoal("AiPlayer_GoToRadarObjective","do_it_running")
						-- AI:PushGoal("AiPlayer_GoToRadarObjective","not_shoot")
						-- AI:PushGoal("AiPlayer_GoToRadarObjective","form",1,"beacon")
						-- -- AI:PushGoal("AiPlayer_GoToRadarObjective","locate",0,"player")
						-- -- AI:PushGoal("AiPlayer_GoToRadarObjective","acqtarget",0,"") -- Все грёбанные баги при возвращении к игроку были только из-за этого.
						-- AI:PushGoal("AiPlayer_GoToRadarObjective","pathfind",1,"")
						-- AI:PushGoal("AiPlayer_GoToRadarObjective","trace",1,1,1) -- 1,1,0 -- Нуль на конце обязателен, по крайней мере в закрытых помещениях, иначе так как он постоянно натыкается на что-нибудь, то он сразу же пропукает новый маршрут.
						-- -- AI:PushGoal("AiPlayer_GoToRadarObjective","trace",0,1,0)
						-- -- AI:PushGoal("AiPlayer_GoToRadarObjective","timeout",1,.1,2)
						-- AI:PushGoal("AiPlayer_GoToRadarObjective","signal",0,1,"GO_FOLLOW",0)
						
						-- AI:CreateGoalPipe("AiPlayer_GoToRadarObjective")
						-- -- AI:PushGoal("AiPlayer_GoToRadarObjective","setup_stand")
						-- AI:PushGoal("AiPlayer_GoToRadarObjective","do_it_walking")
						-- AI:PushGoal("AiPlayer_GoToRadarObjective","timeout",1,.1)
						-- -- AI:PushGoal("AiPlayer_GoToRadarObjective","signal",0,1,"AI_SETUP_UP",0)
						-- AI:PushGoal("AiPlayer_GoToRadarObjective","do_it_running")
						-- AI:PushGoal("AiPlayer_GoToRadarObjective","not_shoot")
						-- AI:PushGoal("AiPlayer_GoToRadarObjective","form",1,"beacon")
						-- -- AI:PushGoal("AiPlayer_GoToRadarObjective","locate",0,"player")
						-- -- AI:PushGoal("AiPlayer_GoToRadarObjective","locate",0,Hud.RadarObjectiveName)
						-- -- AI:PushGoal("AiPlayer_GoToRadarObjective","acqtarget",0,"") -- Все грёбанные баги при возвращении к игроку были только из-за этого.
						-- AI:PushGoal("AiPlayer_GoToRadarObjective","pathfind",1,"")
						-- -- AI:PushGoal("AiPlayer_GoToRadarObjective","trace",1,1,1) -- 1,1,0 -- Нуль на конце обязателен, по крайней мере в закрытых помещениях, иначе, так как он постоянно натыкается на что-нибудь, он сразу же пропукает новый маршрут.
						-- AI:PushGoal("AiPlayer_GoToRadarObjective","trace",1,1,0) -- 1,1,0 -- Нуль на конце обязателен, по крайней мере в закрытых помещениях, иначе, так как он постоянно натыкается на что-нибудь, он сразу же пропукает новый маршрут.
						-- -- AI:PushGoal("AiPlayer_GoToRadarObjective","trace",0,1,0)
						-- -- AI:PushGoal("AiPlayer_GoToRadarObjective","timeout",1,.1,2)
						-- AI:PushGoal("AiPlayer_GoToRadarObjective","ignoreall",0,1) -- Специально идёт подряд чтобы не поворачивались и не смотрели на цель в этом промежутке. Взято с get_gun.
						-- AI:PushGoal("AiPlayer_GoToRadarObjective","ignoreall",0,0)
						-- AI:PushGoal("AiPlayer_GoToRadarObjective","approach",0,1)
						-- AI:PushGoal("AiPlayer_GoToRadarObjective","trace",1,1,1)
						-- AI:PushGoal("AiPlayer_GoToRadarObjective","ignoreall",0,1)
						-- AI:PushGoal("AiPlayer_GoToRadarObjective","ignoreall",0,0)
						-- AI:PushGoal("AiPlayer_GoToRadarObjective","setup_stand")
						-- AI:PushGoal("AiPlayer_GoToRadarObjective","signal",0,1,"GO_FOLLOW",0)
						
						AI:CreateGoalPipe("AiPlayer_GoToRadarObjective")
						-- AI:PushGoal("AiPlayer_GoToRadarObjective","setup_stand")
						AI:PushGoal("AiPlayer_GoToRadarObjective","acqtarget",0,"")
						AI:PushGoal("AiPlayer_GoToRadarObjective","do_it_walking")
						AI:PushGoal("AiPlayer_GoToRadarObjective","timeout",1,.1)
						-- AI:PushGoal("AiPlayer_GoToRadarObjective","signal",0,1,"AI_SETUP_UP",0)
						AI:PushGoal("AiPlayer_GoToRadarObjective","do_it_running")
						AI:PushGoal("AiPlayer_GoToRadarObjective","not_shoot")
						AI:PushGoal("AiPlayer_GoToRadarObjective","form",1,"beacon")
						AI:PushGoal("AiPlayer_GoToRadarObjective","acqtarget",0,"")
						-- AI:PushGoal("AiPlayer_GoToRadarObjective","locate",0,"player")
						-- AI:PushGoal("AiPlayer_GoToRadarObjective","locate",0,Hud.RadarObjectiveName)
						-- AI:PushGoal("AiPlayer_GoToRadarObjective","acqtarget",0,"") -- Все грёбанные баги при возвращении к игроку были только из-за этого.
						AI:PushGoal("AiPlayer_GoToRadarObjective","pathfind",1,"")
						-- AI:PushGoal("AiPlayer_GoToRadarObjective","trace",1,1,1) -- 1,1,0 -- Нуль на конце обязателен, по крайней мере в закрытых помещениях, иначе, так как он постоянно натыкается на что-нибудь, он сразу же пропукает новый маршрут.
						AI:PushGoal("AiPlayer_GoToRadarObjective","trace",1,1,0) -- 1,1,0 -- Нуль на конце обязателен, по крайней мере в закрытых помещениях, иначе, так как он постоянно натыкается на что-нибудь, он сразу же пропукает новый маршрут.
						-- AI:PushGoal("AiPlayer_GoToRadarObjective","trace",0,1,0)
						-- AI:PushGoal("AiPlayer_GoToRadarObjective","timeout",1,.1,2)
						AI:PushGoal("AiPlayer_GoToRadarObjective","ignoreall",0,1) -- Специально идёт подряд чтобы не поворачивались и не смотрели на цель в этом промежутке. Взято с get_gun.
						AI:PushGoal("AiPlayer_GoToRadarObjective","ignoreall",0,0)
						AI:PushGoal("AiPlayer_GoToRadarObjective","approach",0,1)
						AI:PushGoal("AiPlayer_GoToRadarObjective","trace",1,1,1)
						AI:PushGoal("AiPlayer_GoToRadarObjective","ignoreall",0,1)
						AI:PushGoal("AiPlayer_GoToRadarObjective","ignoreall",0,0)
						AI:PushGoal("AiPlayer_GoToRadarObjective","setup_stand")
						AI:PushGoal("AiPlayer_GoToRadarObjective","signal",0,1,"GO_FOLLOW",0)

						-- if Hud.radarObjective then
							-- Hud:AddMessage(entity:GetName()..": GO_FOLLOW/radarObjective")
							-- System:Log(entity:GetName()..": GO_FOLLOW/radarObjective")
						-- end

						local RadarObjectivePoint
						if Hud and Hud.RadarObjectiveName then
							RadarObjectivePoint = Game:GetTagPoint(Hud.RadarObjectiveName)
						end
						if entity.AiPlayerAllowSearchGun then
							Hud:AddMessage(entity:GetName()..": GO_FOLLOW/AiPlayerAllowSearchGun: 1")
							System:Log(entity:GetName()..": GO_FOLLOW/AiPlayerAllowSearchGun: 1")
						else
							Hud:AddMessage(entity:GetName()..": GO_FOLLOW/AiPlayerAllowSearchGun: nil")
							System:Log(entity:GetName()..": GO_FOLLOW/AiPlayerAllowSearchGun: nil")
						end
						if not entity.AiPlayerAllowSearchGun or not entity:SearchAmmunition(1,1) then
						-- if not entity:SearchAmmunition(1,1) and not entity:RunToVehicle() then
							if RadarObjectivePoint then
								Hud:AddMessage(entity:GetName()..": GO_FOLLOW/RadarObjectivePoint: "..Hud.RadarObjectiveName)
								System:Log(entity:GetName()..": GO_FOLLOW/RadarObjectivePoint: "..Hud.RadarObjectiveName)
								entity:SelectPipe(0,"AiPlayer_GoToRadarObjective",Hud.RadarObjectiveName)
								if random(1,2)==1 then entity.Following=nil end
							else
								-- if entity.FirstFollow then
								-- Hud:AddMessage(entity:GetName()..": GO_FOLLOW/RadarObjectivePoint ELSE")
								-- System:Log(entity:GetName()..": GO_FOLLOW/RadarObjectivePoint ELSE")
								entity.FirstFollow = nil
								entity.Following=nil
								AI:Signal(0,1,"FIND_A_TARGET",entity.id)
							end
						end
						-- if entity.cnt.proning then
							-- entity:InsertSubpipe(0,"setup_crouch")
						-- elseif entity.cnt.crouching then
							-- entity:InsertSubpipe(0,"setup_stand")
						-- end
					-- end
				end
			end
		end
	end,

	AFTER_GET_AMMO_GO_FOLLOW = function(self,entity,sender)
		-- Hud:AddMessage(entity:GetName()..": AIPlayerIdle/AFTER_GET_AMMO_GO_FOLLOW")
		-- System:Log(entity:GetName()..": AIPlayerIdle/AFTER_GET_AMMO_GO_FOLLOW")
		-- if entity.sees~=1 then
			entity:TriggerEvent(AIEVENT_CLEAR) --
			-- entity.sees = 0
		-- end
		-- AI:Signal(0,1,"GO_FOLLOW",entity.id)
		self:GO_FOLLOW(entity,sender)
	end,

	NOT_ALLOW_MOVE_SELECT_LOOK = function(self,entity,sender)
		AI:CreateGoalPipe("AiPlayer_look")
		AI:PushGoal("AiPlayer_look","timeout",1,1)
		AI:PushGoal("AiPlayer_look","lookat",1,-90,90)
		AI:PushGoal("AiPlayer_look","timeout",1,0,9)
		entity:SelectPipe(0,"AiPlayer_look")
	end,

	ALLOW_MOVE_SELECT_LOOK = function(self,entity,sender)
		entity.TempAiAction = nil
		self:NOT_ALLOW_MOVE_SELECT_LOOK(entity)
	end,

	NOT_ALLOW_MOVE_INSERT_LOOK = function(self,entity,sender)
		AI:CreateGoalPipe("AiPlayer_look")
		AI:PushGoal("AiPlayer_look","timeout",1,1)
		AI:PushGoal("AiPlayer_look","lookat",1,-90,90)
		AI:PushGoal("AiPlayer_look","timeout",1,.5,9)
		entity:InsertSubpipe(0,"AiPlayer_look")
	end,

	ALLOW_MOVE_INSERT_LOOK = function(self,entity,sender)
		entity.TempAiAction = nil
		self:NOT_ALLOW_MOVE_INSERT_LOOK(entity)
	end,

	SCOUTING_SOUND = function(self,entity)
		if entity.TempAiAction=="Stopping" then return end
		AI:CreateGoalPipe("AiPlayer_ScoutingSound")
		local rnd = random(1,3)
		if rnd==1 then -- Идти прямо к цели.
			AI:PushGoal("AiPlayer_ScoutingSound","hide",1,10,HM_NEAREST,0)
			AI:PushGoal("AiPlayer_ScoutingSound","pathfind",1,"")
			AI:PushGoal("AiPlayer_ScoutingSound","trace",1,1,0)
			AI:PushGoal("AiPlayer_ScoutingSound","signal",0,1,"STEALTH_ATTACK",0)
		elseif rnd==2 then -- Смотреть по сторонам.
			AI:PushGoal("AiPlayer_ScoutingSound","lookat",1,-45,45)
			AI:PushGoal("look_around","signal",0,1,"FORCE_RESPONSIVENESS_3",0)
			AI:PushGoal("AiPlayer_ScoutingSound","timeout",1,.5,1.5)
			AI:PushGoal("look_around","signal",0,1,"FORCE_RESPONSIVENESS_CLEAR",0)
			AI:PushGoal("AiPlayer_ScoutingSound","lookat",1,-90,90)
			-- AI:PushGoal("AiPlayer_ScoutingSound","lookat",1,-145,145)
			AI:PushGoal("AiPlayer_ScoutingSound","timeout",1,.5,1.5)
			AI:PushGoal("AiPlayer_ScoutingSound","locate",0,"hidepoint")
			AI:PushGoal("AiPlayer_ScoutingSound","acqtarget",0,"")
			AI:PushGoal("AiPlayer_ScoutingSound","timeout",1,.5,5)
			AI:PushGoal("AiPlayer_ScoutingSound","locate",0,"hidepoint")
			AI:PushGoal("AiPlayer_ScoutingSound","acqtarget",0,"")
			AI:PushGoal("AiPlayer_ScoutingSound","timeout",1,.5,5)
			AI:PushGoal("AiPlayer_ScoutingSound","locate",0,"hidepoint")
			AI:PushGoal("AiPlayer_ScoutingSound","acqtarget",0,"")
			AI:PushGoal("AiPlayer_ScoutingSound","timeout",1,.5,5)
			AI:PushGoal("AiPlayer_ScoutingSound","locate",0,"hidepoint")
			AI:PushGoal("AiPlayer_ScoutingSound","acqtarget",0,"")
			AI:PushGoal("AiPlayer_ScoutingSound","timeout",1,.5,5)
			AI:PushGoal("AiPlayer_ScoutingSound","pathfind",1,"")
			AI:PushGoal("AiPlayer_ScoutingSound","trace",1,1,0)
			AI:PushGoal("AiPlayer_ScoutingSound","signal",0,1,"STEALTH_ATTACK",0)
		else -- Сменить позицию и атаковать.
			AI:PushGoal("AiPlayer_ScoutingSound","hide",1,60,HM_RANDOM,1)
			AI:PushGoal("AiPlayer_ScoutingSound","timeout",1,1,5)
			AI:PushGoal("AiPlayer_ScoutingSound","locate",0,"hidepoint")
			AI:PushGoal("AiPlayer_ScoutingSound","acqtarget",1,"")
			AI:PushGoal("AiPlayer_ScoutingSound","locate",0,"beacon")
			AI:PushGoal("AiPlayer_ScoutingSound","acqtarget",1,"")
			AI:PushGoal("AiPlayer_ScoutingSound","pathfind",1,"")
			AI:PushGoal("AiPlayer_ScoutingSound","trace",1,1,0)
			AI:PushGoal("AiPlayer_ScoutingSound","signal",0,1,"AIPLAYER_ATTACK",0)
		end
		entity:SelectPipe(0,"AiPlayer_ScoutingSound")
		if not entity.cnt.proning and not entity.cnt.crouching then
			entity:InsertSubpipe(0,"setup_crouch")
		elseif entity.cnt.crouching then
			entity:InsertSubpipe(0,"setup_prone")
		end
	end,

	STEALTH_ATTACK = function(self,entity)
		if entity.TempAiAction=="Stopping" then return end
		AI:CreateGoalPipe("AiPlayer_stealth_attack")
		AI:PushGoal("AiPlayer_stealth_attack","locate",0,"beacon") -- atttarget
		AI:PushGoal("AiPlayer_stealth_attack","acqtarget",1,"")
		AI:PushGoal("AiPlayer_stealth_attack","timeout",1,2,5)
		AI:PushGoal("AiPlayer_stealth_attack","hide",1,30,HM_NEAREST,0)
		AI:PushGoal("AiPlayer_stealth_attack","hide",1,300,HM_NEAREST,1)
		AI:PushGoal("AiPlayer_stealth_attack","timeout",1,.5,1.5)
		AI:PushGoal("AiPlayer_stealth_attack","locate",0,"hidepoint")
		AI:PushGoal("AiPlayer_stealth_attack","acqtarget",1,"")
		AI:PushGoal("AiPlayer_stealth_attack","timeout",1,.5,1.5)
		AI:PushGoal("AiPlayer_stealth_attack","locate",0,"hidepoint")
		AI:PushGoal("AiPlayer_stealth_attack","acqtarget",1,"")
		AI:PushGoal("AiPlayer_stealth_attack","timeout",1,.5,1.5)
		AI:PushGoal("AiPlayer_stealth_attack","hide",1,300,HM_NEAREST_TO_TARGET,1)
		AI:PushGoal("AiPlayer_stealth_attack","signal",0,1,"AIPLAYER_ATTACK",0)
		-- AIBehaviour.DEFAULT:AI_SETUP_DOWN(entity)
		if not entity.cnt.proning and not entity.cnt.crouching then
			entity:InsertSubpipe(0,"setup_crouch")
			-- entity:InsertSubpipe(0,"do_it_walking")
		elseif entity.cnt.crouching then
			entity:InsertSubpipe(0,"setup_prone")
			-- entity:InsertSubpipe(0,"do_it_walking")
		end
		entity:SelectPipe(0,"AiPlayer_stealth_attack")
		entity:InsertSubpipe(0,"do_it_walking")
		entity:InsertSubpipe(0,"just_shoot")
	end,

	AIPLAYER_ATTACK = function(self,entity,sender)
		if entity.TempAiAction=="Stopping" then return end
		-- entity:InsertSubpipe(0,"reload")
		-- if entity.critical_status then
			-- entity:SelectPipe(0,"AiPlayer_hide_on_critical_status")
			-- do return end
		-- end
		-- if random(1,10)==1 then
			--
		-- else
		if entity.AiPlayerIncomingFireStart then -- OnBulletRain, AiPlayer_incoming_fire
			-- Hud:AddMessage(entity:GetName()..": entity.AiPlayerIncomingFireStart: "..entity.AiPlayerIncomingFireStart)
			if not entity.cnt.proning and not entity.cnt.crouching then
				entity:InsertSubpipe(0,"setup_crouch")
				entity:InsertSubpipe(0,"do_it_walking")
			elseif entity.cnt.crouching then
				entity:InsertSubpipe(0,"setup_prone")
				entity:InsertSubpipe(0,"do_it_walking")
			end
			return
		end
		entity:SelectPipe(0,"AiPlayer_pindown")
		entity:InsertSubpipe(0,"just_shoot")
		if entity.Following then
			if not entity.cnt.proning and not entity.cnt.crouching then
				entity:InsertSubpipe(0,"setup_crouch")
				entity:InsertSubpipe(0,"do_it_walking")
			elseif entity.cnt.crouching then
				entity:InsertSubpipe(0,"setup_prone")
				entity:InsertSubpipe(0,"do_it_walking")
			end
		end
		if entity.TempAiAction=="Attack" then
			if entity.sees~=1 then
				AI:Signal(0,1,"FIND_A_TARGET",entity.id)
			-- else
				-- entity:SelectPipe(0,"AiPlayer_scramble")
			end
			entity.TempAiAction=nil
		end
	end,

	AIPLAYER_CAMP = function(self,entity,sender)
		if entity.TempAiAction=="Stopping" then return end
		entity:SelectPipe(0,"AiPlayer_camp_x")
	end,

	COVER_STRAFE = function(self,entity,sender)
		if entity.TempAiAction=="Stopping" then return end
		AI:CreateGoalPipe("cover_strafe")
		AI:PushGoal("cover_strafe","just_shoot")
		AI:PushGoal("cover_strafe","locate",0,"beacon")
		AI:PushGoal("cover_strafe","acqtarget",1,"")
		if not entity.IsIndoor then
			if random(1,3) > 1 then
				AI:PushGoal("cover_strafe","approach",0,1)
			end
			local rnd = random(-15,15)
			if rnd > -3 and rnd < 0 then rnd = -3  end
			if rnd < 3 and rnd >=0 then rnd = 3  end
			AI:PushGoal("cover_strafe","strafe",0,rnd)
			AI:PushGoal("cover_strafe","timeout",1,2,5)
		else
			AI:PushGoal("cover_strafe","approach",0,1)
			AI:PushGoal("cover_strafe","trace",1,1,1)
		end
		AI:PushGoal("cover_strafe","locate",0,"hidepoint")
		AI:PushGoal("cover_strafe","acqtarget",0,"")
		AI:PushGoal("cover_strafe","timeout",1,0,.5)
		-- Hud:AddMessage(entity:GetName()..": COVER_STRAFE/strafe: "..rnd)
		-- System:Log(entity:GetName()..": COVER_STRAFE/strafe: "..rnd)
		AI:PushGoal("cover_strafe","signal",0,1,"CHECK_FOR_FIND_A_TARGET",0)
		local att_target = AI:GetAttentionTargetOf(entity.id)
		if not att_target then -- Чтоб не стоял на одном месте если при выборе цель была потеряна.
			-- Hud:AddMessage(entity:GetName()..": COVER_STRAFE/not att_target")
			-- System:Log(entity:GetName()..": COVER_STRAFE/not att_target")
			AI:PushGoal("cover_strafe","signal",0,1,"FIND_A_TARGET",0)
			-- AI:PushGoal("cover_strafe","signal",0,1,"HIDE_LEFT_OR_RIGHT",0)
		end
		entity:SelectPipe(0,"cover_strafe")
		if entity.cnt.crouching then
			if random(1,2)==1 then
				entity:InsertSubpipe(0,"do_it_walking")
			else
				entity:InsertSubpipe(0,"setup_stand")
				entity:InsertSubpipe(0,"do_it_running")
			end
		elseif not entity.cnt.proning then
			entity:InsertSubpipe(0,"setup_stand")
			entity:InsertSubpipe(0,"do_it_running")
		elseif entity.cnt.proning then
			entity:SelectPipe(0,"AiPlayer_scramble")
			entity:InsertSubpipe(0,"setup_crouch")
		end
	end,

	HIDE_LEFT_OR_RIGHT = function(self,entity,sender) -- За укрытием дожен вставать.
		if entity.TempAiAction=="Stopping" then return end
		-- Hud:AddMessage(entity:GetName()..": HIDE_LEFT_OR_RIGHT START")
		-- System:Log(entity:GetName()..": HIDE_LEFT_OR_RIGHT START")
		if entity.not_sees_timer_start==0 then -- Есть цель.
			entity.target_lost_muted = 1
		else
			entity.target_lost_muted = nil
		end
		entity.farhide = nil
		AI:CreateGoalPipe("cover_hide_left_or_right")
		AI:PushGoal("cover_hide_left_or_right","just_shoot")
		if entity.not_sees_timer_start~=0 then -- Нет цели.
			AI:PushGoal("cover_hide_left_or_right","timeout",1,.5,3)
		end
		AI:PushGoal("cover_hide_left_or_right","locate",0,"beacon")
		AI:PushGoal("cover_hide_left_or_right","acqtarget",0,"")
		-- if entity.sees==1 then -- Есть цель.
			-- look = 1
			-- if not entity.farhide then
				-- -- Hud:AddMessage(entity:GetName()..": HIDE_LEFT_OR_RIGHT/HM_FARTHEST_FROM_TARGET")
				-- -- System:Log(entity:GetName()..": HIDE_LEFT_OR_RIGHT/HM_FARTHEST_FROM_TARGET")
				-- entity.farhide = 1
				-- AI:PushGoal("cover_hide_left_or_right","hide",1,15,HM_FARTHEST_FROM_TARGET,0)
				-- AI:PushGoal("cover_hide_left_or_right","hide",1,15,HM_FARTHEST_FROM_TARGET,1)
			-- end
			-- AI:PushGoal("cover_hide_left_or_right","do_it_running")
			-- if entity.cnt.proning or entity.cnt.crouching then
				-- look = 0
			-- else
				-- AI:PushGoal("cover_hide_left_or_right","not_shoot")
			-- end
		-- else
			-- look = 0
		-- end
		if entity.sees~=0 then
			look = 0
		else
			look = 1
		end
		if not entity.ai_flanking then
			entity.ai_flanking = random(1,2)
		end
		if entity.ai_flanking==1 then
			if random(1,2)==1 then
				AI:PushGoal("cover_hide_left_or_right","hide",1,100,HM_LEFTMOST_FROM_TARGET,look)
			else
				AI:PushGoal("cover_hide_left_or_right","hide",1,100,HM_LEFT_FROM_TARGET,look)
			end
		else
			if random(1,2)==1 then
				AI:PushGoal("cover_hide_left_or_right","hide",1,100,HM_RIGHTMOST_FROM_TARGET,look)
			else
				AI:PushGoal("cover_hide_left_or_right","hide",1,100,HM_RIGHT_FROM_TARGET,look)
			end
		end
		AI:PushGoal("cover_hide_left_or_right","just_shoot")
		if entity.not_sees_timer_start~=0 then -- Нет цели.
			AI:PushGoal("cover_hide_left_or_right","do_it_walking")
			AI:PushGoal("cover_hide_left_or_right","timeout",1,.5,1)
			AI:PushGoal("cover_hide_left_or_right","look_around")
			AI:PushGoal("cover_hide_left_or_right","timeout",1,0,3)
			AI:PushGoal("cover_hide_left_or_right","locate",0,"hidepoint")
			AI:PushGoal("cover_hide_left_or_right","acqtarget",0,"")
			AI:PushGoal("cover_hide_left_or_right","timeout",1,0,3)
		else
			if look==0 then
				AI:PushGoal("cover_hide_left_or_right","timeout",1,0,3)
				if ai_flanking==1 then
					AI:PushGoal("cover_strafe","strafe",0,15)
				else
					AI:PushGoal("cover_strafe","strafe",0,-15)
				end
				AI:PushGoal("cover_strafe","timeout",1,2,5)
				AI:PushGoal("cover_strafe","strafe",0,0)
			end
			AI:PushGoal("cover_hide_left_or_right","locate",0,"hidepoint")
			AI:PushGoal("cover_hide_left_or_right","acqtarget",0,"")
			AI:PushGoal("cover_hide_left_or_right","timeout",1,0,.5)
		end
		-- Hud:AddMessage(entity:GetName()..": HIDE_LEFT_OR_RIGHT END")
		-- System:Log(entity:GetName()..": HIDE_LEFT_OR_RIGHT END")
		AI:PushGoal("cover_hide_left_or_right","hide",1,100,HM_NEAREST_TO_TARGET,look)
		AI:PushGoal("cover_hide_left_or_right","signal",0,1,"CHECK_FOR_FIND_A_TARGET",0)
		AI:PushGoal("cover_hide_left_or_right","signal",0,1,"HIDE_LEFT_OR_RIGHT",0)
		look = nil
		entity:SelectPipe(0,"cover_hide_left_or_right")
		-- AIBehaviour.DEFAULT:AI_SETUP_DOWN(entity)
		if not entity.cnt.proning and not entity.cnt.crouching then
			entity:InsertSubpipe(0,"setup_crouch")
			entity:InsertSubpipe(0,"do_it_walking")
		elseif entity.cnt.crouching then
			entity:InsertSubpipe(0,"setup_prone")
			entity:InsertSubpipe(0,"do_it_walking")
		end
		if not entity.cnt.proning and not entity.cnt.crouching then
			entity:InsertSubpipe(0,"do_it_running")
		else
			entity:InsertSubpipe(0,"do_it_walking")
		end
	end,

	HIDE_TACTIC = function(self,entity,sender)
		if entity.TempAiAction=="Stopping" then return end
		entity:SelectPipe(0,"AiPlayer_hide_tactic")
	end,

	AISF_GoOn = function(self,entity,sender)
		if entity.TempAiAction=="Stopping" then return end
		entity:SelectPipe(0,"AiPlayer_scramble")
	end,

	HEADS_UP_GUYS = function(self,entity,sender)
		-- if entity.ForceSenderId then sender=System:GetEntity(entity.ForceSenderId) entity.ForceSenderId=nil end
		if entity.ForceSenderId then
			sender = System:GetEntity(entity.ForceSenderId)
			-- Hud:AddMessage(sender:GetName()..": sender")
			entity.ForceSenderId = nil
		end
		if entity.TempAiAction=="Stopping" then
			if entity.Properties.species==sender.Properties.species and entity~=sender
			and not entity.RunToTrigger and not entity.heads_up_guys and not entity.ai_flanking and entity.sees~=1 then
				if not entity.rs_x then	entity.rs_x = 1	end
				if sender and sender.SenderId then
					entity:InsertSubpipe(0,"DropBeaconAt",sender.SenderId) -- Посмотреть на замеченную другом цель.
				end
			end
			return
		end
		AIBehaviour.DEFAULT:AllWakeUp(entity)
		-- Hud:AddMessage(entity:GetName()..": HEADS_UP_GUYS")
		if entity.Properties.species==sender.Properties.species and entity~=sender
		-- and not entity.RunToTrigger and not entity.heads_up_guys and not entity.ai_flanking and entity.sees~=1 then -- С этим entity.heads_up_guys надо решить, понять что делать когда игрок постоянно видит кого-то.
		and not entity.RunToTrigger and not entity.heads_up_guys and not entity.ai_flanking and (entity.sees==0 or (entity.sees~=1 and entity.Following)) then
		-- and not entity.RunToTrigger and not entity.ai_flanking and entity.sees~=1 then
		-- if entity~=sender then
			if not entity.rs_x then	entity.rs_x = 1	end
			-- Hud:AddMessage(entity:GetName()..": HEADS_UP_GUYS 2")
			entity:SelectPipe(0,"AiPlayer_beacon_pindown")
			if sender and sender.SenderId then
				entity:SelectPipe(0,"AiPlayer_check_beacon")
				entity:InsertSubpipe(0,"DropBeaconAt",sender.SenderId)
				local SenderDistance = entity:GetDistanceFromPoint(sender:GetPos())
				if SenderDistance and SenderDistance > 30 then -- Чтобы лишний раз к отправителю не бегал.
					entity:InsertSubpipe(0,"go_to_sender",sender.id)
				end
			end
			if entity.not_sees_timer_start2 then self.not_sees_timer_start2=_time end -- Обновляем счётчик. А лучше вообще сделать так, чтобы как бы официально была OnPlayerSeen, чтобы sees стал 1.
			entity.heads_up_guys = 1
			entity.Following = nil
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,10)
			AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY(entity)
			entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)
		end
	end,

	INCOMING_FIRE = function(self,entity,sender)
		-- do nothing on this signal
	end,

	ALARM_ON = function(self,entity,sender)
	end,

	ALERT_SIGNAL = function(self,entity,sender)
	end,

	LOOK_AT_BEACON = function(self,entity,sender)
	end,
	--------------------------------------------------
	-- GROUP SIGNALS
	--------------------------------------------------
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
}