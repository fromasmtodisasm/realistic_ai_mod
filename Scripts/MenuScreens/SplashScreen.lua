UI.PageSplashScreen=
{
	GUI=
	{
		background=
		{
			classname = "static",
			
			left = 0, top = 0,
			width = 800, height = 600,
			bordersize = 0,
			
			halign = UIALIGN_CENTER,
			valign = UIALIGN_MIDDLE,
			
			tabstop = 1,
			
			zorder = 5000,
			
			color = "255 255 255 255",
		},
		
		OnUpdate = function(self)
			if (UI.PageSplashScreen.fEndTime < _time) then
				UI.PageSplashScreen.End();
			end
			
			if (UI.PageSplashScreen.bSkipable and (UI.PageSplashScreen.fCanSkipTime < _time)) then
				local szKeyName = Input:GetXKeyPressedName();
			
				if ((szKeyName == "esc") or (szKeyName == "spacebar") or (szKeyName == "f7")) then
					UI.PageSplashScreen.End();
				end
			end		
		end,
		
		OnActivate = function(self)
			self.background:SetTexture(UI.PageSplashScreen.iTexture);
			
			if (UI.PageSplashScreen.szText) then
				self.background:SetText(UI.PageSplashScreen.szText);
			else
				self.background:SetText("");
			end
		end,
		
		OnDeactivate = function(self)
			UI:SetFocus(self.background);
			self.background:SetTexture(nil);
		end,
	},
	
	End = function()
		if (UI.PageSplashScreen.pfnNextProc) then
			UI.PageSplashScreen.pfnNextProc();
		end

		UI:DeactivateScreen("SplashScreen");
		UI.PageSplashScreen.iTexture = nil;
	end,
}


UI:CreateScreenFromTable("SplashScreen", UI.PageSplashScreen.GUI);


function UI.SplashScreen(texture, text, skipable, duration, nextproc)
	UI.PageSplashScreen.iTexture = texture;
	UI.PageSplashScreen.szText = text;
	UI.PageSplashScreen.bSkipable = skipable;
	UI.PageSplashScreen.pfnNextProc = nextproc;
	if (duration) then
		UI.PageSplashScreen.fEndTime = _time + duration;
		UI.PageSplashScreen.fCanSkipTime = _time + UI.fCanSkipTime;
	end
	
	
	UI:ActivateScreen("SplashScreen");
end