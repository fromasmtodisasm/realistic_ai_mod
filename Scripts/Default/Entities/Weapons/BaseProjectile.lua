BaseProjectile = {
	tid_cloud = System:LoadTexture("textures/cloud.jpg"),
	decal_tid = System:LoadTexture("textures/decal/explo_decal.dds"),
	deleteOnGameReset=1,
	bPhysicalized = nil,
	was_underwater=nil,
	fDeformRadius = 3.5, -- 3
	SoundEvent = {
		fVolumeRadius = 200, -- default 13
		fThreat = 1, -- default 1
		fInterest = 0,
	},
}

function BaseProjectile:Server_OnInit()
	self.part_time = 0
	if not self.bPhysicalized then
		self:CreateParticlePhys(2,10,0)
		self.bPhysicalized=1
	end

	self.ExplosionParams = new(self.ExplosionParams)

	--if this projectile have some special parameters for multiplayer,merge them.
	if (Game:IsMultiplayer() and self.ExplosionParams_Mp) then
		merge(self.ExplosionParams,self.ExplosionParams_Mp)
	end

	self:EnableUpdate(1)

	-- explode after a set amount of time
	self:SetTimer(self.lifetime)
	-- Hud:AddMessage("INIT")
end

function BaseProjectile:Client_OnInit()
	self.part_time = 0
	if not self.bPhysicalized then
		self:CreateParticlePhys(2,10)
		self.bPhysicalized=1
	end
	self.Param.heading = self:GetDirectionVector()

	self:SetPhysicParams(PHYSICPARAM_PARTICLE,self.Param)

	self:EnableUpdate(1)

	-- self:SetViewDistRatio(255)
	self:LoadObject(self.projectileObject,0,self.projectileObjectScale)

	local EngineSound = self.EngineSound
	if EngineSound then
		EngineSound.sound = Sound:Load3DSound(EngineSound.name,SOUND_UNSCALABLE)
		Sound:SetMinMaxDistance(EngineSound.sound,EngineSound.minDist,EngineSound.maxDist)
		Sound:SetSoundLoop(EngineSound.sound,1)
		if Hud and Hud.SharedSoundScale~=0 then
			self:PlaySound(EngineSound.sound)
		end
	end

	-- FIXME: please leave this in for now ... a weird check to detect client/server synchronization issue
	self.theweirdxpos = self:GetPos().x
end

function BaseProjectile:Server_OnUpdate(dt)
	if not self.AllowShoot then return end
	local status=GetParticleCollisionStatus(self)
	local pos=self:GetPos()
	if status and (self.explodeOnContact==1 or self.IsBullet or self.MG_Explosive) then
		self.isExploding = 1
	elseif (System:IsValidMapPos(pos)~=1) then
		self.isExploding = 1
	end
	-- local Pos = self:GetPos() -- Неправльно, убирает все миномётные выстрелы.
	-- if self.SaveRocketPos then -- Если после сброса в редакторе ракета остаётся на одном месте, то удалить её.
		-- if (self.SaveRocketPos.x<=Pos.x+1 or self.SaveRocketPos.x>=Pos.x-1)
		-- and (self.SaveRocketPos.y<=Pos.y+1 or self.SaveRocketPos.y>=Pos.y-1)
		-- and (self.SaveRocketPos.z<=Pos.z+1 or self.SaveRocketPos.z>=Pos.z-1) then
			-- -- self.IsTerminating = 1
			-- local Shooter = self.shooter
			-- if not Shooter then Shooter="nil" end
			-- Hud:AddMessage(Shooter:GetName()..": Projectile is terminating!")
			-- System:Log(Shooter:GetName()..": Projectile is terminating!")
			-- Server:RemoveEntity(self.id)
		-- end
	-- end
	self.SaveRocketPos = new(Pos)
	if self.isExploding==1 and not self.IsTerminating then
		if self.IsBullet then
			-- -- self:DrawObject(0,0) -- Так можно прятать искры из глаз.
			self:SetTimer(1) -- Вот, так то лучше, и об искрах можно не беспокоиться. Вот только если материал простреливаемый, то пусть пуля летит дальше.
			-- -- self:EnableUpdate(0)
		end
		self.ExplosionParams.pos = pos
		if not self.IsBullet or self.MG_Explosive then
			Game:CreateExplosion(self.ExplosionParams)
		end

		if not status then
			status = {}
			status.objtype = 0
			if (self.force_objtype) then
				status.objtype = self.force_objtype
			end
		end

		if (not status.normal) then
			status.normal = g_Vectors.v001
		end

		-- spawn client side effect
		Server:BroadcastCommand("FX",self:GetPos(),status.normal,self.id,status.objtype)						-- invoke OnServerCmd() on the client

		local soundEvent = self.SoundEvent
		if soundEvent and self.ExplosionParams.shooterid and (not self.IsBullet or self.MG_Explosive) then
			-- if self.MG_Explosive then -- Временно.
				-- SoundEvent = {
					-- fVolumeRadius = 50,
					-- fThreat = 1,
					-- fInterest = 0,
				--}
			-- end
			AI:SoundEvent(self.id,pos,soundEvent.fVolumeRadius,soundEvent.fThreat,soundEvent.fInterest,self.ExplosionParams.shooterid)
		end

		--System:Log("Terminate")
		if not self.IsBullet then
			self:SetTimer(1000)
		end
		self.IsTerminating = 1
	end

	-- self.PrevPos = new(pos) -- Пока только так.
	-- -- if self.PrevPos then
		-- -- System:Log("pos 1: "..self.PrevPos.x..","..self.PrevPos.y..","..self.PrevPos.z)
	-- -- end
	-- if not self.PosHistory then self.PosHistory={} end
	-- if not self.TheNumberOfRows then self.TheNumberOfRows=0 end
	-- for i,val in self.PosHistory do -- i всегда начинается с еденицы.
		-- if self.TheNumberOfRows~=i then
			-- self.TheNumberOfRows=i
		-- end
	-- end
	-- if not self.FlyCount then self.FlyCount=0 end
	-- self.FlyCount=self.FlyCount+1
	-- System:Log("FLY: "..self.FlyCount)
	-- -- System:Log("START")
	-- for i=0,self.TheNumberOfRows do
		-- if i==self.TheNumberOfRows then
			-- self.PosHistory[i+1]=self.PrevPos
			-- -- if i>0 then
				-- -- System:Log("i: "..i..", val:"..self.PosHistory[i].x..", val+1:"..self.PosHistory[i+1].x)
			-- -- end
		-- end
		-- -- if self.PosHistory[i] and self.PosHistory[i+1] then
			-- -- System:Log("i: "..i..", val:"..self.PosHistory[i].x..", val+1:"..self.PosHistory[i+1].x)
		-- -- end
	-- end
	-- -- System:Log("END")
