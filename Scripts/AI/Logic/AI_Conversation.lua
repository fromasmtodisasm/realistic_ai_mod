-- AI_Conversation -
-- Created by Petar  10102002
--------------------------
AI_Conversation = {
	-- this table will be filled out by the conversation manager
	Actor = {},
}

function AI_Conversation:Join(entity)
	if self.Joined>=self.Participants then return end
	self.Joined = self.Joined + 1
	self.Actor[self.Joined] = entity
	entity.CurrentConversation = self
	-- Hud:AddMessage(entity:GetName()..": Join: "..self.Joined..", Participants: "..self.Participants)
	-- System:Log(entity:GetName()..": 2 Join: "..self.Joined..", Participants: "..self.Participants)
	if entity:RemoveTagPoint(entity:GetName().."_CONVERSATION") then
		-- System:Log(entity:GetName()..": entity! Remove tag point!")
	end
	if self.Joined==self.Participants then
		-- for i,val in self.Participants do
			-- self.Actor[1]:RemoveTagPoint(self.Actor[1]:GetName().."_CONVERSATION")
		-- end
		-- if self.Actor[1]:RemoveTagPoint(self.Actor[1]:GetName().."_CONVERSATION") then
			-- System:Log(self.Actor[1]:GetName()..": self.Actor[1]! Remove tag point!")
		-- end
		if not self.Actor[1].CurrentConversation.IN_PLACE then -- Не наместе.
			self.Actor[1]:ComeToMe(self.Actor[2]) -- Подойти ко второму актёру.
		else
			self.Actor[1].CurrentConversation:Start(self.Actor[1])
		end
	end
	return 1
end

function AI_Conversation:Start(entity)
	-- self.InPlaceJoined = self.InPlaceJoined + 1
	-- local Ps = self.Participants-1
	-- System:Log(entity:GetName()..": Participants: "..Ps..", InPlaceJoined: "..self.InPlaceJoined)
	-- if not self.IN_PLACE and self.InPlaceJoined<Ps then -- Это если двое к стартеру подходят и каждый вызывает старт.
		-- do return end
	-- end
	-- System:Log(entity:GetName()..": AI_Conversation:Start. Progress:"..self.Progress)
	if self.Progress > 0 then do return end end
	-- System:Log(entity:GetName()..": AI_Conversation:Start. Progress:"..self.Progress)
	-- if not self.IN_PLACE then
		-- self.Actor[2]:SelectPipe(0,"stand_timer2",self.Actor[1].id)
	-- end
	self:Continue(entity)
	for i=1,self.Participants do
		if self.Actor[i] then
			-- if i>2 then
				-- self.Actor[i]:ComeToMe(entity)
			-- end
			self.Actor[i].EXPRESSIONS_ALLOWED = nil
			AI:Signal(0,1,"CONVERSATION_REQUEST",self.Actor[i].id) -- Переключение состояния.
		end
	end
end

function AI_Conversation:Continue(entity) -- Бардак в коде! Дико много копий!
	local PrevLine -- Это и есть, тот, кто только что говорил и передал эстафету.
	if self.Progress>0 then
		PrevLine = self.ConversationScript[self.Progress]
	end
	self.Progress = self.Progress + 1
	local NextLine = self.ConversationScript[self.Progress]
	local NextLinePlusOne = self.ConversationScript[self.Progress+1]
	local NextLineMinusOne = self.ConversationScript[self.Progress-1]
	-- local name = "no name"
	-- if entity then
		-- name = entity:GetName()
	-- end
	-- -- if PrevLine and not self.Actor[PrevLine.Actor]:GetName() then
		-- -- self:Stop() -- Был такой случай при загрузке, лучше их комментировать пока не нужны.
	-- -- end
	-- local name2 = "no name"
	-- if PrevLine then
		-- name2 = self.Actor[PrevLine.Actor]:GetName()
	-- end
	-- local name3 = "no name"
	-- if NextLine then
		-- name3 = self.Actor[NextLine.Actor]:GetName()
	-- end
	-- local name4 = "no name"
	-- if NextLinePlusOne then
		-- name4 = self.Actor[NextLinePlusOne.Actor]:GetName()
	-- end
	-- local name5 = "no name"
	-- if NextLineMinusOne then
		-- name5 = self.Actor[NextLineMinusOne.Actor]:GetName()
	-- end
	-- System:Log(name..": PrevLine: "..name2..", NextLine: "..name3..", NextLine+1: "..name4..", NextLine-1: "..name5..", Progress: "..self.Progress)
	if self.Progress <= self.ScriptLines then
		if NextLine.Actor then
			if self.Actor[NextLine.Actor]:CreateTagPoint(self.Actor[NextLine.Actor]:GetName().."_CONVERSATION")~=2 then
				-- System:Log(self.Actor[NextLine.Actor]:GetName()..": NextLine.Actor! Create tag point!")
			end
		end
