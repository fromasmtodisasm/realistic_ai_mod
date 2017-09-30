-- MORE REALISTIC MACHETE (IMPROVED BY MIXER)
Machete = {
	name		= "Machete",
	object		= "objects/weapons/machete/machete_bind.cgf",
	character	= "objects/weapons/machete/machete.cgf",
	-- character	= "objects/weapons/hands/hands.cgf",
	PlayerSlowDown = 1,
	ActivateSound = Sound:LoadSound("Sounds/Weapons/machete/machete_pickup.wav",0,120),
	NoZoom=1,
	hit_delay=.2,
	FireParams ={													
	{
		type = 3,
		FireSounds = {
			"Sounds/Weapons/machete/fire1.wav",
			"Sounds/Weapons/machete/fire2.wav",
			"Sounds/Weapons/machete/fire3.wav",
		},
		SoundMinMaxVol = {100,1,20},
	},
	},
}

CreateBasicWeapon(Machete)

--SINGLE FIRE
Machete.anim_table={}
Machete.anim_table[1]={
	idle={
		"Idle11",
		"Idle21",
	},
	fidget={
		"fidget11",
		"fidget21",
	},
	fire={
		"Fire11", -- Сверху.
		"Fire12", -- Справа.
		"Fire21",  -- Справа чуть выше.
		-- "Fire31", -- Сверху.
		-- "Fire41", -- Справа.
		-- "Fire51",  -- Справа чуть выше.
	},
	swim={
		"swim"
	},
	activate={
		"Activate1"
	},
	
	-- deactivate={--
		-- "Deactivate1"
	--},
}

-- function Machete.Client:OnHit(hit)
	-- if (not self.cl_cold_wpn_contact) then
	-- self.cl_cold_wpn_contact = _time+self.hit_delay 
	-- self.cl_hitparams = hit 
	-- end
-- end

-- function Machete.Client:OnUpdate(delta,shooter)
	-- BasicWeapon.Client.OnUpdate(self,delta,shooter)
	-- if (self.cl_cold_wpn_contact) and (self.cl_cold_wpn_contact < _time) then
		-- self.cl_cold_wpn_contact=nil 
		-- if (self.cl_hitparams.shooter) and (self.cl_hitparams.shooter.fireparams) then
			-- BasicWeapon.Client.OnHit(self,self.cl_hitparams)
		-- end
	-- end
-- end

function Machete.Client:OnHit(hit)
	if (not self.cl_cold_wpn_contact) then
	self.cl_cold_wpn_contact = _time+self.hit_delay 
	self.cl_hitparams = hit 
	end
	if (Game:IsServer()==nil) and (hit.shooter.handStrength) then
		hit.impact_force_mul = hit.impact_force_mul*hit.shooter.handStrength 
		hit.impact_force_mul_final = hit.impact_force_mul_final*hit.shooter.handStrength 
		hit.impact_force_mul_final_torso = hit.impact_force_mul+hit.impact_force_mul_final 
		hit.damage = hit.damage*(hit.shooter.handStrength*.25)
	end
end

function Machete.Server:OnHit(hit)
	BasicWeapon.Server.OnHit(self,hit)
	if (hit.shooter.handStrength) then
		hit.impact_force_mul = hit.impact_force_mul*hit.shooter.handStrength 
		hit.impact_force_mul_final = hit.impact_force_mul_final*hit.shooter.handStrength 
		hit.impact_force_mul_final_torso = hit.impact_force_mul+hit.impact_force_mul_final 
		hit.damage = hit.damage*(hit.shooter.handStrength*.25)
	end
end

function Machete.Client:OnActivate(Params)
BasicWeapon.Client.OnActivate(self,Params)
if (Params.shooter) and (Params.shooter.MUTANT) and ClientStuff and (ClientStuff.cl_survival) then -- ClientStuff, добавил чтобы просто nil убрать. Это всё равно надо всё поубирать
	Params.shooter.cnt:DrawThirdPersonWeapon(0)
end
end

function Machete.Server:OnUpdate(delta, shooter)
	if (shooter.ai) and (GameRules.SimulateMelee) then
		local at_target = AI:GetAttentionTargetOf(shooter.id)
		if (at_target) and (type(at_target)=="table") then
			at_target = at_target:GetPos()
			at_target = shooter:GetDistanceFromPoint(at_target)
		else
			at_target = shooter.cnt.melee_distance + 1 
		end
		if (at_target > shooter.cnt.melee_distance) then
			if (GameRules.insta_play) then
				shooter.cnt.lock_weapon=nil 
			else
				if (shooter.survival_gun) then
					shooter.cnt:MakeWeaponAvailable(shooter.survival_gun)
					shooter.cnt:SetCurrWeapon(shooter.survival_gun)
				end
			end
			shooter:ChangeAIParameter(AIPARAM_AGGRESION,shooter.Properties.aggression)
			return 
		end
	end
end

