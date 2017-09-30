--[kirill]
-- helper entity - to be used as wreck for destroyed vehicles
--

--filippo: store the splash sound just once.
PieceShared = {
	SplashSound = Sound:Load3DSound("sounds/player/water/watersplash.wav", 0, 255, 50, 300),
}

Piece = {
	name = "Piece",

	isActive = 0,
	isTouching = 0,
	lastPoint = {x=0,y=0,z=0},

	SimParams = {

--		density = 1100,
--		water_density = 1000,

		-- 
		density = 300,
		water_density = 200,
--		density = 200,
--		water_density = 295,

		
		damping = 0.1,
		water_damping = 1.5,
		water_resistance = 500,--0,
		max_time_step = 0.02,
		sleep_speed = 0.1,
	},

	PieceParticlesBubbles = {--underwater bubbles for sank pieces
		focus = 0.0,
		speed = 0.25,
		count = 10,
		size = 0.05, size_speed=0.0,
		start_color = {1,1,1},
		gravity = { x = 0.0, y = 0.0, z = 2.6 },
		lifetime=2.5,
		tid = System:LoadTexture("textures\\bubble.tga"),
		frames=0,
		},
	PieceParticlesVapor = {--underwater vapor for sank pieces
		focus = 20.0,
		speed = 2,
		count = 1,
		size = 0.6, size_speed=2.5,
		gravity={x=1,y=0.0,z=2.0},
		rotation={x=0.0,y=0.0,z=1.0},
		lifetime=2,
		turbulence_size=0.62,
		turbulence_speed=5,
		tid = System:LoadTexture("textures/clouda2.dds"),
		start_color = {1,1,1},
		frames=0,

	},

	DeadEffect = "fire.burning_after_explosion.a",
	DeadEffectMinor = "smoke.black_smoke.a",
	part_update_freq = 100,
	piece_idx = 0,
	fileName = nil,
	
	emtrPos = {x=0,y=0,z=0},
	
	
	PropertiesInstance = {
		sightrange = 0,
		soundrange = 0,	-- rememeber that sound ranges intersect and sound range for AI doubles when in alert
		aibehavior_behaviour = "Car_idle",		
		groupid = 0,
	},
	Properties = {		
		bTrackable=0,
		aggression = 1.0,
		commrange = 0.0,
		cohesion = 5,
		attackrange = 0,
		horizontal_fov = 0,
		eye_height = 2.1,
		forward_speed = 1,
--		back_speed = 3,
		responsiveness = 7,
		species = 1,
		fSpeciesHostility = 2,
		fGroupHostility = 0,
		fPersistence = 0,
		aicharacter_character = "FWDVehicle",
	},
	
	SplashSound = PieceShared.SplashSound,
	splashed = 0,
}

------------------------------------------------------------------------------------------------------
function Piece:OnInit()

	self:SetName( self.name );

	self:EnableSave(0);
	self:EnableUpdate( 0 );
	self.UpdateCounter = 0;

	self:LoadObject("Objects/default.cgf",0,1);
	self:CreateRigidBody( 1, 0, 0 );
	self:SetPhysicParams(PHYSICPARAM_SIMULATION, self.SimParams );
	self:SetPhysicParams(PHYSICPARAM_BUOYANCY, self.SimParams);
	self:EnablePhysics( 0 );
end


------------------------------------------------------------------------------------------------------
function Piece:Load( fileName, pieceIdx )
		if (fileName == "") then
			return 0;
		end

		if(self:LoadObjectPiece(fileName, pieceIdx )~=1) then
			return 0;
		end	
		self.piece_idx=pieceIdx;
		self.fileName = fileName;
--	self.CreateStaicEntity();
		self:CreateRigidBodyPiece( 1, 0, 0 );
--		self.CreateRigidBody( 0, 100, 0 );
--		self.CreateStaticEntity( 100, 0 );
		self:SetPhysicParams(PHYSICPARAM_SIMULATION, self.SimParams );
		self:SetPhysicParams(PHYSICPARAM_BUOYANCY, self.SimParams);
		self:EnablePhysics( 0 );
		self:DrawObject(0,0);
--		self.DrawObject(1,0);

		self.isActive = 0;
--	self.RenderShadow( 0 );
		return 1;
	
end



------------------------------------------------------------------------------------------------------
function Piece:LoadFile( fileName )
	if (fileName ~= "") then
		self:LoadObject(fileName, 0, 1);
	end
--	self:CreateRigidBody( 0, 1000, 0 );
	self:CreateRigidBody( 1, 0, 0 );
	self:SetPhysicParams(PHYSICPARAM_SIMULATION, self.SimParams );
	self:SetPhysicParams(PHYSICPARAM_BUOYANCY, self.SimParams);
	
	self:EnablePhysics( 0 );
	self:DrawObject(0,0);
	self.isActive = 0;
	self.piece_idx = -1;
	return 1;
end


------------------------------------------------------------------------------------------------------
function Piece:OnUpdate()

	if( self.unlimited and _time - self.timeStart > 15) then
		self:SetUpdateRadius( 100 ); -- Update for 100 meter.		
		self.unlimited = nil;
	end	

	if (self.UpdateCounter == 0) then
		if (self.isActive == 1) then
			self:SetTimer(self.part_update_freq);
		end
	end
	self.UpdateCounter = self.UpdateCounter  + 1;
