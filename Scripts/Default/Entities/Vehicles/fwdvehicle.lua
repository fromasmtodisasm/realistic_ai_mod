-- Fout wheels drive vehicle script
-- created by Kirill Bulatsev


FWDVehicle = {
--	type = "Vehicle",
	IsCar = 1,
	ammoMG = 700,
	ammoRL = 11,
	-- [kirill] vehicle gets different damage depending on who's shooter
	-- defines the intensity of the damage caused by the weapons to
	-- the vehicle
	DamageParams = {
		-- fDmgScaleAIBullet = .03, --.03
		-- fDmgScaleAIExplosion = .65,
		fDmgScaleBullet = .01,
		fDmgScaleExplosion = .17, --patch2:vehicles must explode with 1 missile --before was .12, --.17
		-- dmgBulletMP = 1, --if this value exist in multiplayer will be used this damage for every bullet,.66
				  --so for instance,no difference between a sniper rifle and a desert eagle.
				  --Vehicles have 100 points of health.
				  --in this case 150 bullets are needed to destroy the vehicle.
				  --now changed to 100...Doc
	},

	ExplosionParams = {
		nDamage = 1150,
	},

	fileModel="objects/Vehicles/Humvee/Humvee.cgf",
	--model to be used for destroyed vehicle
	fileModelDead = "objects/Vehicles/Humvee/Humvee_wreck.cgf",
	fileModelPieces = "objects/Vehicles/Humvee/humvee_pieces.cgf",
	fileGunModel = "Objects/Vehicles/Mounted_gun/mounted_gun_with_RL.cga",
	waterDepth = 1,	-- Максимальный уровень погружения,на котором машина может быть использована.
	IsPhisicalized = 0,
	IdleTime = 0,

	windows={
		{
		fileName="Objects/vehicles/humvee/humvee_window.cgf",
		helperName="front_window_left",		--"window1",
		entity=nil,
		},
		{
		fileName="Objects/vehicles/humvee/humvee_window.cgf",
		helperName="front_window_right",		--"window2",
		entity=nil,
		},
	},

	-- if speed is over maximum - don't play exit animation
	MaxSpeed2Exit = 9,
	-- previous state on the client before entering the vehicle
	-- bDriverInTheVehicle = 0,
	-- -- previous driver on the client before leaving the vehicle
	-- pPreviousDriver=nil,

	bDriverInTheVehicle = 0,
	pPreviousDriver=nil,
	bGunnerInTheVehicle = 0,
	pPreviousGunner=nil,
	bPassengerInTheVehicle = 0,
	pPreviousPassenger=nil,

	dropState = 0,
	userCounter = 0,
	driverWaiting = 1, -- Сколько водитель ждёт?
	driverDelay = 0,
	passengerLimit = 5,
	bIsEnabled = 1,
	-- A temporary storage vector used converting local positions to world positions
--	CurrentPosition = nil,
	-- particle system to display when the vehicle is damaged stage 1
	Damage1Effect = "smoke.vehicle_damage1.a",
	-- particle system to display when the vehicle is damaged stage 2
	Damage2Effect = "smoke.vehicle_damage2.a",
	-- particle system to display when the vehicle explodes
	ExplosionEffect = "explosions.4WD_explosion.a",
	-- particle system to display when the vehicle is destroyed
	DeadEffect = "fire.burning_after_explosion.a",
	-- material to be used when vehicle is destroyed
	DeadMaterial = "Vehicles.Humvee_Screwed",

	CarDef = {
--		file = "objects/Vehicles/Humvee/Humvee2.cgf",
		engine_power = 120000, --60000 --100000 -- default using old mass 150000
		engine_power_back = 120000, --60000 --80000 -- default using old mass 95000
		engine_maxrpm = 2500, --2500
		axle_friction = 500, --300
		max_steer = 22, -- default 30
		stabilizer = 0,
		dyn_friction_ratio = 1, -- Динамическое трение колес об землю чтобы поехать. При нуле будет скользить.
		max_braking_friction = .3, -- Трение при использовании ручного тормоза.
		handbraking_value = 9, -- meter/s / s -- Ручной тормоз.
		max_braking_friction_nodriver = 1, --this friction is applied when there is no driver inside the car --1
		handbraking_value_nodriver = 3, -- (meter/s / s),same as above,this value is applied only when the car have no driver -- 3
		stabilize_jump = 1500, --this set how much to correct the car angles while it is in air. --1500
		slip_threshold = .05, -- Порог скольжения.
		brake_torque = 20000, --Вращающий момент.
		engine_minRPM = 20,
		engine_idleRPM = 80,
		engine_startRPM = 400,
		engine_shiftupRPM = 1400,
		engine_shiftdownRPM = 350,
		clutch_speed = 1,
		--gears = {-3,0,3,2,1.5,1.1},
		--gears = {-6,0,3,2,1.5,1.1},
		gears = {-3,0,60,17,3.1,},-- {-3.5,0,6,4.5,3.1,2.8},
		--gears = {-7,0,3.5,2.8},
		gear_dir_switch_RPM = 2000, --1500
		integration_type = 1,
		cam_stifness_positive = {x=400,y=400,z=100},
	  	cam_stifness_negative = {x=400,y=400,z=100},
	  	cam_limits_positive = {x=0,y=.5,z=0},
	  	cam_limits_negative = {x=0,y=.3,z=0},
	  	cam_damping = 22,
	  	cam_max_timestep = .01,
	  	cam_snap_dist = .001,
	  	cam_snap_vel = .01,
		pedal_speed = 8, --8
		---steering----
		------------------------------------------------
		steer_speed = 12,--(degree/s) steer speed at max velocity (the max speed is about 30 m/s) --12 -- Поворачиваемость.
		steer_speed_min = 120,--(degree/s) steer speed at min velocity
		steer_speed_scale = 1, --steering speed scale at top speed
		steer_speed_scale_min = 2, --steering speed scale at min speed
		--steer_speed_valScale = 1,
		max_steer_v0 = 37, --max steer angle
		--max_steer_kv = 0,
		steer_relaxation_v0 = 720,--(degree/s) steer speed when return to forward direction.
		--steer_relaxation_kv = 15, --15,
		-----------------------------------------------
		max_time_step_vehicle = 1, --.02
		sleep_speed_vehicle = 1, --.04 -- 1 - прыгает -- Пытаюсь решить проблему путём временного отключения физики.
		damping_vehicle = .11, --.11 -- Амортизация.
		-- rigid_body_params
		max_time_step = 3, --.01
		damping = .1, --.1
		sleep_speed = 3, --.04 -- 3 - прыгает
		freefall_damping = .03,
		gravityz = -15.81,
		freefall_gravityz = -15.81,
		water_density=30,
		--hull0 = {mass=2359,flags=0,zoffset=.41	},-- default mass 4000
		--hull1 = {mass=3800,flags=0,zoffset=-.65,yoffset=-.7	},-- default mass 4000
		hull1 = {mass=1850,flags=0,zoffset=-.5,yoffset=-.35	},--mass: 2909-- default mass 4000
		hull2 = {mass=0,flags=1	},
		hull3 = {mass=0,flags=1	},
		wheel1 = {driving=1,axle=0,can_brake=1,len_max=.43,stiffness=0,damping=-.4,surface_id = 69,min_friction=1,max_friction=1.5},
		wheel2 = {driving=1,axle=0,can_brake=1,len_max=.43,stiffness=0,damping=-.4,surface_id = 69,min_friction=1,max_friction=1.5},
		wheel3 = {driving=1,axle=1,can_brake=1,len_max=.43,stiffness=0,damping=-.5,surface_id = 69,min_friction=1.05,max_friction=1.55},
		wheel4 = {driving=1,axle=1,can_brake=1,len_max=.43,stiffness=0,damping=-.5,surface_id = 69,min_friction=1.05,max_friction=1.55},
		wheel_num = 4,
	},

	tmp = 0,

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
	part_time = 0,
	partDmg_time = 0,
	slip_speed = 0,
	particles_updatefreq = .1, --.05, --initial frequency of updating wheel dust particles and 1st damage partcls

	PropertiesInstance = {
		sightrange = 110,
		soundrange = 10,	-- rememeber that sound ranges intersect and sound range for AI doubles when in alert
		aibehavior_behaviour = "Car_idle",
		groupid = 1,
	},

	Properties = {

		bActive = 1,	-- if vehicle is initially active or needs to be activated
				-- with Event_Activate first

		--fileModel="objects/Vehicles/Humvee/Humvee2.cgf",
		bEnabled  = 1,
		DisabledMessage = "",
		bLightsOn = 0,
		bHasRockets = 1,
		bUseRL = 0,	-- weapon for gunner is RocketLauncher
		bUseRLguided = 0,	-- weapon for gunner is COVERRL
		sDriverName = "",

		GunnerParams = {
			responsiveness = 50,
			sightrange = 110,
			attackrange = 350,
			horizontal_fov = 80, -- -1
--			aggression = 1,
--			accuracy = 1,
		},

		bLockUser = 0,

		bSetInvestigate = 0,	-- when releasing people - make them to go to Job_Investigate
		bSameGroupId = 1,

		bTrackable=1,
		fLimitLRAngles = 100,
		fLimitUDMinAngles = -5,
		fLimitUDMaxAngles = 20,
		fStartDelay = 2,

		ExplosionParams = {
			nDamage = 1000, -- 1150
			fRadiusMin = 12, -- default 12
			fRadiusMax = 20, -- default 35.5
			fRadius = 14, -- default 18
			fImpulsivePressure = 600, -- default 200 Умножается на 2.
		},

		bUsable = 1,								-- if this vehicle can be used by _localplayer

-- those are AI related properties
		pointReinforce = "Drop",
		pointBackOff = "Base",
		aggression = 1,
		commrange = 100,
		cohesion = 5,
		attackrange = 70,
		horizontal_fov = -1,
--		vertical_fov =90,
		eye_height = 2.1,
		forward_speed = 1,
--		back_speed = 3,
		max_health = 100, -- Нигде для не ИИ машин этот параметр не существует!
		responsiveness = 7,
		species = 1,
		fSpeciesHostility = 2,
		fGroupHostility = 0,
		fPersistence = 0,
		aicharacter_character = "FWDVehicle",
		bApproachPlayer = 1,
--		bodypos = 0,
		pathname = "drive",
		pathsteps = 0,
		pathstart = 0,
		pathstartAlter = -1,
		bPathloop = 1,
		ReinforcePoint = "none",
		fApproachDist = 20,
		fAttackStickDist = 1,
		bUsePathfind = 1,	-- pathfind when outdoors
		hit_upward_vel = 6,
		damage_players = 1,
		bSleeping = 0,
--		bEnterImmedeately = 0,	-- put AI in vehicle without approaching/animations

		--filippo
--		OverrideParams = {
--			fSteer_relax = 9,
--			fBraking_friction = .3,
--			fBraking_ammount = 9,--(mtr/sec)/sec
--			fWheel_frict_min = 1,
--			fWheel_frict_max = 1.5,
--			fSteer_range = 37,
--			bUse_override_params = 0,
--			fSteer_speed = 39,
--		},

		--filippo: This table is used (if exist) into "VC:AddUserT" , if the driver is an AI we merge this table with the CarDef.
		AICarDef = {
			bAI_use = 1,
			damping_vehicle = .03,
			dyn_friction_ratio = 1.3,
			handbraking_value = 9,
			max_braking_friction = .3,
			max_steer_v0 = 37,
			steer_relaxation_v0 = 720,
			steer_speed = 12,
			steer_speed_min = 120,
		},
	},

	bExploded=false,
	-- engine health,status of the vehicle
	-- default is set to maximum (1.0f)
	fEngineHealth = 100,
	-- damage inflicted to the vehicle when it collides
	fOnCollideDamage=0,
	-- damage inflicted to the vehicle when it collides with terrain (falls off)
	fOnCollideGroundDamage=.7, --.7 -- столкнулся
	--damage inflicted when falling,this value is multiplied by the half of the square of the falling speed:
	--for istance: 5 m/s = 12 dmgpoints * fOnFallDamage
	--	      10 m/s = 50 dmgpoints * fOnFallDamage
	--	      20 m/s = 200 dmgpoints * fOnFallDamage
	fOnFallDamage=.1, --.1 -- упал
	--damage when colliding with another vehicle,this value is multiplied by the hit.impact value.
	fOnCollideVehicleDamage=.75, --.75
	bGroundVehicle=1,

	-- seats
	driverT = {
		type = PVS_DRIVER,
		helper = "driver",
		in_helper = "driver_sit_pos",
		in_anim = "humvee_driver_in",
		out_anim = "humvee_driver_out",
		sit_anim = "humvee_driver_sit",
		anchor = AIAnchor.z_CARENTER_DRIVER,
		out_ang = -90,
		message = "@driverhumvee",
		-- invehicle animations
		animations = {
			"humvee_driver_sit",		-- idle in animation
			"humvee_driver_moving",		-- driving firward
			"humvee_driver_forward_hit",	-- impact / break
			"humvee_driver_leftturn",	-- turning left
			"humvee_driver_rightturn",	-- turning right
			"humvee_driver_reverse",	-- reversing
			"humvee_driver_reverse_hit",	-- reversing impact / break
		},
	},
	gunnerT = {
		type = PVS_GUNNER,
		enterpoint = "gunner",
		helper = "gunner",
		in_helper = "gunner_sit_pos",
		in_anim = "humvee_gunner_in",
		out_anim = "humvee_gunner_out",
		sit_anim = "humvee_gunner_sit",
		anchor = AIAnchor.z_CARENTER_GUNNER,
		out_ang = 0,
		message = "@gunnerhumvee",
	},
	passengersTT = {
		{
			type = PVS_PASSENGER,
			helper = "passenger",
			in_helper = "passenger_sit_pos",
			in_anim = "humvee_passenger1_in",
			out_anim = "humvee_passenger1_out",
			sit_anim = "humvee_passenger1_sit",
			anchor = AIAnchor.z_CARENTER_PASSENGER1,
			out_ang = 90,
			message = "@passengerhumvee",
			-- invehicle animations
			animations = {
				"humvee_passenger1_sit",		-- idle in animation
				"humvee_passenger1_moving",		-- driving firward
				"humvee_passenger1_forward_hit",	-- impact / break
				"humvee_passenger1_leftturn",		-- turning left
				"humvee_passenger1_rightturn",		-- turning right
				"humvee_passenger1_reverse",		-- reversing
				"humvee_passenger1_reverse_hit",	-- reversing impact / break
			},
		},
		{
			type = PVS_PASSENGER,
			helper = "passenger2",
			in_helper = "passenger2_sit_pos",
			in_anim = "humvee_passenger2_in",
			out_anim = "humvee_passenger2_out",
			sit_anim = "humvee_passenger2_sit",
			anchor = AIAnchor.z_CARENTER_PASSENGER2,
			out_ang = -90,
			message = "@passengerhumvee",
			-- invehicle animations
			animations = {
				"humvee_passenger2_sit",		-- idle in animation
				"humvee_passenger2_moving",		-- driving firward
				"humvee_passenger2_forward_hit",	-- impact / break
				"humvee_passenger2_leftturn",		-- turning left
				"humvee_passenger2_rightturn",		-- turning right
				"humvee_passenger2_reverse",		-- reversing
				"humvee_passenger2_reverse_hit",	-- reversing impact / break
			},
		},
		{
			type = PVS_PASSENGER,
			helper = "passenger3",
			in_helper = "passenger3_sit_pos",
			in_anim = "humvee_passenger3_in",
			out_anim = "humvee_passenger3_out",
			sit_anim = "humvee_passenger3_sit",
			anchor = AIAnchor.z_CARENTER_PASSENGER3,
			out_ang = 90,
			message = "@passengerhumvee",
			-- invehicle animations
			animations = {
				"humvee_passenger3_sit",		-- idle in animation
				"humvee_passenger3_moving",		-- driving firward
				"humvee_passenger3_forward_hit",	-- impact / break
				"humvee_passenger3_leftturn",		-- turning left
				"humvee_passenger3_rightturn",		-- turning right
				"humvee_passenger3_reverse",		-- reversing
				"humvee_passenger3_reverse_hit",	-- reversing impact / break
			},
		},
		{
			type = PVS_PASSENGER,
			helper = "passenger4",
			in_helper = "passenger4_sit_pos",
			in_anim = "humvee_passenger4_in",
			out_anim = "humvee_passenger4_out",
			sit_anim = "humvee_passenger4_sit",
			anchor = AIAnchor.z_CARENTER_PASSENGER4,
			out_ang = -90,
			message = "@passengerhumvee",
			-- invehicle animations
			animations = {
				"humvee_passenger4_sit",		-- idle in animation
				"humvee_passenger4_moving",		-- driving firward
				"humvee_passenger4_forward_hit",	-- impact / break
				"humvee_passenger4_leftturn",		-- turning left
				"humvee_passenger4_rightturn",		-- turning right
				"humvee_passenger4_reverse",		-- reversing
				"humvee_passenger4_reverse_hit",	-- reversing impact / break
			},
		},
		{
			type = PVS_PASSENGER,
			helper = "passenger5",
			in_helper = "passenger5_sit_pos",
			in_anim = "humvee_passenger5_in",
			out_anim = "humvee_passenger5_out",
			sit_anim = "humvee_passenger5_sit",
			anchor = AIAnchor.z_CARENTER_PASSENGER5,
			out_ang = 90,
			message = "@passengerhumvee",
			-- invehicle animations
			animations = {
				"humvee_passenger5_sit",		-- idle in animation
				"humvee_passenger5_moving",		-- driving firward
				"humvee_passenger5_forward_hit",	-- impact / break
				"humvee_passenger5_leftturn",		-- turning left
				"humvee_passenger5_rightturn",		-- turning right
				"humvee_passenger5_reverse",		-- reversing
				"humvee_passenger5_reverse_hit",	-- reversing impact / break
			},
		},
	},
}

