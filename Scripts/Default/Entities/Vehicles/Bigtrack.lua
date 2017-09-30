
-- Bigtrack
Bigtrack = {
--	type = "Vehicle",

	IsCar = 1,

--	CanShoot = 1,	-- player can shoot from his veapon while driving this vehicle - 
--			-- don't change action map to vehicle when entering

	IsPhisicalized = 0,

	-- [kirill] vehicle gets different damage depending on who's shooter
	-- defines the intensity of the damage caused by the weapons to
	-- the vehicle	
	
	--
	DamageParams = {
		fDmgScaleAIBullet = 0.02,
		fDmgScaleAIExplosion = 0.115,--patch2:3 missiles to be destroyed --before was 0.03,  
		fDmgScaleBullet = 0.02,
		fDmgScaleExplosion = 0.085,--patch2:3 missiles to be destroyed --before was 0.03,  
		
		dmgBulletMP = 0.2,--if this value exist in multiplayer will be used this damage for every bullet , 
				  --so for instance, no difference between a sniper rifle and a desert eagle.
				  --Vehicles have 100 points of health.
				  --in this case 500 bullets are needed to destroy the vehicle.
	},

	--model to be used for destroyed vehicle
	fileModelDead = "objects/Vehicles/hemtt/hemtt_wreck.cgf",
	fileModelPieces = "objects/Vehicles/hemtt/hemtt_pieces.cgf",	
	waterDepth = 1,	-- if water is deeper then this value - vehicle can't be used

	windows={
		{
		fileName="Objects/vehicles/hemtt/hemtt_window_left.cgf",
		helperName="front_window_left",		--"window1",
		entity=nil,
		},
		{
		fileName="Objects/vehicles/hemtt/hemtt_window_right.cgf",
		helperName="front_window_right",		--"window2",
		entity=nil,
		},
	},

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
	
	passengerLimit=9,

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

--	szNormalModel="Objects/Vehicles/HEMTT/hemtt_driveable.cgf",

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

	CarDef = {		
		file = "Objects/Vehicles/HEMTT/hemtt_driveable.cgf",
		
		engine_power = 	    900000, -- default 110000
		engine_power_back = 900000, -- default 85000
		engine_maxrpm = 2200, -- default 700
		axle_friction = 7000, -- default 650
		max_steer = 20, -- default 22
		stabilizer = 0,
		
		max_braking_friction = 0.5,
		handbraking_value = 9,-- meter/s / s
		
		max_braking_friction_nodriver = 1.0, --this friction is applied when there is no driver inside the car
		handbraking_value_nodriver = 3,-- (meter/s / s) , same as above, this value is applied only when the car have no driver

		stabilize_jump = 2000,--this set how much to correct the car angles while it is in air.
		
		engine_minRPM = 20,
		engine_idleRPM = 80,
		engine_startRPM = 400,
		engine_shiftupRPM = 1500,
		engine_shiftdownRPM = 700,
		
		clutch_speed = 2,
		gears = { -4.0,0,4.7,4.1 },
		
		integration_type = 1,
		brake_torque = 60000,
    		dyn_friction_ratio = 1.0,
		gear_dir_switch_RPM = 20,
		slip_threshold = 0.05,
		
		cam_stifness_positive = { x=400,y=400,z=100 },
	  cam_stifness_negative = { x=400,y=400,z=100 },
	  cam_limits_positive = { x=0,y=0.5,z=0 },
	  cam_limits_negative = { x=0,y=0.3,z=0 },
	  cam_damping = 22,
	  cam_max_timestep = 0.01,
	  cam_snap_dist = 0.001,
	  cam_snap_vel = 0.01,

		pedal_speed = 2.0,
		
		---steering----
		------------------------------------------------
		steer_speed = 50,--(degree/s) steer speed at max velocity (the max speed is about 30 m/s)
		steer_speed_min = 100, --(degree/s) steer speed at min velocity
		
		steer_speed_scale = 1.0,--steering speed scale at top speed
		steer_speed_scale_min = 2.0,--steering speed scale at min speed
		--steer_speed_valScale = 1.0, 
		
		max_steer_v0 = 25.0, --max steer angle
		--max_steer_kv = 0.0,
		
		steer_relaxation_v0 = 720,--(degree/s) steer speed when return to forward direction.
		--steer_relaxation_kv = 15,--15,
		-----------------------------------------------
				
		brake_vel_threshold = 2, -- default 1000 if vehicle's velocity is below this, normal handbrake is used, otherwise increased axle_friction is 
	  brake_axle_friction = 3000, -- used to simulate braking default 5000
	  
	  max_time_step_vehicle = 0.02,
		sleep_speed_vehicle = 0.11,
		damping_vehicle = 0.5,
		
		-- rigid_body_params
		max_time_step = 0.01,
		damping = 0.1,
		sleep_speed = 0.04,
		freefall_damping = 0.03,
		gravityz = -10.81,
		freefall_gravityz = -10.81,

		water_density=30,
		
--		hull0 = { mass=1859,flags=0,zoffset=.41	}, -- default mass 1859
		hull1 = { mass=50000,flags=0,zoffset=-0.5,yoffset=0.0	}, -- default mass 2359
		hull2 = { mass=0,flags=1	},
		hull3 = { mass=0,flags=1	},
		
		wheel1 = { driving=1,axle=0,len_max=0.3,stiffness=0,damping=-0.7, surface_id = 69, min_friction=1.0, max_friction=1.5 },
		wheel2 = { driving=1,axle=0,len_max=0.3,stiffness=0,damping=-0.7, surface_id = 69, min_friction=1.0, max_friction=1.5 },
		wheel3 = { driving=1,axle=1,len_max=0.3,stiffness=0,damping=-0.7, surface_id = 69, min_friction=1.0, max_friction=1.5 },
		wheel4 = { driving=1,axle=1,len_max=0.3,stiffness=0,damping=-0.7, surface_id = 69, min_friction=1.0, max_friction=1.5 },		
		wheel5 = { driving=1,axle=2,len_max=0.3,stiffness=0,damping=-0.7, surface_id = 69, min_friction=1.0, max_friction=1.5 },				
		wheel6 = { driving=1,axle=2,len_max=0.3,stiffness=0,damping=-0.7, surface_id = 69, min_friction=1.0, max_friction=1.5 },		
		wheel7 = { driving=1,axle=3,len_max=0.3,stiffness=0,damping=-0.7, surface_id = 69, min_friction=1.0, max_friction=1.5 },		
		wheel8 = { driving=1,axle=3,len_max=0.3,stiffness=0,damping=-0.7, surface_id = 69, min_friction=1.0, max_friction=1.5 },
		
		wheel_num = 8,
	},

	tmp = 0,


--/////////////////////////////////////////////////////////////////////////
-- damage stuff
	-- particle system to display when the vehicle is damaged stage 1
	Damage1Effect = "smoke.vehicle_damage1.a",
	-- particle system to display when the vehicle is damaged stage 2
	Damage2Effect = "smoke.vehicle_damage2.a",
	-- particle system to display when the vehicle explodes
	ExplosionEffect = "explosions.humvee_explosion.a",
	-- particle system to display when the vehicle is destroyed
	DeadEffect = "fire.burning_after_explosion.a",


	bExploded=false,

	
--	last frame suspension compretion ratio
	suspWheel1 = 0,
	suspWheel2 = 0,
	suspWheel3 = 0,
	suspWheel4 = 0,

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
	
		object_Model="Objects/Vehicles/HEMTT/hemtt_driveable.cgf",	
	
		bTrackable=1,
		bDrawDriver = 0,
		fLimitLRAngles = 100,
		fLimitUDMinAngles = -30,
		fLimitUDMaxAngles = 20,
		
		ExplosionParams = {
			nDamage = 600,
			fRadiusMin = 8.0, -- default 12
			fRadiusMax = 10, -- default 35.5
			fRadius = 10, -- default 17
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
			
			steer_speed = 50.0,
			steer_speed_min = 100.0,
			max_steer_v0 = 25,
			steer_relaxation_v0 = 720,
			
			dyn_friction_ratio = 1.0,
			max_braking_friction = 0.5,
			handbraking_value = 9,
			
			damping_vehicle = 0.06,
		},	
	},

	-- engine health, status of the vehicle
	-- default is set to maximum (1.0f)
	fEngineHealth = 100.0,

	-- damage inflicted to the vehicle when it collides
	fOnCollideDamage=0,
	-- damage inflicted to the vehicle when it collides with terrain (falls off)
	fOnCollideGroundDamage=0.3,
	
	--damage inflicted when falling , this value is multiplied by the half of the square of the falling speed:
	--for istance: 5 m/s = 12 dmgpoints * fOnFallDamage
	--	      10 m/s = 50 dmgpoints * fOnFallDamage
	--	      20 m/s = 200 dmgpoints * fOnFallDamage
	fOnFallDamage=0.05,
	
	--damage when colliding with another vehicle, this value is multiplied by the hit.impact value.
	fOnCollideVehicleDamage=0.5,
	

	bGroundVehicle=1,

	driverT = {
		type = PVS_DRIVER,
	
		helper = "driver",	-- to bind to
		in_helper = "driver_sit_pos",
		in_anim = "hemtt_driver_in",
		out_anim = "hemtt_driver_out",
		sit_anim = "hemtt_driver_sit",
		anchor = AIAnchor.z_CARENTER_DRIVER,
		out_ang = -90,
		message = "@driverbigtruck",
	},
	
	passengersTT = {
		{
			type = PVS_PASSENGER,
		
			helper = "passenger2",
			in_helper = "passenger2_sit_pos",
			in_anim = "hemtt_passenger_front_in",
			out_anim = "hemtt_passenger_front_out",
			sit_anim = "hemtt_passenger_front_sit",
			anchor = AIAnchor.z_CARENTER_PASSENGER2,
			out_ang = -90,
			message = "@passengerbigtruck",
		},
		{
			type = PVS_PASSENGER,
		
			helper = "passenger3",
			in_helper = "passenger3_sit_pos",
			in_anim = "hemtt_passenger_r_in",
			out_anim = "hemtt_passenger_r_out",
			sit_anim = "hemtt_passenger_r_sit",
			anchor = AIAnchor.z_CARENTER_PASSENGER3,
			out_ang = 90,
			message = "@passengerbigtruck",
		},
		{
			type =PVS_PASSENGER,		
				
			helper = "passenger4",
			in_helper = "passenger4_sit_pos",
			in_anim = "hemtt_passenger_r_in",
			out_anim = "hemtt_passenger_r_out",
			sit_anim = "hemtt_passenger_r_sit",
			anchor = AIAnchor.z_CARENTER_PASSENGER4,
			out_ang = -90,
			message = "@passengerbigtruck",
		},
		{
			type = PVS_PASSENGER,
					
			helper = "passenger5",
			in_helper = "passenger5_sit_pos",
			in_anim = "hemtt_passenger_r_in",
			out_anim = "hemtt_passenger_r_out",
			sit_anim = "hemtt_passenger_r_sit",
			anchor = AIAnchor.z_CARENTER_PASSENGER5,
			out_ang = 90,
			message = "@passengerbigtruck",
		},
		{
			type = PVS_PASSENGER,
					
			helper = "passenger6",
			in_helper = "passenger6_sit_pos",
			in_anim = "hemtt_passenger_r_in",
			out_anim = "hemtt_passenger_r_out",
			sit_anim = "hemtt_passenger_r_sit",
			anchor = AIAnchor.z_CARENTER_PASSENGER6,
			out_ang = 90,
			message = "@passengerbigtruck",
		},
		{
			type = PVS_PASSENGER,
					
			helper = "passenger7",
			in_helper = "passenger7_sit_pos",
			in_anim = "hemtt_passenger_l_in",
			out_anim = "hemtt_passenger_l_out",
			sit_anim = "hemtt_passenger_l_sit",
			anchor = AIAnchor.z_CARENTER_PASSENGER7,
			out_ang = 90,
			message = "@passengerbigtruck",
		},
		{
			type = PVS_PASSENGER,
					
			helper = "passenger8",
			in_helper = "passenger8_sit_pos",
			in_anim = "hemtt_passenger_l_in",
			out_anim = "hemtt_passenger_l_out",
			sit_anim = "hemtt_passenger_l_sit",
			anchor = AIAnchor.z_CARENTER_PASSENGER8,
			out_ang = 90,
			message = "@passengerbigtruck",
		},
		{
			type = PVS_PASSENGER,
					
			helper = "passenger9",
			in_helper = "passenger9_sit_pos",
			in_anim = "hemtt_passenger_l_in",
			out_anim = "hemtt_passenger_l_out",
			sit_anim = "hemtt_passenger_l_sit",
			anchor = AIAnchor.z_CARENTER_PASSENGER9,
			out_ang = 90,
			message = "@passengerbigtruck",
		},
		{
			type = PVS_PASSENGER,
					
			helper = "passenger10",
			in_helper = "passenger10_sit_pos",
			in_anim = "hemtt_passenger_l_in",
			out_anim = "hemtt_passenger_l_out",
			sit_anim = "hemtt_passenger_l_sit",
			anchor = AIAnchor.z_CARENTER_PASSENGER10,
			out_ang = 90,
			message = "@passengerbigtruck",
		},
	},
	
}

