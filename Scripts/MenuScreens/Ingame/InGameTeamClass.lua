Script:LoadScript("SCRIPTS/MULTIPLAYER/MultiplayerClassDefiniton.lua",1);		-- global MultiplayerClassDefiniton
Script:LoadScript("Scripts/Multiplayer/SVcommands.lua");

UI.PageInGameTeamClass =
{	
	GUI=
	{
		MissionName =
		{
			skin = UI.skins.MenuBorder,
			
			left = 200, top = 110,
			width = 580, height = 25,
		},
		
		InfoBack = 
		{
			skin = UI.skins.MenuBorder,
			left = 200, top = 141,
			width = 580, height = 42,
			
			zorder = -10,
		},
		
		GameTime=
		{
			skin = UI.skins.MenuStatic,
			
			left = 430, top = 150,
			width = 44, height = 24,
					
			halign = UIALIGN_CENTER,
		},
	
		RespawnTime=
		{
			skin = UI.skins.MenuStatic,
			
			left = 710, top = 150,
			width = 32, height = 24,
					
			halign = UIALIGN_CENTER,
		},
	
		GameTimeStatic=
		{
			skin = UI.skins.Label,
			
			left = 200, top = 150,
			width = 220, height = 24,
					
			text = Localize("RemainingTime"),
		},
		
	
		RespawntimeStatic=
		{
			skin = UI.skins.Label,
			
			left = 480, top = 150,
			width = 220, height = 24,

			text = Localize("ReinforcementTime"),
		},
		
		-- teams and classes
		--------------------
		-- team red
		Team1 =
		{
			skin = UI.skins.CheckBox,
			
			left = 283, top = 190,
			width = 128, height = 30,

			text = Localize("TeamRed"),
			leftspacing = 20,
			
			tabstop = 1,
			
			checkcolor = "180 0 0 255",
			
			Team1Count =
			{
				skin = UI.skins.MenuStatic,
				left = 0, top = 0,
				width = 30, height = 30,
				bordersides="r",
				
				greyedcolor = "0 0 0 0",
				color = "0 0 0 0",
				
				halign = UIALIGN_CENTER,
				flags = UIFLAG_VISIBLE,
			},
		},
	
	
		Team2 =
		{
			skin = UI.skins.CheckBox,
			
			left = 426, top = 190,
			width = 128, height = 30,

			text = Localize("TeamBlue"),
			
			leftspacing = 20,
			
			tabstop = 2,
			
			checkcolor = "0 0 180 255",
			
			
			Team2Count =
			{
				skin = UI.skins.MenuStatic,
				left = 0, top = 0,
				width = 30, height = 30,
				bordersides="r",
				
				greyedcolor = "0 0 0 0",
				color = "0 0 0 0",
				
				halign = UIALIGN_CENTER,
				flags = UIFLAG_VISIBLE,
			},
		},
			
		TeamSpec =
		{
			skin = UI.skins.CheckBox,
			
			left = 569, top = 190,
			width = 128, height = 30,

			text = Localize("TeamSpec"),
			leftspacing = 20,
			
			tabstop = 3,
			
			checkcolor = "12 96 12 255",
			
			TeamSpecCount =
			{
				skin = UI.skins.MenuStatic,
				left = 0, top = 0,
				width = 30, height = 30,
				bordersides="r",
				
				greyedcolor = "0 0 0 0",
				color = "0 0 0 0",
				
				halign = UIALIGN_CENTER,
				flags = UIFLAG_VISIBLE,
			},
		},
		
		--------------------------------------------------------------------------------
		Class1 =
		{
			skin = UI.skins.CheckBox,
			color = "255 255 255 255",
			style = 0,
			
			left = 362, top = 228,
			width = 56, height = 56,
			
			tabstop = 4,
			
			texture = System:LoadImage("textures/gui/standard_buttons"),
			downtexture = System:LoadImage("textures/gui/selected_buttons"),
			overtexture = System:LoadImage("textures/gui/rollover_buttons"),
			texrect = "101, 5, 54, 54", -- grunt	
			
			Class1Count =
			{
				skin = UI.skins.MenuStatic,
				
				left = 14, top = 36,
				width = 30, height = 20,
				
				greyedcolor = "0 0 0 0",
				color = "0 0 0 0",
				
				bordersides = "lrt",
				
				halign = UIALIGN_CENTER,
				flags = UIFLAG_VISIBLE,
			},
		},
	
			
		Class2 =
		{
			skin = UI.skins.CheckBox,
			color = "255 255 255 255",
			style = 0,
			
			left = 578, top = 228,
			width = 56, height = 56,
			
			tabstop = 6,
			
			texture = System:LoadImage("textures/gui/standard_buttons"),
			downtexture = System:LoadImage("textures/gui/selected_buttons"),
			overtexture = System:LoadImage("textures/gui/rollover_buttons"),
			texrect = "198, 5, 54, 54", -- mechanic
			
			Class2Count =
			{
				skin = UI.skins.MenuStatic,
				
				left = 14, top = 36,
				width = 30, height = 20,
				
				greyedcolor = "0 0 0 0",
				color = "0 0 0 0",
				
				bordersides = "lrt",
				
				halign = UIALIGN_CENTER,
				flags = UIFLAG_VISIBLE,
			},
		},
			
		Class3 =
		{
			skin = UI.skins.CheckBox,
			color = "255 255 255 255",
			style = 0,
			
			left = 470, top = 228,
			width = 56, height = 56,
			
			tabstop = 5,

			texture = System:LoadImage("textures/gui/standard_buttons"),
			downtexture = System:LoadImage("textures/gui/selected_buttons"),
			overtexture = System:LoadImage("textures/gui/rollover_buttons"),
			texrect = "6, 61, 54, 54", -- sniper
			
			Class3Count =
			{
				skin = UI.skins.MenuStatic,
				
				left = 14, top = 36,
				width = 30, height = 20,
				
				greyedcolor = "0 0 0 0",
				color = "0 0 0 0",
				
				bordersides = "lrt",
				
				halign = UIALIGN_CENTER,
				flags = UIFLAG_VISIBLE,
			},
		},			
	
		-- weapons
		----------
		Weapon1=
		{
			skin = UI.skins.ComboBox,
			
			left = 223, top = 292,
			width = 126, height = 32,
			
			tabstop = 7,
		},
	
		Weapon2=
		{
			skin = UI.skins.ComboBox,
			
			left = 359, top = 292,
			width = 126, height = 32,
			
			tabstop = 8,
		},
	
		Weapon3=
		{
			skin = UI.skins.ComboBox,
			
			left = 495, top = 292,
			width = 126, height = 32,
			
			tabstop = 9,
		},
	
		Weapon4=
		{	
			skin = UI.skins.ComboBox,
			
			left = 631, top = 292,
			width = 126, height = 32,
			
			tabstop = 10,
		},

		
		Suicide =
		{
			skin = UI.skins.BottomMenuButton,
			
			left = 780-159,
			width = 160,
			bordersides="",
			
			tabstop = 12,

			text = Localize("SuicideAndApply"),

			OnCommand = function(Sender)
				local Apply = UI:GetWidget("Apply", "InGameTeamClass");
				
				Apply:OnCommand(Apply);
				
				if (Client) then
					Client:Kill();
				end
			end,
		},

		Apply =
		{
			skin = UI.skins.BottomMenuButton,
			left = 620-158,
			width = 160,
			bordersides="lr",
			
			tabstop = 11,
			
			text = Localize("Apply"),
			
			OnCommand = function(Sender)
			
				local iWeapon;
				local szTeam;
				local szClassString = "CPC ";

				if (UI:GetWidget("Team1", "InGameTeamClass"):GetChecked()) then			
					szTeam = "red";
				elseif (UI:GetWidget("Team2", "InGameTeamClass"):GetChecked()) then
					szTeam = "blue";
				else
					szTeam = "spectators";
				end
				
--				printf("TEAM: "..szTeam);
				
				-- get classname
				local Widget;
				for i = 1, 3 do
					Widget = UI:GetWidget("Class"..i, "InGameTeamClass");
					
					if (Widget:GetChecked()) then
						break;
					end
				end
				
				local szClassName = UI.PageInGameTeamClass.GUI.WidgetToClass[Widget:GetName()];
			
--				printf("CLASSNAME: "..szClassName);
				szClassString = szClassString .. szClassName .. " ";
				
				-- get weapons
				iWeapon = UI:GetWidget("Weapon1", "InGameTeamClass"):GetSelectionIndex()
				if (iWeapon) then
					szClassString = szClassString .. iWeapon .. " ";
				end

				iWeapon = UI:GetWidget("Weapon2", "InGameTeamClass"):GetSelectionIndex()
				if (iWeapon) then
					szClassString = szClassString .. iWeapon .. " ";
				end
	
				iWeapon = UI:GetWidget("Weapon3", "InGameTeamClass"):GetSelectionIndex()
				if (iWeapon) then
					szClassString = szClassString .. iWeapon .. " ";
				end
	
				iWeapon = UI:GetWidget("Weapon4", "InGameTeamClass"):GetSelectionIndex()
				if (iWeapon) then
					szClassString = szClassString .. iWeapon;
				end
				
				if (Client) then
					Client:SendCommand(szClassString);
					Client:JoinTeamRequest(szTeam);
				end

				Game:SendMessage("Switch");
			end
		},

--		Ready =
--		{
--			skin = UI.skins.BottomMenuButton,
--			left = 620-159-158,
--			width = 160,
--
--			text = Localize("Ready"),		
--			
--			OnCommand = function(Sender)
--				if (Client) then
--					Client:CallVote("ready");
--				end
--			end
--		},

		VoteYes =
		{
			skin = UI.skins.BottomMenuButton,
			left = 620-160-160,
			width = 100,

			text = "Vote Yes",		
			
			OnCommand = function(Sender)
				if (Client) then
					Client:Vote("yes");
        		UI:HideWidget("VoteYes", "InGameTeamClass");
			UI:HideWidget("VoteNo", "InGameTeamClass");
				end
			end
		},

		VoteNo =
		{
			skin = UI.skins.BottomMenuButton,
			left = 620-160-160-100,
			width = 100,


			text = "Vote No",		
			
			OnCommand = function(Sender)
				if (Client) then
					Client:Vote("no");
        		UI:HideWidget("VoteYes", "InGameTeamClass");
			UI:HideWidget("VoteNo", "InGameTeamClass");
				end
			end
		},

		PunishYes =
		{
			skin = UI.skins.BottomMenuButton,
			left = 620-160-160,
			width = 100,
			top = 465+30,

			text = "TK Punish",		
			
			OnCommand = function(Sender)
				if (Client) then
				        local judge=Hud["szSelfJudge"];
				        local criminal=Hud["szSelfCriminal"];
				        if (judge) then
				                Client:SendCommand("VTK "..judge.." "..criminal.." "..1);
                                        --UI.PageInGameTeamClass.GUI:UpdatePunish();
        		UI:HideWidget("PunishYes", "InGameTeamClass");
			UI:HideWidget("PunishNo", "InGameTeamClass");
                                end
				end
			end
		},

		PunishNo =
		{
			skin = UI.skins.BottomMenuButton,
			left = 620-160-160-100,
			width = 100,
			top = 465+30,

			text = "TK Forgive",		
			
			OnCommand = function(Sender)
				if (Client) then
				        local judge=Hud["szSelfJudge"];
				        local criminal=Hud["szSelfCriminal"];
				        if (judge) then
				                Client:SendCommand("VTK "..judge.." "..criminal.." "..0);
                                        --UI.PageInGameTeamClass.GUI:UpdatePunish();
        		UI:HideWidget("PunishYes", "InGameTeamClass");
			UI:HideWidget("PunishNo", "InGameTeamClass");
                                end
				end
			end
		},
	},
}


