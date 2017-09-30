
function PipeManager:OnInitMand()
	-------------------
	----
	---- ISLANDER
	----
	--------------------
-- patrol for specific path not sure how or if you can pass entity.properties.pathname to
-- pipe so that you could make this a generic function. Are there performance benefits to 
-- defining in pipe manager over in script. I think pipeManager just good for pipes which
-- need to be accessed from multiple behaviours 
 
-- if not walking make sure AI Physics is on
	AI:CreateGoalPipe("cargo_run");
	AI:PushGoal("cargo_run","bodypos",1,0);
	AI:PushGoal("cargo_run","run",0,0);
	AI:PushGoal("cargo_run","firecmd",0,0);
	AI:PushGoal("cargo_run","pathfind",1,"cargo_run");
	AI:PushGoal("cargo_run","trace",1,1);
	AI:PushGoal("cargo_run","lookaround",1,6);	
	-------------------
	----
	---- BEZERKER
	----
	--------------------

--not breaking out of this cycle when AI can no longer see the player
--want him to go looking for player when player hides
	AI:CreateGoalPipe("bezerker_tooclose_attack");
--	AI:PushGoal("bezerker_tooclose_attack","ignoreall",0,1);
--	AI:PushGoal("bezerker_tooclose_attack","acqtarget",0,"");
	AI:PushGoal("bezerker_tooclose_attack","firecmd",0,1);	
	AI:PushGoal("bezerker_tooclose_attack","bodypos",0,0);
	AI:PushGoal("bezerker_tooclose_attack","run",0,1);
	AI:PushGoal("bezerker_tooclose_attack","approach",1,10);
	AI:PushGoal("bezerker_tooclose_attack","minimize_exposure");
	AI:PushGoal("bezerker_tooclose_attack","run",0,0);
	AI:PushGoal("bezerker_tooclose_attack","signal",0,1,"BERZERKER_NORMALATTACK",0);

	AI:CreateGoalPipe("bezerker_attack_left");
	AI:PushGoal("bezerker_attack_left","bodypos",0,0);
	AI:PushGoal("bezerker_attack_left","firecmd",0,1);
	AI:PushGoal("bezerker_attack_left","run",0,1);
	AI:PushGoal("bezerker_attack_left","hide",1,10,HM_LEFTMOST_FROM_TARGET);
	AI:PushGoal("bezerker_attack_left","run",0,1);
	AI:PushGoal("bezerker_attack_left","bodypos",0,1);
	AI:PushGoal("bezerker_attack_left","reload");
	AI:PushGoal("bezerker_attack_left","approach",1,0.8);
	AI:PushGoal("bezerker_attack_left","timeout",1,30);

	AI:CreateGoalPipe("bezerker_attack_right");
	AI:PushGoal("bezerker_attack_right","bodypos",0,0);
	AI:PushGoal("bezerker_attack_right","firecmd",0,1);
	AI:PushGoal("bezerker_attack_right","run",0,1);
	AI:PushGoal("bezerker_attack_right","hide",1,10,HM_RIGHTMOST_FROM_TARGET);
	AI:PushGoal("bezerker_attack_right","run",0,1);
	AI:PushGoal("bezerker_attack_right","bodypos",0,1);
	AI:PushGoal("bezerker_attack_right","reload");
	AI:PushGoal("bezerker_attack_right","approach",1,0.8);
	AI:PushGoal("bezerker_attack_right","timeout",1,30);

--if i leave locate as nil will it locate last event eg. interesting sound
--or should it be set to player
	AI:CreateGoalPipe("bezerker_aggresive_investigate");
	AI:PushGoal("bezerker_aggresive_investigate","locate",0,"player");
	AI:PushGoal("bezerker_aggresive_investigate","pathfind",1,"");
	AI:PushGoal("bezerker_aggresive_investigate","trace",1,0);
	AI:PushGoal("bezerker_aggresive_investigate","timeout",1,2);
	--AI:PushGoal("bezerker_aggresive_investigate","signal",0,1,"BERZERKER_NORMALATTACK",0);
	
-- attach to boat wide patrol path
--	AI:CreateGoalPipe("bezerker_patrol_wide");

--this should be more aggressive for bezerker maybe skip minimize exposure
	AI:CreateGoalPipe("bezerker_scramble");
	AI:PushGoal("bezerker_scramble","firecmd",0,1);
	AI:PushGoal("bezerker_scramble","minimize_exposure");
	AI:PushGoal("bezerker_scramble","reload");
	AI:PushGoal("bezerker_scramble","signal",0,1,"BERZERKER_NORMALATTACK",0);

	AI:CreateGoalPipe("bezerker_attack");
	AI:PushGoal("bezerker_attack","firecmd",0,1);
	AI:PushGoal("bezerker_attack","bodypos",0,1);
	AI:PushGoal("bezerker_attack","reload");
	AI:PushGoal("bezerker_attack","approach",1,0.8);
	AI:PushGoal("bezerker_attack","timeout",1,30);

--reusable

--cover 


--rear	
	AI:CreateGoalPipe("respond_rear")
	-- dont respond immediately to every call
	--AI:PushGoal("respond_rear","timeout",1,5);
	--target to approach is team member who requested rear
	
	--cant get sender.ID at the moment so using named
	--AI:PushGoal("respond_rear","acqtarget",1,"");
	AI:PushGoal("respond_rear","acqtarget",1,"Cover");
	
	--let team member know on our way so will say low ammo or whatever
	AI:PushGoal("respond_rear","signal",0,1,"REAR_REPLIED","");
	
	--give team member time to ask you to come now that they know you are here
	AI:PushGoal("respond_rear","timeout",1,10);
	-- on your way
	AI:PushGoal("respond_rear","run",1,1);
	AI:PushGoal("respond_rear","bodypos",1,0);
	AI:PushGoal("respond_rear","firecmd",1,0);
	--approach to 5m and throw some ammo
	AI:PushGoal("respond_rear","ignoreall",1,0);
	AI:PushGoal("respond_rear","approach",1,5);
	AI:PushGoal("respond_rear","signal",0,1,"EXCHANGE_AMMO",0);
	AI:PushGoal("respond_rear","timeout",1,1);
	
--cover 
	AI:CreateGoalPipe("request_rear")
	AI:PushGoal("request_rear","minimize_exposure");
	--AI:PushGoal("request_rear","signal",0,1,"RESPOND_REAR",SIGNALFILTER_GROUPONLY);
	AI:PushGoal("request_rear","signal",0,1,"RESPOND_REAR",SIGNALFILTER_SUPERGROUP);

	AI:CreateGoalPipe("low_ammo");
	AI:PushGoal("low_ammo","signal",0,1,"LOW_AMMO",SIGNALID_READIBILITY);
	AI:PushGoal("low_ammo","timeout",1,100);
	
	AI:CreateGoalPipe("act_suprised");
	AI:PushGoal("act_suprised","signal",0,1,"ACT_SURPRISED",SIGNALID_READIBILITY);

	AI:CreateGoalPipe("catch_ammo");
	AI:PushGoal("catch_ammo","timeout",1,5);
	AI:PushGoal("catch_ammo","signal",0,1,"ACT_SURPRISED",SIGNALID_READIBILITY);
			
	System:Log("MAND PIPES LOADED");
end


