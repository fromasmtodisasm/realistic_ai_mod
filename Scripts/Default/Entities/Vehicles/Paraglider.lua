

Paraglider = {

	bNoImpuls=1,
	
	bParaglider=1,
	CanShoot = 1,	-- player can shoot from his veapon while driving this vehicle - 
			-- don't change action map to vehicle when entering

	fileModelDead = "objects/Vehicles/glider/glider.cgf",
	
	userCounter = 0,
	driverWaiting = 0,
	driverDelay = 0,
	passengerLimit = 0,
	
	messageTime=0,
	
	-- previous state on the client before entering the vehicle
	bDriverInTheVehicle = 0,
	-- previous driver on the client before leaving the vehicle
	pPreviousDriver=nil,
	-- previous passenger state on the client before entering the vehicle
	bPassengerInTheVehicle = 0,
	-- previous passenger on the client before leaving the vehicle
	pPreviousPassenger=nil,

	IsPhisicalized = 0,	
	
	-- [kirill] vehicle gets different damage depending on who's shooter
	-- defines the intensity of the damage caused by the weapons to
	-- the vehicle	
	
	--
	DamageParams = {
		fDmgScaleAIBullet = 0.01,
		fDmgScaleAIExplosion = 0.7,
		fDmgScaleBullet = 0.01,
		fDmgScaleExplosion = 1.1,
	},
		
	--szNormalModel="objects/Vehicles/zodiacraft/zodiacraft.cgf",
	szNormalModel="objects/Vehicles/glider/glider.cgf",

	PropertiesInstance = {
		sightrange = 180,
		soundrange = 10,	-- rememeber that sound ranges intersect and sound range for AI doubles when in alert
		aibehavior_behaviour = "Boat_idle",		
		groupid = 154,
	},

	Properties = {		
		bTrackable=1,

		--fileName = "objects/Vehicles/zodiacraft/zodiacraft.cgf",			
		fileName = "objects/Vehicles/glider/glider.cgf",
		
		bUserPassanger = 0,
		bDrawDriver = 0,
		damping = 0.1,
		water_damping = 1.5,
		water_resistance = 0,
		fLimitLRAngles = 150,
		fLimitUDMinAngles = -45,
		fLimitUDMaxAngles = 40,
				
	},

	boat_params={
		Damprot	 	= 25,	--turning dump
		Dampv		= 30,	--movement dump
		Dampvs		= 100,	--
		Dampvh		= 100,	--
		Dampw		= 20,	--waves dump
		Turn		= 30,		
		--Speedv		= 5000,
		Speedv		= 500,		
		Speedturnmin	= 2,
		WaveM		= 500,	--fake waves momentum
		Stand		= 30,	-- forsing to normal vertical position impuls
		TiltTurn	= 5,	--tilt momentum when turning		
		
		TiltSpd		= 3,	--tilt momentum when speeding up
		TiltSpdA	= 0.06,	--tilt momentum when speeding up (acceleration thrhld)
		TiltSpdMinV	= 10.0,	--tilt momentum when speeding up (min speed to tilt when not accelerating)
		TiltSpdMinVTilt	= 0.37,	--tilt momentum when speeding up (how much to tilt when not accelerating)
		
		DownRate 	= 110,	
		BackUpRate 	= 900,
		BackUpSlowDwnRate=120.3,
		UpSpeedThrhld 	= 6,
		
		fMass 		= 100,
		Flying		= 1,
	},


--	boat_params={
--		Damprot	 	= 25,	--turning dump		
--		Dampv		= 30,	--movement dump
--		Dampvs		= 100,	--
--		Dampvh		= 100,	--
--		Dampw		= 20,	--waves dump
--		Turn		= 60,				
--		--Speedv		= 5000,		
--		Speedv		= 200,		
--		Speedturnmin	= 2,
--		WaveM		= 500,	--fake waves momentum
--		Stand		= 30,	-- forsing to normal vertical position impuls
--		TiltTurn	= 15,	--tilt momentum when turning		
--		
--		TiltSpd		= 3,	--tilt momentum when speeding up
--		TiltSpdA	= 0.06,	--tilt momentum when speeding up (acceleration thrhld)
--		TiltSpdMinV	= 10.0,	--tilt momentum when speeding up (min speed to tilt when not accelerating)
--		TiltSpdMinVTilt	= 0.37,	--tilt momentum when speeding up (how much to tilt when not accelerating)
--		
--		fMass 		= 100,
--		Flying		= 1,
--	},


	
	sound_time = 0,
		
	bExploded=false,

	-- engine health, status of the vehicle
	-- default is set to maximum (1.0f)
	fEngineHealth = 1.0,

	-- damage inflicted to the vehicle when it collides
	fOnCollideDamage=0,

	-- damage inflicted to the vehicle when it collides with terrain (falls off)
	fOnCollideGroundDamage=3,

	bGroundVehicle=0,

	driverT = {
		type = PVS_DRIVER,	-- not to switch action map to "vehicle"
	
		helper = "driver",
		in_helper = "driver_sit_pos",
		sit_anim = "glider_driver_sit",	-- "vzsittingd",
		anchor = AIAnchor.AIANCHOR_BOATENTER_SPOT,
		out_ang = -90,
		message = "@driverparaglider",
		timePast=0,
		HS=0,	-- used for fake jump arch calculatio - arch scale
		HK=0,	-- used for fake jump arch calculatio
		HO=0,	-- used for fake jump arch calculatio	
		HT=0,	-- used for fake jump arch calculatio
	},
}

