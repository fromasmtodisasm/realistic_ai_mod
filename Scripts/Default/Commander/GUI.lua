-------------------------------------------------------------------------
--	Menu Script Code
--
--	Created by Lennert Schneider
--
-- Copyright (C) 2001 Crytek Studios Inc.
-------------------------------------------------------------------------


--Menu Definition
------------------------------------------------------------------------

CmdGui={
	nMenuId=0,
	nCmdPage=0,
	pStdMouseCursor=0,
	nStdCursorSize=20,
	pMouseCursor=0,
	nCursorSize=0,
	nCursorOfsX=0,
	nCursorOfsY=0,
	nMouseX=0,
  nMouseY=0,
	nMouseState=0,
	pData=nil,
	pPlayerButtons={},
}

-------------------------------------------------------------------------
--Menu
-------------------------------------------------------------------------
function CmdGui:OnInit(nMenuId)
	Game:SetMenuCallback(nMenuId, "CmdGuiMenuCallback");
	--load mouse cursor image
	CmdGui.pStdMouseCursor=System:LoadImage("textures/GUI/mousecursor.tga");
	CmdGui.pMouseCursor=CmdGui.pStdMouseCursor;
	CmdGui.nCursorSize=CmdGui.nStdCursorSize;
	--create controls & stuff
	local CmdPage=Game:CreateMenuPage(nMenuId, "CmdPage");
	
	CmdGui.nMenuId=nMenuId;
	CmdGui.nCmdPage=CmdPage;
	
	CmdGui.MoveMapBtn=Game:AddButton(nMenuId, CmdPage,"MOVEMAP",nil,"GUI/cmd_move_n","GUI/cmd_move_o",370-32,590-32,32,32,"NOTHING",format( "Shift"));
	CmdGui.ZoomInMapBtn=Game:AddButton(nMenuId, CmdPage,"ZOOMINMAP",nil,"GUI/cmd_ZoomIn_n","GUI/cmd_ZoomIn_o",410-32,590-32,32,32,"NOTHING",format( "Zoom In"));
	CmdGui.ZoomOutMapBtn=Game:AddButton(nMenuId, CmdPage,"ZOOMOUTMAP",nil,"GUI/cmd_ZoomOut_n","GUI/cmd_ZoomOut_o",450-32,590-32,32,32,"NOTHING",format( "Zoom Out"));
	CmdGui.ZoomRangeMapBtn=Game:AddButton(nMenuId, CmdPage,"ZOOMRANGEMAP",nil,"GUI/cmd_ZoomRange_n","GUI/cmd_ZoomRange_o",490-32,590-32,32,32,"NOTHING",format( "Zoom Range"));
	
	CmdGui.Cam1OnBtn=Game:AddButton(nMenuId, CmdPage,"CAM1ON",nil,"GUI/cmd_camactivate_n","GUI/cmd_camactivate_o",520,170,32,32,"NOTHING",format( "Enable Camera 1"));
	CmdGui.Cam1OffBtn=Game:AddButton(nMenuId, CmdPage,"CAM1OFF",nil,"GUI/cmd_camdeactivate_n","GUI/cmd_camdeactivate_o",555,170,32,32,"NOTHING",format( "Disable Camera 1"));
	CmdGui.Cam1FreezeBtn=Game:AddButton(nMenuId, CmdPage,"CAM1FREEZE",nil,"GUI/cmd_camfreeze_n","GUI/cmd_camfreeze_o",590,170,32,32,"NOTHING",format( "Freeze Camera 1"));
	
	CmdGui.Cam2OnBtn=Game:AddButton(nMenuId, CmdPage,"CAM2ON",nil,"GUI/cmd_camactivate_n","GUI/cmd_camactivate_o",520,390,32,32,"NOTHING",format( "Enable Camera 2"));
	CmdGui.Cam2OffBtn=Game:AddButton(nMenuId, CmdPage,"CAM2OFF",nil,"GUI/cmd_camdeactivate_n","GUI/cmd_camdeactivate_o",555,390,32,32,"NOTHING",format( "Disable Camera 2"));
	CmdGui.Cam2FreezeBtn=Game:AddButton(nMenuId, CmdPage,"CAM2FREEZE",nil,"GUI/cmd_camfreeze_n","GUI/cmd_camfreeze_o",590,390,32,32,"NOTHING",format( "Freeze Camera 2"));
	
	local Orders1=Game:AddButton(nMenuId, CmdPage,"CMDB1",Language.Orders1,nil,nil,10,80,15,15,"NOTHING",format( "Pulldown menu for [Primary Orders]"));
	Game:SetButtonFont(nMenuId, CmdPage,Orders1,"Default","CmdGui",1,1,1);
	
	local Orders2=Game:AddButton(nMenuId, CmdPage,"CMDB2",Language.Orders2,nil,nil,180,80,15,15,"NOTHING",format( "Pulldown menu for [Secondary Orders]"));
	Game:SetButtonFont(nMenuId, CmdPage,Orders2,"Default","CmdGui",1,1,1);
	
	local Special=Game:AddButton(nMenuId, CmdPage,"CMDB3",Language.Special,nil,nil,370,80,15,15,"NOTHING",format( "Pulldown menu for [Special Orders]"));
	Game:SetButtonFont(nMenuId, CmdPage,Special,"Default","CmdGui",1,1,1);
	
	local PDMenu;
	CmdGui.O1_Go=Game:AddButton(nMenuId, CmdPage,"PD1B1",Language.O1_Go,nil,nil,0,0,16,16,"NOTHING",format( "Go to destination-point"));
	Game:SetButtonFont(nMenuId, CmdPage,CmdGui.O1_Go,"Default","CmdGui",1,1,1);
	CmdGui.O1_Attack=Game:AddButton(nMenuId, CmdPage,"PD1B2",Language.O1_Attack,nil,nil,0,0,16,16,"NOTHING",format( "Attack destination-point"));
	Game:SetButtonFont(nMenuId, CmdPage,CmdGui.O1_Attack,"Default","CmdGui",1,1,1);
	CmdGui.O1_Defend=Game:AddButton(nMenuId, CmdPage,"PD1B3",Language.O1_Defend,nil,nil,0,0,16,16,"NOTHING",format( "Defend destination-point"));
	Game:SetButtonFont(nMenuId, CmdPage,CmdGui.O1_Follow,"Default","CmdGui",1,1,1);
	PDMenu=Game:InitPDMenu(nMenuId, CmdPage, Orders1);
	Game:AddPDMenuItem(nMenuId, CmdPage, PDMenu, CmdGui.O1_Go);
	Game:AddPDMenuItem(nMenuId, CmdPage, PDMenu, CmdGui.O1_Attack);
	Game:AddPDMenuItem(nMenuId, CmdPage, PDMenu, CmdGui.O1_Defend);
	
	CmdGui.O2_Cover=Game:AddButton(nMenuId, CmdPage,"PD2B1",Language.O2_Cover,nil,nil,0,0,16,16,"NOTHING",format( "Cover the destination-point"));
	Game:SetButtonFont(nMenuId, CmdPage,CmdGui.O2_Cover,"Default","CmdGui",1,1,1);
	CmdGui.O2_BarrageFire=Game:AddButton(nMenuId, CmdPage,"PD2B2",Language.O2_BarrageFire,nil,nil,0,0,16,16,"NOTHING",format( "Perform a barrage-fire at the destination-point"));
	Game:SetButtonFont(nMenuId, CmdPage,CmdGui.O2_BarrageFire,"Default","CmdGui",1,1,1);
	PDMenu=Game:InitPDMenu(nMenuId, CmdPage, Orders2);
	Game:AddPDMenuItem(nMenuId, CmdPage, PDMenu, CmdGui.O2_Cover);
	Game:AddPDMenuItem(nMenuId, CmdPage, PDMenu, CmdGui.O2_BarrageFire);
	
	CmdGui.S_Grenade=Game:AddButton(nMenuId, CmdPage,"PD3B1",Language.S_Grenade,nil,nil,0,0,16,16,"NOTHING",format( "Throw a grenade at the destination-point"));
	Game:SetButtonFont(nMenuId, CmdPage,CmdGui.S_Grenade,"Default","CmdGui",1,1,1);
	CmdGui.S_BlendGrenade=Game:AddButton(nMenuId, CmdPage,"PD3B2",Language.S_BlendGrenade,nil,nil,0,0,16,16,"NOTHING",format( "Throw a blend-grenade at the destination-point"));
	Game:SetButtonFont(nMenuId, CmdPage,CmdGui.S_BlendGrenade,"Default","CmdGui",1,1,1);
	CmdGui.S_SmokeGrenade=Game:AddButton(nMenuId, CmdPage,"PD3B3",Language.S_SmokeGrenade,nil,nil,0,0,16,16,"NOTHING",format( "Throw a smoke-grenade at the destination-point"));
	Game:SetButtonFont(nMenuId, CmdPage,CmdGui.S_SmokeGrenade,"Default","CmdGui",1,1,1);
	CmdGui.S_Trap=Game:AddButton(nMenuId, CmdPage,"PD3B4",Language.S_Trap,nil,nil,0,0,16,16,"NOTHING",format( "Set a trap at the destination-point"));
	Game:SetButtonFont(nMenuId, CmdPage,CmdGui.S_Trap,"Default","CmdGui",1,1,1);
	CmdGui.S_NoFire=Game:AddButton(nMenuId, CmdPage,"PD3B5",Language.S_NoFire,nil,nil,0,0,16,16,"NOTHING",format( "Don't fire"));
	Game:SetButtonFont(nMenuId, CmdPage,CmdGui.S_NoFire,"Default","CmdGui",1,1,1);
	CmdGui.S_Loud=Game:AddButton(nMenuId, CmdPage,"PD3B6",Language.S_Loud,nil,nil,0,0,16,16,"NOTHING",format( "Go loud"));
	Game:SetButtonFont(nMenuId, CmdPage,CmdGui.S_Loud,"Default","CmdGui",1,1,1);
	CmdGui.S_Silent=Game:AddButton(nMenuId, CmdPage,"PD3B7",Language.S_Silent,nil,nil,0,0,16,16,"NOTHING",format( "Go silent"));
	Game:SetButtonFont(nMenuId, CmdPage,CmdGui.S_Silent,"Default","CmdGui",1,1,1);
	
	PDMenu=Game:InitPDMenu(nMenuId, CmdPage, Special);
	Game:AddPDMenuItem(nMenuId, CmdPage, PDMenu, CmdGui.S_Grenade);
	Game:AddPDMenuItem(nMenuId, CmdPage, PDMenu, CmdGui.S_BlendGrenade);
	Game:AddPDMenuItem(nMenuId, CmdPage, PDMenu, CmdGui.S_SmokeGrenade);
	Game:AddPDMenuItem(nMenuId, CmdPage, PDMenu, CmdGui.S_Trap);
	Game:AddPDMenuItem(nMenuId, CmdPage, PDMenu, CmdGui.S_NoFire);
	Game:AddPDMenuItem(nMenuId, CmdPage, PDMenu, CmdGui.S_Loud);
	Game:AddPDMenuItem(nMenuId, CmdPage, PDMenu, CmdGui.S_Silent);
	
	for y=0,3,1 do
		for x=0,3,1 do
			CmdGui.pPlayerButtons[y*4+x+1]=Game:AddButton(nMenuId, CmdPage, "PB"..x..y, "", nil, nil, 0, 0, 15, 15, "NOTHING", "Unit selector/status");
			Game:SetButtonFont(nMenuId, CmdPage, CmdGui.pPlayerButtons[y*4+x+1], "Default", "CmdGui", 1, 1, 1);
			Game:SetButtonPosition(nMenuId, CmdPage, CmdGui.pPlayerButtons[y*4+x+1], 30+192.5+x*192.5, 2+y*20, 15, 15, 2);
		end
	end

	Game:SetCurrentPage(nMenuId, "CmdPage");
