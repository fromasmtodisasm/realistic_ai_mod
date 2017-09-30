------------------------------------------------------------------------------------------------
--
--	flyingFox entity - transports player from it's original position to TagPoint with name set in
--	Properties.destination
--	
--	created by Kirill
--
FlyingFox = {
	name = "FlyingFox",

	Properties = {
		destination = "FlyWire",	
		fileModel = "Objects/Buildings/M03/compound_area/flyingfox_seat.cgf",
		velocity = .3,
		acceleration = .01,
		fLimitLRAngles = 200,
		bEnabled = 1,
		message = "@drivefox",--"Press USE to use FlyingFox",
	},

	Editor={
		Model="Objects/Editor/arrow.cgf",
	},

	user = nil,	

	curVelocity = 0,

	noReleaseTime = 0,
	
	curDist = -1,
	startPos = {x=0, y=0, z=0},
	savedPos = nil,
	destPos = {x=0, y=0, z=0},
	curPos = {x=0, y=0, z=0},
	direction = {x=0, y=0, z=0},
--	time2Travel = 0,	

	movingSound = Sound:Load3DSound("sounds\\player\\zipline.wav",0,255,15,30);
}


----------------------------------------------------------------------------------------------------------------------------
--
--
function FlyingFox:OnReset()

	local min = {x=-1, y=-1, z=-3};
	local max = {x=.2, y=1, z=1};	
	self:SetBBox(min, max);
	
--	self.LoadObject("Objects/Vehicles/V-22/Rope/FlyingFox.cgf", 0, 0);
--	self:LoadCharacter(self.Properties.fileModel, 0 );

--System:LogToConsole( "Loading the object ".. self.Properties.fileModel );

	self:LoadObject(self.Properties.fileModel, 0, 1);
	self:DrawObject(0,1);
	self.IsPhisicalized = 1;
	self:RenderShadow( 0 );

	self:GotoState("Inactive");
	
end
----------------------------------------------------------------------------------------------------------------------------
--
--
function FlyingFox:OnPropertyChange()

	self:OnReset();
	
end 

------------------------------------------------------------------------------------------------------
function FlyingFox:CliSrv_OnInit()

--	self:SetName( self.name );

	self.startPos = new( self:GetPos() );
	self.curPos = new( self:GetPos() );
	
	self:OnReset();

	self:RegisterState("Inactive");
	self:RegisterState("Active");
--	self:RegisterWithAI(AIAnchor.AIOBJECT_FLYING_FOX);	
	AI:RegisterWithAI(self.id, AIAnchor.AIOBJECT_FLYING_FOX);		
end


------------------------------------------------------------------------------------------------------
function FlyingFox:SetUser(  player  )

--System:Log( "FlyingFox:SetUser ");

	-- Bind the player self
	-- do the rest in OnBind	
	self:Bind(player);

end

function FlyingFox:OnBindCommon( player, table_id )


	if( self.user ) then return 0; end

--System:Log( "FlyingFox:OnBind 1");
	local pos={x=0, y=0, z=0};

	local	baseAngles={x=0,y=0,z=180};
	player:SetAngles( baseAngles );	

	pos=self:GetHelperPos("player_pos",1);
	
	--if there is no helper shift the position donw of 2.5 m
	if (pos.z+pos.y+pos.z == 0) then
		pos.z = pos.z - 2.5;
	end

	player:SetPos( pos );

	if(self.Properties.fLimitLRAngles<180 and self.Properties.fLimitLRAngles>0) then
		player.cnt:SetAngleLimitBase(baseAngles);
		player.cnt:SetMaxAngleLimitH(self.Properties.fLimitLRAngles);
		player.cnt:SetMinAngleLimitH(-self.Properties.fLimitLRAngles);
		player.cnt:EnableAngleLimitH( 1 );
	end
	self.user = player;

	--fixme - physics is deactivated on CEntity::OnBindAI
	self.user:ActivatePhysics(1);

	self:GotoState("Active");

	return 1;
end

------------------------------------------------------------------------------------------------------
function FlyingFox:ReleaseUser(  )

	if( self.user == nil ) then return end
	
	self.user.cnt:EnableAngleLimitH( 0 );	
	self:Unbind(self.user);
	
	self.user = nil;
	
end

------------------------------------------------------------------------------------------------------
function FlyingFox:OnContactInactiveServer( player )

	if( player.type ~= "Player" ) then return end
	if( self.user	) then return end
	if( self.Properties.bEnabled==0 ) then return end

--System:Log( "\001 Contact  ----------------------------------- "..player.type );

	if(player.cnt.use_pressed) then
		player.cnt.use_pressed = nil;
		
--System:Log( "\001 StaringUsing ");
		self:SetUser( player );

		self.noReleaseTime = 1;

	end
end


------------------------------------------------------------------------------------------------------
function FlyingFox:OnContactInactiveClient( collider )

	if(collider.type ~= "Player" ) then return end
	if( self.user	) then return end
	if( self.Properties.bEnabled==0 ) then return end

	if( collider == _localplayer ) then
		Hud.label = self.Properties.message;
	else
		AI:FreeSignal(1, "USE_FLYWIRE", self:GetPos(), 2);
	end	

end

------------------------------------------------------------------------------------------------------
function FlyingFox:OnUpdateActiveServer( dt )