VC.CreateVehicle(Bigtrack);

--////////////////////////////////////////////////////////////////////////////////////////
function Bigtrack:OnReset()

	if(self.bExploded == 1) then
		VC.InitGroundVehicleServer(self,self.Properties.object_Model);
	end	

	VC.OnResetCommon(self);
	self:NetPresent(1);
	VC.EveryoneOutForce(self);
	self.fEngineHealth = 100.0;
	self.bExploded=false;
	self.cnt:SetVehicleEngineHealth(self.fEngineHealth);
	
	AI:RegisterWithAI(self.id, AIOBJECT_CAR,self.Properties,self.PropertiesInstance);
	VC.InitAnchors( self );	
	VC.AIDriver( self, 0 );	

	self.step = self.Properties.pathstart - 1;

	VC.InitWindows(self);
	
end


--////////////////////////////////////////////////////////////////////////////////////////
function Bigtrack:InitPhis()

	VC.InitGroundVehiclePhysics(self,self.Properties.object_Model);
end	

--////////////////////////////////////////////////////////////////////////////////////////
function Bigtrack:InitClient()
	VC.InitSeats(self, Bigtrack);

	--/////////////////////////////////////////////////////////////////////////
	-- local sounds for the client

--	self.drive_sound = Sound:Load3DSound("sounds\\vehicle\\buggy\\aidle_loop.wav",0,200,7,100000);
	self.drive_sound_move = Sound:Load3DSound("sounds\\vehicle\\tire_rocks.wav",0,200,13,300);
	self.maxvolume_speed = 15;
	
	self.drive_sound_move_water = Sound:Load3DSound("sounds\\vehicle\\boat\\splashLP.wav",0,0,13,300);
	self.maxvolume_speed_water = 5;
	
