function PipeManager:InitMutants()

	AI:CreateGoalPipe("bust_lock_at");
	AI:PushGoal("bust_lock_at","acqtarget",0,"");
	AI:PushGoal("bust_lock_at","run",1,1);
	AI:PushGoal("bust_lock_at","approach",1,1);
	AI:PushGoal("bust_lock_at","signal",1,1,"ANY_MORE_TO_RELEASE",0);

	AI:CreateGoalPipe("mutant_caged_idle");
	AI:PushGoal("mutant_caged_idle","devalue",0);
	AI:PushGoal("mutant_caged_idle","signal",1,1,"MUTANT_RELAXED_ANIM",0);
	AI:PushGoal("mutant_caged_idle","lookat",1,-30,30);
--	AI:PushGoal("mutant_caged_idle","timeout",1,0,1);

	AI:CreateGoalPipe("mutant_caged_upset");
	AI:PushGoal("mutant_caged_upset","signal",1,1,"MUTANT_UPSET_ANIM",0);
	AI:PushGoal("mutant_caged_upset","timeout",1,0,0.7);


	AI:CreateGoalPipe("wait_state");
	AI:PushGoal("wait_state","ignoreall",1,0);
	AI:PushGoal("wait_state","signal",1,1,"STILL_WAITING",0);
	AI:PushGoal("wait_state","timeout",1,0.5);
	AI:PushGoal("wait_state","ignoreall",1,1);

	AI:CreateGoalPipe("waiting...");
	AI:PushGoal("waiting...","timeout",1,1);

	--------------------------------
	-- NEW MUTANT SCREWED
	--------------------------------

	AI:CreateGoalPipe("mutant_shared_bellowhowl");
	AI:PushGoal("mutant_shared_bellowhowl","firecmd",0,0);
	AI:PushGoal("mutant_shared_bellowhowl","signal",1,1,"MAKE_BELLOW_HOWL_ANIMATION",0);
	AI:PushGoal("mutant_shared_bellowhowl","timeout",1,0.2);

	AI:CreateGoalPipe("mutant_run_to_target");
	AI:PushGoal("mutant_run_to_target","run",0,1);
--	AI:PushGoal("mutant_run_to_target","approach",1,3);
	AI:PushGoal("mutant_run_to_target","locate",1,"atttarget");
	AI:PushGoal("mutant_run_to_target","pathfind",1,"");
	AI:PushGoal("mutant_run_to_target","trace",1,1);
	AI:PushGoal("mutant_run_to_target","run",0,0);

	AI:CreateGoalPipe("mutant_walk_to_beacon");
	AI:PushGoal("mutant_walk_to_beacon","locate",0,"beacon");
	AI:PushGoal("mutant_walk_to_beacon","acqtarget",0,"");
	AI:PushGoal("mutant_walk_to_beacon","mutant_walk_to_target");

	AI:CreateGoalPipe("mutant_run_to_beacon");
	AI:PushGoal("mutant_run_to_beacon","locate",0,"beacon");
	AI:PushGoal("mutant_run_to_beacon","acqtarget",0,"");
	AI:PushGoal("mutant_run_to_beacon","mutant_run_to_target");

	AI:CreateGoalPipe("mutant_run_towards_target");
	AI:PushGoal("mutant_run_towards_target","run",0,1);
	AI:PushGoal("mutant_run_towards_target","approach",1,0.5);
	AI:PushGoal("mutant_run_towards_target","run",0,0);

	AI:CreateGoalPipe("mutant_walk_to_target");
	AI:PushGoal("mutant_walk_to_target","firecmd",0,0);
	AI:PushGoal("mutant_walk_to_target","run",0,0);
	AI:PushGoal("mutant_walk_to_target","approach",1,2);
	AI:PushGoal("mutant_walk_to_target","firecmd",0,1);

	AI:CreateGoalPipe("mutant_screwed_attack");
	AI:PushGoal("mutant_screwed_attack","mutant_run_to_target");
