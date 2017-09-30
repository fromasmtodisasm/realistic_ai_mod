RLSP = {
	name			= "RL",
	object		= "Objects/Weapons/RL/RL_bind.cgf",
	character	= "Objects/Weapons/RL/RL.cgf",

	-- if the weapon supports zooming then add this...
	ZoomActive = 0,												-- initially always 0
	MaxZoomSteps = 3,
	ZoomSteps = {2, 4, 6,},
	AimMode = 2,											--IronSights
	AimOffset={x=.132, y=.3, z=.08},						--IronSights
	ZoomSound=Sound:LoadSound("Sounds/items/scope.wav"),
	ZoomDeadSwitch = 1,
	TargetLocker = 1,
	Sway = 2,
	---------------------------------------------------
	PlayerSlowDown = .5,									-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	ActivateSound = Sound:LoadSound("Sounds/Weapons/Mortar/mortar_33.wav"),	-- sound to play when this weapon is selected
	---------------------------------------------------
	DrawFlare=1,

	FireParams =
	{													-- describes all supported firemodes
		{
			FireSounds = {
				"Sounds/Weapons/rl/FINAL_RL_MONO.wav",
			},
			FireSoundsStereo = {
				"Sounds/Weapons/rl/FINAL_RL_STEREO.wav",
			},
			DrySound = "Sounds/Weapons/AG36/DryFire.wav",
			-- Light from flying rocket is enough so this light is not needed
			-- LightFlash = {
				-- fRadius = 4,
				-- vDiffRGBA = {r = 1,g = 1,b = 0,a = 1,},
				-- vSpecRGBA = {r = .3,g = .3,b = .3,a = 1,},
				-- fLifeTime = .25,
			--},
			SoundMinMaxVol = {255,3,200},
		},
	},

	--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
--	FireParams_Mp =
--	{
--		{
--			bullets_per_clip=1,
--		},
--	},

		SoundEvents={
		--	animname,	frame,	soundfile
		{	"reload1",	18,			Sound:LoadSound("Sounds/Weapons/RL/rl_18.wav",0,80)},
		{	"reload1",	88,			Sound:LoadSound("Sounds/Weapons/RL/rl_78.wav",0,80)},
--		{	"swim",		1,			Sound:LoadSound("Sounds/player/water/underwaterswim2.wav",0,255)},
	},
}

RLMP = {
	name			= "RL",
	object		= "Objects/Weapons/RL/RL_bind.cgf",
	character	= "Objects/Weapons/RL/RL.cgf",

	-- if the weapon supports zooming then add this...
	ZoomActive = 0,												-- initially always 0
	MaxZoomSteps = 3,
	ZoomSteps = {2, 4, 6,},
	AimMode = 2,											--IronSights
	AimOffset={x=.132, y=.3, z=.08},						--IronSights
	ZoomSound=Sound:LoadSound("Sounds/items/scope.wav"),
	LockSound=Sound:LoadSound("Sounds/items/lock2.wav"), --
	ZoomDeadSwitch = 1,
	TargetLocker = 1,
	Sway = 2,
	---------------------------------------------------
	PlayerSlowDown = .5,									-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	ActivateSound = Sound:LoadSound("Sounds/Weapons/Mortar/mortar_33.wav"),	-- sound to play when this weapon is selected
	---------------------------------------------------
	DrawFlare=1,

	FireParams =
	{													-- describes all supported firemodes
		{
			FireSounds = {
				"Sounds/Weapons/rl/FINAL_RL_MONO.wav",
			},
			FireSoundsStereo = {
				"Sounds/Weapons/rl/FINAL_RL_STEREO.wav",
			},
			DrySound = "Sounds/Weapons/AG36/DryFire.wav",
			-- Light from flying rocket is enough so this light is not needed
			-- LightFlash = {
				-- fRadius = 4,
				-- vDiffRGBA = {r = 1,g = 1,b = 0,a = 1,},
				-- vSpecRGBA = {r = .3,g = .3,b = .3,a = 1,},
				-- fLifeTime = .25,
			--},
			SoundMinMaxVol = {255,3,200},
		},
	},

	--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
--	FireParams_Mp =
--	{
--		{
--			bullets_per_clip=1,
--		},
--	},

		SoundEvents={
		--	animname,	frame,	soundfile
		{	"reload1",	18,			Sound:LoadSound("Sounds/Weapons/RL/rl_18.wav",0,80)},
		{	"reload1",	88,			Sound:LoadSound("Sounds/Weapons/RL/rl_78.wav",0,80)},
--		{	"swim",		1,			Sound:LoadSound("Sounds/player/water/underwaterswim2.wav",0,255)},
	},
	minaimtime = .5, --
}

RL = RLSP

if (Game:IsMultiplayer()) then
	RL = RLMP
