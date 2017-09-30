
-- Forklift
Forklift = {
--	type = "Vehicle",

	IsCar = 1,
	
	CanShoot = 1,	-- player can shoot from his veapon while driving this vehicle - 
			-- don't change action map to vehicle when entering
	

	IsPhisicalized = 0,
	
	-- [kirill] vehicle gets different damage depending on who's shooter
	-- defines the intensity of the damage caused by the weapons to
	-- the vehicle	
	
	--
	DamageParams = {
		fDmgScaleAIBullet = 0.0,
		fDmgScaleAIExplosion = 0.0,
		fDmgScaleBullet = 0.0,
		fDmgScaleExplosion = 0.0,
	},
	
--/////////////////////////////////////////////////////////////////////////
	-- damage stuff
	fileModelDead = "objects/Vehicles/forklift/forklift_wreck.cgf",
	fileModelPieces = "objects/Vehicles/forklift/forklift_pieces.cgf",

	-- particle system to display when the vehicle is damaged stage 1
	Damage1Effect = "smoke.vehicle_damage1.a",
	-- particle system to display when the vehicle is damaged stage 2
	Damage2Effect = "smoke.vehicle_damage2.a",
	-- particle system to display when the vehicle explodes
	ExplosionEffect = "explosions.4WD_explosion.a",
	-- particle system to display when the vehicle is destroyed
	DeadEffect = "fire.burning_after_explosion.a",
	-- material to be used when vehicle is destroyed
--/////////////////////////////////////////////////////////////////////////

	waterDepth = 1,	-- if water is deeper then this value - vehicle can't be used

	IdleTime = 0,
	FlipTime = 5,
	FlipTimeTotal = .3,
	FlipUpVel = 0,
	FlipXVel = 0,
	FlipYVel = 0,
	FlipH = 5,
--	FlipHCur = 0,
	FlipIdle = 2,
	FlipLimit = 65,
--	FlipLimit = 6,	
	FlipFlag = 0,

	userCounter = 0,
	driverWaiting = 1,
	driverDelay = 0,
	
	passengerLimit=0,

	-- if speed is over maximum - don't play exit animation
	MaxSpeed2Exit = 7,

	driverId = 0,

	
	driver = nil,

	-- previous state on the client before entering the vehicle
	bDriverInTheVehicle = 0,
	-- previous driver on the client before leaving the vehicle
	pPreviousDriver=nil,
	-- previous passenger state on the client before entering the vehicle
	bPassengerInTheVehicle = 0,
	-- previous passenger on the client before leaving the vehicle
	pPreviousPassenger=nil,

	--third person view mode before player entered jeep
	tpvStateD = 0,
	tpvStateP = 0,
	
	turretResetMode = 0,
	deltaZ = 0,
	deltaX = 0,
	curAngle = 0,
	aSpeedZ = 300,
	aSpeedX = 120,

	--used weapons
	dWeapon = 0,
	pWeapon = 0,
	gWeapon = 0,
	
	CameraTargetPoint = nil,
	
	-- A temporary storage vector used converting local positions to world positions
--	CurrentPosition = nil,
	
	--obsolete
--	CarDefDamage = 	{
--	  hull1 = { zoffset=-0.5	},
--		wheel1 = { driving=1,axle=0,len_max=0.23,stiffness=0,damping=-0.7, surface_id = 69, min_friction=1.8, max_friction=1.8 },
--		wheel2 = { driving=1,axle=0,len_max=0.23,stiffness=0,damping=-0.7, surface_id = 69, min_friction=1.8, max_friction=1.8 },
--		wheel3 = { driving=1,axle=1,len_max=0.23,stiffness=0,damping=-0.7, surface_id = 69, min_friction=1.8, max_friction=1.8 },
--		wheel4 = { driving=1,axle=1,len_max=0.23,stiffness=0,damping=-0.7, surface_id = 69, min_friction=1.8, max_friction=1.8 },		
--	},
--
--	CarDefNormal = 	{
--	  hull1 = { zoffset=-0.5	},
--		wheel1 = { driving=1,axle=0,len_max=0.23,stiffness=0,damping=-0.3, surface_id = 69, min_friction=1.8, max_friction=1.8 },
--		wheel2 = { driving=1,axle=0,len_max=0.23,stiffness=0,damping=-0.3, surface_id = 69, min_friction=1.8, max_friction=1.8 },
--		wheel3 = { driving=1,axle=1,len_max=0.23,stiffness=0,damping=-0.3, surface_id = 69, min_friction=1.8, max_friction=1.8 },
--		wheel4 = { driving=1,axle=1,len_max=0.23,stiffness=0,damping=-0.3, surface_id = 69, min_friction=1.8, max_friction=1.8 },		
--	},

	CarDef = {		
		file = "objects/Vehicles/forklift/forklift_driveable_crate.cgf", 
		
		engine_power = 90000, -- default 110000
		engine_power_back = 100,--70000, -- default 85000
		engine_maxrpm = 200, -- default 700
		axle_friction = 400, -- default 650
		max_steer = 100, -- default 22
		stabilizer = 1.0,
		
		engine_startRPM = 40,
		max_braking_friction = 1.25,
		engine_minRPM = 10,
		engine_idleRPM = 30,
		engine_shiftupRPM = 100,
		engine_shiftdownRPM = 40,
		clutch_speed = 2,
		gears = { -1,0,1 },

		pedal_speed = 0.75,--9
		
		---steering----
		------------------------------------------------
		steer_speed = 70,--(degree/s) steer speed at max velocity (the max speed is about 30 m/s)
		steer_speed_min = 70, --(degree/s) steer speed at min velocity
		
		steer_speed_scale = 1.0,--steering speed scale at top speed
		steer_speed_scale_min = 1.0,--steering speed scale at min speed
		--steer_speed_valScale = 1.0, 
		
		max_steer_v0 = 50.0, --max steer angle
		--max_steer_kv = 0.0,
		
		steer_relaxation_v0 = 720,--(degree/s) steer speed when return to forward direction.
		--steer_relaxation_kv = 15,--15,
		-----------------------------------------------
				
		dyn_friction_ratio = 1.0,
		gear_dir_switch_RPM = 20,
		slip_threshold = 0.05,
		brake_torque = 4000,
		
		cam_stifness_positive = { x=400,y=400,z=100 },
	  cam_stifness_negative = { x=400,y=400,z=100 },
	  cam_limits_positive = { x=0,y=0.5,z=0 },
	  cam_limits_negative = { x=0,y=0.3,z=0 },
	  cam_damping = 22,
	  cam_max_timestep = 0.01,
	  cam_snap_dist = 0.001,
	  cam_snap_vel = 0.01,
		
		brake_vel_threshold = 2, -- default 1000 if vehicle's velocity is below this, normal handbrake is used, otherwise increased axle_friction is 
	  brake_axle_friction = 3000, -- used to simulate braking default 5000
	  
	  max_time_step_vehicle = 0.02,
		sleep_speed_vehicle = 0.11,
		damping_vehicle = 0.11,
		
		-- rigid_body_params
		max_time_step = 0.01,
		damping = 0.1,
		sleep_speed = 0.04,
		freefall_damping = 0.03,
		gravityz = -9.81,
		freefall_gravityz = -9.81,

		water_density=30,
		
--		hull0 = { mass=1859,flags=0,zoffset=.41	}, -- default mass 1859
		hull1 = { mass=5559,flags=0,zoffset=-0.35,yoffset=0.0	}, -- default mass 2359
		hull2 = { mass=0,flags=1	},
		hull3 = { mass=0,flags=1	},
		
		wheel1 = { driving=1,axle=0,len_max=0.23,stiffness=0,damping=-0.3, surface_id = 69, min_friction=1.6, max_friction=1.7 },
		wheel2 = { driving=1,axle=0,len_max=0.23,stiffness=0,damping=-0.3, surface_id = 69, min_friction=1.6, max_friction=1.7 },
		wheel3 = { driving=1,axle=1,len_max=0.23,stiffness=0,damping=-0.3, surface_id = 69, min_friction=1.6, max_friction=1.7 },
		wheel4 = { driving=1,axle=1,len_max=0.23,stiffness=0,damping=-0.3, surface_id = 69, min_friction=1.6, max_friction=1.7 },
		
		wheel_num = 4,
	},


	bExploded=0,

	-- suspention
	-- table used to store some data for suspension sound processing for each wheel
	suspTable = {
		{
			helper = "wheel1_lower",
			suspWheel = 0,			--	last frame suspension compretion ratio
		},
		{
			helper = "wheel2_lower",
			suspWheel = 0,			--	last frame suspension compretion ratio
		},
		{
			helper = "wheel3_lower",
			suspWheel = 0,			--	last frame suspension compretion ratio
		},
		{
			helper = "wheel4_lower",
			suspWheel = 0,			--	last frame suspension compretion ratio
		},
	},
	suspSoundTable = {
		nil,
		nil,
		nil,
		nil,
	},
	-- suspension compresion threshold - when to start susp sound
	suspThreshold = .02,
	-- suspension over


--	delaytimer = 0,
--	counting = nil,
	part_time = 0,
	partDmg_time = 0,
	slip_speed = 0,
	particles_updatefreq = 0.1,--0.05, --initial frequency of updating wheel dust particles and 1st damage partcls

	PropertiesInstance = {
		sightrange = 180,
		soundrange = 10,	-- rememeber that sound ranges intersect and sound range for AI doubles when in alert
		aibehavior_behaviour = "Car_idle",		
		groupid = 154,
	},

	Properties = {	
	
		damage_scale = .1,
	
		bActive = 1,	-- if vehicle is initially active or needs to be activated 
				-- with Event_Activate first
		bTrackable=1,
		bDrawDriver = 0,
		fLimitLRAngles = 100,
		fLimitUDMinAngles = -30,
		fLimitUDMaxAngles = 20,
		object_Model="objects/Vehicles/forklift/forklift_driveable_crate.cgf", 
		
		ExplosionParams = {
			nDamage = 600,
			fRadiusMin = 8.0, -- default 12
			fRadiusMax = 35.5, -- default 70.5
			fRadius = 17, -- default 30
			fImpulsivePressure = 200, -- default 200
			},
			
		bUsable = 1,								-- if this vehicle can be used by _localplayer

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
		responsiveness = 7,
		species = 1,
		fSpeciesHostility = 2,
		fGroupHostility = 0,
		fPersistence = 0,
		aicharacter_character = "FWDVehicle",
		bApproachPlayer = 1,
		bodypos = 0,
		pathname = "drive",
		pathsteps = 0,
		pathstart = 0,
		bPathloop = 1,
		ReinforcePoint = "none",			
		fApproachDist = 20,
		
		bUsePathfind = 1,	-- pathfind when outdoors		
		
		hit_upward_vel = 6,
		damage_players = 1,
		forward_speed = 1,
		
		--filippo: This table is used (if exist) into "VC:AddUserT" , if the driver is an AI we merge this table with the CarDef.
		AICarDef = {
			bAI_use = 1,
			
			steer_speed = 70.0,
			steer_speed_min = 70.0,
			max_steer_v0 = 50,
			steer_relaxation_v0 = 720,
			
			dyn_friction_ratio = 1.0,
			max_braking_friction = 1.25,
						
			damping_vehicle = 0.03,
		},		
	},

	-- engine health, status of the vehicle
	-- default is set to maximum (1.0f)
	fEngineHealth = 100.0,

	-- damage inflicted to the vehicle when it collides
	fOnCollideDamage=0,
	-- damage inflicted to the vehicle when it collides with terrain (falls off)
	fOnCollideGroundDamage=0,
	
	--damage when colliding with another vehicle, this value is multiplied by the hit.impact value.
	fOnCollideVehicleDamage=0,


	bGroundVehicle=1,

	driverT = {
		type = PVS_DRIVER,
	
		helper = "driver",	-- to bind to
		in_helper = "driver_sit_pos",
		in_anim =  "forklift_driver_in",
		out_anim = "forklift_driver_out",
		sit_anim = "forklift_driver_sit",
		anchor = AIAnchor.z_CARENTER_DRIVER,
		out_ang = -90,
		message = "@driverforklift",
		
		animations = {
			"forklift_driver_sit",		-- idle in animation
			"forklift_driver_moving",		-- driving firward
			"forklift_driver_forward_hit",	-- impact / break
			"forklift_driver_leftturn",	-- turning left
			"forklift_driver_rightturn",	-- turning right
			"forklift_driver_reverse",		-- reversing
			"forklift_driver_reverse_hit",	-- reversing impact / break
		},
	},
}

