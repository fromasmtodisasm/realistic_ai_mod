Script:ReloadScript( "Scripts/Default/Entities/Others/BasicEntity.lua" );

DestroyableObject={
	Properties = {
		object_Model="Objects/Indoor/boxes/crates/barrel1.cgf",
		object_ModelDestroyed="",
		nDamage=100,
		nExplosionRadius=5,
		bExplosion=1,
		ExplosionTable="explosions.rocket_indoors.a",
		bTriggeredOnlyByExplosion=0,
		impulsivePressure=2000, -- physics params
		rmin = 2.0, -- physics params
		rmax = 20.5, -- physics params
		timer=-1,
		bPlayerOnly = 0,
		bHidden=0,
		bAllowMeleeDamage=1,
		damage_players = 0, -- Damage from physical collision.
		
		AliveSoundLoop={
			sndFilename="",
			InnerRadius=1,
			OuterRadius=10,
			nVolume=255,
		},
		DeadSoundLoop={
			sndFilename="",
			InnerRadius=1,
			OuterRadius=10,
			nVolume=255,
		},
		DyingSound={
			sndFilename="",
			InnerRadius=1,
			OuterRadius=10,
			nVolume=255,
		},

		AISoundEvent = {
			bGenerateAISoundEvent = 1,
			fRadius = 30,
		},

		nPlayerDamage=100,
		nPlayerDamageRadius=3,
		Physics = {
			bRigidBody=0, -- True if rigid body.
			bRigidBodyAfterDeath=1, -- True if same rigid body after death too.
			bRigidBodyActive = 1, -- If rigid body is originally created (1) OR will be created only on OnActivate (0).
			bActivateOnDamage = 0, -- Activate when a rocket hit the entity.
			bResting = 0, -- If rigid body is originally in resting state.
			Density = -1,
			Mass = 100,
			vector_Impulse = {x=0,y=0,z=0}, -- Impulse to apply at event.
			max_time_step = 0.01,
			sleep_speed = 0.04,
			damping = 0,
			water_damping = 0,
			water_resistance = 1000,	
			water_density = 1000,
			Type="Unknown",
			bFixedDamping = 0,
			HitDamageScale = 0,
		},

	},
	--PHYSICS PARAMS
	explosion_params = {
		pos = nil,
		damage = 100,
		rmin = 2.0,
		rmax = 20.5,
		radius = 3,
		impulsive_pressure = 2000,
		shooter = nil,
		weapon = nil,
	},

	bNeedsReloadInEditor=0,	

	
	-----------------------------------------------------------------------------
	-- Reassign physics related methods to basic entity.
	-----------------------------------------------------------------------------
	StopLastPhysicsSounds = BasicEntity.StopLastPhysicsSounds,
	OnStopRollSlideContact = BasicEntity.OnStopRollSlideContact,
}

function DestroyableObject:OnInit()
	self.hitPos = {x=0,y=0,z=0};
	self:EnableUpdate(0);
	self:RegisterState("Active");
	self:RegisterState("Dead");
	self:OnReset();
end

function DestroyableObject:OnPropertyChange()
	self:OnReset();
end

function DestroyableObject:OnShutDown()

end

function DestroyableObject:Event_Reset( sender )
	self:OnReset();
end

function DestroyableObject:Event_UnHide( sender )
	self:CreateStaticEntity( 10,-1,0 );
	self:DrawObject(0,1);
end

function DestroyableObject:Event_Explode( sender )

	if self:GetState()=="Dead" then return end

	if (self.Delay > 0) then
		self:SetTimer(self.Delay*1000);
		self.Delay = -1;
		do return end
	end

	self:Explode();
	BroadcastEvent( self,"Explode" );
end

function DestroyableObject:Explode()
	if(self.explosion)then
		local normal = self:GetDirectionVector();
--		local normal = {x=0,y=0,z=1};
--		local pos = self:GetPos();
		--ExecuteMaterial( pos,normal,self.explosion_table, 1 );

		if(self.hitPos.x == 0) then
			self.hitPos = self:GetPos(); 
		end	

		Particle:SpawnEffect(self.hitPos, {x=0,y=0,z=1}, self.Properties.ExplosionTable ,1.0);

		-- raduis, r, g, b, lifetime, pos
		CreateEntityLight( self, 7, 1, 1, 0.7, 0.5, self.hitPos );

		self.explosion_params.pos = self:GetPos();
		self.explosion_params.shooter=self;			
	end

	if (self.Properties.AISoundEvent.bGenerateAISoundEvent == 1) then
		if (self.shooter_detroyer == nil) then 
			self.shooter_detroyer = _localplayer;
		end
		AI:SoundEvent(self.id,self:GetPos(),self.Properties.AISoundEvent.fRadius, 0, 1, self.shooter_detroyer.id);
	end

	self:GoDead();
	
	if(self.explosion)then
		self.explosion_params.damage=self.Properties.nPlayerDamage;
		self.explosion_params.radius=self.Properties.nPlayerDamageRadius;
		self.explosion_params.impulsive_pressure=self.Properties.impulsivePressure;		
		self.explosion_params.rmin=self.Properties.rmin;
		self.explosion_params.rmax=self.Properties.rmax;
		Game:CreateExplosion(self.explosion_params);
	end
