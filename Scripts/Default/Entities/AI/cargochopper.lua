--
--
-- new CargoChopper
-------------------------------------------------------------------------------------------------------------




CargoChopper = {

	temp_ModelName = "none",

	ExplosionEffect = "explosions.helicopter_explosion.a",

	hely = 1,
	part_time = 0,
	landed = 1,
	dustTime = 0,
	
	pathStep = 0,
	dropState = 0,

	------------------------------------------
	---	rotors rotation stuff
	rotorSpeed = 0,
	rotorSpeedMax = 1600,
	rotorSpeedUp = 17,
	------------------------------------------


	-- puppet's entering stuff
	userCounter = 0,
	passengerLimit=6,
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

	theRopeEntity1 = nil,
	theRopeEntity2 = nil,
	theRopeEntity3 = nil,

	damage = 0,
	bExploded = 0,

	strafeDir = -1,

	explosionImpulse = 10,

--	theDrop1 = nil,
--	theDrop2 = nil,
--	theDrop3 = nil,

	troopersNumber = 0,
	dropCounter = 1,	
	dropDelay = 0,

	PropertiesInstance = {
		sightrange = 280,
		soundrange = 10,	-- rememeber that sound ranges intersect and sound range for AI doubles when in alert
		aibehavior_behaviour = "Heli_idle",		
		groupid = 154,
		Rope1Name	="Rope0",
		Rope2Name	="Rope1",
		Rope3Name	="Rope2",

	},

	fileModel = "objects/vehicles/v-22/v22_breakable.cgf",
	
	Properties = {		
	
		bSoundOutdoorOnly = 1,
		bTrackable=1,
		bFadeEngineSound = 1,		
		
		-- trees bending
		fBendRadius = 2.3,	-- range is 0-50
		fBendForce = 1,		-- range is 0-1

		fFlightAltitude = 20,
		fFlightAltitudeMin = 0,		
		fAttackDistanse = 20,
		fAttackAltitude = 10,
		
		fDmgScaleBullet = .1,
		fDmgScaleExplosion = 1.7,

		-- those are AI related properties
		commrange = 100.0,
		cohesion = 5,
		horizontal_fov = -1,		-- no fov restriction
		eye_height = 2.1,
		forward_speed = 10,
		back_speed = 5,
		max_health = 150,
		accuracy = 0.6,
		responsiveness = 5,
		species = 1,
		fSpeciesHostility = 2,
		fGroupHostility = 0,
		fPersistence = 0,
		aicharacter_character = "HeliCargo",
		pathname = "none",
		pathsteps = 0,
		pathstart = 0,
		bPathloop = 1,
		pointReinforce = "Drop",
		pointBackOff = "Base",
		dropAltitude = 17.1,
		
		ExplosionParams = {
			nDamage = 600,
			fRadiusMin = 20.0, -- default 12
			fRadiusMax = 20.5, -- default 70.5
			fRadius = 20, -- default 30
			fImpulsivePressure = 100600, -- default 200
		},
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
	sound_engine_file = "SOUNDS/Ambient/E3/hele/heleLP1.wav",
	sound_engine_start_file = "SOUNDS/Ambient/E3/hele/helestart.wav",
	sound_engine_stop_file = "SOUNDS/Ambient/E3/hele/heleoff.wav",
	EngineSoundTimeout = 7.534,
--	bFadeEngineSound = 0,
	FadeEngineTime = 5,

	
	sound_engine = nil,

}


----------------------------------------------------------------------------------------------------------------------------
--
--
----------------------------------------------------------------------------------------------------------------------------
--
--

CargoChopper.Client = {
	OnInit = function(self)
		System:Log("Client CargoChopper onInit");
		self:InitClient();
	end,
	OnContact = function(self,player)
 		self:OnContactClient(player);
	end,
--	OnEvent = function (self, id, params)
--		self:OnEventClient( id, params);
--	end,
	OnUpdate = function(self,dt)
--System.Log("CargoChopper Client Update ");
--		self:OnUpdate(dt);
		self:UpdateClient(dt);
--		self:UpdateCommon();
	end,
	OnBind = VC.OnBind
}


------------------------------------------------------
--
--
CargoChopper.Server = {
	OnInit = function(self)
		System:Log("Server CargoChopper onInit");	
		self:InitServer();
	end,
	OnContact = function(self,player)
 		self:OnContactServer(player);
	end,
	OnEvent = function (self, id, params)
		self:OnEventServer( id, params);
	end,
	OnShutDown = function (self)
		self:OnShutDownServer(self);
	end,
	OnUpdate = function(self,dt)
--System.Log("CargoChopper Server Update ");	
--		self:OnUpdate(dt);
		self:UpdateServer(dt);
-- 		self:UpdateCommon();
	end,
	OnDamage = function (self, hit)
--		AI:Signal(0,1,"OnReceivingDamage",self.id);
--
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
function CargoChopper:OnReset()

--System:Log("\002 OnReset ----------------------------");

	HC.StopEngineSounds( self );

--	self:RegisterWithAI(AIOBJECT_HELICOPTER,self.Properties);	
	AI:RegisterWithAI(self.id, AIOBJECT_HELICOPTER,self.Properties,self.PropertiesInstance);	
--	AI_HandlersDefault:InitCharacter( self );
--	self:SetAICustomFloat( self.Properties.fFlightAltitude );
	
	self:Land(1);

	self:ReleaseStuff();
--	self:SpawnStuff();
	self.damage = 0;
	self.bExploded = 0;
	self.dropState = 0;	
	self.dropCounter = 1;
	self.troopersNumber = 0;

	self.pathStep = 0;

	self.strafeDir = -1;
	
	if(self.Properties.bSoundOutdoorOnly == 1) then
		self.ExplosionSound = Sound:Load3DSound(self.sound_explosion_file, SOUND_OUTDOOR + SOUND_RADIUS,255,150,1000);
		self.sound_engine = Sound:Load3DSound(self.sound_engine_file, SOUND_OUTDOOR + SOUND_NO_SW_ATTENUATION,255,5,700);
		self.sound_engine_start = Sound:Load3DSound(self.sound_engine_start_file, SOUND_OUTDOOR + SOUND_RADIUS,255,5,700);
		self.sound_engine_stop = Sound:Load3DSound(self.sound_engine_stop_file, SOUND_OUTDOOR + SOUND_RADIUS,255,5,700);
	else
		self.ExplosionSound = Sound:Load3DSound(self.sound_explosion_file, SOUND_RADIUS,255,150,1000);	
		self.sound_engine = Sound:Load3DSound(self.sound_engine_file, SOUND_RADIUS,255,5,700);
		self.sound_engine_start = Sound:Load3DSound(self.sound_engine_start_file, SOUND_RADIUS,255,5,700);
		self.sound_engine_stop = Sound:Load3DSound(self.sound_engine_stop_file, SOUND_RADIUS,255,5,700);
	end
		
	self.part_time = 0;
	
	self:LoadModel();
	self:DrawObject(0,1);
	HC.ResetPieces( self );
	VC.InitAnchors( self );
	
	VC.AIDriver( self, 0 );	

	self.driverWaiting = 0;
	
	self.rotorSpeed = 0;
	self:SetShaderFloat( "Speed", self.rotorSpeed, 1, 1);
	self.rotorOn = 0;
	
--	self:SwitchLight(1);	-- switch on attached lights

end


----------------------------------------------------------------------------------------------------------------------------
--
--
function CargoChopper:OnPropertyChange()

	self:OnReset();

--	self:LoadModel();
		
--	Sound:SetSoundLoop(self.sound_engine, 1);

end


----------------------------------------------------------------------------------------------------------------------------
--
--
function CargoChopper:LoadModel()

	HC.LoadModel(self);
	
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function CargoChopper:InitClient()


	self:OnReset();

--	self:LoadModel();
		
	Sound:SetSoundLoop(self.sound_engine, 1);
	

--	self:AIDriver( 0 );	

end

----------------------------------------------------------------------------------------------------------------------------
--
--
function CargoChopper:InitServer()

	self.passengersTT = {
		{
		entity = nil,
		state = 0,
		time = 0,
		helper = "enter1",
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
		{
		entity = nil,
		state = 0,
		time = 0,
		helper = "enter1",
		in_helper = "trooper4",
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
		in_helper = "trooper5",
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
		in_helper = "trooper6",
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
	
--	self:EnableSave(0);
	
--	self:NetPresent(1);
end


--////////////////////////////////////////////////////////////////////////////////////////
--function CargoChopper:OnShutDown()

--	self:ReleaseStuff();
		
--end



----------------------------------------------------------------------------------------------------------------------------
--
--
function CargoChopper:SpawnStuff()

--System:Log("\002 SPAWN stuff");


--	self.theRopeEntity1 = Server:SpawnEntity("Rope");
--	self.theRopeEntity2 = Server:SpawnEntity("Rope");	
--	self.theRopeEntity3 = Server:SpawnEntity("Rope");	
							  
--	System:LogToConsole(self.PropertiesInstance.Rope1Name);
	self.theRopeEntity1 = System:GetEntityByName(self.PropertiesInstance.Rope1Name);
	self.theRopeEntity2 = System:GetEntityByName(self.PropertiesInstance.Rope2Name);
	self.theRopeEntity3 = System:GetEntityByName(self.PropertiesInstance.Rope3Name);

	if(self.theRopeEntity1) then
		self.theRopeEntity1:SetAngles({x=0,y=0,z=random(0, 359)});
--		self.theRopeEntity1.theHely = self;
--		self.theRopeEntity1:EnableSave ( 0 );
	end	
	if(self.theRopeEntity2) then
		self.theRopeEntity2:SetAngles({x=0,y=0,z=random(0, 359)});
--		self.theRopeEntity2.theHely = self;
--		self.theRopeEntity2:EnableSave ( 0 );
	end	
	if(self.theRopeEntity3) then

		self.theRopeEntity3:SetAngles({x=0,y=0,z=random(0, 359)});
--		self.theRopeEntity3.theHely = self;
--		self.theRopeEntity3:EnableSave ( 0 );
	end
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function CargoChopper:InitDrop()


end


----------------------------------------------------------------------------------------------------------------------------
--
--
function CargoChopper:ReleaseStuff()

--System:Log("\002 Release stuff");
	
	if(self.theRopeEntity1) then
----		self.theRopeEntity1:ReleaseStuff();
		Server:RemoveEntity( self.theRopeEntity1.id );
		self.theRopeEntity1 = nil;
	end	
	if(self.theRopeEntity2) then
----		self.theRopeEntity1:ReleaseStuff();
		Server:RemoveEntity( self.theRopeEntity2.id );
		self.theRopeEntity2 = nil;
	end	
	if(self.theRopeEntity3) then
----		self.theRopeEntity1:ReleaseStuff();
		Server:RemoveEntity( self.theRopeEntity3.id );
		self.theRopeEntity3 = nil;
	end	

	VC.EveryoneOutForce(self);
end


-------------------------------------------------------------------------------------------------------------
--
--
-------------------------------------------------------------------------------------------------------------
--
--
function CargoChopper:OnContactServer( player )
	
	if(player.type ~= "Player" ) then
		do return end
	end
end

-------------------------------------------------------------------------------------------------------------
--
--
function CargoChopper:OnContactClient( player )
	
	if(player.type ~= "Player" ) then
		do return end
	end

end

-------------------------------------------------------------------------------------------------------------
--
--
function CargoChopper:UpdateServer(dt)


	VC.UpdateEnteringLeaving( self, dt );
	VC.UpdateServerCommonT( self, dt );

	if( self.theRopeEntity1) then	-- if ropes are spawn....
		self.theRopeEntity1:SetPos(self:GetHelperPos("rope1"));
	end	
	if( self.theRopeEntity2) then	-- if ropes are spawn....		
		self.theRopeEntity2:SetPos(self:GetHelperPos("rope2"));
	end	
	if( self.theRopeEntity3) then	-- if ropes are spawn....
		self.theRopeEntity3:SetPos(self:GetHelperPos("rope3"));
	end

	if(self.dropState == 1 ) then
		local dropTarget = Game:GetTagPoint(self.Properties.pointReinforce);
		if(dropTarget) then
			local atitude = self:GetPos().z - dropTarget.z;

--System:Log( "\001 ALT "..atitude.." dAld "..(self.Properties.dropAltitude) );
			
			if( atitude < (self.Properties.dropAltitude+2.5) ) then
				self:DoDropPeople( );
			end	
		else
			System:Warning( "[AI] helicopter CargoChopper:UpdateServer can't find pointReinforce");
		end
	end

	
--System:GetEntityByName("Trooper1"):SetPos(self:GetHelperPos("rope2"));

end


-------------------------------------------------------------------------------------------------------------
--
function CargoChopper:UpdateClient(dt)

	HC.UpdateClient(self, dt);
	
end

----------------------------------------------------------------------------------------------------------------------------
--
function CargoChopper:OnDamageServer( hit )

	if (hit.damage_type ~= "normal" and hit.damage_type ~= "collision" or hit.damage<=0) then return end
	if (hit.damage_type == "normal") then
		-- this is hit by knife/shocker - don't apply damage
		local shooter = hit.shooter;
		if (shooter and shooter.fireparams and shooter.fireparams.fire_mode_type == FireMode_Melee) then return end
	end

--System:LogToConsole( "Damage  "..hit.damage.." total "..self.damage );

	if( self.damage<0 ) then
		do return end
	end

	if( hit.explosion ) then
		self.damage = self.damage + hit.damage*self.Properties.fDmgScaleExplosion;
	else	
		self.damage = self.damage + hit.damage*self.Properties.fDmgScaleBullet;
	end	
		
--	if( self.damage > self.Properties.max_health ) then
--		AI:Signal(0, 1, "GO_2_BASE", self.id);
----		self.damage = -1;		
--	end	
	
	
	--self:SetDamage;

end


----------------------------------------------------------------------------------------------------------------------------
--

----------------------------------------------------------------------------------------------------------------------------
--
--
function CargoChopper:OnShutDownServer()

System:LogToConsole( "CargoChopper OnShutDOWN ---------------------------" );

	HC.OnShutDownServer( self );

--	self:ReleaseStuff();
--	
--	for idx,piece in self.pieces do
----System:Log( " Piece #"..idx );
--		Server:RemoveEntity( piece.id );
--	end

end

----------------------------------------------------------------------------------------------------------------------------
--
--
function CargoChopper:OnSave(stm)

	stm:WriteString( self.Behaviour.Name );
	stm:WriteInt(self.pathStep);
	stm:WriteInt(self.dropState);
	stm:WriteInt(self.troopersNumber);
end

----------------------------------------------------------------------------------------------------------------------------
--
--


function CargoChopper:OnLoadRELEASE(stm)
	

	local behaviourName = stm:ReadString( );
	self.pathStep = stm:ReadInt();
	self.dropState = stm:ReadInt();
	self.troopersNumber = stm:ReadInt();

	if( behaviourName == "Heli_path" ) then
		HC.StartRotorFull( self );
		self:SetAICustomFloat( self.Properties.fFlightAltitude );		
		VC.AIDriver( self, 1 );	
		AI:Signal(0, 1, "PATH_RESTORE", self.id);
		self.RestoringState = 1;
	elseif( behaviourName == "Heli_transport" ) then
		HC.StartRotorFull( self );
		self:SetAICustomFloat( self.Properties.fFlightAltitude );
		VC.AIDriver( self, 1 );	
		self.RestoringState = 1;

		if(self.dropState ~= 3) then
			self.dropState=0;
			AI:Signal(0, 0, "BRING_REINFORCMENT", self.id);	-- abort dropping - go to base
		else
			AI:Signal(0, 1, "SWITCH_TO_TRANSPORT", self.id);
			self:SelectPipe(0,"h_timeout_readytogo");
		end
	end
end


function CargoChopper:OnLoad(stm)

	local behaviourName = stm:ReadString( );
	self.pathStep = stm:ReadInt();
	self.dropState = stm:ReadInt();
	self.troopersNumber = stm:ReadInt();

--	self.theRopeEntity1 = System:GetEntityByName(self.PropertiesInstance.Rope1Name);
--	self.theRopeEntity2 = System:GetEntityByName(self.PropertiesInstance.Rope2Name);
--	self.theRopeEntity3 = System:GetEntityByName(self.PropertiesInstance.Rope3Name);

	if( behaviourName == "Heli_path" ) then
		HC.StartRotorFull( self );
		self:SetAICustomFloat( self.Properties.fFlightAltitude );		
		VC.AIDriver( self, 1 );	
		AI:Signal(0, 1, "PATH_RESTORE", self.id);
		self.RestoringState = 1;
	elseif( behaviourName == "Heli_transport" ) then
		HC.StartRotorFull( self );
		self:SetAICustomFloat( self.Properties.fFlightAltitude );
		VC.AIDriver( self, 1 );	
		self.RestoringState = 1;

--System:Log("CargoChopper:OnLoad  "..self.dropState);

		if(self.dropState == 1) then
			self.dropState=0;
			AI:Signal(0, 0, "at_reinforsment_point", self.id);	-- ropes down
--			self:DropPeople();
--		elseif(self.dropState == 2) then
--			self:DoDropPeople();
		end	
--		if(self.dropState ~= 3) then
--			self.dropState=0;
--			AI:Signal(0, 0, "BRING_REINFORCMENT", self.id);	-- abort dropping - go to base
--		else
--			AI:Signal(0, 1, "SWITCH_TO_TRANSPORT", self.id);
--			self:SelectPipe(0,"h_timeout_readytogo");
--		end

	end

end


--------------------------------------------------------------------------------------------------------------

function CargoChopper:OnSaveOverall(stm)
end

--------------------------------------------------------------------------------------------------------------

function CargoChopper:OnLoadOverall(stm)

	self.theRopeEntity1 = System:GetEntityByName(self.PropertiesInstance.Rope1Name);
	self.theRopeEntity2 = System:GetEntityByName(self.PropertiesInstance.Rope2Name);
	self.theRopeEntity3 = System:GetEntityByName(self.PropertiesInstance.Rope3Name);
end

--------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------
--
--
function CargoChopper:OnEventServer( id, params)


--	if (id == ScriptEvent_Reset)
--	then
--	end
end


----------------------------------------------------------------------------------------------------------------------------
--
--
----------------------------------------------------------------------------------------------------------------------------
--
--

function CargoChopper:OnWrite( stm )
	
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function CargoChopper:OnRead( stm )
end


----------------------------------------------------------------------------------------------------------------------------
--
--
----------------------------------------------------------------------------------------------------------------------------
--
--
function CargoChopper:RadioChatter()
end


----------------------------------------------------------------------------------------------------------------------------
--
--
function CargoChopper:RopsDown()

--System:LogToConsole( "\001 CargoChopper RopeDown " );


--	if(self.theRopeEntity1 == nil)then	-- ropes are not spawned - spawn
		self:SpawnStuff();
--	end	


	self.theRopeEntity1:Down(0.0);
	self.theRopeEntity2:Down(0.8);
	self.theRopeEntity3:Down(0.3);

	do return end


	if( self.troopersNumber > 0 ) then
		self.theRopeEntity1:Down(0.0);
	end	
	if( self.troopersNumber > 1 ) then
		self.theRopeEntity2:Down(0.8);
	end
	if( self.troopersNumber > 2 ) then
		self.theRopeEntity3:Down(0.3);
	end

end

----------------------------------------------------------------------------------------------------------------------------
--
--
function CargoChopper:RopsUp()

	self.theRopeEntity1:Retrieve( );  
	self.theRopeEntity2:Retrieve( );  	
	self.theRopeEntity3:Retrieve( );  	
	
end


----------------------------------------------------------------------------------------------------------------------------
--
--
function CargoChopper:DropDone()


--System:LogToConsole( " CargoChopper:DropDone  -------------------------------------------------->>>" );	

-- normal speed
	self:ChangeAIParameter(AIPARAM_FWDSPEED,self.Properties.forward_speed);

end


----------------------------------------------------------------------------------------------------------------------------
--
--
function CargoChopper:ApproachingDropPoint()


--System:LogToConsole( "\001 CargoChopper:ApproachingDropPoint  -------------------------------------------------->>>" );	

-- slow down
	if( self.Properties.forward_speed > 15 ) then
		self:ChangeAIParameter(AIPARAM_FWDSPEED,self.Properties.forward_speed*.2);
	else	
		self:ChangeAIParameter(AIPARAM_FWDSPEED,self.Properties.forward_speed*.5);
	end	

end

----------------------------------------------------------------------------------------------------------------------------
--
--
function CargoChopper:TrooperOut( rope )

--System:Log( "\001 CargoChopper:TrooperOut "..self.troopersNumber);

	if( self.troopersNumber < 1 ) then return end

--System:LogToConsole( "\001 CargoChopper:TrooperOut  -------------------------------------------------->>> "..self.troopersNumber );

	local	trooperEntity = nil;
	for idx=1, self.passengerLimit do
		
--System:Log( "\001 CargoChopper:TrooperOut check "..idx);
		
		
		if(self.passengersTT[idx].entity) then
			trooperEntity = self.passengersTT[idx].entity;
			self.passengersTT[idx].entity = nil;
--System:LogToConsole( "\001 CargoChopper:TrooperOut  found			>>>" );	
			self:Unbind(trooperEntity);
			rope:DropTheEntity( trooperEntity, 1 );
		
--			trooperEntity:TriggerEvent(AIEVENT_ENABLE);
--			AI:Signal(0, 1, "exited_vehicle", trooperEntity.id);
		
--			self.troopersNumber = self.troopersNumber - 1;
			do return end
		end
	end

--System:LogToConsole( "\001 CargoChopper:TrooperOut  ######>>>" );						
--	self.troopersNumber = 0;

end

----------------------------------------------------------------------------------------------------------------------------
--
--
function CargoChopper:DropPeople()



	self.dropState = 1;
	self:SetAICustomFloat( self.Properties.dropAltitude );
	
	self:RopsDown();

end

----------------------------------------------------------------------------------------------------------------------------
--
--
function CargoChopper:DoDropPeople()

--System:Log( "\001 CargoChopper:DoDropPeople ");

	self.dropState = 2;
	self:TrooperOut( self.theRopeEntity1 );
	self.theRopeEntity1.dropEntity1Delay = 0;
	self:TrooperOut( self.theRopeEntity2 );
	self.theRopeEntity2.dropEntity1Delay = .9;
	self:TrooperOut( self.theRopeEntity3 );
	self.theRopeEntity3.dropEntity1Delay = .5;
	self:TrooperOut( self.theRopeEntity1 );
	self.theRopeEntity1.dropEntity2Delay = 0;	
	self:TrooperOut( self.theRopeEntity2 );
	self.theRopeEntity2.dropEntity2Delay = .7;
	self:TrooperOut( self.theRopeEntity3 );
	self.theRopeEntity3.dropEntity2Delay = .3;
end


----------------------------------------------------------------------------------------------------------------------------
--
--
function CargoChopper:Event_Reinforcment( params )

--System:Log("\001  CargoChopper Reinforcment  ");

	HC.StartRotor(self);

	VC.AIDriver( self, 1 );

	AI:Signal(0, 1, "BRING_REINFORCMENT", self.id);

end


----------------------------------------------------------------------------------------------------------------------------
--
--
function CargoChopper:Event_IsDead( params )
	BroadcastEvent( self,"IsDead" );
end



----------------------------------------------------------------------------------------------------------------------------
--
--
function CargoChopper:Event_Kill( params )

	HC.BlowUp(self);
--	HC.BreakOnPieces(self);
end


----------------------------------------------------------------------------------------------------------------------------
--
--
function CargoChopper:Event_GoPath( params )

--System:Log("\001  CargoChopper GoPath  ");

	HC.StartRotor(self);

	VC.AIDriver( self, 1 );	

	AI:Signal(0, 1, "wakeup", self.id);
	AI:Signal(0, 1, "GO_PATH", self.id);

end


----------------------------------------------------------------------------------------------------------------------------
--
--
-- this one starts moving immidiately - no waiting for people to get in
function CargoChopper:Event_GoPathULTIMATE( params )

--System:Log("\001  CargoChopper GoPath  ");

	HC.StartRotor(self);

	VC.AIDriver( self, 1 );	
	AI:Signal(0, 1, "DRIVER_IN", self.id);
	AI:Signal(0, 1, "GO_PATH", self.id);

end


----------------------------------------------------------------------------------------------------------------------------
--
--
function CargoChopper:Event_Land( params )
	
	self:Land();
	
end


----------------------------------------------------------------------------------------------------------------------------
--
--
function CargoChopper:Event_Fly( params )
	
	self:Fly();
	
end


-----------------------------------------------------------------------------------------------------
function CargoChopper:Event_LoadPeople( params )

	self:LoadPeople();
	
end


----------------------------------------------------------------------------------------------------------------------------
--
--






--------------------------------------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
--
--
----------------------------------------------------------------------------------------------------------------------------
--
--
function CargoChopper:AddDriver( player )

	return 0 
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function CargoChopper:AddGunner( player )

	return 0
end



----------------------------------------------------------------------------------------------------------------------------
--
--
function CargoChopper:AddPassenger( puppet )

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
function CargoChopper:DoEnter( puppet )

	local tbl = VC.FindPassenger( self, puppet );
	if( not tbl ) then return end
	VC.AddPassengerHely( self, tbl );
	VC.InitEnteringJump( self, tbl );
--		VC.InitEntering( self, tbl );
end


----------------------------------------------------------------------------------------------------------------------------
--
--

----------------------------------------------------------------------------------------------------------------------------
--
--
function CargoChopper:LoadPeople()

--	self:AIDriver( 1 );

--System:Log("CargoChopper LoadPeople  ");
	
	AI:Signal(SIGNALFILTER_GROUPONLY, 1, "wakeup", self.id);	
	AI:Signal(SIGNALFILTER_GROUPONLY, 1, "SHARED_ENTER_ME_VEHICLE", self.id);
	self.dropState = 0;
	System:Log("CargoChopper LoadPeople  ");
end


--------------------------------------------------------------------------------------------------------------
--
function CargoChopper:Land( bNoSound )

	HC.Land(self, bNoSound);

end


--------------------------------------------------------------------------------------------------------------
--
function CargoChopper:Fly( )
	HC.Fly(self);
end



--------------------------------------------------------------------------------------------------------------
--


--------------------------------------------------------------------------------------------------------------
--



--------------------------------------------------------------------------------------------------------
-- empty function to get reed of script error - it's called from behavours
function CargoChopper:MakeAlerted()
end


--------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
--
--
 