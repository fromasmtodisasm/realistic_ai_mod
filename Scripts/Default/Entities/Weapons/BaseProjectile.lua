BaseProjectile = {
	tid_cloud = System:LoadTexture("textures/cloud.jpg"),
	decal_tid = System:LoadTexture("textures/decal/explo_decal.dds"),
	
	deleteOnGameReset=1,

	bPhysicalized = nil,
	was_underwater=nil,	
	
	fDeformRadius = 3,
	
	SoundEvent = {
		fVolumeRadius = 200, -- default 13
		fThreat = 1, -- default 1
		fInterest = 0.0,
	},
}

function BaseProjectile:Server_OnInit()
	self.part_time = 0;
	if(self.bPhysicalized==nil)then
		self:CreateParticlePhys( 2, 10, 0 );
		self.bPhysicalized=1;
	end
	
	self.ExplosionParams = new(self.ExplosionParams);
	
	--if this projectile have some special parameters for multiplayer, merge them.
	if (Game:IsMultiplayer() and self.ExplosionParams_Mp) then
		merge(self.ExplosionParams,self.ExplosionParams_Mp);
	end	
	
	self:EnableUpdate(1);

	-- explode after a set amount of time
	self:SetTimer(self.lifetime);
end

function BaseProjectile:Client_OnInit()
	self.part_time = 0;
	if(self.bPhysicalized==nil)then
		self:CreateParticlePhys( 2, 10 );
		self.bPhysicalized=1;
	end
	self.Param.heading = self:GetDirectionVector();
	
	self:SetPhysicParams( PHYSICPARAM_PARTICLE, self.Param );
	
	self:EnableUpdate(1);

	self:SetViewDistRatio(255);
	self:LoadObject( self.projectileObject,0, self.projectileObjectScale);

	local engineSound = self.EngineSound;
	if (engineSound) then
		engineSound.sound = Sound:Load3DSound(engineSound.name, 512);
		Sound:SetMinMaxDistance(engineSound.sound, engineSound.minDist, engineSound.maxDist);
		Sound:SetSoundLoop(engineSound.sound, 1);
		self:PlaySound(engineSound.sound);
	end
	
	-- FIXME: please leave this in for now ... a weird check to detect client/server synchronization issue
	self.theweirdxpos = self:GetPos().x;
end

function BaseProjectile:Server_OnUpdate(dt)
	local status=GetParticleCollisionStatus(self);
	local pos=self:GetPos();
	
	if (status and self.explodeOnContact == 1) then
		self.isExploding = 1;
	elseif (System:IsValidMapPos(pos) ~= 1) then
		self.isExploding = 1;
	end
	
	if (self.isExploding == 1 and not self.isTerminating) then
		self.ExplosionParams.pos = pos;
		Game:CreateExplosion( self.ExplosionParams );
	
		if (not status) then
			status = {};
			status.objtype = 0;
			if (self.force_objtype) then
				status.objtype = self.force_objtype;
			end
		end
		
		if (not status.normal) then
			status.normal = g_Vectors.v001;
		end

		-- spawn client side effect
    Server:BroadcastCommand("FX", self:GetPos(), status.normal, self.id, status.objtype);						-- invoke OnServerCmd() on the client

		local soundEvent = self.SoundEvent;
		if (soundEvent and self.ExplosionParams.shooterid) then
			AI:SoundEvent(self.id, pos, soundEvent.fVolumeRadius, soundEvent.fThreat, soundEvent.fInterest, self.ExplosionParams.shooterid);
		end

		--System:Log("Terminate");    
		self:SetTimer(1000);
		self.isTerminating = 1;
	end
end

function BaseProjectile:Client_OnUpdate(dt)
	if (self.isTerminating) then
		return
	end
	
	local pos = self:GetPos();
	
	-- FIXME: please leave this in for now ... a weird check to detect client/server synchronization issue
	if (self.theweirdxpos) then
		if (self.theweirdxpos~=pos.x) then
			self:DrawObject( 0, 1 );
			-- Initialize Smoke trail particles.
			if (self.SmokeEffectEmitter) then
				self:CreateParticleEmitterEffect( 0,self.SmokeEffectEmitter,1000,g_Vectors.v000,g_Vectors.v010,1 );
			end
		else
			return
		end
		self.theweirdxpos = nil;
	end
	
	
	if (self.Smoke and not self.was_underwater) then
		self.part_time = self.part_time + dt*2;
		if (self.part_time>0.03) then		
			Particle:CreateParticle(pos, g_Vectors.v000, self.Smoke);
			self.part_time=0;
		end
	end
	
	if (self.SmokeEffect) then
		local dir = self:GetDirectionVector();
		Particle:SpawnEffect( pos, dir, self.SmokeEffect, 1 );
	end

	if(Materials["mat_water"] and Materials["mat_water"].projectile_hit)then
		if(not self.was_underwater)then
			if(Game:IsPointInWater(self:GetPos())) then
				System:LogToConsole("UNDERWATER");
				self.was_underwater=1;
				ExecuteMaterial(pos, g_Vectors.v001, Materials.mat_water.projectile_hit, 1 )
			end
		end
	end

	if(self.dynamic_light ~= 0) then
		-- raduis, r, g, b, lifetime
		CreateEntityLight( self, self.dynamic_light*2, 0.5, 0.5, 0.4, 0.0 );
	end	
	
