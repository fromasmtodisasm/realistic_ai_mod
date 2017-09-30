STATE_HANDLER_ONBEGINSTATE="OnBeginState"
STATE_HANDLER_ONENDSTATE="OnEndState"
STATE_HANDLER_ONUPDATE="OnUpdate"
STATE_HANDLER_ONTIMER="OnTimer"

__StateMachine={
	current_state={},
	--states={},
	timer_start=nil,
	timer_eta=0
};

-------------------------------------------------
function __StateMachine:GetState()
	for i,val in self.states do
		if(val==self.current_state)then
			return i;
		end
	end
	return "unknown"
end

-------------------------------------------------
function __StateMachine:GotoState(statename)
	local state=self.states[statename];
--	System:Log("$3state is "..type(state));
	if(state)then
		local hOnEndState=self.current_state.OnEndState;
		if(hOnEndState)then
			--hOnEndState(self,params)
			hOnEndState(self);
		end
		
		local hOnBeginState=state.OnBeginState;
		if(hOnBeginState)then
			--hOnBeginState(self,params)
			hOnBeginState(self);
		end
		self.current_state=state;
	else
		if(statename)then
			System:LogToConsole("state not found ["..statename.."]");
		else
			System:LogToConsole("state not found [statename was nil]");
		end
	end
end
-------------------------------------------------
function __StateMachine:Invoke(funcname,...)
	local func=self.current_state[funcname]
	if(func)then
		tinsert(arg,1,self);
		return call(func,arg);
	end
end
-------------------------------------------------
function __StateMachine:SetTimer(time)
	self.timer_start=_time;
	if(time<=0)then
		self.timer_eta=0.01;
	else
		self.timer_eta=time/1000;
	end
end
-------------------------------------------------
function __StateMachine:KillTimer()
	self.timer_start=nil;
end
-------------------------------------------------
function __StateMachine:Update(params)
	--update timers
	if(self.timer_start and ((_time-self.timer_start)>self.timer_eta))then
		local hOnTimer=self.current_state.OnTimer;
		self.timer_start=nil;
		if(hOnTimer)then
			hOnTimer(self,params)
		end
		
	end
	--update
	local hOnUpdate=self.current_state.OnUpdate;
	if(hOnUpdate)then
		hOnUpdate(self,params)
	end
end
-------------------------------------------------
function CreateStateMachine(basetable)
	if(not basetable)then
		return new(__StateMachine);
	else
		mergef(basetable,__StateMachine,1);
		return basetable;
	end
end