VC.CreateVehicle(FWDVehicle)

FWDVehicle.Client = {
	OnInit = function(self)
		self:InitClient()
	end,
	OnShutDown = function(self)
		self:OnShutDown()
	end,
	Alive = {
		OnBeginState = function(self)
			VC.InitGroundVehicleCommon(self,self.fileModel)
		end,
		OnContact = function(self,player)
	 		self:OnContactClient(player)
		end,
		OnUpdate = VC.UpdateClientAlive,
		OnCollide = VC.OnCollideClient,
		OnBind = VC.OnBind,
		OnUnBind = VC.OnUnBind,
	},
	Inactive = {
		OnBeginState = function(self)
--System:Log("\001  inactive begin")
			self:Hide(1)
		end,
		OnEndState = function(self)
--System:Log("\001  inactive end")
--			self:Hide(0)
			self.IsPhisicalized = 0
		end,
	},
	Dead = {
		OnBeginState = function(self)
			VC.BlowUpClient(self)
		end,
		OnContact = function(self,player)
	 		VC.OnContactClientDead(self,player)
		end,
		OnUpdate = VC.UpdateClientDead,
		OnCollide = VC.OnCollideClient,
		OnUnBind = VC.OnUnBind,
	},
}

FWDVehicle.Server = {
	OnInit = function(self)
		self:InitServer()
	end,
	OnShutDown = function(self)
		self:OnShutDown()
	end,
	Alive = {
		OnBeginState = function(self)
			VC.InitGroundVehicleCommon(self,self.fileModel)
		end,
		OnContact = function(self,player)
	 		self:OnContactServer(player)
		end,
		OnBind = VC.OnBind,
		OnDamage = VC.OnDamageServer,
		OnCollide = VC.OnCollideServer,
		OnUpdate = function(self,dt)
			self:UpdateServer(dt)
		end,
		OnEvent = function(self,id,params)
			self:OnEventServer(id,params)
		end,
	},
	Inactive = {
	},
	Dead = {
		OnBeginState = function(self)
			VC.BlowUpServer(self)
		end,
		OnContact = function(self,player)
	 		VC.OnContactServerDead(self,player)
		end,
	},
}

