function DefOnMouseEnter(self)
	self:SetBorderColor(UI.szFocusColor);
end

function DefOnMouseLeave(self)
	local Focus = UI:GetFocus();
	
	if (Focus) then
		if (Focus:GetName() == self:GetName()) then
			local ScreenF = Focus:GetScreen();
			local ScreenS = self:GetScreen();

			if (ScreenF:GetName() == ScreenS:GetName()) then
				return
			end
		end
	end

	self:SetBorderColor(UI.szBorderColor);
end

function DefOnGotFocus(self)
	self:SetBorderColor(UI.szFocusColor);
end

function DefOnLostFocus(self)
	self:SetBorderColor(UI.szBorderColor);
end

function DefOnMouseEnterSideButton(self)
	self:SetFontColor(UI.szFocusColor);
end

function DefOnGotFocusButton(self)
	self:SetOverState(1);
end

function DefOnLostFocusButton(self)
	self:SetOverState(0);
end

function DefOnMouseLeaveSideButton(self)
	local Focus = UI:GetFocus();
	
	if (Focus) then
		if (Focus:GetName() == self:GetName()) then
			local ScreenF = Focus:GetScreen();
			local ScreenS = self:GetScreen();

			if (ScreenF:GetName() == ScreenS:GetName()) then
				return
			end
		end
	end

	self:SetFontColor("113 142 122 255");
end
	
function DefOnGotFocusSideButton(self)
	self:SetFontColor(UI.szFocusColor);
end

function DefOnLostFocusSideButton(self)
	self:SetFontColor("113 142 122 255");
end


