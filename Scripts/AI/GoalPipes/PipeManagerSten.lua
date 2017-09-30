
function PipeManager:OnInitSten()
	System:Log("INITStenCALLED");



-- ______________________________________________________________________________________________________________________		
-- -------------------------------------------------- SHARED SCRIPTS ----------------------------------------------------
				
			
		------------------------------------ SEARCH ---------------------------------------
		
	
		-- Look for Threat
		AI:CreateGoalPipe("AIS_LookForThreat");	
		AI:PushGoal("AIS_LookForThreat","lookat",1,-150,-210);
		AI:PushGoal("AIS_LookForThreat","lookat",1,-90,-180);
		AI:PushGoal("AIS_LookForThreat","lookat",1,70,110);
		AI:PushGoal("AIS_LookForThreat","lookat",1,-70,-110);
		
		
		AI:CreateGoalPipe("AIS_SearchLocateHide_and_Signal");
		AI:PushGoal("AIS_SearchLocateHide_and_Signal","SearchDamageCause");
		AI:PushGoal("AIS_SearchLocateHide_and_Signal","bodypos",1,0);
		AI:PushGoal("AIS_SearchLocateHide_and_Signal","AIS_RunHidePoint");
		AI:PushGoal("AIS_SearchLocateHide_and_Signal","signal",0,1,"AIS_Search_and_Signal",0);
		
		AI:CreateGoalPipe("AIS_TeamMemberDiedIndoor");
		AI:PushGoal("AIS_TeamMemberDiedIndoor","bodypos",1,0);
		AI:PushGoal("AIS_TeamMemberDiedIndoor","run",1,1);
		AI:PushGoal("AIS_TeamMemberDiedIndoor","pathfind",1,"");
		AI:PushGoal("AIS_TeamMemberDiedIndoor","trace",1,1);
		AI:PushGoal("AIS_TeamMemberDiedIndoor","clear",0);
		AI:PushGoal("AIS_TeamMemberDiedIndoor","AIS_LookForThreat");
		AI:PushGoal("AIS_TeamMemberDiedIndoor","AIS_AcquireRunHideNear");
		AI:PushGoal("AIS_TeamMemberDiedIndoor","AIS_Search_and_Signal");
			
		AI:CreateGoalPipe("AIS_InvestigateSenderTarget");
		AI:PushGoal("AIS_InvestigateSenderTarget","bodypos",0,0);
		AI:PushGoal("AIS_InvestigateSenderTarget","run",0,1);
		AI:PushGoal("AIS_InvestigateSenderTarget","locate",1,"formation");
		AI:PushGoal("AIS_InvestigateSenderTarget","pathfind",1,"");
		AI:PushGoal("AIS_InvestigateSenderTarget","trace",1,1);
		
	
		AI:CreateGoalPipe("AIS_investigateThreatIndoor");
		AI:PushGoal("AIS_investigateThreatIndoor","bodypos",1,0);
		AI:PushGoal("AIS_investigateThreatIndoor","AIS_LookForThreat");
		AI:PushGoal("AIS_investigateThreatIndoor","run",1,1);
		AI:PushGoal("AIS_investigateThreatIndoor","locate",1,"atttarget");
		AI:PushGoal("AIS_investigateThreatIndoor","pathfind",1,"");
		AI:PushGoal("AIS_investigateThreatIndoor","trace",1,0);
		AI:PushGoal("AIS_investigateThreatIndoor","AIS_disturbed");
		
		-----------------------------------------------------------------------------------

		------------------------------------- ATTACK --------------------------------------
		
		AI:CreateGoalPipe("AIS_GuardTraceAttack");
		AI:PushGoal("AIS_GuardTraceAttack","firecmd",1,1);
		AI:PushGoal("AIS_GuardTraceAttack","run",0,1);
		AI:PushGoal("AIS_GuardTraceAttack","bodypos",0,0);
		AI:PushGoal("AIS_GuardTraceAttack","locate",1,"atttarget");
		AI:PushGoal("AIS_GuardTraceAttack","timeout",1,0.1);
		AI:PushGoal("AIS_GuardTraceAttack","pathfind",1,"");
		AI:PushGoal("AIS_GuardTraceAttack","trace",1,0);
		AI:PushGoal("AIS_GuardTraceAttack","timeout",1,0.1);
		AI:PushGoal("AIS_GuardTraceAttack","signal",0,1,"AIS_changeAttack",0);		
		

		-- Stand Attack
		AI:CreateGoalPipe("AIS_StandAttack");
		AI:PushGoal("AIS_StandAttack","bodypos",1,0);
		AI:PushGoal("AIS_StandAttack","run",0,0);
		AI:PushGoal("AIS_StandAttack","timeout",1,3);
		AI:PushGoal("AIS_StandAttack","signal",1,1,"AIS_changeAttack",0);					
		
						

-- -------------------------------------------------- SHARED SCRIPTS ----------------------------------------------------
	
end