--	self.accelerate_sound = {
--		Sound:Load3DSound("sounds\\vehicle\\rev.wav",0,0,7,100000),
--		Sound:Load3DSound("sounds\\vehicle\\rev.wav",0,0,7,100000),
--		Sound:Load3DSound("sounds\\vehicle\\rev.wav",0,0,7,100000),
--		Sound:Load3DSound("sounds\\vehicle\\rev.wav",0,0,7,100000),
--	};

	self.suspSoundTable[1] = Sound:Load3DSound("sounds\\vehicle\\comp1.wav",0,150,7,100000);
	self.suspSoundTable[2] = Sound:Load3DSound("sounds\\vehicle\\comp2.wav",0,150,7,100000);	
	self.suspSoundTable[3] = Sound:Load3DSound("sounds\\vehicle\\comp3.wav",0,150,7,100000);	
	self.suspSoundTable[4] = Sound:Load3DSound("sounds\\vehicle\\comp4.wav",0,150,7,100000);	

	self.break_sound = Sound:Load3DSound("sounds\\vehicle\\break1.wav",0,100,13,300);
	self.engine_start = Sound:Load3DSound("sounds\\vehicle\\HV\\hvstart.wav",0,255,13,300);
	self.engine_off = Sound:Load3DSound("sounds\\vehicle\\HV\\hvoff.wav",0,255,13,300);
	self.sliding_sound = Sound:Load3DSound("sounds\\vehicle\\break2.wav",0,150,13,300);

	-------------------------------------------------------------------------------------
