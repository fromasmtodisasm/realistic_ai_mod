--------------------------------------------------
--   Created By: petar
--   Description: the idle behaviour for the cover
--------------------------


AIBehaviour.SpecialGuy = {
	Name = "SpecialGuy",
	


	OnSpawn = function(self,entity )
		entity:InitAIRelaxed();
	
		local dh=entity:GetName().."_OBSERVE";

		-- try to get tagpoint of the same name as yourself first
		local TagPoint = Game:GetTagPoint(dh);
 		if (TagPoint==nil) then
			-- try to fish for a observation anhor within 2 meter from yourself
			dh = AI:FindObjectOfType(entity.id,20,AIAnchor.AIANCHOR_OBSERVE);
		end
		
		entity:SelectPipe(0,"observe_direction",dh);
		if (TagPoint or dh) then
			entity:InsertSubpipe(0,"patrol_approach_to",dh);
		end
		entity:InsertSubpipe(0,"setup_idle");	-- get in correct stance
	end,

	OnPlayerSeen = function( self, entity, fDistance )
		AI:Signal(SIGNALID_READIBILITY, AIREADIBILITY_SEEN, "FIRST_HOSTILE_CONTACT",entity.id);	
	end,
	---------------------------------------------
	OnSomethingSeen = function( self, entity )
		AI:Signal(SIGNALID_READIBILITY, AIREADIBILITY_INTERESTING, "IDLE_TO_INTERESTED",entity.id);
	end,
	---------------------------------------------
	OnEnemyMemory = function( self, entity )
		AI:Signal(SIGNALID_READIBILITY, AIREADIBILITY_LOST, "ENEMY_TARGET_LOST",entity.id);	
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function( self, entity )
		AI:Signal(SIGNALID_READIBILITY, AIREADIBILITY_NORMAL, "IDLE_TO_INTERESTED",entity.id);
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function( self, entity, fDistance )
		AI:Signal(SIGNALID_READIBILITY, AIREADIBILITY_NORMAL, "IDLE_TO_THREATENED",entity.id);

	end,

	
}