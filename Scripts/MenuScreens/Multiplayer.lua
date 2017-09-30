UI.PageMultiplayer =
{
	GUI=
	{
		LAN=
		{
			skin = UI.skins.TopMenuButton,

			tabstop = 1,

			text = Localize("LAN"),

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

			left = 200 + 179,

			text = Localize("Internet"),

			greyedcolor = UI.szTabAdditiveColor,
			greyedblend = UIBLEND_ADDITIVE,

			OnCommand = function(Sender)

				UI:DeactivateScreen("LANServerList");
				UI:ActivateScreen("NETServerList");

				UI:DisableWidget(Sender);
				UI:EnableWidget("LAN", "Multiplayer");

				UI:ShowWidget(UI.PageMultiplayer.GUI.Logout);

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

		Logout =
		{
			skin = UI.skins.BottomMenuButton,
			left = 200,
			width = 163,
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


		Create = {
			skin = UI.skins.BottomMenuButton,
			left = 780-140-139-139,
			width = 140,

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


		Refresh=
		{
			skin = UI.skins.BottomMenuButton,
			left = 780-140-139,
			width = 140,

			tabstop = 7,

			text = Localize("Refresh"),

			OnCommand = function(Sender)
				UI.PageMultiplayer.CurrentList.RefreshList();
			end
		},


		Join =
		{
			skin = UI.skins.BottomMenuButton,
			left = 780-140,
			width = 140,

			tabstop = 8,

			text = Localize("Join"),
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
		
		OnActivate = function(Sender)

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

			if (UI.PageMultiplayer.CurrentList) then
				local ServerList = UI.PageMultiplayer.CurrentList.GUI.ServerList;

				if (ServerList:GetSelectionCount() > 0) then
					UI:EnableWidget(UI.PageMultiplayer.GUI.Join);
				else
					UI:DisableWidget(UI.PageMultiplayer.GUI.Join);
				end
			end

			if( NewUbisoftClient ) then
				NewUbisoftClient.szCurrentUbiName = szName;
				NewUbisoftClient.szCurrentUbiPass = szPassword;
			end;

			UI.PageNETServerList.iCurrentLobby = 0;
		end,
	},

	CreateServer = function()
		Game:Disconnect();
		GotoPage("CreateServer");
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