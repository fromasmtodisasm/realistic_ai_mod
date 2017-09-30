--------------------------------------------------
--    Created By: SniperIdle
--   Description: <short_description>
--------------------------
--

AIBehaviour.SniperE3 = {
	Name = "SniperE3",

	-- SYSTEM EVENTS			-----
	
	YOU_ARE_BEING_WATCHED = function(self,entity,sender)
		AI:CreateGoalPipe("binocular_anim")
		AI:PushGoal("binocular_anim","signal",1,1,"MAKE_BINOCULAR_ANIM",0)
		AI:PushGoal("binocular_anim","timeout",1,1.6)
		AI:PushGoal("binocular_anim","signal",1,1,"SHOOTING_ALLOWED",SIGNALFILTER_SUPERGROUP)
		AI:PushGoal("binocular_anim","signal",1,1,"MAKE_POINTING_ANIM",0)
		AI:PushGoal("binocular_anim","DRAW_GUN")
		AI:PushGoal("binocular_anim","clear",0)

		entity:SelectPipe(0,"binocular_anim")

	end,

	OnActivate = function(self,entity)
		self:YOU_ARE_BEING_WATCHED(entity,entity)
	end,

	MAKE_BINOCULAR_ANIM = function(self,entity,sender)
		entity:StartAnimation(0,"_binoculars",4)
	end,

	MAKE_POINTING_ANIM = function(self,entity,sender)
		entity:InsertAnimationPipe("signal_formation")
		self.AnimationFinished = 1 
	end,


	---------------------------------------------
	OnSpawn = function(self,entity)
		-- called when enemy spawned or reset
		--entity:SelectPipe(0,"sniper_getdown")
		self.AnimationFinished=nil 
	end,

	---------------------------------------------
	OnPlayerSeen = function(self,entity,fDistance,NotContact)

		if (self.AnimationFinished==nil) then 
			do return end 
		end

		-- called when the enemy sees a living player
		if (fDistance < 30) then
			entity.DONT_DO_IT = 1 
		end


		entity:MakeAlerted()		
		local point = AI:GetAnchor(entity.id,AIAnchor.AIANCHOR_SHOOTSPOT,10)
		if (point) then
			entity:SelectPipe(0,"sniper_relocate_to",point)
		else
			AI:Signal(0,1,"SNIPER_NORMALATTACK",entity.id)
			
		end


		if (entity.SIGNAL_SENT==nil) then
			if (entity:GetGroupCount() > 1) then
				-- only send this signal if you are not alone
				entity.SIGNAL_SENT = 1 
				AI:Signal(SIGNALFILTER_GROUPONLY,1,"HEADS_UP_GUYS",entity.id)
				entity:TriggerEvent(AIEVENT_DROPBEACON)
			end
		end

		entity:InsertSubpipe(0,"DRAW_GUN")

	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity)
		-- called when the enemy hears an interesting sound
		AI:Signal(0,1,"SNIPER_NORMALATTACK",entity.id)		

	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity)
		-- called when the enemy hears a scary sound
		AI:Signal(0,1,"SNIPER_NORMALATTACK",entity.id)
	end,
	---------------------------------------------
	OnBulletRain = function(self,entity,sender)
		-- called when the enemy is damaged
		--System:Log("\004 SNIPER BULLET RAIN!!")
	
	

		if (entity.DONT_DO_IT) then
			do return end
		end

		local rnd = random(1,30)
		local time1 = rnd/10 + 1 
		local time2 = rnd/60 

		entity:MakeAlerted()		

		AI:CreateGoalPipe("sniper_alarmed")
		AI:PushGoal("sniper_alarmed","not_shoot")
		AI:PushGoal("sniper_alarmed","timeout",1,time2)
		AI:PushGoal("sniper_alarmed","setup_crouch")
		AI:PushGoal("sniper_alarmed","timeout",1,time1)
		AI:PushGoal("sniper_alarmed","setup_crouch")
		AI:PushGoal("sniper_alarmed","signal",0,1,"SNIPER_NORMALATTACK",0)

		entity:SelectPipe(0,"sniper_alarmed")
	end,
	---------------------------------------------
	OnReceivingDamage = function(self,entity,sender)
		-- called when the enemy sees a grenade
		self:OnBulletRain(entity,sender)
	end,
	---------------------------------------------
	OnNoHidingPlace = function(self,entity,sender)
		-- called when no hiding place can be found with the specified parameters
		entity:InsertSubpipe(0,"grenade_run_away")
	end,

	HEADS_UP_GUYS = function(self,entity,sender)
		if entity.ForceSenderId then sender=System:GetEntity(entity.ForceSenderId) entity.ForceSenderId=nil end
		if (entity~=sender) then
			entity:SelectPipe(0,"lookat_beacon")
			entity.SIGNAL_SENT = 1 
		end
	end,
	
	SNIPER_NORMALATTACK = function(self,entity,sender)
		local rnd = random(1,10)
		if (rnd > 6) then
			entity:SelectPipe(0,"sniper_dumbshoot")
		else
			entity:SelectPipe(0,"sniper_justshoot")
		end
	end,
}