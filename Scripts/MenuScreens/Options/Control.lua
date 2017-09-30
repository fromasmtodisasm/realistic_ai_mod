--
-- control options menu page
--


UI.PageOptionsControl=
{
	KeyOrder=
	{
		MOVEMENT=
		{
			"MoveForward",
			"MoveBackward",
			"MoveLeft",
			"MoveRight",
			"Jump",
			"Crouch",
			"CrouchToggle",
			"Prone",
			"Walk",
			"SprintRun",
			"LeanLeft",
			"LeanRight",
		},
		
		MULTIPLAYER=
		{
			"Chat",
			"TeamChat",
			"ViewScoreboard",
		},

		GAME=
		{
			"Use",
			"HoldBreath",
			"ToggleFlashlight",
			"Binoculars",
			"ThermalVision",
			"TakeScreenshot",
			"SwitchView",
			"Quicksave",
			"Quickload",
		},	

		COMBAT=
		{		
			"Fire",
			"Reload",
			"ToggleFiremode",
			"NextWeapon",
			"PrevWeapon",
			"DropWeapon",
			"CycleGrenade",
			"ThrowGrenade",
			"ToggleZoom",
			"ZoomIn",
			"ZoomOut",
			"ToggleAim",
			"Slot1",
			"Slot2",
			"Slot3",
			"Slot4",
		},
	},

	GUI=
	{	
		-------------------sens-------------
		sensitivitytext=
		{
			skin = UI.skins.Label,
			left = 200, 
			top = 396,--362
			width = 142, 
			height = 28,
			
			text=Localize("MouseSensitivity"),
		},
		
		sensitivity=
		{
			skin = UI.skins.HScrollBar,
			
			left = 390,--350,
			top = 400,--366,
			width = 200,
			
			tabstop = 3,

			OnChanged = function(Sender)
				Input:SetMouseSensitivity(Sender:GetValue()*50.0+5.0);
			end,
		},
		
		invertmousetext=
		{
			skin = UI.skins.Label,
			
			left = 590, 
			top = 364,
			width = 112,
			
			text=Localize("InvertMouse"),
		},

		invertmouse=
		{
			skin = UI.skins.CheckBox,

			left = 710, 
			top = 366,
			
			tabstop = 6,

			OnChanged=function(Sender)
				if (Sender:GetChecked()) then
					Input:SetInvertedMouse(1);
				else
					Input:SetInvertedMouse(0);
				end
			end,
		},
		
		-------------------smooth-------------
		mousesmoothing_text=
		{
			skin = UI.skins.Label,

			left = 200, 
			top = 364,--391,
			width = 142, 
			height = 28,

			text=Localize( "MouseSmoothing" ),
		},

		mousesmoothing=
		{
			left = 390,--350,
			top = 366,--393,
			width = 200,

			skin = UI.skins.ComboBox,

			tabstop = 2,

			OnChanged = function( Sender )
				local curSelection = UI.PageOptionsControl.GUI.mousesmoothing:GetSelectionIndex();
				if( curSelection == 1 ) then
					setglobal( "i_mouse_smooth", "0.0" );
				elseif( curSelection == 2 ) then
					setglobal( "i_mouse_smooth", "0.5" );
				elseif( curSelection == 3 ) then
					setglobal( "i_mouse_smooth", "1.0" );
				end;
			end,
		},
		
		-------------------accel-------------
		mouseacceleration_text =
		{
			skin = UI.skins.Label,
			left = 200, top = 425,
			width = 142, height = 28,

			text = Localize( "MouseAcceleration" ),
		},

		mouseacceleration =
		{
			skin = UI.skins.HScrollBar,

			left = 390,--350,
			top = 429,
			width = 200,

			tabstop = 5,

			OnChanged = function( Sender )
				local accel = tonumber( UI.PageOptionsControl.GUI.mouseacceleration:GetValue() );
				if( accel < 0.01 ) then
					accel = 0.01;
				elseif( accel > 1.0 ) then
					accel = 1.0;
				end;
				setglobal( "i_mouse_accel", accel );
			end,
		},

		mouseacceleration_enable =
		{
			left = 355,--710, 
			top = 429,--429,
			width = 20,
			height = 20,

			skin = UI.skins.CheckBox,

			tabstop = 4,
			OnChanged = function( Sender )
				if( UI.PageOptionsControl.GUI.mouseacceleration_enable:GetChecked() == nil ) then
					UI.PageOptionsControl.GUI.mouseacceleration:SetValue( 0.0 );
					setglobal( "i_mouse_accel", "0.0" );
					UI:DisableWidget( UI.PageOptionsControl.GUI.mouseacceleration );
				else
					UI.PageOptionsControl.GUI.mouseacceleration:SetValue( 0.1 );
					setglobal( "i_mouse_accel", "0.1" );
					UI:EnableWidget( UI.PageOptionsControl.GUI.mouseacceleration );
				end;
			end,
		},
	
		controllist=
		{
			skin = UI.skins.ListView,

			left = 200, top = 140,
			width = 580, height = 219,--259,
			color = "0 0 0 96",
			
			nosort = 1,
			columnselect = 1,
			
			tabstop = 1,

			vscrollbar=
			{
				skin = UI.skins.VScrollBar,
			},

			hscrollbar=
			{
				skin = UI.skins.HScrollBar,
			}
		},
		
		reset=
		{
			skin = UI.skins.BottomMenuButton,
			left = 780-180-178.5,
			
			tabstop = 7,

			text=Localize("RestoreDefaults"),

			OnCommand=function(Sender)
				UI.YesNoBox(Localize("ResetToDefault"), Localize("GenericAreYouSure"), UI.PageOptionsControl.ResetToDefaults);
			end,
		},

		change=
		{
			skin = UI.skins.BottomMenuButton,
			left = 780-180,
			
			tabstop = 8,
			
			text=Localize("ChangeCtrlBind"),
			
			OnCommand=function(Sender)
				if UI.PageOptionsControl.GUI.controllist:GetSelectionCount()==1 then -- something selected ???
					local index=UI.PageOptionsControl.GUI.controllist:GetSelection(0);
					local Action = UI.PageOptionsControl.Actions[index];
					local iNumber = UI.PageOptionsControl.GUI.controllist:GetSelectedColumn()-1;
					if (Action.configurable) then
						UI.PageWaitForKey:SetLabel(Action, iNumber);
						UI:ActivateScreen("BindWaitForKey");
					end
				end
			end,
		},
			
		OnActivate= function(Sender)			
			local inv=0;
			if Input:GetInvertedMouse() then
				inv=1;
			end
			
			-- invert mouse
			UI.PageOptionsControl.GUI.invertmouse:SetChecked(inv);

			-- controls
			UI.PageOptionsControl.GUI.controllist:ClearColumns();
			UI.PageOptionsControl.GUI.controllist:Clear();
			UI.PageOptionsControl.GUI.controllist.OnCommand=UI.PageOptionsControl.GUI.change.OnCommand;

			UI.PageOptionsControl.GUI.controllist:AddColumn(Localize("CtrlActionName"), 270, UIALIGN_RIGHT, UI.szListViewOddColor, "0 0 0 0", nil, nil, 0, 0);
			UI.PageOptionsControl.GUI.controllist:AddColumn(Localize("CtrlActionBinding1"), 144, UIALIGN_CENTER, UI.szListViewEvenColor, "0 0 0 12");
			UI.PageOptionsControl.GUI.controllist:AddColumn(Localize("CtrlActionBinding2"), 144, UIALIGN_CENTER, UI.szListViewOddColor, "0 0 0 0");

			UI.PageOptionsControl.FillBindList();

			-- sensitivity
			UI.PageOptionsControl.GUI.sensitivity:SetValue((Input:GetMouseSensitivity()-5.0)/50.0);
			
			-----------------------------------------------------------------

			UI.PageOptionsControl.GUI.mousesmoothing:Clear();
			UI.PageOptionsControl.GUI.mousesmoothing:AddItem( Localize( "None" ) );
			UI.PageOptionsControl.GUI.mousesmoothing:AddItem( Localize( "Fast" ) );
			UI.PageOptionsControl.GUI.mousesmoothing:AddItem( Localize( "Default" ) );

			local cur_i_mouse_smooth = tonumber( getglobal( "i_mouse_smooth" ) );
			if( cur_i_mouse_smooth == 0.5 ) then
				UI.PageOptionsControl.GUI.mousesmoothing:SelectIndex( 2 );
			elseif( cur_i_mouse_smooth == 1.0 ) then
				UI.PageOptionsControl.GUI.mousesmoothing:SelectIndex( 3 );
			else
				UI.PageOptionsControl.GUI.mousesmoothing:SelectIndex( 1 );
			end;

			-----------------------------------------------------------------

			local cur_i_mouse_accel = tonumber( getglobal( "i_mouse_accel" ) );
			UI.PageOptionsControl.GUI.mouseacceleration:SetValue( cur_i_mouse_accel );
			if( cur_i_mouse_accel == 0.0 ) then
				UI.PageOptionsControl.GUI.mouseacceleration_enable:SetChecked( 0 );
				UI:DisableWidget( UI.PageOptionsControl.GUI.mouseacceleration );
			else
				UI.PageOptionsControl.GUI.mouseacceleration_enable:SetChecked( 1 );
				UI:EnableWidget( UI.PageOptionsControl.GUI.mouseacceleration );
			end;

--	ControlSettingsPage.WarningText=self:CreateStatic(150, 570, 650, 20, 0, "");
			
		end,
	},

	------------------------------------------------------------------------

	Actions=nil,			-- 
}

