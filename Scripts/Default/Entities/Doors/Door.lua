Door = {
	Properties = {
		CloseDelay=1.5,
		AnimationSpeed=1,
		AnimationOpen="",
		AnimationOpenBack="",
		AnimationClose="",
		vector_Bounds={x=0,y=0,z=0},
  		bPlayerOnly = 0,
		object_AnimatedModel= "",
  		
  		--sound_SoundOpen = "Sounds/doors/open.wav",
  		--sound_SoundClose = "Sounds/doors/close.wav",
  		
  		bAutomatic = 1,
  		bEnabled = 1,
  		iNeededKey=-1,
		bUsePortal=1,
		fHitImpulse = 10,
		--TextInstruction=Localize("NeedKey"),
		TextInstruction="",
		bAllowRigidBodiesToOpenDoor=1,
		bStayOpenWhenOccupied=1,
		Sound={
			sound_Open = "Sounds/doors/open.wav",
  			sound_Close = "Sounds/doors/close.wav",
			sound_Unlock = "sounds/items/bombactivate.wav",
  			InnerRadius = 1,
			OuterRadius = 25,
			nVolume = 255,
			},		
  	},
  temp_vec={x=0,y=0,z=0},
  bLocked=false,
  bEnabled = 1,
  isclosed=nil,
}

function Door:OnPropertyChange()
	self:CreateGeom();
	
	self:SetSoundProperties();
	
	local min={x=0,y=0,z=0};
	local max={x=0,y=0,z=0};
	min.x = self.min_box.x - self.Properties.vector_Bounds.x;
	min.y = self.min_box.y - self.Properties.vector_Bounds.y;
	min.z = self.min_box.z - self.Properties.vector_Bounds.z;
	--
	max.x = self.max_box.x + self.Properties.vector_Bounds.x;
	max.y = self.max_box.y + self.Properties.vector_Bounds.y;
	max.z = self.max_box.z + self.Properties.vector_Bounds.z;
	--
	self:SetBBox( min,max );
	--{x=-(self.Properties.vector_Bounds.x*0.5),y=-(self.Properties.vector_Bounds.y*0.5),z=-(self.Properties.vector_Bounds.z*0.5)},
	--{x=(self.Properties.vector_Bounds.x*0.5),y=(self.Properties.vector_Bounds.y*0.5),z=(self.Properties.vector_Bounds.z*0.5)});

	if (self.Properties.iNeededKey~=-1) then
		self.bLocked=1;
	else
		self.bLocked=0;
	end

	if(self.Properties.bEnabled==1)then
		self:GotoState( "Closed" );
		self.bEnabled=1;
	else
		self:GotoState( "Inactive" );
		self.bEnabled=0;
	end
end

function Door:SetSoundProperties()
	if ( self.Properties.Sound.sound_Open ~= self.CurrOpenSound ) then
		self.CurrOpenSound = self.Properties.Sound.sound_Open;
		self.OpenSound = Sound:Load3DSound(self.CurrOpenSound);
	end
	if (self.Properties.Sound.sound_Close ~= self.CurrCloseSound ) then
		self.CurrCloseSound=self.Properties.Sound.sound_Close;
		self.CloseSound=Sound:Load3DSound(self.CurrCloseSound);
	end
	if (self.Properties.Sound.sound_Unlock ~= self.CurrUnlockSound ) then
		self.CurrUnlockSound=self.Properties.Sound.sound_Unlock;
		self.UnlockSound=Sound:Load3DSound(self.CurrUnlockSound);
	end
	
	-- Open sound.
	Sound:SetSoundVolume(self.OpenSound, self.Properties.Sound.nVolume);
	Sound:SetMinMaxDistance(self.OpenSound, self.Properties.Sound.InnerRadius, self.Properties.Sound.OuterRadius);
	
	-- Close sound.
	Sound:SetSoundVolume(self.CloseSound, self.Properties.Sound.nVolume);
	Sound:SetMinMaxDistance(self.CloseSound, self.Properties.Sound.InnerRadius, self.Properties.Sound.OuterRadius);

	-- Unlock sound.	
	Sound:SetSoundVolume(self.UnlockSound, self.Properties.Sound.nVolume);
	Sound:SetMinMaxDistance(self.UnlockSound, self.Properties.Sound.InnerRadius, self.Properties.Sound.OuterRadius);
