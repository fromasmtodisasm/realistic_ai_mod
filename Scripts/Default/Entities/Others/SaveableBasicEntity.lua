Script:ReloadScript("scripts/materials/PhysicsSounds.lua")

-- simple entity

SaveableBasicEntity = {
	Name = "SaveableBasicEntity",
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
			max_time_step = 0.01,
			sleep_speed = 0.04,
			damping = 0,
			water_damping = 0,
			water_resistance = 1000,	
			water_density = 1000,
			Type="Unknown",
			bFixedDamping = 0,
			LowSpec = {
			  bKeepRigidBody = 1,
			  bRigidBody = 0,
			  max_time_step = 0.025,
			  sleep_speed = 0.04,
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
			--bSaveAnimStatus=0,
		},

		damage_players=0,
		sndAnimStart="",
		sndAnimStop="",
	},
	temp_vec={x=0,y=0,z=0},
	animsoundstart=nil,
	animsoundstop=nil,
	animstarted=0,
}

------------------------------------------------------------------------------------------------------
function SaveableBasicEntity:IsARigidBody()
	local qual=tonumber(getglobal("physics_quality"));
	
 	if qual>0 or self.Properties.Physics.LowSpec.bKeepRigidBody==1 then
		return self.Properties.Physics.bRigidBody;
	end
	
	return self.Properties.Physics.LowSpec.bRigidBody;
end

------------------------------------------------------------------------------------------------------
function SaveableBasicEntity:SetFromProperties()
	if (self.Properties.object_Model == "") then
		do return end;
	end
	local bPhysicalize = 1;
	if (self.ModelName ~= self.Properties.object_Model) then
		self.ModelName = self.Properties.object_Model;
		--bPhysicalize = 1;
		
		-- try to load an animated model first
		if (self:LoadCharacter(self.ModelName,0)) then
			-- Needs to be updated when visible
			self.bCharacter = 1;
			self:DrawCharacter(0,1);
		else
			-- Dont need to be updated.
			-- let's create either a rigid body or a normal static object
			self:LoadObject( self.ModelName,0,1 );
			self.bCharacter = 0;
			self:DrawObject(0,1); --param nPos(slot number), nMode(0 = Don't draw, 1 = Draw normally, 3 = Draw near)
		end
	end
	
	if (self.Properties.Animation.bPlaying ~= self.bAnimPlaying or self.Properties.Animation.bLoop ~= self.bAnimLoop or 
			self.Properties.Animation.Animation ~= self.AnimName) then
		self.bAnimPlaying = self.Properties.Animation.bPlaying;
		self.bAnimLoop = self.Properties.Animation.bLoop;
		self.AnimName = self.Properties.Animation.Animation;
		if (self.Properties.Animation.bPlaying == 1) then
			self:StartAnimation( 0,self.Properties.Animation.Animation,0,0,1,self.Properties.Animation.bLoop );			
		else
			self:ResetAnimation(0);
		end
	end
	self:SetAnimationSpeed( self.Properties.Animation.Speed )
	
	-- Set physics.
	self:SetPhysicsProperties( bPhysicalize,self.Properties.Physics.bRigidBodyActive );

	--self:EnablePhysics(1);
	
	self:SetSoundProperties();
	
	if (self.bCharacter == 1) then
		if (self:IsARigidBody() == 1) then
			-- Characters needs also to be updated when they are visible.
			self:SetUpdateType( eUT_PhysicsVisible );
		else
			self:SetUpdateType( eUT_Visible );
		end
	else
		if (self:IsARigidBody() == 1) then
			-- Rigid bodies needs only to be updated when physics awake.
			self:SetUpdateType( eUT_Physics );
		else
			-- Static objects should be updated depending on when update is enabled.
			self:SetUpdateType( eUT_Always );
		end
	end
end

------------------------------------------------------------------------------------------------------
function SaveableBasicEntity:SetSoundProperties()
	-- load sounds
	self.SplashSound=Sound:Load3DSound("sounds/player/water/watersplash.wav", 0, 255, 2, 50);

	if (self.Properties.sndAnimStart~="") then
		self.animsoundstart=Sound:Load3DSound(self.Properties.sndAnimStart, 0,255,1,10);
	end

	if (self.Properties.sndAnimStop~="") then
		self.animsoundstop=Sound:Load3DSound(self.Properties.sndAnimStop, 0,255,1,10);
	end
end

------------------------------------------------------------------------------------------------------
-- Set Physics parameters.
------------------------------------------------------------------------------------------------------
function SaveableBasicEntity:SetPhysicsProperties( bPhysicalize,bActivateRigidBody )
  local Mass,Density,qual;

	-- [marco] in multiplayer settings must be exactly the same
	-- on all machines
	if (Game:IsMultiplayer()) then
		qual=2;
	else
		qual = tonumber(getglobal("physics_quality"));
	end

  	if (qual>0 or self.Properties.Physics.LowSpec.bKeepMassAndWater==1) then
  	  	Mass    = self.Properties.Physics.Mass; 
  	  	Density = self.Properties.Physics.Density;
	else
	    Mass    = self.Properties.Physics.LowSpec.Mass; 
  		Density = self.Properties.Physics.LowSpec.Density;
	end
  
	if (self:IsARigidBody() == 1) then
		-- Make Rigid body.
		if (bPhysicalize==1) then
			self:CreateRigidBody( Density,Mass,-1 );
			if (self.bCharacter == 1) then
				self:PhysicalizeCharacter( Mass,0,0,0);
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
		};
		
		if qual==0 then
		  SimParams.max_time_step = self.Properties.Physics.LowSpec.max_time_step;
		  SimParams.sleep_speed = self.Properties.Physics.LowSpec.sleep_speed;
		  if (self.Properties.Physics.LowSpec.bKeepMassAndWater==0) then
		    SimParams.water_resistance = self.Properties.Physics.LowSpec.water_resistance;
			  SimParams.water_density = self.Properties.Physics.LowSpec.water_density;
		  end
		end
		
		self.bRigidBodyActive = bActivateRigidBody;
		if (bActivateRigidBody ~= 1) then
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
		
	else
		-- Not rigid body, not character.
		-- Make simple static physics.
		if (bPhysicalize == 1) then
			self:CreateStaticEntity( self.Mass,-1 );
			if (self.bCharacter == 1) then
				self:PhysicalizeCharacter( Mass,0,0,0);
			end
		end
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
			--System:Log("[SaveableBasicEntity] Warning: Table *PhysicsSoundsTable.Soft* or *PhysicsSoundsTable.Soft["..self.Properties.Physics.Type.."]* no found !");
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
			--System:Log("[SaveableBasicEntity] Warning: Table *PhysicsSoundsTable.Hard* or *PhysicsSoundsTable.Hard["..self.Properties.Physics.Type.."]* no found !");
		end
	else
		--System:Log("[SaveableBasicEntity] Warning: Table *PhysicsSoundsTable* no found !");
	end