function FWDVehicle:OnReset()
	self.bIsEnabled = self.Properties.bEnabled
	--	if (self.fEngineHealth < 100) then
	--	if (self.bExploded==1) then
	--		VC.InitGroundVehicleServer(self,self.fileModel)
	--	end
	VC.OnResetCommon(self)
	self.fEngineHealth = 100
	self:NetPresent(1)
	--System:Log("\001  FWDVehicle RESET------------------------------------------ ")
	VC.EveryoneOutForce(self)
	AI:RegisterWithAI(self.id,AIOBJECT_CAR,self.Properties,self.PropertiesInstance)
	VC.InitAnchors(self)
	VC.AIDriver(self,0)
	self.bExploded=false
	self.cnt:SetVehicleEngineHealth(self.fEngineHealth)
	self.dropState = 0
	self.step = self.Properties.pathstart - 1
	Sound:StopSound(self.drive_sound)
	VC.InitWindows(self)
	if (self.Properties.bSleeping==1) then
		self:AwakePhysics(0)
	end
end

function FWDVehicle:InitPhis()
	VC.InitGroundVehiclePhysics(self,self.fileModel)
end

function FWDVehicle:InitClient()
	if (self.Properties.bHasRockets==0) then
		self.ammoRL = 0
	end
	VC.InitSeats(self,FWDVehicle)
	-- PROTO: Load3DSound(szFilename,dwFlags,nVolume(0-255))
