Script:ReloadScript("Scripts/Default/Entities/Others/BasicEntity.lua")

BreakableObject={
	Properties = {
		object_Model="", -- Default must be empty.
		nDamage=10,
		fBreakImpuls = 7,	-- impuls applayed when the object is broken
		nExplosionRadius=5,
		bExplosion=1,
		bTriggeredOnlyByExplosion=0,
		impulsivePressure=200, -- physics params
		rmin = 2, -- physics params
		rmax = 20.5, -- physics params
		Parts = {
			bRigidBody = 0,
			LifeTime = 20,
			Density = 100,
		},
		DyingSound={
			sndFilename="",
			InnerRadius=1,
			OuterRadius=10,
			nVolume=255,
		},
		Physics = {
			bRigidBody=0, -- True if rigid body.
			bRigidBodyActive = 1, -- If rigid body is originally created (1) OR will be created only on OnActivate (0).
			bActivateOnDamage = 0, -- Activate when a rocket hit the entity.
			bResting = 0, -- If rigid body is originally in resting state.
			Density = -1,
			Mass = 700,
			vector_Impulse = {x=0,y=0,z=0}, -- Impulse to apply at event.
			max_time_step = .01,
			sleep_speed = .04,
			damping = 0,
			water_damping = 0,
			water_resistance = 1000,	
			water_density = 1000,
			Type="Unknown",
			bFixedDamping = 0,
			HitDamageScale = 0,
		},
	},
	
	bBreakByCar=1,
	
	dead = 0,
	deathVector = {x=0,y=0,z=1},
	
	isLoading = nil,

	StopLastPhysicsSounds = BasicEntity.StopLastPhysicsSounds,
	OnStopRollSlideContact = BasicEntity.OnStopRollSlideContact,
}

function BreakableObject:OnInit()

	self:RegisterState("Active")
	self:RegisterState("Dead")

	self:EnableUpdate(0)
	self:TrackColliders(1)
	self.dead = 0 
	self:OnReset()
end

function BreakableObject:OnPropertyChange()
	self:OnReset()
end

function BreakableObject:OnShutDown()

end

function BreakableObject:SetPhysicsProperties()
	if (self.Properties.Physics.bRigidBody~=1) then
		return 
	end

  local Mass,Density,qual 
  
 	Mass    = self.Properties.Physics.Mass  
 	Density = self.Properties.Physics.Density 
 	
  
		-- Make Rigid body.
	self:CreateRigidBody(Density,Mass,-1)
	if (self.bCharacter==1) then
		self:PhysicalizeCharacter(Mass,0,0,0)
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
	
	
		self.bRigidBodyActive = self.Properties.Physics.bRigidBodyActive 
		if (self.bRigidBodyActive~=1) then
			-- If rigid body should not be activated, it must have 0 mass.
			SimParams.mass = 0 
			SimParams.density = 0 
		end

		local Flags = {flags_mask=pef_fixed_damping, flags=0} 
		if (self.Properties.Physics.bFixedDamping~=0) then
			Flags.flags = pef_fixed_damping 
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
				--Sound:SetSoundLoop(self.ContactSounds_Soft.Roll, 1)
			end
			SoundDesc=PhysicsSoundsTable.Soft[self.Properties.Physics.Type].Slide 
			if (SoundDesc) then
				self.ContactSounds_Soft.Slide=Sound:Load3DSound(SoundDesc[1], SoundDesc[2], 255, SoundDesc[4], SoundDesc[5])
				self.ContactSounds_Soft.SlideVolume=SoundDesc[3] 
				--Sound:SetSoundLoop(self.ContactSounds_Soft.Slide, 1)
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
				--Sound:SetSoundLoop(self.ContactSounds_Hard.Roll, 1)
			end
			SoundDesc=PhysicsSoundsTable.Hard[self.Properties.Physics.Type].Slide 
			if (SoundDesc) then
				self.ContactSounds_Hard.Slide=Sound:Load3DSound(SoundDesc[1], SoundDesc[2], 255, SoundDesc[4], SoundDesc[5])
				self.ContactSounds_Hard.SlideVolume=SoundDesc[3] 
				--Sound:SetSoundLoop(self.ContactSounds_Hard.Slide, 1)
			end
		else
			--System:Log("[BasicEntity] Warning: Table *PhysicsSoundsTable.Hard* or *PhysicsSoundsTable.Hard["..self.Properties.Physics.Type.."]* no found !")
		end
	else
		--System:Log("[BasicEntity] Warning: Table *PhysicsSoundsTable* no found !")
	end
end

function BreakableObject:Event_Die(sender)
	self:GoDead()
	BroadcastEvent(self, "Die")
end

function BreakableObject:Event_IsDead(sender)
	BroadcastEvent(self, "IsDead")
end

