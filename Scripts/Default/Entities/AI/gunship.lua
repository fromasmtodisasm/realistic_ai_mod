--#Script:ReloadScript("scripts/Default/Entities/Others/piece.lua")
--Script:LoadScript("scripts/Default/Entities/Others/piece.lua")
--

-- new gunship
-------------------------------------------------------------------------------------------------------------




Gunship = {

	hely = 1,
	landed = 1,
	dustTime = 0,
	rotorOn = 0,
	
	temp_ModelName = "none",

	ExplosionEffect = "explosions.helicopter_explosion.a",
	
	pathStep = 0,
	dropState = 0,

	-- puppet's entering stuff
	userCounter = 0,
	passengerLimit=3,
	entVel = 11,
	

	V22PhysParams = {
		mass = 900,
		height = .1,
		eyeheight = .1,
		sphereheight = .1,
		radius = .5,
		gravity = 0,
		aircontrol = 1,	
	},

	troopersLimit=3,
	troopersNumber=0,
	troopers = {
		nil,
		nil,
		nil,
	},

	troopersHlp = {
		"trooper1",
		"trooper2",
		"trooper3",
	},

	troopersOutHlp = "trooperout",

	------------------------------------------
	---	rotors rotation stuff
	rotorSpeed = 0,
	rotorSpeedMax = 1600,
	rotorSpeedUp = 17,
	------------------------------------------

	damage = 0,
	bExploded = 0,

	strafeDir = -1,
	curStrafeDir = -1,
	seesPlayer=0,

	explosionImpulse = 10,

--	theDrop1 = nil,
--	theDrop2 = nil,
--	theDrop3 = nil,

	dropDelay = 0,

	PropertiesInstance = {
		sightrange = 280,
		soundrange = 10,	-- rememeber that sound ranges intersect and sound range for AI doubles when in alert
		aibehavior_behaviour = "Heli_idle",		
		groupid = 154,
	},

	Properties = {		

		fStartDelay = 2,
		bSoundOutdoorOnly = 1,
		fKillDist = 11,
		bIgnoreCollisions = 0,	--
		bIsKiller = 0,
		bFadeEngineSound = 1,

		GunnerParams = {
			responsiveness = 50,
			sightrange = 150,
			attackrange = 150,			
			horizontal_fov = -1,
--			aggression = 1,
--			accuracy = 1,
		},

		-- trees bending
		fBendRadius = 2.3,	-- range is 0-50
		fBendForce = 1,		-- range is 0-1

		fFlightAltitude = 20,
		fFlightAltitudeMin = 0,		
--		fAttackDistanse = 20,
		fAttackAltitude = 10,
		
		fDmgScaleBullet = .1,
		fDmgScaleExplosion = 1.7,
		
--		aggression = 1.0,
		commrange = 100.0,
--		cohesion = 5,
		attackrange = 70,
		horizontal_fov = -1,		-- no fov restriction
		vertical_fov =90,
		eye_height = 2.1,
--		root_bone = "Bip01",
		forward_speed = 10,
		back_speed = 5,
		max_health = 150,
--		max_healthattack = 150,		-- if damage is more then this - stop attacking, go to base
		max_damageattack = 150,		-- if damage is more then this - stop attacking, go to base		
--		accuracy = 0.6,
		responsiveness = 5,
		species = 1,
		fSpeciesHostility = 2,
		fGroupHostility = 0,
		fPersistence = 0,
--		equipEquipment = "none",
--		equipDropPack = "none",
--		AnimPack = "",
--		SoundPack = "",
		aicharacter_character = "HeliAssault",
--		bodypos = 0,
		pathname = "none",
		pathsteps = 0,
		pathstart = 0,
		bPathloop = 1,
		pointReinforce = "Drop",
		pointAttack = "Attack",
		pointBackOff = "Base",
		dropAltitude = 5.3,
		fileModel = "objects/vehicles/troopgunship/troopgunship_inflight.cgf",		
		bTrackable=1,
		
		ExplosionParams = {
			nDamage = 100,
			fRadiusMin = 20.0, -- default 12
			fRadiusMax = 20.5, -- default 70.5
			fRadius = 20, -- default 30
			fImpulsivePressure = 100600, -- default 200
		},
		fileGunModel = "Objects/Weapons/minigun/minigun.cga",
	},
	
	DamageParticles1 = {--initial smoke that shows vehicle is damaged
		focus = 0.0,
		speed = 1.5,
		count = 1,
		size = 0.06, size_speed=1.5,
		linearsizespeed=1,
		gravity={x=1,y=0.0,z=-0.6},
		rotation={x=0.0,y=0.0,z=1.85},
		lifetime=4,
		turbulence_size=0.62,
		turbulence_speed=5,
		tid = System:LoadTexture("textures/clouda2.dds"),
		start_color = {0.89,0.69,0.3},
		end_color = {1,1,1},

		frames=0,

	},


	DamageParticles1a = {--initial flame that shows vehicle is damaged
		focus = 0,
		speed = 2.0,
		count = 1,
		size = 0.05, 
		size_speed=0.5,
		gravity={x=0.0,y=0.0,z=-0.0},
		rotation={x=0.0,y=0.0,z=1.5},
		lifetime=0.4,
		tid = System:LoadTexture("textures\\cloud.dds"),
		start_color = {1,0.0,0.0},
		end_color = {1,1,0.5},
		blend_type = 2,
		frames=0,
		draw_last=1,
	},


	DamageParticles2 = {--smoke created by burning vehicle after explosion
		focus = 1.2, -- default 1.8
		speed = 0.6, -- default 1
		count = 1, -- default 1
		size = 0.3, size_speed=0.5, -- default size = 1.5-- default size_speed = 0.5 
		gravity={x=0.3,y=0.0,z=0.3}, -- default z= 0.3
		rotation={x=1.75,y=1,z=1.75}, -- default z= 1.75
		lifetime=7, -- default 7
		tid = System:LoadTexture("textures\\cloud_grey.dds"), 
		frames=0,
		color_based_blending = 2 -- default 0
	},

	DamageParticles3 = {--fire created by burning vehicle after explosion
		focus = 1.2, -- default 90
		speed = 0.6, -- default 0.25
		count = 1, -- default 1
		size = 1.3, size_speed=0.5, -- default size = 0.3-- default size_speed = 0.5 
		gravity={x=0.0,y=0.0,z=0.3}, -- default z= 0.3
		rotation={x=1.75,y=1,z=1.75}, -- default z= 1.75
		lifetime=4, -- default 2
		tid = System:LoadTexture("textures/flame.dds"),
		frames=0,
		color_based_blending = 0 -- default 0
	},

	Elementsparticle = {--helicopter engines affecting the ground
		focus = 0,
		speed = 12.0,
		count = 9,
		size = 0.01, 
		size_speed=0.01,
		turbulence_size=6,
		turbulence_speed=6,	
		gravity={x=3,y=2,z=-6},
		rotation={x=0.0,y=0.5,z=.5},
		lifetime=1.5,
		tid = System:LoadTexture("textures\\helicopter_particles_a"),
		start_color = {1.1,1},
		end_color = {1,1,1},
		blend_type = 0,
		frames=0,
		draw_last=0,
	},


	Dustparticle = {--helicopter engines affecting the ground
		focus = 0,
		speed = 7.0,
		count = 2,
		turbulence_size=6,
		turbulence_speed=6,		
		size = 2.5, 
		size_speed=0.03,
		gravity={x=0.0,y=0.0,z=-2.3},
		rotation={x=0.0,y=0.5,z=.5},
		lifetime=2.5,
		tid = System:LoadTexture("textures\\helicopter_particles_B"),
		start_color = {1,1,1},
		end_color = {0.7,0.7,0.7},
		blend_type = 0,
		frames=0,
		draw_last=1,
	},

	WaterParticle = {--helicopter engines affecting the water (dust)
		focus = 1,
		speed = 7.0,
		count = 3,
		size = 2.5, 
		size_speed=0.03,
		turbulence_size=6,
		turbulence_speed=6,		
		gravity={x=0.0,y=0.0,z=-5},
		rotation={x=-4,y=0,z=0},
		lifetime=2,
		tid = System:LoadTexture("textures\\water_splash"),
		start_color = {0.9,0.9,0.9},
		end_color = {0.6,0.6,0.6},
		blend_type = 0,
		frames=0,
		draw_last=1,
	},

	WaterRipples = {--helicopter engines affecting the water (ripples)
		particle_type = 1,	
		focus = 0,
		speed = 4.0,
		count = 1,
		size = 1.2, 
		size_speed=3,
		gravity={x=0,y=0,z=0},
		rotation={x=1,y=1,z=1},
		lifetime=2.5,
		tid = System:LoadTexture("textures\\Water_ripples"),
		start_color = {0.8,0.8,0.8},
		end_color = {1,1,1},
		blend_type = 1,
		frames=0,
		draw_last=1,
	},

	sound_explosion_file = "SOUNDS/explosions/explosion2.wav",
	sound_engine_file = "SOUNDS/vehicle/blackhawk.wav",
	sound_engine_start_file = "SOUNDS/vehicle/blackhawkstart.wav",
	sound_engine_stop_file = "SOUNDS/vehicle/blackhawkoff.wav",
	EngineSoundTimeout = 7.187,
--	bFadeEngineSound = 0,
	FadeEngineTime = 5,
	
	part_time = 0, --counter for particle update

	vDist = {x=0,y=0,z=0},
}


