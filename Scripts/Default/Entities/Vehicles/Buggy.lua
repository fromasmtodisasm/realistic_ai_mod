
-- quad buggy
Buggy = {
--	type = "Vehicle",

	IsCar = 1,
	IsPhisicalized = 0,

	ammoMG = 500,
--	ammoRL = 30,


	-- [kirill] vehicle gets different damage depending on who's shooter
	-- defines the intensity of the damage caused by the weapons to the vehicle
	
	--
	DamageParams = {
		fDmgScaleAIBullet = 0.09,
		fDmgScaleAIExplosion = 0.1,
		fDmgScaleBullet = 0.15,
		fDmgScaleExplosion = 0.25,--patch2:vehicles must explode with 1 missile --before was 0.12,  
		
		dmgBulletMP = 0.5,--if this value exist in multiplayer will be used this damage for every bullet , 1.0
				  --so for instance, no difference between a sniper rifle and a desert eagle.
				  --Vehicles have 100 points of health.
				  --in this case 100 bullets are needed to destroy the vehicle. 
				  --now changed to 50...Doc
	},

	ExplosionParams = {
		nDamage = 900,
	},

	--model to be used for destroyed vehicle
	fileModelDead = "objects/Vehicles/Buggy/Buggy_wreck.cgf",
	fileModelPieces = "objects/Vehicles/Buggy/Buggy_pieces.cgf",	
--	fileGunModel = "Objects/Vehicles/Mounted_gun/m2.cga",
	fileGunModel = "Objects/Vehicles/Mounted_gun/mounted_gun_buggy.cga",
	

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
	
	passengerLimit=1,

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

	szNormalModel="objects/Vehicles/buggy/buggy.cgf", 

	CarDef = {		
		--file = "objects/Vehicles/buggy/buggy.cgf", 		
		
		engine_power = 200000, -- default 110000
		engine_power_back = 200000, -- default 85000
		engine_maxrpm = 2700, -- default 700
		axle_friction = 300, -- default 650
		max_steer = 22, -- default 20
		stabilizer = 0.0,
		
		engine_startRPM = 400,
		
		dyn_friction_ratio = 1.0,
		
		max_braking_friction = 0.4,
		handbraking_value = 10, -- meters / sec
		
		max_braking_friction_nodriver = 1.0, --this friction is applied when there is no driver inside the car
		handbraking_value_nodriver = 3,-- (meter/s / s) , same as above, this value is applied only when the car have no driver
		
		stabilize_jump = 1500,--this set how much to correct the car angles while it is in air.

		engine_minRPM = 10,
		engine_idleRPM = 80,
		engine_shiftupRPM = 1600,
		engine_shiftdownRPM = 350,
		clutch_speed = 2,
		--gears = { -3,0,3,2,1.1,0.7 },
		--gears = { -7,0,6,4.5,3.75,2.5 },
		gears = { -7,0,5,3.9,2.5 },
		
		integration_type = 1,
		
		gear_dir_switch_RPM = 1500,
		slip_threshold = 0.05,
		brake_torque = 40000,

		cam_stifness_positive = { x=400,y=400,z=100 },
	  cam_stifness_negative = { x=400,y=400,z=100 },
	  cam_limits_positive = { x=0,y=0.5,z=0 },
	  cam_limits_negative = { x=0,y=0.3,z=0 },
	  cam_damping = 22,
	  cam_max_timestep = 0.01,
	  cam_snap_dist = 0.001,
	  cam_snap_vel = 0.01,

		pedal_speed = 4.6,
		
		---steering----
		------------------------------------------------
		steer_speed = 12,--(degree/s) steer speed at max velocity (the max speed is about 30 m/s)
		steer_speed_min = 120, --(degree/s) steer speed at min velocity
		
		steer_speed_scale = 1.0,--steering speed scale at top speed
		steer_speed_scale_min = 2.0,--steering speed scale at min speed
		--steer_speed_valScale = 1.0, 
		
		max_steer_v0 = 37.0, --max steer angle
		--max_steer_kv = 0.0,
		
		steer_relaxation_v0 = 720,--(degree/s) steer speed when return to forward direction.
		--steer_relaxation_kv = 15,--15,
		-----------------------------------------------
		
		--brake_vel_threshold = 1000, -- default 1000 if vehicle's velocity is below this, normal handbrake is used, otherwise increased axle_friction is 
	  	--brake_axle_friction = 3000, -- used to simulate braking default 5000
	  
	  max_time_step_vehicle = 0.02,
		sleep_speed_vehicle = 0.11,
		damping_vehicle = 0.11,
		
		-- rigid_body_params
		max_time_step = 0.01,
		damping = 0.1,
		sleep_speed = 0.04,
		freefall_damping = 0.03,
		gravityz = -12.81, -- -10.81
		freefall_gravityz = -12.81, -- -10.81

		water_density=30,
		
--		hull0 = { mass=1859,flags=0,zoffset=.41	}, -- default mass 1859
		--hull1 = { mass=1859,flags=0,zoffset=-0.5,yoffset=.0	}, -- default mass 2359
		--hull1 = { mass=1000,flags=0,zoffset=-0.5,yoffset=-0.7	}, -- default mass 2359
		hull1 = { mass=3500,flags=0,zoffset=-0.35,yoffset=-0.35	}, --mass:1000 -- default mass 2359
		hull2 = { mass=0,flags=1	},
		hull3 = { mass=0,flags=1	},
		
		wheel1 = { driving=1,axle=0,can_brake=1,len_max=0.40,stiffness=0,damping=-0.4, surface_id = 69, min_friction=1.0, max_friction=1.5 },
		wheel2 = { driving=1,axle=0,can_brake=1,len_max=0.40,stiffness=0,damping=-0.4, surface_id = 69, min_friction=1.0, max_friction=1.5 },
		wheel3 = { driving=1,axle=1,can_brake=1,len_max=0.43,stiffness=0,damping=-0.5, surface_id = 69, min_friction=1.05, max_friction=1.55 },
		wheel4 = { driving=1,axle=1,can_brake=1,len_max=0.43,stiffness=0,damping=-0.5, surface_id = 69, min_friction=1.05, max_friction=1.55 },
		
		wheel_num = 4,
	},
		
	tmp = 0,


--/////////////////////////////////////////////////////////////////////////
-- damage stuff
	-- particle system to display when the vehicle is damaged stage 1
	Damage1Effect = "smoke.vehicle_damage1.a",
	-- particle system to display when the vehicle is damaged stage 2
	Damage2Effect = "smoke.vehicle_damage2.a",
	-- particle system to display when the vehicle explodes
	ExplosionEffect = "explosions.4WD_explosion.a",
	-- particle system to display when the vehicle is destroyed
	DeadEffect = "fire.burning_after_explosion.a",
	-- material to be used when vehicle is destroyed
	DeadMaterial = "Vehicles.Buggy_Screwed",


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
		
		bActive = 1,	-- if vehicle is initially active or needs to be activated 
				-- with Event_Activate first
		bLightsOn = 0,

		bSetInvestigate = 0,		-- when releasing people - make them to go to Job_Investigate
		bTrackable=1,
		bDrawDriver = 0,
		fLimitLRAngles = 100,
		fLimitUDMinAngles = -30,
		fLimitUDMaxAngles = 20,
		fStartDelay = 2,
		
		ExplosionParams = {
			nDamage = 800,
			fRadiusMin = 8.0, -- default 8
			fRadiusMax = 10, -- default 35.5
			fRadius = 10, -- default 30
			fImpulsivePressure = 600, -- default 200
			},
			
		bUsable = 1,								-- if this vehicle can be used by _localplayer
		
		bSameGroupId = 1,

-- those are AI related properties
		pointReinforce = "Drop",
		pointBackOff = "Base",
		aggression = 1.0,
		commrange = 100.0,
		cohesion = 5,
		attackrange = 70,
		horizontal_fov = 160,
		vertical_fov =90,
		forward_speed = 1,
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
		
		--filippo: This table is used (if exist) into "VC:AddUserT" , if the driver is an AI we merge this table with the CarDef.
		AICarDef = {
			bAI_use = 1,
			
			steer_speed = 12.0,--60
			steer_speed_min = 120.0,--60
			max_steer_v0 = 30,
			steer_relaxation_v0 = 720,
			
			dyn_friction_ratio = 1.0,
			max_braking_friction = 0.3,
			handbraking_value = 9,
			
			damping_vehicle = 0.03,
		},	
	},

	-- engine health, status of the vehicle
	-- default is set to maximum (1.0f)
	fEngineHealth = 100.0,

	-- damage inflicted to the vehicle when it collides
	fOnCollideDamage=0,
	-- damage inflicted to the vehicle when it collides with terrain (falls off)
	fOnCollideGroundDamage=0.75,
	
	--damage inflicted when falling , this value is multiplied by the half of the square of the falling speed:
	--for istance: 5 m/s = 12 dmgpoints * fOnFallDamage
	--	      10 m/s = 50 dmgpoints * fOnFallDamage
	--	      20 m/s = 200 dmgpoints * fOnFallDamage
	fOnFallDamage=0.125,
	
	--damage when colliding with another vehicle, this value is multiplied by the hit.impact value.
	fOnCollideVehicleDamage=1,

	bGroundVehicle=1,
		
