
function PipeManager:OnInitSwat()
	System:Log("SWAT PIPES LOADED");
	
	


-- ______________________________________________________________________________________________________________________		
-- -------------------------------------------------- SWAT SCRIPTS ----------------------------------------------------
	
	
	-- interesting sound heard
	--come out after a while  and go to last operation target -----------------------
	AI:CreateGoalPipe("swat_huntLostPlayer");
	AI:PushGoal("swat_huntLostPlayer","form",0,"beacon");
	AI:PushGoal("swat_huntLostPlayer","bodypos",0,0);
	AI:PushGoal("swat_huntLostPlayer","timeout",1,2); 
	AI:PushGoal("swat_huntLostPlayer","locate",1,"beacon");
--	AI:PushGoal("swat_huntLostPlayer","locate",1,"player");
--	AI:PushGoal("swat_huntLostPlayer","lookat",1,-5,5);
	AI:PushGoal("swat_huntLostPlayer","run",1,1);
	AI:PushGoal("swat_huntLostPlayer","pathfind",1,"");
	AI:PushGoal("swat_huntLostPlayer","trace",1,1);
	AI:PushGoal("swat_huntLostPlayer","lookat",1,-10,10);
	AI:PushGoal("swat_huntLostPlayer","timeout",1,2); 
	AI:PushGoal("swat_huntLostPlayer","lookat",1,-90,90);
	AI:PushGoal("swat_huntLostPlayer","timeout",1,2); 
	AI:PushGoal("swat_huntLostPlayer","lookat",1,-180,180);
	AI:PushGoal("swat_huntLostPlayer","timeout",1,3); 
	AI:PushGoal("swat_huntLostPlayer","signal",0,1,"HERE_I_COME",0); 
	AI:PushGoal("swat_huntLostPlayer","swat_cease_investigation");
-- 	AI:PushGoal("swat_huntLostPlayer","signal",0,1,"swat_attack",0); -- start proper action there

	AI:CreateGoalPipe("swat_noHide");
	AI:PushGoal("swat_noHide","bodypos",0,1);
	AI:PushGoal("swat_noHide","firecmd",1,1); 
	AI:PushGoal("swat_noHide","timeout",1,1); 
--	AI:PushGoal("swat_noHide","locate",1,"player");
	AI:PushGoal("swat_noHide","pathfind",1,"");
	AI:PushGoal("swat_noHide","trace",0,1,1);
	AI:PushGoal("swat_noHide","lookat",1,-30,30);