--	self.gearup_sounds= {	
--		Sound:Load3DSound("sounds\\vehicle\\HV\\hvlowspeedgeardown.wav",0,255,7,50), -- reverse up (0-1)		
--		Sound:Load3DSound("sounds\\vehicle\\HV\\hvfirstaccel.wav",0,255,7,50), -- (1-2)
--		Sound:Load3DSound("sounds\\vehicle\\HV\\hvsecondaccel.wav",0,255,7,50), -- (2-3)
--		Sound:Load3DSound("sounds\\vehicle\\HV\\hvsecondaccel.wav",0,255,7,50), -- (3-4)
--		Sound:Load3DSound("sounds\\vehicle\\HV\\hvsecondaccel.wav",0,255,7,50), -- (4-5)
--	};
--
--	self.geardn_sounds={		
--		Sound:Load3DSound("sounds\\vehicle\\HV\\hvfirstaccel.wav",0,255,7,50), -- reverse down (1-0)
--		Sound:Load3DSound("sounds\\vehicle\\HV\\hvlowspeedgeardown.wav",0,255,7,50), -- (2-1)
--		Sound:Load3DSound("sounds\\vehicle\\HV\\hvhighgeardown.wav",0,255,7,50), -- (3-2)
--		Sound:Load3DSound("sounds\\vehicle\\HV\\hvhighgeardown.wav",0,255,7,50), -- (4-3)
--		Sound:Load3DSound("sounds\\vehicle\\HV\\hvhighgeardown.wav",0,255,7,50), -- (5-4)
--	};
--
--	self.idle_sounds={				
--		Sound:Load3DSound("sounds\\vehicle\\HV\\hvidle.wav",0,255,7,50), -- reverse idle (0)
--		Sound:Load3DSound("sounds\\vehicle\\HV\\hvidle.wav",0,255,7,50), -- engine idle (1)
--		Sound:Load3DSound("SOUNDS\\Vehicle\\HV\\hvfirstgearspeedidle.wav",0,255,7,50), -- (2)
--		Sound:Load3DSound("SOUNDS\\Vehicle\\HV\\hvsecondgearspeedidle.wav",0,255,7,50), -- (3)
--		Sound:Load3DSound("SOUNDS\\Vehicle\\HV\\hvtopspeedidle.wav",0,255,7,50), -- (4)				
--		Sound:Load3DSound("SOUNDS\\Vehicle\\HV\\hvtopspeedidle.wav",0,255,7,50), -- (5)	
--	};
	
	self.clutch_sound = Sound:Load3DSound("sounds\\vehicle\\vehicle_efx\\gearchange.wav",0,255,13,300);
	
	self.idleengine = Sound:Load3DSound("sounds\\vehicle\\HV\\hvidle.wav",0,255,13,300);
	self.idleengine_ratios = {0.9,0.9,1.15,0.9};
	self.clutchengine_frequencies = {1000,1000,500,700};
	self.clutchfreqspeed = 10;
	self.enginefreqspeed = 1;

	--self.nogroundcontact_sound=Sound:Load3DSound("sounds\\vehicle\\HV\\hvfirstaccel.wav",0,255,7,50);
	self.land_sound = Sound:Load3DSound("sounds\\vehicle\\vehicle_efx\\carclunk.wav",0,255,13,300);
	-------------------------------------------------------------------------------------

	self.compression_sound1 = Sound:Load3DSound("sounds\\vehicle\\comp1.wav",0,0,7,100000);
	self.compression_sound2 = Sound:Load3DSound("sounds\\vehicle\\comp2.wav",0,0,7,100000);
	self.compression_sound3 = Sound:Load3DSound("sounds\\vehicle\\comp3.wav",0,0,7,100000);
	self.compression_sound4 = Sound:Load3DSound("sounds\\vehicle\\comp4.wav",0,0,7,100000);
	self.ExplosionSound=Sound:Load3DSound("sounds\\explosions\\explosion2.wav",0,255,150,1000);

