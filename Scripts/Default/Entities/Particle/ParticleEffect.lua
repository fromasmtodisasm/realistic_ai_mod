ParticleEffect = {
	Properties = {
		SpawnPeriod = 0.1, -- how often particle system is spawned.
		bActive=1,
		Scale=1,
		fUpdateRadius=50,
		
		ParticleEffect="",
	},
	Editor={
		Model="Objects/Editor/Particles.cgf",
	},
	vOffset = { x=0,y=0,z=0 },
	vDir = { x=0,y=1,z=0 }
};

-------------------------------------------------------
function ParticleEffect:OnInit()
	-- Create particle table.
	self:RegisterState( "Active" );
	self:RegisterState( "Idle" );
	
	self.spawnTimer = 0;
	self.Direction = {x=0,y=0,z=1};
	
	self:EnableUpdate(0);
	self:SetRegisterInSectors(1);
	self:SetRadius(0.01);
	
	self:SetUpdateType( eUT_PotVisible );

	self:OnReset();
	--self:NetPresent(nil);
end

-------------------------------------------------------
function ParticleEffect:OnPropertyChange()
	-- Create particle table.
	self:OnReset();
end

-------------------------------------------------------
function ParticleEffect:OnReset()
	self:EnableUpdate(1); -- another pot vis System will check is update needed or not
	self:SetUpdateRadius( self.Properties.fUpdateRadius );
	
	self:GotoState( "" );
	if (self.Properties.bActive ~= 0) then
		self:GotoState( "Active" );
	else
		self:GotoState( "Idle" );
	end
end

function ParticleEffect:Event_Enable()
	self:GotoState( "Active" );
end

function ParticleEffect:Event_Disable()
	self:GotoState( "Idle" );
end



--------------------------------------------------------------------------------------------------------
-- get "do one pulse" command
function ParticleEffect:OnRemoteEffect(toktable, pos, normal, userbyte)
	local dir = self:GetDirectionVector();
	dir.x = -dir.x;
	dir.y = -dir.y;
	dir.z = -dir.z;
	Particle:SpawnEffect( self:GetPos(),dir,self.Properties.ParticleEffect,self.Properties.Scale );
end

function ParticleEffect:Event_Pulse()
	if Game:IsMultiplayer() then
		Server:BroadcastCommand("FX",g_Vectors.v000,g_Vectors.v000,self.id,0);			-- send over network
	else
		self:OnRemoteEffect();		-- apply immediatly (editor or game)
	end
end

-------------------------------------------------------------------------------
-- Active State
-------------------------------------------------------------------------------
ParticleEffect.Active =
{
	OnBeginState = function( self )
		self:EnableUpdate(1);
		self:CreateParticleEmitterEffect( 0,self.Properties.ParticleEffect,self.Properties.SpawnPeriod,self.vOffset,self.vDir,self.Properties.Scale );
		self.bHaveEmitter = 1;
	end,
	OnEndState = function( self )
		self.bHaveEmitter = nil;
		self:DeleteParticleEmitter(0);
		self:EnableUpdate(0);
	end,
}

-------------------------------------------------------------------------------
-- Idle State
-------------------------------------------------------------------------------
ParticleEffect.Idle =
{
	OnBeginState = function( self )
		self:EnableUpdate(0);
		if (self.bHaveEmitter) then
			self:DeleteParticleEmitter(0);
			self.bHaveEmitter = nil;
		end
	end,
}

-------------------------------------------------------
function ParticleEffect:OnShutDown()
end