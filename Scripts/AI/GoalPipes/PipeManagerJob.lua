
function PipeManager:OnInitJob()

	AI:CreateGoalPipe("job_approach_lastop");
	AI:PushGoal("job_approach_lastop","pathfind",1,"");
	AI:PushGoal("job_approach_lastop","trace",1,1);
	AI:PushGoal("job_approach_lastop","lookat",1,0,0);
	AI:PushGoal("job_approach_lastop","timeout",1,2);

	AI:CreateGoalPipe("anchor_animation");
	AI:PushGoal("anchor_animation","signal",1,1,"START_ANIM",0);
	AI:PushGoal("anchor_animation","signal",1,1,"LOOP_ANIM",0);
	AI:PushGoal("anchor_animation","signal",1,1,"DECISION_POINT",0);
	AI:PushGoal("anchor_animation","signal",1,1,"END_ANIM",0);


	---  REVIEWED -----------------------------------------------




	--see Job_StandIdle.lua
	AI:CreateGoalPipe("idle_break");
	AI:PushGoal("idle_break","signal",0,1,"MAIN",0);
	AI:PushGoal("idle_break","timeout",1,2,6);
	AI:PushGoal("idle_break","signal",0,1,"DECISION_POINT",0);
	AI:PushGoal("idle_break","timeout",1,2,6);

	AI:CreateGoalPipe("hide_gun");
--	AI:PushGoal("hide_gun","ignoreall",1,1);
	AI:PushGoal("hide_gun","timeout",1,1);
	AI:PushGoal("hide_gun","signal",0,1,"HIDE_GUN",0);
	AI:PushGoal("hide_gun","timeout",1,8);

	AI:CreateGoalPipe("Trace_Look");
	AI:PushGoal("Trace_Look","pathfind",1,"");
	AI:PushGoal("Trace_Look","trace",1,1);
	AI:PushGoal("Trace_Look","lookat",1,0,0);

	AI:CreateGoalPipe("anchor_PutDown");		
	AI:PushGoal("anchor_PutDown","pathfind",1,"");		
--	AI:PushGoal("anchor_PutDown","trace",1,1);		
	AI:PushGoal("anchor_PutDown","lookat",1,0,0);
	AI:PushGoal("anchor_PutDown","approach",1,1);
	AI:PushGoal("anchor_PutDown","signal",0,1,"END_ANIM",0);
	AI:PushGoal("anchor_PutDown","timeout",1,0.8);
	AI:PushGoal("anchor_PutDown","signal",0,1,"UNBIND_CRATE",0);
	AI:PushGoal("anchor_PutDown","timeout",1,0.5,1);
	AI:PushGoal("anchor_PutDown","bodypos",0,0);
	AI:PushGoal("anchor_PutDown","signal",0,1,"FIND_ANCHOR",0);

	AI:CreateGoalPipe("PutDown");		
	AI:PushGoal("PutDown","timeout",1,0.5,2);
	AI:PushGoal("PutDown","signal",0,1,"END_ANIM",0);
	AI:PushGoal("PutDown","timeout",1,0.8);
	AI:PushGoal("PutDown","signal",0,1,"UNBIND_CRATE",0);
	AI:PushGoal("PutDown","timeout",1,0.5,1);
	AI:PushGoal("PutDown","bodypos",0,0);
	AI:PushGoal("PutDown","signal",0,1,"FIND_ANCHOR",0);
		
	AI:CreateGoalPipe("anchor_Pickup");		
	AI:PushGoal("anchor_Pickup","pathfind",1,"");		
	AI:PushGoal("anchor_Pickup","lookat",1,0,0);
	AI:PushGoal("anchor_Pickup","approach",1,1);
	AI:PushGoal("anchor_Pickup","signal",0,1,"FIND_CRATE",0);
	
	AI:CreateGoalPipe("bind_crate");
	AI:PushGoal("bind_crate","pathfind",1,"");		