end

function Door:CreateGeom()
	if (self.Properties.object_AnimatedModel ~= self.AnimatedModel) then
		self.AnimatedModel = self.Properties.object_AnimatedModel;
		self:LoadCharacter(self.Properties.object_AnimatedModel,0 );
		self:ResetAnimation(0);
		self:CreateStaticEntity( 100, 0 );
		self:PhysicalizeCharacter( 100,0,0,0 );
		self:DrawCharacter( 0,1 );
		
		local bbox = self:GetLocalBBox(min,max);
		
		self.min_box = new(bbox.min);
		self.max_box = new(bbox.max);
		
		if (self.Properties.AnimationOpen ~= "") then
			self.AnimationLength = self:GetAnimationLength( self.Properties.AnimationOpen );
		else
			self.AnimationLength = self:GetAnimationLength( "Default" );
		end
	end
end

----------------------------------------------------------
function Door:IsCollisionFree()
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
			collider:AddImpulse( contact.partid1,contact.center,contact.normal,self.Properties.fHitImpulse );
		end
  	return nil;
  end
  return 1;
end

function Door:CanOpenDoor( entity )
	if (self.Properties.bPlayerOnly==1 and entity ~= _localplayer) then
		return 0;
	end

	if (entity.ai ~= nil and entity.type ~= "Player") then
		-- Not AI, Not Player, Doors not opens.
		return 0;
	end

	if ((not entity.cnt) or (not entity.cnt.health) or (entity.cnt.health<=0)) then
		return 0;
	end

	return 1;
end

function Door:OnReset()

	--System:Log("ON RESET ("..self:GetName()..") ");

	if (self.Properties.bUsePortal==1) then
		System:ActivatePortal(self:GetPos(),0,self.id);
	end
	self:Event_Closed(self);

	self.refcounter=0;
end

function Door:Event_Unlocked(sender)
	self.bLocked=0;
	BroadcastEvent(self, "Unlocked");
	self:PlaySound(self.UnlockSound);
end

function Door:Event_Relocate(sender)
	local point = Game:GetTagPoint(self:GetName().."_RELOCATE");
	if (point) then 
		self:SetPos({x=point.x,y=point.y,z=point.z});
	else
		System:Warning( "Entity "..self:GetName().." received a relocate event but has no relocate tagpoint");
	end
	BroadcastEvent(self, "Relocate");

end


function Door:OnSave(stm)
	--System:Log("EVENT SAVE ("..self:GetName()..") ");
	stm:WriteInt(self.bEnabled);
	stm:WriteInt(self.bLocked);
end


function Door:OnLoad(stm)
	--System:Log("ON LOAD ("..self:GetName()..") ");
	self.bEnabled=stm:ReadInt();
	self.bLocked = stm:ReadInt();
	self.justloaded=1;
end

function Door:OnInit()
	self.refcounter=0;

	--System:Log("ON INIT ("..self:GetName()..") ");
	self:EnableUpdate(0);
	self:TrackColliders(1);

	self:RegisterState("Inactive");
	self:RegisterState("Opened");
	self:RegisterState("Closed");
	self:RegisterState("Opening");
	self:RegisterState("Closing");
	
	self:OnPropertyChange();
	self:OnReset();
end

--function Door:Log( msg )
--	System:Log( msg );
--end

