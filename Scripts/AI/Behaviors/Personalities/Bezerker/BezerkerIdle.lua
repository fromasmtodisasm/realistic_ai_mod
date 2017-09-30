--------------------------------------------------
--    Created By: Amanda
--   Description: the idle behaviour for the Bezerker
--------------------------
--

AIBehaviour.BezerkerIdle = {
	Name = "BezerkerIdle",

	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSpawn = function(self,entity)
		-- called when enemy spawned or reset
		entity.cnt.AnimationSystemEnabled = 1 
		entity:SelectPipe(0,"mutant_idling")
		entity.runPath = nil 
	end,
	---------------------------------------------
	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		-- called when the enemy sees a living player
 		AI:Signal(SIGNALFILTER_GROUPONLY,1,"HEADS_UP_GUYS",entity.id)
 		if ((entity.runPath==nil) and (entity.Properties.pathname~="none") and (entity.Properties.pathname~="")) then
			self:RUN_TO_PATH(entity)			
 		elseif (fDistance< 10) then
 			entity:SelectPipe(0,"bezerker_tooclose_attack")
 		else
 			AI:Signal(0,1,"MUTANT_NORMAL_ATTACK",entity.id)
 		end
	end,
	---------------------------------------------
	OnEnemyMemory = function(self,entity,fDistance,NotContact)
	end,	
	---------------------------------------------
	OnReceivingDamage = function(self,entity,sender)
		entity:SelectPipe(0,"bezerker_scramble")
	end,

	---------------------------------------------
	OnBulletRain = function(self,entity,sender)
		if ((entity.runPath==nil) and (entity.Properties.pathname~="none") and (entity.Properties.pathname~="")) then
			self:RUN_TO_PATH(entity)			
		else	
			entity:SelectPipe(0,"bezerker_scramble")
		end
	end,
	--------------------------------------------------
	OnThreateningSound = function(self,entity,sender)	
--		System:Log("\001"..entity:GetName().."OnThreateningSound")
		entity:SelectPipe(0,"bezerker_aggresive_investigate")
	end,
	--------------------------------------------------	
	OnInterestingSound = function(self,entity,sender)	
--		System:Log("\001"..entity:GetName().."OnInterestingSound")
		entity:SelectPipe(0,"bezerker_aggresive_investigate")
	end,
	--------------------------------------------------	
	OnNoHidingPlace = function(self,entity,sender)	
		entity:StartAnimation(0,"idle_look")
	end,
	--------------------------------------------------
	OnCloseContact = function(self,entity,sender)
		-- called when the enemy detects close contact with enemy
		entity:InsertSubpipe(0,"mutant_melee_attack")
	end,	
	--------------------------------------------------
	-- CUSTOM FUNCTIONS
	--------------------------------------------------	
	RUN_TO_PATH = function(self,entity)	

		entity.runPath = 1 
		entity:SelectPipe(0,"beat")
		AI:Signal(0,1,"RUN_PATH",entity.id)
		entity.EventToCall = "OnSpawn" 
	end,
	--------------------------------------------------
	MUTANT_THREATEN = function(self,entity,sender)
 		AI:Signal(SIGNALID_READIBILITY,1,"THREATEN",entity.id)
		if (random(1,4)==1) then
			
			entity:StartAnimation(0,"idle_beatchest",0,.1,1)	
			entity:InsertSubpipe(0,"wait_animation")
		end
	end,
	--------------------------------------------------		
	MUTANT_NORMAL_ATTACK = function(self,entity,sender)
		local rnd = random(1,40)
		if (rnd<10) then
			entity:SelectPipe(0,"bezerker_attack_far")
		elseif (rnd<25) then
			entity:SelectPipe(0,"bezerker_attack_left")
		else	
			entity:SelectPipe(0,"bezerker_attack_right")
		end
	end,
	--------------------------------------------------
	HEADS_UP_GUYS = function(self,entity,sender)
		entity:MakeAlerted()
	end,
}