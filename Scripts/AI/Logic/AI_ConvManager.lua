-- AI_ConvManager - 
-- Created by Petar; 10102002
--------------------------


AI_ConvManager = {

	NewConversation = {},
	
}

function AI_ConvManager:GetSpecificConversation( name, conv_id)

	if (name=="RANDOM") then

		local conv = AI_IdleConversations[conv_id];

		self.NewConversation = new(AI_Conversation);
		self.NewConversation.Participants = conv.Participants;
		self.NewConversation.ConversationScript = conv.Script;
		self.NewConversation.ScriptLines = count(conv.Script);
		self.NewConversation.Joined = 0;
		self.NewConversation.NAME = "RANDOM";
		self.NewConversation.CONV_ID = conv_id;

		return self.NewConversation;
	else

		local conv = AI_CriticalConversations[name][conv_id];

		self.NewConversation = new(AI_Conversation);
		self.NewConversation.Participants = conv.Participants;
		self.NewConversation.ConversationScript = conv.Script;
		self.NewConversation.ScriptLines = count(conv.Script);
		self.NewConversation.Joined = 0;
		self.NewConversation.NAME = name;
		self.NewConversation.CONV_ID = conv_id;

		return self.NewConversation;

	end

end

function AI_ConvManager:GetControlledRandomConv( conv_table )

	
	local num_conv = count(conv_table);

	local rnd = random(1,num_conv);
	

	local conv = conv_table[rnd];
	local cnt = 0;
	while (conv.UseTag) do
		rnd=rnd+1;
		if (rnd>num_conv) then
			rnd = 1;
		end
		conv=conv_table[rnd];
		cnt=cnt+1;

		-- reset conversation tags so they can be reused
		if (cnt>num_conv) then 
			for i,value in conv_table do
				value.UseTag=nil;
			end
		end
	end

	conv.UseTag = 1;
	conv.CONV_ID = rnd;
	return conv;
end


function AI_ConvManager:GetRandomIdleConversation()

	

	local conv = self:GetControlledRandomConv( AI_IdleConversations );
	

	self.NewConversation = new(AI_Conversation);
	self.NewConversation.Participants = conv.Participants;
	self.NewConversation.ConversationScript = conv.Script;
	self.NewConversation.ScriptLines = count(conv.Script);
	self.NewConversation.Joined = 0;
	self.NewConversation.NAME = "RANDOM";
	self.NewConversation.CONV_ID = conv.CONV_ID;

	return self.NewConversation;
	
end

function AI_ConvManager:GetRandomCriticalConversation( name , inplace)

	local rnd;
	local Conversation = AI_CriticalConversations[name];
	local bUseShortName = 0;
	local short_name="X";

	if (Conversation==nil) then
		if (strlen(name) > 2) then 

		short_name = strsub(name,1,strlen(name)-3);
		Conversation = AI_CriticalConversations[short_name];
		if (Conversation==nil) then
				System:Warning( "[AIWARNING] An agent requested a critical conversation ("..name..") that doesn't exist. Tried also ("..short_name..") that doesnt exist either.");
			return nil;
		end
		bUseShortName = 1;
		
		else

		System:Warning( "[AIWARNING] An agent requested a critical conversation ("..name..") that doesn't exist");
		end

	end

	

	local RandomConv = self:GetControlledRandomConv( Conversation );

	self.NewConversation = new(AI_Conversation);
	self.NewConversation.Participants = RandomConv.Participants;
	self.NewConversation.Joined = 0;
	self.NewConversation.ConversationScript = RandomConv.Script;
	self.NewConversation.ScriptLines = count(RandomConv.Script);

	if (bUseShortName==0) then
		self.NewConversation.NAME = name;
	else
		self.NewConversation.NAME = short_name;
	end

	self.NewConversation.CONV_ID = RandomConv.CONV_ID;

	if (inplace) then 
		self.NewConversation.IN_PLACE = 1;
	else
		self.NewConversation.IN_PLACE = nil;
	end

	return self.NewConversation;
end





	
				
	
	
	
