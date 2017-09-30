Hands = {
	name		= "Hands",
	object		= nil,
	character	= "objects/weapons/hands/hands.cgf",
	PlayerSlowDown = 1,
	ActivateSound = Sound:LoadSound("Sounds/Weapons/melee/swish.wav",0,120),
	NoZoom=1,
	hit_delay=.1,
	FireParams ={
	{
		type = 3,
		FireSounds = {
			"Sounds/Weapons/melee/swish.wav",
		},
		SoundMinMaxVol = {100,1,20},
	},
	},
}

CreateBasicWeapon(Hands)

--SINGLE FIRE
Hands.anim_table={}
Hands.anim_table[1]={
	idle={
		"Idle11",
	},
	-- fidget={
	--},
	fire={
		"leftjab",
		"rightjab",
		"uppercut",
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

function Hands.Server:OnHit(hit)
	if (not self.cl_cold_wpn_contact) then
		self.cl_cold_wpn_contact = _time+self.hit_delay
		self.cl_hitparams = hit
	end
end

function Hands.Server:OnUpdate(delta,shooter)
	BasicWeapon.Server.OnUpdate(self,delta,shooter)
	if (self.cl_cold_wpn_contact) and (self.cl_cold_wpn_contact < _time) then
		self.cl_cold_wpn_contact=nil
		if (self.cl_hitparams.shooter) and (self.cl_hitparams.shooter.fireparams) then
			if self.cl_hitparams.target then
				self.cl_hitparams.target:AddImpulse(self.cl_hitparams.ipart,self.cl_hitparams.pos,self.cl_hitparams.dir,self.cl_hitparams.impact_force_mul) -- Так выглядит смачнее, когда объекту передаётся импульс.
			end
			BasicWeapon.Server.OnHit(self,self.cl_hitparams)
		end
	end
end

function Hands.Server:Drop(Params) -- Руки нельзя выбросить.
end