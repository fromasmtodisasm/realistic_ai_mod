--#Script.ReloadScript("SCRIPTS/Default/Entities/Vehicles/boat.lua")
	BoatPatrol = {
--	type = "Vehicle",

	fPartUpdateTime = 0,
	fGroundtime = 0,
	dWeapon = 0,
	tpvStateD = 0,
	driverState = 0,


	userCounter = 0,
	driverWaiting = 1,
	driverDelay = 0,
	passengerLimit = 0,




	curPathStep = 0,
	

	IsPhisicalized = 0,	
		
------------------------------begin-----------------------------------
------------initial effect that shows vehicle is damaged----------------
	DamageParticles1 = {--white smoke
		focus = 2.5,
		speed = 1.5,
		count = 2,
		size = 0.7, 
		size_speed=0.05,
		gravity={x=0.0,y=0.0,z=-0.3},
		rotation={x=0.0,y=0.0,z=1.5},
		lifetime=4,
		tid = System:LoadTexture("textures\\clouda2.dds"),
		start_color = {0.89,0.69,0.3},
		end_color = {1,1,1},
		turbulence_size=0.5,
		turbulence_speed=0.5,

		frames=0,
	},
	DamageParticles1a = { --sparks
		focus = 2.5,
		color = {1,1,1},
		speed = 5.0,
		count = 1,
		size = 0.030, 
		size_speed=0,
		gravity={x=0,y=0,z=-15},
		lifetime=0.5,
		tid = System:LoadTexture("Textures/Decal/Spark.dds"),
		start_color = {1,0.0,0.0},
		end_color = {1,1,1},
		tail_length = 0.2,
		frames=0,
		blend_type = 2,

	},

	DamageParticles1b = { --small flame
		focus = 3,
		speed = 1.5,
		count = 1,
		size = 0.07, 
		size_speed=0.1,
		gravity={x=0.0,y=0.0,z=-0.3},
		rotation={x=0.0,y=0.0,z=1.5},
		lifetime=0.75,
		tid = System:LoadTexture("textures\\cloud.dds"),
		start_color = {1,0.0,0.0},
		end_color = {1,1,0.5},
		blend_type = 2,

		frames=0,

	},
------------initial effect that shows vehicle is damaged---------------
----------------------------end---------------------------------------


------------effect created by burning vehicle after explosion-----------
----------------------------begin--------------------------------------



	DamageParticles3 = {--fire 
		focus = 2,
		speed = 2.5,
		count = 3,
		size = 0.75, 
		size_speed=0.2,
		gravity={x=0.0,y=0.0,z=0},
		rotation={x=0.0,y=0.0,z=1.5},
		lifetime=0.75,
		tid = System:LoadTexture("textures\\cloud.dds"),
		start_color = {1,0.0,0.0},
		end_color = {1,1,0.5},
		blend_type = 2,
		frames=0,
		draw_last=1,
	},

	DamageParticles2 = { --smoke
		focus = 3,
		speed = 2,
		count = 3,
		size = 0.5, 
		size_speed=0.5,
		gravity={x=0.0,y=0.0,z=0},
		rotation={x=0.0,y=0.0,z=1.0},
		lifetime=3,
		tid = System:LoadTexture("textures\\cloud_black1.dds"),
		frames=0,
		draw_last=0,
	},

------------effect created by burning vehicle after explosion-----------
--------------------------------end------------------------------------
 


	-- parts that will be thrown away during the explosion

	ExplodingPart1 = {
		file = "Objects/Vehicles/gunboat/gunboat_debris03.cgf",
		geometry=nil,
		focus = 3, 
		color = { 1, 1, 1},
		speed = 8.0,
		count = 2, 
		size = 1.0,
		size_speed = 0.0,
		gravity = { x = 0.0, y = 0.0, z = -5.81 },
		rotation={x=12.75,y=22,z=1.75},
		lifetime = 4.0,
		frames = 0,
		color_based_blending = 0,
		particle_type = 0,
    		ChildSpawnPeriod = 0.05,
    		ChildProcess = 
			{
			focus = 15,
			speed = 0.5,
			count = 1,
			size = 0.35, 
			size_speed=0.2,
			gravity={x=0.0,y=0.0,z=5.0},
			rotation={x=0.0,y=0.0,z=1.5},
			lifetime=1,
			tid = System:LoadTexture("textures\\cloud.dds"),
			start_color = {0.75,0.0,0.0},
			end_color = {0.75,0.75,0.35},
			blend_type = 2,
			frames=0,
			draw_last=1,
	  		}
	},
	ExplodingPart2 = {
		
		focus = 3, 
		color = { 1, 1, 1},
		speed = 8.0,
		count = 3, 
		size = 0.0,
		size_speed = 0.0,
		gravity = { x = 0.0, y = 0.0, z = -5.81 },
		rotation={x=0,y=0,z=0},
		lifetime = 4.0,
		frames = 0,
		bouncyness = 0,
    		ChildSpawnPeriod = 0.05,
    		ChildProcess = 
			{
			focus = 15,
			speed = 0.5,
			count = 1,
			size = 0.15, 
			size_speed=0.1,
			gravity={x=0.0,y=0.0,z=5.0},
			rotation={x=0.0,y=0.0,z=1.5},
			lifetime=0.5,
			tid = System:LoadTexture("textures\\cloud.dds"),
			start_color = {0.75,0.0,0.0},
			end_color = {0.75,0.75,0.35},
			blend_type = 2,
			frames=0,
			draw_last=1,
	  		}
	},



	szNormalModel="objects/Vehicles/patrolboat/patrolboat.cgf",
	-- szNormalModel="objects/Vehicles/patrolboat/patrolboat_hull.cgf",

	PropertiesInstance = {
		sightrange = 180,
		soundrange = 10,	-- rememeber that sound ranges intersect and sound range for AI doubles when in alert
		aibehavior_behaviour = "Boat_idle",		
		groupid = 154,
	},


	Properties = {		
		bTrackable=1,
		fileName = "objects/Vehicles/patrolboat/patrolboat.cgf",
		--fileName = "objects/Vehicles/gunboat/gunboat.cgf",					
		-- defines the intensity of the damage caused by the weapons to
		-- the vehicle
		fDmgScaleExplosion = 2.0,		-- explosions
		fDmgScaleBullet = 0.5,			-- shooting
		
		bDrawDriver = 0,
		bUsable = 1,								-- if this boat can be used by _localplayer
		damping = 0.1,
		water_damping = 0,
		water_sleep_speed = 0.015,
		water_resistance = 1000,
		fLimitLRAngles = 150,
		fLimitUDMinAngles = -45,
		fLimitUDMaxAngles = 40,
		
		ExplosionParams = {
			nDamage = 600,
			fRadiusMin = 8.0, -- default 12
			fRadiusMax = 10, -- default 35.5
			fRadius = 10, -- default 17
			fImpulsivePressure = 200, -- default 200
		},
-- those are AI related properties
		pointReinforce = "Drop",
		pointBackOff = "Base",
		aggression = 1.0,
		commrange = 100.0,
		cohesion = 5,
		attackrange = 70,
		horizontal_fov = 160,
		vertical_fov =90,
		eye_height = 2.1,
		max_health = 70,
		accuracy = 0.6,
		responsiveness = 7,
		species = 1,
		fSpeciesHostility = 2,
		fGroupHostility = 0,
		fPersistence = 0,
		aicharacter_character = "BoatGun",
		bodypos = 0,
		pathname = "none",
		pathsteps = 0,
		pathstart = 0,
		
		bUsePathfind = 0,	-- pathfind when outdoors
	},


--	boat_params={
--		Dumprot	 	= 6000,
--		Dumpv		= 700,
--		Dumpvh		= 10000,
--		Dumpw		= 2000,	--waves dump
--		Turn		= 12000,
--		Speedv		= 30000,
--		Speedturnmin	= 3,
--		Stand		= 10000,	-- forsing to normal vertical position impuls
--		WaveM		= 500,	--fake waves momentum
--		TiltTurn	= 130,	--tilt momentum when turning
--		fMass 		= 2800,
--	},
	
	boat_params={
		Dumprot	 	= 19000,
		Dumpv		= 1900,
		Dumpvh		= 59000,
		Dumpw		= 8000,	--waves dump
		Turn		= 12000,
		Speedv		= 30000,
		Speedturnmin	= 3,
		Stand		= 10000,	-- forsing to normal vertical position impuls
		WaveM		= 500,	--fake waves momentum
		TiltTurn	= 130,	--tilt momentum when turning
		fMass 		= 12800,
	},



	
	
--	b_speedv = 1200,  -- controls boat speed (movement forward/backward impulse) 
--	b_turn = 100,  -- controls how fast boat turns (turning left/right impulse)
--	fMass = 2500,

	sound_time = 0,

	particles_updatefreq = 0.07, --initial frequency of updating wheel dust particles and 1st damage partcls



--// particles definitions
--////////////////////////////////////////////////////////////////////////////////////////
	WaterFogTrail=
			{ --WaterFogTrail
				focus = 50,
				start_color = {1,1,1},
				end_color = {1,1,1}, 
				gravity = {x = 0.0,y = 0.0,z = -6.5}, --default z = -6.5
				rotation = {x = 0.0, y = 0.0, z = 2},
				speed = 12, -- default 12
				count = 12,
				size = 1, 
				size_speed=2.50, --default = 15
				lifetime= 1.0, --default = 3.5
				tid = System:LoadTexture("textures\\clouda2.dds"),
				frames=1,
				blend_type = 0
			},
	WaterSplashes=
			{ --WaterSplashes
				focus = 60.0, --default = 0.7
				start_color = {1,1,1},
				end_color = {1,1,1},
				gravity = {x = 0.0,y = 0.0,z = 0.0}, --default z = -8
				rotation = {x = 0.0, y = 0.0, z = 0.0}, --default z = 0.5
				speed = 6,
				count = 1,
				size = 10.0, --it was 15
				size_speed=20,
				lifetime= 18.0, --default = 0.5
				tid = System:LoadTexture("textures\\dirt2.dds"),
				frames=1,
				blend_type = 0,
				particle_type=1
			},

	PropellerWake=
			{ --PropellerWake
				focus = 20.0, --default = 60
				start_color = {1,1,1},
				end_color = {1,1,1},
				gravity = {x = 0.0,y = 0.0,z = 0.0}, 
				rotation = {x = 0.0, y = 0.0, z = 0.0}, 
				speed = 6,
				count = 5,
				size = 4.0, --default = 4
				size_speed=4.0,
				lifetime= 3.0, --default = 3.0
				tid = System:LoadTexture("textures\\dirt2.dds"),
				frames=1,
				blend_type = 0,
				particle_type=1
			},

	bExploded=false,

	-- engine health, status of the vehicle
	-- default is set to maximum (1.0f)
	fEngineHealth = 100.0,

	-- damage inflicted to the vehicle when it collides
	fOnCollideDamage=0,

	bGroundVehicle=0,

	-- to smooth speed changes
	timecount=0,
	previousTimes={},

	--seats
	driverT = {
		helper = "driver",
		in_helper = "driver_sit_pos",
		sit_anim = "sidle",
		anchor = AIAnchor.AIANCHOR_BOATENTER_SPOT,
		out_ang = -90,
		message = "Press USE KEY to enter driver of gunboat",
		timePast=0,
		HS=0,	-- used for fake jump arch calculatio - arch scale
		HK=0,	-- used for fake jump arch calculatio
		HO=0,	-- used for fake jump arch calculatio	
		HT=0,	-- used for fake jump arch calculatio
	},
}

