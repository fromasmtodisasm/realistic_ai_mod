

Radio={

	type = "Trigger",

	Properties = {

		DimX = 5,
		DimY = 5,
		DimZ = 5,

		object_Model="Objects/Outdoor/human_camp/fieldradio.cgf",
		object_ModelDestroyed="Objects/Outdoor/human_camp/fieldradio_destroyed.cgf",
		nDamage=100,
		nExplosionRadius=5,
		bExplosion=1,
		bOnlyAIcanTrigger=1,
		
		ExplosionEffect="explosions.Grenade_indoors.explosion",
		ExplosionScale=1,
		
		bTriggeredOnlyByExplosion=0,
		impulsivePressure=200, -- physics params
		rmin = 2.0, -- physics params
		rmax = 20.5, -- physics params
		AliveSoundLoop={
			sndFilename="",
			InnerRadius=1,
			OuterRadius=10,
			nVolume=255,
		},
		DeadSoundLoop={
			sndFilename="",
			InnerRadius=1,
			OuterRadius=10,
			nVolume=255,
		},
		DyingSound={
			sndFilename="",
			InnerRadius=1,
			OuterRadius=10,
			nVolume=255,
		},

		bTrackable=1,

		-- we need engine particles emitters, not scripts 
		DeadParticles = {
			TimeDelay = 0.1, -- how often particle system is spawned.

			bActive=0,

			nType=0, -- Type of particles 0=Billboard,1=Water splashes,2=Underwater,3=LineParticle,
			Focus = 4,
			clrColorStart={1,1,1},
			clrColorEnd={1,1,1},
			Speed = 1.2,
			nCount = 1,
			Size = 0.2,
			SizeSpeed = 2.2,
			LifeTime = 2,
			FadeInTime = 0.5,
			nFrames = 0,
			Tail = 0, -- Tail lengths.
			Bounciness = 0.5,
			bPhysics = 0, -- Enable or disable real particle physics.
			-- Blend types
			bAdditiveBlend = 0,
			bColorBlend = 0,
			nDrawOrder = 0,

			Gravity = { X=0,Y=0,Z=1 },
			Rotation = { X=0,Y=0,Z=0 },
			Textures = {
				fileTex1="Textures\\carsmoke.tga",
				fileTex2="",
				fileTex3="",
				fileTex4="",
				fileTex5="",
			},
			-- Objects to spawn instead of texture.
			Objects = {
				objObject1="",
				objObject2="",
				objObject3="",
				objObject4="",
				objObject5="",
			},

			turbulence_size = 0,
			turbulence_speed = 0,
			bLinearSizeSpeed = 0,
			ShaderName="ParticleLight",


			-- Child process definition.
			ChildSpawnPeriod = 0,
			ChildProcess = {},
		},

	},
	--PHYSICS PARAMS
	explosion_params = {
		pos = nil,
		damage = 100,
		rmin = 2.0,
		rmax = 20.5,
		radius = 3,
		impulsive_pressure = 200,
		shooter = nil,
		weapon = nil,
	},

	Editor={
		Model="Objects/Editor/T.cgf",
	},
}

-------------------------------------------------------
function Radio:OnInit()
	self:EnableUpdate(0);
	self:TrackColliders(1);

	-- Create particle table.
	self.ParticleParams = {};
	self.Textures={};
	self.TexturesId={};
	self.Objects={};
	self.Direction = {x=0,y=0,z=1};	

	self:RegisterState("Active");
	self:RegisterState("Dead");
	
	self:OnReset();
end

-------------------------------------------------------
function Radio:OnPropertyChange()
	self:OnReset();
end

-------------------------------------------------------
function Radio:OnShutDown()
	if (self.Properties.DeadParticles.bActive ~= 0) then		
		self:DeleteParticleEmitter();
	end
end

-------------------------------------------------------
function Radio:Event_Explode( sender )
	self:Explode();
	BroadcastEvent( self,"Explode" );
end

-------------------------------------------------------
function Radio:Explode()
	if(self.explosion)then
		local normal = { x=0,y=0,z=0.5 };
		local pos = self:GetPos();
		--ExecuteMaterial( pos,normal,Materials.mat_default.projectile_hit, 1 );
		
		Particle:SpawnEffect( pos,normal,self.Properties.ExplosionEffect,self.Properties.ExplosionScale );	
		
		-- raduis, r, g, b, lifetime, pos
		CreateEntityLight( self, 7, 1, 1, 0.7, 0.5);
		
		self.explosion_params.pos = pos;
		self.explosion_params.shooter=self;
	end

	if (self.Properties.DeadParticles.bActive ~= 0) then		
		self:CreateParticleEmitter( self.ParticleParams, self.Properties.DeadParticles.TimeDelay );
	end

	self.Properties.bTrackable=0;
	
	self:GoDead();
	
	if(self.explosion)then
		Game:CreateExplosion(self.explosion_params);
	end
