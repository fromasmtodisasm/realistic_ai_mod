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

	self.inprogress = 1;
	self.command = command;
	self.arg1 = arg1;
	self.timeout = _time+60;   -- vote lasts 1 minute?
	self.votes = {};

	Server:BroadcastText("@VoteWasCalled "..server_slot:GetName()..": "..command.." "..arg1);
	Server:BroadcastText("@VoteYesNo");

	-- player that does callvote automatically does "vote yes"
	self:OnVote(server_slot, 1)
end

-------------------------------------------------------------------------
function VotingState:OnVote(server_slot, vote)
	local svote = "yes";
	if vote==0 then
		svote = "no"
	end

	local id = server_slot:GetPlayerId();

	if _time>self.timeout then
		server_slot:SendText("@NoVoteInProgress");
		return
	end

	Server:BroadcastText("@VoteCastBy "..server_slot:GetName()..": "..svote);

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
		Server:BroadcastText("@VotePassed "..infavor.."/"..total);
		self.timeout = 0;
		local fun = GameCommands[self.command].OnExecute;
		fun(GameCommands[self.command]);
	end
end
-------------------------------------------------------------------------
function VotingState:new()
	return new(VotingState);
end