function Door:OpenDoor(bPlayFront)

	local sAnimName = "default";
	if (bPlayFront == 0) then
		-- Play back open animation.
		--System:Log("PLAY OPEN  BACK ("..self:GetName()..") ");
		sAnimName = self.Properties.AnimationOpenBack;
	else
		-- Player front open animation.
		--System:Log("PLAY OPEN  FRONT ("..self:GetName()..") ");
		if (self.Properties.AnimationOpen ~= "") then
			sAnimName = self.Properties.AnimationOpen;
		end
	end
	
	if (self:GetState() == "Closing" and self.Properties.AnimationClose == "") then
		self:SetAnimationSpeed(self.Properties.AnimationSpeed);
	else
		self:StartAnimation(0,sAnimName,0,0.5,self.Properties.AnimationSpeed);
	end
end


function Door:Event_Open(sender)

	if (self.lastEvent ~= 1) then
--		System:Log("**EVENT** Open");
		self.lastEvent = 1;
		BroadcastEvent(self, "Open");
		
--		System:Log("EVENT OPEN ("..self:GetName()..") ");

		if (Sound:IsPlaying(self.OpenSound)~=1) then
			self:PlaySound(self.OpenSound);
		end
		
		if (self.Properties.bUsePortal==1) then
			System:ActivatePortal(self:GetPos(),1,self.id);
			--System:Log("Portal Active!");
		end
		
		local bPlayFront = 1;
		if (self.Properties.AnimationOpenBack ~= "" and self.WhoOpens ~= nil) then
			local vD = new(self:GetDirectionVector()); -- door direction vector
			local doorPos = new(self:GetPos());
			local playerPos = new(self.WhoOpens:GetPos());
			local vP = { -- Player to door direction vector.
				x = playerPos.x - doorPos.x,
				y = playerPos.y - doorPos.y,
				z = playerPos.z - doorPos.z
			};
			-- Dot product of Player to door with door direction vectors will give cos of angle between them.
			local cosa = vP.x*vD.x + vP.y*vD.y + vP.z*vD.z;
			-- Check if cosa is positive then player facing door front, overwise player facing door back.
			if (cosa >= 0) then 
				--System:Log("Play Front cosa="..playerPos.x);
				bPlayFront = 1;
			else
				--System:Log("Play Back cosa="..cosa);
				bPlayFront = 0;
			end
		end

		self:OpenDoor(bPlayFront);
		
		self:GotoState( "Opening" );
	end
	self.WhoOpens = nil;
end

function Door:Event_Activate(sender)
	self:GotoState( "Closed" );
	BroadcastEvent(self, "Activate");
	self.bEnabled=1;
end

function Door:Event_Deactivate(sender)
	self:GotoState( "Inactive" );
	BroadcastEvent(self, "Deactivate");
	self.bEnabled=0;
end

function Door:Event_Close(sender)
	if (self.lastEvent ~= 2) then
--		System:Log("**EVENT** Close");
		self.lastEvent = 2;
		BroadcastEvent(self, "Close");
		
		if (Sound:IsPlaying(self.CloseSound)~=1) then
			self:PlaySound(self.CloseSound);
		end
		
		if (self.Properties.AnimationClose ~= "") then
			--System:Log("*STAR ANIM CLOSE");
			self:StartAnimation(0,self.Properties.AnimationClose,0,0.5,self.Properties.AnimationSpeed);
		else
			self:SetAnimationSpeed(-self.Properties.AnimationSpeed);
		end
		self:GotoState( "Closing" );
	end
end

function Door:Event_Opened(sender)
	if (self.lastEvent ~= 3) then
--		System:Log("**EVENT** Opened");
		self.lastEvent = 3;
		BroadcastEvent(self, "Opened");
		self:GotoState( "Opened" );
	end
end

function Door:Event_Closed(sender)
	if (self.lastEvent ~= 4) then