--	local doProjectileLight = tonumber(getglobal("cl_projectile_light"));
--	if (self.dynamic_light ~= 0 and doProjectileLight == 1) then		-- no specular
--		-- vPos, fRadius, DiffR, DiffG, DiffB, DiffA, SpecR, SpecG, SpecB, SpecA, fLifeTime
--		self:AddDynamicLight(self:GetPos(), self.dynamic_light*2, 1, 1, 0.7, 1, 0, 0, 0, 0, 0.5);
--	elseif (self.dynamic_light ~= 0 and doProjectileLight == 2) then		-- with specular
--		self:AddDynamicLight(self:GetPos(), self.dynamic_light*2, 1, 1, 0.7, 1, 1, 1, 0.7, 1, 0.5);
--	end

end


function BaseProjectile:Launch( weapon, shooter, pos, angles, dir, target )

	-- register with the AI system 
	if (self.Param.AI_Type) then 
		if (self.Param.AI_Type == AIOBJECT_ATTRIBUTE) then
			AI:RegisterWithAI(self.id, AIOBJECT_ATTRIBUTE, shooter.id);
		else
			AI:RegisterWithAI(self.id, self.Param.AI_Type);
		end
	else
		AI:RegisterWithAI(self.id, AIAnchor.AIOBJECT_DAMAGEGRENADE);
	end

	-- special AI processing (for Mortar)
	if (shooter.ai and self.useAIProjectileShoot~=nil) then
		BaseProjectile.default_iv = self.Param.initial_velocity;
		self.Param.initial_velocity = AI:ProjectileShoot(shooter.id,self.Param);
	else
		self.Param.heading = dir;
	end
	
	self.Param.collider_to_ignore = shooter;

	--filippo: moved below
	--self:SetPhysicParams( PHYSICPARAM_PARTICLE, self.Param );
	
	if (BaseProjectile.default_iv ~= nil) then
		self.Param.initial_velocity = BaseProjectile.default_iv;
		BaseProjectile.default_iv = nil;
	end
	
	local projectilepos = g_Vectors.temp_v1;
		
	--[kirill] start from some helper's position - for vehicle mounted RLs 
	--filippo: the helper position is not take into consideration inside the C++ code, so in this case , recalculate the direction vector.
	if (self.LaunchHelper and not shooter.ai) then
				
		CopyVector(projectilepos,shooter.cnt:GetTPVHelper(0, self.LaunchHelper));
					
		local dest = g_Vectors.temp_v2;
		
		dest.x = pos.x + dir.x * 150;
		dest.y = pos.y + dir.y * 150;
		dest.z = pos.z + dir.z * 150;
		
		local hits = System:RayWorldIntersection(pos, dest, 1,ent_static+ent_sleeping_rigid+ent_rigid+ent_independent+ent_terrain+ent_living,shooter.id);
		
		--if we found a hit point (most of cases),  use it to recalculate direction of the projectile.
		-- but the point has to be not closer than 5 meters (to prevent shooting backwards)
		if (getn(hits)>0 and hits[1].dist>5) then
			
			local hitpos = g_Vectors.temp_v3;
			
			CopyVector(hitpos,hits[1].pos);
			
			dest.x = hitpos.x - projectilepos.x;
			dest.y = hitpos.y - projectilepos.y;
			dest.z = hitpos.z - projectilepos.z;
						
			NormalizeVector(dest);
						
			self.Param.heading = dest;
		end
	else
		--otherwise use the normal position we got
		CopyVector(projectilepos,pos);
	end	
	
	self:SetPhysicParams( PHYSICPARAM_PARTICLE, self.Param );
	
	self:SetViewDistRatio(255);
	self:SetPos( projectilepos );
	self:SetAngles( angles );
	self.ExplosionParams.shooterid = shooter.id;
	self.ExplosionParams.weapon = self;		-- dangerous  - was weapon
	
--	System:Log("Lauched BaseProjectile id="..self.id.."team="..Game:GetEntityTeam(shooter.id));				-- debug

	self.LaunchedByTeam=Game:GetEntityTeam(shooter.id);
	self.isExploding = nil;
	
	if (TargetLocker and shooter == _localplayer) then
		self.Target=TargetLocker:PopTarget();	
	end

	-- the ID of the server slot who 'shot' this health pack
	-- used for statistics
	local serverSlot = Server:GetServerSlotByEntityId(shooter.id);
	
	--System:Log("BaseProjectile:Launch "..tostring(shooter.id));

	if (serverSlot) then
		self.shooterSSID = serverSlot:GetId();
		self.ExplosionParams.shooterSSID = serverSlot:GetId();
		--System:Log("BaseProjectile:Launch b");
	end
end