--	AI:PushGoal("bind_crate","lookat",1,-10,10);
	AI:PushGoal("bind_crate","lookat",1,0,0);
	AI:PushGoal("bind_crate","approach",1,0.1);
--	AI:PushGoal("bind_crate","lookat",1,0,0);
	AI:PushGoal("bind_crate","signal",0,1,"HIDE_GUN",0);
	AI:PushGoal("bind_crate","signal",0,1,"START_ANIM",0);
	AI:PushGoal("bind_crate","timeout",1,0.5);
	AI:PushGoal("bind_crate","signal",0,1,"BIND_CRATE_TO_ME",0);
	AI:PushGoal("bind_crate","timeout",1,0.5);
	AI:PushGoal("bind_crate","signal",0,1,"LOOP_ANIM",0);
	AI:PushGoal("bind_crate","signal",0,1,"FIND_ANCHOR",0);

	AI:CreateGoalPipe("crouch");		
	AI:PushGoal("crouch","bodypos",0,1);
		
	--eg. see Job_LookPatrol.lua
	AI:CreateGoalPipe("approach_lookAround");
	AI:PushGoal("approach_lookAround","acqtarget",1,"");
	AI:PushGoal("approach_lookAround","signal",0,1,"RELAXED_STANCE",0);
	AI:PushGoal("approach_lookAround","approach",1,0.1);
	AI:PushGoal("approach_lookAround","signal",0,1,"LOOK_AT_LEFT",0);
	AI:PushGoal("approach_lookAround","acqtarget",1,"");
	AI:PushGoal("approach_lookAround","signal",0,1,"IDLE_ANIMATION",0);
	AI:PushGoal("approach_lookAround","signal",0,1,"LOOK_AT_RIGHT",0);
	AI:PushGoal("approach_lookAround","signal",0,1,"FIND_ANCHOR",0);
		
	
	
	AI:CreateGoalPipe("anchor_set_animation");
	AI:PushGoal("anchor_set_animation","timeout",1,1.5);
	AI:PushGoal("anchor_set_animation","pathfind",1,"");
	AI:PushGoal("anchor_set_animation","trace",1,1);
	AI:PushGoal("anchor_set_animation","lookat",1,0,0);
	AI:PushGoal("anchor_set_animation","signal",0,1,"HIDE_GUN",0);
	AI:PushGoal("anchor_set_animation","signal",0,1,"START_ANIM",0);
--	AI:PushGoal("anchor_set_animation","timeout",1,1);
	AI:PushGoal("anchor_set_animation","signal",0,1,"LOOP_ANIM",0);
	
	AI:CreateGoalPipe("loop_animation");
	AI:PushGoal("loop_animation","timeout",1,1.67);
	AI:PushGoal("loop_animation","signal",0,1,"DECISION_POINT",0);
 --	AI:PushGoal("loop_animation","timeout",1,1,5);
 	AI:PushGoal("loop_animation","signal",0,1,"LOOP_ANIM",0);

	AI:CreateGoalPipe("animation_takeBreak");
--	AI:PushGoal("animation_takeBreak","timeout",1,1);
 	AI:PushGoal("animation_takeBreak","signal",0,1,"END_ANIM",0);
