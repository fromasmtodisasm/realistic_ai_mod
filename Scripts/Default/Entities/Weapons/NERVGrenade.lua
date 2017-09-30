-- #Script.ReloadScript("scripts/default/entities/weapons/NERVGrenade.lua")
NERVGrenade = {
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
		initial_velocity = 50,
		k_air_resistance = 0,
		acc_thrust = 0,
		acc_lift = 0,
		surface_idx = 0,
		gravity = {x=0, y=0, z=4*-9.8 },
		collider_to_ignore = nil,
	},
	
	Gas = {
		focus = 0,
		color = {1,1,1},
		speed = 0.8,
		count = 1,
		size = 1.20, size_speed=0.70,
		lifetime=8,
		frames=1,
		color_based_blending = 0,
		gravity ={x=0.1,y=0.1,z=-0.1},
		tid = System:LoadTexture("textures/decal/nervecloud.dds"),
	},
	
	
	
	ExplosionTimer = 0,	
	bPhysicalized = nil,
	lifetime=10,
	was_underwater=nil,
	water_normal={x=0,y=0,z=1},
	v_000={x=0,y=0,z=0}
}

function NERVGrenade:Server_OnInit()
	self:RegisterState("Flying");
	self:RegisterState("Exploding");
	self:GotoState( "Flying" );
	self.gas_sound=Sound:Load3DSound("sounds/weapons/grenade/nerve.wav",SOUND_UNSCALABLE,75,2,100000),
	self:SetPos({x=-1000,y=-1000,z=-1000});
	self.part_time = 0;
	if(self.bPhysicalized==nil)then
		self:CreateParticlePhys( 2, 10 );
		self.bPhysicalized=1;
	end
end

function NERVGrenade:Client_OnInit()


	self:RegisterState("Flying");
	self:RegisterState("Exploding");
	self:GotoState( "Flying" );

	self:LoadObject( "objects/weapons/Rockets/Rocket.cgf",0,0.5);
--	self.LoadObject( "objects/explosion/explosion.cgf", 1, 0.5);
	self.part_time = 0;
	if(self.bPhysicalized==nil)then
		self:CreateParticlePhys( 2, 10 );
		self.bPhysicalized=1;
	end
end

function NERVGrenade:Server_Flying_OnUpdate(dt)
	local status=GetParticleCollisionStatus(self);
	local pos=self:GetPos();
	if ( status) then
		--set a member variable to pass to ExecuteMaterial in OnCollision
		self["status"]=status;
		self:GotoState("Exploding");
	elseif (System:IsValidMapPos(pos) ~= 1) then
		self:GotoState("Exploding");
		--System.RemoveEntity(self.id);
	end
end

function NERVGrenade:Server_Exploding_OnUpdate(dt)
	self.esm:Update(self);
	--if (_time - self.ExplosionTimer > self.lifetime) then
	--System:LogToConsole("STOPPING NERV GRANADE SOUND");
		--Sound:StopSound(self.gas_sound);
		--Server:RemoveEntity( self.id );		
	--end
end

function NERVGrenade:Client_Flying_OnUpdate(dt)

	self.part_time = self.part_time + dt*2;

	if (self.part_time>0.1) then
		self:DrawObject(0,1);
		local pos = self:GetPos();
		Particle:CreateParticle( pos,{x=0,y=0,z=0},self.Smoke );
		self.part_time=0;
	end

--	self:AddDynamicLight(self:GetPos(), 10, 1, 1, 0.3, 1, 1, 1, 0.3, 1, 0);
end

function NERVGrenade:Client_Exploding_OnUpdate(dt)
	--self.part_time = self.part_time + dt*2;

	--self:SetStatObjScale((_time - self.ExplosionTimer) * 35);
	Particle:CreateParticle( self:GetPos(), {0,0,0}, self.Gas );

	-- vPos, fRadius, DiffR, DiffG, DiffB, DiffA, SpecR, SpecG, SpecB, SpecA, fLifeTime
	--self:AddDynamicLight(self:GetPos(), 10, 1, 1, 0.3, 1, 1, 1, 0.3, 1, 0);
	
end