--	AI:PushGoal("swat_noHide","approach",0,1);
	AI:PushGoal("swat_noHide","timeout",1,1); 
	AI:PushGoal("swat_noHide","signal",0,1,"OUT_HIDE",0); 
		
	-- attentive -----------------------
	AI:CreateGoalPipe("swat_attentive");
	AI:PushGoal("swat_attentive","bodypos",0,0);
	AI:PushGoal("swat_attentive","timeout",0,15,20); -- start branch
	AI:PushGoal("swat_attentive","lookat",1,-75,75);
	AI:PushGoal("swat_attentive","timeout",1,3,4);
	AI:PushGoal("swat_attentive","branch",1,-2);	-- end branch
	AI:PushGoal("swat_attentive","signal",0,1,"back_to",0); -- change behaviour back to idle
	AI:PushGoal("swat_attentive","signal",0,1,"GoOn",0); -- start proper action there
	
	-- investigate -----------------------		
	AI:CreateGoalPipe("swat_investigate");
	AI:PushGoal("swat_investigate","run",1,0);
	AI:PushGoal("swat_investigate","bodypos",1,5);
	AI:PushGoal("swat_investigate","timeout",1,0.5,0.75);
	AI:PushGoal("swat_investigate","locate",1,"beacon");
	AI:PushGoal("swat_investigate","pathfind",1,"");
	AI:PushGoal("swat_investigate","trace",1,1,1);
	AI:PushGoal("swat_investigate","timeout",1,2,3);
	AI:PushGoal("swat_investigate","lookat",1,35,55);
	AI:PushGoal("swat_investigate","timeout",1,0.2,0.3);
	AI:PushGoal("swat_investigate","lookat",1,-35,-55);
	AI:PushGoal("swat_investigate","timeout",1,2,3);
	AI:PushGoal("swat_investigate","signal",0,1,"Cease",0);
	
	-- cease -------------------------------------
	AI:CreateGoalPipe("swat_cease_investigation");
	AI:PushGoal("swat_cease_investigation","devalue",0);
	AI:PushGoal("swat_cease_investigation","signal",0,1,"target_lost_animation",0); -- play animation
	AI:PushGoal("swat_cease_investigation","timeout",1,2.5,3); 
	AI:PushGoal("swat_cease_investigation","lookat",1,-55,55);
	AI:PushGoal("swat_cease_investigation","timeout",1,3); 
	AI:PushGoal("swat_cease_investigation","bodypos",1,0);
	AI:PushGoal("swat_cease_investigation","timeout",1,1,2);
	AI:PushGoal("swat_cease_investigation","signal",0,1,"confused_animation",0); -- play animation
	AI:PushGoal("swat_cease_investigation","timeout",1,2,3);
	AI:PushGoal("swat_cease_investigation","signal",0,1,"back_to",0); -- change behaviour back to idle
	AI:PushGoal("swat_cease_investigation","signal",0,1,"GoOn",0);  -- start proper action there
	
	-- threatening sound heard
	-- disturbed -----------------------
	AI:CreateGoalPipe("swat_disturbed");
	AI:PushGoal("swat_disturbed","bodypos",0,5);
	AI:PushGoal("swat_disturbed","timeout",0,15,20); -- start branch
	AI:PushGoal("swat_disturbed","lookat",1,-120,120);
	AI:PushGoal("swat_disturbed","timeout",1,0.5,1);
	AI:PushGoal("swat_disturbed","branch",1,-2); -- end branch
	AI:PushGoal("swat_disturbed","timeout",1,4,6);
	AI:PushGoal("swat_disturbed","signal",0,1,"back_to",0); -- change behaviour back to idle
	AI:PushGoal("swat_disturbed","signal",0,1,"GoOn",0);  -- start proper action there
			
	-- threatened ----------------------------		
	AI:CreateGoalPipe("swat_approach_threat");
	AI:PushGoal("swat_approach_threat","bodypos",1,0);
	AI:PushGoal("swat_approach_threat","run",1,1);
	AI:PushGoal("swat_approach_threat","hide",1,10,HM_NEAREST);
	AI:PushGoal("swat_approach_threat","timeout",1,0.5,1);
	AI:PushGoal("swat_approach_threat","run",0,0);
	AI:PushGoal("swat_approach_threat","locate",1,"beacon");
	AI:PushGoal("swat_approach_threat","pathfind",1,"");
	AI:PushGoal("swat_approach_threat","trace",1,1,1);
	AI:PushGoal("swat_approach_threat","bodypos",1,5);
	AI:PushGoal("swat_approach_threat","trace",1,0,1);
	AI:PushGoal("swat_approach_threat","timeout",1,1);
	AI:PushGoal("swat_approach_threat","signal",0,1,"Cease",0);
	
	-- cease --------------------------------
	AI:CreateGoalPipe("swat_cease_approach");
	AI:PushGoal("swat_cease_approach","devalue",0);
	AI:PushGoal("swat_cease_approach","signal",0,1,"target_lost_animation",0); -- play animation
	AI:PushGoal("swat_cease_approach","timeout",1,3,3.5); 
	AI:PushGoal("swat_cease_approach","lookat",1,-65,65);
	AI:PushGoal("swat_cease_approach","timeout",1,3);
	AI:PushGoal("swat_cease_approach","bodypos",1,0);
	AI:PushGoal("swat_cease_approach","timeout",1,1,2);
	AI:PushGoal("swat_cease_approach","signal",0,1,"confused_animation",0); -- play animation
	AI:PushGoal("swat_cease_approach","timeout",1,2,3);
	AI:PushGoal("swat_cease_approach","signal",0,1,"back_to",0); -- change behaviour back to idle
	AI:PushGoal("swat_cease_approach","signal",0,1,"GoOn",0); -- start proper action there
	
	----------------------------------- BATTLE MODE -------------------------------------------------------------	
	
	-- go for cover
	AI:CreateGoalPipe("swat_cover");
	AI:PushGoal("swat_cover","locate",0,"beacon");
	AI:PushGoal("swat_cover","acqtarget",0,"");
	AI:PushGoal("swat_cover","bodypos",1,0);
	AI:PushGoal("swat_cover","run",1,1);
	AI:PushGoal("swat_cover","hide",1,10,HM_NEAREST);
	AI:PushGoal("swat_cover","devalue",0);
	AI:PushGoal("swat_cover","bodypos",1,1);
	AI:PushGoal("swat_cover","timeout",1,0.25,0.5);
	AI:PushGoal("swat_cover","timeout",0,10,12); -- start branch
	AI:PushGoal("swat_cover","lookat",1,50,-50);
	AI:PushGoal("swat_cover","timeout",1,1,1.5);
	AI:PushGoal("swat_cover","branch",1,-2); -- end branch
	AI:PushGoal("swat_cover","locate",0,"beacon");
	AI:PushGoal("swat_cover","acqtarget",0,"");
	AI:PushGoal("swat_cover","swat_approach_threat");
	
	-- SWAT advancing
	AI:CreateGoalPipe("swat_advance");
	AI:PushGoal("swat_advance","signal",0,1,"SUSPRESSION_FIRE",SIGNALFILTER_GROUPONLY);
	AI:PushGoal("swat_advance","run",1,1);
	AI:PushGoal("swat_advance","ignoreall",1,1);
	AI:PushGoal("swat_advance","hide",0,20,HM_NEAREST_TO_TARGET,1);
	AI:PushGoal("swat_advance","bodypos",1,0);
	AI:PushGoal("swat_advance","branch",1,-1);
	AI:PushGoal("swat_advance","ignoreall",1,0);
	AI:PushGoal("swat_advance","bodypos",1,1);
	AI:PushGoal("swat_advance","signal",0,1,"SELECT_GROUPREADY",SIGNALFILTER_GROUPONLY);
	AI:PushGoal("swat_advance","timeout",1,0.3);
	AI:PushGoal("swat_advance","signal",0,1,"signal_inposition",0);
	AI:PushGoal("swat_advance","signal",0,1,"NEXT_ADVANCE",SIGNALFILTER_GROUPONLY);
	AI:PushGoal("swat_advance","timeout",1,2);
	AI:PushGoal("swat_advance","signal",0,1,"NO_RESPOND",SIGNALFILTER_GROUPONLY);
	
	-- SWAT single advancing
	AI:CreateGoalPipe("swat_singleadvance");
	AI:PushGoal("swat_singleadvance","run",1,1);
	AI:PushGoal("swat_singleadvance","ignoreall",1,1);
	AI:PushGoal("swat_singleadvance","hide",0,20,HM_NEAREST_TO_TARGET,1);
	AI:PushGoal("swat_singleadvance","bodypos",1,0);
	AI:PushGoal("swat_singleadvance","branch",1,-1);
	AI:PushGoal("swat_singleadvance","ignoreall",1,0);
	AI:PushGoal("swat_singleadvance","bodypos",1,1);
	AI:PushGoal("swat_singleadvance","timeout",1,2,3);
				
	-- SWAT delayed advance signal
	AI:CreateGoalPipe("swat_signal_NEXT_ADVANCE");
	AI:PushGoal("swat_signal_NEXT_ADVANCE","timeout",1,0.5);
	AI:PushGoal("swat_signal_NEXT_ADVANCE","signal",0,1,"NEXT_ADVANCE",SIGNALFILTER_GROUPONLY);
	
	-- SWAT just wait
	AI:CreateGoalPipe("swat_groupwait");
	AI:PushGoal("swat_groupwait","firecmd",1,0);
	AI:PushGoal("swat_groupwait","run",1,1);
	AI:PushGoal("swat_groupwait","hide",1,10,HM_NEAREST);
	AI:PushGoal("swat_groupwait","bodypos",1,1);
	AI:PushGoal("swat_groupwait","timeout",1,0.5,1);
	
	-- SWAT support suspression fire
	AI:CreateGoalPipe("swat_suspress");
	AI:PushGoal("swat_suspress","timeout",1,0.3,0.5);
	AI:PushGoal("swat_suspress","bodypos",0,0);
	AI:PushGoal("swat_suspress","firecmd",1,1);
	AI:PushGoal("swat_suspress","timeout",1,1,1.5);
	AI:PushGoal("swat_suspress","firecmd",1,0);
	AI:PushGoal("swat_suspress","bodypos",1,1);
	
	-- SWAT stay in cover
	AI:CreateGoalPipe("swat_grouphide");
	AI:PushGoal("swat_grouphide","firecmd",1,0);
	AI:PushGoal("swat_grouphide","hide",1,5,HM_NEAREST);
	AI:PushGoal("swat_grouphide","bodypos",1,1);
	AI:PushGoal("swat_grouphide","timeout",1,0.5,1);
		
	-- SWAT trace sender position
	AI:CreateGoalPipe("swat_trace_sender");
	AI:PushGoal("swat_trace_sender","pathfind",1,"");
	AI:PushGoal("swat_trace_sender","run",1,1);
	AI:PushGoal("swat_trace_sender","ignoreall",1,1);
	AI:PushGoal("swat_trace_sender","trace",0,1);
	AI:PushGoal("swat_trace_sender","bodypos",1,0);
	AI:PushGoal("swat_trace_sender","branch",1,-1);
	AI:PushGoal("swat_trace_sender","ignoreall",1,0);
	--AI:PushGoal("swat_trace_sender","bodypos",1,1);
	--AI:PushGoal("swat_trace_sender","timeout",1,0.5,0.85);
	AI:PushGoal("swat_trace_sender","signal",0,1,"SUSPRESSION_FIRE",SIGNALFILTER_GROUPONLY);
	AI:PushGoal("swat_trace_sender","run",1,1);
	AI:PushGoal("swat_trace_sender","ignoreall",1,1);
	AI:PushGoal("swat_trace_sender","hide",0,20,HM_NEAREST_TO_TARGET,1);
	AI:PushGoal("swat_trace_sender","timeout",1,0.2);
	AI:PushGoal("swat_trace_sender","bodypos",1,0);
	AI:PushGoal("swat_trace_sender","branch",1,-2);
	AI:PushGoal("swat_trace_sender","ignoreall",1,0);
	AI:PushGoal("swat_trace_sender","bodypos",1,1);
	AI:PushGoal("swat_trace_sender","signal",0,1,"SELECT_GROUPREADY",SIGNALFILTER_GROUPONLY);
	AI:PushGoal("swat_trace_sender","timeout",1,0.3);
	AI:PushGoal("swat_trace_sender","signal",0,1,"signal_inposition",0);
	AI:PushGoal("swat_trace_sender","signal",0,1,"NEXT_ADVANCE",SIGNALFILTER_GROUPONLY);
	AI:PushGoal("swat_trace_sender","timeout",1,2);
	AI:PushGoal("swat_trace_sender","signal",0,1,"NO_RESPOND",SIGNALFILTER_GROUPONLY);
	

	-- ADVANCE MODE	
	
	
	AI:CreateGoalPipe("swat_attack_advance");
	AI:PushGoal("swat_attack_advance","run",1,1);
	AI:PushGoal("swat_attack_advance","ignoreall",1,1);
	AI:PushGoal("swat_attack_advance","hide",0,20,HM_NEAREST_TO_TARGET,1);
	AI:PushGoal("swat_attack_advance","bodypos",1,0);
	AI:PushGoal("swat_attack_advance","branch",1,-1);
	AI:PushGoal("swat_attack_advance","ignoreall",1,0);
	AI:PushGoal("swat_attack_advance","bodypos",1,1);
	AI:PushGoal("swat_attack_advance","timeout",1,2,3);
	AI:PushGoal("swat_attack_advance","signal",0,1,"swat_attack",0);
	
	-- go for cover
	AI:CreateGoalPipe("swat_goforcover");
	AI:PushGoal("swat_goforcover","bodypos",1,0);
	AI:PushGoal("swat_goforcover","run",1,1);
	AI:PushGoal("swat_goforcover","hide",1,10,HM_NEAREST);
	AI:PushGoal("swat_goforcover","bodypos",1,1);
	AI:PushGoal("swat_goforcover","timeout",1,1.5,3);
	
	AI:CreateGoalPipe("swat_coverattack");
	AI:PushGoal("swat_coverattack","run",1,1);
	AI:PushGoal("swat_coverattack","firecmd",0,0);
	AI:PushGoal("swat_coverattack","hide",1,10,HM_NEAREST);
	AI:PushGoal("swat_coverattack","signal",0,1,"swat_attack",0);
	
	AI:CreateGoalPipe("swat_coverattack_nearest");
	AI:PushGoal("swat_coverattack_nearest","bodypos",1,0);
	AI:PushGoal("swat_coverattack_nearest","run",1,1);
	AI:PushGoal("swat_coverattack_nearest","firecmd",0,0);
	AI:PushGoal("swat_coverattack_nearest","hide",1,7,HM_NEAREST);
	AI:PushGoal("swat_coverattack_nearest","bodypos",1,1);
	AI:PushGoal("swat_coverattack_nearest","timeout",1,1,2);
	AI:PushGoal("swat_coverattack_nearest","signal",0,1,"swat_attack",0);
		
	-- start attack sequence	
	AI:CreateGoalPipe("swat_startattack");
	AI:PushGoal("swat_startattack","signal",0,1,"swat_attack",0);
	AI:PushGoal("swat_startattack","timeout",1,1);
		
	-- comeout 
	AI:CreateGoalPipe("swat_comeout");
	AI:PushGoal("swat_comeout","run",0,1);
	AI:PushGoal("swat_comeout","bodypos",0,0);
	AI:PushGoal("swat_comeout","approach",1,0.9);
	AI:PushGoal("swat_comeout","firecmd",0,1);
	AI:PushGoal("swat_comeout","timeout",1,0.7,1.3);
	AI:PushGoal("swat_comeout","firecmd",0,0);
	AI:PushGoal("swat_comeout","swat_coverattack_nearest");
	
	-- left cover
	AI:CreateGoalPipe("swat_takeleftcover");
	AI:PushGoal("swat_takeleftcover","bodypos",1,0);
	AI:PushGoal("swat_takeleftcover","run",1,1);
	AI:PushGoal("swat_takeleftcover","hide",1,10,HM_LEFTMOST_FROM_TARGET);
	AI:PushGoal("swat_takeleftcover","approach",1,0.9);
	AI:PushGoal("swat_takeleftcover","firecmd",0,1);
	AI:PushGoal("swat_takeleftcover","timeout",1,0.7,1.3);
	AI:PushGoal("swat_takeleftcover","hide",1,5,HM_NEAREST);
	AI:PushGoal("swat_takeleftcover","bodypos",1,1);
	AI:PushGoal("swat_takeleftcover","timeout",1,0.7,1.3);
	AI:PushGoal("swat_takeleftcover","signal",0,1,"swat_attack",0);
	
	-- right cover
	AI:CreateGoalPipe("swat_takerightcover");
	AI:PushGoal("swat_takerightcover","bodypos",1,0);
	AI:PushGoal("swat_takerightcover","run",1,1);
	AI:PushGoal("swat_takerightcover","hide",1,10,HM_RIGHTMOST_FROM_TARGET);
	AI:PushGoal("swat_takerightcover","approach",1,0.9);
	AI:PushGoal("swat_takerightcover","firecmd",0,1);
	AI:PushGoal("swat_takerightcover","timeout",1,0.7,1.3);
	AI:PushGoal("swat_takerightcover","hide",1,5,HM_NEAREST);
	AI:PushGoal("swat_takerightcover","bodypos",1,1);
	AI:PushGoal("swat_takerightcover","timeout",1,0.7,1.3);
	AI:PushGoal("swat_takerightcover","signal",0,1,"swat_attack",0);
	
	----------------------------------------------------
	-- for combat manager
	
	-- swat roll left
	AI:CreateGoalPipe("swat_comeout_rollleft");
	AI:PushGoal("swat_comeout_rollleft","firecmd",1,0);
	AI:PushGoal("swat_comeout_rollleft","bodypos",1,0);
	AI:PushGoal("swat_comeout_rollleft","run",1,0);
	AI:PushGoal("swat_comeout_rollleft","Trace_Anchor");
	AI:PushGoal("swat_comeout_rollleft","strafe",0,1);
	AI:PushGoal("swat_comeout_rollleft","signal",0,1,"SHARED_PLAYLEFTROLL");
	AI:PushGoal("swat_comeout_rollleft","timeout",1,0.2);
	AI:PushGoal("swat_comeout_rollleft","strafe",0,0);
	AI:PushGoal("swat_comeout_rollleft","firecmd",1,1);
	AI:PushGoal("swat_comeout_rollleft","timeout",1,1.5,2);
	AI:PushGoal("swat_comeout_rollleft","firecmd",1,0);
	AI:PushGoal("swat_comeout_rollleft","hide",1,5,HM_NEAREST);
	AI:PushGoal("swat_comeout_rollleft","timeout",1,1,2);
	AI:PushGoal("swat_comeout_rollleft","signal",0,1,"swat_attack",0);
	
	
	-- swat roll right
	AI:CreateGoalPipe("swat_comeout_rollright");
	AI:PushGoal("swat_comeout_rollright","firecmd",1,0);
	AI:PushGoal("swat_comeout_rollright","bodypos",1,0);
	AI:PushGoal("swat_comeout_rollright","run",1,0);
	AI:PushGoal("swat_comeout_rollright","Trace_Anchor");
	AI:PushGoal("swat_comeout_rollright","strafe",0,-1);
	AI:PushGoal("swat_comeout_rollright","signal",0,1,"SHARED_PLAYRIGHTROLL");
	AI:PushGoal("swat_comeout_rollright","timeout",1,0.2);
	AI:PushGoal("swat_comeout_rollright","strafe",0,0);
	AI:PushGoal("swat_comeout_rollright","firecmd",1,1);
	AI:PushGoal("swat_comeout_rollright","timeout",1,1.5,2);
	AI:PushGoal("swat_comeout_rollright","firecmd",1,0);
	AI:PushGoal("swat_comeout_rollright","hide",1,5,HM_NEAREST);
	AI:PushGoal("swat_comeout_rollright","timeout",1,1,2);
	AI:PushGoal("swat_comeout_rollright","signal",0,1,"swat_attack",0);
	
	-- swat comeout left
	AI:CreateGoalPipe("swat_comeout_left");
	AI:PushGoal("swat_comeout_right","firecmd",1,0);
	AI:PushGoal("swat_comeout_left","bodypos",1,0);
	AI:PushGoal("swat_comeout_left","run",1,0);
	AI:PushGoal("swat_comeout_left","Trace_Anchor");