end

function BaseProjectile:Client_OnUpdate(dt)
	if self.IsTerminating or not self.AllowShoot then return end

	local pos = self:GetPos()

	-- FIXME: please leave this in for now ... a weird check to detect client/server synchronization issue
	if (self.theweirdxpos) then
		if self.Param.nosmoke~=1 or tonumber(getglobal("game_DifficultyLevel"))<2 or self.MG_Explosive then
			if (self.theweirdxpos~=pos.x) then
				self:DrawObject(0,1) -- Заменить обьект.
				-- Initialize Smoke trail particles.
				if self.SmokeEffectEmitter then
					self:CreateParticleEmitterEffect(0,self.SmokeEffectEmitter,1000,g_Vectors.v000,g_Vectors.v010,1) -- А вот и размерчик дыма в конце указан.
				end
			else
				return
			end
		end
		self.theweirdxpos = nil
	end

	if (self.Smoke and not self.was_underwater and self.Param.nosmoke~=1) then
		self.part_time = self.part_time + dt*2
		if (self.part_time>.03) then
			Particle:CreateParticle(pos,g_Vectors.v000,self.Smoke)
			self.part_time=0
		end
	end

	if (self.SmokeEffect) then
		local dir = self:GetDirectionVector()
		Particle:SpawnEffect(pos,dir,self.SmokeEffect,1)
		-- System:Log(": dir.z "..dir.z..": dir.x "..dir.x..": dir.y "..dir.y)
	end

	if (Materials["mat_water"] and Materials["mat_water"].projectile_hit) then
		if (not self.was_underwater) then
			if (Game:IsPointInWater(self:GetPos())) then
				-- System:Log("UNDERWATER")
				self.was_underwater=1
				ExecuteMaterial(pos,g_Vectors.v001,Materials.mat_water.projectile_hit,1)
			end
		end
	end

	if (self.dynamic_light~=0) then
		-- raduis,r,g,b,lifetime
		CreateEntityLight(self,self.dynamic_light*2,.5,.5,.4,0)
	end

--	local doProjectileLight = tonumber(getglobal("cl_projectile_light"))
--	if (self.dynamic_light~=0 and doProjectileLight==1) then		-- no specular
--		-- vPos,fRadius,DiffR,DiffG,DiffB,DiffA,SpecR,SpecG,SpecB,SpecA,fLifeTime
--		self:AddDynamicLight(self:GetPos(),self.dynamic_light*2,1,1,.7,1,0,0,0,0,.5)
--	elseif (self.dynamic_light~=0 and doProjectileLight==2) then		-- with specular
--		self:AddDynamicLight(self:GetPos(),self.dynamic_light*2,1,1,.7,1,1,1,.7,1,.5)
--	end

	-- if (self.Param.AI_Type) then
		-- if (self.Param.AI_Type==AIOBJECT_ATTRIBUTE) then
			-- if (self.Param.AI_Type_ALTERNATE) then
				-- AI:RegisterWithAI(self.id,self.Param.AI_Type_ALTERNATE)
				-- self.Param.AI_Type = self.Param.AI_Type_ALTERNATE
			-- end
		-- end
	-- end
	if (self.Param.AI_Type or self.changetype) then
		if (self.Param.AI_Type==AIOBJECT_ATTRIBUTE) then
			if (self.Param.AI_Type_ALTERNATE) then
				if not self.changetype then self.changetype = 1  end
				if self.changetype <= 1 then
					AI:RegisterWithAI(self.id,self.Param.AI_Type_ALTERNATE)
					self.changetype = self.changetype+1
				elseif self.changetype >= 3 then -- Так хорошо убегает от гранат(если AI_Type_ALTERNATE равен AIOBJECT_DAMAGEGRENADE).
				-- elseif self.changetype >= 2 then -- А так лучше замечает противника.
					local shooter = self.shooter  -- Не убирать!
					AI:RegisterWithAI(self.id,self.Param.AI_Type,shooter.id)
					self.changetype = self.changetype-1
				end
			end
		end
	end