----------------------------------------------------------------------------------------------------------------------------
--
--
----------------------------------------------------------------------------------------------------------------------------
--
--

Gunship.Client = {
	OnInit = function(self)
		System:Log("Client Gunship onInit");
		self:InitClient();
	end,
	OnContact = function(self,player)
 		self:OnContactClient(player);
	end,
--	OnEvent = function (self, id, params)
--		self:OnEventClient( id, params);
--	end,
	OnUpdate = function(self,dt)
--System.Log("Gunship Client Update ");
--		self:OnUpdate(dt);
		self:UpdateClient(dt);
--		self:UpdateCommon();
	end,
	OnBind = VC.OnBind,
	OnUnBind = VC.OnUnBind
}


------------------------------------------------------
--
--
Gunship.Server = {
	OnInit = function(self)
		System:Log("Server Gunship onInit");	
		self:InitServer();
	end,
	OnContact = function(self,player)
 		self:OnContactServer(player);
	end,
	OnShutDown = function (self)
		self:OnShutDownServer(self);
	end,
	OnCollide = function (self, hit)
		self:OnCollideServer(hit);
	end,
	OnUpdate = function(self,dt)
--System.Log("Gunship Server Update ");	
--		self:OnUpdate(dt);
		self:UpdateServer(dt);
-- 		self:UpdateCommon();
	end,
	OnDamage = function (self, hit)
	
--		AI:Signal(0,1,"OnReceivingDamage",self.id);

--		if (self.Behaviour.OnKnownDamage) then
--			self.Behaviour:OnKnownDamage(self,hit.shooter);
--		end
--		AI:Signal(SIGNALID_READIBILITY, 1, "AI_DAMAGED",self.id);
		self:OnDamageServer( hit );
	end,
	OnTimer=function(self)
		HC.BreakOnPieces(self);
	end
}


