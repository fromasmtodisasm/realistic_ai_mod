UI.PageBackScreen=
{
	GUI=
	{
		StaticImage=
		{
			classname = "static",
			left = 0, top = 0,
			width = 800, height = 600,

			zorder = -109,
			bordersize = 0,

			texture = System:LoadImage("textures/gui/menubackground"),
			texrect = "0, 0, 1024, 1024",
		},

		Video=
		{
			classname = "videopanel",

			left = 0, top = 0,
			width = 800, height = 600,

			color = "0 0 0 255",

			zorder = -110,

			looping = 1,
			keepaspect = 1,

			OnError = function(Sender, szError)
				Sender:OnFinished();
			end,

			OnFinished = function(Sender)
				UI.PageBackScreen:PlayRandomVideo();
			end,
		},

		Header=
		{
			zorder = -99,
			skin = UI.skins.MenuHeader,
		},
		Right=
		{
			zorder = 100,
			skin = UI.skins.MenuRight,
		},
		Version=
		{
			classname = "static",

			left = 574, top = 2,
			width = 220, height = 18,

			color = "0 0 0 0",
			bordersize = 0,

			fontsize = 14,
			fontcolor = "255 255 255 255",

			halign = UIALIGN_RIGHT,

			text = "v"..Game:GetVersion("%d.%d%d © 2004 Crytek, All Rights Reserved");
		},

		Left=
		{
			zorder = -99,
			skin = UI.skins.MenuLeft,
		},


		Footer=
		{
			zorder = -100,
			skin = UI.skins.MenuFooter,

			Ad =
			{
				skin = UI.skins.FooterAd,

				OnCommand = function(Sender)
					if (UI.PageBackScreen.AdCfg.target) then
						System:BrowseURL(UI.PageBackScreen.AdCfg.target);
					end
				end,
			},
		},

		BackStatic=
		{
			zorder = -99,
			skin = UI.skins.BackStatic,

			BackStaticTop=
			{
				left = 0, top = 24,
				height = 8, width = UI.skins.BackStatic.width,

				skin = UI.skins.MenuBorder,
			},

			BackStaticBottom=
			{
				left = 0, top = UI.skins.BackStatic.height - 8 - 24,
				height = 8, width = UI.skins.BackStatic.width,

				skin = UI.skins.MenuBorder,
			},

		},

		OnInit = function (Sender)
			UI.PageBackScreen.AdCfg = ReadTableFromFile(UI.szBannerCfgPath);

			local AdCfg = UI.PageBackScreen.AdCfg;
			local Ad = Sender.Footer.Ad;

			if (AdCfg == nil) then
				return;
			end

			if (AdCfg.rect) then
				Ad:SetRect(AdCfg.rect);
			end

			if ((AdCfg.left) and (AdCfg.top) and (AdCfg.width) and (AdCfg.height)) then
				Ad:SetRect(AdCfg.left..","..AdCfg.top..","..AdCfg.width..","..AdCfg.height);
			end

			if (AdCfg.path) then

				printf("LOADING %s", AdCfg.path);

				local iTexture = System:LoadImage(AdCfg.path);

				if (iTexture) then
					Ad:SetTexture(iTexture);

					UI:ShowWidget(Ad);
					UI:EnableWidget(Ad);
				else
					UI:HideWidget(Ad);
					UI:DisableWidget(Ad);
				end
			end
		end,

		OnActivate = function(Sender)

			UI:ShowMouseCursor();

			UI:PlayMusic();

			UI.PageBackScreen:PlayRandomVideo();

			local syspec = tonumber(getglobal("sys_spec"));
			local firstLaunch = tonumber(getglobal( "sys_firstlaunch" ));
			local bkvideo = 0;

			--if its lowspec, and we are at first launch, set "ui_BackGroundVideo" to 0 = no video background.
			if (firstLaunch == 1 and syspec == 0) then
				setglobal( "ui_BackGroundVideo", bkvideo );
			else
				bkvideo = tonumber(getglobal("ui_BackGroundVideo"));
			end

			--adjust cl_weapon_fx if first time;
			if (firstLaunch == 1) then

				if (syspec==0) then
					setglobal( "cl_weapon_fx", 0 );
				else
					setglobal( "cl_weapon_fx", 2 );
				end
			end

			if (bkvideo==0) then
				UI:HideWidget(UI.PageBackScreen.GUI.Video);
				UI:ShowWidget(UI.PageBackScreen.GUI.StaticImage);
			else
				UI:HideWidget(UI.PageBackScreen.GUI.StaticImage);
				UI:ShowWidget(UI.PageBackScreen.GUI.Video);
			end
		end,

		OnDeactivate = function(Sender)
			UI:StopMusic();
			Sender.Video:ReleaseVideo();
		end,
	},

	PlayRandomVideo = function()

		local iVideoCount = getn(UI.VideoList);

		if (iVideoCount and iVideoCount > 0) then
			local iVideo = random(iVideoCount);
			local szVideo = UI:GetDemoLoopDrive()..UI.szCutSceneFolder.."demoloops/"..UI.VideoList[iVideo];

			UI.PageBackScreen.GUI.Video:LoadVideo(szVideo, 0);
			UI.PageBackScreen.GUI.Video:SetVolume(tonumber(getglobal("s_SFXVolume")));

			if (getglobal("s_SoundEnable") and tonumber(getglobal("s_SoundEnable")) ~= 0) then
				UI.PageBackScreen.GUI.Video:EnableAudio(1);
			else
				UI.PageBackScreen.GUI.Video:SetVolume(0);
			end

			UI.PageBackScreen.GUI.Video:Play();
		else
			setglobal("ui_BackGroundVideo", 0);
			UI:HideWidget(UI.PageBackScreen.GUI.Video);
			UI:ShowWidget(UI.PageBackScreen.GUI.StaticImage);
		end
	end,

	AdCfg={},
}

UI:CreateScreenFromTable("BackScreen", UI.PageBackScreen.GUI);