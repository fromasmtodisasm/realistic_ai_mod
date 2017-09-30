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
				Sender:AddColumn("@PB", 24, UIALIGN_CENTER, UI.szListViewOddColor, "0 0 0 0", nil, nil, 0, 0, 1);
				Sender:AddColumn("@PWD", 24, UIALIGN_CENTER, UI.szListViewEvenColor, "0 0 0 0", nil, nil, 0, 0, 1);
				Sender:AddColumn("@Name", 248, UIALIGN_LEFT, UI.szListViewOddColor, "0 0 0 0");
				Sender:AddColumn("@GameType", 72, UIALIGN_CENTER, UI.szListViewEvenColor, "0 0 0 64");
				Sender:AddColumn("@Mod", 72, UIALIGN_CENTER, UI.szListViewOddColor, "0 0 0 0");
				Sender:AddColumn("@Map", 96, UIALIGN_CENTER, UI.szListViewEvenColor, "0 0 0 64");
				Sender:AddColumn("@Players", 48, UIALIGN_CENTER, UI.szListViewOddColor, "0 0 0 0", nil, nil, 1);
				Sender:AddColumn("@Ping", 42, UIALIGN_CENTER, UI.szListViewEvenColor, "0 0 0 64", nil, nil, 1);
				Sender:AddColumn("@IP", 104, UIALIGN_CENTER, UI.szListViewOddColor, "0 0 0 0");
				Sender:AddImageList(UI.skins.ServerTypeIcon);
			end,

			OnChanged = function(Sender)
				if (Sender:GetSelectionCount() > 0) then
					UI:EnableWidget(UI.PageMultiplayer.GUI.Join);
				else
					UI:DisableWidget(UI.PageMultiplayer.GUI.Join);
				end
			end,
			
			left = 200, top = 140.5,
			width = 580, height = 280,
			
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
		
		local sSelected=Page.Servers[iSelected].Mod;
		local sCurrent=Game:GetCurrentModName();
	
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
			
			UI.PageNETServerList.JoinServer();
		end	
	end,
	
	JoinServer = function(Sender)
		if (UI.PageNETServerList.szJoinIP) then
			NewUbisoftClient:Client_JoinGameServer(UI.PageNETServerList.iJoinLobbyID, UI.PageNETServerList.iJoinRoomID);
			Game:Connect(UI.PageNETServerList.szJoinIP,1,1);					-- (IP=..,bLateSwitch=1,bCDKeyAuthorization=1)
		end
		
		UI:EnableWidget(UI.PageMultiplayer.GUI.Refresh);
		UI.PageNETServerList.szJoinIP = nil;
	end,

	RefreshList = function()
		Game:ClearServerInfo(); -- clear list of "waiting for response" servers..
		UI.PageNETServerList.GUI.ServerList:Clear();
		NewUbisoftClient:Client_RequestGameServers();

		UI:DisableWidget(UI.PageMultiplayer.GUI.Refresh);
	end,
	
	AddServerToList = function(Server)

		local LocalServerList = UI.PageNETServerList.Servers;
		local ServerListView = UI.PageNETServerList.GUI.ServerList;
		local ServerIndex;
		local szPing;
		local szPlayers;
		

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

			ServerIndex = ServerListView:AddItem("", "", Server.Name, Server.GameType, Server.Mod, Server.Map, szPlayers, szPing, Server.IP);

			-- add punkbuster icon			
			if (Server.PunkBuster and Server.PunkBuster ~= 0) then
				ServerListView:SetItemImage(8, ServerIndex);
			end

			-- add password icon
			if (Server.Password and Server.Password ~= 0) then
				ServerListView:SetItemImage(9, ServerIndex, 1);
			end

--		end

		LocalServerList[ServerIndex] = {};
		LocalServerList[ServerIndex].IP = Server.IP;
		LocalServerList[ServerIndex].Mod = Server.Mod;
		LocalServerList[ServerIndex].Password = Server.Password;
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
	
	Server.Ping = 9999;
	Server.Players = UBIGameServer.NumPlayers;
	Server.MaxPlayers = UBIGameServer.MaxPlayers;
	Server.Name = "$9"..UBIGameServer.ServerName;
	Server.Map="$9 @UnknownMap $3";
	Server.Mod=UI.PageNETServerList.UnknownModString;
	Server.GameType="$9 @UnknownGameType $3";
	
	Server.MaxPlayers = UI.PageNETServerList.AddServerToList(Server);
end