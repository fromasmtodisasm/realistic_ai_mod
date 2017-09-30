--

-- HeliStatic
-------------------------------------




HeliStatic = {

	temp_ModelName = "none",

	pathStep = 0,
	dropState = 0,

	V22PhysParams = {
		mass = 900,
		height = .1,
		eyeheight = .1,
		sphereheight = .1,
		radius = .5,
		gravity = 0,
		aircontrol = 1,
	},


	damage = 0,
	bExploded = 0,

	pieces = {},

	explosionImpulse = 10,

	Properties = {

		fDmgScaleBullet = .1,
		fDmgScaleExplosion = 1.7,

		bTrackable=1,

		max_health = 150,
		bRigidBodyActive = 0,
		Mass = 5000,

		fileModel = "objects/vehicles/troopgunship/troopgunship_inflight.cgf",

		ExplosionParams = {
			nDamage = 600,
			fRadiusMin = 12,
			fRadiusMax = 70.5,
			fRadius = 30,
			fImpulsivePressure = 600
		},

		sound_engine_file = "SOUNDS/Ambient/E3/hele/heleLP1.wav",
	},

	DamageParticles1 = {
		focus = 1.8, -- default 90
		speed = 1.55, -- default .25
		count = 1, -- default 1
		size = .04,size_speed=.1, -- default size = .04-- default size_speed = .03
		gravity={x=0,y=0,z=.3},-- default z= .3
		rotation={x=0,y=0,z=1.75},-- default z= 1.75
		lifetime=2, -- default 2
		tid = System:LoadTexture("textures/clouda.dds"),
		frames=0,
		color_based_blending = 0 -- default 0
	},

	DamageParticles2 = {
		focus = 1.8, -- default 1.8
		speed = .6, -- default 1
		count = 1, -- default 1
		size = .3,size_speed=.5, -- default size = 1.5-- default size_speed = .5
		gravity={x=.3,y=0,z=.3},-- default z= .3
		rotation={x=1.75,y=1,z=1.75},-- default z= 1.75
		lifetime=4, -- default 7
		tid = System:LoadTexture("textures\\cloud_black1.dds"),
		frames=0,
		color_based_blending = 0 -- default 0
	},

	sound_engine = nil,

}


----------------------------------------------------
--
--
----------------------------------------------------
--
--

HeliStatic.Client = {
	OnInit = function(self)
		System:Log("Client HeliStatic onInit")
		self:InitClient()
	end,
	OnContact = function(self,player)
 		self:OnContactClient(player)
	end,
--	OnEvent = function(self,id,params)
--		self:OnEventClient(id,params)
--	end,
	OnUpdate = function(self,dt)
--System.Log("V22 Client Update ")
--		self:OnUpdate(dt)
		self:UpdateClient(dt)
--		self:UpdateCommon()
	end
}


------------------------------------------------------
--
--
HeliStatic.Server = {
	OnInit = function(self)
		System:Log("Server HeliStatic onInit")
		self:InitServer()
	end,
	OnContact = function(self,player)
 		self:OnContactServer(player)
	end,
	OnEvent = function(self,id,params)
		self:OnEventServer(id,params)
	end,
	OnShutDown = function(self)
		self:OnShutDownServer(self)
	end,
	OnUpdate = function(self,dt)
--System.Log("V22 Server Update ")
--		self:OnUpdate(dt)
		self:UpdateServer(dt)
-- 		self:UpdateCommon()
	end,
	OnDamage = function(self,hit)

		self:OnDamageServer(hit)
	end,

}


----------------------------------------------------
--
--
function HeliStatic:OnReset()


	self.damage = 0
	self.sound_engine = Sound:Load3DSound(self.Properties.sound_engine_file,bor(SOUND_OUTDOOR,SOUND_UNSCALABLE),255,1,100)

end


----------------------------------------------------
--
--
function HeliStatic:OnPropertyChange()

	self:OnReset()

	self:LoadModel()

	Sound:SetSoundLoop(self.sound_engine,1)

end


----------------------------------------------------
--
--
function HeliStatic:LoadModel()

System:Log("loading HeliStatic "..self.Properties.fileModel)

