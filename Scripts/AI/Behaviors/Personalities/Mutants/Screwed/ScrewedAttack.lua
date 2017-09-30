--------------------------------------------------
--    Created By: Petar


AIBehaviour.ScrewedAttack = {
	Name = "ScrewedAttack",


	---------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )
		-- called when the enemy sees a living player
		entity:InsertSubpipe(0,"DropBeaconAt");
	end,
	---------------------------------------------
	OnEnemyMemory = function( self, entity )
		-- called when the enemy can no longer see its foe, but remembers where it saw it last
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function( self, entity )
		-- called when the enemy hears an interesting sound
		entity:InsertSubpipe(0,"DropBeaconAt");
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function( self, entity )
		-- called when the enemy hears a scary sound
		entity:InsertSubpipe(0,"DropBeaconAt");
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
			entity:SelectPipe(0,"abberation_melee");
			entity:InsertAnimationPipe(melee_anim_name,3);
		else
			Hud:AddMessage("==================UNACCEPTABLE ERROR====================");
			Hud:AddMessage("Entity "..entity:GetName().." made melee attack but has no melee animations.");
			Hud:AddMessage("==================UNACCEPTABLE ERROR====================");
		end
	end,
	--------------------------------------------------
	SWITCH_TO_ABBERATION_ATTACK = function ( self, entity, sender)
		entity:SelectPipe(0,"mutant_screwed_attack");
	end,
	--------------------------------------------------

}