-- OnInit
function UI.PageInGameTeamClass.GUI:OnInit()
	-- set the callbacks
	self.Team1.OnChanged = self.OnTeamChanged;
	self.Team2.OnChanged = self.OnTeamChanged;
	self.TeamSpec.OnChanged = self.OnTeamChanged;

	self.Class1.OnChanged = self.OnClassChanged;
	self.Class2.OnChanged = self.OnClassChanged;
	self.Class3.OnChanged = self.OnClassChanged;
	--self.Class4.OnChanged = self.OnClassChanged;
	--self.Class5.OnChanged = self.OnClassChanged;
end


-- OnUpdate
function UI.PageInGameTeamClass.GUI.OnUpdate(self)

	local iGameState;
	
	if (Client) then
		iGameState = Client:GetGameState();
	else
		iGameState = CGS_INTERMISSION;
	end

	if iGameState ~= CGS_INTERMISSION then
		if ((not UI.PageInGameTeamClass.fLastRPCTime) or (UI.PageInGameTeamClass.fLastRPCTime and (UI.PageInGameTeamClass.fLastRPCTime + 1 < _time))) then
			UI.PageInGameTeamClass.fLastRPCTime = _time;
			Client:SendCommand("RPC");
	
			if (Hud.bWaitingForSelfStat) then
				Client:SendCommand("GPC");
			end
		end
	end
	
	-- set remaining mission time
	local fTime;	
	
	if (Hud.fTimeLimit and (Hud.fTimeLimit > 0)) then
		if (iGameState == CGS_INPROGRESS) then
			fTime = floor(Hud.fTimeLimit * 60) - (_time - Client:GetGameStartTime());
			self.GameTime:SetText(SecondsToString(max(fTime, 0)));
		else
			self.GameTime:SetText("00:00");
		end
	else
		self.GameTime:SetText("N/A");
	end
	
	-- set respawn remaining
	if (iGameState == CGS_INPROGRESS and Hud.iRespawnCycleLength) then
		fTime = ceil(Hud.iRespawnCycleLength - (_time - Hud.iRespawnCycleStart));
		self.RespawnTime:SetText(max(fTime, 0));
	else
		self.RespawnTime:SetText("0");
	end
	
	-- set player count
	local Team01Count 	= UI:GetWidget("Team1Count", "InGameTeamClass");
	local Team02Count 	= UI:GetWidget("Team2Count", "InGameTeamClass");
	local TeamSpecCount = UI:GetWidget("TeamSpecCount", "InGameTeamClass");
	local iClassIndex 	= 1;
	local Widget;

	if (Hud.bReceivedPlayerCount) then
		Team01Count:SetText(Hud.iTeam01Count);
		Team02Count:SetText(Hud.iTeam02Count);
		TeamSpecCount:SetText(Hud.iTeamSpecCount);
		
		local ClassCount = { 0, 0, 0, 0 };
		
		if (UI.PageInGameTeamClass.GUI.Team1:GetChecked()) then
			ClassCount = Hud.Team01ClassCount;
		elseif (UI.PageInGameTeamClass.GUI.Team2:GetChecked()) then
			ClassCount = Hud.Team02ClassCount;
		end
	
		for szClassName, ClassTable in MultiplayerClassDefiniton.PlayerClasses do

			Widget = UI:GetWidget("Class"..iClassIndex.."Count", "InGameTeamClass");
			
			if (Widget) then
				Widget:SetText(ClassCount[iClassIndex]);
			end
			
			iClassIndex = iClassIndex + 1;
		end
	else
		Team01Count:SetText("");
		Team02Count:SetText("");
		TeamSpecCount:SetText("");
		
		for szClassName, ClassTable in MultiplayerClassDefiniton.PlayerClasses do
			Widget = UI:GetWidget("Class"..iClassIndex.."Count", "InGameTeamClass");
			
			if (Widget) then
				Widget:SetText("");
			end

			iClassIndex = iClassIndex + 1;
		end		
	end

	if getglobal("gr_votetime") then
		if _time>tonumber(getglobal("gr_votetime")) then
			UI:HideWidget("VoteYes", "InGameTeamClass");
			UI:HideWidget("VoteNo", "InGameTeamClass");
		else
			UI:ShowWidget("VoteYes", "InGameTeamClass");
			UI:ShowWidget("VoteNo", "InGameTeamClass");
		end
	else 

			UI:HideWidget("VoteYes", "InGameTeamClass");
			UI:HideWidget("VoteNo", "InGameTeamClass");
	end

	if (Client) then
           Client:SendCommand("GTK");
      end

	UI.PageInGameTeamClass.GUI:UpdatePunish();


	if (Hud.bReceivedSelfStat and Hud.bWaitingForSelfStat) then
		local Widget;
		