function NERVGrenade:Launch( weapon, shooter, pos, angles, dir )
	self.Param.heading = dir;
	self.Param.collider_to_ignore = shooter;
	self:SetPhysicParams( PHYSICPARAM_PARTICLE, self.Param );
	self:SetPos( pos );
	self:SetAngles( angles );
	self.shooter=shooter;
	self.weapon=weaopn;
	--self.ExplosionParams.shooter = shooter;
	--self.ExplosionParams.weapon = weapon;
	
	if (Game:IsClient()) then
		self:DrawObject( 0, 1 );

	end
end

----------------------------------
function NERVGrenade:Server_OnCollision( hit )
	
	self.ExplosionParams.pos = hit.pos;
	
	if ( hit.target ) then
		if ( hit.target == self.ExplosionParams.shooter ) then
			return
		end
	end
end

function NERVGrenade:Client_OnCollision()

--	System:LogToConsole("asdads adasd adasd asdasd");
	Sound:SetSoundLoop(self.gas_sound,1);
	self:PlaySound(self.gas_sound);

	
	-- First-time explosion effects

	local pos = self:GetPos();

	local hit=self.status;
	
	
	
	self.ExplosionTimer = _time;

--	self.DrawObject(1,1);
	self:DrawObject(0,0);
	
	if (hit ~= nil) then
		
		if (hit.target_material ~= nil) then
			if(Game:IsPointInWater(hit.pos))then
				local h=Game:GetWaterHeight()-hit.pos.z;
				if(h>2)then
					do return end
				end
			end
			
			--ExecuteMaterial( hit.pos, hit.normal, hit.target_material.grenade_hit, 1 );
		else
			System:LogToConsole("hit.target_material is nil");
		end

	else
		System:LogToConsole("hit is nil");
	end
	
end

function NERVGrenade:CreateExplodingStateMachine()
	self.esm=CreateStateMachine();
	local exploding=self.esm:CreateState("exploding");
	
	-----
	local updating=function (self,params) 
		System:LogToConsole("exploding")
	end
	-----
	local stopping=function (self,params)
		System:LogToConsole("STOPPING NERV GRANADE SOUND");
		Sound:StopSound(params.gas_sound);
		Server:RemoveEntity( params.id );		
	end
	
	exploding:AddHandler(STATE_HANDLER_ONUPDATE, updating);
	exploding:AddHandler(STATE_HANDLER_ONTIMER, stopping);
	self.esm:SetTimer(self.lifetime*1000);
	self.esm:GotoState("exploding");
end

NERVGrenade.Server = {
	OnInit = NERVGrenade.Server_OnInit,
	OnCollision = NERVGrenade.Server_OnCollision,
	Flying = {
		OnBeginState = function(self)
		end,
		OnEndState = function(self)
		end,
		OnUpdate = NERVGrenade.Server_Flying_OnUpdate,
	},
	Exploding = {
		OnBeginState = function(self)
			self:SetBBox({x=-6,y=-6,z=-6},{x=6,y=6,z=6});
		end,
		OnEndState = function(self)
		end,
		OnContact = function(self,collider)
			if(collider.type=="Player")then
				local hit={};
				hit.weapon=self.weapon;
				hit.target=collider;
				hit.shooter=self.shooter;
				hit.damage=1;
				hit.weapon_death_anim_id=0;
				hit.explosion=1;
				hit.dir=self.v_000;
				hit.target_material=Materials.mat_flesh;
				collider:Damage(hit);
			end
		end,
		OnUpdate = NERVGrenade.Server_Exploding_OnUpdate,
	},
}

NERVGrenade.Client = {
	OnInit = NERVGrenade.Client_OnInit,
	OnCollision = NERVGrenade.Client_OnCollision,
	Flying = {
		OnBeginState = function(self)
		end,
		OnEndState = function(self)
		end,
		OnUpdate = NERVGrenade.Client_Flying_OnUpdate,
	},
	Exploding = {
		OnBeginState = function(self)
			self.Client_OnCollision( self );
			self:CreateExplodingStateMachine();
			
		end,
		OnEndState = function(self)
		end,
		OnUpdate = NERVGrenade.Client_Exploding_OnUpdate,
	},
}