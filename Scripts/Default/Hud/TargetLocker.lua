--------------------------------------------------------------------
-- X-Isle Script File
-- Description: Defines the TargetLocker
-- Created by Kirill Bulatsev
--------------------------------------------------------------------
-- #Script:ReloadScript("scripts/default/hud/targetlocker.lua");
TargetLocker = {
	IsActive = 0,
	TrackerSize=50,
	MaxTrackerSize=600,
	max_dist_from_center=50, -- in pixels
	targets={},
	AcquisitionTime={},
	vEntities=nil,
	type="",
}

-------------------------------------------------------
function TargetLocker:OnInit()
	
	self.Indicator=System:LoadImage( "Textures/Hud/Binocular/binoculars_targeting" );
	self.MarkerIndicator=System:LoadImage( "Textures/Hud/crosshair/rl.tga" );
	self.LockSnd=Sound:LoadSound("Sounds/Items/lock.wav");
	self.SeekSnd=Sound:LoadSound("Sounds/Items/seek.wav");
end

-------------------------------------------------------
function TargetLocker:OnUpdate()
	--dummy on update
end
-------------------------------------------------------
function TargetLocker:GetTargetScreenSpace(target,dest_table)
	if(target.id)then
		local pos=target:GetPos();
		dest_table.x=pos.x;
		dest_table.y=pos.y;
		dest_table.z=pos.z;
	else
		dest_table.x=target.x;
		dest_table.y=target.y;
		dest_table.z=target.z;
	end
	System:ProjectToScreen(dest_table);
end

function TargetLocker:CleanupTargetList()
	local offset=0;
	local ss={}
	if(self:GetTargetsCount()>0)then
		for i,target in self.targets do
			self:GetTargetScreenSpace(target,ss)
			
			if((ss.x>800) or (ss.x<0) or
				(ss.y>600) or (ss.y<0)
			)then
				printf("removing %d (x=%f y=%f)",i,ss.x,ss.y);
				self.targets[i]=nil;
				offset=offset+1;
			else
				local temp=self.targets[i];
				self.targets[i]=nil;
				self.targets[i-offset]=temp;
			end
		end
	end
end



function TargetLocker:OnUpdate_SwarmRL()
	if(self.IsActive==0)then
		return
	end
	
	--self.vEntities=Game:GetEntitiesScreenSpace("Bip01 Spine2");
	
	--TRACK TARGET------------------------------------------------------
	TargetLocker:CleanupTargetList();
	local ss={};
	if(self:GetTargetsCount()>0)then
		local size=50;
		for i,target in self.targets do
			local bFound=nil;
			local f=_time-self.AcquisitionTime[i];
	asd=[[				for id,ent in self.vEntities do
				if((ent.pEntity==target))then
					bFound=1;
					srcPos=new(ent.Position);
					--printf("FOUND %d",ent.pEntity.id);
					break
				end
			end
			]]
			--if(bFound and (target.lockable or (target.cnt.health>0)))then
				if(f>1)then f=1; end
				self:GetTargetScreenSpace(target,ss)
				if(target.id)then
				--IS AN ENTITY
				System:DrawImageColor(self.Indicator, ss.x-size/2, 
								ss.y-size/2,size+(1-f)*size,size+(1-f)*size, 4, 1, 1, 1, f);		
				else
				--IS A MARKER
				System:DrawImageColor(self.MarkerIndicator, ss.x-size/2, 
								ss.y-size/2,size+(1-f)*size,size+(1-f)*size, 4, 0, 1, 0, f);		
				end
			--else
--				printf("Target LOST");
				--self.targets[i]=nil;
			--end
			
		end
	end
	
	