VC.CreateVehicle(Paraglider);

--////////////////////////////////////////////////////////////////////////////////////////
function Paraglider:OnReset()
	VC.OnResetCommon(self);

	self:NetPresent(1);

	VC.EveryoneOutForce(self);
	--VC.ReleaseDriver(self);
	--self:PassengerOut();

	self.fEngineHealth = 1.0;
	self.bExploded=false;
	self.cnt:SetVehicleEngineHealth(self.fEngineHealth);	
end

--////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////
--// CLIENT functions definitions
--////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////
Paraglider.Client = {
	OnInit = function(self)
		--System:Log("CLIENT Paraglider onInit");
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
	
	OnBind = VC.OnBind,	
}

--////////////////////////////////////////////////////////////////////////////////////////
function Paraglider:OnInitClient()
	VC.InitSeats(self, Paraglider);

	--// load sounds on client only 
	--////////////////////////////////////////////////////////////////////////////////////////
	
	--self.ExplosionSound=Sound:Load3DSound("sounds\\weapons\\explosions\\mbarrel.wav",0,0,7,100000);

	self.drive_sound = Sound:Load3DSound("sounds\\Ambient\\E3\\whistlewindLP.wav",0,175,7,1000);
	self.drive_sound_move = Sound:Load3DSound("sounds\\jungle\\silence.wav",0,0,7,100);

	self.accelerate_sound = {
		Sound:Load3DSound("sounds\\vehicle\\rev1.wav",0,0,7,100000),
		Sound:Load3DSound("sounds\\vehicle\\rev2.wav",0,0,7,100000),
		Sound:Load3DSound("sounds\\vehicle\\rev3.wav",0,0,7,100000),
		Sound:Load3DSound("sounds\\vehicle\\rev4.wav",0,0,7,100000),
	};

	self.break_sound = Sound:Load3DSound("sounds\\vehicle\\break1.wav",0,0,7,100000);
	self.engine_start = Sound:Load3DSound("sounds\\vehicle\\boat\\zod_start.wav",0,0,7,100000);
	self.engine_off = Sound:Load3DSound("sounds\\vehicle\\boat\\zod_off.wav",0,0,7,100000);
	self.sliding_sound = Sound:Load3DSound("sounds\\vehicle\\break2.wav",0,0,7,100000);

	self.crash_sound = Sound:Load3DSound("sounds\\vehicle\\boat\\rubber.wav",0,0,7,100000);

	-- init common stuff for client and server
	VC.InitBoatCommon(self,self.szNormalModel);

end

--////////////////////////////////////////////////////////////////////////////////////////
function Paraglider:UpdateClient(dt)

	VC.PlayEngineOnOffSounds(self);

	-- plays the sounds, using a timestep of 0.04 		

	self.sound_time = self.sound_time + dt;
	if ( self.sound_time > 0.04 ) then		
		
		-- reset timer
		self.sound_time = 0;

		-- get vehicle's velocity
		local fCarSpeed = self.cnt:GetVehicleVelocity();
		
		VC.PlayDrivingSounds(self,fCarSpeed);

	end

	if(self.messageTime<0) then
		self.messageTime = self.messageTime + dt;
		if(self.driverT.entity == _localplayer ) then
			Hud.label = "@switchviewPara";
--			Hud.label = "press F1 to switch the view";			
		end	
	end
end

--////////////////////////////////////////////////////////////////////////////////////////
function Paraglider:OnContactClient( player )

	--VC.OnContactBoatClient(self,player);	
	VC.OnContactClientT(self,player);
end