--		System:Log("**EVENT** Closed");
		self.lastEvent = 4;
		BroadcastEvent(self, "Closed");
		if (self.Properties.bUsePortal==1) then
			--System:Log("Portal Deactivated");
			System:ActivatePortal(self:GetPos(),0,self.id);
		end
		-- Stop all animtions.
		--System:Log("Reset Anim");
		self:ResetAnimation(0);
		self:GotoState( "Closed" );
	end
end


----------------------------------------------------------
function Door:HasKeycard(player)
	if (player.keycards and (player.keycards[self.Properties.iNeededKey]==1)) then
		return 1;
	end
	return nil;
end

----------------------------------------------------------
function Door:OnOpen(self,other,usepressed)

	if ((not other.cnt)) then
		return 0
	end

	-- if the door is locked we need to check for the key first
	if (self.bLocked~=0) then

		if (not self:HasKeycard(other)) then
			-- this message should be shown to the local player only
			if ((other==_localplayer) and self.Properties.iNeededKey>=0) then
				Hud.label = self.Properties.TextInstruction;
			end
			self:SetTimer(100);
			return 0
		end
	end
	------
	
	if (self:CanOpenDoor( other ) == 0) then
		return 0
	end

	if (other.ai) then 
		usepressed = 1;
	end
	
	self.WhoOpens = other;

	if ((self.Properties.bAutomatic==1) or ((self.Properties.bAutomatic==0) and (usepressed==1)) ) then
		if (self.bLocked~=0) then
			if (self:HasKeycard(other)) then
				other.keycards[self.Properties.iNeededKey]=0;
				self:Event_Unlocked(self);
			end
		end
		
		self:Event_Open(self);
		return 1
	end			

	return 1

end

------------------------------------------------------------------------------------------
function Door:OnUse(player)
	
	if ( self.isclosed and self.Properties.bAutomatic==0 and (self.bEnabled==1)) then
		self:OnOpen(self,player,1);
		return 1;
	end

	return 0;
end

------------------------------------------------------------------------------------------
function Door:DecRefCount(entity,areaId)
	--System:Log("LEAVE AREA");

	if (self:CanOpenDoor( entity ) == 1) then
		self.bCanOpen=0;
		self.bCanClose=1;
	end

	self.refcounter=self.refcounter-1;
	--System:Log("REF COUNTER LEAVE="..self.refcounter);
	if (self.refcounter<0) then
		self.refcounter=0;
	end
end