VC.CreateVehicle(BoatPatrol);

--////////////////////////////////////////////////////////////////////////////////////////
function BoatPatrol:OnReset()
	VC.OnResetCommon(self);

	VC.InitBoatCommon(self);

	self:NetPresent(1);

	self:UnloadPeople();

	self.fEngineHealth = 100.0;
	self.bExploded=false;
	self.cnt:SetVehicleEngineHealth(self.fEngineHealth);
	
	--AI stuff
--	self:RegisterWithAI(AIOBJECT_BOAT,self.Properties);	
	AI:RegisterWithAI(self.id, AIOBJECT_BOAT,self.Properties,self.PropertiesInstance);	
--	AI_HandlersDefault:InitCharacter( self );
	VC.AIDriver( self, 1 );	

	self.curPathStep = 0;

	self.driverState = 0;

	self.fPartUpdateTime = 0;
	self.fGroundtime = 0;
	
	VC.EveryoneOutForce(self);
	
end


--////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////
--// CLIENT functions definitions
--////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////
BoatPatrol.Client = {
	OnInit = function(self)
		--System:Log("CLIENT Boat Patrol onInit");
		self:OnInitClient();
	end,

	OnUpdate = function(self,dt)
		self:UpdateClient(dt);
	end,

	OnContact = function(self,player)
 		self:OnContactClient(player);
	end,

	OnDamage = function(self,hit)
		self:OnDamageClient(hit);
	end,

	OnCollide = function(self,hit)
		self:OnCollide(hit);
	end,
}

