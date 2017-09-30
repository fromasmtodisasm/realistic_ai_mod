-- used for the ASSAULTCheckPoint

FlagEntity = {
	Properties = {
--		object_Model_NonPhysicFlag="Objects/testcloth.cgf",
--		object_Model_PhysicFlag="Objects/testcloth.cgf",
		object_Model_Supporter="objects/multiplayer/flagbase/flagpole_supporter.cgf",
		object_Model_Supporter_Animated="objects/multiplayer/flagbase/mp_flag_animated.cgf",
	},

	ASSAULTCheckPointID=nil,	-- set by the creator, creator of this object
--	ClothEntityID=nil,			-- EntityID,  nil=not created
	fRaiseHeight=0.0,			-- 0=lowered .. 1=raised
	
	use_animated = 1,
	animation_state = 0,--0 = is down, 1 = is up
	is_moving = 0,
}


-------------------------------------------------------------------------------
function FlagEntity:OnReset()
	self.fRaiseHeight=0.0;
	self:GotoState("down");
end


-------------------------------------------------------------------------------
function FlagEntity:LoadGeometry()
	
	if (self.use_animated) then
		self:LoadCharacter(self.Properties.object_Model_Supporter_Animated, 0);
		self:DrawCharacter(0,1);
		self:ResetAnimation(0);
		self:StartAnimation(0,"flag_bottom",0,0,1,1);
	else	
		self:LoadObject( self.Properties.object_Model_Supporter, 0, 0 );
		self:DrawObject( 0, 1 );
	end
--	self:CreateRigidBody( 0,0,-1 );		-- has to be physicalized to attach objects to it
	self.fRaiseHeight=0.0;				-- lowered
end


-------------------------------------------------------
function FlagEntity:OnContact( player )
end

-------------------------------------------------------
function FlagEntity:OnUpdate(dt)
end

-------------------------------------------------------
function FlagEntity:OnShutDown()
end

-------------------------------------------------------
function FlagEntity:OnActivate()

end


-------------------------------------------------------------------------------
function FlagEntity:RegisterStates()
	self:RegisterState("up");
	self:RegisterState("down");
end


-------------------------------------------------------------------------------
function FlagEntity:UpdatePos()
	self:SetObjectPos(0,{x=0,y=0,z=self.fRaiseHeight*10.35-0.65});
end

----------------------------------------------------
function FlagEntity:UpdateAnimation(direction)
	--direction 0 = down
	--direction 1 = up
		
	if (self.is_moving==0) then
		
		if (direction~=self.animation_state) then
			
			if (direction==1) then
				self:StartAnimation(0,"flag_up",0,0.0);
			else
				self:StartAnimation(0,"flag_down",0,0.0);
			end
			
			self.is_moving = 1;
			
		elseif (self:IsAnimationRunning(0)==nil) then
			
			if (direction==1) then
				self:StartAnimation(0,"flag_waving",0,0.0,1.0,1);
			else
				self:StartAnimation(0,"flag_bottom",0,0.0,1.0,1);
			end			
		end
	else
		if (self:IsAnimationRunning(0)==nil) then
						
			self.animation_state = direction;
			self.is_moving = 0;		
		end			
	end
end


----------------------------------------------------
--SERVER
----------------------------------------------------
FlagEntity.Server={
	OnInit=function(self)
		self:LoadGeometry();
		self:RegisterStates();
		self:OnReset();
		self:NetPresent(nil);
		self:EnableUpdate(1);
	end,
-------------------------------------
	up={
	},
-------------------------------------
	down={
	},
}



----------------------------------------------------
--CLIENT
----------------------------------------------------
FlagEntity.Client={
	OnInit=function(self)
		self:LoadGeometry()
		self:RegisterStates();
	end,
-------------------------------------
	up={
		OnBeginState=function(self)
		end,
		OnUpdate=function(self)
		
			if (self.use_animated) then
				self:UpdateAnimation(1);	
			else
				self.fRaiseHeight = self.fRaiseHeight + _frametime*0.4;
				if self.fRaiseHeight>1 then
					self.fRaiseHeight=1;
				end
				self:UpdatePos();
			end
		end,
	},
-------------------------------------
	down={
		OnBeginState=function(self)
		end,
		OnUpdate=function(self)
			
			if (self.use_animated) then
				self:UpdateAnimation(0);	
			else
				self.fRaiseHeight = self.fRaiseHeight - _frametime*0.4;
				if self.fRaiseHeight<0 then
					self.fRaiseHeight=0;
				end
				self:UpdatePos();
			end
		end,
	},
}