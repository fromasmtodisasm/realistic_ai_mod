----------------------------------------------------------------------------
--
-- Description :		General purpose AI trigger
--
-- Created by Petar 
--
----------------------------------------------------------------------------
AITrigger = {
	type = "Trigger",

	Properties = {
		DimX = 5,
		DimY = 5,
		DimZ = 5,
		bEnabled=1,
		aianchorAIAction = "",
		fAnchorRadius = 0,
		ExitDelay=0,
		bTriggerOnce = 0,
		fileModel = "",
		bAILadder = 0,
		bToggleStance = 0,
		bSkipFlyingAI = 1,
		bSkipSpecialAI = 1,	
		bDestroyOnSelect = 0,	

		Signal = {
			bSendSignal = 0,
			bReadibility = 0,
			signalText = "ALARM_ON",
			signalRadius = 20,
		},
				
	},

	Waiting = {},
	NumWaiting = 0,
	NumInside = 0,
	bExplicitlyDisabled = 0,
	
	Editor={
		Model="Objects/Editor/T.cgf",
	},
}

function AITrigger:OnPropertyChange()
	self:OnReset();
	if (self.Properties.fileModel~=self.LastModelLoaded) then
		if (self.Properties.fileModel~="") then
			self:LoadObject(self.Properties.fileModel,0,0);
			self:DrawObject(0,1);
			self.LastModelLoaded = self.Properties.fileModel;
		end
	end

end

function AITrigger:OnInit()
	self.Who = nil;
	self.Entered = 0;
	self.bLocked = 0;
	self.bTriggered = 0;

	self:RegisterState("Inactive");
	self:RegisterState("Empty");
	self:RegisterState("Occupied");
	self:OnReset();

	if (self.Properties.fileModel~="") then
		self:LoadObject(self.Properties.fileModel,0,0);
		self:DrawObject(0,1);
		self.LastModelLoaded = self.Properties.fileModel;
	end

	self:EnableUpdate(0);
	self:SetUpdateType( eUT_Physics );
	self:TrackColliders(1);
end

function AITrigger:OnShutDown()
end

function AITrigger:OnSave(stm)
	--WriteToStream(stm,self.Properties);
	stm:WriteInt(self.bExplicitlyDisabled);
end


function AITrigger:OnLoad(stm)
	self.bExplicitlyDisabled = stm:ReadInt();
	-- voodoo trick to make sure we are in the correct state
	self:GotoState("Empty");
	self:GotoState("Inactive");

end

function AITrigger:OnReset()
	self:KillTimer();
	self.bTriggered = 0;
	self.bExplicitlyDisabled = 0;

	local Min = { x=-self.Properties.DimX/2, y=-self.Properties.DimY/2, z=-self.Properties.DimZ/2 };
	local Max = { x=self.Properties.DimX/2, y=self.Properties.DimY/2, z=self.Properties.DimZ/2 };
	self:SetBBox( Min, Max );
	

	self.Who = nil;
	self.UpdateCounter = 0;
	self.Entered = 0;


	if(self.Properties.bEnabled==1)then
		self:GotoState( "Inactive" );
		self:GotoState( "Empty" );
	else
		self:GotoState( "Empty" );
		self:GotoState( "Inactive" );
	end


end

function AITrigger:Event_Enter( sender )
	if ((self.Entered ~= 0)) then
		return
	end

	if (sender) then 
		if (sender.cnt and (sender.type=="Player")) then 
			self.Who = sender;
		elseif (sender and sender.Who) then 
			self.Who = sender.Who;
		end
	end

	self:Event_Signal(self);

	self.bTriggered = 1;
	self.Entered = 1;


	BroadcastEvent( self,"Enter" );

	if (self.Properties.bTriggerOnce==1) then
		self:GotoState( "Inactive" );
	end



	if ( sender ) then
		self:Log( "Player "..sender:GetName().." Enter AITrigger "..self:GetName() );
	end
end

function AITrigger:Event_Leave( sender )
	if (self.Entered == 0) then
		return
	end
	self.Entered = 0;
	BroadcastEvent( self,"Leave" );
	if (sender ~= nil) then
		self:Log( "Player "..sender:GetName().." Leave AITrigger "..self:GetName() );
	end
end

function AITrigger:Event_Enable( sender )
	self:GotoState("Empty")
	if (self.Properties.aianchorAIAction~="") then
		AI:RegisterWithAI(self.id, AIAnchor[self.Properties.aianchorAIAction], self.Properties.fAnchorRadius);
	else
		AI:RegisterWithAI(self.id, AIAnchor.PLACEHOLDER, self.Properties.fAnchorRadius);
	end

	BroadcastEvent( self,"Enable" );
end

function AITrigger:Event_Signal( sender )

	if (self.Properties.Signal.bSendSignal == 1)  then
		if (self.Who) then
			if (self.Properties.Signal.bReadibility==1) then
				AI:Signal(SIGNALID_READIBILITY, 1, self.Properties.Signal.signalText,self.Who.id);
			else		
				AI:FreeSignal(1,self.Properties.Signal.signalText,self:GetPos(),self.Properties.Signal.signalRadius,self.Who.id); 
			end
		else
			AI:FreeSignal(1,self.Properties.Signal.signalText,self:GetPos(),self.Properties.Signal.signalRadius,self.id); 
		end
	end

	BroadcastEvent( self,"Signal" );
end

function AITrigger:Event_Disable( sender )
	self:GotoState( "Inactive" );
	AI:RegisterWithAI(self.id, 0);
	self.bExplicitlyDisabled = 1;
	BroadcastEvent( self,"Disable" );