end

function DestroyableObject:OnReset()
	self.Delay = self.Properties.timer;
	self.bDead = 0;
	
	self:StopLastPhysicsSounds();

	if (self.bNeedsReloadInEditor==1) then
		-- [marco] in editor mode, if the object exploded, we might have
		-- physicalized a different object, must be reset back now
		self:DestroyPhysics(); 
	end

	if (self.Properties.object_Model ~= self.CurrModel or self.bNeedsReloadInEditor==1) then
		self.CurrModel = self.Properties.object_Model;
		if (self.Properties.object_Model ~= "") then
			self:LoadObject(self.Properties.object_Model,0,1);				
			if (self.Properties.bHidden==1) then
				self:DrawObject(0,0);
			else
				self:CreateStaticEntity( 10,-1,0 );
				self:DrawObject(0,1);
			end
		end
	end

	self.bNeedsReloadInEditor=0;

	if ((self.Properties.object_ModelDestroyed ~="") and 
	(self.Properties.object_ModelDestroyed ~= self.CurrDestroyedModel)) then
		self.CurrDestroyedModel = self.Properties.object_ModelDestroyed;
		self:LoadObject(self.Properties.object_ModelDestroyed,1,1);
		self:DrawObject(1,0);
	end
	
	-- stop old sounds
	if (self.DyingSoundLoop and Sound:IsPlaying(self.DyingSound)) then
		Sound:StopSound(self.DyingSound);
	end
	if (self.DeadSoundLoop and Sound:IsPlaying(self.DeadSoundLoop)) then
		Sound:StopSound(self.DeadSoundLoop);
	end
	if (self.AliveSoundLoop and Sound:IsPlaying(self.AliveSoundLoop)) then
		Sound:StopSound(self.AliveSoundLoop);
	end
	-- load sounds
	local SndTbl;
	SndTbl=self.Properties.AliveSoundLoop;
	if (SndTbl.sndFilename~="") then
		self.AliveSoundLoop=Sound:Load3DSound(SndTbl.sndFilename, 0);
		if (self.AliveSoundLoop) then
			Sound:SetSoundPosition(self.AliveSoundLoop, self:GetPos());
			Sound:SetSoundLoop(self.AliveSoundLoop, 1);
			Sound:SetSoundVolume(self.AliveSoundLoop, SndTbl.nVolume);
			Sound:SetMinMaxDistance(self.AliveSoundLoop, SndTbl.InnerRadius, SndTbl.OuterRadius);
		end
	else
		self.AliveSoundLoop=nil;
	end
	SndTbl=self.Properties.DeadSoundLoop;
	if (SndTbl.sndFilename~="") then
		self.DeadSoundLoop=Sound:Load3DSound(SndTbl.sndFilename, 0);
		if (self.DeadSoundLoop) then
			Sound:SetSoundPosition(self.DeadSoundLoop, self:GetPos());
			Sound:SetSoundLoop(self.DeadSoundLoop, 1);
			Sound:SetSoundVolume(self.DeadSoundLoop, SndTbl.nVolume);
			Sound:SetMinMaxDistance(self.DeadSoundLoop, SndTbl.InnerRadius, SndTbl.OuterRadius);
		end
	else
		self.DeadSoundLoop=nil;
	end
	SndTbl=self.Properties.DyingSound;
	if (SndTbl.sndFilename~="") then
		self.DyingSound=Sound:Load3DSound(SndTbl.sndFilename, 0);
		if (self.DyingSound) then
			Sound:SetSoundPosition(self.DyingSound, self:GetPos());
			Sound:SetSoundVolume(self.DyingSound, SndTbl.nVolume);
			Sound:SetMinMaxDistance(self.DyingSound, SndTbl.InnerRadius, SndTbl.OuterRadius);
		end
	else
		self.DyingSound=nil;
	end

	self.explosion_params.impulsive_pressure=self.Properties.impulsivePressure;	
	self.curr_damage=self.Properties.nDamage;
	self.explosion_params.radius=self.Properties.nExplosionRadius;
	self.explosion_params.rmin=self.Properties.rmin;
	self.explosion_params.rmax=self.Properties.rmax;

	if(self.Properties.bExplosion==1)then
		self.explosion=1;
		--if(self.Properties.ExplosionTable~="")then
		--	self.explosion_table=globals()[self.Properties.ExplosionTable];
		--else
		--	self.explosion_table=Materials.mat_default.projectile_hit;
		--end
	end
	--System:Log("---RESET DESTROY");
	
	
	-- Set physics.
	self:SetPhysicsProperties(0);
	
	self:GoAlive();
