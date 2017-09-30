-- this script is used to create lua side only console variables

-- passing "NetSynch" as third parameter means server synchronized (cannot be changed on client and is syncroized if changed on the server)

Game:CreateVariable("gr_ScoreLimit", 0);												--
Game:CreateVariable("gr_TimeLimit", 20, "NetSynch");												-- in minutes
Game:CreateVariable("gr_DamageScale", 1);												-- affects damage of all weapons
Game:CreateVariable("gr_HeadshotMultiplier", 2);								-- normal damage X this variable for headshots. Default 2.

Game:CreateVariable("gr_NextMap", "");													-- e.g. "mp_airstrip"

Game:CreateVariable("gr_RespawnTime", 20, "NetSynch");											-- in seconds, 0 to deactivate the respawning in waves
Game:CreateVariable("gr_PrewarOn", 0, "NetSynch");							-- 0/1=prewar gamestate on
Game:CreateVariable("gr_CountDown", 5);													-- countdown for round start

Game:CreateVariable("gr_DropFadeTime", 20, "NetSynch");					-- [1..100], time in seconds it takes for pickups to fade away

Game:CreateVariable("gr_RespawnAtDeathPos", 1);									--
Game:CreateVariable("gr_FriendlyFire", 1);											-- determines if teammates can hurt each other
Game:CreateVariable("gr_Detonate", 0, "NetSynch");							--
Game:CreateVariable("gr_votetime", 0, "NetSynch");							-- adjusts the amount of vote time.  Synch'd up with C++, so 60 secs.

Game:CreateVariable("gr_ForceTDMRespawn", 1);				-- Forces players to respawn in TDM games. 1 = true

Game:CreateVariable("gr_MinTeamLimit", "1");										-- >=1 game starts with prewar till enough players are in the game
Game:CreateVariable("gr_MaxTeamLimit", "16");										-- max number of players per side

Game:CreateVariable("gr_InvulnerabilityTimer", 5, "NetSynch");	-- Amount of time player is invulnerable after spawning

Game:CreateVariable("gr_CrossName",1,"NetSynch");								-- Determines whether enemy names appear on crosshair 

Game:CreateVariable("cl_AllowUserModels","0");									-- 1=yes/0=no, allows alternate mp models
Game:CreateVariable("gr_allow_voting",1);								-- Toggle for allowing votes - 1=Yes, 0=No

Game:CreateVariable("g_vehicleBulletDamage","1"); 							-- 0 = vehicles dont get damage from bullets, 1 = they do.
Game:CreateVariable("gr_checkpoint", "1");											-- In assault gametype, sets the current flag to capture.  Requires map restart.
Game:CreateVariable("gr_task_enable",1);												-- Turns the task list on or off
Game:CreateVariable("gr_task_autoload",1);											-- autoloads the task list on server start

Game:CreateVariable("gr_allow_teamkilling",0);  	              -- allow teamkilling (default = 0 (no))
Game:CreateVariable("gr_free_teamkills",0);             				-- number of teamkills without time punishment
Game:CreateVariable("gr_teamkill_extra_time",10);        				-- add respawntime for each teamkill after number of free_teamkills exceeded
Game:CreateVariable("gr_teamkill_kick", 1);        						-- kick each teamkill after number of free_teamkills exceeded (default = 1 = yes)
Game:CreateVariable("gr_teamkill_kick_time",10);        				-- PB kick time for each teamkill after number of free_teamkills exceeded, no PB = simple kick
Game:CreateVariable("gr_teamkill_force_spectate", 5);   				-- if player has this number of teamkills, they will only be sent to spectator
Game:CreateVariable("gr_punish_protected",1);           				-- if 'protected names' should be punished for tk's
Game:CreateVariable("gr_log_teamkillers",0);            				-- makes a log of teamkillers to teamkillers_[x].log

Game:CreateVariable("gr_spawnmessage1","");                     -- first message that will appear on hud when player spawns 
Game:CreateVariable("gr_spawnmessage2","");											-- second message that will appear on hud when player spawns
Game:CreateVariable("gr_spawnmessage3","");											-- third message that will appear on hud when player spawns
Game:CreateVariable("gr_spawnmessage4","");							        -- fourth message that will appear on hud when player spawns

Game:CreateVariable("gr_initial_ag36_nades",5); 								-- amount of AG36 nades player has when they spawn
Game:CreateVariable("gr_pickup_ag36_nades",0); 									-- amount of AG36 nades player gets when at ammobox
Game:CreateVariable("gr_droppickup_ag36_nades",2); 							-- amount of AG36 nades player gets from pickup canister
Game:CreateVariable("gr_max_ag36_nades",5); 										-- maximum of AG36 nades on a player at one time

