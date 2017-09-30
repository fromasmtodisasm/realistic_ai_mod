Binoculars = {
	name = "Binoculars",
	type = "Weapon",
	
	-- if the weapon supports zooming then add this...
	ZoomActive = 0,												-- initially always 0
	MinZoom =   45 * 3.1415962 / 180,		-- minimum zoom-factor (calculated: 90 / desired_zoom_factor * pi / 180)
	MaxZoom =   4.5 * 3.1415962 / 180,		-- maximum zoom-factor (calculated like minzoom)
	
	OldWeapon = -1,
	WasInVehicle = 0,
}

-------------------------------------------------------
function Binoculars:OnInit()
	self.SetName( self.name );
	self.MulMask=System.LoadImage("Textures/Hud/BinocularsMulMask.tga");
	Binoculars.nMotionTrackerLayerId=Game.AddViewLayer("scripts/default/hud/MoTrackLayer.lua", "MoTrackLayer");	-- load motiontracker
	if (Binoculars.nMotionTrackerLayerId) then
		Game.EnableViewLayer(Binoculars.nMotionTrackerLayerId, nil);	-- disable motiontracker
	end
end

-------------------------------------------------------
function Binoculars:OnUpdate()
end

-------------------------------------------------------
function Binoculars:OnShutdown()
	if (Binoculars.nMotionTrackerLayerId) then
		Game.RemoveViewLayer(Binoculars.nMotionTrackerLayerId);	-- destroy motiontracker
	end
end

----------------------------------
function Binoculars:OnFire( Params )
	return nil;
end

----------------------------------
function Binoculars:OnHit( hit )
end

----------------------------------
function Binoculars:OnEvent( EventId, Params )
	if ( EventId == ScriptEvent_Activate ) then
		self.OnActivate( self );
	elseif ( EventId == ScriptEvent_Deactivate ) then
		self.OnDeactivate( self );
	end
end


----------------------------------
function Binoculars:OnEnhanceHUD( )
	local MyPlayer = System.GetMyPlayer();
	local stats = MyPlayer.cnt.GetPlayerStats();
	if ( stats.in_vehicle ) then
		Zoom.Activate( Zoom, 0 );
		self.WasInVehicle = 1;
	else
		if ( self.WasInVehicle == 1 ) then
			Zoom.Activate( Zoom, 1 );
			self.WasInVehicle = 0;
		end
		System.DrawImage(self.MulMask, 0, 0, 800, 600, 4);
	end
end

----------------------------------
function Binoculars:OnActivate()
	self.WasInVehicle = 0;
	Zoom.Zoomable = 1;
	Zoom.DrawStats = 1;
	Zoom.MinZoom = self.MinZoom;
	Zoom.MaxZoom = self.MaxZoom;
	local MyPlayer = System.GetMyPlayer();
	local stats = MyPlayer.cnt.GetPlayerStats();
	if ( stats.in_vehicle ) then
		self.WasInVehicle = 1;
	else
		Zoom.Activate( Zoom, 1 );
	end
	MyPlayer.DisableSway = 1;
	if (Binoculars.nMotionTrackerLayerId) then
		MoTrackLayer.Enable( MoTrackLayer, Binoculars.nMotionTrackerLayerId );
	end
--	local player = System.GetMyPlayer();
--	if ( player ) then
--		System.LogToConsole(self.OldWeapon);
--		if ( self.OldWeapon == -1 ) then
--			self.OldWeapon = player.cnt.GetCurrWeaponId();
--		else
--			player.cnt.SetCurrWeapon( self.OldWeapon );
--			self.OldWeapon = -1;
--		end
--	end
end

----------------------------------
function Binoculars:OnDeactivate()
	Zoom.Activate( Zoom, 0 );
	self.OldWeapon = -1;
	local MyPlayer = System.GetMyPlayer();
	MyPlayer.DisableSway = nil;
	if (Binoculars.nMotionTrackerLayerId) then
		MoTrackLayer.Disable( MoTrackLayer, Binoculars.nMotionTrackerLayerId );
	end
end

----------------------------------
function Binoculars:OnSave( stm )
end

----------------------------------
function Binoculars:OnLoad( stm )
end