--	if (self.IsPhisicalized==0) then
	if (self.temp_ModelName~=self.Properties.fileModel) then
--		self:LoadObjectPiece(self.Properties.fileModel,-1)
		self:LoadObject(self.Properties.fileModel,0,1)

--		self:DrawObject(0,1)
--		self:CreateLivingEntity(self.V22PhysParams)

		if (self.Properties.bRigidBodyActive==1) then
			self:CreateRigidBody(1000,5000,0)
--			self:CreateRigidBody(self.Properties.Density,self.Properties.Mass,0)
		else
			self:CreateStaticEntity(5000,0)
			self:EnablePhysics(1)
			self:DrawObject(0,1)

--			self:CreateStaticEntity(self.Properties.Mass,0)
		end

		self.temp_ModelName = self.Properties.fileModel

		--	load parts for explosion
		local idx=1
		local	loaded=1
		while loaded==1 do
			local piece=Server:SpawnEntity("Piece")
			if (piece) then

System:Log("loading Piece #"..idx)

				self.pieces[idx] = piece
				loaded = self.pieces[idx].Load(self.pieces[idx],self.Properties.fileModel,idx)
				idx = idx + 1
			else
				break
			end
		end
		self.pieces[idx-1] = nil


	end

--	self:ActivatePhysics(0)

	self.temp_ModelName = self.Properties.fileModel
end

----------------------------------------------------
--
--
function HeliStatic:InitClient()


	self:LoadModel()

	self:OnReset()
	Sound:SetSoundLoop(self.sound_engine,1)

	self.ExplosionSound=Sound:Load3DSound("sounds\\weapons\\explosions\\mbarrel.wav",0,0,7,100)

end

----------------------------------------------------
--
--
function HeliStatic:InitServer()

	self:OnReset()

	self:EnableUpdate(1)

	self:LoadModel()

--	self:NetPresent(1)
end


----------------------------------------------------
--
--

----------------------------------------------------
--
--

----------------------------------------------------
--
--
-------------------------------------
--
--
function HeliStatic:OnContactServer(player)

	if (player.type~="Player") then
		do return end
	end
end

-------------------------------------
--
--
function HeliStatic:OnContactClient(player)

	if (player.type~="Player") then
		do return end
	end

end

-------------------------------------
--
--
function HeliStatic:UpdateServer(dt)


end


-------------------------------------
--
function HeliStatic:UpdateClient(dt)

	--do force - grass/bushes deformation
	local pos = self:GetPos()
	pos.z=pos.z-5
	System:ApplyForceToEnvironment(pos,50,1)

	--do sounds
	if (_localplayer and _localplayer.id and self.sound_engine) then
		-- no hellicopter sound whein inside
		if (System:IsPointIndoors(_localplayer:GetPos())) then
			if (Sound:IsPlaying(self.sound_engine)) then
				Sound:StopSound(self.sound_engine)
			end
		else
			Sound:SetSoundPosition(self.sound_engine,pos)
			if (Sound:IsPlaying(self.sound_engine)==nil) then
				Sound:PlaySound(self.sound_engine)
			end
		end
	end

	self:ExecuteDamageModel()

end

----------------------------------------------------
--
function HeliStatic:OnDamageServer(hit)

--do return end


System:Log("Damage  "..hit.damage.." total "..self.damage)

	if (self.damage<0) then
		do return end
	end

	if (hit.explosion) then
		self.damage = self.damage + hit.damage*self.Properties.fDmgScaleExplosion
	else
		self.damage = self.damage + hit.damage*self.Properties.fDmgScaleBullet
	end



	--self:SetDamage

end


----------------------------------------------------
--
--
function HeliStatic:OnShutDownServer()

System:Log("HeliStatic OnShutDOWN ---------------------------")


	for idx,piece in self.pieces do
--System:Log(" Piece #"..idx)
		Server:RemoveEntity(piece.id)
	end

end

----------------------------------------------------
--
--
function HeliStatic:OnSave(stm)
end

----------------------------------------------------
--
--
function HeliStatic:OnLoad(stm)
end

----------------------------------------------------
--
--
function HeliStatic:OnEventServer(id,params)


--	if (id==ScriptEvent_Reset)
--	then
--	end
end


