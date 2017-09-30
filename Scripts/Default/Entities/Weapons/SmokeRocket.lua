--#Script.ReloadScript("scripts/default/entities/weapons/smokerocket.lua")
SmokeRocket = {
	type = "Projectile",
	tid_cloud = System:LoadTexture("textures/cloud.jpg"),
	decal_tid = System:LoadTexture("textures/explo_decal.tga"),

	lockTarget = nil,
	smokeTime = 120,
	
	Param = {
		mass = 1,
		size = 0.05,
		heading = {},
		initial_velocity = 60,
		k_air_resistance = 0,
		acc_thrust = 0,
		acc_lift = 0,
		surface_idx = 0,
		gravity = {x=0, y=0, z=4*-9.8 },
		collider_to_ignore = nil,
	},
	
	ExplosionParams = {
		pos = {},
		damage = 160,
		rmin = 0.8,
		rmax = 10.5,
		radius = 10,
		impulsive_pressure = 5,
		shooter = nil,
		weapon = nil,
	},
	
	FlyingSmoke = {
		focus = 0,
		start_color = {0.737,0.286,0.725},
		end_color = {0.737,0.286,0.725},
		speed = 0.2,
		count = 1,
		size = 0.2, size_speed=1.2,
		lifetime=1,
		frames=1,
		tid = System:LoadTexture("textures/clouda.dds"),
	},

	SignalSmoke = {
		focus = 3,
		start_color = {0.737,0.286,0.725},
		end_color = {0.737,0.286,0.725},
		speed = 1.75,
		count = 2,
		size = 0.005, size_speed=0.1,
		lifetime=15,
		gravity = {x= 0.3,y= 0,z= 0},
		rotation = {x= 0,y = 0,z = 3},
		frames=1,
		tid = System:LoadTexture("textures/clouda.dds"),
	},
	
	RocketEngineLoop = nil,

	ExplosionTimer = 0,	
	bPhysicalized = nil,
	was_underwater=nil,
	water_normal={x=0,y=0,z=1}		
}

function SmokeRocket:Server_OnInit()
	self:RegisterState("Flying");
	self:RegisterState("Exploding");
	self:GotoState( "Flying" );

	self:SetPos({x=-1000,y=-1000,z=-1000});
	self.part_time = 0;
	if(self.bPhysicalized==nil)then
		self:CreateParticlePhys( 2, 10 );
		self.bPhysicalized=1;
	end
end

function SmokeRocket:Client_OnInit()

	self.RocketEngineLoop = Sound:Load3DSound("Sounds/building/smoke.wav",SOUND_DUPLICATE);

	self:RegisterState("Flying");
	self:RegisterState("Exploding");
	self:GotoState( "Flying" );

	self:LoadObject( "objects/weapons/Rockets/rocket.cgf",0,0.5);
	--self.LoadObject( "objects/explosion/explosion.cgf", 1, 0.5);
	self.part_time = 0;
	if(self.bPhysicalized==nil)then
		self:CreateParticlePhys( 2, 10 );
		self.bPhysicalized=1;
	end
end

function SmokeRocket:Server_Flying_OnUpdate(dt)

	if(self.lockTarget~=nil) then
		--FIXME hack because the better way to see if entity is still valid should be implemented soon by Alberto
		if( self.lockTarget.GetPos == nil ) then
			self.lockTarget=nil;
		else
			self:DoHam(self.lockTarget:GetPos());
		end	
	end	

	--System.LogToConsole("--> Rocket Snd ID: "..self.RocketEngineLoop);

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

function SmokeRocket:Server_Exploding_OnUpdate(dt)

	self.smokeTime = self.smokeTime - dt;
	if( self.smokeTime<0 ) then
		Server:RemoveEntity( self.id );
		
	end	

end

function SmokeRocket:Client_Flying_OnUpdate(dt)
	self.part_time = self.part_time + dt*2;

	if (self.part_time>0.03) then		
		self:DrawObject(0,1);
		local pos = self:GetPos();
		Particle:CreateParticle( pos,{x=0,y=0,z=0},self.FlyingSmoke );
		self.part_time=0;
	end


	-- HACK: Marco, why do I have to call PlaySound all the time, no looping ?
	--	 Alberto, why doesn't self.PlaySound() move the sound and I have to do that manually ?
--	if (Sound.IsPlaying(self.RocketEngineLoop) == nil) then
--		self.PlaySound(self.RocketEngineLoop);
--	end
--	Sound.SetSoundPosition(self.RocketEngineLoop, self.GetPos());



end

function SmokeRocket:Client_Exploding_OnUpdate(dt)

	local pos = self.GetPos();
	Particle:CreateParticle( pos,{x=0,y=0,z=1},self.SignalSmoke );

	self.part_time = self.part_time + dt*2;

	self:SetStatObjScale((System:GetCurrTime() - self.ExplosionTimer) * 35);

	-- vPos, fRadius, DiffR, DiffG, DiffB, DiffA, SpecR, SpecG, SpecB, SpecA, fLifeTime


	if (Sound:IsPlaying(self.RocketEngineLoop)) then
		Sound:SetSoundPosition(self.RocketEngineLoop, pos);
	end	
	
--self.RocketEngineLoop=-1;
end

function SmokeRocket:Launch( weapon, shooter, pos, angles, dir, target )
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

	if (self.RocketEngineLoop) then
		Sound:SetSoundLoop(self.RocketEngineLoop, 1);
		Sound:SetMinMaxDistance(self.RocketEngineLoop, 3, 100000);
		Sound:SetSoundVolume(self.RocketEngineLoop, 50);
		Sound:PlaySound(self.RocketEngineLoop);
	end
end

----------------------------------
function SmokeRocket:Server_OnCollision( hit )
end

function SmokeRocket:Client_OnCollision()
	
end

SmokeRocket.Server = {
	OnInit = SmokeRocket.Server_OnInit,
	OnCollision = SmokeRocket.Server_OnCollision,
	Flying = {
		OnBeginState = function(self)
		end,
		OnEndState = function(self)
		end,
		OnUpdate = SmokeRocket.Server_Flying_OnUpdate,
	},
	Exploding = {
		OnBeginState = function(self)
		end,
		OnEndState = function(self)
		end,
		OnUpdate = SmokeRocket.Server_Exploding_OnUpdate,
	},
}

SmokeRocket.Client = {
	OnInit = SmokeRocket.Client_OnInit,
	OnCollision = SmokeRocket.Client_OnCollision,
	Flying = {
		OnBeginState = function(self)
		end,
		OnEndState = function(self)
		end,
		OnUpdate = SmokeRocket.Client_Flying_OnUpdate,
	},
	Exploding = {
		OnBeginState = function(self)
			self.Client_OnCollision( self );
		end,
		OnEndState = function(self)
		end,
		OnUpdate = SmokeRocket.Client_Exploding_OnUpdate,
	},
}