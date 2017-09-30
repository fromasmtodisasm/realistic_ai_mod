--
-- options menu page
--
function FormatName(szName)
	local c = strsub(szName, 1, 1);
	local szResult = strupper(c)..strsub(szName, 2);

	return szResult;
end


UI.PageCampaign=
{	
	GUI=
	{
		StartNewGameTab=
		{
			text = Localize("StartNewGame"),
			skin = UI.skins.TopMenuButton,
			
			greyedcolor = UI.szTabAdditiveColor,
			greyedblend = UIBLEND_ADDITIVE,
			
			tabstop = 1,
			
			OnCommand = function(Sender)
				UI.iStat = nil;
				UI:DeactivateScreen("CampaignLoad");
				UI:ActivateScreen("CampaignStart");
				UI:DisableWidget("StartNewGameTab", "Campaign");
				UI:EnableWidget("LoadSavedGameTab", "Campaign");
				UI:EnableWidget("StatTab", "Campaign");
				UI.PageCampaignStart.GUI:OnActivate();
				
				UI.PageCampaign.GUI.StartNewGameTab.skin.OnLostFocus(UI.PageCampaign.GUI.StartNewGameTab);
				UI.PageCampaign.GUI.LoadSavedGameTab.skin.OnLostFocus(UI.PageCampaign.GUI.LoadSavedGameTab);
				UI.PageCampaign.GUI.StatTab.skin.OnLostFocus(UI.PageCampaign.GUI.StatTab);
			end
		},

		LoadSavedGameTab=
		{
			tabstop = 2,
			
			text = Localize("LoadSavedGame"),
			left = 379,
			skin = UI.skins.TopMenuButton,
			
			greyedcolor = UI.szTabAdditiveColor,
			greyedblend = UIBLEND_ADDITIVE,
			
			OnCommand = function()
				UI.iStat = nil;
				UI:DisableWidget("LoadSavedGameTab", "Campaign");
				UI:EnableWidget("StartNewGameTab", "Campaign");
				UI:EnableWidget("StatTab", "Campaign");
				UI:DeactivateScreen("CampaignStart");
				UI:ActivateScreen("CampaignLoad");

				UI.PageCampaign.GUI.StartNewGameTab.skin.OnLostFocus(UI.PageCampaign.GUI.StartNewGameTab);
				UI.PageCampaign.GUI.LoadSavedGameTab.skin.OnLostFocus(UI.PageCampaign.GUI.LoadSavedGameTab);
				UI.PageCampaign.GUI.StatTab.skin.OnLostFocus(UI.PageCampaign.GUI.StatTab);
			end
		},
		
		StatTab=
		{
			tabstop = 3,
			
			text = Localize("StatStatsMode"),
			left = 558,
			skin = UI.skins.TopMenuButton,
			
			greyedcolor = UI.szTabAdditiveColor,
			greyedblend = UIBLEND_ADDITIVE,
			
			OnCommand = function()
				UI.iStat = 1;
				UI:DisableWidget("StatTab", "Campaign");
				UI:EnableWidget("StartNewGameTab", "Campaign");
				UI:EnableWidget("LoadSavedGameTab", "Campaign");
				UI:ActivateScreen("CampaignStart");
				UI:DeactivateScreen("CampaignLoad");
				UI.PageCampaignStart.GUI:OnActivate();

				UI.PageCampaign.GUI.StartNewGameTab.skin.OnLostFocus(UI.PageCampaign.GUI.StartNewGameTab);
				UI.PageCampaign.GUI.LoadSavedGameTab.skin.OnLostFocus(UI.PageCampaign.GUI.LoadSavedGameTab);				
				UI.PageCampaign.GUI.StatTab.skin.OnLostFocus(UI.PageCampaign.GUI.StatTab);
			end
		},
		
		OnInit = function(Sender)
			Game:CreateVariable("ai_autobalance", "0");
		end,	
					
		OnActivate= function(Sender)
			Sender.StartNewGameTab.OnCommand(Sender.StartNewGameTab);
			if (tonumber(g_timezone) == tonumber(__tz1)) then UI:ShowWidget(Sender.StatTab);
			else UI:HideWidget(Sender.StatTab); end
		end,
	},
};


