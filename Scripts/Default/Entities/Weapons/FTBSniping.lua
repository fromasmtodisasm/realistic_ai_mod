-- Questions;
-- Whats does 'FTB' mean?
-- This script does not make much sense, TotalBreathHoldTime is fine, but BreathFadeTime and
-- BreathHoldTime, BreathScale, BreathOutTime etc... AND what kind of 'time' are these values?
-- (minutes, seconds, milisceonds?? they seem to be inconsistant)
--
-- How the sniper should work....
-- Zoom-in, adjust with the MWheel what zoom factor, scope has some shake to it (which is 
--   adjustable). Holding your breath will will steady the scope over an adjustable time.
--   You can hold your breath for an adjustable time frame.
-- If you hold your breath too long your loose your zoom (exit zoom mode)
-- If you hold your breath too long the scope fades to black
-- If you shoot you loose your Zoom (exit zoom mode)
-- When you exit Zoom mode your zoom factor is remeber
-- adjustable values should be in seconds or miliseconds (please comment :])
--
-- Tig

FTBSniping = {
	SwayMultiplier = 0.0,		-- decrease factor of swaying
	NormalMinSway = 0,
	NormalMaxSway = 0,
	SwayFreq = 0.2,						-- the amount of change in the sway wobble
	PrevSway = 0,
	TotalBreathHoldTime = 15,	-- time you can hold the breath
	BreathFadeTime = 2,		-- time in which the view changes (during breath in)
	BreathHoldTime = 0,
	ReleasingBreath = nil,
	BreathScale = 2,		-- the maximum factor of breathing when we change fom breath in to -out
	BreathOutTime = 0,
	TotalBreathOutTime = 1.3,		-- time needed to breath out
	BreathInSnd = Sound:LoadSound("sounds/player/breathin.wav"),
	BreathOutSnd = Sound:LoadSound("sounds/player/breathout.wav"),
	BreathBlurImg = System:LoadImage("Textures/Hud/BreathBlur.tga"),
	ExtraZoom = 0.0,
}

function FTBSniping:OnInit()
	self.BreathHold = 0;
	Sound:SetSoundLoop( FTBSniping.BreathInSnd, 0 );
	Sound:SetSoundLoop( FTBSniping.BreathOutSnd, 0 );
	Sound:SetSoundVolume( FTBSniping.BreathInSnd, 25 );
	Sound:SetSoundVolume( FTBSniping.BreathOutSnd, 25 );
end

function FTBSniping:OnActivate()
	self.SwayMultiplier = 0.0125;
	self.NormalMinSway = ZoomView.MinSway;
	self.NormalMaxSway = ZoomView.MaxSway;
	self.PrevSway = ZoomView.Sway;
end

function FTBSniping:OnUpdate()
	local States = ZoomView;
	local stats = _localplayer.cnt;

	if ( stats.holding_breath and ( stats.moving == nil ) and ( self.ReleasingBreath == nil ) ) then		
		-- we've pressed the button, are not moving and we dont breath out so hold the breath...
		if ( States.Sway == States.MinSway ) then		
			-- you can only hold the breath if you're not out-of-breath =)
			if ( self.BreathHoldTime == 0 ) then		
				-- we just started to breath in, so play sound and set params
				Sound:PlaySound( FTBSniping.BreathInSnd );
				FTBSniping.OnActivate(self);
				stats:SetSwayFreq(self.SwayFreq);
				self.NormalMinSway = States.MinSway;
				self.NormalMaxSway = States.MaxSway;
				self.PrevSway = States.Sway;
				--States.MinSway = States.Sway * self.SwayMultiplier;
			end
		end
		self.BreathHoldTime = self.BreathHoldTime + _frametime;
	else
		self:BreathRelease();
	end

	if (stats.holding_breath) then
		-- Make crosshair smoothly come to rest
		local Inverse = 1.0 - self.SwayMultiplier;
		local ScaledSwayMul = 1.0 - Inverse  * (States.Sway) * min(1.0, self.BreathHoldTime / self.BreathFadeTime);

		ZoomView.AddZoom = 1 - (ScaledSwayMul * 1);
		--ZoomView.AddZoom = 0;

		ScaledSwayMul = max(ScaledSwayMul, self.SwayMultiplier);
		States.MinSway = States.Sway * ScaledSwayMul;
		if (States.MinSway < 0.5 * self.NormalMinSway) then
			States.MinSway = 0.5 * self.NormalMinSway;
		end
	end

	if ( self.ReleasingBreath ) then
		--tig 
		--want to kill the zoom if the player holds their breath too long
		ZoomView.AddZoom = 0;

		self.BreathOutTime = self.BreathOutTime + System:GetFrameTime();
		if ( self.BreathOutTime >= self.TotalBreathOutTime ) then
			self.ReleasingBreath = nil;
			self.BreathOutTime = 0;
		end
	end
end

function FTBSniping:OnFire()
	--tig
	--want to kill the zoom here!!
	self:BreathRelease();
	--ClientStuff.vlayers:DeactivateLayer("WeaponScope");
	
end

function FTBSniping:OnEnhanceHUD()
	if ( ( self.BreathHoldTime > 0 ) ) then
		local mul = self.BreathHoldTime / self.BreathFadeTime;
		if ( mul > 1 ) then
			mul = 1;
		end
		System:DrawImageColor( FTBSniping.BreathBlurImg, 0, 0, 800, 600, 4, 1, 1, 1, mul );
		self.BreathScale = mul;
	end
	if ( self.ReleasingBreath ) then
		local mul = ( 1 - ( self.BreathOutTime / self.TotalBreathOutTime ) ) * self.BreathScale;
		System:DrawImageColor( FTBSniping.BreathBlurImg, 0, 0, 800, 600, 4, 1, 1, 1, mul );
	end
end

function FTBSniping:BreathRelease()
	local States = ZoomView;

	if ( self.BreathHoldTime > 0 ) then		
		-- still holding the breath, so breath out

		System:LogToConsole("--> Breathing Out !!!");
		Sound:PlaySound( FTBSniping.BreathOutSnd );
		self.BreathHoldTime = 0;
		self.BreathOutTime = 0;
		States.MinSway = self.NormalMinSway;
		--States.MaxSway = self.PrevSway * 2;
		--if ( States.MaxSway > 5 ) then
		--	States.MaxSway = 5;
		--end
		--States.SwayInc = 1;
		self.ReleasingBreath = 1;
	end
end