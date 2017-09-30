--------------------------------------------------
--    Created By: Petar
--   Description: Attack behaviour for the Scout personality
--------------------------
--

AIBehaviour.ScoutAttack = {
	Name = "ScoutAttack",
	Direction = 0,


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
		entity:Readibility("ENEMY_TARGET_LOST");
		entity:SelectPipe(0,"scout_hunt_beacon");
	end,
	---------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )

		if (entity.AI_Flanking) then 
			do return end;
		end

		entity:Readibility("THREATEN",1);
		
		if (AI:GetGroupCount(entity.id) > 1) then
			-- only send this signal if you are not alone
			AI:Signal(SIGNALFILTER_SUPERGROUP, 1, "wakeup",entity.id);
			AI:Signal(SIGNALFILTER_SUPERGROUP, 1, "HEADS_UP_GUYS",entity.id);

			if (fDistance<15) then
				entity:SelectPipe(0,"scout_tooclose_attack_beacon");
			else
				entity:SelectPipe(0,"scout_scramble_beacon");
			end

		else
			-- you are on your own
			if (fDistance<15) then
				entity:SelectPipe(0,"scout_tooclose_attack");
			else
				self:SCOUT_NORMALATTACK(entity);
				--AI:Signal(0,1,"SCOUT_NORMALATTACK",entity.id);
			end
		end

	end,
	---------------------------------------------
	OnEnemyMemory = function( self, entity )	
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function( self, entity )
		-- called when the enemy hears an interesting sound
		entity:SelectPipe(0,"scout_scramble");
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function( self, entity )
		-- called when the enemy hears a scary sound
		entity:SelectPipe(0,"scout_scramble");
	end,
	---------------------------------------------
	OnReload = function( self, entity )
		-- called when the enemy goes into automatic reload after its clip is empty
		--entity:SelectPipe(0,"scout_scramble");
	end,
	---------------------------------------------
	OnClipNearlyEmpty = function(self,entity )
		entity:SelectPipe(0,"scout_cover_NOW");
	end,
	---------------------------------------------
	OnGroupMemberDied = function( self, entity )
		-- dont handle this
	end,
	---------------------------------------------
	OnGroupMemberDiedNearest = function( self, entity )
		-- dont handle this
	end,
	---------------------------------------------
	OnNoHidingPlace = function( self, entity, sender )
		-- called when no hiding place can be found with the specified parameters
		self:SCOUT_NORMALATTACK(entity);
	end,	
	---------------------------------------------
	OnReceivingDamage = function ( self, entity, sender)
		entity:SelectPipe(0,"scout_cover_NOW");
	end,
	--------------------------------------------------
	OnBulletRain = function (self,entity, sender)
	end,


	OnGrenadeSeen = function( self, entity, fDistance )
		-- called when the enemy sees a grenade
		entity:Readibility("GRENADE_SEEN",1);
		entity:InsertSubpipe(0,"grenade_run_away");
	end,
	--------------------------------------------------
				

	-- CUSTOM
	---------------------------------------------------------
	SCOUT_NORMALATTACK = function ( self, entity, sender)
		entity.AI_Flanking = nil;
		local rnd = random(1,40);
		if (rnd<10) then
			entity:SelectPipe(0,"scout_attack_far");
		elseif (rnd<20) then
			entity:SelectPipe(0,"scout_comeout");
		elseif (rnd<30) then
			entity.AI_Flanking = 1;
			entity:SelectPipe(0,"scout_attack_left");
		else	
			entity.AI_Flanking = 1;
			entity:SelectPipe(0,"scout_attack_right");
		end
	end,

	START_HUNTING = function ( self, entity, sender)
		entity:SelectPipe(0,"scout_hunt");	 
		entity:InsertSubpipe(0,"scout_dropebeacon_and_target");		
	end,


	---------------------------------------------
	INCOMING_FIRE = function (self, entity, sender)
	end,
	---------------------------------------------
	HEADS_UP_GUYS = function (self, entity, sender)
		entity.RunToTrigger = 1;
	end,

	-- GROUP SIGNALS
	---------------------------------------------	
	KEEP_FORMATION = function (self, entity, sender)
		-- the team leader wants everyone to keep formation
	end,
	---------------------------------------------	
	BREAK_FORMATION = function (self, entity, sender)
		-- the team can split
	end,
	---------------------------------------------	
	IN_POSITION = function (self, entity, sender)
		-- some member of the group is safely in position
	end,
	---------------------------------------------	
	PHASE_RED_ATTACK = function (self, entity, sender)
		-- team leader instructs red team to attack
	end,
	---------------------------------------------	
	PHASE_BLACK_ATTACK = function (self, entity, sender)
		-- team leader instructs black team to attack
	end,
	---------------------------------------------	
	GROUP_MERGE = function (self, entity, sender)
		-- team leader instructs groups to merge into a team again
	end,
}