UI.PageCampaignStart=
{	
	GUI=
	{
		Easy=
		{
			skin = UI.skins.CheckBox,
			left = 400, top = 157,
			width = 180, height = 32,
			
			text = Localize("Easy"),
			
			tabstop = 3,
		},
		Medium=
		{
			skin = UI.skins.CheckBox,
			left = 400, top = 197,
			width = 180, height = 32,
			
			text = Localize("Medium"),
			
			tabstop = 11,
		},
		Challenging=
		{
			skin = UI.skins.CheckBox,
			left = 400, top = 237,
			width = 180, height = 32,
			
			text = Localize("Challenging"),
			
			tabstop = 12,
		},

		Veteran=
		{
			skin = UI.skins.CheckBox,
			left = 400, top = 277,
			width = 180, height = 32,
			
			text = Localize("Veteran"),
			
			tabstop = 13,
		},

		Realistic=
		{
			skin = UI.skins.CheckBox,
			left = 400, top = 317,
			width = 180, height = 32,
			
			text = Localize("Realistic"),
			
			tabstop = 14,
		},
		
		DiffInfo=
		{
			classname = "static",
			
			halign = UIALIGN_CENTER,
			valign = UIALIGN_MIDDLE,
			
			flags = UIFLAG_VISIBLE,
			greyedcolor = "0 0 0 0",
			
			bordersize = 1,
			bordercolor = UI.szBorderColor,
			
			color = "0 0 0 255",
			style = UISTYLE_WORDWRAP + UISTYLE_MULTILINE,
			
			left = 250, top = 394,
			width = 480, height = 56,
		},
		
		AutoBalanceLabel=
		{
			skin = UI.skins.Label,

			left = 580-UI.skins.CheckBox.width-120, top = 357,
			width = 112,

			text=Localize("AIAutoBalance"),
		},
		
		AutoBalance=
		{
			skin = UI.skins.CheckBox,
			left = 580-UI.skins.CheckBox.width, top = 357,
			
			tabstop = 15,
						
			OnChanged = function(self)
				if (self:GetChecked()) then
					setglobal("ai_autobalance", 1);
				else
					setglobal("ai_autobalance", 0);
				end
			end,
		},
		
		
		LevelLabel=
		{
			skin = UI.skins.MenuBorder,
			left = 588, top = 147,
			width = 184, height = 28,
			
			bordersides = "tlr",
			
			halign = UIALIGN_CENTER,
			
			text = Localize("Level");
		},

		MapList=
		{
			skin = UI.skins.ListView,
			left = 588, top = 174,
			width = 184, height = 214,
			
			tabstop = 16,
			
			zorder = 10,
			
			vscrollbar=
			{
				skin = UI.skins.VScrollBar,
			},
			
			hscrollbar=
			{
				skin = UI.skins.HScrollBar,
			},
			
			OnCommand = function(Sender)
				local iLevel = Sender:GetSelection(0);
				
				if (iLevel) then
				
					local Table = UI.PageCampaignStart.DefiantTable[iLevel];
					
					local szLevel = Table[1];
					local szMission = Table[2];
					
					if (szLevel and strlen(szLevel)) then
						UI.PageCampaignStart.szLevelName = szLevel.." "..szMission;
						
						if (UI:WillTerminate()) then
							UI.YesNoBox(Localize("TerminateCurrentGame"), Localize("TerminateCurrentGameLabel"), UI.PageCampaignStart.StartGame);
						else
							UI.PageCampaignStart.StartGame();
						end
					end
				end
			end,
		},
		
		StartGame=
		{
			text=Localize("Start"),
			left = 600,
			skin = UI.skins.BottomMenuButton,
			
			tabstop = 17,
			
			OnCommand=function(Sender)
				UI.PageCampaignStart.szLevelName = "Training Training";		-- is used by YesNoBox command

				if UI:IsWidgetVisible(UI.PageCampaignStart.GUI.MapList) and UI.PageCampaignStart.GUI.MapList:GetSelection(0) then
					UI.PageCampaignStart.GUI.MapList.OnCommand(UI.PageCampaignStart.GUI.MapList);
				else
					if (UI:WillTerminate()) then
						UI.YesNoBox(Localize("TerminateCurrentGame"), Localize("TerminateCurrentGameLabel"), UI.PageCampaignStart.StartGame);
					else
						UI.PageCampaignStart.StartGame();
					end
				end
			end,
		},
		
		OnActivate = function(Sender)
		
			if (UI.iStat or (System:IsDevModeEnable() == 1)) then
				UI:ShowWidget(UI.PageCampaignStart.GUI.MapList);
				UI:ShowWidget(UI.PageCampaignStart.GUI.LevelLabel);
			else
				UI:HideWidget(UI.PageCampaignStart.GUI.MapList);
				UI:HideWidget(UI.PageCampaignStart.GUI.LevelLabel);
			end
			
			-- TEMPORARY
			-- TEMPORARY
			UI.PageCampaignStart.GUI.MapList:Clear();			
			UI.PageCampaignStart.DefiantTable = {};
			
			for i, Table in DEFIANT do
				UI.PageCampaignStart.DefiantTable[UI.PageCampaignStart.GUI.MapList:AddItem("@Level"..Table[1])] = Table;
			end

			UI.PageCampaignStart.GUI.Easy.OnChanged = UI.PageCampaignStart.DifficultyChanged;
			UI.PageCampaignStart.GUI.Medium.OnChanged = UI.PageCampaignStart.DifficultyChanged;
			UI.PageCampaignStart.GUI.Challenging.OnChanged = UI.PageCampaignStart.DifficultyChanged;
			UI.PageCampaignStart.GUI.Veteran.OnChanged = UI.PageCampaignStart.DifficultyChanged;
			UI.PageCampaignStart.GUI.Realistic.OnChanged = UI.PageCampaignStart.DifficultyChanged;

			UI.PageCampaignStart.GUI.Easy:SetChecked(0);
			UI.PageCampaignStart.GUI.Medium:SetChecked(0);
			UI.PageCampaignStart.GUI.Challenging:SetChecked(0);
			UI.PageCampaignStart.GUI.Veteran:SetChecked(0);
			UI.PageCampaignStart.GUI.Realistic:SetChecked(0);

			UI.PageCampaignStart.iDifficultyLevel = 1;

			if getglobal("game_DifficultyLevel") then
				UI.PageCampaignStart.iDifficultyLevel = getglobal("game_DifficultyLevel");
			end

			if (tonumber(UI.PageCampaignStart.iDifficultyLevel) == 0) then
				UI.PageCampaignStart.GUI.Easy:SetChecked(1);
				UI.PageCampaignStart.GUI.Easy:OnChanged();
			elseif (tonumber(UI.PageCampaignStart.iDifficultyLevel) == 1) then
				UI.PageCampaignStart.GUI.Medium:SetChecked(1);
				UI.PageCampaignStart.GUI.Medium:OnChanged();
			elseif (tonumber(UI.PageCampaignStart.iDifficultyLevel) == 2) then
				UI.PageCampaignStart.GUI.Challenging:SetChecked(1);
				UI.PageCampaignStart.GUI.Challenging:OnChanged();
			elseif (tonumber(UI.PageCampaignStart.iDifficultyLevel) == 3) then
				UI.PageCampaignStart.GUI.Veteran:SetChecked(1);
				UI.PageCampaignStart.GUI.Veteran:OnChanged();
			else
				UI.PageCampaignStart.GUI.Realistic:SetChecked(1);
				UI.PageCampaignStart.GUI.Realistic:OnChanged();
			end
			
			if (tonumber(getglobal("ai_autobalance")) ~= 0) then
				UI.PageCampaignStart.GUI.AutoBalance:SetChecked(1);
			else
				UI.PageCampaignStart.GUI.AutoBalance:SetChecked(0);
			end
		end
	},
	
	StartGame = function()
		UI:TerminateGame();
		
		if (UI.PageCampaignStart.szLevelName) then
		
			local SaveList = Game:GetSaveGameList(getglobal("g_playerprofile"));
					
			if (SaveList and getn(SaveList) > 0) then
				UI.YesNoBox("@NewGameWarningTitle", "@StartNewGameWarning", UI.PageCampaignStart.StartGameReally);
			else
				UI.PageCampaignStart.StartGameReally();
			end
		end
	end,
	
	StartGameReally = function()
		
		if (UI.iStat) then setglobal("g_LevelStated", 1);
		else setglobal("g_LevelStated", 0);	end

		setglobal("g_GameType", "Default");			
		UI.PageCampaign:SetAIDifficulty(UI.PageCampaignStart.iDifficultyLevel);
		
		if (strlower(UI.PageCampaignStart.szLevelName) == "training training") then
			UI:PlayCutScene("training_begin.bik", "StartLevel "..UI.PageCampaignStart.szLevelName);
		else
			Game:SendMessage("StartLevel "..UI.PageCampaignStart.szLevelName);
		end
		UI.PageCampaignStart.szLevelName = nil;
	end,
	
	DifficultyChanged = function (Sender)
		UI.PageCampaignStart.GUI.Easy:SetChecked(0);
		UI.PageCampaignStart.GUI.Medium:SetChecked(0);
		UI.PageCampaignStart.GUI.Challenging:SetChecked(0);
		UI.PageCampaignStart.GUI.Veteran:SetChecked(0);
		UI.PageCampaignStart.GUI.Realistic:SetChecked(0);

		Sender:SetChecked(1);

		if (Sender:GetName() == "Easy") then
			UI.PageCampaignStart.iDifficultyLevel = 0;
		elseif (Sender:GetName() == "Medium") then
			UI.PageCampaignStart.iDifficultyLevel = 1;
		elseif (Sender:GetName() == "Challenging") then
			UI.PageCampaignStart.iDifficultyLevel = 2;
		elseif (Sender:GetName() == "Veteran") then
			UI.PageCampaignStart.iDifficultyLevel = 3;
		else
			UI.PageCampaignStart.iDifficultyLevel = 4;
		end
		
		UI.PageCampaign:SetAIDifficulty(UI.PageCampaignStart.iDifficultyLevel);
		UI.PageCampaignStart.GUI.DiffInfo:SetText("@DifficultyText"..Sender:GetName());
	end
}

