-- #Script.ReloadScript("scripts/default/entities/weapons/ProjProximityMine.lua")
ProjProximityMine = {
	type = "Projectile",
	tid_cloud = System:LoadTexture("textures/cloud.jpg"),
	decal_tid = System:LoadTexture("textures\\explo_decal.tga"),
	

	Smoke = {
		focus = 0,
		color = {1,1,1},
		speed = 0.2,
		count = 1,
		size = 0.2, size_speed=1.2,
		lifetime=1,
		frames=1,
		color_based_blending = 3,
		tid = System:LoadTexture("textures/cloud.dds"),
	},
	
	Param = {
		mass = 1,
		size = 0.05,
		heading = {},
		flags=1,
--		initial_velocity = 75,
		initial_velocity = 50,
		k_air_resistance = 0,
		acc_thrust = 0,
		acc_lift = 0,
		surface_idx = -1,
		gravity = {x=0, y=0, z=0 },
		collider_to_ignore = nil,
	},
	
	ExplosionParams = {
		pos = {},
		damage = 220,
		rmin = 0.8,
		rmax = 10.5, -- default = 10.5
		radius = 10.5, -- default = 8
		impulsive_pressure = 10,
		shooter = nil,
		weapon = nil,
	},
	
	radius=4,
	explosion_delay=1.5,
	auto_explosion_delay=25,
	
	ExplosionTimer = 0,	
	bPhysicalized = nil,
	lifetime=10,
	was_underwater=nil,
	water_normal={x=0,y=0,z=1},		
	
	fileActivationSound=Sound:Load3DSound("SOUNDS/items/nvisionactivate.wav",0,190,2,200),
	
}

--==================================================================
function ProjProximityMine:Server_OnInit()
	self:RegisterState("Flying");
	self:RegisterState("Exploding");
	self:RegisterState("Armed");
	self:RegisterState("Triggered");
	self:GotoState( "Flying" );
	self.Who = nil;
	self.Died = 0;
	self:SetPos({x=-1000,y=-1000,z=-1000});
	self.part_time = 0;
	if(self.bPhysicalized==nil)then
		self:LoadObject( "objects/weapons/Grenades/Grenade.cgf",0,0.5);
		self:CreateParticlePhys( 2, 10 ,0);
		self.bPhysicalized=1;
	end
	self:EnableUpdate(1);
end

--==================================================================
function ProjProximityMine:Client_OnInit()
	self:RegisterState("Flying");
	self:RegisterState("Exploding");
	self:RegisterState("Armed");
	self:RegisterState("Triggered");
	self:GotoState( "Flying" );
	
	self.part_time = 0;
	if(self.bPhysicalized==nil)then
		self:LoadObject( "objects/weapons/Grenades/Grenade.cgf",0,0.5);
		self:CreateParticlePhys( 2, 10 ,0);
		self.bPhysicalized=1;
	end
	self:EnableUpdate(1);
end

--==================================================================
function ProjProximityMine:Server_Flying_OnUpdate(dt)
	local status=GetParticleCollisionStatus(self);
	local pos=self:GetPos();
	if ( status) then
		self.pos=new(pos);
		--set a member variable to pass to ExecuteMaterial in OnCollision
		self["status"]=status;
		self:EnablePhysics(nil);
		self:GotoState("Armed");
	elseif (System:IsValidMapPos(pos) ~= 1) then
		self:GotoState("Exploding");
	end
	
	--TRACKING
	if(self.Target)then
		local tpos;
		if(self.Target.GetPos)then
			tpos=self.Target:GetPos();
		else
			tpos=self.Target;
		end
		self:DoHam(tpos);
	end
end

--==================================================================
function ProjProximityMine:Server_Exploding_OnUpdate(dt)
	if (_time - self.ExplosionTimer > self.lifetime) then
		System:LogToConsole("DELETING PROJ");
		Server:RemoveEntity( self.id );		
	end
end

--==================================================================
function ProjProximityMine:Client_Flying_OnUpdate(dt)

	self.part_time = self.part_time + dt*2;

	if (self.part_time>0.1) then
		self:DrawObject(0,1);
		local pos = self:GetPos();
		Particle:CreateParticle( pos,{x=0,y=0,z=0},self.Smoke );
		self.part_time=0;
	end
end

--==================================================================
function ProjProximityMine:Client_Exploding_OnUpdate(dt)
	self.part_time = self.part_time + dt*2;
end