VC.CreateVehicle(Forklift);

--////////////////////////////////////////////////////////////////////////////////////////
function Forklift:OnReset()

	VC.OnResetCommon(self);
	self:NetPresent(1);
	VC.EveryoneOutForce(self);
	self.fEngineHealth = 100.0;
	self.bExploded=0;
	self.cnt:SetVehicleEngineHealth(self.fEngineHealth);
	
	AI:RegisterWithAI(self.id, AIOBJECT_CAR,self.Properties,self.PropertiesInstance);
	VC.InitAnchors( self );	
	VC.AIDriver( self, 0 );	

	self.step = self.Properties.pathstart - 1;
	
end


--////////////////////////////////////////////////////////////////////////////////////////
function Forklift:InitPhis()

	VC.InitGroundVehiclePhysics(self,self.Properties.object_Model);
end	

--////////////////////////////////////////////////////////////////////////////////////////
function Forklift:InitClient()
	VC.InitSeats(self, Forklift);

	--/////////////////////////////////////////////////////////////////////////
	-- local sounds for the client

	self.drive_sound = Sound:Load3DSound("sounds\\vehicle\\buggy\\aidle_loop.wav",0,200,7,100000);
	
	self.drive_sound_move = Sound:Load3DSound("sounds\\vehicle\\tire_rocks.wav",0,200,7,100000);
	self.maxvolume_speed = 10;
	
	self.drive_sound_move_water = Sound:Load3DSound("sounds\\vehicle\\boat\\splashLP.wav",0,0,13,300);
	self.maxvolume_speed_water = 5;
	
	self.accelerate_sound = {
		Sound:Load3DSound("sounds\\vehicle\\rev.wav",0,0,7,100000),
		Sound:Load3DSound("sounds\\vehicle\\rev.wav",0,0,7,100000),
		Sound:Load3DSound("sounds\\vehicle\\rev.wav",0,0,7,100000),
		Sound:Load3DSound("sounds\\vehicle\\rev.wav",0,0,7,100000),
	};

	self.suspSoundTable[1] = Sound:Load3DSound("sounds\\vehicle\\comp1.wav",0,150,7,100000);
	self.suspSoundTable[2] = Sound:Load3DSound("sounds\\vehicle\\comp2.wav",0,150,7,100000);	
	self.suspSoundTable[3] = Sound:Load3DSound("sounds\\vehicle\\comp3.wav",0,150,7,100000);	
	self.suspSoundTable[4] = Sound:Load3DSound("sounds\\vehicle\\comp4.wav",0,150,7,100000);	

	self.break_sound = Sound:Load3DSound("sounds\\vehicle\\break1.wav",0,100,7,100000);
	self.engine_start = Sound:Load3DSound("sounds\\vehicle\\buggy\\abuggy_start.wav",0,200,7,100000);
	self.engine_off = Sound:Load3DSound("sounds\\vehicle\\buggy\\abuggy_off.wav",0,120,7,100000);
	self.sliding_sound = Sound:Load3DSound("sounds\\vehicle\\break2.wav",0,150,7,100000);

	self.compression_sound1 = Sound:Load3DSound("sounds\\vehicle\\comp1.wav",0,0,7,100000);
	self.compression_sound2 = Sound:Load3DSound("sounds\\vehicle\\comp2.wav",0,0,7,100000);
	self.compression_sound3 = Sound:Load3DSound("sounds\\vehicle\\comp3.wav",0,0,7,100000);
	self.compression_sound4 = Sound:Load3DSound("sounds\\vehicle\\comp4.wav",0,0,7,100000);
	self.ExplosionSound=Sound:Load3DSound("sounds\\explosions\\explosion2.wav",0,255,150,1000);

