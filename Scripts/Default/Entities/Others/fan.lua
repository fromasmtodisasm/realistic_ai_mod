Fan = {
  type = "Fan",
  minrotspeed = 0,
  maxrotspeed = 1300,
  acceleration = 300,
  currrotspeed = 0,
  changespeed = 0,
  currangle = 0,

	Properties = {
	},
}

-------------------------------------------------------
function Fan:OnInit()
	self:SetName( "Fan" );
	self:LoadObject( "Objects/Indoor/Fan.cgf", 0, 0 );
	self:DrawObject( 0, 1 );
end

-------------------------------------------------------
function Fan:OnContact( player )
end

-------------------------------------------------------
function Fan:OnUpdate(dt)
	if ( self.changespeed == 0 ) then
		self.currrotspeed = self.currrotspeed - System.GetFrameTime() * self.acceleration;
		if ( self.currrotspeed < self.minrotspeed ) then
			self.currrotspeed = self.minrotspeed;
		end
	else
		self.currrotspeed = self.currrotspeed + System.GetFrameTime() * self.acceleration;
		if ( self.currrotspeed > self.maxrotspeed ) then
			self.currrotspeed = self.maxrotspeed;
		end
	end
	self.currangle = self.currangle + System:GetFrameTime() * self.currrotspeed;
	local a = { x=0, y=0, z=-self.currangle };
	self:SetAngles( a );
end

-------------------------------------------------------
function Fan:OnShutDown()
end

-------------------------------------------------------
function Fan:OnActivate()
	self.changespeed = 1 - self.changespeed;
end

-------------------------------------------------------
function Fan:OnLoad(stm)
end

-------------------------------------------------------
function Fan:OnSave(stm)
end