-- #Script.ReloadScript("scripts/default/entities/weapons/ProjSentryDrone.lua")
ProjSentryDrone = {
	type = "Projectile",
	tid_cloud = System:LoadTexture("textures/cloud.jpg"),
	decal_tid = System:LoadTexture("textures/explo_decal.tga"),
	

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
		initial_velocity = 80,
		k_air_resistance = 0,
		acc_thrust = 0,
		acc_lift = 0,
		surface_idx = 0,
		gravity = {x=0, y=0, z=4*-9.8 },
		collider_to_ignore = nil,
	},
	
	ExplosionParams = {
		pos = {},
		damage = 110,
		rmin = 0.8,
		rmax = 10.5, -- default = 10.5
		radius = 10.5, -- default = 8
		impulsive_pressure = 10,
		shooter = nil,
		weapon = nil,
	},
	
	radius=4,
	explosion_delay=1.5,
	auto_explosion_delay=10,
	
	ExplosionTimer = 0,	
	bPhysicalized = nil,
	lifetime=10,
	was_underwater=nil,
	water_normal={x=0,y=0,z=1},		
	
	fileActivationSound=Sound:Load3DSound("SOUNDS/items/nvisionactivate.wav",0,190,2,200),
}

--==================================================================
function ProjSentryDrone:Server_OnInit()
	self:RegisterState("Flying");
	self:RegisterState("Armed");
	self:GotoState( "Flying" );
	self.Who = nil;
	self.Died = 0;
	self:SetPos({x=-1000,y=-1000,z=-1000});
	self.part_time = 0;
	if(self.bPhysicalized==nil)then
		self:LoadObject( "Objects/characters/devices/spidercam/spidercam.cgf",0,0.5);
		self:CreateParticlePhys( 2, 10 );
		self.bPhysicalized=1;
	end
	self:EnableUpdate(1);
end

--==================================================================
function ProjSentryDrone:Client_OnInit()
	self.object_angle={x=0,y=0,z=0};
	self:RegisterState("Flying");
	self:RegisterState("Armed");
	self:GotoState( "Flying" );
	
	self.part_time = 0;
	if(self.bPhysicalized==nil)then
		self:LoadObject( "Objects/characters/devices/spidercam/spidercam.cgf",0,0.5);
		self:CreateParticlePhys( 2, 10 );
		self.bPhysicalized=1;
	end
	self:EnableUpdate(1);
end

--==================================================================
function ProjSentryDrone:Server_Flying_OnUpdate(dt)
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
end

--==================================================================
function ProjSentryDrone:Server_Exploding_OnUpdate(dt)
	if (_time - self.ExplosionTimer > self.lifetime) then
		System:LogToConsole("DELETING PROJ");
		Server:RemoveEntity( self.id );		
	end
end

--==================================================================
function ProjSentryDrone:Client_Flying_OnUpdate(dt)

	self.part_time = self.part_time + dt*2;
	self.object_angle.z=mod(self.object_angle.z+dt*1440,360);
	--self:SetObjectAngles(0,self.object_angle);
	if (self.part_time>0.1) then
		self:DrawObject(0,1);
		local pos = self:GetPos();
		Particle:CreateParticle( pos,{x=0,y=0,z=0},self.Smoke );
		self.part_time=0;
	end
end

--==================================================================
function ProjSentryDrone:Client_Exploding_OnUpdate(dt)
	self.part_time = self.part_time + dt*2;
end

--==================================================================
function ProjSentryDrone:Launch( weapon, shooter, pos, angles, dir )
	self.Param.heading = dir;
	self.Param.collider_to_ignore = shooter;
	self:SetPhysicParams( PHYSICPARAM_PARTICLE, self.Param );
	self:SetPos( pos );
	self:SetAngles( angles );
	self.shooter=shooter;
	self.weapon=weapon;
	--self.ExplosionParams.shooter = shooter;
	--self.ExplosionParams.weapon = weapon;
	
	if (Game:IsClient()) then
		self:DrawObject( 0, 1 );

	end
end

--==================================================================
function ProjSentryDrone:Server_Explode()
	
	self.ExplosionParams.pos = self.status.pos;
	self.ExplosionParams.shooter = self.shooter;
	self.ExplosionParams.weapon = self.weapon;
	
	
	Game:CreateExplosion(self.ExplosionParams);
end
--==================================================================
function ProjSentryDrone:Client_Explode()

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
			ExecuteMaterial( hit.pos,hit.normal,Materials.mat_default.projectile_hit,1);
			ExecuteMaterial( hit.pos, hit.normal, hit.target_material.grenade_hit, 1 );
		else
			System:LogToConsole("hit.target_material is nil");
		end

	else
		System:LogToConsole("hit is nil");
	end
	
end
--==================================================================
ProjSentryDrone.Server = {
	OnInit = ProjSentryDrone.Server_OnInit,
	Flying = {
		OnBeginState = function(self)
		end,
		OnEndState = function(self)
		end,
		OnUpdate = ProjSentryDrone.Server_Flying_OnUpdate,
	},
	Armed = {
		OnBeginState = function(self)
			local drone=Server:SpawnEntity("SentryDrone");
			if(drone~=nil)then
				drone:SetPos(self:GetPos());
			else
				printf("ProjSentryDrone [SentryDrone creation failed] ");
			end
			Server:RemoveEntity(self.id);
		end,
	},
}
--==================================================================
ProjSentryDrone.Client = {
	OnInit = ProjSentryDrone.Client_OnInit,
	OnShutDown = ProjSentryDrone.Client_OnShutDown,
	Flying = {
		OnBeginState = function(self)
		end,
		OnEndState = function(self)
		end,
		OnUpdate = ProjSentryDrone.Client_Flying_OnUpdate,
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