--	self.buggy_sound = Sound:Load3DSound("sounds\\vehicle\\buggy.wav",0,200,7,100000);

	self.crash_sound = Sound:Load3DSound("sounds\\vehicle\\carcrash.wav",0,200,7,100000);

	VC.InitGroundVehicleClient(self, self.Properties.object_Model);
	
	self.cnt:InitLights( "","",
			"","","",
			"back_light_left", "back_light_right","humvee_backlight" );
	
end

--////////////////////////////////////////////////////////////////////////////////////////
function Forklift:InitServer()
	VC.InitSeats(self, Forklift);

	VC.InitGroundVehicleServer(self, self.Properties.object_Model);
	
	self:OnReset();
end

--////////////////////////////////////////////////////////////////////////////////////////
function Forklift:OnContactServer( player )

	if( self.Properties.bUsable==0 ) then return end
	if( VC.IsUnderWater( self ) == 1 ) then return end

	-- DON't need this "noEnter" anymore
	-- for forklift - din't enter but jump if not really close to it
--	local dist = player:GetDistanceFromPoint( self:GetPos() );
--	local dist = player:GetDistanceFromPoint( self:GetHelperPos("driver_sit_pos", 0) );		
--System:Log( "\001 COntact dist "..dist );
	
--	if( dist > 1.5 ) then return end
	
	VC.OnContactServerT(self,player);
