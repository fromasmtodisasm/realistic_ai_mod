UI.PageWaitServer=
{
	GUI=
	{
		background=
		{
			classname = "static",
			left = 0, top = 0,
			width = 800, height = 600,
			
			color = UI.szMessageBoxScreenColor,
			
			zorder = 1500,	-- must be above all
		},
		
		
		border01=
		{
			skin = UI.skins.MenuBorder,
		
			left = 225, top = 175,
			width = 350, height = 250,
			
			color = UI.szMessageBoxColor,
			
			zorder = 1505,
			
			border02=
			{
				left = 0, top = 24,
				height = 8, width = 350,
				bordersides = "tb",
				color = "0 0 0 0",
				
				skin = UI.skins.MenuBorder,
			},
			
			border03=
			{
				left = 0, top = 250 - 8 - 24,
				height = 8, width = 350,
				bordersides = "tb",
				color = "0 0 0 0",
				
				skin = UI.skins.MenuBorder,
			},
			
			Title=
			{
				classname = "static",
				left = 1, top = 1,
				height = 23, width = 348,
				color = "0 0 0 0",
				
				halign = UIALIGN_CENTER,
				
				bordersize = 0,
				
				text = Localize("WaitingForServerTitle"),
			},

			Label=
			{
				classname = "static",
				left = 0, top = 24+8,
				width = 350, height = 250 - 25*2-8,
				color = "0 0 0 0",
				
				bordersize = 0,
				
				halign = UIALIGN_CENTER,
				valign = UIALIGN_MIDDLE,
				
				style = UISTYLE_MULTILINE + UISTYLE_WORDWRAP,
				
				text = Localize("WaitingForServerLabel"),

				zorder = 1510,
			}
		},

		Disconnect=
		{
			skin = UI.skins.TopMenuButton,
			
			left = 330, top = 175 + 250 - 25,
			width = 140, height = 25,
			
			text = Localize("Disconnect"),
			
			zorder = 1510,
			tabstop = 1,
			
			OnCommand = function(Sender)
			
				UI.QuitWaitServer();

				if (UI.PageWaitServer.OnDisconnect) then
					UI.PageWaitServer.OnDisconnect();
				else
					Game:ShowMenu();
					GotoPage("Disconnect", 0);
				end
			end
		},
	
		OnActivate = function(Sender)
			Input:ResetKeyState();
			UI:ShowMouseCursor();
			UI:SetFocusScreen(Sender);
			UI:EnableSwitch(0, 0);
			UI:FirstTabStop();
		end,

		OnDeactivate = function(Sender)

			UI:SetFocusScreen();
			Game:EnableUIOverlay(0, 0);

			UI.PageWaitServer.OnDisconnect = nil;
			UI:EnableSwitch(1);
		end,
	},
}

UI:CreateScreenFromTable("WaitServer", UI.PageWaitServer.GUI);


function UI.WaitServer(OnDisconnect)

	if (not Game:IsMultiplayer()) then
		return;
	end
	
	UI.PageWaitServer.OnDisconnect = OnDisconnect;

	if (not Game:IsInMenu()) then
		UI:HideBackground();
		UI:DeactivateAllScreens();
	end

	Game:EnableUIOverlay(1, 1);
	
	UI:ActivateScreen("WaitServer");
end

function UI.QuitWaitServer()

	UI:DeactivateScreen("WaitServer");
end