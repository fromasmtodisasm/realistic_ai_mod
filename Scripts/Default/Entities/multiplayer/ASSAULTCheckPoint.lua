ASSAULTCheckPoint={
	Properties={
		CheckPoint_Number=1,		-- any value, only the order matters
		bAttackerSpawnPoint=1,	-- 0/1=this point is a possible spawnpoint for the attacker (used by ASSAULT GameRules)
		bDefenderSpawnPoint=1,	-- 0/1=this point is a possible spawnpoint for the defender (used by ASSAULT GameRules)
		bVisible=1,							-- 0/1=visible and collision with attacker is recognized
		WarmupTime=15,					-- time in second till you are able to capture it
	},

	Editor={
		Model="Objects/Editor/assaultspawn.cgf",
	},
	
	FlagEntityID=nil,					-- EntityID,  nil=not created
	fRaiseTime=10, 						-- time in seconds it takes to raise the flag
	fCaptureRadius = 1.5,			-- distance from 
}


-------------------------------------------------------------------------------
function ASSAULTCheckPoint:LoadGeometry()
	self:LoadObject("objects/multiplayer/flagbase/flagbase_captured.cgf",0,1);				-- Spawn
	self:LoadObject("objects/multiplayer/flagbase/flagbase_inactive.cgf",1,1);				-- Touched
	self:LoadObject("objects/multiplayer/flagbase/flagbase_active.cgf",2,1);					-- Untouched
	self:LoadObject("objects/multiplayer/flagbase/flagbase_capturing.cgf",3,1);				-- Capturing
	self:LoadObject("objects/multiplayer/flagbase/flagbase_inactive.cgf",4,1);				-- Blocked
	self:LoadObject("objects/multiplayer/flagbase/flagbase_inactive.cgf",5,1);				-- Warmup
	
	self:UpdatePhysicsMesh();
end

-------------------------------------------------------------------------------
function ASSAULTCheckPoint:RegisterStates()
	self:RegisterState("Spawn");				-- acts as the current spawnpoint
	self:RegisterState("Blocked");			-- you have to capture other checkpoints before
	self:RegisterState("Warmup");				-- you have to wait then it goes to Untouched state
	self:RegisterState("Untouched");		-- you have to capture it
	self:RegisterState("Capturing");		-- attacker is touching it
	self:RegisterState("Touched");			-- no longer needed
end


	
-------------------------------------------------------------------------------
function ASSAULTCheckPoint:OnMultiplayerReset()
	self:OnReset();
end

-------------------------------------------------------------------------------
function ASSAULTCheckPoint:OnReset()
	-- remove all the references to this checkpoint from the list of potential
	-- capture colliders
	self.captureCollider = nil;
	self.cannotCapture = nil;
	
	if Game:IsServer() then
		if self.Properties.bVisible then
			self:Event_Blocked();
		else
			self:Event_Spawn();
		end
	end

	self:UpdateRendermesh();
	self:UpdatePhysicsMesh();
end


-------------------------------------------------------------------------------
-- for editor support
function ASSAULTCheckPoint:OnPropertyChange()
	self:OnReset();
	self:UpdateRendermesh();
	sefl:UpdatePhysicsMesh();
end


-- change state
-------------------------------------------------------------------------------
function ASSAULTCheckPoint:Event_Spawn()
	if self.Properties.bVisible==1 then		-- only visible ones have to be syncronized over network
		self:GotoState("Spawn");
	end
	BroadcastEvent(self, "Spawn");		-- beware circular endless loop is possible
end

function ASSAULTCheckPoint:Event_Averted()
	self.captureCollider = nil;
	self.cannotCapture = nil;
	self:Event_Untouched();
--	Server:BroadcastText("@AvertCapture"); -- Attackers have begun to 
	Server:BroadcastCommand("AVC");					-- play avert sound
	GameRules:OnCaptureStep_Touchable(self.Properties.CheckPoint_Number);
end

-------------------------------------------------------------------------------
function ASSAULTCheckPoint:Event_Touched()
	if self.Properties.bVisible==1 then		-- only visible ones have to be syncronized over network
		self:GotoState("Touched");
	end
	BroadcastEvent(self, "Touched");		-- beware circular endless loop is possible
end

-------------------------------------------------------------------------------
function ASSAULTCheckPoint:Event_Untouched()
	if self.Properties.bVisible==1 then		-- only visible ones have to be syncronized over network
		self:GotoState("Untouched");
	end
	BroadcastEvent(self, "Untouched");		-- beware circular endless loop is possible
