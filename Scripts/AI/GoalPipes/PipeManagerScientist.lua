
function PipeManager:OnInitScientist()
	System:Log("SCIENTIST PIPES LOADED");
	
	
	AI:CreateGoalPipe("scientist_runAway");
	AI:PushGoal("scientist_runAway","bodypos",0,BODYPOS_STEALTH);
	AI:PushGoal("scientist_runAway","run",0,0);
	AI:PushGoal("scientist_runAway","firecmd",0,0);
	AI:PushGoal("scientist_runAway","hide",1,10,HM_NEAREST);
	AI:PushGoal("scientist_runAway","timeout",1,1,2);

	
	AI:CreateGoalPipe("scientist_defend");
	AI:PushGoal("scientist_defend","firecmd",0,1);	
	AI:PushGoal("scientist_defend","timeout",1,1,3);
	
	AI:CreateGoalPipe("scientist_hideNow");
	AI:PushGoal("scientist_hideNow","firecmd",0,1);	
	AI:PushGoal("scientist_hideNow","hide",1,10,HM_NEAREST);
	AI:PushGoal("scientist_hideNow","bodypos",0,1);
	AI:PushGoal("scientist_hideNow","signal",0,1,"SCIENTIST_NORMALATTACK",0);
	
	AI:CreateGoalPipe( "scientist_randomhide");
	AI:PushGoal("scientist_randomhide","AIS_LookForThreat");
	--AI:PushGoal("scientist_randomhide","lookaround",0,1);	
	AI:PushGoal("scientist_randomhide","randomhide");
	
	AI:CreateGoalPipe( "scientist_grabGun");
	AI:PushGoal("scientist_grabGun","bodypos",0,0);
	AI:PushGoal("scientist_grabGun","run",0,1);
	AI:PushGoal("scientist_grabGun","Trace_Anchor"); -- f. PipeManagerCombat.lua
	AI:PushGoal("scientist_grabGun","signal",0,1,"SCIENTIST_PICKUP_GUN",0);
	AI:PushGoal("scientist_grabGun","devalue_anchor"); -- f. PipeMangerJob.lua;

	AI:CreateGoalPipe("scientist_cower");
 	AI:PushGoal("scientist_cower","firecmd",0,0);
	AI:PushGoal("scientist_cower","timeout",1,0,1);
	AI:PushGoal("scientist_cower","signal",1,1,"ACT_SCARED",SIGNALID_READIBILITY);
	AI:PushGoal("scientist_cower","bodypos",0,BODYPOS_CROUCH);
	
	
	AI:CreateGoalPipe( "scientist_PushAlarm");
	AI:PushGoal("scientist_PushAlarm","ignoreall",1,1);
	AI:PushGoal("scientist_PushAlarm","bodypos",0,0);
	AI:PushGoal("scientist_PushAlarm","run",0,1);
	AI:PushGoal("scientist_PushAlarm","Trace_Anchor");
	AI:PushGoal("scientist_PushAlarm","devalue_anchor");
	AI:PushGoal("scientist_PushAlarm","signal",0,1,"SCIENTIST_PUSH_ALARM",0);

	AI:CreateGoalPipe( "scientist_PullAlarm");
	AI:PushGoal("scientist_PullAlarm","ignoreall",1,1);
	AI:PushGoal("scientist_PullAlarm","bodypos",0,0);
	AI:PushGoal("scientist_PullAlarm","run",0,1);
	AI:PushGoal("scientist_PullAlarm","Trace_Anchor");
	AI:PushGoal("scientist_PullAlarm","devalue_anchor");
	AI:PushGoal("scientist_PullAlarm","signal",0,1,"SCIENTIST_PULL_ALARM",0);
	
	AI:CreateGoalPipe( "scientist_table_crouch");
	AI:PushGoal("scientist_table_crouch","ignoreall",1,1);
	AI:PushGoal("scientist_table_crouch","bodypos",0,0);	
	AI:PushGoal("scientist_table_crouch","run",0,1);
	AI:PushGoal("scientist_table_crouch","pathfind",1,"");
	AI:PushGoal("scientist_table_crouch","trace",1,1);
	AI:PushGoal("scientist_table_crouch","lookat",1,0,0);
	AI:PushGoal("scientist_table_crouch","bodypos",0,2);	
	AI:PushGoal("scientist_table_crouch","approach",1,0.8);
	AI:PushGoal("scientist_table_crouch","bodypos",0,1);	
	AI:PushGoal("scientist_table_crouch","lookaround",0,0);
	AI:PushGoal("scientist_table_crouch","timeout",1,1,6);	
	AI:PushGoal("scientist_table_crouch","lookat",1,0,180);
	AI:PushGoal("scientist_table_crouch","devalue_anchor");
	AI:PushGoal("scientist_table_crouch","ignoreall",1,0);
--	AI:PushGoal("scientist_table_crouch","signal",0,1,"SCIENTIST_NORMALATTACK",0);		
	
	AI:CreateGoalPipe( "scientist_table_prone");
	AI:PushGoal("scientist_table_prone","ignoreall",1,1);
	AI:PushGoal("scientist_table_prone","bodypos",0,0);	
	AI:PushGoal("scientist_table_prone","run",0,1);
	AI:PushGoal("scientist_table_prone","pathfind",1,"");
	AI:PushGoal("scientist_table_prone","trace",1,1);
	AI:PushGoal("scientist_table_prone","lookat",1,0,0);
	AI:PushGoal("scientist_table_prone","bodypos",0,2);	
	AI:PushGoal("scientist_table_prone","approach",1,0.8);
	AI:PushGoal("scientist_table_prone","lookaround",0,0);
	AI:PushGoal("scientist_table_prone","timeout",1,1,6);
	AI:PushGoal("scientist_table_prone","lookat",1,0,180);
	AI:PushGoal("scientist_table_prone","devalue_anchor");
	AI:PushGoal("scientist_table_prone","ignoreall",1,0);
--	AI:PushGoal("scientist_table_prone","signal",0,1,"SCIENTIST_NORMALATTACK",0);	
end