----------------------------------------------------------------------------------------------------------------------------
--
--
function Gunship:OnReset()

--System:Log("\002 OnReset ----------------------------");

	HC.StopEngineSounds( self );

--	self:RegisterWithAI(AIOBJECT_HELICOPTER,self.Properties);	
	AI:RegisterWithAI(self.id, AIOBJECT_HELICOPTER,self.Properties,self.PropertiesInstance);
--	AI_HandlersDefault:InitCharacter( self );
--	self:SetAICustomFloat( self.Properties.fFlightAltitude );

	self:Land(1);

	self:ReleaseStuff();

	self.damage = 0;
	self.bExploded = 0;
	self.pathStep = 0;
	self.dropState = 0;	
	self.dropCounter = 1;
	self.troopersNumber = 0;
	if(random(1,100)<50) then
		self.strafeDir = -1;
	else	
		self.strafeDir = 1;
	end	
	
	
	
	self.seesPlayer = 0;
	
	if(self.Properties.bSoundOutdoorOnly == 1) then
		self.ExplosionSound = Sound:Load3DSound(self.sound_explosion_file, SOUND_OUTDOOR + SOUND_RADIUS,255,150,1000);
		self.sound_engine = Sound:Load3DSound(self.sound_engine_file, SOUND_OUTDOOR + SOUND_NO_SW_ATTENUATION,255,8,1000);
		self.sound_engine_start = Sound:Load3DSound(self.sound_engine_start_file, SOUND_OUTDOOR + SOUND_RADIUS,255,8,1000);
		self.sound_engine_stop = Sound:Load3DSound(self.sound_engine_stop_file, SOUND_OUTDOOR + SOUND_RADIUS,255,8,1000);
	else
		self.ExplosionSound = Sound:Load3DSound(self.sound_explosion_file, SOUND_RADIUS,255,150,1000);
		self.sound_engine = Sound:Load3DSound(self.sound_engine_file, SOUND_NO_SW_ATTENUATION,255,8,1000);
		self.sound_engine_start = Sound:Load3DSound(self.sound_engine_start_file, SOUND_RADIUS,255,8,1000);
		self.sound_engine_stop = Sound:Load3DSound(self.sound_engine_stop_file, SOUND_RADIUS,255,8,1000);
	end
	
	self:LoadModel();
	self:DrawObject(0,1);
	HC.ResetPieces( self );

	VC.InitAnchors( self );
