-- Description: Blur effect layer for the smoke grenade
-- Created by Marco Kцgler
SmokeBlur = {
	IsActive=0,					-- effect state
	fadeInRate = 1,		-- the speed at which it fades in (1 units per seconds ... so after 1 second it goes from 0 to 1)
	fadeInScale = 1,	-- another scale applied to the fade in rate
	fadeOutRate = .1,	-- the speed at which it fades out (.2 units per seconds ... so after 10 seconds it goes from 0 to 1)
	blurAmount = 0,		-- strength of the blur effect
}

function SmokeBlur:OnInit()
	if not BasicPlayer.IsAlive(_localplayer) then return end
	SmokeBlur.IsActive=0
	SmokeBlur.iNumActive=0
	SmokeBlur.fadeInRate = 1
	SmokeBlur.fadeInScale = 1
	SmokeBlur.fadeOutRate = .1 -- .1
	SmokeBlur.blurAmount = 0
end

function SmokeBlur:OnActivate()
	if not BasicPlayer.IsAlive(_localplayer) then return end
	-- Hack:Only reset smokeblur data if layer deactivated. Else its active already (after quickload)
	if SmokeBlur.IsActive==0 then
		SmokeBlur.blurAmount = 0
		SmokeBlur.fadeInScale = 1
	end
	SmokeBlur.lastTime = _time
	System:SetScreenFx("ScreenBlur",1)
	-- System:SetScreenFxParamFloat("ScreenBlur","ScreenBlurAmount",SmokeBlur.blurAmount)
	-- System:SetScreenFxParamFloat("ScreenBlur","ScreenBlurColorRed",1)
	-- System:SetScreenFxParamFloat("ScreenBlur","ScreenBlurColorGreen",1)
	-- System:SetScreenFxParamFloat("ScreenBlur","ScreenBlurColorBlue",1)
	SmokeBlur.IsActive=1
	Amout = tonumber(getglobal("game_ScreenBlurAmout"))
	-- if ClientStuff.vlayers:IsActive("NightVision") or ClientStuff.vlayers:IsActive("HeatVision") then Amout = 0 end
end

function SmokeBlur:OnDeactivate()
	-- System:SetScreenFx("ScreenBlur",0) -- Не вырубать, а то один кадр ярким становится.
	SmokeBlur.IsActive=0
end

function SmokeBlur:OnFadeOut()
	if not BasicPlayer.IsAlive(_localplayer) then return end
	if not SmokeBlur.lastTime then SmokeBlur:OnDeactivate() return 1 end --
	local dt = _time - SmokeBlur.lastTime
	SmokeBlur.lastTime = _time
	SmokeBlur.blurAmount = SmokeBlur.blurAmount - dt * SmokeBlur.fadeOutRate
	-- System:Log("blurAmount: "..SmokeBlur.blurAmount)
	if SmokeBlur.blurAmount < 0 or (Amout and SmokeBlur.blurAmount<Amout) then
		SmokeBlur:OnDeactivate()
		return 1
	end
	System:SetScreenFxParamFloat("ScreenBlur","ScreenBlurAmount",SmokeBlur.blurAmount)
end

function SmokeBlur:OnUpdate()
	if not BasicPlayer.IsAlive(_localplayer) then return end
	local dt = _time - SmokeBlur.lastTime
	SmokeBlur.blurAmount = SmokeBlur.blurAmount + dt * (SmokeBlur.fadeInRate * SmokeBlur.fadeInScale - SmokeBlur.fadeOutRate)
	if SmokeBlur.blurAmount < 0 then
		SmokeBlur.blurAmount = 0
--		SmokeBlur:OnDeactivate()
		-- don't disable layer,some bug on this. Only disable effect.
		--ClientStuff.vlayers:DeactivateLayer("SmokeBlur")
	end
	if SmokeBlur.blurAmount > 1 then
		System:SetScreenFx("ScreenBlur",1) -- always make sure its active..
		SmokeBlur.blurAmount = 1
	end
	if Amout and SmokeBlur.blurAmount<Amout then
		SmokeBlur.blurAmount = Amout
	end
	-- System:Log("blurAmount: "..SmokeBlur.blurAmount)
	System:SetScreenFxParamFloat("ScreenBlur","ScreenBlurAmount",SmokeBlur.blurAmount)
	local R,G,B
	if Amout then
		R = tonumber(getglobal("game_ScreenBlurR"))
		G = tonumber(getglobal("game_ScreenBlurG"))
		B = tonumber(getglobal("game_ScreenBlurB"))
		local AddAmout = 0
		-- if SmokeBlur.blurAmount>Amout then -- Резкая активация получается и дизактивация.
		if SmokeBlur.blurAmount>Amout or R+AddAmout>R or G+AddAmout>G or B+AddAmout>B then -- Так лучше, но маленький промежуток есть.
		-- if NoLimit>Amout then -- Резкая активация получается.
			AddAmout = SmokeBlur.blurAmount
		end
		R = R+AddAmout
		G = G+AddAmout
		B = B+AddAmout
		if R>1 then R=1 end	if G>1 then G=1 end	if B>1 then B=1 end
		-- -- if not R then R=1 G=1 B=1 end
		Hud:SetScreenDamageColor(R,G,B)
		-- System:Log("R: "..R..", G: "..G..", B: "..B..", blurAmount: "..SmokeBlur.blurAmount)
	end
	-- last call to OnUpdate is deactivation time
	SmokeBlur.lastTime = _time
	SmokeBlur.fadeInScale = 0
end

function SmokeBlur:OnShutdown()
end

function SmokeBlur:OnRestore(pRestoreTbl)
	SmokeBlur.IsActive = pRestoreTbl.IsActive
	SmokeBlur.blurAmount = pRestoreTbl.blurAmount
	SmokeBlur.fadeInRate = pRestoreTbl.fadeInRate
	SmokeBlur.fadeInScale = pRestoreTbl.fadeInScale
	SmokeBlur.fadeOutRate = pRestoreTbl.fadeOutRate
end