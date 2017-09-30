Script:ReloadScript("scripts/materials/PhysicsSounds.lua")
-- Modified by Mixer
-- simple entity
BasicEntity = {
	Name = "BasicEntity",
	Properties = {
		object_Model = "",

		aianchorAIAction = "",
		fAnchorRadius = 0,

		Physics = {
			bRigidBody=0, -- True if rigid body.
			bRigidBodyActive = 1, -- If rigid body is originally created (1) OR will be created only on OnActivate (0).
			bActivateOnDamage = 0, -- Activate when a rocket hit the entity.
			bResting = 0, -- If rigid body is originally in resting state.
			Density = -1,
			Mass = 700,
			vector_Impulse = {x=1,y=2,z=3}, -- Impulse to apply at event.
			max_time_step = .01,
			sleep_speed = .04,
			damping = 0,
			water_damping = 0,
			water_resistance = 1000,
			water_density = 1000,
			Type="",
			bFixedDamping = 0,
			bUseSimpleSolver = 0,
			LowSpec = {
				bKeepRigidBody = 1,
				bRigidBody = 0,
				max_time_step = .025,
				sleep_speed = .04,
				bKeepMassAndWater = 1,
				Mass = 700,
				Density = -1,
				water_resistance = 1000,
				water_density = 1000,
			},
		},

		Animation = {
			Animation = "Default",
			Speed=1,
			bLoop=0,
			bPlaying=0,
		},

		AISoundEventOfCollision  = {
			fRadius = 0,
			fThreatening = 0,
			fIntersting = 0,
		},

		damage_players=0,
		sndAnimStart="",
		sndAnimStop="",
	},
	temp_vec = {x=0,y=0,z=0},
	animsoundstart = nil,
	animsoundstop = nil,
	animstarted = 0,
	-- CollideEffect = "other.phys_impact.phys_impact"
}


------------------------------
function BasicEntity:IsARigidBody()
	local qual=tonumber(getglobal("physics_quality"))
 	if qual>0 or self.Properties.Physics.LowSpec.bKeepRigidBody==1 then
		return self.Properties.Physics.bRigidBody
	end
	return self.Properties.Physics.LowSpec.bRigidBody
end

