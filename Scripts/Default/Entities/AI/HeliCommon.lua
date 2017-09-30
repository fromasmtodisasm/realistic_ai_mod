--#Script:ReloadScript("scripts/Default/Entities/Others/piece.lua")
Script:LoadScript("scripts/Default/Entities/Others/piece.lua")

HC = {

	HClanded = 1,

};

-- new particle explosions
HeliExplosion = {
	particleEffects = {
		name = "explosions.helicopter_explosion.a",
	},
	sounds = {
		{"Sounds/Weapons/RL/explosion1.wav",0,255,8,100000},
		{"Sounds/Weapons/RL/explosion2.wav",0,255,8,100000},
		{"Sounds/Weapons/RL/explosion3.wav",0,255,8,100000},
	},
}


----------------------------------------------------------------------------------------------------------------------------
--
--
----------------------------------------------------------------------------------------------------------------------------
--
--




----------------------------------------------------------------------------------------------------------------------------
--
--
function HC:LoadModel()
	local model = self.Properties.fileModel;
	if (model == nil) then
		model = self.fileModel;
	end
	
	System:Log( "Loading Heli: "..model );

	--	if(self.IsPhisicalized == 0) then
	if( self.temp_ModelName ~= model) then
		
		--System:Log( "loading HELY ----------------------------------------------------- ");		
		self:LoadObjectPiece(model, -1 );
		self:DrawObject(0,1);
	
		self.V22PhysParams.collide = 1;
		self:CreateLivingEntity(self.V22PhysParams, Game:GetMaterialIDByName("mat_meat"));
		self.temp_ModelName = model;

		self:SetPhysicParams( PHYSICPARAM_FLAGS, {flags_mask=pef_pushable_by_players, flags=0} );

		--	load parts for explosion
		local idx=1;
		local	loaded=1;
		self.piecesId={};
		while loaded==1 do
			local piece=Server:SpawnEntity("Piece");
--			local piece=nil;
			if(piece)then
				
			System:Log( "loading Piece #"..idx );					

				self.piecesId[idx] = piece.id;
				loaded = piece.Load(piece, model, idx );
				idx = idx + 1;
			else
				break
			end

		end
		-- can't remove it coz on startup update (actual removing) is called befor playerSpawn 
		-- on loading from checkpoint update (actual removing) is NOT called befor playerSpawn 
--		if(idx>1) then
--			Server:RemoveEntity( self.pieces[idx-1].id );
--		end
		self.piecesId[idx-1] = 0;
	end	
	self:NoExplosionCollision();
	self.temp_ModelName = model;
end


----------------------------------------------------------------------------------------------------------------------------
--



----------------------------------------------------------------------------------------------------------------------------
--
--






----------------------------------------------------------------------------------------------------------------------------
--
--
function HC:OnShutDownServer()

System:LogToConsole( "Gunship OnShutDOWN ---------------------------" );

	self:ReleaseStuff();
	
	for idx,pieceId in self.piecesId do
--System:Log( " Piece #"..idx );
		Server:RemoveEntity( pieceId );
	end

end



--////////////////////////////////////////////////////////////////////////////////////////
function HC:ExecuteDamageModel()

--do return end



	-- maximum damage
	if (self.damage>self.Properties.max_health) then
		local vVec=self:GetHelperPos("vehicle_damage2",0); 
		Particle:CreateParticle(vVec,g_Vectors.v001,self.DamageParticles2);
		Particle:CreateParticle(vVec,g_Vectors.v001,self.DamageParticles3);
		HC.BlowUp(self);