--////////////////////////////////////////////////////////////////////////////////////////
function BoatPatrol:OnInitClient()
	VC.InitSeats(self, BoatPatrol);

	--// load sounds on the client
	--////////////////////////////////////////////////////////////////////////////////////////
	
	self.ExplosionSound=Sound:Load3DSound("sounds\\weapons\\explosions\\mbarrel.wav",0,0,7,100000);

	self.drive_sound = Sound:Load3DSound("sounds\\vehicle\\boat\\gunboat_idle.wav",0,255,30,300);
	self.drive_sound_move = Sound:Load3DSound("sounds\\vehicle\\boat\\splashLP.wav",0,130,30,300);

	self.accelerate_sound = {
		Sound:Load3DSound("sounds\\vehicle\\rev1.wav",0,0,7,100000),
		Sound:Load3DSound("sounds\\vehicle\\rev2.wav",0,0,7,100000),
		Sound:Load3DSound("sounds\\vehicle\\rev3.wav",0,0,7,100000),
		Sound:Load3DSound("sounds\\vehicle\\rev4.wav",0,0,7,100000),
	};

	self.break_sound = Sound:Load3DSound("sounds\\vehicle\\break1.wav",0,0,7,100000);
	self.engine_start = Sound:Load3DSound("sounds\\vehicle\\boat\\gunboat_start.wav",0,255,30,300);
	self.engine_off = Sound:Load3DSound("sounds\\vehicle\\boat\\gunboat_off.wav",0,255,30,300);
	self.sliding_sound = Sound:Load3DSound("sounds\\vehicle\\break2.wav",0,0,7,100000);

	self.crash_sound = Sound:Load3DSound("sounds\\vehicle\\boat\\gunboathit.wav",0,70,7,100000);

	self.ExplodingPart1.geometry=System:LoadObject(self.ExplodingPart1.file);

	-- init common stuff for client and server
	VC.InitBoatCommon(self);