------------------------------
function BasicEntity:SetFromProperties()
	if (self.Properties.object_Model=="") then
		do return end
	end
	local bPhysicalize = 1
	if (self.ModelName~=self.Properties.object_Model) then
		self.ModelName = self.Properties.object_Model
		--bPhysicalize = 1

		-- try to load an animated model first
		if (self:LoadCharacter(self.ModelName,0)) then
			-- Needs to be updated when visible
			self.bCharacter = 1
			self:DrawCharacter(0,1)
		else
			-- Dont need to be updated.
			-- let's create either a rigid body or a normal static object
			self:LoadObject(self.ModelName,0,1)
			self.bCharacter = 0
			self:DrawObject(0,1) --param nPos(slot number), nMode(0 = Don't draw, 1 = Draw normally, 3 = Draw near)
		end
	end

	if (self.Properties.Animation.bPlaying~=self.bAnimPlaying or self.Properties.Animation.bLoop~=self.bAnimLoop or
			self.Properties.Animation.Animation~=self.AnimName) then
		self.bAnimPlaying = self.Properties.Animation.bPlaying
		self.bAnimLoop = self.Properties.Animation.bLoop
		self.AnimName = self.Properties.Animation.Animation
		if (self.Properties.Animation.bPlaying==1) then
			self:StartAnimation(0,self.Properties.Animation.Animation,0,0,1,self.Properties.Animation.bLoop)
		else
			self:ResetAnimation(0)
		end
	end
	self:SetAnimationSpeed(self.Properties.Animation.Speed)

	-- Set physics.
	self:SetPhysicsProperties(bPhysicalize,self.Properties.Physics.bRigidBodyActive)

	--self:EnablePhysics(1)

	self:SetSoundProperties()

	if (self.bCharacter==1) then
		if (self:IsARigidBody()==1) then
			-- Characters needs also to be updated when they are visible.
			self:SetUpdateType(eUT_PhysicsVisible)
		else
			self:SetUpdateType(eUT_Visible)
		end
	else
		if (self:IsARigidBody()==1) then
			-- Rigid bodies needs only to be updated when physics awake.
			self:SetUpdateType(eUT_Physics)
		else
			-- Static objects should be updated depending on when update is enabled.
			self:SetUpdateType(eUT_Always)
		end
	end

	self:GotoState("Default")
end

------------------------------
function BasicEntity:SetSoundProperties()
	-- load sounds
	self.SplashSound=Sound:Load3DSound("sounds/player/water/watersplash.wav", 0, 255, 2, 50)

	if (self.Properties.sndAnimStart~="") then
		self.animsoundstart=Sound:Load3DSound(self.Properties.sndAnimStart, 0,255,1,10)
	end

	if (self.Properties.sndAnimStop~="") then
		self.animsoundstop=Sound:Load3DSound(self.Properties.sndAnimStop, 0,255,1,10)
	end
end

------------------------------
-- Set Physics parameters.
------------------------------
function BasicEntity:SetPhysicsProperties(bPhysicalize,bActivateRigidBody)
  local Mass,Density,qual

	-- [marco] in multiplayer settings must be exactly the same
	-- on all machines
	if (Game:IsMultiplayer()) then
		-- if (Mission) and (Mission.soccer_center) then
			-- qual=1
		-- else
			qual=2
		-- end
	else
		qual = tonumber(getglobal("physics_quality"))
	end

  	if (qual>0 or self.Properties.Physics.LowSpec.bKeepMassAndWater==1) then
  	  	Mass    = self.Properties.Physics.Mass
  	  	Density = self.Properties.Physics.Density
	else
	    Mass    = self.Properties.Physics.LowSpec.Mass
  		Density = self.Properties.Physics.LowSpec.Density
	end

	if (self:IsARigidBody()==1) then
		-- Make Rigid body.
		if (bPhysicalize==1) then
			self:CreateRigidBody(Density,Mass,-1)
			if (self.bCharacter==1) then
				self:PhysicalizeCharacter(Mass,0,0,0)
			end
		end

		local SimParams = {
			max_time_step = self.Properties.Physics.max_time_step,
			sleep_speed = self.Properties.Physics.sleep_speed,
			damping = self.Properties.Physics.damping,
			water_damping = self.Properties.Physics.water_damping,
			water_resistance = self.Properties.Physics.water_resistance,
			water_density = self.Properties.Physics.water_density,
			mass = Mass,
			density = Density
		}

		if qual==0 then
		  SimParams.max_time_step = self.Properties.Physics.LowSpec.max_time_step
		  SimParams.sleep_speed = self.Properties.Physics.LowSpec.sleep_speed
		  if (self.Properties.Physics.LowSpec.bKeepMassAndWater==0) then
		    SimParams.water_resistance = self.Properties.Physics.LowSpec.water_resistance
			  SimParams.water_density = self.Properties.Physics.LowSpec.water_density
		  end
		end

		self.bRigidBodyActive = bActivateRigidBody
		if (bActivateRigidBody~=1) then
			-- If rigid body should not be activated, it must have 0 mass.
			SimParams.mass = 0
			SimParams.density = 0
		end

		local Flags = {flags_mask=pef_fixed_damping+ref_use_simple_solver, flags=0}
		Flags.flags = self.Properties.Physics.bFixedDamping*pef_fixed_damping
		if self.Properties.Physics.bUseSimpleSolver then
			Flags.flags = Flags.flags + self.Properties.Physics.bUseSimpleSolver*ref_use_simple_solver
		end

		self:SetPhysicParams(PHYSICPARAM_SIMULATION, SimParams)
		self:SetPhysicParams(PHYSICPARAM_BUOYANCY, self.Properties.Physics)
		self:SetPhysicParams(PHYSICPARAM_FLAGS, Flags)

		if (self.Properties.Physics.bResting==0) then
			self:EnableUpdate(1)
			self:AwakePhysics(1)
		else
			self:EnableUpdate(0)
			self:AwakePhysics(0)
		end

	else
		-- Not rigid body, not character.
		-- Make simple static physics.
		if (bPhysicalize==1) then
			self:CreateStaticEntity(self.Mass,-1)
			if (self.bCharacter==1) then
				self:PhysicalizeCharacter(Mass,0,0,0)
			end
		end
	end

	-- physics-sounds
	if (PhysicsSoundsTable) then
		local SoundDesc
		-- load soft contact sounds
		self.ContactSounds_Soft={}
		if (PhysicsSoundsTable.Soft and PhysicsSoundsTable.Soft[self.Properties.Physics.Type]) then
			SoundDesc=PhysicsSoundsTable.Soft[self.Properties.Physics.Type].Impact
			if (SoundDesc) then
				self.ContactSounds_Soft.Impact=Sound:Load3DSound(SoundDesc[1], SoundDesc[2], 255, SoundDesc[4], SoundDesc[5])
				self.ContactSounds_Soft.ImpactVolume=SoundDesc[3]
			end
			SoundDesc=PhysicsSoundsTable.Soft[self.Properties.Physics.Type].Roll
			if (SoundDesc) then
				self.ContactSounds_Soft.Roll=Sound:Load3DSound(SoundDesc[1], SoundDesc[2], 255, SoundDesc[4], SoundDesc[5])
				self.ContactSounds_Soft.RollVolume=SoundDesc[3]
			end
			SoundDesc=PhysicsSoundsTable.Soft[self.Properties.Physics.Type].Slide
			if (SoundDesc) then
				self.ContactSounds_Soft.Slide=Sound:Load3DSound(SoundDesc[1], SoundDesc[2], 255, SoundDesc[4], SoundDesc[5])
				self.ContactSounds_Soft.SlideVolume=SoundDesc[3]
			end
		else
			--System:Log("[BasicEntity] Warning: Table *PhysicsSoundsTable.Soft* or *PhysicsSoundsTable.Soft["..self.Properties.Physics.Type.."]* no found !")
		end
		-- load hard contact sounds
		self.ContactSounds_Hard={}
		if (PhysicsSoundsTable.Hard and PhysicsSoundsTable.Hard[self.Properties.Physics.Type]) then
			SoundDesc=PhysicsSoundsTable.Hard[self.Properties.Physics.Type].Impact
			if (SoundDesc) then
				self.ContactSounds_Hard.Impact=Sound:Load3DSound(SoundDesc[1], SoundDesc[2], 255, SoundDesc[4], SoundDesc[5])
				self.ContactSounds_Hard.ImpactVolume=SoundDesc[3]
			end
			SoundDesc=PhysicsSoundsTable.Hard[self.Properties.Physics.Type].Roll
			if (SoundDesc) then
				self.ContactSounds_Hard.Roll=Sound:Load3DSound(SoundDesc[1], SoundDesc[2], 255, SoundDesc[4], SoundDesc[5])
				self.ContactSounds_Hard.RollVolume=SoundDesc[3]
			end
			SoundDesc=PhysicsSoundsTable.Hard[self.Properties.Physics.Type].Slide
			if (SoundDesc) then
				self.ContactSounds_Hard.Slide=Sound:Load3DSound(SoundDesc[1], SoundDesc[2], 255, SoundDesc[4], SoundDesc[5])
				self.ContactSounds_Hard.SlideVolume=SoundDesc[3]
			end
		else
			--System:Log("[BasicEntity] Warning: Table *PhysicsSoundsTable.Hard* or *PhysicsSoundsTable.Hard["..self.Properties.Physics.Type.."]* no found !")
		end
	else
		--System:Log("[BasicEntity] Warning: Table *PhysicsSoundsTable* no found !")
	end
end

----------
function BasicEntity:OnReset()
	self:GotoState("Default")
	if (self:IsARigidBody()==1) then
		self:EnableUpdate(1-self.Properties.Physics.bResting)
		self:AwakePhysics(1-self.Properties.Physics.bResting)
	end
	self:StopLastPhysicsSounds()
	self:ResetAnimation(0)
	self.dhit = nil

	if self.Properties.aianchorAIAction~="" then
		AI:RegisterWithAI(self.id, AIAnchor[self.Properties.aianchorAIAction], self.Properties.fAnchorRadius)
	end

	if self.physpickup and self.weapon and self.Properties.Animation.sAmmotype_Primary then
		AI:RegisterWithAI(self.id,AIOBJECT_WEAPON)
		self.Properties.Animation.AvailableWeapon = 1
	end
	self.EntityDisabled = nil

	if self.autodelete then
		AI:RegisterWithAI(self.id,0)
		Server:RemoveEntity(self.id)
	end
end

----------
function BasicEntity:OnInit()
  self:RegisterState("Default")
  self:RegisterState("Activated")
	self.bRigidBodyActive = self.Properties.Physics.bRigidBodyActive
	if (self.Properties.Physics.bRigidBody==1) then
		self:NetPresent(1)
	else
		self:NetPresent(nil)
	end
	self:SetFromProperties()
end

----------
function BasicEntity:OnPropertyChange()
	self:SetFromProperties()
end

------------------------------
function BasicEntity:OnEvent(id, params)
	if (id==ScriptEvent_PhysicalizeOnDemand) then
		self:SetPhysicsProperties(0,self.bRigidBodyActive)
	end
end

-----------------
function BasicEntity:Event_Remove()
	if self.physpickup and self.weapon and self.Properties.Animation.sAmmotype_Primary then -- Не работает.
		AI:RegisterWithAI(self.id,0)
		self.Properties.Animation.AvailableWeapon = nil
	end
	self:DrawObject(0,0)
	self:DestroyPhysics()
end

----------------
function BasicEntity:Event_Hide()
	if self.physpickup and self.weapon and self.Properties.Animation.sAmmotype_Primary then -- Проверить.
		AI:RegisterWithAI(self.id,0)
		self.Properties.Animation.AvailableWeapon = nil
	end
	self:Hide(1)
end

-------------------
function BasicEntity:Event_UnHide()
	if self.physpickup and self.weapon and self.Properties.Animation.sAmmotype_Primary then -- Проверить.
		AI:RegisterWithAI(self.id,AIOBJECT_WEAPON)
		self.Properties.Animation.AvailableWeapon = 1
	end
	self:Hide(0)
end

------------------
function BasicEntity:Event_ResetAnimation()
	self:ResetAnimation(0)
	self:PlaySound(self.animsoundstop)
end

-----------------------
function BasicEntity:OnCollide(hit)
	-- Hud:AddMessage("OnCollide")
	if not self.CollideTime then self.CollideTime = _time end
	if self.EntityDisabled then -- Сработало касательно потерянного оружия.
		self.EntityDisabled = nil
		System:Log(self:GetName()..": BasicEntity/EntityEnable2")
		self:SetPhysicsProperties(0,1)
		self:EnableUpdate(1)
		self:AwakePhysics(1)
	end
	--Добавить: Если выбросил оружие, то оно издаёт для ИИ звук при падении. BasicWeapon.Server:Drop(Params)
	if self.Properties.AISoundEventOfCollision then
		if self.Properties.AISoundEventOfCollision.fRadius > 0 and (self.Properties.AISoundEventOfCollision.fThreatening > 0 or self.Properties.AISoundEventOfCollision.fIntersting > 0) then
			if self.Properties.AISoundEventOfCollision.fThreatening > 1 then
				self.Properties.AISoundEventOfCollision.fThreatening = 1
			end
			if self.Properties.AISoundEventOfCollision.fIntersting > 1 then
				self.Properties.AISoundEventOfCollision.fIntersting = 1
			end
			AI:SoundEvent(self.id,self:GetPos(),self.Properties.AISoundEventOfCollision.fRadius,self.Properties.AISoundEventOfCollision.fThreatening,self.Properties.AISoundEventOfCollision.fIntersting,_localplayer.id)
		end
	end
	-- if self.Properties.AISignalOfCollision then -- Ни так, ни сяк не отправляет...
		-- if self.Properties.AISignalOfCollision.signalRadius > 0 then
			-- AI:FreeSignal(1,self.Properties.AISignalOfCollision.signalText,self:GetPos(),self.Properties.AISignalOfCollision.signalRadius,_localplayer.id)
			-- -- AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,self.Properties.AISignalOfCollision.signalText,_localplayer.id)
		-- end
	-- end
	if (hit.impact) then
		-- Particle:SpawnEffect(self:GetPos(),{x=0,y=0,z=0},self.CollideEffect)
		if (self.Properties.Physics.HitDamageScale and self.Properties.Physics.HitDamageScale~=0) then
			if (self.OnDamage) then
				if (not self._localHitTable) then
					self._localHitTable = {pos={x=0,y=0,z=0},}
				end
				local pos = self:GetPos()
				self._localHitTable.damage = hit.fSpeed*self.Properties.Physics.HitDamageScale
				self._localHitTable.pos.x = pos.x
				self._localHitTable.pos.y = pos.y
				self._localHitTable.pos.z = pos.z
				self:OnDamage(self._localHitTable)
			end
		end
	end

	if (self.Properties.Physics.Type) then
		local mat=Game:GetMaterialBySurfaceID(hit.matId)
		if (mat and mat.PhysicsSounds) then
			local NewPhysicsSounds
			if (mat.PhysicsSounds==PhysicsSoundsTable.Soft) then
				NewPhysicsSounds=self.ContactSounds_Soft
			else
				NewPhysicsSounds=self.ContactSounds_Hard
			end
			if (NewPhysicsSounds~=self.LastPhysicsSounds) then
				self:StopLastPhysicsSounds()
			end
			self.LastPhysicsSounds=NewPhysicsSounds
			if (self.LastPhysicsSounds and self.LastPhysicsSounds.ImpactVolume) then
				if (hit.impact) then
					local Volume=hit.impact*.1
					if (Volume>1) then Volume=1  end

					local finalvol=Volume*self.LastPhysicsSounds.ImpactVolume
					if (self.LastPhysicsSounds.Impact and finalvol>1) then
						self:PlaySound(self.LastPhysicsSounds.Impact)
						Sound:SetSoundVolume(self.LastPhysicsSounds.Impact, finalvol)
					end
				end
				local Volume
				if (hit.roll) then
				  Volume=(hit.roll-.1)*.1
				else
				  Volume = 0
				end
				if (Volume>1) then Volume=1  end

				if (self.LastPhysicsSounds.Roll) then
					local rollvol=Volume*self.LastPhysicsSounds.RollVolume

					if (rollvol>1) then
						if (not Sound:IsPlaying(self.LastPhysicsSounds.Roll)) then
							self:PlaySound(self.LastPhysicsSounds.Roll)
						end
						Sound:SetSoundVolume(self.LastPhysicsSounds.Roll, rollvol)
						Sound:SetSoundFrequency(self.LastPhysicsSounds.Roll, Volume*400+800)
						--System:Log("Roll: "..hit.roll)
					end
				end
				if (hit.slide) then
					Volume=(hit.slide-.1)*.1
				else
					Volume = 0
				end
				if (Volume>1) then Volume=1  end

				if (self.LastPhysicsSounds.Slide) then
					local slidevol=Volume*self.LastPhysicsSounds.SlideVolume

					if (slidevol>1) then
						if (not Sound:IsPlaying(self.LastPhysicsSounds.Slide)) then
							self:PlaySound(self.LastPhysicsSounds.Slide)
						end
						Sound:SetSoundVolume(self.LastPhysicsSounds.Slide,slidevol)
						Sound:SetSoundFrequency(self.LastPhysicsSounds.Slide, Volume*400+800)
						--System:Log("Slide: "..hit.slide)
					end
				end
			end
		end
	end

	if (hit.splashes) then

		if (g_lastSplashTime+g_SplashDuration < _time) then g_curSplashes = 0  end

		for i,splash in hit.splashes do
			if (g_curSplashes<g_maxSplashes) then
				--System:Log("splash : ("..splash.center.x..","..splash.center.y..","..splash.center.z.."), radius "..splash.radius)
				ExecuteMaterial(splash.center, g_Vectors.v001, CommonEffects.water_splash, 1)
				g_curSplashes = g_curSplashes+1  g_lastSplashTime = _time
			end
		end

	end
	-- local FPS = tonumber(getglobal("FPS"))
	-- if FPS and (FPS<24 or (self.TimeToEnablePhysics and self.TimeToEnablePhysics and FPS<35)) then -- Если условие верно, то для выхода потребуется больше 35 fps.
		-- -- self:EnablePhysics(0)
		-- self:EnableUpdate(0)
		-- self.TimeToEnablePhysics=_time
	-- elseif self.TimeToEnablePhysics and _time>self.TimeToEnablePhysics+1 then
		-- self.TimeToEnablePhysics=nil
		-- -- self:EnablePhysics(1)
		-- self:EnableUpdate(0)
		-- if (self.sliding_sound and Sound:IsPlaying(self.sliding_sound)==1) then
			-- Sound:StopSound(self.sliding_sound)
		-- end
		-- if (self.break_sound and Sound:IsPlaying(self.break_sound)==1) then
			-- Sound:StopSound(self.break_sound)
		-- end
	-- end