--	self.drive_sound = Sound:Load3DSound("sounds\\vehicle\\idle_loop.wav",0,200,7,100000)
	self.drive_sound_move = Sound:Load3DSound("sounds\\vehicle\\tire_rocks2.wav",0,200,13,300)
	self.maxvolume_speed = 35
	self.drive_sound_move_water = Sound:Load3DSound("sounds\\vehicle\\boat\\splashLP.wav",0,0,13,300)
	self.maxvolume_speed_water = 10
	self.ExplosionSound=Sound:Load3DSound("sounds\\explosions\\explosion2.wav",0,200,150,1000)
--	self.accelerate_sound = {
--		Sound:Load3DSound("sounds\\vehicle\\rev1.wav",0,0,7,200),
--		Sound:Load3DSound("sounds\\vehicle\\rev2.wav",0,0,7,200),
--		Sound:Load3DSound("sounds\\vehicle\\rev3.wav",0,0,7,200),
--		Sound:Load3DSound("sounds\\vehicle\\rev4.wav",0,0,7,200),
--	}
	self.break_sound = Sound:Load3DSound("sounds\\vehicle\\break1.wav",0,100,13,300)
	self.engine_start = Sound:Load3DSound("sounds\\vehicle\\HV\\hvstart.wav",0,255,13,300)
	self.engine_off = Sound:Load3DSound("sounds\\vehicle\\HV\\hvoff.wav",0,255,13,300)
	self.sliding_sound = Sound:Load3DSound("sounds\\vehicle\\break2.wav",0,150,13,300)

	-------------