end

------------------------------------------------------------------------------------------------------
function DestroyableObject:StopLastPhysicsSounds()
	self:OnStopRollSlideContact("roll");
	self:OnStopRollSlideContact("slide");
end

------------------------------------------------------------------------------------------------------
function DestroyableObject:OnStopRollSlideContact(ContactType)
	if (self.LastPhysicsSounds) then
		if (ContactType=="roll") then -- and (Sound:IsPlaying(self.LastPhysicsSounds.Roll))) then
			--System:Log("Stopping Roll");
			Sound:StopSound(self.LastPhysicsSounds.Roll);
		end
		if (ContactType=="slide") then -- and (Sound:IsPlaying(self.LastPhysicsSounds.Slide))) then
			--System:Log("Stopping Slide");
			Sound:StopSound(self.LastPhysicsSounds.Slide);
		end
	end
end

------------------------------------------------------------------------------------------------------
function DestroyableObject:GoAlive()

	self:EnablePhysics(1);
	if (self.Properties.bHidden==1) then
		self:DrawObject(0,0);
	else
		self:DrawObject(0,1);
	end
	
	self:DrawObject(1,0);
	if (self.DeadSoundLoop) then
		Sound:StopSound(self.DeadSoundLoop);
		--System:Log("stopping dead-loop");
	end
	if (self.AliveSoundLoop and (not Sound:IsPlaying(self.AliveSoundLoop))) then
		Sound:PlaySound(self.AliveSoundLoop);
		--System:Log("starting alive-loop");
	end
	self:GotoState( "Active" );
end

function DestroyableObject:GoDead()


	self:GotoState( "Dead" );
end