UI.PageCampaignLoad	=
{
	LevelList={},
	CheckpointName = {},
	iDifficultyLevel = 1,
	GUI=
	{	
		CheckpointLabel=
		{
			skin = UI.skins.MenuBorder,
			left = 512, top = 147,
			width = 262, height = 28,
			bordersides = "tlr",
			
			halign = UIALIGN_CENTER,
			
			text = Localize("Checkpoint"),			
		},

		CheckpointList=
		{
			skin = UI.skins.ListView,
			left = 512, top = 174,
			width = 262, height = 84,
						
			fontsize = 12,
			
			zorder = 10,
			
			tabstop = 12,
			
			vscrollbar=
			{
				skin = UI.skins.VScrollBar,
			},
			hscrollbar=
			{
				skin = UI.skins.HScrollBar,
			},
			
			OnChanged = function(Sender)
				UI.PageCampaignLoad:SetPicture();		
			end
		},

		LevelLabel=
		{
			skin = UI.skins.MenuBorder,
			left = 205, top = 147,
			width = 300, height = 28,
			
			bordersides = "tlr",
			
			halign = UIALIGN_CENTER,
			
			text = Localize("Level");
		},

		LevelList=
		{
			skin = UI.skins.ListView,
			left = 205, top = 174,
			width = 300, height = 244,
			
			tabstop = 11,
			
			zorder = 10,
			
			vscrollbar=
			{
				skin = UI.skins.VScrollBar,
			},
			
			hscrollbar=
			{
				skin = UI.skins.HScrollBar,
			},
			
			OnChanged = function(Sender)
				UI.PageCampaignLoad.PopulateCheckpointList();
			end,
		},

		thumbnail=
		{
			skin = UI.skins.MenuBorder,
			left = 515, top = 264,
			width = 256, height = 192,
			
			color = "255 255 255 255",
		},

		profilenamestatic=
		{
			skin = UI.skins.Label,
			left = 140, top = 424,
			width = 182, height = 28,

			text = Localize("CurrentProfile"),			
		},

		profilename=
		{
			skin = UI.skins.MenuStatic,
			halign = UIALIGN_LEFT,
			
			left = 325, top = 424,
			width = 180, height = 28,		
		},

		loadgame=
		{
			text=Localize("Load_SaveGame"),
			left = 600,
			skin = UI.skins.BottomMenuButton,
			
			tabstop = 13,
			
			OnCommand=function(Sender)
			
				local iSelection = UI.PageCampaignLoad.GUI.CheckpointList:GetSelection(0);

				if not iSelection then
					return
				end
				
				UI.PageCampaignLoad.szFileName = UI.PageCampaignLoad.CheckpointName[iSelection];
				
				if (UI:WillTerminate()) then
					UI.YesNoBox(Localize("TerminateCurrentGame"), Localize("TerminateCurrentGameLabel"), UI.PageCampaignLoad.LoadGame);
				else
					UI.PageCampaignLoad.LoadGame();
				end
			end,
		},
		
		OnActivate = function(Sender)
		
			Sender.CheckpointList.OnCommand = Sender.loadgame.OnCommand;
		
			UI.PageCampaignStart.GUI.OnActivate(Sender);
			
			Sender.LevelList:Clear();
			Sender.CheckpointList:Clear();

			Sender.LevelList.OnCommand = Sender.loadgame.OnCommand;		
			Sender.LevelList:Clear();

			local szProfileName = getglobal("g_playerprofile");
			
			if ((not szProfileName) or (strlen(szProfileName) < 1)) then
				szProfileName = "default";
				g_playerprofile = "default";
			end
			
			Sender.profilename:SetText(szProfileName);

			UI.PageCampaignLoad.SaveList = nil;
			UI.PageCampaignLoad.SaveList = Game:GetSaveGameList(szProfileName);

			UI.PageCampaignLoad.LevelList = {};
			local LevelList = UI.PageCampaignLoad.LevelList;
				
			for i, SaveGame in UI.PageCampaignLoad.SaveList do
				if (not LevelList[SaveGame.Level]) then
					LevelList[SaveGame.Level] = {};
				end
				tinsert(LevelList[SaveGame.Level], SaveGame);
				
				-- remove the "n" that lua just inserts (tinsert call)
				LevelList[SaveGame.Level].n = nil;
			end
				
			UI.PageCampaignLoad:PopulateLevelList();
			UI.PageCampaignLoad:SetPicture();
		end,
	},
	
	SetPicture = function()
		local iSelection = UI.PageCampaignLoad.GUI.CheckpointList:GetSelection(0);

		if iSelection then
		
			local szFileName = UI.PageCampaignLoad.CheckpointName[iSelection];
			
			if (szFileName and strlen(szFileName) > 1) then
			
				--szFileName = "profiles/player/"..getglobal("g_playerprofile").."/savegames/"..szFileName;
				szFileName = "textures/checkpoints/"..szFileName;
			
				local iTexture = System:LoadImage(szFileName);
	
				if (iTexture) then
					UI.PageCampaignLoad.GUI.thumbnail:SetColor("255 255 255 255");
					UI.PageCampaignLoad.GUI.thumbnail:SetTexture(iTexture);
	
					return;
				end
			end
		end

		UI.PageCampaignLoad.GUI.thumbnail:SetColor("0 0 0 64");
		UI.PageCampaignLoad.GUI.thumbnail:SetTexture(nil);
	end,
	
	LoadGame = function()
		UI:TerminateGame();
	
		if (UI.PageCampaignLoad.szFileName) then
			--UI.PageCampaign.SetAIDifficulty(UI.PageCampaignLoad.iDifficultyLevel);

			if (UI.iStat) then setglobal("g_LevelStated", 1);
			else setglobal("g_LevelStated", 0);	end

			setglobal("g_GameType","Default");
			
			Game:SendMessage("LoadGame "..UI.PageCampaignLoad.szFileName);		
		end

		UI.PageCampaignLoad.szFileName = nil;
	end,
	
	PopulateLevelList = function()
		local LevelList = UI.PageCampaignLoad.LevelList;
		local ListView = UI.PageCampaignLoad.GUI.LevelList;
		
		ListView:Clear();
		
		UI.PageCampaignLoad.DefiantTable = {};
		-- this is needed so that the levels are in order of appearence
		-- it's not efficient, but it's fast implemented, and no changes needed
		for i, Level in DEFIANT do
			for szLevelName, CheckPointList in LevelList do
				if (strlower(tostring(szLevelName)) == strlower(tostring(Level[1]))) then
					UI.PageCampaignLoad.DefiantTable[ListView:AddItem("@Level"..Level[1])] = Level;
					break;
				end
			end
		end
	end,
	
	PopulateCheckpointList = function()
		local LevelList = UI.PageCampaignLoad.LevelList;
		local LevelListView = UI.PageCampaignLoad.GUI.LevelList;
		local ListView = UI.PageCampaignLoad.GUI.CheckpointList;
	
		ListView:Clear();
		UI.PageCampaignLoad.CheckpointName = {};
	
		local iSelection = LevelListView:GetSelection(0);
		
		if (iSelection) then
			local szLevel = UI.PageCampaignLoad.DefiantTable[iSelection][1];
			local CheckpointList = LevelList[strlower(szLevel)];
		
			if (CheckpointList) then
	
				local iCPCount = count(CheckpointList);
	
				for i=1, iCPCount do
					-- remove the .sav part
					local Checkpoint = CheckpointList[i];
					local szFileName = strsub(Checkpoint.Filename, 1, strlen(Checkpoint.Filename)-strlen(".sav"));	
					local szCheckpointName;
					local szDate = "%.2d/%.2d/%.2d";
					
					if (getglobal("g_language") and strlower(getglobal("g_language")) == "french") then
						szDate = format(szDate, Checkpoint.Day, Checkpoint.Month, Checkpoint.Year);
					else
						szDate = format(szDate, Checkpoint.Month, Checkpoint.Day, Checkpoint.Year);
					end
	
					if (i == iCPCount) then 
						szCheckpointName = format(szDate.." [%.2d:%.2d:%.2d] @CheckpointLast", Checkpoint.Hour, Checkpoint.Minute, Checkpoint.Second);
					else
						szCheckpointName = format(szDate.." [%.2d:%.2d:%.2d]", Checkpoint.Hour, Checkpoint.Minute, Checkpoint.Second);
					end
	
					UI.PageCampaignLoad.CheckpointName[ListView:InsertItem(0, szCheckpointName)] = szFileName;
				end
			end
		end
		
		UI.PageCampaignLoad:SetPicture();
		
		--UI.PageCampaignLoad.GUI.CheckpointList:SortEx(UISORT_DESCENDING, 0);
	end
}

