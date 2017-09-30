Script:LoadScript("scripts/default/entities/weapons/BaseHandGrenade.lua")
local ExplodingEffect=function(self)
	if (self.counter>.6) then
		Particle:CreateParticle(self:GetPos(),{0,0,1},self.Gas)
		self.counter=0
	end
	self.counter=self.counter+_frametime
end

local ExplodeEffect=function(self)
	System:Log("DISPLAYING SOFT COVER")
end

local param={
	softcover="objects/Editor/COVER/soft_cover_0.cgf",
	softcoverscale=6,
	ClientHooks = {
		OnExplode = ExplodeEffect,
		OnExploding = ExplodingEffect,
	},
	explode_on_contact=1,
	no_explosion=1,
	lifetime=12000,
	no_trail=1,
}

ProjSmokeGrenade=CreateHandGrenade(param)
ProjSmokeGrenade.counter=1

ProjSmokeGrenade.Gas= {
	focus = 6,
	start_color = {.89,.69,.3},
	end_color = {1,1,1},
	speed = 2,
	count = 2,
	size = 1.5,size_speed=4,
	lifetime=6,
	frames=1,
	gravity ={x=.1,y=.1,z=-.3},
	rotation={x=0,y=0,z=1},
	bouncyness=0,
	tid = System:LoadTexture("textures/clouda1.dds"),
}

ProjSmokeGrenade.SmokeTrail = {
		focus = 0,
		color = {1,1,1},
		speed = 0,
		count = 1,
		size = .05,size_speed=.25,
		lifetime=.5,
		frames=1,
		tid = System:LoadTexture("textures/clouda1.dds"),
		rotation={x=0,y=0,z=3},
	}
--<<FIXME>> enter back the soft cover