--	AI:CreateBoundObject( self.id, AIAnchor.z_HELYENTER, self:GetHelperPos("enter1",1), self:GetAngles() );
--	AI:CreateBoundObject( self.id, AIAnchor.z_HELYENTER, self:GetHelperPos("enter2",1), self:GetAngles() );	

--	VC.AIDriver( self, 0 );	

	if(not self.mountedWeapon) then
		self:InitMountedWeapon( );
		if(self.mountedWeapon) then
			local ang={x=0,y=0,z=90};
			self.mountedWeapon:SetAngles( ang );
			self.mountedWeapon.Properties.angHLimit = -1;
			self.mountedWeapon.Properties.angVLimitMin = -70;	-- up direction default  -50
			self.mountedWeapon.Properties.angVLimitMax = 70;	-- down direction default 20
		end
	end
	
	self.driverWaiting = 0;
	
	VC.AIDriver( self, 0 );	
	self.rotorSpeed = 0;
	self:SetShaderFloat( "Speed", self.rotorSpeed, 1, 1);
	self.rotorOn = 0;

	self.lowHealth = nil;

--	self:SwitchLight(1);	-- switch on attached lights

end


----------------------------------------------------------------------------------------------------------------------------
--
--
function Gunship:OnPropertyChange()

	self:OnReset();

--	self:LoadModel();
		
	Sound:SetSoundLoop(self.sound_engine, 1);

end


----------------------------------------------------------------------------------------------------------------------------
--
--
function Gunship:LoadModel()
	
	HC.LoadModel(self);
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function Gunship:InitClient()

	self:OnReset();
--	self:LoadModel();
	Sound:SetSoundLoop(self.sound_engine, 1);
	
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function Gunship:InitServer()

	self.gunnerT = {
		entity = nil,
		state = 0,
		time = 0,
		helper = "enter1",
		in_helper = "gunner",
		sit_anim = "heli_gunner",
		anchor = AIAnchor.z_HELYENTER,
		exittime = 0,
		entertime = 0,
		out_ang = -90,
		timePast=0,
		HS=0,	-- used for fake jump arch calculatio - arch scale
		HK=0,	-- used for fake jump arch calculatio
		HO=0,	-- used for fake jump arch calculatio	
		HT=0,	-- used for fake jump arch calculatio
	};


	self.passengersTT = {
		{
		entity = nil,
		state = 0,
		time = 0,
		helper = "enter2",
		in_helper = "trooper1",
		sit_anim = "sidle",
		anchor = AIAnchor.z_HELYENTER,
		exittime = 0,
		entertime = 0,
		out_ang = 90,
		timePast=0,
		HS=0,	-- used for fake jump arch calculatio - arch scale
		HK=0,	-- used for fake jump arch calculatio
		HO=0,	-- used for fake jump arch calculatio	
		HT=0,	-- used for fake jump arch calculatio
		},
		{
		entity = nil,
		state = 0,
		time = 0,
		helper = "enter1",
		in_helper = "trooper2",
		sit_anim = "sidle",
		anchor = AIAnchor.z_HELYENTER,
		exittime = 0,
		entertime = 0,
		out_ang = 90,
		timePast=0,
		HS=0,	-- used for fake jump arch calculatio - arch scale
		HK=0,	-- used for fake jump arch calculatio
		HO=0,	-- used for fake jump arch calculatio	
		HT=0,	-- used for fake jump arch calculatio
		},
		{
		entity = nil,
		state = 0,
		time = 0,
		helper = "enter1",
		in_helper = "trooper3",
		sit_anim = "sidle",
		anchor = AIAnchor.z_HELYENTER,
		exittime = 0,
		entertime = 0,
		out_ang = 90,
		timePast=0,
		HS=0,	-- used for fake jump arch calculatio - arch scale
		HK=0,	-- used for fake jump arch calculatio
		HO=0,	-- used for fake jump arch calculatio	
		HT=0,	-- used for fake jump arch calculatio
		},
	};

	self:OnReset();
	
--	self:EnableUpdate(1);

--	self:LoadModel();
	
	self:EnableSave(1);
	
--	self:NetPresent(1);
end


--////////////////////////////////////////////////////////////////////////////////////////
--function Gunship:OnShutDown()

--	self:ReleaseStuff();
		
--end



