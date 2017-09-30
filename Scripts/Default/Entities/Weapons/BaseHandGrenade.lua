BaseHandGrenade={
	type="Projectile",
	explosion_timer = 3100,
	lifetime = 3100,
-- Material of the grenade, adjust bouncyness inside
	projectile_matname = "mat_bounce",
	hit_effect = "rock_hit",
	explode_effect = "grenade_explosion",
	dynamic_light=0,
	deleteOnGameReset=1,
	explode_underwater = nil,
---------------------------------
	PhysParams = {
		flags = particle_traceable,
		mass = 0.5,
		size = 0.2,
		heading = {},
		initial_velocity = 25,
		k_air_resistance = 0.5,
		w = {x=1, y=3, z=5},
		acc_thrust = 0,
		acc_lift = 0,
		surface_idx = -1,
		gravity = {x=0, y=0, z=-13 },
		collider_to_ignore = nil,
		water_gravity={x=0, y=0, z=-2 },
		k_water_resistance = 4.0,
		pierceability = 15,
		min_bounce_vel = 16,
	},
---------------------------------
	ExplosionParams = {
		pos = {},
		damage = 110,
		rmin = 0.8,
		rmax = 6.0, -- default = 10.5
		radius = 6.0, -- default = 10.5
		impulsive_pressure = 10,
		shooter = nil,
		weapon = nil,
	},
	SmokeTrail = {
		focus = 0,
		color = {1,1,1},
		speed = 0.0,
		count = 1,
		size = 0.125, size_speed=-0.01,
		lifetime=0.55,
		frames=1,
		tid = System:LoadTexture("textures/clouda2.dds"),
		rotation={x=0,y=0,z=3},
	},
	model="objects/weapons/Grenades/Grenade.cgf",
	model_scale = 1.0,
	softcoverscale=10,
};


function BaseHandGrenade:InitStates()
	if(not self.bStatesInitialized)then
		self:RegisterState("Flying");
		self:RegisterState("Exploding");
		self:RegisterState("Terminating");
		self.bStatesInitialized=1
	end
end

function BaseHandGrenade:InitGeometry()
	if(not self.bGeomInitialized)then
		self.PhysParams.surface_idx = Game:GetMaterialIDByName(self.projectile_matname);
		self.part_time = 0;
		self:CreateParticlePhys( 2, 10, 0 );
		self.bGeomInitialized=1;
	end
end

function BaseHandGrenade:Server_OnInit()
	self:InitGeometry();
	self:InitStates();
	self:GotoState( "Flying" );
	self.ExplosionParams = new(self.ExplosionParams); -- explosion params have to be unique per instance
	self:EnableUpdate(1);
end

function BaseHandGrenade:Client_OnInit()
	if(self.model)then
		self:LoadObject(self.model,0, self.model_scale);
		if (self.model_nooffset == nil) then
			self:SetObjectPos(0, {x=0,y=0,z=-0.07})
		end
 	end
	
	self.was_underwater = nil;
	self.last_bounce=0;
	
	if(self.softcover and not Game:IsMultiplayer())then
		self:LoadObject( self.softcover,1,1.0);
		self:DrawObject(1,0);
	end	
	if(self.deform_terrain)then
		self.decal_tid = System:LoadTexture("textures/decal/explo_decal.dds");
	end
	if(self.exploding_sound)then
		local s=self.exploding_sound;
		self.exploding=Sound:Load3DSound(s.sound,s.flags,s.volume,s.min,s.max)
	end
	self:SetViewDistRatio(255);
	self:DrawObject(0,1);
	self:InitGeometry();
	self:InitStates();
	self:EnableUpdate(1);
	--set the params with velocity 0 on the client
	local t=self.PhysParams.initial_velocity
	self.PhysParams.initial_velocity=0;
	self:SetPhysicParams( PHYSICPARAM_PARTICLE, self.PhysParams);
	self.PhysParams.initial_velocity=t;
end

