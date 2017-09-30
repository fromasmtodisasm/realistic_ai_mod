-- carrY box between AIANCHOR_PICKUP and AIANCHOR_PUTDOWN anchors,
-- crates need to be entity/other/AICrate
-- Created 2002-11-28 Amanda
-- Modified 2008-11-10 Mixer

AIBehaviour.Job_CarryBox = {
	Name = "Job_CarryBox",

	point_one = AIAnchor.AIANCHOR_PICKUP,
	point_two = AIAnchor.AIANCHOR_PUTDOWN,

	JOB = 1,

	OnSpawn = function(self,entity)
		entity:InitAIRelaxed()
		entity.AI_Carrying = nil

		if (not self.improved_gp_carrybox) then
		AI:CreateGoalPipe("job_pickup_crate")
		AI:PushGoal("job_pickup_crate","timeout",1,1.7)
		AI:PushGoal("job_pickup_crate","approach_to_lastop")
		AI:PushGoal("job_pickup_crate","signal",1,1,"START_PICKUP_ANIM",0)
		AI:PushGoal("job_pickup_crate","timeout",1,1)
		AI:PushGoal("job_pickup_crate","signal",1,1,"BIND_CRATE_TO_ME",0)
		AI:CreateGoalPipe("job_drop_crate")
		AI:PushGoal("job_drop_crate","approach_to_lastop")
		AI:PushGoal("job_drop_crate","signal",1,1,"START_PUTDOWN_ANIM",0)
		AI:PushGoal("job_drop_crate","timeout",1,.2)
		AI:PushGoal("job_drop_crate","signal",1,1,"FIND_PICKUP",0)
		self.improved_gp_carrybox = 1  end

		self:FIND_PICKUP(entity)
		entity:InsertSubpipe(0,"setup_idle")
	end,

	OnJobExit = function(self, entity)

		if (entity.AI_Carrying) then
			entity:DetachObjectToBone("weapon_bone")
			local entpos = entity:GetBonePos("Bip01 R Hand")
			entity.AI_Carrying:SetPos(entpos)
			entity.AI_Carrying:DrawObject(0,1)
			entity.AI_Carrying:AwakePhysics(1)
			entity.cnt:HoldGun()
			entity.cnt:HolsterGun()
			entity.cnt:HoldGun()
		end
		entity:DrawObject(1,0)
	end,

	START_PICKUP_ANIM = function(self, entity)
		if (AI:FindObjectOfType(entity:GetPos(),5,AIAnchor.AIOBJECT_CARRY_CRATE)) then
			entity:StartAnimation(0,"box_pickup",4)
			entity:StartAnimation(0,"box_carry",3)
		end
	end,

	START_PUTDOWN_ANIM = function(self, entity)
		entity:StartAnimation(0,"box_putdown",4)
		entity:StartAnimation(0,"NULL",3)
	end,


 	FIND_PICKUP = function(self,entity,sender)

		if (entity.AI_Carrying) then
		entity.AI_Carrying:DrawObject(0,1)
		entity:DetachObjectToBone("weapon_bone")
		local entpos = Game:GetTagPoint(entity.AI_Carrying:GetName().."_PUT")
		if (entpos==nil) then

		local entdir=entity:GetDirectionVector()
		entpos=entity:GetBonePos('Bip01 Pelvis')
		entpos.x = entpos.x + entdir.x
		entpos.y = entpos.y + entdir.y
		entdir = entity:GetAngles()
		entity.AI_Carrying:SetAngles(entdir)

		end
		entity.AI_Carrying:SetPos(entpos)
		entity.AI_Carrying:AwakePhysics(1)
		end

		local pickup_point = AI:FindObjectOfType(entity:GetPos(),130,self.point_one)
		if (pickup_point) then
			entity:SelectPipe(0,"job_pickup_crate",pickup_point)
		else
			System:Warning("[AI] "..entity:GetName().." has a carry box behaviour but no pickup point")
			AIBehaviour.Job_PracticeFire:OnLowAmmoExit(entity,1)
		end

	end,


 	BIND_CRATE_TO_ME = function(self,entity,sender)
		local crate = AI:FindObjectOfType(entity:GetPos(),5,AIAnchor.AIOBJECT_CARRY_CRATE)
		if (crate) then

			entity.AI_Carrying = System:GetEntityByName(crate)
			if (entity.AI_Carrying) then
				entity:AttachToBone(entity.AI_Carrying,"weapon_bone")
				crate = entity.AI_Carrying:GetName().."_GOTO"
				if (Game:GetTagPoint(crate)==nil) then crate = nil end
				entity.AI_Carrying:DrawObject(0,0)
			end

			if (crate==nil) then
				crate = AI:FindObjectOfType(entity:GetPos(),130,self.point_two)
			end
			if (crate) then
				entity:SelectPipe(0,"job_drop_crate",crate)
			else
				System:Warning("[AI] "..entity:GetName().." has a carry box behaviour but no drop point")
				AIBehaviour.Job_PracticeFire:OnLowAmmoExit(entity,1)
			end
		else
			-- System:Warning("[AI] "..entity:GetName().." bounced")
			entity:StartAnimation(0,"NULL",3)
			local pttemp = self.point_one
			self.point_one = self.point_two
			self.point_two = pttemp
			self:OnSpawn(entity)
		end
	end,

}