function UI.PageCampaign:SetAIDifficulty(difficultylevel)

	setglobal("game_DifficultyLevel", difficultylevel);

	if tonumber(getglobal("game_DifficultyLevel"))==0 then		-- EASY
		System:Log("UI.PageCampaign:SetAIDifficulty easy");
		setglobal("game_Accuracy",0.4);
		setglobal("game_Aggression",0.3);
		setglobal("game_Health",0.5);
		setglobal("ai_allow_accuracy_decrease",1);
		setglobal("ai_allow_accuracy_increase",0);
		setglobal("ai_SOM_SPEED",1.2);
	
	elseif tonumber(getglobal("game_DifficultyLevel"))==1 then	-- MEDIUM
		System:Log("UI.PageCampaign:SetAIDifficulty medium");
		setglobal("game_Accuracy",0.5);
		setglobal("game_Aggression",0.5);
		setglobal("game_Health",0.7);
		setglobal("ai_allow_accuracy_decrease",1);
		setglobal("ai_allow_accuracy_increase",0);
		setglobal("ai_SOM_SPEED",1.5);
	elseif tonumber(getglobal("game_DifficultyLevel"))==2 then	-- CHALLENGING
		System:Log("UI.PageCampaign:SetAIDifficulty challenging");
		setglobal("game_Accuracy",0.8);
		setglobal("game_Aggression",0.8);
		setglobal("game_Health",1.0);
		setglobal("ai_allow_accuracy_decrease",1);
		setglobal("ai_allow_accuracy_increase",0);
		setglobal("ai_SOM_SPEED",1.5);
	elseif tonumber(getglobal("game_DifficultyLevel"))==3 then	-- BRUTAL
		System:Log("UI.PageCampaign:SetAIDifficulty brutal");
		setglobal("game_Accuracy",1.1);
		setglobal("game_Aggression",1.1);
		setglobal("game_Health",1.2);
		setglobal("ai_allow_accuracy_decrease",1);
		setglobal("ai_allow_accuracy_increase",1);
		setglobal("ai_SOM_SPEED",1.8);
	elseif tonumber(getglobal("game_DifficultyLevel"))==4 then	-- REALISTIC
		System:Log("UI.PageCampaign:SetAIDifficulty realistic");
		setglobal("game_Accuracy",2.0);
		setglobal("game_Aggression",2.0);
		setglobal("game_Health",1.5);
		setglobal("ai_allow_accuracy_decrease",1);
		setglobal("ai_allow_accuracy_increase",1);
		setglobal("ai_SOM_SPEED",2.2);
	end
