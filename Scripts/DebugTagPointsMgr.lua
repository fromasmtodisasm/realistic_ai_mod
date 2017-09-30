DebugTagPointsMgr={
	tagPoints={},
	maxtags=6,
	path="",
};

function DebugTagPointsMgr:Init(mapname)
	self.path=sprintf("LEVELS/%s/tags.txt",mapname);
	printf("DebugTagPointsMgr INITIALIZED [%s]",self.path);
	self:Load();
end

function DebugTagPointsMgr:ReadTag(file)
	local _x,_y,_z,_ax,_ay,_az=read(file,'*n','*n','*n','*n','*n','*n');
	if((_x~=nil) and (_y~=nil) and (_z~=nil) and (_ax~=nil) and (_ay~=nil) and (_az~=nil))then
		return {pos={x=_x,y=_y,z=_z},angles={x=_ax,y=_ay,z=_az}}
	else
		return nil;
	end
end

function DebugTagPointsMgr:Load()
	local nNumOfCoords=0;
	local file=openfile(self.path,"r");
	
	if(file)then
		local coord=self:ReadTag(file);
		while(coord~=nil)do
			nNumOfCoords=nNumOfCoords+1;
			self.tagPoints[nNumOfCoords]=coord;
			coord=self:ReadTag(file);
		end
		closefile(file);
	else
		printf("cannot open the file %s",self.path);
	end

	for i=(nNumOfCoords+1),self.maxtags do
		self.tagPoints[i]={pos={x=0,y=0,z=0},angles={x=0,y=0,z=0}};
	end
end

------------------------------------------------------------
function DebugTagPointsMgr:Save()
	local file=openfile(self.path,"w+");
	for i=1,self.maxtags do
		if(self.tagPoints[i]==nil)then
			printf("self.tagPoints[%s]==nil\n",i)
			break
		else
			local pos=self.tagPoints[i].pos;
			local ang=self.tagPoints[i].angles;
			write(file,sprintf("%0.8f %0.8f %0.8f %0.8f %0.8f %0.8f\n",pos.x,pos.y,pos.z,ang.x,ang.y,ang.z));
		end
	end
	closefile(file);
end
------------------------------------------------------------
function DebugTagPointsMgr:Dump()
	self:Load();
	for i=1,self.maxtags do
		if(self.tagPoints[i])then
			local pos=self.tagPoints[i].pos;
			local ang=self.tagPoints[i].angles;
			printf("%0.8f %0.8f %0.8f %0.8f %0.8f %0.8f\n",pos.x,pos.y,pos.z,ang.x,ang.y,ang.z);
		end
	end
end
------------------------------------------------------------
function DebugTagPointsMgr:SetTag(idx,_pos,_ang)
	if((idx<1) or (idx>self.maxtags))then
		printf("index out of range %d",idx);
		return
	else
		if(_pos==nil or _ang==nil)then
			printf("a param is nil",idx);
			return
		end
		self:Load();
		self.tagPoints[idx]={pos=_pos,angles=_ang};
		self:Save();
	end
end
------------------------------------------------------------
function DebugTagPointsMgr:GetTag(idx)
	if((idx<1) or (idx>self.maxtags))then
		printf("index out of range %d",idx);
		return
	else
		self:Load();
		return self.tagPoints[idx];
	end
end