end

------------------------------
function BasicEntity:StopLastPhysicsSounds()
	self:OnStopRollSlideContact("roll")
	self:OnStopRollSlideContact("slide")
end

------------------------------
function BasicEntity:OnStopRollSlideContact(ContactType)
	if (self.LastPhysicsSounds) then
		if (ContactType=="roll") then -- and (Sound:IsPlaying(self.LastPhysicsSounds.Roll))) then
			--System:Log("Stopping Roll")
			Sound:StopSound(self.LastPhysicsSounds.Roll)
		end
		if (ContactType=="slide") then -- and (Sound:IsPlaying(self.LastPhysicsSounds.Slide))) then
			--System:Log("Stopping Slide")
			Sound:StopSound(self.LastPhysicsSounds.Slide)
		end
	end
end

------------------------------
function BasicEntity:OnShutDown()
	self:StopLastPhysicsSounds()
end

function BasicEntity:OnDamage(hit)
		if self.EntityDisabled then
			self.EntityDisabled = nil
			System:Log(self:GetName()..": BasicEntity/EntityEnable3") -- Есть
			self:SetPhysicsProperties(0,1)
			self:EnableUpdate(1)
			self:AwakePhysics(1)
		end
	if (self:IsARigidBody()==1) then
		if (self.Properties.Physics.bActivateOnDamage==1) then
			if (hit.explosion) and (self:GetState()~="Activated") then
				BroadcastEvent(self, "Activate")
				self:GotoState("Activated")
			end
		end
		if (hit.shooter) and (hit.shooter.cnt) and (hit.shooter.cnt.weapon) and (hit.shooter.cnt.weapon.hit_delay) then
			self.dhit = hit
			self:SetTimer(hit.shooter.cnt.weapon.hit_delay*1000)
			return
		end
	end

	if (hit.ipart and hit.ipart>=0) then
		self:AddImpulse(hit.ipart, hit.pos, hit.dir, hit.impact_force_mul)
	end
