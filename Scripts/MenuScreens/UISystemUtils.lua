-- CVars that need the game to be restarted when changed.
--
UI.cvarsNeedingRelaunch=
{
	e_beach = 1,
	e_use_global_fog_in_fog_volumes = 1,
	e_vegetation_min_size = 1,
	r_Quality_BumpMapping = 1,
	r_Vegetation_PerpixelLight = 1,
	e_light_maps_quality = 1,
	e_detail_texture_quality = 1,
	e_stencil_shadows = 1,
	e_shadow_maps = 1,
	e_cgf_load_lods = 1,
	es_EnableCloth = 1,
	r_Quality_Reflection = 1,
	sys_skiponlowspec = 1,
	s_MaxHWChannels = 1,
	s_CompatibleMode = 1,
	s_SpeakerConfig = 1,
}

function UI:WillTerminate()
	if (Game:IsMultiplayer()) then
		if (ClientStuff) then
			return 1;
		end
		return nil;
	else
		if (ClientStuff) then
			if (_localplayer and _localplayer.cnt.health <= 0) then
			 	return nil;
			else
			 	return 1;
			end
		else
			return nil;
		end
	end
end

function UI:TerminateGame()
	Game:Disconnect();
	Game:CleanUpLevel();
end

function UI:PrecacheMPModels()
	local ModelView = UI.PageOptionsGame.GUI.modelview;
	local bResult = ModelView:LoadModel(getglobal("mp_model"));
	
	if (bResult and tonumber(bResult) ~= 0) then
		ModelView:SetAnimation("swalkfwd");
	end
end

function UI:CheckCutSceneDrive()
	local szCutSceneFolder = UI.szLocalizedCutSceneFolder;
	szCutSceneFolder = gsub(szCutSceneFolder, "&language&", getglobal("g_language"));
	
	UI.szCutSceneDrive = "./";
	
	local FileList = System:ScanDirectory("./"..szCutSceneFolder, SCANDIR_FILES);
	local CutSceneList = {};

	for i, szFileName in FileList do
		if (strlower(strsub(szFileName, -4)) == ".bik") then
			tinsert(CutSceneList, szFileName);
		end
	end
	
	if (getn(CutSceneList) and (getn(CutSceneList) > 0)) then
		-- cutscenes are on disk
		return;
	end
	
	-- cutscenes are on cd
	local szCDPath = Game:GetCDPath();
	
	if (szCDPath) then
		UI.szCutSceneDrive = strsub(szCDPath, 1, 2).."/";
	end
end

function UI:BuildDemoLoopList()
	local FileList = System:ScanDirectory(UI.szCutSceneFolder.."demoloops/", SCANDIR_FILES);
	UI.szDemoLoopDrive = "./";
	
	UI.VideoList = {};
	for i, szFileName in FileList do
		if (strlower(strsub(szFileName, -4)) == ".bik") or (strlower(strsub(szFileName, -4)) == ".avi") then
			tinsert(UI.VideoList, szFileName);
		end
	end

	if (getn(UI.VideoList) < 1) then
		local szCDPath = Game:GetCDPath();

		if (szCDPath) then
			UI.szDemoLoopDrive = strsub(szCDPath, 1, 2).."/";
			FileList = System:ScanDirectory(strsub(szCDPath, 1, 2)..UI.szCutSceneFolder.."demoloops/", SCANDIR_FILES);
		end
	end

	UI.VideoList = {};
	for i, szFileName in FileList do
		if (strlower(strsub(szFileName, -4)) == ".bik") or (strlower(strsub(szFileName, -4)) == ".avi") then
			tinsert(UI.VideoList, szFileName);
		end
	end

	if (not getn(UI.VideoList) or (getn(UI.VideoList) < 1)) then
		UI.szDemoLoopDrive = "./";
	end
end

function UI:GetDemoLoopDrive()
	return UI.szDemoLoopDrive;
end

function UI:GetCutSceneDrive()
	return UI.szCutSceneDrive;
end

--------------------------------------------------------------------------------
-- Goto the options page
--------------------------------------------------------------------------------
function UI:GotoGameOptions()
	GotoPage( "Options", 1 );
	UI.PageOptions.GUI.GameOptions:OnCommand( UI.PageOptions.GUI.GameOptions );
end

--------------------------------------------------------------------------------
-- Check if we should bring up the options or not
--------------------------------------------------------------------------------
function UI:CheckOptions()
	local firstLaunch = tonumber( getglobal( "sys_firstlaunch" ) );
	if( firstLaunch == 0 ) then
		GotoPage( "$MainScreen$", 0 );
	else
		GotoPage( "$MainScreen$", 0 );
		-- launch video menu when game was started for the first time
		--UI.YesNoBox( Localize( "Options" ), Localize( "AskAdjOptions" ), UI.GotoGameOptions );
	end
