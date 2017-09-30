UI.PageDemoLoop=
{	
	GUI=
	{
		Video =
		{
			classname = "videopanel",
			
			left = 0, top = 0,
			width = 800, height = 600,
			
			color = "0 0 0 255",

			zorder = 1000,	
			
			looping = 0,
			keepaspect = 1,
			
			OnMouseMove = function(Sender)
				if ((_time - UI.PageDemoLoop.fStartTime) > UI.fCanSkipTime) then
					UI.PageDemoLoop:Finished();
				end
			end,
			
			OnError = function(Sender, szErrorString)
				Sender:OnFinished();
			end,
			
			OnFinished = function(Sender)
				UI.PageDemoLoop:PlayRandomVideo();
			end
		},
		
		OnUpdate = function(Sender)
			if ((_time - UI.PageDemoLoop.fStartTime) >= UI.fCanSkipTime) then
				local szKeyName = Input:GetXKeyPressedName();
			
				if ((szKeyName == "esc") or (szKeyName == "spacebar") or (szKeyName == "f7")) then
					UI:DeactivateScreen("DemoLoop");
				end
			end
		end,

		OnActivate= function(Sender)
			UI:HideMouseCursor();
			UI:DeactivateAllScreens();
			UI.PageDemoLoop.fStartTime = _time;
			
			UI.PageDemoLoop:PlayRandomVideo();
			UI:EnableSwitch(0);
			UI:PlayMusic();
		end,

		OnDeactivate = function(Sender)
			UI:StopMusic();
			UI:ShowMouseCursor();

			UI.PageDemoLoop.GUI.Video:ReleaseVideo();
			
			if (not UI.bWasIdle) then
				GotoPage("$MainScreen$", 0);
			end
			
			UI.bWasIdle = nil;
		end
	},	

	PlayRandomVideo = function()

		local iVideoCount = getn(UI.VideoList);

		if (iVideoCount and iVideoCount > 0) then
			local iVideo = random(iVideoCount);	
			local szVideo = UI:GetDemoLoopDrive()..UI.szCutSceneFolder.."demoloops/"..UI.VideoList[iVideo];
		
			UI.PageDemoLoop.GUI.Video:LoadVideo(szVideo);
			UI.PageDemoLoop.GUI.Video:SetVolume(tonumber(getglobal("s_SFXVolume")));
				
			if (getglobal("s_SoundEnable") and tonumber(getglobal("s_SoundEnable")) ~= 0) then
				UI.PageDemoLoop.GUI.Video:EnableAudio(1);
			else
				UI.PageDemoLoop.GUI.Video:SetVolume(0);
			end
			
			UI.PageDemoLoop.GUI.Video:Play();
		else
			UI.PageDemoLoop:Finished();
		end
	end,	
};

function UI.PageDemoLoop:Finished()
	GotoPage("$MainScreen$", 0);
end

UI:CreateScreenFromTable("DemoLoop", UI.PageDemoLoop.GUI);