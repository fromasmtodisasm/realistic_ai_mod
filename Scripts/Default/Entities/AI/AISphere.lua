
AISphere ={
	Properties = {
		InnerRadius = 10,
	},
	

}

function AISphere:OnInit()

	self:RegisterState("Active");
	self:RegisterState("Inactive");

	self:EnableUpdate(0);
	self:TrackColliders(1);
	self:OnReset();
end

function AISphere:OnPropertyChange()
	self:OnReset();
end



function AISphere:Event_Activate( sender )
	self:GotoState( "Active" );
	BroadcastEvent(self, "Activate");
end

function AISphere:Event_Deactivate( sender )
	self:GotoState("Inactive");
	BroadcastEvent(self, "Deactivate");
end



function AISphere:OnReset()
	self:EnableUpdate(0);
	self:TrackColliders(1);

end


AISphere.Active={
	OnBeginState=function(self)
		AI:EnableNodesInSphere(self:GetPos(),self.Properties.InnerRadius,1);
	end,
}

AISphere.Inactive={
	OnBeginState=function(self)
		AI:EnableNodesInSphere(self:GetPos(),self.Properties.InnerRadius,0);
	end,
}