end

------------------------------------------------------------------------------------------------------
function Piece:OnTimer( )

--System:Log("\001 Piece:OnTimer ");

	if(self.isActive == 0) then
		do return end
	end

	if (self.UpdateCounter > 0) then
		self:SetTimer(self.part_update_freq);
	end
	self.UpdateCounter = 0;
	
	--do splash	
	local pos = g_Vectors.temp_v1;
	
	CopyVector(pos,self:GetPos());
		
	pos.z = pos.z-1;
	
	if(Game:IsPointInWater(pos)) then 
			
		if (self.splashed==0) then	
			Piece.DoSplash(self,pos);
		end
		
		self.splashed = 1;
	end
	
	if( self.piece_idx < 0 ) then
--		self.emtrPos = self:GetPos();
		self.emtrPos = self:GetHelperPos("fire");
	else	
		self.emtrPos = self:GetHelperPos("piecedummy"..self.piece_idx);
	end	
 
 	-- if no helper present - no effect spuwn
	if( self.emtrPos.x == 0 ) then return end

	-- if more that 3 meters under water
	if(Game:GetWaterHeight()>self.emtrPos.z+3) then
--System:Log("\001 underwater   "..self.emtrPos.z);
		self.emtrPos.x=self.emtrPos.x+(3-random(0,3));
		self.emtrPos.y=self.emtrPos.y+(3-random(0,3));
		Particle:CreateParticle(self.emtrPos,g_Vectors.v001,self.PieceParticlesBubbles);
		Particle:CreateParticle(self.emtrPos,g_Vectors.v001,self.PieceParticlesVapor);
		do return end
	end
	-- if just in water - don't spawn any fire
--	if(Game:GetWaterHeight()>self.emtrPos.z) then return end
	if(Game:IsPointInWater(self.emtrPos)) then 
		if (self.bParticleEmitter) then
			self:DeleteParticleEmitter(0);		
			self.bParticleEmitter = nil;
		end
		do return end
	end
	--//usual burning
	if( self.piece_idx < 2 ) then
		--Particle:SpawnEffect(self.emtrPos,g_Vectors.v001, self.DeadEffect);
		if (self.bParticleEmitter == nil) then
			self.bParticleEmitter = 1;
			-- need object space position of helper
			self.emtrPos = self:GetHelperPos("piecedummy"..self.piece_idx,1);
			self:CreateParticleEmitterEffect( 0,self.DeadEffect,self.part_update_freq/1000.0,self.emtrPos,g_Vectors.v001,1 );
		end
	else
		Particle:SpawnEffect(self.emtrPos,g_Vectors.v001, self.DeadEffectMinor);
	end

	local face = self:GetTouchedSurfaceID();
	if( face==-1 ) then
		self.isTouching = -1;
		do return end
	end

--	if( face==self.isTouching ) then
--		do return end
--	end

	local	material = Game:GetMaterialBySurfaceID( face );
	if( material and material.collision ) then	
		local	pos = self:GetTouchedPoint();
		if( pos ) then
			if( pos.x~=self.lastPoint.x or pos.y~=self.lastPoint.y or pos.z~=self.lastPoint.z ) then
				self.isTouching = face;
--			pos = self.GetPos();
				self.lastPoint = pos;
				ExecuteMaterial(pos,g_Vectors.v001,material.collision,1);
			end	
		end	
	end
end



------------------------------------------------------------------------------------------------------
function Piece:Activate(dosplash)

--System:Log("Piece:Activate( )");
	self.bParticleEmitter = nil;
	self:DrawObject(0,1);
	self:EnablePhysics(1);
	self:EnableUpdate( 1 );
	self:SetUpdateType( eUT_PotVisible );
	self:SetUpdateRadius( 0 ); -- Update unlimited.	
	self.unlimited = 1;
	self.isActive = 1;
	self:SetTimer(self.part_update_freq);	
	
	self.timeStart = _time;

	-- it's the BIG piece - register it with AI so vehicles will avoid it
	if( self.piece_idx == 1 ) then
		AI:RegisterWithAI(self.id, AIOBJECT_CAR,self.Properties,self.PropertiesInstance);
	end	
	
	
	self:EnableSave(1);
	
	--if 1 the piece will do splash in the water. if nothing no splash
	if (dosplash) then
		self.splashed = 0;
	else
		self.splashed = 1;
	end
end

------------------------------------------------------------------------------------------------------
function Piece:Deactivate( )

--System:Log("Piece:Activate( )");

	self:DrawObject(0,0);
	self:EnablePhysics(0);
	self:EnableUpdate( 0 );
	self.isActive = 0;
	self:DeleteParticleEmitter(0);
	self:EnableSave(0);
end



----------------------------------------------------------------------------------------------------------------------------
--
--
function Piece:OnSave(stm)

	stm:WriteInt( self.isActive );
	stm:WriteInt( self.piece_idx );
	stm:WriteString( self.fileName );
