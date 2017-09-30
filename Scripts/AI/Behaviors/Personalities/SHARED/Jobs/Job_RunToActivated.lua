
-- created by petar
--------------------------


AIBehaviour.Job_RunToActivated = {
	Name = "Job_RunToActivated",
	JOB = 1,
	CHANGE_STANCE = 1, -- При 1, принудительно разрешить автоматически менять положение тела, скорость перемещения и прыгать во время работы в случае столкновения с препятствием.
	FORCE_RUN = 1, -- Бежать при положении стоя или скрытно.
	ALLOW_JUMP = 1, -- Разрешить прыгать.

	OnSpawn = function(self,entity)
		entity:InitAIRelaxed()
		entity:SelectPipe(0,"stand_only")
		entity:InsertSubpipe(0,"setup_idle")
		if entity.Properties.special==1 then
			AI:Signal(0,0,"SPECIAL_GODUMB",entity.id)
		end
	end,

	OnJobContinue = function(self,entity,sender)
		self:OnSpawn(entity)
	end,

	OnActivate = function(self,entity)
		-- called when enemy receives an activate event (from a trigger,for example)
		-- try to get tagpoint of the same name as yourself first
		local run_target = entity:GetName().."_RUNTO"
		local TagPoint = Game:GetTagPoint(run_target)
		if (TagPoint) then
			AI:CreateGoalPipe("run_to")
			AI:PushGoal("run_to","do_it_running")
			if entity.cnt.weapon then
				AI:PushGoal("run_to","setup_stand")
			else
				if (entity.Properties.special==1) then
					AI:MakePuppetIgnorant(entity.id,1)
				end
				AI:PushGoal("run_to","setup_relax")
			end
			AI:PushGoal("run_to","acqtarget",0,"")
			AI:PushGoal("run_to","approach",1,1)
			entity:SelectPipe(0,"run_to",run_target)
		else
			System:Warning("[AI] Entity "..entity:GetName().." has run job assigned to it but no tag point name_RUNTO.")
		end
		entity:InsertSubpipe(0,"setup_idle")
		entity:GunOut()
		-- entity:CheckFlashLight()
	end,
}


