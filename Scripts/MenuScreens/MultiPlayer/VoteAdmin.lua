UI.PageVoteAdmin=
{
    LevelList={},       -- { missionname1={}, missionname2={}, }
    
    GUI =
    {   
        VoteAdminText=
        {
            skin = UI.skins.Label,
            
            left = 200, top = 110,
            width = 122, 
            halign = UIALIGN_LEFT,
            
            text = "Voting Panel";
        },
        
        KickPlayerIDTest=
        {
            skin = UI.skins.Label,
            
            left = 175, top = 340,
            width = 140, height = 24,
            
		fontsize = 12,
            text = "Player ID # to Kick";
        },


             
        KickPlayerID=
        {       
            skin = UI.skins.EditBox,

            left = 320, top = 340,
            width = 25, height = 24,

            fontsize = 11,            
            
            tabstop = 13,
        },
        
        KickPlayer=
        {
            skin = UI.skins.BottomMenuButton,
            
            text = "Kick",
            
            tabstop = 14,
            fontsize = 14,
            
            left = 345, top = 340,
            width = 75, height = 24,
            
            OnCommand = function(Sender)
                local PlayerToKick = UI.PageVoteAdmin.GUI.KickPlayerID:GetText();
--                Game:ExecuteRConCommand("kickid "..PlayerToKick);
                  if (PlayerToKick~= nil) then
			if (Client) then
				Client:CallVote("kick",PlayerToKick);
			end
			end

                System:ShowConsole(1);
            end,
        },
        
        ListActivePlayers=
        {
            skin = UI.skins.BottomMenuButton,
            
            text = "List Active Players",
            
            tabstop = 12,
            fontsize = 14,
            
            left = 320, top = 280,
            width = 140, height = 24,

            OnCommand = function(Sender)
                System:ExecuteCommand("gr_list");
                System:ShowConsole(1);
            end            
        },

        ListActivePlayersText=
        {
            skin = UI.skins.Label,
            
            left = 320, top = 310,
            width = 230, height = 24,
            
            fontsize = 12,
            text = "Hit the ` or ~ key to toggle from console to menu";
        },
        


        MODListText=
        {
            skin = UI.skins.Label,
            
            left = 175, top = 140,
            width = 140, height = 24,
            
            fontsize = 12,
            text = "Map Type";
        },
        
        MODList=
        {
            skin = UI.skins.ComboBox,
            
            left = 320, top = 140,
            width = 140, height = 24,
            
            buttonsize = 15,
            
            maxitems = 5,
            fontsize = 12, 
            
            tabstop = 3,

            vscrollbar=
            {
                skin = UI.skins.VScrollBar,
            },      
            
            OnChanged = function(Sender)
                UI.PageVoteAdmin.PopulateMapList();
                
                if (UI.PageVoteAdmin.GUI.MapList:GetItemCount()) then
                
                    if (getglobal(gr_NextMap)) then
                        UI.PageVoteAdmin.GUI.MapList:Select(tostring(gr_NextMap));
                        
                        if (not UI.PageVoteAdmin.GUI.MapList:GetSelection()) then
                            UI.PageVoteAdmin.GUI.MapList:SelectIndex(1);
                        end
                    else
                        UI.PageVoteAdmin.GUI.MapList:SelectIndex(1);
                    end
                end
            end,
        },        
        
        MapListText=
        {
            skin = UI.skins.Label,
            
            left = 175, top = 170,
            width = 140, height = 24,
            
            fontsize = 12,
            text = "Map Name";
        },
        
        MapList=
        {
            skin = UI.skins.ComboBox,
            
            left = 320, top = 170,
            width = 140, height = 24,
            
            buttonsize = 15,
            
            maxitems = 5,
            fontsize = 12,
            
            tabstop = 4,
            
            vscrollbar=
            {
                skin = UI.skins.VScrollBar,
            },           
        },

        ChangeMap=
        {
            skin = UI.skins.BottomMenuButton,
            
            text = "Change Map",
            
            tabstop = 5,
            fontsize = 14,
            
            left = 465, top = 170,
            width = 75, height = 24,
            
            OnCommand = function(Sender)
                local NewMapName = UI.PageVoteAdmin.GUI.MapList:GetSelection();
                local NewMapType = UI.PageVoteAdmin.GUI.MODList:GetSelection();
		    NewMapName=NewMapName.." "..NewMapType;
                  if (NewMapName ~= nil) then
			if (Client) then
				Client:CallVote("map",NewMapName);
			end
			end
            end            
        },
        



        RestartMapDelayText=
        {
            skin = UI.skins.Label,
            
            left = 175, top = 210,
            width = 140, height = 24,
            
		fontsize = 12,
            text = "Restart Delay (max 30)";
        },

        RestartMapDelay=
        {       
            skin = UI.skins.EditBox,

            left = 175+145, top = 210,
            width = 25, height = 24,

            fontsize = 11,            
            
            tabstop = 6,
		text="5";
        },

        RestartMap=
        {
            skin = UI.skins.BottomMenuButton,
            
            text = "Restart Map",
            
            tabstop = 7,
            fontsize = 14,
            
            left = 175+145+25, top = 210,
            width = 75, height = 24,
            
            OnCommand = function(Sender)
			local delay= tonumber(UI.PageVoteAdmin.GUI.RestartMapDelay:GetText()); 
			if ((delay == nil) or (delay > 30)) then
				delay=5;
			end
--                Game:ExecuteRConCommand("sv_restart");
			if (Client) then
				Client:CallVote("restart",delay);
			end
            end            
        },
    
        OnActivate = function(Sender)
            UI.PageVoteAdmin.GUI.MODList:Clear();

            for name, MOD in AvailableMODList do
                UI.PageVoteAdmin.GUI.MODList:AddItem(name);
            end
            UI.PageVoteAdmin.RefreshLevelList();

            UI.PageVoteAdmin.RefreshWidgets();
        end,

        OnUpdate = function(Sender)
            
        end,
    },
       
    PopulateMapList = function()
        local szMOD = UI.PageVoteAdmin.GUI.MODList:GetSelection();
        
        UI.PageVoteAdmin.GUI.MapList:Clear();
        if (szMOD) then
            local szMission = AvailableMODList[strupper(szMOD)].mission;
            
            for i, szLevelName in UI.PageVoteAdmin.LevelList[szMission] do
                UI.PageVoteAdmin.GUI.MapList:AddItem(szLevelName);
            end
        end
        
        UI.PageVoteAdmin.GUI.MapList:SelectIndex(1);
    end,
    
    RefreshLevelList = function()
        UI.PageVoteAdmin.LevelList = {};
        
        -- create the tables
        for name, MOD in AvailableMODList do
            local szMission = MOD.mission;
            
            UI.PageVoteAdmin.LevelList[szMission] = {};
        end

        -- request level list from game 
        local LevelList = Game:GetLevelList();
    
        -- go through all the levels
        for LevelIndex, Level in LevelList do
            -- all mission names
            for MissionIndex, MissionName in Level.MissionList do
                -- get the mission names that are supported, and insert them in the appropriate table
                for name, AvailableMOD in AvailableMODList do
                    local szMission = AvailableMOD.mission;
            
                    if (strlower(MissionName) == strlower(szMission)) then
                        tinsert(UI.PageVoteAdmin.LevelList[szMission], Level.Name);
                        -- tinsert adds a "n" key, so we just remove it here
                        UI.PageVoteAdmin.LevelList[szMission].n = nil;
                        break;
                    end
                end
            end
        end
    end,

    RefreshWidgets = function()
        local GUI = UI.PageVoteAdmin.GUI;

        if (g_GameType and (g_GameType ~= "Default")) then
            GUI.MODList:Select(g_GameType);
        else
            GUI.MODList:SelectIndex(1);
        end 
        GUI.MODList.OnChanged(GUI.MODList);
        
        if (getglobal("gr_NextMap")) then
            GUI.MapList:Select(getglobal("gr_NextMap"));
        else
            GUI.MapList:SelectIndex(1);
        end
        
        if (g_LastIP ~= nil) then
            --GUI.ServerIP:SetText(g_LastIP);
        end
    end,
}

AddUISideMenu(UI.PageVoteAdmin.GUI,
{
    { "MainMenu", Localize("MainMenu"), "$MainScreen$", 0},
    { "Options", Localize("Options"), "Options", },
});

UI:CreateScreenFromTable("VoteAdmin", UI.PageVoteAdmin.GUI);