end

function Game:DisplayTimeZone()
	if ((not ClientStuff) or (not AI) or (not UI)) then
		return;
	end
	
	UI.bInGameOverride = 1;
	
	UI:TerminateGame();
	Game:ShowMenu();

	GotoPage("TimeZone");
end

UI.PageTimeZone=
{
	GUI=
	{
		StatsLabel=
		{
			skin = UI.skins.MenuBorder,
			left = 208, top = 147,
			width = 260, height = 28,
			
			bordersides = "tlr",
			
			halign = UIALIGN_CENTER,
		},
		
		StatsList=
		{
			skin = UI.skins.ListView,
			left = 208, top = 174,
			width = 260, height = 277,
			headerheight = 0,
			
			tabstop = 1,

			vscrollbar={ skin = UI.skins.VScrollBar, },
			hscrollbar={ skin = UI.skins.HScrollBar, },
		},
		
		LevelLabel=
		{
			skin = UI.skins.MenuBorder,
			left = 588, top = 147,
			width = 184, height = 28,
			
			bordersides = "tlr",
			
			halign = UIALIGN_CENTER,
			
			text = Localize("Level");
		},	
		
		MapList=
		{
			skin = UI.skins.ListView,
			left = 588, top = 174,
			width = 184, height = 277,
					
			zorder = 10,
			tabstop = 2,
			
			vscrollbar=
			{
				skin = UI.skins.VScrollBar,
			},
			
			hscrollbar=
			{
				skin = UI.skins.HScrollBar,
			},
			
			OnCommand = function(Sender)
				local iLevel = Sender:GetSelection(0);
				
				if (iLevel) then
				
					local Table = UI.PageTimeZone.DefiantTable[iLevel];
					
					local szLevel = Table[1];
					local szMission = Table[2];
					
					if (szLevel and strlen(szLevel)) then
						UI.PageCampaignStart.szLevelName = szLevel.." "..szMission;						
						UI.PageCampaignStart.StartGame();
					end
				end
			end,
		},

		StartGame=
		{
			text=Localize("Start"),
			left = 600,
			skin = UI.skins.BottomMenuButton,
			
			tabstop = 3,
			
			OnCommand=function(Sender)
				UI.PageCampaignStart.szLevelName = "Training Training";		-- is used by YesNoBox command

				if UI:IsWidgetVisible(UI.PageTimeZone.GUI.MapList) and UI.PageTimeZone.GUI.MapList:GetSelection(0) then
					UI.PageTimeZone.GUI.MapList.OnCommand(UI.PageTimeZone.GUI.MapList);
				else
					UI.PageCampaignStart.StartGame();
				end
			end,
		},
		
		OnActivate = function(self)
		
			
			UI.bInGameOverride = 0;
		
			self.StatsList:Clear();
			self.StatsList:ClearColumns();
					
			self.StatsList:AddColumn("", 158, UIALIGN_RIGHT, UI.szListViewOddColor, "0 0 0 0");
			self.StatsList:AddColumn("", 98, UIALIGN_LEFT, UI.szListViewOddColor, "0 0 0 0");
			
			
			Stats = {};
			AI:GetStats(Stats);
			
			local szFinishTime = Stats.TotalTime;
			local enKilled = Stats.EnemiesKilled;
			local enSurvived = max(0, Stats.TotalEnemiesInLevel - Stats.EnemiesKilled);
			local enKillpcnt = 0;
			
			if (tonumber(Stats.TotalEnemiesInLevel) > 0) then
				enKillpcnt = 100 * Stats.EnemiesKilled / Stats.TotalEnemiesInLevel;
			end
			
			local enAVGLifeTime = Stats.AVGEnemyLifetime;
			local enSilentKills = Stats.SilentKills;
			
			local plShotsFired = Stats.ShotsFired;
			local plShotsHit = Stats.ShotsHit;
			local plAccuracy = 0;
			
			if (tonumber(Stats.ShotsFired) > 0) then
				plAccuracy = 100 * Stats.ShotsHit / Stats.ShotsFired;
			end
			
			local plDeadliness = 0;
			
			if (tonumber(Stats.ShotsFired) > 0) then
				plDeadliness = 100 * Stats.EnemiesKilled / Stats.ShotsFired;
			end
			
			local plDeaths = Stats.TotalPlayerDeaths;
			local plDeathsPerCheckpoint = Stats.TotalPlayerDeaths;
			
			if (tonumber(Stats.CheckpointsHit) > 0) then
				plDeathsPerCheckpoint = Stats.TotalPlayerDeaths / Stats.CheckpointsHit;
			end
			
			local plAvgDeathsTime = 0;
			
			if (tonumber(Stats.CheckpointsHit) > 0) then
				plAvgDeathsTime =  Stats.TotalTimeSecs / Stats.CheckpointsHit;
			end
			
			local plVehiclesDestroyed = Stats.VehiclesDestroyed;
			
			self.StatsList:AddItem("@StatFinishTime", Stats.TotalTime);
			self.StatsList:AddItem("$$", "");
			self.StatsList:AddItem("@StatEnemies", "");
			self.StatsList:AddItem("@StatKilled", tostring(enKilled));
			self.StatsList:AddItem("@StatSurvived", tostring(enSurvived));
			self.StatsList:AddItem("@StatKillPct", format("%g", format("%.3f", enKillpcnt)).."%");
			self.StatsList:AddItem("@StatAvgLifeTime", format("%g @StatSeconds", format("%.3f", enAVGLifeTime)));
			self.StatsList:AddItem("@StatSilentKill", tostring(enSilentKills));
			self.StatsList:AddItem("@StatPlayer", "");
			self.StatsList:AddItem("@StatShotsFired", tostring(plShotsFired));
			self.StatsList:AddItem("@StatShotsHit", tostring(plShotsHit));
			self.StatsList:AddItem("@StatAccuracy", format("%g", format("%.3f", plAccuracy)).."%");
			self.StatsList:AddItem("@StatDeadliness", format("%g", format("%.3f", plDeadliness)).."%");
			self.StatsList:AddItem("@StatDeaths", tostring(plDeaths));
			self.StatsList:AddItem("@StatDeathsChkpt", format("%g", format("%.3f", plDeathsPerCheckpoint)));
			self.StatsList:AddItem("@StatAvgChkptTime", format("%g @StatSeconds", format("%.3f", plAvgDeathsTime)));
			self.StatsList:AddItem("@StatVehicles", tostring(plVehiclesDestroyed));
			
			UI.PageTimeZone.GUI.MapList:Clear();
			UI.PageTimeZone.DefiantTable = {};
	
			for i, Table in DEFIANT do
				UI.PageTimeZone.DefiantTable[UI.PageTimeZone.GUI.MapList:AddItem("@Level"..Table[1])] = Table;				
			end			
			
			self.StatsLabel:SetText("@Level"..getglobal("g_LevelName").." @StatStats");
		end
	}
}

AddUISideMenu(UI.PageCampaign.GUI,
{
	{ "MainMenu", Localize("MainMenu"), "$MainScreen$", 0},
	{ "Options", Localize("Options"), "Options", },
});

AddUISideMenu(UI.PageTimeZone.GUI,
{
	{ "MainMenu", Localize("MainMenu"), "$MainScreen$", 0},
	{ "Options", Localize("Options"), "Options", },
	{ "-", "-", "-", },
	{ "Quit", Localize("Quit"), UI.PageMainScreen.ShowConfirmation, },
});
		
Language:LoadStringTable("summary.xml");

UI:CreateScreenFromTable("CampaignStart",UI.PageCampaignStart.GUI);
UI:CreateScreenFromTable("CampaignLoad",UI.PageCampaignLoad.GUI);
UI:CreateScreenFromTable("Campaign",UI.PageCampaign.GUI);
UI:CreateScreenFromTable("TimeZone",UI.PageTimeZone.GUI);