-- 	AI:PushGoal("animation_takeBreak","timeout",1,1.5);
 	AI:PushGoal("animation_takeBreak","signal",0,1,"IDLE_ANIMATION",0);

	AI:CreateGoalPipe("get_toolbox");
	AI:PushGoal("get_toolbox","timeout",1,3);
	AI:PushGoal("get_toolbox","locate",1,AIAnchor.AIANCHOR_TOOLBOX);		
	AI:PushGoal("get_toolbox","pathfind",1,"");		
	AI:PushGoal("get_toolbox","trace",1,1);		
	AI:PushGoal("get_toolbox","lookat",1,0,0);
	AI:PushGoal("get_toolbox","bodypos",0,1);
	AI:PushGoal("get_toolbox","timeout",1,0.5,1);
	AI:PushGoal("get_toolbox","bodypos",0,0);
	AI:PushGoal("get_toolbox","signal",0,1,"GOT_TOOLS",0);
	
	AI:CreateGoalPipe("anchor_indoorCar");
	AI:PushGoal("anchor_indoorCar","timeout",1,1.5);
	AI:PushGoal("anchor_indoorCar","pathfind",1,"");
	AI:PushGoal("anchor_indoorCar","trace",1,1);
	AI:PushGoal("anchor_indoorCar","lookat",0,0,0);
	AI:PushGoal("anchor_indoorCar","approach",1,0.5);
	AI:PushGoal("anchor_indoorCar","signal",0,1,"HIDE_GUN",0);
	AI:PushGoal("anchor_indoorCar","signal",0,1,"START_ANIM",0);
	AI:PushGoal("anchor_indoorCar","timeout",1,1);
	AI:PushGoal("anchor_indoorCar","signal",0,1,"LOOP_ANIM",0);
	AI:PushGoal("anchor_indoorCar","timeout",1,2,4);
	AI:PushGoal("anchor_indoorCar","signal",0,1,"DECISION_POINT",0);
	AI:PushGoal("anchor_indoorCar","timeout",1,3);
	AI:PushGoal("anchor_indoorCar","signal",0,1,"END_ANIM",0);
	AI:PushGoal("anchor_indoorCar","timeout",1,1);
	AI:PushGoal("anchor_indoorCar","signal",0,1,"FIND_ANCHOR",0);

	AI:CreateGoalPipe("get_toolbox_indoor");
	AI:PushGoal("get_toolbox_indoor","timeout",1,3);
	AI:PushGoal("get_toolbox_indoor","locate",1,AIAnchor.AIANCHOR_TOOLBOX);		
	AI:PushGoal("get_toolbox_indoor","pathfind",1,"");		
	AI:PushGoal("get_toolbox_indoor","trace",1,1);	
	AI:PushGoal("get_toolbox_indoor","lookat",0,0,0);	
	AI:PushGoal("get_toolbox_indoor","approach",1,0.5);
	AI:PushGoal("get_toolbox_indoor","bodypos",0,1);
	AI:PushGoal("get_toolbox_indoor","timeout",1,0.5,1);
	AI:PushGoal("get_toolbox_indoor","bodypos",0,0);
	AI:PushGoal("get_toolbox_indoor","signal",0,1,"GOT_TOOLS",0);
	
	
	AI:CreateGoalPipe("anchor_traceChair");
	AI:PushGoal("anchor_traceChair","bodypos",0,0);
	AI:PushGoal("anchor_traceChair","timeout",1,1.5);
	AI:PushGoal("anchor_traceChair","pathfind",1,"");
	AI:PushGoal("anchor_traceChair","trace",1,1);
	AI:PushGoal("anchor_traceChair","lookat",1,0,0);
	AI:PushGoal("anchor_traceChair","signal",0,1,"HIDE_GUN",0);
	AI:PushGoal("anchor_traceChair","signal",0,1,"FIND_ANCHOR",0);
	
	AI:CreateGoalPipe("bindChair_trace");
	AI:PushGoal("bindChair_trace","lookat",1,0,0);
	AI:PushGoal("bindChair_trace","signal",0,1,"SITDOWN_ANIM",0);
 	--AI:PushGoal("bindChair_trace","timeout",1,0.05);
	AI:PushGoal("bindChair_trace","signal",0,1,"BIND_CHAIR_TO_ME",0);
	AI:PushGoal("bindChair_trace","timeout",1,1.5);
	AI:PushGoal("bindChair_trace","pathfind",1,"");
	AI:PushGoal("bindChair_trace","trace",1,1);	
	AI:PushGoal("bindChair_trace","approach",0,.5);
	AI:PushGoal("bindChair_trace","signal",0,1,"START_TASK",0);
	
	AI:CreateGoalPipe("bindChair");
