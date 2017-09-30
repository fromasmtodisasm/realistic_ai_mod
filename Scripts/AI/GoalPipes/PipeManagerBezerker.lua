
function PipeManager:OnInitBezerker()	
	-------------------
	----
	---- BEZERKER
	----
	--------------------

--not breaking out of this cycle when AI can no longer see the player
--want him to go looking for player when player hides
	AI:CreateGoalPipe("bezerker_tooclose_attack");
--	AI:PushGoal("bezerker_tooclose_attack","firecmd",0,1);	
	AI:PushGoal("bezerker_tooclose_attack","run",0,1);
--	AI:PushGoal("bezerker_tooclose_attack","lookat",1,-10,10);
	AI:PushGoal("bezerker_tooclose_attack","signal",0,1,"MUTANT_THREATEN",0);
	AI:PushGoal("bezerker_tooclose_attack","approach",1,1.5);
	AI:PushGoal("bezerker_tooclose_attack","timeout",1,1);
	AI:PushGoal("bezerker_tooclose_attack","bezerker_minimise_exposure");
	AI:PushGoal("bezerker_tooclose_attack","signal",0,1,"MUTANT_NORMAL_ATTACK",0);

	AI:CreateGoalPipe("bezerker_rush");
--	 AI:PushGoal("bezerker_rush","lookat",1,-10,10);
	AI:PushGoal("bezerker_rush","run",0,1);
	AI:PushGoal("bezerker_rush","signal",0,1,"MUTANT_THREATEN",0);
	AI:PushGoal("bezerker_rush","approach",1,1.5);
 	AI:PushGoal("bezerker_rush","timeout",1,1);
 	AI:PushGoal("bezerker_rush","signal",0,1,"MUTANT_NORMAL_ATTACK",0);
 	
	AI:CreateGoalPipe("bezerker_attack_left");
--	AI:PushGoal("bezerker_attack_left","firecmd",0,1);
	AI:PushGoal("bezerker_attack_left","run",0,1);
	AI:PushGoal("bezerker_attack_left","mutanthide",1,10,HM_LEFTMOST_FROM_TARGET);
	AI:PushGoal("bezerker_attack_left","bezerker_rush");

	AI:CreateGoalPipe("bezerker_attack_right");
--	AI:PushGoal("bezerker_attack_right","firecmd",0,1);
	AI:PushGoal("bezerker_attack_right","run",0,1);
	AI:PushGoal("bezerker_attack_right","mutanthide",1,10,HM_RIGHTMOST_FROM_TARGET);
 	AI:PushGoal("bezerker_attack_right","bezerker_rush");

	
	AI:CreateGoalPipe("bezerker_attack_far");
--	AI:PushGoal("bezerker_attack_far","firecmd",0,1);
	AI:PushGoal("bezerker_attack_far","run",0,1);
	AI:PushGoal("bezerker_attack_far","mutanthide",1,10,HM_FARTHEST_FROM_TARGET);
	AI:PushGoal("bezerker_attack_far","bezerker_rush");
	
	AI:CreateGoalPipe("bezerker_minimise_exposure");
	AI:PushGoal("bezerker_minimise_exposure","run",0,1);
	AI:PushGoal("bezerker_minimise_exposure","mutanthide",1,10,HM_NEAREST);
	AI:PushGoal("bezerker_minimise_exposure","timeout",1,1,2);	


	AI:CreateGoalPipe("bezerker_aggresive_investigate");
	AI:PushGoal("bezerker_aggresive_investigate","locate",0,"");
--	AI:PushGoal("bezerker_aggresive_investigate","lookat",1,-10,10);
	AI:PushGoal("bezerker_aggresive_investigate","approach",1,0.8);
	AI:PushGoal("bezerker_aggresive_investigate","timeout",1,0.5,2);
	AI:PushGoal("bezerker_aggresive_investigate","signal",0,1,"MUTANT_NORMAL_ATTACK",0);
	

	AI:CreateGoalPipe("bezerker_scramble");
--	AI:PushGoal("bezerker_scramble","firecmd",0,1);
	AI:PushGoal("bezerker_scramble","bezerker_minimise_exposure");
 	AI:PushGoal("bezerker_scramble","locate",0,"");
 --		AI:PushGoal("bezerker_scramble","timeout",1,1,5);
 	AI:PushGoal("bezerker_scramble","lookat",1,-10,10);
	AI:PushGoal("bezerker_scramble","timeout",1,0.5,1);
	AI:PushGoal("bezerker_scramble","signal",0,1,"MUTANT_NORMAL_ATTACK",0);

	AI:CreateGoalPipe("bezerker_stay");
	AI:PushGoal("bezerker_stay","firecmd",0,0);
	AI:PushGoal("bezerker_stay","approach",0,0.1);
	AI:PushGoal("bezerker_stay","timeout",0,0.8);
	AI:PushGoal("bezerker_stay","backoff",0,0.1);
 	AI:PushGoal("bezerker_stay","signal",0,1,"MUTANT_NORMAL_ATTACK",0);	
 	
 	AI:CreateGoalPipe("bezerker_backoff");
--	AI:PushGoal("bezerker_backoff","firecmd",0,1);
	AI:PushGoal("bezerker_backoff","backoff",1,7);
	AI:PushGoal("bezerker_backoff","signal",0,1,"MUTANT_NORMAL_ATTACK",0);
 	
 	AI:CreateGoalPipe("wait_animation");
	AI:PushGoal("wait_animation","timeout",1,1,2);
 	
 	AI:CreateGoalPipe("idle_animation");
	AI:PushGoal("idle_animation","timeout",1,1,2);
	AI:PushGoal("idle_animation","signal",0,1,"FIND_ANCHOR",0);
				
	System:Log("BEZERKER PIPES LOADED");
end


