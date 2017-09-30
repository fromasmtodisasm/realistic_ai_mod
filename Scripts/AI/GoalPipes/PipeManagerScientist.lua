
function PipeManager:OnInitScientist()
	System:Log("SCIENTIST PIPES LOADED")
	
	
	AI:CreateGoalPipe("scientist_runAway")
	AI:PushGoal("scientist_runAway","setup_stealth")
	AI:PushGoal("scientist_runAway","do_it_walking")
	AI:PushGoal("scientist_runAway","not_shoot")
	AI:PushGoal("scientist_runAway","hide",1,10,HM_NEAREST)
	AI:PushGoal("scientist_runAway","timeout",1,1,2)

	
	AI:CreateGoalPipe("scientist_defend")
	AI:PushGoal("scientist_defend","just_shoot")	
	AI:PushGoal("scientist_defend","timeout",1,1,3)
	
	AI:CreateGoalPipe("scientist_hideNow")
	AI:PushGoal("scientist_hideNow","just_shoot")	
	AI:PushGoal("scientist_hideNow","hide",1,10,HM_NEAREST)
	AI:PushGoal("scientist_hideNow","setup_crouch")
	AI:PushGoal("scientist_hideNow","signal",0,1,"SCIENTIST_NORMALATTACK",0)
	
	AI:CreateGoalPipe("scientist_randomhide")
	AI:PushGoal("scientist_randomhide","AIS_LookForThreat")
	--AI:PushGoal("scientist_randomhide","lookaround",0,1)	
	AI:PushGoal("scientist_randomhide","randomhide")
	
	AI:CreateGoalPipe("scientist_grabGun")
	AI:PushGoal("scientist_grabGun","setup_stand")
	AI:PushGoal("scientist_grabGun","do_it_running")
	AI:PushGoal("scientist_grabGun","Trace_Anchor") -- f. PipeManagerCombat.lua
	AI:PushGoal("scientist_grabGun","signal",0,1,"SCIENTIST_PICKUP_GUN",0)
	AI:PushGoal("scientist_grabGun","devalue_anchor") -- f. PipeMangerJob.lua 

	AI:CreateGoalPipe("scientist_cower")
 	AI:PushGoal("scientist_cower","not_shoot")
	AI:PushGoal("scientist_cower","timeout",1,0,1)
	AI:PushGoal("scientist_cower","signal",1,1,"ACT_SCARED",SIGNALID_READIBILITY)
	AI:PushGoal("scientist_cower","setup_crouch")
	
	
	AI:CreateGoalPipe("scientist_PushAlarm")
	AI:PushGoal("scientist_PushAlarm","ignoreall",1,1)
	AI:PushGoal("scientist_PushAlarm","setup_stand")
	AI:PushGoal("scientist_PushAlarm","do_it_running")
	AI:PushGoal("scientist_PushAlarm","Trace_Anchor")
	AI:PushGoal("scientist_PushAlarm","devalue_anchor")
	AI:PushGoal("scientist_PushAlarm","signal",0,1,"SCIENTIST_PUSH_ALARM",0)

	AI:CreateGoalPipe("scientist_PullAlarm")
	AI:PushGoal("scientist_PullAlarm","ignoreall",1,1)
	AI:PushGoal("scientist_PullAlarm","setup_stand")
	AI:PushGoal("scientist_PullAlarm","do_it_running")
	AI:PushGoal("scientist_PullAlarm","Trace_Anchor")
	AI:PushGoal("scientist_PullAlarm","devalue_anchor")
	AI:PushGoal("scientist_PullAlarm","signal",0,1,"SCIENTIST_PULL_ALARM",0)
	
	AI:CreateGoalPipe("scientist_table_crouch")
	AI:PushGoal("scientist_table_crouch","ignoreall",1,1)
	AI:PushGoal("scientist_table_crouch","setup_stand")	
	AI:PushGoal("scientist_table_crouch","do_it_running")
	AI:PushGoal("scientist_table_crouch","pathfind",1,"")
	AI:PushGoal("scientist_table_crouch","trace",1,1)
	AI:PushGoal("scientist_table_crouch","lookat",1,0,0)
	AI:PushGoal("scientist_table_crouch","setup_prone")	
	AI:PushGoal("scientist_table_crouch","approach",1,.8)
	AI:PushGoal("scientist_table_crouch","setup_crouch")	
	AI:PushGoal("scientist_table_crouch","lookaround",0,0)
	AI:PushGoal("scientist_table_crouch","timeout",1,1,6)	
	AI:PushGoal("scientist_table_crouch","lookat",1,0,180)
	AI:PushGoal("scientist_table_crouch","devalue_anchor")
	AI:PushGoal("scientist_table_crouch","ignoreall",1,0)
--	AI:PushGoal("scientist_table_crouch","signal",0,1,"SCIENTIST_NORMALATTACK",0)		
	
	AI:CreateGoalPipe("scientist_table_prone")
	AI:PushGoal("scientist_table_prone","ignoreall",1,1)
	AI:PushGoal("scientist_table_prone","setup_stand")	
	AI:PushGoal("scientist_table_prone","do_it_running")
	AI:PushGoal("scientist_table_prone","pathfind",1,"")
	AI:PushGoal("scientist_table_prone","trace",1,1)
	AI:PushGoal("scientist_table_prone","lookat",1,0,0)
	AI:PushGoal("scientist_table_prone","setup_prone")	
	AI:PushGoal("scientist_table_prone","approach",1,.8)
	AI:PushGoal("scientist_table_prone","lookaround",0,0)
	AI:PushGoal("scientist_table_prone","timeout",1,1,6)
	AI:PushGoal("scientist_table_prone","lookat",1,0,180)
	AI:PushGoal("scientist_table_prone","devalue_anchor")
	AI:PushGoal("scientist_table_prone","ignoreall",1,0)
--	AI:PushGoal("scientist_table_prone","signal",0,1,"SCIENTIST_NORMALATTACK",0)	
end


