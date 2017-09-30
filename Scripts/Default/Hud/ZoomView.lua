ZoomView={
	IsActive = 0,
	--Zoomable = 1,
	NoZoom = 90 * 3.1415962 / 180,
	CurrZoomStep = 1,
	MaxZoomSteps = 1,
	ZoomSteps={ NoZoom },
	Sway = 0.0,
	MinSway = 0.2,
	MaxSway = 0.4,
	SwayInc = 1,
	StanceSwayModifier = 1.0,
	AddZoom = 0.0,
	NumActive = 0,
	blend = 0,
};
--------------------------------------------------------
function ZoomView:OnInit()
	Game:CreateVariable("h_zoom_speed");
	h_zoom_speed = 250 * 3.1415962 / 180;
	Game:CreateVariable("h_zoom_sway",1); 
end

function ZoomView:Reset()
	Game:SetCameraFov( self.NoZoom);
end
--------------------------------------------------------
function ZoomView:Activate(_keymap,_sway,_fixedfactor,_fade)
	-- increment activate count
	ZoomView.NumActive = ZoomView.NumActive + 1;
	if (self.active == 1) then
		return;
	end

	self.AddZoom=0;
	if (_sway==nil) then
		_sway=0;
	end
	
	self.Sway = _sway;
	self.MinSway = _sway*0.5;
	
	--System:Log("ACTIVATE self.MinSway'"..self.MinSway.."' * self.StanceSwayModifier'"..self.StanceSwayModifier.."'");
		
	if ( _keymap == nil ) then		-- no keymap specified => use default zoom map
		_keymap = "zoom";
	end

	-- we have to do it this way, otherwise zooming undoes the stance input limits (slow movement when prone, etc..)
	if (ZoomView.NumActive == 1) then
		self.OldSensitivityScale = Input:GetMouseSensitivityScale();
		Input:SetMouseSensitivityScale( 0.3 * self.OldSensitivityScale );
		-- the code below forces to use detail mapping mode 2 for scoped weapons/items
		-- such as Binoculars, OICW, AG36, SniperRifle, RL and detail mapping mode 1 for
		-- the iron-sight aiming
		self.old_detail_val = e_detail_texture_min_fov;
		--if (self.MaxZoomSteps == 1) then
		--	e_detail_texture_min_fov = 0.01;
		--else
		--	e_detail_texture_min_fov = 100.0;
		--end
	end
	
	self.ZoomOverlayFunc =_overlay;
	self.FixedFactor=_fixedfactor;
	local player = _localplayer;
	
	if ( _sway ) then
		player.cnt:SetSwayAmp( _sway );
		player.cnt:SetSwayFreq( 0.6 );
	end
	local stats = player.cnt;
	stats.zoom = 1;
	if(_fade)then
		self.fade=self.ZoomSteps[self.CurrZoomStep];
		self.fade_start=_time - ZoomView.blend;
		Game:SetCameraFov( self.NoZoom);
	else
		Game:SetCameraFov( self.NoZoom / self.ZoomSteps[self.CurrZoomStep] );
	end
	Input:SetActionMap(_keymap);
	--System:Log("Input:SetActionMap ".._keymap);
	self.active=1;
end
--------------------------------------------------------
function ZoomView:OnUpdate()
	if(tonumber(h_zoom_sway)~=0)then
		_localplayer.cnt:SetSwayAmp(self.MinSway * self.StanceSwayModifier);
	else
		_localplayer.cnt:SetSwayAmp(0);
	end
	
	local ZoomTmp = (self.AddZoom / 50);
	if(ZoomTmp<0) then
		ZoomTmp=0;
	end
	
	if(self.fade)then
		local delta=_time-self.fade_start;
		local target = self.NoZoom/self.ZoomSteps[self.CurrZoomStep];
		local diff = self.NoZoom-target;
		local factor;	
		if(delta>=0.5)then
			self.fade=nil
			delta=0.5
		end
		factor=delta/0.5;
		self.currfov=self.NoZoom-(diff*factor);
		ZoomView.blend = factor;
		--System:Log("ZoomView "..tostring(ZoomView.blend));
		Game:SetCameraFov(self.currfov);
	else
		ZoomView.blend = 1.0;
		--System:Log("ZoomView2 "..tostring(ZoomView.blend));
		self.currfov=(self.NoZoom/self.ZoomSteps[self.CurrZoomStep]-ZoomTmp)
		Game:SetCameraFov(self.currfov);
	end
end
--------------------------------------------------------
function ZoomView:Deactivate()
	ZoomView.NumActive = ZoomView.NumActive - 1;
	
	if (ZoomView.NumActive < 0) then
		ZoomView.NumActive = 0;
	end

	if(self.active and ZoomView.NumActive == 0) then
		Input:SetActionMap( "default" );
		--System:Log("Input:SetActionMap Deactivate default");
		Input:SetMouseSensitivityScale( 1.0 );
		ZoomView.blend = 0;
		-- fix of detail map problem
		--e_detail_texture_min_fov = self.old_detail_val;
		
		self.active=nil;
	end
		
	self.FixedFactor=nil;
	self.AddZoom=0;
	
	local player = _localplayer;
	local stats = player.cnt;
	stats:SetSwayAmp( 0 );
	stats.zoom = 0;
	Game:SetCameraFov( self.NoZoom );
	
	self.fading=nil;
end
--------------------------------------------------------
function ZoomView:FadeOut()
	if(self.currfov==nil) then self.currfov=self.NoZoom end
	if(not self.fading)then
		self.fading=self.currfov-self.NoZoom;
		self.fading_time=_time
	else
		if((self.currfov-self.NoZoom)>=0)then
			ZoomView.blend = 0;
			--System:Log("ZoomView3 "..tostring(ZoomView.blend));
			self:Deactivate();
			return 1;
		else
			local target = self.NoZoom/self.ZoomSteps[self.CurrZoomStep];
			local diff = target - self.NoZoom;
			--System:Log("ZoomView42 "..tostring(self.currfov).."    "..tostring(_time-self.fading_time).."    "..tostring(self.fading));
			self.currfov=self.currfov+abs(self.fading*((_time-self.fading_time)));
			ZoomView.blend = (self.currfov - self.NoZoom)/diff;
			if (ZoomView.blend < 0) then
				ZoomView.blend = 0;
			end
			--System:Log("ZoomView4 "..tostring(ZoomView.blend));
			if(self.currfov>self.NoZoom)then return end
			Game:SetCameraFov( self.currfov );
		end
	end
end
--------------------------------------------------------
function ZoomView:ZoomIn()
	if (self.active and self.FixedFactor==nil) then
		self.CurrZoomStep = self.CurrZoomStep + 1;
		if ( self.CurrZoomStep > self.MaxZoomSteps ) then
			self.CurrZoomStep = self.MaxZoomSteps;
		end
		Game:SetCameraFov( self.NoZoom / self.ZoomSteps[self.CurrZoomStep]);
	end
end
--------------------------------------------------------
function ZoomView:ZoomOut()
	if (self.active and self.FixedFactor==nil) then
		self.CurrZoomStep = self.CurrZoomStep - 1;
		if ( self.CurrZoomStep < 1 ) then
			self.CurrZoomStep = 1;
		end
		Game:SetCameraFov( self.NoZoom / (self.ZoomSteps[self.CurrZoomStep]) );
	end
end
--------------------------------------------------------
function ZoomView:IsActive()
	return self.active;
end