----------------------------------------------------------------------------------------------------------------------------
--
--
----------------------------------------------------------------------------------------------------------------------------
--
--
function Gunship:AddDriver( player )

	return 0 
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function Gunship:AddGunner( puppet )

	if(self.Properties.attackrange<0) then return 0 end	-- this instance can't attack - no gunner 

	if (self.gunnerT.entity ~= nil)		then	-- already have a gunner
		do return 0 end
	end

	self.driverWaiting = 1;
--System:Log("adding gunner ---------------------------------------------------");

	self.gunnerT.entity = puppet;
	if( VC.InitApproach( self, self.gunnerT )==0 ) then
		self:DoEnter( puppet );
	end	
	
	if(self.Properties.bIsKiller == 1) then
		
	--System:Log("\001 GUNSHIP killer >>>>> ");
		
		puppet.killer = 1;
		puppet.Properties.bInvulnerable = 1;
	end	
	
	do return 1 end	

end



----------------------------------------------------------------------------------------------------------------------------
--
--
function Gunship:AddPassenger( puppet )


	local pasTbl = VC.CanAddPassenger( self, 1 );

	if( not pasTbl ) then	return 0 end	-- no more passangers can be added
	
	self.driverWaiting = 1;
	
	pasTbl.entity = puppet;
	if( VC.InitApproach( self, pasTbl )==0 ) then
		self:DoEnter( puppet );
	end
	do return 1 end	

end

-------------------------------------------------------------------------------------------------------------
--
--
function Gunship:DoEnter( puppet )

	if( puppet == self.gunnerT.entity ) then		-- gunner
		VC.AddGunnerHely( self, self.gunnerT );
		VC.InitEnteringJump( self, self.gunnerT );
--		VC.InitEntering( self, self.gunnerT );
	else							-- passengers
		local tbl = VC.FindPassenger( self, puppet );
		if( not tbl ) then return end
		VC.AddPassengerHely( self, tbl );
		VC.InitEnteringJump( self, tbl );
--		VC.InitEntering( self, tbl );
	end
end


----------------------------------------------------------------------------------------------------------------------------
--
--
function Gunship:ReleaseStuff()

--System:Log( "\001  Gunship:ReleaseStuff  ---------------------------------- " );

	VC.EveryoneOutForce(self);
	


end


-------------------------------------------------------------------------------------------------------------
--
--
-------------------------------------------------------------------------------------------------------------
--
--
function Gunship:OnContactServer( player )

--System:Log("\001  Gunship:OnContactServer");

	if(self.Properties.bIgnoreCollisions == 1 and player.IsCar == 1) then
		local vTmp = self:GetPos();
		self.vDist.x = vTmp.x;
		self.vDist.y = vTmp.y;
		self.vDist.z = vTmp.z;
		self.vDist=DifferenceVectors( self.vDist, player:GetPos() );
		local sDist = LengthSqVector( self.vDist );
		
--System:Log("\001  Gunship:OnContactServer   "..sDist);
		if( sDist < self.Properties.fKillDist*self.Properties.fKillDist ) then
			self.damage = self.Properties.max_health+10;
			if(player.Event_KillTriger) then
				player:Event_KillTriger();
			end	
		end	
	end
	
	if(player.type ~= "Player" ) then
		do return end
	end

end

-------------------------------------------------------------------------------------------------------------
--
--
function Gunship:OnContactClient( player )
	
	if(player.type ~= "Player" ) then
		do return end
	end

end

-------------------------------------------------------------------------------------------------------------
--
--
function Gunship:UpdateServer(dt)

	VC.UpdateEnteringLeaving( self, dt );
	VC.UpdateServerCommonT( self, dt );
	
	if( self.gunnerT.entity ) then
		local	base=self:GetAngles();
		base.z = base.z+90; 
		self.gunnerT.entity.cnt:SetAngleLimitBase(base);
	end	
		

----	local atitude = self:GetPos().z - System:GetTerrainElevation( self:GetPos() );
--
--	for idx=1, self.troopersLimit do
--		if(self.troopers[idx] ~= nil) then
--			if(self.troopers[idx].cnt.health <= 0) then
--				local pos = self:GetHelperPos(self.troopersHlp[idx]);
--				self:Unbind(self.troopers[idx]);
--				self.troopers[idx]:SetPos( pos );
--				self.troopers[idx]:ActivatePhysics(1);
--				self.troopers[idx] = nil;
--				self.troopersNumber = self.troopersNumber-1;
--			end
--		end
--	end


--System:Log( "\002 update  dropState "..self.dropState.." troopers "..self.troopersNumber);

	if(self.dropState == 1 ) then
		