end

--////////////////////////////////////////////////////////////////////////////////////////
function Forklift:OnContactClient( player )

	if( self.Properties.bUsable==0 ) then return end
	if( VC.IsUnderWater( self ) == 1 ) then return end

	-- DON't need this "noEnter" anymore	
	-- for forklift - din't enter but jump if not really close to it
--	local dist = player:GetDistanceFromPoint( self:GetPos() );
--	local dist = player:GetDistanceFromPoint( self:GetHelperPos("driver_sit_pos", 0) );	
--	if( dist > 1.5 ) then return end
	
	VC.OnContactClientT(self,player);
end



-------------------------------------------------------------------------------------------------------------
--
--

-------------------------------------------------------------------------------------------------------------
--
--
function Forklift:UpdateServer(dt)

	VC.UpdateEnteringLeaving( self, dt );
	VC.UpdateServerCommonT(self,dt);
	
	VC.UpdateWheelFriction( self );
	
	if( VC.IsUnderWater( self, dt ) == 1 ) then 
		VC.EveryoneOutForce( self );
	end;

end



----------------------------------------------------------------------------------------------------------------------------
--
--
function Forklift:OnShutDown()

	--assingning to nil is not really needed
	--if the entity will be destroyed
	VC.EveryoneOutForce( self );	
	self.break_sound=nil;
	self.engine_start=nil;
	self.engine_off=nil;
	self.sliding_sound=nil;
	self.drive_sound=nil;
	self.drive_sound_move=nil;	
	self.accelerate_sound=nil;

