
function PipeManager:OnInitVehicle()
	System:Log("INITVehicleCALLED");



-- ______________________________________________________________________________________________________________________		
-- -------------------------------------------------- SHARED SCRIPTS ----------------------------------------------------
		
-- ______________________________________________________________________________________________________________________		
-- -------------------------------------------------- SHARED SCRIPTS ----------------------------------------------------

-- ______________________________________________________________________________________________________________________		
---------------------------------------------------- HELICOPTER ----------------------------------------------------

		AI:CreateGoalPipe("h_drop");
--		AI:PushGoal("h_drop","signal",0,1,"INIT_DROP",0);		
		AI:PushGoal("h_drop","acqtarget",0,"");
		AI:PushGoal("h_drop","ignoreall",0,1);
		AI:PushGoal("h_drop","approach",1,35);
		AI:PushGoal("h_drop","signal",0,1,"APPROACHING_DROPPOINT",0);
		AI:PushGoal("h_drop","stick",0,.5);		
--		AI:PushGoal("h_drop","lookat",0,0, 10);
--		AI:PushGoal("h_drop","approach",1,15);
		AI:PushGoal("h_drop","timeout",1,5);
		AI:PushGoal("h_drop","bodypos",0,1);		--	to ignore possible collisions with trees, etc		
--		AI:PushGoal("h_drop","stick",0,.5);
--		AI:PushGoal("h_drop","timeout",1,5);
--	AI:PushGoal("h_drop","signal",0,1,"REINFORCMENT_OUT",0);
		AI:PushGoal("h_drop","bodypos",0,1);		--	to ignore possible collisions with trees, etc
		AI:PushGoal("h_drop","signal",0,1,"at_reinforsment_point",0);

		AI:CreateGoalPipe("h_timeout_readytogo");
		AI:PushGoal("h_timeout_readytogo","ignoreall",0,1);
		AI:PushGoal("h_timeout_readytogo","timeout",1,3);
		AI:PushGoal("h_timeout_readytogo","signal",0,1,"READY_TO_GO",0);

		AI:CreateGoalPipe("h_goto_start");
		AI:PushGoal("h_goto_start","bodypos",0,0);		--	stop ignoring possible collisions with trees, etc		
		AI:PushGoal("h_goto_start","ignoreall",0,1);
		AI:PushGoal("h_goto_start","acqtarget",0,"");		
--AI:PushGoal("h_goto","bodypos",0,2);		
		AI:PushGoal("h_goto_start","signal",0,1,"FLY",0);
		AI:PushGoal("h_goto_start","timeout",1,4);
		AI:PushGoal("h_goto_start","signal",0,1,"READY_TO_GO",0);

		AI:CreateGoalPipe("h_goto");
		AI:PushGoal("h_goto","stick",0,-1);		
		AI:PushGoal("h_goto","ignoreall",0,1);
		AI:PushGoal("h_goto","bodypos",0,0);
		AI:PushGoal("h_goto","signal",0,1,"FLY",0);
		AI:PushGoal("h_goto","acqtarget",0,"");
--AI:PushGoal("h_goto","approach",1,25);
--AI:PushGoal("h_goto","bodypos",0,0);
		AI:PushGoal("h_goto","approach",1,15);
		AI:PushGoal("h_goto","signal",0,1,"NEXTPOINT",0);

