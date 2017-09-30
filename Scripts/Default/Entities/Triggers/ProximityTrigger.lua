----------------------------------------------------------------------------
--
-- Description :		Delayed proxymity trigger
--
-- Create by Alberto :	03 March 2002
--
----------------------------------------------------------------------------
ProximityTrigger = {
	type = "Trigger",

	Properties = {
		DimX = 5,
		DimY = 5,
		DimZ = 5,
		bEnabled=1,
		EnterDelay=0,
		ExitDelay=0,
		bOnlyPlayer=1,
		bOnlyMyPlayer=0,
		bOnlyAI = 0,
		bOnlySpecialAI = 0,
		bKillOnTrigger=0,
		bTriggerOnce=0,
		ScriptCommand="",
		PlaySequence="",		
		aianchorAIAction = "",
		TextInstruction= "",
		bActivateWithUseButton=0,
		bInVehicleOnly=0,		
	},
	
	Editor={
		Model="Objects/Editor/T.cgf",
	},	
}

function ProximityTrigger:OnPropertyChange()
	self:OnReset();
end

function ProximityTrigger:OnInit()
	self:EnableUpdate(0);
	self:SetUpdateType( eUT_Physics );
	self:TrackColliders(1);

	self.Who = nil;
	self.Entered = 0;
	self.bLocked = 0;
	self.bTriggered = 0;

	self:RegisterState("Inactive");
	self:RegisterState("Empty");
	self:RegisterState("Occupied");
	self:RegisterState("OccupiedUse");
	self:OnReset();
end

function ProximityTrigger:OnShutDown()
end

function ProximityTrigger:OnSave(stm)

	stm:WriteInt(self.bTriggered);
	if (self.Who) then 
		if (self.Who == _localplayer) then 
			stm:WriteInt(0);
		else
			stm:WriteInt(self.Who.id);
		end
	else
		stm:WriteInt(-1);
	end
end


function ProximityTrigger:OnLoad(stm)

	self.bTriggered=stm:ReadInt();

	-- this complication is there to support loading.saving
	self.WhoID = stm:ReadInt();
	if (self.WhoID<0) then 
		self.WhoID = nil;
	elseif (self.WhoID==0) then 
		self.WhoID = 0;
	end
end

function ProximityTrigger:OnLoadRELEASE(stm)

	self.bTriggered=stm:ReadInt();
end


function ProximityTrigger:OnReset()
	self:KillTimer();
	self.bTriggered = 0;

	local Min = { x=-self.Properties.DimX/2, y=-self.Properties.DimY/2, z=-self.Properties.DimZ/2 };
	local Max = { x=self.Properties.DimX/2, y=self.Properties.DimY/2, z=self.Properties.DimZ/2 };
	self:SetBBox( Min, Max );
	--self:Log( "BBox:"..Min.x..","..Min.y..","..Min.z.."  "..Max.x..","..Max.y..","..Max.z );
	self.Who = nil;
	self.UpdateCounter = 0;
	self.Entered = 0;
	if(self.Properties.bEnabled==1)then
		self:GotoState( "Empty" );
	else
		self:GotoState( "Inactive" );
	end


end

function ProximityTrigger:Event_Enter( sender )

	-- to make it not trigger when event sent to inactive tringger
	if (self:GetState( ) == "Inactive") then return end

	if ((self.Entered ~= 0)) then
		return
	end
	if (self.Properties.bTriggerOnce == 1 and self.bTriggered == 1) then
		return
	end
	self.bTriggered = 1;
	self.Entered = 1;
	-- Trigger script command on enter.
	if(self.Properties.ScriptCommand and self.Properties.ScriptCommand~="")then
		--self:Log( "Executing: "..self.Properties.ScriptCommand);
		dostring(self.Properties.ScriptCommand);
	end
	if(self.Properties.PlaySequence~="")then
		Movie:PlaySequence( self.Properties.PlaySequence );
	end

	BroadcastEvent( self,"Enter" );
	AI:RegisterWithAI(self.id, 0);

	--self:Log( "Player "..sender:GetName().." Enter ProximityTrigger "..self:GetName() );
end


function ProximityTrigger:Event_Leave( sender )
	if (self.Entered == 0) then
		return
	end
	self.Entered = 0;
	BroadcastEvent( self,"Leave" );

	--self:Log( "Player "..sender:GetName().." Leave ProximityTrigger "..self:GetName() );
	
	if(self.Properties.bTriggerOnce==1)then
		self:GotoState("Inactive");
	end
end

function ProximityTrigger:Event_Enable( sender )
	self:GotoState("Empty")
	BroadcastEvent( self,"Enable" );
end

function ProximityTrigger:Event_Disable( sender )
	self:GotoState( "Inactive" );
	AI:RegisterWithAI(self.id, 0);
	BroadcastEvent( self,"Disable" );
end

--function ProximityTrigger:Log( msg )
--	System:LogToConsole( msg );
--end