--	self.gearup_sounds= {
--		Sound:Load3DSound("sounds\\vehicle\\HV\\hvlowspeedgeardown.wav",0,255,7,200),-- reverse up (0-1)
--		Sound:Load3DSound("sounds\\vehicle\\HV\\hvfirstaccel.wav",0,255,7,200),-- (1-2)
--		Sound:Load3DSound("sounds\\vehicle\\HV\\hvsecondaccel.wav",0,255,7,200),-- (2-3)
--	}
--
--	self.geardn_sounds={
--		Sound:Load3DSound("sounds\\vehicle\\HV\\hvfirstaccel.wav",0,255,7,200),-- reverse down (1-0)
--		Sound:Load3DSound("sounds\\vehicle\\HV\\hvlowspeedgeardown.wav",0,255,7,200),-- (2-1)
--		Sound:Load3DSound("sounds\\vehicle\\HV\\hvhighgeardown.wav",0,255,7,200),-- (3-2)
--	}
--
--	self.idle_sounds={
--		Sound:Load3DSound("sounds\\vehicle\\HV\\hvidle.wav",0,255,7,200),-- reverse idle (0)
--		Sound:Load3DSound("sounds\\vehicle\\HV\\hvidle.wav",0,255,7,200),-- engine idle (1)
--		Sound:Load3DSound("SOUNDS\\Vehicle\\HV\\hvfirstgearspeedidle.wav",0,255,7,200),-- (2)
--		Sound:Load3DSound("SOUNDS\\Vehicle\\HV\\hvsecondgearspeedidle.wav",0,255,7,200),-- (3)
--	}

	self.clutch_sound = Sound:Load3DSound("sounds\\vehicle\\vehicle_efx\\gearchange.wav",0,255,13,300)
	self.idleengine = Sound:Load3DSound("SOUNDS\\Vehicle\\HV\\hvidle.wav",0,255,13,300)
	self.idleengine_ratios = {1,1,1.25,1}
	self.clutchengine_frequencies = {1000,900,500,700}
	self.clutchfreqspeed = 12
	self.enginefreqspeed = 2
	self.land_sound = Sound:Load3DSound("sounds\\vehicle\\vehicle_efx\\carclunk.wav",0,255,13,300)
	--self.nogroundcontact_sound=Sound:Load3DSound("sounds\\vehicle\\HV\\hvfirstaccel.wav",0,255,7,200)
	-------------
