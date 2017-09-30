UI.PageOptionsMod=
{
	GUI=
	{
		reset=
		{
			skin = UI.skins.BottomMenuButton,
			left = 780-180,

			tabstop = 9,

			text=Localize("RestoreDefaults"),

			OnCommand=function(Sender)
				UI.YesNoBox(Localize("ResetToDefault"),Localize("GenericAreYouSure"),UI.PageOptionsMod.ResetToDefaults)
			end,
		},

		widget_back =
		{
			left = 208,top = 142 + 318 - 34,
			width = 160,
			skin = UI.skins.BottomMenuButton,
			bordersides = "lrtb",

			text = Localize("BasicVIdOptions"),

			tabstop = 1,

			OnCommand = function(Sender)
				GotoPage("Options")
			end,
		},
		
		-- damagemultipliertext=
		-- {
			-- skin = UI.skins.Label,

			-- left = 200,top = 149,
			-- width = 112,

			-- -- text=Localize("DamageMultiplier"),
			-- text=Localize("RealisticDamage"),
		-- },

		-- damagemultiplier =
		-- {
			-- skin = UI.skins.HScrollBar,

			-- left = 320,top = 149,
			-- width = 162,height = 24,

			-- tabstop = 2,

			-- OnChanged = function(sender)
				-- local newValue = tonumber(UI.PageOptionsMod.GUI.damagemultiplier:GetValue())
				-- if newValue < .1 then
					-- newValue = .1
				-- elseif newValue > 1 then
					-- newValue = 1
				-- end
				-- setglobal("game_DamageMultiplier",newValue)
			-- end,
		-- },
		
		-- damagemultiplier=
		-- {
			-- left = 320,top = 149,
			-- width = 28,height = 28,

			-- skin = UI.skins.CheckBox,

			-- tabstop = 2,

			-- OnChanged=function(Sender)
				-- if (Sender:GetChecked()) then
					-- setglobal("game_DamageMultiplier",1)
				-- else
					-- setglobal("game_DamageMultiplier",.4)
				-- end
			-- end,
		-- },

		subtitlestext=
		{
			skin = UI.skins.Label,

			left = 200,top = 184,
			width = 112,

			text=Localize("Subtitles"),
		},

		subtitles=
		{
			left = 320,top = 184,
			width = 28,height = 28,

			skin = UI.skins.CheckBox,

			tabstop = 3,

			OnChanged=function(Sender)
				if (Sender:GetChecked()) then
					setglobal("game_subtitles2",1) -- Точная копия первой, просто чтобы название было другое и при игре вне мода субтитры не включались бы.
				else
					setglobal("game_subtitles2",0)
				end
			end,
		},

		realisticcameratext=
		{
			skin = UI.skins.Label,

			left = 200,top = 219,
			width = 112,

			text=Localize("EnableHeadCamera"),
		},

		realisticcamera=
		{
			left = 320,top = 219,
			width = 28,height = 28,

			skin = UI.skins.CheckBox,

			tabstop = 4,

			OnChanged=function(Sender)
				if (Sender:GetChecked()) then
					setglobal("p_head_camera2",1) -- Тоже, что и с субтитрами, но работать тогда вообще криво будет.
				else
					setglobal("p_head_camera2",0)
				end
			end,
		},

		newshootingmodetext=
		{
			skin = UI.skins.Label,

			left = 200,top = 254,
			width = 112,

			text=Localize("PhysicsBullets"),
		},

		newshootingmode=
		{
			left = 320,top = 254,
			width = 28,height = 28,

			skin = UI.skins.CheckBox,

			tabstop = 5,

			OnChanged=function(Sender)
				if (Sender:GetChecked()) then
					setglobal("game_NewShootingMode",1)
				else
					setglobal("game_NewShootingMode",0)
				end
			end,
		},

		createassistanttext=
		{
			skin = UI.skins.Label,

			left = 200,top = 289,
			width = 112,

			text=Localize("CreateAssistant"),
		},

		createassistant=
		{
			left = 320,top = 289,
			width = 28,height = 28,

			skin = UI.skins.CheckBox,

			tabstop = 6,

			OnChanged=function(Sender)
				if (Sender:GetChecked()) then
					setglobal("game_CreateAssistant",1)
				else
					setglobal("game_CreateAssistant",0)
				end
			end,
		},

		predatorsmaybeinvisibletext=
		{
			skin = UI.skins.Label,

			left = 200,top = 324,
			width = 112,

			text=Localize("PredatorsMayBeInvisible"),
		},

		predatorsmaybeinvisible=
		{
			left = 320,top = 324,
			width = 28,height = 28,

			skin = UI.skins.CheckBox,

			tabstop = 7,

			OnChanged=function(Sender)
				if (Sender:GetChecked()) then
					setglobal("game_PredatorsMayBeInvisible",1)
				else
					setglobal("game_PredatorsMayBeInvisible",0)
				end
			end,
		},
		
		aiplayertext=
		{
			skin = UI.skins.Label,

			left = 200,top = 149, -- 359
			width = 112,

			text=Localize("AIPlayer"),
		},

		aiplayer=
		{
			left = 320,top = 149,
			width = 28,height = 28,

			skin = UI.skins.CheckBox,

			tabstop = 2, -- 8

			OnChanged=function(Sender)
				if (Sender:GetChecked()) then
					setglobal("AIPlayer",1)
				else
					setglobal("AIPlayer",0)
				end
			end,
		},

		OnActivate = function(Sender)
			UI.PageOptionsMod.GUI.subtitles:SetChecked(tonumber(getglobal("game_subtitles2")))
			UI.PageOptionsMod.GUI.realisticcamera:SetChecked(tonumber(getglobal("p_head_camera2")))
			UI.PageOptionsMod.GUI.newshootingmode:SetChecked(tonumber(getglobal("game_NewShootingMode")))
			UI.PageOptionsMod.GUI.createassistant:SetChecked(tonumber(getglobal("game_CreateAssistant")))
			UI.PageOptionsMod.GUI.predatorsmaybeinvisible:SetChecked(tonumber(getglobal("game_PredatorsMayBeInvisible")))
			UI.PageOptionsMod.GUI.aiplayer:SetChecked(tonumber(getglobal("AIPlayer")))
			-- UI.PageOptionsMod.GUI.damagemultiplier:SetValue(getglobal("game_DamageMultiplier"))
			-- local DamageMultiplier = tonumber(getglobal("game_DamageMultiplier"))
			-- if DamageMultiplier==1 then
				-- UI.PageOptionsMod.GUI.damagemultiplier:SetChecked(1)
			-- else
				-- UI.PageOptionsMod.GUI.damagemultiplier:SetChecked(0)
			-- end
		end,

		-- OnDeactivate = function(Sender)
		-- end
	},

	ResetToDefaults=function()
		local NewShootingMode = tonumber(getglobal("game_NewShootingMode"))
		if NewShootingMode then -- А то вдруг CryGame стандартный.
			setglobal("game_subtitles2",1)
			setglobal("p_head_camera2",0)
			setglobal("game_NewShootingMode",0)
			setglobal("game_CreateAssistant",0)
			setglobal("game_PredatorsMayBeInvisible",1)
			-- setglobal("game_DamageMultiplier",1)
		end
		UI.PageOptionsMod.GUI:OnActivate()
	end,
}

AddUISideMenu(UI.PageOptionsMod.GUI,
{
	{"MainMenu",Localize("MainMenu"),"$MainScreen$",0},
})

UI:CreateScreenFromTable("ModOptions",UI.PageOptionsMod.GUI)