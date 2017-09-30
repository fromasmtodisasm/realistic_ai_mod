MessageModeScreen = 
{
	Static = 
	{
		classname = "static",
		rect = "110, 3, 80, 22",
		halign = UIALIGN_RIGHT,
		style = UISTYLE_DEFAULT + UISTYLE_TRANSPARENT,
		flags = UIFLAG_DEFAULT - UIFLAG_CANHAVEFOCUS,
	},
	
	Edit =
	{
		classname = "editbox",
		rect = "190, 3, 600, 22",
		style = UISTYLE_DEFAULT + UISTYLE_TRANSPARENT,
		
		maxlength = 64,
		
		tabstop = 1,
		
		OnCommand = function (Sender)

			if (Sender:GetName() == "Edit") then
			
				if (Sender.szCommand) then
				
					local szText = Sender:GetText();
					
					if (szText) then
					
						System:ExecuteCommand(Sender.szCommand.." "..szText);
						
					end
				
				end
				
				Sender:Clear();
				
				UI:DeactivateScreen("MessageModeScreen");
				
				Game:EnableUIOverlay(0, 0);
		
			end
		end,

		OnLostFocus = function (Sender)
			if (UI:IsScreenActive(Sender) == 1) then
				UI:SetFocus(Sender);
			end
		end
	},
}


function MessageModeScreen:OnInit()

	UI:DeactivateScreen("MessageModeScreen");
	
end


function MessageModeScreen:OnActivate()

	UI:DeactivateAllScreens();
	
	UI:HideBackground();
	UI:HideMouseCursor();
	
	Input:ResetKeyState();
end

function MessageModeScreen:OnDeactivate()

	local Edit = UI:GetWidget("Edit", "MessageModeScreen");
	
	Edit:SetText("");
	Game:EnableUIOverlay(0, 0);
	
	Input:ResetKeyState();
end

function Game:MessageMode2(szCommand)

	if (not ClientStuff) then return end;

	local bSpectator = 1;
	
	if (_localplayer and (_localplayer.entity_type ~= "spectator")) then bSpectator = nil; end;
	
	if (bSpectator or ((ClientStuff:ModeDesc() == "FFA") and	((szCommand == "sayteam") or (not szCommand) or strlen(szCommand) == 0))) then
		return
	else
		Game:MessageMode(szCommand, "sayteam");
	end	
end


function Game:MessageMode(szCommand, szAlternate)

	if (not Game:IsMultiplayer()) then
		return;
	end

	UI:ActivateScreen("MessageModeScreen");
	
	local Screen = UI:GetScreen("MessageModeScreen");
	local Edit = UI:GetWidget("Edit", "MessageModeScreen");
	local Static = UI:GetWidget("Static", "MessageModeScreen");
	
	if (szCommand) then
	
		if (szCommand == "sayteam") then
			Static:SetText("@CmdSayTeam ");	
		else
			Static:SetText(szCommand ..": ");
		end

		Edit.szCommand = szCommand;
		
	else
		if (szAlternate) then
		
			if (szAlternate == "sayteam") then
				Static:SetText("@CmdSayTeam ");	
			else
				Static:SetText(szAlternate ..": ");
			end
				
			Edit.szCommand = szAlternate;
			
		else
		
			Static:SetText("@CmdSay ");
			Edit.szCommand = "say";
		
		end
	end
	
	Game:EnableUIOverlay(1, 1);
end


UI:CreateScreenFromTable("MessageModeScreen", MessageModeScreen);	