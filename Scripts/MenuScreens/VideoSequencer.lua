VideoSequencer={};

function VideoSequencer:Play(VideoList, pfnEndProc)
	if (VideoList) then
		VideoSequencer.VideoList = VideoList;
	end

	UI:EnableSwitch(0, 0);

	VideoSequencer.pfnEndProc = pfnEndProc;
	VideoSequencer.iCurrentVideo = 1;
	VideoSequencer:PlayVideo(VideoSequencer.iCurrentVideo);
	
	UI:StopMusic();
end

function VideoSequencer:Stop()
	VideoSequencer:OnSequenceFinished();
end

function VideoSequencer:PlayVideo(iVideo)
	local Video = VideoSequencer.VideoList[iVideo];

	if (not Video) then
		VideoSequencer:OnSequenceFinished();

		return;
	end

	local szVideoName = Video[1];
	local iCanSkip = Video[2];
	local iImage = Video[3];
	local iImageDuration = Video[4];
	
	if (iImage and iImage ~= 0) then
		UI.SplashScreen(System:LoadImage(szVideoName), "", iCanSkip, iImageDuration, VideoSequencer.OnVideoFinished);
	else
		UI:PlayCutSceneEx(szVideoName, VideoSequencer.OnVideoFinished, nil, nil, iCanSkip);
	end
end

function VideoSequencer.OnVideoFinished()
	if (not VideoSequencer.VideoList) then
		return;
	end
	
	VideoSequencer.iCurrentVideo = VideoSequencer.iCurrentVideo+1;

	local Video = VideoSequencer.VideoList[VideoSequencer.iCurrentVideo];

	if (not Video) then
		VideoSequencer:OnSequenceFinished();
	else
		VideoSequencer:PlayVideo(VideoSequencer.iCurrentVideo);
	end
end

function VideoSequencer:OnSequenceFinished()
	if (VideoSequencer.pfnEndProc) then
		VideoSequencer.pfnEndProc();
	else
		UI:StopCutScene();
		GotoPage("$MainScreen$", 0);
	end

	VideoSequencer.VideoList = nil;
	VideoSequencer.iCurrentVideo = nil;

	UI:PlayMusic();
	UI:EnableSwitch(1);
end

function VideoSequencer.TerminateGame()
	UI:TerminateGame();
	GotoPage("Credits");
	if (g_timezone == __tz0) then g_timezone = __tz1; end
end

function VideoSequencer:IsPlaying()
	if (VideoSequencer.VideoList and VideoSequencer.iCurrentVideo) then
		return 1;
	end
	
	return nil;
end