------------------------------------------------------------------------------------------------------
-- Set Physics parameters.
------------------------------------------------------------------------------------------------------
function DestroyableObject:SetPhysicsProperties( nObjectSlot )
	if (self.Properties.Physics.bRigidBody ~= 1) then
		return;
	end
	
	self:SetUpdateType( eUT_Physics );

  local Mass,Density,qual;
  
 	Mass    = self.Properties.Physics.Mass; 
 	Density = self.Properties.Physics.Density;
 	
  
		-- Make Rigid body.
	self:CreateRigidBody( Density,Mass,-1,g_Vectors.v000,nObjectSlot ); -- Density,Mass,surfaceId,InitialVelocity,Slot
	if (self.bCharacter == 1) then
		self:PhysicalizeCharacter( Mass,0,0,0);
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
		};
	
	
		self.bRigidBodyActive = self.Properties.Physics.bRigidBodyActive;
		if (self.bRigidBodyActive ~= 1) then
			-- If rigid body should not be activated, it must have 0 mass.
			SimParams.mass = 0;
			SimParams.density = 0;
		end

		local Flags = { flags_mask=pef_fixed_damping, flags=0 };
		if (self.Properties.Physics.bFixedDamping~=0) then
			Flags.flags = pef_fixed_damping;
		end
		
		self:SetPhysicParams(PHYSICPARAM_SIMULATION, SimParams );
		self:SetPhysicParams(PHYSICPARAM_BUOYANCY, self.Properties.Physics );
		self:SetPhysicParams(PHYSICPARAM_FLAGS, Flags );
		
		if (self.Properties.Physics.bResting == 0) then
			self:EnableUpdate(1);
			self:AwakePhysics(1);
		else
			self:EnableUpdate(0);
			self:AwakePhysics(0);
		end
		
	
	-- physics-sounds
	if (PhysicsSoundsTable) then
		local SoundDesc;
		-- load soft contact sounds
		self.ContactSounds_Soft={};
		if (PhysicsSoundsTable.Soft and PhysicsSoundsTable.Soft[self.Properties.Physics.Type]) then
			SoundDesc=PhysicsSoundsTable.Soft[self.Properties.Physics.Type].Impact;
			if (SoundDesc) then
				self.ContactSounds_Soft.Impact=Sound:Load3DSound(SoundDesc[1], SoundDesc[2], 255, SoundDesc[4], SoundDesc[5]);
				self.ContactSounds_Soft.ImpactVolume=SoundDesc[3];
			end
			SoundDesc=PhysicsSoundsTable.Soft[self.Properties.Physics.Type].Roll;
			if (SoundDesc) then
				self.ContactSounds_Soft.Roll=Sound:Load3DSound(SoundDesc[1], SoundDesc[2], 255, SoundDesc[4], SoundDesc[5]);
				self.ContactSounds_Soft.RollVolume=SoundDesc[3];
				Sound:SetSoundLoop(self.ContactSounds_Soft.Roll, 1);
			end
			SoundDesc=PhysicsSoundsTable.Soft[self.Properties.Physics.Type].Slide;
			if (SoundDesc) then
				self.ContactSounds_Soft.Slide=Sound:Load3DSound(SoundDesc[1], SoundDesc[2], 255, SoundDesc[4], SoundDesc[5]);
				self.ContactSounds_Soft.SlideVolume=SoundDesc[3];
				Sound:SetSoundLoop(self.ContactSounds_Soft.Slide, 1);
			end
		else
			--System:Log("[BasicEntity] Warning: Table *PhysicsSoundsTable.Soft* or *PhysicsSoundsTable.Soft["..self.Properties.Physics.Type.."]* no found !");
		end
		-- load hard contact sounds
		self.ContactSounds_Hard={};
		if (PhysicsSoundsTable.Hard and PhysicsSoundsTable.Hard[self.Properties.Physics.Type]) then
			SoundDesc=PhysicsSoundsTable.Hard[self.Properties.Physics.Type].Impact;
			if (SoundDesc) then
				self.ContactSounds_Hard.Impact=Sound:Load3DSound(SoundDesc[1], SoundDesc[2], 255, SoundDesc[4], SoundDesc[5]);
				self.ContactSounds_Hard.ImpactVolume=SoundDesc[3];
			end
			SoundDesc=PhysicsSoundsTable.Hard[self.Properties.Physics.Type].Roll;
			if (SoundDesc) then
				self.ContactSounds_Hard.Roll=Sound:Load3DSound(SoundDesc[1], SoundDesc[2], 255, SoundDesc[4], SoundDesc[5]);
				self.ContactSounds_Hard.RollVolume=SoundDesc[3];
				Sound:SetSoundLoop(self.ContactSounds_Hard.Roll, 1);
			end
			SoundDesc=PhysicsSoundsTable.Hard[self.Properties.Physics.Type].Slide;
			if (SoundDesc) then
				self.ContactSounds_Hard.Slide=Sound:Load3DSound(SoundDesc[1], SoundDesc[2], 255, SoundDesc[4], SoundDesc[5]);
				self.ContactSounds_Hard.SlideVolume=SoundDesc[3];
				Sound:SetSoundLoop(self.ContactSounds_Hard.Slide, 1);
			end
		else
			--System:Log("[BasicEntity] Warning: Table *PhysicsSoundsTable.Hard* or *PhysicsSoundsTable.Hard["..self.Properties.Physics.Type.."]* no found !");
		end
	else
		--System:Log("[BasicEntity] Warning: Table *PhysicsSoundsTable* no found !");
	end
end

function DestroyableObject:OnDamage(hit)
	if (self.bDead == 1) then return end;
	--System:Log("ON DAMAGE "..self.id.." AMOUNT="..hit.damage);
	
	self:AwakePhysics(1);

	local shooter = hit.shooter;	

	if (self.Properties.bPlayerOnly == 1) then 
		if (shooter.ai) then 
			do return end;
		end
	end

	-- [marco] if told so, don't allow melee weapons to damage the destroyable object		
	if (shooter and shooter.fireparams and (shooter.fireparams.fire_mode_type == FireMode_Melee)) then 
		if (self.Properties.bAllowMeleeDamage==0) then do return end end			
	end
		
	self:Event_OnDamage();

	if((self.Properties.bTriggeredOnlyByExplosion==1)
		and (not hit.explosion))then return end;
			
	self.curr_damage=self.curr_damage-hit.damage;
		
	if(self.curr_damage<=0)then
		self:SetTimer(1);
			
		self.hitPos.x = hit.pos.x;
		self.hitPos.y = hit.pos.y;
		self.hitPos.z = hit.pos.z;
		self.shooter_detroyer = hit.shooter;
		--self:Event_Explode();
	end
	if( hit.ipart and hit.ipart>=0 ) then
		self:AddImpulse( hit.ipart, hit.pos, hit.dir, hit.impact_force_mul );
	end
