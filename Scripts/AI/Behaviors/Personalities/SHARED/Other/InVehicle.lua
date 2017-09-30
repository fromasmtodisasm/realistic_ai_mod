--------------------------------------------------
--    Created By: Petar
--   Description: 	This gets called when the guy knows something has happened (he is getting shot at, does not know by whom), or he is hit. Basically
--  			he doesnt know what to do, so he just kinda sticks to cover and tries to find out who is shooting him
--------------------------
--

AIBehaviour.InVehicle = {
	Name = "InVehicle",
	NOPREVIOUS = 1,

	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSelected = function( self, entity )	
	end,
	---------------------------------------------
	OnSpawn = function( self, entity )

	end,
	---------------------------------------------
	OnActivate = function( self, entity )
		-- called when enemy receives an activate event (from a trigger, for example)
	end,
	---------------------------------------------
	OnNoTarget = function( self, entity )
	
		AI:Signal(SIGNALFILTER_GROUPONLY, 1, "GunnerLostTarget",entity.id);
		
		--System:Log("\001 gunner in vehicle lost target ");
		-- called when the enemy stops having an attention target
	end,
	---------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )
	
printf("InVehicle   ---  on player seen -----------------------------------")	
		-- called when the enemy sees a living player
	end,
	---------------------------------------------
	OnEnemySeen = function( self, entity )
		-- called when the enemy sees a foe which is not a living player
	end,
	---------------------------------------------
	OnFriendSeen = function( self, entity )
		-- called when the enemy sees a friendly target
	end,
	---------------------------------------------
	OnDeadBodySeen = function( self, entity )
		-- called when the enemy a dead body
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
	OnGroupMemberDied = function( self, entity )
		-- called when a member of the group dies
	end,
	OnGroupMemberDiedNearest = function ( self, entity, sender)
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
	---------------------------------------------
	OnCoverRequested = function ( self, entity, sender)
		-- called when the enemy is damaged
	end,
	--------------------------------------------------
	OnBulletRain = function ( self, entity, sender)
		-- called when the enemy detects bullet trails around him
	end,
	--------------------------------------------------
	OnDeath = function( self,entity )
		AI:Signal(SIGNALFILTER_GROUPONLY, 1, "OnGroupMemberDied",entity.id);	
		-- if driver killed - make all the passengers unignorant, get out/stop entering
		
		if(entity.theVehicle )	then
			local tbl = VC.FindUserTable( entity.theVehicle, entity );
			if( tbl and tbl.type == PVS_DRIVER ) then
				AI:Signal(SIGNALFILTER_GROUPONLY, -1, "MAKE_ME_UNIGNORANT",entity.id);		
			end
		end	
	end,
	
	---------------------------------------------
	---------------------------------------------	--------------------------------------------------
	-- CUSTOM
	--------------------------------------------
	exited_vehicle = function( self,entity, sender )

		AI:Signal(SIGNALID_READIBILITY, 2, "AI_AGGRESSIVE",entity.id);
		entity:TriggerEvent(AIEVENT_CLEAR);
		if(entity.HASBEACON == nil) then
			entity.EventToCall = "OnSpawn";	
		end
		if(entity.DriverKilled ~= nil) then
			local hit =	{
				dir = g_Vectors.v001,
				damage = 1,
				target = entity,
				shooter = entity,
				landed = 1,
				impact_force_mul_final=5,
				impact_force_mul=5,
				damage_type="healthonly",
			};
			entity:Damage( hit );
		end
	end,

	exited_vehicle_investigate = function( self,entity, sender )

		AI:Signal(SIGNALID_READIBILITY, 2, "AI_AGGRESSIVE",entity.id);	
		entity:TriggerEvent(AIEVENT_CLEAR);
		if(entity.HASBEACON == nil) then
			entity.EventToCall = "OnSpawn";	
		end
		if(entity.DriverKilled ~= nil) then
			local hit =	{
				dir = g_Vectors.v001,
				damage = 1,
				target = entity,
				shooter = entity,
				landed = 1,
				impact_force_mul_final=5,
				impact_force_mul=5,
				damage_type="healthonly",
			};
			entity:Damage( hit );
		end
	end,

	--------------------------------------------
	do_exit_vehicle = function( self,entity, sender )

--		entity:TriggerEvent(AIEVENT_ENABLE);
--		entity:SelectPipe(0,"reevaluate");
System:LogToConsole( "puppet -------------------------------- exited_vehicle " );
--		entity:SelectPipe(0,"standingthere");		
		
		AI:MakePuppetIgnorant(entity.id,0);
		entity:SelectPipe(0,"b_user_getout", entity:GetName().."_land");
		
--		Previous();
	end,


	--------------------------------------------
	do_exit_hely = function( self,entity, sender )

--		entity:TriggerEvent(AIEVENT_ENABLE);
--		entity:SelectPipe(0,"reevaluate");
--System:LogToConsole( "puppet -------------------------------- exited_vehicle " );
--		entity:SelectPipe(0,"standingthere");		
		
		if(entity.theVehicle and entity.theVehicle.Properties.pointReinforce) then
			entity:SelectPipe(0,"h_user_getout", entity.theVehicle.Properties.pointReinforce);
--System:LogToConsole( "\001 do_exit_hely  --------------------------------   "..entity.theVehicle.Properties.pointReinforce );
		else	
			entity:SelectPipe(0,"h_user_getout");
		end	
		
--		Previous();
	end,



	--------------------------------------------------
	SHARED_ENTER_ME_VEHICLE = function( self,entity, sender )
	
	-- in vehicle already - don't do anything

	end,

	--------------------------------------------
	desable_me = function( self,entity, sender )
		entity:TriggerEvent(AIEVENT_DISABLE);
	end,

	-- no need to run away from cars
	OnVehicleDanger = function(self,entity,sender)
	end,

}