-- the special pipe for Alex - to stay at one position and not to avoid collisions with vehicles
-- to be hit by car
		AI:CreateGoalPipe("h_goto_special");
		AI:PushGoal("h_goto_special","stick",0,-1);		
		AI:PushGoal("h_goto_special","ignoreall",0,1);
		AI:PushGoal("h_goto_special","bodypos",0,4);
		AI:PushGoal("h_goto_special","signal",0,1,"FLY",0);
		AI:PushGoal("h_goto_special","acqtarget",0,"");
		AI:PushGoal("h_goto_special","approach",1,0);	-- We want to stay at this point forewer
		AI:PushGoal("h_goto_special","signal",0,1,"NEXTPOINT",0);


		AI:CreateGoalPipe("h_goto_patrol");
		AI:PushGoal("h_goto_patrol","stick",0,-1);		
		AI:PushGoal("h_goto_patrol","bodypos",0,0);
		AI:PushGoal("h_goto_patrol","signal",0,1,"FLY",0);
		AI:PushGoal("h_goto_patrol","acqtarget",0,"");
		AI:PushGoal("h_goto_patrol","approach",1,15);
		AI:PushGoal("h_goto_patrol","signal",0,1,"NEXTPOINT",0);


		AI:CreateGoalPipe("h_gotoattack");
		AI:PushGoal("h_gotoattack","bodypos",0,0);		--	stop ignoring possible collisions with trees, etc				
		AI:PushGoal("h_gotoattack","signal",0,1,"FLY",0);
		AI:PushGoal("h_gotoattack","acqtarget",0,"");
		AI:PushGoal("h_gotoattack","approach",1,55);
		AI:PushGoal("h_gotoattack","signal",0,1,"NEXTPOINT_ATTACK",0);


		AI:CreateGoalPipe("h_gunner_fire");
--		AI:PushGoal("h_gunner_fire","ignoreall",0,0);
--		AI:PushGoal("h_gunner_fire","signal",1,-1,"MAKE_ME_UNIGNORANT",0);
		AI:PushGoal("h_gunner_fire","firecmd",0,1);
		
		AI:CreateGoalPipe("h_gunner_no_fire");
		AI:PushGoal("h_gunner_no_fire","firecmd",0,0);

		AI:CreateGoalPipe("h_gunner_ignore");
		AI:PushGoal("h_gunner_ignore","devalue",0,1);


		AI:CreateGoalPipe("h_strafe_left");
		AI:PushGoal("h_strafe_left","strafe",0,1);
		
		AI:CreateGoalPipe("h_strafe_right");
		AI:PushGoal("h_strafe_right","strafe",0,-1);

		AI:CreateGoalPipe("h_move_erratically");
		AI:PushGoal("h_move_erratically","bodypos",0,2);

		AI:CreateGoalPipe("h_standingthere");
--		AI:PushGoal("h_standingthere","ignoreall",0,1);
		AI:PushGoal("h_standingthere","firecmd",0,0);
		AI:PushGoal("h_standingthere","stick",0,-1);		
--		AI:PushGoal("h_standingthere","lookat",0,0,0);

		AI:CreateGoalPipe("h_standingtherestill");
		AI:PushGoal("h_standingtherestill","ignoreall",0,1);
		AI:PushGoal("h_standingtherestill","firecmd",0,0);
--		AI:PushGoal("h_standingthere","lookat",0,0,0);

		AI:CreateGoalPipe("h_attack");
		AI:PushGoal("h_attack","bodypos",0,3);			-- attack mode
		AI:PushGoal("h_attack","stick",0,32);
		AI:PushGoal("h_attack","signal",0,1,"STARTSTRAFE",0);
		AI:PushGoal("h_attack","timeout",1,7,12);				
		AI:PushGoal("h_attack","signal",0,1,"advance",0);

		-- does not see player - make short strafe than try to advance for better position
		AI:CreateGoalPipe("h_attack_short");
		AI:PushGoal("h_attack_short","bodypos",0,3);			-- attack mode
		AI:PushGoal("h_attack_short","stick",0,32);
		AI:PushGoal("h_attack_short","signal",0,1,"STARTSTRAFE",0);
		AI:PushGoal("h_attack_short","timeout",1,2,4);				
		AI:PushGoal("h_attack_short","signal",0,1,"advance",0);

		AI:CreateGoalPipe("h_attack_advance");
--		AI:PushGoal("h_attack_advance","bodypos",0,0);
--		AI:PushGoal("h_attack_advance","ignoreall",0,1);
		AI:PushGoal("h_attack_advance","heliadv",1,0);
		AI:PushGoal("h_attack_advance","stick",0,-1);		
--		AI:PushGoal("h_attack_advance","acqtarget",0,"");
		AI:PushGoal("h_attack_advance","approach",1,10,1);