--	AI:PushGoal("swat_comeout_left","lookat",-10,10);
	AI:PushGoal("swat_comeout_left","strafe",0,1);
	AI:PushGoal("swat_comeout_left","timeout",1,0.1,0.2);
	AI:PushGoal("swat_comeout_left","strafe",0,0);
	AI:PushGoal("swat_comeout_left","firecmd",1,1);
	AI:PushGoal("swat_comeout_left","timeout",1,1.5,2.5);
	AI:PushGoal("swat_comeout_left","firecmd",1,0);
	AI:PushGoal("swat_comeout_left","hide",1,5,HM_NEAREST);
	AI:PushGoal("swat_comeout_left","timeout",1,1,2);
	AI:PushGoal("swat_comeout_left","signal",0,1,"swat_attack",0);
	
	-- swat comeout right
	AI:CreateGoalPipe("swat_comeout_right");
	AI:PushGoal("swat_comeout_right","firecmd",1,0);
	AI:PushGoal("swat_comeout_right","bodypos",1,0);
	AI:PushGoal("swat_comeout_right","run",1,0);
	AI:PushGoal("swat_comeout_right","Trace_Anchor");
--	AI:PushGoal("swat_comeout_left","lookat",10,-10);
	AI:PushGoal("swat_comeout_right","strafe",0,-1);
	AI:PushGoal("swat_comeout_right","timeout",1,0.1,0.2);
	AI:PushGoal("swat_comeout_right","strafe",0,0);
	AI:PushGoal("swat_comeout_right","firecmd",1,1);
	AI:PushGoal("swat_comeout_right","timeout",1,1.5,2.5);
	AI:PushGoal("swat_comeout_right","firecmd",1,0);
	AI:PushGoal("swat_comeout_right","hide",1,5,HM_NEAREST);
	AI:PushGoal("swat_comeout_right","timeout",1,1,2);
	AI:PushGoal("swat_comeout_right","signal",0,1,"swat_attack",0);
	
	-- swat crouchcomeout left
	AI:CreateGoalPipe("swat_crouchcomeout_left");
	AI:PushGoal("swat_crouchcomeout_left","firecmd",1,0);
	AI:PushGoal("swat_crouchcomeout_left","run",1,0);
	AI:PushGoal("swat_crouchcomeout_left","Trace_Anchor");
	AI:PushGoal("swat_crouchcomeout_left","strafe",0,1);
	AI:PushGoal("swat_crouchcomeout_left","timeout",1,0.1,0.2);
	AI:PushGoal("swat_crouchcomeout_left","strafe",0,0);
	AI:PushGoal("swat_crouchcomeout_left","firecmd",1,1);
	AI:PushGoal("swat_crouchcomeout_left","timeout",1,1.5,2.5);
	AI:PushGoal("swat_crouchcomeout_left","firecmd",0,0);
	AI:PushGoal("swat_crouchcomeout_left","hide",1,5,HM_NEAREST);
	AI:PushGoal("swat_crouchcomeout_left","bodypos",1,1);
	AI:PushGoal("swat_crouchcomeout_left","timeout",1,1,2);
	AI:PushGoal("swat_crouchcomeout_left","signal",0,1,"swat_attack",0);
	
	-- swat crouchcomeout right
	AI:CreateGoalPipe("swat_crouchcomeout_right");
	AI:PushGoal("swat_crouchcomeout_right","firecmd",1,0);
	AI:PushGoal("swat_crouchcomeout_right","run",1,0);
	AI:PushGoal("swat_crouchcomeout_right","Trace_Anchor");
	AI:PushGoal("swat_crouchcomeout_right","strafe",0,-1);
	AI:PushGoal("swat_crouchcomeout_right","timeout",1,0.1,0.2);
	AI:PushGoal("swat_crouchcomeout_right","strafe",0,0);
	AI:PushGoal("swat_crouchcomeout_right","firecmd",1,1);
	AI:PushGoal("swat_crouchcomeout_right","timeout",1,1.5,2.5);
	AI:PushGoal("swat_crouchcomeout_right","firecmd",0,0);
	AI:PushGoal("swat_crouchcomeout_right","hide",1,5,HM_NEAREST);
	AI:PushGoal("swat_crouchcomeout_right","bodypos",1,1);
	AI:PushGoal("swat_crouchcomeout_right","timeout",1,1,2);
	AI:PushGoal("swat_crouchcomeout_right","signal",0,1,"swat_attack",0);
	
	-- swat standup
	AI:CreateGoalPipe("swat_standup");
	AI:PushGoal("swat_standup","firecmd",1,0);
	AI:PushGoal("swat_standup","run",1,0);
	AI:PushGoal("swat_standup","Trace_Anchor");
	AI:PushGoal("swat_standup","bodypos",1,0);
	AI:PushGoal("swat_standup","firecmd",1,1);
	AI:PushGoal("swat_standup","timeout",1,1.5,2.5);
	AI:PushGoal("swat_standup","hide",1,5,HM_NEAREST);
	AI:PushGoal("swat_standup","bodypos",1,1);
	AI:PushGoal("swat_standup","timeout",1,1,2);
	AI:PushGoal("swat_standup","signal",0,1,"swat_attack",0);
	
	-- swat kneel attack
	AI:CreateGoalPipe("swat_kneelattack");
	AI:PushGoal("swat_kneelattack","Trace_Anchor");
	AI:PushGoal("swat_kneelattack","run",1,1);
	AI:PushGoal("swat_kneelattack","bodypos",1,0);
	AI:PushGoal("swat_kneelattack","locate",1,"atttarget");
	AI:PushGoal("swat_kneelattack","pathfind",1,"");
	AI:PushGoal("swat_kneelattack","trace",1,0,1);
	AI:PushGoal("swat_kneelattack","timeout",1,0.3);
	AI:PushGoal("swat_kneelattack","firecmd",0,1);
	AI:PushGoal("swat_kneelattack","signal",0,1,"kneel_start_animation",0);
	AI:PushGoal("swat_kneelattack","timeout",1,1);
	AI:PushGoal("swat_kneelattack","signal",0,1,"kneel_idle_loop_animation",0);
	AI:PushGoal("swat_kneelattack","timeout",1,0.7,1.3);
	AI:PushGoal("swat_kneelattack","signal",0,1,"kneel_end_animation",0);
	AI:PushGoal("swat_kneelattack","timeout",1,1);
	AI:PushGoal("swat_kneelattack","firecmd",0,0);
	AI:PushGoal("swat_kneelattack","hide",1,5,HM_NEAREST);
	AI:PushGoal("swat_kneelattack","timeout",1,1,2);
	AI:PushGoal("swat_kneelattack","signal",0,1,"swat_attack",0);



-- ______________________________________________________________________________________________________________________		
-- -------------------------------------------------- SWAT SCRIPTS ----------------------------------------------------
end


