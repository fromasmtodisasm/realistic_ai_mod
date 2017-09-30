UI.PageJoinIPDialog=
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
			
			left = 250, top = 159,
			width = 300, height = 282,
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
			
--			Notice=
--			{
--				classname = "static",
--				left = 10, top = 214,
--				height = 32, width = 330,
--				color = "0 0 0 0",
				
--				halign = UIALIGN_LEFT,
--				style = UISTYLE_MULTILINE + UISTYLE_WORDWRAP,
				
--				bordersize = 0,
--				text = "@GameXPWarning",
--			},
			
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
				height = 23, width = 298,
				color = "0 0 0 0",
				
				halign = UIALIGN_CENTER,
				
				bordersize = 0,
			},
			
			Message=
			{
				classname = "static",
				left = 20, top = 32,
				width = 330, height = 32,
				color = "0 0 0 0",
				
				bordersize = 0,
				zorder = 510,
			},
		

			IPLabel=
			{
				classname = "static",
				left = 20, top = 32 + 30,
				width = 30, height = 32,
				color = "0 0 0 0",
				
				bordersize = 0,
				text = Localize("IP"),

				zorder = 510,
			},

			PortLabel=
			{
				classname = "static",
				left = 180, top = 32 + 30,
				width = 30, height = 32,
				color = "0 0 0 0",
				
				bordersize = 0,
				text = "Port",

				zorder = 510,
			},

			IP1=
			{
				skin = UI.skins.EditBox,
							
				left = 20, top = 32 + 60,
				width = 30, height = 28,
				
				tabstop = 1,
				
				OnCommand = function(Sender)
--					UI.PageJoinIPDialog.GUI.Ok.OnCommand(UI.PageJoinIPDialog.GUI.Ok);
				end,				
			},			

			Period1=
			{
				classname = "static",
				left = 55, top = 32 + 60,
				width = 5, height = 32,
				color = "0 0 0 0",
				
				bordersize = 0,
				text = ".",

				zorder = 510,
			},

			IP2=
			{
				skin = UI.skins.EditBox,
							
				left = 60, top = 32 + 60,
				width = 30, height = 28,
				
				tabstop = 2,
				
				OnCommand = function(Sender)
--					UI.PageJoinIPDialog.GUI.Ok.OnCommand(UI.PageJoinIPDialog.GUI.Ok);
				end,				
			},			

			Period2=
			{
				classname = "static",
				left = 95, top = 32 + 60,
				width = 5, height = 32,
				color = "0 0 0 0",
				
				bordersize = 0,
				text = ".",

				zorder = 510,
			},

			IP3=
			{
				skin = UI.skins.EditBox,
							
				left = 100, top = 32 + 60,
				width = 30, height = 28,
				
				tabstop = 3,
				
				OnCommand = function(Sender)
--					UI.PageJoinIPDialog.GUI.Ok.OnCommand(UI.PageJoinIPDialog.GUI.Ok);
				end,				
			},			

			Period3=
			{
				classname = "static",
				left = 135, top = 32 + 60,
				width = 5, height = 32,
				color = "0 0 0 0",
				
				bordersize = 0,
				text = ".",

				zorder = 510,
			},

			IP4=
			{
				skin = UI.skins.EditBox,
							
				left = 140, top = 32 + 60,
				width = 30, height = 28,
				
				tabstop = 4,
				
				OnCommand = function(Sender)
--					UI.PageJoinIPDialog.GUI.Ok.OnCommand(UI.PageJoinIPDialog.GUI.Ok);
				end,				
			},			

			Colon1=
			{
				classname = "static",
				left = 175, top = 32 + 60,
				width = 5, height = 32,
				color = "0 0 0 0",
				
				bordersize = 0,
				text = ":",

				zorder = 510,
			},

			Port=
			{
				skin = UI.skins.EditBox,
							
				left = 180, top = 32 + 60,
				width = 40, height = 28,
				
				tabstop = 5,
				
				OnCommand = function(Sender)
--					UI.PageJoinIPDialog.GUI.Ok.OnCommand(UI.PageJoinIPDialog.GUI.Ok);
				end,				
			},			

--			PasswordLabel=
--			{
--				classname = "static",
--				left = 10, top = 32 + 86,
--				width = 330, height = 32,
--				color = "0 0 0 0",
				
--				text = Localize("LoginPassword"),
				
--				bordersize = 0,												
--				zorder = 510,
--			},

--			Password=
--			{
--				skin = UI.skins.EditBox,
				
--				left = 10, top = 32 + 116,
--				width = 330, height = 28,
				
--				style = UISTYLE_PASSWORD,
				
--				tabstop = 2,
				
--				OnCommand = function(Sender)
--					UI.PageJoinIPDialog.GUI.Ok.OnCommand(UI.PageJoinIPDialog.GUI.Ok);
--				end,					
--			},
			
		},
			