Game:CreateVariable("gr_initial_oicw_nades",5); 	              -- amount of OICW nades player has when they spawn
Game:CreateVariable("gr_pickup_oicw_nades",0); 									-- amount of OICW nades player gets from ammobox canister
Game:CreateVariable("gr_droppickup_oicw_nades",2); 							-- amount of OICW nades player gets from pickup canister
Game:CreateVariable("gr_max_oicw_nades",5); 										-- maximum amount of OICW nades on a player at one time

Game:CreateVariable("gr_initial_rockets",5); 										-- amount of rockets player spawns with 
Game:CreateVariable("gr_pickup_rockets",0); 										-- amount of rockets player gets from ammobox canister
Game:CreateVariable("gr_droppickup_rockets",2); 								-- amount of rockets player gets from pickup canister
Game:CreateVariable("gr_max_rockets",5); 												-- maximum amount of rockets on a player at one time

Game:CreateVariable("gr_initial_sticky_explosives",3); 					-- intial amount of bombs player spawns with 
Game:CreateVariable("gr_pickup_sticky_explosives",3);           -- amount of bombs player gets from ammobox canister
Game:CreateVariable("gr_droppickup_sticky_explosives",1);       -- amount of bombs player gets from pickup canister
Game:CreateVariable("gr_max_sticky_explosives",3);              -- maximum amount of bombs on a player at one time

Game:CreateVariable("gr_initial_sniper_ammo",20);               -- intial amount of sniper rounds player spawns with
Game:CreateVariable("gr_pickup_sniper_ammo",10);                -- amount of sniper rounds player gets from ammobox canister
Game:CreateVariable("gr_droppickup_sniper_ammo",10);            -- amount of sniper rounds player gets from pickup canister
Game:CreateVariable("gr_max_sniper_ammo",30);                   -- maximum amount of sniper round on a player at one time
 
Game:CreateVariable("gr_max_rockets_ffa",10);                   -- maximum number of rockets allowed in FFA  
Game:CreateVariable("gr_max_oicw_nades_ffa",10);                -- maximum number of OICW nades allowed in FFA
Game:CreateVariable("gr_max_ag36_nades_ffa",10);                -- maximum number of AG36 nades allowed in FFA

Game:CreateVariable("gr_rocket_damage_factor",1);               -- percentage damage rockets due based on default amount 1 = 100%.  0.5 = 50%     
Game:CreateVariable("gr_oicw_nade_damage_factor",1);						-- percentage damage OICW nades due based on default amount 1 = 100%.  0.5 = 50% 
Game:CreateVariable("gr_ag36_nade_damage_factor",1);						-- percentage damage AG36 due based on default amount 1 = 100%.  0.5 = 50% 

Game:CreateVariable("gr_sniper_flashbang",0);										-- sets snipers to spawn with flashbang grenades 1 = yes
Game:CreateVariable("gr_grunt_flashbang",0);										-- sets grunts to spawn with flashbang grenades 1 = yes
Game:CreateVariable("gr_engineer_flashbang",0);                 -- sets engineers to spawn with flashbang grenades 1 = yes

Game:CreateVariable("gr_killing_spree",5);                      -- sets the amount of kills needed to have a killing spree  
Game:CreateVariable("gr_killing_spree_display",0);  						-- 0 displays every kill after spree announced, 1 = display only the total at end of the spree

Game:CreateVariable("gr_max_average_ping",90);     							-- This sets the maximum allowed ping on the server; 0 means NO ping kick
Game:CreateVariable("gr_ping_check_interval",8);  							-- check each player's ping each every x seconds
Game:CreateVariable("gr_ping_warnings",3);        							-- number of sequential warnings before kick
Game:CreateVariable("gr_ping_reset_on_connect", 0);  						-- sets whether ping stats are reset upon player reconnect 0= no (player kicked again immediately) 
Game:CreateVariable("gr_last_checked",0);                       -- system variable. Do not alter
Game:CreateVariable("gr_last_spawn_checked",0);                 -- system variable. Do not alter

Game:CreateVariable("gr_announce_headshot",1);                  -- 0 = no message, 1 = message on headshot kill
Game:CreateVariable("gr_headshot_message_private",0);           -- 0 = message to all players, 1 = message to shooter only