--		printf (Hud.szSelfTeam);
		if (Hud.szSelfTeam == "red") then
			Widget = UI:GetWidget("Team1", "InGameTeamClass");
		elseif (Hud.szSelfTeam == "blue") then
			Widget = UI:GetWidget("Team2", "InGameTeamClass");
		else
			Widget = UI:GetWidget("TeamSpec", "InGameTeamClass");
		end
		
		-- select the team
		UI.PageInGameTeamClass.GUI.OnTeamChanged(Widget);
			
		Widget = UI:GetWidget(UI.PageInGameTeamClass.GUI.ClassToWidget[Hud.szSelfClass], "InGameTeamClass");

		-- select the class
		UI.PageInGameTeamClass.GUI.OnClassChanged(Widget);
		
		-- select the weapons
		local iWeapon;
		for i=1, 4 do
			iWeapon = Hud["iSelfWeapon"..i];

			if (iWeapon and iWeapon > 0) then
				Widget = UI:GetWidget("Weapon"..i, "InGameTeamClass");
				Widget:SelectIndex(iWeapon);
			end
		end

		UI.PageInGameTeamClass.GUI:EnableWidgets(1, 1, 0);
		Hud.bWaitingForSelfStat = nil;
	end	
	self:PopulateChatTarget(1);
