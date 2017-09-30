----------------------------------------------------------------------------
--
-- Description :		Delayed proxymity trigger
--
-- Create by Alberto :	03 March 2002
--
----------------------------------------------------------------------------
AreaTrigger = {
	type = "Trigger",

	Properties = {
		bEnabled=1,
		bTriggerOnce=0,
		ScriptCommand="",
	},


	Editor={
		Model="Objects/Editor/T.cgf",
	},

	-- Who triggered me.
	Who=nil,
	Enabled=1,
	Entered=0,
	triggeredIn=0,
	triggeredOut=0,
}

function AreaTrigger:OnPropertyChange()
	self:OnReset();
end

function AreaTrigger:OnInit()

	self:RegisterState("Occupied");
	self:RegisterState("Empty");

	self:EnableUpdate(0);
	self:OnReset();
end

function AreaTrigger:OnSave(stm)
	--WriteToStream(stm,self.Properties);
	stm:WriteInt(self.Enabled);
	stm:WriteInt(self.triggeredIn);
	stm:WriteInt(self.triggeredOut);
end


function AreaTrigger:OnLoad(stm)
	--self.Properties=ReadFromStream(stm);
	self:OnReset();
	self.Enabled = stm:ReadInt();
	self.triggeredIn = stm:ReadInt();
	self.triggeredOut = stm:ReadInt();
end

function AreaTrigger:OnShutDown()
end

function AreaTrigger:OnReset()

	self.Enabled = self.Properties.bEnabled;
	self.Who = nil;
	self.UpdateCounter = 0;
	self.Entered = 0;
	self.triggeredIn = 0;
	self.triggeredOut = 0;
	self:GotoState( "Empty" );
end

function AreaTrigger:Event_Enter( sender )
	if ((self.Enabled ~= 1) or (self.Entered ~= 0)) then
		return
	end
	self.Entered = 1;
	--if ( sender ) then
	--	System:LogToConsole( "Player "..sender:GetName().." Enter AreaTrigger "..self:GetName() );
	--end
	BroadcastEvent( self,"Enter" );
end

function AreaTrigger:Event_Leave( sender )
	if (self.Enabled ~= 1 or self.Entered == 0) then
		return
	end
	--System:LogToConsole( "Player "..sender:GetName().." Leave AreaTrigger "..self:GetName() );
	BroadcastEvent( self,"Leave" );
end

function AreaTrigger:Event_Enable( sender )
	self.Enabled = 1;
	BroadcastEvent( self,"Enable" );
end

function AreaTrigger:Event_Disable( sender )
	self.Enabled = 0;
	self:GotoState( "Empty" );
	BroadcastEvent( self,"Disable" );
end

-------------------------------------------------------------------------------
-- Empty State ----------------------------------------------------------------
-------------------------------------------------------------------------------
AreaTrigger.Empty =
{
	-------------------------------------------------------------------------------
	OnBeginState = function( self )
		self.Who = nil;
		self.UpdateCounter = 0;
		self.Entered = 0;
	end,

	-------------------------------------------------------------------------------
	OnEndState = function( self )
	end,
	OnEnterArea = function( self,player,areaId )
		-- Ignore if disabled.
		if (self.Enabled ~= 1) then
			return
		end
		if (self.Who==nil) then
			self.Who = player;
			self:GotoState( "Occupied" );
		end
	end,
}

-------------------------------------------------------------------------------
-- Empty State ----------------------------------------------------------------
-------------------------------------------------------------------------------
AreaTrigger.Occupied =
{
	-------------------------------------------------------------------------------
	OnBeginState = function( self )
		--if has already been triggered and bTriggerOnce is 1
		--skip the envent
		if((self.Properties.bTriggerOnce==1) and self.triggeredIn==1)then
			self.Entered = 1;
			return
		end
		self.triggeredIn=1;
		self:Event_Enter(self.Who);

		if(self.Properties.ScriptCommand and self.Properties.ScriptCommand~="")then
			System:LogToConsole("Executing: "..self.Properties.ScriptCommand);
			dostring(self.Properties.ScriptCommand);
		end
	end,
	-------------------------------------------------------------------------------
	OnEndState = function( self )
	end,


	OnLeaveArea = function( self,player,areaId )
		-- Ignore if disabled.
		if (self.Enabled ~= 1) then
			return
		end
		--System:LogToConsole("Sending on leave");
		
		if((self.Properties.bTriggerOnce~=1) or self.triggeredOut~=1)then
			self.triggeredOut=1;
			self:Event_Leave( self.Who );
		end
		
		self.triggeredOut=1;
		self:GotoState("Empty");
	end,
}