end

RL.LockSoundTrigger = 0


function RL:DrawZoomOverlay(ZoomStep)
	if (Game:IsMultiplayer()) then
		local	minaimtime = .5
		if (_localplayer.cnt.aimtime==nil) then
			_localplayer.cnt.aimtime=0
		end

		if (ZoomStep~=self.PrevZoomStep) then
			if (RL.ZoomSound) then
				Sound:StopSound(RL.ZoomSound)
				Sound:PlaySound(RL.ZoomSound)
			end
			self.PrevZoomStep = ZoomStep
		end
	--	System.DrawRectShader("ScreenDistort", 0, 0, 800, 600, 1, 1, 1, 1)
		local elapstime =_time-_localplayer.cnt.aimtime

		if (RL.ZoomBackgroundTID) then

			if (elapstime > minaimtime or _localplayer.cnt.aimtime==0) then
			-- [tiago] must add crossair..
			System:Draw2DLine(398-44, 300, 398,  300, 0, 0, 0, 1)
			System:Draw2DLine(402, 300, 402+45, 300, 0, 0, 0, 1)
			System:Draw2DLine(400   ,302, 400   ,302+45, 0, 0, 0, 1)
			if (_localplayer.cnt.aimtime~=0) then
				if (RL.LockSoundTrigger==0) then
					Sound:PlaySound(RL.LockSound)
					RL.LockSoundTrigger = 1
				end
				Game:WriteHudString(390, 370, "FIRE", 0, 1, .5, .9, 20, 20)
			end
			end

			-- [tiago] must adjust texel coordinates
			local fTexelWidth=1/512
			local fTexelHeight=1/1024
			System:DrawImageColorCoords(RL.ZoomBackgroundTID, 0, 0, 400, 600, 4, 1, 1, 1, 1,  fTexelWidth, 1-fTexelHeight, 1-fTexelWidth, fTexelHeight)
			System:DrawImageColorCoords(RL.ZoomBackgroundTID, 800, 0, -400, 600, 4, 1, 1, 1, 1,  fTexelWidth, 1-fTexelHeight, 1-fTexelWidth, fTexelHeight)

		end

	--	if (RL.ZoomTID) then
	--		System.DrawImage(RL.ZoomTID[ZoomStep], 400, 22, 185, 80, 4)
	--	end
		--Game:SetHUDFont("radiosta", "sniperscope")
		Game:SetHUDFont("radiosta", "binozoom")

		-- Draw distance
		local myPlayer=_localplayer
		if (myPlayer) then
			local int_pt=myPlayer.cnt:GetViewIntersection()
			if (int_pt) then
				local s=format("%07.2fm", int_pt.len*1.5)
				--Game:WriteHudStringFixed(366, 350, s, 0, 1, .5, .5, 20, 20, .6)
				Game:WriteHudString(370, 350, s, 0, 1, .5, .5, 15, 15)
			else
				--Game:WriteHudStringFixed(366, 350, "----.--m", 0, 1, .5, .9, 20, 20, .6)
				Game:WriteHudString(370, 350, "----.--m", 0, 1, .5, .9, 20, 20)
			end
		end
	else
		if (ZoomStep~=self.PrevZoomStep) then
			if (RL.ZoomSound) then
				Sound:StopSound(RL.ZoomSound)
				Sound:PlaySound(RL.ZoomSound)
			end
			self.PrevZoomStep = ZoomStep
		end
	--	System.DrawRectShader("ScreenDistort", 0, 0, 800, 600, 1, 1, 1, 1)

		if (RL.ZoomBackgroundTID) then

			-- [tiago] must add crossair..
			System:Draw2DLine(398-44, 300, 398,  300, 0, 0, 0, 1)
			System:Draw2DLine(402, 300, 402+45, 300, 0, 0, 0, 1)
			System:Draw2DLine(400   ,302, 400   ,302+45, 0, 0, 0, 1)

			-- [tiago] must adjust texel coordinates
			local fTexelWidth=1/512
			local fTexelHeight=1/1024
			System:DrawImageColorCoords(RL.ZoomBackgroundTID, 0, 0, 400, 600, 4, 1, 1, 1, 1,  fTexelWidth, 1-fTexelHeight, 1-fTexelWidth, fTexelHeight)
			System:DrawImageColorCoords(RL.ZoomBackgroundTID, 800, 0, -400, 600, 4, 1, 1, 1, 1,  fTexelWidth, 1-fTexelHeight, 1-fTexelWidth, fTexelHeight)

		end

	--	if (RL.ZoomTID) then
	--		System.DrawImage(RL.ZoomTID[ZoomStep], 400, 22, 185, 80, 4)
	--	end
		--Game:SetHUDFont("radiosta", "sniperscope")
		Game:SetHUDFont("radiosta", "binozoom")

		-- Draw distance
		local myPlayer=_localplayer
		if (myPlayer) then
			local int_pt=myPlayer.cnt:GetViewIntersection()
			if (int_pt) then
				local s=format("%07.2fm", int_pt.len*1.5)
				--Game:WriteHudStringFixed(366, 350, s, 0, 1, .5, .5, 20, 20, .6)
				Game:WriteHudString(370, 350, s, 0, 1, .5, .5, 15, 15)
			else
				--Game:WriteHudStringFixed(366, 350, "----.--m", 0, 1, .5, .9, 20, 20, .6)
				Game:WriteHudString(370, 350, "----.--m", 0, 1, .5, .9, 20, 20)
			end
		end

	end
