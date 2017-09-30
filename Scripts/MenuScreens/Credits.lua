function instruction_compare(a, b)
	if (a[1] < b[1]) then
		return 1;
	end
	
	return nil;
end

UI.PageCredits=
{
	fFadeOutTime = 1,	-- seconds
	fFadeInTime = 1, -- seconds

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
						
			zorder = 5000,
			
			color = "255 255 255 255",
		},

		foreground=
		{
			classname = "static",
			
			left = 0, top = 0,
			width = 800, height = 600,
			bordersize = 0,
			
			halign = UIALIGN_CENTER,
			valign = UIALIGN_MIDDLE,
			
			zorder = 5010,
			
			color = "255 255 255 0",
		},
		
		OnInit = function(self)
		
			UI.PageCredits.Script = {};
			UI.PageCredits:AddPage(0, 		"01blank");
			UI.PageCredits:AddPage(0.125, "01a");
			UI.PageCredits:AddPage(8, 		"01b");
			UI.PageCredits:AddPage(8, 		"01c");
			UI.PageCredits:AddPage(8, 		"02a");
			UI.PageCredits:AddBack(4, 		"02blank");
			UI.PageCredits:AddPage(4, 		"02b");
			UI.PageCredits:AddPage(8, 		"03a");
			UI.PageCredits:AddBack(4, 		"03blank");
			UI.PageCredits:AddPage(4, 		"03b");
			UI.PageCredits:AddPage(8, 		"04a");
			UI.PageCredits:AddBack(4, 		"04blank");
			UI.PageCredits:AddPage(4, 		"05a");
			UI.PageCredits:AddBack(4, 		"05blank");
			UI.PageCredits:AddPage(4, 		"05b");
			UI.PageCredits:AddPage(8, 		"06a");
			UI.PageCredits:AddBack(4, 		"06blank");
			UI.PageCredits:AddPage(4, 		"06b");
			UI.PageCredits:AddPage(8, 		"07a");
			UI.PageCredits:AddBack(4, 		"07blank");
			UI.PageCredits:AddPage(4, 		"07b");
			UI.PageCredits:AddPage(8, 		"07c");
			UI.PageCredits:AddPage(8, 		"08a");
			UI.PageCredits:AddBack(4, 		"08blank");
			UI.PageCredits:AddPage(4, 		"08b");
			UI.PageCredits:AddPage(8, 		"09a");
			UI.PageCredits:AddBack(4, 		"09a");
			UI.PageCredits:AddPage(4, 		"09b");
			UI.PageCredits:AddBack(4, 		"09b");
			UI.PageCredits:AddPage(4, 		"09c");
			UI.PageCredits:AddBack(4, 		"09c");
			UI.PageCredits:AddPage(4, 		"09d");
			UI.PageCredits:AddBack(4, 		"09d");
			UI.PageCredits:AddPage(4, 		"09e");
			UI.PageCredits:AddBack(4, 		"09e");
			UI.PageCredits:AddPage(4, 		"10a");
			UI.PageCredits:AddBack(4, 		"10a");
			UI.PageCredits:AddPage(4, 		"11a");
			UI.PageCredits:AddBack(4, 		"11blank");
			UI.PageCredits:AddPage(4, 		"11b");
			UI.PageCredits:AddPage(8, 		"12a");
			UI.PageCredits:AddBack(4, 		"12blank");
			UI.PageCredits:AddPage(4, 		"12b");
			UI.PageCredits:AddPage(8, 		"12c");
			UI.PageCredits:AddPage(8, 		"12d");
			UI.PageCredits:AddPage(8, 		"12e");
			UI.PageCredits:AddPage(8, 		"13a");
			UI.PageCredits:AddBack(4, 		"13blank");
			UI.PageCredits:AddPage(4, 		"13b");
			UI.PageCredits:AddPage(8, 		"13c");
			UI.PageCredits:AddPage(8, 		"14a");
			UI.PageCredits:AddBack(4, 		"14blank");
			UI.PageCredits:AddPage(4, 		"14b");
			UI.PageCredits:AddPage(8, 		"14c");
			UI.PageCredits:AddPage(8, 		"14d");
			UI.PageCredits:AddPage(8, 		"14e");
			UI.PageCredits:AddPage(8, 		"15a");
			UI.PageCredits:AddBack(4, 		"15blank");
			UI.PageCredits:AddPage(4, 		"15b");
			UI.PageCredits:AddPage(8, 		"15c");
			UI.PageCredits:AddPage(8, 		"16a");
			UI.PageCredits:AddBack(4, 		"16blank");
			UI.PageCredits:AddPage(4, 		"16b");
			UI.PageCredits:AddPage(8, 		"17a");
			UI.PageCredits:AddBack(4, 		"17blank");
			UI.PageCredits:AddPage(4, 		"17b");
			UI.PageCredits:AddPage(8, 		"17c");
			UI.PageCredits:AddPage(8, 		"17d");
			UI.PageCredits:AddPage(10, 		"end");

			sort(UI.PageCredits.Script, instruction_compare);

		end,
		
		OnActivate = function(self)
			self.fStartTime = System:GetCurrAsyncTime();
			self.fForegroundFadeIn = nil;
			self.iIP = 1;
			
			UI:DeactivateAllScreens();
			UI:HideMouseCursor();
			UI:ShowBackground();
			UI:SetBackgroundColor("0 0 0 255");
			
			UI:StopMusic();
			UI.PageCredits.PlayMusic(self);
			
			self.background:SetTexture(System:LoadImage(UI.PageCredits.Script[1][2]));
			UI.PageCredits.SetForegroundAlpha(0);
			
			UI:EnableSwitch(0);
		end,
		
		OnDeactivate = function(self)
			UI.PageCredits.StopMusic(self);
			UI:PlayMusic();
			
			self.background:SetTexture(nil);
			self.foreground:SetTexture(nil);
		end,
		
		OnUpdate = function(self)
			
			UI:StopMusic();

			local Instruction = UI.PageCredits.Script[self.iIP];
			
			if (not UI.PageCredits.Script[self.iIP]) then
				UI.PageCredits:Finished();
				return;
			end
				
			local fRTime = System:GetCurrAsyncTime() - self.fStartTime;
			
			if (fRTime > UI.fCanSkipTime) then
				if ((Input:GetXKeyPressedName() == "esc") or (Input:GetXKeyPressedName() == "spacebar") or (Input:GetXKeyPressedName() == "f7")) then
					UI.PageCredits:Finished();
					return;
				end
			end

			if (fRTime > Instruction[1]) then
			
				if (Instruction[2] == "textures/credits/end") then
					UI.PageCredits:Finished();
					return;
				end
				
				if (Instruction[3] and Instruction[3] ~= 0) then
					UI.PageCredits.GUI.background:SetTexture(System:LoadImage(Instruction[2]));
				else
					UI.PageCredits.GUI.foreground:SetTexture(System:LoadImage(Instruction[2]));
					UI.PageCredits.SetForegroundAlpha(0);
					self.fForegroundFadeIn = Instruction[1];
					self.fForegroundFadeOut = UI.PageCredits.GetNextForegroundTime(self);
				end

				self.iIP = self.iIP+1;
			end
			
			if (self.fForegroundFadeIn and self.fForegroundFadeOut) then
				if (fRTime < self.fForegroundFadeIn + UI.PageCredits.fFadeInTime) then
					UI.PageCredits.SetForegroundAlpha((fRTime - self.fForegroundFadeIn) / UI.PageCredits.fFadeInTime);
				elseif (fRTime +  UI.PageCredits.fFadeOutTime > self.fForegroundFadeOut) then
					UI.PageCredits.SetForegroundAlpha(max((self.fForegroundFadeOut - fRTime) / UI.PageCredits.fFadeOutTime, 0));
				else
					UI.PageCredits.SetForegroundAlpha(1);
				end
			end
		end,
	},

	SetForegroundAlpha = function(fAlpha)
		UI.PageCredits.GUI.foreground:SetColor("255 255 255 "..floor(fAlpha * 255));
	end,
	
	GetNextForegroundTime = function(self)
		local iIP = self.iIP+1;
		
		if (not UI.PageCredits.Script[iIP][3] or UI.PageCredits.Script[iIP][3] == 0) then
			return UI.PageCredits.Script[iIP][1];
		end
		
		iIP = iIP+1;
		if (not UI.PageCredits.Script[iIP][3] or UI.PageCredits.Script[iIP][3] == 0) then
			return UI.PageCredits.Script[iIP][1];
		end
		
		return nil;
	end,
	
	GetNextBackgroundTime = function(self)
		
		local iIP = self.iIP+1;
		
		if (UI.PageCredits.Script[iIP][3] and UI.PageCredits.Script[iIP][3] ~= 0) then
			return UI.PageCredits.Script[iIP][1];
		end
		
		iIP = iIP+1;
		if (UI.PageCredits.Script[iIP][3] and UI.PageCredits.Script[iIP][3] ~= 0) then
			return UI.PageCredits.Script[iIP][1];
		end
		
		return nil;
	end,
	
	Finished = function(self)
		Game:ShowMenu();
		GotoPage("$MainScreen$", 0);
	end,
	
	PlayMusic = function(self)
		
		UI:StopMusic();
		
		UI.PageCredits.MusicId = Sound:LoadStreamSound(UI.szCreditsMusic, SOUND_LOOP+SOUND_MUSIC+SOUND_UNSCALABLE);
		
		if (UI.PageCredits.MusicId and tostring(getglobal("s_MusicEnable")) == "1") then
			Sound:SetSoundLoop(UI.PageCredits.MusicId, 1);
			Sound:PlaySound(UI.PageCredits.MusicId);
			Sound:SetSoundVolume(UI.PageCredits.MusicId, getglobal("s_MusicVolume") * 255.0);
		end
	end,
	
	StopMusic = function(self)
		Sound:StopSound(UI.PageCredits.MusicId);
		UI.PageCredits.MusicId = nil;
		
		UI:PlayMusic();
	end,
	
	AddBack = function (self, fDelta, szImage)
		local fTime = fDelta;
		
		if (self.Script[getn(self.Script)]) then
			fTime = fTime + self.Script[getn(self.Script)][1];
		end
		
		local NewBackground = { fTime, "textures/credits/"..szImage, 1 };
		
		tinsert(self.Script, NewBackground);
	end,
	
	AddPage = function (self, fDelta, szImage)
		local fTime = fDelta;
		
		if (self.Script[getn(self.Script)]) then
			fTime = fTime + self.Script[getn(self.Script)][1];
		end
		
		local NewPage = { fTime, "textures/credits/"..szImage };
		
		tinsert(self.Script, NewPage);		
	end,
}

UI:CreateScreenFromTable("Credits", UI.PageCredits.GUI);