-- user's types
--	1 - driver
--	2 - gunner
--	3 - passenger
	driverT = {
		type = PVS_DRIVER,
	
		helper = "driver",	-- to bind to
		in_helper = "driver_sit_pos",--"driver",
		in_anim = "buggy_driver_in",
		out_anim = "buggy_driver_out",
		sit_anim = "buggy_driver_sit",
		anchor = AIAnchor.z_CARENTER_DRIVER,
		out_ang = -90,
		message = "@driverbuggy",
		-- invehicle animations 
		animations = {
			"buggy_driver_sit",		-- idle in animation
			"buggy_driver_moving",		-- driving firward
			"buggy_driver_forward_hit",	-- impact / break
			"buggy_driver_leftturn",	-- turning left
			"buggy_driver_rightturn",	-- turning right
			"buggy_driver_reverse",		-- reversing
			"buggy_driver_reverse_hit",	-- reversing impact / break
		},
	},

	passengersTT = {
		{
			type = PVS_PASSENGER,
		
			helper = "passenger",
			in_helper = "passenger_sit_pos",--"passenger",
			in_anim = "buggy_passenger_in",
			out_anim = "buggy_passenger_out",
			sit_anim = "buggy_passenger_sit",
			anchor = AIAnchor.z_CARENTER_PASSENGER1,
			out_ang = 90,
			message = "@passengerbuggy",
			-- invehicle animations 
			animations = {
				"buggy_passenger_sit",		-- idle in animation
				"buggy_passenger_moving",	-- driving firward
				"buggy_passenger_forward_hit",	-- impact / break
				"buggy_passenger_leftturn",	-- turning left
				"buggy_passenger_rightturn",	-- turning right
				"buggy_passenger_reverse",	-- reversing
				"buggy_passenger_reverse_hit",	-- reversing impact / break
			},
		},
	},
}

