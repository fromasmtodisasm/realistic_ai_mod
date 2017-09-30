-- linear patroling behaviour - 
--Each character will patrol a set of TagPoints in a linear way ie 1 2 3 4 5 4 3 2 1 etc

--The character will approach each TagPoint sequentialy, look in the direction of the current TagPoint, 
--make some idles and look around. After the last TagPoint he will return to his first point and start again.
-- created by sten: 		18-09-2002
-- last modified by petar
--------------------------

AIBehaviour.Job_FormPatrolLinear = {
	Name = "Job_FormPatrolLinear",
	JOB = 1,
	
	

	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSpawn = function(self,entity )
		entity:InitAIRelaxed();
		entity.AI_PathStep = 0;
		entity.AI_SignIncrement = 1;
		self:PatrolPath(entity);
	end,

	OnJobContinue = function(self,entity )
		entity:InitAIRelaxed();
		self:PatrolPath(entity);
	end,
	---------------------------------------------		
	OnBored = function (self, entity)
		entity:MakeRandomConversation();
	end,
	----------------------------------------------------FUNCTIONS 
	PatrolPath = function (self, entity, sender)
		-- select next tagpoint for patrolling
		local name = entity:GetName();


		local tpname = name.."_P"..entity.AI_PathStep;

		local TagPoint = Game:GetTagPoint(name.."_P"..entity.AI_PathStep);
		if (TagPoint== nil) then 		

			if (entity.AI_PathStep == 0) then 
				System:Log("Warning: Entity "..name.." has a path job but no specified path points.");
				do return end
			end

			entity.AI_SignIncrement = -entity.AI_SignIncrement;
			entity.AI_PathStep = entity.AI_PathStep + entity.AI_SignIncrement;
			tpname = name.."_P"..(entity.AI_PathStep + entity.AI_SignIncrement);
		end

		
		entity:SelectPipe(0,"patrol_approach_to",tpname);
		entity:InsertSubpipe(0,"make_formation");
		entity.AI_PathStep = entity.AI_PathStep + entity.AI_SignIncrement;
	end,
	
	------------------------------------------------------------------------
	-- GROUP SIGNALS
	------------------------------------------------------------------------
	BREAK_AND_IDLE = function (self, entity, sender)
	end,
	------------------------------------------------------------------------	
	
}

 