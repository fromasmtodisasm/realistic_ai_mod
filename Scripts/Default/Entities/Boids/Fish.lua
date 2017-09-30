Fish = {
  type = "Fish",
  MapVisMask = 0,
	ENTITY_DETAIL_ID=1,

	Properties = {
		objModel = "Objects\\characters\\animals\\Fish\\fish01.cgf",
		nNumFish = 10,
		
		BoidSize = 1,
		MinHeight = 0,
		MaxHeight = 20,
		MinAttractDist = 1,
		MaxAttractDist = 10,
		MinSpeed = 2,
		MaxSpeed = 8,
		
		FactorAlign = 0,
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
		bActivateOnStart = 1,
		
		VisibilityDist = 200,
	},
	ParticlesBubbles = {--underwater bubbles for fish breathing
		particle_type=2, --underwater
		focus = 0.0,
		speed = 0.25,
		count = 1,
		size = 0.1, size_speed=0.002,
		start_color = {1,1,1},
		gravity = { x = 0.0, y = 0.0, z = 1.6 },
		lifetime=2.5,
		tid = System:LoadTexture("textures\\bubble.tga"),
		frames=0,
		},


	Editor = {
		Model = "Objects\\Editor\\T.cgf"
	},
	params={x=0,y=0,z=0},
	bubble_pos={x=0,y=0,z=0},
	bubble_dir={x=0,y=0,z=1},
}

-------------------------------------------------------
function Fish:OnInit()

	self:NetPresent(nil);
	self:EnableSave(1);		

	self.flock = 0;
	self:CreateFlock();
	if (self.Properties.bActivateOnStart ~= 1 and self.flock ~= 0) then
		Boids:EnableFlock( self.flock,0 );
	end
end

-------------------------------------------------------
function Fish:OnShutDown()
	if (self.flock ~= 0) then
		Boids:RemoveFlock( self.flock );
		self.flock = 0;
	end
end

-------------------------------------------------------
function Fish:CreateFlock()
	self.params.count = self.Properties.nNumFish;
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
	
	self.params.fov_angle = self.Properties.BoidFOV;
	
	self.params.max_anim_speed = self.Properties.MaxAnimSpeed;
	self.params.follow_player = self.Properties.bFollowPlayer;
	self.params.no_landing = self.Properties.bNoLanding;
	self.params.avoid_obstacles = self.Properties.bObstacleAvoidance;
	self.params.max_view_distance = self.Properties.VisibilityDist;
	
	if (self.flock == 0) then
		self.flock = Boids:CreateFishFlock( self:GetName(),self:GetPos(),self.id,self.params );
	end
	
	if (self.flock ~= 0) then
		Boids:SetFlockPos( self.flock,self:GetPos() );
		Boids:SetFlockName( self.flock,self:GetName() );
		Boids:SetFlockParams( self.flock,self.params );
	end
end

-------------------------------------------------------
function Fish:OnPropertyChange()
	self:CreateFlock();
end

-------------------------------------------------------
function Fish:OnSpawnBubble( pos )
	Particle:CreateParticle( pos,self.bubble_dir,self.ParticlesBubbles );
end

-------------------------------------------------------
function Fish:OnMove()
	if (self.flock ~= 0) then
		Boids:SetFlockPos( self.flock,self:GetPos() );
	end
end

-------------------------------------------------------
function Fish:Event_Activate()
	if (self.flock ~= 0) then
		Boids:EnableFlock( self.flock,1 );
	end
end

-------------------------------------------------------
function Fish:Event_Deactivate()
	if (self.flock ~= 0) then
		Boids:EnableFlock( self.flock,0 );
	end
end

-------------------------------------------------------
function Fish:OnEnterArea( player,areaId )
	-- Enable area.
	self:Event_Activate( player );
end
	
--------------------------------------------------------
function Fish:OnLeaveArea( player,areaId )
	self:Event_Deactivate( player );
end

function Fish:OnProceedFadeArea( player,areaId,fadeCoeff )
	if (self.flock ~= 0) then
		Boids:SetFlockPercentEnabled( self.flock,fadeCoeff*100 );
	end
end