--	AI:PushGoal("mutant_screwed_attack","timeout",1,0,0.5);

	AI:CreateGoalPipe("mutant_push_stuff_at");
	AI:PushGoal("mutant_push_stuff_at","run",0,1);
	AI:PushGoal("mutant_push_stuff_at","ignoreall",0,1);
	AI:PushGoal("mutant_push_stuff_at","acqtarget",0,"");
	AI:PushGoal("mutant_push_stuff_at","approach",1,2);
	AI:PushGoal("mutant_push_stuff_at","signal",1,1,"APPLY_IMPULSE_TO_ENVIRONMENT",0);
	AI:PushGoal("mutant_push_stuff_at","ignoreall",0,0);

	AI:CreateGoalPipe("jump_wrapper");
	AI:PushGoal("jump_wrapper","firecmd",0,0); 
	AI:PushGoal("jump_wrapper","firecmd",0,1); 
	AI:PushGoal("jump_wrapper","signal",1,1,"JUMP_FINISHED",0);		


	-----------------------------------
	-- NEW MUTANT SCOUT
	-----------------------------------
	



	AI:CreateGoalPipe("jump_left_hide");
	AI:PushGoal("jump_left_hide","firecmd",0,0); 
	AI:PushGoal("jump_left_hide","jump",1,20,HM_LEFTMOST_FROM_TARGET,1);	-- calculate jump only DONT ACTUALLY JUMP
	AI:PushGoal("jump_left_hide","signal",1,1,"START_DESIRED_ANIMATION",0);		
	AI:PushGoal("jump_left_hide","signal",1,1,"SET_CORRECT_ANIMATION_SCALE",0);		
	AI:PushGoal("jump_left_hide","jump",1,20,HM_LEFTMOST_FROM_TARGET);	-- actual jump executed here
	AI:PushGoal("jump_left_hide","signal",1,1,"RESET_JUMP_VARIABLES",0);	

	AI:CreateGoalPipe("jump_right_hide");
	AI:PushGoal("jump_right_hide","firecmd",0,0); 
	AI:PushGoal("jump_right_hide","jump",1,20,HM_LEFTMOST_FROM_TARGET,1);	-- calculate jump only DONT ACTUALLY JUMP
	AI:PushGoal("jump_right_hide","signal",1,1,"START_DESIRED_ANIMATION",0);		
	AI:PushGoal("jump_right_hide","signal",1,1,"SET_CORRECT_ANIMATION_SCALE",0);		
	AI:PushGoal("jump_right_hide","jump",1,20,HM_RIGHTMOST_FROM_TARGET);	-- actual jump executed here
	AI:PushGoal("jump_right_hide","signal",1,1,"RESET_JUMP_VARIABLES",0);		

	AI:CreateGoalPipe("fast_investigate");
	AI:PushGoal("fast_investigate","mutant_walk_to_target");


	AI:CreateGoalPipe("fast_shoot_approach");
	AI:PushGoal("fast_shoot_approach","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("fast_shoot_approach","firecmd",1,1);
	AI:PushGoal("fast_shoot_approach","approach",1,0.5);
	AI:PushGoal("fast_shoot_approach","signal",1,1,"SWITCH_TO_SHOOT",0);


	AI:CreateGoalPipe("fast_shoot");
	AI:PushGoal("fast_shoot","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("fast_shoot","run",0,1);
	AI:PushGoal("fast_shoot","firecmd",0,1);
	AI:PushGoal("fast_shoot","timeout",1,3);

	AI:CreateGoalPipe("krieger_fast_shoot");
	AI:PushGoal("krieger_fast_shoot","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("krieger_fast_shoot","run",0,1);
	AI:PushGoal("krieger_fast_shoot","firecmd",0,1);
	AI:PushGoal("krieger_fast_shoot","timeout",1,1,2);
	AI:PushGoal("krieger_fast_shoot","signal",1,1,"CHANGE_POSITION",0);



	
	AI:CreateGoalPipe("fast_invisible_attack_left");
	AI:PushGoal("fast_invisible_attack_left","firecmd",0,0);
	AI:PushGoal("fast_invisible_attack_left","run",0,1);
	AI:PushGoal("fast_invisible_attack_left","hide",1,20,HM_LEFTMOST_FROM_TARGET);
	AI:PushGoal("fast_invisible_attack_left","hide",1,20,HM_LEFTMOST_FROM_TARGET);
	AI:PushGoal("fast_invisible_attack_left","approach",1,2);
	AI:PushGoal("fast_invisible_attack_left","firecmd",0,1);
	AI:PushGoal("fast_invisible_attack_left","run",0,0);

	AI:CreateGoalPipe("fast_invisible_attack_right");
	AI:PushGoal("fast_invisible_attack_right","firecmd",0,0);
	AI:PushGoal("fast_invisible_attack_right","run",0,1);
	AI:PushGoal("fast_invisible_attack_right","hide",1,20,HM_RIGHTMOST_FROM_TARGET);
	AI:PushGoal("fast_invisible_attack_right","hide",1,20,HM_RIGHTMOST_FROM_TARGET);
	AI:PushGoal("fast_invisible_attack_right","approach",1,2);
	AI:PushGoal("fast_invisible_attack_right","firecmd",0,1);
	AI:PushGoal("fast_invisible_attack_right","run",0,0);

	AI:CreateGoalPipe("fast_hide");
	AI:PushGoal("fast_hide","firecmd",0,1);
	AI:PushGoal("fast_hide","run",0,1);
	AI:PushGoal("fast_hide","hide",1,20,HM_NEAREST);
	AI:PushGoal("fast_hide","signal",1,1,"SWITCH_TO_SHOOT",0);


	AI:CreateGoalPipe("krieger_fast_hide");
	AI:PushGoal("krieger_fast_hide","firecmd",0,1);
	AI:PushGoal("krieger_fast_hide","run",0,1);
	AI:PushGoal("krieger_fast_hide","signal",1,1,"SELECT_HIDE_METHOD",0);
	AI:PushGoal("krieger_fast_hide","signal",1,1,"SWITCH_TO_SHOOT",0);

	AI:CreateGoalPipe("krieger_hide_left");
	AI:PushGoal("krieger_hide_left","hide",1,30,HM_LEFTMOST_FROM_TARGET);

	AI:CreateGoalPipe("krieger_hide_right");
	AI:PushGoal("krieger_hide_right","hide",1,30,HM_RIGHTMOST_FROM_TARGET);


	---------------------------------------
	-- NEW MUTANT COVER
	---------------------------------------

	AI:CreateGoalPipe("big_shoot");
	AI:PushGoal("big_shoot","firecmd",0,0);
	AI:PushGoal("big_shoot","signal",1,1,"PLAY_SHOOT_ANIMATION",0);
	AI:PushGoal("big_shoot","signal",1,1,"RUN_TO_TARGET",0);

	AI:CreateGoalPipe("big_new_shoot");
	AI:PushGoal("big_new_shoot","timeout",1,0.5,1);
	AI:PushGoal("big_new_shoot","firecmd",0,1);
	AI:PushGoal("big_new_shoot","timeout",1,1,2);
	AI:PushGoal("big_new_shoot","firecmd",0,0);

	AI:CreateGoalPipe("big_pindown");
	AI:PushGoal("big_pindown","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("big_pindown","run",0,1);
	--AI:PushGoal("big_pindown","hide",1,15,HM_NEAREST_TO_TARGET,0);
	AI:PushGoal("big_pindown","signal",1,1,"SELECT_LEFT_RIGHT_COMEOUT",0);

	AI:CreateGoalPipe("big_roam");
	AI:PushGoal("big_roam","run",0,0);
	AI:PushGoal("big_roam","locate",0,"hidepoint");
	AI:PushGoal("big_roam","pathfind",1,"");
	AI:PushGoal("big_roam","trace",1,1);
	AI:PushGoal("big_roam","lookat",1,-45,45);
	AI:PushGoal("big_roam","timeout",1,1,2);
	AI:PushGoal("big_roam","lookat",1,-45,45);
	AI:PushGoal("big_roam","timeout",1,1,2);


	AI:CreateGoalPipe("big_comeout_left");
	AI:PushGoal("big_comeout_left","strafe",1,-3);
	AI:PushGoal("big_comeout_left","clear",0);

	AI:CreateGoalPipe("big_comeout_right");
	AI:PushGoal("big_comeout_right","strafe",1,3);
	AI:PushGoal("big_comeout_right","clear",0);

	AI:CreateGoalPipe("big_run_to_beacon");
	AI:PushGoal("big_run_to_beacon","locate",0,"beacon");
	AI:PushGoal("big_run_to_beacon","acqtarget",0,"");
	AI:PushGoal("big_run_to_beacon","big_run_to_target");

	AI:CreateGoalPipe("big_run_to_target");
	AI:PushGoal("big_run_to_target","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("big_run_to_target","run",0,1);
	AI:PushGoal("big_run_to_target","approach",0,2);
	AI:PushGoal("big_run_to_target","signal",1,1,"DECIDE_TO_SHOOT_OR_NOT",0);
--	AI:PushGoal("big_run_to_target","timeout",1,1,2);
	AI:PushGoal("big_run_to_target","branch",1,-1);
	AI:PushGoal("big_run_to_target","run",0,0);
	AI:PushGoal("big_run_to_target","signal",0,1,"THREATEN",SIGNALID_READIBILITY);
	--------------------------------------------------------------


	---------------------------------------
	-- NEW MUTANT STEALTH
	---------------------------------------
	
	AI:CreateGoalPipe("stealth_investigate");
	AI:PushGoal("stealth_investigate","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("stealth_investigate","approach",1,0.6);
	AI:PushGoal("stealth_investigate","lookat",1,-45,45);
	AI:PushGoal("stealth_investigate","lookat",1,-45,45);
	AI:PushGoal("stealth_investigate","signal",1,1,"DECIDE_IF_INVESTIGATING_MORE",0);

	AI:CreateGoalPipe("stealth_hunt");
	AI:PushGoal("stealth_hunt","locate",0,"beacon");
	AI:PushGoal("stealth_hunt","acqtarget",0,"");
	AI:PushGoal("stealth_hunt","run",0,1);
	AI:PushGoal("stealth_hunt","signal",1,1,"GO_REFRACTIVE",0);
	AI:PushGoal("stealth_hunt","hide",1,20,HM_NEAREST);
	AI:PushGoal("stealth_hunt","run",0,0);
	AI:PushGoal("stealth_hunt","bodypos",0,BODYPOS_STEALTH);
	AI:PushGoal("stealth_hunt","timeout",1,0,1);
	AI:PushGoal("stealth_hunt","hide",1,20,HM_FRONTLEFTMOST_FROM_TARGET,1);
	AI:PushGoal("stealth_hunt","timeout",1,0,1);
	AI:PushGoal("stealth_hunt","hide",1,20,HM_NEAREST_TO_TARGET,1);
	AI:PushGoal("stealth_hunt","timeout",1,0,1);
	AI:PushGoal("stealth_hunt","hide",1,20,HM_FRONTLEFTMOST_FROM_TARGET,1);
	AI:PushGoal("stealth_hunt","timeout",1,0,1);
	AI:PushGoal("stealth_hunt","hide",1,20,HM_NEAREST_TO_TARGET,1);
	AI:PushGoal("stealth_hunt","timeout",1,0,1);
	AI:PushGoal("stealth_hunt","approach",1,2);
	AI:PushGoal("stealth_hunt","signal",1,1,"GO_VISIBLE",0);
	AI:PushGoal("stealth_hunt","signal",1,1,"RETURN_TO_FIRST",0);

	AI:CreateGoalPipe("stealth_normal_attack");
	AI:PushGoal("stealth_normal_attack","signal",1,1,"GO_VISIBLE",0); -- just in case
	AI:PushGoal("stealth_normal_attack","bodypos",1,BODYPOS_STAND);
	AI:PushGoal("stealth_normal_attack","run",0,1);
	AI:PushGoal("stealth_normal_attack","firecmd",0,1);
	AI:PushGoal("stealth_normal_attack","hide",1,20,HM_FRONTLEFTMOST_FROM_TARGET);
	AI:PushGoal("stealth_normal_attack","hide",1,20,HM_FRONTRIGHTMOST_FROM_TARGET);

	AI:CreateGoalPipe("stealth_sneakup_left");
	AI:PushGoal("stealth_sneakup_left","signal",1,1,"GO_REFRACTIVE",0);
	AI:PushGoal("stealth_sneakup_left","firecmd",0,0);
	AI:PushGoal("stealth_sneakup_left","bodypos",1,BODYPOS_STAND);
	AI:PushGoal("stealth_sneakup_left","run",0,1);
	AI:PushGoal("stealth_sneakup_left","hide",1,20,HM_FRONTLEFTMOST_FROM_TARGET);
	AI:PushGoal("stealth_sneakup_left","timeout",1,0.5,1.5);
	AI:PushGoal("stealth_sneakup_left","hide",1,20,HM_NEAREST_TO_TARGET);
	AI:PushGoal("stealth_sneakup_left","timeout",1,0.5,1.5);
	AI:PushGoal("stealth_sneakup_left","hide",1,20,HM_FRONTLEFTMOST_FROM_TARGET);
	AI:PushGoal("stealth_sneakup_left","timeout",1,0.5,1.5);
	AI:PushGoal("stealth_sneakup_left","approach",1,3);
	AI:PushGoal("stealth_sneakup_left","signal",1,1,"GO_VISIBLE",0);

	AI:CreateGoalPipe("stealth_sneakup_right");
	AI:PushGoal("stealth_sneakup_right","signal",1,1,"GO_REFRACTIVE",0);
	AI:PushGoal("stealth_sneakup_right","firecmd",0,0);
	AI:PushGoal("stealth_sneakup_right","bodypos",1,BODYPOS_STAND);
	AI:PushGoal("stealth_sneakup_right","run",0,1);
	AI:PushGoal("stealth_sneakup_right","hide",1,20,HM_FRONTRIGHTMOST_FROM_TARGET);
	AI:PushGoal("stealth_sneakup_right","timeout",1,0.5,1.5);
	AI:PushGoal("stealth_sneakup_right","hide",1,20,HM_NEAREST_TO_TARGET);
	AI:PushGoal("stealth_sneakup_right","timeout",1,0.5,1.5);
	AI:PushGoal("stealth_sneakup_right","hide",1,20,HM_FRONTRIGHTMOST_FROM_TARGET);
	AI:PushGoal("stealth_sneakup_right","timeout",1,0.5,1.5);
	AI:PushGoal("stealth_sneakup_right","approach",1,3);
	AI:PushGoal("stealth_sneakup_right","signal",1,1,"GO_VISIBLE",0);

	---------------------------------------
	-- MUTANT MORPHER
	---------------------------------------

	AI:CreateGoalPipe("morpher_attack_wrapper");
	AI:PushGoal("morpher_attack_wrapper","firecmd",0,1);
	AI:PushGoal("morpher_attack_wrapper","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("morpher_attack_wrapper","signal",1,1,"SELECT_MORPH_ATTACK");
	AI:PushGoal("morpher_attack_wrapper","timeout",1,0,0.5);

	AI:CreateGoalPipe("morpher_attack_left");
	AI:PushGoal("morpher_attack_left","firecmd",0,1);
	AI:PushGoal("morpher_attack_left","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("morpher_attack_left","run",0,1);
	AI:PushGoal("morpher_attack_left","hide",1,15,HM_FRONTLEFTMOST_FROM_TARGET);

	AI:CreateGoalPipe("morpher_attack_right");
	AI:PushGoal("morpher_attack_right","firecmd",0,1);
	AI:PushGoal("morpher_attack_right","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("morpher_attack_right","run",0,1);
	AI:PushGoal("morpher_attack_right","hide",1,15,HM_FRONTRIGHTMOST_FROM_TARGET);

	AI:CreateGoalPipe("morpher_attack_retreat");
	AI:PushGoal("morpher_attack_retreat","firecmd",0,1);
	AI:PushGoal("morpher_attack_retreat","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("morpher_attack_retreat","run",0,1);
	AI:PushGoal("morpher_attack_retreat","hide",1,15,HM_FARTHEST_FROM_TARGET);
	
	AI:CreateGoalPipe("morpher_wait_for_target");
	AI:PushGoal("morpher_wait_for_target","firecmd",0,0);
--	AI:PushGoal("morpher_wait_for_target","ignoreall",0,1);
	AI:PushGoal("morpher_wait_for_target","locate",0,"hidepoint");
	AI:PushGoal("morpher_wait_for_target","acqtarget",0,"");
	AI:PushGoal("morpher_wait_for_target","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("morpher_wait_for_target","run",0,0);
	AI:PushGoal("morpher_wait_for_target","timeout",1,60);

	AI:CreateGoalPipe("morpher_invisible_attack");
	AI:PushGoal("morpher_invisible_attack","firecmd",0,0);
	AI:PushGoal("morpher_invisible_attack","run",0,1);
	AI:PushGoal("morpher_invisible_attack","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("morpher_invisible_attack","hide",1,20,HM_LEFTMOST_FROM_TARGET);
	AI:PushGoal("morpher_invisible_attack","approach",1,2);


	AI:CreateGoalPipe("morpher_chase");
	AI:PushGoal("morpher_chase","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("morpher_chase","timeout",1,1,2);
	AI:PushGoal("morpher_chase","signal",1,1,"CHASE_TARGET",0);

	AI:CreateGoalPipe("morpher_morph_at");
	AI:PushGoal("morpher_morph_at","bodypos",0,BODYPOS_STAND);
--	AI:PushGoal("morpher_morph_at","ignoreall",0,1);
	AI:PushGoal("morpher_morph_at","acqtarget",0,"");
	AI:PushGoal("morpher_morph_at","run",0,1);
	AI:PushGoal("morpher_morph_at","approach",1,2);
	AI:PushGoal("morpher_morph_at","signal",1,1,"MORPH",0);
--	AI:PushGoal("morpher_morph_at","ignoreall",0,0);

	----------------------------
	-- ABBERATION STUFF
	-------------------------------


	AI:CreateGoalPipe("abberation_scared");
	AI:PushGoal("abberation_scared","bodypos",0,0);
	AI:PushGoal("abberation_scared","bodypos",0,0);
	AI:PushGoal("abberation_scared","run",0,1);
	AI:PushGoal("abberation_scared","locate",0,"hidepoint");
	AI:PushGoal("abberation_scared","acqtarget",0,"");
	AI:PushGoal("abberation_scared","approach",1,3);
	AI:PushGoal("abberation_scared","signal",1,1,"MAKE_COMBAT_BREAK_ANIM",0);
	AI:PushGoal("abberation_scared","lookat",1,-90,90);
	AI:PushGoal("abberation_scared","lookat",1,-90,90);
	AI:PushGoal("abberation_scared","lookat",1,-90,90);

	AI:CreateGoalPipe("jump_decision");
	AI:PushGoal("jump_decision","signal",1,1,"SEEK_JUMP_ANCHOR",0);

	AI:CreateGoalPipe("abberation_attack");
	AI:PushGoal("abberation_attack","firecmd",0,0);
	AI:PushGoal("abberation_attack","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("abberation_attack","run",0,1);
	AI:PushGoal("abberation_attack","approach",1,0.5);
	AI:PushGoal("abberation_attack","signal",1,1,"SEEK_JUMP_ANCHOR",0);

	AI:CreateGoalPipe("abberation_hang_back");
	AI:PushGoal("abberation_hang_back","firecmd",0,0);
	AI:PushGoal("abberation_hang_back","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("abberation_hang_back","run",0,1);
	AI:PushGoal("abberation_hang_back","signal",1,1,"MAKE_COMBAT_BREAK_ANIM",0);
	AI:PushGoal("abberation_hang_back","signal",1,1,"SELECT_MOVEMENT",0);
	AI:PushGoal("abberation_hang_back","timeout",1,0.3,0.8);

	AI:CreateGoalPipe("abberation_hang_left");
	AI:PushGoal("abberation_hang_left","hide",1,15,HM_FRONTLEFTMOST_FROM_TARGET);
	
	AI:CreateGoalPipe("abberation_hang_right");
	AI:PushGoal("abberation_hang_right","hide",1,15,HM_FRONTRIGHTMOST_FROM_TARGET);

	AI:CreateGoalPipe("abberation_hang_away");
	AI:PushGoal("abberation_hang_away","hide",1,10,HM_FARTHEST_FROM_TARGET);

	AI:CreateGoalPipe("abberation_wait_back");
	AI:PushGoal("abberation_wait_back","timeout",1,0.5,1);


	AI:CreateGoalPipe("abberation_melee");
	AI:PushGoal("abberation_melee","firecmd",1,0);
	AI:PushGoal("abberation_melee","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("abberation_melee","timeout",1,1);
	AI:PushGoal("abberation_melee","signal",1,1,"SWITCH_TO_ABBERATION_ATTACK",0);

	AI:CreateGoalPipe("mutant_idling");
	AI:PushGoal("mutant_idling","firecmd",0,0);
	AI:PushGoal("mutant_idling","firecmd",0,0);
	AI:PushGoal("mutant_idling","locate",0,"hidepoint");
	AI:PushGoal("mutant_idling","acqtarget",0,"");
	AI:PushGoal("mutant_idling","approach",1,0.4);
	AI:PushGoal("mutant_idling","devalue",0);
	AI:PushGoal("mutant_idling","lookat",1,-45,45);
	AI:PushGoal("mutant_idling","timeout",1,0,1);
	AI:PushGoal("mutant_idling","lookat",1,-45,45);
	AI:PushGoal("mutant_idling","signal",1,1,"DO_SOMETHING_IDLE",0);

	AI:CreateGoalPipe("devalue_target");
	AI:PushGoal("devalue_target","devalue",0);

	AI:CreateGoalPipe("mutant_investigate_target");
	AI:PushGoal("mutant_investigate_target","hide",0,10,HM_NEAREST_TO_TARGET);
	AI:PushGoal("mutant_investigate_target","lookat",1,-90,90);
	AI:PushGoal("mutant_investigate_target","branch",0,-1);
	AI:PushGoal("mutant_investigate_target","lookat",1,-180,180);
	AI:PushGoal("mutant_investigate_target","timeout",1,0,2);

	AI:CreateGoalPipe("mutant_avoid_grenade");
	AI:PushGoal("mutant_avoid_grenade","firecmd",0,0);
	AI:PushGoal("mutant_avoid_grenade","run",0,1);
	AI:PushGoal("mutant_avoid_grenade","hide",1,10,HM_FARTHEST_FROM_TARGET,1);
	AI:PushGoal("mutant_avoid_grenade","devalue",1);


	AI:CreateGoalPipe("mutant_random_walk");
	AI:PushGoal("mutant_random_walk","locate",0,"hidepoint");
--	AI:PushGoal("mutant_random_walk","acqtarget",0,"");
	AI:PushGoal("mutant_random_walk","timeout",1,0.5,2);
	AI:PushGoal("mutant_random_walk","approach",1,0.7);
	AI:PushGoal("mutant_random_walk","signal",0,1,"MUTANT_SELECT_IDLE",0);

	AI:CreateGoalPipe("mutant_random_look");
	AI:PushGoal("mutant_random_look","locate",0,"hidepoint");
	AI:PushGoal("mutant_random_look","acqtarget",0,"");
--	AI:PushGoal("mutant_random_look","timeout",0,2,3);
	AI:PushGoal("mutant_random_look","lookat",1,-10,10);
	AI:PushGoal("mutant_random_look","lookat",1,-10,10);
--	AI:PushGoal("mutant_random_look","branch",1,-2);
	AI:PushGoal("mutant_random_look","signal",0,1,"MUTANT_SELECT_IDLE",0);

	AI:CreateGoalPipe("m_c_shoot");
	AI:PushGoal("m_c_shoot","firecmd",0,0);
	AI:PushGoal("m_c_shoot","signal",1,1,"START_PREP_ANIMATION",0);
	AI:PushGoal("m_c_shoot","timeout",1,0.4);
	AI:PushGoal("m_c_shoot","firecmd",0,1);
	AI:PushGoal("m_c_shoot","timeout",1,0.2);
	AI:PushGoal("m_c_shoot","firecmd",0,0);
	AI:PushGoal("m_c_shoot","timeout",1,1,2);
	AI:PushGoal("m_c_shoot","signal",1,1,"STOPPED_FIRING",0);
	AI:PushGoal("m_c_shoot","signal",1,1,"RUSH_TARGET",0);

	AI:CreateGoalPipe("m_c_quickhide");
	AI:PushGoal("m_c_quickhide","run",0,1);
	AI:PushGoal("m_c_quickhide","hide",1,10,HM_NEAREST);

	AI:CreateGoalPipe("m_c_rush_target")
	AI:PushGoal("m_c_rush_target","run",0,1);
	AI:PushGoal("m_c_rush_target","firecmd",0,0);
	AI:PushGoal("m_c_rush_target","approach",1,1);
	AI:PushGoal("m_c_rush_target","clear",0);

	AI:CreateGoalPipe("m_c_rush_memory")
	AI:PushGoal("m_c_rush_target","run",0,1);
	AI:PushGoal("m_c_rush_target","approach",1,0.5);
	AI:PushGoal("m_c_rush_target","timeout",1,0.5,1);
	AI:PushGoal("m_c_rush_target","signal",0,1,"ENEMY_TARGET_LOST",SIGNALID_READIBILITY);


	AI:CreateGoalPipe("m_c_find_target")
	AI:PushGoal("m_c_find_target","run",0,0);
	AI:PushGoal("m_c_find_target","approach",1,1);


	AI:CreateGoalPipe("m_c_melee_attack");
	AI:PushGoal("m_c_melee_attack","signal",0,1,"SELECT_MELEE_ANIMATION",0);
	AI:PushGoal("m_c_melee_attack","signal",0,1,"APPLY_MELEE_DAMAGE",0);
	AI:PushGoal("m_c_melee_attack","signal",0,1,"RESET_MELEE_DAMAGE",0);

	
	AI:CreateGoalPipe("mutant_cover_cover");
	AI:PushGoal("mutant_cover_cover","firecmd",0,0);
	AI:PushGoal("mutant_cover_cover","signal",0,1,"MUTANT_COVER_UP",0);
	AI:PushGoal("mutant_cover_cover","timeout",1,2,3);
	AI:PushGoal("mutant_cover_cover","firecmd",0,1);	
	AI:PushGoal("mutant_cover_cover","signal",0,1,"MUTANT_COVER_DOWN",0);
--	AI:PushGoal("mutant_cover_cover","firecmd",0,1);
	AI:PushGoal("mutant_cover_cover","signal",0,1,"MUTANT_NORMAL_ATTACK",0);

	AI:CreateGoalPipe("mutant_cover_attack");
--	AI:PushGoal("mutant_cover_attack","firecmd",0,0);
--	AI:PushGoal("mutant_cover_attack","signal",0,1,"MUTANT_COVER_UP",0);
----	AI:PushGoal("mutant_cover_attack","timeout",1,2);
--	AI:PushGoal("mutant_cover_attack","timeout",1,1,4);
--	AI:PushGoal("mutant_cover_attack","signal",0,1,"MUTANT_COVER_DOWN",0);
--	AI:PushGoal("mutant_cover_attack","timeout",1,.1,.3);
	AI:PushGoal("mutant_cover_attack","firecmd",0,1);
	AI:PushGoal("mutant_cover_attack","approach",1,0.5);
	AI:PushGoal("mutant_cover_attack","signal",0,1,"MUTANT_NORMAL_ATTACK",0);

	AI:CreateGoalPipe("mutant_cover_close_attack");
--AI:PushGoal("mutant_cover_close_attack","bodypos",0,1);	
	AI:PushGoal("mutant_cover_close_attack","firecmd",0,1);
	AI:PushGoal("mutant_cover_close_attack","run",0,1);	
	AI:PushGoal("mutant_cover_close_attack","approach",1,5);	
--AI:PushGoal("mutant_cover_close_attack","bodypos",0,0);
	AI:PushGoal("mutant_cover_close_attack","firecmd",0,0);	
	AI:PushGoal("mutant_cover_close_attack","approach",1,1);
	AI:PushGoal("mutant_cover_close_attack","signal",0,1,"MUTANT_CLOSE_ATTACK",0);	
--	AI:PushGoal("mutant_cover_close_attack","hide",1,10,HM_RANDOM,1);	
--	AI:PushGoal("mutant_cover_close_attack","signal",0,1,"MUTANT_NORMAL_ATTACK",0);


	AI:CreateGoalPipe("mutant_cover_backoffattack");
	AI:PushGoal("mutant_cover_backoffattack","firecmd",0,1);
	AI:PushGoal("mutant_cover_backoffattack","backoff",1,7);
	AI:PushGoal("mutant_cover_backoffattack","signal",0,1,"MUTANT_NORMAL_ATTACK",0);




	AI:CreateGoalPipe("mutant_standard_attack");
	AI:PushGoal("mutant_standard_attack","firecmd",0,0);
	AI:PushGoal("mutant_standard_attack","run",0,1);		
	AI:PushGoal("mutant_standard_attack","hide",1,10,HM_NEAREST,1);
	AI:PushGoal("mutant_standard_attack","firecmd",0,1);
	AI:PushGoal("mutant_standard_attack","timeout",1,0,2);
	AI:PushGoal("mutant_standard_attack","signal",0,1,"MUTANT_NORMAL_ATTACK",0);

	AI:CreateGoalPipe("mutant_cover_strafe_left");
	AI:PushGoal("mutant_cover_strafe_left","strafe",1,-1);

	AI:CreateGoalPipe("mutant_cover_strafe_right");
	AI:PushGoal("mutant_cover_strafe_right","strafe",1,1);

	AI:CreateGoalPipe("mutant_cover_strafe");
	AI:PushGoal("mutant_cover_strafe","bodypos",1,0);
	AI:PushGoal("mutant_cover_strafe","firecmd",0,1);	
	AI:PushGoal("mutant_cover_strafe","signal",0,1,"MUTANT_COVER_STRAFE",0);	
	AI:PushGoal("mutant_cover_strafe","timeout",1,0.2,2.8);
	AI:PushGoal("mutant_cover_strafe","strafe",1,0);
	AI:PushGoal("mutant_cover_strafe","signal",0,1,"MUTANT_NORMAL_ATTACK",0);	

	AI:CreateGoalPipe("mutant_cover_strafe_hunt_right");
	AI:PushGoal("mutant_cover_strafe_hunt_right","bodypos",1,0);
	AI:PushGoal("mutant_cover_strafe_hunt_right","strafe",1,1);
	AI:PushGoal("mutant_cover_strafe_hunt_right","timeout",1,0.2,0.8);
	AI:PushGoal("mutant_cover_strafe_hunt_right","strafe",1,0);
	AI:PushGoal("mutant_cover_strafe_hunt_right","signal",0,1,"MUTANT_COVER_HUNT",0);	

	AI:CreateGoalPipe("mutant_cover_strafe_hunt_left");
	AI:PushGoal("mutant_cover_strafe_hunt_left","bodypos",1,0);
	AI:PushGoal("mutant_cover_strafe_hunt_left","strafe",1,1);
	AI:PushGoal("mutant_cover_strafe_hunt_left","timeout",1,0.2,0.8);
	AI:PushGoal("mutant_cover_strafe_hunt_left","strafe",1,0);
	AI:PushGoal("mutant_cover_strafe_hunt_left","signal",0,1,"MUTANT_COVER_HUNT",0);	

	AI:CreateGoalPipe("mutant_cover_hunt");
	AI:PushGoal("mutant_cover_hunt","locate",0,"hidepoint");
	AI:PushGoal("mutant_cover_hunt","acqtarget",0,"");
	AI:PushGoal("mutant_cover_hunt","approach",0,2);
	AI:PushGoal("mutant_cover_hunt","lookat",1,-90,90);
	AI:PushGoal("mutant_cover_hunt","timeout",1,0.2,0.8);	
	AI:PushGoal("mutant_cover_hunt","branch",1,-2);
	AI:PushGoal("mutant_cover_hunt","signal",0,1,"MUTANT_COVER_HUNT",0);

	AI:CreateGoalPipe("mutant_cover_stay");
	AI:PushGoal("mutant_cover_stay","firecmd",0,0);	
	AI:PushGoal("mutant_cover_stay","timeout",0,0.8);
	AI:PushGoal("mutant_cover_stay","signal",0,1,"MUTANT_CLOSE_ATTACK",0);	

	AI:CreateGoalPipe("mutant_crazy_attack");
	AI:PushGoal("mutant_crazy_attack","run",0,1);
	AI:PushGoal("mutant_crazy_attack","approach",1,1);
	--AI:PushGoal("mutant_crazy_attack","signal",0,1,"MUTANT_NORMAL_ATTACK",0);

	AI:CreateGoalPipe("mutant_side_attack");
	AI:PushGoal("mutant_side_attack","locate",0,"hidepoint");
	AI:PushGoal("mutant_side_attack","ignoreall",0,1);
	AI:PushGoal("mutant_side_attack","approach",1,0.8);
	AI:PushGoal("mutant_side_attack","ignoreall",0,0);
	AI:PushGoal("mutant_side_attack","mutant_crazy_attack");

	AI:CreateGoalPipe("mutant_small_jump_attack");
	AI:PushGoal("mutant_small_jump_attack","mutanthide",1,7,HM_NEAREST);
	AI:PushGoal("mutant_small_jump_attack","mutant_crazy_attack");

	AI:CreateGoalPipe("mutant_runaway");
	AI:PushGoal("mutant_runaway","run",0,1);
	AI:PushGoal("mutant_runaway","hide",1,20,HM_FARTHEST_FROM_TARGET,1);
	AI:PushGoal("mutant_runaway","signal",0,1,"MUTANT_NORMAL_ATTACK",0);
	
	AI:CreateGoalPipe("mutant_stay");
	AI:PushGoal("mutant_stay","firecmd",0,0);	
	AI:PushGoal("mutant_stay","approach",0,0.1);
	AI:PushGoal("mutant_stay","timeout",0,0.8);
	AI:PushGoal("mutant_stay","backoff",0,0.1);
	AI:PushGoal("mutant_stay","signal",0,1,"MUTANT_NORMAL_ATTACK",0);	
	
	AI:CreateGoalPipe("mutant_shocker");
	AI:PushGoal("mutant_shocker","firecmd",0,1);
--	AI:PushGoal("mutant_shocker","backoff",1,0.4);
--	AI:PushGoal("mutant_shocker","firecmd",0,1);	
	AI:PushGoal("mutant_shocker","timeout",0,0.5,1);
	AI:PushGoal("mutant_shocker","signal",0,1,"MUTANT_NORMAL_ATTACK",0);	

--
-----------------------------------------------------------------------------------------
--	Mutant rear
-----------------------------------------------------------------------------------------
--


	AI:CreateGoalPipe("mutant_refract_sneak");
	AI:PushGoal("mutant_refract_sneak","signal",1,1,"GO_REFRACTIVE",0);
	AI:PushGoal("mutant_refract_sneak","take_cover");
	AI:PushGoal("mutant_refract_sneak","run",0,1);
	AI:PushGoal("mutant_refract_sneak","hide",1,10,HM_NEAREST_TO_TARGET);
	AI:PushGoal("mutant_refract_sneak","branch",0,-1,1);
	AI:PushGoal("mutant_refract_sneak","signal",1,1,"GO_VISIBLE",0);
	AI:PushGoal("mutant_refract_sneak","clear",0);

	AI:CreateGoalPipe("mutant_refract_retreat");
	AI:PushGoal("mutant_refract_retreat","signal",1,1,"GO_REFRACTIVE",0);
	AI:PushGoal("mutant_refract_retreat","take_cover");
	AI:PushGoal("mutant_refract_retreat","hide",1,10,HM_FARTHEST_FROM_TARGET,1);
	AI:PushGoal("mutant_refract_retreat","timeout",1,0,2);
	AI:PushGoal("mutant_refract_retreat","signal",1,1,"GO_VISIBLE",0);
	AI:PushGoal("mutant_refract_retreat","clear",0);

	AI:CreateGoalPipe("mutant_monkey_attack");
	AI:PushGoal("mutant_monkey_attack","signal",1,1,"GO_REFRACTIVE",0);
	AI:PushGoal("mutant_monkey_attack","mutant_call_monkeys");
	AI:PushGoal("mutant_monkey_attack","firecmd",0,1);
	AI:PushGoal("mutant_monkey_attack","shoot_cover");
	AI:PushGoal("mutant_monkey_attack","run",0,1);
	AI:PushGoal("mutant_monkey_attack","timeout",1,3,6);
	AI:PushGoal("mutant_monkey_attack","mutant_unleash_monkeys");
	AI:PushGoal("mutant_monkey_attack","signal",1,1,"GO_VISIBLE",0);
	AI:PushGoal("mutant_monkey_attack","firecmd",0,0);
	AI:PushGoal("mutant_monkey_attack","hide",1,10,HM_FRONTLEFTMOST_FROM_TARGET);
	AI:PushGoal("mutant_monkey_attack","hide",1,10,HM_NEAREST_TO_TARGET);
	AI:PushGoal("mutant_monkey_attack","firecmd",0,1);
	AI:PushGoal("mutant_monkey_attack","hide",1,10,HM_FRONTLEFTMOST_FROM_TARGET);
	AI:PushGoal("mutant_monkey_attack","hide",1,10,HM_NEAREST_TO_TARGET);
	AI:PushGoal("mutant_monkey_attack","clear",0);
	

	AI:CreateGoalPipe("mutant_call_monkeys");
	AI:PushGoal("mutant_call_monkeys","form",1,"mutant_form");
	AI:PushGoal("mutant_call_monkeys","signal",1,1,"wakeup",SIGNALFILTER_SUPERGROUP);
	AI:PushGoal("mutant_call_monkeys","signal",1,1,"COME_TO_ME",SIGNALFILTER_SUPERGROUP);

	AI:CreateGoalPipe("mutant_unleash_monkeys");
	AI:PushGoal("mutant_unleash_monkeys","form",1,"");
	AI:PushGoal("mutant_unleash_monkeys","form",1,"beacon");
	AI:PushGoal("mutant_unleash_monkeys","signal",1,1,"ATTACK_BEACON",SIGNALFILTER_SUPERGROUP);
	
	AI:CreateGoalPipe("mutant_refract_attack");
	AI:PushGoal("mutant_refract_attack","firecmd",0,0);
	AI:PushGoal("mutant_refract_attack","signal",1,1,"GO_REFRACTIVE",0);
	AI:PushGoal("mutant_refract_attack","take_cover");
	AI:PushGoal("mutant_refract_attack","run",0,1);
	AI:PushGoal("mutant_refract_attack","signal",1,1,"GO_VISIBLE",0);
	AI:PushGoal("mutant_refract_attack","firecmd",0,1);
	AI:PushGoal("mutant_refract_attack","approach",1,3);
	AI:PushGoal("mutant_refract_attack","clear",0);


	AI:CreateGoalPipe("mutant_advance_one_cover");
	AI:PushGoal("mutant_advance_one_cover","strafe",0,0);
	AI:PushGoal("mutant_advance_one_cover","hide",1,10,HM_NEAREST_TO_TARGET,1,1);
	AI:PushGoal("mutant_advance_one_cover","branch",1,-1,1);

	AI:CreateGoalPipe("monkey_attack_beacon");
	AI:PushGoal("monkey_attack_beacon","locate",0,"beacon");
	AI:PushGoal("monkey_attack_beacon","acqtarget",0,"");
	AI:PushGoal("monkey_attack_beacon","run",0,1);
	AI:PushGoal("monkey_attack_beacon","approach",1,1);
	AI:PushGoal("monkey_attack_beacon","clear",0);

	AI:CreateGoalPipe("monkey_form");
	AI:PushGoal("monkey_form","locate",0,"formation");
	AI:PushGoal("monkey_form","ignoreall",0,1);
	AI:PushGoal("monkey_form","acqtarget",0,"");
	AI:PushGoal("monkey_form","run",0,1);
	AI:PushGoal("monkey_form","approach",1,1);


--
-----------------------------------------------------------------------------------------
--	Mutant Scout
-----------------------------------------------------------------------------------------
--

	AI:CreateGoalPipe("mutant_scout_attack_far");
	AI:PushGoal("mutant_scout_attack_far","bodypos",0,0);
	AI:PushGoal("mutant_scout_attack_far","firecmd",0,1);
	AI:PushGoal("mutant_scout_attack_far","run",0,1);
	AI:PushGoal("mutant_scout_attack_far","mutanthide",1,15,HM_LEFTMOST_FROM_TARGET);
	AI:PushGoal("mutant_scout_attack_far","reload");
	AI:PushGoal("mutant_scout_attack_far","timeout",1,1,2);
	
	AI:CreateGoalPipe("mutant_scout_attack_left");
	AI:PushGoal("mutant_scout_attack_left","bodypos",0,0);
	AI:PushGoal("mutant_scout_attack_left","firecmd",0,1);
	AI:PushGoal("mutant_scout_attack_left","timeout",1,0,0.5);
	AI:PushGoal("mutant_scout_attack_left","run",0,1);
	AI:PushGoal("mutant_scout_attack_left","mutanthide",1,15,HM_FRONTLEFTMOST_FROM_TARGET);
	AI:PushGoal("mutant_scout_attack_left","reload");
	AI:PushGoal("mutant_scout_attack_left","timeout",1,1,2);
	
	AI:CreateGoalPipe("mutant_scout_attack_right");
	AI:PushGoal("mutant_scout_attack_right","bodypos",0,0);
	AI:PushGoal("mutant_scout_attack_right","firecmd",0,1);
	AI:PushGoal("mutant_scout_attack_right","timeout",1,0,0.5);
	AI:PushGoal("mutant_scout_attack_right","run",0,1);
	AI:PushGoal("mutant_scout_attack_right","mutanthide",1,15,HM_FRONTRIGHTMOST_FROM_TARGET);
	AI:PushGoal("mutant_scout_attack_right","reload");
	AI:PushGoal("mutant_scout_attack_right","timeout",1,1,2);

	AI:CreateGoalPipe("mutant_scout_attack_rand");
	AI:PushGoal("mutant_scout_attack_rand","bodypos",0,0);
	AI:PushGoal("mutant_scout_attack_rand","firecmd",0,1);
	AI:PushGoal("mutant_scout_attack_rand","timeout",1,0,0.5);
	AI:PushGoal("mutant_scout_attack_rand","run",0,1);
	AI:PushGoal("mutant_scout_attack_rand","mutanthide",1,15,HM_RANDOM);
--	AI:PushGoal("mutant_scout_attack_rand","reload");
	AI:PushGoal("mutant_scout_attack_rand","timeout",1,1,2);
	
	AI:CreateGoalPipe("mutant_scout_cover_NOW");
	AI:PushGoal("mutant_scout_cover_NOW","firecmd",0,1);
	AI:PushGoal("mutant_scout_cover_NOW","mutanthide",1,15,HM_NEAREST);
	AI:PushGoal("mutant_scout_cover_NOW","signal",0,1,"SCOUT_NORMALATTACK",0);
	
	AI:CreateGoalPipe("mutant_scout_tooclose_attack_beacon")
	AI:PushGoal("mutant_scout_tooclose_attack_beacon","DropBeaconAt",0);
	AI:PushGoal("mutant_scout_tooclose_attack_beacon","mutant_scout_tooclose_attack",0);
	
	AI:CreateGoalPipe("mutant_scout_tooclose_attack");
	AI:PushGoal("mutant_scout_tooclose_attack","firecmd",0,1);
	AI:PushGoal("mutant_scout_tooclose_attack","request_cover");
	AI:PushGoal("mutant_scout_tooclose_attack","run",0,1);
	AI:PushGoal("mutant_scout_tooclose_attack","bodypos",0,0);
	AI:PushGoal("mutant_scout_tooclose_attack","firecmd",0,0);
	AI:PushGoal("mutant_scout_tooclose_attack","mutanthide",1,15,HM_FARTHEST_FROM_TARGET,1);
	AI:PushGoal("mutant_scout_tooclose_attack","firecmd",0,1);
--	AI:PushGoal("scout_tooclose_attack","hide",1,5,HM_NEAREST);
	AI:PushGoal("mutant_scout_tooclose_attack","run",0,0);
	AI:PushGoal("mutant_scout_tooclose_attack","reload");
	AI:PushGoal("mutant_scout_tooclose_attack","signal",0,1,"SCOUT_NORMALATTACK",0);

	AI:CreateGoalPipe("mutant_scout_hunt");
	AI:PushGoal("mutant_scout_hunt","bodypos",0,1);
	AI:PushGoal("mutant_scout_hunt","mutanthide",1,15,HM_NEAREST_TO_TARGET);
	AI:PushGoal("mutant_scout_hunt","lookat",1,-90,90);
	AI:PushGoal("mutant_scout_hunt","timeout",1,1,2);
	AI:PushGoal("mutant_scout_hunt","branch",0,-3,1);	
	-- try to get closer as long as there is cover to advance
	AI:PushGoal("mutant_scout_hunt","scout_dropebeacon_and_target");
	AI:PushGoal("mutant_scout_hunt","signal",0,1,"SCOUT_HIDE_LEFT_OR_RIGHT",0);	
	AI:PushGoal("mutant_scout_hunt","lookat",1,-90,90);
	AI:PushGoal("mutant_scout_hunt","timeout",1,1,2);
	AI:PushGoal("mutant_scout_hunt","scout_dropebeacon_and_target");
	AI:PushGoal("mutant_scout_hunt","signal",0,1,"SCOUT_HIDE_LEFT_OR_RIGHT",0);	
	AI:PushGoal("mutant_scout_hunt","lookat",1,-90,90);
	AI:PushGoal("mutant_scout_hunt","timeout",1,1,2);
	AI:PushGoal("mutant_scout_hunt","branch",0,-12,1);	-- if you succeeded moving left, now try moving closer again
	-- if you get here, it means that you cannot move with cover anywhere
	AI:PushGoal("mutant_scout_hunt","timeout",1,2,5);	-- think about it some time
	AI:PushGoal("mutant_scout_hunt","bodypos",0,1);
	AI:PushGoal("mutant_scout_hunt","approach",1,0.5);	-- halve the distance to your target
	AI:PushGoal("mutant_scout_hunt","signal",0,1,"SCOUT_GOTO_ALERT",0);	


	AI:CreateGoalPipe("approach_and_look_at");
	AI:PushGoal("approach_and_look_at","acqtarget",0,"");
	AI:PushGoal("approach_and_look_at","approach",1,1);
	AI:PushGoal("approach_and_look_at","lookat",1,0,0);

	AI:CreateGoalPipe("mutant_eat");
	AI:PushGoal("mutant_eat","signal",0,1,"PLAY_FEED_LOOP",0);
	AI:PushGoal("mutant_eat","signal",0,1,"DECISION_POINT",0);
	
	System:Log("MUTANT PIPES LOADED");
end






