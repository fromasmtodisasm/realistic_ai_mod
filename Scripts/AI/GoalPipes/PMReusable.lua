
function PipeManager:InitReusable()

	AI:CreateGoalPipe("shoot_the_beacon");
	--AI:PushGoal("shoot_the_beacon","signal",1,1,"MAKE_ME_IGNORANT",0);
	AI:PushGoal("shoot_the_beacon","locate",1,"beacon");
	AI:PushGoal("shoot_the_beacon","acqtarget",1,"");
	AI:PushGoal("shoot_the_beacon","firecmd",0,2);
	AI:PushGoal("shoot_the_beacon","timeout",1,2,4);
	AI:PushGoal("shoot_the_beacon","firecmd",0,1);
	--AI:PushGoal("shoot_the_beacon","signal",1,-1,"MAKE_ME_UNIGNORANT",0);

	AI:CreateGoalPipe("bomb_the_beacon");
	--AI:PushGoal("bomb_the_beacon","signal",1,1,"MAKE_ME_IGNORANT",0);
	AI:PushGoal("bomb_the_beacon","locate",1,"beacon");
	AI:PushGoal("bomb_the_beacon","acqtarget",1,"");
	AI:PushGoal("bomb_the_beacon","firecmd",1,0);
	AI:PushGoal("bomb_the_beacon","throw_grenade");
	--AI:PushGoal("bomb_the_beacon","signal",1,-1,"MAKE_ME_UNIGNORANT",0);


	AI:CreateGoalPipe("friend_circle");
	AI:PushGoal("friend_circle","strafe",1,3);

	AI:CreateGoalPipe("scared_shoot");
	AI:PushGoal("scared_shoot","firecmd",1,2);
	AI:PushGoal("scared_shoot","firecmd",1,2);
	AI:PushGoal("scared_shoot","signal",1,1,"AI_AGGRESSIVE",SIGNALID_READIBILITY);
	AI:PushGoal("scared_shoot","form",1,"beacon");
	AI:PushGoal("scared_shoot","locate",1,"beacon");
	AI:PushGoal("scared_shoot","timeout",1,0.5,2);
	AI:PushGoal("scared_shoot","firecmd",1,1);

	AI:CreateGoalPipe("retaliate_damage");
	AI:PushGoal("retaliate_damage","devalue",0,1);
	AI:PushGoal("retaliate_damage","acqtarget",0,"");
	AI:PushGoal("retaliate_damage","clear",0);


	AI:CreateGoalPipe("dodge_wrapper");
	--AI:PushGoal("dodge_wrapper","firecmd",1,1);
	--AI:PushGoal("dodge_wrapper","timeout",1,0.3,0.5);
	AI:PushGoal("dodge_wrapper","signal",1,1,"TRY_NEXT",0);

	AI:CreateGoalPipe("crowe_dodge_1");
	AI:PushGoal("crowe_dodge_1","strafe",1,-5);
	AI:PushGoal("crowe_dodge_1","signal",1,1,"TRY_NEXT",0);

	AI:CreateGoalPipe("crowe_dodge_3");
	AI:PushGoal("crowe_dodge_3","strafe",1,-3);
	AI:PushGoal("crowe_dodge_3","signal",1,1,"TRY_NEXT",0);

	AI:CreateGoalPipe("crowe_dodge_2");
	AI:PushGoal("crowe_dodge_2","strafe",1,3);
	AI:PushGoal("crowe_dodge_2","signal",1,1,"TRY_NEXT",0);

	AI:CreateGoalPipe("crowe_dodge_4");
	AI:PushGoal("crowe_dodge_4","strafe",1,5);
	AI:PushGoal("crowe_dodge_4","signal",1,1,"TRY_NEXT",0);




	AI:CreateGoalPipe("hide_forward");
	AI:PushGoal("hide_forward","hide",1,30,HM_NEAREST_TO_TARGET);

	AI:CreateGoalPipe("dumb_wrapper");
	AI:PushGoal("dumb_wrapper","timeout",1,1);
	AI:PushGoal("dumb_wrapper","signal",1,-1,"DO_SOMETHING_IDLE",0);

	AI:CreateGoalPipe("hold_spot");
	AI:PushGoal("hold_spot","bodypos",0,BODYPOS_COMBAT);
	AI:PushGoal("hold_spot","locate",1,AIAnchor.SPECIAL_HOLD_SPOT);
	AI:PushGoal("hold_spot","ignoreall",0,1);
	AI:PushGoal("hold_spot","acqtarget",0,"");
	AI:PushGoal("hold_spot","run",1,1);
	AI:PushGoal("hold_spot","approach",1,1);
	AI:PushGoal("hold_spot","ignoreall",0,0);
	AI:PushGoal("hold_spot","lookat",1,-45,45);
	AI:PushGoal("hold_spot","timeout",1,0.5,2);

	AI:CreateGoalPipe("retreat_back");
	AI:PushGoal("retreat_back","ignoreall",0,1);
	AI:PushGoal("retreat_back","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("retreat_back","timeout",1,0.2,0.6);
	AI:PushGoal("retreat_back","signal",1,1,"REGISTER_AS_RETREATER",0);
	AI:PushGoal("retreat_back","signal",1,1,"PROVIDE_COVERING_FIRE",SIGNALFILTER_SUPERGROUP);
	AI:PushGoal("retreat_back","firecmd",0,0);
	AI:PushGoal("retreat_back","run",0,1);
	AI:PushGoal("retreat_back","hide",1,35,HM_FARTHEST_FROM_TARGET,1);
	AI:PushGoal("retreat_back","firecmd",0,1);
	AI:PushGoal("retreat_back","signal",1,1,"RETREATED_SAFE",0);
	AI:PushGoal("retreat_back","ignoreall",0,0);

	AI:CreateGoalPipe("retreat_back_phase2");
	AI:PushGoal("retreat_back_phase2","ignoreall",0,1);
	AI:PushGoal("retreat_back_phase2","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("retreat_back_phase2","timeout",1,0.2,0.6);
	AI:PushGoal("retreat_back_phase2","signal",1,1,"REGISTER_AS_RETREATER",0);
	AI:PushGoal("retreat_back_phase2","firecmd",0,0);
	AI:PushGoal("retreat_back_phase2","run",0,1);
	AI:PushGoal("retreat_back_phase2","hide",1,35,HM_FARTHEST_FROM_TARGET,1);
	AI:PushGoal("retreat_back_phase2","firecmd",0,1);
	AI:PushGoal("retreat_back_phase2","signal",1,1,"RETREATED_SAFE_PHASE2",0);
	AI:PushGoal("retreat_back_phase2","ignoreall",0,0);

	AI:CreateGoalPipe("retreat_to_spot");
	AI:PushGoal("retreat_to_spot","ignoreall",0,1);
	AI:PushGoal("retreat_to_spot","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("retreat_to_spot","timeout",1,0.2,0.6);
	AI:PushGoal("retreat_to_spot","signal",1,1,"REGISTER_AS_RETREATER",0);
	AI:PushGoal("retreat_to_spot","signal",1,1,"PROVIDE_COVERING_FIRE",SIGNALFILTER_SUPERGROUP);
	AI:PushGoal("retreat_to_spot","firecmd",0,0);
	AI:PushGoal("retreat_to_spot","run",0,1);
	AI:PushGoal("retreat_to_spot","hide",1,35,HM_NEAREST_TO_LASTOPRESULT,1);
	AI:PushGoal("retreat_to_spot","firecmd",0,1);
	AI:PushGoal("retreat_to_spot","signal",1,1,"RETREATED_SAFE",0);
	AI:PushGoal("retreat_to_spot","ignoreall",0,0);

	AI:CreateGoalPipe("retreat_to_spot_phase2");
	AI:PushGoal("retreat_to_spot_phase2","ignoreall",0,1);
	AI:PushGoal("retreat_to_spot_phase2","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("retreat_to_spot_phase2","timeout",1,0.2,0.6);
	AI:PushGoal("retreat_to_spot_phase2","signal",1,1,"REGISTER_AS_RETREATER",0);
	AI:PushGoal("retreat_to_spot_phase2","firecmd",0,0);
	AI:PushGoal("retreat_to_spot_phase2","run",0,1);
	AI:PushGoal("retreat_to_spot_phase2","hide",1,35,HM_NEAREST_TO_LASTOPRESULT,1);
	AI:PushGoal("retreat_to_spot_phase2","firecmd",0,1);
	AI:PushGoal("retreat_to_spot_phase2","signal",1,1,"RETREATED_SAFE_PHASE2",0);
	AI:PushGoal("retreat_to_spot_phase2","ignoreall",0,0);

	
	AI:CreateGoalPipe("shoot_to");
	AI:PushGoal("shoot_to","ignoreall",0,1);
	AI:PushGoal("shoot_to","acqtarget",0,"");
	AI:PushGoal("shoot_to","firecmd",0,2);
	AI:PushGoal("shoot_to","timeout",1,0.5,1.5);
	AI:PushGoal("shoot_to","firecmd",0,1);
	AI:PushGoal("shoot_to","ignoreall",0,0);

	AI:CreateGoalPipe("special_hold_position");
	AI:PushGoal("special_hold_position","take_cover");
	AI:PushGoal("special_hold_position","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("special_hold_position","take_cover");
	AI:PushGoal("special_hold_position","lookat",1,-90,90);
	AI:PushGoal("special_hold_position","take_cover");
	AI:PushGoal("special_hold_position","lookat",1,-90,90);
	AI:PushGoal("special_hold_position","clear",0);

	AI:CreateGoalPipe("throw_flare");
	AI:PushGoal("throw_flare","locate",1,AIAnchor.AIANCHOR_THROW_FLARE);
	AI:PushGoal("throw_flare","ignoreall",1,1);
	AI:PushGoal("throw_flare","acqtarget",1,"");
	AI:PushGoal("throw_flare","unconditional_flare");
	AI:PushGoal("throw_flare","timeout",1,0.2);
	AI:PushGoal("throw_flare","ignoreall",1,0);
	AI:PushGoal("throw_flare","signal",1,1,"SWITCH_GRENADE_TYPE",0);

	AI:CreateGoalPipe("unconditional_flare");
	AI:PushGoal("unconditional_flare","signal",1,1,"GET_REINFORCEMENTS",SIGNALID_READIBILITY);
	AI:PushGoal("unconditional_flare","signal",1,1,"SHARED_GRANATE_THROW_ANIM",0);
	AI:PushGoal("unconditional_flare","timeout",1,1);
	AI:PushGoal("unconditional_flare","signal",1,-10,"grenate",0);

	AI:CreateGoalPipe("make_formation");
	AI:PushGoal("make_formation","form",0,"wedge");
	AI:PushGoal("make_formation","signal",1,1,"FOLLOW_ME",SIGNALFILTER_SUPERGROUP);

	AI:CreateGoalPipe("simple_follow");
	AI:PushGoal("simple_follow","approach",1,1);

	AI:CreateGoalPipe("follow_leader");
	AI:PushGoal("follow_leader","locate",0,"formation");
	AI:PushGoal("follow_leader","acqtarget",0,"");

	AI:CreateGoalPipe("flashlight_investigate");
	AI:PushGoal("flashlight_investigate","signal",1,1,"FLASHLIGHT_ON",0);
	AI:PushGoal("flashlight_investigate","lookat",1,0,0);
	AI:PushGoal("flashlight_investigate","timeout",1,0.5,1.5);
	AI:PushGoal("flashlight_investigate","lookat",1,-90,90);
	AI:PushGoal("flashlight_investigate","timeout",1,0.5,1.5);
	AI:PushGoal("flashlight_investigate","lookat",1,-90,90);
	AI:PushGoal("flashlight_investigate","timeout",1,0.5,1.5);
	AI:PushGoal("flashlight_investigate","signal",1,1,"FLASHLIGHT_OFF",0);


	AI:CreateGoalPipe("stand_timer");
	AI:PushGoal("stand_timer","acqtarget",1,"");
	AI:PushGoal("stand_timer","timeout",1,3);
	AI:PushGoal("stand_timer","clear",0);
	AI:PushGoal("stand_timer","timeout",1,1000);

	-----------------------------------------
	-- Investigate surroundings while remaining in formation if one exists		CHECK IF THIS CAN BE SAFELY REMOVED
	----------------------------------------------
	AI:CreateGoalPipe("formation_investigate");
	AI:PushGoal("formation_investigate","locate",0,"formation");
	AI:PushGoal("formation_investigate","acqtarget",0,"");
	AI:PushGoal("formation_investigate","approach",0,2);
	AI:PushGoal("formation_investigate","lookaround",1,3);
	AI:PushGoal("formation_investigate","branch",0,-1);
	AI:PushGoal("formation_investigate","lookaround",1,-1);
	AI:PushGoal("formation_investigate","lookaround",1,-1);

	AI:CreateGoalPipe("check_it_out");
	AI:PushGoal("check_it_out","bodypos",0,BODYPOS_STEALTH);
	AI:PushGoal("check_it_out","lookat",1,-90,90);
	AI:PushGoal("check_it_out","lookat",1,-90,90);
	AI:PushGoal("check_it_out","bodypos",0,BODYPOS_STAND);

	-- use this pipe when you want to change behaviour and then issue the same signal in the new behaviour
	AI:CreateGoalPipe("force_reevaluate");
	--AI:PushGoal("force_reevaluate","timeout",1,0.5);
	AI:PushGoal("force_reevaluate","clear",0);

	-- new improved crouch should be used instead of directly calling bodypos
	AI:CreateGoalPipe("goto_crouch");
	AI:PushGoal("goto_crouch","signal",0,1,"DEFAULT_CURRENT_TO_CROUCH",0);
	AI:PushGoal("goto_crouch","timeout",1,1.5);
	AI:PushGoal("goto_crouch","bodypos",0,1);

	-- new improved prone should be used instead of directly calling bodypos
	AI:CreateGoalPipe("goto_prone");
	AI:PushGoal("goto_prone","signal",0,1,"DEFAULT_CURRENT_TO_PRONE",0);
	AI:PushGoal("goto_prone","timeout",1,1.5);
	AI:PushGoal("goto_prone","bodypos",0,2);

	AI:CreateGoalPipe("lookat_beacon");
	AI:PushGoal("lookat_beacon","locate",0,"beacon");
	AI:PushGoal("lookat_beacon","acqtarget",0,"");
	AI:PushGoal("lookat_beacon","timeout",1,1,1.5);
	AI:PushGoal("lookat_beacon","lookat",1,-90,90);
	AI:PushGoal("lookat_beacon","lookat",1,-90,90);

	-- new improved prone should be used instead of directly calling bodypos
	AI:CreateGoalPipe("goto_stand");
	AI:PushGoal("goto_stand","signal",0,1,"DEFAULT_CURRENT_TO_STAND",0);
	AI:PushGoal("goto_stand","timeout",1,1.5);
	AI:PushGoal("goto_stand","bodypos",0,0);

	AI:CreateGoalPipe("grenade_run_hide");
	AI:PushGoal("grenade_run_hide","firecmd",0,0);
	AI:PushGoal("grenade_run_hide","bodypos",0,0);
	AI:PushGoal("grenade_run_hide","run",0,1);
	AI:PushGoal("grenade_run_hide","hide",1,6,HM_FARTHEST_FROM_TARGET);
	AI:PushGoal("grenade_run_hide","devalue",1);

	AI:CreateGoalPipe("grenade_run_away");
	AI:PushGoal("grenade_run_away","firecmd",0,0);
	AI:PushGoal("grenade_run_away","bodypos",0,0);
	AI:PushGoal("grenade_run_away","run",0,1);
	AI:PushGoal("grenade_run_away","backoff",1,6);
	AI:PushGoal("grenade_run_away","devalue",1);
		
	AI:CreateGoalPipe("randomhide");
	AI:PushGoal("randomhide","firecmd",0,0);
	AI:PushGoal("randomhide","devalue");
	AI:PushGoal("randomhide","locate",0,"hidepoint");
	AI:PushGoal("randomhide","acqtarget",0,"");
	AI:PushGoal("randomhide","run",0,1);
	AI:PushGoal("randomhide","approach",1,2);
	AI:PushGoal("randomhide","bodypos",0,1);
	AI:PushGoal("randomhide","devalue",0);
	AI:PushGoal("randomhide","signal",1,1,"TRY_TO_LOCATE_SOURCE",0);
	
	AI:CreateGoalPipe("randomhide_trace");
	AI:PushGoal("randomhide_trace","firecmd",0,0);
	AI:PushGoal("randomhide_trace","locate",0,"hidepoint");
	AI:PushGoal("randomhide_trace","bodypos",0,0);
	AI:PushGoal("randomhide_trace","run",0,1);
	AI:PushGoal("randomhide_trace","pathfind",1,"");
	AI:PushGoal("randomhide_trace","trace",1,1);
	AI:PushGoal("randomhide_trace","bodypos",0,1);
	AI:PushGoal("randomhide_trace","signal",0,1,"TRY_TO_LOCATE_SOURCE",0);
	
	AI:CreateGoalPipe("not_so_random_hide_from");
	AI:PushGoal("not_so_random_hide_from","devalue",0);
	AI:PushGoal("not_so_random_hide_from","form",0,"beacon");
	AI:PushGoal("not_so_random_hide_from","locate",0,"beacon");
	AI:PushGoal("not_so_random_hide_from","acqtarget",1,"");
	AI:PushGoal("not_so_random_hide_from","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("not_so_random_hide_from","run",0,1);
	AI:PushGoal("not_so_random_hide_from","hide",1,10,HM_NEAREST,1)
	AI:PushGoal("not_so_random_hide_from","bodypos",0,BODYPOS_CROUCH);
	AI:PushGoal("not_so_random_hide_from","run",0,0);
	AI:PushGoal("not_so_random_hide_from","timeout",1,1,3);
	--AI:PushGoal("not_so_random_hide_from","signal",1,1,"TRY_TO_LOCATE_SOURCE",0);

	AI:CreateGoalPipe("basic_lookingaround");
	AI:PushGoal("basic_lookingaround","force_reevaluate");
	AI:PushGoal("basic_lookingaround","lookat",1,-90,90);
	AI:PushGoal("basic_lookingaround","timeout",1,1,3);

	AI:CreateGoalPipe("advanced_lookingaround");
	AI:PushGoal("advanced_lookingaround","basic_lookingaround");
	AI:PushGoal("advanced_lookingaround","locate",0,"hidepoint");
	AI:PushGoal("advanced_lookingaround","approach",1,0.5);

	AI:CreateGoalPipe("lookaround_30seconds");
	AI:PushGoal("lookaround_30seconds","clear")
	AI:PushGoal("lookaround_30seconds","timeout",0,30)
	AI:PushGoal("lookaround_30seconds","lookat",1,-90,90);
	AI:PushGoal("lookaround_30seconds","timeout",1,1,3);
	AI:PushGoal("lookaround_30seconds","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("lookaround_30seconds","timeout",1,1,3);
	AI:PushGoal("lookaround_30seconds","strafe",1,-2);
	AI:PushGoal("lookaround_30seconds","bodypos",0,BODYPOS_CROUCH);
	AI:PushGoal("lookaround_30seconds","lookat",1,-90,90);
	AI:PushGoal("lookaround_30seconds","timeout",1,1,3);
	AI:PushGoal("lookaround_30seconds","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("lookaround_30seconds","timeout",1,1,3);
	AI:PushGoal("lookaround_30seconds","strafe",1,2);
	AI:PushGoal("lookaround_30seconds","bodypos",0,BODYPOS_CROUCH);
	AI:PushGoal("lookaround_30seconds","branch",0,-6);


	AI:CreateGoalPipe("stealth_idle");
	AI:PushGoal("stealth_idle","bodypos",0,5);
	AI:PushGoal("stealth_idle","lookaround",1,-1);
	AI:PushGoal("stealth_idle","timeout",1,1);
	
	AI:CreateGoalPipe("stealth_surround");
--	AI:PushGoal("stealth_surround","signal",0,1,"FIRST_CONTACT",SIGNALID_READIBILITY);		
	AI:PushGoal("stealth_surround","bodypos",0,5);		-- go into stealth mode
	AI:PushGoal("stealth_surround","timeout",1,1);		-- freeze for a sec
	AI:PushGoal("stealth_surround","lookaround",1,3);	-- try to locate source without moving
	AI:PushGoal("stealth_surround","lookaround",1,3);
	AI:PushGoal("stealth_surround","strafe",0,1);
	AI:PushGoal("stealth_surround","timeout",1,0.5);
	AI:PushGoal("stealth_surround","strafe",0,0);
	AI:PushGoal("stealth_surround","timeout",1,1);		-- freeze for a sec
	AI:PushGoal("stealth_surround","lookaround",1,3);	-- try to locate source without moving
	AI:PushGoal("stealth_surround","strafe",0,-1);
	AI:PushGoal("stealth_surround","timeout",1,1);
	AI:PushGoal("stealth_surround","strafe",0,0);
	AI:PushGoal("stealth_surround","timeout",1,1);		-- freeze for a sec
	AI:PushGoal("stealth_surround","lookaround",1,3);	-- try to locate source without moving
	AI:PushGoal("stealth_surround","hide",1,10,5);   	-- try to hide left of disturbance

	AI:CreateGoalPipe("advise_caution_to_team");
	AI:PushGoal("advise_caution_to_team","bodypos",0,1);
	AI:PushGoal("advise_caution_to_team","signal",0,1,"DISTURBANCE_NOTICE",SIGNALFILTER_GROUPONLY);
	AI:PushGoal("advise_caution_to_team","timeout",1,1);
	AI:PushGoal("advise_caution_to_team","bodypos",0,0);

	-- later enhance with all kind of cool anims and sounds
	AI:CreateGoalPipe("request_cover");
	AI:PushGoal("request_cover","signal",0,1,"OnCoverRequested",SIGNALFILTER_GROUPONLY);

	AI:CreateGoalPipe("reload");
	AI:PushGoal("reload","signal",0,1,"SHARED_RELOAD",0);


	AI:CreateGoalPipe("throw_grenade");
	AI:PushGoal("throw_grenade","timeout",1,0.2);
	AI:PushGoal("throw_grenade","signal",0,1,"SHARED_GRENADE_THROW_OR_NOT",0);

	AI:CreateGoalPipe("unconditional_grenade");
	AI:PushGoal("unconditional_grenade","signal",1,1,"FIRE_IN_THE_HOLE",SIGNALID_READIBILITY);
	AI:PushGoal("unconditional_grenade","signal",1,1,"SHARED_GRANATE_THROW_ANIM",0);
	AI:PushGoal("unconditional_grenade","timeout",1,1);
	AI:PushGoal("unconditional_grenade","signal",1,-10,"grenate",0);


	AI:CreateGoalPipe("look_in_direction_of");
	AI:PushGoal("look_in_direction_of","acqtarget",0,"");
	AI:PushGoal("look_in_direction_of","timeout",1,1,3);
	AI:PushGoal("look_in_direction_of","lookat",1,-180,180);


	AI:CreateGoalPipe("minimize_exposure");
	AI:PushGoal("minimize_exposure","run",0,1);
	AI:PushGoal("minimize_exposure","run",0,1);
	AI:PushGoal("minimize_exposure","bodypos",0,0);
	AI:PushGoal("minimize_exposure","firecmd",0,0);
	AI:PushGoal("minimize_exposure","hide",1,20,HM_NEAREST,1);
	AI:PushGoal("minimize_exposure","run",0,0);

	AI:CreateGoalPipe("notify_team");
	AI:PushGoal("notify_team","lookaround",1,-1);
	AI:PushGoal("notify_team","lookaround",1,-1);
	AI:PushGoal("notify_team","advise_caution_to_team");
	AI:PushGoal("notify_team","signal",0,1,"KEEP_ALERTED",0);

	AI:CreateGoalPipe("kneeling_left_attack");
	AI:PushGoal("kneeling_left_attack","firecmd",0,1);
	AI:PushGoal("kneeling_left_attack","strafe",0,-1);
	AI:PushGoal("kneeling_left_attack","timeout",1,0.5,1);
	AI:PushGoal("kneeling_left_attack","strafe",0,0);
	AI:PushGoal("kneeling_left_attack","timeout",1,0.5);
	AI:PushGoal("kneeling_left_attack","signal",0,1,"DEFAULT_GO_KNEEL",0);
	AI:PushGoal("kneeling_left_attack","timeout",1,2,4);
	AI:PushGoal("kneeling_left_attack","signal",0,1,"DEFAULT_UNKNEEL",0);

	AI:CreateGoalPipe("kneeling_right_attack");
	AI:PushGoal("kneeling_right_attack","firecmd",0,1);
	AI:PushGoal("kneeling_right_attack","strafe",0,1);
	AI:PushGoal("kneeling_right_attack","timeout",1,0.5,1);
	AI:PushGoal("kneeling_right_attack","strafe",0,0);
	AI:PushGoal("kneeling_right_attack","timeout",1,0.5);
	AI:PushGoal("kneeling_right_attack","signal",0,1,"DEFAULT_GO_KNEEL",0);
	AI:PushGoal("kneeling_right_attack","timeout",1,2,4);
	AI:PushGoal("kneeling_right_attack","signal",0,1,"DEFAULT_UNKNEEL",0);


	-------------------
	----
	---- SCOUT
	----
	--------------------

	AI:CreateGoalPipe("scout_find_threat");
	AI:PushGoal("scout_find_threat","timeout",1,1,2);
	AI:PushGoal("scout_find_threat","take_cover");

	AI:CreateGoalPipe("scout_threatening_sound");
	AI:PushGoal("scout_threatening_sound","take_cover");
	AI:PushGoal("scout_threatening_sound","setup_combat");
	AI:PushGoal("scout_threatening_sound","timeout",0,999);	 -- do the following bit forever (f.a. intents&purposes)
	AI:PushGoal("scout_threatening_sound","hide",1,15,HM_LEFTMOST_FROM_TARGET);
	AI:PushGoal("scout_threatening_sound","timeout",1,0,1);
	AI:PushGoal("scout_threatening_sound","branch",1,-2,1);	-- hide left as much as you can
	AI:PushGoal("scout_threatening_sound","hide",1,10,HM_NEAREST_TO_TARGET);
	AI:PushGoal("scout_threatening_sound","timeout",1,0,1);
	AI:PushGoal("scout_threatening_sound","branch",1,-5,1);	-- then try going left again
	AI:PushGoal("scout_threatening_sound","hide",1,15,HM_RIGHTMOST_FROM_TARGET);
	AI:PushGoal("scout_threatening_sound","timeout",1,0,1);
	AI:PushGoal("scout_threatening_sound","branch",1,-2,1);	-- hide right as much as you can
	AI:PushGoal("scout_threatening_sound","hide",1,10,HM_NEAREST_TO_TARGET);
	AI:PushGoal("scout_threatening_sound","timeout",1,0,1);
	AI:PushGoal("scout_threatening_sound","branch",1,-5,1);	-- then try going left again
	AI:PushGoal("scout_threatening_sound","branch",1,-12);	-- all over again


	
	AI:CreateGoalPipe("scout_interesting_sound");
	AI:PushGoal("scout_interesting_sound","take_cover");
	AI:PushGoal("scout_interesting_sound","setup_stealth");
	AI:PushGoal("scout_interesting_sound","timeout",0,99);
	AI:PushGoal("scout_interesting_sound","lookat",1,-90,90);
	AI:PushGoal("scout_interesting_sound","timeout",1,0,1);
	AI:PushGoal("scout_interesting_sound","DropBeaconAt");
	AI:PushGoal("scout_interesting_sound","take_cover");
	AI:PushGoal("scout_interesting_sound","branch",0,-4);	 	-- lookaround for 2 sec


	AI:CreateGoalPipe("scout_hunt_beacon");
	AI:PushGoal("scout_hunt_beacon","locate",0,"beacon");
	AI:PushGoal("scout_hunt_beacon","acqtarget",0,"");
	AI:PushGoal("scout_hunt_beacon","scout_hunt_run");

	AI:CreateGoalPipe("scout_hunt_run");
	AI:PushGoal("scout_hunt_run","setup_combat");
	AI:PushGoal("scout_hunt_run","run",0,1);
	AI:PushGoal("scout_hunt_run","hide",1,15,HM_FRONTLEFTMOST_FROM_TARGET);
	AI:PushGoal("scout_hunt_run","branch",0,-1,1);
	AI:PushGoal("scout_hunt_run","hide",1,15,HM_FRONTRIGHTMOST_FROM_TARGET);
	AI:PushGoal("scout_hunt_run","approach",1,0.5);
	AI:PushGoal("scout_hunt_run","devalue",0);


	AI:CreateGoalPipe("scout_hunt");
	AI:PushGoal("scout_hunt","setup_crouch");
	AI:PushGoal("scout_hunt","hide",1,10,HM_NEAREST_TO_TARGET);
	AI:PushGoal("scout_hunt","timeout",1,0,1.5);
	AI:PushGoal("scout_hunt","hide",1,15,HM_FRONTLEFTMOST_FROM_TARGET);
	AI:PushGoal("scout_hunt","timeout",1,0,2);
	AI:PushGoal("scout_hunt","branch",0,-4,1);	
	AI:PushGoal("scout_hunt","hide",1,15,HM_FRONTRIGHTMOST_FROM_TARGET);
	AI:PushGoal("scout_hunt","timeout",1,0,1);
	AI:PushGoal("scout_hunt","branch",0,-7,1);	
	AI:PushGoal("scout_hunt","timeout",1,0,2);	
	AI:PushGoal("scout_hunt","approach",1,0.5);	
	AI:PushGoal("scout_hunt","devalue",0);		

	AI:CreateGoalPipe("scout_group_hunt");
	AI:PushGoal("scout_group_hunt","setup_crouch");
	AI:PushGoal("scout_group_hunt","locate",0,"beacon");
	AI:PushGoal("scout_group_hunt","acqtarget",0,"");
	AI:PushGoal("scout_group_hunt","firecmd",0,2);
	AI:PushGoal("scout_group_hunt","hide",1,10,HM_NEAREST_TO_TARGET);
	AI:PushGoal("scout_group_hunt","timeout",1,0,1.5);
	AI:PushGoal("scout_group_hunt","hide",1,15,HM_FRONTLEFTMOST_FROM_TARGET);
	AI:PushGoal("scout_group_hunt","timeout",1,0,2);
	AI:PushGoal("scout_group_hunt","branch",0,-4,1);	
	AI:PushGoal("scout_group_hunt","hide",1,15,HM_FRONTRIGHTMOST_FROM_TARGET);
	AI:PushGoal("scout_group_hunt","timeout",1,0,1);
	AI:PushGoal("scout_group_hunt","branch",0,-7,1);	
	AI:PushGoal("scout_group_hunt","timeout",1,0,2);	
	AI:PushGoal("scout_group_hunt","approach",1,0.5);	
	AI:PushGoal("scout_group_hunt","devalue",0);		


	AI:CreateGoalPipe("scout_tooclose_attack_beacon")
	AI:PushGoal("scout_tooclose_attack_beacon","DropBeaconAt",0);
	AI:PushGoal("scout_tooclose_attack_beacon","scout_tooclose_attack",0);

	AI:CreateGoalPipe("scout_wait_and_hunt");
	AI:PushGoal("scout_wait_and_hunt","timeout",1,2,5);
	AI:PushGoal("scout_wait_and_hunt","signal",0,1,"START_HUNTING",0);

	AI:CreateGoalPipe("scout_tooclose_attack");
	AI:PushGoal("scout_tooclose_attack","firecmd",0,1);
	AI:PushGoal("scout_tooclose_attack","request_cover");
	AI:PushGoal("scout_tooclose_attack","run",0,1);
	AI:PushGoal("scout_tooclose_attack","bodypos",0,0);
	AI:PushGoal("scout_tooclose_attack","firecmd",0,0);
	AI:PushGoal("scout_tooclose_attack","hide",1,10,HM_FARTHEST_FROM_TARGET,1);
	AI:PushGoal("scout_tooclose_attack","firecmd",0,1);
--	AI:PushGoal("scout_tooclose_attack","hide",1,5,HM_NEAREST);
	AI:PushGoal("scout_tooclose_attack","run",0,0);
	AI:PushGoal("scout_tooclose_attack","reload");
	AI:PushGoal("scout_tooclose_attack","signal",0,1,"SCOUT_NORMALATTACK",0);
	
	AI:CreateGoalPipe("scout_firesome");
	AI:PushGoal("scout_firesome","firecmd",0,1);
	AI:PushGoal("scout_firesome","timeout",1,1);
	AI:PushGoal("scout_firesome","minimize_exposure");
	AI:PushGoal("scout_firesome","reload");
	AI:PushGoal("scout_firesome","signal",0,1,"SCOUT_NORMALATTACK",0);

	AI:CreateGoalPipe("scout_comeout");
	AI:PushGoal("scout_comeout","firecmd",0,1);
	AI:PushGoal("scout_comeout","approach",1,0.9);
	AI:PushGoal("scout_comeout","signal",0,1,"SCOUT_NORMALATTACK",0);

	AI:CreateGoalPipe("scout_quickhide");
	AI:PushGoal("scout_quickhide","hide",1,10,HM_NEAREST);
	AI:PushGoal("scout_quickhide","timeout",1,0.5);

	AI:CreateGoalPipe("scout_cover_NOW");
	AI:PushGoal("scout_cover_NOW","firecmd",0,1);
	AI:PushGoal("scout_cover_NOW","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("scout_cover_NOW","run",0,1);
	AI:PushGoal("scout_cover_NOW","hide",1,10,HM_NEAREST);
	AI:PushGoal("scout_cover_NOW","signal",1,1,"SCOUT_NORMALATTACK",0);

	AI:CreateGoalPipe("scout_attack_far");
	AI:PushGoal("scout_attack_far","bodypos",0,0);
	AI:PushGoal("scout_attack_far","firecmd",0,1);
	AI:PushGoal("scout_attack_far","run",0,1);
	AI:PushGoal("scout_attack_far","hide",1,10,HM_LEFTMOST_FROM_TARGET);
	AI:PushGoal("scout_attack_far","timeout",1,0,1);

	AI:CreateGoalPipe("scout_attack_left");
	AI:PushGoal("scout_attack_left","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("scout_attack_left","firecmd",0,1);
	AI:PushGoal("scout_attack_left","run",0,1);
	AI:PushGoal("scout_attack_left","hide",1,20,HM_FRONTLEFTMOST_FROM_TARGET);
	AI:PushGoal("scout_attack_left","timeout",1,0,1);

	AI:CreateGoalPipe("red_scout_attack");
	AI:PushGoal("red_scout_attack","locate",0,"beacon");
	AI:PushGoal("red_scout_attack","acqtarget",0,"");
	AI:PushGoal("red_scout_attack","scout_attack_left");
	AI:PushGoal("red_scout_attack","signal",1,1,"RED_IN_POSITION",SIGNALFILTER_SUPERGROUP);

	AI:CreateGoalPipe("scout_attack_right");
	AI:PushGoal("scout_attack_right","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("scout_attack_right","firecmd",0,1);
	AI:PushGoal("scout_attack_right","run",0,1);
	AI:PushGoal("scout_attack_right","hide",1,20,HM_FRONTRIGHTMOST_FROM_TARGET);
	AI:PushGoal("scout_attack_right","timeout",1,0,1);

	AI:CreateGoalPipe("black_scout_attack");
	AI:PushGoal("black_scout_attack","locate",0,"beacon");
	AI:PushGoal("black_scout_attack","acqtarget",0,"");
	AI:PushGoal("black_scout_attack","scout_attack_right");
	AI:PushGoal("black_scout_attack","signal",1,1,"BLACK_IN_POSITION",SIGNALFILTER_SUPERGROUP);

	
	AI:CreateGoalPipe("scout_approach");
	AI:PushGoal("scout_approach","bodypos",0,1);
	AI:PushGoal("scout_approach","run",0,1)
	AI:PushGoal("scout_approach","hide",1,10,HM_NEAREST_TO_TARGET);
	AI:PushGoal("scout_approach","timeout",1,0,2);
	AI:PushGoal("scout_approach","branch",0,-2,1);	
	-- try to get closer as long as there is cover to advance
	AI:PushGoal("scout_approach","signal",0,1,"SCOUT_HIDE_LEFT_OR_RIGHT",0);	
	AI:PushGoal("scout_approach","timeout",1,0,2);
	AI:PushGoal("scout_approach","signal",0,1,"SCOUT_HIDE_LEFT_OR_RIGHT",0);	
	AI:PushGoal("scout_approach","timeout",1,0,2);
	AI:PushGoal("scout_approach","branch",0,-7,1);	-- if you succeeded moving left, now try moving closer again
	-- if you get here, it means that you cannot move with cover anywhere
	AI:PushGoal("scout_approach","timeout",1,1,3);	-- think about it some time
	--AI:PushGoal("scout_approach","approach",1,0.5);	-- halve the distance to your target
	AI:PushGoal("scout_approach","signal",0,1,"ATTACK_ENEMY",0);
	
	AI:CreateGoalPipe("scout_aggresive_investigate");
	AI:PushGoal("scout_aggresive_investigate","firecmd",0,0)
	AI:PushGoal("scout_aggresive_investigate","bodypos",0,1)
	AI:PushGoal("scout_aggresive_investigate","run",0,0)
	AI:PushGoal("scout_aggresive_investigate","timeout",1,0.5)
	AI:PushGoal("scout_aggresive_investigate","hide",1,10,HM_NEAREST_TO_TARGET)

	AI:CreateGoalPipe("scout_scramble_beacon");
	AI:PushGoal("scout_scramble_beacon","DropBeaconAt",0);
	AI:PushGoal("scout_scramble_beacon","scout_scramble",0);

	AI:CreateGoalPipe("scout_scramble");
	AI:PushGoal("scout_scramble","minimize_exposure");
	AI:PushGoal("scout_scramble","reload");
	AI:PushGoal("scout_scramble","signal",0,1,"SCOUT_NORMALATTACK",0);

	AI:CreateGoalPipe("scout_attack");
	--AI:PushGoal("scout_attack","firecmd",0,1);
	AI:PushGoal("scout_attack","signal",0,1,"fire_or_not",0);
	AI:PushGoal("scout_attack","bodypos",0,1);
	AI:PushGoal("scout_attack","reload");
	AI:PushGoal("scout_attack","approach",1,0.8);
	AI:PushGoal("scout_attack","timeout",1,30);


	AI:CreateGoalPipe("scout_form");
	AI:PushGoal("scout_form","locate",0,"formation");
	AI:PushGoal("scout_form","ignoreall",0,1);
	AI:PushGoal("scout_form","acqtarget",0,"");
	AI:PushGoal("scout_form","run",0,1);
	AI:PushGoal("scout_form","approach",1,2);
	AI:PushGoal("scout_form","ignoreall",0,0);


	-------------------
	----
	---- COVER
	----
	--------------------

	AI:CreateGoalPipe("dont_shoot");
	AI:PushGoal("dont_shoot","firecmd",0,0);
	AI:PushGoal("dont_shoot","timeout",1,0,0.5);
	AI:PushGoal("dont_shoot","firecmd",0,1);

	
	AI:CreateGoalPipe("cover_look_closer");				-- USED
	AI:PushGoal("cover_look_closer","timeout",1,0.5,1.5);
	AI:PushGoal("cover_look_closer","approach",1,0.5);
	AI:PushGoal("cover_look_closer","lookat",1,0,-90);
	AI:PushGoal("cover_look_closer","timeout",1,0.5);
	AI:PushGoal("cover_look_closer","lookat",1,0,90);
	


	AI:CreateGoalPipe("cover_wait_a_sec");
	AI:PushGoal("cover_wait_a_sec","timeout",1,0.5,1.5);
	AI:PushGoal("cover_wait_a_sec","signal",0,1,"OnNoHidingPlace",0); -- fake make him attack close
	
	AI:CreateGoalPipe("cover_grenade_run_away");
	AI:PushGoal("cover_grenade_run_away","firecmd",0,0);
	AI:PushGoal("cover_grenade_run_away","signal",0,1,"IM_RUNNING_AWAY",0);
	AI:PushGoal("cover_grenade_run_away","bodypos",0,0);
	AI:PushGoal("cover_grenade_run_away","run",0,1);
	AI:PushGoal("cover_grenade_run_away","backoff",1,8);
	AI:PushGoal("cover_grenade_run_away","devalue",1);
	AI:PushGoal("cover_grenade_run_away","clear",0);

	AI:CreateGoalPipe("cover_scramble_beacon");
	AI:PushGoal("cover_scramble_beacon","DropBeaconAt",0);
	AI:PushGoal("cover_scramble_beacon","cover_scramble",0);
	
	AI:CreateGoalPipe("cover_scramble");
	AI:PushGoal("cover_scramble","setup_combat");
	AI:PushGoal("cover_scramble","timeout",1,0.3);
	AI:PushGoal("cover_scramble","firecmd",0,1);
	AI:PushGoal("cover_scramble","hide",1,10,HM_NEAREST);
	AI:PushGoal("cover_scramble","timeout",1,0,1);
	AI:PushGoal("cover_scramble","signal",0,1,"COVER_NORMALATTACK",0);

	AI:CreateGoalPipe("cover_pindown");
	AI:PushGoal("cover_pindown","run",0,1);
	AI:PushGoal("cover_pindown","bodypos",0,0);
	AI:PushGoal("cover_pindown","firecmd",0,1);
	AI:PushGoal("cover_pindown","hide",1,10,HM_NEAREST_TO_TARGET);
	AI:PushGoal("cover_pindown","branch",0,-1,1);


	AI:CreateGoalPipe("cover_close_wrapper");
	AI:PushGoal("cover_close_wrapper","signal",0,1,"COVER_NORMALATTACK");

	AI:CreateGoalPipe("cover_crouchleft");
	AI:PushGoal("cover_crouchleft","firecmd",0,1);
	AI:PushGoal("cover_crouchleft","bodypos",0,1);
	AI:PushGoal("cover_crouchleft","strafe",0,-1);
	AI:PushGoal("cover_crouchleft","timeout",1,0.5,1);
	AI:PushGoal("cover_crouchleft","strafe",0,0);

	AI:CreateGoalPipe("cover_crouchright");
	AI:PushGoal("cover_crouchright","firecmd",0,1);
	AI:PushGoal("cover_crouchright","bodypos",0,1);
	AI:PushGoal("cover_crouchright","strafe",0,1);
	AI:PushGoal("cover_crouchright","timeout",1,0.5,1);
	AI:PushGoal("cover_crouchright","strafe",0,0);


	AI:CreateGoalPipe("cover_step_pindown");
	AI:PushGoal("cover_step_pindown","firecmd",0,0);
	AI:PushGoal("cover_step_pindown","run",0,1);
	AI:PushGoal("cover_step_pindown","hide",1,10,HM_NEAREST_TO_TARGET,1);

	AI:CreateGoalPipe("cover_rollLeft");
	AI:PushGoal("cover_rollLeft","firecmd",0,0);
	AI:PushGoal("cover_rollLeft","strafe",0,1);
	AI:PushGoal("cover_rollLeft","signal",0,1,"SHARED_PLAYLEFTROLL");
	AI:PushGoal("cover_rollLeft","timeout",1,1);
	AI:PushGoal("cover_rollLeft","strafe",0,0);
	AI:PushGoal("cover_rollLeft","firecmd",0,1);
	AI:PushGoal("cover_rollLeft","timeout",1,60);

	AI:CreateGoalPipe("cover_rollRight");
	AI:PushGoal("cover_rollRight","firecmd",0,0);
	AI:PushGoal("cover_rollRight","strafe",0,-1);
	AI:PushGoal("cover_rollRight","signal",0,1,"SHARED_PLAYRIGHTROLL");
	AI:PushGoal("cover_rollRight","timeout",1,1);
	AI:PushGoal("cover_rollRight","strafe",0,0);
	AI:PushGoal("cover_rollRight","firecmd",0,1);
	AI:PushGoal("cover_rollRight","timeout",1,60);


	AI:CreateGoalPipe("cover_beacon_pindown");
	AI:PushGoal("cover_beacon_pindown","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("cover_beacon_pindown","locate",0,"beacon");
	AI:PushGoal("cover_beacon_pindown","pathfind",1,"");
	AI:PushGoal("cover_beacon_pindown","run",0,1);
	AI:PushGoal("cover_beacon_pindown","trace",1,1);
	AI:PushGoal("cover_beacon_pindown","timeout",1,0,1);
	AI:PushGoal("cover_beacon_pindown","signal",1,1,"FINISH_RUN_TO_FRIEND",0);


	AI:CreateGoalPipe("left_cover_step_pindown");
	AI:PushGoal("left_cover_step_pindown","locate",0,"beacon");
	AI:PushGoal("left_cover_step_pindown","acqtarget",0,"");
	AI:PushGoal("left_cover_step_pindown","firecmd",0,0);
	AI:PushGoal("left_cover_step_pindown","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("left_cover_step_pindown","run",0,1);
	AI:PushGoal("left_cover_step_pindown","hide",1,15,HM_FRONTLEFTMOST_FROM_TARGET,1);

	AI:CreateGoalPipe("right_cover_step_pindown");
	AI:PushGoal("right_cover_step_pindown","locate",0,"beacon");
	AI:PushGoal("right_cover_step_pindown","acqtarget",0,"");
	AI:PushGoal("right_cover_step_pindown","firecmd",0,0);
	AI:PushGoal("right_cover_step_pindown","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("right_cover_step_pindown","run",0,1);
	AI:PushGoal("right_cover_step_pindown","hide",1,15,HM_FRONTRIGHTMOST_FROM_TARGET,1);


	AI:CreateGoalPipe("forward_cover_step_pindown");
	AI:PushGoal("forward_cover_step_pindown","locate",0,"beacon");
	AI:PushGoal("forward_cover_step_pindown","acqtarget",0,"");
	AI:PushGoal("forward_cover_step_pindown","firecmd",0,0);
	AI:PushGoal("forward_cover_step_pindown","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("forward_cover_step_pindown","run",0,1);
	AI:PushGoal("forward_cover_step_pindown","hide",1,15,HM_NEAREST_TO_TARGET,1);
	



	AI:CreateGoalPipe("red_cover_pindown");
	AI:PushGoal("red_cover_pindown","signal",1,1,"ORDER_RECEIVED",SIGNALID_READIBILITY);
	AI:PushGoal("red_cover_pindown","left_cover_step_pindown");
	AI:PushGoal("red_cover_pindown","timeout",1,0,0.5);
	AI:PushGoal("red_cover_pindown","signal",0,1,"RED_IN_POSITION",SIGNALFILTER_SUPERGROUP);

	AI:CreateGoalPipe("black_cover_pindown");
	AI:PushGoal("black_cover_pindown","signal",1,1,"ORDER_RECEIVED",SIGNALID_READIBILITY);
	AI:PushGoal("black_cover_pindown","right_cover_step_pindown");
	AI:PushGoal("black_cover_pindown","timeout",1,0,0.5);
	AI:PushGoal("black_cover_pindown","signal",0,1,"BLACK_IN_POSITION",SIGNALFILTER_SUPERGROUP);



	AI:CreateGoalPipe("cover_strafeattack");
	AI:PushGoal("cover_strafeattack","firecmd",0,1);
	AI:PushGoal("cover_strafeattack","approach",1,0.5);
	AI:PushGoal("cover_strafeattack","approach",1,0.5);
	AI:PushGoal("cover_strafeattack","timeout",1,1);

	AI:CreateGoalPipe("cover_closeleft");
	AI:PushGoal("cover_closeleft","strafe",0,-1);
	AI:PushGoal("cover_closeleft","cover_strafeout");

	AI:CreateGoalPipe("cover_closeright");
	AI:PushGoal("cover_closeright","strafe",0,1);
	AI:PushGoal("cover_closeright","cover_strafeout");

	AI:CreateGoalPipe("cover_strafeout");
	AI:PushGoal("cover_strafeout","run",0,1);
	AI:PushGoal("cover_strafeout","timeout",1,0.2);
	AI:PushGoal("cover_strafeout","strafe",0,0);
	AI:PushGoal("cover_strafeout","firecmd",0,0);
	AI:PushGoal("cover_strafeout","timeout",1,1);
	AI:PushGoal("cover_strafeout","signal",0,1,"COVER_NORMALATTACK",0);


	AI:CreateGoalPipe("cover_coverfire");
	AI:PushGoal("cover_coverfire","timeout",1,0,0.3);
	AI:PushGoal("cover_coverfire","strafe",0,0);
	AI:PushGoal("cover_coverfire","firecmd",0,1);
	AI:PushGoal("cover_coverfire","timeout",1,2);

	AI:CreateGoalPipe("cover_coverleft");
	AI:PushGoal("cover_coverleft","strafe",0,1);
	AI:PushGoal("cover_coverleft","cover_coverfire");

	AI:CreateGoalPipe("cover_coverright");
	AI:PushGoal("cover_coverright","strafe",0,-1);
	AI:PushGoal("cover_coverright","cover_coverfire");

	AI:CreateGoalPipe("cover_provide_cover");
	AI:PushGoal("cover_provide_cover","firecmd",0,1);
	AI:PushGoal("cover_provide_cover","locate",0,"beacon");
	AI:PushGoal("cover_provide_cover","acqtarget",0,"");
	AI:PushGoal("cover_provide_cover","pathfind",1,"");
	AI:PushGoal("cover_provide_cover","trace",1,0,1);
	AI:PushGoal("cover_provide_cover","firecmd",0,2);
	AI:PushGoal("cover_provide_cover","timeout",1,10);
	
	
	AI:CreateGoalPipe("cover_searchlr");
	AI:PushGoal("cover_searchlr","bodypos",0,1);
	AI:PushGoal("cover_searchlr","firecmd",0,1);
	AI:PushGoal("cover_searchlr","strafe",0,1);
	AI:PushGoal("cover_searchlr","timeout",1,0.5);
	AI:PushGoal("cover_searchlr","strafe",0,0);
	AI:PushGoal("cover_searchlr","signal",0,1,"WaitForTarget",0);

	AI:CreateGoalPipe("acquire_beacon");
	AI:PushGoal("acquire_beacon","locate",0,"beacon");
	AI:PushGoal("acquire_beacon","acqtarget",0,"");

	AI:CreateGoalPipe("cover_hideform");
	AI:PushGoal("cover_hideform","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("cover_hideform","firecmd",0,1);
	AI:PushGoal("cover_hideform","locate",0,"formation");
	AI:PushGoal("cover_hideform","run",0,1);
	AI:PushGoal("cover_hideform","hide",1,10,HM_NEAREST_TO_LASTOPRESULT_NOSAME);
	AI:PushGoal("cover_hideform","reload");
	AI:PushGoal("cover_hideform","signal",0,1,"HOLD_POSITION");

	AI:CreateGoalPipe("cover_form_comeout");
	AI:PushGoal("cover_form_comeout","timeout",1,0,1);
	AI:PushGoal("cover_form_comeout","comeout");
	AI:PushGoal("cover_form_comeout","timeout",1,0,1);
	AI:PushGoal("cover_form_comeout","signal",0,1,"FORM_STOP_COVERING",0);

	AI:CreateGoalPipe("cover_red_form");
	AI:PushGoal("cover_red_form","setup_combat");
	AI:PushGoal("cover_red_form","firecmd",0,1);
	AI:PushGoal("cover_red_form","hide",1,20,HM_FRONTLEFTMOST_FROM_TARGET);

	AI:CreateGoalPipe("cover_black_form");
	AI:PushGoal("cover_black_form","setup_combat");
	AI:PushGoal("cover_black_form","firecmd",0,1);
	AI:PushGoal("cover_black_form","hide",1,20,HM_FRONTRIGHTMOST_FROM_TARGET);

	AI:CreateGoalPipe("cover_neutral_form");
	AI:PushGoal("cover_black_form","setup_combat");
	AI:PushGoal("cover_black_form","firecmd",0,1);
	AI:PushGoal("cover_black_form","hide",1,15,HM_NEAREST_TO_TARGET);

	AI:CreateGoalPipe("cover_form");
	AI:PushGoal("cover_form","locate",0,"beacon");
	AI:PushGoal("cover_form","acqtarget",0,"");
	AI:PushGoal("cover_form","lookat",1,-90,90);
	AI:PushGoal("cover_form","shoot_cover");

	AI:CreateGoalPipe("cover_form_wait");
	AI:PushGoal("cover_form_wait","hide",1,20,HM_FARTHEST_FROM_TARGET,1);
	AI:PushGoal("cover_form_wait","timeout",1,0,0.5);


	AI:CreateGoalPipe("cover_crouchfire");
	AI:PushGoal("cover_crouchfire","bodypos",0,1);
	AI:PushGoal("cover_crouchfire","firecmd",0,1);
	AI:PushGoal("cover_crouchfire","timeout",1,1);
	AI:PushGoal("cover_crouchfire","cover_hideform");

	---------------------
	--
	--  REAR GUARD
	-- 
	---------------------


	AI:CreateGoalPipe("rear_interested");
	AI:PushGoal("rear_interested","take_cover");
	AI:PushGoal("rear_interested","lookat",1,-90,90);
	AI:PushGoal("rear_interested","DropBeaconAt");


	AI:CreateGoalPipe("rear_target2close");
	AI:PushGoal("rear_target2close","request_cover");
	AI:PushGoal("rear_target2close","run",0,1);
	AI:PushGoal("rear_target2close","firecmd",0,1);
	AI:PushGoal("rear_target2close","bodypos",0,0);
	AI:PushGoal("rear_target2close","hide",1,10,HM_FARTHEST_FROM_TARGET);
	AI:PushGoal("rear_target2close","run",0,0);
	AI:PushGoal("rear_target2close","signal",0,1,"REAR_NORMALATTACK",0);

	AI:CreateGoalPipe("rear_comeout");
	AI:PushGoal("rear_comeout","firecmd",0,1);
	AI:PushGoal("rear_comeout","setup_combat");
	AI:PushGoal("rear_comeout","locate",0,"atttarget");
	AI:PushGoal("rear_comeout","pathfind",1,"");
	AI:PushGoal("rear_comeout","trace",1,0,1);
	AI:PushGoal("rear_comeout","clear",0);

	AI:CreateGoalPipe("rear_weaponAttack");
	AI:PushGoal("rear_weaponAttack","firecmd",0,1);
	AI:PushGoal("rear_weaponAttack","timeout",1,2,3);

	AI:CreateGoalPipe("rear_grenadeAttack");
	AI:PushGoal("rear_grenadeAttack","firecmd",0,0);
	AI:PushGoal("rear_grenadeAttack","throw_grenade");
	AI:PushGoal("rear_grenadeAttack","firecmd",0,1);
	AI:PushGoal("rear_grenadeAttack","timeout",1,2);


	AI:CreateGoalPipe("protect_spot");
	AI:PushGoal("protect_spot","firecmd",0,1);
	AI:PushGoal("protect_spot","run",0,1);
	AI:PushGoal("protect_spot","hide",1,10,HM_NEAREST_TO_LASTOPRESULT_NOSAME);
	AI:PushGoal("protect_spot","run",0,0);
	AI:PushGoal("protect_spot","firecmd",0,0);
	AI:PushGoal("protect_spot","signal",0,1,"REAR_NORMALATTACK",0);


	AI:CreateGoalPipe("rear_scramble");
	AI:PushGoal("rear_scramble","take_cover");
	AI:PushGoal("rear_scramble","signal",0,1,"REAR_NORMALATTACK");


	---------------
	--
	-- SNIPER 
	--
	----------------

	AI:CreateGoalPipe("sniper_potshot");
	AI:PushGoal("sniper_potshot","firecmd",0,0);
	AI:PushGoal("sniper_potshot","signal",1,1,"MAKE_ME_IGNORANT",0);
	AI:PushGoal("sniper_potshot","firecmd",0,0);
	AI:PushGoal("sniper_potshot","acqtarget",1,"");
	AI:PushGoal("sniper_potshot","timeout",1,0,0.5);
	AI:PushGoal("sniper_potshot","firecmd",0,2);
	AI:PushGoal("sniper_potshot","timeout",1,2,3);
	AI:PushGoal("sniper_potshot","firecmd",0,1);
	AI:PushGoal("sniper_potshot","signal",1,-1,"MAKE_ME_UNIGNORANT",0);
	AI:PushGoal("sniper_potshot","clear");


	AI:CreateGoalPipe("sniper_headdown");
	--AI:PushGoal("sniper_headdown","firecmd",0,0);
	--AI:PushGoal("sniper_headdown","bodypos",0,1);
	AI:PushGoal("sniper_headdown","timeout",1,1,5);
	AI:PushGoal("sniper_headdown","signal",0,1,"SNIPER_NORMALATTACK",0);

	AI:CreateGoalPipe("sniper_getdown");
	AI:PushGoal("sniper_getdown","firecmd",0,0);
	--AI:PushGoal("sniper_getdown","bodypos",0,1);
	AI:PushGoal("sniper_getdown","timeout",1,1);
	AI:PushGoal("sniper_getdown","bodypos",0,1);
	
	AI:CreateGoalPipe("sniper_shootfast");	
	AI:PushGoal("sniper_shootfast","firecmd",0,1);
	--AI:PushGoal("sniper_shootfast","bodypos",0,1);
	AI:PushGoal("sniper_shootfast","timeout",1,2);
	AI:PushGoal("sniper_shootfast","signal",0,1,"SNIPER_NORMALATTACK",0);

	AI:CreateGoalPipe("sniper_aimalittle");
	AI:PushGoal("sniper_aimalittle","firecmd",0,0);
	--AI:PushGoal("sniper_aimalittle","bodypos",0,1);
	AI:PushGoal("sniper_aimalittle","timeout",1,0,1);
	AI:PushGoal("sniper_aimalittle","firecmd",0,1);
	AI:PushGoal("sniper_aimalittle","timeout",1,4);
	AI:PushGoal("sniper_aimalittle","signal",0,1,"SNIPER_NORMALATTACK",0);


	AI:CreateGoalPipe("sniper_relocate_to");
	AI:PushGoal("sniper_relocate_to","firecmd",0,0);
	AI:PushGoal("sniper_relocate_to","ignoreall",0,1);
	AI:PushGoal("sniper_relocate_to","acqtarget",0,"");
	AI:PushGoal("sniper_relocate_to","approach",1,2);
	AI:PushGoal("sniper_relocate_to","lookat",1,0,0);
	AI:PushGoal("sniper_relocate_to","ignoreall",0,0);
	AI:PushGoal("sniper_relocate_to","signal",0,1,"SNIPER_NORMALATTACK",0);

	AI:CreateGoalPipe("sniper_movealittle_r");
	AI:PushGoal("sniper_movealittle_r","firecmd",0,0);
	AI:PushGoal("sniper_movealittle_r","strafe",0,1);
	AI:PushGoal("sniper_movealittle_r","timeout",1,0.5);
	AI:PushGoal("sniper_movealittle_r","strafe",0,0);
	AI:PushGoal("sniper_movealittle_r","signal",0,1,"SNIPER_NORMALATTACK",0);
	
	-----------------------
	--
	-- TEAM LEADER DEFENSE 1
	--
	------------------------

	AI:CreateGoalPipe("defend_point");
	AI:PushGoal("defend_point","form",0,"beacon");
	AI:PushGoal("defend_point","run",0,1);
	AI:PushGoal("defend_point","firecmd",0,1);
	AI:PushGoal("defend_point","hide",1,10,HM_NEAREST_TO_LASTOPRESULT_NOSAME);
	AI:PushGoal("defend_point","form",0,"test_attack");
	AI:PushGoal("defend_point","signal",1,1,"KEEP_FORMATION",SIGNALFILTER_SUPERGROUP);
	
	AI:CreateGoalPipe("defense_keepcovered");
	AI:PushGoal("defense_keepcovered","firecmd",0,1);
	AI:PushGoal("defense_keepcovered","locate",0,"beacon");
	AI:PushGoal("defense_keepcovered","acqtarget",0,"");
	AI:PushGoal("defense_keepcovered","locate",0,AIAnchor.AIANCHOR_PROTECT_THIS_POINT);
	AI:PushGoal("defense_keepcovered","hide",1,10,HM_NEAREST_TO_LASTOPRESULT_NOSAME);
	AI:PushGoal("defense_keepcovered","timeout",1,3,5);
	AI:PushGoal("defense_keepcovered","signal",1,1,"KEEP_FORMATION",SIGNALFILTER_SUPERGROUP);

	-----------------------
	--
	-- TEAM LEADER ATTACK 2
	--
	-------------------------

	AI:CreateGoalPipe("look_at_beacon");
	AI:PushGoal("look_at_beacon","locate",0,"beacon");
	AI:PushGoal("look_at_beacon","acqtarget",0,"");

	AI:CreateGoalPipe("leader_quickhide");
	AI:PushGoal("leader_quickhide","hide",1,10,HM_NEAREST);

	AI:CreateGoalPipe("offer_join_team");
	AI:PushGoal("offer_join_team","signal",1,1,"OFFER_JOIN_TEAM",SIGNALFILTER_SPECIESONLY);

	AI:CreateGoalPipe("oleader_investigate");
	AI:PushGoal("oleader_investigate","form",0,"woodwalk");
	AI:PushGoal("oleader_investigate","signal",0,1,"MOVE_IN_FORMATION",SIGNALFILTER_GROUPONLY);
	AI:PushGoal("oleader_investigate","run",0,1);
	AI:PushGoal("oleader_investigate","approach",1,0.5);
	AI:PushGoal("oleader_investigate","timeout",0,3,7);
	AI:PushGoal("oleader_investigate","approach",1,0.5);
	AI:PushGoal("oleader_investigate","lookat",1,-90,90);
	AI:PushGoal("oleader_investigate","branch",0,-2);

	AI:CreateGoalPipe("split_team");
	AI:PushGoal("split_team","setup_combat");
	AI:PushGoal("split_team","signal",1,1,"INIT_TEAM_COUNTERS",0);	-- you are finished
	AI:PushGoal("split_team","signal",1,1,"SELECT_RED",SIGNALFILTER_HALFOFGROUP);	-- order half of group to select red
	AI:PushGoal("split_team","signal",1,1,"FORM_RED",SIGNALFILTER_SUPERGROUP);	-- order red to fall into formation
	AI:PushGoal("split_team","signal",1,1,"LO_SPLIT_LEFT",SIGNALID_READIBILITY);	
--	AI:PushGoal("split_team","timeout",1,1,1.5);
	AI:PushGoal("split_team","signal",1,1,"SELECT_BLACK",SIGNALFILTER_SUPERGROUP);	-- order the rest to select black
	AI:PushGoal("split_team","signal",1,1,"FORM_BLACK",SIGNALFILTER_SUPERGROUP);	-- order red to fall into formation
	AI:PushGoal("split_team","signal",1,1,"LO_SPLIT_RIGHT",SIGNALID_READIBILITY);	
--	AI:PushGoal("split_team","timeout",1,1,1.5);
	AI:PushGoal("split_team","firecmd",0,1);
	AI:PushGoal("split_team","run",0,1);
	AI:PushGoal("split_team","take_cover");
	AI:PushGoal("split_team","DropBeaconAt");
	AI:PushGoal("split_team","signal",1,1,"START_ATTACK",0);	-- you are finished

	AI:CreateGoalPipe("coordinate_red_attack");
	AI:PushGoal("coordinate_red_attack","form",0,"beacon");	-- drop a beacon where target was seen last
	AI:PushGoal("coordinate_red_attack","signal",1,1,"LO_LEFT_ADVANCE",SIGNALID_READIBILITY);	
	AI:PushGoal("coordinate_red_attack","signal",1,1,"PHASE_RED_ATTACK",SIGNALFILTER_SUPERGROUP);	
	AI:PushGoal("coordinate_red_attack","signal",1,1,"BLACK_COVER",SIGNALFILTER_SUPERGROUP);	
	AI:PushGoal("coordinate_red_attack","shoot_cover");
	AI:PushGoal("coordinate_red_attack","signal",1,1,"RELAX",0);		

	AI:CreateGoalPipe("coordinate_black_attack");
	AI:PushGoal("coordinate_black_attack","form",0,"beacon");	-- drop a beacon where target was seen last
	AI:PushGoal("coordinate_black_attack","signal",1,1,"LO_RIGHT_ADVANCE",SIGNALID_READIBILITY);	
	AI:PushGoal("coordinate_black_attack","signal",1,1,"PHASE_BLACK_ATTACK",SIGNALFILTER_SUPERGROUP);	
	AI:PushGoal("coordinate_black_attack","signal",1,1,"RED_COVER",SIGNALFILTER_SUPERGROUP)
	AI:PushGoal("coordinate_black_attack","shoot_cover");	
	AI:PushGoal("coordinate_black_attack","signal",1,1,"RELAX",0);	-- hide yourself	

	AI:CreateGoalPipe("reset_attack");
	AI:PushGoal("reset_attack","form",0,"beacon");
	AI:PushGoal("reset_attack","signal",1,1,"START_ATTACK",0);

	AI:CreateGoalPipe("respond_to_sighting");
	AI:PushGoal("respond_to_sighting","forget",0);
	AI:PushGoal("respond_to_sighting","acqtarget",0,"");
	AI:PushGoal("respond_to_sighting","form",0,"beacon");

	AI:CreateGoalPipe("update_beacon");
	AI:PushGoal("update_beacon","form",0,"beacon");
	
	AI:CreateGoalPipe("re_split_team");
	AI:PushGoal("re_split_team","signal",1,1,"GROUP_MERGE",SIGNALFILTER_SUPERGROUP);
	AI:PushGoal("re_split_team","signal",1,1,"SELECT_RED",SIGNALFILTER_HALFOFGROUP);
	AI:PushGoal("re_split_team","signal",1,1,"SELECT_BLACK",SIGNALFILTER_SUPERGROUP);
	AI:PushGoal("re_split_team","reset_attack");

	AI:CreateGoalPipe("fire_minimize");
	AI:PushGoal("fire_minimize","firecmd",0,1);
	AI:PushGoal("fire_minimize","run",0,1);
	AI:PushGoal("fire_minimize","hide",1,20,HM_NEAREST);
	AI:PushGoal("fire_minimize","run",0,0);

	AI:CreateGoalPipe("surrender_fake");
	AI:PushGoal("surrender_fake","firecmd",0,0);
	AI:PushGoal("surrender_fake","run",0,0);
	AI:PushGoal("surrender_fake","locate",0,"formation");
	AI:PushGoal("surrender_fake","acqtarget",0,"");
	AI:PushGoal("surrender_fake","approach",0,6);
	AI:PushGoal("surrender_fake","signal",0,1,"PLAY_SURRENDER",0);
	AI:PushGoal("surrender_fake","timeout",1,0.5);
	AI:PushGoal("surrender_fake","branch",0,-2);
	AI:PushGoal("surrender_fake","firecmd",0,1);
	AI:PushGoal("surrender_fake","timeout",1,120);

	-----------------------
	--
	-- TEAM LEADER FAKE GROUP
	--
	-------------------------

	AI:CreateGoalPipe("fake_takeUpPositions");
	AI:PushGoal("fake_takeUpPositions","firecmd",1,1);
	AI:PushGoal("fake_takeUpPositions","signal",0,1,"LO_LEFT_ADVANCE",SIGNALID_READIBILITY);
	AI:PushGoal("fake_takeUpPositions","signal",0,1,"OnActivate",SIGNALFILTER_HALFOFGROUP);
	AI:PushGoal("fake_takeUpPositions","timeout",1,1);
	AI:PushGoal("fake_takeUpPositions","minimize_exposure");
	AI:PushGoal("fake_takeUpPositions","timeout",1,5);
	AI:PushGoal("fake_takeUpPositions","signal",0,1,"LO_RIGHT_ADVANCE",SIGNALID_READIBILITY);
	AI:PushGoal("fake_takeUpPositions","signal",0,1,"OnActivate",SIGNALFILTER_SUPERGROUP);
	AI:PushGoal("fake_takeUpPositions","signal",0,1,"MINIMIZE_YOURSELF",0);

	-- go to tag 
	AI:CreateGoalPipe("offer_join_team_to");
	AI:PushGoal("offer_join_team_to","signal",0,1,"JoinGroup",SIGNALFILTER_LASTOP);	
	AI:PushGoal("offer_join_team_to","timeout",1,0.5);
	AI:PushGoal("offer_join_team_to","signal",0,1,"wakeup",SIGNALFILTER_GROUPONLY);	
	AI:PushGoal("offer_join_team_to","signal",0,1,"HEADS_UP_GUYS",SIGNALFILTER_GROUPONLY);	

	---------------------------------------
	---
	--- CROWE PIPES
	---
	--------------------------------------

	AI:CreateGoalPipe("crowe_coordinating")
	--AI:PushGoal("crowe_coordinating","signal",1,1,"UNCONDITIONAL_JOIN",SIGNALFILTER_ANYONEINCOMM);
	AI:PushGoal("crowe_coordinating","run",0,1);
	AI:PushGoal("crowe_coordinating","firecmd",0,1);
	AI:PushGoal("crowe_coordinating","bodypos",0,BODYPOS_STAND);
	AI:PushGoal("crowe_coordinating","hide",1,30,HM_NEAREST);


	AI:CreateGoalPipe("cover_comeout");
	AI:PushGoal("cover_comeout","firecmd",0,1);
	AI:PushGoal("cover_comeout","approach",1,0.9);
	AI:PushGoal("cover_comeout","signal",1,1,"COVER_NORMALATTACK",0);

	System:Log("REUSABLE PIPES LOADED");


end