end

----------------------------------------------------------------------------------------------------------------------------
--
--
function Forklift:OnSave(stm)
	stm:WriteInt(self.step);
	stm:WriteInt(self.fEngineHealth);
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function Forklift:OnLoad(stm)
	self.step = stm:ReadInt();
	self.fEngineHealth = stm:ReadInt();
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function Forklift:OnEventServer( id, params)


--	if (id == ScriptEvent_Reset)
--	then
--		VC.EveryoneOutForce( self );	
--	end
end


----------------------------------------------------------------------------------------------------------------------------
--
--

----------------------------------------------------------------------------------------------------------------------------
--
--

function Forklift:OnWrite( stm )
	stm:WriteInt(0);
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function Forklift:OnRead( stm )
	local	id=0;	
	stm:ReadInt(); -- dummy read to make sure it stais compatible with old version	
end

----------------------------------------------------------------------------------------------------------------------------
--
--


--////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////
--// CLIENT functions definitions
--////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////

Forklift.Client = {
	OnInit = function(self)
		self:InitClient();
	end,
	OnShutDown = function(self)
		self:OnShutDown();
	end,
	Alive = {
		OnBeginState = function( self )	
			VC.InitGroundVehicleCommon(self,self.Properties.object_Model);
		end,
		OnContact = function(self,player)
	 		self:OnContactClient(player);
		end,
		OnUpdate = VC.UpdateClientAlive,
		OnCollide = VC.OnCollideClient,
		OnBind = VC.OnBind,
		OnUnBind = VC.OnUnBind,
	},
	Inactive = {
		OnBeginState = function( self )
			self:Hide(1);
		end,
		OnEndState = function( self )
			self.IsPhisicalized = 0;
		end,
	},
	Dead = {
		OnBeginState = function( self )
			VC.BlowUpClient(self);
		end,
		OnContact = function(self,player)
	 		VC.OnContactClientDead(self,player);
		end,
		OnUpdate = VC.UpdateClientDead,
		OnCollide = VC.OnCollideClient,
		OnUnBind = VC.OnUnBind,
	},
}


