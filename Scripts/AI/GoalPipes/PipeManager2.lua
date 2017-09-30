
function PipeManager:OnInit2()
	System:Log("INIT2CALLED");
	
	AI:CreateGoalPipe("hide_from_beacon");
	AI:PushGoal("hide_from_beacon","locate",0,"beacon");
	AI:PushGoal("hide_from_beacon","acqtarget",0,"");
	AI:PushGoal("hide_from_beacon","hide",1,20,HM_NEAREST);

	AI:CreateGoalPipe("rush_player");
	AI:PushGoal("rush_player","locate",0,"player");
	AI:PushGoal("rush_player","acqtarget",1,"");
	AI:PushGoal("rush_player","run",0,1);
	AI:PushGoal("rush_player","timeout",1,0.2,0.8);
	AI:PushGoal("rush_player","firecmd",1,1);
	AI:PushGoal("rush_player","approach",1,5);
	AI:PushGoal("rush_player","firecmd",1,0);
	AI:PushGoal("rush_player","signal",1,1,"STOP_RUSH",0);

	AI:CreateGoalPipe("swim_to");
	AI:PushGoal("swim_to","firecmd",0,0);
	AI:PushGoal("swim_to","acqtarget",1,"");
	AI:PushGoal("swim_to","approach",1,2);
	AI:PushGoal("swim_to","devalue",0);
	AI:PushGoal("swim_to","signal",1,-1,"SWIM_TO_ANOTHER_SPOT",0);

	AI:CreateGoalPipe("swim_inplace");
	AI:PushGoal("swim_inplace","firecmd",0,0);
	AI:PushGoal("swim_inplace","timeout",1,2);
	AI:PushGoal("swim_inplace","signal",1,-1,"SWIM_TO_ANOTHER_SPOT",0);

	AI:CreateGoalPipe("stunned");
	AI:PushGoal("stunned","firecmd",0,0);
	AI:PushGoal("stunned","signal",1,1,"MAKE_ME_IGNORANT",0);
	AI:PushGoal("stunned","signal",1,-1,"MAKE_STUNNED_ANIMATION",0);
	AI:PushGoal("stunned","timeout",1,0,0.5);
	AI:PushGoal("stunned","timeout",1,1,2);
	AI:PushGoal("stunned","signal",1,-1,"SHARED_UNBLINDED",0);
	AI:PushGoal("stunned","signal",1,-1,"MAKE_ME_UNIGNORANT",0);
	AI:PushGoal("stunned","firecmd",0,1);
	
	AI:CreateGoalPipe("get_gun");
	AI:PushGoal("get_gun","ignoreall",0,1);
	AI:PushGoal("get_gun","bodypos",0,0);
	AI:PushGoal("get_gun","signal",1,1,"GETTING_A_WEAPON",SIGNALID_READIBILITY);
	AI:PushGoal("get_gun","pathfind",1,"");
	AI:PushGoal("get_gun","run",0,1);
	AI:PushGoal("get_gun","trace",1,1);
	AI:PushGoal("get_gun","ignoreall",0,0);


	AI:CreateGoalPipe("any_idle_stand");
	AI:PushGoal("any_idle_stand","timeout",1,0,1);
	AI:PushGoal("any_idle_stand","signal",1,-1,"DECIDE_TO_BREAK_OR_NOT",0);

	AI:CreateGoalPipe("any_idle_reach_lastop");
	AI:PushGoal("any_idle_reach_lastop","devalue",1);
	AI:PushGoal("any_idle_reach_lastop","approach_to_lastop");
	AI:PushGoal("any_idle_reach_lastop","lookat",1,0,0);
	AI:PushGoal("any_idle_reach_lastop","timeout",1,1,2);
	AI:PushGoal("any_idle_reach_lastop","signal",1,-1,"ANCHOR_REACHED",0);


	AI:CreateGoalPipe("any_break_anim");
	AI:PushGoal("any_break_anim","signal",1,-1,"PLAY_BREAK_ANIMATION",0);
	AI:PushGoal("any_break_anim","timeout",1,0,1);

	AI:CreateGoalPipe("any_end_idle");
	AI:PushGoal("any_end_idle","timeout",1,0,1);
	AI:PushGoal("any_end_idle","signal",1,1,"BackToJob",0);

	AI:CreateGoalPipe("investigate_alarm");
	AI:PushGoal("investigate_alarm","lookat",1,-45,45);
	AI:PushGoal("investigate_alarm","timeout",1,0.5,1.5);
	AI:PushGoal("investigate_alarm","locate",0,"hidepoint");
	AI:PushGoal("investigate_alarm","acqtarget",0,"");
	AI:PushGoal("investigate_alarm","approach",1,0.5);
	AI:PushGoal("investigate_alarm","devalue",1);
	AI:PushGoal("investigate_alarm","lookat",1,-45,45);
	AI:PushGoal("investigate_alarm","timeout",1,0,1);
	AI:PushGoal("investigate_alarm","lookat",1,-45,45);
	AI:PushGoal("investigate_alarm","timeout",1,0,1);

	AI:CreateGoalPipe("run_to_beacon");
	AI:PushGoal("run_to_beacon","setup_combat");
	AI:PushGoal("run_to_beacon","locate",0,"beacon");
	AI:PushGoal("run_to_beacon","pathfind",1,"");
	AI:PushGoal("run_to_beacon","run",0,1);
	AI:PushGoal("run_to_beacon","trace",1,1);
	AI:PushGoal("run_to_beacon","run",0,0);


	AI:CreateGoalPipe("look_at_lastop");
	AI:PushGoal("look_at_lastop","lookat",1,0,0);

	AI:CreateGoalPipe("backoff_from_lastop");
	AI:PushGoal("backoff_from_lastop","ignoreall",0,1);
	AI:PushGoal("backoff_from_lastop","acqtarget",0,"");
	AI:PushGoal("backoff_from_lastop","run",0,1);
	AI:PushGoal("backoff_from_lastop","backoff",1,10);
	AI:PushGoal("backoff_from_lastop","run",0,0);
	AI:PushGoal("backoff_from_lastop","ignoreall",0,0);
	AI:PushGoal("backoff_from_lastop","devalue",0);	

	AI:CreateGoalPipe("simple_follow_target");
	AI:PushGoal("simple_follow_target","run",0,1);
	AI:PushGoal("simple_follow_target","firecmd",0,0);
	AI:PushGoal("simple_follow_target","approach",1,3);
	AI:PushGoal("simple_follow_target","timeout",1,0,1);

	AI:CreateGoalPipe("random_timeout");
	AI:PushGoal("random_timeout","firecmd",0,0);
	AI:PushGoal("random_timeout","timeout",1,0,2);
	AI:PushGoal("random_timeout","clear",0);

	AI:CreateGoalPipe("get_curious");
	AI:PushGoal("get_curious","timeout",1,0.5);
	AI:PushGoal("get_curious","signal",0,1,"SHARED_PLAY_CURIOUS_ANIMATION",0);
	AI:PushGoal("get_curious","timeout",1,0.2);

	AI:CreateGoalPipe("setup_idle");	
	AI:PushGoal("setup_idle","firecmd",0,0);	
	AI:PushGoal("setup_idle","bodypos",0,BODYPOS_RELAX);	
	AI:PushGoal("setup_idle","run",0,0);	
	--AI:PushGoal("setup_idle","firecmd",0,0);	

	AI:CreateGoalPipe("setup_crouch");	
	AI:PushGoal("setup_crouch","bodypos",0,BODYPOS_CROUCH);	
	AI:PushGoal("setup_crouch","firecmd",0,1);	

	AI:CreateGoalPipe("setup_prone");	
	AI:PushGoal("setup_prone","bodypos",0,BODYPOS_PRONE);	
	AI:PushGoal("setup_prone","firecmd",0,1);	


	AI:CreateGoalPipe("crouch_cover");
	AI:PushGoal("crouch_cover","setup_crouch");
	AI:PushGoal("crouch_cover","timeout",1,1,1.5);

	AI:CreateGoalPipe("setup_stealth");	
	AI:PushGoal("setup_stealth","bodypos",0,BODYPOS_STEALTH);	
	AI:PushGoal("setup_stealth","run",0,0);	

	AI:CreateGoalPipe("setup_combat");	
	AI:PushGoal("setup_combat","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("setup_combat","run",0,1);

	AI:CreateGoalPipe("do_it_running");
	AI:PushGoal("do_it_running","run",0,1);
	AI:PushGoal("do_it_running","run",0,1);

	AI:CreateGoalPipe("do_it_walking");
	AI:PushGoal("do_it_walking","run",0,0);
	AI:PushGoal("do_it_walking","run",0,0);

	AI:CreateGoalPipe("dig_in_attack");
	AI:PushGoal("dig_in_attack","firecmd",0,1);
	AI:PushGoal("dig_in_attack","bodypos",0,BODYPOS_CROUCH);
	AI:PushGoal("dig_in_attack","signal",1,1,"SHARED_PLAY_GETDOWN_ANIM",0)
	AI:PushGoal("dig_in_attack","signal",1,1,"CHECK_FOR_SAFETY",0)
	AI:PushGoal("dig_in_attack","timeout",1,0.5,1.5);
	AI:PushGoal("dig_in_attack","hide",1,10,HM_NEAREST);
	AI:PushGoal("dig_in_attack","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("dig_in_attack","signal",1,1,"SHARED_PLAY_GETUP_ANIM",0)
	AI:PushGoal("dig_in_attack","signal",1,1,"CHECK_FOR_TARGET",0)
	AI:PushGoal("dig_in_attack","firecmd",0,1);
	AI:PushGoal("dig_in_attack","timeout",1,1,3);
	AI:PushGoal("dig_in_attack","hide",1,10,HM_NEAREST);


	-----------------------------------------------------
	AI:CreateGoalPipe("observe_direction");
	AI:PushGoal("observe_direction","lookat",1,0,0);			-- look at passed object
	AI:PushGoal("observe_direction","timeout",1,1,2);			-- wait at most 1 second
	AI:PushGoal("observe_direction","signal",1,1,"DO_SOMETHING_IDLE",0);	-- do something (or not)
	AI:PushGoal("observe_direction","lookat",1,-90,90);			-- lookaround					
	AI:PushGoal("observe_direction","timeout",1,0.5,1.5);			
	AI:PushGoal("observe_direction","lookat",1,-90,90);			-- again look around			
	AI:PushGoal("observe_direction","timeout",1,0.5,1.5);			
	AI:PushGoal("observe_direction","signal",1,1,"RANDOM_IDLE_SOUND",SIGNALID_READIBILITY);

	-----------------------------------------------------
	AI:CreateGoalPipe("stand_only");
	AI:PushGoal("stand_only","timeout",1,0,1);
	AI:PushGoal("stand_only","signal",0,1,"DO_SOMETHING_IDLE",0);	-- do something (or not)


	-----------------------------------------------------
	AI:CreateGoalPipe("patrol_approach_to");
	AI:PushGoal("patrol_approach_to","setup_idle");
	AI:PushGoal("patrol_approach_to","pathfind",1,"");
	AI:PushGoal("patrol_approach_to","signal",1,1,"RANDOM_IDLE_SOUND",SIGNALID_READIBILITY);	
	AI:PushGoal("patrol_approach_to","trace",1,1);
	AI:PushGoal("patrol_approach_to","devalue",0);
	AI:PushGoal("patrol_approach_to","lookat",1,0,0);
	AI:PushGoal("patrol_approach_to","timeout",1,0.5,1.5);
	AI:PushGoal("patrol_approach_to","signal",0,1,"DO_SOMETHING_IDLE",0);	-- do something (or not)
	AI:PushGoal("patrol_approach_to","signal",0,1,"PatrolPath",0);	-- get next point in path


	-----------------------------------------------------
	AI:CreateGoalPipe("patrol_run_to");
	AI:PushGoal("patrol_run_to","ignoreall",0,1);
	AI:PushGoal("patrol_run_to","acqtarget",1,"");
	AI:PushGoal("patrol_run_to","pathfind",1,"");
	AI:PushGoal("patrol_run_to","run",1,1);
	AI:PushGoal("patrol_run_to","trace",1,1);
	AI:PushGoal("patrol_run_to","ignoreall",0,0);
	AI:PushGoal("patrol_run_to","devalue",0);






	-----------------------------------------------------
	AI:CreateGoalPipe("investigate_to");
	AI:PushGoal("investigate_to","pathfind",1,"");
	AI:PushGoal("investigate_to","trace",0,1);
	AI:PushGoal("investigate_to","lookat",1,-90,90);
	AI:PushGoal("investigate_to","branch",1,-1);
	AI:PushGoal("investigate_to","lookat",1,0,0);
	AI:PushGoal("investigate_to","devalue",0);
	AI:PushGoal("investigate_to","lookat",1,-45,45);
	AI:PushGoal("investigate_to","timeout",1,0.5,1.5);
	
	AI:CreateGoalPipe("investigate_wrapper");
	AI:PushGoal("investigate_wrapper","timeout",1,0.5,1.5);
	AI:PushGoal("investigate_wrapper","signal",1,1,"TAKE_NEXT_INVESTIGATION_POINT",0);
	AI:PushGoal("investigate_wrapper","timeout",1,0.5,1.5);
	

	----------------------------------------------------
	AI:CreateGoalPipe("disturbance_let_it_go");
	AI:PushGoal("disturbance_let_it_go","setup_idle");
	AI:PushGoal("disturbance_let_it_go","timeout",1,1,2);
	AI:PushGoal("disturbance_let_it_go","signal",0,1,"DO_LETGO_ANIMATION",0);
	AI:PushGoal("disturbance_let_it_go","timeout",1,0,1);
	AI:PushGoal("disturbance_let_it_go","signal",0,1,"RETURN_TO_FIRST",0);

	----------------------------------------------------
	AI:CreateGoalPipe("DRAW_GUN");
	AI:PushGoal("DRAW_GUN","signal",0,1,"SHARED_DRAW_GUN_ANIM",0);	
--	AI:PushGoal("DRAW_GUN","timeout",1,0.4);	
	AI:PushGoal("DRAW_GUN","signal",0,1,"SHARED_REBIND_GUN_TO_HANDS",0);				


	AI:CreateGoalPipe("HOLSTER_GUN");
--	AI:PushGoal("HOLSTER_GUN","timeout",1,0,0.5);	
	AI:PushGoal("HOLSTER_GUN","firecmd",0,0);	
	AI:PushGoal("HOLSTER_GUN","signal",0,1,"SHARED_HOLSTER_GUN_ANIM",0);	
	--AI:PushGoal("HOLSTER_GUN","timeout",1,0.6);	
	AI:PushGoal("HOLSTER_GUN","signal",0,1,"SHARED_REBIND_GUN_TO_BACK",0);	

	AI:CreateGoalPipe("take_cover");
	AI:PushGoal("take_cover","run",0,1);
	AI:PushGoal("take_cover","hide",1,10,HM_NEAREST,1);
	AI:PushGoal("take_cover","run",0,0);

	AI:CreateGoalPipe("shoot_cover");
	AI:PushGoal("shoot_cover","firecmd",0,2);
	AI:PushGoal("shoot_cover","run",0,1);
	AI:PushGoal("shoot_cover","hide",1,10,HM_NEAREST);
	AI:PushGoal("shoot_cover","run",0,0);
	AI:PushGoal("shoot_cover","firecmd",0,0);

	


	AI:CreateGoalPipe("cover_threatened");
	AI:PushGoal("cover_threatened","DRAW_GUN"); 
	AI:PushGoal("cover_threatened","setup_combat");
	AI:PushGoal("cover_threatened","timeout",1,0.2,0.8); 
	AI:PushGoal("cover_threatened","signal",1,1,"DO_THREATENED_ANIMATION",0);
	AI:PushGoal("cover_threatened","take_cover");
	AI:PushGoal("cover_threatened","timeout",1,0.5,1); 

	AI:CreateGoalPipe("cover_investigate_threat");
	AI:PushGoal("cover_investigate_threat","firecmd",0,1);	
	AI:PushGoal("cover_investigate_threat","approach",1,0.7);	-- approach a little
	AI:PushGoal("cover_investigate_threat","timeout",1,0.5,1.5);	

	AI:CreateGoalPipe("comeout");
	AI:PushGoal("comeout","firecmd",0,1)
	AI:PushGoal("comeout","locate",0,"atttarget");
	AI:PushGoal("comeout","pathfind",1,"");
	AI:PushGoal("comeout","trace",1,0,1);

	AI:CreateGoalPipe("comeout_standfire");
	AI:PushGoal("comeout_standfire","comeout");
	AI:PushGoal("comeout_standfire","timeout",1,0.5,1.5);

	AI:CreateGoalPipe("comeout_crouchfire");
	AI:PushGoal("comeout_crouchfire","setup_crouch");
	AI:PushGoal("comeout_crouchfire","comeout");
	AI:PushGoal("comeout_crouchfire","timeout",1,0.5,1.5);
	AI:PushGoal("comeout_crouchfire","setup_combat");

	AI:CreateGoalPipe("just_shoot");
	AI:PushGoal("just_shoot","firecmd",0,1);
	AI:PushGoal("just_shoot","timeout",1,1);

	AI:CreateGoalPipe("dumb_shoot");
	AI:PushGoal("dumb_shoot","locate",0,"beacon");
	AI:PushGoal("dumb_shoot","acqtarget",0,"");
	AI:PushGoal("dumb_shoot","firecmd",0,2);
	AI:PushGoal("dumb_shoot","timeout",1,1);


	AI:CreateGoalPipe("seek_target");
	AI:PushGoal("seek_target","approach",1,1);
	AI:PushGoal("seek_target","signal",0,1,"LOOK_FOR_TARGET",0);

	AI:CreateGoalPipe("confirm_targetloss");
	AI:PushGoal("confirm_targetloss","setup_stealth");
	AI:PushGoal("confirm_targetloss","locate",0,"beacon");
	AI:PushGoal("confirm_targetloss","acqtarget",0,"");
	AI:PushGoal("confirm_targetloss","approach",1,1);
	AI:PushGoal("confirm_targetloss","devalue",0);

	AI:CreateGoalPipe("look_around");
	AI:PushGoal("look_around","lookat",1,-180,180);

	AI:CreateGoalPipe("getting_shot_at");
	AI:PushGoal("getting_shot_at","clear",0);	-- get to cover, nothing else matters
	AI:PushGoal("getting_shot_at","ignoreall",0,1);	-- get to cover, nothing else matters
	AI:PushGoal("getting_shot_at","take_cover");
	AI:PushGoal("getting_shot_at","DRAW_GUN");
	AI:PushGoal("getting_shot_at","setup_combat");	-- now regroup
	AI:PushGoal("getting_shot_at","signal",0,1,"INVESTIGATE_TARGET",0);

	AI:CreateGoalPipe("approach_beacon");
	AI:PushGoal("approach_beacon","locate",0,"beacon");
	AI:PushGoal("approach_beacon","acqtarget",0,"");
	AI:PushGoal("approach_beacon","approach",1,1);
	AI:PushGoal("approach_beacon","lookat",1,-180,180);
	AI:PushGoal("approach_beacon","lookat",1,-180,180);

	AI:CreateGoalPipe("shoot_from_spot");
	AI:PushGoal("shoot_from_spot","pathfind",1,"");
	AI:PushGoal("shoot_from_spot","trace",1,0);
	AI:PushGoal("shoot_from_spot","timeout",1,3,5);

	AI:CreateGoalPipe("run_to_trigger");
	AI:PushGoal("run_to_trigger","setup_combat");
	AI:PushGoal("run_to_trigger","acqtarget",0,"");
	AI:PushGoal("run_to_trigger","pathfind",1,"");
	AI:PushGoal("run_to_trigger","run",0,1);
	AI:PushGoal("run_to_trigger","trace",1,1);
	AI:PushGoal("run_to_trigger","run",0,0);
	AI:PushGoal("run_to_trigger","ignoreall",0,0);
	AI:PushGoal("run_to_trigger","signal",1,-1,"EXIT_RUNTOALARM",0);
	AI:PushGoal("run_to_trigger","clear",0);

	AI:CreateGoalPipe("simple_approach_to")
	AI:PushGoal("simple_approach_to","acqtarget",0,"");
	AI:PushGoal("simple_approach_to","approach",1,3);
	AI:PushGoal("simple_approach_to","signal",1,1,"CONVERSATION_START",0);
	AI:PushGoal("simple_approach_to","clear");


	AI:CreateGoalPipe("approach_to_lastop");
	AI:PushGoal("approach_to_lastop","pathfind",1,"");
	AI:PushGoal("approach_to_lastop","trace",1,1);
	--AI:PushGoal("approach_to_lastop","acqtarget",0,"");
	--AI:PushGoal("approach_to_lastop","approach",1,0.5);

	AI:CreateGoalPipe("job_pickup_crate");
	AI:PushGoal("job_pickup_crate","approach_to_lastop");
	AI:PushGoal("job_pickup_crate","signal",1,1,"START_PICKUP_ANIM",0);
	AI:PushGoal("job_pickup_crate","timeout",1,1);
	AI:PushGoal("job_pickup_crate","signal",1,1,"BIND_CRATE_TO_ME",0);

	AI:CreateGoalPipe("job_drop_crate");
	AI:PushGoal("job_drop_crate","approach_to_lastop");
	AI:PushGoal("job_drop_crate","signal",1,1,"START_PUTDOWN_ANIM",0);
	AI:PushGoal("job_drop_crate","timeout",1,2);
	AI:PushGoal("job_drop_crate","signal",1,1,"FIND_PICKUP",0);

	AI:CreateGoalPipe("lean_right_attack");
	AI:PushGoal("lean_right_attack","firecmd",0,1);
	AI:PushGoal("lean_right_attack","signal",1,1,"CLEAR_SUCCESS_FLAG",0);
	AI:PushGoal("lean_right_attack","signal",1,1,"LEAN_RIGHT_ANIM",0);
	AI:PushGoal("lean_right_attack","signal",1,1,"CHECK_SUCCESS_FLAG",0);
	AI:PushGoal("lean_right_attack","hide",1,10,HM_NEAREST);
	AI:PushGoal("lean_right_attack","signal",1,1,"TO_PREVIOUS",0);



	AI:CreateGoalPipe("lean_left_attack");
	AI:PushGoal("lean_left_attack","firecmd",0,1);
	AI:PushGoal("lean_left_attack","signal",1,1,"CLEAR_SUCCESS_FLAG",0);
	AI:PushGoal("lean_left_attack","signal",1,1,"LEAN_LEFT_ANIM",0);
	AI:PushGoal("lean_left_attack","signal",1,1,"CHECK_SUCCESS_FLAG",0);
	AI:PushGoal("lean_left_attack","hide",1,10,HM_NEAREST);
	AI:PushGoal("lean_left_attack","signal",1,1,"TO_PREVIOUS",0);

	AI:CreateGoalPipe("goto_mounted_weapon");
	AI:PushGoal("goto_mounted_weapon","signal",1,1,"MAKE_ME_IGNORANT",0)
	AI:PushGoal("goto_mounted_weapon","acqtarget",1,"")
	AI:PushGoal("goto_mounted_weapon","bodypos",0,BODYPOS_STAND)
	AI:PushGoal("goto_mounted_weapon","run",1,1)
	AI:PushGoal("goto_mounted_weapon","approach",1,1)
	AI:PushGoal("goto_mounted_weapon","signal",1,-1,"USE_MOUNTED_WEAPON",0);


	AI:CreateGoalPipe("use_mounted_weapon");
	AI:PushGoal("use_mounted_weapon","firecmd",1,1)
	AI:PushGoal("use_mounted_weapon","timeout",1,1,2)
	AI:PushGoal("use_mounted_weapon","clear",1,1)

	AI:CreateGoalPipe("delay_headsup");
	AI:PushGoal("delay_headsup","DropBeaconAt");
	AI:PushGoal("delay_headsup","ignoreall",1,1);
	AI:PushGoal("delay_headsup","bodypos",1,BODYPOS_STAND);
	AI:PushGoal("delay_headsup","run",1,1);
	AI:PushGoal("delay_headsup","acqtarget",1,"");
	AI:PushGoal("delay_headsup","signal",1,1,"GET_REINFORCEMENTS",SIGNALID_READIBILITY);
	AI:PushGoal("delay_headsup","approach",1,1);
	AI:PushGoal("delay_headsup","signal",1,1,"wakeup",SIGNALFILTER_SUPERGROUP);
	AI:PushGoal("delay_headsup","signal",1,1,"HEADS_UP_GUYS",SIGNALFILTER_SUPERGROUP);
	AI:PushGoal("delay_headsup","signal",1,1,"CALL_REINFORCEMENTS",SIGNALID_READIBILITY);
	AI:PushGoal("delay_headsup","ignoreall",0,0);
	AI:PushGoal("delay_headsup","timeout",1,0.2);

	AI:CreateGoalPipe("look_at_beacon");
	AI:PushGoal("look_at_beacon","locate",0,"beacon");
	AI:PushGoal("look_at_beacon","acqtarget",0,"");
	AI:PushGoal("look_at_beacon","timeout",1,1);

	AI:CreateGoalPipe("hide_sometime");
	AI:PushGoal("hide_sometime","take_cover");
	AI:PushGoal("hide_sometime","timeout",1,1,3);

	AI:CreateGoalPipe("search_for_target");
	AI:PushGoal("search_for_target","setup_stealth");
	AI:PushGoal("search_for_target","run",0,0);
	AI:PushGoal("search_for_target","firecmd",0,0);
	AI:PushGoal("search_for_target","locate",0,"beacon");
	AI:PushGoal("search_for_target","pathfind",1,"");
	AI:PushGoal("search_for_target","trace",1,1);
	AI:PushGoal("search_for_target","locate",0,"hidepoint");
	AI:PushGoal("search_for_target","acqtarget",1,"");
	AI:PushGoal("search_for_target","approach",1,3);
	AI:PushGoal("search_for_target","devalue",0);	
	AI:PushGoal("search_for_target","timeout",1,1,3);
	AI:PushGoal("search_for_target","lookat",1,-90,90);
	AI:PushGoal("search_for_target","timeout",1,1,3);
	AI:PushGoal("search_for_target","lookat",1,-90,90);

	AI:CreateGoalPipe("walk_to_target");
	AI:PushGoal("walk_to_target","firecmd",0,0);
	AI:PushGoal("walk_to_target","run",0,0);
	AI:PushGoal("walk_to_target","approach",1,1.5);

	AI:CreateGoalPipe("go_to_sleep");
	AI:PushGoal("go_to_sleep","walk_to_target");
	AI:PushGoal("go_to_sleep","lookat",1,0,0);
	AI:PushGoal("go_to_sleep","timeout",1,2,2.5);
	AI:PushGoal("go_to_sleep","signal",1,1,"LAY_DOWN",0);
	
	AI:CreateGoalPipe("sleep");
	AI:PushGoal("sleep","timeout",1,10);

	AI:CreateGoalPipe("practice_shot");
	AI:PushGoal("practice_shot","firecmd",0,0);
	AI:PushGoal("practice_shot","acqtarget",0,"");
	AI:PushGoal("practice_shot","signal",1,1,"DO_SOMETHING_SPECIAL",0);
	AI:PushGoal("practice_shot","timeout",1,0.5,1.5);
	AI:PushGoal("practice_shot","setup_combat");
	AI:PushGoal("practice_shot","firecmd",0,2);
	AI:PushGoal("practice_shot","timeout",1,2,4);


	AI:CreateGoalPipe("val_follow");
	AI:PushGoal("val_follow","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("val_follow","run",1,1);
	AI:PushGoal("val_follow","firecmd",0,0);
	AI:PushGoal("val_follow","locate",0,"player");
	AI:PushGoal("val_follow","ignoreall",0,1);
	AI:PushGoal("val_follow","acqtarget",0,"");
	AI:PushGoal("val_follow","form",0,"beacon");
	AI:PushGoal("val_follow","locate",0,"beacon");
	AI:PushGoal("val_follow","acqtarget",0,"");
	AI:PushGoal("val_follow","approach",1,5);
	AI:PushGoal("val_follow","ignoreall",0,0);

	AI:CreateGoalPipe("val_lead_to");
	AI:PushGoal("val_lead_to","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("val_lead_to","firecmd",1,0);
	AI:PushGoal("val_lead_to","run",1,1);
	AI:PushGoal("val_lead_to","pathfind",1,"");
	AI:PushGoal("val_lead_to","trace",1,1);
	AI:PushGoal("val_lead_to","lookat",1,0,0);
	AI:PushGoal("val_lead_to","signal",1,1,"YOU_CAN_APPROACH_TO_NEXT",0);


	AI:CreateGoalPipe("pause_shooting");
	AI:PushGoal("pause_shooting","firecmd",0,0);
	AI:PushGoal("pause_shooting","timeout",1,0.5,1.5);
	AI:PushGoal("pause_shooting","firecmd",0,1);
end