--self.compression_sound_test = Sound:Load3DSound("sounds\\vehicle\\break1.wav",0,150,7,200)
--self.suspSoundTable[1] = Sound:Load3DSound("sounds\\vehicle\\break1.wav",0,150,7,200)
	self.suspSoundTable[1] = Sound:Load3DSound("sounds\\vehicle\\comp1.wav",0,150,7,200)
	self.suspSoundTable[2] = Sound:Load3DSound("sounds\\vehicle\\comp2.wav",0,150,7,200)
	self.suspSoundTable[3] = Sound:Load3DSound("sounds\\vehicle\\comp3.wav",0,150,7,200)
	self.suspSoundTable[4] = Sound:Load3DSound("sounds\\vehicle\\comp4.wav",0,150,7,200)
	self.crash_sound = Sound:Load3DSound("sounds\\vehicle\\carcrash.wav",0,200,13,300)
	self.light_sound = Sound:Load3DSound("SOUNDS/items/flight.wav",SOUND_UNSCALABLE,160,3,30)
	VC.InitGroundVehicleClient(self,self.fileModel)
--front_light
--fron_light_left front_light_right
--back_light_left back_light_right
--textures/lights/front_light
	self.cnt:InitLights("front_light","textures/lights/front_light",
			"front_light_left","front_light_right","humvee_frontlight",
			"back_light_left","back_light_right","humvee_backlight")
	self:InitWeapon()
end

function FWDVehicle:InitServer()
	if (self.Properties.bHasRockets==0) then
		self.ammoRL = 0
--		self.Ammo["VehicleRocket"] = nil
	end
	VC.InitSeats(self,FWDVehicle)
	VC.InitGroundVehicleServer(self,self.fileModel)
	self:OnReset()
--	self:EnableUpdate(1)
--	self.EnableSave(0)
	self:InitWeapon()
end

function FWDVehicle:OnContactServer(player)
	if (self.bIsEnabled==0) then return end
	if (self.Properties.bUsable==0) then return end
	if (VC.IsUnderWater(self)==1) then return end
	VC.OnContactServerT(self,player)
end

function FWDVehicle:OnContactClient(player)
	if (self.bIsEnabled==0) then
		Hud.label = self.Properties.DisabledMessage
		return
	end
	if (self.Properties.bUsable==0) then return end
	if (VC.IsUnderWater(self)==1) then return end
	VC.OnContactClientT(self,player)
end

function FWDVehicle:UpdateServer(dt)
	--filippo
	--VC.FunPhysics(self,dt)
	VC.UpdateEnteringLeaving(self,dt)
	VC.UpdateServerCommonT(self,dt)
	VC.UpdateWheelFriction(self)
	if (VC.IsUnderWater(self,dt)==1) then
		VC.EveryoneOutForce(self)
	end
end

function FWDVehicle:OnShutDown()
	-- Free resources
--	System:UnloadImage(self.DustParticles.tid)
	--assingning to nil is not really needed
	--if the entity will be destroyed
	self.break_sound=nil
	self.engine_start=nil
	self.engine_off=nil
	self.sliding_sound=nil
	self.drive_sound=nil
	self.drive_sound_move=nil
	self.accelerate_sound=nil
	VC.EveryoneOutForce(self)
	VC.RemovePieces(self)
	VC.RemoveWindows(self)
	if (self.wreck)	then
		Server:RemoveEntity(self.wreck.id,1)
	end
end

function FWDVehicle:OnSave(stm)
	stm:WriteInt(self.bIsEnabled)
	VC.SaveAmmo(self,stm)
--	VC.SaveCommon(self,stm)
	stm:WriteInt(self.fEngineHealth)
end

function FWDVehicle:OnLoad(stm)
	self.bIsEnabled = stm:ReadInt()
	VC.LoadAmmo(self,stm)
--	VC.LoadCommon(self,stm)
	self.fEngineHealth = stm:ReadInt()
end
 --this is called from vehicleProxy when all the saving is done
function FWDVehicle:OnSaveOverall(stm)
	VC.SaveCommon(self,stm)
end
 --this is called from vehicleProxy when all the loading is done and all the entities are spawn
function FWDVehicle:OnLoadOverall(stm)
	VC.LoadCommon(self,stm)
end

function FWDVehicle:OnEventServer(id,params)
--	if (id==ScriptEvent_Reset)
--	then
--		VC.EveryoneOutForce(self)
--		-- make the guy exit the vehicle
--	end
end

function FWDVehicle:DoEnter(puppet)
	System:Log("FWDVehicle:DoEnter "..self:GetName().."  "..puppet:GetName())
	if (puppet==self.driverT.entity) then		-- driver
		System:Log("FWDVehicle:DoEnter 1")
		VC.AddUserT(self,self.driverT)