end

		
-- OnActivate
function UI.PageInGameTeamClass.GUI:OnActivate()

	Hud.bReceivedPlayerCount = nil;
	Hud.bReceivedSelfStat = nil;
	Hud.bWaitingForSelfStat = 1;
	
	local Page = UI.PageInGameTeamClass.GUI;
	
	Page.WidgetToClass = {};
	Page.ClassToWidget = {};
	Page.WeaponToTexture = {};
	
	Page.Class1:SetChecked(0);
	Page.Class2:SetChecked(0);
	Page.Class3:SetChecked(0);
	--Page.Class4:SetChecked(0);
	--Page.Class5:SetChecked(0);
		
	-- set mission name
	self.MissionName:SetText(g_LevelName);
	self:PopulateTables();
	self:PopulateChatTarget();
	
	-- disable everything until the server replies
	UI.PageInGameTeamClass.GUI:ClearWidgets();
	UI.PageInGameTeamClass.GUI:DisableWidgets(1, 1, 1);

	if (Client) then
           Client:SendCommand("GTK");
      end
	
--	if (gr_PrewarOn and tonumber(getglobal("gr_PrewarOn")) ~= 0) then
--		UI:ShowWidget("Ready", "InGameTeamClass");
--	else
--		UI:HideWidget("Ready", "InGameTeamClass");
--	end

	if getglobal("gr_votetime") then
		if _time>tonumber(getglobal("gr_votetime")) then
			UI:HideWidget("VoteYes", "InGameTeamClass");
			UI:HideWidget("VoteNo", "InGameTeamClass");
		else
			UI:ShowWidget("VoteYes", "InGameTeamClass");
			UI:ShowWidget("VoteNo", "InGameTeamClass");
		end
	else 

			UI:HideWidget("VoteYes", "InGameTeamClass");
			UI:HideWidget("VoteNo", "InGameTeamClass");
	end

 	UI.PageInGameTeamClass.GUI:UpdatePunish();

	if (Hud) then
		Hud.bHide = 1;
	end
