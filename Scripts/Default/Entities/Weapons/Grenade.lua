-- #Script.ReloadScript("scripts/default/entities/weapons/rocket.lua")

Grenade = {
	type = "Projectile",
	tid_cloud = System:LoadTexture("textures/cloud.jpg"),
	decal_tid = System:LoadTexture("textures\\explo_decal.tga"),

	lockTarget = nil,
	
	Param = {
		mass = 1,
		size = 0.15,
		heading = {},
		initial_velocity = 70,
		k_air_resistance = 0,
		acc_thrust = 0,
		acc_lift = 0,
		surface_idx = 0,
		gravity = {x=0, y=0, z=4*-9.8 },
		collider_to_ignore = nil,
	},

	ExplosionParams = {
		pos = {},
		damage = 150,
		rmin = 0.8,
		rmax = 8.5, -- default = 10.5 
		radius = 8.5, -- default = 8
		DeafnessRadius = 10.5,
		DeafnessTime = 12.0,
		impulsive_pressure = 15, -- default 5
		shooter = nil,
		weapon = nil,
		explosion = 1,
		rmin_occlusion=0.2,
		occlusion_res=32,
		inflate=2,
	},
	
	Smoke = {
		focus = 0,
		color = {1,1,1},
		speed = 0.2,
		count = 1,
		size = 2, size_speed=1.2,
		lifetime=1,
		frames=1,
		color_based_blending = 3,
		tid = System:LoadTexture("textures/cloud.dds"),
	},
	
	ExplosionTimer = 0, -- default 0	 
	bPhysicalized = nil,
	was_underwater=nil,
	water_normal={x=0,y=0,z=1}		
}

function Grenade:Server_OnInit()
	self:RegisterState("Flying");
	self:RegisterState("Exploding");
	self:GotoState( "Flying" );

	self:SetPos({x=-1000,y=-1000,z=-1000});
	self.part_time = 0;
	if(self.bPhysicalized==nil)then
		self:CreateParticlePhys( 2, 10, 0 );
		self.bPhysicalized=1;
	end
	self:EnableUpdate(1);
end

function Grenade:Client_OnInit()

	self:RegisterState("Flying");
	self:RegisterState("Exploding");
	self:GotoState( "Flying" );

	self:LoadObject( "objects/weapons/Rockets/rocket.cgf",0,0.5);
	self.part_time = 0;
	if(self.bPhysicalized==nil)then
		self:CreateParticlePhys( 2, 10 );
		self.bPhysicalized=1;
	end
	self:EnableUpdate(1);
end

function Grenade:Server_Flying_OnUpdate(dt)

	if(self.lockTarget~=nil) then
		--FIXME hack because the better way to see if entity is still valid should be implemented soon by Alberto
		if( self.lockTarget.GetPos == nil ) then
			self.lockTarget=nil;
		else
			self:DoHam(self.lockTarget.GetPos());
		end	
	end	

	local status=GetParticleCollisionStatus(self);
	local pos=self:GetPos();
	
	if (status ~= nil) then
		--set a member variable to pass to ExecuteMaterial in OnCollision
		local material=status.target_material;
		if(IsMaterialUnpierceble(status.target_material))then
			self["status"]=status;
			self:GotoState("Exploding");
		else
			ExecuteMaterial(pos,status.normal,material.projectile_hit,1)
		end
	elseif (System:IsValidMapPos(pos) ~= 1) then
		self:GotoState("Exploding");
		--System.RemoveEntity(self.id);
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
end

function Grenade:Server_Exploding_OnUpdate(dt)
	if (_time - self.ExplosionTimer > 0.75) then
		Server:RemoveEntity( self.id );		
	end
end

function Grenade:Client_Flying_OnUpdate(dt)
	self.part_time = self.part_time + dt*2;

	if (self.part_time>0.03) then		
		self:DrawObject(0,1);
		local pos = self:GetPos();
		Particle:CreateParticle( pos,{x=0,y=0,z=0},self.Smoke );
		self.part_time=0;
	end
