UI.PageServerAdmin=
{
    LevelList={},       -- { missionname1={}, missionname2={}, }
    
    GUI =
    {   
        ServerAdminText=
        {
            skin = UI.skins.Label,
            
            left = 200, top = 110,
            width = 122, 
            halign = UIALIGN_LEFT,
            
            text = "Server Admin";
        },
        
        ServerIPText=
        {
            skin = UI.skins.Label,
            
            left = 350, top = 110,
            width = 50, height = 24,
            
            fontsize = 11,
            text = "Server IP";
        },
        
        ServerIP=
        {
            skin = UI.skins.EditBox,
            
            left = 405, top = 110,
            width = 100, height = 24,
            
            tabstop = 1,
            
            fontsize = 11,
            
            maxlength = 26,
        },

        RCONPasswordText=
        {
            skin = UI.skins.Label,
            
            left = 510, top = 110,
            width = 65, height = 24,
            fontsize = 11,
            text = "RCON Password";      
        },
        
        RCONPassword=
        {
            skin = UI.skins.EditBox,
            
            left = 580, top = 110,
            width = 100, height = 24,
            
            style = UISTYLE_PASSWORD,
            
            fontsize = 12,
            fontsize = 11,
            tabstop = 2,
            maxlength = 28,
        },
        
        RCONLogin=
        {
            skin = UI.skins.TopMenuButton,

            text = "RCON Login",
            
            left = 680, top = 110,
            width = 100, height = 24,
            
            tabstop = 3,
            fontsize = 11,
            
            OnCommand = function(Sender)
                local GUI = UI.PageServerAdmin.GUI;

                local szServerIP = GUI.ServerIP:GetText();
                local szRCONPassword = GUI.RCONPassword:GetText();

                if ((szServerIP ~= nil) and (szServerIP ~= 0)) then
			setglobal("cl_rcon_serverip", szServerIP);
		    end
                setglobal("cl_rcon_password", szRCONPassword);
		    UI.PageServerAdmin.RefreshWidgets();
		    UI.PageServerAdmin.RefreshCheckbox();

            end            
        },

        RCONServerNameText=
        {
            skin = UI.skins.Label,
            
            left = 175, top = 110+(24+6)*1,
            width = 120, height = 24,
            
            fontsize = 11,
            text = "Server Name";
        },
        
        RCONServerName=
        {
            skin = UI.skins.EditBox,
            
            left = 300, top = 110+(24+6)*1,
            width = 210, height = 24,
            
            fontsize = 11,
            
            tabstop = 4,
                     
        },

        ChangeServerName=
        {
            skin = UI.skins.BottomMenuButton,
            
            text = "Set Name",
            
            tabstop = 5,
            fontsize = 11,

            left = 515, top = 110+(24+6)*1,
            width = 85, height = 24,

            OnCommand = function(Sender)
                local NewServerName = UI.PageServerAdmin.GUI.RCONServerName:GetText();
                if (NewServerName ~= nil) then
				if (Game:IsServer()) then
      	                         System:ExecuteCommand("sv_name "..NewServerName);
				else
	                        Game:ExecuteRConCommand("sv_name "..NewServerName);
				end
                end
            end            
        },
        
        RCONSetPasswordText=
        {
            skin = UI.skins.Label,
            
            left = 175, top = 110+(24+6)*2,
            width = 120, height = 24,
            
            fontsize = 11,
            text = "Server Password";
        },
        
        RCONSetPassword=
        {       
            skin = UI.skins.EditBox,

            left = 300, top = 110+(24+6)*2,
            width = 120, height = 24,

            fontsize = 11,            
            
            tabstop = 8,
        },
        
        SetServerPassword=
        {
            skin = UI.skins.BottomMenuButton,
            
            text = "Set",
            
            tabstop = 9,
            fontsize = 11,
            
            left = 425, top = 110+(24+6)*2,
            width = 40, height = 24,
            
            OnCommand = function(Sender)
                if (UI.PageServerAdmin.GUI.RCONSetPassword:GetText() ~= nil) then
				if (Game:IsServer()) then
      	                  System:ExecuteCommand("sv_password "..UI.PageServerAdmin.GUI.RCONSetPassword:GetText());
				else
	                        Game:ExecuteRConCommand("sv_password "..UI.PageServerAdmin.GUI.RCONSetPassword:GetText());
				end
                end
            end,           
        },
        
        RemoveServerPassword=
        {
            skin = UI.skins.BottomMenuButton,
            
            text = "Remove",

            tabstop = 10,
            fontsize = 11,
            
            left = 470, top = 110+(24+6)*2,
            width = 40, height = 24,
            
            OnCommand = function(Sender)
				if (Game:IsServer()) then
      	                  System:ExecuteCommand("sv_password ".."\"".."0".."\"");
				else
               			Game:ExecuteRConCommand("sv_password ".."\"".."0".."\"");
				end
            end,           
        },

        ShowServerPassword=
        {
            skin = UI.skins.BottomMenuButton,
            
            text = "Show Password",

            tabstop = 12,
            fontsize = 11,
            
            left = 515, top = 110+(24+6)*2,
            width = 85, height = 24,
            
            OnCommand = function(Sender)
				if (Game:IsServer()) then
      	                  System:ExecuteCommand("sv_password");
				else
		                Game:ExecuteRConCommand("sv_password");
				end
                System:ShowConsole(1);
            end            
        },        
        
        RCONPlayerListText=
        {
            skin = UI.skins.Label,
            
            left = 155, top = 105+(24+6)*11,
            width = 120, height = 24,

            fontsize = 11,
            text = "Player ID";
        },

        RCONPlayerList=
        {
            skin = UI.skins.EditBox,

            left = 280, top = 105+(24+6)*11,
            width = 34, height = 24,

            fontsize = 11,
            
            tabstop = 21,
        },
        
        BanPlayer=
        {
            skin = UI.skins.BottomMenuButton,
            
            text = "Ban",
            
            tabstop = 22,
            fontsize = 11,

            left = 317, top = 105+(24+6)*11,
            width = 40, height = 24,
            
            OnCommand = function(Sender)
                if (UI.PageServerAdmin.GUI.RCONPlayerList:GetText() ~= nil) then
                        local PlayerToBan = UI.PageServerAdmin.GUI.RCONPlayerList:GetText();
				if (Game:IsServer()) then
      	                  System:ExecuteCommand("banid "..PlayerToBan);
				else
	                        Game:ExecuteRConCommand("banid "..PlayerToBan);
				end
                        System:ShowConsole(1);
                end
            end,           
        },
        
        KickPlayer=
        {
            skin = UI.skins.BottomMenuButton,
            
            text = "Kick",

            tabstop = 23,
            fontsize = 11,
            
            left = 361, top = 105+(24+6)*11,
            width = 40, height = 24,
            
            OnCommand = function(Sender)
                if (UI.PageServerAdmin.GUI.RCONPlayerList:GetText() ~= nil) then
                        local PlayerToKick = UI.PageServerAdmin.GUI.RCONPlayerList:GetText();
				if (Game:IsServer()) then
      	                  System:ExecuteCommand("kickid "..PlayerToKick);
				else
	                        Game:ExecuteRConCommand("kickid "..PlayerToKick);
				end
                        System:ShowConsole(1);
                end
            end,
        },
        
        UnbanPlayer=
        {
            skin = UI.skins.BottomMenuButton,
            
            text = "Unban",

            tabstop = 24,
            fontsize = 11,
            
            left = 405, top = 105+(24+6)*11,
            width = 40, height = 24,
            
            OnCommand = function(Sender)
                if (UI.PageServerAdmin.GUI.RCONPlayerList:GetText() ~= nil) then
				if (Game:IsServer()) then
      	                  System:ExecuteCommand("unban "..UI.PageServerAdmin.GUI.RCONPlayerList:GetText());
				else
	                        Game:ExecuteRConCommand("unban "..UI.PageServerAdmin.GUI.RCONPlayerList:GetText());
				end
                        System:ShowConsole(1);
                end
            end,
        },
        MoveRedPlayer=
        {
            skin = UI.skins.BottomMenuButton,

            text = "> Red",

            tabstop = 25,
            fontsize = 11,
            
            left = 405+44, top = 105+(24+6)*11,
            width = 40, height = 24,
            
            OnCommand = function(Sender)
                if (UI.PageServerAdmin.GUI.RCONPlayerList:GetText() ~= nil) then
				if (Game:IsServer()) then
      	                  System:ExecuteCommand("gr_move "..UI.PageServerAdmin.GUI.RCONPlayerList:GetText().." red");
				else
	                        Game:ExecuteRConCommand("gr_move "..UI.PageServerAdmin.GUI.RCONPlayerList:GetText().." red");
				end
                        System:ShowConsole(1);
                end
            end,
        },
        MoveBluePlayer=
        {
            skin = UI.skins.BottomMenuButton,

            text = "> Blue",

            tabstop = 26,
            fontsize = 11,

            left = 405+44+44, top = 105+(24+6)*11,
            width = 40, height = 24,

            OnCommand = function(Sender)
                if (UI.PageServerAdmin.GUI.RCONPlayerList:GetText() ~= nil) then
				if (Game:IsServer()) then
      	                  System:ExecuteCommand("gr_move "..UI.PageServerAdmin.GUI.RCONPlayerList:GetText().." blue");
				else
	                        Game:ExecuteRConCommand("gr_move "..UI.PageServerAdmin.GUI.RCONPlayerList:GetText().." blue");
				end
                        System:ShowConsole(1);
                end
            end,
        },
        
        
        
        ListBans=
        {
            skin = UI.skins.BottomMenuButton,
            
            text = "List Banned Players",
            
            tabstop = 28,
            fontsize = 11,
            left = 245+140, width = 127,
            --top = 100+(24+6)*10,
            OnCommand = function(Sender)
				if (Game:IsServer()) then
      	                  System:ExecuteCommand("listban");
				else
		                Game:ExecuteRConCommand("listban");
				end
                System:ShowConsole(1);
            end            
        },

        ListActivePlayers=
        {
            skin = UI.skins.BottomMenuButton,

            text = "List Active Players",
            
            tabstop = 27,
            fontsize = 11,
            left = 244, width = 127,
            --top = 100+(24+6)*10,
            
            OnCommand = function(Sender)
                System:ExecuteCommand("gr_list");
                System:ShowConsole(1);
            end
        },

        RCONMODListText=
        {
            skin = UI.skins.Label,
            
            left = 510, top = 110+(24+6)*9,
            width = 120, height = 24,
            
            fontsize = 11,
            text = "Map Type";
        },
        
        RCONMODList=
        {
            skin = UI.skins.ComboBox,

            left = 510+125, top = 110+(24+6)*9,
            width = 120, height = 24,
            
            buttonsize = 15,
            
            maxitems = 5,
            fontsize = 11, 
            
            tabstop = 31,

            vscrollbar=
            {
                skin = UI.skins.VScrollBar,
            },      
            
            OnChanged = function(Sender)
                UI.PageServerAdmin.PopulateRCONMapList();
                
                if (UI.PageServerAdmin.GUI.RCONMapList:GetItemCount()) then
                
                    if (getglobal(gr_NextMap)) then
                        UI.PageServerAdmin.GUI.RCONMapList:Select(tostring(gr_NextMap));
                        
                        if (not UI.PageServerAdmin.GUI.RCONMapList:GetSelection()) then
                            UI.PageServerAdmin.GUI.RCONMapList:SelectIndex(1);
                        end
                    else
                        UI.PageServerAdmin.GUI.RCONMapList:SelectIndex(1);
                    end
                end
            end,
        },
        
        RCONMapListText=
        {
            skin = UI.skins.Label,
            
            left = 510, top = 110+(24+6)*10,
            width = 120, height = 24,

            fontsize = 11,
            text = "Map Name";
        },
        
        RCONMapList=
        {
            skin = UI.skins.ComboBox,
            
            left = 510+125, top = 110+(24+6)*10,
            width = 120, height = 24,
            
            buttonsize = 15,
            
            maxitems = 5,
            fontsize = 11,
            
            tabstop = 32,
            
            vscrollbar=
            {
                skin = UI.skins.VScrollBar,
            },
        },

        ChangeMap=
        {
            skin = UI.skins.BottomMenuButton,

            text = "Change Map",
            
            tabstop = 35,
            fontsize = 11,
            
            left = 575+60+60+5, top = 105+(24+6)*11,
            width = 55, height = 24,
            
            OnCommand = function(Sender)
                if (UI.PageServerAdmin.GUI.RCONMapList:GetSelection() ~= nil) then
                        local NewMapName = UI.PageServerAdmin.GUI.RCONMapList:GetSelection();
				if (Game:IsServer()) then
      	                  --System:ExecuteCommand("sv_changemap "..NewMapName.." "..getglobal("g_gametype"));
					System:ExecuteCommand("sv_changemap "..NewMapName.." "..UI.PageServerAdmin.GUI.RCONMODList:GetSelection());
				else
                        	--Game:ExecuteRConCommand("sv_changemap "..NewMapName.." "..getglobal("g_gametype"));
					Game:ExecuteRConCommand("sv_changemap "..NewMapName.." "..UI.PageServerAdmin.GUI.RCONMODList:GetSelection())
				end
                end
            end
        },

        RCONRestartDelay=
        {       
            skin = UI.skins.EditBox,

            left = 575+20, top = 105+(24+6)*11,
            width = 24, height = 24,

            fontsize = 11,            
            
            tabstop = 33,
        },

        RestartMap=
        {
            skin = UI.skins.BottomMenuButton,
            
            text = "Restart Map",
            
            tabstop = 34,
            fontsize = 11,
            
            left = 575+20+24, top = 105+(24+6)*11,
            width = 55, height = 24,

            OnCommand = function(Sender)
			local delay= UI.PageServerAdmin.GUI.RCONRestartDelay:GetText() 
			if (delay == nil) then
				delay=tonumber(getglobal("gr_map_restart_delay"));
			else
				setglobal("gr_map_restart_delay", delay);
			end

				if (Game:IsServer()) then
      	                  System:ExecuteCommand("sv_restart "..delay);
				else
		                Game:ExecuteRConCommand("sv_restart "..delay);
				end
            end
        },

        RCONRespawnTimeText=
        {
            skin = UI.skins.Label,
            
            left = 175, top = 110+(24+6)*3,
            width = 120, height = 24,

            fontsize = 11,
            text = "Respawn Time (sec)";
        },
        
        RCONRespawnTime=
        {       
            skin = UI.skins.EditBox,

            left = 300, top = 110+(24+6)*3,
            width = 34, height = 24,

            fontsize = 11,            
            
            tabstop = 50,
        },
        
        SetRespawnTime=
        {
            skin = UI.skins.BottomMenuButton,
            
            text = "Set",

            tabstop = 51,
            fontsize = 11,
            
            left = 341, top = 110+(24+6)*3,
            width = 40, height = 24,
            
            OnCommand = function(Sender)
                if (UI.PageServerAdmin.GUI.RCONRespawnTime:GetText() ~= nil) then
				if (not Game:IsServer()) then
	                        Game:ExecuteRConCommand("gr_RespawnTime "..UI.PageServerAdmin.GUI.RCONRespawnTime:GetText());
				end
				System:ExecuteCommand("gr_RespawnTime "..UI.PageServerAdmin.GUI.RCONRespawnTime:GetText());
                end
            end,
        },
        
        RCONMapTimeText=
        {
            skin = UI.skins.Label,
            
            left = 175, top = 110+(24+6)*4,
            width = 120, height = 24,
            
            fontsize = 11,
            text = "Map Time (min)";
        },
        
        RCONMapTime=
        {
            skin = UI.skins.EditBox,

            left = 300, top = 110+(24+6)*4,
            width = 34, height = 24,

            fontsize = 11,            

            tabstop = 52,
        },
        
        SetMapTime=
        {
            skin = UI.skins.BottomMenuButton,
            
            text = "Set",

            tabstop = 53,
            fontsize = 11,
            
            left = 341, top = 110+(24+6)*4,
            width = 40, height = 24,
            
            OnCommand = function(Sender)
                if (UI.PageServerAdmin.GUI.RCONMapTime:GetText() ~= nil) then
				if (not Game:IsServer()) then
      	                Game:ExecuteRConCommand("gr_TimeLimit "..UI.PageServerAdmin.GUI.RCONMapTime:GetText());
				end
                        System:ExecuteCommand("gr_TimeLimit "..UI.PageServerAdmin.GUI.RCONMapTime:GetText());
                end
            end,           
        },


        RCONMaxTeamLimitText=
        {
            skin = UI.skins.Label,
            
            left = 175, top = 110+(24+6)*5,
            width = 120, height = 24,

            fontsize = 11,
            text = "Max Team Limit";
        },
        
        RCONMaxTeamLimit=
        {       
            skin = UI.skins.EditBox,

            left = 300, top = 110+(24+6)*5,
            width = 34, height = 24,

            fontsize = 11,
            
            tabstop = 54,
        },
        
        SetMaxTeamLimit=
        {
            skin = UI.skins.BottomMenuButton,
            
            text = "Set",
            
            tabstop = 55,
            fontsize = 11,

            left = 341, top = 110+(24+6)*5,
            width = 40, height = 24,
            
            OnCommand = function(Sender)
                if (UI.PageServerAdmin.GUI.RCONMaxTeamLimit:GetText() ~= nil) then
				if (not Game:IsServer()) then
		                Game:ExecuteRConCommand("gr_MaxTeamLimit "..UI.PageServerAdmin.GUI.RCONMaxTeamLimit:GetText());
				end
                System:ExecuteCommand("gr_MaxTeamLimit "..UI.PageServerAdmin.GUI.RCONMaxTeamLimit:GetText());
                end
            end,
        },
        
        RCONMaxAvgPingText=
        {
            skin = UI.skins.Label,

            left = 175, top = 110+(24+6)*6,
            width = 120, height = 24,
            
            fontsize = 11,
            text = "Max Avg Ping";
        },
        
        RCONMaxAvgPing=
        {       
            skin = UI.skins.EditBox,

            left = 300, top = 110+(24+6)*6,
            width = 34, height = 24,

            fontsize = 11,
            
            tabstop = 56,
        },
        
        SetMaxAvgPing=
        {
            skin = UI.skins.BottomMenuButton,
            
            text = "Set",

            tabstop = 57,
            fontsize = 11,

            left = 341, top = 110+(24+6)*6,
            width = 40, height = 24,
            
            OnCommand = function(Sender)
                if (UI.PageServerAdmin.GUI.RCONMaxAvgPing:GetText() ~= nil) then
				if (not Game:IsServer()) then
		                Game:ExecuteRConCommand("gr_max_average_ping "..UI.PageServerAdmin.GUI.RCONMaxAvgPing:GetText());
				end
                System:ExecuteCommand("gr_max_average_ping "..UI.PageServerAdmin.GUI.RCONMaxAvgPing:GetText());
                end
            end,           
        },

        RCONPingWarningsText=
        {
            skin = UI.skins.Label,
            
            left = 175, top = 110+(24+6)*7,
            width = 120, height = 24,
            
            fontsize = 11,
            text = "Ping Warnings";
        },
        RCONPingWarnings=
        {       
            skin = UI.skins.EditBox,

            left = 175+125, top = 110+(24+6)*7,
            width = 34, height = 24,

            fontsize = 11,
            
            tabstop = 58,
        },

        SetPingWarnings=
        {
            skin = UI.skins.BottomMenuButton,

            text = "Set",
            
            tabstop = 59,
            fontsize = 11,

            left = 175+125+41, top = 110+(24+6)*7,
            width = 40, height = 24,

            OnCommand = function(Sender)
                if (UI.PageServerAdmin.GUI.RCONPingWarnings:GetText() ~= nil) then
				if (not Game:IsServer()) then
		                Game:ExecuteRConCommand("gr_ping_warnings "..UI.PageServerAdmin.GUI.RCONPingWarnings:GetText());
				end
                System:ExecuteCommand("gr_ping_warnings "..UI.PageServerAdmin.GUI.RCONPingWarnings:GetText());
                end
            end,
        },
        RCONMaxTKText=
        {
            skin = UI.skins.Label,
            
            left = 175, top = 110+(24+6)*8,
            width = 120, height = 24,
            
            fontsize = 11,
            text = "TK Limit";
        },
        RCONMaxTK=
        {       
            skin = UI.skins.EditBox,

            left = 175+125, top = 110+(24+6)*8,
            width = 34, height = 24,

            fontsize = 11,
            
            tabstop = 60,
        },

        SetMaxTK=
        {
            skin = UI.skins.BottomMenuButton,
            
            text = "Set",

            tabstop = 61,
            fontsize = 11,

            left = 175+125+41, top = 110+(24+6)*8,
            width = 40, height = 24,

            OnCommand = function(Sender)
                if (UI.PageServerAdmin.GUI.RCONMaxTK:GetText() ~= nil) then
				if (not Game:IsServer()) then
		                Game:ExecuteRConCommand("gr_teamkill_force_spectate "..UI.PageServerAdmin.GUI.RCONMaxTK:GetText());
				end
                System:ExecuteCommand("gr_teamkill_force_spectate "..UI.PageServerAdmin.GUI.RCONMaxTK:GetText());
                end
            end,           
        },
        RCONTimeperTKText=
        {
            skin = UI.skins.Label,
            
            left = 175, top = 110+(24+6)*9,
            width = 120, height = 24,
            
            fontsize = 11,
            text = "Extra Time per TK";
        },
        RCONTimeperTK=
        {       
            skin = UI.skins.EditBox,

            left = 175+125, top = 110+(24+6)*9,
            width = 34, height = 24,

            fontsize = 11,
            
            tabstop = 62,
        },

        SetTimeperTK=
        {
            skin = UI.skins.BottomMenuButton,
            
            text = "Set",

            tabstop = 63,
            fontsize = 11,

            left = 175+125+41, top = 110+(24+6)*9,
            width = 40, height = 24,

            OnCommand = function(Sender)
                if (UI.PageServerAdmin.GUI.RCONTimeperTK:GetText() ~= nil) then
				if (not Game:IsServer()) then
		                Game:ExecuteRConCommand("gr_teamkill_extra_time "..UI.PageServerAdmin.GUI.RCONTimeperTK:GetText());
				end
                System:ExecuteCommand("gr_teamkill_extra_time "..UI.PageServerAdmin.GUI.RCONTimeperTK:GetText());
                end
            end,
        },


        FriendlyFireText=
        {
            skin = UI.skins.Label,
            left = 371, top = 110+(24+6)*3,
            width = 120, height = 24,
            
            fontsize = 11,
            
            text = "Friendly Fire";
        },
        
        FriendlyFire=
        {
            skin = UI.skins.CheckBox,
            left = 371+125, top = 110+(24+6)*3,
            width = 24, height = 24,

            tabstop = 80,

            OnChanged = function(self)
                if(self:GetChecked()) then
				if (not Game:IsServer()) then
	                    Game:ExecuteRConCommand("gr_friendlyfire 1");
				end
                    System:ExecuteCommand("gr_friendlyfire 1");
                else
				if (not Game:IsServer()) then
	                    Game:ExecuteRConCommand("gr_friendlyfire 0");
				end
                    System:ExecuteCommand("gr_friendlyfire 0");
                end
            end,
        },

        AllowTKText=
        {
            skin = UI.skins.Label,
            left = 371, top = 110+(24+6)*4,
            width = 120, height = 24,
            
            fontsize = 11,
            
            text = "Team Kill Allow";
        },
        
        AllowTK=
        {
            skin = UI.skins.CheckBox,
            left = 371+125, top = 110+(24+6)*4,
            width = 24, height = 24,

            tabstop = 81,

            OnChanged = function(self)
                if(self:GetChecked()) then
				if (not Game:IsServer()) then
	                    Game:ExecuteRConCommand("gr_allow_teamkilling 1");
				end
                    System:ExecuteCommand("gr_allow_teamkilling 1");
                else
				if (not Game:IsServer()) then
	                    Game:ExecuteRConCommand("gr_allow_teamkilling 0");
				end
                    System:ExecuteCommand("gr_allow_teamkilling 0");
                end
            end,
        },

        StopWatchText=
        {
            skin = UI.skins.Label,
            left = 371, top = 110+(24+6)*5,
            width = 120, height = 24,

            fontsize = 11,

            text = "Stopwatch";
        },
        
        StopWatch=
        {
            skin = UI.skins.CheckBox,
            left = 371+125, top = 110+(24+6)*5,
            width = 24, height = 24,
            
            tabstop = 82,

            OnChanged = function(self)
                if(self:GetChecked()) then
				if (not Game:IsServer()) then
	                    Game:ExecuteRConCommand("gr_fulltime 0");
				end
                    System:ExecuteCommand("gr_fulltime 0");
                else
				if (not Game:IsServer()) then
	                    Game:ExecuteRConCommand("gr_fulltime 1");
				end
                    System:ExecuteCommand("gr_fulltime 1");
                end
            end,
        },

        StaticRespawnText=
        {
            skin = UI.skins.Label,
            left = 371, top = 110+(24+6)*6,
            width = 120, height = 24,

            fontsize = 11,

            text = "Static Respawn";
        },

        StaticRespawn=
        {
            skin = UI.skins.CheckBox,
            left = 371+125, top = 110+(24+6)*6,
            width = 24, height = 24,
            
            tabstop = 83,

            OnChanged = function(self)
                if(self:GetChecked()) then
				if (not Game:IsServer()) then
	                    Game:ExecuteRConCommand("gr_static_respawn 1");
				end
                    System:ExecuteCommand("gr_static_respawn 1");
                else
				if (not Game:IsServer()) then
	                    Game:ExecuteRConCommand("gr_static_respawn 0");
				end
                    System:ExecuteCommand("gr_static_respawn 0");
                end
            end,
        },
        CrossNameText=
        {
            skin = UI.skins.Label,
            left = 371, top = 110+(24+6)*7,
            width = 120, height = 24,

            fontsize = 11,

            text = "Show Enemy Names";
        },

        CrossName=
        {
            skin = UI.skins.CheckBox,
            left = 371+125, top = 110+(24+6)*7,
            width = 24, height = 24,
            
            tabstop = 84,

            OnChanged = function(self)
                if(self:GetChecked()) then
				if (not Game:IsServer()) then
	                    Game:ExecuteRConCommand("gr_crossname 1");
				end
                    System:ExecuteCommand("gr_crossname 1");
                else
				if (not Game:IsServer()) then
	                    Game:ExecuteRConCommand("gr_crossname 0");
				end
                    System:ExecuteCommand("gr_crossname 0");
                end
            end,
        },
	  RealReloadText=
        {
            skin = UI.skins.Label,
           left = 371, top = 110+(24+6)*9,
            width = 120, height = 24,

            fontsize = 11,

            text = "Realistic Reload";
        },

        RealReload=
        {
            skin = UI.skins.CheckBox,
            left = 371+125, top = 110+(24+6)*9,
            width = 24, height = 24,
            
            tabstop = 85,

            OnChanged = function(self)
                if(self:GetChecked()) then
				if (not Game:IsServer()) then
	                    Game:ExecuteRConCommand("gr_realistic_reload 1");
				end
                    System:ExecuteCommand("gr_realistic_reload 1");
                else
				if (not Game:IsServer()) then
	                    Game:ExecuteRConCommand("gr_realistic_reload 0");
				end
                    System:ExecuteCommand("gr_realistic_reload 0");
                end
            end,
        },

        LockTeamText=
        {
            skin = UI.skins.Label,
            left = 371, top = 110+(24+6)*8,
            width = 120, height = 24,

            fontsize = 11,

            text = "Lock Team: Red";
        },

        LockTeamRed=
        {
            skin = UI.skins.CheckBox,
            left = 371+125, top = 110+(24+6)*8,
            width = 24, height = 24,
            
            tabstop = 86,
            
            OnChanged = function(self)
                if(self:GetChecked()) then
				if (Game:IsServer()) then
      	                  System:ExecuteCommand("gr_lock red");
				else
	                    Game:ExecuteRConCommand("gr_lock red");
				end
                else
				if (Game:IsServer()) then
      	                  System:ExecuteCommand("gr_unlock red");
				else
	                   Game:ExecuteRConCommand("gr_unlock red");
				end
                end
            end,
        },
        LockTeamBlueText=
        {
            skin = UI.skins.Label,
            left = 371+125+25, top = 110+(24+6)*8,
            width = 40, height = 24,

            fontsize = 11,

            text = "Blue";
        },

        LockTeamBlue=
        {
            skin = UI.skins.CheckBox,
            left = 371+125+25+40, top = 110+(24+6)*8,
            width = 24, height = 24,
            
            tabstop = 87,
            
            OnChanged = function(self)
                if(self:GetChecked()) then
				if (Game:IsServer()) then
      	                  System:ExecuteCommand("gr_lock blue");
				else
	                    Game:ExecuteRConCommand("gr_lock blue");
				end
                else
				if (Game:IsServer()) then
      	                  System:ExecuteCommand("gr_unlock blue");
				else
		                   Game:ExecuteRConCommand("gr_unlock blue");
				end
                end
            end,
        },
        
        WeapWarningText=
        {
            skin = UI.skins.Label,
            left = 535, top = 110+(24+6)*3,
            width = 240, height = 24,
            
            fontsize = 11,

            text = "Note: Weapon changes below require a new map load";
        },

        
        RLText=
        {
            skin = UI.skins.Label,
            left = 560, top = 110+(24+6)*4,
            width = 120, height = 24,
            
            fontsize = 11,

            text = "Max Rocket Ammo";
        },
        RCONRL=
        {       
            skin = UI.skins.EditBox,

            left = 560+125, top = 110+(24+6)*4,
            width = 34, height = 24,

            fontsize = 11,
            
            tabstop = 90,
        },

        SetRL=
        {
            skin = UI.skins.BottomMenuButton,

            text = "Set",
            
            tabstop = 91,
            fontsize = 11,

            left = 560+125+41, top = 110+(24+6)*4,
            width = 40, height = 24,

            OnCommand = function(Sender)
                if (UI.PageServerAdmin.GUI.RCONRL:GetText() ~= nil) then
					if (not Game:IsServer()) then
						Game:ExecuteRConCommand("gr_max_rockets "..UI.PageServerAdmin.GUI.RCONRL:GetText());
						Game:ExecuteRConCommand("gr_initial_rockets "..UI.PageServerAdmin.GUI.RCONRL:GetText());
					end
					System:ExecuteCommand("gr_max_rockets "..UI.PageServerAdmin.GUI.RCONRL:GetText());
					System:ExecuteCommand("gr_initial_rockets "..UI.PageServerAdmin.GUI.RCONRL:GetText());
				end
            end,           
        },
        OICWGLText=
        {
            skin = UI.skins.Label,
            left = 560, top = 110+(24+6)*5,
            width = 120, height = 24,
            
            fontsize = 11,

            text = "Max OICW GL";
        },
        RCONOICWGL=
        {       
            skin = UI.skins.EditBox,

            left = 560+125, top = 110+(24+6)*5,
            width = 34, height = 24,

            fontsize = 11,

            tabstop = 92,
        },

        SetOICWGL=
        {
            skin = UI.skins.BottomMenuButton,

            text = "Set",
            
            tabstop = 93,
            fontsize = 11,

            left = 560+125+41, top = 110+(24+6)*5,
            width = 40, height = 24,

            OnCommand = function(Sender)
                if (UI.PageServerAdmin.GUI.RCONOICWGL:GetText() ~= nil) then
					if (not Game:IsServer()) then
						Game:ExecuteRConCommand("gr_max_oicw_nades "..UI.PageServerAdmin.GUI.RCONOICWGL:GetText());
						Game:ExecuteRConCommand("gr_initial_oicw_nades "..UI.PageServerAdmin.GUI.RCONOICWGL:GetText());
					end
					System:ExecuteCommand("gr_max_oicw_nades "..UI.PageServerAdmin.GUI.RCONOICWGL:GetText());
					System:ExecuteCommand("gr_initial_oicw_nades "..UI.PageServerAdmin.GUI.RCONOICWGL:GetText());
				end
            end,           
        },
        AG36GLText=
        {
            skin = UI.skins.Label,
            left = 560, top = 110+(24+6)*6,
            width = 120, height = 24,
            
            fontsize = 11,

            text = "Max AG36 GL";
        },
        RCONAG36GL=
        {       
            skin = UI.skins.EditBox,

            left = 560+125, top = 110+(24+6)*6,
            width = 34, height = 24,

            fontsize = 11,

            tabstop = 94,
        },
        
        SetAG36GL=
        {
            skin = UI.skins.BottomMenuButton,

            text = "Set",
            
            tabstop = 95,
            fontsize = 11,

            left = 560+125+41, top = 110+(24+6)*6,
            width = 40, height = 24,

            OnCommand = function(Sender)
                if (UI.PageServerAdmin.GUI.RCONAG36GL:GetText() ~= nil) then
					if (not Game:IsServer()) then
						Game:ExecuteRConCommand("gr_max_ag36_nades "..UI.PageServerAdmin.GUI.RCONAG36GL:GetText());
						Game:ExecuteRConCommand("gr_initial_ag36_nades "..UI.PageServerAdmin.GUI.RCONAG36GL:GetText());
					end
					System:ExecuteCommand("gr_max_ag36_nades "..UI.PageServerAdmin.GUI.RCONAG36GL:GetText());
					System:ExecuteCommand("gr_initial_ag36_nades "..UI.PageServerAdmin.GUI.RCONAG36GL:GetText());
				end
            end,
        },
        DamageScaleText=
        {
            skin = UI.skins.Label,
            left = 560, top = 110+(24+6)*7,
            width = 120, height = 24,

            fontsize = 11,

            text = "Damage Scale";
        },
        RCONDamageScale=
        {       
            skin = UI.skins.EditBox,

            left = 560+125, top = 110+(24+6)*7,
            width = 34, height = 24,

            fontsize = 11,
            
            tabstop = 96,
        },

        SetDamageScale=
        {
            skin = UI.skins.BottomMenuButton,

            text = "Set",
            
            tabstop = 97,
            fontsize = 11,

            left = 560+125+41, top = 110+(24+6)*7,
            width = 40, height = 24,

            OnCommand = function(Sender)
                if (UI.PageServerAdmin.GUI.RCONDamageScale:GetText() ~= nil) then
				if (not Game:IsServer()) then
		                Game:ExecuteRConCommand("gr_customdamagescale "..UI.PageServerAdmin.GUI.RCONDamageScale:GetText());
				end
                System:ExecuteCommand("gr_customdamagescale "..UI.PageServerAdmin.GUI.RCONDamageScale:GetText());
                end
            end,
        },


    
        SwitchTeam=
        {
            skin = UI.skins.BottomMenuButton,
            
            text = "Switch Sides",
            
            tabstop = 36,
            fontsize = 11,

            left = 635, width = 115,

            OnCommand = function(Sender)
				if (Game:IsServer()) then
      	                System:ExecuteCommand("gr_switchteams");
				else
		                Game:ExecuteRConCommand("gr_switchteams");
				end
            end            
        },
        OnActivate = function(Sender)
            UI.PageServerAdmin.GUI.RCONMODList:Clear();

            for name, MOD in AvailableMODList do
                UI.PageServerAdmin.GUI.RCONMODList:AddItem(name);
            end
            UI.PageServerAdmin.RefreshLevelList();
            UI.PageServerAdmin.RefreshCheckbox();
            UI.PageServerAdmin.RefreshWidgets();
            UI.PageServerAdmin.RefreshValues();
        end,

        OnUpdate = function(Sender)

        end,
    },
       
    PopulateRCONMapList = function()
        local szMOD = UI.PageServerAdmin.GUI.RCONMODList:GetSelection();

        UI.PageServerAdmin.GUI.RCONMapList:Clear();
        if (szMOD) then
            local szMission = AvailableMODList[strupper(szMOD)].mission;
            
            for i, szLevelName in UI.PageServerAdmin.LevelList[szMission] do
                UI.PageServerAdmin.GUI.RCONMapList:AddItem(szLevelName);
            end
        end
        
        UI.PageServerAdmin.GUI.RCONMapList:SelectIndex(1);
    end,
    
    RefreshLevelList = function()
        UI.PageServerAdmin.LevelList = {};
        
        -- create the tables
        for name, MOD in AvailableMODList do
            local szMission = MOD.mission;
            
            UI.PageServerAdmin.LevelList[szMission] = {};
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
                        tinsert(UI.PageServerAdmin.LevelList[szMission], Level.Name);
                        -- tinsert adds a "n" key, so we just remove it here
                        UI.PageServerAdmin.LevelList[szMission].n = nil;
                        break;
                    end
                end
            end
        end
    end,

    RefreshCheckbox = function()
        if(tonumber(getglobal("gr_FriendlyFire")) == 1) then
                UI.PageServerAdmin.GUI.FriendlyFire:SetChecked(1);
        end
        if(tonumber(getglobal("gr_allow_teamkilling")) == 1) then
                UI.PageServerAdmin.GUI.AllowTK:SetChecked(1);
        end
        if(tonumber(getglobal("gr_fulltime")) == 0) then
                UI.PageServerAdmin.GUI.StopWatch:SetChecked(1);
        end
        if(tonumber(getglobal("gr_static_respawn"))  == 1) then
                UI.PageServerAdmin.GUI.StaticRespawn:SetChecked(1);
        end
        if(tonumber(getglobal("gr_realistic_reload")) == 1) then
              UI.PageServerAdmin.GUI.RealReload:SetChecked(1);
        end
        if(tonumber(getglobal("gr_CrossName")) == 1) then
                UI.PageServerAdmin.GUI.CrossName:SetChecked(1);
        end
    end,
    RefreshValues = function()
        if(tonumber(getglobal("gr_RespawnTime")) ~= nil) then
                UI.PageServerAdmin.GUI.RCONRespawnTime:SetText(tonumber(getglobal("gr_RespawnTime")));
        end
        if(tonumber(getglobal("gr_map_restart_delay")) ~= nil) then
                UI.PageServerAdmin.GUI.RCONRestartDelay:SetText(tonumber(getglobal("gr_map_restart_delay")));
        end
        if(tonumber(getglobal("gr_TimeLimit")) ~= nil) then
                UI.PageServerAdmin.GUI.RCONMapTime:SetText(tonumber(getglobal("gr_TimeLimit")));
        end
        if(tonumber(getglobal("gr_MaxTeamLimit")) ~= nil) then
                UI.PageServerAdmin.GUI.RCONMaxTeamLimit:SetText(tonumber(getglobal("gr_MaxTeamLimit")));
        end
        if(tonumber(getglobal("gr_max_average_ping")) ~= nil) then
                UI.PageServerAdmin.GUI.RCONMaxAvgPing:SetText(tonumber(getglobal("gr_max_average_ping")));
        end
        if(tonumber(getglobal("gr_ping_warnings")) ~= nil) then
                UI.PageServerAdmin.GUI.RCONPingWarnings:SetText(tonumber(getglobal("gr_ping_warnings")));
        end
        if(tonumber(getglobal("gr_teamkill_force_spectate")) ~= nil) then
                UI.PageServerAdmin.GUI.RCONMaxTK:SetText(tonumber(getglobal("gr_teamkill_force_spectate")));
        end
        if(tonumber(getglobal("gr_teamkill_extra_time")) ~= nil) then
                UI.PageServerAdmin.GUI.RCONTimeperTK:SetText(tonumber(getglobal("gr_teamkill_extra_time")));
        end
        if(tonumber(getglobal("gr_max_rockets")) ~= nil) then
                UI.PageServerAdmin.GUI.RCONRL:SetText(tonumber(getglobal("gr_max_rockets")));
        end
        if(tonumber(getglobal("gr_max_oicw_nades")) ~= nil) then
                UI.PageServerAdmin.GUI.RCONOICWGL:SetText(tonumber(getglobal("gr_max_oicw_nades")));
        end
        if(tonumber(getglobal("gr_max_ag36_nades")) ~= nil) then
                UI.PageServerAdmin.GUI.RCONAG36GL:SetText(tonumber(getglobal("gr_max_ag36_nades")));
        end
        if(tonumber(getglobal("gr_customdamagescale")) ~= nil) then
                UI.PageServerAdmin.GUI.RCONDamageScale:SetText(tonumber(getglobal("gr_customdamagescale")));
        end
    end,

    RefreshWidgets = function()

        local GUI = UI.PageServerAdmin.GUI;

        if (g_GameType and (g_GameType ~= "Default")) then
            GUI.RCONMODList:Select(g_GameType);
        else
            GUI.RCONMODList:SelectIndex(1);
        end 
        GUI.RCONMODList.OnChanged(GUI.RCONMODList);

        if (getglobal("gr_NextMap")) then
            GUI.RCONMapList:Select(getglobal("gr_NextMap"));
        else
            GUI.RCONMapList:SelectIndex(1);
        end

        GUI.RCONPassword:SetText(getglobal("cl_rcon_password"));
        if (g_LastServerName ~= nil) then
                GUI.RCONServerName:SetText(g_LastServerName);
        end

		local g_LastIP;
		if (Game:IsServer()) then
			g_LastIP = Game:GetServerIP();
		else
			g_LastIP = getglobal("g_LastIP");
		end
        if (g_LastIP ~= nil and g_LastIP ~= 0) then
            GUI.ServerIP:SetText(g_LastIP);
        end


	if (getglobal("cl_rcon_password") == "") and (not Game:IsServer()) then
			UI:DisableWidget(UI.PageServerAdmin.GUI.RCONServerName);
			UI:DisableWidget(UI.PageServerAdmin.GUI.ChangeServerName);
        		UI:DisableWidget(UI.PageServerAdmin.GUI.RCONSetPassword);
        		UI:DisableWidget(UI.PageServerAdmin.GUI.SetServerPassword);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.RemoveServerPassword);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.ShowServerPassword);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.RCONPlayerList);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.BanPlayer);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.KickPlayer);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.UnbanPlayer);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.MoveRedPlayer);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.MoveBluePlayer);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.ListBans);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.ListActivePlayers);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.RCONMODList);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.RCONMapList);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.ChangeMap);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.RCONRestartDelay);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.RestartMap);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.RCONRespawnTime);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.SetRespawnTime);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.RCONMapTime);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.SetMapTime);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.RCONMaxTeamLimit);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.SetMaxTeamLimit);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.RCONMaxAvgPing);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.SetMaxAvgPing);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.RCONPingWarnings);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.SetPingWarnings);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.RCONMaxTK);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.SetMaxTK);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.RCONTimeperTK);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.SetTimeperTK);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.FriendlyFire);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.AllowTK);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.StopWatch);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.StaticRespawn);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.RealReload);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.CrossName);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.LockTeamRed);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.LockTeamBlue);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.RCONRL);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.SetRL);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.RCONOICWGL);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.SetOICWGL);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.RCONAG36GL);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.SetAG36GL);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.RCONDamageScale);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.SetDamageScale);
		        UI:DisableWidget(UI.PageServerAdmin.GUI.SwitchTeam);



		else
			UI:EnableWidget(UI.PageServerAdmin.GUI.RCONServerName);
			UI:EnableWidget(UI.PageServerAdmin.GUI.ChangeServerName);
        		UI:EnableWidget(UI.PageServerAdmin.GUI.RCONSetPassword);
        		UI:EnableWidget(UI.PageServerAdmin.GUI.SetServerPassword);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.RemoveServerPassword);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.ShowServerPassword);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.RCONPlayerList);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.BanPlayer);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.KickPlayer);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.UnbanPlayer);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.MoveRedPlayer);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.MoveBluePlayer);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.ListBans);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.ListActivePlayers);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.RCONMODList);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.RCONMapList);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.ChangeMap);
			  UI:EnableWidget(UI.PageServerAdmin.GUI.RCONRestartDelay);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.RestartMap);  
		        UI:EnableWidget(UI.PageServerAdmin.GUI.RCONRespawnTime);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.SetRespawnTime);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.RCONMapTime);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.SetMapTime);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.RCONMaxTeamLimit);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.SetMaxTeamLimit);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.RCONMaxAvgPing);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.SetMaxAvgPing);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.RCONPingWarnings);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.SetPingWarnings);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.RCONMaxTK);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.SetMaxTK);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.RCONTimeperTK);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.SetTimeperTK);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.FriendlyFire);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.AllowTK);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.StopWatch);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.StaticRespawn);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.RealReload);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.CrossName);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.LockTeamRed);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.LockTeamBlue);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.RCONRL);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.SetRL);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.RCONOICWGL);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.SetOICWGL);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.RCONAG36GL);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.SetAG36GL);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.RCONDamageScale);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.SetDamageScale);
		        UI:EnableWidget(UI.PageServerAdmin.GUI.SwitchTeam);

		end

    end,
}

AddUISideMenu(UI.PageServerAdmin.GUI,
{
    { "MainMenu", Localize("MainMenu"), "$MainScreen$", 0},
    { "Options", Localize("Options"), "Options", },
});

UI:CreateScreenFromTable("ServerAdmin", UI.PageServerAdmin.GUI);
