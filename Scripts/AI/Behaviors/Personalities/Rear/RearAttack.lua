--------------------------------------------------
--   Created By: Petar
--   Description: Rear Combat Behavior
--------------------------
--

AIBehaviour.RearAttack = {
	Name = "RearAttack",


--	OnLeftLean  = function( self, entity, sender)
--		local rnd=random(1,10);
--		if (rnd > 5) then 
--			AI:Signal(0,1,"LEFT_LEAN_ENTER",entity.id);
--		end
--	end,
--	---------------------------------------------
--	OnRightLean  = function( self, entity, sender)
--		local rnd=random(1,10);
--		if (rnd > 5) then 
--			AI:Signal(0,1,"LEFT_LEAN_ENTER",entity.id);
--		end
--	end,
--	---------------------------------------------
--
--	---------------------------------------------
--	OnLowHideSpot = function( self, entity, sender)
--		entity:SelectPipe(0,"dig_in_attack");
--	end,
--

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
		-- called when the enemy stops having an attention target
		if (AI:GetGroupCount(entity.id) > 1) then	
			AI:Signal(SIGNALID_READIBILITY, AIREADIBILITY_LOST, "ENEMY_TARGET_LOST_GROUP",entity.id);	
		else
			AI:Signal(SIGNALID_READIBILITY, AIREADIBILITY_LOST, "ENEMY_TARGET_LOST",entity.id);	
		end	

	end,
	---------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )
		
		entity:SelectPipe(0,"protect_spot",entity:GetName().."_PROTECT");


		if (fDistance>8 and fDistance<30 and entity.cnt.numofgrenades>0) then 
			local rnd = random(1,10);
			if (rnd<3) then
				entity:InsertSubpipe(0,"rear_weaponAttack");
			else
				entity:InsertSubpipe(0,"rear_grenadeAttack");
			end
		else
			entity:InsertSubpipe(0,"rear_weaponAttack");
		end


	end,
	---------------------------------------------
	OnEnemyMemory = function( self, entity )
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function( self, entity )
		-- called when the enemy hears an interesting sound
		entity:SelectPipe(0,"rear_scramble");
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function( self, entity )
		-- called when the enemy hears a scary sound
		entity:SelectPipe(0,"rear_scramble");
	end,
	---------------------------------------------
	OnClipNearlyEmpty = function( self, entity )
		-- called when the enemy goes into automatic reload after its clip is empty
		entity:SelectPipe(0,"rear_scramble");
	end,
	---------------------------------------------
	OnReload = function ( self, entity, sender)
		-- called when the AI has low ammo
		-- entity:SelectPipe(0,"low_ammo");
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
		if (entity.DROP_GRENADE==nil) then
			entity:SelectPipe(0,"rear_scramble");
		else
			entity:InsertSubpipe(0,"take_cover");
		end
		
	end,
	---------------------------------------------
	OnBulletRain = function ( self, entity, sender)
		-- called when the enemy is damaged
	end,
	---------------------------------------------
	OnCoverRequested = function ( self, entity, sender)
		-- called when the enemy is damaged
	end,
	---------------------------------------------
	OnDeath = function ( self, entity, sender)
		-- called when the enemy is killed
		-- call default processing
		AIBehaviour.DEFAULT:OnDeath(entity,sender);

		if (entity.DROP_GRENADE) then
			local gnd = Server:SpawnEntity("ProjFlashbangGrenade");
			if (gnd) then
				gnd:Launch(nil,entity,entity:GetPos(),{x=0,y=0,z=0},{x=0,y=0,z=-0.001});
			end
		end
	end,
		---------------------------------------------
	OnGrenadeSeen = function( self, entity, fDistance )
		-- called when the enemy sees a grenade
		--System:LogToConsole("+++++++++++++++++++++++++++OnGrenadeSeen");
		AI:Signal(SIGNALID_READIBILITY, 1, "GRENADE_SEEN",entity.id);
		entity:InsertSubpipe(0,"grenade_run_hide");
	end,
	---------------------------------------------
	
	
	--------------------------------------------------
	-- CUSTOM SIGNALS
	--------------------------------------------------
	EXCHANGE_AMMO = function (self, entity,sender)
	--rear guard within throw range so throw

		entity:StartAnimation(0,"sgrenade",1);
	end,
	---------------------------------------------
	GRANADE_OUT = function (self, entity, sender)
		entity.DROP_GRENADE = nil;
	end,
	---------------------------------------------	
	REAR_NORMALATTACK = function (self, entity, sender)

		entity:SelectPipe(0,"rear_comeout");

		entity.DROP_GRENADE = nil;
	end,
	---------------------------------------------	
	REAR_SELECTATTACK = function (self, entity, sender)
	end,
	--------------------------------------------------
	----------------- GROUP SIGNALS ------------------
	--------------------------------------------------
	HEADS_UP_GUYS = function (self, entity, sender)
		entity.RunToTrigger = 1;
	end,
	---------------------------------------------
	OnGroupMemberDied = function( self, entity, sender)
	end,
	--------------------------------------------------
	OnGroupMemberDiedNearest = function ( self, entity, sender)
	end,
	--------------------------------------------------
	KEEP_FORMATION = function (self, entity, sender)
		-- the team leader wants everyone to keep formation
	end,
	---------------------------------------------	
	BREAK_FORMATION = function (self, entity, sender)
		-- the team can split
	end,
	---------------------------------------------	
	SINGLE_GO = function (self, entity, sender)
		-- the team leader has instructed this group member to approach the enemy
	end,
	---------------------------------------------	
	GROUP_COVER = function (self, entity, sender)
		-- the team leader has instructed this group member to cover his friends
	end,
	---------------------------------------------	
	IN_POSITION = function (self, entity, sender)
		-- some member of the group is safely in position
	end,
	---------------------------------------------	
	GROUP_SPLIT = function (self, entity, sender)
		-- team leader instructs group to split
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
	---------------------------------------------	
	CLOSE_IN_PHASE = function (self, entity, sender)
		-- team leader instructs groups to initiate part one of assault fire maneuver
	end,
	---------------------------------------------	
	ASSAULT_PHASE = function (self, entity, sender)
		-- team leader instructs groups to initiate part one of assault fire maneuver
	end,
	---------------------------------------------	
	GROUP_NEUTRALISED = function (self, entity, sender)
		-- team leader instructs groups to initiate part one of assault fire maneuver
	end,
}