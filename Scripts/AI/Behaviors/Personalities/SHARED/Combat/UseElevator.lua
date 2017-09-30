-- use Elevator, use path outdoor and tag points indoor
---------------------------------------------


AIBehaviour.UseElevator = {
	Name = "UseElevator",
	
	-- SYSTEM EVENTS			-----
	
	---------------------------------------------
	OnSpawn = function(self,entity )
		AI:CreateGoalPipe(entity.Properties.pathname.."UseElevator");
		AI:PushGoal(entity.Properties.pathname.."UseElevator","signal",0,1,"AI_AGGRESSIVE",SIGNALID_READIBILITY);	
		AI:PushGoal(entity.Properties.pathname.."UseElevator","run",0,1);
		AI:PushGoal(entity.Properties.pathname.."UseElevator","bodypos",0,0);
		AI:PushGoal(entity.Properties.pathname.."UseElevator","firecmd",0,1);
		AI:PushGoal(entity.Properties.pathname.."UseElevator","pathfind",1,entity.Properties.pathname.."1");
		AI:PushGoal(entity.Properties.pathname.."UseElevator","trace",1,1);
		AI:PushGoal(entity.Properties.pathname.."UseElevator","timeout",1,10);
		AI:PushGoal(entity.Properties.pathname.."UseElevator","pathfind",1,entity.Properties.pathname.."2");
		AI:PushGoal(entity.Properties.pathname.."UseElevator","trace",1,1);
		AI:PushGoal(entity.Properties.pathname.."UseElevator","signal",0,1,"PathDone",0);	
				
		entity:SelectPipe(0,"patrol_idling");
	end,
	---------------------------------------------
	OnActivate = function(self,entity )
		entity:SelectPipe(0,entity.Properties.pathname.."UseElevator");		
	end,
	----------------------------------------------------FUNCTIONS -------------------------------------------------------------
	PathDone = function (self, entity, sender)
		entity:SelectPipe(0,"force_reevaluate");
		-- entity:SelectPipe(0,"basic_lookingaround");
		-- entity:InsertSubpipe(0,"force_reevaluate");
	end,
	------------------------------------------------------------------------

	OnGroupMemberDied = function( self, entity, sender)
		-- call the default to do stuff that everyone should do
		AIBehaviour.DEFAULT:OnGroupMemberDied(entity,sender);
	end,
	--------------------------------------------------
	OnGroupMemberDiedNearest = function ( self, entity, sender)
		-- call the default to do stuff that everyone should do
		AIBehaviour.DEFAULT:OnGroupMemberDiedNearest(entity,sender);
	end,
	--------------------------------------------------
	OnReceivingDamage = function ( self, entity, sender)
		-- dont handle this
	end,
	---------------------------------------------
	OnCoverRequested = function ( self, entity, sender)
			-- dont handle this
	end,
	--------------------------------------------------
	OnBulletRain = function ( self, entity, sender)
				-- dont handle this
	end,
	--------------------------------------------------
	HEADS_UP_GUYS = function ( self, entity, sender)
				-- dont handle this
	end,
	--------------------------------------------------
	IDLING = function ( self, entity, sender)
		entity:SelectPipe(0,"patrol_idling");
	end,

	IDLE_ANIMATION = function ( self, entity, sender)
		entity.cnt.AnimationSystemEnabled = 1;
		local rnd = random(1,10);
		if (rnd>4) then
			local MyAnim = IdleManager:GetIdle();
			entity:StartAnimation(0,MyAnim.Name);							
		end
	end,	
}