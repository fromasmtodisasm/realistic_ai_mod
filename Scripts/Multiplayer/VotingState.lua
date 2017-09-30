-------------------------------------------------------------------------
--	Generic Voting code for MP
--
--	written by Alberto based on Wouter's code 
-------------------------------------------------------------------------
VotingState={
	timeout = 0,
	command = "",
	arg1 = "",
	votes = {},
	lastvoter = "",
	numvotes = 0,
	firstvotetime = 0,
}
-------------------------------------------------------------------------
function VotingState:OnCallVote(server_slot, command, arg1)
	if _time<self.timeout then
		server_slot:SendText("@VoteInProgress");
		return
	end
	
	local CmdStruct=GameCommands[command];
	
	if CmdStruct==nil then
		server_slot:SendText("@VoteUnknCommand");
		local coms = "";
		for name, impl in GameCommands do
		    coms = coms.." "..name;
		end
		server_slot:SendText("@ListOfVoteCmd "..coms);
		return
	end

	-- \return nil=call is not possible, otherwise the vote has started
	if( not CmdStruct.OnCallVote(CmdStruct,server_slot,arg1) )then
		return;
	end
	
	-- check for vote spamming
	local newvoter = server_slot:GetName();
	if (newvoter == self.lastvoter) then
--System:LogAlways("Vote initiator same as last vote.");
--System:LogAlways("Vote is number "..tostring(self.numvotes));
--System:LogAlways("Vote time: "..tostring(_time).." First vote at: "..tostring(self.firstvotetime));
		self.numvotes = self.numvotes + 1;
		if (self.numvotes > 2) then
			if (self.firstvotetime > _time - 240) then
				local pb = tonumber(getglobal("sv_punkbuster")); 
				if(pb and pb==1) then 
					local ntime = 10; 
					System:ExecuteCommand("pb_sv_kick \""..server_slot:GetName().."\" "..ntime.." Kicked for Vote Spamming"); 
				else 
					GameRules:KickSlot(server_slot) 
				end 
			end
		end
	else
--System:LogAlways("Vote initiator different from last vote.");
		self.lastvoter = newvoter;
		self.numvotes = 1;
		self.firstvotetime = _time;
	end

	-- initiate vote
	self.inprogress = 1;
	self.command = command;
	self.arg1 = arg1;
	self.timeout = _time+60;   -- vote lasts 1 minute?
	setglobal("gr_votetime",self.timeout);
	self.votes = {};

	Server:BroadcastText("@VoteWasCalled "..server_slot:GetName()..": "..command.." "..arg1);
	Server:BroadcastText("@VoteYesNo");
	Server:BroadcastText("Hit ESC and cast your vote!");

	-- player that does callvote automatically does "vote yes"
	self:OnVote(server_slot, 1)
end

-------------------------------------------------------------------------
function VotingState:OnVote(server_slot, vote)
	local svote = "yes";
	if vote==0 then
		svote = "no"
	end

	local id = server_slot:GetId();

	if _time>self.timeout then
		server_slot:SendText("@NoVoteInProgress");
		return
	end

	if self.command == "kick" then
		Server:BroadcastText(server_slot:GetName().." voted: "..svote.." to "..self.command.." "..Server:GetServerSlotBySSId(self.arg1):GetName());
	else
		Server:BroadcastText(server_slot:GetName().." voted: "..svote.." for "..self.command.." "..self.arg1);
	end
	Server:BroadcastText("Hit ESC and cast your vote!");

	-- cast the vote
	self.votes[id] = vote;

	local infavor = 0;
	local total = count(Server:GetServerSlotMap());

	if total==0 then
		System:LogToConsole("vote: no players?");
		return
	end

	-- count the votes
	for pid, pvote in self.votes do
		if pvote==1 then
			infavor = infavor+1;
		end
	end

	if infavor/total > 0.5 then
		Server:BroadcastText("@VotePassed "..self.command.." with "..infavor.."/"..total.." votes");
		self.timeout = 0;
	        infavor = 0;
		setglobal("gr_votetime",self.timeout);
		local fun = GameCommands[self.command].OnExecute;
		fun(GameCommands[self.command]);
	end
end
-------------------------------------------------------------------------
function VotingState:new()
	return new(VotingState);
end
