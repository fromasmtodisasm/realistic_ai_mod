function UI:UpdateBanner()
	if (UI.BannerCfgDownload or UI.BannerImageDownload) then
		return;
	end
	
	UI.BannerCfgDownload = System:CreateDownload();
	UI.BannerCfgDownload.OnComplete = UI.OnCfgComplete;	
	UI.BannerCfgDownload.OnError = UI.OnCfgError;	
	UI.BannerCfgDownload:Download(UI.szBannerCfgURL, UI.szBannerCfgPath);
end

function UI:ReloadBanner()

	printf("RELOADING BANNER!");
	
	local Ad = UI.PageBackScreen.GUI.Footer.Ad;
	local iTexture = Ad:GetTexture();
	
	System:FreeImage(iTexture);
	
	UI.PageBackScreen.GUI:OnInit();
end


function UI.OnCfgComplete()
	local Cfg = ReadTableFromFile(UI.szBannerCfgPath);
	
	if (Cfg and Cfg.url and Cfg.path) then
		UI.BannerImageDownload = System:CreateDownload();
		UI.BannerImageDownload.OnComplete = UI.OnImageComplete;
		UI.BannerImageDownload.OnError = UI.OnImageError;
		UI.BannerImageDownload:Download(Cfg.url, Cfg.path);
	end
	
	UI.BannerCfgDownload = nil;
end

function UI.OnCfgError()
	UI.BannerCfgDownload = nil;
end

function UI.OnImageComplete()
	UI:ReloadBanner();
	
	UI.BannerImageDownload = nil;
end

function UI.OnImageError()
	UI.BannerImageDownload = nil;
end