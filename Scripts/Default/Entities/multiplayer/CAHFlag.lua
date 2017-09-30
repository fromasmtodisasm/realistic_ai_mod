--------------------------------------------------------------
-- Capture And Hold FLAG
--
-- implemented by Alberto
--
--------------------------------------------------------------
CAHFlag={
	-- all parameters present in the table Properties will be customizable by the editor
	Properties={
		particle_templ={
		TimeDelay = 0.1, -- how often particle system is spawned.
		particle_type=0, -- Type of particles 0=Billboard,1=Water splashes,2=Underwater,3=LineParticle,
		focus = 20,
		speed = 7,
		count = 4,
		size = 2,
		size_speed = 0,
		lifetime = 6.5,
		fadeintime = 1.5,
		frames = 0,
		tail_length = 0, -- Tail lengths.
		bouncyness = 0.5,
		physics = 0, -- Enable or disable real particle physics.
		-- Blend types
		blend_type =1,
		draw_last = 0,
		gravity = { x=0,y=0,z=-1 },
		rotation = { x=0,y=1,z=0 },
		--dir={ x=0,y=0,z=1 },
		tid=System:LoadTexture("Textures/carsmoke.tga"),
		turbulence_size = 0,
		turbulence_speed = 0,
		},
	},
	
	colors ={
		neutral={127,127,127},
		red={255,0,0},
		blue={0,0,255},
	},
	
	 -- used to keep track of the last collide time
	 -- This avoids switching if 2 players of opposite teams are touching the flag at the same time
	last_contact_time=0,
}

function CAHFlag:LoadGeometry()
	self:LoadObject("objects/multiplayer/boxes/grey.cgf",0,1);
	self:LoadObject("objects/multiplayer/boxes/red.cgf",1,1);	
	self:LoadObject("objects/multiplayer/boxes/blue.cgf",2,1);
end

function CAHFlag:RegisterStates()
	self:RegisterState("neutral");
	self:RegisterState("blue");
	self:RegisterState("red");
end

function CAHFlag:OnReset()
	self:GotoState("neutral");
end

CAHFlag.OnMultiplayerReset=CAHFlag.OnReset;

function CAHFlag:Event_Red()
	self:GotoState("red");
end

function CAHFlag:Event_Blue()
	self:GotoState("blue");
end

function CAHFlag:Event_Neutral()
	self:GotoState("neutral");
end

function CAHFlag:SwitchState(collider)
	local state=self:GetState();
	local team=Game:GetEntityTeam(collider.id);
	if(team~=state)then
		collider.cnt.health=collider.cnt.health+50;
		if(collider.cnt.health>collider.cnt.max_health)then
			collider.cnt.health=collider.cnt.max_health;
		end
		self:GotoState(team);
	end
end

function CAHFlag:Server_OnContact(collider)
	if(GameRules:GetState()~="INPROGRESS") then return end
	if(collider.type=="Player" and (collider.cnt.health>0)) then
		local state=self:GetState();
		local team=Game:GetEntityTeam(collider.id);
		if (state==team) then
			self.last_contact_time = _time -- update the time this flag was last touched by a living player
		elseif (_time - self.last_contact_time > .05) then -- 50 ms must have passed for the flag to switch teams
			self:SwitchState(collider);
			self.last_contact_time = _time -- update the time this flag was last touched by a living player
		end
	end
end

----------------------------------------------------
--SERVER
----------------------------------------------------
CAHFlag.Server={
	OnInit=function(self)
		self:LoadGeometry()
		self:RegisterStates();
		self:OnReset();
		--the entity will not move so only the state change is sycronized over the net
		self:NetPresent(nil);
		self:EnableUpdate(1);
		if(GameRules.RegisterFlag)then
			GameRules:RegisterFlag(self);
		end
	end,
-------------------------------------
	neutral={
		OnContact=CAHFlag.Server_OnContact,
	},
-------------------------------------
	blue={
		OnBeginState=function(self)
			Server:BroadcastText("@BlueCaptureHold");
		end,
		OnContact=CAHFlag.Server_OnContact,
	},
-------------------------------------
	red={
		OnBeginState=function(self)
			Server:BroadcastText("@RedCaptureHold");
		end,
		OnContact=CAHFlag.Server_OnContact,
	},
}

function CAHFlag:StartEmitter(color)
	local particle=new(self.Properties.particle_templ);
	local clr=self.colors[color];
	particle.end_color=clr;
	particle.start_color=clr;
	self:CreateParticleEmitter( particle, 0.2 );
end
----------------------------------------------------
--CLIENT
----------------------------------------------------
CAHFlag.Client={
	OnInit=function(self)
		self:LoadGeometry()
		self:RegisterStates();
		self:OnReset();
	end,
-------------------------------------
	neutral={
		OnBeginState=function(self)
			self:DrawObject(0,1);
			self:DrawObject(1,0);
			self:DrawObject(2,0);
	--		self:StartEmitter(self:GetState());
		end,
	},
-------------------------------------
	blue={
		OnBeginState=function(self)
			self:DrawObject(0,0);
			self:DrawObject(1,0);
			self:DrawObject(2,1);
		--	self:StartEmitter(self:GetState());
		end,
	},
-------------------------------------
	red={
		OnBeginState=function(self)
			self:DrawObject(0,0);
			self:DrawObject(1,1);
			self:DrawObject(2,0);
	--		self:StartEmitter(self:GetState());
		end,
	},
}