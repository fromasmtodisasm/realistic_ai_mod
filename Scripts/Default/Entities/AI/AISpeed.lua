--filippo: this entity change the speed of an AI entity, its designed for helycopters but should can be used with every ai vehicles.
--it must be used together with an AItrigger , because the new speed is applied to the object is entering (or leaving) the trigger.

AISpeed ={
	Properties = {
		forward_speed = 10,
	},
}

function AISpeed:OnInit()
	self:OnReset();
end

function AISpeed:OnPropertyChange()
	self:OnReset();
end

function AISpeed:EntitySupported(Who)
	
	--at the moment we support only helycopters
	if (Who and Who.hely) then 
		return 1; 
	end
	
	return nil;
end

function AISpeed:Event_ChangeSpeed( sender )
	
	BroadcastEvent(self, "ChangeSpeed");
	
	if (sender==nil) then 
		return;
	end
		
	local Who = sender;
	
	if (sender.Who) then
		Who = sender.Who;
	end
	
	if (not AISpeed.EntitySupported(self,Who)) then	
		return;
	end
			
	--System:Log(Who:GetName().." change speed to "..self.Properties.forward_speed);
	Who:ChangeAIParameter(AIPARAM_FWDSPEED,self.Properties.forward_speed);
end

function AISpeed:Event_RestoreSpeed( sender )
	
	BroadcastEvent(self, "RestoreSpeed");
	
	if (sender==nil) then 
		return;
	end
		
	local Who = sender;
	
	if (sender.Who) then
		Who = sender.Who;
	end
	
	if (not AISpeed.EntitySupported(self,Who)) then	
		return;
	end
	
	if (Who.Properties and Who.Properties.forward_speed) then 

		--System:Log(Who:GetName().." change speed to "..Who.Properties.forward_speed);
		Who:ChangeAIParameter(AIPARAM_FWDSPEED,Who.Properties.forward_speed);
	end
end

function AISpeed:OnReset()

	self:EnableUpdate(0);
	self:TrackColliders(0);
end


