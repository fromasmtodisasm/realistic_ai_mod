
Script:LoadScript("scripts/default/entities/weapons/BaseHandGrenade.lua");

local ExplodeEffect=function(self)
	--System:Log("DISPLAYING SOFT COVER");
	ClientStuff.vlayers:ActivateLayer("SmokeBlur");
	local layer = ClientStuff.vlayers:GetActivateLayer("SmokeBlur");
	
	-- count the number of smoke grenades which have exploded
	SmokeGrenade.numActive = SmokeGrenade.numActive + 1;
	
	if (layer) then	
		self.fadeInScale = 0.0;
	end
	
	self.stopSmokeTime = self.lifetime/1000.0 - 0.5*SmokeGrenade.Gas.lifetime + _time;
end

local ExplodingEffect=function(self)
	if (self.stopSmokeTime) then
		if(self.counter>0.6 and self.stopSmokeTime > _time)then
			Particle:CreateParticle( self:GetPos(), {0,0,1}, self.Gas );
			self.counter=0;
		end
		self.counter=self.counter+_frametime;
		
		-- if the localplayer is close enough to the explosion, we apply the blur
		local radiusSq = 10;
		local x = self:GetPos().x - _localplayer:GetPos().x;
		local y = self:GetPos().y - _localplayer:GetPos().y;
		local z = self:GetPos().z - _localplayer:GetPos().z;
		local distSq = x*x + y*y + z*z;
		
		local layer = ClientStuff.vlayers:GetActivateLayer("SmokeBlur");
		if (layer) then	
			local scale = 1 - distSq/radiusSq;
			
			if (scale < 0) then
				scale = 0;
			end
			
			-- have to add scale, because there could be multiple smoke grenades
			layer.fadeInScale = layer.fadeInScale + scale;
		end
	end
end

local ShutDownEffect=function(self)
  -- decrement number of active FX
	SmokeGrenade.numActive = SmokeGrenade.numActive - 1;
	
  -- only if the last grenade has been Shutdown, can we turn off the SmokeBlur effect
	if (SmokeGrenade.numActive == 0 and ClientStuff.vlayers:IsActive("SmokeBlur")) then
		ClientStuff.vlayers:DeactivateLayer("SmokeBlur");
	end
end


local ExplodeServer=function(self)
	AI:FreeSignal(1, "SMOKE_GRENADE_EFFECT", self:GetPos(), 40);
end

local param={
	model="objects/Pickups/grenade/grenade_smoke_pickup.cgf",
	AIBouncingSound = {
		SoundRadius  = AIWeaponProperties.GrenadeBounce.VolumeRadius,
		Interest = AIWeaponProperties.GrenadeBounce.fInterest,
		Threat = AIWeaponProperties.GrenadeBounce.fThreat,
	},
	AIExplodingSound = {
		SoundRadius  = AIWeaponProperties.SmokeGrenade.VolumeRadius,
		Interest = AIWeaponProperties.SmokeGrenade.fInterest,
		Threat = AIWeaponProperties.SmokeGrenade.fThreat,
	},
	
	ClientHooks = {
		OnExplode = ExplodeEffect,
		OnExploding = ExplodingEffect,
		OnShutdown = ShutDownEffect,
	},
	
	ServerHooks = {
		OnExplode = ExplodeServer,
	},
	
	exploding_sound={
		sound="sounds/building/smoke.wav",
		flags=SOUND_UNSCALABLE,
		volume=190,
		min=5,
		max=60,
	},
	loop_exploding_sound = 1,
	hit_effect = "smokegrenade_hit",
	
	softcover="objects/Editor/COVER/soft_cover_0.cgf",
	softcoverscale=6,

	explode_on_contact=1,
	damage_on_player_contact = 1,
	no_explosion=1,
	lifetime=18000,
};

SmokeGrenade=CreateHandGrenade(param);

SmokeGrenade.numActive=0;
SmokeGrenade.counter=1;
SmokeGrenade.Gas= {
	focus = 6,
	start_color = {0.89,0.49,0.2},
	end_color = {1,0.5,0.1},
	speed = 2,
	count = 2,
	size = 1.5, size_speed=4,
	lifetime=6,
	frames=1,
	gravity ={x=0.1,y=0.1,z=-0.3},
	rotation={x=0,y=0,z=1}, 
	bouncyness=0,
	tid = System:LoadTexture("textures/clouda1.dds"),
}

SmokeGrenade.SmokeTrail = {
		focus = 0,
		color = {1,1,1},
		speed = 0.0,
		count = 1,
		size = 0.05, size_speed=0.25,
		lifetime=0.5,
		frames=1,
		tid = System:LoadTexture("textures/clouda1.dds"),
		rotation={x=0,y=0,z=3},
	}


--<<FIXME>> add back the soft cover