--////////////////////////////////////////////////////////////////////////////////////////
function Paraglider:DoParticles(dt)

	--VC.CreateWaterParticles(self);

end


--////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////
--// SERVER functions definitions
--////////////////////////////////////////////////////////////////////////////////////////
--////////////////////////////////////////////////////////////////////////////////////////
Paraglider.Server = {
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
		self:OnDamageClient(hit);
	end,
}

--////////////////////////////////////////////////////////////////////////////////////////
function Paraglider:OnInitServer()
	VC.InitSeats(self, Paraglider);

	-- init common stuff for client and server
	VC.InitBoatCommon(self,self.szNormalModel);

	self:OnReset();
end

-- called on the server when the player collides with the Paraglider
--////////////////////////////////////////////////////////////////////////////////////////
function Paraglider:OnContactServer( collider )

	if(self.driverT.entity) then

		if(collider~=self.driverT.entity) then -- collided with something - fall down
			VC.EveryoneOutForce(self);
		end	
		return
	end

	if(VC.OnContactServerT(self,collider) == 1) then
		local startPos = self:GetPos();
		startPos.z = startPos.z+4;
		self:SetPos( startPos );
		local startAng = self:GetAngles();
		startAng.x=0;
		startAng.y=0;
		self:SetAngles( startAng );
--		Game:SetThirdPerson(1);
		
		self.messageTime = -10;
		
		local	baseAngles={x=0,y=0,z=180};
		collider.cnt:SetAngleLimitBase(baseAngles);
		collider.cnt:SetMaxAngleLimitH(130);
		collider.cnt:SetMinAngleLimitH(-130);
		collider.cnt:EnableAngleLimitH( 1 );
		
		
	end
end


--////////////////////////////////////////////////////////////////////////////////////////
function Paraglider:UpdateServer(dt)

--System:Log("\004 Paraglider:UpdateServer");

	VC.UpdateServerCommonT(self,dt);

	if( self.driverT.entity ) then
		local pos=self:GetPos();
		pos.z = pos.z-2;
		if (Game:IsPointInWater(pos) ~= nil) then	-- stop flying - landing on water
			VC.EveryoneOutForce(self);
		end
	end
end


--////////////////////////////////////////////////////////////////////////////////////////
function Paraglider:OnEventServer( id, params)
end


--////////////////////////////////////////////////////////////////////////////////////////
function Paraglider:OnDamageClient(hit)

--	VC.OnDamageClient(self,hit);
	
end

--////////////////////////////////////////////////////////////////////////////////////////
function Paraglider:OnDamageServer(hit)

	VC.OnDamageServer(self,hit);	
end

--////////////////////////////////////////////////////////////////////////////////////////
function Paraglider:OnCollide(hit)
	VC.OnCollideClient(self,hit);	
	
	if (hit.fSpeed > .1) then	
		VC.EveryoneOutForce(self);
	end	

end

--////////////////////////////////////////////////////////////////////////////////////////
function Paraglider:OnShutDown()

	VC.EveryoneOutForce(self);
	--VC.ReleaseDriver(self);
	--self:PassengerOut();
end


----------------------------------------------------------------------------------------------------------------------------
--
--
function Paraglider:OnEventServer( id, params)

	if (id == ScriptEvent_Reset)
	then
		-- make the guy exit the vehicle
		self:OnShutDown();
	end
end


--////////////////////////////////////////////////////////////////////////////////////////
function Paraglider:OnSave(stm)
end

--////////////////////////////////////////////////////////////////////////////////////////
function Paraglider:OnLoad(stm)
end


--////////////////////////////////////////////////////////////////////////////////////////
function Paraglider:OnWrite( stm )	
end

--////////////////////////////////////////////////////////////////////////////////////////
function Paraglider:OnRead( stm )
end

----------------------------------------------------------------------------------------------------------------------------
--
function Paraglider:Event_DriverIn( params )

	BroadcastEvent( self,"DriverIn" );
	
	if( self.driverT.entity == _localplayer ) then
		local	baseAngles={x=0,y=0,z=180};
		_localplayer.cnt:SetAngleLimitBase(baseAngles);
		_localplayer.cnt:SetMaxAngleLimitH(130);
		_localplayer.cnt:SetMinAngleLimitH(-130);
		_localplayer.cnt:EnableAngleLimitH( 1 );
	end	
end	


--------------------------------------------------------------------------------------------------------
-- empty function to get reed of script error - it's called from behavours
function Paraglider:MakeAlerted()
end


--------------------------------------------------------------------------------------------------------------
