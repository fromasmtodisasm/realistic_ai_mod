AutomaticDoor = {
	Properties = {
  		Direction = {
				X=1,
  			Y=0,
				Z=0,
  		},
  		CloseDelay=1.5,
  		BBOX_Size={
				X=3,
  			Y=3,
				Z=2,
  		},
  		fHitImpulse = 10,
		AISoundEvent = {
			bEnabled = 0,
			fRadius = 10,
		},
  		MovingDistance = 0.9,
  		MovingSpeed = 2,
  		bPlayerBounce = 1,
  		bPlayerOnly = 0,
		fileAnimatedModel= "MISSING.cga",
  		fileModel_Left = "Objects/glm/ww2_indust_set1/doors/door_indust_2_left.cgf",
  		fileModel_Right = "Objects/glm/ww2_indust_set1/doors/door_indust_2_right.cgf",
  		fileOpenSound = "Sounds/doors/open.wav",
  		fileCloseSound = "Sounds/doors/close.wav",
		fileUnlockSound = "sounds/items/bombactivate.wav",
  		bAutomatic = 1,
  		bCloseTimer = 1,
  		bEnabled = 1,
  		iNeededKey=-1,
		bUseAnimatedModel=0,
		bUsePortal=1,
		TextInstruction="",
		bAllowRigidBodiesToOpenDoor=1,
		--TextInstruction=Localize("NeedKey"),
  	},
  CurrModel = "Objects/lift/lift.cgf",
  temp_vec={x=0,y=0,z=0},
  Distance = 0,
  EndReached=nil,
  OpeningTime=0,
  bLocked=false,
  bInitialized=nil,
}

function AutomaticDoor:OnPropertyChange()
	self:OnReset();
	if ( self.Properties.fileOpenSound ~= self.CurrOpenSound ) then
		self.CurrOpenSound=self.Properties.fileOpenSound;
		self.OpenSound=Sound:Load3DSound(self.CurrOpenSound);
	end
	if ( self.Properties.fileCloseSound ~= self.CurrCloseSound ) then
		self.CurrCloseSound=self.Properties.fileCloseSound;
		self.CloseSound=Sound:Load3DSound(self.CurrCloseSound);
	end
end

function AutomaticDoor:OnReset()
	self.AI_SIGNAL_GENERATED=nil;
	if (self.Properties.bUseAnimatedModel==0) then
		if (self.Properties.fileModel_Right ~= "") then
			self:LoadObject( self.Properties.fileModel_Right, 0, 0 );
		end
		if (self.Properties.fileModel_Left ~= "") then
			self:LoadObject( self.Properties.fileModel_Left, 1, 0 );
		end
		self:DrawObject( 0, 1 );
		self:DrawObject( 1, 1 );
		self:CreateStaticEntity( 100,-1 ); -- -1 is surface_idx, which means 'not used'
		--self:CreateStaticEntity( 100, 1 );
	else		
		self:LoadCharacter(self.Properties.fileAnimatedModel, 0 ,0);
		self:DrawObject( 0, 1 );
	end

	self.CurrOpenSound=self.Properties.fileOpenSound;
	self.OpenSound=Sound:Load3DSound(self.CurrOpenSound);
	self.CurrCloseSound=self.Properties.fileCloseSound;
	self.CloseSound=Sound:Load3DSound(self.CurrCloseSound);
	self.CurrUnlockSound=self.Properties.fileUnlockSound;
	self.UnlockSound=Sound:Load3DSound(self.CurrUnlockSound);

	self:SetBBox({x=-(self.Properties.BBOX_Size.X*0.5),y=-(self.Properties.BBOX_Size.Y*0.5),z=-(self.Properties.BBOX_Size.Z*0.5)},
	{x=(self.Properties.BBOX_Size.X*0.5),y=(self.Properties.BBOX_Size.Y*0.5),z=(self.Properties.BBOX_Size.Z*0.5)});
	self:RegisterState("Inactive");
	self:RegisterState("Opened");
	self:RegisterState("Closed");

	if (self.Properties.iNeededKey~=-1) then
		--System:LogToConsole("Need the key!");
		self.bLocked=1;
	else
		self.bLocked=0;
	end

	if(self.Properties.bEnabled==1)then
		self:GotoState( "Closed" );
	else
		self:GotoState( "Inactive" );
	end

	if(self.MovingSpeed==0)then
		self.MovingSpeed=0.01;
	end
	--calculate how long the door to be opened
	self.OpeningTime=self.Properties.MovingDistance/self.Properties.MovingSpeed;
	self.Timer=0;
	
	self:UpdatePortal();
end


function AutomaticDoor:OnSave(stm)
	stm:WriteInt(self.bLocked);
end


function AutomaticDoor:OnLoad(stm)
	self.bLocked = stm:ReadInt();