end;

DestroyableObject.Active={
	OnDamage = DestroyableObject.OnDamage,
	OnTimer = function(self)
		self:Event_Explode();
	end,
	
	------------------------------------------------------------------------------------------------------
	-- Use Basic Entity function for this.
	------------------------------------------------------------------------------------------------------
	OnCollide = BasicEntity.OnCollide,
}

DestroyableObject.Dead={
	OnBeginState=function(self)

		if (self.AliveSoundLoop) then
			Sound:StopSound(self.AliveSoundLoop);
			--System:Log("stopping alive-loop");
		end
		if (self.DyingSound and (not Sound:IsPlaying(self.DyingSound))) then
			Sound:PlaySound(self.DyingSound);
			--System:Log("starting dying");
		end
		if (self.DeadSoundLoop and (not Sound:IsPlaying(self.DeadSoundLoop))) then
			Sound:PlaySound(self.DeadSoundLoop);
			--System:Log("starting dead-loop");
		end

		self.bDead = 1;
		--System:Log("enter dead");
		self:SetTimer(1);
	end,
	OnTimer=function(self)
		self.bNeedsReloadInEditor=1; -- [marco] recreate physics in editor next time
		self:DrawObject(0,0);
		self:RemoveDecals();
		if (self.Properties.Physics.bRigidBody == 1 and self.Properties.Physics.bRigidBodyAfterDeath == 1) then
			if(self.Properties.object_ModelDestroyed~="")then
				self:SetPhysicsProperties(1);
				self:DrawObject(1,1);
				self:EnableUpdate(1);
				self:AwakePhysics(1);
			end
		else
			self:DestroyPhysics();
			if(self.Properties.object_ModelDestroyed~="")then
				self:DrawObject(1,1);
				self:CreateStaticEntity( 10,-1,1 );				
			end
		end
	end,
	OnDamage = function(self,hit)
		self:AwakePhysics(1);
		if( hit.ipart and hit.ipart>=0 ) then
			self:AddImpulse( hit.ipart, hit.pos, hit.dir, hit.impact_force_mul );
		end
	end
}



function DestroyableObject:Event_OnDamage( sender )

	if self:GetState()=="Dead" then return end
	BroadcastEvent( self,"OnDamage" );
end

------------------------------------------------------------------------------------------------------
-- Input events
------------------------------------------------------------------------------------------------------
function DestroyableObject:Event_AddImpulse(sender)
  local len = sqrt(LengthSqVector(self.Properties.Physics.vector_Impulse));
  if (len>0) then
    local rlen = 1.0/len;
	  self.temp_vec.x=self.Properties.Physics.vector_Impulse.x*rlen;
	  self.temp_vec.y=self.Properties.Physics.vector_Impulse.y*rlen;
	  self.temp_vec.z=self.Properties.Physics.vector_Impulse.z*rlen;
	  self:AddImpulse(0,nil,self.temp_vec,len);
	end
end

------------------------------------------------------------------------------------------------------
function DestroyableObject:Event_Activate(sender)	

	--System:Log("Activating RIGID BODY");
	
	--create rigid body 
	if (self.Activated==0 and self:IsARigidBody() == 1) then
		self:SetPhysicsProperties(0);
		if (self.Properties.Physics.bResting==0) then
			self:EnableUpdate(1);
			self:AwakePhysics(1);
		end
	end
end

------------------------------------------------------------------------------------------------------
-- Events to switch material Applied to object.
------------------------------------------------------------------------------------------------------
function DestroyableObject:CommonSwitchToMaterial( numStr )
	if (not self.sOriginalMaterial) then
		self.sOriginalMaterial = self:GetMaterial();
	end
	
	if (self.sOriginalMaterial) then
		System:Log( "Material: "..self.sOriginalMaterial..numStr );
		self:SetMaterial( self.sOriginalMaterial..numStr );
	end
end

------------------------------------------------------------------------------------------------------
function DestroyableObject:Event_SwitchToMaterialOriginal(sender)
	self:CommonSwitchToMaterial( "" );
end

------------------------------------------------------------------------------------------------------
function DestroyableObject:Event_SwitchToMaterial1(sender)
	self:CommonSwitchToMaterial( "1" );
end
------------------------------------------------------------------------------------------------------
function DestroyableObject:Event_SwitchToMaterial2(sender)
	self:CommonSwitchToMaterial( "2" );
end