--MAX - add different damage particles here
	elseif (self.damage>self.Properties.max_health*.75) then				
		-- maximum damage (more than 75%)
		local vVec=self:GetHelperPos("vehicle_damage1",0); 
		Particle:CreateParticle(vVec,g_Vectors.v001,self.DamageParticles1); --vector(0,0,1) is up
		Particle:CreateParticle(vVec,g_Vectors.v001,self.DamageParticles1a); --vector(0,0,1) is up
	elseif (self.damage>self.Properties.max_health*.50) then				
		-- midium damage (50%-75%)
		local vVec=self:GetHelperPos("vehicle_damage1",0); 
		Particle:CreateParticle(vVec,g_Vectors.v001,self.DamageParticles1); --vector(0,0,1) is up
		Particle:CreateParticle(vVec,g_Vectors.v001,self.DamageParticles1a); --vector(0,0,1) is up
	elseif (self.damage>self.Properties.max_health*.25) then				
		-- small damage (25%-75%)
		local vVec=self:GetHelperPos("vehicle_damage1",0); 
		Particle:CreateParticle(vVec,g_Vectors.v001,self.DamageParticles1); --vector(0,0,1) is up
		Particle:CreateParticle(vVec,g_Vectors.v001,self.DamageParticles1a); --vector(0,0,1) is up
	end
	
	if (self.bExploded~=1 and self.lowHealth ) then
		local vVec=self:GetHelperPos("vehicle_damage1",0); 
		Particle:SpawnEffect(vVec,g_Vectors.v001,"fire.burning_after_explosion.a"); --vector(0,0,1) is up
	end	
end

--////////////////////////////////////////////////////////////////////////////////////////


function HC:BlowUp()

	self:SwitchLight(0);	-- switch off attached lights
	
	if( self.ReleaseMountedWeapon) then
		self:ReleaseMountedWeapon();
	end	
	VC.KillEveryone( self );
	self:ReleaseStuff();

	if (self.bExploded==1) then
		do return end
	end

--	System:Log("BLOW UP!");	
	local	 explDir={x=0, y=0, z=1};
--	ExecuteMaterial(self:GetPos(),explDir, HeliExplosion,1);
	Particle:SpawnEffect(self:GetPos(),explDir, self.ExplosionEffect);

	-- raduis, r, g, b, lifetime, pos
	CreateEntityLight( self, 7, 1, 1, 0.7, 0.5);

	local ExplosionParams = {};
 	ExplosionParams.pos =	self:GetHelperPos("vehicle_damage2",0); 
	ExplosionParams.damage= self.Properties.ExplosionParams.nDamage;
	ExplosionParams.rmin = self.Properties.ExplosionParams.fRadiusMin;
	ExplosionParams.rmax = self.Properties.ExplosionParams.fRadiusMax;
	ExplosionParams.radius = self.Properties.ExplosionParams.fRadius;
	ExplosionParams.impulsive_pressure = self.Properties.ExplosionParams.fImpulsivePressure;
	ExplosionParams.shooter = self;
	ExplosionParams.weapon = self;
	Game:CreateExplosion( ExplosionParams );

	--play explosion sound
--	if (self.ExplosionSound ~= nil) then
--		--make sure to place the explosion sound at the correct position
--		Sound:SetSoundPosition(self.ExplosionSound,self:GetPos());
--		Sound:PlaySound(self.ExplosionSound);
--		--System:LogToConsole("playing explo sound");
--	end

	self:SetTimer(50);

	self:EnableSave(0);
----	self.damage=0; 
	self.bExploded=1;
	--self.IsPhisicalized = 0; -- so that the next call to reset will reload the normal model
	
	VC.AIDriver( self, 0 );

	if( self.Event_IsDead ) then
		self:Event_IsDead();
	end
end




--------------------------------------------------------------------------------------------------------------


function HC:BreakOnPieces()

local	pos=self:GetPos();
local	angle=self:GetAngles();
local	dir={x=0, y=0, z=1};

	self:DrawObject(0,0);	
	self:EnablePhysics(0);

--System:Log( " DoPiece ");	

	for idx,pieceId in self.piecesId do
--System:Log( " Piece #"..idx );
		local pieceEnt = System:GetEntity( pieceId );
		if( pieceEnt ) then
			pieceEnt:DrawObject(0,1);
			pieceEnt:EnablePhysics(1);
			
			pieceEnt:SetPos( pos );
			pieceEnt:SetAngles( angle );		
			dir.x= (2-random(0,4));
			dir.y= (2-random(0,4));
			dir.z= -1;
			
			pieceEnt:AddImpulseObj(dir, self.explosionImpulse*5000);
			pieceEnt:Activate(1);
			pieceEnt:SwitchLight(0);	-- switch off attached lights
		end		
	end

	HC.StopEngineSounds( self );


	self:ReleaseStuff();
	self:TriggerEvent(AIEVENT_DISABLE);
	self:EnableUpdate( 0 );
