	UI.PageInputDialog=
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
			},

			Label=
			{
				classname = "static",
				left = 10, top = 32 + 40,
				width = 330, height = 32,
				color = "0 0 0 0",
				
				bordersize = 0,
								
				style = UISTYLE_MULTILINE + UISTYLE_WORDWRAP,

				zorder = 510,
			},

			EditBox=
			{
				skin = UI.skins.EditBox,
				
				left = 10, top = 32+ 78,
				width = 330, height = 28,
				
				tabstop = 1,
				
				OnCommand = function(Sender)
					UI.PageInputDialog.GUI.Ok.OnCommand(UI.PageInputDialog.GUI.Ok);
				end,
			},			
		},
			
		Ok=
		{
			skin = UI.skins.TopMenuButton,
			
			left = 225, top = 175 + 250 - 25,
			width = 100, height = 25,
			
			text = Localize("Ok"),
			
			tabstop = 2,
			
			zorder = 510,
			
			OnCommand = function(Sender)
				if (UI.PageInputDialog.OnOk) then
					if (UI.PageInputDialog.OnOk(UI.PageInputDialog.GUI.border01.EditBox:GetText())) then
						UI:DeactivateScreen("InputDialog");
					end
				else
					UI:DeactivateScreen("InputDialog");
				end
			end
		},
		
		Cancel=
		{
			skin = UI.skins.TopMenuButton,
			
			left = 225 + 350 - 100, top = 175 + 250 - 25,
			width = 100, height = 25,
			
			text = Localize("Cancel"),
			
			zorder = 510,
			
			tabstop = 3,

			OnCommand = function(Sender)
				if (UI.PageInputDialog.OnCancel) then
					if (UI.PageInputDialog.OnCancel(UI.PageInputDialog.GUI.border01.EditBox:GetText())) then
						UI:DeactivateScreen("InputDialog");
					end
				else
					UI:DeactivateScreen("InputDialog");
				end
			end
		},
		
		OnActivate = function(Sender)
		
			UI:ShowMouseCursor();
			UI:SetFocusScreen(Sender);
			UI:EnableSwitch(0, 0);
			UI:FirstTabStop();
			
			if (UI.PageInputDialog.szTitleText) then
				Sender.border01.Title:SetText(UI.PageInputDialog.szTitleText);
				UI.PageInputDialog.szTitleText = nil;
			else
				Sender.border01.Title:SetText("");
			end
			
			if (UI.PageInputDialog.szMessage) then
				Sender.border01.Label:SetText(UI.PageInputDialog.szMessage);
				UI.PageInputDialog.szMessage = nil;
			else
				Sender.border01.Label:SetText("");
			end
			
			if (UI.PageInputDialog.szInitialText) then
				Sender.border01.EditBox:SetText(UI.PageInputDialog.szInitialText);
			else
				Sender.border01.EditBox:SetText("");
			end
			
			Sender.border01.EditBox.OnCommand = Sender.Ok.OnCommand;
		end,
		
		OnDeactivate = function(Sender)
			UI:SetFocusScreen();
			UI:EnableSwitch(1);
		end,
	
	}
}

UI:CreateScreenFromTable("InputDialog", UI.PageInputDialog.GUI);


-----------------------------------------------------------------------
function UI.InputBox(Title, Message, InitialText, OnOkProc, OnCancelProc)
	UI.InputBoxEx(Title, Message, InitialText, nil, nil, nil, nil, 0, OnOkProc, OnCancelProc)
end

function UI.InputBoxEx(Title, Message, InitialText, bNumberic, bPathSafe, bNameSafe, bPassword, iMaxLength, OnOkProc, OnCancelProc)

	UI.PageInputDialog.szTitleText = Title;
	UI.PageInputDialog.szMessage = Message;
	UI.PageInputDialog.szInitialText = InitialText;
	UI.PageInputDialog.OnOk = OnOkProc;
	UI.PageInputDialog.OnCancel = OnCancelProc;
	
	if (bNumeric and tonumber(bNumeric) ~= 0) then
		UI.PageInputDialog.GUI.border01.EditBox:SetNumeric(1);
	elseif (bNumeric) then
		UI.PageInputDialog.GUI.border01.EditBox:SetNumeric(0);
	end

	if (bPathSafe and tonumber(bPathSafe) ~= 0) then
		UI.PageInputDialog.GUI.border01.EditBox:SetPathSafe(1);
	elseif (bPathSafe) then
		UI.PageInputDialog.GUI.border01.EditBox:SetPathSafe(0);
	end

	if (bNameSafe and tonumber(bNameSafe) ~= 0) then
		UI.PageInputDialog.GUI.border01.EditBox:SetNameSafe(1);
	elseif (bNameSafe) then
		UI.PageInputDialog.GUI.border01.EditBox:SetNameSafe(0);
	end

	if (bPassword and tonumber(bPassword) ~= 0) then
		UI.PageInputDialog.GUI.border01.EditBox:SetPassword(1);
	elseif (bPassword) then
		UI.PageInputDialog.GUI.border01.EditBox:SetPassword(0);
	end

	if (iMaxLength) then
		UI.PageInputDialog.GUI.border01.EditBox:SetMaxLength(iMaxLength);
	end
		
	UI:ActivateScreen("InputDialog");	
end