WeaponScope={
	overlay_func = nil,
	-- Положительные: X - влево,Y - на себя,Z - вверх.
	v_01010 = {x=.11,y=.09,z=.05},
	v_M4 = {x=.07,y=.09,z=.06},
	-- v_M249 = {x=.03,y=-.07,z=.08},-- Тоже видна "пустота".
	v_M249 = {x=0,y=0,z=0},
	v_P90 = {x=.08,y=.1,z=.07},
	-- v_Shotgun = {x=.03,y=-.020,z=.09},-- Для дробовика трудно подобрать.
	v_Shotgun = {x=0,y=0,z=0},
	v_MP5 = {x=.06,y=-.01,z=.06},
	v_Falcon = {x=.1,y=.05,z=.08},
	temp = {},
	target_pos_temp = {},
	LastZoom = 1,
}
-------------------------------------------------------
function WeaponScope:OnActivate()
	local w=_localplayer.cnt.weapon
	if (w) then
		--System:Log("Aiming = TRUE")
		_localplayer.cnt.aiming = 1
		self.PrevZoomStep = nil

		if w.ZoomOverlayFunc and w.AimMode~=2 then					--IronSights
			--System:Log("WeaponScope -> ZoomOverlayFunc")
			self.overlay_func=w.ZoomOverlayFunc
		else
			--System:Log("WeaponScope -> Default OverlayFunc")
			self.overlay_func=DefaultZoomHUD.DrawHUD
			--FIX THIS
			-- DefaultZoomHUD.MulMask = _localplayer.fireparams.ScopeTexId -- Реалистичные прицелы.
			DefaultZoomHUD.MulMask = nil 							--IronSights
		end

		if w.ZoomOverlayFunc and w.AimMode==2 then	
			-- _localplayer.cnt.bForceWalk = 1
		end

		if (w.MaxZoomSteps) then
			ZoomView.MaxZoomSteps = w.MaxZoomSteps
			ZoomView.ZoomSteps = w.ZoomSteps
		else
			ZoomView.MaxZoomSteps = 3
			ZoomView.ZoomSteps = {2,4,6}
		end

		if (w.DoesFTBSniping) then
			self.fade=_time
			self.has_aimmode=1
			ZoomView.CurrZoomStep = 1
		elseif (w.AimMode) then
			self.fade=_time
			self.has_aimmode=1
			ZoomView.CurrZoomStep = 1
		else
			self.has_aimmode = nil
			ZoomView.CurrZoomStep = min(self.LastZoom,ZoomView.MaxZoomSteps)
			_localplayer.cnt.drawfpweapon = nil
		end

		if (w.DoesFTBSniping) then
			_localplayer.cnt.weapon_busy = w:GetAnimationLength("StartSniping")
			w:StartAnimation(0,"StartSniping",0,.3)
		else
			ZoomView:Activate(nil,w.Sway,w.ZoomFixedFactor,w.AimMode)
		end
	end
end
-------------------------------------------------------
function WeaponScope:OnDeactivate(nofade)
	--System:Log("WeaponScope:OnDeactivate")

	-- this check is necessary to allow 'double-clicking' of aim button
	if ((not ClientStuff.vlayers:IsActive("WeaponScope")) or nofade) then
		self.fade = nil
		self.target_pos = nil
		self.blend = nil

		if _localplayer.cnt.drawfpweapon~=1 then
			_localplayer.cnt.drawfpweapon = 1
		end

		local w=_localplayer.cnt.weapon
		r_ScreenRefract=0
		-- [MarcoK] M5 change request
		--self.LastZoom=ZoomView.CurrZoomStep
		self.LastZoom=1
		ZoomView:Deactivate()
		_localplayer.cnt.bForceWalk = nil

		if (ClientStuff.vlayers:IsActive("Binoculars")) then
			_localplayer.cnt.drawfpweapon = nil
		end

		--System:Log("Aiming = NIL")
		_localplayer.cnt.aiming = nil
		if (w) then
			w.cnt:SetFirstPersonWeaponPos(g_Vectors.v000,g_Vectors.v000)
		end
	end
