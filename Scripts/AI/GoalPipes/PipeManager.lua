PipeManager =	 {

}


function PipeManager:OnInit()

	AI:CreateGoalPipe("runaway");
	AI:PushGoal("runaway","firecmd",0,0);
	AI:PushGoal("runaway","backoff",1,10);

	-- normal close distance attack
	AI:CreateGoalPipe("close_attack");	
--	AI:PushGoal("close_attack","ignoreall",0,1);
--	AI:PushGoal("close_attack","acqtarget",0,"");
	AI:PushGoal("close_attack","firecmd",0,1);	
	AI:PushGoal("close_attack","bodypos",0,0);
	AI:PushGoal("close_attack","run",0,1);
	AI:PushGoal("close_attack","approach",1,10);
	AI:PushGoal("close_attack","strafe",0,-1);		
	AI:PushGoal("close_attack","timeout",1,1);
	AI:PushGoal("close_attack","strafe",0,0);
--	AI:PushGoal("close_attack","backoff",1,12);
	AI:PushGoal("close_attack","strafe",0,1);						
	AI:PushGoal("close_attack","timeout",1,2);						
	AI:PushGoal("close_attack","strafe",0,0);							
	AI:PushGoal("close_attack","run",0,0);

	-- retreat
	AI:CreateGoalPipe("retreat");
	AI:PushGoal("retreat","ignoreall",0,1);
	AI:PushGoal("retreat","firecmd",0,1);
	AI:PushGoal("retreat","bodypos",0,0);
	AI:PushGoal("retreat","run",0,1);
	AI:PushGoal("retreat","acqtarget",0,"");
	AI:PushGoal("retreat","backoff",0,30);
	AI:PushGoal("retreat","strafe",0,-1);
	AI:PushGoal("retreat","timeout",0,2);
	AI:PushGoal("retreat","strafe",0,1);
	AI:PushGoal("retreat","timeout",0,1);
	AI:PushGoal("retreat","strafe",0,0);

	-- crouch and fire
	AI:CreateGoalPipe("crouchfire");
	AI:PushGoal("crouchfire","firecmd",0,1);
	AI:PushGoal("crouchfire","bodypos",0,1);
	AI:PushGoal("crouchfire","timeout",1,5);
	
	AI:CreateGoalPipe("investigatesound");
	AI:PushGoal("investigatesound","signal",1,1,"DoYouHearSomething",SIGNALFILTER_SUPERGROUP);
	AI:PushGoal("investigatesound","timeout",1,2);
	AI:PushGoal("investigatesound","firecmd",0,0);
	AI:PushGoal("investigatesound","approach",0,4);
	AI:PushGoal("investigatesound","lookaround",1,1);
	AI:PushGoal("investigatesound","branch",1,-1);
	AI:PushGoal("investigatesound","timeout",1,3);
	AI:PushGoal("investigatesound","lookaround",1,-1);
	AI:PushGoal("investigatesound","devalue",0);

	AI:CreateGoalPipe("standingthere");
	AI:PushGoal("standingthere","bodypos",0,0);
	AI:PushGoal("standingthere","firecmd",0,0);


	-- crouch and fire
	AI:CreateGoalPipe("diethere");
--	AI:PushGoal("diethere","bodypos",0,0);
	AI:PushGoal("diethere","firecmd",0,0);
	AI:PushGoal("diethere","ignoreall",0,1);
	AI:PushGoal("diethere","signal",1,1,"SHARED_PLAY_DAMAGEAREA_ANIM",0);	



	System:Log("PipeManager initialized");
	
	Script:ReloadScript("Scripts/AI/GoalPipes/PipeManagerSten.lua");
	Script:ReloadScript("Scripts/AI/GoalPipes/PipeManagerShared.lua");
	Script:ReloadScript("Scripts/AI/GoalPipes/PipeManager2.lua");
	Script:ReloadScript("Scripts/AI/GoalPipes/PipeManagerJob.lua");
	Script:ReloadScript("Scripts/AI/GoalPipes/PipeManagerSwat.lua");
	Script:ReloadScript("Scripts/AI/GoalPipes/PipeManagerCombat.lua");
	Script:ReloadScript("Scripts/AI/GoalPipes/PipeManagerScientist.lua");
	Script:ReloadScript("Scripts/AI/GoalPipes/PMReusable.lua");
	Script:ReloadScript("Scripts/AI/GoalPipes/PipeManagerVehicle.lua");
	Script:ReloadScript("Scripts/AI/GoalPipes/PMMutant.lua");                                                         
	Script:ReloadScript("Scripts/AI/GoalPipes/PipeManagerBezerker.lua");
	
	
	PipeManager:OnInitSten();
	PipeManager:OnInitShared();
	PipeManager:OnInit2();
	PipeManager:InitReusable();
	PipeManager:OnInitJob();
	PipeManager:OnInitSwat();
	PipeManager:OnInitCombat();
	PipeManager:OnInitScientist();
	PipeManager:OnInitVehicle();	
	PipeManager:InitMutants();
	PipeManager:OnInitBezerker();

	
end