end

------------------------------------------------------------------------------------------------------
function SaveableBasicEntity:OnReset()

	if (self:IsARigidBody() == 1) then
		self:SetPhysicsProperties( 0,self.Properties.Physics.bRigidBodyActive );
	end

	self.Activated=0;
	self:StopLastPhysicsSounds();
	self:ResetAnimation(0);

	if (self.Properties.aianchorAIAction~="") then
		AI:RegisterWithAI(self.id, AIAnchor[self.Properties.aianchorAIAction], self.Properties.fAnchorRadius);
	end

end

------------------------------------------------------------------------------------------------------
function SaveableBasicEntity:OnInit()
	self.bRigidBodyActive = self.Properties.Physics.bRigidBodyActive
	self:NetPresent(nil);
	self:SetFromProperties();	
	self.Activated=0;
	
	self:EnableUpdate(0);
end

------------------------------------------------------------------------------------------------------
function SaveableBasicEntity:OnPropertyChange()
	self:SetFromProperties();
end

------------------------------------------------------------------------------------------------------
function SaveableBasicEntity:OnEvent( id, params)
	if (id == ScriptEvent_PhysicalizeOnDemand) then
		self:SetPhysicsProperties( 0,self.bRigidBodyActive );
	end
end

------------------------------------------------------------------------------------------------------
function SaveableBasicEntity:Event_Hide()
	self:Hide(1);
	--self:DrawObject(0,0);
	--self:DestroyPhysics();
end

------------------------------------------------------------------------------------------------------
function SaveableBasicEntity:Event_UnHide()
	self:Hide(0);
	--self:DrawObject(0,1);
	--self:SetPhysicsProperties( 1,self.bRigidBodyActive );
end

