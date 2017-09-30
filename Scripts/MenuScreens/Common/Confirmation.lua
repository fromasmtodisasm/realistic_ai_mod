UI.PageConfirmation=
{
	GUI=
	{
		background=
		{
			classname = "static",
			left = 0, top = 0,
			width = 800, height = 600,
			
			color = UI.szMessageBoxScreenColor,
			
			zorder = 500,	-- must be above all
		},
				
		border01=
		{
			skin = UI.skins.MenuBorder,
		
			left = 225, top = 175,
			width = 350, height = 250,
			color = UI.szMessageBoxColor,
			
			zorder = 505,
			
			border02=
			{
				left = 0, top = 24,
				height = 8, width = 350,
				bordersides = "tb",
				
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

				zorder = 510,
			}
		},
			
		Yes=
		{
			skin = UI.skins.TopMenuButton,
			
			left = 225, top = 175 + 250 - 25,
			width = 100, height = 25,
			
			text = Localize("Yes"),
			
			tabstop = 1,
			
			zorder = 510,
			
			OnCommand = function(Sender)
				UI:DeactivateScreen("ConfirmationDialog");

				if (UI.PageConfirmation.OnYes) then
					UI.PageConfirmation.OnYes();
				end
			end
		},
		
		No=
		{
			skin = UI.skins.TopMenuButton,
			
			left = 225 + 350 - 100, top = 175 + 250 - 25,
			width = 100, height = 25,
			
			text = Localize("No"),
			
			tabstop = 2,
			
			zorder = 510,

			OnCommand = function(Sender)
				UI:DeactivateScreen("ConfirmationDialog");

				if (UI.PageConfirmation.OnNo) then
					UI.PageConfirmation.OnNo();
				end
			end
		},
		
		OnActivate = function(Sender)
			
			UI:ShowMouseCursor();
			UI:SetFocusScreen(Sender);
			UI:EnableSwitch(0, 0);
			UI:FirstTabStop();
			
			if (UI.PageConfirmation.szTitleText) then
				Sender.border01.Title:SetText(UI.PageConfirmation.szTitleText);
				UI.PageConfirmation.szTitleText = nil;
			else
				Sender.border01.Title:SetText("");
			end
			
			if (UI.PageConfirmation.szMessage) then
				Sender.border01.Label:SetText(UI.PageConfirmation.szMessage);
				UI.PageConfirmation.szMessage = nil;
			else
				Sender.border01.Label:SetText("");
			end
		end,
		
		OnDeactivate = function(Sender)
			UI:SetFocusScreen();
			UI:EnableSwitch(1);
		end,
	}
}

UI:CreateScreenFromTable("ConfirmationDialog", UI.PageConfirmation.GUI);


-----------------------------------------------------------------------
function UI.YesNoBox(Title, Message, OnYesProc, OnNoProc)

	UI.PageConfirmation.szTitleText = Title;
	UI.PageConfirmation.szMessage = Message;
	UI.PageConfirmation.OnYes = OnYesProc;
	UI.PageConfirmation.OnNo = OnNoProc;
	
	UI:ActivateScreen("ConfirmationDialog");	
end