----------------------------------------------------
--
--
----------------------------------------------------
--
--

function HeliStatic:OnWrite(stm)

end

----------------------------------------------------
--
--
function HeliStatic:OnRead(stm)
end


----------------------------------------------------
--
--
----------------------------------------------------
--
--


function HeliStatic:ExecuteDamageModel()

	-- if (self.damage>self.Properties.max_health*.2) then -- default .5
	if (self.damage>150*.2) then -- default .5

		-- middle damage
		local vVec=self:GetHelperPos("vehicle_damage1",0)
		Particle:CreateParticle(vVec,{x=0,y=0,z=1},self.DamageParticles1) --vector(0,0,1) is up

		-- maximum damage
		-- if (self.damage>self.Properties.max_health) then -- default .1
		if (self.damage>150) then -- default .1
			vVec=self:GetHelperPos("vehicle_damage2",0)
			Particle:CreateParticle(vVec,{x=0,y=0,z=1},self.DamageParticles2)
			HeliStatic.BlowUp(self)
		end
	end
end


function HeliStatic:BlowUp()


	if (self.bExploded==1) then
		do return end
	end

--	System:Log("BLOW UP!")

	local	 explDir={x=0,y=0,z=1}
	ExecuteMaterial(self:GetPos(),explDir,HeliExplosion,1)

	local ExplosionParams = {}
	ExplosionParams.pos = self:GetPos()
	local nDamage = self.Properties.ExplosionParams.nDamage
	if nDamage>600 then
		nDamage=600
	end
	ExplosionParams.damage = nDamage
	local fRadiusMax = self.Properties.ExplosionParams.fRadiusMax
	if fRadiusMax>70.5 then
		fRadiusMax=70.5
	end
	ExplosionParams.rmax = fRadiusMax
	local fRadiusMin = self.Properties.ExplosionParams.fRadiusMin
	if fRadiusMin>fRadiusMax then
		fRadiusMin=fRadiusMax
	end
	ExplosionParams.rmin = fRadiusMin
	local fRadius = self.Properties.ExplosionParams.fRadius
	if fRadius>30 then
		fRadius=30
	end
	ExplosionParams.radius = fRadius  -- Урон.
	local fImpulsivePressure = self.Properties.ExplosionParams.fImpulsivePressure
	if fImpulsivePressure>600 then
		fImpulsivePressure=600
	end
	ExplosionParams.impulsive_pressure = fImpulsivePressure  -- Имульс.
	ExplosionParams.shooter = self
	ExplosionParams.weapon = self
	Game:CreateExplosion(ExplosionParams)

--	ExplosionParams.pos = self:GetPos()
--	ExplosionParams.pos.x=ExplosionParams.pos.x+2
	ExplosionParams.pos =	self:GetHelperPos("vehicle_damage2",0)
	Game:CreateExplosion(ExplosionParams)

	--play explosion sound
	if (self.ExplosionSound) then
		--make sure to place the explosion sound at the correct position
		Sound:SetSoundPosition(self.ExplosionSound,self:GetPos())
		Sound:PlaySound(self.ExplosionSound)
		--System:Log("playing explo sound")
	end

	self:BreakOnPieces()

--	self.damage=0
	self.bExploded=1
	--self.IsPhisicalized = 0  -- so that the next call to reset will reload the normal model
end



--------------------------------------

function HeliStatic:BreakOnPieces()

local	pos=self:GetPos()
local	angle=self:GetAngles()
	self:DrawObject(0,0)
System:Log(" DoPiece ")
local	dir={x=0,y=0,z=1}
	for idx,piece in self.pieces do
System:Log(" Piece #"..idx)
		piece:DrawObject(0,1)
		piece:EnablePhysics(1)
		piece:SetPos(pos)
		piece:SetAngles(angle)
		dir.x= (2-random(0,4))
		dir.y= (2-random(0,4))
		dir.z= 2

--		piece:AddImpulseObj(dir,self.explosionImpulse)
		piece:Activate(piece)

	end

	if (self.sound_engine) then
		Sound:StopSound(self.sound_engine)
	end

	self:EnableUpdate(0)
--	Server:RemoveEntity(self.id)

end

--------------------------------------
--------------------------------------
--------------------------------------
--
--
