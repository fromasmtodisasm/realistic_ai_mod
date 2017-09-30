ViewLayersMgr={
	layer={
		obj=0,
		priority=0,
	},
	layers={},
	fading_layers=nil,
	activelayers=nil,
}

function ViewLayersMgr:AddLayer(name,layer)
	local n=count(self.layers);
	self.layers[name]={ obj=layer, priority=n };
end

function ViewLayersMgr:Update()
	for i,layer in self.fading_layers do
		if(layer:OnFadeOut())then
			self.fading_layers[i]=nil;
		end
	end
	
	-- This allocates lua tables.
	--self.activelayers:OnUpdate();
	
	local pool = self.activelayers._pool;
	for i,val in pool do
		if (val.OnUpdate) then
			val:OnUpdate();
		end
	end
end

function ViewLayersMgr:DrawOverlay(zoomstep)
	-- This allocates lua tables.
	--self.activelayers:DrawOverlay(zoomstep);
	local pool = self.activelayers._pool;
	for i,object in pool do
		if (object.DrawOverlay) then
			object:DrawOverlay(zoomstep);
		end
	end
end

function ViewLayersMgr:IsActive(name)
	local layer=self.layers[name];
	if(layer)then
		return self.activelayers:Exists(layer.priority);
	else
		return nil;
	end
end

function ViewLayersMgr:IsFading(name)
	return self.fading_layers[name];
end

function ViewLayersMgr:ActivateLayer(name)
	local layer=self.layers[name];
	if(layer)then
		if(layer.obj.OnActivate)then
			layer.obj:OnActivate();
		end
		self.activelayers:AddObj(layer.obj,layer.priority);
	else
		if(name)then
			System:Log("Error layer not found "..name);
		else
			System:Log("Error layer not found [name is nil]");
		end
	end
end

function ViewLayersMgr:GetActivateLayer(name)
	local layer=self.layers[name];
	
	if(layer)then
		return layer.obj;
	else
		return nil;
	end
end

function ViewLayersMgr:GetFadingLayer(name)
	return self.fading_layers[name];
end

function ViewLayersMgr:DeactivateLayer(name,nofade)
	local layer=self.layers[name];
	
	self.activelayers:RemoveObject(layer.priority);
	
	if(layer.obj.OnFadeOut and (not nofade))then
		self.fading_layers[name]=layer.obj;
	elseif(layer.obj.OnDeactivate)then
		layer.obj:OnDeactivate(nofade);
	end
	
	if (nofade) then
		self.fading_layers[name]=nil;
	end
end

function ViewLayersMgr:DeactivateActiveLayer(name,nofade)
	if (self:IsActive(name)) then
		self:DeactivateLayer(name, nofade);
	end
end

function ViewLayersMgr:ReactivateLayer(name)
	local layerObj=self.fading_layers[name];
	
	if (layerObj) then
		self.fading_layers[name]=nil;
	end
	
	local layer=self.layers[name];

	if (layer) then
		self.activelayers:AddObj(layer.obj,layer.priority);
		if (layer.obj.OnReactivate) then
			layer.obj.OnReactivate();
		end
	end
end

function ViewLayersMgr:DeactivateAll()
	self.activelayers:OnDeactivate(1);
	self.activelayers=MethodDispatcherPool:new();
end

function ViewLayersMgr:new()
	local vlm=new(ViewLayersMgr);
	vlm.activelayers=MethodDispatcherPool:new()
	vlm.fading_layers={}
	return vlm;
end