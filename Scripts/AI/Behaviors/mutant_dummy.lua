
--------------------------------------------------
--   Created By: <Sten Huebler>
--   Description: <does nothing anyway>
--------------------------
--

AIBehaviour.mutant_dummy = {
	Name = "mutant_dummy",

	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSelected = function(self,entity)
	end,
	---------------------------------------------
	OnSpawn = function(self,entity)
		-- called when enemy spawned or reset

		AI:CreateGoalPipe("melee")

		local tgpoint = entity:GetName()

		if (Game:GetTagPoint(tgpoint.."_SWALKTO")) then
			tgpoint = tgpoint.."_SWALKTO"
			AI:PushGoal("melee","setup_relax")
		elseif (Game:GetTagPoint(tgpoint.."_SRUNTO")) then
			tgpoint = tgpoint.."_SRUNTO"
			AI:PushGoal("melee","setup_relax")
			AI:PushGoal("melee","do_it_running")
		elseif (Game:GetTagPoint(tgpoint.."_AWALKTO")) then
			tgpoint = tgpoint.."_AWALKTO"
			AI:PushGoal("melee","setup_stand")
		elseif (Game:GetTagPoint(tgpoint.."_ARUNTO")) then
			tgpoint = tgpoint.."_ARUNTO"
			AI:PushGoal("melee","setup_stand")
			AI:PushGoal("melee","do_it_running")
		elseif (Game:GetTagPoint(tgpoint.."_XWALKTO")) then
			tgpoint = tgpoint.."_XWALKTO"
			AI:PushGoal("melee","setup_stealth")
		elseif (Game:GetTagPoint(tgpoint.."_XRUNTO")) then
			tgpoint = tgpoint.."_XRUNTO"
			AI:PushGoal("melee","setup_stealth")
			AI:PushGoal("melee","do_it_running")
		elseif (Game:GetTagPoint(tgpoint.."_CWALKTO")) then
			tgpoint = tgpoint.."_CWALKTO"
			AI:PushGoal("melee","setup_crouch")
		elseif (Game:GetTagPoint(tgpoint.."_CRUNTO")) then
			tgpoint = tgpoint.."_CRUNTO"
			AI:PushGoal("melee","setup_crouch")
			AI:PushGoal("melee","do_it_running")
		end

		AI:PushGoal("melee","locate",0,tgpoint)
		AI:PushGoal("melee","acqtarget",0,"")
		AI:PushGoal("melee","approach",1,1)
--		AI:PushGoal("melee","pathfind",1,"")
--		AI:PushGoal("melee","trace",1,1)

		entity:SelectPipe(0,"melee")


	end,
	---------------------------------------------
	OnActivate = function(self,entity)
		-- called when enemy receives an activate event (from a trigger,for example)

	end,
	---------------------------------------------
	OnNoTarget = function(self,entity)
		-- called when the enemy stops having an attention target
	end,
	---------------------------------------------
	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		-- called when the enemy sees a living player
	end,
	---------------------------------------------
	OnEnemySeen = function(self,entity)
		-- called when the enemy sees a foe which is not a living player
	end,
	---------------------------------------------
	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		-- called when the enemy can no longer see its foe,but remembers where it saw it last
		entity:SelectPipe(0,"scout_comeout")
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity)
		-- called when the enemy hears an interesting sound
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity)
		-- called when the enemy hears a scary sound
	 	entity:SelectPipe(0,"cover_investigate_threat")
	 	entity:InsertSubpipe(0,"DropBeaconTarget") -- in PipeManagerShared.lua
	end,
	---------------------------------------------
	OnReload = function(self,entity)
		-- called when the enemy goes into automatic reload after its clip is empty
		System:Log(entity:GetName().." .. OnReload")
	end,

	OnNoHidingPlace = function(self,entity,sender)
		-- called when no hiding place can be found with the specified parameters
		System:Log(entity:GetName().." .. OnNoHidingPlace")
	end,
	---------------------------------------------
	OnReceivingDamage = function(self,entity,sender)
		-- called when the enemy is damaged
		entity:SelectPipe(0,"cover_scramble")
	end,
	---------------------------------------------
	notaim = function(self,entity,sender)
		-- called when the enemy is damaged
		entity:StartAnimation(0,"notaim",1,.2)
	end,
	---------------------------------------------
	rise = function(self,entity,sender)
		-- called when the enemy is damaged
		entity:StartAnimation(0,"aim_loop",1,0)
	end,
	---------------------------------------------
	shoot = function(self,entity,sender)
		-- called when the enemy is damaged
		entity:StartAnimation(0,"shoot_loop",1,0)
	end,
	---------------------------------------------
	CONSIDER = function(self,entity,sender)
		-- called when the enemy is damaged
		entity.cnt.AnimationSystemEnabled = 1
		local XRandom = random(1,3)
		if (XRandom==1) then
			entity:SelectPipe(0,"MoveLeft")
		elseif (XRandom==2) then
			entity:SelectPipe(0,"MoveRight")
		end
	end,
	---------------------------------------------
	ShootBack = function(self,entity,sender)
		-- called when the enemy is damaged
		entity.cnt.AnimationSystemEnabled = 1
		entity:SelectPipe(0,"TestFight")
	end,
}