end

-------------------------------------------------------------------------------
function ASSAULTCheckPoint:Event_Capturing()
	if self.Properties.bVisible==1 then		-- only visible ones have to be syncronized over network
		self:GotoState("Capturing");
		local ss=Server:GetServerSlotBySSId(self.captureCollider);
		if toNumberOrZero(getglobal("gr_flag_startcapture_message"))==1 then
			local flagsact=SVplayerTrack:GetBySs(ss,"flagsactivated")+1;
			Server:BroadcastText("$4>$2>$4> "..ss:GetName().."$6 has activated the flag $4<$2<$4< $6("..flagsact.." total)");
		end
		if toNumberOrZero(getglobal("gr_rm_needed_kills"))>0 then
			SVplayerTrack:RMFlagActivated(ss);
		end
		SVplayerTrack:SetBySs(ss,"flagsactivated",1,1);
		MPStatistics:AddStatisticsDataSSId(self.captureCollider, "nCaptureStarted", 1);
	end
	BroadcastEvent(self, "Capturing");		-- beware circular endless loop is possible
	
end

-------------------------------------------------------------------------------
function ASSAULTCheckPoint:Event_Blocked()
	if self.Properties.bVisible==1 then		-- only visible ones have to be syncronized over network
		self:GotoState("Blocked");
	end
	BroadcastEvent(self, "Blocked");		-- beware circular endless loop is possible
end

-------------------------------------------------------------------------------
function ASSAULTCheckPoint:Event_Warmup()
	if self.Properties.bVisible==1 then		-- only visible ones have to be syncronized over network
		self:GotoState("Warmup");
	end
	BroadcastEvent(self, "Warmup");		-- beware circular endless loop is possible
end

-------------------------------------------------------------------------------
-- react on event from outside
function ASSAULTCheckPoint:Event_AttackerTouch()
	if(GameRules.GetState==nil or GameRules:GetState()~="INPROGRESS") then return end
	GameRules:TouchedCheckpoint(self, nil);		-- nil because there is no collider
end




-------------------------------------------------------------------------------
function ASSAULTCheckPoint:UpdateRendermesh()

	local state=self:GetState();
	local vis=self.Properties.bVisible;

	if state=="Spawn" then
		self:DrawObject(0,vis);
	else
		self:DrawObject(0,0);
	end
	
	if state=="Touched" then 
		self:DrawObject(1,vis);
	else
		self:DrawObject(1,0);
	end
	
	if state=="Untouched" then 
		self:DrawObject(2,vis);
	else
		self:DrawObject(2,0);
	end
	
	if state=="Capturing" then 
		self:DrawObject(3,vis);
	else
		self:DrawObject(3,0);
	end
	
	if state=="Blocked" then 
		self:DrawObject(4,vis);
	else
		self:DrawObject(4,0);
	end

	if state=="Warmup" then 
		self:DrawObject(5,vis);
	else
		self:DrawObject(5,0);
	end
end


function ASSAULTCheckPoint:UpdatePhysicsMesh()
	-- make sure all the physics stuff in our surroundings gets updated
	self:AwakeEnvironment();

	local vis=self.Properties.bVisible;
	
	if(vis==0)then
		self:DestroyPhysics();
	else
		local state= self:GetState();
		
		if state=="Spawn" then
			self:CreateStaticEntity(2,-1,0);
		elseif state=="Touched" then
			self:CreateStaticEntity(2,-1,1);
		elseif state=="Untouched" then
			self:CreateStaticEntity(2,-1,2);
		elseif state=="Capturing" then
			self:CreateStaticEntity(2,-1,3);
		elseif state=="Blocked" then
			self:CreateStaticEntity(2,-1,4);
		elseif state=="Warmup" then
			self:CreateStaticEntity(2,-1,5);
		end
	end
end

-------------------------------------------------------------------------------
function ASSAULTCheckPoint:RecreateAttachedEntity()
	-- remove flag
	if self.FlagEntityID then
		local Flag=System:GetEntity(self.FlagEntityID);
		Server:RemoveEntity(self.FlagEntityID);
		self.FlagEntityID=nil;
	end

	-- create flag
	if self.Properties.bVisible~=0 then
		local pos=self:GetPos();

		local classid=Game:GetEntityClassIDByClassName("FlagEntity");
		local Flag=Server:SpawnEntity(classid,pos);
		if not Flag then
			printf("ASSAULTCheckPoint [Flag Entity creation failed]");
			return;
		end
		Flag.ASSAULTCheckPointID=self.id;
		self.FlagEntityID=Flag.id;
	end