--	AI:PushGoal("bindChair","lookat",1,0,0);
--	AI:PushGoal("bindChair","signal",0,1,"SITDOWN_ANIM",0);
 	--AI:PushGoal("bindChair","timeout",1,0.05);
	AI:PushGoal("bindChair","signal",0,1,"BIND_CHAIR_TO_ME",0);
	
	AI:CreateGoalPipe("start_task");
--	AI:PushGoal("start_task","timeout",1,0.5);
--	AI:PushGoal("start_task","signal",0,1,"SITDOWN_ANIM",0);
 	AI:PushGoal("start_task","timeout",1,1);
	AI:PushGoal("start_task","signal",0,1,"START_TASK",0);
		
	--seeJob_CheckApparatus
	AI:CreateGoalPipe("anchor_animation_devalue");
	AI:PushGoal("anchor_animation_devalue","timeout",1,1.5);
 	AI:PushGoal("anchor_animation_devalue","pathfind",1,"");
	AI:PushGoal("anchor_animation_devalue","trace",1,1);
	AI:PushGoal("anchor_animation_devalue","lookat",1,0,0);
	AI:PushGoal("anchor_animation_devalue","signal",0,1,"HIDE_GUN",0);
	AI:PushGoal("anchor_animation_devalue","signal",0,1,"START_ANIM",0);
	AI:PushGoal("anchor_animation_devalue","timeout",1,1);
	AI:PushGoal("anchor_animation_devalue","signal",0,1,"LOOP_ANIM",0);
	AI:PushGoal("anchor_animation_devalue","timeout",1,1,4);
	AI:PushGoal("anchor_animation_devalue","signal",0,1,"DECISION_POINT",0);
	AI:PushGoal("anchor_animation_devalue","signal",0,1,"END_ANIM",0);
	AI:PushGoal("anchor_animation_devalue","timeout",1,1);
	AI:PushGoal("anchor_animation_devalue","acqtarget",0,"");
	AI:PushGoal("anchor_animation_devalue","devalue",0);
	AI:PushGoal("anchor_animation_devalue","signal",0,1,"FIND_ANCHOR",0);
	
	AI:CreateGoalPipe("animation_cycle");
	AI:PushGoal("animation_cycle","signal",0,1,"START_ANIM",0);
	AI:PushGoal("animation_cycle","timeout",1,1);
	AI:PushGoal("animation_cycle","signal",0,1,"LOOP_ANIM",0);
	AI:PushGoal("animation_cycle","timeout",1,1,4);
	AI:PushGoal("animation_cycle","signal",0,1,"DECISION_POINT",0);
	AI:PushGoal("animation_cycle","signal",0,1,"END_ANIM",0);
	AI:PushGoal("animation_cycle","timeout",1,1);
	AI:PushGoal("animation_cycle","acqtarget",0,"");
	AI:PushGoal("animation_cycle","devalue",0);
	AI:PushGoal("animation_cycle","signal",0,1,"FIND_ANCHOR",0);	
	
	AI:CreateGoalPipe("anchor_SitDown");
	AI:PushGoal("anchor_SitDown","timeout",1,1.5);
 	AI:PushGoal("anchor_SitDown","pathfind",1,"");
	AI:PushGoal("anchor_SitDown","trace",1,1);
	AI:PushGoal("anchor_SitDown","lookat",1,0,0);
	AI:PushGoal("anchor_SitDown","timeout",1,1.5);
	AI:PushGoal("anchor_SitDown","signal",0,1,"SITDOWN_ANIM",0);
 	AI:PushGoal("anchor_SitDown","timeout",1,0.05);
	AI:PushGoal("anchor_SitDown","signal",0,1,"BIND_CHAIR_TO_ME",0);