end

function BaseProjectile:Launch(weapon,shooter,pos,angles,dir,target) -- Починить, даже Mortar.Client:OnEvent(EventId,Params) не вызывается.
	if shooter.ai and self.UseAIProjectileShoot then
		self.Param.initial_velocity = AI:ProjectileShoot(shooter.id,self.Param)
		-- Hud:AddMessage(shooter:GetName()..": initial_velocity: "..self.Param.initial_velocity)
		if self.Param.initial_velocity<=50 then -- Вблизи и смотрится не очень, и по себе может случайно пальнуть.
			Server:RemoveEntity(self.id) -- Удаляет снаряд и всё сопутствующее.
			for i,nSoundIdx in shooter.sounddata.FireSounds do -- Останавливает звук выстрела.
				Sound:StopSound(nSoundIdx)
			end
			for i,nSoundIdx in shooter.sounddata.FireSoundsStereo do
				Sound:StopSound(nSoundIdx)
			end
			AI:Signal(0,1,"RETURN_TO_NORMAL",shooter.id) -- Говорит слезть с миномёта. В режиме практики не сработает, потому на карте Форт нормально проходит...
			return
		end
	else
		self.Param.heading = dir
	end
	self.AllowShoot = 1
	-- self:SetTimer(.1)

	-- Должен временно не видеть цели сам посмотреть чуть выше прежде чем стрелять. Сделать просмотр найденых режимов в новой пушке.
	-- register with the AI system
	if (self.Param.AI_Type) then
		if (self.Param.AI_Type==AIOBJECT_ATTRIBUTE) then
			AI:RegisterWithAI(self.id,AIOBJECT_ATTRIBUTE,shooter.id)
		else
			AI:RegisterWithAI(self.id,self.Param.AI_Type)
		end
	else
		AI:RegisterWithAI(self.id,AIAnchor.AIOBJECT_DAMAGEGRENADE)
	end
	self.shooter = shooter
	self.Param.collider_to_ignore = shooter
	local projectilepos = g_Vectors.temp_v1

	--[kirill] start from some helper's position - for vehicle mounted RLs
	--filippo: the helper position is not take into consideration inside the C++ code,so in this case,recalculate the direction vector.
	if (self.LaunchHelper and not shooter.ai) then
		CopyVector(projectilepos,shooter.cnt:GetTPVHelper(0,self.LaunchHelper))
		local dest = g_Vectors.temp_v2
		dest.x = pos.x + dir.x * 150
		dest.y = pos.y + dir.y * 150
		dest.z = pos.z + dir.z * 150
		local hits = System:RayWorldIntersection(pos,dest,1,ent_static+ent_sleeping_rigid+ent_rigid+ent_independent+ent_terrain+ent_living,shooter.id)
		--if we found a hit point (most of cases), use it to recalculate direction of the projectile.
		-- but the point has to be not closer than 5 meters (to prevent shooting backwards)
		if (getn(hits)>0 and hits[1].dist>5) then
			local hitpos = g_Vectors.temp_v3
			CopyVector(hitpos,hits[1].pos)
			dest.x = hitpos.x - projectilepos.x
			dest.y = hitpos.y - projectilepos.y
			dest.z = hitpos.z - projectilepos.z
			NormalizeVector(dest)
			self.Param.heading = dest
		end
	else
		--otherwise use the normal position we got
		CopyVector(projectilepos,pos)
	end

	self:SetPhysicParams(PHYSICPARAM_PARTICLE,self.Param)

	-- self:SetViewDistRatio(255)
	self:SetPos(projectilepos)
	-- local att_target = AI:GetAttentionTargetOf(shooter.id)
	-- if att_target and type(att_target)=="table" then
		-- dir.z = shooter:GetAngles().z+att_target:GetAngles().z
		-- System:Log(shooter:GetName()..": shooter:GetAngles().z "..shooter:GetAngles().z)
		-- local NewAngles = shooter:GetAngles()
		-- -- NewAngles.x = shooter:GetAngles().x+att_target:GetPos().x
		-- -- NewAngles.y = shooter:GetAngles().y+att_target:GetPos().y
		-- NewAngles.z = shooter:GetAngles().z+att_target:GetPos().z
		-- AI:MakePuppetIgnorant(shooter.id,1)
		-- shooter:SetAngles(NewAngles)
		-- AI:MakePuppetIgnorant(shooter.id,0)
		-- Hud:AddMessage(shooter:GetName()..": dir.z "..dir.z.." pos.z "..pos.z.." angles.z "..angles.z)
		-- dir.z=dir.z+att_target:GetPos().z
	-- end
	-- System:Log(shooter:GetName()..": dir.z "..dir.z.." pos.z "..pos.z.." angles.z "..angles.z.." shooter:GetAngles().z "..shooter:GetAngles().z)
	self:SetAngles(angles)
	self.ExplosionParams.shooterid = shooter.id
	self.ExplosionParams.weapon = self 		-- dangerous  - was weapon