function UI.PageOptionsControl:LoadConfig(lang)
	local szFileName = "profiles/defaults/"..lang.."/game.cfg";

	-- check if file exists
	local hfile = openfile(szFileName, "r");

	if (hfile) then
		closefile(hfile);
	
		Input:ResetAllBindings();
		
		Game:LoadConfigurationEx("", szFileName);
		return 1;
	end
	
	return nil;	
end

function UI.PageOptionsControl:AddBind(Action)
	if ((not Action) or (not Action.actionmaps[1])) then
		return nil
	end
	
	local Binding = Input:GetBinding(Action.actionmaps[1], Action.id);
	local b1="";
	local b2="";
	
	if (Binding[1]) then
		if (Binding[1].mod) then
			b1="@control"..Binding[1].mod_id.." + ".."@control"..Binding[1].key_id;
		else
			b1="@control"..Binding[1].key_id;
		end
	end
	
	if (Binding[2]) then
		if (Binding[2].mod) then
			b2="@control"..Binding[2].mod_id.." + ".."@control"..Binding[2].key_id;
		else
			b2="@control"..Binding[2].key_id;
		end
	end
	
	return UI.PageOptionsControl.GUI.controllist:AddItem(Action.desc, b1, b2);
end

-------------------------------------------------------------------------
function UI.PageOptionsControl.FillBindList()
	
	UI.PageOptionsControl.GUI.controllist:Clear();
	UI.PageOptionsControl.Actions={};

	local ActionList = Game:GetActions();
	local ActionMap = {};

	for i, Action in ActionList do
		if (Action.configurable and Action.configurable ~= 0) then
			if (not ActionMap[Action.type]) then
				ActionMap[Action.type] = {};
			end

			tinsert(ActionMap[Action.type], Action);
			ActionMap[Action.type].n = nil;
		end
	end

	for szType, Map in ActionMap do
	
		local szTypeTitle = "@CONTROLS_"..strupper(szType);
		local MapOrder = UI.PageOptionsControl.KeyOrder[strupper(szType)];
		
		UI.PageOptionsControl.GUI.controllist:AddItem(szTypeTitle);
	
		for i, szActionName in MapOrder do
			for j, Action in Map do
						
				-- find the key in the list of keys with this szType
				if (strlower(strsub(Action.desc, 2)) == strlower(szActionName)) or
					(strlower(strsub(Action.desc, 1)) == strlower(szActionName)) then
					local iIndex = UI.PageOptionsControl:AddBind(Action);
	
					if (iIndex) then
						UI.PageOptionsControl.Actions[iIndex] = Action;	
						break;
					end
				end
			end			
		end
	end