end

function BasicEntity:CheckFPS() -- OnUpdate, само собой, что физика уже активна и можно вручную включать и выключать. -- Апдейт отрубается как только вырубается физика.
	-- В редакторе надо отключить пока ресета не будет.
	-- if not UI and Game:IsClient() then
	-- if not UI then and Game:IsClient() return end
	local FPS = tonumber(getglobal("FPS"))
	local GetState = self:GetState()
	-- System:Log(self:GetName()..": CheckFPS, "..GetState)
	-- if FPS and (FPS<24 or (self.TimeToEnablePhysics and self.TimeToEnablePhysics and FPS<35)) then -- Если условие верно, то для выхода потребуется больше 35 fps.
	-- if FPS and FPS<=5 and not self.EntityDisabled and not self.weapon then
	-- if not self.EntityDisabled and FPS and ((FPS<=5 and not self.weapon) or (FPS<=1 and self.weapon)) then -- Лучше что-бы было при критическом показателе. Тест. -- 24
	if not self.EntityDisabled and FPS and FPS<=24 and self.weapon and self.CollideTime and _time>self.CollideTime+5 then
		self.CollideTime=nil
		-- self.TimeToEnablePhysics=_time
		self.EntityDisabled=1
					-- По отдельности:
		self:SetPhysicsProperties(0,0) -- После отключения не включает.
		self:EnableUpdate(0) -- Не помогает.
		self:AwakePhysics(0) -- Почти сразу замирает.
		-- System:Log(self:GetName()..": Disable entity on low fps, state: "..GetState)
		-- System:Log(self:GetName()..": Disable weapon physics on low fps, state: "..GetState)
	-- elseif self.TimeToEnablePhysics and _time>self.TimeToEnablePhysics+1 then
	-- else
		-- -- self.TimeToEnablePhysics=nil
		-- -- self:EnablePhysics(1)
		-- -- self:EnableUpdate(0)
		-- System:Log(self:GetName()..": Enable entity on normal fps, state: "..GetState)
		-- -- if GetState=="Default" then
			-- if (self:IsARigidBody()==1) then
				-- if (self.bRigidBodyActive~=self.Properties.Physics.bRigidBodyActive) then
					-- self:SetPhysicsProperties(0,self.Properties.Physics.bRigidBodyActive)
				-- else
					-- self:EnableUpdate(1-self.Properties.Physics.bResting)
					-- self:AwakePhysics(1-self.Properties.Physics.bResting)
				-- end
			-- else
				-- self:EnableUpdate(0)
			-- end
		-- -- else
			-- -- if (self:IsARigidBody()==1 and self.bRigidBodyActive==0) then
				-- -- self:SetPhysicsProperties(0,1)
				-- -- self:EnableUpdate(1)
				-- -- self:AwakePhysics(1)
			-- -- end
		-- -- end
	end
