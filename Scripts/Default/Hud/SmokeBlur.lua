--------------------------------------------------------------------
-- Description: Blur effect layer for the smoke grenade
-- Created by Marco Kögler
--------------------------------------------------------------------

SmokeBlur = {
	IsActive=0,					-- effect state
	fadeInRate = 1.0,		-- the speed at which it fades in (1.0 units per seconds ... so after 1 second it goes from 0 to 1)
	fadeInScale = 1.0,	-- another scale applied to the fade in rate
	fadeOutRate = 0.1,	-- the speed at which it fades out (0.2 units per seconds ... so after 10 seconds it goes from 0 to 1)
	blurAmount = 0.0,		-- strength of the blur effect
}

-------------------------------------------------------
function SmokeBlur:OnInit()
	SmokeBlur.IsActive=0;
	SmokeBlur.iNumActive=0;
	SmokeBlur.fadeInRate = 1.0;
	SmokeBlur.fadeInScale = 1.0;
	SmokeBlur.fadeOutRate = 0.1;
	SmokeBlur.blurAmount = 0.0;
end

-------------------------------------------------------
function SmokeBlur:OnActivate()

	-- Hack:Only reset smokeblur data if layer deactivated. Else its active already (after quickload)
	if(SmokeBlur.IsActive==0) then		
		SmokeBlur.blurAmount = 0.0;
		SmokeBlur.fadeInScale = 1.0;
  end
	
	SmokeBlur.lastTime = _time;
	
	System:SetScreenFx("ScreenBlur", 1);	
	System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurAmount", SmokeBlur.blurAmount);
	System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurColorRed", 1.0);
	System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurColorGreen", 1.0);
	System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurColorBlue", 1.0);
	
	SmokeBlur.IsActive=1;
end

-------------------------------------------------------
function SmokeBlur:OnDeactivate()
	System:SetScreenFx("ScreenBlur", 0);
	SmokeBlur.IsActive=0;
end

-------------------------------------------------------
function SmokeBlur:OnFadeOut()
	local dt = _time - SmokeBlur.lastTime;
	SmokeBlur.lastTime = _time;
	
	SmokeBlur.blurAmount = SmokeBlur.blurAmount - dt * SmokeBlur.fadeOutRate;
	
	if (SmokeBlur.blurAmount < 0.0) then
		SmokeBlur:OnDeactivate();
		return 1;
	end
	
	System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurAmount", SmokeBlur.blurAmount);
end

-----------------------------------------------------
function SmokeBlur:OnUpdate()
	local dt = _time - SmokeBlur.lastTime;
	
	SmokeBlur.blurAmount = SmokeBlur.blurAmount + dt * (SmokeBlur.fadeInRate * SmokeBlur.fadeInScale - SmokeBlur.fadeOutRate);
	
	if (SmokeBlur.blurAmount < 0.0) then
		SmokeBlur.blurAmount = 0.0;		
--		SmokeBlur:OnDeactivate();
		
		-- don't disable layer, some bug on this. Only disable effect.
		--ClientStuff.vlayers:DeactivateLayer("SmokeBlur");
	end
	
	if (SmokeBlur.blurAmount > 1.0) then
		System:SetScreenFx("ScreenBlur", 1); -- always make sure its active..
		SmokeBlur.blurAmount = 1.0;
	end
	
	System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurAmount", SmokeBlur.blurAmount);
	-- last call to OnUpdate is deactivation time
	SmokeBlur.lastTime = _time;
	SmokeBlur.fadeInScale = 0;
end

-----------------------------------------------------
function SmokeBlur:OnShutdown()
end

-----------------------------------------------------
function SmokeBlur:OnRestore(pRestoreTbl)
	SmokeBlur.IsActive= pRestoreTbl.IsActive;
	SmokeBlur.blurAmount= pRestoreTbl.blurAmount;
	SmokeBlur.fadeInRate= pRestoreTbl.fadeInRate;
	SmokeBlur.fadeInScale= pRestoreTbl.fadeInScale;
	SmokeBlur.fadeOutRate= pRestoreTbl.fadeOutRate;				
end