end

-- OnDeactivate
function UI.PageInGameTeamClass.GUI:OnDeactivate()

	UI.PageInGameTeamClass.fLastRPCTime = nil;
	Hud.bReceivedPlayerCount = nil;
	Hud.bReceivedSelfStat = nil;
	Hud.bWaitingForSelfStat = 1;
	
	if (Hud) then
		Hud.bHide = nil;
	end
end
		
-- OnTeamChanged
function UI.PageInGameTeamClass.GUI.OnTeamChanged(Sender)	
	UI:GetWidget("Team1", "InGameTeamClass"):SetChecked(0);
	UI:GetWidget("Team2", "InGameTeamClass"):SetChecked(0);
	UI:GetWidget("TeamSpec", "InGameTeamClass"):SetChecked(0);

	Sender:SetChecked(1);
end
	
		
-- OnClassChanged
function UI.PageInGameTeamClass.GUI.OnClassChanged(Sender)

	for i=1, 3 do
		local Class = UI:GetWidget("Class"..i, "InGameTeamClass");
			
		Class:SetChecked(0);
	end
		
	Sender:SetChecked(1);
			
	local ClassDef = MultiplayerClassDefiniton.PlayerClasses[UI.PageInGameTeamClass.GUI.WidgetToClass[Sender:GetName()]];
		
	for i=1, 4 do			
		local WeaponSlot = UI:GetWidget("Weapon"..i, "InGameTeamClass");
			
		WeaponSlot:Clear();

		for WeaponIndex, WeaponName in ClassDef["weapon"..i] do

			WeaponSlot:AddItem("", System:LoadImage("textures/gui/weapons"), UI.PageInGameTeamClass.GUI.WeaponToTexture[WeaponName]);

		end

		if (WeaponSlot:GetItemCount() ~= 0) then
			UI:EnableWidget(WeaponSlot);
			WeaponSlot:SelectIndex(1);
		else
			UI:DisableWidget(WeaponSlot);
		end
	end
