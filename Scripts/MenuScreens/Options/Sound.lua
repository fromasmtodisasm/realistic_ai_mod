----------------------------------------------------------------------------------------------

UI.PageOptionsSound=
{
	SpeakerConfigIndex = {},
	SampleRateIndex = {},
	GUI=
	{
		reset=
		{
			skin = UI.skins.BottomMenuButton,
			left = 780-180-178.5,

			tabstop = 10,

			text=Localize("RestoreDefaults"),

			OnCommand=function(Sender)
				UI.YesNoBox(Localize("ResetToDefault"), Localize("GenericAreYouSure"), UI.PageOptionsSound.ResetToDefaults);
			end,
		},

		apply=
		{
			skin = UI.skins.BottomMenuButton,
			left = 780-180,

			text=Localize("Apply"),

			tabstop = 9,

			OnCommand = function(Sender)

				-- test relaunch conditions
				local bRelaunch = 0;

				local HWMix = UI.PageOptionsSound.GUI.hwmix;
				if( HWMix:GetChecked() ) then
					if( tonumber( getglobal( "s_MaxHWChannels" ) ) ~= 28 ) then
						bRelaunch = 1;
					end
				else
					if( tonumber( getglobal( "s_MaxHWChannels" ) ) ~= 0 ) then
						bRelaunch = 1;
					end
				end

				local ComMode = UI.PageOptionsSound.GUI.compatiblemode;
				if( ComMode:GetChecked() ) then
					if( tonumber( getglobal( "s_CompatibleMode" ) ) ~= 1 ) then
						bRelaunch = 1;
					end
				else
					if( tonumber( getglobal( "s_CompatibleMode" ) ) ~= 0 ) then
						bRelaunch = 1;
					end
				end
				
				local SpeakerSetup = UI.PageOptionsSound.SpeakerConfigIndex[UI.PageOptionsSound.GUI.speakersetup:GetSelectionIndex()];

				if (tonumber(getglobal("s_SpeakerConfig")) ~= tonumber(SpeakerSetup)) then
					bRelaunch = 1;
				end

				UI.PageOptionsSound:ApplySettings();
				
				-- apply settings
				if( bRelaunch ~= 0 ) then
					UI.MessageBox( Localize( "SoundOptions" ), Localize( "AdvChangeMess2" ));
				end
			end,
		},

		soundfxvolumetext=
		{
			skin = UI.skins.Label,
			left = 200, top = 176,
			width = 112,

			text=Localize("SoundVolume"),
		},

		soundfxvolume=
		{
			skin = UI.skins.HScrollBar,

			left = 320, top = 176,
			width = 322, height = 24,

			tabstop = 1,

			user =
			{
				soundSfxCue = Sound:LoadSound( "Sounds/Menu/Click.wav",SOUND_UNSCALABLE),
			},

			OnChanged = function( Sender )
				setglobal( "s_SFXVolume", Sender:GetValue() );	-- 0..1
				local sound = UI.PageOptionsSound.GUI.soundfxvolume.user.soundSfxCue;
				if( sound ~= nil ) then
					Sound:SetSoundVolume( sound, getglobal( "s_SFXVolume" ) * 255.0 );
					Sound:SetSoundLoop( sound, 0 );
					Sound:PlaySound( sound );
				end;
			end,
		},

		musicvolumetext=
		{
			skin = UI.skins.Label,
			left = 200, top = 224,
			width = 112,

			text=Localize("MusicVolume"),
		},
		musicvolume=
		{
			skin = UI.skins.HScrollBar,

			left = 320, top = 224,
			width = 322, height = 24,

			tabstop = 2,

			OnChanged = function(Sender)
				setglobal("s_MusicVolume", Sender:GetValue());	-- 0..1
				Sound:SetSoundVolume(UI.MusicId, Sender:GetValue() * 255.0);
			end,
		},

		speakersetuptext=
		{
			skin = UI.skins.Label,

			left = 355, top = 262,
			width = 112,

			text=Localize("SpeakerConfig"),
		},

		speakersetup=
		{
			skin = UI.skins.ComboBox,

			left = 475, top = 262,

			tabstop = 3,
		},

		checkboxstatic=
		{
			skin = UI.skins.MenuBorder,

			left = 200, top = 300,
			width = 580, height = 159,
			bordersides="t",

			zorder = -50,
		},

		dopplertext=
		{
			skin = UI.skins.Label,
			left = 142, top = 314,
			width = 312,

			text=Localize("Doppler"),
		},
		doppler=
		{
			left = 460, top = 314,

			tabstop = 4,

			skin = UI.skins.CheckBox,
		},

		hwmixtext=
		{
			skin = UI.skins.Label,
			left = 142, top = 350,
			width = 312,

			text=Localize("HardwareMixing"),
		},

		hwmix=
		{
			left = 460, top = 350,

			tabstop = 5,

			skin = UI.skins.CheckBox,

			OnChanged = function(Sender)
				if (Sender:GetChecked()) then
					UI:EnableWidget("eax", "SoundOptions");
					UI.PageOptionsSound.GUI.eax:SetChecked(1);
				else
					UI:DisableWidget("eax", "SoundOptions");
					UI.PageOptionsSound.GUI.eax:SetChecked(0);
				end
			end
		},

		eaxtext=
		{
			skin = UI.skins.Label,
			left = 142, top = 386,
			width = 312,

			text=Localize("EnableEAX"),
		},

		eax=
		{
			left = 460, top = 386,

			tabstop = 6,

			skin = UI.skins.CheckBox,
		},

		compatiblemodetext=
		{
			skin = UI.skins.Label,
			left = 142, top = 422,
			width = 312,

			--text=("Compatible mode (needs restart) \n Enable in case of playback issues"),
			text=Localize("SoundCompatibleMode"),
		},

		compatiblemode=
		{
			left = 460, top = 422,

			tabstop = 11,

			skin = UI.skins.CheckBox,
		},

		musictext=
		{
			skin = UI.skins.Label,
			left = 492, top = 314,
			width = 112,

			text=Localize("EnableMusic"),
		},

		music=
		{
			left = 612, top = 314,

			tabstop = 7,

			skin = UI.skins.CheckBox,

			OnChanged=function(Sender)
				if (Sender:GetChecked()) then
					UI:EnableWidget( UI.PageOptionsSound.GUI.musicquality );
				else
					UI:DisableWidget( UI.PageOptionsSound.GUI.musicquality );
				end
			end,
		},

		musicqualitytext =
		{
			skin = UI.skins.Label,
			left = 492, top = 350,
			width = 112,

			text = Localize( "MusicQuality" ),
		},

		musicquality =
		{
			left = 612, top = 350,
			width = 160,

			tabstop = 8,

			skin = UI.skins.ComboBox,

			OnChanged = function( Sender )
				local selIndex = UI.PageOptionsSound.GUI.musicquality:GetSelectionIndex();
				if( selIndex == 4 ) then
					local musicQuality = Localize( "Low" );
					local cpuQuality = tonumber( System:GetCPUQuality() );
					selIndex = 1;
					if( cpuQuality == 1 ) then
						selIndex = 2;
						musicQuality = Localize( "Medium" );
					elseif( cpuQuality >= 2 ) then
						selIndex = 3;
						musicQuality = Localize( "High" );
					end;
					UI.MessageBox( Localize( "SoundOptions" ), Localize( "MusicQualitySetT" ).." : "..musicQuality );
					UI.PageOptionsSound.GUI.musicquality:SelectIndex( selIndex );
				end
			end,
		},

		OnActivate= function(Sender)
			UI.PageOptionsSound.GUI.doppler:SetChecked(getglobal("s_DopplerEnable"));
			UI.PageOptionsSound.GUI.music:SetChecked(getglobal("s_MusicEnable"));

			UI.PageOptionsSound.GUI.soundfxvolume:SetValue(getglobal("s_SFXVolume"));
			UI.PageOptionsSound.GUI.musicvolume:SetValue(getglobal("s_MusicVolume"));

			UI.PageOptionsSound.SampleRateIndex = {};
			local SRI = UI.PageOptionsSound.SampleRateIndex;

			if (getglobal("s_MaxHWChannels") and tonumber(getglobal("s_MaxHWChannels")) ~= 0) then
				UI.PageOptionsSound.GUI.hwmix:SetChecked(1);
				UI:EnableWidget("eax", "SoundOptions");

				if (tostring(getglobal("s_EnableSoundFX")) ~= "0") then
					UI.PageOptionsSound.GUI.eax:SetChecked(1);
				end
			else
				UI.PageOptionsSound.GUI.hwmix:SetChecked(0);
				UI.PageOptionsSound.GUI.eax:SetChecked(0);
				UI:DisableWidget("eax", "SoundOptions");
			end

			UI.PageOptionsSound.SpeakerConfigIndex = {};
			local SCI = UI.PageOptionsSound.SpeakerConfigIndex;

			UI.PageOptionsSound.GUI.speakersetup:Clear();
			SCI[UI.PageOptionsSound.GUI.speakersetup:AddItem(Localize("Mono"))] = 3;
			SCI[UI.PageOptionsSound.GUI.speakersetup:AddItem(Localize("Stereo"))] = 5;
			SCI[UI.PageOptionsSound.GUI.speakersetup:AddItem(Localize("Headphones"))] = 2;
			SCI[UI.PageOptionsSound.GUI.speakersetup:AddItem(Localize("Quadrophonic"))] = 4;
			SCI[UI.PageOptionsSound.GUI.speakersetup:AddItem(Localize("Surround"))] = 6;
			SCI[UI.PageOptionsSound.GUI.speakersetup:AddItem(Localize("5_1"))] = 1;
			
			for i=1,6 do
				if (tonumber(getglobal("s_SpeakerConfig")) == tonumber(SCI[i])) then
					UI.PageOptionsSound.GUI.speakersetup:SelectIndex(i);
				end
			end

			UI.PageOptionsSound.GUI.compatiblemode:SetChecked( getglobal( "s_CompatibleMode" ) );

			-- init music quality widget
			UI.PageOptionsSound.GUI.musicquality:Clear();
			UI.PageOptionsSound.GUI.musicquality:AddItem( Localize( "Low" ) );
			UI.PageOptionsSound.GUI.musicquality:AddItem( Localize( "Medium" ) );
			UI.PageOptionsSound.GUI.musicquality:AddItem( Localize( "High" ) );
			UI.PageOptionsSound.GUI.musicquality:AddItem( Localize( "AutoDetect" ) );
			if( tonumber( getglobal( "s_MusicEnable" ) ) == 0 ) then
				UI:DisableWidget( UI.PageOptionsSound.GUI.musicquality );
			end
			local maxPatterns = tonumber( getglobal( "s_MusicMaxPatterns" ) );
			if( maxPatterns == 0 ) then
				UI.PageOptionsSound.GUI.musicquality:SelectIndex( 1 ); -- low music quality
			else
				local streamedData = tonumber( getglobal( "s_MusicStreamedData" ) );
				if( streamedData == 0 ) then
					UI.PageOptionsSound.GUI.musicquality:SelectIndex( 2 ); -- medium music quality
				else
					UI.PageOptionsSound.GUI.musicquality:SelectIndex( 3 ); -- high music quality
				end
			end
		end,
	},

	RefreshPage = function( self )
		GotoPage( "Options" );
		UI.PageOptions.GUI.VideoOptions.OnCommand( UI.PageOptions.GUI.SoundOptions );
	end,

	ApplySettings = function( self )
		local SpeakerSetup = UI.PageOptionsSound.GUI.speakersetup;
		local SCI = UI.PageOptionsSound.SpeakerConfigIndex[SpeakerSetup:GetSelectionIndex()];

		if (SCI) then
			setglobal("s_SpeakerConfig", tonumber(SCI));
		else
			setglobal("s_SpeakerConfig", 5);
		end

		local Doppler = UI.PageOptionsSound.GUI.doppler;
		if (Doppler:GetChecked()) then
			setglobal("s_DopplerEnable", 1);
		else
			setglobal("s_DopplerEnable", 0);
		end

		local HWMix = UI.PageOptionsSound.GUI.hwmix;
		if (HWMix:GetChecked()) then
			setglobal("s_MaxHWChannels", 28);
			UI:EnableWidget("eax", "SoundOptions");
		else
			setglobal("s_MaxHWChannels", 0);
			UI.PageOptionsSound.GUI.eax:SetChecked(0);
		end

		local EAX = UI.PageOptionsSound.GUI.eax;
		if (EAX:GetChecked()) then
			setglobal("s_EnableSoundFX", 1);
		else
			setglobal("s_EnableSoundFX", 0);
		end

		local ComMode = UI.PageOptionsSound.GUI.compatiblemode;
		if (ComMode:GetChecked()) then
			setglobal("s_CompatibleMode", 1);
		else
			setglobal("s_CompatibleMode", 0);
		end

		local Music = UI.PageOptionsSound.GUI.music;
		if (Music:GetChecked()) then
			setglobal("s_MusicEnable", 1);
			Sound:PlaySound(UI.MusicId);
		else
			Sound:StopSound(UI.MusicId);
			setglobal("s_MusicEnable", 0);
		end

		local MusicQuality = UI.PageOptionsSound.GUI.musicquality;
		local selIndex = MusicQuality:GetSelectionIndex();
		if( selIndex == 1 ) then
			setglobal( "s_MusicMaxPatterns", 0 );  -- low music quality
			setglobal( "s_MusicStreamedData", 0 );
		elseif( selIndex == 2) then
			setglobal( "s_MusicMaxPatterns", 12 ); -- medium music quality
			setglobal( "s_MusicStreamedData", 0 );
		elseif( selIndex == 3 ) then
			setglobal( "s_MusicMaxPatterns", 12 ); -- high music quality
			setglobal( "s_MusicStreamedData", 1 );
		end
	end,
}