--		self.driverDelay = 2
--		if (self.Properties.fStartDelay) then
--			self.driverDelay = self.Properties.fStartDelay
--		end
		VC.InitEntering(self,self.driverT)
	elseif (puppet==self.gunnerT.entity) then		-- gunner
		System:Log("FWDVehicle:DoEnter 2")
		VC.AddUserT(self,self.gunnerT)
		VC.InitEntering(self,self.gunnerT)
	else
		-- System:Log("FWDVehicle:DoEnter 3") 				-- passengers
		local tbl = VC.FindPassenger(self,puppet)
		if (not tbl) then return end
		VC.AddUserT(self,tbl)
		VC.InitEntering(self,tbl)
		System:Log("FWDVehicle:DoEnter 3")
	end
end

function FWDVehicle:AddDriver(puppet)
	--do return 0 end
	if self.driverT.entity or not puppet then	-- already have a driver
		do return 0 end
	end
	--System:Log("FWDVehicle:AddDriver")
	if (self.Properties.sDriverName~="" and self.Properties.sDriverName~=puppet:GetName()) then return 0 end
	--	self.driver = puppet
	self.driverT.entity = puppet
	if (VC.InitApproach(self,self.driverT)==0) then
	--System:Log("FWDVehicle:AddDriver  1")
		self:DoEnter(puppet)
	end
	do return 1 end
end

function FWDVehicle:AddGunner(puppet)
	if self.gunnerT.entity or not puppet then	-- already have a gunner -- Добавил or not puppet. Когда кого-то пытается посадить за оружие при загрузке уровня, но его сущности почему-то нет.
		do return 0 end
	end
--System:Log("entering gunner ---------------------------------------------------")
	self.gunnerT.entity = puppet
	if (VC.InitApproach(self,self.gunnerT)==0) then
		self:DoEnter(puppet)
	end
	do return 1 end
end

function FWDVehicle:AddPassenger(puppet)
--do return 0 end
	local pasTbl = VC.CanAddPassenger(self,1)
	if not pasTbl or not puppet then return 0 end	-- no more passangers can be entered
	pasTbl.entity = puppet
	if (VC.InitApproach(self,pasTbl)==0) then
		self:DoEnter(puppet)
	end
	do return 1 end
end

function FWDVehicle:OnWrite(stm)
--	if (self.driver) then
--		stm:WriteInt(self.driver.id)
--	else
--		stm:WriteInt(0)
--	end
--	if (self.passenger) then
--		stm:WriteInt(self.passenger.id)
--	else
--		stm:WriteInt(0)
--	end
end

function FWDVehicle:OnRead(stm)
--local	id=0
--
--
--	id = stm:ReadInt()
--	if (id~=0) then
--		self.driver = System:GetEntity(id)
--	else
----		self.driverP = self.driver
--		self.driver = nil
--	end
--
--	id = stm:ReadInt()
--	if (id~=0) then
--		self.passenger = System:GetEntity(id)
--	else
--		self.passenger = nil
--	end
end

function FWDVehicle:Event_EveryoneOut()
	VC.DropPeople(self)
end

function FWDVehicle:Event_AIDriverIn()
	if (VC.FreeToUse(self)==0) then return end	-- can't use it - player is in
	VC.AIDriver(self,1)
end

function FWDVehicle:Event_AIDriverOut()
	if (VC.FreeToUse(self)==0) then return end	-- can't use it - player is in
	VC.AIDriver(self,0)
end

function FWDVehicle:RadioChatter()
end

function FWDVehicle:LoadPeople()
	if (VC.FreeToUse(self)==0) then return end	-- can't use it - player is in
--	self:AIDriver(1)
--System:Log("humvee LoadPeople  ")
	if self.driverT.entity and self.driverT.entity.ai  then
--System:Log("FWDVehicle LoadPeople  DRIVER IN ")
		AI:Signal(0,1,"DRIVER_IN",self.id)
	end
--System:Log("FWDVehicle LoadPeople loading")
	if (self.Properties.bSameGroupId==1) then
		AI:Signal(SIGNALFILTER_GROUPONLY,-1,"WakeUp",self.id)
		AI:Signal(SIGNALFILTER_GROUPONLY,-1,"WakeUp2",self.id)
		AI:Signal(SIGNALFILTER_GROUPONLY,1,"SHARED_ENTER_ME_VEHICLE",self.id)
	else
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,-1,"WakeUp",self.id)
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,-1,"WakeUp2",self.id)
		AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"SHARED_ENTER_ME_VEHICLE",self.id)
	end
	self.dropState = 1
end

function FWDVehicle:DropPeople()
	VC.DropPeople(self)
end

function FWDVehicle:DropDriver()
	VC.DropDriver(self)
end

function FWDVehicle:DropGunner()
	VC.DropGunner(self)
end

function FWDVehicle:DropPassengers()
	VC.DropPassengers(self)
end

--	to test-call reinf
function FWDVehicle:Event_Reinforcment(params)
--printf("signaling BRING_REINFORCMENT ")
	if (VC.FreeToUse(self)==0) then return end	-- can't use it - player is in
	VC.AIDriver(self,1)
	AI:Signal(0,1,"BRING_REINFORCMENT",self.id)
end