--	AI:PushGoal("anchor_SitDown","timeout",1,1);
	AI:PushGoal("anchor_SitDown","signal",0,1,"DECISION_POINT",0);

	AI:CreateGoalPipe("anchor_Seat");
	AI:PushGoal("anchor_Seat","timeout",1,1.5);
 	AI:PushGoal("anchor_Seat","pathfind",1,"");
	AI:PushGoal("anchor_Seat","trace",1,1);
	AI:PushGoal("anchor_Seat","lookat",1,0,0);
	AI:PushGoal("anchor_Seat","timeout",1,1.5);
	AI:PushGoal("anchor_Seat","signal",0,1,"SITDOWN_ANIM",0);
 	AI:PushGoal("anchor_Seat","timeout",1,0.05);
	AI:PushGoal("anchor_Seat","signal",0,1,"FIND_ANCHOR",0);
	
	AI:CreateGoalPipe("anchor_SitDown_findAnchor");
	AI:PushGoal("anchor_SitDown_findAnchor","timeout",1,1.5);
 	AI:PushGoal("anchor_SitDown_findAnchor","pathfind",1,"");
	AI:PushGoal("anchor_SitDown_findAnchor","trace",1,1);
	AI:PushGoal("anchor_SitDown_findAnchor","lookat",1,0,0);
	AI:PushGoal("anchor_SitDown_findAnchor","timeout",1,1.5);
	AI:PushGoal("anchor_SitDown_findAnchor","signal",0,1,"SITDOWN_ANIM",0);
 	AI:PushGoal("anchor_SitDown_findAnchor","timeout",1,0.05);
	AI:PushGoal("anchor_SitDown_findAnchor","signal",0,1,"BIND_CHAIR_TO_ME",0);
--	AI:PushGoal("anchor_SitDown_findAnchor","timeout",1,1);
	AI:PushGoal("anchor_SitDown_findAnchor","signal",0,1,"FIND_ANCHOR",0);	
	
	AI:CreateGoalPipe("anchor_SitUp");
	AI:PushGoal("anchor_SitUp","ignoreall",1,1);
--	AI:PushGoal("anchor_SitUp","signal",0,1,"SITUP_ANIM",0);
	AI:PushGoal("anchor_SitUp","signal",0,1,"UNBIND_CHAIR",0);
--	AI:PushGoal("anchor_SitUp","bodypos",0,1);
--	AI:PushGoal("anchor_SitUp","bodypos",0,0);
	AI:PushGoal("anchor_SitUp","timeout",1,1);	
	
	AI:CreateGoalPipe("anchor_SitUp_Bored");
	AI:PushGoal("anchor_SitUp_Bored","anchor_SitUp");
	AI:PushGoal("anchor_SitUp","signal",0,1,"BORED_BORED",0);
	---anchor_loop_idle
	AI:CreateGoalPipe("anchor_loop_idle");
	AI:PushGoal("anchor_loop_idle","timeout",1,1.5);
 	AI:PushGoal("anchor_loop_idle","pathfind",1,"");
	AI:PushGoal("anchor_loop_idle","trace",1,1);
	AI:PushGoal("anchor_loop_idle","lookat",1,0,0);
	AI:PushGoal("anchor_loop_idle","loop_break");

	AI:CreateGoalPipe("anchor_loop_devalue");
	AI:PushGoal("anchor_loop_devalue","timeout",1,1.5);
 	AI:PushGoal("anchor_loop_devalue","pathfind",1,"");
	AI:PushGoal("anchor_loop_devalue","trace",1,1);
	AI:PushGoal("anchor_loop_devalue","lookat",1,0,0);
	AI:PushGoal("anchor_loop_devalue","signal",0,1,"HIDE_GUN",0);
	AI:PushGoal("anchor_loop_devalue","loop_break");
	AI:PushGoal("anchor_loop_devalue","devalue_anchor");
		
	AI:CreateGoalPipe("loop_break");