--System:Log( "\001 update 22  ");
		
		if(self.troopersNumber<1 or (self.troopersNumber==1 and self.gunnerT.entity) ) then	-- if no troopers - send signal
--			AI:Signal(0, 1, "READY_TO_GO",self.id);
			AI:Signal(0, 1, "ON_GROUND",self.id);
			self.dropState = 2;
			do return end
		end
		local dropTarget = Game:GetTagPoint(self.Properties.pointReinforce);
		if(dropTarget) then
			local atitude = self:GetPos().z - dropTarget.z;

--System:Log( "ALT "..atitude.." dAld "..(self.Properties.dropAltitude+.4) );
			
			if( atitude < (self.Properties.dropAltitude+.4) and atitude > 0 ) then
				self:TrooperOut( dt );
			end	
		else
			System:Warning( "[AI] helicopter Gunship:UpdateServer can't find pointReinforce");
		end
	end
	
--System:GetEntityByName("Trooper1"):SetPos(self:GetHelperPos("rope2"));

end


-------------------------------------------------------------------------------------------------------------
--
function Gunship:UpdateClient(dt)

	HC.UpdateClient(self, dt);

--if(self.Behaviour) then
--	System:Log("\001 the behaviour is >>>>   "..self.Behaviour.Name);
--else	
--	System:Log("\001 <<< no behaviour ");
--end
	
end

----------------------------------------------------------------------------------------------------------------------------
--
function Gunship:OnDamageServer( hit )

	if (hit.damage_type ~= "normal" and hit.damage_type ~= "collision" or hit.damage<=0) then return end
	if (hit.damage_type == "normal") then
		-- this is hit by knife/shocker - don't apply damage
		local shooter = hit.shooter;
		if (shooter and shooter.fireparams and shooter.fireparams.fire_mode_type == FireMode_Melee) then return end
	end
	
	if( hit.shooter == self.gunnerT.entity ) then		-- no damage if shoont itself
--System:LogToConsole( "Self Gunner damage");	
		do return end
	end	

--System:LogToConsole( "Damage  "..hit.damage.." total "..self.damage );

	if( self.damage<0 ) then
		do return end
	end
	local prevDamage = self.damage;
	if( hit.explosion ) then
		self.damage = self.damage + hit.damage*self.Properties.fDmgScaleExplosion;
	else	
		self.damage = self.damage + hit.damage*self.Properties.fDmgScaleBullet;
	end	


--System:LogToConsole( "\001 Damage  "..self.damage.." prev "..prevDamage );
--System:LogToConsole( "\001 maxAttack "..self.Properties.max_healthattack );
	if( self.damage > self.Properties.max_damageattack and prevDamage < self.Properties.max_damageattack) then
		