function Machete.Client:OnFire( Params )
	if (BasicWeapon.Client.OnFire( self,Params )~=nil) then
		if (Params.shooter) and (Params.shooter.cnt) and (Params.shooter.cnt.first_person) then
			Params.shooter.playingReloadAnimation = 1 
			self.cl_coldfakehit=nil 
		end
		if (ClientStuff.cl_survival) and (Params.shooter) and (Params.shooter.MUTANT) then
			local m_num = Params.shooter.Properties.KEYFRAME_TABLE 
			if (m_num=="MUTANT_FAST") or (m_num=="MUTANT_STEALTH") then
				m_num = 1 
			elseif (m_num=="MUTANT_BIG") then
				m_num = 5 
			elseif (m_num=="MUTANT_MONKEY") then
				if (Params.shooter.Properties.SOUND_TABLE=="MUTANT_STEALTH") then
					m_num = random(2,3)
				else
					m_num = random(1,3)
				end
			else
				m_num = 1 
			end
			Params.shooter:StartAnimation(0,"attack_melee"..m_num,2)
		end
		return 1 
	end
end

function Machete.Client:OnDeactivate(Params)
	BasicWeapon.Client.OnDeactivate(self,Params)
	if (Params.shooter) and (Params.shooter.MUTANT) and (ClientStuff.cl_survival) then
		Params.shooter.cnt:DrawThirdPersonWeapon(1)
	end
end

function Machete.Client:OnUpdate(delta, shooter)
	BasicWeapon.Client.OnUpdate(self,delta,shooter)
	if (self.cl_cold_wpn_contact) and (self.cl_cold_wpn_contact < _time) then
		self.cl_cold_wpn_contact=nil 
		BasicWeapon.Client.OnHit(self,self.cl_hitparams)
		self.cl_coldfakehit = _time+self.hit_delay 
	elseif (shooter.cnt) and (shooter.cnt.first_person) then
		if (self.cl_coldfakehit) and (self.cl_coldfakehit < _time) then
			self.cl_coldfakehit=nil 
			BasicWeapon.RandomAnimation(self,"idle",shooter.firemodenum, .3)
		end
	end
end

function Machete:ZoomAsAltFire(shtr)
	if (shtr) then
		if (shtr.asg_nextshot) and (shtr.asg_nextshot > _time) then
		else
			shtr.asg_nextshot = _time + 1.1 
			if (Game:IsServer()) then
				--BasicWeapon.Server.Drop( self, {Player = shtr, throw_this=1,} )
					--

				local pos = SumVectors(shtr:GetPos(),{x=0,y=0,z=1.5})
				local ang = new(shtr:GetAngles())
				ang.z = ang.z-90 

				-- adjust spawn height based on player stance
				if (shtr.cnt.crouching) then
					pos = SumVectors(pos, {x=0,y=0,z=-.5})
				elseif (shtr.cnt.proning) then
					pos = SumVectors(pos, {x=0,y=0,z=-1})
				end

				local dir = BasicWeapon.temp_v1 
				local dest = BasicWeapon.temp_v2 
				----------- temp 2
				CopyVector(dir,shtr:GetDirectionVector())

				dest.x = pos.x + dir.x * 1.5 
				dest.y = pos.y + dir.y * 1.5 
				dest.z = pos.z + dir.z * 1.5 

				local hits = System:RayWorldIntersection(pos,dest,1,ent_terrain+ent_static+ent_rigid+ent_sleeping_rigid,shtr.id)

				if (hits and getn(hits)>0) then
					local temp = hits[1].pos 
					dest.x = temp.x - dir.x * .15 
					dest.y = temp.y - dir.y * .15 
					dest.z = temp.z - dir.z * .15 
				end 
				--
				local jdummy = Game:GetEntityClassIDByClassName("ThrowMachete")
				if (jdummy) then
					jdummy = {
						classid=jdummy*1,
						pos=pos,
						angles=ang,
					} 
					
					local jdummy = Server:SpawnEntity(jdummy)
					if (jdummy) then
						jdummy:Launch(shtr.cnt.weapon, shtr, pos, ang, dir, 10000)
						Server:BroadcastCommand("PLAS "..shtr.id.." "..shtr.id)
						shtr.cnt:MakeWeaponAvailable(self.classid,0)
						if (BasicPlayer.AddPlayerHands) then
							BasicPlayer.AddPlayerHands(shtr,1)
						end
						shtr.cnt:SetCurrWeapon(9)
					end
				end
			else
				Client:SendCommand("VB_GV 0")
			end
		end
	end
end

function Machete:ZoomAsAltFcl(shtr)
	if (shtr.cnt) and (shtr.cnt.first_person) then
		shtr.thrw_some_m = 1 
	elseif (_localplayer) and (shtr~=_localplayer) then
		shtr.stop_my_talk = _time + .3 
		shtr:StartAnimation(0,"aidle_umshoot",4)
	end
end