-- Check if source entity is valid for triggering.
function ProximityTrigger:IsValidSource( entity )
	if (self.Properties.bOnlyPlayer ~= 0 and entity.type ~= "Player") then
		return 0;
	end

	if (self.Properties.bOnlySpecialAI ~= 0 and entity.ai ~= nil and entity.Properties.special==0) then 
		return 0;
	end

	-- if Only for AI, then check
	if (self.Properties.bOnlyAI ~=0 and entity.ai == nil) then
		return 0;
	end

		-- Ignore if not my player.
	if (self.Properties.bOnlyMyPlayer ~= 0 and entity ~= _localplayer) then
		return 0;
	end

	-- if only in vehicle - check if collider is in vehicle
	if (self.Properties.bInVehicleOnly ~= 0 and not entity.theVehicle) then
		return 0;
	end

	if (entity.cnt.health <= 0) then 
		return 0;
	end


	return 1;
end


-------------------------------------------------------------------------------
-- Inactive State -------------------------------------------------------------
-------------------------------------------------------------------------------
ProximityTrigger.Inactive =
{
	OnBeginState = function( self )
		AI:RegisterWithAI(self.id, 0);
	end,
	OnEndState = function( self )
	end,
}
-------------------------------------------------------------------------------
-- Empty State ----------------------------------------------------------------
-------------------------------------------------------------------------------
ProximityTrigger.Empty =
{
	-------------------------------------------------------------------------------
	OnBeginState = function( self )
		self.Who = nil;
		self.UpdateCounter = 0;
		self.Entered = 0;
		if (self.Properties.aianchorAIAction~="") then
			AI:RegisterWithAI(self.id, AIAnchor[self.Properties.aianchorAIAction]);
		end
	end,

	OnTimer = function( self )
		self:GotoState( "Occupied" );
	end,

	-------------------------------------------------------------------------------
	OnEnterArea = function( self,entity,areaId )


		if (self:IsValidSource(entity) == 0) then
			return
		end
		

		
		if (entity.ai==nil) then
			if (self.Properties.bActivateWithUseButton~=0) then
				self.Who = entity;
				self:GotoState( "OccupiedUse" );
				do return end;
			end
		end
		
		if (self.Properties.EnterDelay > 0) then
			if (self.Who == nil) then
				-- Not yet triggered.
				self.Who = entity;
				self:SetTimer( self.Properties.EnterDelay*1000 );
			end
		else
			self.Who = entity;
			self:GotoState( "Occupied" );
		end
	end,


}

-------------------------------------------------------------------------------
-- Occupied State ----------------------------------------------------------------
-------------------------------------------------------------------------------
ProximityTrigger.Occupied =
{
	-------------------------------------------------------------------------------
	OnBeginState = function( self )
		self:Event_Enter(self.Who);
--		self:Do_Enter(self.Who);

		--self:Log("Enter");

		if(self.Properties.bKillOnTrigger==1)then
			Server:RemoveEntity(self.id);
		end
	end,

	-------------------------------------------------------------------------------
	OnTimer = function( self )
		--self:Log("Sending on leave");
		self:Event_Leave( self,self.Who );
		if(self.Properties.bTriggerOnce~=1)then
			self:GotoState("Empty");
		end
	end,

	-------------------------------------------------------------------------------
	OnLeaveArea = function( self,entity,areaId )
		-- Ignore if disabled.
		--add a very small delay(so is immediate)
		if (self:IsValidSource(entity) == 0) then
			return
		end
		
		if(self.Properties.ExitDelay==0) then
			self.Properties.ExitDelay=0.01;
		end
		self:SetTimer(self.Properties.ExitDelay*1000);
	end,
}

-------------------------------------------------------------------------------
-- OccupiedText State ---------------------------------------------------------
-------------------------------------------------------------------------------
ProximityTrigger.OccupiedUse =
{
	-------------------------------------------------------------------------------
	OnBeginState = function( self )
		self:EnableUpdate(1);
	end,
	-------------------------------------------------------------------------------
	OnEndState = function( self )
		self:EnableUpdate(0);
	end,
	-------------------------------------------------------------------------------
	OnUpdate = function( self )

		if (self.WhoID) then 
			if (self.WhoID == 0) then 
				self.Who = _localplayer;
			else
				self.Who = System:GetEntity(self.WhoID);
			end
			self.WhoID = nil;
		end

		if (self.Who.cnt) then			
			if (not self.Who.cnt.use_pressed) then			
				if (strlen(self.Properties.TextInstruction)>0) then
					Hud.label = self.Properties.TextInstruction;
				end
				do return end;
			end
		end

		if (self.Properties.EnterDelay > 0) then
			self:SetTimer( self.Properties.EnterDelay*1000 );
		else
			self:GotoState( "Occupied" );
		end
	end,
	
	-------------------------------------------------------------------------------
	OnTimer = function( self )
		self:GotoState( "Occupied" );
	end,

	-------------------------------------------------------------------------------
	OnLeaveArea = function( self,entity,areaId )
		if (self.Who == entity) then
			self:GotoState( "Empty" );
		end
	end,
}