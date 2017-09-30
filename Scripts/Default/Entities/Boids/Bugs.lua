Bugs = {
  type = "Bugs",
  MapVisMask = 0,
	ENTITY_DETAIL_ID=1,

	Properties = {
		object_Model1 = "Objects\\Characters\\Animals\\GlowBug\\GlowBug.cgf",
		object_Model2 = "",
		object_Model3 = "",
		object_Model4 = "",
		object_Model5 = "",
		object_Character = "",
		
		nNumBugs = 10,
		nBehaviour = 0,
		
		Scale = 1,
		
		HeightMin = 1,
		HeightMax = 5,
		
		SpeedMin = 5,
		SpeedMax = 15,
		
		FactorOrigin = 1,
		--FactorHeight = 0.4,
		--FactorAvoidLand = 10,
		RandomMovement = 1,
		
		bFollowPlayer = 0,

		Radius = 10,
		
		--boid_mass = 10,

		bActivateOnStart = 1,
		bNoLanding = 0,
		
		AnimationSpeed = 1,
		Animation = "",
		
		VisibilityDist = 100,
	},
	Editor = {
		Model = "Objects\\Editor\\Flock.cgf"
	},
	params={x=0,y=0,z=0},
}

-------------------------------------------------------
function Bugs:OnInit()

	self:NetPresent(nil);
	self:EnableSave(1);		

	self.flock = 0;
	self:CreateFlock();
	if (self.Properties.bActivateOnStart ~= 1 and self.flock ~= 0) then
		Boids:EnableFlock( self.flock,0 );
	end
end

-------------------------------------------------------
function Bugs:OnShutDown()
	self:RemoveFlock();
end

-------------------------------------------------------
function Bugs:RemoveFlock()
	if (self.flock ~= 0) then
		Boids:RemoveFlock( self.flock );
		self.flock = 0;
	end
end

-------------------------------------------------------
function Bugs:CreateFlock()
	self.params.count = self.Properties.nNumBugs;
	
	self.params.model = self.Properties.object_Model1;
	self.params.model1 = self.Properties.object_Model2;
	self.params.model2 = self.Properties.object_Model3;
	self.params.model3 = self.Properties.object_Model4;
	self.params.model4 = self.Properties.object_Model5;
	self.params.character = self.Properties.object_Character;
	
	self.params.behavior = self.Properties.nBehaviour;

	self.params.boid_size = self.Properties.Scale;
	self.params.min_height = self.Properties.HeightMin;
	self.params.max_height = self.Properties.HeightMax;
	--self.params.min_attract_distance = self.Properties.MinAttractDist;
	self.params.max_attract_distance = self.Properties.Radius;
	self.params.min_speed = self.Properties.SpeedMin;
	self.params.max_speed = self.Properties.SpeedMax;
	
	self.params.factor_align = self.Properties.RandomMovement;
	--self.params.factor_cohesion = self.Properties.FactorCohesion;
	--self.params.factor_separation = self.Properties.FactorSeparation;
	self.params.factor_origin = self.Properties.FactorOrigin;
	--self.params.factor_keep_height = self.Properties.FactorHeight;
	--self.params.factor_avoid_land = self.Properties.FactorAvoidLand;
	
	self.params.spawn_radius = self.Properties.Radius;
	--self.params.boid_mass = self.Properties.boid_mass;

	--self.params.fov_angle = self.Properties.BoidFOV;
	
	self.params.max_anim_speed = self.Properties.AnimationSpeed;
	self.params.animation = self.Properties.Animation;
	self.params.follow_player = self.Properties.bFollowPlayer;
	self.params.no_landing = self.Properties.bNoLanding;
	--self.params.avoid_obstacles = self.Properties.bObstacleAvoidance;
	self.params.max_view_distance = self.Properties.VisibilityDist;
	
		
	if (self.flock == 0) then
		self.flock = Boids:CreateBugsFlock( self:GetName(),self:GetPos(),self.id,self.params );
	end
	if (self.flock ~= 0) then
		Boids:SetFlockPos( self.flock,self:GetPos() );
		Boids:SetFlockName( self.flock,self:GetName() );
		Boids:SetFlockParams( self.flock,self.params );
	end
end

-------------------------------------------------------
function Bugs:OnPropertyChange()
	self:RemoveFlock();
	self:CreateFlock();
end

-------------------------------------------------------
function Bugs:OnMove()
	if (self.flock ~= 0) then
		Boids:SetFlockPos( self.flock,self:GetPos() );
	end
end

-------------------------------------------------------
function Bugs:Event_Activate( sender )
	if (self.flock ~= 0) then
		Boids:EnableFlock( self.flock,1 );
	end
end

-------------------------------------------------------
function Bugs:Event_Deactivate( sender )
	if (self.flock ~= 0) then
		Boids:EnableFlock( self.flock,0 );
	end
end

-------------------------------------------------------
function Bugs:OnEnterArea( player,areaId )
	-- Enable area.
	self:Event_Activate( player );
end
	
--------------------------------------------------------
function Bugs:OnLeaveArea( player,areaId )
	self:Event_Deactivate( player );
end

function Bugs:OnProceedFadeArea( player,areaId,fadeCoeff )
	if (self.flock ~= 0) then
		Boids:SetFlockPercentEnabled( self.flock,fadeCoeff*100 );
	end
end