end
-------------------------------------------------------
function WeaponScope:OnFadeOut()
	--System:Log("WeaponScope:OnFadeOut")
	local w=_localplayer.cnt.weapon
	r_ScreenRefract=0
	if (not self.has_aimmode) then
		self:OnDeactivate()
		return 1
	elseif (ZoomView:FadeOut()) then
		self:OnDeactivate()
		return 1
	end

	if (self.has_aimmode) then
		if (w and w.AimMode==2 and _localplayer.cnt.drawfpweapon~=1) then					--IronSights
			_localplayer.cnt.drawfpweapon = 1
		end
		local pos = self.temp
		local srcPos
		if (self.target_pos) then
			srcPos = self.target_pos
		else
			srcPos = self.v_01010
		end
		pos.x = srcPos.x
		pos.y = srcPos.y
		pos.z = srcPos.z

--------------------Iron Sights 10/29/09--------------------
		local IronSights = getglobal("g_enableironsights")
		if (w and w.AimOffset and ((IronSights and IronSights>="1") or w.AimMode==2)) then
			pos.x = w.AimOffset.x
			pos.y = w.AimOffset.y
			pos.z = w.AimOffset.z
		end
--------------------Iron Sights 10/29/09--------------------

		if (self.blend) then
			local theBlend = ZoomView.blend
			--System:Log("theBlend "..tostring(theBlend))
			if (theBlend < 0) then
				theBlend = 0
			end

			ScaleVectorInPlace(pos,theBlend)
			if (w) then
				-- w.cnt:SetFirstPersonWeaponPos(pos,g_Vectors.v000)
--------------------Iron Sights 10/29/09--------------------
				local AngleOffset = {x=0,y=0,z=0}
				local IronSights = getglobal("g_enableironsights")
				if ( w.AimAngleOffset and IronSights and IronSights>="1" ) then
					AngleOffset.x = w.AimAngleOffset.x
					AngleOffset.y = w.AimAngleOffset.y
					AngleOffset.z = w.AimAngleOffset.z
				end
				ScaleVectorInPlace(AngleOffset,theBlend)

				if w.NewPos and pos~=w.NewPos then -- Управление находится в OnUpdate.
					pos = w.NewPos
				end
				if w.NewAngle and AngleOffset~=w.NewAngle then
					AngleOffset = w.NewAngle
				end
				local Correction = w.Correction
				if w.NewCorrection and Correction~=w.NewCorrection then
				-- if w.NewCorrection then
					Correction = w.NewCorrection
				end
				w.cnt:SetFirstPersonWeaponPos(pos,AngleOffset,Correction)
--------------------Iron Sights 10/29/09--------------------
			end
		end
	end
end
-------------------------------------------------------
function WeaponScope:DrawOverlay()
	if (self.overlay_func and not self.fade) or (self.fade and self.state~=1) then
		self:overlay_func(ZoomView.CurrZoomStep) -- Значит вызывалось что-то из crygame
	end
	if (self.DoesFTBSniping and self.state~=1) then
		FTBSniping:OnEnhanceHUD()
	end