VC.CreateVehicle(Buggy);

--////////////////////////////////////////////////////////////////////////////////////////
function Buggy:OnReset()

--	if(self.bExploded == 1) then
--		VC.InitGroundVehicleServer(self,self.szNormalModel);
--	end	

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
function Buggy:InitPhis()
	VC.InitGroundVehiclePhysics(self,self.szNormalModel);
end	

--////////////////////////////////////////////////////////////////////////////////////////
function Buggy:InitClient()
	VC.InitSeats(self, Buggy);

	--/////////////////////////////////////////////////////////////////////////
	-- local sounds for the client

	self.sndVel1 = 5;
	self.sndVel2 = 10;
		
--	self.drive_sound = Sound:Load3DSound("sounds\\vehicle\\buggy\\idle_loop.wav",0,100,7,200);
	self.drive_sound_move = Sound:Load3DSound("sounds\\vehicle\\tire_rocks.wav",0,200,13,300);
	self.maxvolume_speed = 35;
	
	self.drive_sound_move_water = Sound:Load3DSound("sounds\\vehicle\\boat\\splashLP.wav",0,0,13,300);
	self.maxvolume_speed_water = 10;
	
--	self.accelerate_sound = {
--		Sound:Load3DSound("sounds\\vehicle\\rev.wav",0,0,7,100),
--		Sound:Load3DSound("sounds\\vehicle\\rev.wav",0,0,7,100),
--		Sound:Load3DSound("sounds\\vehicle\\rev.wav",0,0,7,100),
--		Sound:Load3DSound("sounds\\vehicle\\rev.wav",0,0,7,100),
--	};

	self.break_sound = Sound:Load3DSound("sounds\\vehicle\\break1.wav",0,100,7,200);
	self.engine_start = Sound:Load3DSound("sounds\\vehicle\\little_buggy\\start.wav",0,255,13,300);
	self.engine_off = Sound:Load3DSound("sounds\\vehicle\\little_buggy\\off.wav",0,255,13,300);
	self.sliding_sound = Sound:Load3DSound("sounds\\vehicle\\break2.wav",0,150,13,300);

	-------------------------------------------------------------------------------------
	-- [marco] new sounds
