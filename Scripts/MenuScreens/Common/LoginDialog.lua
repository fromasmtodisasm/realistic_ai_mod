UI.PageLoginDialog=
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
			
			left = 225, top = 159,
			width = 350, height = 282,
			color = UI.szMessageBoxColor,
			
			zorder = 505,
			
			border02=
			{
				left = 0, top = 24,
				height = 8, width = 350,
				bordersides = "tb",
				color = "0 0 0 0",
				
				skin = UI.skins.MenuBorder,
			},
			
			Notice=
			{
				classname = "static",
				left = 10, top = 214,
				height = 32, width = 330,
				color = "0 0 0 0",
				
				halign = UIALIGN_LEFT,
				style = UISTYLE_MULTILINE + UISTYLE_WORDWRAP,
				
				bordersize = 0,
				text = "@GameXPWarning",
			},
			
			border03=
			{
				left = 0, top = 250,
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
			
			Message=
			{
				classname = "static",
				left = 10, top = 32,
				width = 330, height = 32,
				color = "0 0 0 0",
				
				bordersize = 0,
				zorder = 510,
			},
		

			NameLabel=
			{
				classname = "static",
				left = 10, top = 32 + 30,
				width = 330, height = 32,
				color = "0 0 0 0",
				
				bordersize = 0,
				text = Localize("LoginName"),

				zorder = 510,
			},

			Name=
			{
				skin = UI.skins.EditBox,
							
				left = 10, top = 32 + 60,
				width = 330, height = 28,
				
				tabstop = 1,
				
				OnCommand = function(Sender)
					UI.PageLoginDialog.GUI.Ok.OnCommand(UI.PageLoginDialog.GUI.Ok);
				end,				
			},			

			PasswordLabel=
			{
				classname = "static",
				left = 10, top = 32 + 86,
				width = 330, height = 32,
				color = "0 0 0 0",
				
				text = Localize("LoginPassword"),
				
				bordersize = 0,												
				zorder = 510,
			},

			Password=
			{
				skin = UI.skins.EditBox,
				
				left = 10, top = 32 + 116,
				width = 330, height = 28,
				
				style = UISTYLE_PASSWORD,
				
				tabstop = 2,
				
				OnCommand = function(Sender)
					UI.PageLoginDialog.GUI.Ok.OnCommand(UI.PageLoginDialog.GUI.Ok);
				end,					
			},
			
		},
			
		Create=
		{
			skin = UI.skins.TopMenuButton,
			
			left = 340, top = 175 + 241,
			width = 120, height = 25,

			text = Localize("CreateAccount"),
			
			tabstop = 6,

			zorder = 510,
			
			OnCommand = function(Sender)
				if (UI.PageLoginDialog.szCreateAccountURL) then
					System:BrowseURL(UI.PageLoginDialog.szCreateAccountURL);
				end			
			end
		},

		Ok=
		{
			skin = UI.skins.TopMenuButton,
			
			left = 225, top = 175 + 241,
			width = 100, height = 25,

			text = Localize("Ok"),
			
			tabstop = 3,

			zorder = 510,

			OnCommand = function(Sender)
				
				if (UI.PageLoginDialog.OnOk) then
					local GUI = UI.PageLoginDialog.GUI.border01;
					if (UI.PageLoginDialog.OnOk(GUI.Name:GetText(), GUI.Password:GetText())) then
						UI:DeactivateScreen("LoginDialog");
					end
				else
					UI:DeactivateScreen("LoginDialog");
				end
			end
		},
		
		Cancel=
		{
			skin = UI.skins.TopMenuButton,
			
			left = 225 + 350 - 100, top = 175 + 241,
			width = 100, height = 25,
			
			text = Localize("Cancel"),
			
			tabstop = 4,
			
			zorder = 510,

			OnCommand = function(Sender)

				if (UI.PageLoginDialog.OnCancel) then
					local GUI = UI.PageLoginDialog.GUI.border01;
					if (UI.PageLoginDialog.OnCancel(GUI.Name:GetText(), GUI.Password:GetText())) then
						UI:DeactivateScreen("LoginDialog");
					end
				else
					UI:DeactivateScreen("LoginDialog");
				end
			end
		},
		
		OnActivate = function(Sender)
		
			UI:ShowMouseCursor();
			UI:SetFocusScreen(Sender);
			UI:EnableSwitch(0, 0);
			UI:FirstTabStop();
		
			if (UI.PageLoginDialog.szTitleText) then
				Sender.border01.Title:SetText(UI.PageLoginDialog.szTitleText);
				UI.PageLoginDialog.szTitleText = nil;
			else
				Sender.border01.Title:SetText("");
			end
			
			if (UI.PageLoginDialog.szMessage) then
				Sender.border01.Message:SetText(UI.PageLoginDialog.szMessage);
				UI.PageLoginDialog.szMessage = nil;
			else
				Sender.border01.Message:SetText("");
			end
			
			if (UI.PageLoginDialog.szInitialName) then
				Sender.border01.Name:SetText(UI.PageLoginDialog.szInitialName);
			else
				Sender.border01.Name:SetText("");
			end

			if (UI.PageLoginDialog.szInitialPassword) then
				Sender.border01.Password:SetText(UI.PageLoginDialog.szInitialPassword);
			else
				Sender.border01.Password:SetText("");
			end
			
			if (UI.PageLoginDialog.szCreateAccountURL and strlen(UI.PageLoginDialog.szCreateAccountURL) > 0) then
				UI:ShowWidget(Sender.Create);
			else
				UI:HideWidget(Sender.Create);
			end
			
		end,
		
		OnDeactivate = function(Sender)
			UI:SetFocusScreen();
			UI:EnableSwitch(1);
		end,
	}
}

UI:CreateScreenFromTable("LoginDialog", UI.PageLoginDialog.GUI);


-----------------------------------------------------------------------
function UI.LoginBox(Title, Message, InitialName, InitialPassword, CreateAccountURL, OnOkProc, OnCancelProc)

	UI.PageLoginDialog.szTitleText = Title;
	UI.PageLoginDialog.szMessage = Message;
	UI.PageLoginDialog.szInitialName = InitialName;
	UI.PageLoginDialog.szInitialPassword = InitialPassword;
	UI.PageLoginDialog.OnOk = OnOkProc;
	UI.PageLoginDialog.OnCancel = OnCancelProc;
	UI.PageLoginDialog.szCreateAccountURL = CreateAccountURL;	
	
	UI:ActivateScreen("LoginDialog");	
end