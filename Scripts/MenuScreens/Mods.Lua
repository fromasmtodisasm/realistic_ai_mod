
--
-- Mod menu page
--

UI.PageMods=
{

	GUI=
	{

		currentmod =
		{
			skin = UI.skins.Label,
			left = 490, top = 108,
			width = 312,			

			halign = UIALIGN_CENTER,

			text = "",			
		},

		widget_load =
		{
			skin = UI.skins.BottomMenuButton,
			left = 780 - 180,

			tabstop = 15,

			text = Localize( "LoadMOD" ),

			OnCommand = function( sender )
				-- apply mod changes and restart, if needed

				local tMod=UI.PageMods.GetMod();
				
				if (tMod) then				
					if (tMod.CurrentMod) then
						UI.MessageBox(Localize("ModChange1"), tMod.Title.." @Modalreadyselected");
					else
						UI.YesNoBox( Localize( "ModChange1" ), Localize( "ModChange2" ), UI.PageMods.UpdateYes,UI.PageMods.UpdateNo );
					end
				end
			end,
		},

		description =
		{
			skin = UI.skins.MultilineStatic,
			style = UISTYLE_MULTILINE,

			left = 220, top = 316,
			width = 260, height = 140,			

			tabstop = 2,

			vscrollbar=
			{
				skin = UI.skins.VScrollBar,
			},			

			hscrollbar=
			{
				skin = UI.skins.HScrollBar,
			}
		},
		
		nametext =
		{
			skin = UI.skins.Label,
			left = 515, top = 349,
			width = 312,
			halign = UIALIGN_LEFT,

			text = "",
		},

		versiontext =
		{
			skin = UI.skins.Label,
			left = 515, top = 349+20,
			width = 312,
			halign = UIALIGN_LEFT,

			text = "",
		},

		authortext =
		{
			skin = UI.skins.Label,
			left = 515, top = 349+40,
			width = 312,
			halign = UIALIGN_LEFT,

			text = "",
		},

		websitetext =
		{
			skin = UI.skins.Label,
			left = 515, top = 349+60,
			width = 312,
			halign = UIALIGN_LEFT,

			text = "",
		},

		mods =
		{
			skin = UI.skins.ListView,

			left = 220, top = 149,
			width = 260, height = 159,			

			tabstop = 1,

			vscrollbar=
			{
				skin = UI.skins.VScrollBar,
			},

			OnChanged=function(Sender)
				UI.PageMods.UpdateMods();
			end,
		},

		separator=
		{
			skin = UI.skins.MenuBorder,
			left = 490, top = 141,
			width = 2, height = 317,
			color = "0 0 0 0",
			bordersides = "l",
		},

		thumbnail=
		{
			skin = UI.skins.MenuBorder,

			left = 515, top = 149,
			width = 256, height = 192,
			
			color = "255 255 255 255",
		},

		OnActivate = function(Sender)
			
			UI.PageMods.GUI.mods:Clear();
			UI.PageMods.GUI.description:Clear();

			UI.PageMods.ModsList=Game:GetModsList();
			local modslist=UI.PageMods.ModsList;

			iSelection = 1;

			if (modslist) then
				for i, ModDesc in modslist do
					UI.PageMods.GUI.mods:AddItem(ModDesc.Title.." ("..ModDesc.Name..")");					
					if (ModDesc.CurrentMod) then
						iSelection=i; 
						UI.PageMods.GUI.currentmod:SetText("$8@CurrentMOD : $1"..ModDesc.Title.." ("..ModDesc.Name..")");
					end
				end
			end
			
			UI.PageMods.GUI.mods:SelectIndex(iSelection);			
			UI.PageMods:UpdateMods();

		end,
	},	

	ModsList={},

	SetPicture = function()

		local tMod=UI.PageMods.GetMod();
		
		if (tMod) then

			local szFileName = tMod.Folder.."/ModPreview.dds";
			--System:Log("szFileName = "..szFileName);
		
			local iTexture = System:LoadImage(szFileName);

			if (iTexture) then
				--System:Log(szFileName.."found, loaded");
				UI.PageMods.GUI.thumbnail:SetColor("255 255 255 255");
				UI.PageMods.GUI.thumbnail:SetTexture(iTexture);

				return;
			else
				UI.PageMods.GUI.thumbnail:SetColor("0 0 0 64");
				UI.PageMods.GUI.thumbnail:SetTexture(nil);
			end
		end

		UI.PageMods.GUI.thumbnail:SetColor("0 0 0 64");
		UI.PageMods.GUI.thumbnail:SetTexture(nil);

	end,


	------------------------------------------------------------------------
	GetMod = function()

		local iSelection = UI.PageMods.GUI.mods:GetSelection(0);

		--System:Log("iSelection="..iSelection);

		if (UI.PageMods.ModsList) then
			local tMod=UI.PageMods.ModsList[iSelection];						
			if (tMod) then			
				return (UI.PageMods.ModsList[iSelection]);
			end
		end

		return (nil);
	end,

	------------------------------------------------------------------------
	UpdateMods = function()

		local tMod=UI.PageMods.GetMod();
		
		if (tMod) then

			UI.PageMods:SetPicture();

			UI.PageMods.GUI.nametext:SetText("$8@Title : $1"..tMod.Title.." ("..tMod.Name..")");
			UI.PageMods.GUI.versiontext:SetText("$8@Version : $1"..tMod.Version);
			UI.PageMods.GUI.authortext:SetText("$8@Author : $1"..tMod.Author);
			UI.PageMods.GUI.websitetext:SetText("$8@Website : $1"..tMod.Website);
			UI.PageMods.GUI.description:Clear();
			UI.PageMods.GUI.description:AddLine(tMod.Description);
		end		
	end,

	------------------------------------------------------------------------
	UpdateYes = function()
		System:Log("UpdateYES");
		local tMod=UI.PageMods.GetMod();		
		if (tMod) then		
			Game:LoadMOD(tMod.Name,1);
		end
	end,

	UpdateNo = function()
		System:Log("UpdateNO");
	end,

};

AddUISideMenu(UI.PageMods.GUI,
{
	{ "MainMenu", Localize("MainMenu"), "$MainScreen$", 0},	
});

UI:CreateScreenFromTable("Mods", UI.PageMods.GUI);