--	Server:RemoveEntity( self.id );	
	
end


--------------------------------------------------------------------------------------------------------------


function HC:ResetPieces()

--System:Log( " DoPiece ");	

	for idx,pieceId in self.piecesId do
--System:Log( " Piece #"..idx );
--		piece:Deactivate( piece );
		local pieceEnt = System:GetEntity( pieceId );
		if( pieceEnt ) then
			pieceEnt:DrawObject(0,0);
			pieceEnt:EnablePhysics(0);
		end	
	end
	
end


----------------------------------------------------------------------------------------------------------------------------
--
--
function HC:LoadPeople()

--	self:AIDriver( 1 );

System:Log("Gunship LoadPeople  ");
	
	AI:Signal(SIGNALFILTER_GROUPONLY, 1, "wakeup", self.id);	
	AI:Signal(SIGNALFILTER_GROUPONLY, 1, "SHARED_ENTER_ME_VEHICLE", self.id);
	self.dropState = 0;
--	self.driverWaiting = 1;
end



--------------------------------------------------------------------------------------------------------------
--
function HC:Land( bNoSound )

	self.attacking = nil;

	local alt = self:GetHelperPos("land",1);
	
	self:SelectPipe(0,"h_standingtherestill");
	
	if(alt) then
		self:SetAICustomFloat( alt.z );
	else	
		self:SetAICustomFloat( -5.0 );
	end	
	self.landed = 1;

	HC.StopRotor( self );
	
	if (bNoSound) then
		do return end
	end
	if (self.Properties.bFadeEngineSound==0) then
		self.CurrEngineFade=self.FadeEngineTime;
		self.FadeDir=2;
	else
		if (self.sound_engine_stop) then
			self:PlaySound(self.sound_engine_stop);
		end
		if (self.sound_engine) then
			Sound:StopSound(self.sound_engine);
		end
	end
	
--	self:SetShaderFloat( "Speed", 0, 1, 1);	

--System:Log("\001 no rotate ");	
	
end


--------------------------------------------------------------------------------------------------------------
--
function HC:Fly( )

	self:SetAICustomFloat( self.Properties.fFlightAltitude );
	self.landed = 0;
	
--	self:SetShaderFloat( "Speed", 500, 1, 1);
	
end

--------------------------------------------------------------------------------------------------------------
function HC:UpdateClient(dt)

	if (self.bExploded==1) then
		do return end
	end

	if (self.CurrEngineSoundTimeout and (self.CurrEngineSoundTimeout>0)) then
		self.CurrEngineSoundTimeout=self.CurrEngineSoundTimeout-dt;
		if (self.CurrEngineSoundTimeout<=0) then
			if (self.sound_engine) then
				if (not Sound:IsPlaying(self.sound_engine)) then
					self:PlaySound(self.sound_engine);
				end
			end
		end
	end
	if (self.sound_engine and (self.Properties.bFadeEngineSound==0)) then
		if (self.CurrEngineFade and (self.CurrEngineFade>0)) then
			self.CurrEngineFade=self.CurrEngineFade-dt;
			if (self.CurrEngineFade<=0) then
				if (self.FadeDir==2) then
					Sound:StopSound(self.sound_engine);
				end
			else
				local fScale=self.CurrEngineFade/self.FadeEngineTime;
				if (self.FadeDir==1) then
					Sound:SetSoundRatio(self.sound_engine, 1-fScale);
				else
					Sound:SetSoundRatio(self.sound_engine, fScale);
				end
			end
		end
	end


	if(self.rotorOn == 0 and self.landed and self and
		self.rotorSpeed > 0 and self.rotorSpeed < self.rotorSpeedUp*2) then
		VC.AIDriver( self, 0 );
	end
	
	local pos = self:GetPos();
--	local soundpos=new(pos);
	pos.z=pos.z-5;
