--------------------------------------------------
--    Created By: Amanda
--   Description: This is the combat behaviour of the Bezerker
--------------------------
--

AIBehaviour.BezerkerAttack = {
	
	Name = "BezerkerAttack",
	
	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )
		-- called when the enemy sees a living player
		entity.cnt.AnimationSystemEnabled = 1;
		AI:Signal(SIGNALFILTER_GROUPONLY, 1, "HEADS_UP_GUYS",entity.id);
 		if (fDistance<5) then
 			entity:SelectPipe(0,"bezerker_tooclose_attack");
 		else
			AI:Signal(0,1,"MUTANT_NORMAL_ATTACK",entity.id);
 		end
	end,
	---------------------------------------------
	HEADS_UP_GUYS = function (self, entity, sender)
		entity:MakeAlerted();
	end,
	---------------------------------------------
	OnInterestingSound = function ( self, entity, sender)	
		entity:SelectPipe(0,"bezerker_aggresive_investigate");
	end,
	---------------------------------------------
	OnNoHidingPlace = function( self, entity, sender )
		-- called when no hiding place can be found with the specified parameters
	end,	
	--------------------------------------------------
			
	MUTANT_NORMAL_ATTACK = function (self, entity, sender)
	
		
		local rnd = random(1,40);
		if (entity.cnt.melee_attack == 1) then
			if (rnd<10) then
				entity.cnt.melee_attack = 0;
				entity:SelectPipe(0,"bezerker_backoff");
			end
		else	
			if (rnd<10) then
				entity:SelectPipe(0,"bezerker_attack_far");
			elseif (rnd<25) then
				entity:SelectPipe(0,"bezerker_attack_left");
			else	
				entity:SelectPipe(0,"bezerker_attack_right");
			end
		end
	end,
	
}