--	self.buggy_sound = Sound:Load3DSound("sounds\\vehicle\\buggy.wav",0,200,7,100000);

	self.crash_sound = Sound:Load3DSound("sounds\\vehicle\\carcrash.wav",0,200,7,300);
	
	self.light_sound = Sound:Load3DSound("SOUNDS/items/flight.wav",SOUND_UNSCALABLE,160,3,30),

	VC.InitGroundVehicleClient(self, self.Properties.object_Model);
	
	self.cnt:InitLights( "front_light","textures/lights/front_light",
			"front_light_left","front_light_right","humvee_frontlight",
			"back_light_left", "back_light_right","humvee_backlight" );
			
	self.cnt:SetWeaponName("none","");
	
end

--////////////////////////////////////////////////////////////////////////////////////////
function Bigtrack:InitServer()
	VC.InitSeats(self, Bigtrack);

	VC.InitGroundVehicleServer(self, self.Properties.object_Model);

	self:OnReset();
	self.cnt:SetWeaponName("none","");
end

--////////////////////////////////////////////////////////////////////////////////////////
function Bigtrack:OnContactServer( player )

	if( self.Properties.bUsable==0 ) then return end
	if( VC.IsUnderWater( self ) == 1 ) then return end
	
	VC.OnContactServerT(self,player);
end

