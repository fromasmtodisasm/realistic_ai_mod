--------------------------------------------------
--   Created By: amanda
--   Description: run to alarm anchor
--------------------------

AIBehaviour.MutantCaged = {
	Name = "MutantCaged",
	NOPREVIOUS = 1,
	
	---------------------------------------------
	OnSpawn = function( self, entity )
		entity:SelectPipe(0,"mutant_caged_idle");
		entity:ChangeAIParameter(AIPARAM_SPECIES,1);
	end,
	---------------------------------------------
	OnActivate = function( self, entity )
		entity:TriggerEvent(AIEVENT_CLEAR);
		local release_friends = AI:FindObjectOfType(entity.id,50,AIAnchor.MUTANT_LOCK);
		if (release_friends) then 
			entity:SelectPipe(0,"bust_lock_at",release_friends);			
		end
		entity:ChangeAIParameter(AIPARAM_SPECIES,100);
		AI:Signal(0,1,"RELEASED",entity.id);
	end,
	---------------------------------------------
	OnNoTarget = function( self, entity )
		entity:SelectPipe(0,"mutant_caged_idle");
	end,
	---------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )
		entity:SelectPipe(0,"mutant_caged_upset");
	end,
	---------------------------------------------
	OnEnemyMemory = function( self, entity )
		-- called when the enemy can no longer see its foe, but remembers where it saw it last
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function( self, entity )
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function( self, entity )
		entity:SelectPipe(0,"mutant_caged_upset");
	end,
	---------------------------------------------
	OnReceivingDamage = function ( self, entity, sender)
		entity:SelectPipe(0,"mutant_caged_upset");
	end,
	--------------------------------------------------
	OnBulletRain = function ( self, entity, sender)
		entity:SelectPipe(0,"mutant_caged_upset");
	end,
	--------------------------------------------------
	OnGrenadeSeen = function( self, entity, fDistance )
	end,

	OnGroupMemberDied = function( self, entity, sender)
	end,
	--------------------------------------------------
	OnGroupMemberDiedNearest = function ( self, entity, sender)
	end,

	--------------------------------------------------
	MUTANT_RELAXED_ANIM = function (self, entity, sender)
		entity:MakeRandomIdleAnimation(); 		-- make idle animation
	end,

	--------------------------------------------------
	MUTANT_UPSET_ANIM = function (self, entity, sender)
		if (entity.COMBAT_IDLE_COUNT) then
			local rnd = random(0,entity.COMBAT_IDLE_COUNT);
			local idle_anim_name = format("combat_idle%02d",rnd);
			entity:InsertAnimationPipe(idle_anim_name,4);
		else
			Hud:AddMessage("============ UNACCEPTABLE ERROR ===================");
			Hud:AddMessage("[ASSETERROR] No combat idles for "..entity:GetName());
			Hud:AddMessage("============ UNACCEPTABLE ERROR ===================");
		end
	end,


	-- GROUP SIGNALS
	--------------------------------------------------
	HEADS_UP_GUYS = function (self, entity, sender)
	end,
	---------------------------------------------
	INCOMING_FIRE = function (self, entity, sender)
	end,
	
}