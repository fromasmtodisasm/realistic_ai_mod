-- 5 diffeerent states
-- can be build and repaired
-- all states are physicalized (depending on material)


BuildableObject={
	Properties={
		object_Model_unbuilt = "Objects/Outdoor/temp/duck.cgf",
		object_Model_building = "Objects/Outdoor/temp/duck.cgf",
		object_Model_built = "Objects/Outdoor/temp/duck.cgf",
		object_Model_repair = "Objects/Outdoor/temp/duck.cgf",
		object_Model_damaged = "Objects/Outdoor/temp/duck.cgf",
		
		max_buildpoints=0,			-- affect the buildtime, 0=cannot be built
		max_repairpoints=0,			-- affect the repairtime, 0=cannot be repaired
		max_hitpoints=0,				-- affect the buildtime, 0=cannot be destroyed
		iInitalState=1,					-- -1=hidden, 0=unbuilt, 1=built, 2=damaged
	},

	health=0,							-- used as current building, repair and damage value
}

function BuildableObject:RegisterStates()
	self:RegisterState("hidden");
	self:RegisterState("unbuilt");
	self:RegisterState("building");
	self:RegisterState("built");
	self:RegisterState("repair");
	self:RegisterState("damaged");
end


function BuildableObject:LoadGeometry()
	if(self.Properties.object_Model_unbuilt~="")then
		self:LoadObject(self.Properties.object_Model_unbuilt,0,1);	-- unbuilt
		self:CreateStaticEntity(2,-1,0);		-- precache physics representation
	end
	if(self.Properties.object_Model_building~="")then
		self:LoadObject(self.Properties.object_Model_building,1,1);	-- building
		self:CreateStaticEntity(2,-1,1);		-- precache physics representation
	end
	if(self.Properties.object_Model_built~="")then
		self:LoadObject(self.Properties.object_Model_built,2,1);	-- built
		self:CreateStaticEntity(2,-1,2);		-- precache physics representation
	end
	if(self.Properties.object_Model_repair~="")then
		self:LoadObject(self.Properties.object_Model_repair,3,1);	-- repair
		self:CreateStaticEntity(2,-1,3);		-- precache physics representation
	end
	if(self.Properties.object_Model_damaged~="")then
		self:LoadObject(self.Properties.object_Model_damaged,4,1);	-- damaged
		self:CreateStaticEntity(2,-1,4);		-- precache physics representation
	end
end


function BuildableObject:OnReset()
	if self.Properties.iInitalState==-1 then		-- hidden
		self:Event_hidden();
	elseif self.Properties.iInitalState==0 then		-- unbuilt
		self:Event_unbuilt();
	elseif self.Properties.iInitalState==1 then		-- built
		self:Event_built();
	else						--   2				-- damaged
		self:Event_damaged();
	end
end


-------------------------------------------------------------------------------
function BuildableObject:OnMultiplayerReset()
	self:OnReset();
end


------------------------------------------------------------------------------------------------------
function BuildableObject:OnPropertyChange()
	self:LoadGeometry();
	self:OnReset();
end


------------------------------------------------------------------------------------------------------
-- check for the netity itself and the buildable object which are connected to it (recursivly - beware circular endless loop is possible)
function BuildableObject:IsCollisionFree()
	-- check this entity
  local colltable = self:CheckCollisions(ent_rigid+ent_sleeping_rigid+ent_living, geom_colltype_player);
  
  if (colltable and colltable.contacts and getn(colltable.contacts)>0) then
    return nil;
  end
   
  -- check connected objects
	local sender=self;
	
  -- Check if Event Target for this input event exists.
	if (sender.Events) then
		for Event,eventTargets in sender.Events do
			if (eventTargets) then
				for i, target in eventTargets do
					local TargetId = target[1];
					local TargetEvent = target[2];
	
					if (TargetId ~= 0) then
						-- If TargetId refere to Entity.  - otherwise it would be to the global Mission tabls
						local entity = System:GetEntity(TargetId);					
						if (entity ~= nil) then

							-- check connected entities
							local colltable = entity:CheckCollisions(ent_rigid+ent_sleeping_rigid+ent_living, geom_colltype_player);
							  
							if (colltable and colltable.contacts and getn(colltable.contacts)>0) then
								return nil;		-- collision with an connected entity
							end
						end
					end
				end
 			end
 		end
 	end
    
	return 1;	-- collision free