------------------------------------------------------------------------------------------------------
function SaveableBasicEntity:Event_ResetAnimation()
	self:ResetAnimation(0);
	self:PlaySound(self.animsoundstop);
end

------------------------------------------------------------------------------------------------------
function SaveableBasicEntity:OnCollide(hit)
	if (hit.impact) then
		if (self.Properties.Physics.HitDamageScale ~= nil and self.Properties.Physics.HitDamageScale ~= 0) then
			if (self.OnDamage) then
				if (not self._localHitTable) then
					self._localHitTable = {pos={x=0,y=0,z=0},};
				end
				local pos = self:GetPos();
				self._localHitTable.damage = hit.fSpeed*self.Properties.Physics.HitDamageScale;
				self._localHitTable.pos.x = pos.x;
				self._localHitTable.pos.y = pos.y;
				self._localHitTable.pos.z = pos.z;
				self:OnDamage( self._localHitTable );
			end
		end
	end

	if (self.Properties.Physics.Type) then
		local mat=Game:GetMaterialBySurfaceID(hit.matId);
		if (mat and mat.PhysicsSounds) then
			local NewPhysicsSounds;
			if (mat.PhysicsSounds==PhysicsSoundsTable.Soft) then
				NewPhysicsSounds=self.ContactSounds_Soft;
			else
				NewPhysicsSounds=self.ContactSounds_Hard;
			end
			if (NewPhysicsSounds~=self.LastPhysicsSounds) then
				self:StopLastPhysicsSounds();
			end
			self.LastPhysicsSounds=NewPhysicsSounds;
			if (self.LastPhysicsSounds and self.LastPhysicsSounds.ImpactVolume) then
				if (hit.impact) then
					local Volume=hit.impact*0.1;
					if (Volume>1) then Volume=1; end

					local finalvol=Volume*self.LastPhysicsSounds.ImpactVolume;					
					if (self.LastPhysicsSounds.Impact and finalvol>1) then
						self:PlaySound(self.LastPhysicsSounds.Impact);
						Sound:SetSoundVolume(self.LastPhysicsSounds.Impact, finalvol);
						--System:Log("Impact: "..hit.impact);
					end
				end
				local Volume;
				if (hit.roll) then
				  Volume=(hit.roll-0.1)*0.1;
				else
				  Volume = 0;
				end  
				if (Volume>1) then Volume=1; end
				
				if (self.LastPhysicsSounds.Roll) then
					local rollvol=Volume*self.LastPhysicsSounds.RollVolume;

					if (rollvol>1) then
						if (not Sound:IsPlaying(self.LastPhysicsSounds.Roll)) then
							self:PlaySound(self.LastPhysicsSounds.Roll);
						end
						Sound:SetSoundVolume(self.LastPhysicsSounds.Roll, rollvol);
						Sound:SetSoundFrequency(self.LastPhysicsSounds.Roll, Volume*400+800);
						--System:Log("Roll: "..hit.roll);
					end
				end
				if (hit.slide) then
					Volume=(hit.slide-0.1)*0.1;
				else
					Volume = 0;
				end	
				if (Volume>1) then Volume=1; end
				
				if (self.LastPhysicsSounds.Slide) then
					local slidevol=Volume*self.LastPhysicsSounds.SlideVolume;

					if (slidevol>1) then
						if (not Sound:IsPlaying(self.LastPhysicsSounds.Slide)) then
							self:PlaySound(self.LastPhysicsSounds.Slide);
						end
						Sound:SetSoundVolume(self.LastPhysicsSounds.Slide,slidevol );
						Sound:SetSoundFrequency(self.LastPhysicsSounds.Slide, Volume*400+800);
						--System:Log("Slide: "..hit.slide);
					end
				end
			end
		end
	end

	--if (self.SplashSound and hit.waterresistance and (hit.waterresistance>0)) then
		--self:PlaySound(self.SplashSound, hit.waterresistance*0.1);
		--System:Log("Splash: "..hit.waterresistance*0.01);
	--end

	if (hit.splashes) then

		if (g_lastSplashTime+g_SplashDuration < _time) then g_curSplashes = 0; end

		for i,splash in hit.splashes do
			if (g_curSplashes<g_maxSplashes) then
				--System:Log("splash : ("..splash.center.x..","..splash.center.y..","..splash.center.z.."), radius "..splash.radius);
				ExecuteMaterial(splash.center, g_Vectors.v001, CommonEffects.water_splash, 1);
				g_curSplashes = g_curSplashes+1; g_lastSplashTime = _time;
			end
		end

	end
