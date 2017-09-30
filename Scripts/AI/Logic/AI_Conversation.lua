-- AI_Conversation - 
-- Created by Petar; 10102002
--------------------------



AI_Conversation = {

	-- this table will be filled out by the conversation manager

	Actor = {},
}


function AI_Conversation:Join( entity )

	--System:LogToConsole("\001 JOINED CONVERSATION "..entity:GetName());

	if ( self.Participants == self.Joined ) then
		do return end	-- we dont allow more people to join if they have no lines
	end

	self.Joined = self.Joined + 1;

	self.Actor[self.Joined] = entity;

--	if (entity.CurrentConversation == nil) then
		entity.CurrentConversation = self;
--	end


	--if (self.Participants == self.Joined) then
		--System:LogToConsole("\001 "..entity:GetName().." Starting a conversation");
	--	self:Start() 	-- start the conversation
	--end

	return 1
	
end


function AI_Conversation:Start()
	self.Progress = 0;
	if (self.IN_PLACE == nil) then 
		self.Actor[1]:SelectPipe(0,"stand_timer",self.Actor[2].id);
	end
	self:Continue();

	for i=1,self.Participants do
		if (self.Actor[i]) then
			self.Actor[i].EXPRESSIONS_ALLOWED = nil
		end
	end

end


function AI_Conversation:Continue()


	local prevLine;
	if (self.Progress>0) then
		prevLine = self.ConversationScript[self.Progress];
	else
		prevLine = nil;
	end
	
	self.Progress = self.Progress + 1;	

	local nextLine = self.ConversationScript[self.Progress];

	if (self.Progress <= self.ScriptLines) then
--		if (nextLine.Duration == nil) then
--			local sound = Sound:Load3DSound(nextLine.SoundData.soundFile,SOUND_UNSCALABLE,nextLine.SoundData.Volume,nextLine.SoundData.min, nextLine.SoundData.max);
--			nextLine.Duration = Sound:GetSoundLength(sound)*1000;
--		end
		
		--self.iTimer = Game:SetTimer(self, nextLine.Duration);

		local rnd = random(1,3);

		--Hud:AddMessage(self.Actor[nextLine.Actor]:GetName().." is playing "..nextLine.SoundData.soundFile.." with dur="..nextLine.Duration);

		-- stop animation for previous guy
		if (prevLine and self.IN_PLACE == nil) then
			self.Actor[prevLine.Actor]:StartAnimation(0,"NULL",4);
		end

		self.Actor[nextLine.Actor]:Say(nextLine.SoundData,self);

		if (self.IN_PLACE == nil) then 
			if (nextLine.AnimationToUse) then
				self.Actor[nextLine.Actor]:StartAnimation(0,nextLine.AnimationToUse,4);
			else
				self.Actor[nextLine.Actor]:StartAnimation(0,"_talk0"..rnd,4);
			end
		end

	else
		self:Stop();
	end

end



function AI_Conversation:Stop( stopper )
	

	for i=1,self.Participants do
		if (self.Actor[i]) then
			self.Actor[i].EXPRESSIONS_ALLOWED = 1;
			self.Actor[i]:StopDialog();
			self.Actor[i].CurrentConversation = nil;
			self.Actor[i]:TriggerEvent(AIEVENT_CLEAR);
			if (self.IN_PLACE == nil) then
				if (stopper~=self.Actor[i]) then
					AI:Signal(0, 1, "CONVERSATION_FINISHED",self.Actor[i].id);
				end
			end
		end
	end
		
	self.Stopped = 1;

end



function AI_Conversation:OnEvent( timerid )

	if (self.Stopped == nil) then
		self:Continue();
	end
end






	
				
	
	
	