end

 function UI.PageInGameTeamClass.GUI.UpdatePunish()


	--local judge=Hud["szSelfJudge"];
	local judge=Hud.szSelfJudge;
	if (judge ~= nil) then
        	if (judge ~= 0) then
			UI:ShowWidget("PunishYes", "InGameTeamClass");
			UI:ShowWidget("PunishNo", "InGameTeamClass");
		else
        		UI:HideWidget("PunishYes", "InGameTeamClass");
			UI:HideWidget("PunishNo", "InGameTeamClass");
		end
	else
			UI:HideWidget("PunishYes", "InGameTeamClass");
			UI:HideWidget("PunishNo", "InGameTeamClass");
	end


end

--------------------------------------------------------------------------------
function UI.PageInGameTeamClass.GUI:GetWeaponAt(y)
	return "0, "..y..", 94, 30";
end

--------------------------------------------------------------------------------
function UI.PageInGameTeamClass.GUI:GetClassAt(x, y)
	return tostring(x)..", "..tostring(y)..", 56, 56";
end

--------------------------------------------------------------------------------
function UI.PageInGameTeamClass.GUI.ClearWidgets()

	UI.PageInGameTeamClass.GUI.Team1:SetChecked(0);
	UI.PageInGameTeamClass.GUI.Team2:SetChecked(0);
	UI.PageInGameTeamClass.GUI.TeamSpec:SetChecked(0);
	
	UI.PageInGameTeamClass.GUI.Class1:SetChecked(0);
	UI.PageInGameTeamClass.GUI.Class2:SetChecked(0);
	UI.PageInGameTeamClass.GUI.Class3:SetChecked(0);
	--UI.PageInGameTeamClass.GUI.Class4:SetChecked(0);
	--UI.PageInGameTeamClass.GUI.Class5:SetChecked(0);
	
	UI.PageInGameTeamClass.GUI.Weapon1:Clear();
	UI.PageInGameTeamClass.GUI.Weapon2:Clear();
	UI.PageInGameTeamClass.GUI.Weapon3:Clear();
	UI.PageInGameTeamClass.GUI.Weapon4:Clear();	

end

