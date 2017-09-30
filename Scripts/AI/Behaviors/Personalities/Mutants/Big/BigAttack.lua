--------------------------------------------------
--    Created By: Petar


AIBehaviour.BigAttack = {
	Name = "BigAttack",


	---------------------------------------------
	OnKnownDamage = function ( self, entity, sender)
		local mytarget = AI:GetAttentionTargetOf(entity.id);
		if (mytarget) then 
			if (type(mytarget)=="table") then 
				if ((mytarget ~= sender) and (sender==_localplayer)) then 
					entity:SelectPipe(0,"retaliate_damage",sender.id);
				end
			end
		end
	end,


	OnNoTarget = function( self, entity )
		entity:SelectPipe(0,"big_roam");
	end,
	---------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )
		-- called when the enemy sees a living player

		entity:SelectPipe(0,"big_pindown");
		

		if (fDistance>5) then
			self:DECIDE_TO_SHOOT_OR_NOT(entity);	
		end
		entity:TriggerEvent(AIEVENT_DROPBEACON);
	
	end,
	---------------------------------------------
	OnEnemyMemory = function( self, entity )
		-- called when the enemy can no longer see its foe, but remembers where it saw it last
		entity:SelectPipe(0,"mutant_run_to_target");
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function( self, entity )
		-- called when the enemy hears an interesting sound
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function( self, entity )
		-- called when the enemy hears a scary sound
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
		entity:SelectPipe(0,"big_run_to_target");
		entity:PushStuff();
	end,	
	---------------------------------------------
	OnReceivingDamage = function ( self, entity, sender)
	end,
	--------------------------------------------------
	OnBulletRain = function ( self, entity, sender)
		-- called when the enemy detects bullet trails around him
	end,
	--------------------------------------------------
	OnCloseContact = function ( self, entity, sender)
		if (entity.MELEE_ANIM_COUNT) then
			local rnd = random(1,entity.MELEE_ANIM_COUNT);
			local melee_anim_name = format("attack_melee%01d",rnd);
			entity:SelectPipe(0,"big_pindown");
			entity:InsertAnimationPipe(melee_anim_name,3);
		else
			Hud:AddMessage("==================UNACCEPTABLE ERROR====================");
			Hud:AddMessage("Entity "..entity:GetName().." made melee attack but has no melee animations.");
			Hud:AddMessage("==================UNACCEPTABLE ERROR====================");
		end

	end,
	--------------------------------------------------

	SELECT_LEFT_RIGHT_COMEOUT = function ( self, entity, sender)
--		local rnd=random(1,2);
--		if (rnd==1) then
--			entity:SelectPipe(0,"big_comeout_left");
--		else
--			entity:SelectPipe(0,"big_comeout_right");
--		end
		entity:SelectPipe(0,"big_run_to_target");
		self:DECIDE_TO_SHOOT_OR_NOT(entity);
		
	end,
	--------------------------------------------------

	DECIDE_TO_SHOOT_OR_NOT = function ( self, entity, sender)
		local tgt = AI:GetAttentionTargetOf(entity.id);
		if ((tgt == nil) or (tgt == AIOBJECT_NONE)) then
			entity:SelectPipe(0,"big_run_to_beacon");
		else
			local rnd=random(1,6);
			if (rnd==1) then
				entity:SelectPipe(0,"big_shoot");
			elseif (rnd==2) then 
				entity:PushStuff();
			end
		end
	end,

	---------------------------------------------
	RUN_TO_TARGET = function( self, entity, sender )
		-- called when no hiding place can be found with the specified parameters
		entity:SelectPipe(0,"big_run_to_target");
		entity:PushStuff();
	end,	
}