--	System:ApplyForceToEnvironment(pos, 2.3, 1);

--	if(self.landed == 0) then -- flying - do effects
	if(self.rotorSpeed > 0) then
		--do force - grass/bushes deformation
		System:ApplyForceToEnvironment(pos, self.Properties.fBendRadius, self.Properties.fBendForce);
		--do some nice particles
		HC.DoDustWater(self, dt);
	end	
	
--	no sounds - done by attaching soundSpot entity to helicopter entity on Steve's request	
--	--do sounds
	--if( _localplayer and _localplayer.id and self.sound_engine ~= nil ) then
	if (self.sound_engine ~= nil ) then
		-- no hellicopter sound whein inside
	--	if( System:IsPointIndoors(_localplayer:GetPos()) ) then
	--		if (Sound:IsPlaying(self.sound_engine)) then
	--			Sound:StopSound(self.sound_engine);
	--		end
	--	else
	end	

	self.part_time = self.part_time + dt;
	if ( self.part_time >0.01) then		------not every frame update
		HC.ExecuteDamageModel( self );
		self.part_time = 0;
	end
	
	
	
end

--------------------------------------------------------------------------------------------------------------
--
function HC:DoDustWater( dt )

	self.dustTime = self.dustTime + dt;
	if( self.dustTime<.1 ) then return end
	self.dustTime = 0;

	if(self.rotorOn == 1) then
		if(self.rotorSpeed < self.rotorSpeedMax ) then
			self.rotorSpeed = self.rotorSpeed + self.rotorSpeedUp;
			self:SetShaderFloat( "Speed", self.rotorSpeed, 1, 1);
			
--System:Log("\001 SetShaderFloat "..self:GetName());			
			
		end
	else
		if(self.rotorSpeed > 0 ) then
			self.rotorSpeed = self.rotorSpeed - self.rotorSpeedUp;
			if(self.rotorSpeed < 0 ) then
				self.rotorSpeed = 0;
			end	
			self:SetShaderFloat( "Speed", self.rotorSpeed, 1, 1);
--System:Log("\001 SetShaderFloat 1 "..self:GetName());						
		end
	end	

	HC.DoRotor( self, "rotor1" );
	HC.DoRotor( self, "rotor2" );

end

--------------------------------------------------------------------------------------------------------------
--
function HC:DoRotor( hlpName )

local pos = self:GetHelperPos(hlpName,0);
--self:GetPos();
local water = Game:GetWaterHeight( );
local terrain = System:GetTerrainElevation( pos );
local dist=0;

--MAX - add different ground effects ( dust/water ) here

	if( terrain < water ) then -- abow water - do water water ripples particles 
		dist = pos.z - water;
		if( dist >15 ) then return end
		pos.z = water;
		Particle:CreateParticle(pos,g_Vectors.v011,self.WaterParticle); --vector(0,0,1) is up
		Particle:CreateParticle(pos,g_Vectors.v000,self.WaterRipples); --vector(0,0,1) is up		

	else	-- do dust 
		dist = pos.z - terrain;
		if( dist > 17 ) then return end
		pos.z = terrain;
--		self.Elementsparticle.rotation.X=rand(0,2);

--		for idx=1, 3 do
	
		local curPos = pos;
		
		curPos.x = curPos.x + random(0,8) - 4;
		curPos.y = curPos.y + random(0,8) - 4;		
		
		Particle:CreateParticle(curPos,g_Vectors.v001,self.Elementsparticle); --vector(0,0,1) is up
		Particle:CreateParticle(curPos,g_Vectors.v001,self.Dustparticle); --vector(0,0,1) is up
		
--		end

		
	end
	
end



--------------------------------------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------
--
function HC:StartRotor( )


--System:Log("\001 start rotors "..self:GetName());

	if(self.rotorSpeed<1) then	
		self.rotorSpeed = 1;
	end	
	self.rotorOn = 1;
	
	Sound:SetSoundLoop(self.sound_engine, 1);	
	
	self.CurrEngineSoundTimeout = self.EngineSoundTimeout;	
	if (self.Properties.bFadeEngineSound==0) then
		if (not Sound:IsPlaying(self.sound_engine)) then
			self:PlaySound(self.sound_engine, 0);
			self.CurrEngineFade=self.FadeEngineTime;
			self.FadeDir=1;
		end
	else
		if (self.sound_engine_start) then
			self:PlaySound(self.sound_engine_start);
		end
	end
	
	self:SwitchLight(1);	-- switch on attached lights	
	
