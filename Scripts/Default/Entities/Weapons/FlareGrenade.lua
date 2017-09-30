
Script:LoadScript("scripts/default/entities/weapons/BaseHandGrenade.lua");

local FlyingEffect=function(self)
	if(self.counter>0.1)then
		--EFFECT
		Particle:CreateParticle( self:GetPos(), {0,0,1}, self.Stuff );
		self.counter=0;
	end
	self.counter=self.counter+_frametime;
end

local param={
	model="objects/Pickups/grenade/grenade_flash_pickup.cgf",
	ClientHooks = {
		OnFlying = FlyingEffect,
	},
	explosion_timer=10000,
	no_explosion=1,
	lifetime=10000,
	AITargetType = 0,
};

FlareGrenade=CreateHandGrenade(param);
FlareGrenade.counter=0;

FlareGrenade.SmokeTrail = {
		focus = 1,
		start_color = {1.0,0.5,0.0},
		end_color = {1.0,1.0,0.0},
		gravity={x=0.65,y=0.0,z=1.75},
		rotation={x=0.0,y=0.0,z=1.5},
		speed = 0.75,
		count = 1,
		size = 0.1, size_speed=1.95,
		LinearSizeSpeed=1,
		lifetime=8,
		frames=1,
		tid = System:LoadTexture("textures/clouda.dds"),
	}


FlareGrenade.Stuff= {
	focus = 0,
	start_color = {1,1,1},
	end_color = {1,1,1},
	speed = 8,
	count = 10,
	size = 0.025, size_speed=0,
	tail_length = 0.4,
	lifetime=0.15,
	frames=1,
	gravity ={x=0.0,y=0.0,z=0.0},
	rotation={x=0,y=0,z=10}, 
	bouncyness=0,
	tid = System:LoadTexture("textures/lens/haze2.pcx"),
	blend_type=2,
	draw_last=1,
}