--	AI:PushGoal("loop_break","lookat",1,0,0);
	AI:PushGoal("loop_break","signal",0,1,"MAIN",0);
	AI:PushGoal("loop_break","timeout",1,2,6);
	AI:PushGoal("loop_break","signal",0,1,"DECISION_POINT",0);
	AI:PushGoal("loop_break","timeout",1,1,2);
			
	AI:CreateGoalPipe("devalue_anchor");
--	AI:PushGoal("devalue_anchor","timeout",1,0.5);
	AI:PushGoal("devalue_anchor","acqtarget",1,"");
	AI:PushGoal("devalue_anchor","devalue",1,0);
	
	AI:CreateGoalPipe("pause");
	AI:PushGoal("pause","timeout",1,2);
	
	AI:CreateGoalPipe("pause_decide");
	AI:PushGoal("pause_findAnchor","timeout",1,2,5);
	AI:PushGoal("pause_findAnchor","signal",0,1,"DECISION_POINT",0);	
	
	AI:CreateGoalPipe("beat");
	AI:PushGoal("beat","timeout",1,.5);
	
	AI:CreateGoalPipe("variable_pause");
	AI:PushGoal("variable_pause","timeout",1,2,5);
		
	AI:CreateGoalPipe("pause_straighten");
	AI:PushGoal("pause_straighten","bodypos",1,0);
	AI:PushGoal("pause_straighten","timeout",1,2);

	AI:CreateGoalPipe("job_tagSet");
	AI:PushGoal("job_tagSet","run",1,0);
	AI:PushGoal("job_tagSet","bodypos",1,0);
	AI:PushGoal("job_tagSet","pathfind",1,"");
	AI:PushGoal("job_tagSet","trace",1,1);
	AI:PushGoal("job_tagSet","lookat",0,0,0);
	AI:PushGoal("job_tagSet","signal",0,1,"IDLE_ANIMATION",0);


	AI:CreateGoalPipe("job_patrolPath");
	AI:PushGoal("job_patrolPath","run",1,0);
	AI:PushGoal("job_patrolPath","bodypos",1,0);
	AI:PushGoal("job_patrolPath","pathfind",1,"");
	AI:PushGoal("job_patrolPath","trace",1,1,1);
	AI:PushGoal("job_patrolPath","signal",0,1,"IDLE_ANIMATION",0);
	AI:PushGoal("job_patrolPath","branch",1,-2);
				
	AI:CreateGoalPipe("patrol_idling");
	AI:PushGoal("patrol_idling","timeout",1,2,3);
	AI:PushGoal("patrol_idling","signal",0,1,"IDLE_ANIMATION",0);
	AI:PushGoal("patrol_idling","timeout",1,2);
	AI:PushGoal("patrol_idling","timeout",1,2,3);

	AI:CreateGoalPipe("patrol_random_walk");
	AI:PushGoal("patrol_random_walk","locate",0,"hidepoint");
	AI:PushGoal("patrol_random_walk","acqtarget",0,"");
	AI:PushGoal("patrol_random_walk","approach",0,0.02);
	AI:PushGoal("patrol_random_walk","lookat",1,-10,10);
	AI:PushGoal("patrol_random_walk","branch",0,-1);
	AI:PushGoal("patrol_random_walk","signal",0,1,"IDLING",0);

	AI:CreateGoalPipe("patrol_random_look");
	AI:PushGoal("patrol_random_look","locate",0,"hidepoint");
	AI:PushGoal("patrol_random_look","acqtarget",0,"");
	AI:PushGoal("patrol_random_look","timeout",0,2,3);
	AI:PushGoal("patrol_random_look","lookat",1,-10,10);
	AI:PushGoal("patrol_random_look","lookat",1,-10,10);
	AI:PushGoal("patrol_random_look","branch",1,-2);
	AI:PushGoal("patrol_random_look","signal",0,1,"IDLING",0);
					
	System:Log("JOB PIPES LOADED");
end