function BaseProjectile:Client_OnRemoteEffect(toktable, pos, normal, userbyte)
	self:DrawObject(0,0);
	
	local originalpos = new(pos);
	
	local hit = {};
	hit.pos = {x = pos.x,y = pos.y,z = pos.z};
	hit.normal = normal;
	hit.target_material = Materials.mat_default;
	hit.play_mat_sound = 1;
	hit.objtype = userbyte;
	
	-- raduis, r, g, b, lifetime
	CreateEntityLight( self, 10, 1, 1, 0.7, 0.5 );
		
	--objtype 2 mean "the terrain"
	if (hit.objtype==2 and self.mark_terrain and (not self.was_underwater)) then
		if(not self.terrain_deformed)then
			self.terrain_deformed=1;
			System:DeformTerrain( pos, self.fDeformRadius, self.decal_tid, self.deform_terrain);
			-- in singleplayer we deform the terrain. We have to adjust the position where the
			-- particle system is spawned ... otherwise it looks like it is floating in the air
			if (self.deform_terrain and tonumber(e_deformable_terrain)==1) then
				hit.pos.z = hit.pos.z - 1;
			end
		end
	end
	
	if (self.EngineSound and self.EngineSound.sound) then
		Sound:StopSound(self.EngineSound.sound);	
	end
		
	--FIXME:redundant code
	if(Game:IsPointInWater(originalpos))then
		--dont take care about deformable terrain shifted pos in the case we are underwater
		CopyVector(hit.pos,originalpos);
		hit.pos.z = Game:GetWaterHeight();
		
		hit.target_material = Materials.mat_water;
		hit.normal = g_Vectors.v001;
			
		ExecuteMaterial2(hit, "grenade_explosion");
		
		--check if we are near water surface, if so play also a normal explosion.			
		hit.pos.z = originalpos.z + 1.0;
		
		if(not Game:IsPointInWater(hit.pos))then
			
			hit.normal = normal;
			hit.target_material = Materials.mat_default;
				
			ExecuteMaterial2(hit, self.matEffect);
		else
			Particle:SpawnEffect(originalpos, hit.normal, "explosions.under_water_explosion.a");
		end
	else
		ExecuteMaterial2(hit, self.matEffect);
		
		--removed: to reactivate there should be a raytrace check to see if there is no terrain between the hit pos and 0.5 m under it.
		--check if we are near water surface, if so play also a water explosion. But just if the impac pos is not plain.			
--		if (normal.z<=0.8) then
--			
--			hit.pos = originalpos;
--			hit.pos.z = hit.pos.z - 0.5;
--		
--			if(Game:IsPointInWater(hit.pos))then
--			
--				hit.target_material = Materials.mat_water;
--				hit.normal = g_Vectors.v001;
--		
--				ExecuteMaterial2(hit, "grenade_explosion");
--			end
--		end
	end
		
	self.isTerminating = 1;

	-- sound event for the radar
	local soundEvent = self.SoundEvent;
	if (soundEvent ~= nil) then
		Game:SoundEvent(originalpos, soundEvent.fVolumeRadius, soundEvent.fThreat, 0);
	end
end

function BaseProjectile:OnSave(stm)
	-- write out if we have data to save :)
	if (self.ExplosionParams.shooterid) then
		stm:WriteBool(1)
		stm:WriteInt(self.ExplosionParams.shooterid)
	else
		stm:WriteBool(0)
	end
end

function BaseProjectile:OnLoad(stm)
	-- read if we have data to load :)
	local bHasData = stm:ReadBool()
	
	if (bHasData == 1) then
		self.ExplosionParams.shooterid = stm:ReadInt()
	end
end

function BaseProjectile:OnLoadRELEASE(stm)
end

BaseProjectile.Server = {
	OnInit = BaseProjectile.Server_OnInit,
	OnTimer = function(self)
		if (not self.isExploding) then
			-- the timer event, triggered by an entity which explodes after a certain amount of time
			self.isExploding = 1;
		else
			-- the timer event, triggered by the exploding entity
			--System:Log("Removing");
			self:KillTimer();
			Server:RemoveEntity(self.id);
		end
	end,
	OnUpdate = BaseProjectile.Server_OnUpdate,
}

BaseProjectile.Client = {
	OnInit = BaseProjectile.Client_OnInit,
	
	OnUpdate = BaseProjectile.Client_OnUpdate,
	
	OnRemoteEffect = BaseProjectile.Client_OnRemoteEffect,
}

function CreateProjectile(projectileDefinition)
	local ret=new(BaseProjectile);
	
	mergef(ret, projectileDefinition, 1);

	-- set some fallback default parameters	
	if (ret.matEffect == nil) then
		ret.matEffect = "projectile_hit";
	end
	if (ret.matEffectScale == nil) then
		ret.matEffectScale = 1.0;
	end
	
	if (ret.projectileObject == nil) then
		ret.projectileObject = "objects/weapons/Rockets/rocket.cgf";
	end
	
	if (ret.projectileObjectScale == nil) then
		ret.projectileObjectScale = 0.5;
	end

	if (ret.lifetime == nil) then
		ret.lifetime = 25000;
	end

	if (ret.dynamic_light == nil) then
		ret.dynamic_light = 0;
	end
	
	return ret;
end
