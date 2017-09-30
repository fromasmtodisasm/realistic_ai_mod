-- #Script:ReloadScript("scripts/default/entities/weapons/Mutantrocket.lua")

MutantRocket = {
	type = "Projectile",
	tid_cloud = System:LoadTexture("textures/cloud.jpg"),
	decal_tid = System:LoadTexture("textures/decal/explo_decal.dds"),

	lockTarget = nil,
	
	Param = {
		mass = 1,
		size = 0.15,
		heading = {},
		flags=1,
		--initial_velocity = 75,
		initial_velocity = 10, --  default 23
		k_air_resistance = 0,
		acc_thrust = 0,
		acc_lift = 0,
		surface_idx = -1,
		gravity = {x=0, y=0, z=0 },
		collider_to_ignore = nil,
	},
	
	ExplosionParams = {
		pos = {},
		damage = 200,
		rmin = 0.8,
		rmax = 3.5, 
		radius = 3.5,--5.5
		shake_factor = 0.20,
		DeafnessRadius = 2.5,
		DeafnessTime = 3.0,
		impulsive_pressure = 5, -- default 5
		shooter = nil,
		weapon = nil,
		explosion = 1,
		rmin_occlusion=0.2,
		occlusion_res=32,
		occlusion_inflate=2,
	},
	
	SmokeWhite = {
		focus = 9,--90,
		start_color = {1,1,1},
		end_color = {0.3,0.3,0.3},
		speed = 3.0,--0.0,
		count = 1,
		size = 0.05, 
		size_speed=0.7,
		rotation = { x=0,y=0,z=0},
		bLinearSizeSpeed=1,
		lifetime=1.0,
		frames=1,
		tid = System:LoadTexture("textures/clouda.dds"),
		draw_last=1,
		
		turbulence_size = 2,
		turbulence_speed = 2.5,
	},
	SmokeBlack = {
		color_start = {0.6,0.6,0.6},
		color_end = {0.1,0.1,0.1},
		focus = 9,--0,
		speed = 3.0,--0.0,
		count = 1,
		size = 0.1, 
		size_speed=0.9,--0.0,
		rotation = { x=0,y=0,z=0},
		bLinearSizeSpeed=1,
		lifetime=0.5,
		frames=1,
		tid = System:LoadTexture("textures/cloud_black1.dds"),
		
		turbulence_size = 2,
		turbulence_speed = 2.5,
	},
	
	RocketEngineLoop = nil,

	ExplosionTimer = 0,	
	bPhysicalized = nil,
	was_underwater=nil,
	water_normal={x=0,y=0,z=1},

	bStatesRegistered = nil,
	--------------------------------------
	second_explosion_delay=0.5, -- default 0.75
}

function MutantRocket:Server_OnInit()

	if (self.bStatesRegistered == nil) then
		self:RegisterState("Flying");
		self:RegisterState("Exploding");
		self:RegisterState("Exploding2");
		self.bStatesRegistered = 1;
	end

	self:GotoState( "Flying" );

	self:SetPos({x=-1000,y=-1000,z=-1000});
	self.part_time = 0;
	if(self.bPhysicalized==nil)then
		self:CreateParticlePhys( 2, 10, 0 );
		self.bPhysicalized=1;
	end
	self:EnableUpdate(1);
end

function MutantRocket:Client_OnInit()

	self.RocketEngineLoop = Sound:Load3DSound("Sounds/Weapons/RL/rocketloop3.wav",512);

	self:SetViewDistRatio(255);
	if (self.bStatesRegistered == nil) then
		self:RegisterState("Flying");
		self:RegisterState("Exploding");
		self:RegisterState("Exploding2");
		self.bStatesRegistered = 1;
	end

	self:LoadObject( "objects/weapons/Rockets/rocket.cgf",0,0.5);
	--self.LoadObject( "objects/explosion/explosion.cgf", 1, 0.5);
	self.part_time = 0;
	if(self.bPhysicalized==nil)then
		self:CreateParticlePhys( 2, 10 );
		self.bPhysicalized=1;
	end
	self:EnableUpdate(1);
end

function MutantRocket:Server_Flying_OnUpdate(dt)

	local status=GetParticleCollisionStatus(self);
	local pos=self:GetPos();
	
	if (status ~= nil) then
		--set a member variable to pass to ExecuteMaterial in OnCollision
		local material=status.target_material;
		if(IsMaterialUnpierceble(status.target_material))then
			self["status"]=status;
			self:GotoState("Exploding");
		else
			--if(status.target_material~=nil)then
			--	ExecuteMaterial(pos,status.normal,material.projectile_hit,1)
			--else
				self["status"]=status;
				self:GotoState("Exploding");
			--end
		end
	elseif (System:IsValidMapPos(pos) ~= 1) then
		self:GotoState("Exploding");
		--System.RemoveEntity(self.id);
	end
	
	--TRACKING
	if(self.Target and type(self.Target)=="table")then
		local tpos;
		if(self.Target.GetPos)then
			tpos=self.Target:GetPos();
		else
			tpos=self.Target;
		end
		self:DoHam(tpos);
	end
	