end

------------------------------------------------------------------------------------------------------
function SaveableBasicEntity:StopLastPhysicsSounds()
	self:OnStopRollSlideContact("roll");
	self:OnStopRollSlideContact("slide");
end

------------------------------------------------------------------------------------------------------
function SaveableBasicEntity:OnStopRollSlideContact(ContactType)
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
function SaveableBasicEntity:OnShutDown()
	self:StopLastPhysicsSounds();
end

------------------------------------------------------------------------------------------------------
function SaveableBasicEntity:OnDamage( hit )


	--System:LogToConsole( "On Damage" );
	if (self:IsARigidBody() == 1) then
				
		if (self.Properties.Physics.bActivateOnDamage == 1) then

			if (self.Activated==0) then
				--System:LogToConsole( "Activate!!" );
				self.Activated=1;
				BroadcastEvent(self, "Activate");				
			end
		
			if (self.bRigidBodyActive == 0) then
				
				if (hit.explosion) then
					self:SetPhysicsProperties( 0,1 );
					--System:LogToConsole( "On Damage (by explosion)" );
					self:EnableUpdate(1);
					self:AwakePhysics(1);
				end
			end
		end
	end

	if( hit.ipart and hit.ipart>=0 ) then
		self:AddImpulse( hit.ipart, hit.pos, hit.dir, hit.impact_force_mul );
	end
end

------------------------------------------------------------------------------------------------------
-- Input events
------------------------------------------------------------------------------------------------------
function SaveableBasicEntity:Event_AddImpulse(sender)
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
function SaveableBasicEntity:Event_Activate(sender)	

	--System:Log("Activating RIGID BODY");
	
	--create rigid body 
	if (self.Activated==0 and self:IsARigidBody() == 1) then
		self:SetPhysicsProperties( 0,1 );
		if (self.Properties.Physics.bResting==0) then
			self:EnableUpdate(1);
			self:AwakePhysics(1);
		end
	end
end

------------------------------------------------------------------------------------------------------
function SaveableBasicEntity:StartEntityAnimation()
	self:ResetAnimation(0);
	self:StartAnimation( 0,self.Properties.Animation.Animation,0,0,1,self.Properties.Animation.bLoop );	
	self:SetAnimationSpeed( self.Properties.Animation.Speed );
	self:PlaySound(self.animsoundstart);
end

------------------------------------------------------------------------------------------------------
function SaveableBasicEntity:Event_StartAnimation(sender)
	self:StartEntityAnimation();
	self.animstarted=1;
end

------------------------------------------------------------------------------------------------------
function SaveableBasicEntity:Event_StopAnimtion(sender)
	self:ResetAnimation(0);	
	self:PlaySound(self.animsoundstop);
end

------------------------------------------------------------------------------------------------------
-- Events to switch material Applied to object.
------------------------------------------------------------------------------------------------------
function SaveableBasicEntity:CommonSwitchToMaterial( numStr )
	if (not self.sOriginalMaterial) then
		self.sOriginalMaterial = self:GetMaterial();
	end
	
	if (self.sOriginalMaterial) then
		System:Log( "Material: "..self.sOriginalMaterial..numStr );
		self:SetMaterial( self.sOriginalMaterial..numStr );
	end
end

------------------------------------------------------------------------------------------------------
function SaveableBasicEntity:Event_SwitchToMaterialOriginal(sender)
	self:CommonSwitchToMaterial( "" );
end

------------------------------------------------------------------------------------------------------
function SaveableBasicEntity:Event_SwitchToMaterial1(sender)
	self:CommonSwitchToMaterial( "1" );
end
------------------------------------------------------------------------------------------------------
function SaveableBasicEntity:Event_SwitchToMaterial2(sender)
	self:CommonSwitchToMaterial( "2" );
end

------------------------------------------------------------------------------------------------------
function SaveableBasicEntity:OnSave(stm)
	stm:WriteInt(self.animstarted);	
end

------------------------------------------------------------------------------------------------------
function SaveableBasicEntity:OnLoad(stm)
	self.animstarted=stm:ReadInt();
	if (self.animstarted==1) then
		self:StartEntityAnimation();
	end	
end