--	System:Log("Lauched BaseProjectile id="..self.id.."team="..Game:GetEntityTeam(shooter.id))				-- debug

	self.LaunchedByTeam=Game:GetEntityTeam(shooter.id)
	self.isExploding = nil

	if (TargetLocker and shooter==_localplayer) then
		self.Target=TargetLocker:PopTarget()
	end

	-- the ID of the server slot who 'shot' this health pack
	-- used for statistics
	local serverSlot = Server:GetServerSlotByEntityId(shooter.id)

	--System:Log("BaseProjectile:Launch "..tostring(shooter.id))

	if (serverSlot) then
		self.shooterSSID = serverSlot:GetId()
		self.ExplosionParams.shooterSSID = serverSlot:GetId()
		--System:Log("BaseProjectile:Launch b")
	end
end

function BaseProjectile:Shot(weapon,shooter,pos,angles,dir,distance,damage,damagedroppermeters,impactforcemul,impactforcemulfinal,impactforcemulfinaltorso,
	deathanim) -- Назвать по нормальному.
	if shooter.current_mounted_weapon and shooter.current_mounted_weapon.fireOn and shooter.current_mounted_weapon.fireOn==0 then
		Server:RemoveEntity(self.id) -- А может в Длл запретить спавн?
		return
	end
	self.AllowShoot = 1
	-- Стреляем пульками.
	-- Hud:AddMessage(shooter:GetName()..": SHOT")
	-- if (self.Param.AI_Type) then -- Регать светящийся bullet
		-- if (self.Param.AI_Type==AIOBJECT_ATTRIBUTE) then
			-- AI:RegisterWithAI(self.id,AIOBJECT_ATTRIBUTE,shooter.id)
		-- else
			-- AI:RegisterWithAI(self.id,self.Param.AI_Type)
		-- end
	-- else
		-- AI:RegisterWithAI(self.id,AIAnchor.AIOBJECT_DAMAGEGRENADE)
	-- end

	-- if not deathanim then deathanim="nil" end
	-- System:Log(shooter:GetName()..": weapon.name: "..weapon.name..", pos.x: "..pos.x..", pos.y: "..pos.y..", pos.z: "..pos.z..", dir.x: "..dir.x..
	-- ", dir.y: "..dir.y..", dir.z: "..dir.z..", distance: "..distance..", damage: "..damage..
	-- ", damagedroppermeters: "..damagedroppermeters..", impactforcemul: "..impactforcemul..", impactforcemulfinal: "..impactforcemulfinal..
	-- ", impactforcemulfinaltorso: "..impactforcemulfinaltorso..", deathanim: "..deathanim)
	-- if deathanim=="nil" then deathanim=nil end

	self.shooter = shooter
	self.IsBullet = 1
	self.Damage = damage
	self.DamageDropPerMeters = damagedroppermeters
	self.iImpactForceMul = impactforcemul
	self.iImpactForceMulFinal = impactforcemulfinal
	self.iImpactForceMulFinalTorso = impactforcemulfinaltorso
	self.ShooterWeapon = weapon
	self.iDeathAnim = deathanim
	self.SaveShooterPos = new(shooter:GetPos())
	-- special AI processing (for Mortar)
	if (shooter.ai and self.UseAIProjectileShoot) then
		BaseProjectile.default_iv = self.Param.initial_velocity
		self.Param.initial_velocity = AI:ProjectileShoot(shooter.id,self.Param)
	else
		self.Param.heading = dir
	end

	self.Param.collider_to_ignore = shooter -- Нужно?

	--filippo: moved below
	--self:SetPhysicParams(PHYSICPARAM_PARTICLE,self.Param)

	if (BaseProjectile.default_iv) then
		self.Param.initial_velocity = BaseProjectile.default_iv
		BaseProjectile.default_iv = nil
	end

	local projectilepos = g_Vectors.temp_v1

	--[kirill] start from some helper's position - for vehicle mounted RLs
	--filippo: the helper position is not take into consideration inside the C++ code,so in this case,recalculate the direction vector.
	if (self.LaunchHelper and not shooter.ai) then
		CopyVector(projectilepos,shooter.cnt:GetTPVHelper(0,self.LaunchHelper))
		local dest = g_Vectors.temp_v2
		dest.x = pos.x + dir.x * 150
		dest.y = pos.y + dir.y * 150
		dest.z = pos.z + dir.z * 150
		local hits = System:RayWorldIntersection(pos,dest,1,ent_static+ent_sleeping_rigid+ent_rigid+ent_independent+ent_terrain+ent_living,shooter.id)
		--if we found a hit point (most of cases), use it to recalculate direction of the projectile.
		-- but the point has to be not closer than 5 meters (to prevent shooting backwards)
		if (getn(hits)>0 and hits[1].dist>5) then
			local hitpos = g_Vectors.temp_v3
			CopyVector(hitpos,hits[1].pos)
			dest.x = hitpos.x - projectilepos.x
			dest.y = hitpos.y - projectilepos.y
			dest.z = hitpos.z - projectilepos.z
			NormalizeVector(dest)
			self.Param.heading = dest
		end
	else
		--otherwise use the normal position we got
		CopyVector(projectilepos,pos)
	end

	self:SetPhysicParams(PHYSICPARAM_PARTICLE,self.Param)

	-- self:SetViewDistUnlimited()
	self:SetPos(projectilepos)
	self:SetAngles(angles)
	self.ExplosionParams.shooterid = shooter.id
	self.ExplosionParams.weapon = self 		-- dangerous  - was weapon