end



------------------------------------------------------------------------------------------------------
-- used to make remote building (e.g. a crate and a bunker) of objects more consistant
-- (you cannot finish a BuildableObject that was created remotely by itself)
function BuildableObject:ResetBuildpointsOfConnected(ssid, team)
  -- check connected objects
	local sender=self;
	
  -- Check if Event Target for this input event exists.
	if (sender.Events) then
		for Event,eventTargets in sender.Events do
			if (eventTargets) then
				for i, target in eventTargets do
					local TargetId = target[1];
					local TargetEvent = target[2];
	
					if (TargetId ~= 0) then
						-- If TargetId refere to Entity.  - otherwise it would be to the global Mission tabls
						local entity = System:GetEntity(TargetId);					
						if (entity and (entity.classname == "BuildableObject")) then
							entity.Properties.max_buildpoints = 0;
						end
					end
				end
 			end
 		end
 	end
end

function BuildableObject:UpdateOwner(ssid, team)

	if (self.classname == "BuildableObject") then
		self.szBuiltByTeam = team;
		self.iBuiltBySSID = ssid;
	else
		return;
	end
  
  -- check connected objects
	local sender=self;
	
  -- Check if Event Target for this input event exists.
	if (sender.Events) then
		for Event,eventTargets in sender.Events do
			if (eventTargets) then
				for i, target in eventTargets do
					local TargetId = target[1];
					local TargetEvent = target[2];
	
					if (TargetId ~= 0) then
						-- If TargetId refere to Entity.  - otherwise it would be to the global Mission tabls
						local entity = System:GetEntity(TargetId);					
						if (entity and (entity.classname == "BuildableObject")) then
							entity.szBuiltByTeam = team;
							entity.iBuiltBySSID = ssid;
						end
					end
				end
 			end
 		end
 	end
end

------------------------------------------------------------------------------------------------------
-- change state
function BuildableObject:ModifyStateCommon(name)
	self:GotoState(name);
	self:ResetBuildpointsOfConnected();
	BroadcastEvent(self, name);						-- beware circular endless loop is possible	
end


function BuildableObject:Event_hidden()
	self:ModifyStateCommon("hidden");
end
function BuildableObject:Event_unbuilt()
	self:ModifyStateCommon("unbuilt");
end
function BuildableObject:Event_building()
	self:ModifyStateCommon("building");
end
function BuildableObject:Event_built()
	self:ModifyStateCommon("built");
end
function BuildableObject:Event_repair()
	self:ModifyStateCommon("repair");
end
function BuildableObject:Event_damaged()
	self:ModifyStateCommon("damaged");
end


-- when construction area is blocked
function BuildableObject:SendNoProgress(shooter,type)
	if shooter then
		local slot;
		
		slot=Server:GetServerSlotByEntityId(shooter.id);
		if slot then
			slot:SendCommand("P "..tostring(type));		-- "progress 2=repair"
		end
	end
end

-- /param type "1"=building, "2"=repair
-- /param shooter
-- /param curr
-- /param max
function BuildableObject:SendProgress(shooter,type,curr,max)
	if shooter then
		local slot;
		
		slot=Server:GetServerSlotByEntityId(shooter.id);
		if slot then
			local PerPercent=100;
			
			if max>0 then
				PerPercent=100-(100*curr)/max;			-- 0..100
			end
			
			local str=format("%.0f",PerPercent);
			
			slot:SendCommand("P "..tostring(type).." "..str);		-- "progress 2=repair 0..100"
		end
	end
end

function BuildableObject:ProcessDamage(hit)
	if not GameRules:IsInteractionPossible(hit.shooter,self) then 
		return;
	end

	self.health=self.health-hit.damage;
	if self.health<=0 then
		self.health=0;
	end
end

