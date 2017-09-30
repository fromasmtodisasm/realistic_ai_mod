--------------------------------------------------
--    Created By: Petar


AIBehaviour.KriegerAttack = {
	Name = "KriegerAttack",


	---------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )
		-- called when the enemy sees a living player
		
	end,
	---------------------------------------------
	OnPlayerAiming = function ( self, entity, sender)
		if (entity:MutantJump(AIAnchor.MUTANT_JUMP_TARGET_WALKING,30,2+1) == nil) then 
			local rnd = random(1.10);
			if (rnd == 5) then
				entity:SelectPipe(0,"krieger_fast_hide");	
			end
		end
		AI:Signal(SIGNALFILTER_SUPERGROUP,1,"DESTROY_THE_BEACON",entity.id);
	end,

	---------------------------------------------
	OnPlayerLookingAway =  function( self, entity, fDistance )
		entity:GoRefractive();
		local rnd = random(1.2);
		if (rnd == 1) then 
			entity:SelectPipe(0,"fast_invisible_attack_left");
		else
			entity:SelectPipe(0,"fast_invisible_attack_right");
		end
	end,

	
	---------------------------------------------
	OnEnemyMemory = function( self, entity )
		-- called when the enemy can no longer see its foe, but remembers where it saw it last
		if (entity.VISIBLE) then 
			if (entity:MutantJump(AIAnchor.MUTANT_JUMP_TARGET_WALKING,30,2+1) == nil) then
				entity:SelectPipe(0,"fast_shoot_approach");
			end
		else
			--Hud:AddMessage("invisible?");
		end
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function( self, entity )
		-- called when the enemy hears an interesting sound
		entity:SelectPipe(0,"fast_shoot_approach");

	end,
	---------------------------------------------
	OnThreateningSoundHeard = function( self, entity )
		-- called when the enemy hears a scary sound
		entity:MakeAlerted();
		entity:SelectPipe(0,"fast_shoot_approach");
	end,
	---------------------------------------------
	OnReload = function( self, entity )
		-- called when the enemy goes into automatic reload after its clip is empty
	end,
	---------------------------------------------
	OnGroupMemberDied = function( self, entity )
		-- called when a member of the group dies
	end,
	---------------------------------------------
	OnNoHidingPlace = function( self, entity, sender )
		-- called when no hiding place can be found with the specified parameters
	end,	
	---------------------------------------------
	OnReceivingDamage = function ( self, entity, sender)
		entity:GoVisible();
		entity:SelectPipe(0,"krieger_fast_hide");
	end,
	--------------------------------------------------
	OnBulletRain = function ( self, entity, sender)
		entity:MakeAlerted();
		-- called when the enemy detects bullet trails around him
	end,
	--------------------------------------------------
	OnCloseContact = function ( self, entity, sender)
		entity:GoVisible();
		if (entity.MELEE_ANIM_COUNT) then
			local rnd = random(1,entity.MELEE_ANIM_COUNT);
			local melee_anim_name = format("attack_melee%01d",rnd);
			entity:InsertAnimationPipe(melee_anim_name,3);
		else
			Hud:AddMessage("==================UNACCEPTABLE ERROR====================");
			Hud:AddMessage("Entity "..entity:GetName().." made melee attack but has no melee animations.");
			Hud:AddMessage("==================UNACCEPTABLE ERROR====================");
		end
	end,
	--------------------------------------------------

	SWITCH_TO_SHOOT = function ( self, entity, sender)
		entity:SelectPipe(0,"krieger_fast_shoot");
	end,
	--------------------------------------------------

	CHANGE_POSITION = function ( self, entity, sender)
		entity:SelectPipe(0,"krieger_fast_hide");
	end,
	--------------------------------------------------

	

	
	JUMP_FINISHED = function (self, entity, sender)
		if (self.Walking) then
			entity:SelectPipe(0,"fast_shoot_approach");
		else
			entity:SelectPipe(0,"krieger_fast_shoot");
		end
	end,
}