end

--////////////////////////////////////////////////////////////////////////////////////////
function BoatPatrol:UpdateClient(dt)

	self.DoParticles(self);


	

	VC.PlayEngineOnOffSounds(self);

	-- plays the sounds, using a timestep of 0.04 		

	self.sound_time = self.sound_time + dt;
	if ( self.sound_time > self.particles_updatefreq ) then		
		

		-- create particles and all that 
		VC.ExecuteDamageModel(self);

		if(self.fEngineHealth<1)then
			self.particles_updatefreq=0.4;
		end


		-- reset timer
		self.sound_time = 0;

		-- get vehicle's velocity
		local fCarSpeed = self.cnt:GetVehicleVelocity();


		-- average the last 4 speed frames together to smooth changes out a bit
		-- especially for water vehicles
		self.previousTimes[band(self.timecount,3)]=fCarSpeed;
		self.timecount=self.timecount+1;

		local total=0;	
		for idx, element in self.previousTimes do
			total=total+element;
		end

		if (total<=0.1) then
			total=1;
		end

		fCarSpeed=total/4.0;

				
		VC.PlayDrivingSounds(self,fCarSpeed);
	end
end


--////////////////////////////////////////////////////////////////////////////////////////
function BoatPatrol:OnContactClient( player )
	
end

--////////////////////////////////////////////////////////////////////////////////////////
function BoatPatrol:DoParticles(dt)

	VC.CreateWaterParticles(self);

end


--////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////
--// SERVER functions definitions
--////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////
BoatPatrol.Server = {
	OnInit = function(self)
		self:OnInitServer();
	end,

	OnContact = function(self,player)
 		self:OnContactServer(player);
	end,

	OnEvent = function (self, id, params)
		self:OnEventServer( id, params);
	end,

	OnUpdate = function(self,dt)
		self:UpdateServer(dt);
	end,

	OnDamage = function(self,hit)
		self:OnDamageServer(hit);
	end,
}

--////////////////////////////////////////////////////////////////////////////////////////
function BoatPatrol:OnInitServer()
	VC.InitSeats(self, BoatPatrol);

	-- init common stuff for client and server
	VC.InitBoatCommon(self);

	self:OnReset();

	-- transmits it over network
--	self:NetPresent(1);
end

-- called on the server when the player collides with the boat
--////////////////////////////////////////////////////////////////////////////////////////
function BoatPatrol:OnContactServer( player )
	

end


--////////////////////////////////////////////////////////////////////////////////////////
function BoatPatrol:UpdateServer(dt)

	VC.UpdateEnteringLeaving( self, dt );
	VC.UpdateServerCommonT( self, dt );

	if(self.cnt.inwater==1) then
		self.fGroundtime = 0;
--System:Log( " -----  "..self.fGroundtime );		
	else	
--System:Log( " >>>>>  "..self.fGroundtime );		
		self.fGroundtime = self.fGroundtime + dt;
		if(self.fGroundtime > 5.5) then
			AI:Signal(0, 1, "ON_GROUND", self.id);			
		end	
	end	
