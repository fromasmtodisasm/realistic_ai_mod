-------------------------------------------------------
--
--	Crytek Studios 2001
--	FILE			:	EntityGroupMgr.lua
--	Created by: Alberto Demichelis
--	date			:	07 November 2001
--
-------------------------------------------------------
EntityGroupMgr = {
	groups={}
}

-------------------------------------------------------
function EntityGroupMgr:AddEntity(_group,_entity)
	local group=self.groups[_group];
	if(group == nil) then
		self.groups[_group]={};
	end
	self.groups[_group][_entity.id]=_entity;
end

-------------------------------------------------------
function EntityGroupMgr:RemoveEntity(_group,_entity)
	local group=self.groups[_group];
	if(group ~= nil) then
		group[_entity.id]=nil;
	end
end

-------------------------------------------------------
function EntityGroupMgr:RemoveGroup(_group)
	self.groups[_group]=nil
end

-------------------------------------------------------
function EntityGroupMgr:CallFunction(_group,_action,...)
	local group=self.groups[_group];
	
	if(group ~= nil) then
		for i,entity in group do
			if(arg.n==0) then
				entity[_action](entity);
			else
				tinsert(arg,1,entity);
				call(entity[_action],arg);
			end 
		end
	end
end

-------------------------------------------------------
function EntityGroupMgr:GetElementsCount(_group)
	local group=self.groups[_group];
	if(group ~= nil) then
		return getn(group);
	end
end

-------------------------------------------------------
function EntityGroupMgr:GetGroup(_group)
	return self.groups[_group];
end