end

-------------------------------------------------------
function Radio:OnReset()

	self:NetPresent(nil);
	self.Entered = 0;
	self.Properties.bTrackable=1;

	local Min = { x=-self.Properties.DimX/2, y=-self.Properties.DimY/2, z=-self.Properties.DimZ/2 };
	local Max = { x=self.Properties.DimX/2, y=self.Properties.DimY/2, z=self.Properties.DimZ/2 };
	self:SetBBox( Min, Max );


	if (self.Properties.DeadParticles.bActive ~= 0) then
		self:Property2ParticleTable( self.ParticleParams,self.Properties.DeadParticles);
		self:ReloadParticleTextures(self.Properties.DeadParticles);
		self:DeleteParticleEmitter();
	end

	if (self.Properties.object_Model ~= self.CurrModel) then
		self.CurrModel = self.Properties.object_Model;
		self:LoadObject(self.Properties.object_Model,0,1);
		self:DrawObject(0,1);
		self:CreateStaticEntity( 10,100 );
	end
	if ((self.Properties.object_ModelDestroyed ~="") and 
	(self.Properties.object_ModelDestroyed ~= self.CurrDestroyedModel)) then
		self.CurrDestroyedModel = self.Properties.object_ModelDestroyed;
		self:LoadObject(self.Properties.object_ModelDestroyed,1,1);
		self:DrawObject(1,0);
		self:CreateStaticEntity( 10,100 );
	end
	
	-- stop old sounds
	if (self.DyingSoundLoop and Sound:IsPlaying(self.DyingSound)) then
		Sound:StopSound(self.DyingSound);
	end
	if (self.DeadSoundLoop and Sound:IsPlaying(self.DeadSoundLoop)) then
		Sound:StopSound(self.DeadSoundLoop);
	end
	if (self.AliveSoundLoop and Sound:IsPlaying(self.AliveSoundLoop)) then
		Sound:StopSound(self.AliveSoundLoop);
	end
	-- load sounds
	local SndTbl;
	SndTbl=self.Properties.AliveSoundLoop;
	if (SndTbl.sndFilename~="") then
		self.AliveSoundLoop=Sound:Load3DSound(SndTbl.sndFilename, 0);
		if (self.AliveSoundLoop) then
			Sound:SetSoundPosition(self.AliveSoundLoop, self:GetPos());
			Sound:SetSoundLoop(self.AliveSoundLoop, 1);
			Sound:SetSoundVolume(self.AliveSoundLoop, SndTbl.nVolume);
			Sound:SetMinMaxDistance(self.AliveSoundLoop, SndTbl.InnerRadius, SndTbl.OuterRadius);
		end
	else
		self.AliveSoundLoop=nil;
	end
	SndTbl=self.Properties.DeadSoundLoop;
	if (SndTbl.sndFilename~="") then
		self.DeadSoundLoop=Sound:Load3DSound(SndTbl.sndFilename, 0);
		if (self.DeadSoundLoop) then
			Sound:SetSoundPosition(self.DeadSoundLoop, self:GetPos());
			Sound:SetSoundLoop(self.DeadSoundLoop, 1);
			Sound:SetSoundVolume(self.DeadSoundLoop, SndTbl.nVolume);
			Sound:SetMinMaxDistance(self.DeadSoundLoop, SndTbl.InnerRadius, SndTbl.OuterRadius);
		end
	else
		self.DeadSoundLoop=nil;
	end
	SndTbl=self.Properties.DyingSound;
	if (SndTbl.sndFilename~="") then
		self.DyingSound=Sound:Load3DSound(SndTbl.sndFilename, 0);
		if (self.DyingSound) then
			Sound:SetSoundPosition(self.DyingSound, self:GetPos());
			Sound:SetSoundVolume(self.DyingSound, SndTbl.nVolume);
			Sound:SetMinMaxDistance(self.DyingSound, SndTbl.InnerRadius, SndTbl.OuterRadius);
		end
	else
		self.DyingSound=nil;
	end

	self.explosion_params.impulsive_pressure=self.Properties.impulsivePressure;	
	self.curr_damage=self.Properties.nDamage;
	self.explosion_params.radius=self.Properties.nExplosionRadius;
	self.explosion_params.rmin=self.Properties.rmin;
	self.explosion_params.rmax=self.Properties.rmax;

	if(self.Properties.bExplosion==1)then
		self.explosion=1;
	end
	--System:Log("---RESET DESTROY");
	self:GoAlive();
end

-------------------------------------------------------
function Radio:GoAlive()
	
	self:EnablePhysics(1);
	self:DrawObject(0,1);
	self:DrawObject(1,0);
	if (self.DeadSoundLoop) then
		Sound:StopSound(self.DeadSoundLoop);
		--System:Log("stopping dead-loop");
	end
	if (self.AliveSoundLoop and (not Sound:IsPlaying(self.AliveSoundLoop))) then
		Sound:PlaySound(self.AliveSoundLoop);
		--System:Log("starting alive-loop");
	end
	self:GotoState( "Active" );
