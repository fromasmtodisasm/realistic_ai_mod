--
-- options menu page
--

UI.PageInGameNonTeam=
{	
	GUI=
	{	
		JoinPlayers=
		{
			skin = UI.skins.TopMenuButton,
			left = 400, top = 162,
			width = 180, height = 30,
			
			bordersides = "lrbt",
			
			tabstop = 1,

			text = Localize("JoinPlayersTeam"),

			OnCommand=function(Sender)
				Client:JoinTeamRequest("players")
				Game:SendMessage("Switch");
			end,
		},
		
		JoinSpectators=
		{
			skin = UI.skins.TopMenuButton,
			left = 400, top = 202,
			width = 180, height = 30,
			bordersides = "lrbt",
			
			tabstop = 2,
			
			text = Localize("JoinSpectatorsTeam"),
			
			OnCommand=function(Sender)
				Client:JoinTeamRequest("spectators")
				Game:SendMessage("Switch");
			end,
		},
		
		Suicide =
		{
			skin = UI.skins.TopMenuButton,
			left = 400, top = 242,
			width = 180, height = 30,
			bordersides = "lrbt",
			
			tabstop = 3,
			
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
			tabstop = 4,	
			
			OnCommand = function(Sender)
				if (Client) then
					Client:Vote("yes");
        		UI:HideWidget("VoteYes", "InGameNonTeam");
			UI:HideWidget("VoteNo", "InGameNonTeam");
				end
			end
		},

		VoteNo =
		{
			skin = UI.skins.BottomMenuButton,
			left = 620-160-160-100,
			width = 100,

			text = "Vote No",	

			tabstop = 5,	
			
			OnCommand = function(Sender)
				if (Client) then
					Client:Vote("no");
        		UI:HideWidget("VoteYes", "InGameNonTeam");
			UI:HideWidget("VoteNo", "InGameNonTeam");
				end
			end
		},

		
		OnActivate = function(Sender)
			Sender:PopulateChatTarget();
			
			if getglobal("gr_votetime") then
				if _time>tonumber(getglobal("gr_votetime")) then
					UI:HideWidget("VoteYes", "InGameNonTeam");
					UI:HideWidget("VoteNo", "InGameNonTeam");
				else
					UI:ShowWidget("VoteYes", "InGameNonTeam");
					UI:ShowWidget("VoteNo", "InGameNonTeam");
				end
			else 
					UI:HideWidget("VoteYes", "InGameNonTeam");
					UI:HideWidget("VoteNo", "InGameNonTeam");
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
			Sender:PopulateChatTarget(1);
		end,
	},
};

UI:AddChatbox(UI.PageInGameNonTeam.GUI, 200, 308, 580, 148, 24);

AddUISideMenu(UI.PageInGameNonTeam.GUI,
{
	{ "Disconnect", Localize("Disconnect"), "$Disconnect$", 0},
	{ "Options", Localize("Options"), "Options",},
      { "ServerAdmin", "Server Admin", "ServerAdmin",},
      { "VotePanel", "Vote Panel", "VotePanel",},

	{ "-", "-", "-", },	-- separator
	{ "Quit", "@Quit", UI.PageMainScreen.ShowConfirmation, },	
});

UI:CreateScreenFromTable("InGameNonTeam",UI.PageInGameNonTeam.GUI);