function BaseHandGrenade:Server_Flying_OnUpdate(dt)
	local status=GetParticleCollisionStatus(self);
	local pos=self:GetPos();

	
	
	-- bouncing AI sound
	if (status) then
		local sound = self.AIBouncingSound;
		if (sound) then 
			AI:SoundEvent(self.id,pos,sound.SoundRadius, sound.Threat, sound.Interest, self.ExplosionParams.shooterid);
		end

		-- apply some damage to the AI guy
		if (self.damage_on_player_contact and status.IsPlayer and status.target) then
			local shooter = self.shooter;
			
			if (self.shooterSSID) then
				local player_slot=Server:GetServerSlotBySSId(self.shooterSSID);
				shooter = player_slot:GetPlayerId();
			end
			
			local hit =	{
				dir = g_Vectors.v001,
				damage = 1,
				target = status.target,
				shooter = shooter,
				landed = 1,
				impact_force_mul_final=5,
				impact_force_mul=5,
				damage_type="healthonly",
			};
			
			self:Damage( hit );			
		end

		-- if it is an attribute AI object, then make it a scary grenade now
		if (self.AITargetType) then
			if (self.AITargetType == AIOBJECT_ATTRIBUTE) then
				if (self.AITargetType_ALTERNATE) then 
					AI:RegisterWithAI(self.id, self.AITargetType_ALTERNATE);
					self.AITargetType = self.AITargetType_ALTERNATE; -- dont do it again
				end
			end
		end
	end

	if ((status and self.explode_on_contact) or (System:IsValidMapPos(pos) ~= 1)) then
		self:GotoState("Exploding");
	end
end

function BaseHandGrenade:Client_Flying_OnUpdate(dt)
	self.part_time = self.part_time + dt*2;
	if(not self.no_trail and not self.was_underwater)then
		local lenSq = LengthSqVector(self:GetVelocity());
		
		if (lenSq > 6.0 and self.SmokeTrail and self.part_time>0.015) then
			local pos = self:GetPos();
			Particle:CreateParticle( pos, g_Vectors.v000, self.SmokeTrail );
			self.part_time=0;
		end
	end
	
	local hook = self.ClientHooks.OnFlying;
	if(hook)then
		hook(self, dt);
	end
	
	local pos=self:GetPos();

	if (not self.was_underwater) then
		if (Game:IsPointInWater(pos)) then
			self.was_underwater=1;
			ExecuteMaterial(pos, g_Vectors.v001, Materials.mat_water[self.hit_effect], 1 )
		else
			local status=GetParticleCollisionStatus(self);
			if(status and ((_time-self.last_bounce)>0.2))then
				self.last_bounce=_time;
				local material=status.target_material;
				if (not material or not material[self.hit_effect]) then
						material = Materials.mat_default;
				end
				if (material[self.hit_effect]) then
					ExecuteMaterial(pos, g_Vectors.v001, material[self.hit_effect], 1 )
				end
			end
		end
	end
end

function BaseHandGrenade:Client_Exploding_OnUpdate(dt)

--	if ((self.dynamic_light>0) and self.bExplosionLightAdded == 0) then
	if ( not self.bExplosionLightAdded ) then		
		-- raduis, r, g, b, lifetime
		CreateEntityLight( self, 10, 1, 1, 0.3, .5 );
--		-- vPos, fRadius, DiffR, DiffG, DiffB, DiffA, SpecR, SpecG, SpecB, SpecA, fLifeTime
--		self:AddDynamicLight(self:GetPos(), 4, 1, 1, 0.3, 1, 1, 1, 0.3, 1, 2);
		self.bExplosionLightAdded = 1;
	end

	local hook = self.ClientHooks.OnExploding;
	if(hook)then
		hook(self);
	end
end

function BaseHandGrenade:Client_OnShutDown(dt)
	local hook = self.ClientHooks.OnShutdown;
	if(hook)then
		hook(self);
	end
end

function BaseHandGrenade:Launch( weapon, shooter, pos, angles, dir ,lifetime)

	--System:LogToConsole("--> Lauch position == x: "..pos.x.." y:"..pos.y.." z:"..pos.z);

	-- register with the AI system 
	if (self.AITargetType) then
		if (self.AITargetType == AIOBJECT_ATTRIBUTE) then
			AI:RegisterWithAI(self.id, AIOBJECT_ATTRIBUTE,shooter.id);
		else
			AI:RegisterWithAI(self.id, self.AITargetType);
		end
	end

	self.PhysParams.heading = dir;
	self.PhysParams.collider_to_ignore = shooter;
	self:SetPhysicParams( PHYSICPARAM_PARTICLE, self.PhysParams );
	self:SetPos( pos );
	self:SetAngles( angles );
	self.ExplosionParams.shooterid = shooter.id;
	self.ExplosionParams.weapon = self;					-- dangerous  - was weapon
	
