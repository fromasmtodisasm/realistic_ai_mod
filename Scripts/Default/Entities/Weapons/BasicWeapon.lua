-- HIGHLY OPTIMIZED BASICWEAPON 1.73uni-h-fcam_pp By MIXER verysoft.narod.ru/fctweaks.htm
Script:LoadScript("scripts/default/hud/DefaultZoomHUD.lua")
Script:LoadScript("scripts/default/hud/AimModeZoomHUD.lua")
Game:CreateVariable("w_firstpersontrail","1")

BasicWeapon = {
	UnderwaterBubbles = {
		focus = .2,
		color = {1,1,1},
		speed = .25,
		count = 1,
		size = .05, size_speed=0, -- default size .2
		gravity = {x = 0, y = 0, z = 2.6},
		lifetime=1.5, -- default 2.5
		tid = System:LoadTexture("textures\\bubble.tga"),
		frames=0,
		color_based_blending = 1,
		fPosRandomOffset=0,
		particle_type = 2, -- [marco] avoid these bubbles to fly out of the water surface (2=PART_FLAG_UNDERWATER)
	},
	TracerBubbles = {
		focus = .2,
		color = {1,1,1},
		speed = .25,
		count = 1,
		size = .02, size_speed=0, -- default size .2
		gravity = {x = 0, y = 0, z = 2.6},
		lifetime=1.5, -- default 2.5
		tid = System:LoadTexture("textures\\bubble.tga"),
		frames=0,
		color_based_blending = 1,
		fPosRandomOffset=0,
		particle_type = 2, -- [marco] avoid these bubbles to fly out of the water surface (2=PART_FLAG_UNDERWATER)
	},
	DefaultFireParams = {
		shoot_underwater = 0,
		aim_recoil_modifier = 1,
		aim_improvement = 0,
		auto_aiming_dist = 0,

		ai_mode = 0, -- specifies whether this firemode is exclusively used by AI (==1)
		allow_hold_breath = 0, -- specifies whether it is possible to use the hold breath feature in zoom mode
		sprint_penalty = .7, -- default decrease in accuracy when sprinting

		accuracy_modifier_standing = 1,
		accuracy_modifier_crouch = .7,
		accuracy_modifier_prone = .5,

		recoil_modifier_standing = 1,
		recoil_modifier_crouch = .5,
		recoil_modifier_prone = .1,
	},
	--temp tables
	temp_dir={x=0,y=0,z=0},
	temp_exitdir={x=0,y=0,z=0},
	temp_pos={x=0,y=0,z=0},
	temp_angles={x=0,y=0,z=0},
	temp_hitpt={x=0,y=0,z=0},
	VoidDist = 1000, -- trace distance if no hit
	blip=Sound:LoadSound("SOUNDS/hit.wav",0,128),
	fireModeChangeSound = Sound:LoadSound("SOUNDS/items/WEAPON_FIRE_MODE.wav", 0, 128),
	Client = {},
	Server = {},

	-- temp tables.
	temp = {
		rotate_vector = {x=0,y=0,z=0},
		light_info = {},
	},

	--vehicle crosshair - now it's always in the middle of screen
	CrossHairPos={xS=400,yS=300},

	scopeFlareInfo={
		lightShader = "ScopeFlare",
		shooterid=nil,
		orad=2,
		areaonly=1,
		coronaScale = 0,
	},
	--cantshoot_sprite: showed when you cant shot where you aiming at
	cantshoot_sprite=System:LoadImage("Textures/hud/crosshair/cantshoot.dds"),

	--weapons particle fx
	Particletemp = {
		focus = 0,
		speed = 0,
		count = 1,
		size = 1,
		size_speed=0,
		lifetime=1,
		tid = nil,
		rotation = {x = 0, y = 0, z = 0},
		gravity = {x = 0, y = 0, z = 0},
		frames=0,
		blend_type = 2,
		AirResistance = 0,
		start_color = {1,1,1},
		end_color = {1,1,1},
		bLinearSizeSpeed = 1,
		--fadeintime = 1
	},

	temp_v1 = {x=0,y=0,z=0},
	temp_v2 = {x=0,y=0,z=0},
	vcolor1 = {1,1,1},
}

function BasicWeapon:SyncVarCache(shooter)
	shooter.firemodenum=shooter.cnt.firemode+1
	shooter.fireparams=self.cnt[shooter.cnt.firemode]
	shooter.sounddata=GetPlayerWeaponInfo(shooter).SndInstances[shooter.firemodenum]
end

function BasicWeapon:InitParams()
	if self.name then self:SetName(self.name) else self:SetName("Nameless") end
	-- merging of weapon params
	-- self.RandomNumber = random(1,10)
	if (self.name) then
		if (WeaponsParams[self.name]) then
			--System:Log("~~~~~~~~~~~~~~~~~~Initializing "..self.name)
			for i,val in self.FireParams do
				--local params=WeaponsParams[self.name][i]
				local params = nil
				--keep retrocompatibility if the weaponsParams table dont contain 2 different tables, one for standard firemodes
				--and one for multiplayer changes
				if (WeaponsParams[self.name].Std and WeaponsParams[self.name].Std[i]) then
					params = WeaponsParams[self.name].Std[i]
				else
					params = WeaponsParams[self.name][i]
				end
				if (params) then
					merge(val,params)
				end
				--now , if multiplayer, merge the special multiplayer fireparams table we have in the weaponsparams.lua
				if (Game:IsMultiplayer() and WeaponsParams[self.name].Mp) then
					--local params=WeaponsParams[self.name].Multi[i]
					local mutli_params = WeaponsParams[self.name].Mp[i]
					if (mutli_params) then
						merge(val,mutli_params)
					end
				end
				-- default tap fire rate is equal to normal fire rate
				if (val.tap_fire_rate==nil) then
					val.tap_fire_rate = val.fire_rate
				end
				for def_key, def_val in BasicWeapon.DefaultFireParams do
					if (val[def_key]==nil) then
						val[def_key] = def_val
					end
				end
				-- if val.Trace and val.Trace.geometry then
					-- val.Trace.speed=.1
					-- if random(1,2)==1 then
						-- System:Log(self.name..": p_tracer_r, i: "..i)
						-- val.Trace.geometry=System:LoadObject("Objects/Weapons/p_tracer_r.cgf")
					-- else
						-- System:Log(self.name..": p_tracer_g, i: "..i)
						-- val.Trace.geometry=System:LoadObject("Objects/Weapons/p_tracer_g.cgf")
					-- end
				-- end
			end
		end
	end
	if not self.bFireParamsSet then
		self.bFireParamsSet = 1
		for idx,element in self.FireParams do
			self.cnt:SetWeaponFireParams(element)
		end
	end
	--kirill moved this from InitClient this has to be done on server as well - for dedicatedServer
	--System:Log("\003 BasicWeapon Init "..self.name)
	if (self.FireParams[1].type) then
		self.cnt:SetHoldingType(self.FireParams[1].type)
	else
		self.cnt:SetHoldingType(1) -- Указывает, какие анимации использовать. 1 или ничего - обычные оружейные анимации двух рук. 2 - пистолеты, 3 - ножи (мачете), 4 - стройка (гаечный ключ), 5 - бросок бомбы или аптечки. Нет оружия - анимации мачете. 
	end
end

--------------------------------------
function BasicWeapon.Server:OnInit()
	--System:Log("BasicWeapon.Server:OnInit")
	BasicWeapon.InitParams(self)