--		AI:PushGoal("h_attack_advance","ignoreall",0,0);
--		AI:PushGoal("h_attack_advance","clear",0);
		AI:PushGoal("h_attack_advance","signal",0,1,"NEXTPOINT_ATTACK",0);		
		

		AI:CreateGoalPipe("h_attack_start");
--		AI:PushGoal("h_attack","ignoreall",0,0);
--		AI:PushGoal("h_attack_start","signal",0,1,"STARTSTRAFE",0);
--		AI:PushGoal("h_attack_start","timeout",1,3,7);
		AI:PushGoal("h_attack_start","signal",0,1,"advance",0);

		AI:CreateGoalPipe("h_attack_stop");
		AI:PushGoal("h_attack_stop","stick",0,-1);

		AI:CreateGoalPipe("h_looking");
		AI:PushGoal("h_looking","stick",0,-1);		
		AI:PushGoal("h_looking","approach",1,3);
		AI:PushGoal("h_looking","lookaround",1,1);
		AI:PushGoal("h_looking","lookat",1,-100, 100);
		AI:PushGoal("h_looking","signal",0,1,"STARTSTRAFE",0);
		AI:PushGoal("h_looking","timeout",1,1,2);		

		AI:CreateGoalPipe("h_grenade_run_away");
		AI:PushGoal("h_grenade_run_away","jump",0,1);
		AI:PushGoal("h_grenade_run_away","devalue",1);
	
		-- troopers getting out of hely
		AI:CreateGoalPipe("h_user_getout");
--		AI:PushGoal("h_user_getout","firecmd",1,1);
		AI:PushGoal("h_user_getout","acqtarget",0,"");
		AI:PushGoal("h_user_getout","run",0,1);
		AI:PushGoal("h_user_getout","signal",1,1,"MAKE_ME_IGNORANT",0);
--		AI:PushGoal("h_user_getout","strafe",0,-1);
		AI:PushGoal("h_user_getout","backoff",0,7);
		AI:PushGoal("h_user_getout","timeout",1,1,2.1);
		AI:PushGoal("h_user_getout","signal",1,-1,"MAKE_ME_UNIGNORANT",0);
		AI:PushGoal("h_user_getout","signal",0,1,"exited_vehicle",0);

-- ______________________________________________________________________________________________________________________		
---------------------------------------------------- CAR ----------------------------------------------------
		AI:CreateGoalPipe("c_brake");
--		AI:PushGoal("c_brake","jump",1,1);
		AI:PushGoal("c_brake","strafe",0,1);					--break
		AI:PushGoal("c_brake","timeout",1,0.7);
		AI:PushGoal("c_brake","strafe",0,0);		
		AI:PushGoal("c_brake","signal",1,1,"stopped",0);
		
		AI:CreateGoalPipe("c_goto");
--		AI:PushGoal("c_goto","ignoreall",0,1);
		AI:PushGoal("c_goto","strafe",0,0);						--stop breaking
		AI:PushGoal("c_goto","acqtarget",0,"");
		AI:PushGoal("c_goto","approach",1,7);
		AI:PushGoal("c_goto","signal",0,1,"next_point",0);

		AI:CreateGoalPipe("c_goto_ignore");
		AI:PushGoal("c_goto_ignore","ignoreall",0,1);
		AI:PushGoal("c_goto_ignore","strafe",0,0);						--stop breaking
		AI:PushGoal("c_goto_ignore","acqtarget",0,"");
		AI:PushGoal("c_goto_ignore","approach",1,20);
		AI:PushGoal("c_goto_ignore","signal",0,1,"next_point",0);

		AI:CreateGoalPipe("c_runover");
		AI:PushGoal("c_runover","strafe",0,0);						--stop breaking
		AI:PushGoal("c_runover","bodypos",0,1);		--	to update path when moving
--		AI:PushGoal("c_runover","acqtarget",0,"");
		AI:PushGoal("c_runover","approach",1,1);
