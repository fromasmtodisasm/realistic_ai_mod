RigidBody = {
  type = "RigidBody",
  MapVisMask = 0,

	Properties = {
		objModel = "Objects/box.cgf",
		Density = 5000,
		Mass = 1,
		bResting = 1, -- If rigid body is originally in resting state.
		bVisible = 1, -- If rigid body is originally visible.
		bRigidBodyActive = 1, -- If rigid body is originally created OR will be created only on OnActivate.
		bActivateOnRocketDamage = 0, -- Activate when a rocket hit the entity.
		Impulse = {X=0,Y=0,Z=0}, -- Impulse to apply at event.
		max_time_step = 0.01,
		sleep_speed = 0.04,
		damping = 0,
		water_damping = 1.5,
		water_resistance = 0,	
	},
	temp_vec={x=0,y=0,z=0},
}

-------------------------------------------------------
function RigidBody:OnInit()
	self:EnableUpdate(0);
	self:SetUpdateType( eUT_Physics );
	
	self.ModelName = "";
	self.Mass = 0;
	self:OnReset();
end

-------------------------------------------------------
function RigidBody:OnReset()
	self:NetPresent(nil);
	if (self.ModelName ~= self.Properties.objModel or self.Mass ~= self.Properties.Mass) then
		self.Mass = self.Properties.Mass;
		self.ModelName = self.Properties.objModel;
		self:LoadObject( self.ModelName, 0,1 );

	end

	if (self.Properties.bRigidBodyActive == 1) then			
		self:CreateRigidBody( self.Properties.Density,self.Properties.Mass,0 );
	else
		self:CreateStaticEntity( self.Properties.Mass, 0 );
	end

	self:SetPhysicParams(PHYSICPARAM_SIMULATION, self.Properties );
	self:SetPhysicParams(PHYSICPARAM_BUOYANCY, self.Properties );
	
	if (self.Properties.bVisible == 0) then
		self:DrawObject( 0,0 );
	else
		self:DrawObject( 0,1 );
	end
	
	if (self.Properties.bResting == 0) then
		self:EnableUpdate(1);
		self:AwakePhysics(1);
	else
		self:EnableUpdate(0);
		self:AwakePhysics(0);
	end

end

-------------------------------------------------------
function RigidBody:OnPropertyChange()
	self:OnReset();
end

-------------------------------------------------------
function RigidBody:OnContact( player )
	self:Event_OnTouch( player );
end

-------------------------------------------------------
function RigidBody:OnDamage( hit )
	--System.LogToConsole( "On Damage" );

	if( hit.ipart ) then
		self:AddImpulse( hit.ipart, hit.pos, hit.dir, hit.impact_force_mul );
--	else	
--		self:AddImpulse( -1, hit.pos, hit.dir, hit.impact_force_mul );
	end	

	if(self.Properties.bActivateOnRocketDamage)then
		if(hit.explosion)then
			System:LogToConsole( "On Damage (by explosion)" );
			self:EnableUpdate(1);
			self:AwakePhysics(1);
		end
	end
end

-------------------------------------------------------
function RigidBody:OnShutDown()
end

-------------------------------------------------------
-- Input events
-------------------------------------------------------
function RigidBody:Event_AddImpulse(sender)
	self.temp_vec.x=self.Properties.Impulse.X;
	self.temp_vec.y=self.Properties.Impulse.Y;
	self.temp_vec.z=self.Properties.Impulse.Z;
	self:AddImpulse(0,nil,self.temp_vec,1);
end

-------------------------------------------------------
function RigidBody:Event_Activate(sender)	

	--create rigid body 
	self:CreateRigidBody( self.Properties.Density,self.Properties.Mass,0 );

	self:EnableUpdate(1);
	self:AwakePhysics(1);
end

-------------------------------------------------------
function RigidBody:Event_Show(sender)
	self:DrawObject( 0,1 );
end

-------------------------------------------------------
function RigidBody:Event_Hide(sender)
	self:DrawObject( 0,0 );
end

-------------------------------------------------------
-- Output events
-------------------------------------------------------
function RigidBody:Event_OnTouch(sender)
	BroadcastEvent( self,"OnTouch" );
end