end


--------------------------------------------------------------------------------------------------------------
--
function HC:StartRotorFull(  )

--System:Log("\001 start rotors "..self:GetName());
	self.rotorSpeed = self.rotorSpeedMax-1;
	self.rotorOn = 1;
	
	Sound:SetSoundLoop(self.sound_engine, 1);	

	if (not Sound:IsPlaying(self.sound_engine)) then
		self:PlaySound(self.sound_engine);
	end
	self:SwitchLight(1);	-- switch on attached lights	

	self:SetAICustomFloat( self.Properties.fFlightAltitude );


end


--------------------------------------------------------------------------------------------------------------
--
function HC:StopRotor( )

	self.rotorOn = 0;
	
	self:SwitchLight(0);	-- switch on attached lights	
end



--------------------------------------------------------------------------------------------------------------
--
function HC:StopEngineSounds( )

	if (self.sound_engine) then
		Sound:StopSound(self.sound_engine);
		self.sound_engine = nil;
	end
	if (self.sound_engine_start) then
		Sound:StopSound(self.sound_engine_start);
		self.sound_engine_start = nil;
	end
	if (self.sound_engine_stop) then
		Sound:StopSound(self.sound_engine_stop);
		self.sound_engine_stop = nil;
	end

end


----------------------------------------------------------------------------------------------------------------------------
--
--


function HC:OnSave(stm)

	stm:WriteString( self.Behaviour.Name );
	stm:WriteInt(self.pathStep);
	stm:WriteInt(self.dropState);
	stm:WriteInt(self.troopersNumber);
	stm:WriteInt(self.damage);
	if( self.lowHealth )then
		stm:WriteInt(1);
	else	
		stm:WriteInt(0);
	end	

--System:Log("HC:OnSave "..self.damage.."  "..self:GetName() );

end



----------------------------------------------------------------------------------------------------------------------------
--
--

function HC:OnLoad(stm)
--
--System:Log("HC:OnLoad "..self.damage.."  "..self:GetName() );
	local behaviourName = stm:ReadString( );
	self.pathStep = stm:ReadInt();
	self.dropState = stm:ReadInt();
	self.troopersNumber = stm:ReadInt();
	self.damage = stm:ReadInt();	
	self.lowHealth = stm:ReadInt();	
	if( self.lowHealth == 0 )then
		self.lowHealth = nil;	
	end	

--System:Log("HC:OnLoad "..self.damage.."  >>> "..self:GetName() );

	if( behaviourName == "Heli_attack" ) then
		HC.StartRotorFull( self );
		self:SetAICustomFloat( self.Properties.fAttackAltitude );		
		VC.AIDriver( self, 1 );	
		AI:Signal(0, 1, "ATTACK_RESTORE", self.id);
		self.RestoringState = 1;
	elseif( behaviourName == "Heli_path" ) then
		HC.StartRotorFull( self );
		self:SetAICustomFloat( self.Properties.fFlightAltitude );		
		VC.AIDriver( self, 1 );	
		AI:Signal(0, 1, "PATH_RESTORE", self.id);
		self.RestoringState = 1;
	elseif( behaviourName == "Heli_goto" ) then
		HC.StartRotorFull( self );
		self:SetAICustomFloat( self.Properties.fFlightAltitude );		
		VC.AIDriver( self, 1 );	
		self:SelectPipe(0,"h_goto");
--		AI:Signal(0, 1, "PATH_RESTORE", self.id);
--		self.RestoringState = 1;
	elseif( behaviourName == "Heli_patrol" ) then
		HC.StartRotorFull( self );
		self:SetAICustomFloat( self.Properties.fFlightAltitude );		
		VC.AIDriver( self, 1 );	
		AI:Signal(0, 1, "PATROL_RESTORE", self.id);
		self.RestoringState = 1;
	elseif( behaviourName == "Heli_transport" ) then
		HC.StartRotorFull( self );
		self:SetAICustomFloat( self.Properties.fFlightAltitude );
		VC.AIDriver( self, 1 );	