--	System:Log("Lauched BaseProjectile id="..self.id.."team="..Game:GetEntityTeam(shooter.id))				-- debug

	self.LaunchedByTeam=Game:GetEntityTeam(shooter.id)
	self.isExploding = nil

	if (TargetLocker and shooter==_localplayer) then
		self.Target=TargetLocker:PopTarget()
	end

	-- the ID of the server slot who 'shot' this health pack
	-- used for statistics
	local serverSlot = Server:GetServerSlotByEntityId(shooter.id)

	--System:Log("BaseProjectile:Launch "..tostring(shooter.id))

	if (serverSlot) then
		self.shooterSSID = serverSlot:GetId()
		self.ExplosionParams.shooterSSID = serverSlot:GetId()
		--System:Log("BaseProjectile:Launch b")
	end

	local Current_AmmoInClip = shooter.cnt.ammo_in_clip -- 1 уже в пути
	local Current_BulletsPerClip = shooter.fireparams.bullets_per_clip
	local UseTrail
	local Number=Current_BulletsPerClip
	for i=1,Current_BulletsPerClip do
		-- System:Log(shooter:GetName()..": Number: "..Number..", Current_AmmoInClip: "..Current_AmmoInClip..", Current_BulletsPerClip: "..Current_BulletsPerClip..", i: "..i)
		if (Number==Current_AmmoInClip+1 and Current_AmmoInClip>0) or (Number==Current_AmmoInClip and Current_AmmoInClip==0) then
			UseTrail=1 -- Каждые пять пуль, выпущеные из оружия, трассерные.
			-- Hud:AddMessage(shooter:GetName()..": UseTrail, Number: "..Number)
			break
		end
		if Number<Current_AmmoInClip then break end
		Number=Number-5
	end
	local AllowGenerateTrace -- Почти точная копия из функции OnFire.
	if not shooter.GunTableOfRandomTrace then shooter.GunTableOfRandomTrace = {} AllowGenerateTrace = 1 end
	if not shooter.GunTableOfRandomTrace[WeaponClassesEx[weapon.name].id] then shooter.GunTableOfRandomTrace[WeaponClassesEx[weapon.name].id] = {} AllowGenerateTrace = 1 end
	if not shooter.GunTableOfRandomTrace[WeaponClassesEx[weapon.name].id].Color then shooter.GunTableOfRandomTrace[WeaponClassesEx[weapon.name].id].Color = {} AllowGenerateTrace = 1 end
	local TableColor = shooter.GunTableOfRandomTrace[WeaponClassesEx[weapon.name].id].Color
	for i,val in weapon.FireParams do
		if i==shooter.firemodenum then
			local Color
			if AllowGenerateTrace then
				if random(1,2)==1 then
					Color="RED"
				else
					Color="GREEN"
				end
			else
				Color = TableColor[i]
			end
			-- if UseTrail then -- Правильное.
			local Difficulty = tonumber(getglobal("game_DifficultyLevel"))
			if (UseTrail or Difficulty<2) and Color then -- Цвет почему-то иногда пропадает.
				AI:RegisterWithAI(self.id,AIOBJECT_ATTRIBUTE,shooter.id)
				if i>1 and weapon.FireParams[i].AmmoType==weapon.FireParams[1].AmmoType then -- На всякий случай. Может чуть неправильно работать...
					if TableColor[i] and TableColor[1] and TableColor[i]~=TableColor[1] then
						TableColor[i] = TableColor[1]
						Color = TableColor[1]
					end
				end
				if Color=="RED" then
					self.projectileObject="Objects/Weapons/p_tracer_r.cgf"
				elseif Color=="GREEN" then
					self.projectileObject="Objects/Weapons/p_tracer_g.cgf"
				end
				if shooter.fireparams.projectile_class=="Bullet" then
					self.projectileObjectScale=1
				elseif shooter.fireparams.projectile_class=="BulletMG" then
					self.projectileObjectScale=1
				end
				-- Hud:AddMessage(shooter:GetName()..": Weapon: "..weapon.name..", Color: "..Color..", i: "..i)
				-- System:Log(shooter:GetName()..": Weapon: "..weapon.name..", Color: "..Color..", i: "..i)
				TableColor[i] = Color
			else
				self.projectileObject = nil
			end
		end
	end
	-- if shooter.fireparams.projectile_class=="Bullet" then
		-- if UseTrail then
			-- self.projectileObject = "Objects/Weapons/trail.cgf"
			-- AI:RegisterWithAI(self.id,AIOBJECT_ATTRIBUTE,shooter.id)
		-- else -- Хаха, да здесь только гильзы!
			-- if shooter.fireparams.AmmoType=="SMG" then
				-- self.projectileObject = "Objects/Weapons/shells/smgshell.cgf"
			-- elseif shooter.fireparams.AmmoType=="Sniper" then
				-- self.projectileObject = "Objects/Weapons/shells/snipershell.cgf"
			-- else
				-- self.projectileObject = "Objects/Weapons/shells/rifleshell.cgf"
			-- end
		-- end
		-- self.projectileObjectScale=1
	-- elseif shooter.fireparams.projectile_class=="BulletMG" then
		-- -- -- if UseTrail then -- Посмотреть как можно вычислить количество или сделать боезапас заканчивающимся.
			-- -- -- self.projectileObject = "Objects/Weapons/trail_mounted.cgf" -- Надо доработать, чтобы не из глаз вылетало.
			-- -- -- self.projectileObjectScale=1
		-- -- -- else
			-- -- self.projectileObject = "Objects/Weapons/shells/rifleshell.cgf"
			-- -- self.projectileObjectScale=1.6
		-- -- -- end

		-- -- if tonumber(getglobal("game_DifficultyLevel"))<2 then -- Пусть лучше всегда пули светятся.
			-- self.projectileObject = "Objects/Weapons/trail_mounted.cgf"
			-- self.projectileObjectScale=1
			-- AI:RegisterWithAI(self.id,AIOBJECT_ATTRIBUTE,shooter.id)
		-- -- else
			-- -- self.projectileObject = "Objects/Weapons/shells/rifleshell.cgf"
			-- -- self.projectileObjectScale=1.6
		-- -- end
	-- end
	if self.projectileObject then
		self:LoadObject(self.projectileObject,0,self.projectileObjectScale)
	end