--		if (NextLine.Duration==nil) then
--			local sound = Sound:Load3DSound(NextLine.SoundData.soundFile,SOUND_UNSCALABLE,NextLine.SoundData.Volume,NextLine.SoundData.min,NextLine.SoundData.max)
--			NextLine.Duration = Sound:GetSoundLength(sound)*1000
--		end
		--self.iTimer = Game:SetTimer(self,NextLine.Duration)
		--Hud:AddMessage(self.Actor[NextLine.Actor]:GetName().." is playing "..NextLine.SoundData.soundFile.." with dur="..NextLine.Duration)
		-- stop animation for previous guy
		-- if (PrevLine and self.IN_PLACE==nil ) then
		-- if PrevLine and not self.IN_PLACE and self.Actor[PrevLine.Actor].StartAnimation then -- Проверка.
			-- self.Actor[PrevLine.Actor]:StartAnimation(0,"NULL",4)
		-- end
		-- self.Actor[NextLine.Actor]:Say(NextLine.SoundData,self)
		self.Actor[NextLine.Actor]:SayDialogAi(NextLine.SoundData,self)
		-- if not self.IN_PLACE then
			-- self.Actor[2]:SelectPipe(0,"stand_timer2",self.Actor[1].id)
		-- end
		-- if not self.IN_PLACE then
			-- if not PrevLine then
				-- self.Actor[NextLine.Actor+1]:SelectPipe(0,"stand_timer2",self.Actor[PrevActor].id)
			-- end
			-- local PrevActor = 1
			-- if PrevLine and PrevLine.Actor then
				-- PrevActor = PrevLine.Actor
			-- end
			-- self.Actor[NextLine.Actor]:SelectPipe(0,"stand_timer2",self.Actor[PrevActor].id)
			-- if self.Actor and self.Actor[self.Progress] and self.Actor[self.Progress+1] then
				-- self.Actor[self.Progress+1]:ComeToMe(self.Actor[self.Progress])
				-- System:Log("NO NULL")
			-- else
				-- System:Log("NULL!!!")
			-- end
			-- if PrevLine and NextLinePlusOne then
				-- self.Actor[PrevLine.Actor]:SelectPipe(0,"stand_timer2",self.Actor[NextLinePlusOne.Actor].id)
			-- end
			-- if PrevLine and NextLine then
				-- self.Actor[PrevLine.Actor]:SelectPipe(0,"stand_timer2",self.Actor[NextLine.Actor].id)
			-- end
		if not self.IN_PLACE
		or (self.IN_PLACE and ((PrevLine and NextLine and not AI:IsMoving(self.Actor[PrevLine.Actor]) and not self.Actor[PrevLine.Actor].ActivateJobAnimation
		and not AI:IsMoving(self.Actor[NextLine.Actor]) and not self.Actor[NextLine.Actor].ActivateJobAnimation and random(1,2)==1)
		or (PrevLine and self.Actor[PrevLine.Actor].HeCame) or (NextLine and self.Actor[NextLine.Actor].HeCame))) then
			if NextLinePlusOne then
				if not self.Actor[NextLinePlusOne.Actor].HeCame and not self.IN_PLACE then
					self.Actor[NextLinePlusOne.Actor].HeCame = 1
					self.Actor[NextLinePlusOne.Actor]:ComeToMe(self.Actor[NextLine.Actor])
					AI:EnablePuppetMovement(self.Actor[NextLinePlusOne.Actor].id,0,1)
				else
					-- if not self.IN_PLACE or (self.IN_PLACE and random(1,2)==1) then
						self.Actor[NextLinePlusOne.Actor].HeCame = 1
						self.Actor[NextLinePlusOne.Actor]:SelectPipe(0,"stand_timer2",self.Actor[NextLine.Actor].id)
						-- AI:EnablePuppetMovement(self.Actor[NextLinePlusOne.Actor].id,0,NextLinePlusOne.Duration)
					-- end
				end
				-- System:Log("PrevLine: "..name2..", NextLine: "..name3..", NextLine+1: "..name4..", NextLine-1:"..name5..", Progress: "..self.Progress)
			end
			if PrevLine and not self.Actor[PrevLine.Actor].CurrentInsertAnimDurationStart
			and (not self.IN_PLACE or (self.IN_PLACE and self.Actor[PrevLine.Actor].HeCame)) then
				self.Actor[PrevLine.Actor]:StartAnimation(0,"NULL",4)
			end
			if PrevLine and not self.Actor[PrevLine.Actor].CurrentInsertAnimDurationStart
			and ((random(1,2)==1 and not self.IN_PLACE) or (self.IN_PLACE and self.Actor[PrevLine.Actor].HeCame)) then
				self.Actor[PrevLine.Actor]:MakeRandomIdleAnimation()
			end
			if PrevLine and NextLine and NextLineMinusOne then
				for i,val in self.ConversationScript do
					if i<self.Progress then
						local ChekLine = self.ConversationScript[i]
						if ChekLine and self.Actor[ChekLine.Actor]~=self.Actor[PrevLine.Actor] and self.Actor[ChekLine.Actor]~=self.Actor[NextLine.Actor]
						and self.Actor[ChekLine.Actor]~=self.Actor[NextLineMinusOne.Actor] then
							-- System:Log("ChekLine: "..self.Actor[ChekLine.Actor]:GetName()..", PrevLine: "..name2..", NextLine: "..name3..", NextLine+1: "..name4..", NextLine-1:"..name5..", Progress: "..self.Progress)
							if (random(1,2)==1 and not self.IN_PLACE) or (self.IN_PLACE and self.Actor[ChekLine.Actor].HeCame) then
								self.Actor[ChekLine.Actor]:MakeRandomIdleAnimation()
							end
							if not self.IN_PLACE or (self.IN_PLACE and self.Actor[ChekLine.Actor].HeCame) then
								self.Actor[ChekLine.Actor]:SelectPipe(0,"stand_timer2",self.Actor[NextLine.Actor].id)
							end
							-- self.Actor[ChekLine.Actor]:ComeToMe(self.Actor[NextLine.Actor])
						end
					end
				end
			end
		end
		-- if not self.IN_PLACE then -- Что-то многовато их. )
			if NextLine then
				if NextLine.AnimationToUse then
					if NextLine.AnimationToUse~="NULL" or (NextLine.AnimationToUse=="NULL" and not self.Actor[NextLine.Actor].CurrentInsertAnimDurationStart) then
						System:Log(self.Actor[NextLine.Actor]:GetName().." NextLine.AnimationToUse: "..NextLine.AnimationToUse)
						self.Actor[NextLine.Actor]:StartAnimation(0,NextLine.AnimationToUse,4)
					end
				else
					if not self.IN_PLACE then
						if not AI:IsMoving(self.Actor[NextLine.Actor]) and random(1,2)==1 then
							self.Actor[NextLine.Actor]:StartAnimation(0,"_talk0"..random(1,3),4)
						else
							if not self.Actor[NextLine.Actor].CurrentInsertAnimDurationStart then
								self.Actor[NextLine.Actor]:MakeRandomIdleAnimation()
							end
						end
					end
				end
				-- if AI:IsMoving(self.Actor[NextLine.Actor]) then
					-- local IsSound = Sound:Load3DSound(NextLine.SoundData.soundFile,SOUND_UNSCALABLE,NextLine.SoundData.Volume,NextLine.SoundData.min,NextLine.SoundData.max)
					-- local Duration = Sound:GetLengthMs(IsSound)/1000
					-- Hud:AddMessage("Duration: "..Duration)
					if not self.IN_PLACE then
						AI:EnablePuppetMovement(self.Actor[NextLine.Actor].id,0,NextLine.Duration) -- NextLine.Duration
					end
				-- end
			end
		-- end
		-- else -- Оно и без вставок работает.
			-- Hud:AddMessage("self.IN_PLACE")
			-- if not AI:IsMoving(self.Actor[NextLine.Actor]) and not self.Actor[NextLine.Actor].ActivateJobAnimation then
				-- rnd = random(1,3)
				-- if rnd==1 then
					-- self.Actor[NextLine.Actor]:MakeRandomIdleAnimation()
				-- elseif rnd==2 then
					-- AI:CreateGoalPipe("Conversation_direction")
					-- AI:PushGoal("Conversation_direction","lookat",1,0,0)
					-- AI:PushGoal("Conversation_direction","timeout",1,1,2)
					-- AI:PushGoal("Conversation_direction","signal",1,1,"MAKE_RANDOM_IDLE_ANIMATION",0)
					-- AI:PushGoal("Conversation_direction","lookat",1,-90,90)
					-- AI:PushGoal("Conversation_direction","timeout",1,.5,1.5)
					-- AI:PushGoal("Conversation_direction","lookat",1,-90,90)
					-- AI:PushGoal("Conversation_direction","timeout",1,.5,1.5)
					-- self.Actor[NextLine.Actor]:InsertSubpipe(0,"Conversation_direction")
				-- end
			-- end
		-- end
	else
		self:Stop()
	end