--		Create=
--		{
--			skin = UI.skins.TopMenuButton,
			
--			left = 340, top = 175 + 241,
--			width = 120, height = 25,

--			text = Localize("CreateAccount"),
			
--			tabstop = 6,

--			zorder = 510,
			
--			OnCommand = function(Sender)
--				if (UI.PageJoinIPDialog.szCreateAccountURL) then
--					System:BrowseURL(UI.PageJoinIPDialog.szCreateAccountURL);
--				end			
--			end
--		},

		Ok=
		{
			skin = UI.skins.TopMenuButton,
			
			left = 250, top = 175 + 241,
			width = 100, height = 25,

			text = Localize("Ok"),
			
			tabstop = 6,

			zorder = 510,

			OnCommand = function(Sender)
				
				if (UI.PageJoinIPDialog.OnOk) then
					local GUI = UI.PageJoinIPDialog.GUI.border01;
					if (UI.PageJoinIPDialog.OnOk(GUI.IP1:GetText(), GUI.IP2:GetText(), GUI.IP3:GetText(), GUI.IP4:GetText(), GUI.Port:GetText())) then
						UI:DeactivateScreen("JoinIPDialog");
					end
				else
					UI:DeactivateScreen("JoinIPDialog");
				end
			end
		},
		
		Cancel=
		{
			skin = UI.skins.TopMenuButton,
			
			left = 225 + 325 - 100, top = 175 + 241,
			width = 100, height = 25,
			
			text = Localize("Cancel"),
			
			tabstop = 7,
			
			zorder = 510,

			OnCommand = function(Sender)

				if (UI.PageJoinIPDialog.OnCancel) then
					local GUI = UI.PageJoinIPDialog.GUI.border01;
					if (UI.PageJoinIPDialog.OnCancel(GUI.IP1:GetText(), GUI.IP2:GetText(), GUI.IP3:GetText(), GUI.IP4:GetText(), GUI.Port:GetText())) then
						UI:DeactivateScreen("JoinIPDialog");
					end
				else
					UI:DeactivateScreen("JoinIPDialog");
				end
			end
		},
		
		OnActivate = function(Sender)
		
			UI:ShowMouseCursor();
			UI:SetFocusScreen(Sender);
			UI:EnableSwitch(0, 0);
			UI:FirstTabStop();
		
			if (UI.PageJoinIPDialog.szTitleText) then
				Sender.border01.Title:SetText(UI.PageJoinIPDialog.szTitleText);
				UI.PageJoinIPDialog.szTitleText = nil;
			else
				Sender.border01.Title:SetText("");
			end
			
			if (UI.PageJoinIPDialog.szMessage) then
				Sender.border01.Message:SetText(UI.PageJoinIPDialog.szMessage);
				UI.PageJoinIPDialog.szMessage = nil;
			else
				Sender.border01.Message:SetText("");
			end
			
--			if (UI.PageJoinIPDialog.szInitialName) then
--				Sender.border01.Name:SetText(UI.PageJoinIPDialog.szInitialName);
--			else
--				Sender.border01.Name:SetText("");
--			end

--			if (UI.PageJoinIPDialog.szInitialPassword) then
--				Sender.border01.Password:SetText(UI.PageJoinIPDialog.szInitialPassword);
--			else
--				Sender.border01.Password:SetText("");
--			end
			
--			if (UI.PageJoinIPDialog.szCreateAccountURL and strlen(UI.PageJoinIPDialog.szCreateAccountURL) > 0) then
--				UI:ShowWidget(Sender.Create);
--			else
--				UI:HideWidget(Sender.Create);
--			end
			
		end,
		
		OnDeactivate = function(Sender)
			UI:SetFocusScreen();
			UI:EnableSwitch(1);
		end,
	}
}

UI:CreateScreenFromTable("JoinIPDialog", UI.PageJoinIPDialog.GUI);


-----------------------------------------------------------------------
function UI.JoinIPBox(Title, Message, OnOkProc, OnCancelProc)

	UI.PageJoinIPDialog.szTitleText = Title;
	UI.PageJoinIPDialog.szMessage = Message;
--	UI.PageJoinIPDialog.szInitialName = InitialName;
--	UI.PageJoinIPDialog.szInitialPassword = InitialPassword;
	UI.PageJoinIPDialog.OnOk = OnOkProc;
	UI.PageJoinIPDialog.OnCancel = OnCancelProc;
--	UI.PageJoinIPDialog.szCreateAccountURL = CreateAccountURL;	
	
	UI:ActivateScreen("JoinIPDialog");	
end