end

function AITrigger:OnEvent( EventId, Params)
	if (EventId == ScriptEvent_Activate) then
		self:GotoState("Empty");
		if (self.Properties.bDestroyOnSelect==1) then
			AI:RegisterWithAI(self.id,0);
		end
	end
end

function AITrigger:Log( msg )
	System:LogToConsole( msg )
end

function AITrigger:EntityCanEnter(ent)

	if (ent.hely) then
			
		if (self.Properties.bSkipFlyingAI==1) then 
			return nil;
		end
	else	
		if (ent.ai == nil) then
			return nil;
		end

		if (self.Properties.bSkipSpecialAI==1 and ent.Properties.special==1) then
			return nil;
		end

		if (ent.cnt and ent.cnt.health<=0) then
			return nil;
		end
	end
	
	return 1;
end

function AITrigger:EntityCanEnterOccupied(ent)

	if (ent.hely) then
			
		if (self.Properties.bSkipFlyingAI==1) then 
			return nil;
		end
	else	
		if (ent.ai == nil) then
			return nil;
		end

		if (ent.cnt and ent.cnt.health<=0) then
			return nil;
		end
	end
	
	return 1;
end

-------------------------------------------------------------------------------
-- Inactive State -------------------------------------------------------------
-------------------------------------------------------------------------------
AITrigger.Inactive =
{
	OnBeginState = function( self )

		if (self.bExplicitlyDisabled==0) then 

			if (self.Properties.bTriggerOnce == 0) then 
				if (self.Properties.aianchorAIAction~="") then
					AI:RegisterWithAI(self.id, AIAnchor[self.Properties.aianchorAIAction], self.Properties.fAnchorRadius);
				else
					AI:RegisterWithAI(self.id, AIAnchor.PLACEHOLDER, self.Properties.fAnchorRadius);
				end
			else
				if (self.Who) then
					AI:RegisterWithAI(self.id, 0);
				else
					if (self.Properties.aianchorAIAction~="") then
						AI:RegisterWithAI(self.id, AIAnchor[self.Properties.aianchorAIAction], self.Properties.fAnchorRadius);
					else
						AI:RegisterWithAI(self.id, AIAnchor.PLACEHOLDER, self.Properties.fAnchorRadius);
					end	
				end
			end
		end
		
	end,
	OnEndState = function( self )
	end,
	OnEvent = AITrigger.OnEvent,
}
-------------------------------------------------------------------------------
-- Empty State ----------------------------------------------------------------
-------------------------------------------------------------------------------
AITrigger.Empty =
{
	-------------------------------------------------------------------------------
	OnBeginState = function( self )

		self.Who = nil;
		self.UpdateCounter = 0;
		self.Entered = 0;



	end,

	OnEndState = function( self )
		if (self.Properties.bTriggerOnce == 1) then
			AI:RegisterWithAI(self.id, 0);
		end
	end,

	OnTimer = function( self )
		self:GotoState( "Occupied" );
	end,

	-------------------------------------------------------------------------------
	OnContact = function( self,player )
	
		if (not AITrigger.EntityCanEnter(self,player)) then 
			return
		end

		self.Who = player;
		self:GotoState( "Occupied" );

	end,

	-------------------------------------------------------------------------------
	OnEnterArea = function( self,player,areaId )
	
		if (not AITrigger.EntityCanEnter(self,player)) then 
			return
		end

		if (self.Who == nil) then
			self.NumInside = self.NumInside + 1;
			self.Who = player;
			self:GotoState( "Occupied" );
		end
	end,
	OnEvent = AITrigger.OnEvent,

}

-------------------------------------------------------------------------------
-- Empty State ----------------------------------------------------------------
-------------------------------------------------------------------------------
AITrigger.Occupied =
{
	-------------------------------------------------------------------------------
	OnBeginState = function( self )

		self:Event_Enter(self.Who);
		if (self.Who and (self.Properties.bToggleStance == 1) and (self.Who.MUTANT == nil)) then 
			if (self.Who.cnt.crouching) then 
				self.Who:InsertSubpipe(0,"setup_combat");
			else
				self.Who:InsertSubpipe(0,"setup_crouch");
			end
		end
		
	end,

	-------------------------------------------------------------------------------
	OnContact = function( self,player )
		-- Ignore if disabled.

		-- if Only for AI, then check
		if (player.ai == nil) then
			return
		end


		if (self.Properties.bAILadder == 1) then 
			player.cnt:SetGravity(0.0);
		end


		--add a very small delay(so is immediate)
		if(self.Properties.ExitDelay==0) then
			self.Properties.ExitDelay=0.01;
		end

		--self:SetTimer(self.Properties.ExitDelay*1000);


	end,

	-------------------------------------------------------------------------------
	OnTimer = function( self )
		--self:Log("Sending on leave");
		--self:Event_Leave( self,self.Who );
		--self:GotoState("Empty");
	end,
	
	OnEnterArea = function( self,player,areaId )

		if (not AITrigger.EntityCanEnterOccupied(self,player)) then 
			return
		end
	
		self.NumInside = self.NumInside + 1;
	end,

	-------------------------------------------------------------------------------
	OnLeaveArea = function( self,player,areaId )
	
		if (not AITrigger.EntityCanEnterOccupied(self,player)) then 
			return
		end
		
		self.NumInside = self.NumInside - 1;
		if (self.NumInside <= 0) then
			--self:Log("Sending on leave");
			self:Event_Leave( self,self.Who );
			self:GotoState("Empty");
		end
	end,

	OnEvent = AITrigger.OnEvent,

}