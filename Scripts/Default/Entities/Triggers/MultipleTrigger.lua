----------------------------------------------------------------------------
--
-- Description :		Trigger that triggers event after some time.
--
----------------------------------------------------------------------------
MultipleTrigger = {
	type = "Trigger",

	Properties = {
		bEnabled = 1,
		iNumInputs = 1,
		ScriptCommand = "",
		PlaySequence = "",
	},

	Editor={
		Model="Objects/Editor/T.cgf",
	},
}

function MultipleTrigger:OnPropertyChange()
	self:OnReset();
end


function MultipleTrigger:OnReset()
	self.numInputs = 0;
end


function MultipleTrigger:OnShutDown()
end


function MultipleTrigger:OnLoad(stm)
	self.numInputs = stm:ReadInt();	
end

function MultipleTrigger:OnSave(stm)
	if (self.numInputs) then
		stm:WriteInt(self.numInputs);
	else
		stm:WriteInt(0);
	end
end


function MultipleTrigger:OnInit()
	self:EnableUpdate(0);
	self:OnReset();
end

---------------------------------------------------------------------
-- Input. Triggers output if triggered enough times.
---------------------------------------------------------------------
function MultipleTrigger:Event_InputTrigger( sender )


	if (self.Properties.bEnabled ~=0) then

		if (self.numInputs >= self.Properties.iNumInputs) then
			return
		end

		
		self.numInputs = self.numInputs + 1;
		if (self.numInputs >= self.Properties.iNumInputs) then
			self:Event_OutputTrigger(sender);
		end
	end

	BroadcastEvent( self,"InputTrigger" );
end

---------------------------------------------------------------------
-- Output, fired counting complete.
---------------------------------------------------------------------
function MultipleTrigger:Event_OutputTrigger( sender )
	if (self.Properties.bEnabled ~=0) then
		
		if(self.Properties.PlaySequence~="")then
			Movie:PlaySequence( self.Properties.PlaySequence );
		end
		
		-- Trigger script command on enter.
		if(self.Properties.ScriptCommand and self.Properties.ScriptCommand~="")then
			dostring(self.Properties.ScriptCommand);
		end
	end
	BroadcastEvent( self,"OutputTrigger" );
end

---------------------------------------------------------------------
function MultipleTrigger:Event_Enable( sender )
	self.Properties.bEnabled = 1;
	BroadcastEvent( self,"Enable" );
end

---------------------------------------------------------------------
function MultipleTrigger:Event_Disable( sender )
	self.Properties.bEnabled = 0;
	BroadcastEvent( self,"Disable" );
end