--	self.gearup_sounds= {	
--		Sound:Load3DSound("sounds\\vehicle\\little_buggy\\accl1.wav",0,255,7,200), -- reverse up (0-1)		
--		Sound:Load3DSound("sounds\\vehicle\\little_buggy\\accl1.wav",0,255,7,200), -- (1-2)
--		Sound:Load3DSound("sounds\\vehicle\\little_buggy\\accl2.wav",0,255,7,200), -- (2-3)
--		
--	};
--
--	self.geardn_sounds={		
--		Sound:Load3DSound("sounds\\vehicle\\vehicle_efx\\reverse.wav",0,255,7,200), -- reverse down (1-0)
--		Sound:Load3DSound("sounds\\vehicle\\little_buggy\\decell1.wav",0,255,7,200), -- (2-1)
--		Sound:Load3DSound("sounds\\vehicle\\little_buggy\\decell1.wav",0,255,7,200), -- (3-2)
--		
--	};
--
--	self.idle_sounds={				
--		Sound:Load3DSound("sounds\\vehicle\\HV\\testbuggy\\idle.wav",0,255,7,200), -- reverse idle (0)
--		Sound:Load3DSound("sounds\\vehicle\\HV\\testbuggy\\idle.wav",0,255,7,200), -- engine idle (1)
--		Sound:Load3DSound("SOUNDS\\Vehicle\\HV\\testbuggy\\hi_idle.wav",0,255,7,200), -- (2)
--		Sound:Load3DSound("SOUNDS\\Vehicle\\HV\\testbuggy\\hi_idle.wav",0,255,7,200), -- (3)			
--	};

	self.clutch_sound = Sound:Load3DSound("sounds\\vehicle\\vehicle_efx\\gearchange.wav",0,200,13,300);
	self.land_sound = Sound:Load3DSound("sounds\\vehicle\\vehicle_efx\\carclunk.wav",0,255,13,300);
	--self.jump_sound = Sound:Load3DSound("sounds\\vehicle\\little_buggy\\airrev.wav",0,200,7,200);
	
	--first param is the sound, the second means if this sound must be looped or not (1=loop,0=once)
--	self.idlesounds={
--		{-- reverse idle (0)
--			{Sound:Load3DSound("sounds\\vehicle\\little_buggy\\idle2.wav",0,255,7,200),1},
--		},
--		{-- engine idle (1)
--			{Sound:Load3DSound("sounds\\vehicle\\little_buggy\\idle.wav",0,255,7,200),1},
--		},
--		{-- (2)
--			{Sound:Load3DSound("sounds\\vehicle\\little_buggy\\decell1.wav",0,255,7,200),0},
--			{Sound:Load3DSound("sounds\\vehicle\\little_buggy\\idle2.wav",0,255,7,200),1},
--		},
--		{-- (3)
--			{Sound:Load3DSound("sounds\\vehicle\\little_buggy\\hi_idle.wav",0,255,7,200),1},
--		},
--	};
	
	self.idleengine = Sound:Load3DSound("sounds\\vehicle\\little_buggy\\idle2.wav",0,255,13,300);
	self.idleengine_ratios = {0.9,0.9,1.1,0.9};
	self.clutchengine_frequencies = {1000,900,500,700};
	self.clutchfreqspeed = 13;
	self.enginefreqspeed = 3
		
	--self.nogroundcontact_sound=Sound:Load3DSound("sounds\\vehicle\\HV\\testbuggy\\accl1.wav",0,255,7,200);
		
	-------------------------------------------------------------------------------------