end

function RL:ZoomToggle()
	TargetLocker:Activate(self.ZoomActive,"RL")
end

CreateBasicWeapon(RL)

function RL.Client:OnInit()
	local cur_r_TexResolution = tonumber(getglobal("r_TexResolution"))
	if (cur_r_TexResolution <= 1) then -- lower res texture for low/med texture quality setting
		RL.ZoomBackgroundTID=System:LoadImage("Textures/Hud/crosshair/RL_scope_low")
	else
		RL.ZoomBackgroundTID=System:LoadImage("Textures/Hud/crosshair/RL_scope")
	end
	self.ZoomOverlayFunc = RL.DrawZoomOverlay
	BasicWeapon.Client.OnInit(self)
end

function RL.Client:OnShutDown()
	RL.ZoomBackgroundTID=nil
end

function RL.Client:OnEvent(EventId, Params)
	if (Game:IsMultiplayer()) then
		if (EventId==ScriptEvent_Fire) then

			if (Params.fire_event_type==FireActivation_OnPress) then
				_localplayer.cnt.aimtime = _time
				Params.shooter.cnt.aimtime = _time
				self.clientrelease = 0
				self.beginclientfire = 1
				self.fireCanceled = 0
				RL.LockSoundTrigger = 0
				return
			elseif (Params.fire_event_type==FireActivation_OnRelease) then
				local elapstime =_time-Params.shooter.cnt.aimtime

				if ((Params.shooter.cnt.aimtime > 0) and (self.minaimtime < elapstime)) then
					self.clientrelease = 1

					self.fireCanceled = 0
					Params.shooter.cnt.aimtime = 0
				else

					self.fireCanceled = 1

					self.clientrelease = 0
					Params.shooter.cnt.aimtime = 0

				end
			end
		elseif (EventId==ScriptEvent_FireCancel) then
			self.fireCanceled = 1
			self.beginclientfire = nil
			self.clientrelease = 0
			return
		end
		if (self.fireCanceled==1 or self.clientrelease~=1 or self.beginclientfire==0 or Params.shooter.cnt.aiming~=1) then
			do return nil end
		end

		self.beginclientfire = 0
		return BasicWeapon.Client.OnEvent(self, EventId, Params)
	else
		return BasicWeapon.Client.OnEvent(self, EventId, Params)
	end
end

function RL.Server:OnEvent(EventId, Params)
	if (Game:IsMultiplayer()) then
		if (EventId==ScriptEvent_Fire) then
			if (Params.fire_event_type==FireActivation_OnPress) then
				self.beginfire = 1
				Params.shooter.cnt.aimtimesvr=_time
			end
			if (Params.fire_event_type==FireActivation_OnRelease and self.beginfire==1) then

				local elapstime =_time-Params.shooter.cnt.aimtimesvr
				if ((Params.shooter.cnt.aimtimesvr > 0) and (self.minaimtime < elapstime)) then
					self.beginfire = 0
					self.fireCanceled = 0
					Params.shooter.cnt.aimtimesvr = 0
				else
					self.beginfire = 0
					self.fireCanceled = 1
					Params.shooter.cnt.aimtimesvr = 0
				end
			else return end
		elseif (EventId==ScriptEvent_FireCancel) then
			self.fireCanceled = 1
			return
		end
		if (self.fireCanceled==1 or Params.shooter.cnt.aiming~=1) then	-- don't fire
			self.beginfire = nil
			do return nil end
		end
		return BasicWeapon.Server.OnEvent(self, EventId, Params)
	else
		return BasicWeapon.Server.OnEvent(self, EventId, Params)
	end
end

---------------------------------------------------------------
--ANIMTABLE
------------------
RL.anim_table={}
--AUTOMATIC FIRE
RL.anim_table[1]={
	idle={
		"Idle11",
		"Idle21",
	},
	reload={
		"Reload1",
	},
	fidget={
		"fidget11",
		"fidget21",
	},
	fire={
		"Fire11",
		"Fire21",
	},
	swim={
		"swim",
	},
	activate={
		"Activate1",
	},
}