--		AI:PushGoal("c_runover","signal",0,1,"next_point",0);
		
		AI:CreateGoalPipe("c_standingthere");
		AI:PushGoal("c_standingthere","strafe",0,1);	--break

		AI:CreateGoalPipe("c_grenade_run_away");
		AI:PushGoal("c_grenade_run_away","jump",0,1);
		AI:PushGoal("c_grenade_run_away","devalue",1);
		AI:PushGoal("c_grenade_run_away","branch",0,-1);

		AI:CreateGoalPipe("c_driver");
		AI:PushGoal("c_driver","clear",0,0);
--		AI:PushGoal("c_driver","lookat",0,0,0);
		AI:PushGoal("c_driver","ignoreall",0,1);
		AI:PushGoal("c_driver","firecmd",0,0);

		AI:CreateGoalPipe("c_getout");
		AI:PushGoal("c_getout","clear",0,0);
		AI:PushGoal("c_getout","lookat",0,-100,100);
		AI:PushGoal("c_getout","timeout",1,1,2);


		AI:CreateGoalPipe("c_goto_path");
--		AI:PushGoal("c_goto_path","ignoreall",0,1);
		AI:PushGoal("c_goto_path","strafe",0,0);						--stop breaking
		AI:PushGoal("c_goto_path","acqtarget",0,"");
		AI:PushGoal("c_goto_path","pathfind",1);
		AI:PushGoal("c_goto_path","trace",1);
		AI:PushGoal("c_goto_path","signal",0,1,"next_point",0);

		AI:CreateGoalPipe("c_approach_n_drop");
		AI:PushGoal("c_approach_n_drop","strafe",0,0);						--stop breaking
		AI:PushGoal("c_approach_n_drop","approach",1,20);
		AI:PushGoal("c_approach_n_drop","signal",0,1,"EVERYONE_OUT",0);


-- ______________________________________________________________________________________________________________________		
---------------------------------------------------- BOAT ----------------------------------------------------


		AI:CreateGoalPipe("b_goto");
		AI:PushGoal("b_goto","acqtarget",0,"");
		AI:PushGoal("b_goto","approach",1,12);
		AI:PushGoal("b_goto","signal",0,1,"next_point",0);

		--this used to trace path ignoring player
		AI:CreateGoalPipe("b_path_ignore");
		AI:PushGoal("b_path_ignore","ignoreall",0,1);		
		AI:PushGoal("b_path_ignore","acqtarget",0,"");
		AI:PushGoal("b_path_ignore","approach",1,12);
		AI:PushGoal("b_path_ignore","signal",0,1,"next_point",0);

		--this used to approach drop point
		AI:CreateGoalPipe("b_goto_ignore");
		AI:PushGoal("b_goto_ignore","ignoreall",0,1);
		AI:PushGoal("b_goto_ignore","acqtarget",0,"");
		AI:PushGoal("b_goto_ignore","approach",1,25);
		AI:PushGoal("b_goto_ignore","strafe",0,1);			-- start slowing down
		AI:PushGoal("b_goto_ignore","approach",1,5.5);	-- keep approaching	
--		AI:PushGoal("b_goto_ignore","timeout",1,1.5);		-- waite a bit	
		AI:PushGoal("b_goto_ignore","signal",0,1,"next_point",0);

		--this used to approach beacon 
		AI:CreateGoalPipe("b_goto_beacon_ignore");
		AI:PushGoal("b_goto_beacon_ignore","ignoreall",0,1);		
		AI:PushGoal("b_goto_beacon_ignore","timeout",1,.5);		-- waite a bit			
		AI:PushGoal("b_goto_beacon_ignore","ignoreall",0,1);
		AI:PushGoal("b_goto_beacon_ignore","locate",1,"beacon");
		AI:PushGoal("b_goto_beacon_ignore","acqtarget",0,"");
		AI:PushGoal("b_goto_beacon_ignore","approach",1,25);
--		AI:PushGoal("b_goto_beacon_ignore","strafe",0,1);			-- start slowing down
		AI:PushGoal("b_goto_beacon_ignore","strafe",0,-1);			-- start slowing down and disable pathfind
		AI:PushGoal("b_goto_beacon_ignore","approach",1,5.5);	-- keep approaching	
