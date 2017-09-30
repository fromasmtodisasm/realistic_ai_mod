UI.PageMultiplayer =
{
    FavServers = {},
    FilterFavorites = 0,
	GUI=
	{
		LAN=
		{
			skin = UI.skins.TopMenuButton,

			tabstop = 1,

			text = Localize("LAN"),
			width = 150,

			greyedcolor = UI.szTabAdditiveColor,
			greyedblend = UIBLEND_ADDITIVE,

			OnCommand = function(Sender)

				UI:DeactivateScreen("NETServerList");
				UI:ActivateScreen("LANServerList");

				UI:DisableWidget(Sender);
				UI:EnableWidget("NET", "Multiplayer");

				UI.PageMultiplayer.CurrentList = UI.PageLANServerList;
				
				UI.PageMultiplayer.GUI.Join.OnCommand = UI.PageMultiplayer.CurrentList.GUI.ServerList.OnCommand;

				UI:HideWidget(UI.PageMultiplayer.GUI.Logout);
				UI:HideWidget(UI.PageMultiplayer.GUI.JoinIP);
				UI:EnableWidget(UI.PageMultiplayer.GUI.Refresh);

				UI.PageMultiplayer.GUI.LAN.skin.OnLostFocus(UI.PageMultiplayer.GUI.LAN);
				UI.PageMultiplayer.GUI.NET.skin.OnLostFocus(UI.PageMultiplayer.GUI.NET);
				
				UI.PageMultiplayer.szLastMultiplayerMenu = "LAN";
			end,
		},

		NET=
		{
			skin = UI.skins.TopMenuButton,

			tabstop = 2,

			left = 200 + 150,
			width = 150,

			text = Localize("Internet"),

			greyedcolor = UI.szTabAdditiveColor,
			greyedblend = UIBLEND_ADDITIVE,

			OnCommand = function(Sender)

				UI:DeactivateScreen("LANServerList");
				UI:ActivateScreen("NETServerList");

				UI:DisableWidget(Sender);
				UI:EnableWidget("LAN", "Multiplayer");

				UI:ShowWidget(UI.PageMultiplayer.GUI.Logout);
				UI:ShowWidget(UI.PageMultiplayer.GUI.JoinIP);

				UI.PageMultiplayer.CurrentList = UI.PageNETServerList;

				UI.PageMultiplayer.GUI.Join.OnCommand = UI.PageMultiplayer.CurrentList.GUI.ServerList.OnCommand;

				if (not NewUbisoftClient:Client_IsConnected()) then
					NewUbisoftClient:Login();
				end

				UI.PageMultiplayer.GUI.LAN.skin.OnLostFocus(UI.PageMultiplayer.GUI.LAN);
				UI.PageMultiplayer.GUI.NET.skin.OnLostFocus(UI.PageMultiplayer.GUI.NET);
				
				UI.PageMultiplayer.szLastMultiplayerMenu = "NET";
			end,
		},
        FavoritesText=
    {
          skin = UI.skins.TopMenuButton,
          
          left = 525+40,
          top = 110, width = 64,
                  
			greyedcolor = UI.szTabAdditiveColor,
			greyedblend = UIBLEND_ADDITIVE,

          text = "Favorites",

		OnCommand = function(Sender)
				UI:DisableWidget(UI.PageMultiplayer.GUI.FavoritesText);
				UI:EnableWidget(UI.PageMultiplayer.GUI.NotFavoritesText);
				UI.PageMultiplayer.GUI.FavoritesText.skin.OnLostFocus(UI.PageMultiplayer.GUI.FavoritesText);
				UI.PageMultiplayer.GUI.NotFavoritesText.skin.OnLostFocus(UI.PageMultiplayer.GUI.NotFavoritesText);

				UI.PageMultiplayer.FilterFavorites = 1;
				--UI.PageMultiplayer.GUI.FilterFavorites:SetChecked(1);
                		Game:ClearServerInfo();
                		UI.PageNETServerList.GUI.ServerList:Clear();
               		UI.PageMultiplayer.CurrentList.RefreshList();

		end
      },

        NotFavoritesText=
    {
          skin = UI.skins.TopMenuButton,
          
          left = 525+0,
          top = 110, width = 40,
                  
			greyedcolor = UI.szTabAdditiveColor,
			greyedblend = UIBLEND_ADDITIVE,

          text = "All",

		OnCommand = function(Sender)
				UI:DisableWidget(UI.PageMultiplayer.GUI.NotFavoritesText);
				UI:EnableWidget(UI.PageMultiplayer.GUI.FavoritesText);
				--UI.PageMultiplayer.GUI.FavoritesText.skin.OnLostFocus(UI.PageMultiplayer.GUI.FavoritesText);
				--UI.PageMultiplayer.GUI.NotFavoritesText.skin.OnLostFocus(UI.PageMultiplayer.GUI.NotFavoritesText);

				UI.PageMultiplayer.FilterFavorites = 0;
				--UI.PageMultiplayer.GUI.FilterFavorites:SetChecked(0);
                		Game:ClearServerInfo();
                		UI.PageNETServerList.GUI.ServerList:Clear();
               		UI.PageMultiplayer.CurrentList.RefreshList();
		end
      },
        
        AddToFavorites=
        {
            skin = UI.skins.TopMenuButton,

            tabstop = 2,

            left = 525+20+60+24,
            top = 110, width = 40,
            
            text = "Add",

            greyedcolor = UI.szTabAdditiveColor,
            greyedblend = UIBLEND_ADDITIVE,

            OnCommand = function(Sender)
                	UI.PageMultiplayer.SaveServerToFavorites();
            end,
        },        
        
        DeleteFromFavorites=
        {
            skin = UI.skins.TopMenuButton,

            tabstop = 2,

            left = 525+20+60+24+40,
            top = 110, width = 40,
            
            text = "Del",

            greyedcolor = UI.szTabAdditiveColor,
            greyedblend = UIBLEND_ADDITIVE,

            OnCommand = function(Sender)
                UI.PageMultiplayer.DeleteServerFromFavorites();
            end,
        },
  

        Create=
        {
			skin = UI.skins.BottomMenuButton,
			left = 780-112-111-111-111,
			width = 112,

			tabstop = 6,

			text = Localize("Create"),

			OnCommand = function(Sender)

				if (UI.PageMultiplayer.CurrentList == UI.PageNETServerList) then
					setglobal("sv_ServerType","UBI");
				elseif (UI.PageMultiplayer.CurrentList == UI.PageLANServerList) then
					setglobal("sv_ServerType","LAN");
				end

				if (UI:WillTerminate()) then
					UI.YesNoBox(Localize("TerminateCurrentGame"), Localize("TerminateCurrentGameLabel"), UI.PageMultiplayer.CreateServer);
				else
					UI.PageMultiplayer.CreateServer();
				end
			end
		},

		Logout =
		{
			skin = UI.skins.BottomMenuButton,
			left = 200,
			width = 135,
			bordersides = "",
			fontsize = 15,

			tabstop = 5,

			text = "@UBILogout",

			OnCommand = function(Sender)
				if (UI:WillTerminate()) then
					UI.YesNoBox(Localize("TerminateCurrentGame"), Localize("TerminateCurrentGameLabel"), UI.PageMultiplayer.LogoutUBI);
				else
					UI.PageMultiplayer.LogoutUBI();
				end
			end
		},


		

		PunkBusterText=
		{
			skin = UI.skins.Label,
			left =614, top = 425,
			width = 122,
			
			text = Localize("EnablePBClient");
		},
		
		PunkBuster=
		{
			skin = UI.skins.CheckBox,
			left = 744, top = 425,
			
			tabstop = 4,
			
			OnChanged = function(self)
				if(self:GetChecked()) then
					setglobal("cl_punkbuster", 1);
					setglobal("sv_punkbuster", 1);
				else
					setglobal("cl_punkbuster", 0);
					setglobal("sv_punkbuster", 0);
				end
			end,
		},
		Refresh=
		{
			skin = UI.skins.BottomMenuButton,
			left = 780-112-111-111,
			width = 112,

			tabstop = 7,

			text = Localize("Refresh"),

			OnCommand = function(Sender)
				UI.PageMultiplayer.CurrentList.RefreshList();
			end
		},


		Join =
		{
			skin = UI.skins.BottomMenuButton,
			left = 780-112-111,
			width = 112,

			tabstop = 8,

			text = Localize("Join"),
		},

		JoinIP =
		{
			skin = UI.skins.BottomMenuButton,
			left = 780-112,
			width = 112,

			tabstop = 9,

			text = Localize("Join").." "..Localize("IP"),
			
			OnCommand = function(Sender)
				UI.PageMultiplayer.JoinServerIP();
			end
		},

		FilterBlock=
		{
			left = 35,
			top = 190,
			height = 299.5,
			width = 165,
			color = UI.szMessageBoxScreenColor,
			skin = UI.skins.MenuBorder,

			Header=
			{
				skin = UI.skins.Label,
				bordersize = 0,
			
				left = 5,
				top = 0,
				width = 155,
			
				halign = UIALIGN_CENTER,
				fontsize = 18,
				text = "Server List Filter";
			},

			GameTypeComboText=
			{
				skin = UI.skins.Label,
				bordersize = 0,
				left = 5, 
				top = 25,
				width = 50,
				height = 24,
				fontsize = 11,			
				text = Localize("GameType");
			},

			GameTypeCombo=
			{
				skin = UI.skins.ComboBox,

				left = 60,
				top = 25,
				width = 100,
				height = 24,
				fontsize = 11,			
			
				tabstop = 3,
			
				vscrollbar=
				{
					skin = UI.skins.VScrollBar,
				},

			},

			PunkbusterComboText=
			{
				skin = UI.skins.Label,
				bordersize = 0,
			
				left = 5, 
				top = 25+24+5,
				width = 50,
				height = 24,
				fontsize = 11,			
				text ="Punkbuster";
			},

			PunkbusterCombo=
			{
				skin = UI.skins.ComboBox,
	
				left = 60,
				top = 25+24+5,
				width = 100,
				height = 24,
				fontsize = 11,			
			
				tabstop = 3,
			
				vscrollbar=
				{
					skin = UI.skins.VScrollBar,
				},

			},

			PingComboText=
			{
				skin = UI.skins.Label,
				bordersize = 0,
				
				left = 5, 
				top = 25+2*(24+5),
				width = 50,
				height = 24,
				fontsize = 11,			
				text = Localize("Ping");
			},

			PingCombo=
			{
				skin = UI.skins.ComboBox,

				left = 60,
				top = 25+2*(24+5),
				width = 100,
				height = 24,
				fontsize = 11,			
			
				tabstop = 3,
			
				vscrollbar=
				{
					skin = UI.skins.VScrollBar,
				},

			},


			Password =
			{
				skin = UI.skins.CheckBox,
				left = 60,
				top = 25+3*(24+5),
				width = 24,
				height = 24,
			},

			PasswordText=
			{
				skin = UI.skins.Label,
				bordersize = 0,
				
				left = 5, 
				top = 25+3*(24+5),
				width = 50,
				height = 24,
				fontsize = 11,			
		
				text = Localize("Password");
			},

			Populated =
			{
				skin = UI.skins.CheckBox,
				left = 60,
				top = 25+4*(24+5),
				width = 24,
				height = 24,
			},

			PolulatedText=
			{
				skin = UI.skins.Label,
				bordersize = 0,
				
				left = 5, 
				top = 25+4*(24+5),
				width = 50,
				height = 24,
				fontsize = 11,			
			
				text = "Not Empty";
			},

			NotFull =
			{
				skin = UI.skins.CheckBox,
				left = 60,
				top = 25+5*(24+5),
				width = 24,
				height = 24,
			},

			NotFullText=
			{
				skin = UI.skins.Label,
				bordersize = 0,
				
				left = 5, 
				top = 25+5*(24+5),
				width = 50,
				height = 24,
				fontsize = 11,			
				
				text = "Not Full";
			},

			ServerNameText=
			{
				skin = UI.skins.Label,
				bordersize = 0,
				
				left = 5, 
				top = 25+6*(24+5),
				width = 50,
				height = 24,
				fontsize = 11,			
			
				text = Localize("ServerName");
			},
		
			ServerName=
			{
				skin = UI.skins.EditBox,
			
				left = 60,
				top = 25+6*(24+5),
				width = 100,
				tabstop = 1,
				fontsize = 11,
				maxlength = 26,
			},

			Instuction=
			{
				skin = UI.skins.Label,
				bordersize = 0,			
				left = 5,
				top = 25+7*(24+5)+10,
				width = 155,
			
				halign = UIALIGN_CENTER,
				fontsize = 11,
				text = "Hit refresh to apply filters";
			},
		},
		
		OnActivate = function(Sender)
			local text = "Version "..Game:GetVersion();
			System:LogAlways(text);
			
			if ((UI.PageMultiplayer.szLastMultiplayerMenu == "NET") and (NewUbisoftClient and NewUbisoftClient:Client_IsConnected())) then
				Sender.NET.OnCommand(Sender.NET);
			else
				Sender.LAN.OnCommand(Sender.LAN);
			end
			
			if (cl_punkbuster and tonumber(cl_punkbuster) ~= 0) then
				Sender.PunkBuster:SetChecked(1);
			else
				Sender.PunkBuster:SetChecked(0);
			end

			UI:DisableWidget(UI.PageMultiplayer.GUI.Join);
			UI:DisableWidget(UI.PageMultiplayer.GUI.DeleteFromFavorites);
			UI:DisableWidget(UI.PageMultiplayer.GUI.AddToFavorites);

			if (UI.PageMultiplayer.CurrentList) then
				local ServerList = UI.PageMultiplayer.CurrentList.GUI.ServerList;

				if (ServerList:GetSelectionCount() > 0) then
					UI:EnableWidget(UI.PageMultiplayer.GUI.Join);
					UI:EnableWidget(UI.PageMultiplayer.GUI.DeleteFromFavorites);
					UI:EnableWidget(UI.PageMultiplayer.GUI.AddToFavorites);
				else
					UI:DisableWidget(UI.PageMultiplayer.GUI.Join);
					UI:DisableWidget(UI.PageMultiplayer.GUI.DeleteFromFavorites);
					UI:DisableWidget(UI.PageMultiplayer.GUI.AddToFavorites);
				end
			end

			if( NewUbisoftClient ) then
				NewUbisoftClient.szCurrentUbiName = szName;
				NewUbisoftClient.szCurrentUbiPass = szPassword;
			end;

			UI.PageNETServerList.iCurrentLobby = 0;

			UI.PageMultiplayer.GUI.FilterBlock.GameTypeCombo:Clear();
			UI.PageMultiplayer.GUI.FilterBlock.GameTypeCombo:AddItem("All");
			for name, MOD in AvailableMODList do
				UI.PageMultiplayer.GUI.FilterBlock.GameTypeCombo:AddItem(name);
			end
			UI.PageMultiplayer.GUI.FilterBlock.GameTypeCombo:SelectIndex(1);

			UI.PageMultiplayer.GUI.FilterBlock.PunkbusterCombo:AddItem("All");
			UI.PageMultiplayer.GUI.FilterBlock.PunkbusterCombo:AddItem("PB Enabled");
			UI.PageMultiplayer.GUI.FilterBlock.PunkbusterCombo:AddItem("PB Disabled");
			UI.PageMultiplayer.GUI.FilterBlock.PunkbusterCombo:SelectIndex(1);

			UI.PageMultiplayer.GUI.FilterBlock.PingCombo:AddItem("All");
			UI.PageMultiplayer.GUI.FilterBlock.PingCombo:AddItem("< 50");
			UI.PageMultiplayer.GUI.FilterBlock.PingCombo:AddItem("< 80");
			UI.PageMultiplayer.GUI.FilterBlock.PingCombo:AddItem("< 120");
			UI.PageMultiplayer.GUI.FilterBlock.PingCombo:SelectIndex(1);
			
			if (UI.PageMultiplayer.FilterFavorites == 0) then
				UI:DisableWidget(UI.PageMultiplayer.GUI.NotFavoritesText);
				UI:EnableWidget(UI.PageMultiplayer.GUI.FavoritesText);
			else
				UI:EnableWidget(UI.PageMultiplayer.GUI.NotFavoritesText);
				UI:DisableWidget(UI.PageMultiplayer.GUI.FavoritesText);
			end

			UI.PageMultiplayer.LoadFavorites();
		end,
	},
	CreateServer = function()
		Game:Disconnect();
		GotoPage("CreateServer");
	end,


    LoadFavorites = function ()
        if (count(UI.PageMultiplayer.FavServers) > 0) then
            for ServerIndex=1, count(UI.PageMultiplayer.FavServers) do
                UI.PageMultiplayer.FavServers[ServerIndex] = nil;
            end
        end
        
        UI.PageMultiplayer.szLoadFileName = "profiles/server/fav_server.cfg";
        
        local hfile = openfile(UI.PageMultiplayer.szLoadFileName, "r");

        if (hfile) then
            closefile(hfile);

            Script:LoadScript(UI.PageMultiplayer.szLoadFileName, 1);
        end
    end,
    
    DeleteServerFromFavorites = function() 

		UI.PageMultiplayer.LoadFavorites();

        UI.PageMultiplayer.szSaveFileName = "profiles/server/fav_server.cfg";        

        local hFile = openfile (UI.PageMultiplayer.szSaveFileName, "r");
        local TempSelection = tonumber(getglobal("g_FavServerIP"));

        local NumOfFavs = count(UI.PageMultiplayer.FavServers);
        NumOfFavs = NumOfFavs + 1;

        local MyIPIwant = UI.PageNETServerList.Servers[TempSelection].IP;
        setglobal("g_FavServerIP", MyIPIwant);

        if (hFile) then
            closefile(hFile);

            hFile = openfile(UI.PageMultiplayer.szSaveFileName, "w");
            
            local MyIndex = 1;
            
            if (count(UI.PageMultiplayer.FavServers) > 0) then
                for ServerIndex=1, count(UI.PageMultiplayer.FavServers) do
                    local TestIP = UI.PageMultiplayer.FavServers[ServerIndex];
                    
                    if (TestIP ~= MyIPIwant) then
                        write(hFile, "UI.PageMultiplayer.FavServers["..MyIndex.."] = "..format('%q', TestIP).."\n");
                        MyIndex = MyIndex + 1;
                    end
                end
            end
            closefile(hFile);
        end

        UI.PageMultiplayer.CurrentList.RefreshList();
    end,    

    SaveServerToFavorites = function() 
        UI.PageMultiplayer.LoadFavorites();

        UI.PageMultiplayer.szSaveFileName = "profiles/server/fav_server.cfg";        

        
        local TempSelection = tonumber(getglobal("g_FavServerIP"));
        local bDuplicate = 0;
        local NumOfFavs = count(UI.PageMultiplayer.FavServers);
        
        NumOfFavs = NumOfFavs + 1;

        local MyIPIwant = UI.PageNETServerList.Servers[TempSelection].IP;
        setglobal("g_FavServerIP", MyIPIwant);


        hFile = openfile(UI.PageMultiplayer.szSaveFileName, "w");

        if (count(UI.PageMultiplayer.FavServers) > 0) then
            for ServerIndex=1, count(UI.PageMultiplayer.FavServers) do
                local TestIP = UI.PageMultiplayer.FavServers[ServerIndex];
                if (TestIP == MyIPIwant) then
                    bDuplicate = 1;
                end
                write(hFile, "UI.PageMultiplayer.FavServers["..ServerIndex.."] = "..format('%q', TestIP).."\n");
            end
            if (bDuplicate == 0) then
                write(hFile, "UI.PageMultiplayer.FavServers["..NumOfFavs.."] = "..format('%q', MyIPIwant).."\n");
            end
        else
            write(hFile, "UI.PageMultiplayer.FavServers[1] = "..format('%q', MyIPIwant).."\n");
        end
        closefile(hFile);

        UI.PageMultiplayer.LoadFavorites();        
    end, 

	JoinServerIP = function(Sender)
		UI.JoinIPBox(Localize("Join").." "..Localize("IP"), "Please enter the server IP and Port to join", UI.PageMultiplayer.ConnectIP);
	end,

	ConnectIP = function(IP1, IP2, IP3, IP4, Port)
		UI:DeactivateScreen("JoinIPDialog");
		if (IP1 and IP2 and IP3 and IP4 and Port) then
			local szConnectIP = IP1.."."..IP2.."."..IP3.."."..IP4..":"..Port;
	System:Log("Connect IP = "..szConnectIP);
			if (szConnectIP) then
				local iColon = strfind(szConnectIP, ':');
				setglobal("g_LastIP", szConnectIP);
				setglobal("g_LastPort", strsub(szConnectIP, iColon+1));
	--            setglobal("g_LastServerName", UI.PageNETServerList.szServerName);
				
				setglobal("cl_rcon_port", g_LastPort);
	--			NewUbisoftClient:Client_JoinGameServer(UI.PageNETServerList.iJoinLobbyID, UI.PageNETServerList.iJoinRoomID);
				Game:Connect(szConnectIP,1,1);					-- (IP=..,bLateSwitch=1,bCDKeyAuthorization=1)
			end
			
--			UI:EnableWidget(UI.PageMultiplayer.GUI.Refresh);
			szConnectIP = nil;
		end
	end,

	LogoutUBI = function()
		UI.MessageBox(Localize("UBIcomInfo"),Localize("DisconnectingFromService"),nil);
		NewUbisoftClient.szCurrentUbiName = szName;
		NewUbisoftClient.szCurrentUbiPass = szPassword;
		Game:Disconnect();
		NewUbisoftClient:Client_Disconnect();
		UI.PageMultiplayer.GUI.LAN.OnCommand(UI.PageMultiplayer.GUI.LAN);
	end,

	OnLoginOk = function (szName, szPassword, bSavePassword)
		if (szName and szPassword) then
			if (strlen(szName) > 0 and strlen(szPassword) > 0) then

				local bLoginResult = NewUbisoftClient:Client_Login(szName, szPassword, bSavePassword);

				if (not bLoginResult) then
					return 1;
				end

				NewUbisoftClient.szCurrentError = nil;
				NewUbisoftClient.szCurrentUbiName = szName;
				NewUbisoftClient.szCurrentUbiPass = szPassword;

				if (bSavePassword and tonumber(bSavePassword) ~= 0) then
					setglobal("cl_saveubipassword", 1);
				else
					setglobal("cl_saveubipassword", 0);
				end

				UI.ProgressBox(Localize("PleaseWait"), Localize("LoggingIn"), UI.PageMultiplayer.CancelLogin);

				return 1;
			end
		end
			
		local szError = "@UbiTypeUsername";

		if (szName and (strlen(szName) > 0)) then
			szError = "@UbiTypePassword";
		end
		
		if (szPassword and (strlen(szPassword) > 0)) then
			szError = "@UbiTypeUsername";
		end

		NewUbisoftClient.szCurrentUbiName = szName;
		NewUbisoftClient.szCurrentUbiPass = szPassword;

		UI.MessageBox("@UBIcomInfo", szError, UI.PageMultiplayer.RetypeRelogin);

		return 1;
	end,
	
	RetypeRelogin = function()
		NewUbisoftClient:Login();
	end,

	OnLoginCancel = function(Name, Password)
		NewUbisoftClient:Client_Disconnect();

		if (UI:IsScreenActive("Multiplayer") == 1) then
			UI.PageMultiplayer.GUI.LAN.OnCommand(UI.PageMultiplayer.GUI.LAN);
		end

		UI.bNeedUbiReconnect = nil;
		
		return 1;
	end,

	CancelLogin = function()
		NewUbisoftClient:Client_Disconnect();

		if (UI:IsScreenActive("Multiplayer") == 1) then
			UI.PageMultiplayer.GUI.LAN.OnCommand(UI.PageMultiplayer.GUI.LAN);
		end
		
		UI.bNeedUbiReconnect = nil;
	end,

	CancelCDKey = function()
		UI.bVerifyingProgress = nil;
		NewUbisoftClient:Client_Disconnect();

		if (UI:IsScreenActive("Multiplayer") == 1) then
			UI.PageMultiplayer.GUI.LAN.OnCommand(UI.PageMultiplayer.GUI.LAN);
		else
			GotoPage("Multiplayer", 0);
			UI.PageMultiplayer.GUI.LAN.OnCommand(UI.PageMultiplayer.GUI.LAN);
		end
		UI.bNeedUbiReconnect = nil;

		return 1;
	end,

	OnCDKeyOk = function(szCDKey)
		if (szCDKey and (strlen(szCDKey) > 0)) then
			NewUbisoftClient:Client_SetCDKey(szCDKey);
			UI.bVerifyingProgress = 1;

			UI.ProgressBox(Localize("PleaseWait"), Localize("VerifyingCDKey"), UI.PageMultiplayer.CancelCDKey);
			return 1;
		end
	end,

	CurrentList = nil,

	bLoggingIn = nil,
}

AddUISideMenu(UI.PageMultiplayer.GUI,
{
	{ "MainMenu", Localize("MainMenu"), "$MainScreen$", 0},
	{ "Options", Localize("Options"), "Options", },
});

UI:CreateScreenFromTable("Multiplayer",UI.PageMultiplayer.GUI);