----------------------------------------------------------------------------
--
-- Description :		Trigger that triggers event after some time.
--
----------------------------------------------------------------------------
DelayTrigger = {
	type = "Trigger",

	Properties = {
		bEnabled = 1,
		bTriggerOnce = 0,
		Delay = 1,
		ScriptCommand = "",
		PlaySequence = "",
	},

	Editor={
		Model="Objects/Editor/Clock.cgf",
	},
}

function DelayTrigger:OnPropertyChange()
	self:OnReset();
end


function DelayTrigger:OnReset()
	self:KillTimer();
	self.bTriggered = 0;
	self.bCounting = 0;
end

function DelayTrigger:OnShutDown()
end

function DelayTrigger:OnSave(stm)
	stm:WriteInt(self.bTriggered);
	if (self.bCounting==1) then
		stm:WriteBool(1);
		local time_remaining = self.Properties.Delay - (System:GetCurrTime()-self.StartTime);
		stm:WriteFloat(time_remaining);		
	else
		stm:WriteBool(0);
	end
end

function DelayTrigger:OnLoad(stm)
	self.bTriggered=stm:ReadInt();
	self.bCounting = stm:ReadBool();
	if (self.bCounting==1) then 
		self.StartTime =System:GetCurrTime(); 
		local timeremaining = stm:ReadFloat();
		self:SetTimer( timeremaining*1000 );
	end
end

function DelayTrigger:OnLoadRELEASE(stm)
	self.bTriggered=stm:ReadInt();
end

function DelayTrigger:OnInit()
	self:EnableUpdate(0);
	self:OnReset();
end

---------------------------------------------------------------------
-- Input. Triggers time counting.
---------------------------------------------------------------------
function DelayTrigger:Event_InputTrigger( sender )
	BroadcastEvent( self,"InputTrigger" );
	if (self.Properties.bTriggerOnce ~= 0 and self.bTriggered ~= 0) then
		return
	end
	
	--System:LogToConsole( "Input" );
	if (self.Properties.bEnabled ~=0) then
		--System:LogToConsole( "Start Timer"..(self.Properties.Delay*1000) );
		self.bCounting = 1;
		self:SetTimer( self.Properties.Delay*1000 );
		self.StartTime = System:GetCurrTime();
	end
end

---------------------------------------------------------------------
-- Output, fired when time counting complete.
---------------------------------------------------------------------
function DelayTrigger:Event_OutputTrigger( sender )
	if (self.Properties.bEnabled ~=0) then
--		self:SetTimer( self.Properties.Delay );
		self:KillTimer();
		self.bCounting = 0;
		self.bTriggered = 1;
		
		BroadcastEvent( self,"OutputTrigger" );
		
		if(self.Properties.PlaySequence~="")then
			Movie:PlaySequence( self.Properties.PlaySequence );
		end
		
		-- Trigger script command on enter.
		if(self.Properties.ScriptCommand and self.Properties.ScriptCommand~="")then
			dostring(self.Properties.ScriptCommand);
		end
	end
end

---------------------------------------------------------------------
function DelayTrigger:Event_Enable( sender )
	self.Properties.bEnabled = 1;
	BroadcastEvent( self,"Enable" );
end

---------------------------------------------------------------------
function DelayTrigger:Event_Disable( sender )
	self.Properties.bEnabled = 0;
	BroadcastEvent( self,"Disable" );
end

---------------------------------------------------------------------
function DelayTrigger:OnTimer()
	--System:LogToConsole( "Trigger" );
	if (self.bCounting ~= 0) then
		--System:LogToConsole( "And call" );
		if (_localplayer and _localplayer.cnt.health>0) then
			self:Event_OutputTrigger( self );
		end
	end
end

