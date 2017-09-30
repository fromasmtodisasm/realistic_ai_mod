--
-- profiles menu page
--


UI.PageProfiles=
{	
	GUI=
	{
		ProfileList=
		{
			left = 205, top = 147,
			width = 570, height = 238,
			
			tabstop = 1,
			
			skin = UI.skins.ListView,
			
			OnChanged=function(self)
				if (self:GetSelection(0)) then
					UI:EnableWidget(UI.PageProfiles.GUI.SelectProfile);
					UI:EnableWidget(UI.PageProfiles.GUI.RemoveProfile);
				else
					UI:DisableWidget(UI.PageProfiles.GUI.SelectProfile);
					UI:DisableWidget(UI.PageProfiles.GUI.RemoveProfile);
				end
			end,
			
			vscrollbar=
			{
				skin = UI.skins.VScrollBar,
			},
			
			hscrollbar=
			{
				skin = UI.skins.HScrollBar,
			}
		},
		
		CurrentProfileNameStatic=
		{
			skin = UI.skins.MenuBorder,

			left = 200, top = 390,
			width = 580, height = 69,
		},
		
		CurrentProfileNameText=
		{
			classname="static",
			text = Localize("CurrentProfile"),
			style = UISTYLE_DEFAULT + UISTYLE_TRANSPARENT,
			halign = UIALIGN_RIGHT, 
			
			left = 210, top = 402,
			width = 180, height = 28,
		},
		
		CurrentProfileName=
		{
			skin = UI.skins.MenuStatic,
			halign = UIALIGN_LEFT,
			
			left = 395, top = 402,
			width = 220, height = 28,		
		},

		SelectProfile=
		{
			skin = UI.skins.BottomMenuButton,
			
			text=Localize("ProfileSelect"),
			left = 780-140,
			width = 140,
			
			tabstop = 4,
			
			OnCommand=function(Sender)
				if (UI:WillTerminate()) then
					UI.YesNoBox(Localize("TerminateCurrentGame"), Localize("TerminateCurrentGameLabel"), UI.PageProfiles.LoadProfile);
				else
					UI.PageProfiles.LoadProfile();
				end
			end,
		},
		
		NewProfile=
		{
			skin = UI.skins.BottomMenuButton,
			
			text=Localize("ProfileNew"),
			left = 780-140-139-139,
			width = 140,
			
			tabstop = 2,

			OnCommand=function(Sender)
				if (UI:WillTerminate()) then
					UI.YesNoBox(Localize("TerminateCurrentGame"), Localize("TerminateCurrentGameLabel"), UI.PageProfiles.CreateProfile);
				else
					UI.PageProfiles.CreateProfile();
				end
			end,
		},
		
		RemoveProfile=
		{
			skin = UI.skins.BottomMenuButton,
			
			text=Localize("RemoveProfile"),
			left = 780-140-139,
			width = 140,
			
			tabstop = 3,
			
			OnCommand=function(Sender)
				local iIndex = UI.PageProfiles.GUI.ProfileList:GetSelection(0);
				
				if (iIndex) then
					local ProfileName = UI.PageProfiles.GUI.ProfileList:GetItem(iIndex);
					
					if (strlower(ProfileName) == "default") then
						UI.MessageBox(Localize("RemoveProfile"), Localize("CanNotRemoveDefaultProfile"));
					else
						UI.YesNoBox(Localize("RemoveProfile"), Localize("RemoveProfileConfirmation"), UI.PageProfiles.OnRemoveYes);
					end
				end
			end,
		},
		

		OnActivate= function(Sender)			
			UI.PageProfiles.RefreshProfileList();			
		end,
	},
	
	------------------------------------------------------------------------
	
	OnRemoveYes = function()
		local iIndex = UI.PageProfiles.GUI.ProfileList:GetSelection(0);
				
		if (iIndex) then
			local ProfileName = UI.PageProfiles.GUI.ProfileList:GetItem(iIndex);
			
			Game:RemoveConfiguration(ProfileName);

			setglobal("g_playerprofile", "default");
			
			UI.PageProfiles.RefreshProfileList();		
		end
	end,
	
	OnCreateOk = function(szNewName)
		if (szNewName and (strlen(szNewName) > 0)) then
		
			if (strlower(szNewName) == "default") then
				return 1;
			end
		
			UI.PageProfiles.szSaveFileName = "profiles/player/"..szNewName.."_system.cfg";
			UI.PageProfiles.szProfileName = szNewName;
			
			-- check if the file exists
			local hFile = openfile (UI.PageProfiles.szSaveFileName, "r");
			
			if (hFile) then
				closefile(hFile);
				
				UI.YesNoBox(Localize("OverwriteConfirmation"), Localize("SProfileOverwrite"), UI.PageProfiles.SaveProfile);
			else
				UI.PageProfiles.SaveProfile();
			end
		end
					
		return 1;
	end,
	
	SaveProfile = function()

		if g_playerprofile~="" then
			Game:SaveConfiguration(g_playerprofile);
		end

		g_playerprofile=UI.PageProfiles.szProfileName; g_timezone = 0;

		Game:SaveConfiguration(g_playerprofile);
		
		UI.PageProfiles.RefreshProfileList();

		return 1;			
	end,

	RefreshProfileList = function()
		local ProfileTable = System:ScanDirectory("profiles/player", SCANDIR_FILES);
		local ProfileList = UI.PageProfiles.GUI.ProfileList;

		ProfileList:Clear();
		for i,filename in ProfileTable do
			local sPostFix="_system.cfg";
			local iLen=strlen(sPostFix);

			local sPost=strsub(filename,-iLen);

			if sPost==sPostFix then
				local sName=strsub(filename,1,strlen(filename)-iLen);		-- left e.f. Bob
				ProfileList:AddItem(sName);
			end
		end
		
		if (g_playerprofile) then
			ProfileList:Select(g_playerprofile);
			UI.PageProfiles.GUI.CurrentProfileName:SetText(g_playerprofile);
		else
			UI.PageProfiles.GUI.CurrentProfileName:SetText("");
		end
		
		UI.PageProfiles.GUI.ProfileList:OnChanged();
	end,
	
	CreateProfile = function()
		UI.bTerminatingGame = 1;
		UI:TerminateGame();
		UI.bTerminatingGame = nil;
	
		UI.InputBoxEx(Localize("CreateProfile"), Localize("ProfileName"), "", 0, 1, 0, 0, 28, UI.PageProfiles.OnCreateOk);	
	end,
	
	LoadProfile = function()
		UI.bTerminatingGame = 1;
		UI:TerminateGame();
		UI.bTerminatingGame = nil;

		if getglobal("g_playerprofile") and strlen(getglobal("g_playerprofile")) > 0 then
			Game:SaveConfiguration(getglobal("g_playerprofile"));
		end
		
		if UI.PageProfiles.GUI.ProfileList:GetSelectionCount()==1 then
			local iIndex=UI.PageProfiles.GUI.ProfileList:GetSelection(0);
			
			setglobal("g_playerprofile", UI.PageProfiles.GUI.ProfileList:GetItem(iIndex));

			System:Log("g_playerprofile");
			System:Log(g_playerprofile);
			
			local SaveCVar = {};
			local bRelaunch = 0;
			
			for szCVarName, i in UI.cvarsNeedingRelaunch do
				SaveCVar[szCVarName] = getglobal(szCVarName);
			end
			
			local width = getglobal("r_Width");
			local height = getglobal("r_Height");
			local bpp = getglobal("r_ColorBits");
	
			Game:LoadConfiguration(g_playerprofile);		-- load
			
			for szCVarName, i in UI.cvarsNeedingRelaunch do
				if (SaveCVar[szCVarName] ~= getglobal(szCVarName)) then
					bRelaunch = 1;
				end
			end
			
			if ((getglobal("r_Width") ~= width) or (getglobal("r_Height") ~= height) or (getglobal("r_ColorBits") ~= bpp)) then
				if (bRelaunch == 1) then
					g_reload_ui = "cmd_goto_profiles_and_warn";
				else
					g_reload_ui = "cmd_goto_profiles";
				end
				
				UI:Reload( 1 );
			elseif (bRelaunch == 1) then
				UI.MessageBox( Localize( "AdvChangeMess1" ), Localize( "AdvChangeMess2" ));				
			end
			
			UI.PageProfiles:RefreshProfileList();
			UI.PageProfiles.GUI.ProfileList:Select(g_playerprofile);
			UI.PageProfiles.GUI.ProfileList:OnChanged();
		end
	end,
};

AddUISideMenu(UI.PageProfiles.GUI,
{
	{ "MainMenu", Localize("MainMenu"), "$MainScreen$", 0},
	{ "Options", Localize("Options"), "Options", },
});

UI:CreateScreenFromTable("Profiles",UI.PageProfiles.GUI);