--System:Log("FlyingFox:OnUpdateActiveServer");

	self.curVelocity = self.curVelocity + dt*self.Properties.acceleration;

	FastSumVectors( self.curPos, self.curPos, ScaleVector( self.direction, self.curVelocity ) );
	
	self:SetPos( self.curPos );
	
	if (self.user == _localplayer ) then
		Hud.label = self.Properties.message;
	end

	local dist = LengthSqVector( DifferenceVectors( self.curPos, self.destPos ) );


	if(self.noReleaseTime>0) then	-- delay coz of use_pressed is buffered
		self.user.cnt.use_pressed = nil;
		self.noReleaseTime = self.noReleaseTime - dt;
	end	

	if( self.user.cnt.use_pressed or self.user.cnt.health<=0 ) then	-- user pressed use to release or user is dead
		self.user.cnt.use_pressed = nil;
		self:GotoState("Inactive");
	elseif( dist < 1 or (self.curDist>0 and self.curDist<dist) ) then		-- close enough OR going away from destination - probably passed it. Stop now
		self:GotoState("Inactive");
	end	
	
--System:Log("FlyingFox:OnUpdateActiveServer >>> "..dist);	
	
	self.curDist = dist;
end

function FlyingFox:OnUpdateActiveClient(dt)

	if (Sound:IsPlaying(self.movingSound)~=1) then
		self:PlaySound(self.movingSound);
	end
end


------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
--
--
function FlyingFox:OnShutDown()

	self:ReleaseUser();

end



----------------------------------------------------------------------------------------------------------------------------
--
-- to test
function FlyingFox:Event_Use( params )

--System:Log("\001  Humvee GoPath  ");

	AI:FreeSignal(1, "SHARED_USE_ME_FLYWIRE", self:GetPos(), 50);

end


----------------------------------------------------------------------------------------------------------------------------
--
-- to test
function FlyingFox:Event_Enable( params )

--System:Log("\001  Humvee GoPath  ");
	
	self.Properties.bEnabled=1;

end


----------------------------------------------------------------------------------------------------------------------------
--
--



FlyingFox.Server={
	OnInit=function(self)
		self:CliSrv_OnInit()
	end,
	OnShutDown=function(self)
	end,

	Inactive={
		OnBeginState=function(self)
			self:ReleaseUser();
			if( self.savedPos ) then
				self:SetPos(self.savedPos);
			else
				self:SetPos(self.startPos);
			end
			CopyVector( self.curPos, self.startPos);
			
--System:Log("\001<<<<<<<<<<<<<<<<<<<<<<<<<<<< FlyingFox Entering INACTIVE");			
		end,
		OnContact = FlyingFox.OnContactInactiveServer,
	},
	Active={
		OnBeginState=function(self)

			self.curDist = -1;
			CopyVector( self.destPos, Game:GetTagPoint( self.Properties.destination ));
			if( self.destPos == nil ) then
				self.destPos = {x=0, y=0, z=0};
				System:Error("FlyingFox: can't find destiination point. Using (0,0,0)");
			end

--			FastDifferenceVectors( self.direction, self.destPos, self.startPos );
						
			self.direction.x = self.destPos.x - self.startPos.x;
			self.direction.y = self.destPos.y - self.startPos.y;
			self.direction.z = self.destPos.z - self.startPos.z;
			
			NormalizeVector( self.direction );

--			self.curPos = new(self:GetPos());
			CopyVector( self.curPos, self:GetPos() );
			
			self.curVelocity = self.Properties.velocity;
--System:Log("\001<<<<<<<<<<<<<<<<<<<<<<<<<<<<  FlyingFox Entering ACTIVE");
		end,
		OnUpdate = FlyingFox.OnUpdateActiveServer,
	},
}


FlyingFox.Client={
	OnInit=function(self)
		self:CliSrv_OnInit()
	end,
	OnShutDown=function(self)
	end,

	Inactive={
		OnContact = FlyingFox.OnContactInactiveClient,		
		OnBind = FlyingFox.OnBindCommon,
	},
	Active={
		OnUpdate = FlyingFox.OnUpdateActiveClient,
		OnBind = FlyingFox.OnBindCommon,
	},
}


----------------------------------------------------------------------------------------------------------------------------
--
--

function FlyingFox:OnSave( stm )
	
	stm:WriteFloat(self.curVelocity);	
	stm:WriteFloat(self.noReleaseTime);
	
	if( self.savedPos ) then
		stm:WriteFloat(self.savedPos.x);
		stm:WriteFloat(self.savedPos.y);
		stm:WriteFloat(self.savedPos.z);
	else
		stm:WriteFloat(self.startPos.x);
		stm:WriteFloat(self.startPos.y);
		stm:WriteFloat(self.startPos.z);
	end
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function FlyingFox:OnLoad( stm )

	self.curVelocity = stm:ReadFloat( );
	self.noReleaseTime = stm:ReadFloat( );

	self.savedPos = new( self:GetPos() );	

	self.savedPos.x = stm:ReadFloat( );
	self.savedPos.y = stm:ReadFloat( );	
	self.savedPos.z = stm:ReadFloat( );	
end


function FlyingFox:OnLoadRELEASE( stm )
end

----------------------------------------------------------------------------------------------------------------------------
--
--