--		AI:Signal(0, 1, "REINFORCMENT_RESTORE", self.id);
		self.RestoringState = 1;

		if(self.dropState == 2 ) then
			self.troopersNumber = 0;
			AI:Signal(0, 1, "READY_TO_GO", self.id);	-- abort dropping - go to base
--			self:SelectPipe(0,"h_timeout_readytogo");
		else
			AI:Signal(0, 1, "REINFORCMENT_RESTORE", self.id);
		end


--		if(self.dropState == 2 and self.DoDropPeople) then
--			if(self.troopersNumber ~= VC.CountPassenger(self)) then
--				AI:Signal(0, 1, "ON_GROUND", self.id);
--			else
--				self:SpawnStuff();
--				self:DoDropPeople();
--			end	
--		end

--System:Log("\001 restoring REINFORC   ");
	end
end


----------------------------------------------------------------------------------------------------------------------------
--
--

function HC:OnLoadRELEASE(stm)
--
--System:Log("HC:OnLoad "..self.damage.."  "..self:GetName() );
	local behaviourName = stm:ReadString( );
	self.pathStep = stm:ReadInt();
	self.dropState = stm:ReadInt();
	self.troopersNumber = stm:ReadInt();

--System:Log("HC:OnLoad "..self.damage.."  >>> "..self:GetName() );

	if( behaviourName == "Heli_attack" ) then
		HC.StartRotorFull( self );
		self:SetAICustomFloat( self.Properties.fAttackAltitude );		
		VC.AIDriver( self, 1 );	
		AI:Signal(0, 1, "ATTACK_RESTORE", self.id);
		self.RestoringState = 1;
	elseif( behaviourName == "Heli_path" ) then
		HC.StartRotorFull( self );
		self:SetAICustomFloat( self.Properties.fFlightAltitude );		
		VC.AIDriver( self, 1 );	
		AI:Signal(0, 1, "PATH_RESTORE", self.id);
		self.RestoringState = 1;
	elseif( behaviourName == "Heli_goto" ) then
		HC.StartRotorFull( self );
		self:SetAICustomFloat( self.Properties.fFlightAltitude );		
		VC.AIDriver( self, 1 );	
		self:SelectPipe(0,"h_goto");
--		AI:Signal(0, 1, "PATH_RESTORE", self.id);
--		self.RestoringState = 1;
	elseif( behaviourName == "Heli_patrol" ) then
		HC.StartRotorFull( self );
		self:SetAICustomFloat( self.Properties.fFlightAltitude );		
		VC.AIDriver( self, 1 );	
		AI:Signal(0, 1, "PATROL_RESTORE", self.id);
		self.RestoringState = 1;
	elseif( behaviourName == "Heli_transport" ) then
		HC.StartRotorFull( self );
		self:SetAICustomFloat( self.Properties.fFlightAltitude );
		VC.AIDriver( self, 1 );	
--		AI:Signal(0, 1, "REINFORCMENT_RESTORE", self.id);
		self.RestoringState = 1;

		if(self.dropState == 2 ) then
			self.troopersNumber = 0;
			AI:Signal(0, 1, "READY_TO_GO", self.id);	-- abort dropping - go to base
--			self:SelectPipe(0,"h_timeout_readytogo");
		else
			AI:Signal(0, 1, "REINFORCMENT_RESTORE", self.id);
		end


--		if(self.dropState == 2 and self.DoDropPeople) then
--			if(self.troopersNumber ~= VC.CountPassenger(self)) then
--				AI:Signal(0, 1, "ON_GROUND", self.id);
--			else
--				self:SpawnStuff();
--				self:DoDropPeople();
--			end	
--		end

--System:Log("\001 restoring REINFORC   ");
	end
end


--------------------------------------------------------------------------------------------------------------



----------------------------------------------------------------------------------------------------------------------------
--
--
 