end

----------------------------------------------------------------------------------------------------------------------------
--
--
function Piece:OnLoad(stm)
	self.isActive = stm:ReadInt();
	self.piece_idx = stm:ReadInt();
	self.fileName = stm:ReadString();
	self:Load( self.fileName, self.piece_idx );
	if(self.isActive) then
		self:Activate( );
	end	
end



------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
--
--
function Piece:OnEvent( id, params)

	if (id == ScriptEvent_EndAnimation)	then
		if( params == self.AniTable.Down  ) then
			self.state = 1;
			self:DisableAnimationEvent( self.id, self.AniTable.Down );
			do return end
		end
		if( params == self.AniTable.Up ) then
			self.state = 0;
			self:DisableAnimationEvent( self.id, self.AniTable.Up );
			do return end
		end
		if( params == self.AniTable.Descend  ) then
			self.state = 5;
			self:DisableAnimationEvent( self.id, self.AniTable.Descend );
			do return end
		end
	end	
end

------------------------------------------------------------------------------------------------------
function Piece:OnContact( player )

	-- damage only players
	if (player.type ~= "Player" ) then return end	
	-- don't want to damage AIs
	if (player.ai ) then return end	
	-- do nothing for dead bodies
	if(player.cnt.health<=0) then return end	
	-- damage only by primary pices (ixd=1)
	if( self.piece_idx > 1 ) then return end
	
	self.emtrPos = self:GetHelperPos("piecedummy"..self.piece_idx);
	-- if just in water - don't spawn any fire
	if(Game:GetWaterHeight()>self.emtrPos.z) then return end
	
	
--	if( self.piece_idx < 0 ) then
--		self.emtrPos = self:GetPos();
--		self.emtrPos = self:GetHelperPos("fire");
--	else	
--		self.emtrPos = self:GetHelperPos("piecedummy"..self.piece_idx);
--	end	

--System:Log("Piece:OnContact >>>> "..self:GetName().."  "..self.piece_idx)
 
 	-- if no helper present - no effect spuwn
	if( self.emtrPos.x == 0 ) then return end

	local playerPos = player:GetPos();
	playerPos.z = playerPos.z+.7;
	FastDifferenceVectors( playerPos, playerPos, self.emtrPos );
	
	-- take projection
--	playerPos.z = 0;
	local dist = LengthSqVector( playerPos );
	
--System:Log("Piece:OnContact >>>> "..dist)	
	if( dist < 3 ) then
		local	hit = {
			dir = g_Vectors.up,
--			{x=0,y=0,z=1},
--			damage = (1-dist)*100,
			fire=1,		-- 
			damage = 1,
			target = player,
			shooter = player,
			landed = 1,
			impact_force_mul_final=5,
			impact_force_mul=5,
			damage_type = "normal",
		};
		player:Damage( hit );
--		if( player == _localplayer ) then
--			Hud:OnMiscDamage(10);
--		end	
	end
end


------------------------------------------------------------------------------------------------------
function Piece:OnShutDown()

end
------------------------------------------------------------------------------------------------------
function Piece:OnEvent( id, params)
	if (id == ScriptEvent_PhysicalizeOnDemand) then
		System:Log("Piece:ScriptEvent_PhysicalizeOnDemand");
		self:SetPhysicParams(PHYSICPARAM_SIMULATION, self.SimParams );
	end
end

------------------------------------------------------------------------------------------------------
function Piece:OnReset()
	if (self.isActive == 1) then
		self:Deactivate();
	end
end

------------------------------------------------------------------------------
function Piece:DoSplash(pos)
		
	pos.z = Game:GetWaterHeight();
	--Hud:AddMessage(sprintf("%s hitpos: %.1f,%.1f,%.1f",self:GetName(),hit.vPos.x,hit.vPos.y,hit.vPos.z));
	
	local bbox = self:GetBBox(0);
	local bbmax = bbox.max;
	local bbmin = bbox.min;
	
	local deltax = bbmax.x-bbmin.x;
	local deltay = bbmax.y-bbmin.y;
	local deltaz = bbmax.z-bbmin.z;
	
	local volume = min(sqrt(deltax*deltay*deltaz),100)*0.015;
	
	--Hud:AddMessage(volume);
			
	if (self.SplashSound) then
		
		--if (Sound:IsPlaying(self.SplashSound)~=1) then
			Sound:SetSoundPosition(self.SplashSound,pos);
			Sound:PlaySound(self.SplashSound,1);
			--self:PlaySound(self.SplashSound);
		--end
	end
	
	for i=1, 3 do
	
		pos.x = random(bbmin.x,bbmax.x);
		pos.y = random(bbmin.y,bbmax.y);
				
		--ExecuteMaterial(pos, g_Vectors.v001, Materials.mat_water.grenade_splash, 1);		
		--ExecuteMaterial(pos, g_Vectors.v001, Materials.mat_water["rock_hit"], 1);		
		--ExecuteMaterial2(hit, "grenade_explosion");
		
		Particle:SpawnEffect(pos,g_Vectors.v001, "explosions.Grenade_water.ripples",volume );
	end
end