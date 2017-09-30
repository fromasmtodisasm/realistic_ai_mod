Birds = {
  type = "Birds",
  MapVisMask = 0,
	ENTITY_DETAIL_ID=1,

	Properties = {
		objModel = "Objects\\characters\\animals\\Seagull\\Seagull.cgf",
		nNumBirds = 10,
		
		BoidSize = 1,
		MinHeight = 5,
		MaxHeight = 40,
		MinAttractDist = 5,
		MaxAttractDist = 20,
		MinSpeed = 2.5,
		MaxSpeed = 15,
		
		FactorAlign = 1,
		FactorCohesion = 1,
		FactorSeparation = 10,
		FactorOrigin = 0.1,
		FactorHeight = 0.4,
		FactorAvoidLand = 10,
		
		BoidFOV = 60,
		MaxAnimSpeed = 1.7,
		bFollowPlayer = 0,
		bNoLanding = 0,
		bObstacleAvoidance = 0,

		InnerRadius = 10,
		OuterRadius = 20,
		
		boid_radius = 0.5,
		gravity_at_death = -9.81,
		boid_mass = 10,

		bActivateOnStart = 1,
		
		VisibilityDist = 300,
	},
	Editor = {
		Model = "Objects\\Editor\\T.cgf"
	},
	params={x=0,y=0,z=0},
}

-------------------------------------------------------
function Birds:OnInit()

	self:NetPresent(nil);
	self:EnableSave(1);		

	self.flock = 0;
	self.currpos = {x=0,y=0,z=0};
	if (self.Properties.bActivateOnStart == 1) then
		self:CreateFlock();
	end
end

-------------------------------------------------------
function Birds:OnShutDown()
	if (self.flock ~= 0) then
		Boids:RemoveFlock( self.flock );
		self.flock = 0;
	end
end

-------------------------------------------------------
function Birds:CreateFlock()
	self.params.count = self.Properties.nNumBirds;
	self.params.model = self.Properties.objModel;

	self.params.boid_size = self.Properties.BoidSize;
	self.params.min_height = self.Properties.MinHeight;
	self.params.max_height = self.Properties.MaxHeight;
	self.params.min_attract_distance = self.Properties.MinAttractDist;
	self.params.max_attract_distance = self.Properties.MaxAttractDist;
	self.params.min_speed = self.Properties.MinSpeed;
	self.params.max_speed = self.Properties.MaxSpeed;
	
	self.params.factor_align = self.Properties.FactorAlign;
	self.params.factor_cohesion = self.Properties.FactorCohesion;
	self.params.factor_separation = self.Properties.FactorSeparation;
	self.params.factor_origin = self.Properties.FactorOrigin;
	self.params.factor_keep_height = self.Properties.FactorHeight;
	self.params.factor_avoid_land = self.Properties.FactorAvoidLand;
	
	self.params.spawn_radius = self.Properties.InnerRadius;
	self.params.boid_radius = self.Properties.boid_radius;
	self.params.gravity_at_death = self.Properties.gravity_at_death;
	self.params.boid_mass = self.Properties.boid_mass;

	self.params.fov_angle = self.Properties.BoidFOV;

	self.params.max_anim_speed = self.Properties.MaxAnimSpeed;
	self.params.follow_player = self.Properties.bFollowPlayer;
	self.params.no_landing = self.Properties.bNoLanding;
	self.params.avoid_obstacles = self.Properties.bObstacleAvoidance;
	self.params.max_view_distance = self.Properties.VisibilityDist;
	
	if (self.flock == 0) then
		self.flock = Boids:CreateBirdsFlock( self:GetName(),self:GetPos(),self.id,self.params );
	end
	if (self.flock ~= 0) then
		Boids:SetFlockPos( self.flock,self:GetPos() );
		Boids:SetFlockName( self.flock,self:GetName() );
		Boids:SetFlockParams( self.flock,self.params );
	end
end

-------------------------------------------------------
function Birds:OnPropertyChange()
	self:OnShutDown();
	if (self.Properties.bActivateOnStart == 1) then
		self:CreateFlock();
	end
end

-------------------------------------------------------
function Birds:OnMove()
	if (self.flock ~= 0) then
		Boids:SetFlockPos( self.flock,self:GetPos() );
	end
end

-------------------------------------------------------
function Birds:Event_Activate()

	if (self.Properties.bActivateOnStart == 0) then
		if (self.flock==0) then
			self:CreateFlock();
		end
	end

	if (self.flock ~= 0) then
		Boids:EnableFlock( self.flock,1 );
	end
end

-------------------------------------------------------
function Birds:Event_Deactivate()
	if (self.flock ~= 0) then
		Boids:EnableFlock( self.flock,0 );
	end
end

-------------------------------------------------------
function Birds:OnEnterArea( player,areaId )
	-- Enable area.
	self:Event_Activate( player );
end
	
--------------------------------------------------------
function Birds:OnLeaveArea( player,areaId )
	self:Event_Deactivate( player );
end

function Birds:OnProceedFadeArea( player,areaId,fadeCoeff )
	if (self.flock ~= 0) then
		Boids:SetFlockPercentEnabled( self.flock,fadeCoeff*100 );
	end
end