--	self.compression_sound1 = Sound:Load3DSound("sounds\\vehicle\\comp1.wav",0,150,7,100);
--	self.compression_sound2 = Sound:Load3DSound("sounds\\vehicle\\comp2.wav",0,150,7,100);
--	self.compression_sound3 = Sound:Load3DSound("sounds\\vehicle\\comp3.wav",0,150,7,100);
--	self.compression_sound4 = Sound:Load3DSound("sounds\\vehicle\\comp4.wav",0,150,7,100);
	
	self.suspSoundTable[1] = Sound:Load3DSound("sounds\\vehicle\\comp1.wav",0,150,7,100000);
	self.suspSoundTable[2] = Sound:Load3DSound("sounds\\vehicle\\comp2.wav",0,150,7,100000);	
	self.suspSoundTable[3] = Sound:Load3DSound("sounds\\vehicle\\comp3.wav",0,150,7,100000);	
	self.suspSoundTable[4] = Sound:Load3DSound("sounds\\vehicle\\comp4.wav",0,150,7,100000);	
	
	
	self.ExplosionSound=Sound:Load3DSound("sounds\\explosions\\explosion2.wav",0,255,150,500);

--	self.buggy_sound = Sound:Load3DSound("sounds\\vehicle\\buggy.wav",0,200,7,100);

	self.crash_sound = Sound:Load3DSound("sounds\\vehicle\\carcrash.wav",0,200,13,300);
	
	self.light_sound = Sound:Load3DSound("SOUNDS/items/flight.wav",SOUND_UNSCALABLE,160,3,30);

	VC.InitGroundVehicleClient(self,self.szNormalModel);

	self.cnt:InitLights( "front_light","textures/lights/front_light",
			"front_light_left","front_light_right","humvee_frontlight",
			"back_light_left", "back_light_right","humvee_backlight" );
			
	self:InitWeapon();
end

--////////////////////////////////////////////////////////////////////////////////////////
function Buggy:InitServer()
	VC.InitSeats(self, Buggy);

	VC.InitGroundVehicleServer(self,self.szNormalModel);

	self:OnReset();
	self:InitWeapon();
end

--////////////////////////////////////////////////////////////////////////////////////////
function Buggy:OnContactServer( player )

	if( self.Properties.bUsable==0 ) then return end
	if( VC.IsUnderWater( self ) == 1 ) then return end
	VC.OnContactServerT(self,player);
end

--////////////////////////////////////////////////////////////////////////////////////////
function Buggy:OnContactClient( player )

	if( self.Properties.bUsable==0 ) then return end
	if( VC.IsUnderWater( self ) == 1 ) then return end
	VC.OnContactClientT(self,player);
end


-------------------------------------------------------------------------------------------------------------
--
--
function Buggy:InitFlip( )

	local	curAngle = self:GetAngles();

	self.IdleTime = 0;
	self.FlipFlag = 1;
	self.FlipTime = 0;
	self.FlipUpVel = self.FlipH/self.FlipTimeTotal;
--		local	curPos = self.GetPos();
--		self.FlipHCur = curPos.z;
	self.FlipXVel = curAngle.x/self.FlipTimeTotal;
	self.FlipYVel = curAngle.y/self.FlipTimeTotal;
end

-------------------------------------------------------------------------------------------------------------
--
--
function Buggy:ProceedFlip( dt )

local	curAngle = self:GetAngles();
	self.FlipTime = self.FlipTime + dt;

	if( self.FlipTime<self.FlipTimeTotal ) then
--System:LogToConsole("flip "..self.FlipTime.." ");
		local	curPos = self:GetPos();
		curPos.z = curPos.z + dt*self.FlipUpVel;
		self.SetPos(curPos);
		curAngle.x = curAngle.x - dt*self.FlipXVel;
		curAngle.y = curAngle.y - dt*self.FlipYVel;
		self:SetAngles(curAngle);
	elseif( self.FlipFlag==1 ) then
		self.FlipFlag = 0;
--System:LogToConsole("FLIP DONE ____");		
		curAngle.x = 0;
	 	curAngle.y = 0;
		self:SetAngles(curAngle);
		self.cnt:WakeUp();
	end
end