end

-------------------------------------------------------------------------
function CmdGui:OnDraw(nMouseX,nMouseY,nMouseState,pData)
	CmdGui.nMouseX=nMouseX;
	CmdGui.nMouseY=nMouseY;
	CmdGui.nMouseState=nMouseState;
	CmdGui.pData=pData;
	System:DrawImage(CmdGui.pMouseCursor,CmdGui.nMouseX-CmdGui.nCursorOfsX, CmdGui.nMouseY-CmdGui.nCursorOfsY, CmdGui.nCursorSize, CmdGui.nCursorSize, 4);
end

-------------------------------------------------------------------------
function CmdGui:OnShutdown()
end

-------------------------------------------------------------------------
-------------------------------------------------------------------------
CmdGuiMenuCallback={
}

-------------------------------------------------------------------------
function CmdGuiMenuCallback:OnMenuItemClick(tbl)
	System:LogToConsole("MNU => ID: "..tbl.id.." (X: "..tbl.x..", Y: "..tbl.y..")");
	if ( tbl.id == CmdGui.O1_Go ) then
		Hud.nLastCmd=CMD_GO;
		Hud.SetMode(Hud, MODE_TARGETHIT);
	end
	if ( tbl.id == CmdGui.O1_Attack ) then
		Hud.nLastCmd=CMD_ATTACK;
		Hud.SetMode(Hud, MODE_TARGETHIT);
	end
	if ( tbl.id == CmdGui.O1_Defend ) then
		Hud.nLastCmd=CMD_DEFEND;
		Hud.SetMode(Hud, MODE_TARGETHIT);
	end
	if ( tbl.id == CmdGui.O2_Cover ) then
		Hud.nLastCmd=CMD_COVER;
		Hud.SetMode(Hud, MODE_TARGETHIT);
	end
	if ( tbl.id == CmdGui.O2_BarrageFire ) then
		Hud.nLastCmd=CMD_BARRAGEFIRE;
		Hud.SetMode(Hud, MODE_TARGETHIT);
	end