end

function BaseProjectile:Client_OnRemoteEffect(toktable,pos,normal,userbyte) -- Убрать лишние импульсы. Узнать что приводит к взыву пули от стационарного пулемёта.
	-- Hud:AddMessage(self.shooter:GetName()..": Client_OnRemoteEffect")
	if not self.AllowShoot then return end
	-- System:Log("REMOTE") -- После ремоута продолжает почему то обновлять. Теперь исправил.
	-- Hud:AddMessage("OnRemoteEffect")
	self:DrawObject(0,0)
	local originalpos = new(pos)
	local hit = {}
	hit.pos = originalpos
	hit.normal = normal
	hit.target_material = Materials.mat_default
	hit.play_mat_sound = 1
	hit.objtype = userbyte
	local status = GetParticleCollisionStatus(self)
	if self.IsBullet and status then
		hit.target = status.target
		if status.target then
			hit.target_id = status.target.id
			-- Hud:AddMessage("partid: "..status.ipart)
			-- Оформить под условие "если есть" так как цель может быть просто entity.
			-- hit.ipart = -- Без id частей тела, в которые было совершено попадание, работает не полноценно. В частности, неправильно распределяются все импульсы.
		end
		local shooter = self.shooter
		hit.shooter = shooter
		local Distance = self:GetDistanceFromPoint(self.SaveShooterPos)
		hit.dir = self:GetDirectionVector()
		-- Hud:AddMessage("Distance: "..Distance)
		local DamageDrop = Distance*self.DamageDropPerMeters
		hit.damage = (self.Damage-DamageDrop)
		hit.damage_type = "normal"
		hit.landed = 1
		-- for i=0,self.TheNumberOfRows do -- По истории можно определять направление и вручную корректировать
			-- if i==self.TheNumberOfRows then
				-- -- self.PosHistory[i+1]=self.PrevPos
				-- if i>0 then
					-- System:Log("i: "..i..", val:"..self.PosHistory[i].x..", val+1:"..self.PosHistory[i+1].x)
				-- end
			-- end
			-- -- if self.PosHistory[i] and self.PosHistory[i+1] then
			-- -- if i>0 then
				-- -- System:Log("0  i: "..i..", val:"..self.PosHistory[i].x..", val+1:"..self.PosHistory[i+1].x)
			-- -- end
			-- -- end
		-- end

		-- local X,Y,Z
		-- local Offset = 1
		-- if hit.pos.x > self.SaveShooterPos.x then
			-- X = hit.pos.x + Offset
		-- elseif hit.pos.x < self.SaveShooterPos.x then
			-- X = hit.pos.x + Offset
		-- elseif hit.pos.x==self.SaveShooterPos.x then
			-- X = hit.pos.x
		-- end
		-- if hit.pos.y > self.SaveShooterPos.y then
			-- Y = hit.pos.y + Offset
		-- elseif hit.pos.y < self.SaveShooterPos.y then
			-- Y = hit.pos.y + Offset
		-- elseif hit.pos.y==self.SaveShooterPos.y then
			-- Y = hit.pos.y
		-- end
		-- if hit.pos.z > self.SaveShooterPos.z then
			-- Z = hit.pos.z + Offset
		-- elseif hit.pos.z < self.SaveShooterPos.z then
			-- Z = hit.pos.z + Offset
		-- elseif hit.pos.z==self.SaveShooterPos.z then
			-- Z = hit.pos.z
		-- end
		-- local PartPos = {x=X,y=Y,z=Z}


		-- self:SetScriptUpdateRate(0) -- Поможет?


		-- System:Log("PartPos: "..PartPos.x..","..PartPos.y..","..PartPos.z..", hit.pos.: "..hit.pos.x..","..hit.pos.y..","..hit.pos.z)
		local PartID = self.ShooterWeapon.cnt:GetHitPartID(hit.pos,hit.dir) -- hit.pos,hit.dir -- game_NewShootingMode 0, 1
		-- local PartID = self.ShooterWeapon.cnt:GetHitPartID(self.PrevPos,hit.dir) -- Пока есть проблема с указанием правильной позиции попадания, чтобы id правильно указывало. Можно в принципе попробовать пустить луч и здесь.
		if PartID then
			-- Hud:AddMessage("PartID: "..PartID)
			hit.ipart = PartID
		end
		-- hit.ipart =
		-- hit.targetStat =
		-- hit.objecttype =
		-- hit.projectile =
		-- hit.surface_id =
		hit.weapon_death_anim_id = self.iDeathAnim
		-- Hud:AddMessage("Distance: "..Distance.." hit.damage: "..hit.damage..", self.Damage: "..self.Damage)
		hit.impact_force_mul = self.iImpactForceMul -- MakeDeadbody по этому вопросу. Птички: theAction.ipart = 0; falloff = 1.0f - fDistance / radius; - что то для импульса.
		hit.impact_force_mul_final = self.iImpactForceMulFinal
		hit.impact_force_mul_final_torso = self.iImpactForceMulFinalTorso
		-- System:Log("dir="..hit.dir.x..","..hit.dir.y..","..hit.dir.z)
		-- System:Log("pos="..hit.pos.x..","..hit.pos.y..","..hit.pos.z)
		-- System:Log("impact_force="..hit.impact_force_mul)
		hit.target_material = status.target_material
		BasicWeapon.Server:OnHit(hit) -- Сделать отдельный сигнал наподобии буллет райн, только чтобы постоянно убегали от этого града пуль как от гранаты.
		BasicWeapon.Client:OnHit(hit)
		-- BasicPlayer.SetDeathImpulse(self,hit)
		-- if BasicPlayer.IsAlive(hit.target) then
		if status.target and status.target.Damage then
			status.target:Damage(hit)
			-- Hud:AddMessage("target: "..status.target:GetName()..", material type: "..hit.target_material.type)
		end
		if self.MG_Explosive then -- Нужно сделать чтобы глючные трасеры пуль не распространялись, а вообще, нужно чтобы светились до почти полной остановки.
			self.matEffect = "mg_hit" -- Доработать.
			-- Не все они бабахают.
			-- CreateEntityLight(self,8,1,1,.7,.4)
			-- local SoundName
			-- local rnd = random(1,5)
			-- if rnd==1 then
				-- SoundName = "Sounds/Weapons/mounted/explode/Flak_01.ogg"
			-- elseif rnd==2 then
				-- SoundName = "Sounds/Weapons/mounted/explode/Flak_02.ogg"
			-- elseif rnd==3 then
				-- SoundName = "Sounds/Weapons/mounted/explode/Flak_03.ogg"
			-- elseif rnd==4 then
				-- SoundName = "Sounds/Weapons/mounted/explode/Flak_04.ogg"
			-- elseif rnd==5 then
				-- SoundName = "Sounds/Weapons/mounted/explode/Flak_05.ogg"
			-- end
			-- if SoundName then
				-- local snd = Sound:Load3DSound(SoundName,SOUND_RELATIVE+SOUND_RADIUS+SOUND_DOPPLER+SOUND_UNSCALABLE+SOUND_OCCLUSION+SOUND_LOAD_SYNCHRONOUSLY,255,10,1000)
				-- if snd then
					-- -- Hud:AddMessage("rnd: "..rnd)
					-- self:PlaySound(snd) -- Добавить задержку в зависимости от расстояния!!!
				-- end
			-- end
		end
	end

	if not self.IsBullet then
		-- raduis,r,g,b,lifetime
		CreateEntityLight(self,10,1,1,.7,.5)
	end

	--objtype 2 mean "the terrain"
	if (hit.objtype==2 and self.mark_terrain and (not self.was_underwater)) then
		if (not self.terrain_deformed) then
			self.terrain_deformed=1
			System:DeformTerrain(pos,self.fDeformRadius,self.decal_tid,self.deform_terrain)
			-- in singleplayer we deform the terrain. We have to adjust the position where the
			-- particle system is spawned ... otherwise it looks like it is floating in the air
			if (self.deform_terrain and tonumber(e_deformable_terrain)==1) then
				hit.pos.z = hit.pos.z - 1
			end
		end
	end

	if self.EngineSound and self.EngineSound.sound then
		Sound:StopSound(self.EngineSound.sound)
	end

	if not self.IsBullet or self.MG_Explosive then
		--FIXME:redundant code
		if (Game:IsPointInWater(originalpos)) then
			--dont take care about deformable terrain shifted pos in the case we are underwater
			CopyVector(hit.pos,originalpos)
			hit.pos.z = Game:GetWaterHeight()
			hit.target_material = Materials.mat_water
			hit.normal = g_Vectors.v001
			ExecuteMaterial2(hit,"grenade_explosion")
			--check if we are near water surface,if so play also a normal explosion.
			hit.pos.z = originalpos.z + 1
			if (not Game:IsPointInWater(hit.pos)) or self.MG_Explosive then
				hit.normal = normal
				hit.target_material = Materials.mat_default
				ExecuteMaterial2(hit,self.matEffect)
			elseif not self.MG_Explosive then
				Particle:SpawnEffect(originalpos,hit.normal,"explosions.under_water_explosion.a")
			end
		else
			ExecuteMaterial2(hit,self.matEffect)
			--removed: to reactivate there should be a raytrace check to see if there is no terrain between the hit pos and .5 m under it.
			--check if we are near water surface,if so play also a water explosion. But just if the impac pos is not plain.
	--		if (normal.z<=.8) then
	--
	--			hit.pos = originalpos
	--			hit.pos.z = hit.pos.z - .5
	--
	--			if (Game:IsPointInWater(hit.pos)) then
	--
	--				hit.target_material = Materials.mat_water
	--				hit.normal = g_Vectors.v001
	--
	--				ExecuteMaterial2(hit,"grenade_explosion")
	--			end
	--		end
		end
	end
	self.IsTerminating = 1

	-- sound event for the radar
	local soundEvent = self.SoundEvent
	if soundEvent then
		-- if self.MG_Explosive then -- Временно.
			-- SoundEvent = {
				-- fVolumeRadius = 50,
				-- fThreat = 1,
			--}
		-- end
		Game:SoundEvent(originalpos,soundEvent.fVolumeRadius,soundEvent.fThreat,0)
	end