--System:LogToConsole( "\001 low health >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

		AI:Signal(0, 1, "low_health", self.id);
		self:Event_LowHelath();
		self.lowHealth = 1;
	end
end


----------------------------------------------------------------------------------------------------------------------------
--
function Gunship:TrooperOut( dt )

--	if(self.troopersNumber<1) then
--		AI:Signal(0, 1, "READY_TO_GO",self.id);
--		self.dropState = 2;
--		do return end
--	end	

	self.dropDelay = self.dropDelay - dt;
	
	if(self.dropDelay>0) then
		do return end
	end	

	System:LogToConsole( " Gunship trooper is out go OUT "..self.troopersNumber);
	
	self.dropDelay = .73;


	for idx=1, self.passengerLimit do
		if(self.passengersTT[idx].entity ~= nil) then
			self.passengersTT[idx].entity:ActivatePhysics(1);
			self:Unbind( self.passengersTT[idx].entity );
			local pos = self:GetHelperPos(self.troopersOutHlp);
			self.passengersTT[idx].entity:SetPos( pos );
			self.passengersTT[idx].entity.cnt.AnimationSystemEnabled = 1;
					
			self.passengersTT[idx].entity:TriggerEvent(AIEVENT_ENABLE);		
--			AI:Signal(0, 1, "exited_vehicle", self.troopers[idx].id);
			AI:Signal(0, 1, "do_exit_hely", self.passengersTT[idx].entity.id);
--			self.troopers[idx]:SelectPipe(0,"h_user_getout");
			self.passengersTT[idx].entity = nil;
			self.troopersNumber = self.troopersNumber-1;
			do return end
		end
	end	

	
--	for idx=1, self.troopersLimit do
--		if(self.troopers[idx] ~= nil) then
--			self.troopers[idx]:ActivatePhysics(1);
--			self:Unbind( self.troopers[idx] );
--			local pos = self:GetHelperPos(self.troopersOutHlp);
--			self.troopers[idx]:SetPos( pos );
--		
--			self.troopers[idx]:TriggerEvent(AIEVENT_ENABLE);		
----			AI:Signal(0, 1, "exited_vehicle", self.troopers[idx].id);
--			AI:Signal(0, 1, "do_exit_hely", self.troopers[idx].id);
----			self.troopers[idx]:SelectPipe(0,"h_user_getout");
--			self.troopers[idx] = nil;
--			self.troopersNumber = self.troopersNumber-1;
--			do return end
--		end
--	end	

end


----------------------------------------------------------------------------------------------------------------------------
--
--
function Gunship:OnShutDownServer()

System:LogToConsole( "Gunship OnShutDOWN ---------------------------" );

	HC.OnShutDownServer( self );
	self:ReleaseMountedWeapon( );
	
--	self:ReleaseStuff();
--	self:ReleaseMountedWeapon( );

--	for idx,piece in self.pieces do
	--System:Log( " Piece #"..idx );
--		Server:RemoveEntity( piece.id );
--	end
end


----------------------------------------------------------------------------------------------------------------------------
--
--
function Gunship:RadioChatter()
end



----------------------------------------------------------------------------------------------------------------------------
--
--
function Gunship:ApproachingDropPoint()

	self:SetAICustomFloat( self.Properties.dropAltitude );

end

----------------------------------------------------------------------------------------------------------------------------
--
--
function Gunship:DropDone()

	self:ChangeAIParameter(AIPARAM_FWDSPEED,self.Properties.forward_speed);

end


----------------------------------------------------------------------------------------------------------------------------
--
--
function Gunship:DropPeople()

	self.dropState = 1;
	self:SetAICustomFloat( self.Properties.dropAltitude );
	
end


----------------------------------------------------------------------------------------------------------------------------
--
--
function Gunship:Event_Reinforcment( params )

	--System:Log("\001  Gunship Reinforcment  ");

	HC.StartRotor(self);

	VC.AIDriver( self, 1 );

	AI:Signal(0, 1, "BRING_REINFORCMENT", self.id);

end


----------------------------------------------------------------------------------------------------------------------------
--
--
function Gunship:Event_Kill( params )

	HC.BlowUp(self);
--	HC.BreakOnPieces(self);
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function Gunship:Event_IsDead( params )
	BroadcastEvent( self,"IsDead" );
end


----------------------------------------------------------------------------------------------------------------------------
--
--
function Gunship:Event_GoPath( params )

--System:Log("\001  Gunship GoPath  ");

	HC.StartRotor(self);

	VC.AIDriver( self, 1 );	

	AI:Signal(0, 1, "GO_PATH", self.id);

end


----------------------------------------------------------------------------------------------------------------------------
--
--
function Gunship:Event_GoPatrol( params )

--System:Log("\001  Gunship GoPath  ");

	HC.StartRotor(self);

	VC.AIDriver( self, 1 );	

	AI:Signal(0, 1, "GO_PATROL", self.id);

end


----------------------------------------------------------------------------------------------------------------------------
--
--
function Gunship:Event_GoAttack( params )

--System:Log("\001  Gunship GoAttack  ");

	HC.StartRotor(self);

	VC.AIDriver( self, 1 );	

--	VC.AIDriver( self, 1 );	
--	AI:Signal(SIGNALFILTER_GROUPONLY, 1, "wakeup", self.id);
	
	if(self.gunnerT.entity) then
--System:Log("\001  Gunship GoAttack has gunner ");
		self.gunnerT.entity:SelectPipe(0,"h_gunner_fire");
	end	

--	if(self.gunner) then
--		self.gunner:SelectPipe(0,"h_gunner_fire");
--	end	



	AI:Signal(0, 1, "GO_ATTACK", self.id);

end


----------------------------------------------------------------------------------------------------------------------------
--
--
function Gunship:Event_Land( params )
	
	self:Land();
	
end


----------------------------------------------------------------------------------------------------------------------------
--
--


function Gunship:Event_Fly( params )
	
	self:Fly();
	
end


-----------------------------------------------------------------------------------------------------
function Gunship:Event_LoadPeople( params )

	self:LoadPeople();
	
end

-----------------------------------------------------------------------------------------------------
function Gunship:Event_LowHelath()

	BroadcastEvent( self,"LowHelath" );
end

--////////////////////////////////////////////////////////////////////////////////////////


------------------------------------------------------
function Gunship:Event_Unhide()

	self:Hide(0);

end




----------------------------------------------------------------------------------------------------------------------------
--
--
function Gunship:LoadPeople()

	HC.LoadPeople(self);

end



--------------------------------------------------------------------------------------------------------------
--
function Gunship:HasReinforcement( )

--	if( self.troopersNumber > 0 ) then
	if( self.troopersNumber>1 or (self.troopersNumber>0 and not self.gunnerT.entity)) then
		
--	self.troopers[1] or self.troopers[2] or self.troopers[3] ) then
		return 1
	end
	return 0	