-------------------------------------------------------------------------------------------------------------
--
--
function Buggy:UpdateServer(dt)

	--filippo
	--VC.FunPhysics(self,dt);
	
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
function Buggy:OnShutDown()

	--assingning to nil is not really needed
	--if the entity will be destroyed
	VC.EveryoneOutForce( self );	
	VC.RemovePieces(self);
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
function Buggy:OnSave(stm)
	VC.SaveAmmo( self, stm );
	stm:WriteInt(self.fEngineHealth);
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function Buggy:OnLoad(stm)
	VC.LoadAmmo( self, stm );
	self.fEngineHealth = stm:ReadInt();
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function Buggy:OnEventServer( id, params)


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

function Buggy:OnWrite( stm )
	
--	stm:WriteInt(self.bExploded);
--	if(self.driver) then
--		stm:WriteInt(self.driver.id);
--	else	
--		stm:WriteInt(0);
--	end	
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function Buggy:OnRead( stm )
local	exploded=0;	

--	exploded = stm:ReadInt();
	
--	if(self.bExploded == 0 and exploded == 1) then
--		self:GotoState( "Dead" );
--	end	

--	id = stm:ReadInt();
--	if( id ~= 0 ) then
--		self.driver = System:GetEntity(id);
--	else
----		self.driverP = self.driver;
--		self.driver = nil;
--	end
end

----------------------------------------------------------------------------------------------------------------------------
--
--


--////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////
--// CLIENT functions definitions
--////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////