end

-------------------------------------------------------
function Radio:GoDead()


	self:GotoState( "Dead" );
end

-------------------------------------------------------
function Radio:Event_Enter( sender )
	if ((self.Entered ~= 0)) then
		return
	end
	self.Entered = 1;
	if (sender) then
		--System:LogToConsole( "Player "..sender:GetName().." Enter RadioTrigger "..self:GetName() );
	end
	BroadcastEvent( self,"Enter" );
end

-------------------------------------------------------
Radio.Active={
	OnBeginState=function(self)
		--System:Log("enter alive");
	end,
	OnDamage = function(self,hit)
		--System:Log("ON DAMAGE "..self.id.." AMOUNT="..hit.damage);
		if((self.Properties.bTriggeredOnlyByExplosion==1)
			and (not hit.explosion))then return end;
			
		self.curr_damage=self.curr_damage-hit.damage;
		
		if(self.curr_damage<=0)then
			self:Event_Explode();
		end
	end,
	OnTimer = function(self)
		self:Event_OnExploded();
	end,
	----------------------------------------------------------------------------------------
	OnEnterArea = function(self,player,areaid)
		if (player ==_localplayer) then
			if (self.Properties.bOnlyAIcanTrigger == 1) then
				return -- only AI should trigger this
			end
		end
		self:Event_Enter(player);
	end,
}

-------------------------------------------------------
Radio.Dead={
	OnBeginState=function(self)
		--System:Log("enter dead");
		if (self.AliveSoundLoop) then
			Sound:StopSound(self.AliveSoundLoop);
			--System:Log("stopping alive-loop");
		end
		if (self.DyingSound and (not Sound:IsPlaying(self.DyingSound))) then
			Sound:PlaySound(self.DyingSound);
			--System:Log("starting dying");
		end
		if (self.DeadSoundLoop and (not Sound:IsPlaying(self.DeadSoundLoop))) then
			Sound:PlaySound(self.DeadSoundLoop);
			--System:Log("starting dead-loop");
		end

		self:SetTimer(1);
	end,
	OnTimer=function(self)
		self:DrawObject(0,0);
		if(self.Properties.object_ModelDestroyed~="")then
			self:DrawObject(1,1);
		else
			self:EnablePhysics(0);		
		end
	end,
}

-------------------------------------------------------
function Radio:Property2ParticleTable( Params,Properties )
	Params.focus = Properties.Focus;
	Params.speed = Properties.Speed;
	Params.count = Properties.nCount;
	Params.size = Properties.Size;
	Params.size_speed = Properties.SizeSpeed / 10;
	Params.lifetime = Properties.LifeTime;
	Params.fadeintime = Properties.FadeInTime;
	Params.frames = Properties.nFrames;
	Params.tail_length = Properties.Tail;
	Params.bouncyness = Properties.Bounciness;
	Params.physics = Properties.bPhysics;
	Params.draw_last = Properties.nDrawOrder;
	Params.particle_type = Properties.nType;

	Params.blend_type = 0;
	if (Properties.bColorBlend ~= 0) then
		Params.blend_type = 1;
	end
	if (Properties.bAdditiveBlend ~= 0) then
		Params.blend_type = 2;
	end

	Params.gravity = {};
	Params.gravity.x  = Properties.Gravity.X;
	Params.gravity.y  = Properties.Gravity.Y;
	Params.gravity.z  = Properties.Gravity.Z;

	Params.rotation = {};
	Params.rotation.x  = Properties.Rotation.X;
	Params.rotation.y  = Properties.Rotation.Y;
	Params.rotation.z  = Properties.Rotation.Z;

	Params.start_color = {};
	Params.start_color[1]  = Properties.clrColorStart[1];
	Params.start_color[2]  = Properties.clrColorStart[2];
	Params.start_color[3]  = Properties.clrColorStart[3];

	Params.end_color = {};
	Params.end_color[1]  = Properties.clrColorEnd[1];
	Params.end_color[2]  = Properties.clrColorEnd[2];
	Params.end_color[3]  = Properties.clrColorEnd[3];

	Params.turbulence_size  = Properties.turbulence_size;
	Params.turbulence_speed = Properties.turbulence_speed;
	Params.bLinearSizeSpeed = Properties.bLinearSizeSpeed;
	Params.ChildSpawnPeriod = Properties.ChildSpawnPeriod;

	Params.ShaderName = Properties.ShaderName;
end

-------------------------------------------------------
function Radio:ReloadParticleTextures(Properties)
	local ind = 1;
	self.TextureIds = {};
	for index, value in Properties.Textures do
		if (value ~= "") then
			self.TexturesId[ind] = System:LoadTexture( value );
			ind = ind + 1;
		end
		self.Textures[index] = value;
	end
end