--------------------------------------------------------------------------------
function UI.PageInGameTeamClass.GUI:EnableWidgets(teams, class, weapons)

	-- enable the teams	
	if (teams and teams ~= 0) then
		UI:EnableWidget("Team1", "InGameTeamClass");
		UI:EnableWidget("Team2", "InGameTeamClass");
		UI:EnableWidget("TeamSpec", "InGameTeamClass");
	end
	
	-- enable the classes
	if (class and class ~= 0) then
		for i=1, 3 do
			UI:EnableWidget("Class"..i, "InGameTeamClass");
		end
	end

	-- enable the weapons
	if (weapons and weapons ~= 0) then
		for i=1, 4 do
			UI:EnableWidget("Weapon"..i, "InGameTeamClass");
		end
	end	
end


--------------------------------------------------------------------------------
function UI.PageInGameTeamClass.GUI:DisableWidgets(teams, classes, weapons)

	-- enable the teams	
	if (teams and teams ~= 0) then
		UI:DisableWidget("Team1", "InGameTeamClass");
		UI:DisableWidget("Team2", "InGameTeamClass");
		UI:DisableWidget("TeamSpec", "InGameTeamClass");
	end
	
	-- enable the classes
	if (classes and classes ~= 0) then
		for i=1, 4 do
			UI:DisableWidget("Class"..i, "InGameTeamClass");
		end
	end

	-- enable the weapons
	if (weapons and weapons ~= 0) then
		for i=1, 4 do
			UI:DisableWidget("Weapon"..i, "InGameTeamClass");
		end
	end	
end

--------------------------------------------------------------------------------
function UI.PageInGameTeamClass.GUI:PopulateTables()

	-- populate the conversion table
	local WidgetToClass = UI.PageInGameTeamClass.GUI.WidgetToClass;
	local ClassToWidget = UI.PageInGameTeamClass.GUI.ClassToWidget;
	local WeaponToTexture = UI.PageInGameTeamClass.GUI.WeaponToTexture;
	
	WeaponToTexture["Machete"] = self:GetWeaponAt(381);
	WeaponToTexture["Falcon"] = self:GetWeaponAt(286);
	WeaponToTexture["MP5"] = self:GetWeaponAt(0);
	WeaponToTexture["P90"] = self:GetWeaponAt(125);
	WeaponToTexture["M4"] = self:GetWeaponAt(318);
	WeaponToTexture["SniperRifle"] = self:GetWeaponAt(350);
	WeaponToTexture["Shotgun"] = self:GetWeaponAt(156);
	WeaponToTexture["M249"] = self:GetWeaponAt(30);
	WeaponToTexture["RL"] = self:GetWeaponAt(61);
	WeaponToTexture["OICW"] = self:GetWeaponAt(93);
	WeaponToTexture["Shocker"] = self:GetWeaponAt(190);
	-- change the following
	WeaponToTexture["AG36"] = self:GetWeaponAt(254);
	WeaponToTexture["MedicTool"] = self:GetWeaponAt(447);
	WeaponToTexture["ScoutTool"] = self:GetWeaponAt(481);
	WeaponToTexture["EngineerTool"] = self:GetWeaponAt(412);
	
	local iIndex = 1; local Widget;		
	
	for szClassName, ClassTable in MultiplayerClassDefiniton.PlayerClasses do
		WidgetToClass["Class"..iIndex] = szClassName;
		ClassToWidget[szClassName] = "Class"..iIndex;

		iIndex = iIndex + 1;
	end
end


UI:AddChatbox(UI.PageInGameTeamClass.GUI, 200, 326, 580, 130, 24, 1);

AddUISideMenu(UI.PageInGameTeamClass.GUI,
{
	{ "Disconnect", Localize("Disconnect"), "$Disconnect$", 0},
	{ "Options", Localize("Options"), "Options", },
      { "ServerAdmin", "Server Admin", "ServerAdmin",},
      { "VotePanel", "Vote Panel", "VotePanel",},
	{ "-", "-", "-", },	-- separator
	{ "Quit", "@Quit", UI.PageMainScreen.ShowConfirmation, },		
});

UI:CreateScreenFromTable("InGameTeamClass", UI.PageInGameTeamClass.GUI);
