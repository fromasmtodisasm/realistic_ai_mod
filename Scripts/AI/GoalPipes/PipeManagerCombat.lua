
function PipeManager:OnInitCombat()

	AI:CreateGoalPipe("send_reinforcements");
	AI:PushGoal("send_reinforcements","signal",0,1,"JoinGroup",SIGNALFILTER_LASTOP);
	AI:PushGoal("send_reinforcements","run",1,1);
	AI:PushGoal("send_reinforcements","bodypos",1,0);
	AI:PushGoal("send_reinforcements","firecmd",1,1);
	AI:PushGoal("send_reinforcements","locate",1,"beacon");
	AI:PushGoal("send_reinforcements","acqtarget",1,"");
	AI:PushGoal("send_reinforcements","approach",1,1);
	AI:PushGoal("send_reinforcements","timeout",1,1);	
--	AI:PushGoal("send_reinforcements","signal",0,1,"SELECT_GROUPADVANCE",SIGNALFILTER_GROUPONLY);

	AI:CreateGoalPipe("SwatApproach");
	AI:PushGoal("SwatApproach","bodypos",0,1);
	AI:PushGoal("SwatApproach","run",0,1)
	AI:PushGoal("SwatApproach","hide",0,10,HM_NEAREST_TO_TARGET);
	AI:PushGoal("SwatApproach","signal",0,1,"CHOOSE_ATTACK",0);
	
	AI:CreateGoalPipe("SwatRoll_Left");
	AI:PushGoal("SwatRoll_Left","Trace_Anchor");
	AI:PushGoal("SwatRoll_Left","firecmd",0,0);
	AI:PushGoal("SwatRoll_Left","strafe",0,1);
	AI:PushGoal("SwatRoll_Left","signal",0,1,"SHARED_PLAYLEFTROLL");
	AI:PushGoal("SwatRoll_Left","timeout",1,1);
	AI:PushGoal("SwatRoll_Left","strafe",0,0);
	AI:PushGoal("SwatRoll_Left","firecmd",0,1);
	AI:PushGoal("SwatRoll_Left","timeout",1,60);

	AI:CreateGoalPipe("SwatRoll_Right");
	AI:PushGoal("SwatRoll_Right","Trace_Anchor");
	AI:PushGoal("SwatRoll_Right","firecmd",0,0);
	AI:PushGoal("SwatRoll_Right","strafe",0,-1);
	AI:PushGoal("SwatRoll_Right","signal",0,1,"SHARED_PLAYRIGHTROLL");
	AI:PushGoal("SwatRoll_Right","timeout",1,1);
	AI:PushGoal("SwatRoll_Right","strafe",0,0);
	AI:PushGoal("SwatRoll_Right","firecmd",0,1);
	AI:PushGoal("SwatRoll_Right","timeout",1,60);

