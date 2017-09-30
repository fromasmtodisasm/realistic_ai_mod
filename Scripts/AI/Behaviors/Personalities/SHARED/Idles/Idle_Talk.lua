-- idle talk behaviour - talks without moving
--------------------------
AIBehaviour.Idle_Talk = {
	Name = "Idle_Talk",
	NOPREVIOUS = 1,
	JOB = 2,

	OnJobExit = function(self,entity,sender)
		if entity.CurrentConversation then
			entity.CurrentConversation:Stop(entity)
			entity:StopDialog()
		end
	end,

	CONVERSATION_FINISHED = function(self,entity)
		-- Hud:AddMessage(entity:GetName()..": Idle_Talk/OnJobExit/Alarm 2")
		-- System:Log(entity:GetName()..": Idle_Talk/OnJobExit/Alarm 2")
		-- Hud:AddMessage(entity:GetName()..": RETURN_TO_THE_STARTING_POSITION")
		local TagPointName = entity:GetName().."_CONVERSATION"
		local TagPoint = Game:GetTagPoint(TagPointName)
		local GoToPoint
		if TagPoint then GoToPoint=TagPointName end
		entity:InitAIRelaxed()
		-- entity:SelectPipe(0,"stand_only")
		entity:SelectPipe(0,"observe_direction")
		entity:InsertSubpipe(0,"setup_idle")
		if GoToPoint then
			AI:CreateGoalPipe("talk_patrol_approach_to")
			AI:PushGoal("talk_patrol_approach_to","timeout",1,0,1)
			AI:PushGoal("talk_patrol_approach_to","acqtarget",1,"")
			AI:PushGoal("talk_patrol_approach_to","timeout",1,0,.5)
			AI:PushGoal("talk_patrol_approach_to","pathfind",1,"")
			AI:PushGoal("talk_patrol_approach_to","trace",1,1,0)
			AI:PushGoal("talk_patrol_approach_to","clear")
			AI:PushGoal("talk_patrol_approach_to","signal",0,1,"GO_IDLE",0)
			entity:SelectPipe(0,"talk_patrol_approach_to",GoToPoint)
		end
	end,

}