----------------------------------------------------
--SERVER
----------------------------------------------------
BuildableObject.Server={
	OnInit=function(self)
		self:RegisterStates();
		self:OnReset();
		self:LoadGeometry();		-- call after state was set
		self:NetPresent(nil);
		self:EnableUpdate(0);
		self:UpdatePhysicsMesh();
	end,
-------------------------------------
	hidden={
		OnBeginState=function(self)
			self:UpdatePhysicsMesh();
		end,
	},
-------------------------------------
	unbuilt={
		OnBeginState=function(self)
			self.health=self.Properties.max_buildpoints;
			self:UpdatePhysicsMesh();
		end,
		OnDamage = function(self,hit)
			if not GameRules:IsInteractionPossible(hit.shooter,self) then return end;
			if(hit.damage_type~="building")then return end;					-- only building damage is allowed
			if(self.Properties.max_buildpoints<=0)then return end;		-- only if it can be built

		  if(not self:IsCollisionFree())then
--		    System:Log("BuildableObject: cannot build due to foreign objects in the build area");
		    self:SendNoProgress(hit.shooter,"1");
		    return;
		  end

			self:SendProgress(hit.shooter,"1",self.health,self.Properties.max_buildpoints);
			self:Event_building();
		end,
	},
-------------------------------------
	building={
		OnBeginState=function(self)
			self.health=self.Properties.max_buildpoints;
			self:UpdatePhysicsMesh();
		end,
		OnDamage = function(self,hit)
			if(hit.damage_type~="building")then return end;					-- only building damage is allowed
			if(self.Properties.max_buildpoints<=0)then return end;		-- only if it can be built

		  if(not self:IsCollisionFree())then
--		    System:Log("BuildableObject: cannot build due to foreign objects in the build area");
		    self:SendNoProgress(hit.shooter,"1");
		    return;
		  end
	
			self:ProcessDamage(hit);
			self:SendProgress(hit.shooter,"1",self.health,self.Properties.max_buildpoints);
			
--			printf(">>>>A>> "..tostring(self.health));

			if self.health<=0 then
				self:Event_built();			-- you built it
				
				local Slot = Server:GetServerSlotByEntityId(hit.shooter.id);
				
				if (Slot) then
					self:UpdateOwner(Slot:GetId(), Game:GetEntityTeam(hit.shooter.id));
				end
				
				MPStatistics:AddStatisticsDataEntity(hit.shooter,"nBuildingBuilt",1);
			end
		end,
	},
-------------------------------------
	built={
		OnBeginState=function(self)
			self.health=self.Properties.max_hitpoints;
			self:UpdatePhysicsMesh();
		end,
		OnDamage = function(self,hit)
			if self.Properties.max_hitpoints==0 then return end;	-- cannot be destroyed	
			if not hit.explosion then return end;									-- only explosion can damage
				
			self:ProcessDamage(hit);
			
			if self.health<=0 then			-- you destroyed it

				self:Event_damaged();
				
				local Slot = Server:GetServerSlotBySSId(hit.shooterSSID);

				if (Slot) then
					local Player = System:GetEntity(Slot:GetPlayerId());

					if (Player and (self.szBuiltByTeam ~= Game:GetEntityTeam(Player.id))) then
						MPStatistics:AddStatisticsDataSSId(hit.shooterSSID,"nBuildingDestroyed", 1);
					else
						MPStatistics:AddStatisticsDataSSId(hit.shooterSSID,"nBuildingDestroyed", -1);
					end
				end
			end
		end,
	},
-------------------------------------
	repair={
		OnBeginState=function(self)
			self.health=self.Properties.max_repairpoints;
			self:UpdatePhysicsMesh();
		end,
		OnDamage = function(self,hit)
			if hit.damage_type ~= "building" then return end;		-- only building damage is allowed
			
		  if(not self:IsCollisionFree())then
--		    System:Log("BuildableObject: cannot build due to foreign objects in the build area");
		    self:SendNoProgress(hit.shooter,"2");
		    return;
		  end

			self:ProcessDamage(hit);
			self:SendProgress(hit.shooter,"2",self.health,self.Properties.max_repairpoints);
			
			if self.health<=0 then			-- you fixed it
				self:Event_built();

				local Slot = Server:GetServerSlotByEntityId(hit.shooter.id);
				
				if (Slot) then
					self:UpdateOwner(Slot:GetId(), Game:GetEntityTeam(hit.shooter.id));
				end

				MPStatistics:AddStatisticsDataEntity(hit.shooter,"nBuildingRepaired",1);
			end
		end,
	},
-------------------------------------
	damaged={
		OnBeginState=function(self)
			self.health=self.Properties.max_repairpoints;
			self:UpdatePhysicsMesh();
		end,
		OnDamage = function(self,hit)
			if not GameRules:IsInteractionPossible(hit.shooter,self) then return end;
			if hit.damage_type ~= "building" then return end;		-- only building damage is allowed
			if self.Properties.max_repairpoints==0 then return end;	-- cannot be repaired	

		  if(not self:IsCollisionFree())then
--		    System:Log("BuildableObject: cannot build due to foreign objects in the build area");
		    self:SendNoProgress(hit.shooter,"2");
		    return;
		  end

			self:SendProgress(hit.shooter,"2",self.health,self.Properties.max_repairpoints);
			self:Event_repair();
		end,
	},
}