------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- SERVER
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
Door["Server"]={
	OnInit = Door.OnInit,
	------------------------------------------------------------------------------------------
	--INACTIVE
	------------------------------------------------------------------------------------------
	Inactive = {
	},
	------------------------------------------------------------------------------------------
	--OPENING
	------------------------------------------------------------------------------------------
	Opening = {
		----------------------------------------------------------
		-- Called when Opened State is Set.
		OnBeginState = function(self)			
--			System:Log("BEGIN OPENING "..self:GetName());
			--self:SetTimer( self.AnimationLength*1000/self.Properties.AnimationSpeed + 200000 );
			self:Event_Open(self);
			self.isclosed=nil;
			self.animTime = -1;

			self.justloaded=nil;
			self:EnableUpdate(1);
		end,
		OnEndState = function(self)
			self:EnableUpdate(0);
		end,
		----------------------------------------------------------
		OnTimer = function(self)
			self:Event_Opened(self);
		end,
		
		----------------------------------------------------------
		-- Check if still opening.
		----------------------------------------------------------
		OnUpdate = function(self,dt)
			local t = self:GetAnimationTime(0,0);
			if (t == self.animTime) then
				self:Event_Opened(self);
			end
			self.animTime = t;
		end,

		-- [marco] the entity can leave the area while the door is opening
		-------------------------------------------------------------------------------
		OnLeaveArea = function( self,entity,areaId )
			self:DecRefCount(entity,areaId);
		end,

	},
	------------------------------------------------------------------------------------------
	--OPENED
	------------------------------------------------------------------------------------------
	Opened = {
		-- Called when Opened State is Set.
	----------------------------------------------------------
		OnBeginState = function(self)			
--			System:Log("BEGIN OPENED "..self:GetName());
			self:SetTimer( self.Properties.CloseDelay*1000+1 );
			self:Event_Opened(self);
			--self.bCanClose=0;
			self.isclosed=nil;

			-- [marco] it happens that in some weird situation
			-- the door is saved when it was opened, but during reloading
			-- from savegame, the door was saved to be opened, but
			-- an entity was entering the door bbox before the door
			-- was going to open and play anim, so ref counter was increased
			-- as it is opened, the entity is stuck in the middle but the  
			-- animation wasn't played so the player can't push the door
			-- opening the door twice anyway should not cause any problem
			if (self.justloaded) then
				self:Event_Open(self);
				self.justloaded=nil;
			end
		end,
	----------------------------------------------------------
		OnContact = function(self,other)
			--System:LogToConsole("SERVER:OnContact");
			if (self:CanOpenDoor( other ) == 0) then
				return
			end
			
			-- Restart timer again.
			self:SetTimer( self.Properties.CloseDelay*1000+1 );			
		end,
		----------------------------------------------------------
		OnTimer = function(self)
			--System:Log("onTIMER check, bCanClose="..self.bCanClose..",refcounter="..self.refcounter);
			if (self.Properties.bStayOpenWhenOccupied == 1) then

				if (not self:IsCollisionFree()) then
					self:SetTimer( self.Properties.CloseDelay*1000+1 );
					do return end
				end

				if (self.bCanClose==1 and self.refcounter==0) then
					self:Event_Close(self);
				else
					self:SetTimer( self.Properties.CloseDelay*1000+1 );
				end
			else
				self:Event_Close(self);
			end
		end,

		-------------------------------------------------------------------------------
		OnLeaveArea = function( self,entity,areaId )
			self:DecRefCount(entity,areaId);
		end,

		-------------------------------------------------------------------------------
		OnEnterArea = function( self,entity,areaId )
			
			if (self:CanOpenDoor( entity ) == 1) then
				self.refcounter=self.refcounter+1;
--				System:Log("OPEN STATUS "..self:GetName().." - REF COUNTER ENTER="..self.refcounter);
			end
		end,

	},
	
	------------------------------------------------------------------------------------------
	--CLOSING
	------------------------------------------------------------------------------------------
	Closing = {
		----------------------------------------------------------
		-- Called when Opened State is Set.
		OnBeginState = function(self)
--			System:Log("BEGIN CLOSING "..self:GetName());
			--self:SetTimer( self.AnimationLength*1000/self.Properties.AnimationSpeed );
			self:Event_Close(self);
			self.bCanOpen=0;
			self.isclosed=nil;
			self.animTime = -1;
			
			self.justloaded=nil;
			self:EnableUpdate(1);
		end,
		OnEndState = function(self)
			self:EnableUpdate(0);
		end,

		----------------------------------------------------------
		OnContact = function(self, other)
			
			if (self:CanOpenDoor( other ) == 1) then
				self.bCanOpen=1;
				self.bCanClose=0;

				--self.refcounter=self.refcounter+1;
				--System:Log("REF COUNTER ENTER="..self.refcounter);

			end			
		end,
		
		-------------------------------------------------------------------------------
		-- Check if still opening.
		-------------------------------------------------------------------------------
		OnUpdate = function( self,dt )
			if ((self.Properties.bAllowRigidBodiesToOpenDoor==1) and (not self:IsCollisionFree())) then
				--System:Log("Calling EVENT OPEN");
				self:Event_Open(self);
				do return end
			end
			
			--System:Log("Calling EVENT CLOSED");
			local t = self:GetAnimationTime(0,0);
			if (t == self.animTime) then
				self:Event_Closed(self);
			end
			self.animTime = t;
		end,

		-------------------------------------------------------------------------------
		OnEnterArea = function( self,entity,areaId )

			--System:Log("ENTER AREA");

			if (self:CanOpenDoor( entity ) == 1) then
				self.bCanOpen=1;
				self.bCanClose=0;

				self.refcounter=self.refcounter+1;
				--System:Log("CLOSING STATUS - REF COUNTER ENTER="..self.refcounter);

			end
		end,

	},

	------------------------------------------------------------------------------------------
	--CLOSED
	------------------------------------------------------------------------------------------
	Closed = {
		-- Called when Closed State is Set.
		----------------------------------------------------------
		OnBeginState = function(self)
			self:Event_Closed(self);
			self.isclosed=1;

			self.justloaded=nil;
		end,
		----------------------------------------------------------
		OnContact = function(self, other)
			
--			System:Log("ON CONTACT");

			if ( ((self.bLocked==0 or self:HasKeycard(other)) and self.Properties.bAutomatic==0) and (not other.ai)) then -- ai can always open the door				
				-- draw this for the local player/client only
				if (other==_localplayer) then
					Hud.label=Localize("OpenDoor"); --"Press USE button to open the door";
				end
				do return end
			end

--			System:Log("CAN OPEN - 1");

			if (self.bCanOpen==1) then
--				System:Log("CAN OPEN - 2 - OPEN!!");
				self:OnOpen(self,other,0);
			end
			
		end,
		OnTimer = function( self )
			--System:LogToConsole("No contact");
			--self.MsgShown=nil;
		end,

		-------------------------------------------------------------------------------
		OnEnterArea = function( self,entity,areaId )

--			System:Log("ENTER AREA");

			if (self:CanOpenDoor( entity ) == 1) then
				self.bCanOpen=1;
				self.bCanClose=0;

				self.refcounter=self.refcounter+1;
--				System:Log("CLOSED STATUS - REF COUNTER ENTER="..self.refcounter);

			end
		end,
	},
}