end

function Grenade:Client_Exploding_OnUpdate(dt)
	self.part_time = self.part_time + dt*2;
	self:SetStatObjScale((_time - self.ExplosionTimer) * 35);

	-- vPos, fRadius, DiffR, DiffG, DiffB, DiffA, SpecR, SpecG, SpecB, SpecA, fLifeTime
	--removed for better frame rate (but does not help, light must be from some where else)
	--self:AddDynamicLight(self:GetPos(), 10, 1, 1, 0.3, 1, 1, 1, 0.3, 1, 0);
	
end

function Grenade:Launch( weapon, shooter, pos, angles, dir, target )
	self.Param.heading = dir;
	self.Param.collider_to_ignore = shooter;
	self:SetPhysicParams( PHYSICPARAM_PARTICLE, self.Param );
	self:SetPos( pos );
	self:SetAngles( angles );
	self.ExplosionParams.shooter = shooter;
	self.ExplosionParams.weapon = weapon;
	
	self.lockTarget = target;

	if(self.lockTarget~=nil) then
		self:ResetHam( );
	end	
	
	if (Game:IsClient()) then
		self:DrawObject( 0, 1 );
	end

end

----------------------------------
function Grenade:Server_OnCollision( hit )
	if ( hit.target ) then
		if ( hit.target == self.ExplosionParams.shooter ) then
			return
		end
	end

	-- First-time explosion effects

	self.ExplosionParams.pos = hit.pos;
	Game:CreateExplosion( self.ExplosionParams );
	-- raduis, r, g, b, lifetime, pos
	CreateEntityLight( self, 7, 1, 1, 0.7, 0.5);

	System:DeformTerrain( hit.pos, 5, self.decal_tid );
end

function Grenade:Client_OnCollision()

	-- First-time explosion effects

	local pos = self:GetPos();

	self.status=GetParticleCollisionStatus(self);
	local hit=self.status;
	
	self.ExplosionParams.pos = pos;
	Game:CreateExplosion( self.ExplosionParams );
	
	-- raduis, r, g, b, lifetime, pos
	CreateEntityLight( self, 7, 1, 1, 0.7, 0.5);

	
	--objtype 2 mean "the terrain"
	System:DeformTerrain( pos, 4, self.decal_tid );
	
	self.ExplosionTimer = _time;

	self:DrawObject(0,0);
	
	if (hit ~= nil) then
		
		if (hit.target_material ~= nil) then
			if(Game:IsPointInWater(hit.pos))then
				local h=Game:GetWaterHeight(hit.pos)-hit.pos.z;
				if(h>2)then
					do return end
				end
			end
			
			ExecuteMaterial(hit.pos,hit.normal,hit.target_material.projectile_hit, 1 );
		else
			System:LogToConsole("hit.target_material is nil");
		end
	else
		System:LogToConsole("hit is nil");
	end
	
end

Grenade.Server = {
	OnInit = Grenade.Server_OnInit,
	--OnCollision = Grenade.Server_OnCollision,
	Flying = {
		OnBeginState = function(self)
		end,
		OnEndState = function(self)
		end,
		OnUpdate = Grenade.Server_Flying_OnUpdate,
	},
	Exploding = {
		OnBeginState = function(self)
		end,
		OnEndState = function(self)
		end,
		OnUpdate = Grenade.Server_Exploding_OnUpdate,
	},
}

Grenade.Client = {
	OnInit = Grenade.Client_OnInit,
	--OnCollision = Grenade.Client_OnCollision,
	Flying = {
		OnBeginState = function(self)
		end,
		OnEndState = function(self)
		end,
		OnUpdate = Grenade.Client_Flying_OnUpdate,
	},
	Exploding = {
		OnBeginState = function(self)
			self.Client_OnCollision( self );
		end,
		OnEndState = function(self)
		end,
		OnUpdate = Grenade.Client_Exploding_OnUpdate,
	},
}