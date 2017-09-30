-- #Script.ReloadScript("scripts/default/entities/weapons/ProjConcussionGrenade.lua")



ProjConcussionGrenade = {
	type = "Projectile",
	tid_cloud = System:LoadTexture("textures/cloud.jpg"),
	decal_tid = System:LoadTexture("textures\\explo_decal.tga"),

	-- Miliseconds to detonation
	explosion_timer = 2500,

	-- Material of the grenade, adjust bouncyness inside
	projectile_matname = "mat_bounce",
	
	-- Ballistic properties of the grenade
	Param = {
	  flags = 0,
		mass = 1.0,
		size = 0.14,
		heading = {},
		initial_velocity = 39,
		k_air_resistance = 0.5,
		acc_thrust = 0,
		acc_lift = 0,
		surface_idx = -1,
		gravity = {x=0, y=0, z=-9.8*4 },
		min_bounce_vel = 0.1,
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
	
	ExplosionTimer = 0,	
	bPhysicalized = nil,
	was_underwater=nil,
	water_normal={x=0,y=0,z=1},

--	bExplosionLightAdded = 0,

	UpVec = {x=0, y=0, z=1},
	hud_icon=System:LoadImage("Textures/Hud/new/Weapons/Grenade.tga")
}

function ProjConcussionGrenade:Server_OnInit()

	self.Param.surface_idx = Game:GetMaterialIDByName(self.projectile_matname);

	self:RegisterState("Flying");
	self:RegisterState("Exploding");
	self:GotoState( "Flying" );

	self:SetPos({x=-1000,y=-1000,z=-1000});
	self.part_time = 0;
	if(self.bPhysicalized==nil)then
		self:CreateParticlePhys( 2, 10, 0 );
		self.bPhysicalized=1;
	end
end

function ProjConcussionGrenade:Client_OnInit()

	self:RegisterState("Flying");
	self:RegisterState("Exploding");
	self:GotoState( "Flying" );

	self:LoadObject( "objects/weapons/Grenades/Grenade.cgf",0,0.5);
	self.part_time = 0;
	if(self.bPhysicalized==nil)then
		self:CreateParticlePhys( 2, 10, 1 );
		self.bPhysicalized=1;
	end
end

function ProjConcussionGrenade:Server_Flying_OnUpdate(dt)

	local status=GetParticleCollisionStatus(self);
	local pos=self:GetPos();


	--set a member variable to pass to ExecuteMaterial in OnCollision
	self["status"]=status;

	if (status) then
		-- Instantly explode
--		self:SetTimer(1);
--	elseif (System:IsValidMapPos(pos) ~= 1) then
		self:GotoState("Exploding");
	end

	if (Materials["mat_water"] and Materials["mat_water"].projectile_hit) then
		if (self.was_underwater == nil) then
			if (Game:IsPointInWater(pos)) then
				System:LogToConsole("UNDERWATER");
				self.was_underwater=1;
				ExecuteMaterial(pos, self.water_normal, Materials.mat_water.projectile_hit, 1 )
			end
		end
	end
end

function ProjConcussionGrenade:Server_Exploding_OnUpdate(dt)
	if (_time - self.ExplosionTimer > 0.75) then
		Server:RemoveEntity( self.id );		
	end
end

function ProjConcussionGrenade:Client_Flying_OnUpdate(dt)
	self.part_time = self.part_time + dt*2;
	self:DrawObject(0,1);
end

function ProjConcussionGrenade:Client_Exploding_OnUpdate(dt)
	self.part_time = self.part_time + dt*2;

	self:SetStatObjScale((_time - self.ExplosionTimer) * 35);

	if (not self.bExplosionLightAdded) then
		-- raduis, r, g, b, lifetime
		CreateEntityLight( self, 10, 1, 1, 0.3, .5 );
--		-- vPos, fRadius, DiffR, DiffG, DiffB, DiffA, SpecR, SpecG, SpecB, SpecA, fLifeTime
--		self:AddDynamicLight(self:GetPos(), 10, 1, 1, 0.3, 1, 1, 1, 0.3, 1, 2);
		self.bExplosionLightAdded = 1;
	end
end

function ProjConcussionGrenade:Launch( weapon, shooter, pos, angles, dir )

	self.Param.heading = dir;
	self.Param.collider_to_ignore = shooter;
	self:SetPhysicParams( PHYSICPARAM_PARTICLE, self.Param );
	self:SetPos( pos );
	self:SetAngles( angles );
	self.ExplosionParams.shooter = shooter;
	self.ExplosionParams.weapon = weapon;
	
	if (Game:IsClient()) then
		self:DrawObject( 0, 1 );
	end

	self:SetTimer(self.explosion_timer);
end

----------------------------------
ProjConcussionGrenade.Server = {
	OnInit = ProjConcussionGrenade.Server_OnInit,
	Flying = {
		OnBeginState = function(self)
		end,
		OnEndState = function(self)
		end,
		OnUpdate = ProjConcussionGrenade.Server_Flying_OnUpdate,
		OnTimer = function(self)
			self:GotoState("Exploding");
		end,
	},
	Exploding = {
		OnBeginState = function(self)
		end,
		OnEndState = function(self)
		end,
		OnUpdate = ProjConcussionGrenade.Server_Exploding_OnUpdate,
		OnEvent = function(Type, Param)
		end,
	},
}

ProjConcussionGrenade.Client = {
	OnInit = ProjConcussionGrenade.Client_OnInit,
	Flying = {
		OnBeginState = function(self)
		end,
		OnEndState = function(self)
		end,
		OnUpdate = ProjConcussionGrenade.Client_Flying_OnUpdate,
		OnEvent = function(Type, Param)
		end,
	},
	Exploding = {
		OnBeginState = function(self)
			-- First-time explosion effects
			local pos = self:GetPos();
			self.ExplosionParams.pos = pos;
			Game:CreateExplosion(self.ExplosionParams);

			self.status=GetParticleCollisionStatus(self);
			local hit=self.status;

			-- objtype 2 means "the terrain"
			if (hit) then
				if (hit.objtype==2) then
					System:DeformTerrain( pos, 4, self.decal_tid );
				end
			end

			self.ExplosionTimer = _time;

			self:DrawObject(0,0);

			if (hit == nil or hit.target_material == nil) then
				hit = {};
				hit["target_material"] = Game:GetMaterialIDByName("mat_default");
				hit["pos"] = self:GetPos();
				hit["normal"] = self.UpVec;
			end

			if (Game:IsPointInWater(hit.pos)) then
			local h=Game:GetWaterHeight()-hit.pos.z;
				if(h>2)then
					do return end
				end
			end


			ExecuteMaterial(pos,normal,Materials.mat_default.projectile_hit,1);
		end,
		OnEndState = function(self)
		end,
		OnUpdate = ProjConcussionGrenade.Client_Exploding_OnUpdate,
	},
}