Game:CreateVariable("gr_flag_saved_message",1);                 -- displays who saves flag
Game:CreateVariable("gr_flag_captured_message",1);              -- displays who captures flag 
Game:CreateVariable("gr_flag_startcapture_message",1);          -- displays who starts flag capture

Game:CreateVariable("gr_rm_needed_kills",5);   									-- number of kills needed to get rambo move message (0 to disable rambo move)
Game:CreateVariable("gr_rm_kill_addtime",5);   	                -- time added for each kill. while time>gametime, rambo move is active. (when flag is activated, no time will be reducted).

Game:CreateVariable("gr_stats_export",0);            						-- export stats to a file called  stats_[x].txt, x being a number set here
Game:CreateVariable("gr_stats_dir","");                         -- directory to put logfiles in, defaults to farcry/ (USE /, NOT \)

Game:CreateVariable("gr_runspeed_factor",1);                    -- percentage of run speed based on 1 = default 100% (0.5 = 50%)
Game:CreateVariable("gr_stamina_use_run",1);                    -- percentage of stamina depletion when running based on 1 = default 100% (0.5 = 50%)
                                        
Game:CreateVariable("gr_realistic_reload",0);                   -- if 1, discard any ammo left in clip when reloading

Game:CreateVariable("gr_keep_lock",1);                          -- keep teamlocks on mapchange (no auto release)
Game:CreateVariable("gr_fulltime",0);                           -- both teams get same amount of time to capture all flags equal to gr_timelimit
Game:CreateVariable("gr_static_respawn",0);                     -- respawn timer is set to this fixed amount (overrides gr_respawntime, 0 is off)

Game:CreateVariable("gr_allow_spectators",1);                   -- spectating allowed (1) or not (0)

Game:CreateVariable("gr_customdamagescale",1);                  -- damage scale factor (overrules standard damage scale, if set to something other than 1) (not added, just overrules)

Game:CreateVariable("gr_keep_score",0);                         -- keeps a player's score even when they join specators and then rejoin game

Game:CreateVariable("gr_walkspeed_factor",1);                   -- percentage of walk speed based on 1 = default 100% (0.5 = 50%)
Game:CreateVariable("gr_swimspeed_factor",1);										-- percentage of swim speed based on 1 = default 100% (0.5 = 50%)
Game:CreateVariable("gr_crouchspeed_factor",1);									-- percentage of speed when crouched based on 1 = default 100% (0.5 = 50%)
Game:CreateVariable("gr_pronespeed_factor",1);									-- percentage of speed when prone based on 1 = default 100% (0.5 = 50%)
Game:CreateVariable("gr_jumpforce_factor",1);                   -- percentage of jump amount based on 1 = default 100% (0.5 = 50%)

Game:CreateVariable("gr_max_snipers",99);                       -- max snipers on a team
Game:CreateVariable("gr_max_grunts",99);                        -- max grunts on a team
Game:CreateVariable("gr_max_engineers",99);                     -- max engineers on a team

Game:CreateVariable("gr_point_per_flag",1);                     -- for scoring in assault, each capture gives one point

Game:CreateVariable("gr_norl",0);                               -- eliminates all Rocket Launchers  1 =  yes

Game:CreateVariable("gr_autokick_connecting",45);               -- autokick players stuck connecting after x seconds 
Game:CreateVariable("gr_lastConnectCheck",0);                   -- Do not alter. system variable

Game:CreateVariable("gr_map_restart_delay", 5);                 -- number of seconds that pass before admin panel calls sv_restart


-- server side flood protection variables
Game:CreateVariable("sv_message_flood_protection", 1 );         -- server message flood protection on or off.
Game:CreateVariable("sv_kick_flood_offender", 1 );              -- if flood protection is on this will toggle whether or not to kick a flooder
Game:CreateVariable("sv_pb_kick_flood_offender_time", 60);      -- time period to kick a message rules violator if punkbuster is turned on
Game:CreateVariable("sv_message_repeat", 3 );                   -- number of times a message can be repeated by client

Game:CreateVariable("sv_flood_reset_time", 5);                  -- number of seconds until client message count is reset to 0.

Game:CreateVariable("sv_max_messages_per_timeframe", 6);        -- maximum number of messages a player can send within x number of seconds
Game:CreateVariable("sv_flood_protection_timeframe", 10);        -- x number of seconds for max messages in timeframe kick


-- client side flood protection variables
Game:CreateVariable("cl_message_flood_protection", 1 );         -- client message flood protection on or off.
Game:CreateVariable("cl_message_repeat", 3 );                   -- number of times a message can be repeated by other clients