end

function BaseProjectile:OnSave(stm)
	-- write out if we have data to save :)
	if (self.ExplosionParams.shooterid) then
		stm:WriteBool(1)
		stm:WriteInt(self.ExplosionParams.shooterid)
	else
		stm:WriteBool(0)
	end
end

function BaseProjectile:OnLoad(stm)
	-- read if we have data to load :)
	local bHasData = stm:ReadBool()

	if (bHasData==1) then
		self.ExplosionParams.shooterid = stm:ReadInt()
	end
end

function BaseProjectile:OnLoadRELEASE(stm)
end

function BaseProjectile:OnTimer()
	Hud:AddMessage("OnTimer 1")
	self.PrevPos = new(self:GetPos())
	-- if self.PrevPos then
		-- System:Log("pos 1: "..self.PrevPos.x..","..self.PrevPos.y..","..self.PrevPos.z)
	-- end
	if not self.PosHistory then self.PosHistory={} end
	if not self.TheNumberOfRows then self.TheNumberOfRows=0 end
	for i,val in self.PosHistory do -- i всегда начинается с еденицы.
		if self.TheNumberOfRows~=i then
			self.TheNumberOfRows=i
		end
	end
	if not self.FlyCount then self.FlyCount=0 end
	self.FlyCount=self.FlyCount+1
	System:Log("FLY: "..self.FlyCount)
	-- System:Log("START")
	for i=0,self.TheNumberOfRows do
		if i==self.TheNumberOfRows then
			self.PosHistory[i+1]=self.PrevPos
			-- if i>0 then
				-- System:Log("i: "..i..", val:"..self.PosHistory[i].x..", val+1:"..self.PosHistory[i+1].x)
			-- end
		end
		-- if self.PosHistory[i] and self.PosHistory[i+1] then
			-- System:Log("i: "..i..", val:"..self.PosHistory[i].x..", val+1:"..self.PosHistory[i+1].x)
		-- end
	end
	-- System:Log("END")