end
-------------------------------------------------------
function WeaponScope:OnUpdate()
	local w = _localplayer.cnt.weapon

	-- if _localplayer.fireparams then -- Управление позицией наведения.
		-- local NewPos = w.AimOffset -- Позиция.
		-- if NewPos then
			-- local PrevPos = new(NewPos)
			-- -- local KeyPress = Input:GetXKeyPressedName()
			-- local KeyPress = Input:GetXKeyDownName()
			-- if KeyPress then
				-- if (KeyPress == "m") then -- numpad4
					-- NewPos.x = NewPos.x + .0001
					-- Hud:AddMessage("Pos Offset x: "..NewPos.x)
				-- elseif (KeyPress == ".") then
					-- NewPos.x = NewPos.x - .0001
					-- Hud:AddMessage("Pos Offset x: "..NewPos.x)
				-- elseif (KeyPress == "k") then
					-- NewPos.z = NewPos.z + .0001
					-- Hud:AddMessage("Pos Offset z: "..NewPos.z)
				-- elseif (KeyPress == ",") then
					-- NewPos.z = NewPos.z - .0001
					-- Hud:AddMessage("Pos Offset z: "..NewPos.z)
				-- elseif (KeyPress == "divide") then -- divide
					-- NewPos.y = NewPos.y + .01
					-- Hud:AddMessage("Pos Offset y: "..NewPos.y)
				-- elseif (KeyPress == "multiply") then -- multiply
					-- NewPos.y = NewPos.y - .01
					-- Hud:AddMessage("Pos Offset y: "..NewPos.y)
				-- end
				-- if NewPos~=PrevPos then
					-- w.NewPos = NewPos
					-- -- w.NewAngle = {0,0,0}
					-- System:LogAlways("New Pos: {x="..NewPos.x..", y="..NewPos.y..", z="..NewPos.z.."},")
				-- end
			-- end
		-- end

		-- local NewAngle = w.AimAngleOffset -- Угол.
		-- if NewAngle then
			-- local PrevAngle = new(NewAngle)
			-- -- local KeyPress = Input:GetXKeyPressedName()
			-- local KeyPress = Input:GetXKeyDownName()
			-- if KeyPress then
				-- if (KeyPress == "down") then
					-- NewAngle.x = NewAngle.x + .01
					-- Hud:AddMessage("Ang Offset x: "..NewAngle.x)
				-- elseif (KeyPress == "up") then
					-- NewAngle.x = NewAngle.x - .01
					-- Hud:AddMessage("Ang Offset x: "..NewAngle.x)
				-- elseif (KeyPress == "left") then
					-- NewAngle.z = NewAngle.z + .01
					-- Hud:AddMessage("Ang Offset z: "..NewAngle.z)
				-- elseif (KeyPress == "right") then
					-- NewAngle.z = NewAngle.z - .01
					-- Hud:AddMessage("Ang Offset z: "..NewAngle.z)
				-- elseif (KeyPress == "subtract") then
					-- NewAngle.y = NewAngle.y + .01
					-- Hud:AddMessage("Ang Offset y: "..NewAngle.y)
				-- elseif (KeyPress == "add") then
					-- NewAngle.y = NewAngle.y - .01
					-- Hud:AddMessage("Ang Offset y: "..NewAngle.y)
				-- end
				-- if NewAngle~=PrevAngle then
					-- w.NewAngle = NewAngle
					-- System:LogAlways("New Angle: {x="..NewAngle.x..", y="..NewAngle.y..", z="..NewAngle.z.."},")
				-- end
			-- end
		-- end
	-- end

	-- Шаг 1
	-- if _localplayer.fireparams then
		-- local NewCorrection = w.Correction
		-- if NewCorrection then
			-- local PrevCorrection = {NewCorrection}
			-- local KeyPress = Input:GetXKeyDownName()
			-- if KeyPress then
				-- if (KeyPress == "left") then
					-- NewCorrection = NewCorrection - .001
					-- Hud:AddMessage("Correction Offset: "..NewCorrection)
				-- elseif (KeyPress == "right") then
					-- NewCorrection = NewCorrection + .001
					-- Hud:AddMessage("Correction Offset: "..NewCorrection)
				-- end
				-- if NewCorrection~=PrevCorrection[1] then
					-- w.NewCorrection = NewCorrection
					-- w.Correction = NewCorrection
					-- System:LogAlways("New Correction: "..NewCorrection)
				-- end
			-- end
		-- end
	-- end
		
	if (w.DoesFTBSniping and self.state==2) or not w.DoesFTBSniping then
		ZoomView:OnUpdate()
	end


	ZoomView.StanceSwayModifier = 1

	if (w.DoesFTBSniping) then
		if (_time-self.fade<.4) then
			--System:Log("STATE 1")
			self.state=1
			ZoomView:Reset()
		else
			if (self.state==1) then
				--System:Log("STATE 1 >> STATE 2")
				self.state=2
				_localplayer.cnt.drawfpweapon = nil
				ZoomView:Activate(nil,w.Sway,w.ZoomFixedFactor,w.AimMode)
				FTBSniping:OnActivate()
				r_ScreenRefract=2
			end
			if (_localplayer.cnt.proning) then
				ZoomView.StanceSwayModifier = _localplayer.SwayModifierProning
			elseif (_localplayer.cnt.crouching) then
				ZoomView.StanceSwayModifier = _localplayer.SwayModifierCrouching
			else
				ZoomView.StanceSwayModifier = 1
			end
			FTBSniping:OnUpdate()
		end

	end
	if (w.AimMode) then
		-- Hud:AddMessage("w.AimMode")
		if (self.target_pos==nil) then
			local pos = self.target_pos_temp
			pos.x=self.v_01010.x
			pos.y=self.v_01010.y
			pos.z=self.v_01010.z
			--adjust some specific weapon positions
			if (w.name=="M4") then
				pos.x=self.v_M4.x
				pos.y=self.v_M4.y
				pos.z=self.v_M4.z
			elseif (w.name=="M249") then
			-- if (w.name=="M249") then
				pos.x=self.v_M249.x
				pos.y=self.v_M249.y
				pos.z=self.v_M249.z
			elseif (w.name=="P90") then
				pos.x=self.v_P90.x
				pos.y=self.v_P90.y
				pos.z=self.v_P90.z
			elseif (w.name=="Shotgun") then
				pos.x=self.v_Shotgun.x
				pos.y=self.v_Shotgun.y
				pos.z=self.v_Shotgun.z
			elseif (w.name=="MP5") then
				pos.x=self.v_MP5.x
				pos.y=self.v_MP5.y
				pos.z=self.v_MP5.z
			elseif (w.name=="Falcon") then
				pos.x=self.v_Falcon.x
				pos.y=self.v_Falcon.y
				pos.z=self.v_Falcon.z
			end

