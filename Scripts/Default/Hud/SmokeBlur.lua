--------------------------------------------------------------------
-- Description: Blur effect layer for the smoke grenade
-- Created by Marco Kögler
--------------------------------------------------------------------

SmokeBlur = {
	fadeInRate = 1.0,		-- the speed at which it fades in (1.0 units per seconds ... so after 1 second it goes from 0 to 1)
	fadeInScale = 1.0,	-- another scale applied to the fade in rate
	fadeOutRate = 0.1,	-- the speed at which it fades out (0.2 units per seconds ... so after 10 seconds it goes from 0 to 1)
	blurAmount = 0.0,		-- strength of the blur effect
}

-------------------------------------------------------
function SmokeBlur:OnInit()
end

-------------------------------------------------------
function SmokeBlur:OnActivate()
	self.lastTime = _time;
	self.blurAmount = 0.0;
	self.fadeInScale = 1.0;
	System:SetScreenFx("ScreenBlur", 1);
	
	System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurAmount", self.blurAmount);
	System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurColorRed", 1.0);
	System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurColorGreen", 1.0);
	System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurColorBlue", 1.0);
end

-------------------------------------------------------
function SmokeBlur:OnDeactivate()
	System:SetScreenFx("ScreenBlur", 0);
end

-------------------------------------------------------
function SmokeBlur:OnFadeOut()
	local dt = _time - self.lastTime;
	self.lastTime = _time;
	
	self.blurAmount = self.blurAmount - dt * self.fadeOutRate;
	
	if (self.blurAmount < 0.0) then
		self.OnDeactivate();
		return 1;
	end
	
	System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurAmount", self.blurAmount);
end

-----------------------------------------------------
function SmokeBlur:OnUpdate()
	local dt = _time - self.lastTime;
	
	self.blurAmount = self.blurAmount + dt * (self.fadeInRate * self.fadeInScale - self.fadeOutRate);
	
	if (self.blurAmount < 0.0) then
		self.blurAmount = 0.0;
	end
	
	if (self.blurAmount > 1.0) then
		self.blurAmount = 1.0;
	end
	
	System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurAmount", self.blurAmount);
	-- last call to OnUpdate is deactivation time
	self.lastTime = _time;
	self.fadeInScale = 0;
end

-----------------------------------------------------
function SmokeBlur:OnShutdown()
end