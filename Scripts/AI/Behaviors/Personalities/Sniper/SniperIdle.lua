--------------------------------------------------
--    Created By: SniperIdle
--   Description: <short_description>
--------------------------
--

AIBehaviour.SniperIdle = {
	Name = "SniperIdle",

	-- SYSTEM EVENTS			-----

	---------------------------------------------
	OnSpawn = function( self, entity )
		-- called when enemy spawned or reset
		entity:InitAICombat();
		entity:SelectPipe(0,"sniper_getdown");
		
	end,

	---------------------------------------------
	OnPlayerSeen = function( self, entity, fDistance )


		local name = AI:FindObjectOfType(entity.id,10,AIAnchor.SNIPER_POTSHOT);
		if (name) then 
			local tgpoint = entity:GetName().."_POTSHOT"..entity.POTSHOTS;
			entity.POTSHOTS	= entity.POTSHOTS + 1;
			if (Game:GetTagPoint(tgpoint)) then
				entity:SelectPipe(0,"sniper_potshot",tgpoint);
				if (entity.AI_GunOut == nil) then 
					entity:InsertSubpipe(0,"DRAW_GUN");
					entity:InsertSubpipe(0,"setup_combat");
				end
				do return end;
			end

		end

		-- called when the enemy sees a living player
		if (fDistance < 30) then
			entity.DONT_DO_IT = 1;
		end


		--entity:MakeAlerted();		
		local point = AI:GetAnchor(entity.id,AIAnchor.AIANCHOR_SHOOTSPOTSTAND,10);
		if (point) then
			entity:SelectPipe(0,"sniper_shootfast",point);
			entity:InsertSubpipe(0,"setup_combat");
		else
			point = AI:GetAnchor(entity.id,AIAnchor.AIANCHOR_SHOOTSPOTCROUCH,10);
			if (point) then
				entity:SelectPipe(0,"sniper_aimalittle",point);
				entity:InsertSubpipe(0,"setup_crouch");
			else
				self:SNIPER_NORMALATTACK(entity);
				entity:InsertSubpipe(0,"setup_combat");
			end
		end


		if (entity.AI_GunOut==nil) then
			entity:InsertSubpipe(0,"DRAW_GUN");
		end


		if (entity.SIGNAL_SENT==nil) then
			entity:GettingAlerted();
			if (AI:GetGroupCount(entity.id) > 1) then
				-- only send this signal if you are not alone
				entity.SIGNAL_SENT = 1;
				AI:Signal(SIGNALFILTER_GROUPONLY, 1, "wakeup",entity.id);
				AI:Signal(SIGNALFILTER_GROUPONLY, 1, "HEADS_UP_GUYS",entity.id);
				entity:InsertSubpipe(0,"DropBeaconAt");
			end
		end



	end,


	SWITCH_TO_MORTARGUY = function(self,entity,sender)

	end,

	---------------------------------------------
	OnEnemyMemory = function( self, entity, fDistance )

		local point = AI:GetAnchor(entity.id,AIAnchor.AIANCHOR_SHOOTSPOTSTAND,10);
		if (point==nil) then
			point = AI:GetAnchor(entity.id,AIAnchor.AIANCHOR_SHOOTSPOTCROUCH,10);
		end

		if (point) then 
			entity:SelectPipe(0,"sniper_relocate_to", point);
		end

	end,
	---------------------------------------------
	OnInterestingSoundHeard = function( self, entity )
		-- called when the enemy hears an interesting sound
		entity:SelectPipe(0,"sniper_shootfast");
		entity:InsertSubpipe(0,"setup_combat");			
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function( self, entity )
		-- called when the enemy hears a scary sound
		entity:MakeAlerted();
		entity:SelectPipe(0,"sniper_shootfast");
		entity:InsertSubpipe(0,"setup_combat");			
	end,
	---------------------------------------------
	OnBulletRain = function ( self, entity, sender)
		-- called when the enemy is damaged
		--System:LogToConsole("\004 SNIPER BULLET RAIN!!");

		if (entity.DONT_DO_IT) then
			do return end
		end

		local rnd = random(1,30);
		local time1 = rnd/10 + 1;
		local time2 = rnd/60;

		entity:MakeAlerted();		


		entity:SelectPipe(0,"sniper_headdown");
		entity:InsertSubpipe(0,"setup_combat");	
	end,
	---------------------------------------------
	OnReceivingDamage = function( self, entity, sender)
		-- called when the enemy sees a grenade
		self:OnBulletRain(entity,sender);
	end,
	---------------------------------------------
	OnGrenadeSeen = function( self, entity, fDistance )
		-- called when the enemy sees a grenade
		AI:Signal(SIGNALID_READIBILITY, 1, "GRENADE_SEEN",entity.id);
		entity:InsertSubpipe(0,"grenade_run_hide");
	end,
	---------------------------------------------
	OnNoHidingPlace = function( self, entity, sender )
		-- called when no hiding place can be found with the specified parameters
		entity:InsertSubpipe(0,"grenade_run_away");
	end,

	HEADS_UP_GUYS = function (self, entity, sender)
		if (entity~=sender) then
			entity:SelectPipe(0,"lookat_beacon");
			entity.SIGNAL_SENT = 1;
		end
	end,

	-- What everyone has to do when they get a notification that someone died
	--------------------------------------------------
	OnGroupMemberDiedNearest = function ( self, entity, sender)

		if (entity.ai) then 
			entity:MakeAlerted();

			entity:Readibility("FRIEND_DEATH",1);

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
	
		entity:SelectPipe(0,"sniper_headdown");
		entity:InsertSubpipe(0,"DRAW_GUN");
		entity:InsertSubpipe(0,"setup_combat");
	end,


	SHOOTING_ALLOWED = function (self, entity, sender)
		self.HoldingFire = nil;
		entity:TriggerEvent(AIEVENT_CLEAR);
		entity:ChangeAIParameter(AIPARAM_SIGHTRANGE, 10000);
	end,
	
	SNIPER_NORMALATTACK = function (self, entity, sender)
		local rnd = random(1,10);
		if (rnd > 6) then
			entity:SelectPipe(0,"sniper_shootfast");
		else
			entity:SelectPipe(0,"sniper_aimalittle");
		end
	
		if (entity.AI_GunOut == nil) then 
			entity:InsertSubpipe(0,"DRAW_GUN");
		end
		entity:InsertSubpipe(0,"DropBeaconAt");
	end,
}