UI.skins=
{	
	ServerTypeIcon = { { System:LoadImage("textures/gui/servericons"), 18, 18, "1 	1		22 	22", }, -- 1 - win32
										 { System:LoadImage("textures/gui/servericons"), 18, 18, "25 	1		22	22", }, -- 2 - win64
										 { System:LoadImage("textures/gui/servericons"), 18, 18, "73	1		22	22", }, -- 3 - lin32
										 { System:LoadImage("textures/gui/servericons"), 18, 18, "49	1		22	22", }, -- 4 - lin64
										 { System:LoadImage("textures/gui/servericons"), 18, 18, "1		25	22	22", }, -- 5 - dedicated
										 { System:LoadImage("textures/gui/servericons"), 18, 18, "25	25	22	22", }, -- 6 - non-dedicated
										 { System:LoadImage("textures/gui/servericons"), 18, 18, "73	25	22	22", }, -- 7 - green cross
										 { System:LoadImage("textures/gui/servericons"), 18, 18, "49	25	22	22", }, -- 8 - punkbuster
										 { System:LoadImage("textures/gui/servericons"), 18, 18, "97	22	22	22", }, -- 9 - password
									 },
	MenuStatic=							-- e.g. time counting down
	{
		classname = "static",
		width = 180, height = 28,
		
		color = "0 0 0 255",
		
		leftspacing = 6,
		
		bordersize = 1,
		bordercolor = UI.szBorderColor,
	},
	
	MenuBorder=							-- e.g. borders to show grouping
	{
		classname = "static",
		width = 180, height = 28,
		
		color = "0 0 0 0",
		
		leftspacing = 6,
		
		bordersize = 1,
		bordercolor = UI.szBorderColor,
	},
	
	TopMenuButton=
	{
		classname = "button",
		left = 200, top = 110,
		width = 180, height = 24.5,
		bordersides="lr",
				
		texture = System:LoadImage("textures/gui/buttons.dss"),
		downtexture = System:LoadImage("textures/gui/buttons_down.dss"),
		overtexture = System:LoadImage("textures/gui/buttons_over.dss"),
		texrect = "0 0 1 1",
		
		color = "255 255 255 255",
				
		bordersize = 1,
		bordercolor = UI.szBorderColor,
		
		fontsize = 18,
		
		OnGotFocus = DefOnGotFocusButton,
		OnLostFocus = DefOnLostFocusButton,	
	},

	BottomMenuButton=
	{
		classname = "button",
		left = 200, top = 465,
		width = 180, height = 25,
		bordersides="lr",
		
		texture = System:LoadImage("textures/gui/buttons.dss"),
		downtexture = System:LoadImage("textures/gui/buttons_down.dss"),
		overtexture = System:LoadImage("textures/gui/buttons_over.dss"),
		texrect = "0 0 1 1",	
		
		color = "255 255 255 255",
		
		bordersize = 1,
		bordercolor = UI.szBorderColor,
				
		fontsize = 18,
		
		OnGotFocus = DefOnGotFocusButton,
		OnLostFocus = DefOnLostFocusButton,	
	},

	SideMenuButton=
	{
		classname = "button",
		width = 148, height = 32,
		style = UISTYLE_TRANSPARENT,
		
		fontcolor = "113 142 122 255",
		
		fontsize = 20,
		halign = UIALIGN_LEFT,
		
		OnGotFocus = DefOnGotFocusSideButton,
		OnLostFocus = DefOnLostFocusSideButton,	
		OnMouseEnter = DefOnMouseEnterSideButton,
		OnMouseLeave = DefOnMouseLeaveSideButton,
	},

	MenuHeader=
	{
		classname = "static",
		left = 0, top = 0,
		width = 800, height = 100,

		bordersize = 0,
		bordercolor = "0 0 0 255",	
		
		color = "0 0 0 0",
	},

	MenuFooter=
	{
		classname = "static",
		left = 0, top = 600 - 100,
		width = 800, height = 100,
		
		bordersize = 0,
				
		texture = System:LoadImage("Textures/gui/menubottom"),
		texrect = "0, 1, 1024, 128",
	},

	MenuLeft=
	{
		classname = "static",
		left = 0, top = 100,
		width = 49, height = 500,
		
		bordersize = 0,
				
		texture = System:LoadImage("Textures/gui/menuleft"),
		texrect = "0, 0, 64, 512",
	},

	MenuRight=
	{
		classname = "static",
		left = 700, top = 100,
		width = 100, height = 100,
		
		bordersize = 0,
		flags = UIFLAG_VISIBLE,
		greyedcolor = "0 0 0 0",
				
		texture = System:LoadImage("Textures/gui/menuright"),
		texrect = "0, 0, 128, 128",
	},

	FooterAd=
	{
		classname = "static",
		
		color = "255 255 255 255",
		
		bordersize = 0,
	},
	
	MenuHeader=
	{
		classname = "static",
		left = 0, top = 0,
		width = 800, height = 100,
		color = "255 255 255 255",
		bordersize = 0,
		
		texture = System:LoadImage("Textures/gui/menutop1"),
		texrect = "0, 0, 1024, 128",
	},
	
	BackStatic=
	{
		classname = "static",
		left = 200, top = 110,
		width = 580, height = 380,
		
		color = "0 0 0 96",
		bordersize = 1,
		bordercolor = UI.szBorderColor,
	},
	
	ComboBox=
	{
		classname = "combobox",
		width = 166, height = 28,

		bordersize = 1,
		bordercolor = UI.szBorderColor,
		
		buttontexture = System:LoadImage("textures/gui/buttons.dds"),
		downbuttontexture = System:LoadImage("textures/gui/buttons_down.dds"),
		overbuttontexture = System:LoadImage("textures/gui/buttons_over.dds"),
		buttontexrect = "2 3 25 25",
		
		itembgcolor = "0 0 0 255",
		
		leftspacing = 6,
		buttonsize = 28,

		OnGotFocus = DefOnGotFocus,
		OnLostFocus = DefOnLostFocus,
		OnMouseEnter = DefOnMouseEnter,
		OnMouseLeave = DefOnMouseLeave,		
	},

	EditBox=
	{
		classname = "editbox",
		width = 166, height = 28,

		bordersize = 1,
		bordercolor = UI.szBorderColor,
		
--		style = UISTYLE_TRANSPARENT,
		
		leftspacing = 4,
		rightspacing = 4,
		
		cursorcolor = "255 255 255 255",
		selectioncolor = UI.szSelectionColor,
		color="0 0 0 255",
				
		OnGotFocus = DefOnGotFocus,
		OnLostFocus = DefOnLostFocus,
		OnMouseEnter = DefOnMouseEnter,
		OnMouseLeave = DefOnMouseLeave,
	},

	ListView=
	{
		classname = "listview",
		width = 680, height = 480,
		bordersize = 1,
		bordercolor = UI.szBorderColor,
		color="0 0 0 0",
		headerheight = 22,
		cellpadding = 4,

		sortcolumntextcolor = "255 255 255 255",
		sortcolumncolor = "181 246 188 255",
		selectioncolor = UI.szSelectionColor,
		
		OnGotFocus = DefOnGotFocus,
		OnLostFocus = DefOnLostFocus,
		OnMouseEnter = DefOnMouseEnter,
		OnMouseLeave = DefOnMouseLeave,
	},
	
	MultilineStatic=
	{
		classname = "static",
		width = 680, height = 480,
		bordersize = 1,
		bordercolor = UI.szBorderColor,
		color="0 0 0 0",		
	},
	
	CheckBox=
	{
		classname = "checkbox",
		width = 28, height = 28,
--		color="255 255 255 255",
		color="0 0 0 255",
				
		bordersize = 1,
		bordercolor = UI.szBorderColor,
		
		checkcolor = "121 186 128 255",
		
--		style = UISTYLE_TRANSPARENT,
		
		OnGotFocus = DefOnGotFocus,
		OnLostFocus = DefOnLostFocus,
		OnMouseEnter = DefOnMouseEnter,
		OnMouseLeave = DefOnMouseLeave,		
	},
	
	Label=
	{
		classname = "static",
		style = UISTYLE_TRANSPARENT,
		halign = UIALIGN_RIGHT,
		height = 28,
		
		leftspacing = 6,
	},

	VScrollBar=
	{
		classname = "scrollbar",
		color = "255 255 255 255",
		
		bordersize = 1,
		bordercolor = UI.szBorderColor,
		
		pathtexture = System:LoadImage("textures/gui/buttons.dds"),
		downpathtexture = System:LoadImage("textures/gui/buttons_down.dds"),
		overpathtexture = System:LoadImage("textures/gui/buttons_over.dds"),
		pathtexrect = "2 2 1 1",
		slidertexture = System:LoadImage("textures/gui/buttons.dds"),
		downslidertexture = System:LoadImage("textures/gui/buttons_down.dds"),
		overslidertexture = System:LoadImage("textures/gui/buttons_over.dds"),
		slidertexrect = "59 30 24 27",
		minustexture = System:LoadImage("textures/gui/buttons.dds"),
		downminustexture = System:LoadImage("textures/gui/buttons_down.dds"),
		overminustexture = System:LoadImage("textures/gui/buttons_over.dds"),
		minustexrect = "31 3 24 24",
		plustexture = System:LoadImage("textures/gui/buttons.dds"),
		downplustexture = System:LoadImage("textures/gui/buttons_down.dds"),
		overplustexture = System:LoadImage("textures/gui/buttons_over.dds"),	
		plustexrect = "3 3 24 24",
		
		width = 20, height = 200,
		
		OnGotFocus = DefOnGotFocus,
		OnLostFocus = DefOnLostFocus,
		OnMouseEnter = DefOnMouseEnter,
		OnMouseLeave = DefOnMouseLeave,		
	},

	HScrollBar=
	{
		classname = "scrollbar",
		color = "255 255 255 255",
		
		bordersize = 1,
		bordercolor = UI.szBorderColor,
		
		pathtexture = System:LoadImage("textures/gui/buttons.dds"),
		downpathtexture = System:LoadImage("textures/gui/buttons_down.dds"),
		overpathtexture = System:LoadImage("textures/gui/buttons_over.dds"),
		pathtexrect = "2 2 1 1",	
		slidertexture = System:LoadImage("textures/gui/buttons.dds"),
		downslidertexture = System:LoadImage("textures/gui/buttons_down.dds"),
		overslidertexture = System:LoadImage("textures/gui/buttons_over.dds"),
		slidertexrect = "58 31 26 24",
		minustexture = System:LoadImage("textures/gui/buttons.dds"),
		downminustexture = System:LoadImage("textures/gui/buttons_down.dds"),
		overminustexture = System:LoadImage("textures/gui/buttons_over.dds"),
		minustexrect = "3 31 24 24",
		plustexture = System:LoadImage("textures/gui/buttons.dds"),
		downplustexture = System:LoadImage("textures/gui/buttons_down.dds"),
		overplustexture = System:LoadImage("textures/gui/buttons_over.dds"),	
		plustexrect = "31 31 24 24",
		
		width = 200, height = 20,

		OnGotFocus = DefOnGotFocus,
		OnLostFocus = DefOnLostFocus,
		OnMouseEnter = DefOnMouseEnter,
		OnMouseLeave = DefOnMouseLeave,		
	},

	ChatBox=
	{
		classname = "static",
		style = UISTYLE_MULTILINE + UISTYLE_WORDWRAP,
		color = "0 0 0 0",
		
		valign = UIALIGN_BOTTOM,
		
		bordersize = 1,
		bordercolor = UI.szBorderColor,
	},
	
	ChatTarget=
	{
		classname = "combobox",
		width = 126, height = 26,

		color = "255, 255, 255, 255",		
		rollup = 1,
		
		bordersize = 1,
		bordercolor = UI.szBorderColor,
		
		buttontexture = System:LoadImage("textures/gui/buttons.dds"),
		downbuttontexture = System:LoadImage("textures/gui/buttons_down.dds"),
		overbuttontexture = System:LoadImage("textures/gui/buttons_over.dds"),
		buttontexrect = "2 3 25 25",
		
		itembgcolor = "0 0 0 255",
		
		leftspacing = 4,
		buttonsize = 22,
		
		OnGotFocus = DefOnGotFocus,
		OnLostFocus = DefOnLostFocus,
		OnMouseEnter = DefOnMouseEnter,
		OnMouseLeave = DefOnMouseLeave,			
	},
	
	ChatInput=
	{
		classname = "editbox",
		width = 440, height = 24,
		
		color = "0 0 0 64",
		
		bordersize = 1,
		bordercolor = UI.szBorderColor,
		cursorcolor = "255 255 255 255",
		selectioncolor = UI.szSelectionColor,
	
		OnGotFocus = DefOnGotFocus,
		OnLostFocus = DefOnLostFocus,
		OnMouseEnter = DefOnMouseEnter,
		OnMouseLeave = DefOnMouseLeave,			
	}
};