end

--------------
-- Input events
--------------
function BasicEntity:Event_AddImpulse(sender)
  local len = sqrt(LengthSqVector(self.Properties.Physics.vector_Impulse))
  if (len>0) then
    local rlen = 1/len
	  self.temp_vec.x=self.Properties.Physics.vector_Impulse.x*rlen
	  self.temp_vec.y=self.Properties.Physics.vector_Impulse.y*rlen
	  self.temp_vec.z=self.Properties.Physics.vector_Impulse.z*rlen
	  self:AddImpulse(0,nil,self.temp_vec,len)
	end
end

-------------
function BasicEntity:Event_Activate(sender)
	self:GotoState("Activated")
end

------------------------------
function BasicEntity:StartEntityAnimation()
	self:ResetAnimation(0)
	self:StartAnimation(0,self.Properties.Animation.Animation,0,0,1,self.Properties.Animation.bLoop)
	self:SetAnimationSpeed(self.Properties.Animation.Speed)
	self:PlaySound(self.animsoundstart)
end

------------------------------
function BasicEntity:Event_StartAnimation(sender)
	self:StartEntityAnimation()
	self.animstarted=1
end

------------------------------
function BasicEntity:Event_StopAnimtion(sender)
	self:ResetAnimation(0)
	self:PlaySound(self.animsoundstop)
