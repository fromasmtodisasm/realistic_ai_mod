
Script:LoadScript("scripts/default/entities/weapons/BaseHandGrenade.lua");
--reload_script scripts/default/entities/weapons/glowstick.lua
local ClientEffect=function(self)
	
	self:AddDynamicLight(self:GetPos(),
				self.radius, --outer radius
				0,--diff r  
				1,--diff g 
				0,--diff b
				1,
				0,--spec r  
				1,--spec g 
				0,--spec b
				1,
				0,
				0, -- not used
				{x=0,y=0,z=1},
				360,
				nil,
				1,
				1 );
	self.time_since_spawn=(self.time_since_spawn+_frametime);
	if(self.time_since_spawn>6)then
		self.radius=self.base_radius*(((6000-((self.time_since_spawn-6)*1000))/6000));
	end
end

local param={
	ClientHooks = {
		OnExploding = ClientEffect,
		OnFlying = ClientEffect,
	},
	
	explode_on_contact=1,
	no_explosion=1,
	lifetime=12000,
};

GlowStick=CreateHandGrenade(param);
GlowStick.time_since_spawn=0;
GlowStick.radius=10;
GlowStick.base_radius=10;

GlowStick.SmokeTrail = {
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