function BuildableObject:UpdateRendermesh()
	if self:GetState()=="unbuilt" then
		self:DrawObject(0,1);
	else
		self:DrawObject(0,0);
	end
	
	if self:GetState()=="building" then 
		self:DrawObject(1,1);
	else
		self:DrawObject(1,0);
	end
	
	if self:GetState()=="built" then 
		self:DrawObject(2,1);
	else
		self:DrawObject(2,0);
	end
	
	if self:GetState()=="repair" then 
		self:DrawObject(3,1);
	else
		self:DrawObject(3,0);
	end
	
	if self:GetState()=="damaged" then 
		self:DrawObject(4,1);
	else
		self:DrawObject(4,0);
	end
	
	self:RemoveDecals();
end

function BuildableObject:UpdatePhysicsMesh()
	-- make sure all the physics stuff in our surroundings gets updated
	self:AwakeEnvironment();
	
	if self:GetState()=="hidden" then
		self:DestroyPhysics();
	elseif self:GetState()=="unbuilt" then
		self:CreateStaticEntity(2,-1,0);
	elseif self:GetState()=="building" then
		self:CreateStaticEntity(2,-1,1);
	elseif self:GetState()=="built" then
		self:CreateStaticEntity(2,-1,2);
	elseif self:GetState()=="repair" then
		self:CreateStaticEntity(2,-1,3);
	elseif self:GetState()=="damaged" then
		self:CreateStaticEntity(2,-1,4);
	end
end

----------------------------------------------------
--CLIENT
----------------------------------------------------
BuildableObject.Client={
	OnInit=function(self)
		self:RegisterStates();
		self:LoadGeometry();		-- call after state was set
		self:EnableUpdate(0);

		local stat=self.Client[self:GetState()];
		if stat then
			stat.OnBeginState(self);
		end
	end,
-------------------------------------
	hidden={
		OnBeginState=function(self)
			self:UpdateRendermesh();
			self:UpdatePhysicsMesh();
		end,
	},
-------------------------------------
	unbuilt={
		OnBeginState=function(self)
			self:UpdateRendermesh();
			self:UpdatePhysicsMesh();
		end,
	},
-------------------------------------
	building={
		OnBeginState=function(self)
			self:UpdateRendermesh();
			self:UpdatePhysicsMesh();
		end,
	},
-------------------------------------
	built={
		OnBeginState=function(self)
			self:UpdateRendermesh();
			self:UpdatePhysicsMesh();
		end,
	},
-------------------------------------
	repair={
		OnBeginState=function(self)
			self:UpdateRendermesh();
			self:UpdatePhysicsMesh();
		end,
	},
-------------------------------------
	damaged={
		OnBeginState=function(self)
			self:UpdateRendermesh();
			self:UpdatePhysicsMesh();
		end,
	},
}