end

------------------------------
-- Events to switch material Applied to object.
------------------------------
function BasicEntity:CommonSwitchToMaterial(numStr)
	if (not self.sOriginalMaterial) then
		self.sOriginalMaterial = self:GetMaterial()
	end

	if (self.sOriginalMaterial) then
		System:Log("Material: "..self.sOriginalMaterial..numStr)
		self:SetMaterial(self.sOriginalMaterial..numStr)
	end
end

------------------------------
function BasicEntity:Event_SwitchToMaterialOriginal(sender)
	self:CommonSwitchToMaterial("")
end

------------------------------
function BasicEntity:Event_SwitchToMaterial1(sender)
	self:CommonSwitchToMaterial("1")
end
------------------------------
function BasicEntity:Event_SwitchToMaterial2(sender)
	self:CommonSwitchToMaterial("2")
end

------------------------------
function BasicEntity:OnSave(stm)

	stm:WriteInt(self.animstarted)

end

------------------------------
function BasicEntity:OnLoad(stm)
	self.animstarted=stm:ReadInt()
	if (self.animstarted==1) then
		self:StartEntityAnimation()
	end
end

function BasicEntity:OnLoadRELEASE(stm)
end

BasicEntity.Default = {
	OnBeginState = function(self)
		if self.EntityDisabled then
			self.EntityDisabled = nil
			System:Log(self:GetName()..": BasicEntity/EntityEnable6")
			self:SetPhysicsProperties(0,1)
			self:EnableUpdate(1)
			self:AwakePhysics(1)
		end
		if (self:IsARigidBody()==1) then
			if (self.bRigidBodyActive~=self.Properties.Physics.bRigidBodyActive) then
				self:SetPhysicsProperties(0,self.Properties.Physics.bRigidBodyActive)
			else
				self:EnableUpdate(1-self.Properties.Physics.bResting)
				self:AwakePhysics(1-self.Properties.Physics.bResting)
			end
		else
			self:EnableUpdate(0)
		end
	end,
	OnDamage = BasicEntity.OnDamage,
	OnCollide = BasicEntity.OnCollide,
	OnTimer = function(self)
		if (self.dhit) and (self.dhit.ipart and self.dhit.ipart>=0) then
			self:AddImpulse(self.dhit.ipart, self.dhit.pos, self.dhit.dir, self.dhit.impact_force_mul)
			self.dhit = nil
		end
	end,
	OnContact = function(self,entity)
		-- -- if self.EntityDisabled then
			-- -- self.EntityDisabled = nil
			-- -- System:Log(self:GetName()..": BasicEntity/EntityEnable10")
			-- -- self:SetPhysicsProperties(0,1)
			-- -- self:EnableUpdate(1)
			-- -- self:AwakePhysics(1)
		-- -- end
	end,
	OnUpdate = function(self)
		self:CheckFPS()
	end,
}

