UI.PageLANServerList=
{
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
			end,
			
			OnChanged = function(Sender)
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

			skin = UI.skins.ListView,
			fontsize = 12,

			left = 200, top = 140.5,
			width = 580, height = 280,
			
			tabstop = 3,

			vscrollbar=
			{
				skin = UI.skins.VScrollBar,
			},

			hscrollbar=
			{
				skin = UI.skins.HScrollBar,
			},

			OnCommand = function(Sender)
			
				local iSelected = UI.PageLANServerList.GUI.ServerList:GetSelection(0);

				if(iSelected and UI.PageLANServerList.Servers[iSelected].Mod~="@UnknownMod")then
					if (ClientStuff) then
						UI.YesNoBox(Localize("TerminateCurrentGame"), Localize("TerminateCurrentGameLabel"), UI.PageLANServerList.CheckChangeModToJoin);
					else
						UI.PageLANServerList.CheckChangeModToJoin();
					end
				end
			end
		},

		RefreshingLabel=
		{
			classname = "static",
			left = 201, top = 141,
			width = 578, height = 317,
			
			flags = UIFLAG_ENABLED,
			
			zorder = 150,
			
			color = "0 0 0 196",
			
			halign = UIALIGN_CENTER,
			valign = UIALIGN_MIDDLE,
			
			text = Localize("RefreshingServerList");
		},

		OnActivate = function(Sender)
			UI.PageLANServerList.RefreshList();
		end,
		
		OnDeactivate = function(Sender)
			UI.PageLANServerList.bRefreshing = nil;
		end,
		
		OnUpdate = function(Sender)			
			if (UI.PageLANServerList.bRefreshing) then
				if (UI.PageLANServerList.fRefreshingTime + 1.70 < _time) then
					UI.PageLANServerList.bRefreshing = nil;
					UI.PageLANServerList:PopulateServerList(UI.PageLANServerList);
				end
-- uncomment this to have automatic refreshing every 30seconds after last refresh
--			elseif (_time - UI.PageLANServerList.fLastRefreshingTime > 30) then
--				UI.PageLANServerList.RefreshList();
			end
		end,
	},
	
	-- is a modchange needed?
	CheckChangeModToJoin = function()
		System:Log("CheckChangeModToJoin");		-- debug
		local Page = UI.PageLANServerList;
		local iSelected = Page.GUI.ServerList:GetSelection(0);
		
		local sSelected=strupper(Page.Servers[iSelected].Mod);
		local sCurrent=strupper(Game:GetCurrentModName());
	
		System:Log("CheckChangeModToJoin '"..sSelected.."' '"..sCurrent.."'");	-- debug
		
		-- is a Mod change needed
		if sSelected~=sCurrent then
			UI.YesNoBox( Localize( "ModChange1" ), Localize( "ModChange2" ), UI.PageLANServerList.ChangeModToJoin,nil );
		else
			UI.PageLANServerList.PrepareToJoin();
		end
	end,
	
	-- change the mod and restart the game
	ChangeModToJoin = function()
		local Page = UI.PageLANServerList;
		local iSelected = Page.GUI.ServerList:GetSelection(0);
		
		System:Log("ChangeModToJoin");		-- debug
		Game:LoadMOD(Page.Servers[iSelected].Mod,1);
	end,

	PrepareToJoin = function()
		System:Log("PrepareToJoin");		-- debug
		local Page = UI.PageLANServerList;
		local iSelected = Page.GUI.ServerList:GetSelection(0);
		
		Game:Disconnect();
		
		if (iSelected) then
			local szServerIP   = Page.Servers[iSelected].IP;
			local szServerName = Page.Servers[iSelected].Name;
			
			UI.PageLANServerList.szJoinIP = szServerIP;
			UI.PageLANServerList.szServerName = szServerName;
			
			UI.PageLANServerList.JoinServer();
		end	
	end,

	JoinServer = function(Sender)
		if (UI.PageLANServerList.szJoinIP) then
            local iColon = strfind(UI.PageLANServerList.szJoinIP, ':');
            setglobal("g_LastIP", strsub(UI.PageLANServerList.szJoinIP, 1, iColon-1));
            setglobal("g_LastPort", strsub(UI.PageLANServerList.szJoinIP, iColon+1));
            setglobal("g_LastServerName", UI.PageLANServerList.szServerName);
			
			Game:Connect(UI.PageLANServerList.szJoinIP, 1);					-- (IP=..,bLateSwitch=1,bCDKeyAuthorization=0)
		end
		UI.PageLANServerList.szJoinIP = nil;
	end,

	RefreshList = function(Sender)
		UI:ShowWidget("RefreshingLabel", "LANServerList");

		UI.PageLANServerList.bRefreshing = 1;
		UI.PageLANServerList.fRefreshingTime = _time;

		Game:RefreshServerList();
	end,

	PopulateServerList = function(Sender)

		local ServerList = Game:GetServerList();
		local LocalServerList = UI.PageLANServerList.Servers;
		local ServerListView = UI.PageLANServerList.GUI.ServerList;
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

		ServerListView:Clear();

		for iIndex, Server in ServerList do		
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
			else
				szPing = "$4"..Server.Ping;
			end

			if (Server.Players == 0) then
				szPlayers = "$6" ..Server.Players.."$1/$6"..Server.MaxPlayers;
			elseif (Server.Players < Server.MaxPlayers) then
				szPlayers = "$3" ..Server.Players.."$1/$3"..Server.MaxPlayers;
			else
				szPlayers = "$4" ..Server.Players.."$1/$4"..Server.MaxPlayers;
			end

			if (Server.InternetServer == 0) then
			
				local szVersion = "";
			
				if (Server.GameVersion) then
					local i = strfind(Server.GameVersion, "%d+$");
					
					if (i) then
						szVersion = strsub(Server.GameVersion, i);
					end
				end

--				ServerIndex = ServerListView:AddItem("", "", Server.Name,  szPing, szPlayers, Server.Map, Server.IP, Server.GameType, Server.Mod, szVersion);

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

			if(szPassworded and szPassworded~=1 and Server.Password and Server.Password ==0) then
				vetoAddToList = 1;
			end
			
			if(szPassworded and szPassworded==0 and Server.Password and Server.Password ==1) then
				vetoAddToList = 1;
			end
			
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

				if(szPingFilter == '< 70' and Server.Ping > 70) then
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
					LocalServerList[ServerIndex].Name = Server.Name;
					LocalServerList[ServerIndex].Password = Server.Password;

				end
			else
				printf("Not showing internet server: %s",Server.IP);
			end
			
		end

		UI:HideWidget("RefreshingLabel", "LANServerList");
		UI.PageLANServerList.fLastRefreshingTime = _time;
	end,
}

UI:CreateScreenFromTable("LANServerList", UI.PageLANServerList.GUI);