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
		
		OnActivate = function(Sender)
			Sender:PopulateChatTarget();
			
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

UI:AddChatbox(UI.PageInGameTeam.GUI, 200, 312, 580, 144, 24, 1);

AddUISideMenu(UI.PageInGameTeam.GUI,
{
	{ "Disconnect", Localize("Disconnect"), "$Disconnect$", 0},
	{ "Options", Localize("Options"), "Options", },

	{ "-", "-", "-", },	-- separator
	{ "Quit", "@Quit", UI.PageMainScreen.ShowConfirmation, },	
});

UI:CreateScreenFromTable("InGameTeam",UI.PageInGameTeam.GUI);