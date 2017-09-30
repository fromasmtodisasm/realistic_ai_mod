
UI.PageCreateServer=
{
	LevelList={},		-- { missionname1={}, missionname2={}, }
	
	GUI =
	{
		CreateUBIServerText=
		{
			skin = UI.skins.Label,
			
			left = 200, top = 110,
			width = 122, 
			halign = UIALIGN_LEFT,
						
			text = Localize("CreateUBIServer");
		},
		
		CreateLANServerText=
		{
			skin = UI.skins.Label,
			
			left = 200, top = 110,
			width = 122, 
			halign = UIALIGN_LEFT,
			
			text = Localize("CreateLANServer");
		},

		ConnectionText=
		{
			skin = UI.skins.Label,
			
			left = 200, top = 110,
			width = 485, 
			
			halign = UIALIGN_RIGHT,
						
			text = Localize("ConnectionSettings");
		},
		
		Connection=
		{
			skin = UI.skins.ComboBox,
			left = 690, top = 110,
			width = 90, height = 25,
			
			vscrollbar=
			{
				skin = UI.skins.VScrollBar,
			},
		},
		
		RightTopStatic=
		{
			skin = UI.skins.MenuBorder,
			
			left = 600, top = 141,
			width = 180, height = 130,
			bordersides = "l",
			
			zorder = -50,
		},
		
		PunkBusterText=
		{
			skin = UI.skins.Label,
			left =600, top = 152,
			width = 134,
			
			text = Localize("EnablePBServer");
		},
		
		PunkBuster=
		{
			skin = UI.skins.CheckBox,
			left = 742, top = 152,
			
			tabstop = 9,
			
			OnChanged = function(self)
				if(self:GetChecked()) then
					setglobal("sv_punkbuster", 1);
					setglobal("cl_punkbuster", 1);
				else
					setglobal("sv_punkbuster", 0);
					setglobal("cl_punkbuster", 0);
				end
			end,
		},

		RightBottomStatic=
		{
			skin = UI.skins.MenuBorder,
			
			left = 600, top = 270,
			width = 180, height = 93,
			
			zorder = -50,
		},

		BottomStatic=
		{
			skin = UI.skins.MenuBorder,
			
			left = 200, top = 362,
			width = 580, height = 97,
			
			zorder = -50,
		},
		
		MODCombo=
		{
			skin = UI.skins.ComboBox,
			
			left = 610, top = 280,
			width = 160, height = 32,
			
			tabstop = 11,
			
			vscrollbar=
			{
				skin = UI.skins.VScrollBar,
			},		
			
			OnChanged = function(Sender)
				UI.PageCreateServer.PopulateLevelCombo();
				
				if (UI.PageCreateServer.GUI.LevelCombo:GetItemCount()) then
				
					if (UI.PageCreateServer.szLastMap) then
						UI.PageCreateServer.GUI.LevelCombo:Select(UI.PageCreateServer.szLastMap);
					elseif (getglobal(gr_NextMap)) then
						UI.PageCreateServer.GUI.LevelCombo:Select(tostring(gr_NextMap));
					end

					if (not UI.PageCreateServer.GUI.LevelCombo:GetSelection()) then
						UI.PageCreateServer.GUI.LevelCombo:SelectIndex(1);
					end
				end
				
				local szMOD = UI.PageCreateServer.GUI.MODCombo:GetSelection();
				
				if szMOD and AvailableMODList[strupper(szMOD)].team==0 then
					UI:HideWidget(UI.PageCreateServer.GUI.FriendlyFireText);
					UI:HideWidget(UI.PageCreateServer.GUI.FriendlyFire);
					UI:HideWidget(UI.PageCreateServer.GUI.MinTeamPlayers);
					UI:HideWidget(UI.PageCreateServer.GUI.MaxTeamPlayers);
					UI:HideWidget(UI.PageCreateServer.GUI.MinTeamPlayersText);
					UI:HideWidget(UI.PageCreateServer.GUI.MaxTeamPlayersText);
				else
					UI:ShowWidget(UI.PageCreateServer.GUI.FriendlyFireText);
					UI:ShowWidget(UI.PageCreateServer.GUI.FriendlyFire);
					UI:ShowWidget(UI.PageCreateServer.GUI.MinTeamPlayers);
					UI:ShowWidget(UI.PageCreateServer.GUI.MaxTeamPlayers);
					UI:ShowWidget(UI.PageCreateServer.GUI.MinTeamPlayersText);
					UI:ShowWidget(UI.PageCreateServer.GUI.MaxTeamPlayersText);
				end	
				
				if szMOD and AvailableMODList[strupper(szMOD)].respawntime==1 then
					UI:ShowWidget(UI.PageCreateServer.GUI.RespawnTimeText);
					UI:ShowWidget(UI.PageCreateServer.GUI.RespawnTime);
				else
					UI:HideWidget(UI.PageCreateServer.GUI.RespawnTimeText);
					UI:HideWidget(UI.PageCreateServer.GUI.RespawnTime);
				end	
			end
		},
		
		LevelCombo=
		{
			skin = UI.skins.ComboBox,
			
			left = 610, top = 320,
			width = 160, height = 32,
			
			tabstop = 12,
			
			vscrollbar=
			{
				skin = UI.skins.VScrollBar,
			},
		},
		
		ServerNameText=
		{
			skin = UI.skins.Label,
			
			left = 200, top = 152,
			width = 122, 
			
			text = Localize("ServerName");
		},
		
		ServerName=
		{
			skin = UI.skins.EditBox,
			
			left = 330, top = 152,
			width = 180,
			
			tabstop = 1,
			
			fontsize = 12,
			
			maxlength = 26,
		},

		ServerPasswordText=
		{
			skin = UI.skins.Label,
			
			left = 200, top = 190,
			width = 122, 
			
			text = Localize("ServerPassword"),		
		},
		
		ServerPassword=
		{
			skin = UI.skins.EditBox,
			
			left = 330, top = 190,
			width = 180,
			
			fontsize = 12,
			
			tabstop = 2,
			maxlength = 28,
		},
		
		MinTeamPlayersText=
		{
			skin = UI.skins.Label,
			
			left = 200, top = 228,
			width = 264, 
			
			text = Localize("MinTeamPlayers");
		},
		
		MinTeamPlayers=
		{
			skin = UI.skins.EditBox,
			
			halign = UIALIGN_CENTER,
			maxlength = 2,
			numeric = 1,
			disallow = ".",
			
			tabstop = 3,
		
			left = 472, top = 228,
			width = 38,
		},

		MaxTeamPlayersText=
		{
			skin = UI.skins.Label,
			
			left = 200, top = 266,
			width = 264, 
			
			text = Localize("MaxTeamPlayers");
		},

		MaxTeamPlayers=
		{
			skin = UI.skins.EditBox,
			
			halign = UIALIGN_CENTER,
			maxlength = 2,
			numeric = 1,
			disallow = ".",
			
			tabstop = 4,
			
			left = 472, top = 266,
			width = 38,
		},

		MaxServerPlayersText=
		{
			skin = UI.skins.Label,
			
			left = 200, top = 304,
			width = 264, 
			
			text = Localize("MaxServerPlayers");
		},

		MaxServerPlayers=
		{
			skin = UI.skins.EditBox,
			
			halign = UIALIGN_CENTER,
			maxlength = 2,
			numeric = 1,
			disallow = ".",
			
			left = 472, top = 304,
			width = 38,
			
			tabstop = 5,
		},
		
		FriendlyFireText=
		{
			skin = UI.skins.Label,
			
			left = 420, top = 412,
			width = 194,		
			text = Localize("FriendlyFire"),
		},
		
		FriendlyFire=
		{
			skin = UI.skins.CheckBox,
			
			left = 622, top = 412,
			width = 28,
			
			tabstop = 8,
		},
	
		LoadProfile=
		{
			skin = UI.skins.BottomMenuButton,
			
			text = Localize("LoadServerProfile"),
			
			left = 208,
			width = 147,
			
			tabstop = 14,
			
			OnCommand = function()
				GotoPage("ServerLoadProfile");
			end
		},
		
		SaveProfile=
		{
			skin = UI.skins.BottomMenuButton,
			
			text = Localize("SaveServerProfile"),
			
			tabstop = 15,
			
			left = 363,
			width = 147,
			
			OnCommand = function(Sender)
				UI.InputBoxEx(Localize("SaveServerProfile"), Localize("AskServerProfileName"), g_serverprofile, 0, 1, 0, 0, 28, UI.PageCreateServer.SaveServerProfileOk);
			end
		},
		
		RespawnTimeText=
		{
			skin = UI.skins.Label,
			
			left = 200, top = 378,
			width = 180,
			
			text = Localize("RespawnTime"),
		},
		
		RespawnTime=
		{
			skin = UI.skins.EditBox,
			
			left = 388, top = 378,
			width = 42,
			
			halign = UIALIGN_CENTER,
			maxlength = 3,
			numeric = 1,
			disallow = ".",
			
			tabstop = 6,
		},
	
--		RespawnCycleText=
--		{
--			skin = UI.skins.Label,
			
--			left = 420, top = 378,
--			width = 194,
			
--			text = Localize("RespawnCycle"),
--		},
		
--		RespawnCycle=
--		{
--			skin = UI.skins.CheckBox,
			
--			left = 622, top = 378,
--			width = 28,
			
--			tabstop = 8,
--		},

		TimeLimitText=
		{
			skin = UI.skins.Label,
			
			left = 200, top = 412,
			width = 180,
			
			text = Localize("TimeLimit"),
		},

		TimeLimit=
		{
			skin = UI.skins.EditBox,
			
			left = 388, top = 412,
			width = 42,
			
			halign = UIALIGN_CENTER,
			maxlength = 3,
			numeric = 1,
			
			tabstop = 7,		
		},

		Launch=
		{
			skin = UI.skins.BottomMenuButton,
			
			left = 780-180,
			
			tabstop = 13,
			
			text = Localize("Launch"),
			
			OnCommand = function(Sender)
				local GUI = UI.PageCreateServer.GUI;
	
				local szLevel = GUI.LevelCombo:GetSelection();
				local szName = GUI.ServerName:GetText();
				local iMaxServerPlayers = tonumber(GUI.MaxServerPlayers:GetText());
							
				if (szLevel == nil) then
					UI.MessageBox("@Error", "@CreateServerSelectMap");
					return
				end

				if (not szName or strlen(szName) < 1) then
					UI.MessageBox("@Error", "@CreateServerTypeName");
					return
				end
			
				if (not iMaxServerPlayers or iMaxServerPlayers > 32) then
					UI.MessageBox("@Error", "@CreateServerMaxPlayers");
					return
				end			
				
				local bOk = 1;
				
				local szText = GUI.MinTeamPlayers:GetText();
				if (UI:IsWidgetVisible(GUI.MinTeamPlayers) and (not szText or (strlen(szText) < 1))) then bOk = 0;	end
							
				szText = GUI.MaxTeamPlayers:GetText();
				if (UI:IsWidgetVisible(GUI.MaxTeamPlayers) and (not szText or (strlen(szText) < 1))) then bOk = 0;	end

				szText = GUI.MaxServerPlayers:GetText();
				if (UI:IsWidgetVisible(GUI.MaxServerPlayers) and (not szText or (strlen(szText) < 1))) then bOk = 0;	end

				szText = GUI.RespawnTime:GetText();
				if (UI:IsWidgetVisible(GUI.RespawnTime) and (not szText or (strlen(szText) < 1))) then bOk = 0;	end

				szText = GUI.TimeLimit:GetText();
				if (UI:IsWidgetVisible(GUI.TimeLimit) and (not szText or (strlen(szText) < 1))) then bOk = 0;	end
				
				if (not bOk or (bOk == 0)) then
					UI.MessageBox("@Error", "@CreateServerFieldEmpty");
					
					return
				end

				local iMinTeamPlayers = tonumber(GUI.MinTeamPlayers:GetText());
				local iMaxTeamPlayers = tonumber(GUI.MaxTeamPlayers:GetText());
				local iMaxServerSlots = tonumber(GUI.MaxServerPlayers:GetText());
				
				if (UI:IsWidgetVisible(GUI.MaxTeamPlayers)) then
					if (iMaxTeamPlayers > iMaxServerSlots) then
						UI.MessageBox("@Error", "@MaxPlayersTooHigh");
					
						return
					end
				end
				
				if (UI:IsWidgetVisible(GUI.MinTeamPlayers)) then
					if (iMinTeamPlayers > iMaxTeamPlayers) then
						UI.MessageBox("@Error", "@MinPlayersTooHigh");
					
						return
					end
					
					if (iMinTeamPlayers > floor(iMaxServerPlayers*0.5)) then
						UI.MessageBox("@Error", "@MinPlayersTooHigh2");
					
						return					
					end
				end
				
				setglobal("g_LastServerName", szName);
				
				UI.PageCreateServer.RefreshVars();			
				UI.PageCreateServer.szGameMessage = "StartLevel "..szLevel.." listen";
				UI.PageCreateServer.szLastMap = szLevel;
				UI.PageCreateServer.LaunchServer();
			end
		},

		OnActivate = function(Sender)

			UI.PageCreateServer.bCreatingNETServer = nil;
			UI.PageCreateServer.szGameMessage = nil;
			
			-- Connection
			
			Sender.Connection:Clear();
			
			for i=1,count(UI.PageCreateServer.ConnectionSettings) do
				Sender.Connection:AddItem(UI.PageCreateServer.ConnectionSettings[i].name);
			end		
	
			local szSelection = UI.PageCreateServer:GetConnection();
			
			if szSelection then
				Sender.Connection:Select(szSelection);
			end
	
			--	
							
			if (UI.PageCreateServer.bDoNotRefreshList) then
				UI.PageCreateServer.bDoNotRefreshList = nil;
			else
				UI.PageCreateServer.GUI.MODCombo:Clear();

				for name, MOD in AvailableMODList do
					UI.PageCreateServer.GUI.MODCombo:AddItem(name);
				end

				UI.PageCreateServer.RefreshLevelList();
			end
			
			--local SaveServerType = getglobal("sv_ServerType");	-- save this because this should be set depending which menu was used
			--UI.PageCreateServer.LoadDefaultProfile();
			--setglobal("sv_ServerType", SaveServerType);					-- restore
			
			UI.PageCreateServer.RefreshWidgets();
		end
	},
			
	LaunchServer = function()
	
		if(UI.PageCreateServer.GUI.PunkBuster:GetChecked()) then
			setglobal("sv_punkbuster", 1);
			setglobal("cl_punkbuster", 1);
		else
			setglobal("sv_punkbuster", 0);
			setglobal("cl_punkbuster", 0);
		end
				
		Game:SendMessage(UI.PageCreateServer.szGameMessage);

		UI.PageCreateServer.szGameMessage = nil;
	end,
	
	
	RefreshLevelList = function()
		UI.PageCreateServer.LevelList = {};
		
		-- create the tables
		for name, MOD in AvailableMODList do
			local szMission = MOD.mission;
			
			UI.PageCreateServer.LevelList[szMission] = {};
		end

		-- request level list from game	
		local LevelList = Game:GetLevelList();
	
		-- go through all the levels
		for LevelIndex, Level in LevelList do
			-- all mission names
			for MissionIndex, MissionName in Level.MissionList do
				-- get the mission names that are supported, and insert them in the appropriate table
				for name, AvailableMOD in AvailableMODList do
					local szMission = AvailableMOD.mission;
			
					if (strlower(MissionName) == strlower(szMission)) then
						tinsert(UI.PageCreateServer.LevelList[szMission], Level.Name);
						-- tinsert adds a "n" key, so we just remove it here
						UI.PageCreateServer.LevelList[szMission].n = nil;
						break;
					end
				end
			end
		end
	end,
	
	PopulateLevelCombo = function()
		local szMOD = UI.PageCreateServer.GUI.MODCombo:GetSelection();
		
		UI.PageCreateServer.GUI.LevelCombo:Clear();
		if (szMOD) then
			local szMission = AvailableMODList[strupper(szMOD)].mission;
			
			for i, szLevelName in UI.PageCreateServer.LevelList[szMission] do
				UI.PageCreateServer.GUI.LevelCombo:AddItem(szLevelName);
			end
		end
		
		UI.PageCreateServer.GUI.LevelCombo:SelectIndex(1);
	end,
	
	IsUBIOrLAN = function()
		if NewUbisoftClient and NewUbisoftClient:Client_IsConnected() and (getglobal("sv_ServerType")=="UBI") then
			return 1;
		end
	end,
	
	RefreshWidgets = function()
		local GUI = UI.PageCreateServer.GUI;
		
		GUI.MinTeamPlayers:SetText(floor(tonumber(getglobal("gr_MinTeamLimit"))));
		GUI.MaxTeamPlayers:SetText(floor(tonumber(getglobal("gr_MaxTeamLimit"))));
		GUI.MaxServerPlayers:SetText(floor(getglobal("sv_maxplayers")));
		GUI.TimeLimit:SetText(floor(getglobal("gr_TimeLimit")));

		if (not getglobal("sv_name") or (strlen(getglobal("sv_name")) < 1)) then
			if (getglobal("cl_ubiname") and (strlen(getglobal("cl_ubiname")) > 0)) then
				setglobal("sv_name", getglobal("cl_ubiname").."'s Server");
			else
				setglobal("sv_name", Game:GetUserName().."'s Server");
			end
		end

		GUI.ServerName:SetText(sv_name);	

		if (sv_password) then
			GUI.ServerPassword:SetText(sv_password);
		end

		if UI.PageCreateServer.IsUBIOrLAN() then
			UI:ShowWidget(UI.PageCreateServer.GUI.CreateUBIServerText);
			UI:HideWidget(UI.PageCreateServer.GUI.CreateLANServerText);
		else
			UI:HideWidget(UI.PageCreateServer.GUI.CreateUBIServerText);
			UI:ShowWidget(UI.PageCreateServer.GUI.CreateLANServerText);
		end

		if (gr_FriendlyFire and (tonumber(gr_FriendlyFire) ~= 0)) then
			GUI.FriendlyFire:SetChecked(1);
		else
			GUI.FriendlyFire:SetChecked(0);
		end

		if (sv_punkbuster and (tonumber(sv_punkbuster) ~= 0)) then
			GUI.PunkBuster:SetChecked(1);
		else
			GUI.PunkBuster:SetChecked(0);
		end

--		if (tonumber(getglobal("gr_RespawnTime")) ~= 0) then
--			GUI.RespawnCycle:SetChecked(1);
			GUI.RespawnTime:SetText(floor(getglobal("gr_RespawnTime")));
--		else
--			GUI.RespawnCycle:SetChecked(0);
--			GUI.RespawnTime:SetText("15");		-- default
--		end

		if (g_GameType and (g_GameType ~= "Default")) then
			GUI.MODCombo:Select(g_GameType);
		else
			GUI.MODCombo:SelectIndex(1);
		end	

		GUI.MODCombo.OnChanged(GUI.MODCombo);
		
		if (UI.PageCreateServer.szLastMap) then
			GUI.LevelCombo:Select(UI.PageCreateServer.szLastMap);
		elseif (getglobal("gr_NextMap")) then
			GUI.LevelCombo:Select(tostring(gr_NextMap));
		end

		if (not UI.PageCreateServer.GUI.LevelCombo:GetSelection()) then
			UI.PageCreateServer.GUI.LevelCombo:SelectIndex(1);
		end				
	end,

	RefreshVars = function()
		local GUI = UI.PageCreateServer.GUI;
		
		local szMOD = GUI.MODCombo:GetSelection();
		local szServerName = GUI.ServerName:GetText();
		local szServerPassword = GUI.ServerPassword:GetText();
		local szNextMap = GUI.LevelCombo:GetSelection()
		local iMinTeamPlayers = GUI.MinTeamPlayers:GetText();
		local iMaxTeamPlayers = GUI.MaxTeamPlayers:GetText();
		local iMaxServerPlayers = GUI.MaxServerPlayers:GetText();
		local iRespawnTime = GUI.RespawnTime:GetText();
		local iTimeLimit = GUI.TimeLimit:GetText();
		local szServerType = "LAN";
		local iFriendlyFire = 0;
		local iPunkBuster = 0;
		
		if (UI.PageMultiplayer.CurrentList == UI.PageNETServerList) then
			szServerType = "UBI";
		end

		UI.PageCreateServer.ApplyConnection();
		
		if GUI.FriendlyFire:GetChecked() then	
			iFriendlyFire = 1; 
		end

		if GUI.PunkBuster:GetChecked() then	
			iPunkBuster = 1; 
		end
		
		if szMOD and AvailableMODList[strupper(szMOD)].team==0 then
			iFriendlyFire = 0; 
		end
						
		UI.PageCreateServer.DOVarI("gr_MinTeamLimit", iMinTeamPlayers);
		UI.PageCreateServer.DOVarI("gr_MaxTeamLimit", iMaxTeamPlayers);
		UI.PageCreateServer.DOVarI("sv_maxplayers", iMaxServerPlayers);
		UI.PageCreateServer.DOVarI("gr_RespawnTime", iRespawnTime);
		UI.PageCreateServer.DOVarI("gr_TimeLimit", iTimeLimit);
		UI.PageCreateServer.DOVarS("gr_NextMap", szNextMap);
		UI.PageCreateServer.DOVarS("sv_ServerType", szServerType);
		UI.PageCreateServer.DOVarB("gr_FriendlyFire", iFriendlyFire);
		UI.PageCreateServer.DOVarB("sv_punkbuster", iPunkBuster);
		UI.PageCreateServer.DOVarS("sv_name", szServerName);
		UI.PageCreateServer.DOVarS("g_LastServerName", szServerName);
		UI.PageCreateServer.DOVarS("sv_password", szServerPassword);
		if (szMOD) then
			UI.PageCreateServer.DOVarS("g_GameType", strupper(szMOD));	
		end
	end,
	
	DOVarS = function (szVarName, szValue)
		if (szValue and (strlen(szValue))) then
			setglobal(szVarName,szValue);
		else
			setglobal(szVarName, "");
		end
	end,
	
	DOVarB = function (szVarName, bValue)
		if (bValue and (bValue ~= 0)) then
			Game:SetVariable(szVarName, 1);
		else
			Game:SetVariable(szVarName, 0);
		end
	end,
	
	DOVarI = function (szVarName, iValue)
		if (iValue) then
			local iVal=tonumber(iValue);
			if not iVal then
				iVal=0;
			end
			Game:SetVariable(szVarName, iVal);
		else
			Game:SetVariable(szVarName, 0);
		end
	end,
	
	SaveServerProfileOk = function(ProfileName)	
		
		if ProfileName then
			UI.PageCreateServer.szSaveFileName = "profiles/server/"..ProfileName.."_server.cfg";		
			UI.PageCreateServer.szProfileName = ProfileName;
			
			-- check if the file exists
			local hFile = openfile (UI.PageCreateServer.szSaveFileName, "r");
			
			if (hFile) then
				closefile(hFile);
				
				UI.YesNoBox(Localize("OverwriteConfirmation"), Localize("SProfileOverwrite"), UI.PageCreateServer.SaveProfile);
			else
				UI.PageCreateServer.SaveProfile();
			end
		end
					
		return 1;
	end,
	
	WriteVarsToScript = function(hFile, VarNameList)
		local iNameMaxLen = 0;
		local iNameLen = 0;

		-- find the maximum length of varname
		-- to output a pretty aligned file
		for i, szVarName in VarNameList do
			iNameLen = strlen(szVarName);
			if (iNameLen > iNameMaxLen) then
				iNameMaxLen = iNameLen;
			end
		end
		
		for i, szVarName in VarNameList do
			local szValue = Game:GetVariable(szVarName);
			
			if (szValue == nil) then
				szValue = "nil";
			else
				szValue = tostring(szValue);
			end
			write(hFile, szVarName..strrep(" ", iNameMaxLen + 1 - strlen(szVarName)).."= "..format('%q', szValue).."\n");
		end
	end,	
	
	SaveProfile = function()
	
		UI.PageCreateServer.RefreshVars();
		
		if (UI.PageCreateServer.szSaveFileName) then
			hFile = openfile(UI.PageCreateServer.szSaveFileName, "w");
			
			if (hFile) then
			
				local VarsToSave =
				{
					"g_GameType",
				  "gr_FriendlyFire",
				  "gr_MinTeamLimit",
				  "gr_MaxTeamLimit",
				  "sv_maxplayers",
				  "gr_NextMap",
				  "sv_ServerType",
				  "sv_password",
				  "sv_name",
				  "gr_RespawnTime",
				  "gr_TimeLimit",
				  "sv_punkbuster",
				};
				
				if UI.PageCreateServer.IsUBIOrLAN() then
					VarsToSave[count(VarsToSave)+1]="sv_maxrate";				-- bitspersecond per player for internet
				else
					VarsToSave[count(VarsToSave)+1]="sv_maxrate_lan";		-- bitspersecond per player for lan
				end
			
				UI.PageCreateServer.WriteVarsToScript(hFile,VarsToSave);
				
				closefile(hFile);
			end
			
			Game:SetVariable("g_serverprofile", UI.PageCreateServer.szProfileName);

			UI.PageCreateServer.szSaveFileName = nil;
			UI.PageCreateServer.szProfileName = nil;
		end
	end,
	
	LoadDefaultProfile = function()
		if (g_serverprofile and (strlen(g_serverprofile) > 0)) then
			System:Log("serverprofile: "..tostring(g_serverprofile));
			UI.PageCreateServer.szLoadFileName = "profiles/server/"..g_serverprofile.."_server.cfg";
			UI.PageCreateServer.LoadProfile();
		end
	end,
	
	LoadProfile = function()
		System:Log("loading "..tostring(UI.PageCreateServer.szLoadFileName));
		if (UI.PageCreateServer.szLoadFileName) then
		
			local hfile = openfile(UI.PageCreateServer.szLoadFileName, "r");

			if (hfile) then
				closefile(hfile);
			
				Script:LoadScript(UI.PageCreateServer.szLoadFileName, 1);
			
				if (UI.PageCreateServer.szProfileName) then			
					Game:SetVariable("g_serverprofile", UI.PageCreateServer.szProfileName);
				end
			end			
			
			UI.PageCreateServer.RefreshWidgets();
			UI.PageCreateServer.bDoNotRefreshList = 1;
			UI.PageCreateServer.szProfileName = nil;
			
			if (sv_punkbuster and tonumber(sv_punkbuster) ~= 0) then	
				setglobal("cl_punkbuster", 1);
			else
				setglobal("cl_punkbuster", 0);
			end
		end
	end,
	
	ConnectionSettings=
	{
		{ name="10Kb/s",bits=10000, },
		{ name="11Kb/s",bits=11000, },
		{ name="12Kb/s",bits=12000, },
		{ name="13Kb/s",bits=13000, },
		{ name="14Kb/s",bits=14000, },
		{ name="15Kb/s",bits=15000, },
		{ name="16Kb/s",bits=16000, },
		{ name="17Kb/s",bits=17000, },
		{ name="18Kb/s",bits=18000, },
		{ name="19Kb/s",bits=19000, },
		{ name="20Kb/s",bits=20000, },
		{ name="21Kb/s",bits=21000, },
		{ name="22Kb/s",bits=22000, },
		{ name="23Kb/s",bits=23000, },
		{ name="24Kb/s",bits=24000, },
		{ name="25Kb/s",bits=25000, },
		{ name="26Kb/s",bits=26000, },
		{ name="27Kb/s",bits=27000, },
		{ name="28Kb/s",bits=28000, },
		{ name="29Kb/s",bits=29000, },
		{ name="30Kb/s",bits=30000, },
		{ name="31Kb/s",bits=31000, },
		{ name="32Kb/s",bits=32000, },
		{ name="33Kb/s",bits=33000, },
		{ name="34Kb/s",bits=34000, },
		{ name="35Kb/s",bits=35000, },
		{ name="36Kb/s",bits=36000, },
		{ name="37Kb/s",bits=37000, },
		{ name="38Kb/s",bits=38000, },
		{ name="39Kb/s",bits=39000, },
		{ name="40Kb/s",bits=40000, },
		{ name="41Kb/s",bits=41000, },
		{ name="42Kb/s",bits=42000, },
		{ name="43Kb/s",bits=43000, },
		{ name="44Kb/s",bits=44000, },
		{ name="45Kb/s",bits=45000, },
		{ name="46Kb/s",bits=46000, },
		{ name="47Kb/s",bits=47000, },
		{ name="48Kb/s",bits=48000, },
		{ name="49Kb/s",bits=49000, },
		{ name="50Kb/s",bits=50000, },
		{ name="60Kb/s",bits=60000, },
		{ name="70Kb/s",bits=70000, },
		{ name="80Kb/s",bits=80000, },
		{ name="90Kb/s",bits=90000, },
		{ name="100Kb/s",bits=100000, },
	},
	
	-- this is where you apply your connection settings
	-- this is called right after the user changes the combobox
	ApplyConnection = function()

		local szConnection = UI.PageCreateServer.GUI.Connection:GetSelection();
		
		if szConnection then  -- not user settings

			System:Log("Applying Network Connection Settings for: "..tostring(szConnection));
			
			for i=1,count(UI.PageCreateServer.ConnectionSettings) do
				if UI.PageCreateServer.ConnectionSettings[i].name==szConnection then

					if UI.PageCreateServer.IsUBIOrLAN() then
						setglobal("sv_maxrate",UI.PageCreateServer.ConnectionSettings[i].bits); 		-- bitspersecond per player for internet
					else
						setglobal("sv_maxrate_lan",UI.PageCreateServer.ConnectionSettings[i].bits);	-- bitspersecond per player for lan
					end
					
					return;
				end
			end
		end
	end,

	-- this func must be implemented,
	-- and it should return the connection string that best represents the current setting
	-- or nil, for custom settings
	GetConnection = function()
	
		local bits;
	
		if UI.PageCreateServer.IsUBIOrLAN() then
			bits=tonumber(getglobal("sv_maxrate")); 		-- bitspersecond per player for internet
		else
			bits=tonumber(getglobal("sv_maxrate_lan"));	-- bitspersecond per player for lan
		end
		
		for i=1,count(UI.PageCreateServer.ConnectionSettings) do
			if UI.PageCreateServer.ConnectionSettings[i].bits==bits then
				return UI.PageCreateServer.ConnectionSettings[i].name;
			end
		end		
		
		return nil;			-- user settings
	end,
}

