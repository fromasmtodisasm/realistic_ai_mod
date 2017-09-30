-- #Script:ReloadScript("scripts/default/entities/weapons/SniperBullet.lua")
SniperBullet = {
	type = "Projectile",
	water_normal={x=0,y=0,z=1},
	meters_per_second=600,	
	params={
		shooter=nil,
		pos={x=0,y=0,y=0},
		angles={x=0,y=0,y=0},
		dir={x=0,y=0,y=0},
		distance=0,
	},
	
	travelTime = 0,
	startDir={x=0,y=0,z=0},
	startVelosity={x=0,y=0,z=0},	
	startPos={x=0,y=0,z=0},
	prevPos={x=0,y=0,z=0},	
	firstUpdate = 1,
	
	G = 3.9,	

	
	
	temp_dir={x=0,y=0,z=0},
	traildir={x=0,y=0,z=0},
	
	-- trace "moving bullet"	
	--Trace = {
---		CGFName = "Objects/Weapons/trail.cgf",
--		tid = System:LoadTexture("Textures/WeaponMuzzleFlash/DE.jpg"),
		--focus = 5000,
		--color = { 1, 1, 1},
		--speed = 0.0,
		--count = 1,
		--size = 1.0, 
		--size_speed = 0.0,
		--gravity = { x = 0.0, y = 0.0, z = 0.0 },
		--lifetime = 0.04,
		--frames = 0,
		--color_based_blending = 3,
		--particle_type = 0,		
		--},
	--I'm just testing if this trace looks better (Alberto)
	Trace = {
			geometry=System:LoadObject("Objects/Weapons/trail.cgf"),
			focus = 5000,
			color = { 1, 1, 1},
			speed = 120.0,
			count = 1,
			size = 1.0, 
			size_speed = 0.0,
			gravity = { x = 0.0, y = 0.0, z = 0.0 },
			lifetime = 0.04,
			frames = 0,
			color_based_blending = 3,
			particle_type = bor(8,32),
		},
	
	
}

function SniperBullet:Server_OnInit()
	self:SetPos({x=-1000,y=-1000,z=-1000});
	self:EnableUpdate(1);
end

function SniperBullet:Client_OnInit()
	
printf( "bullet OnInit" );
	
--		self:LoadObject(self.Trace.CGFName, 0, 0);
--		self.Trace.stat_obj_entity_id = self.id;
--		self.Trace.stat_obj_slot = 0;
--		self.Trace.stat_obj_count = 1;
	self:EnableUpdate(1);
end

function SniperBullet:Server_OnUpdate(dt)

	if(self.firstUpdate==1) then
		self.firstUpdate = 0;
		do return end
	end	

	local	prevPos = self:GetPos();
	self.travelTime = self.travelTime + dt;
	local dir = self:UpdateBulietPos( );
	dir.x = dir.x - prevPos.x;
	dir.y = dir.y - prevPos.y;
	dir.z = dir.z - prevPos.z;

	NormalizeVector(dir);

--printf("bullet OnUpdate time %.4f bullet org %s ", self.travelTime, printvector(self.startVelosity) );
	
	self.params.pos=prevPos;
	self.params.angles=self:GetAngles();	-- not really used
	self.params.dir=dir;
	self.params.distance=self.meters_per_second*dt;
	if(self.shooter)then
		self.params.shooter=System:GetEntity(self.shooter);
	end
	
	if(self.weapon and self.params.distance>0)then
		local hit=self.weapon:GetInstantHit(self.params);
		if(hit)then
--printf("hit----------------------------------------------------------------------------------");
			self.weapon:Hit(hit);
			Server:RemoveEntity(self.id);
			return
		end
	end

	Particle:CreateParticle(self:GetPos(), dir, self.Trace, Math:ConvertUnitVectorToAngles( dir ));

	if (System:IsValidMapPos(prevPos) ~= 1) then
		
--printf("out of map---------------------------------------------------------------------------");
		Server:RemoveEntity(self.id);
	end
end

function printvector(v)
	return sprintf("x=%.2f y=%.2f z=%.2f",v.x,v.y,v.z);
end

function SniperBullet:UpdateBulietPos( )


--printf("bullet OnUpdate time %.4f bullet org %s ", self.travelTime, printvector(self.startVelosity) );

	local dx = self.startVelosity.x*self.travelTime;
	local dy = self.startVelosity.y*self.travelTime;
	local dz = self.startVelosity.z*self.travelTime - self.G*self.travelTime*self.travelTime;	--vt-1/2*at^2
	local pos = {x=0, y=0, z=0};	
	pos.x = self.startPos.x + dx;
	pos.y = self.startPos.y + dy;
	pos.z = self.startPos.z + dz;
--	FastSumVectors(pos,self.startPos,{dx, dy, dz});
	self:SetPos(pos);
	return pos;
end

function SniperBullet:CalcBulletPos( dir, distance )

--NormalizeVector( dir );

local	time = distance/self.meters_per_second;
local	fallOff = -self.G*time*time;
local	bulletPos = new(dir);

	ScaleVectorInPlace( bulletPos, distance );
	
--printf( "dir <%s> time %f off %f pos <%s>", printvector(dir), time, fallOff, printvector(bulletPos));		
	bulletPos.z = bulletPos.z + fallOff;
	
	return bulletPos;
end


function SniperBullet:Client_OnUpdate(dt)
end

function SniperBullet:Launch( weapon, shooter, pos, angles, dir, target )

	self.firstUpdate = 1;
	self.shooter=shooter.id;
	self:SetPos( pos );
	self:SetAngles( self.angles );
	self.weapon=weapon;
	self.startPos=new(pos);
	self.prevPos=new(pos);
	self.travelTime = 0;
--	ConvertToRadAngles(self.startDir,angles);
	self.startDir = new(dir);
	
	self.startVelosity = new(dir);
	
	self.startVelosity.x = self.startDir.x * self.meters_per_second;
	self.startVelosity.y = self.startDir.y * self.meters_per_second;	
	self.startVelosity.z = self.startDir.z * self.meters_per_second;	
	
--	FastScaleVector(self.startVelosity, self.startDir, self.meters_per_second);	
--printf("firedirection  %s  %s ",printvector(self.startDir),printvector(self.startVelosity));

printf( "bullet Launch @ %s",printvector(self:GetPos()) );
	
end

----------------------------------
function SniperBullet:Server_OnShutDown( )
end

function SniperBullet:Client_OnShutDown( )
end

SniperBullet.Server = {
	OnInit = SniperBullet.Server_OnInit,
	OnShutDown = SniperBullet.Server_OnShutDown,
	OnUpdate = SniperBullet.Server_OnUpdate,
}

SniperBullet.Client = {
	OnInit = SniperBullet.Client_OnInit,
	OnShutDown = SniperBullet.Client_OnShutDown,
	OnUpdate = SniperBullet.Client_OnUpdate,
}