--==================================================================
function ProjProximityMine:Launch( weapon, shooter, pos, angles, dir )
	self.Param.heading = dir;
	self.Param.collider_to_ignore = shooter;
	self:SetPhysicParams( PHYSICPARAM_PARTICLE, self.Param );
	self:SetPos( pos );
	self:SetAngles( angles );
	self.shooter=shooter;
	self.weapon=weapon;
	--self.ExplosionParams.shooter = shooter;
	--self.ExplosionParams.weapon = weapon;
	if (TargetLocker and shooter == _localplayer) then
		self.Target=TargetLocker:PopTarget();	
	end
	
	--self.lockTarget = target;

	if(self.Target~=nil) then
		self:ResetHam( );
	end	
	
	if (Game:IsClient()) then
		self:DrawObject( 0, 1 );

	end
end

--==================================================================
function ProjProximityMine:Server_Explode()
	
	self.ExplosionParams.pos = self.status.pos;
	self.ExplosionParams.shooter = self.shooter;
	self.ExplosionParams.weapon = self.weapon;
	
	
	Game:CreateExplosion(self.ExplosionParams);
end
--==================================================================
function ProjProximityMine:Client_Explode()

	local hit=self.status;

	self.ExplosionTimer = _time;

	self:DrawObject(0,0);
	self:SetAngles({x=0,y=0,z=0});
	self:SetStatObjScale(10);
	self:SetObjectPos(1,{x=0,y=0,z=-10});
	
	if (hit ~= nil) then
		
		if (hit.target_material ~= nil) then
			if(Game:IsPointInWater(hit.pos))then
				local h=Game:GetWaterHeight()-hit.pos.z;
				if(h>2)then
					do return end
				end
			end
			
			ExecuteMaterial( hit.pos, hit.normal, Materials.mat_default.projectile_hit,1);
			ExecuteMaterial( hit.pos, hit.normal, hit.target_material.grenade_hit, 1 );
		else
			System:LogToConsole("hit.target_material is nil");
		end

	else
		System:LogToConsole("hit is nil");
	end
	
end
--==================================================================
ProjProximityMine.Server = {
	OnInit = ProjProximityMine.Server_OnInit,
	Flying = {
		OnBeginState = function(self)
		end,
		OnEndState = function(self)
		end,
		OnUpdate = ProjProximityMine.Server_Flying_OnUpdate,
	},
	Triggered = {
		OnBeginState = function(self)
			self:PlaySound(self.fileActivationSound);
			self:SetTimer(self.explosion_delay*1000);
		end,
		OnTimer = function(self)
			self:GotoState("Exploding");
		end
	},
	Armed = {
		OnBeginState = function(self)
			self.Who = nil;
			self.sound_played=nil;
			System:LogToConsole("ARMED SRV!")
			self:SetPos(self.status.pos);
			local Min = { x=-self.radius/2, y=-self.radius/2, z=-self.radius/2 };
			local Max = { x=self.radius/2, y=self.radius/2, z=self.radius/2 };
			self:SetBBox( Min,Max );
			self:SetTimer(self.auto_explosion_delay*1000);
		end,
		OnContact = function(self,collider)
			System:LogToConsole("ON CONTACT");
			if(collider and collider.type=="Player")then
				self:GotoState("Triggered");
			end
		end,
		OnTimer = function(self,collider)
			self:GotoState("Triggered");
		end,
	},
	Exploding = {
		OnBeginState = function(self)
			self:Server_Explode();
		end,
		OnEndState = function(self)
		end,
		OnUpdate = ProjProximityMine.Server_Exploding_OnUpdate,
	},
	
}
--==================================================================
ProjProximityMine.Client = {
	OnInit = ProjProximityMine.Client_OnInit,
	Flying = {
		OnBeginState = function(self)
		end,
		OnEndState = function(self)
		end,
		OnUpdate = ProjProximityMine.Client_Flying_OnUpdate,
	},
	Triggered = {
		OnBeginState = function(self)
			Sound:SetSoundPosition(self.fileActivationSound,self:GetPos());
			Sound:PlaySound(self.fileActivationSound);
		end,
	},
	Exploding = {
		OnBeginState = function(self)
			System:LogToConsole("stopping sound");
			Sound:StopSound(self.fileActivationSound);
			self:Client_Explode();
			self.status=GetParticleCollisionStatus(self);
		end,
		OnEndState = function(self)
		end,
		OnUpdate = ProjProximityMine.Client_Exploding_OnUpdate,
	},
	Armed = {
		OnBeginState = function(self)
			System:LogToConsole("ARMED CLI!")
			self:EnablePhysics(nil);
			self:DrawObject(0,1);
		end,
		OnEndState = function(self)
		end,
	}
}