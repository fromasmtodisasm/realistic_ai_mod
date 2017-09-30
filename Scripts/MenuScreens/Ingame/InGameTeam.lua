Script:LoadScript("Scripts/Multiplayer/SVcommands.lua");
--
-- options menu page
--


UI.PageInGameTeam=
{	
	GUI=
	{	
		JoinRed=
		{
			skin = UI.skins.TopMenuButton,
			left = 400, top = 158,
			width = 180, height = 28,
			bordersides = "lrbt",
			
			tabstop = 1,

			text=Localize("JoinRedTeam"),

			OnCommand=function(Sender)
				Client:JoinTeamRequest("red")
				Game:SendMessage("Switch");
			end,
		},
		
		JoinBlue=
		{
			skin = UI.skins.TopMenuButton,
			left = 400, top = 194,
			width = 180, height = 28,
			bordersides = "lrbt",
			
			tabstop = 2,

			text=Localize("JoinBlueTeam"),


			OnCommand=function(Sender)
				Client:JoinTeamRequest("blue")
				Game:SendMessage("Switch");
			end,
		},
		
		JoinSpectators=
		{
			skin = UI.skins.TopMenuButton,
			left = 400, top = 230,
			width = 180, height = 28,
			bordersides = "lrbt",
			
			tabstop = 3,
			
			text=Localize("JoinSpectatorsTeam"),

			OnCommand=function(Sender)
				Client:JoinTeamRequest("spectators")
				Game:SendMessage("Switch");
			end,
		},
		
		Suicide =
		{
			skin = UI.skins.TopMenuButton,
			left = 400, top = 266,
			width = 180, height = 28,
			bordersides = "lrbt",
			
			tabstop = 4,
			
			text = Localize("DoSuicide"),
			
			OnCommand = function(Sender)
				Client:Kill();
				Game:SendMessage("Switch");
			end,
		},
		VoteYes =
		{
			skin = UI.skins.BottomMenuButton,
			left = 620-160-160,
			width = 100,

			text = "Vote Yes",		
			
			OnCommand = function(Sender)
				if (Client) then
					Client:Vote("yes");
        		UI:HideWidget("VoteYes", "InGameTeam");
			UI:HideWidget("VoteNo", "InGameTeam");
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
        		UI:HideWidget("VoteYes", "InGameTeam");
			UI:HideWidget("VoteNo", "InGameTeam");
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
                                        --UI.PageInGameTeam.GUI:UpdatePunish();
        		UI:HideWidget("PunishYes", "InGameTeam");
			UI:HideWidget("PunishNo", "InGameTeam");
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
                                        --UI.PageInGameTeam.GUI:UpdatePunish();
        		UI:HideWidget("PunishYes", "InGameTeam");
			UI:HideWidget("PunishNo", "InGameTeam");
                                end
				end
			end
		},
		
		OnActivate = function(Sender)
			Sender:PopulateChatTarget();
			UI:HideWidget("PunishYes", "InGameTeam");
			UI:HideWidget("PunishNo", "InGameTeam");


			if (Client) then
		           Client:SendCommand("GTK");
		      end
		
			if getglobal("gr_votetime") then
				if _time>tonumber(getglobal("gr_votetime")) then
					UI:HideWidget("VoteYes", "InGameTeam");
					UI:HideWidget("VoteNo", "InGameTeam");
				else
					UI:ShowWidget("VoteYes", "InGameTeam");
					UI:ShowWidget("VoteNo", "InGameTeam");
				end
			else 
					UI:HideWidget("VoteYes", "InGameTeam");
					UI:HideWidget("VoteNo", "InGameTeam");
			end
	
			local judge=Hud.szSelfJudge;
			if (judge ~= nil) then
		        	if (judge ~= 0) then
					UI:ShowWidget("PunishYes", "InGameTeam");
					UI:ShowWidget("PunishNo", "InGameTeam");
				else
		        		UI:HideWidget("PunishYes", "InGameTeam");
					UI:HideWidget("PunishNo", "InGameTeam");
				end
			else
					UI:HideWidget("PunishYes", "InGameTeam");
					UI:HideWidget("PunishNo", "InGameTeam");
			end



			
			if (Hud) then
				Hud.bHide = 1;
			end
		end,
		
		OnDeactivate = function(Sender)
			if (Hud) then
				Hud.bHide = nil;
			end	
		end,
		
		OnUpdate = function(Sender)
			if (_localplayer) then
				if (_localplayer.entity_type ~= "spectator") then
					UI:EnableWidget(Sender.Suicide);
				else
					UI:DisableWidget(Sender.Suicide);
				end
			end

			if (Client) then
		           Client:SendCommand("GTK");
		      end

			local judge=Hud.szSelfJudge;
			if (judge ~= nil) then
		        	if (judge ~= 0) then
					UI:ShowWidget("PunishYes", "InGameTeam");
					UI:ShowWidget("PunishNo", "InGameTeam");
				else
		        		UI:HideWidget("PunishYes", "InGameTeam");
					UI:HideWidget("PunishNo", "InGameTeam");
				end
			else
					UI:HideWidget("PunishYes", "InGameTeam");
					UI:HideWidget("PunishNo", "InGameTeam");
			end
	
			Sender:PopulateChatTarget(1);
		end,	
	},
};

UI:AddChatbox(UI.PageInGameTeam.GUI, 200, 312, 580, 144, 24, 1);

AddUISideMenu(UI.PageInGameTeam.GUI,
{
	{ "Disconnect", Localize("Disconnect"), "$Disconnect$", 0},
	{ "Options", Localize("Options"), "Options", },
	{ "ServerAdmin", "Server Admin", "ServerAdmin",},
	{ "VotePanel", "Vote Panel", "VotePanel",},

	{ "-", "-", "-", },	-- separator
	{ "Quit", "@Quit", UI.PageMainScreen.ShowConfirmation, },	
});

UI:CreateScreenFromTable("InGameTeam",UI.PageInGameTeam.GUI);