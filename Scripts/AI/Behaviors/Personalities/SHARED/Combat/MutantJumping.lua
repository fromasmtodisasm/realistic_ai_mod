--------------------------------------------------
--    Created By: Petar
--   Description: Enemy should not be disturbed by anything while running for reinforcements
--------------------------
--

AIBehaviour.MutantJumping = {
	Name = "MutantJumping",
	NOPREVIOUS = 1,

	---------------------------------------------
	OnNoTarget = function( self, entity )
		-- called when the enemy stops having an attention target
	end,
	---------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )
		-- called when the enemy sees a living player
	end,
	---------------------------------------------
	OnGrenadeSeen = function( self, entity, fDistance )
		-- called when the enemy sees a grenade
	end,
	---------------------------------------------
	OnEnemyMemory = function( self, entity )
		-- called when the enemy can no longer see its foe, but remembers where it saw it last
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
	OnGroupMemberDied = function( self, entity, sender)
		-- call the default to do stuff that everyone should do
	end,
	--------------------------------------------------
	OnGroupMemberDiedNearest = function ( self, entity, sender)
		-- call the default to do stuff that everyone should do
	end,
	---------------------------------------------
	OnNoHidingPlace = function( self, entity, sender )
		-- called when no hiding place can be found with the specified parameters
	end,	
	--------------------------------------------------
	OnNoFormationPoint = function ( self, entity, sender)
		-- called when the enemy found no formation point
	end,
	---------------------------------------------
	OnReceivingDamage = function ( self, entity, sender)
		-- called when the enemy is damaged
	end,
	--------------------------------------------------
	OnBulletRain = function ( self, entity, sender)
		-- called when the enemy detects bullet trails around him
	end,
	--------------------------------------------------

	--------------------------------------------------
	COVER_NORMALATTACK = function (self, entity, sender)
		-- dont handle this signal
	end,
	--------------------------------------------------
	COVER_RELAX = function (self, entity, sender)
		-- dont handle this signal
	end,
	--------------------------------------------------
	AISF_GoOn = function (self, entity, sender)
		-- dont handle this signal
	end,
	--------------------------------------------------


	---------------------------------------------
	JUMP_FINISHED = function (self, entity, sender)
		AI:Signal(0,1,"BACK_TO_ATTACK",entity.id);
	end,

	---------------------------------------------
	RETURN_TO_PREVIOUS = function (self, entity, sender)
		--entity:SelectPipe(0,"just_shoot");
		AI:Signal(0,1,"OnReload",entity.id);
	end,



	--------------------------------------------------
	HEADS_UP_GUYS = function (self, entity, sender)
		-- dont handle this signal
		entity.RunToTrigger = 1;
	end,
	---------------------------------------------
	INCOMING_FIRE = function (self, entity, sender)
		-- dont handle this signal
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





---  JUMPING RELATED
	----------------------------------

	---------------------------------------------
	START_DESIRED_ANIMATION = function ( self, entity, sender)

		if (self.fLastJumpDuration>0) then

			if (entity.AI_PreferredJumpAnimation==nil) then
				entity.AI_PreferredJumpAnimation= "jump_left_cart02";
			end	
		

			-- wait for the duration of the start-jump
			local JMPTable = entity.JumpSelectionTable[self.nDirectionOfJump][1]; 
			if (JMPTable) then

				if (JMPTable[2]>0) then
					AI:CreateGoalPipe("jump_start_delay");
					AI:PushGoal("jump_start_delay","timeout",1,JMPTable[2]);
					entity:InsertSubpipe(0,"jump_start_delay");
				end

				entity:StartAnimation(0,JMPTable[1],4);
			end	

			
		end
	end,


	---------------------------------------------
	SET_CORRECT_ANIMATION_SCALE = function ( self, entity, sender)
		if (self.fLastJumpDuration>0) then
			local AnimScale = 1;
			entity.cnt.AnimationSystemEnabled = 0;
			if (self.fLastJumpDuration) then
				local JMPTable = entity.JumpSelectionTable[self.nDirectionOfJump][1];  
				if (JMPTable) then
					local totalduration = JMPTable[3];
					AnimScale = totalduration/self.fLastJumpDuration*0.5;
				end
			end
	
			if (AnimScale>1.5) then 
				AnimScale = 1.5;
			end

			entity:SetAnimationSpeed(AnimScale);
		end
	end,
	---------------------------------------------
	RESET_JUMP_VARIABLES = function ( self, entity, sender)

		if (entity.JumpSelectionTable==nil) then
			System:Warning( "Entity "..entity:GetName().." does not have jump sel table.");
			do return end
		end

		-- wait for the duration of the start-jump
		local JMPTable = entity.JumpSelectionTable[self.nDirectionOfJump][1]; 
		if (JMPTable) then
			local anim_dur = entity:GetAnimationLength(JMPTable[1]);
			anim_dur = anim_dur - JMPTable[2] - JMPTable[3];
			AI:CreateGoalPipe("jump_end_delay");
			AI:PushGoal("jump_end_delay","timeout",1,anim_dur);
			entity:InsertSubpipe(0,"jump_end_delay");
			
		end	
		entity.cnt.AnimationSystemEnabled = 1;
		entity:SetAnimationSpeed(1);
	end,
}