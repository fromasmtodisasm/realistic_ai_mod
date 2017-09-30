--------------------------------------------------
--   Created By: Sten
--   Description: Rear Alert
--------------------------

AIBehaviour.RearAlert = {
	Name = "RearAlert",

	---------------------------------------------
	OnNoTarget = function( self, entity )
		-- called when the enemy stops having an attention target
--		entity:MakeIdle();
--		entity:SelectPipe(0,"disturbance_let_it_go");
--		entity:InsertSubpipe(0,"HOLSTER_GUN");
--		entity:InsertSubpipe(0,"random_timeout");
	end,
	---------------------------------------------		
	OnPlayerSeen = function( self, entity, fDistance )
		-- called when the enemy sees a living player
		

		entity:Readibility("ENEMY_TARGET_REGAIN");
		entity:SelectPipe(0,"rear_scramble");


		if (entity.RunToTrigger == nil) then
			entity:RunToAlarm();
		end
		
		if (AI:GetGroupCount(entity.id) > 1) then
			AI:Signal(SIGNALFILTER_SUPERGROUP, 1, "wakeup",entity.id);
			AI:Signal(SIGNALFILTER_SUPERGROUP, 1, "HEADS_UP_GUYS",entity.id);
			entity:InsertSubpipe(0,"DropBeaconAt"); -- in PipeManagerShared.lua
		end	


		
	end,
	---------------------------------------------
	OnEnemyMemory = function( self, entity )
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function( self, entity )
		-- called when the enemy hears an interesting sound
	 	entity:InsertSubpipe(0,"DropBeaconTarget"); -- in PipeManagerShared.lua
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function( self, entity )
		-- called when the enemy hears a scary sound
--		entity:SelectPipe(0,"rear_grenadeAttack");
		entity:SelectPipe(0,"rear_comeout");
		entity:InsertSubpipe(0,"DropBeaconAt"); -- in PipeManagerShared.lua
		entity:Blind_RunToAlarm();
	end,
	---------------------------------------------
	OnReload = function( self, entity )
		-- called when the enemy goes into automatic reload after its clip is empty
	end,
	--------------------------------------------------
	OnNoHidingPlace = function( self, entity, sender )
		-- called when no hiding place can be found with the specified parameters
	end,
	---------------------------------------------
	OnBulletRain = function ( self, entity, sender)	
	end,
	---------------------------------------------
	OnReceivingDamage = function ( self, entity, sender)
	end,
	--------------------------------------------------
	OnGrenadeSeen = function( self, entity, fDistance )
		entity:InsertSubpipe(0,"grenade_run_away");
	end,
	--------------------------------------------------
	-- CUSTOM SIGNALS
	--------------------------------------------------
	Cease = function( self, entity, fDistance )
		entity:SelectPipe(0,"rear_cease_investigation"); -- in PipeManagerShared.lua			 
	end,
	---------------------------------------------
	OnGroupMemberDied = function( self, entity, sender)
		-- called when a member of the group dies
		--System:LogToConsole(entity:GetName().." recieved OnGroupMemberDied signal in RearIdle");
		entity:MakeAlerted();
				
		if (entity ~= sender) then
		 	entity:SelectPipe(0,"rear_goforcover");
		end
	end,
	--------------------------------------------------
	OnGroupMemberDiedNearest = function ( self, entity, sender)
		--System:LogToConsole(entity:GetName().." recieved OnGroupMemberDiedNearest signal in CoverIdle");

		entity:MakeAlerted();

		-- DO NOT TOUCH THIS READIBILITY SIGNAL	---------------------------
		AI:Signal(SIGNALID_READIBILITY, 1, "FRIEND_DEATH",entity.id);
		-------------------------------------------------------------------
		
		-- bounce the dead friend notification to the group (you are going to investigate it)
		AI:Signal(SIGNALFILTER_SPECIESONLY, 1, "OnGroupMemberDied",entity.id);

		entity:SelectPipe(0,"rear_goforcover");
	end,
	--------------------------------------------------
	----------------- GROUP SIGNALS ------------------
	--------------------------------------------------
	HEADS_UP_GUYS = function (self, entity, sender)
		if (entity ~= sender) then
			entity:MakeAlerted();
			entity:SelectPipe(0,"rear_headup");
		end
		entity.RunToTrigger = 1;
	end,

	REAR_NORMALATTACK = function (self, entity, sender)
		entity.DROP_GRENADE = nil;
		entity:SelectPipe(0,"rear_interesting_sound"); 
	end,
	---------------------------------------------
	INCOMING_FIRE = function (self, entity, sender)
	end,
	------------------------------------------------------------------------
	------------------------------ Animation -------------------------------
	target_lost_animation = function (self, entity, sender)
		entity:StartAnimation(0,"sSoundheard",0);
	end,
	------------------------------------------------------------------------
	confused_animation = function (self, entity, sender)
		entity:StartAnimation(0,"_chinrub",0);
	end,
	------------------------------------------------------------------------
}