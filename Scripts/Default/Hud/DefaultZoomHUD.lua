DefaultZoomHUD = {
	MulMask = nil,
	ZoomSound=Sound:LoadSound("Sounds/items/scope.wav"),
};

function DefaultZoomHUD:DrawHUD(ZoomStep)
	if ( ZoomStep ~= self.PrevZoomStep ) then
		if ( DefaultZoomHUD.ZoomSound ) then
			Sound:StopSound( DefaultZoomHUD.ZoomSound );
			Sound:PlaySound( DefaultZoomHUD.ZoomSound );
		end
		self.PrevZoomStep = ZoomStep;
	end

	local posDistX;
	local posDistY;
	local posZoomX;
	local posZoomY;

	-- [tiago] must check what type of scope is active
	if (DefaultZoomHUD.MulMask) then
		-- [tiago] artists wanna wanna pixel perfect crossairs... must draw for each weapon
		if(_localplayer.cnt.weapon.name=="AG36") then
			-- center line
			local radius=25;
			System:Draw2DLine(398, 300, 398-radius+1, 300, 0,0,0,1);
			System:Draw2DLine(402, 300, 402+radius-1, 300, 0,0,0,1);

			-- circle center lines..
			System:Draw2DLine(400, 298-radius+2, 400, 298, 0, 0, 0, 1);
			System:Draw2DLine(400, 302, 400, 302+radius-2, 1, 0, 0, 1);

			posZoomX=290;
			posZoomY=300;
			posDistX=433;
			posDistY=300;
		end

		if(_localplayer.cnt.weapon.name=="OICW") then
			-- center line (some weird problem in line rendering...., line should be 1 pixel w/h...)
			--System:Draw2DLine(398.5, 30, 398.5, 80,0,0,0,1);
		  --System:Draw2DLine(400.5, 30, 400.5, 80,0,0,0,1);

			System:Draw2DLine(400, 30, 400, 300-2,0,0,0,1);
			System:Draw2DLine(400, 300+2, 400, 570,0,0,0,1);

			--System:Draw2DLine(398.5, 520, 398.5, 570,0,0,0,1);
			--System:Draw2DLine(400.5, 520, 400.5, 570,0,0,0,1);

			-- some horizontal lines..
			System:Draw2DLine(400-92, 300, 400-2, 300,0,0,0,1);
			System:Draw2DLine(400+2, 300, 400+92, 300,0,0,0,1);

			System:Draw2DLine(400-25, 380, 400+25, 380,0,0,0,1);
			System:Draw2DLine(400-15, 420, 400+15, 420,0,0,0,1);

			posZoomX=220;
			posZoomY=293;
			posDistX=502;
			posDistY=293;
		end

    -- must take care of texel adjustment... should put texture correct size if texture size changes..
    local fAdjustTexW=1.0/512.0;
    local fAdjustTexH=1.0/1024.0;

		System:DrawImageColorCoords( DefaultZoomHUD.MulMask, 0, 0, 400, 600   , 7, 1, 1, 1, 1, fAdjustTexW, 1-fAdjustTexH, 1-fAdjustTexW, fAdjustTexH);
		System:DrawImageColorCoords( DefaultZoomHUD.MulMask, 800, 0, -400, 600, 7, 1, 1, 1, 1, fAdjustTexW, 1-fAdjustTexH, 1-fAdjustTexW, fAdjustTexH);


	end

	--if (DefaultZoomHUD.MulMask) then
	--	System:DrawImage(DefaultZoomHUD.MulMask, 0, 0, 800, 600, 4);
		--System:Draw2DLine(xcent-7-shift,ycent,xcent-2-shift,ycent,r,g,b,1);
	--end

	-- Draw zoomfactor
	--Game:SetHUDFont("Digital", "Digital");
	Game:SetHUDFont("radiosta", "binozoom");
	local ZoomFactor = ZoomView.ZoomSteps[ZoomView.CurrZoomStep];
	local s=format( "%05.2f X", ZoomFactor);

	Game:WriteHudStringFixed(posZoomX, posZoomY, s, 1, 0, 0, 1 , 10, 10, 1.0);
	-- Draw distance
	local myPlayer=_localplayer;
	local int_pt=myPlayer.cnt:GetViewIntersection();
	if ( int_pt ) then
		local s=format( "%07.2fm", int_pt.len*1.5);
											  		  -- 0.5, 20, 20, 0.6
		Game:WriteHudStringFixed(posDistX, posDistY, s, 1, 0, 0, 1, 10, 10, 1.0);
	else
		Game:WriteHudStringFixed(posDistX, posDistY, "----.--m", 1, 0, 0, 1, 10, 10, 1.0);
	end



end