BasicEntity.Activated = {-- По триггеру, к примеру.
	OnBeginState = function(self)
		if self.EntityDisabled then
			self.EntityDisabled = nil
			System:Log(self:GetName()..": BasicEntity/EntityEnable5")
			-- self:SetPhysicsProperties(0,1)
			-- self:EnableUpdate(1)
			-- self:AwakePhysics(1)
		end
		if (self:IsARigidBody()==1 and self.bRigidBodyActive==0) then
			self:SetPhysicsProperties(0,1)
			self:EnableUpdate(1)
			self:AwakePhysics(1)
		end
	end,
	OnDamage = BasicEntity.OnDamage,
	OnCollide = BasicEntity.OnCollide,
	OnTimer = function(self)
		if (self.dhit) and (self.dhit.ipart and self.dhit.ipart>=0) then
			self:AddImpulse(self.dhit.ipart, self.dhit.pos, self.dhit.dir, self.dhit.impact_force_mul)
			self.dhit = nil
		end
	end,
	OnContact = function(self,entity)
		-- System:Log(entity:GetName()..": BasicEntity/EntityEnable11")
		-- -- if self.EntityDisabled then -- Цикл деактивация/активация.
			-- -- self.EntityDisabled = nil
			-- -- -- System:Log(self:GetName()..": BasicEntity/EntityEnable11")
			-- -- self:SetPhysicsProperties(0,1)
			-- -- self:EnableUpdate(1)
			-- -- self:AwakePhysics(1)
		-- -- end
	end,
	OnUpdate = function(self)
		self:CheckFPS()
	end,
}