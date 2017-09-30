-- Default behaviour - implements all the system callbacks and does something
-- this is so that any enemy has a behaviour to fallback to
--------------------------
-- DO NOT MODIFY THIS BEHAVIOUR

AIBehaviour.DEFAULT = {
	Name = "DEFAULT",



	HIDE_FROM_BEACON = function ( self, entity, sender)
		entity:InsertSubpipe(0,"hide_from_beacon");
	end,

	DESTROY_THE_BEACON = function ( self, entity, sender)
		if (entity.cnt.numofgrenades>0) then 
			local rnd=random(1,4);
			if (rnd>2) then 
				entity:InsertSubpipe(0,"shoot_the_beacon");
			else
				entity:InsertSubpipe(0,"bomb_the_beacon");
			end
		else
			entity:InsertSubpipe(0,"shoot_the_beacon");
		end
	end,

	OnFriendInWay = function ( self, entity, sender)
		local rnd=random(1,4);
		entity:InsertSubpipe(0,"friend_circle");
	end,

	
	MAKE_ME_IGNORANT = function ( self, entity, sender)
		AI:MakePuppetIgnorant(entity.id,1);
	end,
	
	MAKE_ME_UNIGNORANT = function ( self, entity, sender)
		AI:MakePuppetIgnorant(entity.id,0);
	end,

	-- cool retreat tactic
	RETREAT_NOW = function ( self, entity, sender)

		local retreat_spot = AI:FindObjectOfType(entity.id,100,AIAnchor.RETREAT_HERE);
		if (retreat_spot) then 
			entity:SelectPipe(0,"retreat_to_spot",retreat_spot);
		else
			entity:SelectPipe(0,"retreat_back");
		end
		entity:Readibility("RETREATING_NOW",1);
	end,

	RETREAT_NOW_PHASE2 = function ( self, entity, sender)

		local retreat_spot = AI:FindObjectOfType(entity.id,100,AIAnchor.RETREAT_HERE);
		if (retreat_spot) then 
			entity:SelectPipe(0,"retreat_to_spot_phase2",retreat_spot);
		else
			entity:SelectPipe(0,"retreat_back_phase2");
		end
	
		entity:Readibility("RETREATING_NOW",1);
	end,

	PROVIDE_COVERING_FIRE = function ( self, entity, sender)
		entity:SelectPipe(0,"dumb_shoot");
		entity:Readibility("PROVIDING_COVER",1);
	end,

	-- cool rush tactic
	RUSH_TARGET = function ( self, entity, sender)
		entity:SelectPipe(0,"rush_player");
		entity:Readibility("AI_AGGRESSIVE",1);

	end,

	STOP_RUSH = function ( self, entity, sender)
		entity:TriggerEvent(AIEVENT_CLEAR);
	end,
	

	START_SWIMMING = function ( self, entity, sender)
		AI:MakePuppetIgnorant(entity.id,1);
		entity:SelectPipe(0,"swim_inplace");

		if (entity.MUTANT) then
			entity:InsertAnimationPipe("drown00",2,"NOW_DIE",0.15,0.8);
		else
			local dh = AI:FindObjectOfType(entity:GetPos(),30,AIAnchor.SWIM_HERE);
	
			if (dh) then
				entity:InsertSubpipe(0,"swim_to",dh);
			end
		end
	end,

	GO_INTO_WAIT_STATE = function ( self, entity, sender)
		entity:SelectPipe(0,"wait_state");
	end,

	SPECIAL_FOLLOW = function (self, entity, sender)
		entity.AI_SpecialBehaviour = "SPECIAL_FOLLOW";
		entity:SelectPipe(0,"val_follow");
		entity:Readibility("FOLLOWING_PLAYER",1);
		AI:MakePuppetIgnorant(entity.id,0);
	end,

	SPECIAL_GODUMB = function (self, entity, sender)

		if (entity.AI_DynProp) then
			entity.AI_DynProp.push_players = 0;
			entity.AI_DynProp.pushable_by_players = 0;
			entity.cnt:SetDynamicsProperties( entity.AI_DynProp );
		end
		entity.AI_SpecialBehaviour = "SPECIAL_GODUMB";
		entity:DoSomethingInteresting();
		AI:MakePuppetIgnorant(entity.id,1);
	end,

	SPECIAL_STOPALL = function (self, entity, sender)
		entity.AI_SpecialBehaviour = nil;
		--entity.EventToCall = "OnSpawn";
		entity:SelectPipe(0,"standingthere");
		AI:MakePuppetIgnorant(entity.id,0);
	end,

	SPECIAL_LEAD = function (self, entity, sender)
		entity.AI_SpecialBehaviour = "SPECIAL_LEAD";
		entity:SelectPipe(0,"standingthere");
		entity.LEADING = nil;
		entity.EventToCall = "OnCloseContact";
		entity:Readibility("LETS_CONTINUE",1);
		AI:MakePuppetIgnorant(entity.id,0);
	end,

	SPECIAL_HOLD = function (self, entity, sender)
		entity.AI_SpecialBehaviour = "SPECIAL_HOLD";
		local spot = AI:FindObjectOfType(entity:GetPos(),50,AIAnchor.SPECIAL_HOLD_SPOT);
		if (spot == nil) then 
			Hud:AddMessage("========================== UNACCEPTABLE ERROR ====================");
			Hud:AddMessage("No SPECIAL_HOLD_SPOT anchor for entity "..entity:GetName());
			Hud:AddMessage("========================== UNACCEPTABLE ERROR ====================");
		end
		entity:SelectPipe(0,"hold_spot",spot);
		AI:MakePuppetIgnorant(entity.id,0);
	end,


	CANNOT_RESUME_SPECIAL_BEHAVIOUR = function(self,entity,sender)
		if (entity.AI_SpecialBehaviour) then
			entity:Readibility("THERE_IS_STILL_SOMEONE",1);
		end
	end,

	RESUME_SPECIAL_BEHAVIOUR = function(self,entity,sender)
		if (entity.AI_SpecialBehaviour) then
			entity:TriggerEvent(AIEVENT_CLEARSOUNDEVENTS);
			AI:Signal(0,1,entity.AI_SpecialBehaviour,entity.id);
		end
	end,

	--- Everyone is now able to respond to reinforcements
	---------------------------------------------
	AISF_CallForHelp = function ( self, entity, sender)
		local guy_should_reinforce = AI:FindObjectOfType(entity.id,5,AIAnchor.RESPOND_TO_REINFORCEMENT);		
		if (guy_should_reinforce) then 
			--AI:Signal(0,1,"SWITCH_TO_RUN_TO_FRIEND",entity.id);
			entity:MakeAlerted();
			entity:SelectPipe(0,"cover_beacon_pindown");
			entity:InsertSubpipe(0,"offer_join_team_to",sender.id);
			if (entity.AI_GunOut==nil) then
				entity:InsertSubpipe(0,"DRAW_GUN");	
			end
		end
	end,
	---------------------------------------------


	APPLY_IMPULSE_TO_ENVIRONMENT = function(self,entity,sender)
		entity:InsertAnimationPipe("kick_barrel");
		entity.ImpulseParameters.pos = entity:GetPos();
		entity.ImpulseParameters.pos.z = entity.ImpulseParameters.pos.z-1;
		entity:ApplyImpulseToEnvironment(entity.ImpulseParameters);
	end,


	OnVehicleDanger = function(self,entity,sender)
		entity:InsertSubpipe(0,"backoff_from_lastop",sender.id);
	end,

	HIDE_END_EFFECT = function(self,entity,sender)
		entity:StartAnimation(0,"rollfwd",4);
	end,

	Smoking = function(self,entity,sender)
		entity.EventToCall = "OnSpawn";
	end,

	YOU_ARE_BEING_WATCHED = function(self,entity,sender)
		
	end,


	LEFT_LEAN_ENTER = function(self,entity,sender)
		entity:SelectPipe(0,"lean_left_attack");
	end,

	RIGHT_LEAN_ENTER = function(self,entity,sender)
		entity:SelectPipe(0,"lean_right_attack");
	end,


	SWITCH_TO_MORTARGUY = function(self,entity,sender)
		local mounted = AI:FindObjectOfType(entity:GetPos(),200,AIAnchor.USE_THIS_MOUNTED_WEAPON);		
		if (mounted) then
			entity.AI_AtWeapon=nil;
			entity:SelectPipe(0,"goto_mounted_weapon",mounted);
		end

	end,


	RETURN_TO_FIRST = function( self, entity, sender )
		entity.EventToCall = "OnSpawn";	
		entity:Readibility("INTERESTED_TO_IDLE");
	end,

	-- Everyone has to be able to warn anyone around him that he died
	--------------------------------------------------
	OnDeath = function ( self, entity, sender)

		if (AI:GetGroupCount(entity.id) == 2) then
			-- tell nearest to you to go to reinforcement
			AI:Signal(SIGNALFILTER_NEARESTINCOMM, 1, "GoForReinforcement",entity.id);
		end
		-- tell your friends that you died anyway regardless of wheteher someone goes for reinforcement

		if (AI:GetGroupCount(entity.id) > 0) then
			-- tell your nearest that someone you have died only if you were not the only one
			AI:Signal(SIGNALFILTER_NEARESTINCOMM, 1, "OnGroupMemberDiedNearest",entity.id); 
		else
			-- tell anyone that you have been killed, even outside your group
			AI:Signal(SIGNALFILTER_ANYONEINCOMM, 1, "OnSomebodyDied",entity.id);
		end
		
	end,


	-- What everyone has to do when they get a notification that someone died
	--------------------------------------------------
	OnGroupMemberDiedNearest = function ( self, entity, sender)

		if (entity.ai) then 
			entity:MakeAlerted();

			entity:Readibility("FRIEND_DEATH",1);
			entity:InsertSubpipe("DropBeaconAt",sender.id);

			-- bounce the dead friend notification to the group (you are going to investigate it)
			AI:Signal(SIGNALFILTER_GROUPONLY, 1, "OnGroupMemberDied",entity.id);
		else
			-- vehicle bounce the signals further
			AI:Signal(SIGNALFILTER_NEARESTINCOMM, 1, "OnGroupMemberDiedNearest",entity.id);
		end
	end,

	---------------------------------------------
	OnGroupMemberDied = function( self, entity, sender)
		entity:MakeAlerted();
		entity:InsertSubpipe(0,"DRAW_GUN");
		entity:InsertSubpipe(0,"setup_combat");
	end,

	-- reinforcements work the same for everyone
	--------------------------------------------------
	GoForReinforcement = function ( self, entity, sender)
		local ReinforcePoint = AI:FindObjectOfType(entity.id,100,AIAnchor.AIANCHOR_REINFORCEPOINT);


		if (ReinforcePoint) then 


			entity:ChangeAIParameter(AIPARAM_GROUPID,999);			

			entity:Readibility("GET_REINFORCEMENTS",1);
			entity:TriggerEvent(AIEVENT_DROPBEACON);

			-- make myself change behaviour to ignore everything
			AI:Signal(0, 1, "IGNORE_ALL_ELSE",entity.id);
		
			entity:SelectPipe(0,"AIS_GoForReinforcement",ReinforcePoint);
			if (entity.AI_GunOut==nil) then	
				entity:InsertSubpipe(0,"DRAW_GUN");
			end
		end
	end,

	MAKE_REINFORCEMENT_ANIM = function(self,entity,sender)
		
		if (AI:FindObjectOfType(entity.id,10,AIAnchor.USE_RADIO_ANIM)) then
			local rnd=random(1,2);
			entity:InsertAnimationPipe("reinforcements_hutradio"..rnd,3);
		else
			AI:Signal(SIGNALID_READIBILITY, 1, "CALL_REINFORCEMENTS",entity.id);
		end
	end,

	-- and everyone has to be able to respond to an invitation to join a group
	--------------------------------------------------
	JoinGroup = function (self, entity, sender)
		entity:ChangeAIParameter(AIPARAM_GROUPID,AI:GetGroupOf(sender.id));
		entity:SelectPipe(0,"AIS_LookForThreat");
	end,

	UNCONDITIONAL_JOIN = function (self, entity, sender)
		entity:ChangeAIParameter(AIPARAM_GROUPID,AI:GetGroupOf(sender.id));
	end,


	CONVERSATION_START = function (self,entity, sender)
		if (entity.CurrentConversation) then 
			entity.CurrentConversation:Start();
		end
	end,

	
	--------------------------------------------------
	CONVERSATION_REQUEST = function (self,entity, sender)

		if (sender and (entity~=sender)) then	
			if (sender.CurrentConversation:Join(entity)) then
				entity:SelectPipe(0,"stand_timer",sender.id);
				entity:InsertSubpipe(0,"simple_approach_to",sender.id);
				AI:Signal(0,1,"CONVERSATION_REQUEST",sender.id);
			end
		end
	end,

	--------------------------------------------------
	CONVERSATION_REQUEST_INPLACE = function (self,entity, sender)

		if (sender and (entity~=sender)) then	
			if (sender.CurrentConversation:Join(entity)) then
				AI:Signal(0,1,"CONVERSATION_REQUEST_INPLACE",sender.id);
				entity.CurrentConversation:Start();
			end
		end
	end,

	--------------------------------------------------
	OFFER_JOIN_TEAM  = function (self,entity, sender)
		if (entity~=sender) then	
			if (AI:GetGroupOf(entity.id) ~= AI:GetGroupOf(sender.id)) then
				entity:ChangeAIParameter(AIPARAM_GROUPID,AI:GetGroupOf(sender.id));
			end
		end
	end,

	---------------------------------------------	
	SELECT_RED = function (self, entity, sender)
		-- team leader instructs group to split
		if (sender) then
			sender.redteammembers = sender.redteammembers + 1;
		end
		entity:MakeAlerted();
		entity:SelectPipe(0,"look_at_beacon");
	
	end,
	---------------------------------------------	
	SELECT_BLACK = function (self, entity, sender)
		-- team leader instructs group to split
		if (sender) then
			sender.blackteammembers = sender.blackteammembers + 1;
		end
		entity:MakeAlerted();
		entity:SelectPipe(0,"look_at_beacon");
	
	end,


	--------------------------------------------------	
	SHARED_RELOAD = function (self,entity, sender)
		if (entity.cnt) then
			if (entity.cnt.ammo_in_clip) then
				if (entity.cnt.ammo_in_clip > 5) then
					do return end
				end
			end
		end


		AI:CreateGoalPipe("reload_timeout");
		AI:PushGoal("reload_timeout","timeout",1,entity:GetAnimationLength("reload"));
		entity:InsertSubpipe(0,"reload_timeout");

		entity:StartAnimation(0,"reload",4);
--		if (AI:GetGroupCount(entity.id) > 1) then
--			AI:Signal(SIGNALID_READIBILITY, 1, "RELOADING",entity.id);
--		end
		BasicPlayer.Reload(entity);	
	end,

	--------------------------------------------------
	SHARED_GRENADE_THROW_OR_NOT = function(self,entity,sender)
		entity:InsertSubpipe(0,"unconditional_grenade");
	end,

	--------------------------------------------------
	SHARED_GRANATE_THROW_ANIM = function(self,entity,sender)
		entity:StartAnimation(0,"grenade",4);
		entity.DROP_GRENADE = 1;
	end,

	--------------------------------------------------
	SHARED_PLAYLEFTROLL = function(self,entity,sender)
		entity:StartAnimation(0,"rollleft",3);
	end,

	--------------------------------------------------
	SHARED_PLAYRIGHTROLL = function(self,entity,sender)
		entity:StartAnimation(0,"rollright",3);
	end,

	--------------------------------------------------
	SHARED_TAKEOUTPIN = function(self,entity,sender)
		entity:StartAnimation(0,"signal_inposition",3);
	end,

	------------------------------ Animation -------------------------------
	death_recognition = function (self, entity, sender)
		local XRandom = random(1,3)
		if (XRandom == 1) then
			entity:StartAnimation(0,"death_recognition1");
		elseif (XRandom == 2) then
			entity:StartAnimation(0,"death_recognition2");
		elseif (XRandom == 3) then
			entity:StartAnimation(0,"death_recognition3");
		end
	end,
	---------------------------------------------		
	PlayRollLeftAnim = function (self, entity, sender)
		entity:StartAnimation(0,"rollleft",3);
	end,
	------------------------------------------------------------------------
	PlayRollRightAnim = function (self, entity, sender)
		entity:StartAnimation(0,"rollright",3);
	end,
	

	--------------------------------------------------
	SHARED_ENTER_ME_VEHICLE = function( self,entity, sender )


		if( entity.ai == nil ) then return end
		self:SPECIAL_STOPALL(entity,sender);

		local vehicle = sender;
		if (vehicle) then
			
			-- not enter hevicle if there is a human driver inside
			if(vehicle.driverT and vehicle.driverT.entity and (not vehicle.driverT.entity.ai)) then return end
			

			if( vehicle:AddDriver(entity)==1 ) then				-- try to be driver			
				AI:Signal(0, 1, "entered_vehicle",entity.id);
				do return end	
			elseif( vehicle:AddGunner(entity)==1 ) then		-- if not driver - try to be gunner			
				AI:Signal(0, 1, "entered_vehicle",entity.id);
				do return end	
			elseif( vehicle:AddPassenger(entity)==1 ) then				-- if not gunner - try to be passenger
				AI:Signal(0, 1, "entered_vehicle",entity.id);
				do return end	
			end
		end
	end,

	---------------------------------------------
	at_boatenterspot = function(self,entity,sender)

System:Log(">>>>>>>>>>> DEFAULT  at_boatenterspot "..entity:GetName().."  "..entity.theVehicle:GetName());

		entity.theVehicle:DoEnter( entity );
		

		
		-- entity:StartAnimation(0,"arm_on_shoulder",1,0.4);
	end,

	---------------------------------------------
	OnNoAmmo = function( self, entity, sender)
--		entity.cnt:SelectNextWeapon();
	end,

	---------------------------------------------
	OnReceivingDamage = function(self,entity,sender)
	end,

	------------------------------------------------------	
	-- ANIMATION CONTROL FOR GETTING DOWN AND UP BETWEEN STANCES
	DEFAULT_CURRENT_TO_CROUCH = function( self, entity, sender)
		-- this doesn't have an animation from any stance
	end,
	------------------------------------------------------
	DEFAULT_CURRENT_TO_PRONE = function( self, entity, sender)
		-- this doesn't have an animation from crouch
		if ((entity.cnt.crouching==nil) and (entity.cnt.proning==nil)) then
			-- the guy was standing, so play animation getdown
			entity:StartAnimation(0,"pgetdown");
		end
	end,
	------------------------------------------------------
	DEFAULT_CURRENT_TO_STAND = function( self, entity, sender)
		-- this doesn't have an animation from crouch
		if (entity.cnt.proning) then 
			entity:StartAnimation(0,"pgetup");
		end
	end,
	------------------------------------------------------
	DEFAULT_GO_KNEEL = function( self, entity, sender)
		-- this doesn't have an animation from any stance
	--	if ((entity.cnt.crouching==nil) and (entity.cnt.proning==nil)) then
			-- the guy was standing, so play animation to kneeldown

			entity:StartAnimation(0,"kneel_start",2);
			entity:StartAnimation(0,"kneel_idle_loop");
	--	end
	end,
	------------------------------------------------------
	DEFAULT_UNKNEEL = function( self, entity, sender)
		-- this doesn't have an animation from any stance
	--	if ((entity.cnt.crouching==nil) and (entity.cnt.proning==nil)) then
			entity:StartAnimation(0,"sidle");
			entity:StartAnimation(0,"kneel_end",2);
	--	end
	end,
	------------------------------------------------------

	GO_REFRACTIVE  = function(self,entity,sender)
		entity:GoRefractive();	
	end,
	------------------------------------------------------
	GO_VISIBLE  = function(self,entity,sender)
		entity:GoVisible();
	end,



	FLASHLIGHT_ON = function(self,entity,sender)	
		entity.cnt:SwitchFlashLight(1);
		entity:ChangeAIParameter(AIPARAM_SIGHTRANGE,entity.PropertiesInstance.sightrange*3);
		entity:ChangeAIParameter(AIPARAM_FOV,60);		
	end,
	FLASHLIGHT_OFF  = function(self,entity,sender)
		entity.cnt:SwitchFlashLight(0);
		entity:ChangeAIParameter(AIPARAM_SIGHTRANGE,entity.PropertiesInstance.sightrange);
		entity:ChangeAIParameter(AIPARAM_FOV,entity.Properties.horizontal_fov);	
	end,


	------------------------------------------------------
	-- special Harry-urgent-needed-blind-behaviour-hack -- 
	------------------------------------------------------
	LIGHTS_OFF  = function(self,entity,sender)
		entity:ChangeAIParameter(AIPARAM_SIGHTRANGE,0.1);	
	end,
	------------------------------------------------------
	LIGHTS_ON  = function(self,entity,sender)
		entity:ChangeAIParameter(AIPARAM_SIGHTRANGE,entity.PropertiesInstance.sightrange);	
	end,

	APPLY_MELEE_DAMAGE = function(self,entity,sender)
--		if (entity.cnt.melee_attack == nil) then
--			entity.cnt.melee_attack = 1;
--			local target = AI:GetAttentionTargetOf(entity.id);
--			if (type(target) == "table") then
--				entity.cnt.melee_target = target;
--			else
--				entity.cnt.melee_target = nil;
--			end
--			if (entity.ImpulseParameters) then 
--				entity.ImpulseParameters.pos = entity:GetPos();
--				local power = entity.ImpulseParameters.impulsive_pressure;
--				entity.ImpulseParameters.impulsive_pressure=2000;
--				entity:ApplyImpulseToEnvironment(entity.ImpulseParameters);
--				entity.ImpulseParameters.impulsive_pressure=power;
--			end
--		end
	end,

	RESET_MELEE_DAMAGE = function(self,entity,sender)
--		if (entity.cnt.melee_attack ~= nil) then
--			entity.cnt.melee_attack = nil;
--		end
	end,


	---------------------------------------------
	MUTANT_SELECT_IDLE = function ( self, entity, sender)
		entity:SelectPipe(0,"mutant_idling");
	end,
	---------------------------------------------
	MUTANT_PLAY_IDLE_ANIMATION = function ( self, entity, sender)
		local rnd = random(1,15);
		
		if (rnd>13) then
			entity:SelectPipe(0,"mutant_random_walk");
		elseif (rnd>10) then
			entity:SelectPipe(0,"mutant_random_look");
		else 
			local MyAnim = Mutant_IdleManager:GetIdle(entity);
			if (MyAnim) then
				entity:InsertAnimationPipe(MyAnim.Name);	
			end
		end
	end,
	------------------------------------------------------------------------ 
	HIDE_GUN = function (self,entity)
		entity.cnt:DrawThirdPersonWeapon(0);		
	end,
	------------------------------------------------------------------------ 
	UNHIDE_GUN = function (self,entity)
		entity.cnt:DrawThirdPersonWeapon(1);		
	end,
	------------------------------------------------------------------------ 

	SHARED_DRAW_GUN_ANIM = function (self,entity)

		if (entity.cnt:GetCurrWeapon() ~= nil) then 	
			if (entity.AI_GunOut==nil) then 
				if (entity.DRAW_GUN_ANIM_COUNT) then 
					local rnd=random(1,entity.DRAW_GUN_ANIM_COUNT);
					local anim_name = format("draw%02d",rnd);
					entity:StartAnimation(0,anim_name,2);	
					local anim_dur = entity:GetAnimationLength(anim_name);	
					entity:TriggerEvent(AIEVENT_ONBODYSENSOR,anim_dur);
					AI:EnablePuppetMovement(entity.id,0,anim_dur);
					entity.AI_GunOut = 1;
				end
			end
		end
	end,
	------------------------------------------------------------------------ 
	SHARED_HOLSTER_GUN_ANIM = function (self,entity)
		if (entity.AI_GunOut) then 
			if (entity.HOLSTER_GUN_ANIM_COUNT) then 
				local rnd=random(1,entity.HOLSTER_GUN_ANIM_COUNT);
				local anim_name = format("holster%02d",rnd);
				entity:StartAnimation(0,anim_name,2);	
				entity.AI_GunOut = nil;
			end
		end
	end,
	------------------------------------------------------------------------ 
	SHARED_REBIND_GUN_TO_HANDS = function (self,entity)
		--entity.cnt:HoldGun();		
		--AI:MakePuppetIgnorant(entity.id,0);
		entity.AI_GunOut = 1;
	end,
	------------------------------------------------------------------------ 
	SHARED_REBIND_GUN_TO_BACK = function (self,entity)
		--entity.cnt:HolsterGun();		
		--AI:MakePuppetIgnorant(entity.id,0);
		entity.AI_GunOut = nil;
	end,
	------------------------------------------------------------------------ 

	DO_THREATENED_ANIMATION = function(self,entity,sender)

		local rnd = random(1,3);		
		entity:InsertAnimationPipe("_surprise0"..rnd,3);
		local anim_dur = entity:GetAnimationLength("_surprise0"..rnd);	
		entity:TriggerEvent(AIEVENT_ONBODYSENSOR,anim_dur);
		AI:EnablePuppetMovement(entity.id,0,anim_dur);
	end,
	---------------------------------------------
	SHARED_PLAY_CURIOUS_ANIMATION = function(self,entity,sender)

		local rnd = random(1,2);		
		entity:InsertAnimationPipe("_curious"..rnd);
	end,
	---------------------------------------------

	DO_SOMETHING_IDLE = function( self,entity , sender)

		if (entity:MakeMissionConversation()) then		-- try talking to someone
			entity:CheckFlashLight();
			do return end
		end


		if (entity:MakeRandomConversation()) then		-- try talking to someone
			entity:CheckFlashLight();
			do return end
		end

		if (entity:DoSomethingInteresting()) then		-- piss, smoke or whatever
			entity:CheckFlashLight();
			do return end
		end

		-- always make at least an animation :)
		entity:MakeRandomIdleAnimation(); 		-- make idle animation
		entity:CheckFlashLight();
	end,
	---------------------------------------------
	GOING_TO_TRIGGER = function (self, entity, sender)
		entity.RunToTrigger = 1;
 		if ( sender.id == entity.id ) then
			AI:MakePuppetIgnorant(entity.id,1);
 			entity:InsertSubpipe(0,"run_to_trigger",entity.AI_ALARMNAME);
 		end
		
	end,
	---------------------------------------------
	THROW_FLARE = function (self, entity, sender)

 		if ( sender.id == entity.id ) then
			entity:InsertSubpipe(0,"throw_flare");
 		end
	end,

	SWITCH_GRENADE_TYPE = function (self, entity, sender)
		BasicPlayer.SelectGrenade(entity,"HandGrenade");
	end,


	MAKE_STUNNED_ANIMATION = function (self, entity, sender)

		if (entity.BLINDED_ANIM_COUNT) then
			local rnd = random(0,entity.BLINDED_ANIM_COUNT);
			local anim_name = format("blind%02d",rnd);
			entity:InsertAnimationPipe(anim_name,4);
			local dur = entity:GetAnimationLength(anim_name);
			AI:EnablePuppetMovement(entity.id,0,dur+3);	-- added the timeouts in the pipe
			entity:TriggerEvent(AIEVENT_ONBODYSENSOR,dur+3);
		else
			Hud:AddMessage("==================UNACCEPTABLE ERROR====================");
			Hud:AddMessage("Entity "..entity:GetName().." tried to make blinded anim, but no blindXX anims for his character.");
			Hud:AddMessage("==================UNACCEPTABLE ERROR====================");
		end
		
	end,


	---------------------------------------------
	FLASHBANG_GRENADE_EFFECT = function (self, entity, sender)
		if (entity.ai) then
			entity:InsertSubpipe(0,"stunned");
			entity:Readibility("FLASHBANG_GRENADE_EFFECT",1);
		end
		
	end,

	---------------------------------------------
	SHARED_BLINDED = function (self, entity, sender)
	end,

	---------------------------------------------
	SHARED_UNBLINDED = function (self, entity, sender)
		entity:StartAnimation(0,"NULL",4);
	end,

	---------------------------------------------
	SHARED_PLAY_GETDOWN_ANIM = function (self, entity, sender)
		local rnd= random(1,2);
		entity:InsertAnimationPipe("duck"..rnd.."_down",3);
	end,
	---------------------------------------------
	SHARED_PLAY_GETUP_ANIM = function (self, entity, sender)
		local rnd= random(1,2);
		entity:InsertAnimationPipe("duck"..rnd.."_up",3);
	end,
	---------------------------------------------
	SHARED_PLAY_DAMAGEAREA_ANIM = function (self, entity, sender)
		local rnd= random(1,2);
		entity:InsertAnimationPipe("duck"..rnd.."_up",3);
	end,
	

	exited_vehicle = function( self,entity, sender )

--		AI:Signal(SIGNALID_READIBILITY, 2, "AI_AGGRESSIVE",entity.id);	
--		entity.EventToCall = "OnSpawn";	
		AI:Signal(0,1,"OnSpawn",entity.id);
	end,

	---------------------------------------------
	select_gunner_pipe = function ( self, entity, sender)
		entity:SelectPipe(0,"h_gunner_fire");
	end,
	
}