end

--------------------------------------------------------------------------------------------------------------
--
function Gunship:Land( bNoSound )

	HC.Land(self, bNoSound);
	
end


--------------------------------------------------------------------------------------------------------------
--
function Gunship:Fly( )

	HC.Fly(self);
	
end


--------------------------------------------------------------------------------------------------------------
--

function Gunship:OnSave(stm)

	HC.OnSave( self, stm );

end

--------------------------------------------------------------------------------------------------------------
--

function Gunship:OnLoad(stm)

	HC.OnLoad( self, stm );

end

--------------------------------------------------------------------------------------------------------------
--

function Gunship:OnLoadRELEASE(stm)

	HC.OnLoadRELEASE( self, stm );

end


--------------------------------------------------------------------------------------------------------
-- empty function to get reed of script error - it's called from behavours
function Gunship:MakeAlerted()
end



--------------------------------------------------------------------------------------------------------
-- empty function to get reed of script error - it's called from behavours
function Gunship:OnCollideServer( hit )

	--System:Log("\001 Gunship:OnCollideServer");
	if( hit.collier and hit.collider.IsCar == 1 ) then
		self.damage = self.Properties.max_health+10;
	end

end


-----------------------------------------------------------------------------------------------------
function Gunship:InitMountedWeapon( )
	
System:Log("Gunship::InitMountedWeapon( )");
	
--do return end

--	if(self.Properties.bAutoWeapon and self.Properties.bAutoWeapon == 1) then return end
	
	self:ReleaseMountedWeapon( );
	self.mountedWeapon = Server:SpawnEntity("MountedWeaponVehicle");
	if(not self.mountedWeapon) then
		System:Warning( "VC:InitMountedWeapon( ) could not spawn MountedWeapon ");
		return
	end
		
	if( self.Properties.fileGunModel ) then
		self.mountedWeapon.fileGunModel = self.Properties.fileGunModel;
		self.mountedWeapon.IsPhisicalized = nil;
		self.mountedWeapon:Physicalize();
--		self.mountedWeapon:OnReset();
	end
		
	self:Bind( self.mountedWeapon );
	local wpnPos = {x=0,y=0,z=3.5};
	wpnPos = self:GetHelperPos("gun",1);
	
--	wpnPos.z = wpnPos.z+1.4;
	
	self.mountedWeapon:SetPos(wpnPos);
	self.mountedWeapon:SetAngles({x=0,y=0,z=180});
	self.mountedWeapon:SetName("MWeapon_heli");
	self.mountedWeapon.Properties.angHLimit = -1;
--	self.mountedWeapon.Properties.mountRadius = 0.1;
--	self.mountedWeapon.Properties.mountHandle = -.3;
	self.mountedWeapon.isBound = self;
	self.mountedWeapon.isGunnerStatic = 1;
	self.mountedWeapon:EnableSave ( 0 );
	self.mountedWeaponId = self.mountedWeapon.id;

end




----------------------------------------------------------------------------------------------------------------------------
--
--
function Gunship:ReleaseMountedWeapon( noRemove )
--System:Log(" Gunship:ReleaseMountedWeapon");
--do return end

	-- check if already removed
	if(not System:GetEntity( self.mountedWeaponId )) then 
		self.mountedWeapon = nil;
		do return end
	end

	-- fixme - 
	-- self.mountedWeapon.StopUsing
	-- not good, should never happen
	if ( self.mountedWeapon and self.mountedWeapon.ReleaseUser== nil ) then
		System:Error("VC:ReleaseMountedWeapon  >>>>   mounted weapon is corrupted ");
		return
	end

		
	if(self.mountedWeapon) then
--System:Log(" Gunship:ReleaseMountedWeapon do it");
--		self.theRopeEntity1:ReleaseStuff();
		self.mountedWeapon:ReleaseUser( );
		self:Unbind( self.mountedWeapon );
		self.mountedWeapon.isBound = nil;
		if( not noRemove ) then
			Server:RemoveEntity( self.mountedWeapon.id, 0 );	-- do NOT remove NOW
		end
		self.mountedWeapon = nil;
	end	
end


--------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------
--
--
 