--////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////
--// SERVER functions definitions
--////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////

Forklift.Server = {
	OnInit = function(self)
		self:InitServer();
	end,
	OnEvent = function (self, id, params)
		self:OnEventServer( id, params);
	end,
	OnShutDown = function(self)
		self:OnShutDown();
	end,
	Alive = {
		OnBeginState = function( self )	
			VC.InitGroundVehicleCommon(self,self.Properties.object_Model);
		end,
		OnContact = function(self,player)
	 		self:OnContactServer(player);
		end,
		OnDamage = VC.OnDamageServer,
		OnCollide = VC.OnCollideServer,
		OnUpdate = function(self,dt)
			self:UpdateServer(dt);
		end,
		
	},
	Inactive = {
	},
	Dead = {
		OnBeginState = function( self )
			VC.BlowUpServer(self);
		end,
	},
}


-------------------------------------------------------------------------------------------------------------
--
--

-------------------------------------------------------------------------------------------------------------
--
--
function Forklift:DoEnter( puppet )
--System:Log("DoEnter     >>> ");

	if( puppet == self.driverT.entity ) then		
--		local puppet = self.driver;		
		VC.AddUserT( self, self.driverT );
		VC.InitEntering( self, self.driverT );
	end
end

-------------------------------------------------------------------------------------------------------------
--
--
function Forklift:AddDriver( puppet )

	--System:Log("\001 Forklift:AddDriver ");
--do return 0 end
	if (self.driverT.entity ~= nil)		then	-- already have a driver
		do return 0 end
	end

	--System:Log("\001 Forklift:AddDriver 2");

	self.driverT.entity = puppet;
	if( VC.InitApproach( self, self.driverT )==0 ) then	
		
	--System:Log("\001 Forklift:AddDriver 3");		
		self:DoEnter( puppet );
	end	
	do return 1 end	