------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- CLIENT
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
Door["Client"]={
	OnInit = Door.OnInit,
	------------------------------------------------------------------------------------------
	--INACTIVE
	------------------------------------------------------------------------------------------
	Inactive = {
	},
	------------------------------------------------------------------------------------------
	--OPENING
	------------------------------------------------------------------------------------------
	Opening = {
		----------------------------------------------------------
		-- Called when Opened State is Set.
		OnBeginState = function(self)
			--self:SetTimer( self.AnimationLength*1000/self.Properties.AnimationSpeed );
			self:Event_Open(self);
			self:EnableUpdate(1);
		end,
		OnEndState = function(self)
			self:EnableUpdate(0);
		end,
		----------------------------------------------------------
		OnTimer = function(self)
			self:Event_Opened(self);
		end,
	},
	------------------------------------------------------------------------------------------
	--OPENED
	------------------------------------------------------------------------------------------
	Opened = {
		----------------------------------------------------------
		-- Called when Opened State is Set.
		OnBeginState = function(self)
			self:Event_Opened(self);
		end,
	},
	
	------------------------------------------------------------------------------------------
	--CLOSING
	------------------------------------------------------------------------------------------
	Closing = {
		----------------------------------------------------------
		-- Called when Opened State is Set.
		OnBeginState = function(self)
			--self:SetTimer( self.AnimationLength*1000/self.Properties.AnimationSpeed );
			self:Event_Close(self);
			self:EnableUpdate(1);
		end,
		OnEndState = function(self)
			self:EnableUpdate(0);
		end,
		----------------------------------------------------------
		OnTimer = function(self)
			self:Event_Closed(self);
		end,
	},
	------------------------------------------------------------------------------------------
	--CLOSED
	------------------------------------------------------------------------------------------
	Closed = {
		-- Called when Closed State is Set.
		----------------------------------------------------------
		OnBeginState = function(self)
			self:Event_Closed(self);
		end,
	}
}
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

function Door:OnShutDown()
end