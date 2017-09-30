function NewUbisoftClient:ConsoleLogin(username, password)
	NewUbisoftClient:Client_Disconnect();
	
	if (username and password) then
		UI.PageMultiplayer.OnLoginOk(username, password, nil);
	else
		UI.LoginBox("@Login", "@EnterNamePassword", username, password, nil, UI.PageMultiplayer.OnLoginOk, UI.PageMultiplayer.OnLoginCancel);
	end	

	System:ShowConsole(0);
end

function NewUbisoftClient:Login()	
	NewUbisoftClient:Client_Disconnect();
	
	UI.LoginBox("@Login", "@EnterNamePassword", NewUbisoftClient.szCurrentUbiName, NewUbisoftClient.szCurrentUbiPass, UI.szUbiCreateAccountURL, UI.PageMultiplayer.OnLoginOk, UI.PageMultiplayer.OnLoginCancel);
end

function NewUbisoftClient:Client_LoginSuccess(Username)
	UI.ProgressBoxDone();
	UI:UpdateBanner();
end

function NewUbisoftClient:Client_LoginFail(szError)
	UI.ProgressBoxDone();
	UI.MessageBox("@LoginFailed", szError, NewUbisoftClient.Client_LoginFailOk);
end

function NewUbisoftClient:Client_LoginFailOk()
	NewUbisoftClient:Login();
end

function NewUbisoftClient:Client_GameServer(LobbyID, RoomID, Servername, IPAddress, LANIPAddress, MaxPlayers, NumPlayers)
	local iColon = strfind(IPAddress, ':');
	local szIP = strsub(IPAddress, 1, iColon-1);
	local szPort = strsub(IPAddress, iColon+1);
	
	printf("UBI SERVER: %s %s %s:%s (%g)", LobbyID, RoomID, szIP, szPort, _time);

	UI.PageNETServerList.UBIGameServers[IPAddress] = {};
	local UBIGameServer = UI.PageNETServerList.UBIGameServers[IPAddress];

	UBIGameServer.LobbyID= LobbyID;
	UBIGameServer.RoomID = RoomID;
	UBIGameServer.IPAddress = IPAddress;
	UBIGameServer.LANIPAddress = LANIPAddress;
	UBIGameServer.MaxPlayers = MaxPlayers;
	UBIGameServer.ServerName = Servername;
	UBIGameServer.NumPlayers = NumPlayers;
		
	Game:GetServerInfo(szIP, szPort);	
end

function NewUbisoftClient:Client_RequestFinished()
	printf("Ubi.com: Client_RequestFinished");
	UI:EnableWidget(UI.PageMultiplayer.GUI.Refresh);
	UI:EnableWidget(UI.PageMultiplayer.GUI.FavoritesText);
--    UI:EnableWidget(UI.PageMultiplayer.GUI.AddToFavorites);
--    UI:EnableWidget(UI.PageMultiplayer.GUI.DeleteFromFavorites);
--    UI:EnableWidget(UI.PageMultiplayer.GUI.FilterFavorites);
end

function NewUbisoftClient:RefreshNETServerList()
	NewUbisoftClient:Client_RequestGameServers();
end

function NewUbisoftClient:Client_JoinGameServerSuccess()
	printf("Ubi.com: Client_JoinGameServerSuccess");
end

function NewUbisoftClient:Client_JoinGameServerFail( szError )
	printf("Ubi.com: Client_JoinGameServerFail ("..szError..")");
end

function NewUbisoftClient:Server_RegisterServerSuccess(iLobbyID, iRoomID)
	printf("Ubi.com: Server_RegisterServerSuccess");
	NewUbisoftClient:Client_JoinGameServer(iLobbyID, iRoomID);
end

function NewUbisoftClient:Server_RegisterServerFail()
	printf("Ubi.com: Server_RegisterServerFail");
end

function NewUbisoftClient:Server_LobbyServerDisconnected()
	printf("Ubi.com: Server_LobbyServerDisconnected");
end

function NewUbisoftClient:Server_PlayerJoin(szUsername)
	local szText = "Ubi.com: Server_PlayerJoin: " .. szUsername
	printf(szText);
end

function NewUbisoftClient:Server_PlayerLeave(szUsername)
	local szText = "Ubi.com: Server_PlayerLeave: " .. szUsername
	printf(szText);
end

function NewUbisoftClient:CDKey_Failed(szError)
	--local szText = "Ubi.com: CDKey_Failed: " .. szError
	--printf(szText);
	System:Error("CDKey_Failed: " .. szError);
	UI.MessageBox("@CDKeyFailed", szError);
end

function NewUbisoftClient:CDKey_GetCDKey()
	UI.InputBox("@AskCDKeyTitle", "@AskCDKey", "", UI.PageMultiplayer.OnCDKeyOk, UI.PageMultiplayer.OnLoginCancel);
end

function NewUbisoftClient:CDKey_ActivationSuccess()
	printf("Ubi.com: CDKey_ActivationSuccess");
	
	UI.bVerifyingProgress = nil;
	UI.ProgressBoxDone();
	
	if (UI.bNeedUbiReconnect) then
		Game:Reconnect();
	elseif (UI:IsScreenActive("Multiplayer") == 1) then
		UI.PageNETServerList.RefreshList();
	end
end

function NewUbisoftClient:CDKey_ActivationFail(szError)
	printf("Ubi.com: CDKey_ActivationFail %s",szError);
	
	Game:ShowMenu();

	if (UI:IsScreenActive("Multiplayer") ~= 1) then
		GotoPage("Multiplayer");

		Game:Disconnect();
		Game:CleanUpLevel();
		
		UI.MessageBox("@CDKeyFailed", szError);
		
		return;
	end

	UI.ProgressBoxDone();
	
	UI.bVerifyingProgress = nil;
	local szText = szError .. " @AskCDKeyReenter";
	local szCDKey;
	
	if (UI.szCurrentCDKey) then
		szCDKey = UI.szCurrentCDKey;
	else
		szCDKey = "";
	end
		
	UI.InputBox("@AskCDKeyTitle", szText, szCDKey, UI.PageMultiplayer.OnCDKeyOk, UI.PageMultiplayer.CancelCDKey);
end

function NewUbisoftClient:Client_MOTD(szUbiMOTD,szGameMOTD)
	--printf("Ubi.com: Client_MOTD %s %s",szUbiMOTD,szGameMOTD);
end