end


-------------------------------------------------------------------------
function UI.PageOptionsControl.ResetToDefaults()
	Input:ResetAllBindings();
	
	UI.PageOptionsControl.GUI.invertmouse:SetChecked(0);
	UI.PageOptionsControl.GUI.sensitivity:SetValue(0.35);
	UI.PageOptionsControl.GUI.mousesmoothing:SelectIndex( 1 );
	UI.PageOptionsControl.GUI.mouseacceleration_enable:SetChecked( 0 );
	
	if (getglobal("g_language") and strlen(getglobal("g_language")) > 0) then
		if (not UI.PageOptionsControl:LoadConfig(getglobal("g_language"))) then
			UI.PageOptionsControl:LoadConfig("english");
		end
	end

	-- update widgets
	UI.PageOptionsControl.GUI.sensitivity:OnChanged(UI.PageOptionsControl.GUI.sensitivity);
	UI.PageOptionsControl.GUI.invertmouse:OnChanged(UI.PageOptionsControl.GUI.invertmouse);			
	UI.PageOptionsControl.GUI.mousesmoothing:OnChanged(UI.PageOptionsControl.GUI.mousesmoothing);
	UI.PageOptionsControl.GUI.mouseacceleration:OnChanged(UI.PageOptionsControl.GUI.mouseacceleration);
	UI.PageOptionsControl.GUI.mouseacceleration_enable:OnChanged(UI.PageOptionsControl.GUI.mouseacceleration_enable);
	
	UI.PageOptionsControl.FillBindList();	
end


UI:CreateScreenFromTable("ControlOptions",UI.PageOptionsControl.GUI);