end

BaseProjectile.Server = {
	OnInit = BaseProjectile.Server_OnInit,
	OnTimer = function(self)
		if not self.IsBullet then
			if not self.isExploding then
				-- the timer event, triggered by an entity which explodes after a certain amount of time
				self.isExploding = 1
			else
				-- the timer event, triggered by the exploding entity
				-- System:Log("Removing")
				self:KillTimer()
				Server:RemoveEntity(self.id)
			end
		else
			-- Hud:AddMessage("OnTimer 0")
			-- self:OnTimer()
			if not self.isExploding then
				-- the timer event, triggered by an entity which explodes after a certain amount of time
				self.isExploding = 1
			elseif self.IsTerminating then
				-- the timer event, triggered by the exploding entity
				-- System:Log("Removing")
				self:KillTimer()
				Server:RemoveEntity(self.id)
			end
		end
	end,
	OnUpdate = BaseProjectile.Server_OnUpdate,
}

BaseProjectile.Client = {
	OnInit = BaseProjectile.Client_OnInit,
	OnUpdate = BaseProjectile.Client_OnUpdate,
	OnRemoteEffect = BaseProjectile.Client_OnRemoteEffect,
}

function CreateProjectile(projectileDefinition)
	local ret=new(BaseProjectile)

	mergef(ret,projectileDefinition,1)

	-- set some fallback default parameters
	if (ret.matEffect==nil) then
		ret.matEffect = "projectile_hit"
	end
	if (ret.matEffectScale==nil) then
		ret.matEffectScale = 1
	end

	if (ret.projectileObject==nil) then
		ret.projectileObject = "objects/weapons/Rockets/rocket.cgf"
	end

	if (ret.projectileObjectScale==nil) then
		ret.projectileObjectScale = .5
	end

	if (ret.lifetime==nil) then
		ret.lifetime = 25000 -- В миллисекундах(1000).
	end

	if (ret.dynamic_light==nil) then
		ret.dynamic_light = 0
	end

	return ret
end