end

function AutomaticDoor:OnInit()
	self:EnableUpdate(0);
	self:TrackColliders(1);

	if(self.bInitialized==nil)then
		self.bInitialized=1;
		self:OnReset();		
	end
end

function AutomaticDoor:Event_Open(sender)
	self:GotoState( "Opened" );
	BroadcastEvent(self, "Open");
	self:UpdatePortal();
	if (self.Properties.bUseAnimatedModel==1) then
		self:StartAnimation(0,self.Properties.Animation);
	end


	if (self.Properties.AISoundEvent.bEnabled == 1) then 
		if (sender.type == "Player") then
			Game:SetTimer(self,500,sender);
		elseif (sender.Who) then 
			Game:SetTimer(self,500,sender.Who);
		end
	end
	
	
end

function AutomaticDoor:Event_Activate(sender)
	self:GotoState( "Closed" );
	BroadcastEvent(self, "Activate");
	--System:LogToConsole("Door Active");
end

function AutomaticDoor:Event_Deactivate(sender)
	self:GotoState( "Inactive" );
	BroadcastEvent(self, "Deactivate");
	--System:LogToConsole("Door Inactive");
end

function AutomaticDoor:Event_Close(sender)
	self:GotoState( "Closed" );
	BroadcastEvent(self, "Close");
	if (self.Properties.bUseAnimatedModel==1) then
		self:StartAnimation(0,self.Properties.Animation,0,1.5,-1);
	end
end

function AutomaticDoor:Event_Opened(sender)
	self:EnableUpdate(0);
	BroadcastEvent(self, "Opened");
end

----------------------------------------------------------
function AutomaticDoor:Event_Closed(sender)
	self:EnableUpdate(0);
	BroadcastEvent(self, "Closed");
	self:UpdatePortal();
end

----------------------------------------------------------
function AutomaticDoor:Event_Unlocked(sender)
	self.bLocked=0;
	BroadcastEvent(self, "Unlocked");
	
	self:PlaySound(self.UnlockSound);
end

----------------------------------------------------------
function AutomaticDoor:Event_ForceClose(sender)
	self.bLocked=1;
	self:GotoState( "Closed" );
	self:Event_Close(self);
end

----------------------------------------------------------
function AutomaticDoor:IsCollisionFree()
	-- Check Physics Collisions.
	local colltable = self:CheckCollisions(ent_rigid+ent_sleeping_rigid+ent_living, geom_colltype0);
	if (colltable.contacts and getn(colltable.contacts)>0) then
		local contact = colltable.contacts[1];
		local collider = contact.collider; -- Collder entity.
		if (collider) then
			-- Add some impulse to object that was hit.
			contact.normal.x = -contact.normal.x;
			contact.normal.y = -contact.normal.y;
			contact.normal.z = -contact.normal.z;
			collider:AddImpulse( -1,contact.center,contact.normal,self.Properties.fHitImpulse );
		end
  	return nil;
  end
  return 1;
end

----------------------------------------------------------
--OnOpen = function (self,other)
function AutomaticDoor:OnOpen(self,other,usepressed)

	if ((not other.cnt)) then
		return 0
	end


	-- if the door is locked we need to check for the key first
	if (self.bLocked~=0) then

		if (other.keycards and (other.keycards[self.Properties.iNeededKey]==1)) then
			other.keycards[self.Properties.iNeededKey]=0;
			self:Event_Unlocked(self);				

			System:LogToConsole("Door	 unlocked !");
		else
			--System:LogToConsole("Key not available !");												

			-- this message should be shown to the local player only
			if ((other==_localplayer) and (self.Properties.iNeededKey>=0) and (strlen(self.Properties.TextInstruction)>0)) then
				Hud.label = Localize(self.Properties.TextInstruction);
			end
			self:SetTimer(100);
			return 0
		end

	end

	------
	if(self.Properties.bPlayerOnly==1 and (other.type~="Player"))then
		return
	end	

	--------------
	if (self.AI_SIGNAL_GENERATED==nil) then 
		if (self.Properties.AISoundEvent.bEnabled == 1) then 
			AI:SoundEvent(self.id,self:GetPos(),self.Properties.AISoundEvent.fRadius, 0, 10, other.id);
			self.AI_SIGNAL_GENERATED=1;
		end
	end
	


	if ((self.Properties.bAutomatic==1) or ((self.Properties.bAutomatic==0) and (usepressed==1)) and (self.EndReached==nil)) then
		self:Event_Open(self);
		return 1
	end			

	return 0
end



function AutomaticDoor:OnUse(player)
	if ( self.Properties.bAutomatic==0 and (self.Properties.bEnabled==1) and (self.bLocked==0)) then
		return (self:OnOpen(self,player,1));
	end

	return 0
end