--	System:Log("Lauched BaseHandGrenade id="..self.id.."team="..Game:GetEntityTeam(shooter.id));				-- debug

	self.LaunchedByTeam=Game:GetEntityTeam(shooter.id);												-- team of the launching player

	if (Game:IsClient()) then
		self:DrawObject( 0, 1 );
	end
	self:SetTimer(self.explosion_timer);
	if(self.explode_on_hold and lifetime)then
		self.lifetime=lifetime;
		self:SetTimer(self.lifetime);
	end

	-- the ID of the server slot who 'shot' this
	-- used for statistics
	local serverSlot = Server:GetServerSlotByEntityId(shooter.id);
	
	if (serverSlot) then
		self.shooterSSID = serverSlot:GetId();																	-- serverslotid of the launching player
		self.ExplosionParams.shooterSSID = serverSlot:GetId();
	end
end

function BaseHandGrenade:OnSave(stm)
	-- write out if we have data to save :)
	if (self.ExplosionParams.shooterid) then
		stm:WriteBool(1)
		stm:WriteInt(self.ExplosionParams.shooterid)
	else
		stm:WriteBool(0)
	end
end

function BaseHandGrenade:OnLoad(stm)
	-- read if we have data to load :)
	local bHasData = stm:ReadBool()
	
	if (bHasData == 1) then
		self.ExplosionParams.shooterid = stm:ReadInt()
	end
end

function BaseHandGrenade:OnLoadRELEASE(stm)
end

----------------------------------
BaseHandGrenade.Server = {
	OnInit = BaseHandGrenade.Server_OnInit,
	Flying = {
		OnBeginState = function(self)
			--ensure that the grenade will explode also if doesn't collide(after sometimes)
			self:SetTimer(self.lifetime);
		end,
		OnUpdate = BaseHandGrenade.Server_Flying_OnUpdate,
		OnTimer = function(self)
			if(self.no_explosion and self.ClientHooks.OnExplode == nil)then
				self:GotoState("Terminating");
			else
				self:GotoState("Exploding");
			end
		end,
	},
	Exploding = {
		OnBeginState = function(self)
			self:SetTimer(self.lifetime);
			local pos = new(self:GetPos());
			if (not self.no_explosion) then
				-- First-time explosion effects
				self.ExplosionParams.pos = pos;
--				System:Log("self.ExplosionParams "..self.ExplosionParams.weapon.id); -- debug
				Game:CreateExplosion(self.ExplosionParams);
			end
			
			local hook = self.ServerHooks.OnExplode;
			if(hook)then
				hook(self);
			end
			
			if(self.deform_terrain and (not self.terrain_deformed) and (not Game:IsPointInWater(pos)))then
				self.terrain_deformed=1;
				System:DeformTerrain( pos, 3, self.decal_tid );				
			end

			local sound = self.AIExplodingSound;
			if (sound) then 
				AI:SoundEvent(self.id,pos,sound.SoundRadius, sound.Threat, sound.Interest, self.ExplosionParams.shooterid);
--				Game:SoundEvent(pos,sound.SoundRadius, sound.Threat, self.ExplosionParams.shooterid);
			end


			if (self.AITargetType) then
				AI:RegisterWithAI(self.id, 0);
			end
		end,
		OnTimer = function(self)
			self:GotoState("Terminating");
		end,
	},
	Terminating = {
		OnBeginState = function(self)
			Server:RemoveEntity(self.id);		
		end,
	}
}