end
-------------------------------------------------------
function TargetLocker:OnUpdate_RL()

	if(self.IsActive==0)then
		return
	end
	
	self.vEntities=Game:GetEntitiesScreenSpace("Bip01 Spine2");
	
	if(self:GetTargetsCount()>0)then
	--TRACK TARGET------------------------------------------------------
		
		local size=50;
		
		
		for i,target in self.targets do
			local bFound=nil;
			local f=_time-self.AcquisitionTime[i];
			for id,ent in self.vEntities do
				if((ent.pEntity==target) and (ent.DistFromCenter<self.max_dist_from_center))then
					bFound=1;
					srcPos=new(ent.Position);
					--printf("FOUND %d",ent.pEntity.id);
					break
				end
			end
			
			if(bFound and (target.lockable or (target.cnt.health>0)))then
				if(f>1)then f=1; end
				--printf("drawing")
				System:DrawImageColor(self.Indicator, srcPos.x-size/2, 
								srcPos.y-size/2,size+(1-f)*size,size+(1-f)*size, 4, 1, 1, 1, f);		
			else
				--printf("Target LOST");
				self.targets[i]=nil;
			end
			
		end
	
		
		
		
	else
	
		if((self.vEntities==nil) or getn(self.vEntities)==0)then return end
		--ACQUIRE TARGET------------------------------------------------------	
		for id,ent in self.vEntities do
			if((ent.DistFromCenter<self.max_dist_from_center))then
				if(((ent.pEntity.type=="Player") and (ent.pEntity.cnt.health>0)) or (ent.pEntity.lockable))then
						if(self:IsLocked(ent.pEntity)==nil)then
							self:AddTarget(ent.pEntity);
							printf("entity locked");
							break;
						end
				end
			end
		end
		--DRAW STUFF
	end
	
end

-------------------------------------------------------
--Acquire a target shooting a ray from the crosshair
-------------------------------------------------------
function TargetLocker:AcquireTarget()
	if(_localplayer)then
		local int_pt=_localplayer.cnt:GetViewIntersection();
		if(int_pt)then
			if(int_pt.id)then
				--is an entity
				local ent=System:GetEntity(int_pt.id);
				if(ent)then
					printf("Entity acquired");
					self:AddTarget(ent);
				end
			else
				--is a static marker
				int_pt.screen_space={x=0,y=0,z=0};
				self:AddTarget(new(int_pt));
			end
			
			
		end
	end
end

-------------------------------------------------------
function TargetLocker:IsLocked(ent)
	if(self.targets)then
		for i,target in self.targets do
			if(target==ent)then
				return 1;
			end
		end
	end
	return nil
end
-------------------------------------------------------
function TargetLocker:AddTarget(ent)
	if(self.targets==nil)then
		self.targets={};
	end
	local n=getn(self.targets)+1;
	self.targets[n]=ent;
	self.AcquisitionTime[n]=_time;
	return n;
end

-------------------------------------------------------
function TargetLocker:PopTarget()
	if(self.targets)then
		local n=getn(self.targets);
		if(n>0)then
			local temp=self.targets[n];
			self.targets[n]=nil;
			self.AcquisitionTime[n]=nil;
			return temp;
		end
	else
		return nil
	end
end
-------------------------------------------------------
function TargetLocker:GetTarget()
	return self.PopTarget();
end
-------------------------------------------------------
function TargetLocker:GetTargetsCount()
	if(self.targets==nil)then
		return 0
	else
		return getn(self.targets);
	end
end
-------------------------------------------------------
function TargetLocker:OnShutdown()
end

----------------------------------
function TargetLocker:OnActivate()
end

----------------------------------
function TargetLocker:OnDeactivate()
end

function TargetLocker:Activate(bActivate,type)
	if(bActivate==0)then
			self.targets=nil;
	else
		if(self.type~=type)then
			self.type=type;
			local funcUpdate=self["OnUpdate_"..type]
			if(funcUpdate)then
				printf("selecting OnUpdate_"..type)
				self.OnUpdate=funcUpdate;
				self.targets={};
			else
				printf("AAAAA OnUpdate_"..type.." is nil")
				return
			end
		end
	end
	self.IsActive=bActivate;
end


