
-- created by petar
--------------------------


AIBehaviour.Job_RunTo = {-- Добавить: переход в режим поиска.
	Name = "Job_RunTo",
	JOB = 1,
	CHANGE_STANCE = 1, -- При 1, принудительно разрешить автоматически менять положение тела, скорость перемещения и прыгать в случае столкновения с препятствием во время работы.
	FORCE_RUN = 1, -- Бежать при положении стоя или скрытно.
	ALLOW_JUMP = 1, -- Разрешить прыгать.

	OnSpawn = function(self,entity)
		entity.PropertiesInstance.bGunReady = 1
		entity:InitAIRelaxed()
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
		local run_target = entity:GetName().."_RUNTO"
		-- try to get tagpoint of the same name as yourself first
		local TagPoint = Game:GetTagPoint(run_target)
		if (TagPoint) then
			entity:SelectPipe(0,"run_to",run_target)
		else
			System:Warning("[AI] Entity "..entity:GetName().." has run job assigned to it but no tag point name_RUNTO.")
			AIBehaviour.Job_PracticeFire:OnLowAmmoExit(entity,1)
		end
		entity:InsertSubpipe(0,"setup_idle")
		-- entity:CheckFlashLight()
	end,
}