-- Plasma Blob (Mixer)
Script:LoadScript("scripts/default/entities/weapons/BaseProjectile.lua")
projectileDefinitionSP = {
	Param = {
		mass = 1,
		size = .15,
		heading = {},
		flags=1,
		initial_velocity = 24,
		k_air_resistance = .2,
		acc_thrust = 0,
		acc_lift = 0,
		surface_idx = -1,
		gravity = {x=0,y=0,z=-8},
		collider_to_ignore = nil,
		AI_Type = AIOBJECT_ATTRIBUTE,
	},
	
	ExplosionParams = {
		pos = {},
		damage = 55,
		rmin = .8,  --Defines the minimum impulse pressure range
		rmax = .8,  --Defines the maximum impulse pressure range
		radius = .8, --Damage radius where point 0 is max damage. Damage falls off at 1/distance^2
		DeafnessRadius = 0,
		DeafnessTime = 0,
		impulsive_pressure = 0, -- default 5
		shooter = nil,
		weapon = nil,
		rmin_occlusion=0,
		occlusion_res=0,
		occlusion_inflate=0,
	},
	
	EngineSound = {
		name = "Sounds/Weapons/machete/machete_throw.wav",
		minDist = 5,
		maxDist = 50000,
	},
	projectileObject = "Objects/Weapons/machete/machete_bind.cgf",
	matEffect = "melee_slash",
	projectileObjectScale = 1,
	explodeOnContact = 1,
	lifetime = 10000,
}

ThrowMachete = CreateProjectile(projectileDefinitionSP)

function ThrowMachete:Server_OnUpdate(dt)
	Hud:AddMessage("MACHETE")
	self.isExploding = 1 
	local status=GetParticleCollisionStatus(self)
	local poss=self:GetPos()
	if (status) then
		if (status.target) and (status.target.Damage) then
			local shooter = self.shooter 
			if (self.shooterSSID) then
				local player_slot=Server:GetServerSlotBySSId(self.shooterSSID)
				if (player_slot) then
					shooter = player_slot:GetPlayerId()
					if (shooter) then
						shooter = System:GetEntity(shooter)
					end
				else
					local Entities
					if GameRules.AllEntities then
						Entities = GameRules.AllEntities
					end
					if not Entities then
						Entities = System:GetEntities() -- Пожар. Это на случай, если вдруг игрок случайно пальнёт в первую секунду после старта игры и попадёт. Шанс этого, конечно, просто бешенный.
					end
					for i,entity in Entities do
						if (entity.vbot_ssid) then
							if (entity.vbot_ssid==self.shooterSSID) then
							shooter = entity 
							break 
							end
						end
					end
				end
			end
			
			if (not shooter) and (not self.shooterSSID) then
				shooter = status.target 
			end
			
			local hit =	{
				dir = status.normal,
				normal = status.normal,
				e_fx = "melee_slash",
				damage = 100,
				target = status.target,
				shooter = shooter,
				shooterSSID = self.shooterSSID,
				landed = 1,
				impact_force_mul_final=25,
				impact_force_mul=15,
				damage_type="normal",
				pos = poss,
				target_material = status.target_material,
				weapon = {name="MacheteFly"},
				play_mat_sound = 1,
			} 
			if (status.target.cnt) and (status.target.type=="Player") then
				hit.tempstt = ceil(status.target.cnt.max_health*.5)
				if (status.target_material) and (status.target_material.type~="armor" and status.target_material.type~="helmet") then
					BasicPlayer.SetBleeding(status.target,0,hit.tempstt,self.shooterSSID)
				end
			end
			status.target:Damage( hit )
		end
		self.isExploding = 1 
		if (not self.pickup_gen) then
			-- Create Machete pickup here:
			local cid=Game:GetEntityClassIDByClassName("PickupMachete_p")
			if (not cid) or (Game:IsMultiplayer()) then
				cid=Game:GetEntityClassIDByClassName("PickupMachete")
			end
			self.pickup_gen={
				classid=cid,
				pos=status.pos,
				angles={x=0,y=0,z=0},
			} 
			ConvertVectorToCameraAngles(self.pickup_gen.angles,status.normal)
			self.pickup_gen.angles.x = 0 
			self.pickup_gen.angles.y = 0 
			local DroppedItem = Server:SpawnEntity(self.pickup_gen)
			-- tiny hack to prevent instant picking dropped item back:
			DroppedItem.pp_lastdrop = _time + .8 
			----------
			if (not DroppedItem.physpickup) then
				DroppedItem.autodelete=1 
				DroppedItem:EnableSave(1)
				if GameRules.GetPickupFadeTime then
					DroppedItem:SetFadeTime(GameRules:GetPickupFadeTime())
				end
				DroppedItem:GotoState("Dropped")
			else
				-- prepare and throw physical pickup
				DroppedItem:SetViewDistRatio(255)
				local sdv = new(self:GetDirectionVector())
				DroppedItem:AddImpulse(-1,status.pos,sdv,41*DroppedItem.Properties.Animation.Speed)
			end
			----------
		end
		self:SetTimer(200)
	elseif (System:IsValidMapPos(poss)~=1) then
		self.isExploding = 1 
		self:SetTimer(1)
	elseif (not self.ExplosionParams.lnched) then
		self.ExplosionParams.lnched = 1 
	end