end

-------------------------------------------------------------------------
function CmdGuiMenuCallback:OnButtonClick(tbl)
	if (tbl.id==CmdGui.MoveMapBtn) then
		Hud.SetMode(Hud, MODE_PAN);
	elseif (tbl.id==CmdGui.ZoomInMapBtn) then
		Hud.fZoom=Hud.fZoom*1.2;
		if (Hud.fZoom>Hud.fMaxZoom) then
			Hud.fZoom=Hud.fMaxZoom;
		end
	elseif (tbl.id==CmdGui.ZoomOutMapBtn) then
		Hud.fZoom=Hud.fZoom*0.8;
		if (Hud.fZoom<1) then
			Hud.fZoom=1;
		end
	elseif (tbl.id==CmdGui.ZoomRangeMapBtn) then
		Hud.SetMode(Hud, MODE_SELRANGE);
	elseif (tbl.id==CmdGui.Cam1OnBtn) then
		if (Hud.pSingleSelection) then
			Hud.pCam1=Hud.pSingleSelection;
		end
	elseif (tbl.id==CmdGui.Cam1OffBtn) then
		Hud.pCam1=nil;
	elseif (tbl.id==CmdGui.Cam2OnBtn) then
		if (Hud.pSingleSelection) then
			Hud.pCam2=Hud.pSingleSelection;
		end
	elseif (tbl.id==CmdGui.Cam2OffBtn) then
		Hud.pCam2=nil;
	end
--	System.LogToConsole("BTN => ID: "..tbl.id.." (X: "..tbl.x..", Y: "..tbl.y..")");
end