---------------leans waiting on animation not currently called from combat manager	
	AI:CreateGoalPipe("LeanRight");
	AI:PushGoal("LeanRight","Trace_Anchor");
	AI:PushGoal("LeanRight","firecmd",0,0);
	AI:PushGoal("LeanRight","signal",0,1,"SHARED_LEAN_RIGHT",0);
	AI:PushGoal("LeanRight","firecmd",0,1);
	AI:PushGoal("LeanRight","timeout",1,0.5);
		
	AI:CreateGoalPipe("LeanLeft");
	AI:PushGoal("LeanRight","Trace_Anchor");
	AI:PushGoal("LeanLeft","firecmd",0,0);
	AI:PushGoal("LeanLeft","signal",0,1,"SHARED_LEAN_LEFT",0);
	AI:PushGoal("LeanLeft","firecmd",0,1);
	AI:PushGoal("LeanLeft","timeout",1,0.5);
	
	AI:CreateGoalPipe("ComeOut_Right");
	AI:PushGoal("ComeOut_Right","Trace_Anchor");
	AI:PushGoal("ComeOut_Right","firecmd",0,0);
	AI:PushGoal("ComeOut_Right","strafe",0,1);
	AI:PushGoal("ComeOut_Right","firecmd",0,1);
	AI:PushGoal("ComeOut_Right","timeout",1,0.5);
	AI:PushGoal("ComeOut_Right","strafe",0,0);
			
	AI:CreateGoalPipe("ComeOut_Left");
	AI:PushGoal("ComeOut_Left","Trace_Anchor");
	AI:PushGoal("ComeOut_Left","firecmd",0,0);
	AI:PushGoal("ComeOut_Left","strafe",0,-1);
	AI:PushGoal("ComeOut_Left","firecmd",0,1);
	AI:PushGoal("ComeOut_Left","timeout",1,0.5);
	AI:PushGoal("ComeOut_Left","strafe",0,0);
	
	AI:CreateGoalPipe("Shootspot");
	AI:PushGoal("Shootspot","Trace_Anchor");
	AI:PushGoal("Shootspot","bodypos",0,0);
	AI:PushGoal("Shootspot","firecmd",0,1);
	AI:PushGoal("Shootspot","timeout",1,0.5,1);
	AI:PushGoal("Shootspot","bodypos",0,1);
	AI:PushGoal("Shootspot","firecmd",0,1);
	AI:PushGoal("Shootspot","timeout",1,0.5,3);
		
	AI:CreateGoalPipe("Trace_Anchor");
	AI:PushGoal("Trace_Anchor","pathfind",1,"");
	AI:PushGoal("Trace_Anchor","trace",1,1);
	AI:PushGoal("Trace_Anchor","lookat",0,0,0);
	
	AI:CreateGoalPipe("LookForAlarm");
	AI:PushGoal("LookForAlarm","ignoreall",1,1);
	AI:PushGoal("LookForAlarm","signal",0,1,"FIND_ANCHOR",0);
	
	AI:CreateGoalPipe("NoAlarm");
	AI:PushGoal("NoAlarm","ignoreall",1,0);
	
	AI:CreateGoalPipe("RunToTrigger");
	AI:PushGoal("RunToTrigger","ignoreall",1,1);
	AI:PushGoal("RunToTrigger","bodypos",0,0);
	AI:PushGoal("RunToTrigger","run",0,1);
	AI:PushGoal("RunToTrigger","pathfind",1,"");
	AI:PushGoal("RunToTrigger","trace",1,1);
	AI:PushGoal("RunToTrigger","lookat",0,0,0);
 	AI:PushGoal("RunToTrigger","approach",0,.5);	
	AI:PushGoal("RunToTrigger","signal",0,1,"REACHED_TRIGGER",SIGNALFILTER_GROUPONLY);
	AI:PushGoal("RunToTrigger","timeout",1,2);
	AI:PushGoal("RunToTrigger","ignoreall",1,0);
	AI:PushGoal("RunToTrigger","signal",0,1,"PathDone",0);
	
	------Crouch--------------------------------------
	AI:CreateGoalPipe("Crouch_ComeOut_Left");
	AI:PushGoal("Crouch_ComeOut_Left","bodypos",0,1);
	AI:PushGoal("Crouch_ComeOut_Left","ComeOut_Left");

	AI:CreateGoalPipe("Crouch_ComeOut_Right");
	AI:PushGoal("Crouch_ComeOut_Right","bodypos",0,1);
	AI:PushGoal("Crouch_ComeOut_Right","ComeOut_Right");
	
	AI:CreateGoalPipe("Crouch_SwatRoll_Left");
	AI:PushGoal("Crouch_SwatRoll_Left","bodypos",0,1);
	AI:PushGoal("Crouch_SwatRoll_Left","SwatRoll_Left");
	
	AI:CreateGoalPipe("Crouch_SwatRoll_Right");
	AI:PushGoal("Crouch_SwatRoll_Right","bodypos",0,1);
	AI:PushGoal("Crouch_SwatRoll_Right","SwatRoll_Right");

	AI:CreateGoalPipe("Crouch_ThrowGrenade");
	AI:PushGoal("Crouch_ThrowGrenade","bodypos",0,1);
	AI:PushGoal("Crouch_ThrowGrenade","Trace_Anchor");
	AI:PushGoal("Crouch_ThrowGrenade","throw_grenade");	
	
			
	AI:PushGoal("Shootspot","Trace_Anchor");
	AI:PushGoal("Shootspot","bodypos",0,0);
	AI:PushGoal("Shootspot","firecmd",0,1);
	AI:PushGoal("Shootspot","timeout",1,0.5,1);
	AI:PushGoal("Shootspot","bodypos",0,1);
	AI:PushGoal("Shootspot","firecmd",0,1);
	AI:PushGoal("Shootspot","timeout",1,0.5,3);
							
	System:Log("COMBAT PIPES LOADED");
end