end

--------------------------------------------------------------------------------
-- Enable/Disable switching between menu and game
--------------------------------------------------------------------------------
function UI:EnableSwitch(bEnable, bOn)
	if (not bOn) then
		if (bEnable and tonumber(bEnable) ~= 0) then
			UI.bCanSwitchOn = 1;
			UI.bCanSwitchOff = 1;
		else
			UI.bCanSwitchOn = 0;
			UI.bCanSwitchOff = 0;
		end
	else
		if (bOn == 1) then
			if (bEnable and tonumber(bEnable) ~= 0) then
				UI.bCanSwitchOn = 1;
			else
				UI.bCanSwitchOn = 0;
			end
		else
			if (bEnable and tonumber(bEnable) ~= 0) then
				UI.bCanSwitchOff = 1;
			else
				UI.bCanSwitchOff = 0;
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Play the menu music
--------------------------------------------------------------------------------
function UI:PlayMusic()
	if (UI.MusicId~=nil and tostring(getglobal("s_MusicEnable")) == "1") then
		Sound:SetSoundLoop(UI.MusicId, 1);
		Sound:PlaySound(UI.MusicId);
		Sound:SetSoundVolume(UI.MusicId, getglobal("s_MusicVolume") * 255.0);
	end
end

--------------------------------------------------------------------------------
-- Stop the menu music
--------------------------------------------------------------------------------
function UI:StopMusic()
	Sound:StopSound(UI.MusicId);
end

--------------------------------------------------------------------------------
-- Adds a chat box to the page, usefull in multiplayer ingame menus, that allways have it
--------------------------------------------------------------------------------
function UI:AddChatbox(Page, x, y, w, h, inputh, teambased)

	if ((teambased) and (teambased ~= 0)) then
		Page["isTeambased"] = 1;
	end

	Page["ChatBox"] =
	{
		skin = UI.skins.ChatBox,
		left = x, top = y,
		width = w, height = (h - inputh - 3),

		vscrollbar =
		{
			skin = UI.skins.VScrollBar,
		},

		hscrollbar =
		{
			skin = UI.skins.HScrollBar,
		},
	};

	Page["ChatInput"] =
	{
		skin = UI.skins.ChatInput,
		left = x, top = (y + h + 3 - inputh),
		width = w - 140+1, height = inputh,

		bordersides = "ltb",

		maxlength = 64,

		tabstop = 21,

		OnCommand = function (Sender)
			if (Client) then

				local Page = Sender:GetScreen();
				local ChatTo = UI:GetWidget("ChatTarget", Page);

				if (ChatTo:GetSelectionIndex()) then

					if (ChatTo:GetSelectionIndex() == 1) then
						Client:Say(Sender:GetText());
					elseif ((ChatTo:GetSelectionIndex() == 2) and (Page.isTeambased)) then
						Client:SayTeam(Sender:GetText());
					else
						local szSelected = ChatTo:GetSelection();

						if (szSelected) then
							Client:SayOne(szSelected, Sender:GetText());
						end
					end
					Sender:Clear();
				end
			end
		end,
	}

	Page["ChatTarget"] =
	{
		skin = UI.skins.ChatTarget,

		left = x + w - 140, top = (y + h + 3 - inputh),
		width = 140, height = inputh,

		maxitems = 8,
		tabstop = 22,

		vscrollbar=
		{
			skin = UI.skins.VScrollBar,
		},

		OnChanged = function(Sender)
			local Page = Sender:GetScreen();

			Page.szChatTarget = Sender:GetSelection();
		end,
	}

	Page["PopulateChatTarget"] = function(Sender, bRepopulating)

		local ChatTarget = UI:GetWidget("ChatTarget", Sender);

		if (bRepopulating and tonumber(bRepopulating) ~= 0) then
			if (Sender.fNextRepopulateTime) then
				if (_time < Sender.fNextRepopulateTime) then
					return;
				end
			end
			if (ChatTarget:IsDropDown()) then
				return;
			end
		end

		Sender.fNextRepopulateTime = _time + 0.25;

		local PlayerList = Game:GetPlayers();
		local iSelected = 0;

		if (not bRepopulating or tonumber(bRepopulating) == 0) then
			iSelected = 1;
		else
			if (ChatTarget:GetSelectionIndex() == 1) then
				iSelected = 1;
			elseif ((ChatTarget:GetSelectionIndex() == 2) and (Sender.isTeambased)) then
				iSelected = 2;
			end
		end

		ChatTarget:Clear();
		ChatTarget:ClearSelection();
		ChatTarget:AddItem("@ToAll");

		if (Sender.isTeambased) then
			ChatTarget:AddItem("@ToTeam");
		end

		for PlayerIndex, Player in PlayerList do
			-- check if this is the selected player
			if (Player:GetName() == Sender.szChatTarget) then
				iSelected = ChatTarget:AddItem(Player:GetName());
			elseif (_localplayer and _localplayer.GetName) then
				if (Player:GetName() ~= _localplayer:GetName()) then
					ChatTarget:AddItem(Player:GetName());
				end
			end
		end

		-- check if it is a valid selection
		if ((iSelected) and (iSelected > 0)) then
			ChatTarget:SelectIndex(iSelected);
		end
	end