end



function MutantRocket:Client_Flying_OnUpdate(dt)

	local pos = self:GetPos();

	self.part_time = self.part_time + dt*1.0;
	if (self.part_time>0.03) then	
		
		--local dir = {x=0,y=0,z=0};
		local dir = self:GetDirectionVector(0);
		--dir.x = -dir.x;
		--dir.y = -dir.y;
		--dir.z = -dir.z;
		
		if (self.SHOOTER.Properties.customParticle=="none") then
			
			--if (random(0,100)<50) then
				self.SmokeWhite.rotation.z = random(-300,300)*0.01;			
				Particle:CreateParticle( pos,dir,self.SmokeWhite );
			--else
			--on low spec use just the white smoke.
			if (tonumber(getglobal("sys_spec")) ~= 0) then
				self.SmokeBlack.rotation.z = random(-300,300)*0.01;
				Particle:CreateParticle( pos,dir,self.SmokeBlack );
			end
		else
			Particle:SpawnEffect(pos,dir,self.SHOOTER.Properties.customParticle);
		end
		self.part_time=0;

	end

	if(Materials["mat_water"] and Materials["mat_water"].projectile_hit)then
		if(self.was_underwater==nil)then
			if(Game:IsPointInWater(pos)) then
				System:LogToConsole("UNDERWATER");
				self.was_underwater=1;
				ExecuteMaterial(pos, self.water_normal, Materials.mat_water.projectile_hit, 1 )
			end
		end
	end
	
	-- HACK: Marco, why do I have to call PlaySound all the time, no looping ?
	--	 Alberto, why doesn't self.PlaySound() move the sound and I have to do that manually ?
	if (self.RocketEngineLoop and (Sound:IsPlaying(self.RocketEngineLoop) == nil)) then
		Sound:SetMinMaxDistance(self.RocketEngineLoop, 5, 100000);
		self:PlaySound(self.RocketEngineLoop);
	end
	Sound:SetSoundPosition(self.RocketEngineLoop, self:GetPos());

	-- vPos, fRadius, DiffR, DiffG, DiffB, DiffA, SpecR, SpecG, SpecB, SpecA, fLifeTime
	-- Commented out dynamic light for a framerate test - tig
	--self:AddDynamicLight(self:GetPos(), 10, 1, 1, 0.3, 1, 1, 1, 0.3, 1, 0);
end

function MutantRocket:Client_Exploding_OnUpdate(dt)
	self.part_time = self.part_time + dt*2;

	self:SetStatObjScale((_time - self.ExplosionTimer) * 35);

	-- vPos, fRadius, DiffR, DiffG, DiffB, DiffA, SpecR, SpecG, SpecB, SpecA, fLifeTime
	--self:AddDynamicLight(self:GetPos(), 10, 1, 1, 0.3, 1, 1, 1, 0.3, 1, 0);
		
	self.RocketEngineLoop=nil;
end

function MutantRocket:Launch( weapon, shooter, pos, angles, dir, target )

	-- register with the AI system 



	self.Target = AI:GetAttentionTargetOf(shooter.id);
	--AI:RegisterWithAI(self.id, AIAnchor.AIOBJECT_DAMAGEGRENADE);


	if (shooter.Properties.bShootSmartRocketsForward==0) then
		dir.x = 0;
		dir.y = 0;
		dir.z = 1;
	end


	if (shooter.Properties.fRocketSpeed~=nil) then
		self.Param.initial_velocity = shooter.Properties.fRocketSpeed;
	end

	if (shooter.Properties.fRocketDamageOverride) then
		if (shooter.Properties.fRocketDamageOverride>0) then
			self.ExplosionParams.damage = shooter.Properties.fRocketDamageOverride;
		end
	end 

	if (shooter.ROCKET_ORIGIN_KEYFRAME) then 
		if (shooter.ROCKET_ORIGIN_KEYFRAME == KEYFRAME_FIRE_LEFTHAND) then 
			pos = shooter:GetBonePos("Bip01 L Hand");
		elseif (shooter.ROCKET_ORIGIN_KEYFRAME == KEYFRAME_FIRE_RIGHTHAND) then 
			pos = shooter:GetBonePos("Bip01 R Hand");
		elseif (shooter.ROCKET_ORIGIN_KEYFRAME == KEYFRAME_FIRE_FIRE_LEFTTOP) then 
			pos = shooter:GetBonePos("RL_left01");
		elseif (shooter.ROCKET_ORIGIN_KEYFRAME == KEYFRAME_FIRE_FIRE_RIGHTTOP) then 
			pos = shooter:GetBonePos("RL_right01");
		end
	end

	self.SHOOTER = shooter;

	self.Param.heading = dir;
	self.Param.collider_to_ignore = shooter;
	self:SetPhysicParams( PHYSICPARAM_PARTICLE, self.Param );
	self:SetPos( pos );
	self:SetAngles( angles );
	self.ExplosionParams.shooter = shooter;
	self.ExplosionParams.weapon = weapon;
	
	
	--self.lockTarget = target;

	if (shooter.Properties.bDumbRockets~=nil) then
		if (shooter.Properties.bDumbRockets==0) then
			if(self.Target~=nil) then
				self:ResetHam( );
			end	
		else
			self.Target = nil;
		end
	end
	
	if (Game:IsClient()) then
		self:DrawObject( 0, 1 );
	end

	if (self.RocketEngineLoop) then
		Sound:SetMinMaxDistance(self.RocketEngineLoop, 5, 100000);
		self:PlaySound(self.RocketEngineLoop);
		Sound:SetSoundLoop(self.RocketEngineLoop, 1);
		
	end