--////////////////////////////////////////////////////////////////////////////////////////
function Bigtrack:OnContactClient( player )

	if( self.Properties.bUsable==0 ) then return end
	if( VC.IsUnderWater( self ) == 1 ) then return end
	
	VC.OnContactClientT(self,player);
end



-------------------------------------------------------------------------------------------------------------
--
--
function Bigtrack:UpdateServer(dt)

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
function Bigtrack:OnShutDown()

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

	VC.RemoveWindows(self); 
	VC.RemovePieces(self);	
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function Bigtrack:OnSave(stm)
	stm:WriteInt(self.fEngineHealth);
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function Bigtrack:OnLoad(stm)
	self.fEngineHealth = stm:ReadInt();
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function Bigtrack:OnEventServer( id, params)


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

function Bigtrack:OnWrite( stm )
	
	
	if(self.driver) then
		stm:WriteInt(self.driver.id);
	else	
		stm:WriteInt(0);
	end	
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function Bigtrack:OnRead( stm )
local	id=0;	


	id = stm:ReadInt();
	if( id ~= 0 ) then
		self.driver = System:GetEntity(id);
	else
--		self.driverP = self.driver;
		self.driver = nil;
	end
	
end

----------------------------------------------------------------------------------------------------------------------------
--
--


--////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////
--// CLIENT functions definitions
--////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////

Bigtrack.Client = {
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

Bigtrack.Server = {
	OnInit = function(self)
		self:InitServer();
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
	},
}


-------------------------------------------------------------------------------------------------------------
--
--

-------------------------------------------------------------------------------------------------------------
--
--
function Bigtrack:DoEnter( puppet )

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
function Bigtrack:AddDriver( puppet )

--do return 0 end
	if (self.driverT.entity ~= nil)		then	-- already have a driver
		do return 0 end
	end

	self.driver = puppet;
	self.driverT.entity = puppet;
	if( VC.InitApproach( self, self.driverT )==0 ) then	
		self.DoEnter( puppet );
	end	
	do return 1 end	
end

-------------------------------------------------------------------------------------------------------------
--
--
function Bigtrack:AddGunner( puppet )
	return 0;
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function Bigtrack:AddPassenger( puppet )

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
function Bigtrack:LoadPeople()

	if(VC.FreeToUse( self )==0) then return end	-- can't use it - player is in

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
function Bigtrack:Event_Reinforcment( params )

--printf( "signaling BRING_REINFORCMENT " );	

	VC.AIDriver( self, 1 );	

	AI:Signal(0, 1, "BRING_REINFORCMENT", self.id);
	
end	


----------------------------------------------------------------------------------------------------------------------------
--
function Bigtrack:Event_GoPath( params )

	VC.AIDriver( self, 1 );	

	AI:Signal(0, 1, "GO_PATH", self.id);

end

----------------------------------------------------------------------------------------------------------------------------
--
function Bigtrack:Event_GoPatrol( params )

	VC.AIDriver( self, 1 );	

	AI:Signal(0, 1, "GO_PATROL", self.id);

end


----------------------------------------------------------------------------------------------------------------------------
--
function Bigtrack:Event_GoChase( params )

	AI:Signal(0, 1, "GO_CHASE", self.id);

end

----------------------------------------------------------------------------------------------------------------------------
--
-- 
function Bigtrack:Event_KillTriger( params )

	self.fEngineHealth = 0;

end


----------------------------------------------------------------------------------------------------------------------------
--
--
function Bigtrack:DropPeople()

	VC.DropPeople( self );

end

----------------------------------------------------------------------------------------------------------------------------
--
function Bigtrack:Event_DriverIn( params )

	BroadcastEvent( self,"DriverIn" );
	
end	

-----------------------------------------------------------------------------------------------------
--
--
function Bigtrack:Event_Activate( params )

	if(self.bExploded == 1) then return end
	
	self:GotoState( "Alive" );
end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
--
--
--------------------------------------------------------------------------------------------------------
-- empty function to get reed of script error - it's called from behavours
function Bigtrack:MakeAlerted()
end


----------------------------------------------------------------------------------------------------------------------------
--
--this is called from vehicleProxy when all the saving is done
function Bigtrack:OnSaveOverall(stm)

	VC.SaveCommon( self, stm );
	
end

----------------------------------------------------------------------------------------------------------------------------
--
--this is called from vehicleProxy when all the loading is done and all the entities are spawn
function Bigtrack:OnLoadOverall(stm)

	VC.LoadCommon( self, stm );
	
end

--------------------------------------------------------------------------------------------------------------