function AutomaticDoor:UpdatePortal()
	if (self.Properties.bUsePortal==1) then
		local bOpen = self:GetState() == "Opened";	
	
		System:ActivatePortal(self:GetPos(),bOpen,self.id);
	end
end


------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- SERVER
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

AutomaticDoor["Server"]={
	OnInit = AutomaticDoor.OnInit,
	------------------------------------------------------------------------------------------
	--INACTIVE
	------------------------------------------------------------------------------------------
	Inactive = {
	},
	------------------------------------------------------------------------------------------
	--OPENED
	------------------------------------------------------------------------------------------
	Opened = {
		-- Called when Opened State is Set.
	----------------------------------------------------------
		OnBeginState = function(self)
			--System.LogToConsole("SERVER:Opened");
			if(self.Properties.bCloseTimer==1)then
				self:SetTimer(self.Properties.CloseDelay*1000);
			end
			if(self.Timer~=0)then
				Game:KillTimer(self.Timer);
			end
			self.Timer=Game:SetTimer(self,self.OpeningTime);
			self.EventSent = nil;

		end,
	----------------------------------------------------------
		OnEndState = function(self)
			Game:KillTimer(self.Timer);
			self.Timer=0;
		end,
	----------------------------------------------------------
		OnContact = function(self,other)
			--System:LogToConsole("SERVER:OnContact");
			if(self.Properties.bCloseTimer==1)then
				if(self.Properties.bPlayerOnly==1 and (other.type~="Player"))then
					return
				end
				self:SetTimer(self.Properties.CloseDelay*1000);
			end
		end,
	----------------------------------------------------------
		OnTimer = function(self)
			--System:LogToConsole("Opened State Timer Exprired");
			-- close door.
			self:GotoState( "Closed" );
			self:Event_Close(self);
		end,
	----------------------------------------------------------
		OnEvent = function(self,eid,param)
			if (type(param)=="table") then 
				if (self.AI_SIGNAL_GENERATED==nil) then 
					AI:SoundEvent(self.id,self:GetPos(),self.Properties.AISoundEvent.fRadius, 0, 1, param.id);
					self.AI_SIGNAL_GENERATED=1;
				end
			elseif ((eid==ScriptEvent_OnTimer) and (self.Properties.bUseAnimatedModel==0)) then
				self.temp_vec.x = self.Properties.Direction.X * self.Properties.MovingDistance;
				self.temp_vec.y = self.Properties.Direction.Y * self.Properties.MovingDistance;
				self.temp_vec.z = self.Properties.Direction.Z * self.Properties.MovingDistance;
				self:SetObjectPos(0,self.temp_vec);
				self.temp_vec.x =-(self.Properties.Direction.X * self.Properties.MovingDistance);
				self.temp_vec.y =-(self.Properties.Direction.Y * self.Properties.MovingDistance);
				self.temp_vec.z =-(self.Properties.Direction.Z * self.Properties.MovingDistance);
				self:SetObjectPos(1,self.temp_vec);
			end
		end
	----------------------------------------------------------
	},
	------------------------------------------------------------------------------------------
	--CLOSED
	------------------------------------------------------------------------------------------
	Closed = {
		-- Called when Closed State is Set.
		----------------------------------------------------------
		OnBeginState = function(self)
			--System.LogToConsole("SERVER:Closed");
			if(self.Timer~=0)then
				Game:KillTimer(self.Timer);
			end
			self.Timer=Game:SetTimer(self,self.OpeningTime);

			self.EventSent = nil;
			self.EndReached = nil;
		end,
		----------------------------------------------------------
		OnEndState = function(self)
			Game:KillTimer(self.Timer);
			self.Timer=0;
		end,
		----------------------------------------------------------
		OnContact = function(self, other)
			
			--System:Log("On contact,"..other:GetName()..",health="..other.cnt.health);

			if ((not other.cnt) or (not other.cnt.health) or (other.cnt.health<=0)) then
				do return end
			end

			if ( ((self.bLocked==0) and self.Properties.bAutomatic==0) and (not other.ai)) then -- ai can always open the door				
				
				-- draw this for the local player/client only
				if ((other==_localplayer)) then
					Hud.label=Localize("OpenDoor"); --"Press USE button to open the door";
				end
				do return end				
			end

			self:OnOpen(self,other,0);

		end,

		OnTimer = function( self )
			--System:LogToConsole("No contact");			
		end,
		----------------------------------------------------------
--		OnTimer = function(self)
--		end,
		----------------------------------------------------------
		OnEvent = function(self,eid)
			if ((eid==ScriptEvent_OnTimer) and (self.Properties.bUseAnimatedModel==0))
			then
				self:SetObjectPos(0, g_Vectors.v000);
				self:SetObjectPos(1, g_Vectors.v000);
			end
		end
		----------------------------------------------------------
	}
}

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- CLIENT
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
AutomaticDoor["Client"]={
	OnInit = AutomaticDoor.OnInit,
	------------------------------------------------------------------------------------------
	--INACTIVE
	------------------------------------------------------------------------------------------
	Inactive = {
	},
	------------------------------------------------------------------------------------------
	--OPENED
	------------------------------------------------------------------------------------------
	Opened = {
		----------------------------------------------------------
		-- Called when Opened State is Set.
		OnBeginState = function(self)
			self:StartAnimation(0,"default");
			--System.LogToConsole("CLIENT:Open");
			self:EnableUpdate(1);
			self.numupdates=0;

			self:UpdatePortal();			
		end,
		OnEndState = function(self)
			self:EnableUpdate(0);
		end,
		----------------------------------------------------------
		OnUpdate = function(self, dt)
			self.Distance = self.Distance + dt * self.Properties.MovingSpeed;
			if ( self.Distance > self.Properties.MovingDistance ) then
				self.Distance = self.Properties.MovingDistance;
				if ( not self.EventSent ) then
					self.Event_Opened(self);
				end
				self.EventSent = 1;
			end

			if (self.Properties.bUseAnimatedModel==0) then
				self.temp_vec.x = self.Properties.Direction.X * self.Distance;
				self.temp_vec.y = self.Properties.Direction.Y * self.Distance;
				self.temp_vec.z = self.Properties.Direction.Z * self.Distance;
				self:SetObjectPos(0,self.temp_vec);
				self.temp_vec.x = -(self.Properties.Direction.X * self.Distance);
				self.temp_vec.y = -(self.Properties.Direction.Y * self.Distance);
				self.temp_vec.z = -(self.Properties.Direction.Z * self.Distance);
				self:SetObjectPos(1,self.temp_vec);
			end

			--System:LogToConsole("Automatic door client update");

			if ((self.numupdates==5) and (self.OpenSound) and (not Sound:IsPlaying(self.OpenSound))) then
				--Sound:SetSoundPosition(self.OpenSound, self:GetPos());
				--System:LogToConsole("Automatic Door Open("..self:GetPos().x..","..self:GetPos().y..","..self:GetPos().z..",");
				self:PlaySound(self.OpenSound);
				self.bInitialized=nil;
			end

			self.numupdates=self.numupdates+1;
		end,

	},
	------------------------------------------------------------------------------------------
	--CLOSED
	------------------------------------------------------------------------------------------
	Closed = {
		-- Called when Closed State is Set.
		----------------------------------------------------------
		OnBeginState = function(self)
			self:StartAnimation(0,"close");
			--System.LogToConsole("CLIENT:Close");
			--System:LogToConsole("Automatic Door Close("..self:GetPos().x..","..self:GetPos().y..","..self:GetPos().z..",");
			self:EnableUpdate(1);			
			self.collision_updates=0;

		end,
		OnEndState = function(self)
			self:EnableUpdate(0);
		end,
		----------------------------------------------------------
		OnUpdate = function(self, dt)
			local prevDist = self.Distance;
			self.Distance = self.Distance - dt * self.Properties.MovingSpeed;

			if (self.Distance < 0 ) then
				self.Distance = 0;
				if ( not self.EventSent ) then
					self.Event_Closed(self);
				end
				self.EventSent = 1;
				--self.EndReached = 1;
			end
			
			if ((self.Properties.bAllowRigidBodiesToOpenDoor==1) and  (self.Distance > 0) ) then
				if (not self:IsCollisionFree()) then
					self.collision_updates = self.collision_updates + 1;
					if (self.collision_updates > 3) then
						self:Event_Open(self);
					end
					self.Distance = prevDist;
					return;
				end
			end
			
			if (self.Properties.bUseAnimatedModel==0) then
				local CurrPos = {};
				self.temp_vec.x = self.Properties.Direction.X * self.Distance;
				self.temp_vec.y = self.Properties.Direction.Y * self.Distance;
				self.temp_vec.z = self.Properties.Direction.Z * self.Distance;
				self:SetObjectPos(0,self.temp_vec);
				self.temp_vec.x = -(self.Properties.Direction.X * self.Distance);
				self.temp_vec.y = -(self.Properties.Direction.Y * self.Distance);
				self.temp_vec.z = -(self.Properties.Direction.Z * self.Distance);
				self:SetObjectPos(1,self.temp_vec);
			end
			
			if (not self.bInitialized) then 				
				if ((self.Distance>0) and (self.CloseSound) and (not Sound:IsPlaying(self.CloseSound))) then
					System:Log("close sound playing");
					self:PlaySound(self.CloseSound);
				end
			else
				self.bInitialized=nil;
			end
			
		end,

	}
}
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

function AutomaticDoor:OnShutDown()
end