end
-------------------------------------------------------------------------------
function ASSAULTCheckPoint:IsInRange(entity)
	local selfPos = new(self:GetPos()); 
	local entityPos = new(entity:GetPos());
	
	local x = selfPos.x - entityPos.x;
	local y = selfPos.y - entityPos.y;
	
	if ((x*x + y*y) < (self.fCaptureRadius*self.fCaptureRadius)) then
		return 1;
	end
end

-------------------------------------------------------------------------------
-- on the client we have different states, but they all work the same (except spawn)
-- this functionality is represented in the following block (no need
-- to write it 4 times in a row)
ASSAULTCheckPoint.ClientCommonStateBlock = {
	OnBeginState=function(self)
		self:UpdateRendermesh();
		self:UpdatePhysicsMesh();
	end,
}


----------------------------------------------------
--SERVER
----------------------------------------------------
ASSAULTCheckPoint.Server={
	OnInit=function(self)
		self:LoadGeometry();
		self:RegisterStates();
		self:OnReset();
		self:RecreateAttachedEntity();
		self:NetPresent(nil);
		self:EnableUpdate(1);
	end,
-------------------------------------
	Spawn={
		OnBeginState=function(self)
			self:UpdatePhysicsMesh();

			if self.FlagEntityID then
				local Flag=System:GetEntity(self.FlagEntityID);
				Flag:GotoState("up");
			end
		end,
	},
-------------------------------------
	Touched={
		OnBeginState=function(self)
			self:UpdatePhysicsMesh();

			if self.FlagEntityID then
				local Flag=System:GetEntity(self.FlagEntityID);
				Flag:GotoState("down");
			end
		end,
	},
-------------------------------------
	Untouched =
	{
		OnBeginState=function(self)
			self:UpdatePhysicsMesh();
			
			self.cannotCapture = 1;
			self.captureCollider = nil;
			
			self:KillTimer();
			self:SetTimer(1);
			
			GameRules:OnCaptureStep_Touchable(self.Properties.CheckPoint_Number);
			
			if self.FlagEntityID then
				local Flag=System:GetEntity(self.FlagEntityID);
				Flag:GotoState("down");
			end
		end,

		OnContact = function(self, collider)
			if (self.Properties.bVisible~=1 or not GameRules or not GameRules.IsCheckpointTouchable) then
				return;
			end
	
			if collider.type=="Player" and (self:IsInRange(collider)==1) and (collider.cnt.health>0) then
--				System:Log("Untouched Contact");
				-- only attackers can initiate the capture
				if (GameRules:IsAttacker(collider) and (self.captureCollider == nil)) then
					-- set a timer event to happen as fast as possible (next frame)
					
					local Slot = Server:GetServerSlotByEntityId(collider.id);
					self.captureCollider = Slot:GetId();
					
					self:SetTimer(1);	 -- milliseconds
--					System:Log("Untouched Contact(Attacker)");
				elseif (GameRules:IsDefender(collider)) then
--					System:Log("Untouched Contact(Defender)");
					-- if a defender touches it during this frame.. then nothing happens
					self.cannotCapture = 1;
					self.captureCollider = nil;
					self:SetTimer(1);	 -- milliseconds
				end
			end
		end,

		OnTimer = function(self)
			if (self.cannotCapture)then
--				System:Log("Untouched OnTimer CANNOT");
				self.cannotCapture = nil;
				self.captureCollider = nil;
			elseif (self.captureCollider) then
--				System:Log("Untouched OnTimer CAN");
				local touch=GameRules:IsCheckpointTouchableSSId(self, self.captureCollider);		-- nil=no / 1=yes / 2=not yet
				if (touch==1) then
					self:Event_Capturing();
				end
			end
		end,
	},
-------------------------------------
	Capturing =
	{
		OnBeginState=function(self)
			self:UpdatePhysicsMesh();

			self:KillTimer();
			self:SetTimer(self.fRaiseTime * 1000 / GameRules:GetCaptureStepCount());
--			Server:BroadcastText("@BeginCapture"); -- Attackers have begun to 
			GameRules:OnCaptureStep_Next();

			if self.FlagEntityID then
				local Flag=System:GetEntity(self.FlagEntityID);
				Flag:GotoState("down");
			end
		end,

		OnContact = function(self, collider)
			if (self.Properties.bVisible~=1 or not GameRules or not GameRules.IsCheckpointTouchable) then
				return;
			end
			
--			System:Log("Capturing OnContact");

			-- only defendes can untouch the checkpoint
			if (GameRules:IsDefender(collider) and (self:IsInRange(collider) == 1)) then
				local touch=GameRules:IsCheckpointTouchable(self, collider);		-- nil=no / 1=yes / 2=not yet
				
				if (touch==1) then
					MPStatistics:AddStatisticsDataEntity(collider, "nCaptureAverted", 1);
					self:Event_Averted();
					local ss = Server:GetServerSlotByEntityId(collider.id);
					
					if toNumberOrZero(getglobal("gr_flag_saved_message"))==1 then
						local flagssaved=SVplayerTrack:GetBySs(ss,"flagssaved")+1;
						Server:BroadcastText("$4>$2>$4> "..ss:GetName().."$6 saved the flag $4<$2<$4< $6("..flagssaved.." total)");
					end
					SVplayerTrack:SetBySs(ss,"flagssaved", 1, 1);
					if toNumberOrZero(getglobal("gr_rm_needed_kills"))>0 then
						SVplayerTrack:RMFlagSaved();
					end
					
				end
			end
		end,
				
		-- capture timer ... times up
		OnTimer = function(self)
			if GameRules:GetGameState()~=CGS_INPROGRESS then		-- pause when game is not progress
				self:Event_Averted();
				return;
			end

--			System:Log("Capturing OnTimer");
			if self.captureCollider then
				if GameRules:OnCaptureStep_Next()~=nil then
					GameRules:TouchedCheckpoint(self, self.captureCollider);
				else
					self:SetTimer(self.fRaiseTime * 1000 / GameRules:GetCaptureStepCount());
				end
			end
		end,
	},	
-------------------------------------
	-- we only want to display the message about 'not being able to capture a blocked ckeckpoint'
	-- once for a collider. Unfortunately, the 'area' of the entity is bigger than the area of
	-- contact for the touching process, so we cannot just handle it with an OnEnterArea event.
	-- What we do is, that a collider gets a 'token' which tells the OnContact event that he has not
	-- received this message, yet. Upon giving
	Blocked =
	{
		OnBeginState=function(self)
			self:UpdatePhysicsMesh();

			self:KillTimer();
			self:TrackColliders(1);

			if self.FlagEntityID then
				local Flag=System:GetEntity(self.FlagEntityID);
				Flag:GotoState("down");
			end
		end,

		OnEnterArea = function( self,collider )
			collider.messageToken = 1;
		end,
		
		OnContact = function(self, collider)
			if (self.Properties.bVisible~=1 or not GameRules or not GameRules.IsCheckpointTouchable) then
				return;
			end
			
			if (GameRules:IsAttacker(collider) and self.captureCollider == nil and (self:IsInRange(collider) == 1)) then
				local slot=Server:GetServerSlotByEntityId(collider.id);
				if(slot and collider.messageToken~=nil)then
					slot:SendText("@CaptureNotYet",3);
					collider.messageToken = nil;
				end
			end
		end,
		OnLeaveArea = function( self,collider )
			collider.messageToken = nil;
		end,

		OnEndState=function(self)
			self:TrackColliders(0);
		end,
	},	
-------------------------------------
	Warmup = 
	{
		OnBeginState=function(self)
			self:UpdatePhysicsMesh();

			self:SetTimer(self.Properties.WarmupTime*1000);
			if self.FlagEntityID then
				local Flag=System:GetEntity(self.FlagEntityID);
				Flag:GotoState("down");
			end
		end,
		OnTimer = function(self)
			if GameRules:GetGameState()~=CGS_INPROGRESS then		-- pause when game is not progress
				return;
			end

			self:Event_Untouched();
		end,
	},
}

----------------------------------------------------
--CLIENT
----------------------------------------------------
ASSAULTCheckPoint.Client={
	OnInit=function(self)
		self:LoadGeometry()
		self:RegisterStates();
		self:OnReset();
	end,
-------------------------------------
	Spawn = ASSAULTCheckPoint.ClientCommonStateBlock,
-------------------------------------
	Touched = ASSAULTCheckPoint.ClientCommonStateBlock,
-------------------------------------
	Untouched = ASSAULTCheckPoint.ClientCommonStateBlock,
-------------------------------------
	Capturing = ASSAULTCheckPoint.ClientCommonStateBlock,
-------------------------------------
	Blocked = ASSAULTCheckPoint.ClientCommonStateBlock,
-------------------------------------
	Warmup = ASSAULTCheckPoint.ClientCommonStateBlock,
}