end

function AI_Conversation:Stop(Stopper)
	for i=1,self.Participants do
		if self.Actor[i] then
		
			if self.Progress <= self.ScriptLines then
				-- Hud:AddMessage(self.Actor[i]:GetName()..": AI_Conversation/Stop, Behaviour: "..self.Actor[i].Behaviour.Name..", Default Behaviour: "..self.Actor[i].DefaultBehaviour..", Properties Instance Behaviour: "..self.Actor[i].PropertiesInstance.aibehavior_behaviour)
				-- System:Log(self.Actor[i]:GetName()..": AI_Conversation/Stop, Behaviour: "..self.Actor[i].Behaviour.Name..", Default Behaviour: "..self.Actor[i].DefaultBehaviour..", Properties Instance Behaviour: "..self.Actor[i].PropertiesInstance.aibehavior_behaviour)
				for j,val in AIBehaviour.AVAILABLE do -- j - название, val - содержание, путь к файлу.
					-- Hud:AddMessage(self.Actor[i]:GetName()..": j: "..j..", val: "..val)
					-- System:Log(self.Actor[i]:GetName()..": j: "..j..", val: "..val)
					local Behavior = self.Actor[i].PropertiesInstance.aibehavior_behaviour
					if j==Behavior then
						-- if AIBehaviour[Behavior] then
							-- if AIBehaviour[Behavior].OnPlayerSeen then
								-- Hud:AddMessage(self.Actor[i]:GetName()..": AIBehaviour[Behavior].OnPlayerSeen")
								-- System:Log(self.Actor[i]:GetName()..": AIBehaviour[Behavior].OnPlayerSeen")
								-- AIBehaviour[Behavior]:OnPlayerSeen(self.Actor[i])
							-- end
						-- end
						if j=="Job_CroweOne" then
							AI:Signal(0,1,"CROWE_ONE",self.Actor[i].id) -- EventToCall = "OnPlayerSeen"
						end
						break
					end
				end
			end
			
			self.Actor[i].EXPRESSIONS_ALLOWED = 1
			self.Actor[i]:StopDialog()
			if self.Actor[i].SayWordSound and Sound:IsPlaying(self.Actor[i].SayWordSound) then
				Sound:StopSound(self.Actor[i].SayWordSound)
				Hud:AddMessage(self.Actor[i]:GetName()..": Sound:StopSound(self.Actor[i].SayWordSound)")
				System:Log(self.Actor[i]:GetName()..": Sound:StopSound(self.Actor[i].SayWordSound)")
			end
			self.Actor[i].NeedThisSoundTimeInMS = nil
			self.Actor[i].ThisSoundTimeInMS = nil
			self.Actor[i].SayDialogWordStart = nil
			self.Actor[i].CurrentConversation = nil
			-- self.Actor[i]:TriggerEvent(AIEVENT_CLEAR) -- Сволочь, из-за этого они убивали cобеседников после разговоров при инсерте just_shoot в DoNotShootOnFriendsOnTarget. А теперь ещё где-то инсертится такое.
			self.Actor[i].OnConversationFinishedStart = _time
			AI:EnablePuppetMovement(self.Actor[i].id,1)
			if Stopper~=self.Actor[i] then
				AI:Signal(0,1,"CONVERSATION_FINISHED",self.Actor[i].id)
			end
		end
	end
	self.Stopped = 1
end

function AI_Conversation:OnEvent(TimerID)
	if not self.Stopped then
		self:Continue()
	end
end