-------------------------------------------------------------------------
function UI.PageOptionsSound.ResetToDefaults()
	UI.PageOptionsSound.GUI.musicvolume:SetValue(0.6);
	UI.PageOptionsSound.GUI.soundfxvolume:SetValue(1.0);
	UI.PageOptionsSound.GUI.speakersetup:SelectIndex(2);
	UI.PageOptionsSound.GUI.doppler:SetChecked(0);
	UI.PageOptionsSound.GUI.hwmix:SetChecked(1);
	UI.PageOptionsSound.GUI.eax:SetChecked(1);
	UI.PageOptionsSound.GUI.music:SetChecked(1);
	UI.PageOptionsSound.GUI.musicquality:SelectIndex(2);
	UI.PageOptionsSound.GUI.speakersetup:SelectIndex(2);
	UI.PageOptionsSound.GUI.compatiblemode:SetChecked(0);

	UI.PageOptionsSound.GUI.musicvolume:OnChanged(UI.PageOptionsSound.GUI.musicvolume);
	UI.PageOptionsSound.GUI.soundfxvolume:OnChanged(UI.PageOptionsSound.GUI.soundfxvolume);
	UI.PageOptionsSound.GUI.hwmix:OnChanged(UI.PageOptionsSound.GUI.hwmix);
	UI.PageOptionsSound.GUI.music:OnChanged(UI.PageOptionsSound.GUI.music);
	UI.PageOptionsSound.GUI.musicquality:OnChanged(UI.PageOptionsSound.GUI.musicquality);
end


UI:CreateScreenFromTable("SoundOptions",UI.PageOptionsSound.GUI);