--------------------IronSights 10/29/09--------------------
			local IronSights = getglobal("g_enableironsights")
			if (w.AimOffset and ((IronSights and IronSights>="1") or w.AimMode==2)) then
				pos.x = w.AimOffset.x
				pos.y = w.AimOffset.y
				pos.z = w.AimOffset.z
			end
--------------------IronSights 10/29/09--------------------

			self.target_pos = pos
		end

		local pos = self.temp
		pos.x = self.target_pos.x
		pos.y = self.target_pos.y
		pos.z = self.target_pos.z

		if (self.fade) then
			-- if (self.blend==nil) then
				-- self.blend = 0
			-- end
			-- --self.blend = self.blend + _frametime/.4
			-- self.blend = ZoomView.blend
			-- if (self.blend > 1) then
				-- self.blend = 1
			-- end
			-- ScaleVectorInPlace(pos,self.blend)
			-- w.cnt:SetFirstPersonWeaponPos(pos,g_Vectors.v000)
--------------------IronSights 10/29/09--------------------
			local AngleOffset = {x=0,y=0,z=0}
			local IronSights = getglobal("g_enableironsights")
			if (w.AimAngleOffset and IronSights and IronSights>="1") then
				AngleOffset.x = w.AimAngleOffset.x
				AngleOffset.y = w.AimAngleOffset.y
				AngleOffset.z = w.AimAngleOffset.z
				-- Hud:AddMessage("AngleOffset")
			end
			if (self.blend==nil) then
				self.blend = 0
			end
			--self.blend = self.blend + _frametime/.4
			self.blend = ZoomView.blend
			if (self.blend > 1) then
				self.blend = 1
			end
			local IronSights = getglobal("g_enableironsights")
			if IronSights and IronSights<="1" then -- При большем значении отображения hud прицела не будет.
				if (self.blend==1 and (IronSights=="1" or w.AimMode==2)) then
					if (w.ZoomOverlayFunc and self.overlay_func~=w.ZoomOverlayFunc) then
						self.overlay_func=w.ZoomOverlayFunc
						_localplayer.cnt.drawfpweapon = nil
					end
					if (_localplayer.fireparams.ScopeTexId and DefaultZoomHUD.MulMask==nil) then
						DefaultZoomHUD.MulMask = _localplayer.fireparams.ScopeTexId
						_localplayer.cnt.drawfpweapon = nil
					end
				end
			end
			-- System:Log("pos0 "..tostring(theBlend)..", pos: x: "..pos.x..", y: "..pos.y..", z: "..pos.z)
			ScaleVectorInPlace(pos,self.blend)
			-- System:Log("pos1 "..tostring(theBlend)..", pos: x: "..pos.x..", y: "..pos.y..", z: "..pos.z)
			-- System:Log("theBlend "..tostring(theBlend)..", AngleOffset: x: "..AngleOffset.x..", y: "..AngleOffset.y..", z: "..AngleOffset.z)
			ScaleVectorInPlace(AngleOffset,self.blend)  -- Стабильно.
			-- System:Log("theBlen2 "..tostring(theBlend)..", AngleOffset: x: "..AngleOffset.x..", y: "..AngleOffset.y..", z: "..AngleOffset.z)
			-- ScaleVectorInPlace(AngleOffset,0) -- тест
			if w.NewPos and pos~=w.NewPos then -- Управление находится в OnUpdate.
				pos = w.NewPos
			end
			if w.NewAngle and AngleOffset~=w.NewAngle then
				AngleOffset = w.NewAngle
			end
			local Correction = w.Correction
			if w.NewCorrection and Correction~=w.NewCorrection then
			-- if w.NewCorrection then
				Correction = w.NewCorrection
			end
			w.cnt:SetFirstPersonWeaponPos(pos,AngleOffset,Correction)
--------------------IronSights 10/29/09--------------------
		end
	end
end