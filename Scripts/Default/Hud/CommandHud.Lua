--------------------------------------------------------------------
-- X-Isle Script File
-- Description: Commander Hud interface
-- Created by Lennert Schneider
--#Script.ReloadScript("scripts/default/hud/commandhud.lua");
--------------------------------------------------------------------

Hud = {
	nMapViewX=0,
	nMapViewY=100,
	nMapViewW=500,
	nMapViewH=500,
	fMapX=1024,
	fMapY=1024,
	fZoom=1,
	
	nPickType=Math.Or(Math.Or(ENTITYTYPE_PLAYER, ENTITYTYPE_WAYPOINT), ENTITYTYPE_OWNTEAM),
	
	pSingleSelection=nil,
	pSelection=nil,
	pCam1=nil,
	pCam2=nil,
}

----------------------------------
function Hud:OnInit()
	-- turn off rendering of the main view...
	System.EnableMainView(nil);
end

----------------------------------
function Hud:OnUpdate( DeltaTime )
	-- set helmet-cams
	if (Hud.pCam1) then
		CmdUtils.DrawHelmetCam(1, Hud.pCam1.id);
	end
	if (Hud.pCam2) then
		CmdUtils.DrawHelmetCam(2, Hud.pCam2.id);
	end
	if ( Hud.fMapX < 1024 / Hud.fZoom ) then
		Hud.fMapX = 1024 / Hud.fZoom;
	end
	if ( Hud.fMapY < 1024 / Hud.fZoom ) then
		Hud.fMapY = 1024 / Hud.fZoom;
	end
	if ( Hud.fMapX > 2048 - 1024 / Hud.fZoom ) then
		Hud.fMapX = 2048 - 1024 / Hud.fZoom;
	end
	if ( Hud.fMapY > 2048 - 1024 / Hud.fZoom ) then
		Hud.fMapY = 2048 - 1024 / Hud.fZoom;
	end
	CmdUtils.DrawMap(Hud.nMapViewX, Hud.nMapViewY, Hud.nMapViewW, Hud.nMapViewH, Hud.fZoom, Hud.fMapX, Hud.fMapY, Hud.pSelection);
end

----------------------------------
function Hud:OnShutdown()
	-- turn on rendering of the main view...
	System.EnableMainView(1);
end