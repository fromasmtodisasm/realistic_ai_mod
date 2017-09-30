--------------------------------------------------
--   Created By: Petar
--   Description: This is the combat behaviour of the Cover
--------------------------
--   modified by: sten 22-10-2002
--   modified amanda 02-11-19 moved roll animations to default.lua

AIBehaviour.CoverAttack = {
	Name = "CoverAttack",



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

	OnLeftLean  = function( self, entity, sender)
		if (entity.Properties.special==1) then 
			do return end
		end
		local rnd=random(1,10);
		if (rnd > 5) then 
			AI:Signal(0,1,"LEFT_LEAN_ENTER",entity.id);
		end
	end,
	---------------------------------------------
	OnRightLean  = function( self, entity, sender)
		if (entity.Properties.special==1) then 
			do return end
		end

		local rnd=random(1,10);
		if (rnd > 5) then 
			AI:Signal(0,1,"RIGHT_LEAN_ENTER",entity.id);
		end
	end,
	---------------------------------------------

	OnLowHideSpot = function( self, entity, sender)
		if (entity.Properties.special==1) then 
			do return end
		end

		entity:SelectPipe(0,"dig_in_attack");
	end,

	---------------------------------------------
	OnNoTarget = function( self, entity )
		entity:Readibility("ENEMY_TARGET_LOST"); -- you will go to alert from here
		entity:SelectPipe(0,"search_for_target");
	end,
	---------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )
		entity:Readibility("THREATEN",1);
		if (fDistance>10) then
			entity:SelectPipe(0,"cover_pindown");
		else
			entity:SelectPipe(0,"cover_scramble");
		end
	end,
	---------------------------------------------
	OnEnemyMemory = function( self, entity )
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function( self, entity )
		-- called when the enemy hears an interesting sound
		entity:Readibility("RELOADING",1);
		entity:SelectPipe(0,"seek_target");
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function( self, entity )
		-- called when the enemy hears a scary sound
	end,
	---------------------------------------------
	OnReload = function( self, entity )
		-- called when the enemy goes into automatic reload after its clip is empty
		entity:SelectPipe(0,"cover_scramble");
	end,
	---------------------------------------------
	OnGroupMemberDied = function( self, entity )
		-- called when a member of the group dies

		-- PETAR : Cover in attack should not care who died or not. He is too busy 
		-- watching over his own ass :)
	end,
	--------------------------------------------------
	OnGroupMemberDiedNearest = function ( self, entity, sender)
		AIBehaviour.DEFAULT:OnGroupMemberDiedNearest(entity,sender);	
	end,
	---------------------------------------------
	OnNoHidingPlace = function( self, entity, sender )
		-- select random attack pipe		
		NOCOVER:SelectAttack(entity);
		entity:Readibility("THREATEN",1);
	end,	
	---------------------------------------------
	OnReceivingDamage = function ( self, entity, sender)
		-- called when the enemy is damaged

		entity:SelectPipe(0,"cover_scramble");

		-- call default handling
		AIBehaviour.DEFAULT:OnReceivingDamage(entity,sender);
	end,
	--------------------------------------------------
	OnBulletRain = function ( self, entity, sender)
	end,
	--------------------------------------------------
	OnClipNearlyEmpty = function ( self, entity, sender)
		entity:SelectPipe(0,"cover_scramble");
	end,
	--------------------------------------------------
	-- CUSTOM SIGNALS
	--------------------------------------------------
	COVER_NORMALATTACK = function (self, entity, sender)
		entity:SelectPipe(0,"cover_pindown");
		entity:InsertSubpipe(0,"reload");
	end,
	---------------------------------------------
	AISF_GoOn = function (self, entity, sender)
		entity:SelectPipe(0,"cover_scramble");
	end,
	---------------------------------------------
	HEADS_UP_GUYS = function (self, entity, sender)
		-- do nothing on this signal
		entity.RunToTrigger = 1;
	end,
	---------------------------------------------
	INCOMING_FIRE = function (self, entity, sender)
		-- do nothing on this signal
	end,
	--------------------------------------------------
	-- GROUP SIGNALS
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