end

function DisconnectOnYes()
	GotoPage("Disconnect");
end

-- deactivates every screen, except the backscreen and "chosen one"
function GotoPage(PageName, Back, HideBackground)

	if (not UI) then
		return;
	end

	-- process special cases here
	-- where the dependent situation might not change screen
	-- so nothing should be changed (ie: hiding back screens)
	if (tostring(PageName) == "$Disconnect$") then
		UI.YesNoBox("@DisconnectTitle", "@DisconnectYesNo", DisconnectOnYes);
		return;
	end

	-- we don't want to deactivate the "BackScreen"
	for i=0,UI:GetScreenCount()-1 do
		local Screen = UI:GetScreen(i);

		if (Screen and Screen:GetName() ~= "BackScreen") then
			UI:DeactivateScreen(Screen:GetName());
		end
	end

	UI:ActivateScreen("BackScreen");


	if (HideBackground and HideBackground ~= 0) then
		UI:DisableWidget("Video", "BackScreen");
		UI:HideWidget("Video", "BackScreen");
		UI:HideWidget("StaticImage","BackScreen");
		--UI:HideWidget("Header", "BackScreen");
		--UI:HideWidget("Footer", "BackScreen");
		UI:HideWidget("Ad", "BackScreen");
		UI:HideBackground();
	else
		if tonumber(getglobal("ui_BackGroundVideo"))~=0 then
			UI:EnableWidget("Video", "BackScreen");
			UI:ShowWidget("Video", "BackScreen");
			UI:HideWidget(UI.PageBackScreen.GUI.StaticImage);
		else
			UI:DisableWidget("Video", "BackScreen");
			UI:HideWidget("Video", "BackScreen");
			UI:ShowWidget(UI.PageBackScreen.GUI.StaticImage);
		end
		--UI:ShowWidget("Header", "BackScreen");
		--UI:ShowWidget("Footer", "BackScreen");
		UI:ShowWidget("Ad", "BackScreen");
	end

	if ((not Back) or (Back and (Back ~= 0))) then
		UI:ShowWidget("BackStatic", "BackScreen");
	else
		UI:HideWidget("BackStatic", "BackScreen");
	end

	if (tostring(PageName) == "$MainScreen$") then
		if (ClientStuff) then
			UI:ActivateScreen("MainScreenInGame");
		else
			UI:ActivateScreen("MainScreen");
		end
	elseif (tostring(PageName) == "$InGame$") then
		GotoPage(ClientStuff:GetInGameMenuName());
	elseif (tostring(PageName) == "$Return$") then
		Game:HideMenu();
		GotoPage(ClientStuff:GetInGameMenuName());
	else
		UI:ActivateScreen(PageName);
	end
end

--------------------------------------------------------------------------------
-- Add a left navigation button list
--------------------------------------------------------------------------------
function AddUISideMenu(Page, ItemList)

	local iStartY = UI.iSideMenuTop;
	local iStartX = UI.iSideMenuLeft;
	local iSpacing = UI.iSideMenuSpacing;

	local iTabStop = 10001;

	for ItemName, ItemTable in ItemList do

		if ((ItemTable[1] == '-') and (ItemTable[2] == '-') and (ItemTable[3] == '-')) then
			iStartY = iStartY + (UI.skins.SideMenuButton.height * 0.5) + iSpacing * 0.5;
		else
			Page[ItemTable[1]] =
			{
				skin = UI.skins.SideMenuButton,

				left = iStartX,
				top = iStartY,

				text = ItemTable[2],

				user={
					target = ItemTable[3],
					showback = ItemTable[4],
				},

				tabstop = iTabStop,

				OnCommand = function(Sender)
					if (type(Sender.user.target) == "string") then
						GotoPage(Sender.user.target, Sender.user.showback);
					else
						Sender.user.target();
					end
				end,
			}
			iTabStop = iTabStop + 1;
			iStartY = iStartY + UI.skins.SideMenuButton.height + iSpacing;
		end
	end
end

--------------------------------------------------------------------------------
-- Init Some Stuff Here
--------------------------------------------------------------------------------
UI:BuildDemoLoopList();
UI:CheckCutSceneDrive();