Buggy.Client = {
	OnInit = function(self)
		self:InitClient();
	end,
	OnShutDown = function(self)
		self:OnShutDown();
	end,
	Alive = {
		OnBeginState = function( self )	
			VC.InitGroundVehicleCommon(self,self.szNormalModel);
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

Buggy.Server = {
	OnInit = function(self)
		self:InitServer();
	end,
	OnShutDown = function(self)
		self:OnShutDown();
	end,
	Alive = {
		OnBeginState = function( self )	
			VC.InitGroundVehicleCommon(self,self.szNormalModel);
		end,
		OnContact = function(self,player)
	 		self:OnContactServer(player);
		end,
		OnDamage = VC.OnDamageServer,
		OnCollide = VC.OnCollideServer,
		OnUpdate = function(self,dt)
			self:UpdateServer(dt);
		end,
		OnEvent = function (self, id, params)
			self:OnEventServer( id, params);
		end,
	},
	Inactive = {
	},
	Dead = {
		OnBeginState = function( self )
			VC.BlowUpServer(self);
		end,
		OnContact = function(self,player)
	 		VC.OnContactServerDead(self,player);
		end,
	},
}


-------------------------------------------------------------------------------------------------------------
--
--

-------------------------------------------------------------------------------------------------------------
--
--
function Buggy:DoEnter( puppet )

	if( puppet == self.driverT.entity ) then		
		
--System:Log("DoEnter     DRIVER");		
--		local puppet = self.driver;		
		self.driver = nil;
		VC.AddUserT( self, self.driverT );
		VC.InitEntering( self, self.driverT );
	else
		local tbl = VC.FindPassenger( self, puppet );
		if( not tbl ) then return end
--System:Log("DoEnter     passenger");
		VC.AddUserT( self, tbl );
		VC.InitEntering( self, tbl );
	end
end

-------------------------------------------------------------------------------------------------------------
--
--
function Buggy:AddDriver( puppet )

--do return 0 end
	if (self.driverT.entity ~= nil)		then	-- already have a driver
		do return 0 end
	end

	self.driver = puppet;
	self.driverT.entity = puppet;
	if( VC.InitApproach( self, self.driverT )==0 ) then	
		self:DoEnter( puppet );
	end	
	do return 1 end	
end

-------------------------------------------------------------------------------------------------------------
--
--
function Buggy:AddGunner( puppet )
	return 0;
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function Buggy:AddPassenger( puppet )

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
function Buggy:LoadPeople()

	if(VC.FreeToUse( self )==0) then return end	-- can't use it - player is in

	if(self.driverT.entity and self.driverT.entity.ai) then
		AI:Signal(0, 1, "DRIVER_IN", self.id);
	end	
	
--	AI:Signal(SIGNALFILTER_GROUPONLY, 1, "wakeup", self.id);
--	AI:Signal(SIGNALFILTER_GROUPONLY, 1, "SHARED_ENTER_ME_VEHICLE", self.id);
	
	if( self.Properties.bSameGroupId == 1 ) then
		AI:Signal(SIGNALFILTER_GROUPONLY, 1, "wakeup", self.id);	
		AI:Signal(SIGNALFILTER_GROUPONLY, 1, "SHARED_ENTER_ME_VEHICLE", self.id);
	else
		AI:Signal(SIGNALFILTER_ANYONEINCOMM, 1, "wakeup", self.id);	
		AI:Signal(SIGNALFILTER_ANYONEINCOMM, 1, "SHARED_ENTER_ME_VEHICLE", self.id);
	end
	
	
	self.dropState = 1;

end


----------------------------------------------------------------------------------------------------------------------------
--
--	to test-call reinf
function Buggy:Event_Reinforcment( params )

--printf( "signaling BRING_REINFORCMENT " );	

	if(VC.FreeToUse( self )==0) then return end	-- can't use it - player is in

	VC.AIDriver( self, 1 );	
	AI:Signal(0, 1, "BRING_REINFORCMENT", self.id);
	
end	


----------------------------------------------------------------------------------------------------------------------------
--
function Buggy:Event_GoPath( params )
	if(VC.FreeToUse( self )==0) then return end	-- can't use it - player is in

	VC.AIDriver( self, 1 );	
	AI:Signal(0, 1, "GO_PATH", self.id);

end

----------------------------------------------------------------------------------------------------------------------------
--
function Buggy:Event_GoPatrol( params )
	if(VC.FreeToUse( self )==0) then return end	-- can't use it - player is in

	VC.AIDriver( self, 1 );	
	AI:Signal(0, 1, "GO_PATROL", self.id);

end


----------------------------------------------------------------------------------------------------------------------------
--
function Buggy:Event_GoChase( params )
	if(VC.FreeToUse( self )==0) then return end	-- can't use it - player is in

	VC.AIDriver( self, 1 );	
	AI:Signal(0, 1, "GO_CHASE", self.id);

end

----------------------------------------------------------------------------------------------------------------------------
--
-- 
function Buggy:Event_KillTriger( params )

	self.cnt:SetVehicleEngineHealth(0);
	self:GotoState( "Dead" );	
--	self.fEngineHealth = 0;

end


----------------------------------------------------------------------------------------------------------------------------
--
--


-----------------------------------------------------------------------------------------------------
function Buggy:Event_LoadPeople( params )

	self:LoadPeople();
	
end


----------------------------------------------------------------------------------------------------------------------------
--
--
function Buggy:Event_EveryoneOut()

	VC.DropPeople( self );
	
end

-----------------------------------------------------------------------------------------------------
--
--
function Buggy:Event_Activate( params )

	if(self.bExploded == 1) then return end
	
	self:GotoState( "Alive" );
end



----------------------------------------------------------------------------------------------------------------------------
--
--
function Buggy:DropPeople()

	VC.DropPeople( self );

end


----------------------------------------------------------------------------------------------------------------------------
--
function Buggy:Event_DriverIn( params )

	BroadcastEvent( self,"DriverIn" );
	
end	
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
--
--

--------------------------------------------------------------------------------------------------------
-- empty function to get reed of script error - it's called from behavours
function Buggy:MakeAlerted()
end

--------------------------------------------------------------------------------------------------------
-- 
function Buggy:InitWeapon()

--do return end

	-- //m_MinVAngle, m_MaxVAngle, m_MinHAngle, m_MaxHAngle
	self.cnt:SetWeaponLimits(-90,20,0,0);
	self.cnt:SetWeaponName("VehicleMountedAutoMG", "");
--	self.cnt:SetWeaponName("VehicleMountedRocketMG", "");	
	VC.InitAutoWeapon( self );

	self.driverShooting = 1;
--	self.Ammo = {};	
--	self.Ammo["VehicleMG"] = 300;
--	self.Ammo["VehicleRocket"] = 40;
end

----------------------------------------------------------------------------------------------------------------------------
--
--this is called from vehicleProxy when all the saving is done
function Buggy:OnSaveOverall(stm)

	VC.SaveCommon( self, stm );
	
end

----------------------------------------------------------------------------------------------------------------------------
--
--this is called from vehicleProxy when all the loading is done and all the entities are spawn
function Buggy:OnLoadOverall(stm)

	VC.LoadCommon( self, stm );
	
end

--------------------------------------------------------------------------------------------------------------
