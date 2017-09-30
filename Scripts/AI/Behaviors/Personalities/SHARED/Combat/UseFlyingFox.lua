-- path chasing, use path outdoor and tag points indoor
---------------------------------------------


AIBehaviour.UseFlyingFox = {
	Name = "UseFlyingFox",
	
	-- SYSTEM EVENTS			-----
	
	---------------------------------------------
	OnSpawn = function(self,entity )	
		entity.cnt.AnimationSystemEnabled = 1;
--		entity.cnt.use_pressed = nil;
		
		AI:CreateGoalPipe("trace_fox");
		AI:PushGoal("trace_fox","run",0,1);
		AI:PushGoal("trace_fox","pathfind",1,"");
		AI:PushGoal("trace_fox","trace",1,1);
		AI:PushGoal("trace_fox","lookat",1,0,0);
		AI:PushGoal("trace_fox","approach",1,0.2);
		AI:PushGoal("trace_fox","timeout",1,1);
		AI:PushGoal("trace_fox","signal",0,1,"PathDone",0);
			
		entity:SelectPipe(0,"patrol_idling");
	end,
	---------------------------------------------
	OnActivate = function( self,entity, sender )
		local foundObject = AI:FindObjectOfType(entity.id,50,AIAnchor.AIOBJECT_FLYING_FOX);
 		if ( foundObject ) then
 			entity:SelectPipe(0,"trace_fox",foundObject);
 		else
 			self:PathDone(entity,sender);
		end
	end,
	----------------------------------------------------FUNCTIONS -------------------------------------------------------------
	USE_FLYWIRE = function (self, entity) 
		entity.cnt.use_pressed = 1;
	end,
	------------------------------------------------------------------------
	PathDone = function (self,entity)
		entity:SelectPipe(0,"basic_lookingaround");
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
			local MyAnim = Mutant_IdleManager:GetIdle(entity);
			entity:StartAnimation(0,MyAnim.Name);							
		end
	end,	
}