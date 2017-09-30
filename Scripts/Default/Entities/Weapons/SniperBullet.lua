-- Sniper Bullet (Mixer) v0.01

-- не передаётся sound dummy,on bullet rain.
-- Совместить со скиптом из мода
Script:LoadScript("scripts/default/entities/weapons/BaseProjectile.lua")
projectileDefinitionSP = {
	Param = {
		mass = 1,
		size = .15,
		heading = {},
		flags=1,
		initial_velocity = 499,
		k_air_resistance = 0,
		acc_thrust = 0,
		acc_lift = 0,
		surface_idx = -1,
		gravity = {x=0,y=0,z=-3},
		collider_to_ignore = nil,
		AI_Type = AIOBJECT_ATTRIBUTE,
	},

	ExplosionParams = {
		damage = 700,
		effect = "bullet_hit",
		shooter = nil,
		weapon = nil,
	},

	EngineSound = {
		name = "Sounds/Weapons/bullets/whiz1.wav",
		minDist = 1,
		maxDist = 50000,
	},
	projectileObject = "Objects/Weapons/trail.cgf",
	projectileObjectScale = 1,
	explodeOnContact = 1,
	lifetime = 4000,
}

SniperBullet = CreateProjectile(projectileDefinitionSP)

function SniperBullet:Server_OnUpdate(dt)
	self.isExploding = 1
	local status=GetParticleCollisionStatus(self)
	local poss=self:GetPos()
	if (status) then
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

		if (not shooter) and (status.target) then
			shooter = status.target
		end

		self.dir2 = self:GetDirectionVector()

		local hit =	{
			dir = self.dir2,
			normal = self.dir2,
			e_fx = self.ExplosionParams.effect.."",
			damage = self.ExplosionParams.damage*1,
			shooter = shooter,
			landed = 1,
			impact_force_mul_final=25,
			impact_force_mul=15,
			damage_type="normal",
			pos = poss,
			target_material = status.target_material,
			play_mat_sound = 1,
		}
		if (status.target) and (status.target.Damage) then
			-- Hud:AddMessage(hit.target_material.type.." damage: "..hit.damage)
			-- Hud:AddMessage(hit.target_material.type.." damage: "..hit.damage.." Distance "..dist.."m "..hit.target:GetName().." shooter: "..hit.shooter:GetName())
			hit.target = status.target
			status.target:Damage(hit)
		end
		if (Game:IsClient()) then
			ExecuteMaterial2(hit,hit.e_fx)
		end
		self.isExploding = 1
		self:SetTimer(1)
	elseif (System:IsValidMapPos(poss)~=1) then
		self.isExploding = 1
		self:SetTimer(1)
	elseif (not self.ExplosionParams.lnched) then
		self.ExplosionParams.lnched = 1
		if (self.ExplosionParams.shooterid) then
			local shootr = System:GetEntity(self.ExplosionParams.shooterid)
			if (shootr) and (shootr.cnt) and (shootr.cnt.weapon) then
				if (shootr.cnt.first_person) then
					--local fire_pos = shootr.cnt.weapon.cnt:GetBonePos("spitfire")
					--Particle:SpawnEffect(fire_pos,{x=0,y=0,z=1},"misc.sparks.a",1)
				else
					--local fire_pos = shootr.cnt:GetTPVHelper(0,"spitfire")
					--Particle:SpawnEffect(fire_pos,{x=0,y=0,z=1},"misc.sparks.a",1)
				end
			end
			if (shootr) and (shootr.fireparams) and (shootr.fireparams.damage) then
				self.ExplosionParams.damage = shootr.fireparams.damage*1
			end
		end
	end
end

SniperBullet.Server.OnUpdate = SniperBullet.Server_OnUpdate