--		AI:PushGoal("b_goto_beacon_ignore","timeout",1,1.5);		-- waite a bit	
		AI:PushGoal("b_goto_beacon_ignore","signal",0,1,"next_point",0);


		--this used to approach drop point
		AI:CreateGoalPipe("b_attack_land");
		AI:PushGoal("b_attack_land","ignoreall",0,1);
		AI:PushGoal("b_attack_land","stick",0,-1);
		AI:PushGoal("b_attack_land","bodypos",0,1);
		AI:PushGoal("b_attack_land","acqtarget",0,"");
--		AI:PushGoal("b_attack_land","approach",1,20);		
--		AI:PushGoal("b_attack_land","strafe",0,1);			-- start slowing down
		AI:PushGoal("b_attack_land","approach",0,5);
--		AI:PushGoal("b_attack_land","strafe",0,0);			-- stop slowing down		
--		AI:PushGoal("b_attack_land","stick",0,-1);		
		AI:PushGoal("b_attack_land","timeout",1,.25);		-- waite a bit	
		AI:PushGoal("b_attack_land","bodypos",0,0);
		AI:PushGoal("b_attack_land","signal",0,1,"next_point",0);


		AI:CreateGoalPipe("b_stick");
		AI:PushGoal("b_stick","stick",0,17);
--AI:PushGoal("b_stick","acqtarget",0,"Drop");	
--		AI:PushGoal("b_stick","acqtarget",0,"");
		AI:PushGoal("b_stick","approach",1,10.1);
		AI:PushGoal("b_stick","stick",0,-1);
--		AI:PushGoal("b_stick","approach",0,5.1);
--		AI:PushGoal("b_stick","timeout",1,.7);
		AI:PushGoal("b_stick","signal",0,1,"next_point",0);


		AI:CreateGoalPipe("b_standingthere");
		AI:PushGoal("b_standingthere","ignoreall",0,1);
		AI:PushGoal("b_standingthere","firecmd",0,0);
--		AI:PushGoal("h_standingthere","lookat",0,0,0);

		AI:CreateGoalPipe("b_user_getout");
		AI:PushGoal("b_user_getout","acqtarget",0,"");
		AI:PushGoal("b_user_getout","firecmd",0,0);		
		AI:PushGoal("b_user_getout","run",0,1);
--		AI:PushGoal("b_user_getout","firecmd",0,0);
		AI:PushGoal("b_user_getout","approach",1,1.1);
--		AI:PushGoal("b_user_getout","timeout",1,5);
		AI:PushGoal("b_user_getout","signal",0,1,"exited_vehicle",0);

		AI:CreateGoalPipe("b_user_getin");
		AI:PushGoal("b_user_getin","ignoreall",0,1);
		AI:PushGoal("b_user_getin","signal",1,1,"MAKE_ME_IGNORANT",0);
		AI:PushGoal("b_user_getin","acqtarget",0,"");
		AI:PushGoal("b_user_getin","firecmd",0,0);
		AI:PushGoal("b_user_getin","run",0,1);
--		AI:PushGoal("b_user_getin","firecmd",0,0);
		AI:PushGoal("b_user_getin","approach",1,1.1);
--		AI:PushGoal("b_user_getin","timeout",1,5);
		AI:PushGoal("b_user_getin","signal",1,-1,"MAKE_ME_UNIGNORANT",0);
		AI:PushGoal("b_user_getin","signal",1,1,"at_boatenterspot",0);
		AI:PushGoal("b_user_getin","timeout",1,1000);


		AI:CreateGoalPipe("b_timeout");
		AI:PushGoal("b_timeout","ignoreall",0,1);
		AI:PushGoal("b_timeout","firecmd",0,0);
		AI:PushGoal("b_timeout","timeout",1,1);	-- timeout to slow down before people get out of boat
		AI:PushGoal("b_timeout","signal",0,1,"reinforcment_out",0);

		
end

