UI.PageProgressDialog=
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
				color = "0 0 0 0",
				bordersides = "tb",
				
				skin = UI.skins.MenuBorder,
			},
			
			border03=
			{
				left = 0, top = 250 - 8 - 24,
				height = 8, width = 350,
				color = "0 0 0 0",
				bordersides = "tb",
				
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
		
		Cancel=
		{
			skin = UI.skins.TopMenuButton,
			flags = UIFLAG_DEFAULT,
			
			left = 350, top = 175 + 250 - 25,
			width = 100, height = 25,
			
			text = Localize("Cancel"),
			
			zorder = 510,
			
			tabstop = 1,
			
			OnCommand = function(Sender)
				UI:DeactivateScreen("ProgressDialog");

				if (UI.PageProgressDialog.OnCancel) then
					UI.PageProgressDialog.OnCancel();
				end
			end
		},
		
		OnActivate = function(Sender)
			
			UI:ShowMouseCursor();
			UI:SetFocusScreen(Sender);
			UI:EnableSwitch(0, 0);
			UI:FirstTabStop();
			
			if (UI.PageProgressDialog.szTitleText) then
				Sender.border01.Title:SetText(UI.PageProgressDialog.szTitleText);
				UI.PageProgressDialog.szTitleText = nil;
			else
				Sender.border01.Title:SetText("");
			end
			
			if (UI.PageProgressDialog.szMessage) then
				Sender.border01.Label:SetText(UI.PageProgressDialog.szMessage);
				UI.PageProgressDialog.szMessage = nil;
			else
				Sender.border01.Label:SetText("");
			end
		end,
		
		OnDeactivate = function(Sender)
			UI:SetFocusScreen();
			UI:EnableSwitch(1);
		end
	}
}

UI:CreateScreenFromTable("ProgressDialog", UI.PageProgressDialog.GUI);


-----------------------------------------------------------------------
function UI.ProgressBox(Title, Message, OnCancelProc)

	UI.PageProgressDialog.szTitleText = Title;
	UI.PageProgressDialog.szMessage = Message;
	UI.PageProgressDialog.OnCancel = OnCancelProc;
	
	UI:ActivateScreen("ProgressDialog");
end

function UI.ProgressBoxDone()
	UI:DeactivateScreen("ProgressDialog");
	UI.PageProgressDialog.szTitleText = nil;
	UI.PageProgressDialog.szMessage = nil;
	UI.PageProgressDialog.OnCancel = nil;
end

function UI.InProgress()
	local bInProgress = UI:IsScreenActive("ProgressDialog");
	
	if (bInProgress and (bInProgress ~= 0)) then
		return 1;
	else
		return nil;
	end
end