end

----------------------------------
function MutantRocket:Server_OnCollision( hit )
	if ( hit.target ) then
		if ( hit.target == self.ExplosionParams.shooter ) then
			return
		end
	end

	-- First-time explosion effects
	self.ExplosionParams.pos = hit.pos;
	Game:CreateExplosion( self.ExplosionParams );

--	System:DeformTerrain( hit.pos, 5, self.decal_tid );
end

function MutantRocket:Client_OnCollision()

	-- First-time explosion effects

	local pos = self:GetPos();

	self.status=GetParticleCollisionStatus(self);
	local hit=self.status;
	
	
	self.ExplosionParams.pos = pos;
	Game:CreateExplosion( self.ExplosionParams );
	
	-- raduis, r, g, b, lifetime, pos
	CreateEntityLight( self, 7, 1, 1, 0.7, 0.5);
	
	--objtype 2 mean "the terrain"
	if(hit)then
		if (hit.objtype==2) then
--			System:DeformTerrain( pos, 4, self.decal_tid );
		end
	end
	
	Sound:StopSound(self.RocketEngineLoop);

	self.ExplosionTimer = _time;

	if (hit ~= nil) then
		if (hit.target_material ~= nil) then
			if(Game:IsPointInWater(hit.pos))then
				local h=Game:GetWaterHeight()-hit.pos.z;
				if(h>2)then
					do return end
				end
			end
			ExecuteMaterial(hit.pos,hit.normal,hit.target_material.projectile_hit, 1 );
		else
			System:LogToConsole("hit.target_material is nil");
		end
	else
		ExecuteMaterial(pos,normal,Materials.mat_default.projectile_hit,1);
		System:LogToConsole("hit is nil");
	end

	Game:SoundEvent(pos, 200, 1, 0);	
end

MutantRocket.Server = {
	OnInit = MutantRocket.Server_OnInit,
	OnCollision = MutantRocket.Server_OnCollision,
	Flying = {
		OnBeginState = function(self)
			--after 10 sec the rocket will explode in any case
			self:SetTimer(10000);
		end,
		OnTimer = function(self)
			self:GotoState("Exploding");
		end,
		OnUpdate = MutantRocket.Server_Flying_OnUpdate,
	},
	Exploding = {
		OnBeginState = function(self)
			self:SetTimer(1); --delay the explosion to the next update thi help the multiplayer
		end,
		OnUpdate =MutantRocket.Server_Flying_OnUpdate,
		OnTimer = function(self)
			self:GotoState("Exploding2");
		end
	},
	Exploding2 = {
		OnBeginState = function(self)
			self:SetTimer(3000); --delay the explosion to the next update thi help the multiplayer
			self.ExplosionParams.pos = self:GetPos();
			Game:CreateExplosion( self.ExplosionParams );
		end,
		OnTimer = function(self)
			Server:RemoveEntity(self.id);
		end
	}
}

MutantRocket.Client = {
	OnInit = MutantRocket.Client_OnInit,
	OnCollision = MutantRocket.Client_OnCollision,
	Flying = {
		
		OnUpdate = MutantRocket.Client_Flying_OnUpdate,
	},
	Exploding = {
		OnBeginState=function(self)
			self:DrawObject(0,0);
			self.hit=GetParticleCollisionStatus(self);
		end
	},
	Exploding2 = {
		OnBeginState = function(self)
			local hit=self.hit;
			local normal;
			local pos;
			if(not hit)then
				pos=self:GetPos();
				normal={x=0,y=0,z=1};
			else
				normal=hit.normal;
				pos=hit.pos;
			end
			
			Game:SoundEvent(pos, 200, 1, 0);
			
			self:DrawObject(0,0);
			--no explosion if is in deep water
			if(Game:IsPointInWater(pos))then
				local h=Game:GetWaterHeight()-pos.z;
				if(h>2)then
					do return end
				end
			end
			if(hit)then
				if (hit.objtype==2) then
--					System:DeformTerrain( pos, 4, self.decal_tid );
				end
			end
	
			if(hit)then
				ExecuteMaterial(hit.pos,hit.normal,hit.target_material.projectile_hit, 1 );
			else
				ExecuteMaterial(pos,normal,Materials.mat_default.projectile_hit,1);
			end
			self.RocketEngineLoop=nil;
		end,
	}
}