end


--////////////////////////////////////////////////////////////////////////////////////////
function BoatPatrol:OnEventServer( id, params)
end


--////////////////////////////////////////////////////////////////////////////////////////
function BoatPatrol:OnDamageClient(hit)

	VC.OnDamageClient(self,hit);
	
end

--////////////////////////////////////////////////////////////////////////////////////////
function BoatPatrol:OnDamageServer(hit)

	VC.OnDamageServer(self,hit);	
end

--////////////////////////////////////////////////////////////////////////////////////////
function BoatPatrol:OnCollide(hit)
	VC.OnCollide(self,hit);	
end

--////////////////////////////////////////////////////////////////////////////////////////
function BoatPatrol:OnShutDown()

	VC.EveryoneOutForce(self);
	self.driver = 0;
end

--////////////////////////////////////////////////////////////////////////////////////////
function BoatPatrol:OnSave(stm)
end

--////////////////////////////////////////////////////////////////////////////////////////
function BoatPatrol:OnLoad(stm)
end


--////////////////////////////////////////////////////////////////////////////////////////
function BoatPatrol:OnWrite( stm )
	
end

--////////////////////////////////////////////////////////////////////////////////////////
function BoatPatrol:OnRead( stm )

end

--////////////////////////////////////////////////////////////////////////////////////////

----------------------------------------------------------------------------------------------------------------------------
--
--	to test-call reinf
function BoatPatrol:Event_Reinforcment( params )

printf( "signaling BRING_REINFORCMENT " );	

	AI:Signal(0, 1, "BRING_REINFORCMENT", self.id);
	
end	


----------------------------------------------------------------------------------------------------------------------------
--
-- to test
function BoatPatrol:Event_GoPath( params )
	self.curPathStep = self.Properties.pathstart-1;
	AI:Signal(0, 1, "GO_PATH", self.id);
end


----------------------------------------------------------------------------------------------------------------------------
--
function BoatPatrol:Event_GoAttack( params )

--System:Log("\001  Humvee GoPath  ");
	AI:Signal(0, 1, "GO_ATTACK", self.id);

end

----------------------------------------------------------------------------------------------------------------------------
--
-- to test
function BoatPatrol:Event_Load( params )

	self:LoadPeople();

end


----------------------------------------------------------------------------------------------------------------------------
--
-- to test
function BoatPatrol:Event_Release( params )


	self:UnloadPeople();

end


----------------------------------------------------------------------------------------------------------------------------
--
--
function BoatPatrol:RadioChatter()
end

----------------------------------------------------------------------------------------------------------------------------
--
--

----------------------------------------------------------------------------------------------------------------------------
--
-- 
function BoatPatrol:Event_KillTriger( params )

	if (self.driverT.entity and _localplayer) then 
		if (self.driverT.entity ~= _localplayer) then 
			self.fEngineHealth = 0;
		end
	else
		self.fEngineHealth = 0;
	end

end


----------------------------------------------------------------------------------------------------------------------------
--
--
function BoatPatrol:LoadPeople()

--	self:AIDriver( 1 );

System:Log("boatPatrol LoadPeople  ");

--	if(self.driver) then
--System:Log("boat LoadPeople  +++++ DRIVER IS IN ");
--		AI:Signal(0, 1, "DRIVER_IN", self.id);
--	end	
	
	AI:Signal(SIGNALFILTER_GROUPONLY, 1, "wakeup", self.id);
	AI:Signal(SIGNALFILTER_GROUPONLY, 1, "SHARED_ENTER_ME_VEHICLE", self.id);
	self.dropState = 1;
	
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function BoatPatrol:UnloadPeople()

	VC.DropPeople( self );
	
end


-------------------------------------------------------------------------------------------------------------
--
--
function BoatPatrol:AddDriver( puppet )
	AI:Signal(0, 1, "DRIVER_IN", self.id);
	return 0;
end

-------------------------------------------------------------------------------------------------------------
--
--
function BoatPatrol:AddGunner( puppet )
	return 0	-- no gunner for this boat
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function BoatPatrol:AddPassenger( player )

	local pasTbl = VC.CanAddPassenger( self, 1 );

	if( not pasTbl ) then	return 0 end	-- no more passangers can be added
	
	pasTbl.entity = puppet;
	if( VC.InitApproach( self, pasTbl )==0 ) then
		self.DoEnter( puppet );
	end
	do return 1 end	
end




----------------------------------------------------------------------------------------------------------------------------
--
--



