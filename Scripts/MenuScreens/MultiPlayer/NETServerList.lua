UI.PageNETServerList=
{
	UnknownModString="$9 @UnknownMod $3",						-- 

	UBIGameServers={},
	Servers={},
	
	GUI =
	{	
		ServerList=
		{			
			OnInit = function (Sender)
				Sender:ClearColumns();
				Sender:AddColumn("@Name", 208, UIALIGN_LEFT, UI.szListViewOddColor, "0 0 0 0");
				Sender:AddColumn("@Ping", 30, UIALIGN_CENTER, UI.szListViewEvenColor, "0 0 0 64", nil, nil, 1);
				Sender:AddColumn("@PB", 20, UIALIGN_CENTER, UI.szListViewOddColor, "0 0 0 0", nil, nil, 0, 0, 1);
				Sender:AddColumn("@PWD", 20, UIALIGN_CENTER, UI.szListViewEvenColor, "0 0 0 0", nil, nil, 0, 0, 1);
				Sender:AddColumn("@Players", 46, UIALIGN_CENTER, UI.szListViewOddColor, "0 0 0 0", nil, nil, 1);
				Sender:AddColumn("@Map", 78, UIALIGN_CENTER, UI.szListViewEvenColor, "0 0 0 64");
				Sender:AddColumn("@IP", 100, UIALIGN_CENTER, UI.szListViewOddColor, "0 0 0 0");				
				Sender:AddColumn("@GameType", 72, UIALIGN_CENTER, UI.szListViewEvenColor, "0 0 0 64");
				Sender:AddColumn("@Mod", 72, UIALIGN_CENTER, UI.szListViewOddColor, "0 0 0 0");
				Sender:AddColumn("@Version", 52, UIALIGN_CENTER, UI.szListViewEvenColor, "0 0 0 64", nil, nil, 1);
				Sender:AddImageList(UI.skins.ServerTypeIcon);
                Game:CreateVariable("g_LastIP");
                Game:CreateVariable("g_LastPort");
                Game:CreateVariable("g_LastServerName");
                Game:CreateVariable("g_FavServerIP");                
			end,

			OnChanged = function(Sender)
                setglobal("g_FavServerIP", Sender:GetSelection(0));
				if (Sender:GetSelectionCount() > 0) then
					UI:EnableWidget(UI.PageMultiplayer.GUI.Join);
					UI:EnableWidget(UI.PageMultiplayer.GUI.DeleteFromFavorites);
					UI:EnableWidget(UI.PageMultiplayer.GUI.AddToFavorites);
				else
					UI:DisableWidget(UI.PageMultiplayer.GUI.Join);
					UI:DisableWidget(UI.PageMultiplayer.GUI.DeleteFromFavorites);
					UI:DisableWidget(UI.PageMultiplayer.GUI.AddToFavorites);
				end
			end,
			
			left = 200, top = 140.5,
			width = 580, height = 280,
--			left = 50, top = 180,
--			width = 725, height = 280,
			
			tabstop = 3,

			skin = UI.skins.ListView,

			vscrollbar=
			{
				skin = UI.skins.VScrollBar,
			},
			
			hscrollbar=
			{
				skin = UI.skins.HScrollBar,
			},
			
			OnCommand = function(Sender)

				local iSelected = UI.PageNETServerList.GUI.ServerList:GetSelection(0);

				if(iSelected and UI.PageNETServerList.Servers[iSelected].Mod~=UI.PageNETServerList.UnknownModString)then
					if (ClientStuff) then
						UI.YesNoBox(Localize("TerminateCurrentGame"), Localize("TerminateCurrentGameLabel"), UI.PageNETServerList.CheckChangeModToJoin);
					else
						UI.PageNETServerList.CheckChangeModToJoin();				
					end
				end
			end,
		},
	},
	
		-- is a modchange needed?
	CheckChangeModToJoin = function()
		System:Log("CheckChangeModToJoin");		-- debug
		local Page = UI.PageNETServerList;
		local iSelected = Page.GUI.ServerList:GetSelection(0);
		
		local sSelected=strupper(Page.Servers[iSelected].Mod);
		local sCurrent=strupper(Game:GetCurrentModName());
	
		System:Log("CheckChangeModToJoin '"..sSelected.."' '"..sCurrent.."'");	-- debug
		
		-- is a Mod change needed
		if sSelected~=sCurrent then
			UI.YesNoBox( Localize( "ModChange1" ), Localize( "ModChange2" ), UI.PageNETServerList.ChangeModToJoin,nil );
		else
			UI.PageNETServerList.PrepareToJoin();
		end
	end,
	
	-- change the mod and restart the game
	ChangeModToJoin = function()
		local Page = UI.PageNETServerList;
		local iSelected = Page.GUI.ServerList:GetSelection(0);
		
		System:Log("ChangeModToJoin");		-- debug
		Game:LoadMOD(Page.Servers[iSelected].Mod,1);
	end,
	
	PrepareToJoin = function()
		local Page = UI.PageNETServerList;
		local iSelected = Page.GUI.ServerList:GetSelection(0);
		
		Game:Disconnect();
		
		if (iSelected) then
			local szIP = UI.PageNETServerList.Servers[iSelected].IP;
			local UBIGameServer = UI.PageNETServerList.UBIGameServers[szIP];
			
			if (not UBIGameServer) then
				return;
			end
			
			UI.PageNETServerList.szJoinIP = szIP;
			UI.PageNETServerList.iJoinLobbyID = UBIGameServer.LobbyID;
			UI.PageNETServerList.iJoinRoomID = UBIGameServer.RoomID;
			UI.PageNETServerList.szServerName = UBIGameServer.ServerName;
			
			UI.PageNETServerList.JoinServer();
		end	
	end,
	
	JoinServer = function(Sender)
		if (UI.PageNETServerList.szJoinIP) then
            local iColon = strfind(UI.PageNETServerList.szJoinIP, ':');
            setglobal("g_LastIP", strsub(UI.PageNETServerList.szJoinIP, 1, iColon-1));
            setglobal("g_LastPort", strsub(UI.PageNETServerList.szJoinIP, iColon+1));
            setglobal("g_LastServerName", UI.PageNETServerList.szServerName);
            
            setglobal("cl_rcon_port", g_LastPort);
			NewUbisoftClient:Client_JoinGameServer(UI.PageNETServerList.iJoinLobbyID, UI.PageNETServerList.iJoinRoomID);
			Game:Connect(UI.PageNETServerList.szJoinIP,1,1);					-- (IP=..,bLateSwitch=1,bCDKeyAuthorization=1)
		end
		
		UI:EnableWidget(UI.PageMultiplayer.GUI.Refresh);
		UI.PageNETServerList.szJoinIP = nil;
	end,

	RefreshList = function()
		Game:ClearServerInfo(); -- clear list of "waiting for response" servers..
		UI.PageNETServerList.GUI.ServerList:Clear();
        	UI.PageMultiplayer.LoadFavorites();

        	if (UI.PageMultiplayer.FilterFavorites==1) then
            	local iColon;
	            local TestIP;
	            local TestPort;                   
	                          
	            if (count(UI.PageMultiplayer.FavServers) > 0) then
	                for ServerIndex=1, count(UI.PageMultiplayer.FavServers) do
	                    iColon = strfind(UI.PageMultiplayer.FavServers[ServerIndex], ':');
	                    TestIP = strsub(UI.PageMultiplayer.FavServers[ServerIndex], 1, iColon-1);
      	              TestPort = strsub(UI.PageMultiplayer.FavServers[ServerIndex], iColon+1);                    
	                   
	                    Game:GetServerInfo(TestIP, TestPort);
	                end
	            end          
	        else
	            NewUbisoftClient:Client_RequestGameServers();
      	      UI:DisableWidget(UI.PageMultiplayer.GUI.Refresh);
			UI:DisableWidget(UI.PageMultiplayer.GUI.FavoritesText);
	            UI:DisableWidget(UI.PageMultiplayer.GUI.AddToFavorites);
	            UI:DisableWidget(UI.PageMultiplayer.GUI.DeleteFromFavorites);
	        end
	end,
		
	AddServerToList = function(Server)

		local LocalServerList = UI.PageNETServerList.Servers;
		local ServerListView = UI.PageNETServerList.GUI.ServerList;
		local ServerIndex;
		local szPing;
		local szPlayers;

		local vetoAddToList = 0;

		local szGameType = UI.PageMultiplayer.GUI.FilterBlock.GameTypeCombo:GetSelection();		
		local szPassworded = UI.PageMultiplayer.GUI.FilterBlock.Password:GetChecked();		
		local szPunkbuster = UI.PageMultiplayer.GUI.FilterBlock.PunkbusterCombo:GetSelection();		
		local szPopulated = UI.PageMultiplayer.GUI.FilterBlock.Populated:GetChecked();
		local szNotFull = UI.PageMultiplayer.GUI.FilterBlock.NotFull:GetChecked();
		local szServerNameMatch = UI.PageMultiplayer.GUI.FilterBlock.ServerName:GetText();
		local szPingFilter = UI.PageMultiplayer.GUI.FilterBlock.PingCombo:GetSelection()

--		if ((strlen(Server.Name) < 1) and (Server.Ping == 0) and (strlen(Server.Map) < 1) and (strlen(Server.GameType) < 1)) then		
--				ServerIndex = ServerListView:AddItem("", "", Server.Name, "$49999", "", Server.GameType, Server.Map, Server.IP);
--		else

			if (Server.CheatsEnabled and Server.CheatsEnabled ~= 0) then
				Server.Name = "[cheats] " .. Server.Name;
			end
	
			-- colored server settings			
			if (Server.Ping < 50) then
				szPing = "$3"..Server.Ping;
			elseif (Server.Ping < 80) then
				szPing = "$6"..Server.Ping;
			elseif (Server.Ping < 120) then
				szPing = "$8"..Server.Ping;
			elseif (Server.Ping < 9999) then
				szPing = "$4"..Server.Ping;
			else
				szPing = "$9"..Server.Ping;
			end
	
			if (Server.Ping == 9999) then
				szPlayers = "$9" ..Server.Players.."/"..Server.MaxPlayers;
			elseif (Server.Players == 0) then
				szPlayers = "$6" ..Server.Players.."$1/$6"..Server.MaxPlayers;
			elseif (Server.Players < Server.MaxPlayers) then
				szPlayers = "$3" ..Server.Players.."$1/$3"..Server.MaxPlayers;
			else
				szPlayers = "$4" ..Server.Players.."$1/$4"..Server.MaxPlayers;
			end
			
			local szVersion = "";
			
			if (Server.GameVersion) then
				local i = strfind(Server.GameVersion, "%d+$");
				
				if (i) then
					szVersion = strsub(Server.GameVersion, i);
				end
			end

--			ServerIndex = ServerListView:AddItem("", "", Server.Name, szPing, szPlayers, Server.Map, Server.IP, Server.GameType, Server.Mod, szVersion);
			
			local serverWhiteName = strlower(Server.Name);
			serverWhiteName = gsub(serverWhiteName, '$0', '');
			serverWhiteName = gsub(serverWhiteName, '$1', '');
			serverWhiteName = gsub(serverWhiteName, '$2', '');
			serverWhiteName = gsub(serverWhiteName, '$3', '');
			serverWhiteName = gsub(serverWhiteName, '$4', '');
			serverWhiteName = gsub(serverWhiteName, '$5', '');
			serverWhiteName = gsub(serverWhiteName, '$6', '');
			serverWhiteName = gsub(serverWhiteName, '$7', '');
			serverWhiteName = gsub(serverWhiteName, '$8', '');
			serverWhiteName = gsub(serverWhiteName, '$9', '');
			serverWhiteName = gsub(serverWhiteName, '%c', '');

			if(strlower(szGameType) ~= strlower(Server.GameType) and strlower(szGameType)~='all') then
				vetoAddToList = 1;
			end

			if(szPassworded and Server.Password and Server.Password ==0) then
				vetoAddToList = 1;
			end
			
			--if(szPassworded==nil and Server.Password and Server.Password ==1) then
			--	vetoAddToList = 1;
			--end
			
			if(szPunkbuster == "PB Disabled" and Server.PunkBuster and Server.PunkBuster ~= 0) then
				vetoAddToList = 1;
			end

			if(szPunkbuster == "PB Enabled" and Server.PunkBuster and Server.PunkBuster ~= 1) then
				vetoAddToList = 1;
			end


			if(szPopulated and Server.Players==0) then
				vetoAddToList = 1;
			end
			
			if(szNotFull and Server.Players==Server.MaxPlayers) then
				vetoAddToList = 1;
			end

			if(szServerNameMatch and szServerNameMatch ~= '' and strfind(serverWhiteName, strlower(szServerNameMatch),1,1)==nil) then
				vetoAddToList = 1;
			end
			
			if(szPingFilter == '< 50' and Server.Ping > 50) then
				vetoAddToList = 1;
			end

			if(szPingFilter == '< 80' and Server.Ping > 80) then
				vetoAddToList = 1;
			end

			if(szPingFilter == '< 120' and Server.Ping > 120) then
				vetoAddToList = 1;
			end

			if(vetoAddToList == 0) then
				ServerIndex = ServerListView:AddItem(Server.Name, szPing,"","", szPlayers, Server.Map, Server.IP, Server.GameType, Server.Mod, szVersion);
				

				-- add punkbuster icon			
				if (Server.PunkBuster and Server.PunkBuster ~= 0) then
					ServerListView:SetItemImage(8, ServerIndex,2);
				end

				-- add password icon
				if (Server.Password and Server.Password ~= 0) then
					ServerListView:SetItemImage(9, ServerIndex, 3);
				end

				LocalServerList[ServerIndex] = {};
				LocalServerList[ServerIndex].IP = Server.IP;
				LocalServerList[ServerIndex].Mod = Server.Mod;
				LocalServerList[ServerIndex].Password = Server.Password;

			end

--		end

	end		
}

UI:CreateScreenFromTable("NETServerList", UI.PageNETServerList.GUI);

function Game:OnNETServerFound(Server)
	--printf("SERVER FOUND (%g)!", _time);
	UI.PageNETServerList.AddServerToList(Server);
end

function Game:OnNETServerTimeout(Server)
	--printf("SERVER TIMEOUT (%g)!", _time);
	local UBIGameServer = UI.PageNETServerList.UBIGameServers[Server.IP];
if (UBIGameServer == nil) then	
	return;
end
	Server.Ping = 9999;
	Server.Players = UBIGameServer.NumPlayers;
	Server.MaxPlayers = UBIGameServer.MaxPlayers;
	Server.Name = "$9"..UBIGameServer.ServerName;
	Server.Map="$9 @UnknownMap $3";
	Server.Mod=UI.PageNETServerList.UnknownModString;
	Server.GameType="$9 @UnknownGameType $3";
	
	Server.MaxPlayers = UI.PageNETServerList.AddServerToList(Server);
end