function FWDVehicle:Event_GoPatrol(params)
--System:Log("\001  FWDVehicle GoPath  ")
	if (VC.FreeToUse(self)==0) then return end	-- can't use it - player is in
	VC.AIDriver(self,1)
	AI:Signal(0,1,"GO_PATROL",self.id)
end

function FWDVehicle:Event_GoChase(params)
--System:Log("\001  FWDVehicle GoPath  ")
	if (VC.FreeToUse(self)==0) then return end	-- can't use it - player is in
	VC.AIDriver(self,1)
	AI:Signal(0,1,"GO_CHASE",self.id)
end
--
function FWDVehicle:Event_KillTriger(params)
	self.cnt:SetVehicleEngineHealth(0)
	self:GotoState("Dead")
--	self.fEngineHealth = 0
end
-- to test
function FWDVehicle:Event_Grenade(params)
--System:Log("\001  FWDVehicle GoPath  ")
	AI:Signal(0,1,"OnGrenadeSeen",self.id)
end

function FWDVehicle:Event_GoPath(params)
--System:Log("\001  FWDVehicle GoPath  ")
	if (VC.FreeToUse(self)==0) then return end	-- can't use it - player is in
	VC.AIDriver(self,1)
	AI:Signal(0,1,"GO_PATH",self.id)
end

function FWDVehicle:Event_PausePath(params)
--System:Log("\001  FWDVehicle PausePath  ")
--	AI:Signal(0,1,"EVERYONE_OUT",self.id)
	AI:Signal(0,1,"DRIVER_OUT",	self.id)
end

function FWDVehicle:Event_LoadPeople(params)
--	VC.AIDriver(self,1)
	self:LoadPeople()
end

-- function FWDVehicle:Event_LoadPeople2(params)
-- --	VC.AIDriver(self,1)
	-- self:LoadPeople2()
-- end

function FWDVehicle:LoadPeople2()
	if self.driverT.entity and self.driverT.entity.ai  then
		AI:Signal(0,1,"DRIVER_IN",self.id)
	end
	AI:Signal(SIGNALFILTER_GROUPONLY,-1,"WakeUp",self.id)
	AI:Signal(SIGNALFILTER_GROUPONLY,-1,"WakeUp2",self.id)
	AI:Signal(SIGNALFILTER_GROUPONLY,1,"SHARED_ENTER_ME_VEHICLE",self.id)
	self.dropState = 1
	self.Properties.bUsePathfind=1
	self.Properties.bUsable=1
	self.Properties.bLockUser=0
end
--	to test-call reinf
function FWDVehicle:Event_MakePlayerGunner(params)
--printf("signaling BRING_REINFORCMENT ")
--System:Log(" n ")
	self:AddGunner(_localplayer)
end

function FWDVehicle:Event_Wakeup(params)
	self:AwakePhysics(1)
end

function FWDVehicle:Event_EnableFWDVehicle(params)
	self.bIsEnabled = 1
end

function FWDVehicle:Event_DisableFWDVehicle(params)
	self.bIsEnabled = 0
end

function FWDVehicle:Event_DriverIn(params)
	BroadcastEvent(self,"DriverIn")
end

function FWDVehicle:Event_AIEntered(params)
	BroadcastEvent(self,"AIEntered")
end

function FWDVehicle:Event_PlayerEntered(params)
	BroadcastEvent(self,"PlayerEntered")
end

function FWDVehicle:Event_PathEnd(params)
	BroadcastEvent(self,"PathEnd")
end

function FWDVehicle:Event_Activate(params)
	if (self.bExploded==1) then return end
	self:GotoState("Alive")
end

function FWDVehicle:Event_Hide(params) --было закомментировано
	self:Hide(1)
end

function FWDVehicle:Event_Unhide(params)
	self:Hide(0)
end
-- empty function to get reed of script error - it's called from behavours
function FWDVehicle:MakeAlerted()
end

function FWDVehicle:InitWeapon()
	-- m_MinVAngle,m_MaxVAngle,m_MinHAngle,m_MaxHAngle
--	self.cnt:SetWeaponLimits(-90,20,0,0)
--	self.cnt:SetWeaponLimits(-90,10,-120,120)
	self.cnt:SetWeaponLimits(-60,7,0,0)  --	self.cnt:SetWeaponLimits(-60,7,0,0)
--	self.cnt:SetWeaponName("VehicleMountedRocket","MG")
--	self.cnt:SetWeaponName("VehicleMountedRocket","VehicleMountedMG")
	--self.cnt:SetWeaponName("VehicleMountedRocketMG","VehicleMountedMG")  --
	if (self.Properties.bUseRL==1) then
		if (self.Properties.bUseRLguided==1) then
			self.cnt:SetWeaponName("VehicleMountedRocketMG","COVERRL")
		else
			self.cnt:SetWeaponName("VehicleMountedRocketMG","VehicleMountedRocket")
		end
	else
		self.cnt:SetWeaponName("VehicleMountedRocketMG","VehicleMountedMG")
	end
	VC.InitAutoWeapon(self)
	self.driverShooting = 1
--	self.Ammo = {}
--	self.Ammo["VehicleMG"] = 500
--	self.Ammo["VehicleRocket"] = 30
end