end
------------------------------------------
function BasicWeapon.Client:OnInit()
	--System:Log("BasicWeapon.Client:OnInit")
	BasicWeapon.InitParams(self)
	self.nextfidgettime = nil
	if (BasicWeapon.prevShift==nil) then
		BasicWeapon.prevShift = 0
	end
	if (self.Sway==nil and self.ZoomNoSway) then
	self.Sway=1.5
	end
	if (self.special_bone_to_bind) then
		self.cnt:SetBindBone(self.special_bone_to_bind)
	else
		self.cnt:SetBindBone("weapon_bone")
	end
	--Attach animation key events to sounds(the table SoundEvents
	--is optionally implemented in the weapon script
	if (self.SoundEvents) then
			for i,event in self.SoundEvents do
				--System:Log("ADDING SOUND ["..self.name.."] <"..event[1]..">")
				self:SetAnimationKeyEvent(event[1],event[2],event[3])
				if (event[4]~=nil) then
					Sound:SetSoundVolume(event[3],event[4])
				end
			end
		else
		System:Log("WARNING SoundEvents empty ["..self.name.."]")
	end
	-- make sure MuzzleFlash CGFs are cached
	for idx, element in self.FireParams do
		--first person
		if (element.MuzzleFlash and element.MuzzleFlash.geometry_name) then
			self.cnt:CacheObject(element.MuzzleFlash.geometry_name)
		end
		--third person
		if (element.MuzzleFlashTPV and element.MuzzleFlashTPV.geometry_name) then
			self.cnt:CacheObject(element.MuzzleFlashTPV.geometry_name)
		end
	end
end

function BasicWeapon:SyncAmmoInClip(shooter)
	if shooter.Ammo[shooter.fireparams.AmmoType]~=shooter.cnt.ammo then -- Мало ли...
		shooter.Ammo[shooter.fireparams.AmmoType] = shooter.cnt.ammo
		-- System:Log(shooter:GetName()..": shooter.Ammo[shooter.fireparams.AmmoType]: "..shooter.Ammo[shooter.fireparams.AmmoType])
	end
	local weaponState = GetPlayerWeaponInfo(shooter)
	if weaponState then
		if weaponState.AmmoInClip[shooter.firemodenum]~=shooter.cnt.ammo_in_clip then
			weaponState.AmmoInClip[shooter.firemodenum] = shooter.cnt.ammo_in_clip
			-- System:Log(shooter:GetName()..": weaponState.AmmoInClip[shooter.firemodenum]: "..weaponState.AmmoInClip[shooter.firemodenum])
		end
	end
end

function BasicWeapon.Server:OnUpdate(delta, shooter)
	local stats = shooter.cnt
	-- Было stats.underwater~=.
	-- Hud:AddMessage(shooter:GetName().."$1: stats.underwater: "..stats.underwater)
	-- System:Log(shooter:GetName().."$1: stats.underwater: "..stats.underwater)
	if (stats.underwater>0 or stats:IsSwimming()) and stats.reloading then -- Перезарядка не будет удачной, если во время неё игрок попал в воду.
		stats.reloading = nil
		-- Hud:AddMessage(shooter:GetName().."$1: stats.reloading = nil")
	end
	if shooter.IsAiPlayer then
		if stats.reloading then
			if not shooter.StartReloadingTime then
				shooter.StartReloadingTime = _time
				shooter.StartReloadingWeaponName = self.name
			end
		else
			if shooter.StartReloadingTime or shooter.SayReloading or (shooter.StartReloadingWeaponName and shooter.StartReloadingWeaponName~=self.name) then
				shooter.SayReloading = nil
				shooter.StartReloadingTime = nil
				shooter.StartReloadingWeaponName = nil
			end
		end
		if _localplayer and shooter:GetDistanceFromPoint(_localplayer:GetPos()) <= 30+random(0,30) and shooter.StartReloadingTime
		and _time>shooter.StartReloadingTime+1 and not shooter.SayReloading then
			shooter.SayReloading = 1
			local Chat
			local Chat2
			local rnd = random(1,2)
			if rnd==1 then
				Chat = "@Rechargeable"
			elseif rnd==2 then
				Chat = "@Rechargeable2"
			end
			rnd = random(1,2)
			if rnd==1 then
				Chat2 = "@Cover"
			elseif rnd==2 then
				Chat2 = ""
			end
			if Chat then
				Hud:AddMessage(shooter:GetName()..": "..Chat.." "..Chat2)
			end
		end
	end
	-- if (shooter==_localplayer) then
		-- local stats = shooter.cnt
	-- if (stats.underwater~=0 and stats.reloading) then
			-- stats.reloading = nil
			-- Hud:AddMessage(shooter:GetName().."$1: stats.reloading = nil,stats.underwater: "..stats.underwater)
	-- end
	-- end
	BasicWeapon.SyncAmmoInClip(self,shooter)
	
	if shooter==_localplayer and not shooter.IsAiPlayer and shooter.OnWeaponScopeDeactivatingReloading then
		if shooter.OnWeaponScopeDeactivatingReloading~=self.name then shooter.OnWeaponScopeDeactivatingReloading=nil return end -- Если игрок начнёт перезарядку и в этот момент переключит на другое не перезаряженное оружие...
		if ClientStuff.vlayers:IsActive("WeaponScope") then
			-- Hud:AddMessage(shooter:GetName().."$1: BasicWeapon.Server:OnUpdate/DeactivateLayer")
			-- System:Log(shooter:GetName().."$1: BasicWeapon.Server:OnUpdate/DeactivateLayer")
			ClientStuff.vlayers:DeactivateLayer("WeaponScope")
		elseif stats.aiming then -- Не убирать! Тогда, пока прицеливание не станет полностью от бедра, перезарядки не пройзойдёт.
		-- elseif stats.aiming and not shooter.IsAiPlayer then -- Не убирать! Тогда, пока прицеливание не станет полностью от бедра, перезарядки не пройзойдёт.
			-- Hud:AddMessage(shooter:GetName().."$1: BasicWeapon.Server:OnUpdate/stats.aiming")
			-- System:Log(shooter:GetName().."$1: BasicWeapon.Server:OnUpdate/stats.aiming")
		else
			shooter.OnWeaponScopeDeactivatingReloading = nil
			-- Hud:AddMessage(shooter:GetName().."$1: BasicWeapon.Server:OnUpdate/Reload!")
			-- System:Log(shooter:GetName().."$1: BasicWeapon.Server:OnUpdate/Reload!")
			BasicWeapon.Client.Reload(self,shooter)
			BasicWeapon.Server.Reload(self,shooter)
		end
	-- elseif shooter==_localplayer then
		-- if ClientStuff.vlayers:IsActive("WeaponScope") then
			-- -- Hud:AddMessage(shooter:GetName().."$1: BasicWeapon.Server:OnUpdate/DeactivateLayer")
			-- -- System:Log(shooter:GetName().."$1: BasicWeapon.Server:OnUpdate/DeactivateLayer")
			-- ClientStuff.vlayers:DeactivateLayer("WeaponScope")
		-- end
		-- -- Hud:AddMessage(shooter:GetName().."$1: BasicWeapon.Server:OnUpdate/Reload!")
		-- -- System:Log(shooter:GetName().."$1: BasicWeapon.Server:OnUpdate/Reload!")
		-- BasicWeapon.Client.Reload(self,shooter)
		-- BasicWeapon.Server.Reload(self,shooter)
	end
end

function BasicWeapon.Client:OnUpdate(delta, shooter)
	-- if (Game:IsMultiplayer()) and (self.DrawFlare) and (_localplayer and _localplayer.type and tostring(cl_scope_flare)=="1") then
	if self.DrawFlare and _localplayer and _localplayer.type and tostring(cl_scope_flare)=="1" and not shooter.IsIndoor and shooter.TotalLightScale
	and shooter.TotalLightScale>.2 then -- Ещё, добавить проверку на туман.
		local tpos = _localplayer:GetPos()
		local vCamPos = BasicWeapon.temp_pos
		CopyVector(vCamPos, tpos)
		local vShooterPos = shooter:GetPos()

		local fFlareDistance=sqrt((vCamPos.x-vShooterPos.x)*(vCamPos.x-vShooterPos.x)+
		 (vCamPos.y-vShooterPos.y)*(vCamPos.y-vShooterPos.y)+
		 (vCamPos.z-vShooterPos.z)*(vCamPos.z-vShooterPos.z))

		--
		local fMinFlareDist=7 -- in meters
		local fMaxFlareDist=10 -- in meters
		local fFlareScale=.25 -- affects size and brightness overall
		local fFlareDistDownScale=.03 -- affects size and brightness in distance

		-- only display flare, at some distance
		if (fFlareDistance>fMinFlareDist) then
			BasicWeapon.scopeFlareInfo.shooterid=shooter.id
			-- fade in/out flare
			local fScale=fFlareScale/(fFlareDistance*fFlareDistDownScale+1)
			if fFlareDistance<fMaxFlareDist then
				fScale = fScale * (fFlareDistance-fMinFlareDist)/(fMaxFlareDist-fMinFlareDist)
			end
			BasicWeapon.scopeFlareInfo.coronaScale=fScale
			self:DrawScopeFlare(BasicWeapon.scopeFlareInfo)
		end
	end

	if shooter==_localplayer then
		local stats = shooter.cnt
		-- Mixer: Weapon activation in multiplayer spawn debug
		if (not shooter.mp_weapon_active) then
			local tmp_params = {}
			tmp_params.shooter = shooter
			BasicWeapon.Client.OnActivate(self,tmp_params)
		end
		-- if UI then -- Чтобы в редакторе не мешало смотреть издалека.
			-- if stats.flying then
				-- Flying = 1
			-- elseif Flying then
				-- Flying = nil
			-- end
		-- end
		-- Mixer: outofscope optimized / 1.72 fixed
		if ClientStuff.vlayers:IsActive("WeaponScope") then
			-- if (stats.moving or stats.running or Flying) and (self.AimMode~=1) and (not shooter.theVehicle) and (not shooter.cnt.lock_weapon) then
			-- if Velocity.z<-3 and self.AimMode~=1 and not shooter.theVehicle and not shooter.cnt.lock_weapon then
			if not shooter.theVehicle and not shooter.cnt.lock_weapon then
				local Velocity = shooter:GetVelocity()
				if Velocity.z<-3.5 then -- Добавить проверку на нажатие прицеливания и если до сих пор нажато, то приближать снова при выходе.
					-- Hud:AddMessage(shooter:GetName()..": Velocity.z: "..Velocity.z)
					ClientStuff.vlayers:DeactivateLayer("WeaponScope")
				end
				-- local szKeyName = Input:GetXKeyDownName()
				-- local KeyPressed
				-- local KeyId = {59} -- Кнопка бега. Код для того чтобы узнать другие ID есть в AddHands.
				-- for j,val in KeyId do
					-- local Binding = Input:GetBinding("default",val)
					-- for k,val2 in Binding do
						-- -- Hud:AddMessage(shooter:GetName()..": val2.key: "..val2.key)
						-- if val2 and szKeyName==val2.key then
							-- KeyPressed = 1
						-- end
					-- end
				-- end
				-- -- if KeyPressed then
					-- -- Hud:AddMessage(shooter:GetName()..": KeyPressed")
				-- -- end
				if stats.running and KeyPressed and self.AimMode==2 then
					if not self.OutOfScopeTimeStart then self.OutOfScopeTimeStart = _time end
					if self.OutOfScopeTimeStart and _time > self.OutOfScopeTimeStart+2 then
						ClientStuff.vlayers:DeactivateLayer("WeaponScope")
					end
				elseif self.OutOfScopeTimeStart then
					self.OutOfScopeTimeStart = nil
					-- Hud:AddMessage(shooter:GetName()..": clear")
				end
			end
		elseif self.OutOfScopeTimeStart then
			self.OutOfScopeTimeStart = nil
			-- Hud:AddMessage(shooter:GetName()..": clear 2")
		end

		if ClientStuff.vlayers:IsActive("Binoculars") then
			if not shooter.theVehicle and not shooter.cnt.lock_weapon then
				local Velocity = shooter:GetVelocity()
				if Velocity.z<-3.5 then
					ClientStuff.vlayers:DeactivateLayer("Binoculars")
				end
			end
		end

		-- if ClientStuff.vlayers:IsActive("Binoculars") then
			-- stats.bForceWalk = 1
			-- local Velocity = shooter:GetVelocity()
			-- if Velocity.z<-1 and not shooter.theVehicle then
				-- -- Hud:AddMessage(shooter:GetName()..": Velocity.z: "..Velocity.z)
				-- if self.OutOfBinocularsTime then
					-- if _time > self.OutOfBinocularsTime then
						-- ClientStuff.vlayers:DeactivateLayer("Binoculars")
						-- stats.bForceWalk = nil
					-- end
				-- else
					-- self.OutOfBinocularsTime = _time + .5
				-- end
			-- else
				-- self.OutOfBinocularsTime = nil
				-- stats.bForceWalk = nil
			-- end
		-- elseif self.OutOfBinocularsTime then
			-- self.OutOfBinocularsTime = nil
		-- end
		-- Mixer: stats.underwater optimization:
		if (stats.underwater~=0) then
			-- stop reloading
			if (stats.reloading) and (shooter.playingReloadAnimation) then
				self:ResetAnimation(0)
				shooter.playingReloadAnimation = nil
			end
			-- check if we are entering water
			if (shooter.prevUnderwater==0) then
				-- stop the fireloop
				BasicWeapon.Client.OnStopFiring(self,shooter)
			end
			-- track underwater state
			shooter.prevUnderwater = 1
		else
			shooter.prevUnderwater = 0
		end

		-- [marcok] please leave this code in
		local transition
		-- if ((stats:IsSwimming() and stats:IsSwimming()~=shooter.prevSwimming) or
		-- ((stats.moving or stats.running) and (stats.moving or stats.running)~=shooter.prevMoving)) then
		if ((stats:IsSwimming() and stats:IsSwimming()~=shooter.prevSwimming)) then									--IronSights
			transition = 1
		end

		shooter.prevSwimming = stats:IsSwimming()
		shooter.prevMoving = (stats.moving or stats.running)
		-----
		-- Main Player Specific Behavior
		-----
		local CurWeapon = stats.weapon
		stats.dmgFireAccuracy = 100
		-- Idle / fidget animations
		if (self.bDisableIdle==nil) then
			if (self:IsAnimationRunning()==nil or (transition and not shooter.playingReloadAnimation)) then
				shooter.playingReloadAnimation = nil
				-- Once he begins swimming in the water (using the movement keys
				-- while on top of the water), the player arms will immediately switch
				-- to a swimming animation, denying him the ability to shoot his gun unless
				-- he stands still.
				if (stats:IsSwimming() and (stats.moving or stats.running)) then
					local blend = 0
					if (transition) then
						blend = .3
					end
					BasicWeapon.RandomAnimation(self,"swim",shooter.firemodenum, blend)
					self.nextfidgettime = nil
				else
					if (not stats.firing) then
--------------------IronSights: Begin--------------------
						-- Шаг 2
						local IronSights = getglobal("g_enableironsights")
						if (IronSights and IronSights>="1") then
							if self.anim_table and self.SetAnimationFrame then -- Почему-то на отсутствие второго ругалось.
								self:SetAnimationFrame(self.anim_table[shooter.firemodenum]["idle"][1],1)
							end
						else
							if (self.nextfidgettime) and (self.nextfidgettime < _time) then -- Отсюда и до статса вернуть.
								BasicWeapon.RandomAnimation(self,"fidget",shooter.firemodenum)
								self.nextfidgettime = nil
							elseif (stats.aiming) and self.anim_table and (self.anim_table[shooter.firemodenum]) and (self.anim_table[shooter.firemodenum].aiming) then
								-- Mixer: support for aiming anim, if present...
								BasicWeapon.RandomAnimation(self,"aiming",shooter.firemodenum, .3)
							else
								BasicWeapon.RandomAnimation(self,"idle",shooter.firemodenum, .3)
							end
							if (stats.moving) or (stats.running) or (stats.aiming) then
								self.nextfidgettime = _time + random(30,40)
							end
						end
-------------------- IronSights: End --------------------
					end
				end
			end
		end
	end
end

function BasicWeapon:Hide(shooter)
	if shooter==_localplayer then
		shooter.cnt.drawfpweapon = nil
		self:ResetAnimation(0)
		if (shooter.cnt.aiming) then
			ClientStuff.vlayers:DeactivateLayer("WeaponScope")
		end
	end
end

function BasicWeapon:Show(shooter)
	if shooter==_localplayer then
		shooter.cnt.drawfpweapon = 1
	end
end

function BasicWeapon:AllowShootOrNo(shooter) -- Можно добавить задержку перед выстрелов с подствола или отсчитывать время от того, сколькоко игрок находится в прямой видимости чтобы себя не подстреливали...
	if ClientStuff.GamePaused then BasicWeapon.Client.OnStopFiring(self,shooter) return 1 end
	-- if not BasicPlayer.IsAlive(shooter) then System:Log(shooter:GetName()..": do not shoot on die") return 1 end -- Может это исправит зацикливание звука... Не помогло.
	if shooter.current_mounted_weapon and not shooter.ThisIsMortar then
		shooter.current_mounted_weapon.OnPressFire=1
		if shooter.current_mounted_weapon.fireOn==0 then
			-- Hud:AddMessage(shooter:GetName()..": return 1")
			-- System:Log(shooter:GetName()..": return 1")
			return 1 -- Стационарное орудие. Должно возвращать еденицу, чтобы вообще стреляло.
		end
	end
	if shooter.ai then
		local fDistance
		local att_target = AI:GetAttentionTargetOf(shooter.id)
		if att_target and type(att_target)=="table" then
			local TargetPos = att_target:GetPos()
			fDistance = shooter:GetDistanceFromPoint(TargetPos)
			if shooter.AiPlayerDoNotShoot and (att_target.WasInCombat or att_target.sees~=0
			-- if shooter.AiPlayerDoNotShoot and (att_target.WasInCombat or att_target.sees~=0 or (att_target.Behaviour and att_target.Behaviour.Name and (strfind(strlower(att_target.Behaviour.Name))=="attack"
			-- or strfind(strlower(att_target.Behaviour.Name))=="hold" or strfind(strlower(att_target.Behaviour.Name))=="hunt"))
			or (att_target.sees==0 and att_target.not_sees_timer_start~=0) or att_target.RunToTrigger) then
				local EnemySeenPlayer
				local EnemySeenMe
				local Chat
				local Chat2
				local t_att_target = AI:GetAttentionTargetOf(att_target.id)
				if t_att_target and type(att_target)=="table" then
					if t_att_target==_localplayer then
						EnemySeenPlayer = 1
					elseif t_att_target==shooter then
						EnemySeenMe = 1
					end
				end
				local rnd = random(1,3)
				if rnd==1 then
					Chat = "@ThatIsCrap"
				elseif rnd==2 then
					Chat = "@Crap"
				elseif rnd==3 then
					Chat = "@Ahhh"
				else
					Chat = "@Congratulations"
				end
				rnd = random(1,13)
				if rnd==1 then
					Chat2 = "@WeNoticed"
				elseif rnd==2 then
					Chat = "@GetDown"
					Chat2 = ""
				elseif rnd==3 then
					Chat = "@Ahhh"
					Chat2 = ""
				elseif rnd==4 then
					Chat = "@LookOut"
					Chat2 = ""
				elseif rnd==5 then
					Chat = "@Caution"
					Chat2 = ""
				elseif rnd==6 then
					Chat = "@Shoot"
					Chat2 = ""
				elseif rnd==7 then
					Chat = "@OpenFire"
					Chat2 = ""
				elseif rnd==8 then
					Chat = "@IOpenedFireOnHim"
					Chat2 = ""
				else
					if EnemySeenPlayer then
						Chat2 = "@YouNoticed"
					elseif EnemySeenMe then
						Chat2 = "@INoticed"
					else
						Chat2 = "@SomeoneNoticed"
					end
				end
				-- if Chat==Chat2 then
					-- Chat2 = ""
				-- end
				if shooter:GetDistanceFromPoint(_localplayer:GetPos()) <= 30+random(0,30) then
					Hud:AddMessage(shooter:GetName().."$1: "..Chat.." "..Chat2)
				end
				-- AI:Signal(0,1,"OnPlayerSeen",shooter.id)
				AIBehaviour.AIPlayerIdle:OnPlayerSeen(shooter,fDistance)
				shooter.AiPlayerDoNotShoot = nil
			end
			if shooter.AllowVisible==0 or att_target.IsCaged==1 or shooter.AiPlayerDoNotShoot or ((shooter.DoNotShootOnFriendInWayStart
			or shooter.DoNotShootOnFriendsOnTarget or shooter.DoNotShootOnFriendsOnClose) and shooter.fireparams.fire_mode_type~=FireMode_Melee)
			or shooter.Properties.species==att_target.Properties.species or shooter.OnConversationFinishedStart or shooter.cnt.flying then -- att_target - значение берётся у цели, не забывай!
				if shooter == _localpalyer then
					-- Hud:AddMessage(shooter:GetName()..": return 2")
					System:Log(shooter:GetName()..": return 2")
				end
				return 1
			end
			if shooter.DoNotShootAGrenadeLauncherIfNoGoalStart then
				shooter:InsertSubpipe(0,"devalue_target") -- Лучше именно здесь, чтобы забывали про ракеты только когда сами стреляют чтом-то подобным.
				return 1
			end
			if self.name=="RL" or self.name=="COVERRL" then
				if fDistance<15 then -- Не стрелять, если в руках РЛ и цель слишком близко. Это опасно для жизни. Обычно 20, но тут как бы элемент случайности, если цель ближе.
					shooter:InsertSubpipe(0,"retreat_on_close",att_target.id) -- Человек переключает на эту рл или ковер рл по расстоянию, но стрелять вблизи нельзя и переключается на руки, а они сближают...
					-- Hud:AddMessage(shooter:GetName()..": return 3")
					-- System:Log(shooter:GetName()..": return 3")
					-- if self.name=="COVERRL" then
						-- System:Log(shooter:GetName()..": Big select next weapon on fDistance<15")
						-- shooter.cnt:SelectNextWeapon()
					-- end
					return 1 -- Запрещает стрелять пока мерк не отойдёт на безопасное расстояние. Добавить ещё проверку вектора.
				else
					if AI:IsMoving(shooter.id) then
						AI:EnablePuppetMovement(shooter.id,0,2)
					end
				end
			elseif shooter.Properties.fileModel=="Objects/characters/mutants/mutant_big/mutant_big.cgf" then
				if AI:IsMoving(shooter.id) then
					AI:EnablePuppetMovement(shooter.id,0,2)
				end
			end
			if self.name=="SniperRifle" then
				if fDistance>30 then
					if AI:IsMoving(shooter.id) then
						AI:EnablePuppetMovement(shooter.id,0,2)
					end
				end
			end
			local Pos = shooter:GetPos()
			local IsPointInWater = Game:IsPointInWater(Pos)
			if IsPointInWater and not shooter.cnt:IsSwimming() and shooter.fireparams.fire_mode_type~=FireMode_Melee then
				AI:EnablePuppetMovement(shooter.id,0,2)
			end
			if shooter.fireparams.fire_mode_type==FireMode_Projectile and self.name~="SniperRifle" and self.name~="RL" and self.name~="COVERRL" then -- Может перекрывать то, что выше написано.
				AI:EnablePuppetMovement(shooter.id,0,2)
				shooter:InsertSubpipe(0,"just_shoot") -- Чтобы с подствольников себя не подстреливали.
			end
			-- if not shooter.AimLook then -- Дурацкая херня. Не всегда нужно глядеть через прицел чтобы начать стрелять...
			-- Hud:AddMessage(shooter:GetName()..": return 4")
			-- System:Log(shooter:GetName()..": return 4")
			-- return 1 end
		else -- Если цель не видно.
			local Current_AmmoType  -- Тип патронов.
			local Current_Ammo  -- Их количество в запасе.
			local Current_FireModeType  -- Режим огня.
			Current_AmmoType = shooter.fireparams.AmmoType
			Current_Ammo = shooter.Ammo[Current_AmmoType]
			Current_FireModeType = shooter.fireparams.fire_mode_type
			if Current_FireModeType~=FireMode_Melee and Current_FireModeType~="Unlimited" then
				for i,val in MaxAmmo do
					if i==Current_AmmoType then
						if Current_Ammo<=val/2 then
							shooter:InsertSubpipe(0,"just_shoot") -- Прекратить "тупо стрелять", если патронов меньше половины от максимума. Это сделал из-за командиров, которые приказывают постоянно подавлять...
							break
						end
					end
				end
			end
		end
		if fDistance and shooter.NotAllowMeleeShoot and fDistance<=shooter.NotAllowMeleeShoot then shooter.NotAllowMeleeShoot = nil end -- А это чтобы сразу били если цель всё-таки ближе подошла и управлялка оружием не успела обновиться.
		if shooter.NotAllowMeleeShoot then
		-- Hud:AddMessage(shooter:GetName()..": return 5")
		-- System:Log(shooter:GetName()..": return 5")
		return 1 end
		if fDistance and self.FireParams[shooter.cnt.firemode+1].DontUseWeaponOnMelee and fDistance<=self.FireParams[shooter.cnt.firemode+1].DontUseWeaponOnMelee then
		-- Hud:AddMessage(shooter:GetName()..": return 6")
		-- System:Log(shooter:GetName()..": return 6")
		-- if shooter.fireparams.fire_mode_type==FireMode_Projectile then
			-- Hud:AddMessage(shooter:GetName()..": OK!!!")
			-- System:Log(shooter:GetName()..": OK!!!")
		-- end
		return 1 end
	end
	-- System:Log(shooter:GetName()..": no return")
	return nil
end

function BasicWeapon.Server:OnFire(params)
	local retval
	local wi
	local ammo
	local shooter = params.shooter
	local stats = shooter.cnt
	local ammo_left
	if BasicWeapon.AllowShootOrNo(self,shooter) then return end
	--filippo: we dont want player shoot when in thirdperson and driving a vehicle without weapons (zodiac,paraglider,bigtruck)
	if not BasicWeapon.CanFireInThirdPerson(self,shooter) then return end

	-- if shooter has killer flag - damage LocalPlayer with every shot
	-- Это чтобы вертолёт, следящий за границами карты, мог быстро убить игрока.
	if (shooter and shooter.killer) then
		local hit = params
		hit.damage = 100
		hit.damage_type = "normal"
		hit.target = _localplayer
		hit.landed = 1
		_localplayer:Damage(hit)
	end

	if (shooter.fireparams.AmmoType=="Unlimited") then
		wi = nil  -- unl. ammo token
		FireModeNum = 1
		ammo = 1
		ammo_left = 1
	else
		wi = shooter.weapon_info
		-- mixer: burst mode support
		if (shooter.fireparams.burst) then
			stats.ammo_in_clip=stats.ammo_in_clip-shooter.fireparams.burst+1
			if (stats.ammo_in_clip < 0) then stats.ammo_in_clip=0  end
		end
		ammo = stats.ammo_in_clip
		ammo_left = stats.ammo
	end

	if (ammo_left > 0 or ammo > 0) then
		if (ammo > 0) then
			-- Substract ammunition
			if tostring(self.name)=="RL" then
				if toNumberOrZero(getglobal("gr_norl"))==1 then
					return
				end
			end
			if (SVplayerTrack) and (Game:IsMultiplayer()) then
				local ss=MPStatistics:_GetServerSlotOfResponsiblePlayer(shooter)
				if (ss) then
					SVplayerTrack:SetBySs(ss,"bulletsfired", 1, 1)
				end
			end
			if (wi) then
				stats.ammo_in_clip = stats.ammo_in_clip - params.bullets
				ammo = stats.ammo_in_clip
			end

			local AISound = AIWeaponProperties[self.name]
			local ss = shooter.fireparams.specific  -- Для того чтобы задать режиму огня специфическую для него "громкость" или расстояние на котором ИИ услышит выстрелы. Добавьте в параметры режима: "specific = "имя"", где имя - название соответствующей таблицы в файле AIWeapons.lua.
			if ss then
				-- Hud:AddMessage("ss: "..ss)
				AISound = AIWeaponProperties[ss]
			end
			if shooter.fireparams and shooter.fireparams.SoundMinMaxVol then -- Временно.
				AISound.VolumeRadius = (shooter.fireparams.SoundMinMaxVol[2]+shooter.fireparams.SoundMinMaxVol[3])/2.2 -- Короче, расстояние равно среднему двух чисел. А то отдельно трудно подобрать как далеко ИИ услышит.
			end
			if (AISound and (shooter.sounddata.FireSounds or shooter.sounddata.FireLoop)) then
				-- generate event
				-- local MyPos = shooter:GetPos()
				-- Hud:AddMessage(shooter:GetName()..": MyPos: x: "..MyPos.x..", y: "..MyPos.y..", z: "..MyPos.z)
				-- System:Log(shooter:GetName()..": MyPos: x: "..MyPos.x..", y: "..MyPos.y..", z: "..MyPos.z)
				if (shooter.sounddata.FireLoop) then
					AI:SoundEvent(shooter.sounddata.FireLoop,shooter:GetPos(),AISound.VolumeRadius,AISound.fThreat,0,shooter.id)
				else
					AI:SoundEvent(shooter.sounddata.FireSounds[1],shooter:GetPos(),AISound.VolumeRadius,AISound.fThreat,0,shooter.id)
				end
				-- this should not generate any error in multiplayer
			end
			retval = 1
		end

		-- AI EVENT clip nearly empty
		-- triggered if ammo in clip is less than 30% of total clip size
		-- Mixer: this is improved now to reduce CPU usage (check if ai or bot first).
		if (shooter.cis_wpn_nevalue) and (ammo==shooter.cis_wpn_nevalue) then
			AI:Signal(0,1,"OnClipNearlyEmpty",shooter.id)
		end
		------
		if (ammo_left==0) and (ammo==0) and (self.switch_on_empty_ammo==1) then -- Без self.switch_on_empty_ammo==1 пушка исчезает из инвентаря.
			stats:MakeWeaponAvailable(self.classid,0)
			if (BasicPlayer.AddPlayerHands) then
				BasicPlayer.AddPlayerHands(shooter)
			end
			stats:SelectFirstWeapon()
			AI:SoundEvent(shooter.id,shooter:GetPos(),3,.5,.5,shooter.id)
		end
	end

	if (retval==1 and shooter and shooter.invulnerabilityTimer) then
		shooter.invulnerabilityTimer=0
	end

	if (retval==nil) then
		 --play dry sounds that AI can heard
		AI:SoundEvent(shooter.id,shooter:GetPos(),3,.5,.5,shooter.id) -- Исправить: пока не отпустишь кнопку стрельбы, ии будет реагировать на этот звук.
	end
	-- Return value indicates if weapon can fire
	return retval
end

function BasicWeapon:PlayShellsEjectionSound(shooter,material_field)
	local material=shooter.cnt:GetTreadedOnMaterial()
	if material then
		local BulletHitZOffset=-1 -- offset from gun to play the bullet-hit sound from...
		local BulletHitPos = shooter:GetPos()
		BulletHitPos.z=BulletHitPos.z+BulletHitZOffset
		ExecuteMaterial(BulletHitPos,g_Vectors.v001,material[material_field],1)
	end
end

function BasicWeapon.Client:OnStopFiring(shooter)
	shooter.IShoot = nil
	if shooter.current_mounted_weapon and not shooter.ThisIsMortar then
		shooter.current_mounted_weapon.OnPressFire=nil
	end
	BasicWeapon.StopFireLoop(self,shooter,shooter.fireparams,shooter.sounddata)
	if shooter.cnt.canfire then
		if shooter==_localplayer then
			if shooter.bFired_Sht then
				if (shooter.fireparams.BulletRejectType==BULLET_REJECT_TYPE_RAPID) then
					BasicWeapon.PlayShellsEjectionSound(self,shooter,"bullet_drop_rapid")
				elseif (shooter.fireparams.BulletRejectType==BULLET_REJECT_TYPE_SINGLE) then
					BasicWeapon.PlayShellsEjectionSound(self,shooter,"bullet_drop_single")
				end
				shooter.bFired_Sht = nil
			end
		else
			-- Disable MuzzleFlash.
			local MuzzleFlashParams = shooter._MuzzleFlashParams
			if (MuzzleFlashParams) then
				BasicWeapon.ShowMuzzleFlash(MuzzleFlashParams.weapon,MuzzleFlashParams,0)
			end
		end
	end
	self.bPlayedDrySound = nil
end

function BasicWeapon.Client:OnFire(Params)
	local basic_weapon = BasicWeapon
	local my_player = _localplayer
	local shooter = Params.shooter
	local sound = Sound
	local cur_time = _time
	local ReturnVal = nil
	local FireModeNum
	local WeaponStateData = shooter.weapon_info
	local CurFireParams
	local stats = shooter.cnt
	local scope = ClientStuff.vlayers:IsActive("WeaponScope")

	if BasicWeapon.AllowShootOrNo(self,shooter) then return end

	self.nextfidgettime = nil

	if (shooter.fireparams.burst) then
		shooter.cis_burst_avail = shooter.cnt.ammo_in_clip * 1
	else
		shooter.cis_burst_avail = nil
	end

	if (stats==nil or stats.weaponid==nil) then
		return
	end

	if not BasicPlayer.IsAlive(shooter) then
		return
	end

	if tostring(self.name)=="RL" then
		if toNumberOrZero(getglobal("gr_norl"))==1 then
			return
		end
	end
	-- For mounted weapons or other unlimited ammo weapons
	if (self.FireParams[1].AmmoType=="Unlimited") then
		CurFireParams = self.FireParams[1]
	else
		CurFireParams = shooter.fireparams
	end

	--filippo: we dont want player shoot when in thirdperson and driving a vehicle without weapons (zodiac,paraglider,bigtruck)
	if (not BasicWeapon.CanFireInThirdPerson(self,shooter,CurFireParams)) then
		--stop fire sounds and everything else need when player stop fire
		BasicWeapon.Client.OnStopFiring(self,shooter)
		return
	end

	--[kirill]
	--fixme - marko, need unlimited ammo for gunners in heli
	if (shooter.fireparams.AmmoType=="Unlimited") then
		self.bPlayedDrySound = nil
	else
		if (not shooter.cnt.canfire) then
			if (not self.bPlayedDrySound and shooter.sounddata.DrySound and sound:IsPlaying(shooter.sounddata.DrySound)==nil) then
				if Hud and Hud.SharedSoundScale~=0 then
					shooter.cnt:PlaySound(shooter.sounddata.DrySound)
				end
				self.bPlayedDrySound = 1
				-- if shooter.ai then
					-- if random(1,5)==1 then
						-- Hud:AddMessage(shooter:GetName().."$1: BasicWeapon/Client:OnFire/CAN NOT FIRE")
						-- System:Log(shooter:GetName().."$1: BasicWeapon/Client:OnFire/CAN NOT FIRE")
						-- AI:Signal(0,1,"SHARED_RELOAD",shooter.id)
					-- end
				-- end
			end
			return
		else
			self.bPlayedDrySound = nil
		end
	end
	-- Play animation. Mixer: aim fire animation support, if present...
	if (shooter.cnt.first_person) and (not self.rotor_barrel) then
		self:ResetAnimation(0)
		if shooter.cnt.aiming and self.anim_table and self.anim_table[shooter.firemodenum] and self.anim_table[shooter.firemodenum].aimfire then
			BasicWeapon.RandomAnimation(self,"aimfire",shooter.firemodenum)
		else
			BasicWeapon.RandomAnimation(self,"fire",shooter.firemodenum)
		end
	end
	-- if (shooter==my_player) then
-- --------------------IronSights: Begin--------------------
		-- local IronSights = getglobal("g_enableironsights")
		-- if ((not shooter.cnt.aiming) or (shooter.fireparams.RecoilAnimPos==nil) or (shooter.fireparams.RecoilAnimAng==nil) or (IronSights and IronSights=="0") then
			-- BasicWeapon.RandomAnimation(self,"fire",shooter.firemodenum)
		-- else
			-- self.cnt:AffectWeaponVelocity(shooter.fireparams.RecoilAnimPos, shooter.fireparams.RecoilAnimAng)
		-- end
-- -------------------- IronSights: End --------------------
	-- end
	shooter.bFired_Sht = 1
	shooter.IShoot = 1
	-- Obtain the muzzle flash bone
	local fire_pos = Params.pos
	local bMountedWeapon = shooter.cnt.lock_weapon
	local bVehicleWeapon = CurFireParams.vehicleWeapon
	local bHely = nil
	if (shooter.theVehicle and shooter.theVehicle.hely) then
		bVehicleWeapon = nil
		bHely = 1
	end
	if (bHely) or (bMountedWeapon) or (bVehicleWeapon) then
		fire_pos = shooter.cnt:GetTPVHelper(0, "spitfire")
	elseif ((stats.first_person and stats.weaponid > -1)) then
		if (bMountedWeapon) then -- mounted weapon - just get helper
			fire_pos = shooter.cnt:GetTPVHelper(0, "spitfire")
		else
			fire_pos = new(self.cnt:GetBonePos("spitfire"))
		end
	else
		if (self.object) and (shooter.ROCKET_ORIGIN_KEYFRAME==nil) then
			fire_pos = shooter.cnt:GetTPVHelper(0, "spitfire")
		else
			fire_pos = shooter:GetBonePos("weapon_bone")
			if (fire_pos) and (fire_pos.x==0) and (fire_pos.y==0) and (fire_pos.z==0) then
				fire_pos = nil
			end
		end
	end

	 if not fire_pos then
		fire_pos = Params.pos
	 end

	-- when we are looking through a weapon scope, the trail should come from the center
	local vShooterPos = shooter:GetPos()
	if (scope) and (not self.AimMode) and (shooter.cnt.first_person) then
		local vCamPos = my_player:GetCameraPosition()
		FastDifferenceVectors(vCamPos, vCamPos, vShooterPos)
		ScaleVectorInPlace(vCamPos, .9)
		fire_pos = SumVectors(vShooterPos, vCamPos)
		self.bw_mf_for_scope = 1
	end
	-- Fire sound
	if CurFireParams.FireLoop or CurFireParams.FireLoopStereo then
		-- Sound is modelled as a loop with a trailoff
		-- [marco] play stereo sounds for localplayer
		local RndPitching = random(1,150) -- Слегка менять высоту тона у звуков стрельбы, получается небольшой эффект замедления...
		if not shooter.sounddata.TrailOffStereo and not shooter.sounddata.TrailOff then -- Тут у пуль цельный звук стрельбы и окончания.
			local PlayThisSoundStereoIndoor
			local PlayThisSoundIndoor
			local PlayThisSoundStereo
			local PlayThisSound
			local IsIndoors = System:IsPointIndoors(vShooterPos) -- Кстати, у Миксера же тоже есть такая фишка со звуком внутри и снаружи...
			if type(shooter.sounddata.FireLoopStereoIndoor)=="table" and IsIndoors then -- От первого лица, в помещении.
				PlayThisSoundStereoIndoor = shooter.sounddata.FireLoopStereoIndoor[random(1,getn(shooter.sounddata.FireLoopStereoIndoor))] -- Случайное из таблицы.
			elseif type(shooter.sounddata.FireLoopStereo)=="table" then -- Снаружи.
				PlayThisSoundStereo = shooter.sounddata.FireLoopStereo[random(1,getn(shooter.sounddata.FireLoopStereo))]
			end
			if type(shooter.sounddata.FireLoopIndoor)=="table" and IsIndoors then -- От третьего лица, в помещении.
				PlayThisSoundIndoor = shooter.sounddata.FireLoopIndoor[random(1,getn(shooter.sounddata.FireLoopIndoor))]
			elseif type(shooter.sounddata.FireLoop)=="table" then -- Снаружи.
				PlayThisSound = shooter.sounddata.FireLoop[random(1,getn(shooter.sounddata.FireLoop))]
			end
			if PlayThisSoundStereoIndoor and shooter.cnt.first_person then -- От первого лица, в помещении.
				for i,val in shooter.sounddata.FireLoopStereoIndoor do if sound:IsPlaying(val) then sound:StopSound(val) end end -- Предыдущий звук останавливаем.
				Sound:SetSoundPitching(PlayThisSoundStereoIndoor,RndPitching)
				shooter.cnt:PlaySound(PlayThisSoundStereoIndoor) -- И включаем новый. В отличии от оригинала, он проигрывается всего один раз. А может, это и есть решение проблемы с зацикливанием звука стрельбы?
			elseif PlayThisSoundIndoor and not shooter.cnt.first_person then -- От третьего лица, в помещении.
				for i,val in shooter.sounddata.FireLoopIndoor do if sound:IsPlaying(val) then sound:StopSound(val) end end
				Sound:SetSoundPitching(PlayThisSoundIndoor,RndPitching)
				if Hud and Hud.SharedSoundScale~=0 then
					shooter.cnt:PlaySound(PlayThisSoundIndoor)
				end
			elseif PlayThisSoundStereo and shooter.cnt.first_person then -- От первого лица, снаружи.
				for i,val in shooter.sounddata.FireLoopStereo do if sound:IsPlaying(val) then sound:StopSound(val) end end
				Sound:SetSoundPitching(PlayThisSoundStereo,RndPitching)
				shooter.cnt:PlaySound(PlayThisSoundStereo)
			elseif PlayThisSound and not shooter.cnt.first_person then -- От третьего лица, снаружи.
				for i,val in shooter.sounddata.FireLoop do if sound:IsPlaying(val) then sound:StopSound(val) end end
				Sound:SetSoundPitching(PlayThisSound,RndPitching)
				if Hud and Hud.SharedSoundScale~=0 then
					shooter.cnt:PlaySound(PlayThisSound)
				end
			else -- Фиксированное.
				if shooter.sounddata.FireLoopStereo and shooter.cnt.first_person then
					if sound:IsPlaying(shooter.sounddata.FireLoopStereo) then sound:StopSound(shooter.sounddata.FireLoopStereo) end
					Sound:SetSoundPitching(shooter.sounddata.FireLoopStereo,RndPitching)
					shooter.cnt:PlaySound(shooter.sounddata.FireLoopStereo)
				else
					if sound:IsPlaying(shooter.sounddata.FireLoop) then sound:StopSound(shooter.sounddata.FireLoop) end
					Sound:SetSoundPitching(shooter.sounddata.FireLoop,RndPitching)
					if Hud and Hud.SharedSoundScale~=0 then
						shooter.cnt:PlaySound(shooter.sounddata.FireLoop)
					end
				end
			end
		else -- Тут оригинальное.
			if shooter.sounddata.FireLoopStereo and shooter.cnt.first_person then
				if not sound:IsPlaying(shooter.sounddata.FireLoopStereo) then
					sound:SetSoundLoop(shooter.sounddata.FireLoopStereo,1)
					Sound:SetSoundPitching(shooter.sounddata.FireLoopStereo,RndPitching)
					shooter.cnt:PlaySound(shooter.sounddata.FireLoopStereo)
				end
			else
				if shooter.sounddata.FireLoop and not sound:IsPlaying(shooter.sounddata.FireLoop) then
					sound:SetSoundLoop(shooter.sounddata.FireLoop,1)
					Sound:SetSoundPitching(shooter.sounddata.FireLoop,RndPitching)
					if Hud and Hud.SharedSoundScale~=0 then
						shooter.cnt:PlaySound(shooter.sounddata.FireLoop)
					end
				end
			end
		end
	else -- Подствольнки.
		-- Sound is modelled as a random series of different fire sounds
		local nSoundIdx = random(1,getn(shooter.sounddata.FireSounds)) -- Пилять, тоже самое!
		-- [marco] play stereo sounds for localplayer
		if shooter.sounddata.FireSoundsStereo and shooter.cnt.first_person then
			Sound:SetSoundPitching(shooter.sounddata.FireSoundsStereo[nSoundIdx],RndPitching)
			shooter.cnt:PlaySound(shooter.sounddata.FireSoundsStereo[nSoundIdx])
		else
			Sound:SetSoundPitching(shooter.sounddata.FireSounds[nSoundIdx],RndPitching)
			if Hud and Hud.SharedSoundScale~=0 then
				shooter.cnt:PlaySound(shooter.sounddata.FireSounds[nSoundIdx])
			end
		end
	end
	-- sound event for the radar
	local AISound = AIWeaponProperties[self.name]
	local ss = shooter.fireparams.specific
	if ss then
		AISound = AIWeaponProperties[ss]
	end
	if shooter.fireparams and shooter.fireparams.SoundMinMaxVol then
		AISound.VolumeRadius = (shooter.fireparams.SoundMinMaxVol[2]+shooter.fireparams.SoundMinMaxVol[3])/2.2
	end
	if (AISound) then
		-- AI:FreeSignal(-1,"WakeUp",shooter:GetPos(),AISound.VolumeRadius/2,self.id)
		-- AI:FreeSignal(-1,"WakeUp2",shooter:GetPos(),AISound.VolumeRadius/2,self.id)
		Game:SoundEvent(shooter:GetPos(),AISound.VolumeRadius,AISound.fThreat,shooter.id)
	end
	-- Use a temporary member table to avoid a table creation
	local vDirection = basic_weapon.temp_dir
	local hasFakeHit = 0
	if (Params.HitPt==nil or (Params.HitPt.x==0 and Params.HitPt.y==0 and Params.HitPt.z==0)) then
		hasFakeHit = 1
		CopyVector(vDirection,Params.dir)
		ScaleVectorInPlace(vDirection, basic_weapon.VoidDist)
		vDirection.x = vDirection.x + Params.pos.x - fire_pos.x
		vDirection.y = vDirection.y + Params.pos.y - fire_pos.y
		vDirection.z = vDirection.z + Params.pos.z - fire_pos.z
	else
		local pt = Params.HitPt
		vDirection.x = pt.x - fire_pos.x
		vDirection.y = pt.y - fire_pos.y
		vDirection.z = pt.z - fire_pos.z
	end
	-- Spawn a trail
	-- if not (tonumber(w_firstpersontrail)==0 and shooter.cnt.first_person) and (tonumber(getglobal("game_DifficultyLevel"))<2 or self.name=="MG" or self.name=="Mortar") then
	local NewMode = tonumber(getglobal("game_NewShootingMode"))
	-- if not (tonumber(w_firstpersontrail)==0 and shooter.cnt.first_person) and tonumber(getglobal("game_DifficultyLevel"))<2 and (CurFireParams.fire_mode_type~=FireMode_Bullet or (NewMode and NewMode~=1)) then
	if not (tonumber(w_firstpersontrail)==0 and shooter.cnt.first_person) and (CurFireParams.fire_mode_type~=FireMode_Bullet or (NewMode and NewMode~=1)) then -- Лучше пусть трасеры будут всегда, тем более, они сейчас быстро проносятся.
		local trace = CurFireParams.Trace
		if (trace) then
			-- moving trace
			trace.init_angles = basic_weapon.temp_angles
			ConvertVectorToCameraAngles(trace.init_angles, vDirection)
			if (Params.HitDist==nil or Params.HitDist<0) then
				trace.lifetime = basic_weapon.VoidDist/trace.speed
			else
				trace.lifetime = Params.HitDist/trace.speed
			end
			--we don't want traces to bounce
			trace.bouncyness = 0
			trace.space_box = {x=0,y=0,z=0}
			if (vDirection.x<0) then trace.space_box.x = -vDirection.x else trace.space_box.x = vDirection.x end
			if (vDirection.y<0) then trace.space_box.y = -vDirection.y else trace.space_box.y = vDirection.y end
			if (vDirection.z<0) then trace.space_box.z = -vDirection.z else trace.space_box.z = vDirection.z end
			-- adding flag PART_FLAG_SPACELIMIT2048
			trace.particle_type = bor(trace.particle_type, 2048)

			local Current_AmmoInClip = shooter.cnt.ammo_in_clip
			local Current_BulletsPerClip = shooter.fireparams.bullets_per_clip
			local UseTrail
			local Number=Current_BulletsPerClip
			for i=1,Current_BulletsPerClip do
				-- System:Log(shooter:GetName()..": Number: "..Number..", Current_AmmoInClip: "..Current_AmmoInClip..", Current_BulletsPerClip: "..Current_BulletsPerClip..", i: "..i)
				if (Number==Current_AmmoInClip and Current_AmmoInClip>0) or (Number==Current_AmmoInClip and Current_AmmoInClip==0) then
					UseTrail=1 -- Каждые пять пуль, выпущеные из оружия, трассерные.
					-- Hud:AddMessage(shooter:GetName()..": UseTrail, Number: "..Number)
					break
				end
				if Number<Current_AmmoInClip then break end
				Number=Number-5
			end

			local AllowGenerateTrace
			if not shooter.GunTableOfRandomTrace then shooter.GunTableOfRandomTrace = {} AllowGenerateTrace = 1 end
			if not shooter.GunTableOfRandomTrace[WeaponClassesEx[self.name].id] then shooter.GunTableOfRandomTrace[WeaponClassesEx[self.name].id] = {} AllowGenerateTrace = 1 end
			if not shooter.GunTableOfRandomTrace[WeaponClassesEx[self.name].id].Color then shooter.GunTableOfRandomTrace[WeaponClassesEx[self.name].id].Color = {} AllowGenerateTrace = 1 end
			local TableColor = shooter.GunTableOfRandomTrace[WeaponClassesEx[self.name].id].Color
			for i,val in self.FireParams do
				if self.FireParams.AmmoType=="Pistol" then break end -- Пистолеты без трассеров.
				if val.Trace and val.Trace.geometry then
					-- val.Trace.speed=.1 -- Замедление скорости только для теста.
					local Color
					if AllowGenerateTrace then
						if random(1,2)==1 then
							Color="RED"
						else
							Color="GREEN"
						end
					else
						Color = TableColor[i]
					end
					if i>1 and self.FireParams[i].AmmoType==self.FireParams[1].AmmoType then -- На всякий случай. Может чуть неправильно работать...
						if TableColor[i] and TableColor[1] and TableColor[i]~=TableColor[1] then -- Сделать чтобы тоже самое касалось и если начинать стрельбу со второго режима...
							TableColor[i] = TableColor[1]
							if i==shooter.firemodenum then -- Проверить.
								Color = TableColor[1]
							end
						end
					end
					if Color=="RED" then
						val.Trace.geometry=System:LoadObject("Objects/Weapons/p_tracer_r.cgf")
					elseif Color=="GREEN" then
						val.Trace.geometry=System:LoadObject("Objects/Weapons/p_tracer_g.cgf")
					end
					-- if UseTrail then
						-- Hud:AddMessage(shooter:GetName()..": Weapon: "..self.name..", Color: "..Color..", i: "..i)
						-- System:Log(shooter:GetName()..": Weapon: "..self.name..", Color: "..Color..", i: "..i)
					-- end
					TableColor[i] = Color
					-- if i>1 and self.FireParams[i].AmmoType==self.FireParams[1].AmmoType then -- На всякий случай. Может чуть неправильно работать...
						-- if TableColor[i] and TableColor[1] and TableColor[i]~=TableColor[1] then
							-- TableColor[i] = TableColor[1]
						-- end
					-- end
				end
			end
			local Difficulty = tonumber(getglobal("game_DifficultyLevel"))
			if UseTrail or Difficulty<2 then
				Particle:CreateParticle(fire_pos,vDirection,trace)
			end
		end
	end
	-- System:Log("self.RandomNumber: "..self.RandomNumber)
	--Particle system flags
	--#define PART_FLAG_BILLBOARD     0 // usual particle
	--#define PART_FLAG_HORIZONTAL    1 // flat horisontal rounds on the water
	--#define PART_FLAG_UNDERWATER    2 // particle will be removed if go out from outdoor water
	--#define PART_FLAG_LINEPARTICLE  4 // draw billboarded line from vPosition to vPosition+vDirection
	--#define PART_FLAG_SWAP_XY       8 // alternative order of rotation (zxy)
	--#define PART_SIZE_LINEAR       16 // change size liner with time
	--#define PART_FLAG_NO_OFFSET    32 // disable centering of static objects
	--#define PART_FLAG_DRAW_NEAR    64 // render particle in near (weapon) space

	--if ((shooter~=_localplayer) or (not scope) or (self.AimMode and scope)) then
	if (shooter) then
		-- Spawn smoke, bubbles, SpitFire etc.
		if (Game:IsPointInWater(Params.pos)==nil) then
			if (fire_pos) then
				--weaponfx
				local weaponfx = tonumber(getglobal("cl_weapon_fx"))
				local firstperson = stats.first_person
				--mounted and vehicle weapons ever act like we are in thirperson
				if (bMountedWeapon or bVehicleWeapon) then firstperson = nil  end
				--no smoke on low settings
				if (CurFireParams.SmokeEffect and weaponfx>0) then
					BasicWeapon:HandleParticleEffect(CurFireParams.SmokeEffect,fire_pos,vDirection,firstperson,weaponfx)
				end
				--if there is no partile muzzle effect or cl_weapon_fx is set to 0 use normal muzzleflashes.
				--FIXME:temporarly removed from default the particle muzzleflashes , everyone is complaining about them.
				--btw, still usable with cl_weapon_fx 3.
				if (CurFireParams.MuzzleEffect) and (weaponfx>2 or self.bw_mf_for_scope) then
					BasicWeapon:HandleParticleEffect(CurFireParams.MuzzleEffect,fire_pos,vDirection,firstperson,weaponfx)
					self.bw_mf_for_scope = nil
				elseif (CurFireParams.MuzzleFlash) then
					CurFireParams.MuzzleFlash.init_angles = Params.angles
					CurFireParams.MuzzleFlash.init_angles.y = random(0, 360)
					-- remember flags
					local flag = CurFireParams.MuzzleFlash.particle_type
					-- if first person - chcange it
					-- NEW MUZZLE FLASH
					if (not shooter._MuzzleFlashParams) then
						shooter._MuzzleFlashParams = {}
					end
					local MuzzleFlashParams = shooter._MuzzleFlashParams
					MuzzleFlashParams.weapon = self
					MuzzleFlashParams.shooter = shooter
					MuzzleFlashParams.bFirstPerson = nil
					MuzzleFlashParams.MuzzleFlash = CurFireParams.MuzzleFlash
					if (stats.first_person) then
						MuzzleFlashParams.bFirstPerson = 1
					else
						if (CurFireParams.MuzzleFlashTPV) then
							MuzzleFlashParams.MuzzleFlash = CurFireParams.MuzzleFlashTPV
						end
					end
					-- For mounted weapon.
					if (bMountedWeapon) then
						MuzzleFlashParams.weapon = shooter.current_mounted_weapon
						MuzzleFlashParams.shooter = shooter.current_mounted_weapon
					end
					if (bVehicleWeapon) then
						MuzzleFlashParams.weapon = self
						MuzzleFlashParams.shooter = self
						MuzzleFlashParams.bFirstPerson = nil
						VC.ShowMuzzleFlash(Params.shooter.theVehicle, MuzzleFlashParams, 1)
					else
						-- Check if muzzle flash for this shooter is already active.
						BasicWeapon.ShowMuzzleFlash(self,MuzzleFlashParams,1)
					end
				end
			end
		end

		-- Shell Cases
		if (CurFireParams.ShellCases) then
			if (CurFireParams.ShellCases.geometry) then
				local bFirstPerson = 0
				if (shooter==my_player) then
					if (shooter.cnt.first_person) and (shooter.cnt.weaponid > -1) then
						bFirstPerson = 1
					end
				end
				local ShellCaseExitPt
				if (bFirstPerson==1) then
					--filippo: if is a vehicle weapon use the helper.
					if (stats.lock_weapon) or (bVehicleWeapon) then -- mounted weapon - just get helper
						ShellCaseExitPt = stats:GetTPVHelper(0, "shells")
					else
						ShellCaseExitPt = new(self.cnt:GetBonePos("shells"))
					end
				else
					ShellCaseExitPt = stats:GetTPVHelper(0, "shells")
				end
				if (ShellCaseExitPt and CurFireParams.ShellCases) then
					--filippo
					CurFireParams.ShellCases.init_angles = Params.angles
					CurFireParams.ShellCases.rotation = BasicWeapon.temp.rotate_vector
					CurFireParams.ShellCases.rotation.x = random(-600,600)*.1
					CurFireParams.ShellCases.rotation.y = random(-600,600)*.1
					CurFireParams.ShellCases.rotation.z = random(-600,600)*.1
					CurFireParams.ShellCases.bouncyness = .25
					CurFireParams.ShellCases.focus = 10.5
					CurFireParams.ShellCases.speed = 1.5
					CurFireParams.ShellCases.particle_type = 32
					CurFireParams.ShellCases.physics = 1
					-- CurFireParams.ShellCases.lifetime = 1800 -- 900 - 10, 1800 - 30 минут жизни для shell'ов.
					-- CurFireParams.ShellCases.color_based_blending = 3 -- Не помогает с мерцанием в темноте.
					local vExitDirection = basic_weapon.temp_exitdir
					vExitDirection.x = Params.dir.y
					vExitDirection.y = -Params.dir.x
					vExitDirection.z = random(0,150)*.01
					Particle:CreateParticle(ShellCaseExitPt, vExitDirection, CurFireParams.ShellCases)
				else
					if self.name~="MutantMG" then -- Надо сделать сначала чтобы было откуда должны пули выпадать.
						System:Log("ERROR: Weapon '"..self.name.."' Shells/Bone missing, artists fix !")
					end
				end
			else
				System:Log("ERROR: No CGF File Specified For Shell Case Particle System !")
			end
		end
	end

	if (CurFireParams.ExitEffect) then
		Particle:SpawnEffect(fire_pos, vDirection, CurFireParams.ExitEffect, 1)
	end

	-- Spawn a trace of bubbles when underwater
	local doBubbles = 0
	-- check start point
	if (CurFireParams.fire_mode_type==FireMode_Instant and
		(Game:IsPointInWater(Params.pos) or (hasFakeHit==0 and Game:IsPointInWater(Params.HitPt))) and shooter~=my_player) then
		doBubbles = 1
	end

	if (tonumber(w_underwaterbubbles)==1 and doBubbles==1) then -- Добавить: не показывать, если мы режиме редактора.
		--ONLY IF IS UNDERWATER
		local vCurPosOnTrace=basic_weapon.temp_pos
		local vStep = Params.dir
		CopyVector(vCurPosOnTrace,Params.pos)
		ScaleVector(vStep, 3)
		for i=0, 30 do
			FastSumVectors(vCurPosOnTrace,vCurPosOnTrace, vStep)
			if (Game:IsPointInWater(vCurPosOnTrace)==nil) then
				if (i~=0) then break end
				-- at this point we have to calculate the intersection with the water plane
				local waterLevel = Game:GetWaterHeight()
				local d = vStep.z
				if (d > -.0001 and d < .0001) then break  end
				local t = -(vCurPosOnTrace.z-waterLevel)/d
				vCurPosOnTrace.x = vCurPosOnTrace.x + Params.dir.x * t
				vCurPosOnTrace.y = vCurPosOnTrace.y + Params.dir.y * t
				vCurPosOnTrace.z = vCurPosOnTrace.z + Params.dir.z * t
			end
			Particle:CreateParticle(vCurPosOnTrace, g_Vectors.v001, basic_weapon.TracerBubbles)
		end
	end
	--if underwater > 0 player is underwater
	if stats.underwater<=0 then
		--ONLY IF IS NOT UNDERWATER
		-- if ((shooter~=_localplayer) or (_localplayer.FlashLightActive==0)) then
		-- if shooter~=_localplayer then
			-- make light flash when weapon is used
			local doProjectileLight = tonumber(getglobal("cl_weapon_light"))
			if (CurFireParams.LightFlash and doProjectileLight==1) then -- no specular
				local diff=CurFireParams.LightFlash.vDiffRGBA
				shooter:AddDynamicLight(fire_pos,CurFireParams.LightFlash.fRadius,diff.r*.5,diff.g*.5,diff.b*.5,diff.a,0,0,0,0,
				CurFireParams.LightFlash.fLifeTime)
			elseif (CurFireParams.LightFlash and doProjectileLight==2) then -- with specular
				-- vPos, fRadius, DiffR, DiffG, DiffB, DiffA, SpecR, SpecG, SpecB, SpecA, fLifeTime
				local diff=CurFireParams.LightFlash.vDiffRGBA
				local spec=CurFireParams.LightFlash.vSpecRGBA
				shooter:AddDynamicLight(fire_pos,CurFireParams.LightFlash.fRadius,diff.r*.5,diff.g*.5,diff.b*.5,diff.a,spec.r*.5,spec.g*.5,spec.b*.5,spec.a,
				CurFireParams.LightFlash.fLifeTime)
			end
		-- end

		if (shooter~=_localplayer or shooter:GetDistanceFromPoint(Params.BulletPlayerPos)>10) and Params.BulletPlayerPos and (CurFireParams.whizz_sound or CurFireParams.generic_whizz) then -- Не знаю как это будет работать в мультиплеере.
		-- if shooter~=_localplayer and shooter:GetDistanceFromPoint(Params.BulletPlayerPos)>10+random(0,20) and Params.BulletPlayerPos and CurFireParams.whizz_sound then
			local bSkip
			if CurFireParams.whizz_probability then
				if random(0,1000)>CurFireParams.whizz_probability then bSkip=1 end
			end
			if not bSkip then
				local pWhizzSound
				if CurFireParams.generic_whizz~=1 and getn(CurFireParams.whizz_sound)>0 then
					pWhizzSound = CurFireParams.whizz_sound[random(1,getn(CurFireParams.whizz_sound))]
					-- Hud:AddMessage(shooter:GetName()..": no generic_whizz")
				else
					local RndSnd = shooter.sounddata.generic_whizz_sound[random(1,getn(shooter.sounddata.generic_whizz_sound))]
					-- Sound:SetSoundPitching(RndSnd,random(1,1000)) -- Работает ли?
					-- Sound:SetSoundPitching(RndSnd,random(1,1000)) -- Ахрененный эффект! Будто бы громкие взрывы вдалеке...
					-- Sound:SetSoundFrequency(RndSnd,random(1,1000)) -- Тот же эффект получается, по ходу дела. Но можно указать вручную.
					Sound:SetSoundPitching(RndSnd,random(1,200)) -- А этот автоматизированный, так что случайные числа бесполезны.
					pWhizzSound = RndSnd
					-- Hud:AddMessage(shooter:GetName()..": generic_whizz")
				end
				if pWhizzSound then
					Sound:SetSoundPosition(pWhizzSound,Params.BulletPlayerPos)
					Sound:PlaySound(pWhizzSound)
					shooter.pWhizzSound = pWhizzSound
				end
			end
		end
	end
	ReturnVal = 1

	if (self.DoesFTBSniping and (shooter==_localplayer)) then
		FTBSniping.OnFire(FTBSniping)
	end

	--filippo: apply view shake
	if (CurFireParams.weapon_viewshake and CurFireParams.weapon_viewshake > 0) then
		if (CurFireParams.weapon_viewshake_amt) then
			shooter.cnt:ShakeCameraL(CurFireParams.weapon_viewshake_amt, CurFireParams.weapon_viewshake, CurFireParams.fire_rate)
		else
			shooter.cnt:ShakeCameraL(CurFireParams.weapon_viewshake * .001, CurFireParams.weapon_viewshake, CurFireParams.fire_rate)
		end
	end

	return ReturnVal
end

function BasicWeapon.Server:OnHit(hit)
	-- augment hit table with damage type
	if (hit.shooter.fireparams.damage_type) then
		hit.damage_type = hit.shooter.fireparams.damage_type
	else
		hit.damage_type = "normal"
	end
	if (hit.target_material) then
		-- spawn client side effect
		if (hit.target and hit.target.type=="Player" and hit.damage_type=="normal" and hit.target.invulnerabilityTimer==nil) then
			if (Game:IsMultiplayer()) and (SVplayerTrack) then
				local ss=MPStatistics:_GetServerSlotOfResponsiblePlayer(hit.shooter)
				if ss then
					SVplayerTrack:SetBySs(ss,"bulletshit", 1 ,1)
				end
			end
			if BasicPlayer.IsAlive(hit.target) then
				Server:BroadcastCommand("FX", hit.pos, hit.normal, hit.shooter.id, 3)
			end
		end
		if hit.target_material.AI and hit.shooter then
			-- Hud:AddMessage(hit.shooter:GetName().."$1: Client:OnHit")
			AI:FreeSignal(1,"OnBulletRain",hit.pos,hit.target_material.AI.fImpactRadius,hit.shooter.id)
		end
	end
end

function BasicWeapon.Client:OnHit(hit)
	local shooter = hit.shooter
	if shooter.cis_burst_avail then
		if shooter.cis_burst_avail <= 0 then
			if shooter.sounddata.DrySound and not Sound:IsPlaying(shooter.sounddata.DrySound) then
				if Hud and Hud.SharedSoundScale~=0 then
					shooter.cnt:PlaySound(shooter.sounddata.DrySound)
				end
			end
			return
		else
			shooter.cis_burst_avail = shooter.cis_burst_avail - 1
		end
	end
	-- augment hit table with damage type
	if (shooter.fireparams.damage_type) then
		hit.damage_type = shooter.fireparams.damage_type
		if (hit.damage_type~="normal" and hit.damage_type~="building") then
			hit.target_material = nil
		end
	else
		hit.damage_type = "normal"
	end
	-- hit effect
	local effect="bullet_hit"
	if hit.target_material then
		if shooter and shooter.fireparams.mat_effect then
			effect=shooter.fireparams.mat_effect
			if effect=="mg_hit" and not hit.target_material[effect] then
				effect = "bullet_hit" -- Если эффекта для попадания из пулемёта не нашлось, то подменить его на попадание обычной пулей.
			end
			if not hit.target_material[effect] then
				hit.target_material = Game:GetMaterialBySurfaceID(Game:GetMaterialIDByName("mat_default"))
			end
		end
		if (hit.target and hit.target.type=="Player") then
			local doProjGore
			-- armor fx for heavy metal bad guys (saves performance in this case too)
			if (hit.target.ai) and (hit.target.Properties.fSpeciesHostility > 2) then
				hit.target_material = Game:GetMaterialBySurfaceID(Game:GetMaterialIDByName("mat_metal_plate"))
			else
				-- not use helmet material if no helmet
				if (hit.target_material.type=="helmet") then
					if (hit.target.hasHelmet==0) then
						hit.target_material = Game:GetMaterialBySurfaceID(Game:GetMaterialIDByName("mat_head"))
						doProjGore = 1
					end
					-- not use flesh material if player has armor -- Mixer
				elseif (hit.target_material.type=="flesh") then
						if (hit.target.cnt.armor <= 0) then
							doProjGore = 1
						else
							hit.target_material = Game:GetMaterialBySurfaceID(Game:GetMaterialIDByName("mat_armor"))
						end
					-- not use armor material if no armor -- Mixer
				elseif (hit.target_material.type=="armor") then
					if (hit.target.Properties.bHasArmor==0) then
						if (hit.target.cnt.armor <= 0) then
							hit.target_material = Game:GetMaterialBySurfaceID(Game:GetMaterialIDByName("mat_flesh"))
							doProjGore = 1
						end
					end
					-- has kevlar helmet? then change to mat_helmet -- Mixer
				elseif (hit.target_material.type=="head") then
					if (hit.target.items) and (hit.target.items.kevlarhelmet) then
						hit.target_material = Game:GetMaterialBySurfaceID(Game:GetMaterialIDByName("mat_helmet"))
					else
						doProjGore = 1
					end
				else
					doProjGore = 1
				end
			end
			-- draw blood decals on walls and terrain (not if we got hit by EngineerTool)
			if (doProjGore and hit.damage_type~="building") then
				BasicPlayer.DoProjectedGore(hit.target, hit)
			end
		end
		local MaterialSound
		MaterialSound = ExecuteMaterial2(hit,effect)
		if shooter.pWhizzSound and MaterialSound then
			if Sound:IsPlaying(shooter.pWhizzSound) and Sound:IsPlaying(MaterialSound) then
				Sound:StopSound(shooter.pWhizzSound) -- Прекращать звук свиста когда звучит звук попадания по поверхности.
				-- Hud:AddMessage(shooter:GetName()..": Stop Whizz Sound")
				-- System:Log(shooter:GetName()..": Stop Whizz Sound")
			end
		end
		hit.suppressParticleEffect = nil
		-- light on hit solid surfaces
		if hit.target_material.litespark and effect=="bullet_hit" and random(1,3)==3 then
			shooter:AddDynamicLight(hit.pos, .7, 1, 1, .7, 1, 1, 1, .7, 1, .15)
		end
	end
end

function BasicWeapon.Server:OnEvent(EventId, Params)
	local EventSwitch=BasicWeapon.Server_EventHandler[EventId]
	if (EventSwitch) then
		return EventSwitch(self,Params)
	end
end

function BasicWeapon.Client:OnEvent(EventId, Params)
	--System:Log("BasicWeapon.Client:OnEvent "..EventId)
	local EventSwitch=BasicWeapon.Client_EventHandler[EventId]
	if (EventSwitch) then
		return EventSwitch(self,Params)
	end
end

-- NEW MUZZLE FLASH ATTACHMENT SYSTEM. TIMUR&MAX
-- MuzzleFlashTimer turn off timer callback.
MuzzleFlashTurnoffCallback =
{
	OnEvent = function(self,event,Params)
		if Params then
			BasicWeapon.ShowMuzzleFlash(Params.weapon,Params,0)
		end
	end
}

function BasicWeapon:ShowMuzzleFlash(MuzzleFlashParams,bEnable)
	local geomName = "Objects/Weapons/MUZZLEFLASH/muzzleflash.cgf"
	local boneName
	local target
	local lifetime = 10
	if MuzzleFlashParams.bActive and bEnable==1 then
		MuzzleFlashParams.bRepeat = 1
		do return end
	end
	if MuzzleFlashParams.bFirstPerson then
		boneName = "spitfire"
		target = MuzzleFlashParams.weapon
	else
		boneName = "weapon_bone"
		target = MuzzleFlashParams.shooter
	end
	if (MuzzleFlashParams.MuzzleFlash.geometry_name) then
		-- Mixer: big mutant machinegun effect
		if (target.ROCKET_ORIGIN_KEYFRAME) then
			geomName = "Objects/Weapons/Muzzle_Flash/mf_mutantshotgun_tpv.cgf"
		else
			geomName = MuzzleFlashParams.MuzzleFlash.geometry_name
		end
	end
	-- Life time must be in seconds.
	if (MuzzleFlashParams.MuzzleFlash.lifetime) then
		lifetime = MuzzleFlashParams.MuzzleFlash.lifetime * 1000
	end
	if (MuzzleFlashParams.MuzzleFlash.bone_name) then
		boneName = MuzzleFlashParams.MuzzleFlash.bone_name
	end
	-- If MuzzleFlash is active and fire was repeated.
	if MuzzleFlashParams.bRepeat and bEnable==0 then
		MuzzleFlashParams.bRepeat = nil
		MuzzleFlashParams.bActive = nil
		-- Play Muzzle Flash just... abit longer 1/3rd of normal muzzle flash time, until next muzzle flash will be initialized if needed.
		Game:SetTimer(MuzzleFlashTurnoffCallback,lifetime*.3,MuzzleFlashParams)
		do return end
	end
	-- -- if (MuzzleFlashParams.bind_handle==nil) then MuzzleFlashParams.bind_handle = 0  end
	-- -- if (MuzzleFlashParams.aux_bind_handle==nil) then MuzzleFlashParams.aux_bind_handle = 0  end
	-- -- Hud:AddMessage("bind_handle: "..MuzzleFlashParams.bind_handle..",aux_bind_handle: "..MuzzleFlashParams.aux_bind_handle)
	-- local rnd=random(1,2)
	-- if (bEnable==1) then
		-- MuzzleFlashParams.bActive = 1
		-- if (MuzzleFlashParams.bind_handle==0 or not MuzzleFlashParams.bind_handle) then
			-- target:LoadObject(geomName,2,1)
			-- MuzzleFlashParams.bind_handle = target:AttachObjectToBone(2, boneName,1)
		-- end
		-- if (MuzzleFlashParams.aux_bind_handle==0 or not MuzzleFlashParams.aux_bind_handle) then
			-- if (rnd==1) then
				-- MuzzleFlashParams.aux_bind_handle = target:AttachObjectToBone(2, "aux_"..boneName,1)
			-- end
		-- end
		-- -- if (not MuzzleFlashParams.bind_handle) then MuzzleFlashParams.bind_handle = -1  end
		-- -- if (not MuzzleFlashParams.aux_bind_handle) then MuzzleFlashParams.aux_bind_handle = -1  end
		-- -- Hud:AddMessage("bind_handle: "..MuzzleFlashParams.bind_handle..",aux_bind_handle: "..MuzzleFlashParams.aux_bind_handle)
		-- -- if (MuzzleFlashParams.bind_handle==-1) then MuzzleFlashParams.bind_handle = nil  end
		-- -- if (MuzzleFlashParams.aux_bind_handle==-1) then MuzzleFlashParams.aux_bind_handle = nil  end
	-- else
		-- MuzzleFlashParams.bActive = nil
		-- if (MuzzleFlashParams.bind_handle) then
			-- target:DetachObjectToBone(boneName,MuzzleFlashParams.bind_handle)
			-- MuzzleFlashParams.bind_handle = 0
		-- end
		-- if (MuzzleFlashParams.aux_bind_handle) then
			-- target:DetachObjectToBone("aux_"..boneName,MuzzleFlashParams.aux_bind_handle)
			-- MuzzleFlashParams.aux_bind_handle = 0
		-- end
	-- end
	-- if (bEnable==1) then
		-- -- This will result in a call to BasicWeapon.Client:TimerEvent
		-- Game:SetTimer(MuzzleFlashTurnoffCallback,lifetime,MuzzleFlashParams)
	-- end
	if bEnable==1 then
		MuzzleFlashParams.bActive = 1
		if not MuzzleFlashParams.bind_handle then
			target:LoadObject(geomName,2,1)
			MuzzleFlashParams.bind_handle = target:AttachObjectToBone(2,boneName,1)
		end
		if not MuzzleFlashParams.aux_bind_handle then
			if random(1,2)==1 then
				MuzzleFlashParams.aux_bind_handle = target:AttachObjectToBone(2, "aux_"..boneName,1)
			end
		end
		-- This will result in a call to BasicWeapon.Client:TimerEvent
		Game:SetTimer(MuzzleFlashTurnoffCallback,lifetime,MuzzleFlashParams)
	else
		MuzzleFlashParams.bActive = nil
		if MuzzleFlashParams.bind_handle then
			target:DetachObjectToBone(boneName,MuzzleFlashParams.bind_handle) -- error: attempt to call field `DetachObjectToBone' (a nil value)
			MuzzleFlashParams.bind_handle = nil
		end
		if MuzzleFlashParams.aux_bind_handle then
			target:DetachObjectToBone("aux_"..boneName,MuzzleFlashParams.aux_bind_handle)
			MuzzleFlashParams.aux_bind_handle = nil
		end
	end
end

-- MIXER: FIREMODE CHANGE FIXED NOW, SO YOU CAN USE MORE THAN 2 FIREMODES!
function BasicWeapon.Server:FireModeChange(params)
	-- System:Log("__________Server FM Change__________")
	if (type(params)=="table" and params.shooter) then
		-- System:Log("__________Server FM Change 2__________")
		local shooter = params.shooter
		-- if not shooter.fireparams then return nil end -- При загрузке одного из сохранений выдало... Тест.
		-- Hud:AddMessage(shooter:GetName()..": shooter.fireparams: "..type(shooter.fireparams))
		-- System:Log(shooter:GetName()..": shooter.fireparams: "..type(shooter.fireparams))
		if (shooter.cnt.reloading==nil) then
			local weaponState = GetPlayerWeaponInfo(shooter)
			local SwitchClip
			if (shooter.fireparams.AmmoType==shooter.cnt.weapon.FireParams[params.firemode+1].AmmoType or params.ignoreammo) then
				SwitchClip=1
			else
				if (shooter.cnt.weapon.FireParams[params.firemode-1]) and (shooter.cnt.weapon.FireParams[params.firemode-1].AmmoType==shooter.fireparams.AmmoType) then
					weaponState.AmmoInClip[shooter.firemodenum-1]=shooter.cnt.ammo_in_clip
				end
				shooter.Ammo[shooter.fireparams.AmmoType]=shooter.cnt.ammo
				weaponState.AmmoInClip[shooter.firemodenum]=shooter.cnt.ammo_in_clip
			end
			if (shooter.draws_his_gun_sv) then
				shooter.draws_his_gun_sv = nil
			else
				local fm_chngtime=0
				if (self) and (self.anim_table) and (self.anim_table[shooter.firemodenum]) and (self.anim_table[shooter.firemodenum].modeactivate) then
					fm_chngtime=self:GetAnimationLength(self.anim_table[shooter.firemodenum].modeactivate[1])
				end
				if fm_chngtime==0 then
					fm_chngtime=self:GetAnimationLength("Activate1")
				end
				shooter.cnt.weapon_busy=fm_chngtime
			end
			weaponState.FireMode=params.firemode
			BasicWeapon.SyncVarCache(self,shooter)
			if not SwitchClip then
				shooter.cnt.ammo = shooter.Ammo[shooter.fireparams.AmmoType]
				shooter.cnt.ammo_in_clip = weaponState.AmmoInClip[shooter.firemodenum]
			end
			-- if shooter.ai then
				-- Hud:AddMessage(shooter:GetName()..": Server FM Change "..weaponState.FireMode)
				-- System:Log(shooter:GetName()..": Server FM Change "..weaponState.FireMode)
			-- end
			return 1
		end
	end
	return nil
end

function BasicWeapon.Client:FireModeChange(Params)
	-- System:Log("__________Client FM Change___________")
	-- Did we get the owner passed ?
	if (type(Params)=="table" and Params.shooter) then
		-- System:Log("__________Client FM Change 2___________")
		local shooter = Params.shooter
		-- if not shooter.fireparams then return nil end -- Тест.
		if (shooter.cnt.reloading==nil) then
			BasicWeapon.SyncVarCache(self,shooter)
			if shooter==_localplayer then -- Сделать звук для ИИ.
				if (ClientStuff.vlayers:IsActive("WeaponScope") and shooter.fireparams.no_zoom==1) then
					ClientStuff.vlayers:DeactivateLayer("WeaponScope")
				end
				if (Params.ignoreammo==nil and self.FireParams[2]~=nil) then
					shooter.bFired_Sht = nil
					if not shooter.cis_svgload then
						-- self.FireParams[shooter.cnt.firemode+1].
						-- self.FireParams[shooter.firemodenum].
						if shooter.sounddata.FireModeChangeSound then
							shooter.cnt:PlaySound(shooter.sounddata.FireModeChangeSound)
						elseif BasicWeapon.fireModeChangeSound then
							shooter.cnt:PlaySound(BasicWeapon.fireModeChangeSound)
						end
					end
				end
				if (shooter.cis_svgload) then shooter.cis_svgload = nil end
			end
			if (shooter.fireparams.type) then
				self.cnt:SetHoldingType(shooter.fireparams.type)
			end
			if (shooter.draws_his_gun_cl) then
				shooter.draws_his_gun_cl = nil
			else
				local fm_chngtime=0
				if (self) and (self.anim_table) and (self.anim_table[shooter.firemodenum]) and (self.anim_table[shooter.firemodenum].modeactivate) then
					fm_chngtime=self:GetAnimationLength(self.anim_table[shooter.firemodenum].modeactivate[1])
				end
				if fm_chngtime > 0 then
					-- shooter.cnt.reloading = 1
					shooter.playingReloadAnimation = 1
					BasicWeapon.RandomAnimation(self,"modeactivate",shooter.firemodenum)
					shooter.cnt.weapon_busy=fm_chngtime
				end
			end
			-- if shooter.ai then
				-- System:Log(shooter:GetName()..": Client FM Change "..shooter.cnt.firemode)
			-- end
			return 1
		end
	end
	return nil
end

function BasicWeapon:DrawCrosshair(r,g,b,accuracy, xpos, ypos)
	local factor = 0
	if (_localplayer.entity_type=="spectator") then
		if (_localplayer.cnt.GetHost) then
		local ent = System:GetEntity(_localplayer.cnt:GetHost())
			factor = ent.cnt:CalculateAccuracyFactor(accuracy)
		end
	else
		factor = _localplayer.cnt:CalculateAccuracyFactor(accuracy)
	end
	local xcent=400
	local ycent=300
	if (ypos) then
		xcent=xpos
		ycent=ypos
	end
	local shift = xcent * tan(.1308997)/tan(Game:GetCameraFov()/2) * factor
	if (BasicWeapon.prevShift) then
		shift = BasicWeapon.prevShift * .9 + shift * .1
	end
	local fValue=1
	if (hud_fadeamount and tonumber(hud_fadeamount)~=1) then
		fValue=tonumber(hud_fadeamount)
	end
	local IronSights = getglobal("g_enableironsights")
	if ((IronSights and IronSights>="1" and ((getglobal("g_crosshairs")~="0" and not _localplayer.cnt.aiming) or (_localplayer.cnt.weapon.AlwaysCrosshair)))
	or (IronSights and IronSights=="0" and (getglobal("g_crosshairs")~="0" or _localplayer.cnt.aiming) and (not _localplayer.cnt.aiming or _localplayer.cnt.weapon.AimMode~=2))) then					--IronSights: no crosshairs
		%System:Draw2DLine(xcent-7-shift,ycent,xcent-2-shift,ycent,r,g,b,fValue)
		%System:Draw2DLine(xcent+2+shift,ycent,xcent+7+shift,ycent,r,g,b,fValue)
		%System:Draw2DLine(xcent,ycent-2-shift,xcent,ycent-7-shift,r,g,b,fValue)
		%System:Draw2DLine(xcent,ycent+2+shift,xcent,ycent+7+shift,r,g,b,fValue)
		local Difficulty = tonumber(getglobal("game_DifficultyLevel"))
		-- if ClientStuff.vlayers:IsActive("WeaponScope") and Difficulty<2 then
		if Difficulty<2 then
			-- small dot in the centre of screen.
			%System:Draw2DLine(xcent,ycent-.5,xcent,ycent+.5,r,g,b,fValue)
		end
	end

		-- %System:Draw2DLine(xcent-7-shift,ycent,xcent-2-shift,ycent,r,g,b,fValue) -- вернуть всё то, что свыше
		-- %System:Draw2DLine(xcent+2+shift,ycent,xcent+7+shift,ycent,r,g,b,fValue)
		-- %System:Draw2DLine(xcent,ycent-2-shift,xcent,ycent-7-shift,r,g,b,fValue)
		-- %System:Draw2DLine(xcent,ycent+2+shift,xcent,ycent+7+shift,r,g,b,fValue)
		-- %System:Draw2DLine(xcent,ycent-.5,xcent,ycent+.5,r,g,b,fValue)
	BasicWeapon.prevShift = shift
end
-----------
function BasicWeapon.Client:OnEnhanceHUD(scale, bhit, xpos, ypos)
	local myplayer = _localplayer
	if (myplayer.entity_type=="spectator" and myplayer.cnt.GetHost) then
		if (_localplayer.cnt:GetHost()==0) then

		else
			myplayer = System:GetEntity(_localplayer.cnt:GetHost())
		end
	end
	-- some weapons (Mortar) don't have this parameter
	if not scale then
		scale = 1
	end
	if (myplayer) then
		local stats = myplayer.cnt
		if (myplayer.fireparams.HasCrosshair) and (stats.first_person) then
			if ((not ClientStuff.vlayers:IsActive("Binoculars")) and (((not ClientStuff.vlayers:IsActive("WeaponScope")) or (self.AimMode)) or self.ZoomForceCrosshair)) then
				-- if (bhit and bhit>0) then
					-- BasicWeapon.DrawCrosshair(self,1,0,0,stats.accuracy*scale, xpos, ypos)
				-- elseif (stats.reloading) or (stats.ammo_in_clip==0 and stats.ammo==0 and myplayer.fireparams.AmmoType~="Unlimited") then
					-- BasicWeapon.DrawCrosshair(self,.25,.25,0,stats.accuracy*scale, xpos, ypos)
				-- else
					-- BasicWeapon.DrawCrosshair(self,1,1,0,stats.accuracy*scale, xpos, ypos)
				-- end
				if bhit and bhit>0 and tonumber(getglobal("game_DifficultyLevel"))<2 then -- Покраснение при попадании.
					BasicWeapon.DrawCrosshair(self,1,0,0,stats.accuracy*scale, xpos, ypos)
				elseif (stats.reloading) or (stats.ammo_in_clip==0 and stats.ammo==0 and myplayer.fireparams.AmmoType~="Unlimited") then
					BasicWeapon.DrawCrosshair(self,0,0,0,stats.accuracy*scale, xpos, ypos) -- 1,.5,0
				else
					BasicWeapon.DrawCrosshair(self,0,.7,.7,stats.accuracy*scale, xpos, ypos) -- Цвет прицела.
				end
			end
		end -- has crosshair
	end
end
--------
function BasicWeapon.Server:OnActivate(Params)
	-- Set player-related stuff...
	local shooter = Params.shooter
	if (shooter) then
		local stats = shooter.cnt
		local AmmoType
		shooter.weapon_info=GetPlayerWeaponInfo(shooter)
		if (shooter.weapon_info) then
			BasicWeapon.SyncVarCache(self,shooter)
			if shooter.fireparams then -- nil как-то было.
				AmmoType = shooter.fireparams.AmmoType
				stats.ammo = shooter.Ammo[AmmoType]
			end
			stats.ammo_in_clip = shooter.weapon_info.AmmoInClip[shooter.firemodenum]
			stats.weapon_busy=self:GetAnimationLength("Activate"..shooter.firemodenum)
			shooter.draws_his_gun_sv = 1
			-- if (shooter.Event_Follow) then -- Типа чуть больше патронов?
				-- shooter.cis_wpn_nevalue = floor(shooter.fireparams.bullets_per_clip*.33)
			-- end
		end
		self.OldSpeedScale = stats.speedscale
		stats.speedscale = self.PlayerSlowDown
--------------------IronSights: Begin--------------------
		local IronSights = getglobal("g_enableironsights")
		if (IronSights and IronSights>="1") then
			stats:SetSwayAmp(self.Sway)
			stats:SetSwayFreq(.6)
		end
-------------------- IronSights: End --------------------
	end
end
-----
function BasicWeapon.Client:OnActivate(Params)
	-- set player-related stuff...
	local shooter = Params.shooter
	if (shooter) then
		local stats = shooter.cnt
		shooter.weapon_info=GetPlayerWeaponInfo(shooter)
		if (shooter.weapon_info) then
			-- big mutants can have any weapon now!
			if (shooter.ROCKET_ORIGIN_KEYFRAME) then
				shooter.cnt:DrawThirdPersonWeapon(0)
			end
			BasicWeapon.SyncVarCache(self,shooter)
			shooter.draws_his_gun_cl = 1
		end
		if (shooter==_localplayer) and (BasicPlayer.IsAlive(shooter)) then
			-- Mixer: modified to prevent activation sound play on load
			if (not shooter.cis_svgload) and (self.ActivateSound) then
				shooter.cnt:PlaySound(self.ActivateSound)
			end
			-- end modified, see BasicPlayer.lua also
			-- svgload sets to nil on firemodechange func
			if (shooter.firemodenum) then
				stats.weapon_busy=self:GetAnimationLength("Activate"..shooter.firemodenum)
				-- Look here
				BasicWeapon.RandomAnimation(self,"activate",shooter.firemodenum)
			end
			self.cnt:SetFirstPersonWeaponPos(g_Vectors.v000, g_Vectors.v000)
			-- if we are using binoculars, remove them when activating a new weapon
			if (ClientStuff.vlayers:IsActive("Binoculars")) then
				ClientStuff.vlayers:DeactivateLayer("Binoculars")
			end
			-- do not remove this
			BasicPlayer.ProcessPlayerEffects(shooter)
			BasicWeapon.Show(self,shooter)
			shooter.mp_weapon_active = 1
		end -- localplayer code
		self.OldSpeedScale = stats.speedscale
		stats.speedscale = self.PlayerSlowDown
--------------------IronSights: Begin--------------------
		local IronSights = getglobal("g_enableironsights")
		if (IronSights and IronSights>="1") then
			stats:SetSwayAmp(self.Sway)
			stats:SetSwayFreq(.6)
		end
-------------------- IronSights: End --------------------
	end
	self.nextfidgettime = nil
end

function BasicWeapon.Server:OnDeactivate(Params) -- При переключении оружия тоже срабатывает.
	if (Params.shooter) then
		-- Abort any reloading sequence
		local shooter=Params.shooter
		shooter.cnt.reloading = nil
		if shooter.fireparams then -- nil было
			shooter.Ammo[shooter.fireparams.AmmoType]=shooter.cnt.ammo
		end
		-- Hud:AddMessage(shooter:GetName()..": 1")
		-- System:Log(shooter:GetName()..": 1")
		local weaponState = GetPlayerWeaponInfo(shooter)
		if (weaponState) then
			weaponState.AmmoInClip[shooter.firemodenum]=shooter.cnt.ammo_in_clip
			-- Hud:AddMessage(shooter:GetName()..": 2")
			-- System:Log(shooter:GetName()..": 2")
			-- vehicle weapons don't retain any ammo
			if shooter.fireparams and shooter.fireparams.vehicleWeapon then
				-- Hud:AddMessage(shooter:GetName()..": 3")
				-- System:Log(shooter:GetName()..": 3")
				-- empty all the ammo from the clip of the weapon
				BasicPlayer.EmptyClips(shooter, shooter.cnt.weaponid)
			end
		end
	end
end

function BasicWeapon.Client:OnDeactivate(Params)
	-- Did we get the owner passed ?
	if (type(Params)=="table" and Params.shooter==_localplayer) then
		-- Hide the weapon
		BasicWeapon.Hide(self, Params.shooter)
		if (ClientStuff.vlayers:IsActive("WeaponScope")) then
			ClientStuff.vlayers:DeactivateLayer("WeaponScope")
		end
		if self.ActivateSound and Sound:IsPlaying(self.ActivateSound) then
			Sound:StopSound(self.ActivateSound)
		end
	end
	-- kill the muzzleflash
	if (Params.shooter) then
		if (Params.shooter._MuzzleFlashParams) then
			BasicWeapon.ShowMuzzleFlash(self, Params.shooter._MuzzleFlashParams, 0)
		end
		--if (Params.shooter.cnt.firing) then
		BasicWeapon.Client.OnStopFiring(Params.shooter.cnt.weapon,Params.shooter)
		--end
	end
end

-- function BasicWeapon:CountWeaponsInSlots(Params)
	-- local ws = Params.Player.cnt:GetWeaponsSlots()
	-- if not ws then return 0 end
	-- local weaponscount=0
	-- for i,val in ws do
		-- if (val~=0) then
			-- weaponscount=weaponscount+1
		-- end
	-- end
	-- return weaponscount
-- end

function BasicWeapon.Server:Drop(Params) -- Теряет патроны, надо исправить.
	local player=Params.Player
	-- Hud:AddMessage(player:GetName()..": DROP")
	-- System:Log(player:GetName()..": DROP")
	local ppick
	if not player.cnt.weapon or GameRules.bSuppressDropWeapon then return end -- some mods may want this behaviour
	local weapon=player.cnt.weapon
	local cid=Game:GetEntityClassIDByClassName("Pickup"..weapon.name.."_p")
	if (not cid) or (Game:IsMultiplayer()) then
		cid=Game:GetEntityClassIDByClassName("Pickup"..weapon.name)
	else
		ppick = 1
	end
	if cid then
		local pos = SumVectors(player:GetPos(),{x=0,y=0,z=1.5})
		-- adjust spawn height based on player stance
		if (player.cnt.crouching) then
			pos = SumVectors(pos, {x=0,y=0,z=-.5})
		elseif (player.cnt.proning) then
			pos = SumVectors(pos, {x=0,y=0,z=-1})
		end
		local dir = BasicWeapon.temp_v1
		local dest = BasicWeapon.temp_v2
		if (not ppick) then
			CopyVector(dir,player:GetDirectionVector())
			dest.x = pos.x + dir.x * 1.5
			dest.y = pos.y + dir.y * 1.5
			dest.z = pos.z + dir.z * 1.5
			local hits = System:RayWorldIntersection(pos,dest,1,ent_terrain+ent_static+ent_rigid+ent_sleeping_rigid,player.id)
			if (hits and getn(hits)>0) then
			local temp = hits[1].pos
			dest.x = temp.x - dir.x * .15
			dest.y = temp.y - dir.y * .15
			dest.z = temp.z - dir.z * .15
			end
		else
			CopyVector(dir,player:GetDirectionVector())
			dest.x = pos.x + dir.x
			dest.y = pos.y + dir.y
			dest.z = pos.z + dir.z
			local hits = System:RayWorldIntersection(pos,dest,1,ent_terrain+ent_static+ent_rigid+ent_sleeping_rigid,player.id)
			if (hits and getn(hits)>0) then
			-- disable throwing, can hurt self
			player.pp_safedrop = 1
			local temp = hits[1].pos
			dest.x = temp.x - dir.x * .5
			dest.y = temp.y - dir.y * .5
			dest.z = temp.z - dir.z * .5
			end
		end
		-- Create the dropped item
		local ed={
			classid=cid,
			pos=dest, --pos,
		}
		-- tiny hack to prevent instant picking dropped item back:
		player.pp_lastdrop_p = 1
		local DroppedItem = Server:SpawnEntity(ed)
		if not DroppedItem.physpickup then
			DroppedItem:EnableSave(1)
			if GameRules.GetPickupFadeTime then
				DroppedItem:SetFadeTime(GameRules:GetPickupFadeTime())
			end
			DroppedItem:GotoState("Dropped") -- Пишет, что состояние не известное...
		else
			-- prepare and throw physical pickup
			DroppedItem:SetViewDistRatio(255)
			DroppedItem.pp_lastdrop = _time + .8
			local sdv = new(player:GetDirectionVector())
			local t_ang = new(player:GetAngles())
			if (DroppedItem.throw_z) then
				t_ang.z = t_ang.z + DroppedItem.throw_z
				DroppedItem:SetAngles(t_ang)
			end
			if (DroppedItem.throw_sound) then
				local t_snd = Sound:LoadSound(DroppedItem.throw_sound)
				if (t_snd) then
					Sound:PlaySound(t_snd)
				end
			end
			DroppedItem:AddImpulse(-1,dest,sdv,41*DroppedItem.Properties.Animation.Speed)
		end
		DroppedItem.autodelete=1
		player.pp_lastdrop_p = nil
		-- write back current ammo backlog
		player.Ammo[player.fireparams.AmmoType]=player.cnt.ammo
		-- update ammo in clips
		local wi = GetPlayerWeaponInfo(player)
		if (wi) then
			if (self.FireParams[2] and self.FireParams[2].AmmoType==self.FireParams[1].AmmoType and player.firemodenum==2) then -- А если больше режимов сделаю? Тогда надо будет сюда заглянуть.
				wi.AmmoInClip[1]=player.cnt.ammo_in_clip
			end
			wi.AmmoInClip[player.firemodenum]=player.cnt.ammo_in_clip
		end
		player.cnt.ammo_in_clip=0
		local am_amount1 = 0
		local am_amount2 = 0
		-- now we store the ammo for each firemode
		if self.FireParams[1] then
			am_amount1 = wi.AmmoInClip[1] * 1
			wi.AmmoInClip[1]=0
		end
		if self.FireParams[2]
		and self.FireParams[2].AmmoType~=self.FireParams[1].AmmoType then
			am_amount2 = wi.AmmoInClip[2] * 1
			wi.AmmoInClip[2]=0
		end
		if self.FireParams[3]
		and self.FireParams[3].AmmoType~=self.FireParams[2].AmmoTyp
		and self.FireParams[3].AmmoType~=self.FireParams[1].AmmoType then
			am_amount2 = wi.AmmoInClip[3] * 1
			wi.AmmoInClip[3]=0
		end
		if self.FireParams[4]
		and self.FireParams[4].AmmoType~=self.FireParams[3].AmmoType
		and self.FireParams[4].AmmoType~=self.FireParams[2].AmmoType
		and self.FireParams[4].AmmoType~=self.FireParams[1].AmmoType then -- На всякий случай.
			am_amount2 = wi.AmmoInClip[4] * 1
			wi.AmmoInClip[4]=0
		end

		if DroppedItem.physpickup then
			DroppedItem.Properties.Animation.fAmmo_Primary=am_amount1
			DroppedItem.Properties.Animation.fAmmo_Secondary=am_amount2
		else
			DroppedItem.Properties.Amount=am_amount1
			DroppedItem.Properties.Amount2=am_amount2
		end
		DroppedItem:SetName(self.name.."_dropped") -- Это обязательно!
		DroppedItem.Properties.Animation.AvailableWeapon = 1
		AI:RegisterWithAI(DroppedItem.id,AIOBJECT_WEAPON)
		-- Hud:AddMessage(self.name.." dropped: "..player:GetName())
		System:Log(self.name.." dropped: "..player:GetName())
		-- if  BasicWeapon.CountWeaponsInSlots(Params) <= 1 then
			-- self:OnDeactivate(Params) -- Может поможет с исправлением потери патронов.
		-- end
		if player.GunTableOfRandomTrace and player.GunTableOfRandomTrace[WeaponClassesEx[self.name].id]
		and player.GunTableOfRandomTrace[WeaponClassesEx[self.name].id].Color and not DroppedItem.RandomColor then
			DroppedItem.RandomColor = player.GunTableOfRandomTrace[WeaponClassesEx[self.name].id].Color
		end
		-- take away the weapon
		if (not Params.suppressSwitchWeapon) then
			AI:SoundEvent(player.id,player:GetPos(),3,.5,.5,player.id)
			player.cnt:MakeWeaponAvailable(self.classid,0)
			if (BasicPlayer.AddPlayerHands) then
				BasicPlayer.AddPlayerHands(player)
			end
			if tonumber(getglobal("game_DifficultyLevel"))>=2 and player==_localpalyer then -- Выбросив оружие, извольте переключаться на другое сами.
				player.cnt:DeselectWeapon()
			else
				player.cnt:SelectFirstWeapon()
			end
		end
	end
end

function BasicWeapon.Server:WeaponReady(shooter)
	local stats = shooter.cnt
	if stats.reloading then
		local fireparams = shooter.fireparams
		-- Finished
		stats.reloading = nil
		-- Obtain fire params to get ammo type and clip size
		-- System:Log(shooter:GetName()..": stats.ammo 1: "..stats.ammo..", stats.ammo_in_clip: "..stats.ammo_in_clip)
		if toNumberOrZero(getglobal("gr_realistic_reload"))==1 then
			stats.ammo_in_clip=0
		end
		stats.ammo = stats.ammo + stats.ammo_in_clip
		if (stats.ammo >= fireparams.bullets_per_clip) then
			-- Got enough ammo left to fill a clip
			stats.ammo = stats.ammo - fireparams.bullets_per_clip
			stats.ammo_in_clip = fireparams.bullets_per_clip
		elseif (stats.ammo > 0) then
			-- Partially fill the clip
			stats.ammo_in_clip = stats.ammo
			stats.ammo = 0
		end
		-- System:Log(shooter:GetName()..": stats.ammo 10: "..stats.ammo..", stats.ammo_in_clip: "..stats.ammo_in_clip)
		-- ammo has changed, so update Ammo table
		shooter.Ammo[fireparams.AmmoType] = stats.ammo
	end
end

function BasicWeapon.Server:Reload(shooter)
	local stats = shooter.cnt
	if not stats.reloading and not stats.TimeToThrowGrenade then
		-- System:Log(shooter:GetName()..": BasicWeapon.Server:RELOAD 1")
		-- if shooter.IsAiPlayer then
			-- Hud:AddMessage(shooter:GetName()..": BasicWeapon.Server:Reload(shooter)/1")
			-- System:Log(shooter:GetName()..": BasicWeapon.Server:Reload(shooter)/1")
		-- end
		local w = stats.weapon
		if w and stats.ammo>0 and stats.ammo_in_clip < shooter.fireparams.bullets_per_clip then
			if shooter==_localplayer and (ClientStuff.vlayers:IsActive("WeaponScope") or shooter.OnWeaponScopeDeactivatingReloading or stats.aiming) then
				-- Hud:AddMessage(shooter:GetName().."$1: BasicWeapon.Server:Reload")
				-- System:Log(shooter:GetName().."$1: BasicWeapon.Server:Reload")
				-- if shooter.IsAiPlayer then
					-- Hud:AddMessage(shooter:GetName()..": BasicWeapon.Server:Reload(shooter)/2")
					-- System:Log(shooter:GetName()..": BasicWeapon.Server:Reload(shooter)/2")
				-- end
				return
			end
			-- if shooter.IsAiPlayer then
				-- Hud:AddMessage(shooter:GetName()..": BasicWeapon.Server:Reload(shooter)/3")
				-- System:Log(shooter:GetName()..": BasicWeapon.Server:Reload(shooter)/3")
			-- end
			-- System:Log(shooter:GetName()..": BasicWeapon.Server:RELOAD 2")
			shooter.abortGrenadeThrow = 1  -- Может из за этого дымовая граната не бросается?
			stats.weapon_busy = shooter.fireparams.reload_time
			stats.reloading=1
			AI:Signal(0,1,"OnReload",shooter.id)
			AI:SoundEvent(shooter.id,shooter:GetPos(),3,0,.5,shooter.id) -- Добавить задержку.
			-- Hud:AddMessage(shooter:GetName().." reloading SoundEvent")
			local anim_name = "reload"
			-- Mixer - anim not only for DE, for all pistols too
			if (shooter.fireparams.type) and (shooter.fireparams.type==2) then
				anim_name = anim_name.."_DE"
			end
			if (shooter.ai) then
				if (stats.crouching) then
					anim_name = "c"..anim_name
				elseif (stats.proning) then
					anim_name = "s"..anim_name
					-- Hud:AddMessage(shooter:GetName()..": SERVER,stats.proning,anim_name: "..anim_name)
				else
					anim_name = "s"..anim_name
				end
				local dur = shooter:GetAnimationLength(anim_name)
				if (AI:IsMoving(shooter.id)==1 or stats.proning) then
					--moving reload
					anim_name = anim_name.."_moving"
					dur = shooter:GetAnimationLength(anim_name)
				else
					-- stop movement
					AI:EnablePuppetMovement(shooter.id,0,dur) -- Надоели стоять в открытую во время перезарядки! Но, если убрать, то возникают глюки с анимацией.
				end
				-- Hud:AddMessage(shooter:GetName()..": SERVER,anim_name: "..anim_name)
				shooter:TriggerEvent(AIEVENT_ONBODYSENSOR,dur)
			else
				anim_name = "s"..anim_name.."_moving"
			end
		end
	end
end

function BasicWeapon.Client:Reload(shooter)
	local stats = shooter.cnt
	-- System:Log(shooter:GetName()..": BasicWeapon.Client:RELOAD 1")
	-- if shooter.IsAiPlayer then
		-- Hud:AddMessage(shooter:GetName()..": BasicWeapon.Client:Reload(shooter)/1")
		-- System:Log(shooter:GetName()..": BasicWeapon.Client:Reload(shooter)/1")
	-- end
	if shooter.fireparams.no_reload then return end
	if not stats.reloading then
		if stats.ammo_in_clip < shooter.fireparams.bullets_per_clip then
			-- System:Log(shooter:GetName()..": BasicWeapon.Client:RELOAD 2")
			-- if shooter.IsAiPlayer then
				-- Hud:AddMessage(shooter:GetName()..": BasicWeapon.Client:Reload(shooter)/2")
				-- System:Log(shooter:GetName()..": BasicWeapon.Client:Reload(shooter)/2")
			-- end
			local ReloadAnimName = "Reload"..(shooter.firemodenum)
			if stats.ammo > 0 then
				-- if shooter.IsAiPlayer then
					-- Hud:AddMessage(shooter:GetName()..": BasicWeapon.Client:Reload(shooter)/3")
					-- System:Log(shooter:GetName()..": BasicWeapon.Client:Reload(shooter)/3")
				-- end
				if shooter==_localplayer and not shooter.IsAiPlayer and (ClientStuff.vlayers:IsActive("WeaponScope") or shooter.OnWeaponScopeDeactivatingReloading or stats.aiming) then 
				-- if shooter.IsAiPlayer then
					-- Hud:AddMessage(shooter:GetName()..": BasicWeapon.Client:Reload(shooter)/4")
					-- System:Log(shooter:GetName()..": BasicWeapon.Client:Reload(shooter)/4")
				-- end
				-- Дополнительные проверки чтобы на низкой сложности не проскакивало...
					-- Hud:AddMessage(shooter:GetName().."$1: BasicWeapon.Client:Reload")
					-- System:Log(shooter:GetName().."$1: BasicWeapon.Client:Reload")
					if not shooter.OnWeaponScopeDeactivatingReloading then shooter.OnWeaponScopeDeactivatingReloading = self.name end
					return
				end
				-- if shooter.IsAiPlayer then
					-- Hud:AddMessage(shooter:GetName()..": BasicWeapon.Client:Reload(shooter)/5")
					-- System:Log(shooter:GetName()..": BasicWeapon.Client:Reload(shooter)/5")
				-- end
				if shooter==_localplayer and stats.first_person then
					if ClientStuff.vlayers:IsActive("WeaponScope") or ClientStuff.vlayers:IsFading("WeaponScope") then
						ClientStuff.vlayers:DeactivateLayer("WeaponScope",1) -- Это уже и не нужно...
					end
					stats.weapon_busy = shooter.fireparams.reload_time
					BasicWeapon.RandomAnimation(self,"reload",shooter.firemodenum)
					shooter.playingReloadAnimation = 1
				end
				-- always play 3rd person animation (because we might see ourself in a mirror)
				--filippo:check if is a mounted weapon, if so dont play player reload anim.
				local CurFireParams
				if (self.FireParams[1].AmmoType=="Unlimited") then
					CurFireParams = self.FireParams[1]
				else
					CurFireParams = shooter.fireparams
				end
				if (CurFireParams.vehicleWeapon==1) then
					return
				end
				local anim_name = "reload"
				-- Mixer - anim not only for DE, for all pistols too
				if (shooter.fireparams.type) and (shooter.fireparams.type==2) then
					anim_name = anim_name.."_DE"
				end
				if (shooter.ai) then
					if (stats.crouching) then
						anim_name = "c"..anim_name
					elseif (stats.proning) then
						anim_name = "s"..anim_name
						-- Hud:AddMessage(shooter:GetName()..": CLIENT,stats.proning,anim_name: "..anim_name)
					else
						anim_name = "s"..anim_name
					end
					if (AI:IsMoving(shooter.id)==1 or stats.proning) then
						anim_name = anim_name.."_moving"
					end
				else
					anim_name = "s"..anim_name.."_moving"
				end
				shooter:StartAnimation(0,anim_name,4)
			end
		end
	end
end

function BasicWeapon.Client:OnAnimationKey(Params)
	if Params.userdata then
		Sound:PlaySound(Params.userdata)
	end
end

-- MIXER: STOP FIRELOOP ALSO IMPROVED
function BasicWeapon:StopFireLoop(shooter,fireparams,sound_data)
	local sound=Sound
	if sound_data then
		if sound_data.FireLoopStereo and sound:IsPlaying(sound_data.FireLoopStereo) then
			if sound_data.TrailOffStereo then
				sound:StopSound(sound_data.FireLoopStereo)
				shooter.cnt:PlaySound(sound_data.TrailOffStereo)
			end
		end
		if sound_data.FireLoop and sound:IsPlaying(sound_data.FireLoop) then
			if sound_data.TrailOff then
				sound:StopSound(sound_data.FireLoop)
				if fireparams then
					local fDistance = shooter:GetDistanceFromPoint(_localplayer:GetPos()) -- Это защищиает от воспроизведения этого звука, когда дистанция больше слышимости FireLoop.
					if fDistance<=fireparams.SoundMinMaxVol[3]/5 or Game:IsMultiplayer() then -- Деление на 5, то есть 2200/5=440 - как раз в этом месте обрывается звук FireLoop. -- Не знаю как в мультиплеере это определение дистанции работает.
						-- Hud:AddMessage(shooter:GetName()..": TrailOff: "..fireparams.SoundMinMaxVol[1].." "..fireparams.SoundMinMaxVol[2].." "..fireparams.SoundMinMaxVol[3]..", fDistance: "..fDistance)
						if Hud and Hud.SharedSoundScale~=0 then
							shooter.cnt:PlaySound(sound_data.TrailOff)
						end
						sound:SetSoundVolume(sound_data.TrailOff,fireparams.SoundMinMaxVol[1])
						sound:SetMinMaxDistance(sound_data.TrailOff,fireparams.SoundMinMaxVol[2],fireparams.SoundMinMaxVol[3])
					end
				end
			end
		end
	end
end

-- This function augments a passed weapon table with the
-- necessary Client and Server callbacks
function CreateBasicWeapon(weapon)
	-- add default Server callback tables
	if (weapon.Server==nil) then
		weapon.Server = {}
	end
	-- copy over the functions
	for i,val in BasicWeapon.Server do
		weapon.Server[i] = val
	end
	-- add default Client callback tables
	if (weapon.Client==nil) then
		weapon.Client = {}
	end
	-- copy over the functions
	for i,val in BasicWeapon.Client do
		weapon.Client[i] = val
	end
end
------------------------------------------
BasicWeapon.Server_EventHandler={
	[ScriptEvent_Activate]=BasicWeapon.Server.OnActivate,
	[ScriptEvent_Deactivate]=BasicWeapon.Server.OnDeactivate,
	[ScriptEvent_DropItem]=BasicWeapon.Server.Drop,
	[ScriptEvent_FireModeChange]=BasicWeapon.Server.FireModeChange,
	[ScriptEvent_WeaponReady]=BasicWeapon.Server.WeaponReady,
	[ScriptEvent_Hit]=BasicWeapon.Server.OnHit,
	[ScriptEvent_Fire]=BasicWeapon.Server.OnFire,
	[ScriptEvent_FireCancel]=BasicWeapon.Server.OnFireCancel,
	[ScriptEvent_Reload]=BasicWeapon.Server.Reload,
}
------------------------------------------
BasicWeapon.Client_EventHandler={
	[ScriptEvent_AnimationKey]=BasicWeapon.Client.OnAnimationKey,
	[ScriptEvent_Activate]=BasicWeapon.Client.OnActivate,
	[ScriptEvent_Deactivate]=BasicWeapon.Client.OnDeactivate,
	[ScriptEvent_FireModeChange]=BasicWeapon.Client.FireModeChange,
	[ScriptEvent_Hit]=BasicWeapon.Client.OnHit,
	[ScriptEvent_Fire]=BasicWeapon.Client.OnFire,
	[ScriptEvent_StopFiring]=BasicWeapon.Client.OnStopFiring,
	[ScriptEvent_FireCancel]=BasicWeapon.Client.OnFireCancel,
	[ScriptEvent_Reload]=BasicWeapon.Client.Reload,
}

function BasicWeapon:RandomAnimation(anim,firemode, blendtime)
	if (blendtime==nil) then blendtime = 0 end
	if (self.anim_table) then
		local at=self.anim_table[firemode]
		if (at) then
			local t=at[anim]
			if (t) then
				self:StartAnimation(0, t[random(1,getn(t))], 0, blendtime)
				--else
				--System:Log("BasicWeapon:RandomAnimation("..anim..","..firemode..") NO ANIM")
			end
			--else
			--System:Log("BasicWeapon:RandomAnimation("..anim..","..firemode..") NO ANIM TABLE")
		end
		--else
		--System:Log("BasicWeapon:RandomAnimation("..anim..","..firemode..") self.anim_table is nil")
	end
end

-- crosshair for auto weapons mounted on vehicles
function BasicWeapon:DoAutoCrosshair(scale,bHit)
	local bAvailable = nil
	if (_localplayer.entity_type=="spectator") then
		if (_localplayer.cnt.GetHost) then
			local ent = System:GetEntity(_localplayer.cnt:GetHost())
			bAvailable = ent.cnt:GetCrosshairState()
		end
	else
		bAvailable = _localplayer.cnt:GetCrosshairState()
	end
	-- the crosshair is out of the screen
	--System:Log("\001 >>> fMode  ".._localplayer.cnt.firemode)
	local posX = 400
	local posY = 300
	local aimDist = 0
	if _localplayer.entity_type~="spectator" then
		aimDist = self.FireParams[_localplayer.cnt.firemode+1].auto_aiming_dist
	end
	--local aimDist = self.FireParams[1].auto_aiming_dist
	--System:Log("\001 >>> aAimDist  "..aimDist)
	--filippo
	if (bAvailable==nil) then
		if (BasicWeapon.cantshoot_sprite) then
			local cantshootradius = 25
			%System:DrawImageColor(BasicWeapon.cantshoot_sprite, posX-cantshootradius, posY-cantshootradius, cantshootradius*2, cantshootradius*2, 4, 1, .25, .25, .5)
		end
		return
	end
	local Difficulty = tonumber(getglobal("game_DifficultyLevel"))
	if aimDist==0 or Difficulty>=2 then -- Вырубить авто прицел (визуально), начиная с первой сложности. На деле, выключается в CryGame.dll (UpdateWeaponPosAngl).
		BasicWeapon.Client.OnEnhanceHUD(self, scale, bHit, posX, posY)
		--BasicWeapon.Client:OnEnhanceHUD(bHit, BasicWeapon:CrossHairPos.xS, BasicWeapon:CrossHairPos.yS)
		return
	end
	-- Цвет автоприцела.
	-- local r=1
	-- local g=1
	-- local b=.25
	local r=0
	local g=.7
	local b=.7
	if (bHit and bHit>0) then
		r=1
		g=.25
		b=.25
	end
	--if (pos.locked==1) then
	--r=.1
	--g=1
	--b=.1
	--end
	--filippo, if weapon have autoaim_sprite , use it ,if not use the classic square reticule
	local autoaim_sprite = self.FireParams[_localplayer.cnt.firemode+1].autoaim_sprite
	if (autoaim_sprite) then
		%System:DrawImageColor(autoaim_sprite, posX-aimDist, posY-aimDist, aimDist*2, aimDist*2, 4, r, g, b, 1)
	else
		local x1 = posX - aimDist
		local y1 = posY - aimDist
		local x2 = posX + aimDist
		local y2 = posY + aimDist
		%System:Draw2DLine(x1,y1,x2,y1,r,g,b,1)
		%System:Draw2DLine(x1,y2,x2,y2,r,g,b,1)
		%System:Draw2DLine(x1,y1,x1,y2,r,g,b,1)
		%System:Draw2DLine(x2,y1,x2,y2,r,g,b,1)
	end
	--filippo, draw the little cross
	local outerradius=7
	local innerradius=3
	%System:Draw2DLine(posX-innerradius,posY,posX-outerradius,posY,r,g,b,1)
	%System:Draw2DLine(posX+innerradius,posY,posX+outerradius,posY,r,g,b,1)
	%System:Draw2DLine(posX,posY-innerradius,posX,posY-outerradius,r,g,b,1)
	%System:Draw2DLine(posX,posY+innerradius,posX,posY+outerradius,r,g,b,1)
end

function BasicWeapon:HandleParticleEffect(effect,pos,dir,firstperson,weaponfx)
	local sprite = effect.sprite
	if (sprite==nil) then return end
	local temppos = BasicWeapon.temp_v1
	local tempdir = BasicWeapon.temp_v2
	local tempparticle = BasicWeapon.Particletemp
	local steps = effect.steps
	local stepoffset = effect.stepsoffset
	local randomfactor = 50
	local rnd1 = 1
	local rnd2 = 1
	local rotation = effect.rotation
	local lastsprite = nil
	local lastsize = nil
	local onesprite = 1
	local extrascale = 1
	--if sprite is a table we are using multiple and/or random set of sprites.
	if (type(sprite)=="table") then
		onesprite = 0
	else
		lastsprite = sprite
	end
	if (effect.randomfactor) then
		randomfactor = effect.randomfactor
	end
	temppos.x = pos.x
	temppos.y = pos.y
	temppos.z = pos.z
	tempdir.x = dir.x
	tempdir.y = dir.y
	tempdir.z = dir.z
	NormalizeVector(tempdir)
	-- mixer: Muzzleflash througn scope hack
	if (self.bw_mf_for_scope) then
			temppos.x = temppos.x + dir.x
			temppos.y = temppos.y + dir.y
			temppos.z = temppos.z + dir.z
		else
		--particles in first person are shifted forward for some reasons, so shift the startpos 20 cm back
		if (firstperson) then
			temppos.x = temppos.x - tempdir.x * .2
			temppos.y = temppos.y - tempdir.y * .2
			temppos.z = temppos.z - tempdir.z * .2
		else
			--usually thirdperson effects need to be bigger, so scale them by 1.5
			extrascale = 1.5
		end
	end
	--custom particle color?
	if (effect.color) then
		tempparticle.start_color = effect.color
		tempparticle.end_color = effect.color
	else
		tempparticle.start_color = BasicWeapon.vcolor1
		tempparticle.end_color = BasicWeapon.vcolor1
	end
	local wfx=0
	if weaponfx then
		wfx = weaponfx
	else
		wfx = tonumber(getglobal("cl_weapon_fx"))
	end
	if (wfx<2) then steps = max(steps / (3-wfx),1) end
	tempparticle.focus = effect.focus
	tempparticle.gravity.z = effect.gravity
	tempparticle.AirResistance = effect.AirResistance
	--frametime .1 = 10fps
	--frametime .05 = 20fps
	--frametime .033 = 30fps
	--frametime .02 = 50fps
	--frametime .0166 = 60fps
	--as long as particles dont follow very well the fps use lifetimefix to correct life/speed/size
	--the reference is about 60 fps, that means a lifetimefix of 1
	local lifetimefix = 1 - ((_frametime - .0166)/(.1 - .0166))
	if (lifetimefix < .1) then lifetimefix = .1  end
	for i=0, steps-1 do
		--use just 2 random number
		if (randomfactor~=0) then
			rnd1 = random(100-randomfactor,100+randomfactor)*.01
			rnd2 = random(100-randomfactor,100+randomfactor)*.01
		end
		--if we are using different sprites, check if we can use a random sprite.
		if (onesprite==0) then
			if (sprite[i+1]) then
				lastsprite = sprite[i+1]
				if (type(lastsprite)=="table") then
					local spriten = getn(lastsprite)
					if (spriten<=0) then return end
					lastsprite = lastsprite[random(1,spriten)]
				end
			end
		end
		--lastsprite nil? return.
		if (lastsprite==nil) then return end
		if (effect.size[i+1]) then
			lastsize = effect.size[i+1]
		end
		tempparticle.speed = effect.speed*rnd1
		tempparticle.size = lastsize*rnd2*extrascale*lifetimefix
		tempparticle.size_speed = effect.size_speed*rnd1*lifetimefix
		tempparticle.lifetime = effect.lifetime*rnd2*lifetimefix
		tempparticle.tid = lastsprite
		tempparticle.rotation.z = random(-rotation*10,rotation*10)*.1
		Particle:CreateParticle(temppos, tempdir, tempparticle)
		--go straight with the position.
		temppos.x = temppos.x + tempdir.x * stepoffset * extrascale
		temppos.y = temppos.y + tempdir.y * stepoffset * extrascale
		temppos.z = temppos.z + tempdir.z * stepoffset * extrascale
	end
end

function BasicWeapon:CanFireInThirdPerson(shooter,CurFireParams)
	if shooter.ai then return 1 end
	if shooter~=_localplayer then return 1 end
	local FireParams = CurFireParams
	if not FireParams then
		-- For mounted weapons or other unlimited ammo weapons
		if self.FireParams[1].AmmoType=="Unlimited" then
			FireParams = self.FireParams[1]
		else
			FireParams = shooter.fireparams
		end
	end
	if shooter.theVehicle and not FireParams.vehicleWeapon and not shooter.cnt.first_person then
		return nil
	end
	return 1
end