BaseHandGrenade.Client = {
	OnInit = BaseHandGrenade.Client_OnInit,
	Flying = {
		OnUpdate = BaseHandGrenade.Client_Flying_OnUpdate,
	},
	Exploding = {
		OnBeginState = function(self)
			if (self.was_underwater == 1 and self.explode_underwater == nil) then
				return nil;
			end
			
			if(not self.no_explosion)then
				--System:LogToConsole("--> Exploding !");
			
				self.status=GetParticleCollisionStatus(self);
				local hit=self.status;

				self:DrawObject(0,0);

				local effect = self.explode_effect;
				if (hit == nil) then
					hit = {};
				end

				local material = hit.target_material;
				if (not material or not material[effect]) then
						material = Materials.mat_default;
				end
				
				hit.pos = new(self:GetPos());
				hit.normal = g_Vectors.v001;

				-- to display sound on radar
				local sound = self.AIExplodingSound;				
				Game:SoundEvent(hit.pos, sound.SoundRadius, sound.Threat, _localplayer.id);

				local temppos = hit.pos;
				local originalz = temppos.z;				
				local skipexplounderwater = 0;
						
				if((Game:GetWaterHeight(temppos)-temppos.z)>0)then
					
					--check if we are near water surface, if so play also a normal explosion.			
					temppos.z = temppos.z + 1.0;
		
					if(not Game:IsPointInWater(temppos))then

						ExecuteMaterial(temppos, hit.normal, Materials.mat_default["grenade_explosion_air"], 1 );
						
						skipexplounderwater = 1;
					end
					--
					
					material = Materials.mat_water;
					temppos.z=Game:GetWaterHeight(temppos);
				else
					if(self.deform_terrain and (not self.terrain_deformed))then
						self.terrain_deformed=1;
						System:DeformTerrain( hit.pos, 3, self.decal_tid );
						-- adjust explosion particle system
						hit.pos.z = hit.pos.z - 1;
					end
					
					if (self.last_bounce == 0) then
						material = Materials.mat_default;
						effect = "grenade_explosion_air";
					end
					
					skipexplounderwater = 1;
				end

				if (material[effect]) then
					ExecuteMaterial(temppos, hit.normal, material[effect], 1 )
				end
				
				temppos.z = originalz;
				
				if(skipexplounderwater==0 and Game:IsPointInWater(temppos))then
					Particle:SpawnEffect(temppos, hit.normal, "explosions.under_water_explosion.a");
				end
			end
			
			local hook = self.ClientHooks.OnExplode;
			if(hook)then
				hook(self);
			end
			
			if(self.exploding) then
				Sound:SetSoundPosition(self.exploding, self:GetPos());
				if (self.loop_exploding_sound) then
					Sound:SetSoundLoop(self.exploding, 1);
				end
				Sound:PlaySound(self.exploding);
			end
			if(self.softcover and not Game:IsMultiplayer())then
				self:DrawObject(0,0);
				self:CreateStaticEntity(1,Game:GetMaterialIDByName("mat_obstruct"),1);
				self:SetStatObjScale(self.softcoverscale);
				self:SetAngles(g_Vectors.v000);
			end
		end,
		OnUpdate = BaseHandGrenade.Client_Exploding_OnUpdate,

		OnEndState = function(self)
			if(self.exploding and self.loop_exploding_sound) then
				Sound:StopSound(self.exploding);
			end
		end,
	},
	Terminating = {
	},
	OnShutDown = BaseHandGrenade.Client_OnShutDown,
}

--EXAMPLE---------
--parameters = {
--	PhysParams = {
--		flags = 0,
--		mass = .3,
--		size = 0.2,
--		heading = {},
--		initial_velocity = 25, -- default 19
--		k_air_resistance = 0.5,
--		acc_thrust = 0,
--		acc_lift = 0,
--		surface_idx = -1,
--		gravity = {x=0, y=0, z=-13 },
--		min_bounce_vel = 8.5, -- default 2.5
--		collider_to_ignore = nil,
--	},
---------------------------------
--	ExplosionParams = {
--		pos = {},
--		damage = 110,
--		rmin = 0.8,
--		rmax = 6.0, -- default = 10.5
--		radius = 6.0, -- default = 10.5
--		impulsive_pressure = 10,
--		shooter = nil,
--		weapon = nil,
--	},
--	SmokeTrail = {
--		focus = 0,
--		color = {1,1,1},
--		speed = 0.2,
--		count = 1,
--		size = 0.0005, size_speed=0.001,
--		lifetime=1,
--		frames=1,
--		color_based_blending = 3,
--		tid = System:LoadTexture("textures/cloud.dds"),
--	},
-- projectile_matname = "mat_bounce",
-- explosion_timer = 3100,
-- lifetime= 3000,
-- dynamic_light = 0,
-- explode_on_contact = 1,
-- no_explosion = 1
-- no_trail = 1
-- deform_terrain = 1
-- model="objects/weapons/Grenades/Grenade.cgf",
-- }
function CreateHandGrenade(param)
	local ret=new(BaseHandGrenade);
	
	mergef(ret, param, 1);

	if (not ret.ClientHooks) then
		ret.ClientHooks = {};
	end
	
	if (not ret.ServerHooks) then
		ret.ServerHooks = {};
	end
	
	ret.no_explosion=param.no_explosion;
	ret.no_trail=param.no_trail;
	ret.deform_terrain=param.deform_terrain;

	return ret;
end