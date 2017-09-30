--------------------------------------------------------------------------------
-- Callback that gets called when a loading error occurs
--------------------------------------------------------------------------------
function Game:OnLoadingError(szError)	
	--Game:Disconnect(szReason);
	Game:CleanUpLevel();

	if (UI) then
		Game:ShowMenu();
		GotoPage("MainScreen", 0);
		UI.MessageBox("@LoadingError", szError);
		UI.bServerPasswordTry = nil;
	else
		System:Error(szError);
	end
end

--------------------------------------------------------------------------------
-- Callback that gets called right after the "connect" command
--------------------------------------------------------------------------------
function Game:OnConnectBegin(szServerAddress)
	if (not UI) then
		return 1;
	end

	System:ShowConsole(0);
	
	-- stop any movie sequence currently playing
	if (VideoSequencer and VideoSequencer:IsPlaying()) then
		VideoSequencer:Stop();
	end
	
	Game:CleanUpLevel();
	Game:ShowMenu();
	
	local iSC = UI:GetScreenCount();
	local bMainMenu = 1;
	
	for i=0, iSC-1 do
		local Screen = UI:GetScreen(i);
		if (UI:IsScreenActive(Screen) ~= 0) then
			if (ClientStuff and (Screen:GetName() == ClientStuff:GetInGameMenuName())) then
				bMainMenu = 1;
				break;
			end
			bMainMenu = nil;
		end
	end

	if (bMainMenu) then
		GotoPage("MainScreen", 0);
	end
	
	 -- HACK: deactivate any visible message or confirmation dialogs,
	 -- so they won't get overlapped by the connecting window
	UI:DeactivateScreen("ConfirmationDialog");
	UI:DeactivateScreen("MessageDialog");
	UI:DeactivateScreen("InputDialog");
	UI:DeactivateScreen("LoginDialog");
	
	UI.ProgressBox("@ConnectingToServer", "@ConnectingTo "..szServerAddress.."...", CancelConnectProc);
	UI.bConnectingProgress = 1;
	
	local pname = getglobal("p_name");
	
	if (not pname or strlen(pname) < 1) then
		if (NewUbisoftClient) then
			local ubiname = NewUbisoftClient:Client_GetStoredUsername();
			if (ubiname and strlen(ubiname) > 0) then
				setglobal("p_name", ubiname);
			end
		end
	end
	
	return 1;
end

--------------------------------------------------------------------------------
-- Callback that gets called right after we get a response from the server
--------------------------------------------------------------------------------
function Game:OnConnectEstablished()
	if (not UI) then
		return
	end

	UI.ProgressBoxDone();
	UI.bConnectingProgress = nil;
	UI.bServerPasswordTry = nil;
	UI.bNeedUbiReconnect = nil;
end

--------------------------------------------------------------------------------
-- Callback that gets called right after we get a response from the server,
-- but the server is Ubi.com and we are not connected to Ubi.com
--------------------------------------------------------------------------------
function Game:OnConnectNeedUbi()
	if (not UI) then
		return
	end

	UI.ProgressBoxDone();
	UI.bConnectingProgress = nil;
	UI.bServerPasswordTry = nil;
	UI.bNeedUbiReconnect = 1;

	NewUbisoftClient:Login();
end


--------------------------------------------------------------------------------
-- Callback that gets called when the user presses the cancel button in the connect dialog
--------------------------------------------------------------------------------
function CancelConnectProc()
	Game:Disconnect();
	Game:CleanUpLevel();
	UI.bConnectingProgress = nil;
	UI.bServerPasswordTry = nil;
end

---------------------------------------------------------------------------------
-- this is called whenever the client is disconnect from the server
function ClientOnDisconnect(szReason)
	if ((not UI) or UI.bTerminatingGame) then
		UI.bTerminatingGame = nil;
		return
	end
	
	if (UI.bConnectingProgress) then
		UI.ProgressBoxDone();
		UI.bConnectingProgress = nil;
	end
	
	local bSinglePlayer = 1;
	
	if (Game:IsMultiplayer()) then
		bSinglePlayer = nil;
	end
	
	System:ShowConsole(0);
	Game:CleanUpLevel();
	Game:ShowMenu();

	if (bSinglePlayer) then
		GotoPage("MainScreen", 0);
		return;
	end

	if (szReason) then	
		if (strsub(szReason, -1) == '\n') then 	-- remove the \n that punkbuster messages return
		
			szReason = strsub(szReason, 1, -2);
			
		elseif (not strfind(strlower(szReason), "punkbuster")) then
			if (strsub(szReason, 1, 1) ~= "@") then
				szReason = "@"..szReason;
			end			
		end

		if (strfind(szReason, "InvalidServerPassword")) then
			if (UI.bServerPasswordTry) then
				UI.InputBoxEx("@AskServerPassword", "@AskServerPasswordMsgWrong", getglobal("cl_password"), 0, 0, 0, 1, 32, PasswordOkProc, PasswordCancelProc);
				UI.bServerPasswordTry = UI.bServerPasswordTry + 1;
			else
				UI.InputBoxEx("@AskServerPassword", "@AskServerPasswordMsg", getglobal("cl_password"), 0, 0, 0, 1, 32, PasswordOkProc, PasswordCancelProc);
				UI.bServerPasswordTry = 1;
			end
			return;
		else
			
			if (UI:IsScreenActive("MainScreen") ~= 1) then
				GotoPage("Multiplayer");
			end
			
			if ((not (strfind(szReason, "@UserDisconnected")) and (not strfind(szReason, "@ClientHasQuit")))) then
				UI.MessageBox("@DisconnectedFromServer", szReason);
			end
			
			return;
		end
	else
		GotoPage("MainScreen", 0);
	end
end

function PasswordOkProc(szPassword)
	if (szPassword and strlen(szPassword)) then
		setglobal("cl_password", szPassword);
		Game:Reconnect();
		
		return 1;
	end
end

function PasswordCancelProc(szPassword)
	UI.bServerPasswordTry = nil;
	return 1;
end

function LoadErrorOkProc()
	GotoPage("MainScreen", 0);
end

---------------------------------------------------------------------------------
-- this is called whenever the client is waiting for the server for too long
---------------------------------------------------------------------------------
function ClientOnServerTimeout()
	if (not UI) then
		return
	end

	UI.bInGameOverride = 1;
	UI.WaitServer();
end

---------------------------------------------------------------------------------
-- this is called whenever the client was waiting for the server for too long,
-- but the server magically, reborn
---------------------------------------------------------------------------------
function ClientOnServerRessurect()
	if (not UI) then
		return
	end

	UI.bInGameOverride = nil;
	UI.QuitWaitServer();
end