UI.PageServerLoadProfile=
{
	GUI=
	{
		ProfileList= 
		{
			skin = UI.skins.ListView,
			left = 200, top = 141,
			width = 580, height = 318,
			
			vscrollbar =
			{
				skin = UI.skins.VScrollBar,
			},
			
			hscrollbar =
			{
				skin = UI.skins.VScrollBar,
			},
			
			OnChanged = function(self)
				if (self:GetSelection(0)) then
					UI:EnableWidget(UI.PageServerLoadProfile.GUI.RemoveProfile);
					UI:EnableWidget(UI.PageServerLoadProfile.GUI.LoadProfile);
				else
					UI:DisableWidget(UI.PageServerLoadProfile.GUI.RemoveProfile);
					UI:DisableWidget(UI.PageServerLoadProfile.GUI.LoadProfile);				
				end
			end
		},
		
		LoadProfile=
		{
			skin = UI.skins.BottomMenuButton,	
			left = 780-180,
			
			text = Localize("LoadServerProfile"),
			
			OnCommand = function(Sender)
				local sel=UI.PageServerLoadProfile.GUI.ProfileList:GetSelection(0);
				if sel then
					local ProfileName = UI.PageServerLoadProfile.GUI.ProfileList:GetItem(sel);
					if (ProfileName) then
						UI.PageCreateServer.szLoadFileName = "profiles/server/"..ProfileName.."_server.cfg";
						UI.PageCreateServer.szProfileName = ProfileName;
						UI.PageCreateServer.LoadProfile();
	
						GotoPage("CreateServer");
					end
				end
			end
		},

		RemoveProfile=
		{
			skin = UI.skins.BottomMenuButton,	
			left = 780-180-178,
			
			text = Localize("RemoveServerProfile"),
			
			OnCommand = function(Sender)
				local sel=UI.PageServerLoadProfile.GUI.ProfileList:GetSelection(0);
				if sel then
					local ProfileName = UI.PageServerLoadProfile.GUI.ProfileList:GetItem(sel);
					if (ProfileName) then
						UI.YesNoBox(Localize("RemoveProfile"), Localize("RemoveProfileConfirmation"), UI.PageServerLoadProfile.OnRemoveYes);
					end
				end
			end
		},
		
		OnActivate = function(Sender)
			UI.PageServerLoadProfile.RefreshProfileList();
			UI.PageServerLoadProfile.GUI.ProfileList.OnCommand = UI.PageServerLoadProfile.GUI.LoadProfile.OnCommand;
		end,	
	},
	
	OnRemoveYes = function()
		local sel=UI.PageServerLoadProfile.GUI.ProfileList:GetSelection(0);

		if sel then
			local ProfileName = UI.PageServerLoadProfile.GUI.ProfileList:GetItem(sel);
			local szFileName = "profiles/server/"..ProfileName.."_server.cfg";
					
			remove(szFileName);
			
			setglobal("g_serverprofile", "");
			
			UI.PageServerLoadProfile.RefreshProfileList();
		end
	end,
	
	RefreshProfileList = function()
		local ProfileTable = System:ScanDirectory("Profiles/server", SCANDIR_FILES);
		
		UI.PageServerLoadProfile.GUI.ProfileList:Clear();
		
		local iSelection = 0;

		for i, ProfileName in ProfileTable do
			local szPattern = "_server.cfg";
			local iPatternLen = strlen(szPattern);
			if (strsub(ProfileName, -iPatternLen) == szPattern) then
				local szProfileName = strsub(ProfileName, 1, strlen(ProfileName)-iPatternLen);
				
				local iID = UI.PageServerLoadProfile.GUI.ProfileList:AddItem(szProfileName);
				
				if (strlower(szProfileName) == strlower(getglobal("g_serverprofile"))) then
					iSelection = iID;
				end
			end
		end
		
		if (iSelection and iSelection > 0) then
			UI.PageServerLoadProfile.GUI.ProfileList:SelectIndex(iSelection);
		end
		
		UI.PageServerLoadProfile.GUI.ProfileList:OnChanged();
	end,	
}

AddUISideMenu(UI.PageServerLoadProfile.GUI,
{
	{ "MainMenu", Localize("MainMenu"), "$MainScreen$", 0},
	{ "Options", Localize("Options"), "Options", },
	{ "Back", Localize("Back"), "CreateServer", },
});

AddUISideMenu(UI.PageCreateServer.GUI,
{
	{ "MainMenu", Localize("MainMenu"), "$MainScreen$", 0},
	{ "Options", Localize("Options"), "Options", },
	{ "Back", Localize("Back"), "Multiplayer", },
});

UI:CreateScreenFromTable("ServerLoadProfile", UI.PageServerLoadProfile.GUI);
UI:CreateScreenFromTable("CreateServer", UI.PageCreateServer.GUI);