function BreakableObject:Event_OnHit(hit) -- mixer: new function
	BroadcastEvent(self, "OnHit")
	if (self.Properties.Physics.bRigidBody==1) then
		self:AwakePhysics(1)
		if (hit) and (hit.ipart) and (hit.ipart>=0) then
			self:AddImpulse(hit.ipart, hit.pos, hit.dir, hit.impact_force_mul)
		end
	end
end

function BreakableObject:OnReset()
	self:EnableUpdate(0)
	self:TrackColliders(1)
	self.dead = 0 
	self.dhit = nil 

	if (self.Properties.object_Model=="") then return end 
	
	if (self.Properties.object_Model~=self.CurrModel) then
		self.CurrModel = self.Properties.object_Model 
		self:LoadBreakable(self.Properties.object_Model)
		self:CreateStaticEntity(10,-2)
	end
	
	-- stop old sounds
	if (self.DyingSound and Sound:IsPlaying(self.DyingSound)) then
		Sound:StopSound(self.DyingSound)
	end
	-- load sounds
	local SndTbl 
	SndTbl=self.Properties.DyingSound 
	if (SndTbl.sndFilename~="") then
		self.DyingSound=Sound:Load3DSound(SndTbl.sndFilename, SOUND_RADIUS)
		if (self.DyingSound) then
			Sound:SetSoundPosition(self.DyingSound, self:GetPos())
			Sound:SetSoundVolume(self.DyingSound, SndTbl.nVolume)
			Sound:SetMinMaxDistance(self.DyingSound, SndTbl.InnerRadius, SndTbl.OuterRadius)
		end
	else
		self.DyingSound=nil 
	end

	self.curr_damage=self.Properties.nDamage 

	if (self.dead==0) then
		self:GoAlive()
		
		-- Set physics.
		--DestroyableObject:SetPhysicsProperties(self)
		self:SetPhysicsProperties()
	else
		self:GoDead()
	end
end

function BreakableObject:GoAlive()

	self:EnablePhysics(1)
	self:DrawObject(0,1)
	self:DrawObject(1,0)
	self:GotoState("Active")
end

function BreakableObject:GoDead(deathVector)
	if (deathVector) then
		self.deathVector = new(deathVector)
	else
		self.deathVector = {x=0,y=0,z=1} 
	end
	if (self.DyingSound and (not Sound:IsPlaying(self.DyingSound))) then
		Sound:PlaySound(self.DyingSound)
	end

	self:GotoState("Dead")
	
	self:SetTimer(30)
	
end

function BreakableObject:OnDamage(hit)
	if (self.dead==1) then return end 
	self:Event_OnHit(hit)
	if (hit) and (self.curr_damage > 0) then
		self.curr_damage=self.curr_damage-hit.damage 
	if (self.curr_damage<=0) then
		-----
		if (hit.shooter) and (hit.shooter.cnt) and (hit.shooter.cnt.weapon) and (hit.shooter.cnt.weapon.hit_delay) then
			self.dhit = hit 
			self:SetTimer(hit.shooter.cnt.weapon.hit_delay*1000)
			return 
		end
		----
		self:GoDead(hit.dir)
		self.NoDecals = 1 
		hit.target_material = nil 
	end
	end
end

BreakableObject.Active={
	OnBeginState=function(self)
	end,
	

	OnContact = function(self,collider)

		
--System:Log("\001ON contact ")				
		-- it it's vehicle
		if (collider.driverT and self.bBreakByCar==1) then
			self:GoDead()
		end
	end,
	
	OnTimer=function(self)
		if (self.dhit) then
			self:GoDead(self.dhit.dir)
			self.NoDecals = 1 
		end
	end,
	
	OnDamage = BreakableObject.OnDamage,

	-- Use Basic Entity function for this.
	---------
	OnCollide = BasicEntity.OnCollide,
}

BreakableObject.Dead={
	OnBeginState=function(self)
		--System:Log("enter dead")
--		self:SetTimer(1)
		self.dead = 1 
		self.dhit = nil 
		if (self.isLoading==nil) then
			self:Event_IsDead()
			self:BreakEntity(self.deathVector, self.Properties.fBreakImpuls,self.Properties.Parts.bRigidBody,self.Properties.Parts.LifeTime,self.Properties.Parts.Density)
		end	
		
		self:DrawObject(0,0)
		self:DrawObject(1,1)
		self:EnablePhysics(0)
	end,

	OnTimer=function(self)
		self:RemoveDecals()
	end,
}


function BreakableObject:OnSave(stm)
	--WriteToStream(stm,self.Properties)
	stm:WriteInt(self.dead)
end


function BreakableObject:OnLoad(stm)
	--self.Properties=ReadFromStream(stm)
	self.dead = stm:ReadInt()
--	self:OnReset()
	
	if (self.dead==0) then
		self:GoAlive()
	else
		self.isLoading = 1 
		self:GoDead()
	end
	
	
end