end

-------------------------------------------------------------------------------------------------------------
--
--
function Forklift:AddGunner( puppet )
	return 0;
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function Forklift:AddPassenger( puppet )

	local pasTbl = VC.CanAddPassenger( self, 1 );

	if( not pasTbl ) then	return 0 end	-- no more passangers can be added
	
	pasTbl.entity = puppet;
	if( VC.InitApproach( self, pasTbl )==0 ) then
		self:DoEnter( puppet );
	end
	do return 1 end	
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function Forklift:LoadPeople()

--System:Log("Forklift LoadPeople  ");

	if(self.driverT.entity and self.driverT.entity.ai) then
		AI:Signal(0, 1, "DRIVER_IN", self.id);
	end	
	
	AI:Signal(SIGNALFILTER_GROUPONLY, 1, "wakeup", self.id);
	AI:Signal(SIGNALFILTER_GROUPONLY, 1, "SHARED_ENTER_ME_VEHICLE", self.id);
	self.dropState = 1;

end


----------------------------------------------------------------------------------------------------------------------------
--
--	to test-call reinf
function Forklift:Event_Reinforcment( params )

--printf( "signaling BRING_REINFORCMENT " );	

	AI:Signal(0, 1, "BRING_REINFORCMENT", self.id);
	
end	


----------------------------------------------------------------------------------------------------------------------------
--
function Forklift:Event_GoPath( params )
	if(VC.FreeToUse( self )==0) then return end	-- can't use it - player is in

	VC.AIDriver( self, 1 );	
	AI:Signal(0, 1, "GO_PATH", self.id);

end

----------------------------------------------------------------------------------------------------------------------------
--
function Forklift:Event_GoPatrol( params )

--System:Log("\001  Humvee GoPath  ");

	AI:Signal(0, 1, "GO_PATROL", self.id);

end


----------------------------------------------------------------------------------------------------------------------------
--
function Forklift:Event_GoChase( params )

--System:Log("\001  Humvee GoPath  ");

	AI:Signal(0, 1, "GO_CHASE", self.id);

end

----------------------------------------------------------------------------------------------------------------------------
--
-- 
function Forklift:Event_KillTriger( params )

	self.fEngineHealth = 0;

end


-----------------------------------------------------------------------------------------------------
--
--
function Forklift:Event_Activate( params )

	if(self.bExploded == 1) then return end
	
	self:GotoState( "Alive" );
end

----------------------------------------------------------------------------------------------------------------------------
--
function Forklift:Event_PausePath( params )

--System:Log("\001  Humvee PausePath  ");

--	AI:Signal( 0, 1, "EVERYONE_OUT",self.id);
	AI:Signal( 0, 1, "DRIVER_OUT",	self.id);
--	self.cnt:HandBreak(1);

end


----------------------------------------------------------------------------------------------------------------------------
--
--
function Forklift:DropPeople()

	VC.DropPeople( self );

end


----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
--
--

--------------------------------------------------------------------------------------------------------
-- empty function to get reed of script error - it's called from behavours
function Forklift:MakeAlerted()
end


----------------------------------------------------------------------------------------------------------------------------
--
--this is called from vehicleProxy when all the saving is done
function Forklift:OnSaveOverall(stm)

	VC.SaveCommon( self, stm );
	
end

----------------------------------------------------------------------------------------------------------------------------
--
--this is called from vehicleProxy when all the loading is done and all the entities are spawn
function Forklift:OnLoadOverall(stm)

	VC.LoadCommon( self, stm );
	
	
--System:Log( " Forklift:OnLoadOverall  "..self.userCounter.."  >> "..self.driverWaiting);
	
	if(self.userCounter == 0) then
		if(self.Behaviour.Name == "Car_path") then
			AI:Signal(0, 1, "DRIVER_IN", self.id);
		end
	end
	
end

--------------------------------------------------------------------------------------------------------------