end

function ThrowMachete:Client_OnInit()
	self.part_time = 0 
	if (self.bPhysicalized==nil) then
		self:CreateParticlePhys( 2, 10 )
		self.bPhysicalized=1 
	end
	self.Param.heading = self:GetDirectionVector()
	
	self:SetPhysicParams( PHYSICPARAM_PARTICLE, self.Param )
	
	self:EnableUpdate(1)

	self:SetViewDistRatio(255)

	self:LoadObject( self.projectileObject,0, self.projectileObjectScale)

	local engineSound = self.EngineSound 
	if (engineSound) then
		engineSound.sound = Sound:Load3DSound(engineSound.name, 512)
		Sound:SetMinMaxDistance(engineSound.sound, engineSound.minDist, engineSound.maxDist)
		Sound:SetSoundLoop(engineSound.sound, 1)
		self:PlaySound(engineSound.sound)
	end
	self.theweirdang = self:GetAngles()
	self.theweirdxpos = self:GetPos().x 
end

function ThrowMachete:Client_OnUpdate(dt)
	Hud:AddMessage("MACHETE")
	if (self.isTerminating) then
		return
	end
	
	local pos = self:GetPos()
	
	if (self.theweirdang) then
		self.theweirdang.x = mod(_time*-3,5) * 360 
		self:SetAngles(self.theweirdang)
	end

	if (self.theweirdxpos) then
		if (self.theweirdxpos~=pos.x) then
			self:DrawObject( 0, 1 )
		else
			return
		end
		self.theweirdxpos = nil 
	end

	if (Materials["mat_water"] and Materials["mat_water"].projectile_hit) then
		if (not self.was_underwater) then
			if (Game:IsPointInWater(pos)) then
				self.was_underwater=1 
				ExecuteMaterial(pos, g_Vectors.v001, Materials.mat_water.projectile_hit, 1 )
			end
		end
	end
	
	local status=GetParticleCollisionStatus(self)
	if (status) then
		local hit =	{
			dir = status.normal,
			normal = status.normal,
			e_fx = "melee_slash",
			shooter = self,
			landed = 1,
			impact_force_mul_final = 25,
			impact_force_mul = 15,
			damage_type="normal",
			pos = status.pos,
			target_material = status.target_material,
			play_mat_sound = 1,
		} 
		ExecuteMaterial2( hit ,hit.e_fx)
	end
end

ThrowMachete.Server.OnUpdate = ThrowMachete.Server_OnUpdate 
ThrowMachete.Client.OnInit = ThrowMachete.Client_OnInit 
ThrowMachete.Client.OnUpdate = ThrowMachete.Client_OnUpdate 