MusicThemeSelector = {
	type = "MusicThemeSelector",

	Editor = {
		Model="Objects/Editor/MusicTheme.cgf",
	},

	Properties = {
		bIndoorOnly=0,
		bOutdoorOnly=0,
		sTheme = "",
		sDefaultMood = "",
		sMood = "",
	},
	InsideArea=0,
}

function MusicThemeSelector:OnSave(stm)
end

function MusicThemeSelector:OnLoad(stm)
end

function MusicThemeSelector:OnPropertyChange()
	if (self.InsideArea==1) then
		Sound:SetMusicTheme(self.Properties.sTheme);
	end
end

function MusicThemeSelector:CliSrv_OnInit()
	self:EnableUpdate(0);
end

function MusicThemeSelector:OnShutDown()
end

function MusicThemeSelector:Client_OnEnterArea( player,areaId )
	--System:Log("enter music theme area "..self.Properties.sTheme);
	local bActivate=1;
	local Indoor=System:IsPointIndoors(System:GetViewCameraPos());	-- player:GetPos());
	if ((self.Properties.bIndoorOnly==1) and (Indoor==nil)) then
		bActivate=0;
	elseif ((self.Properties.bOutdoorOnly==1) and (Indoor~=nil)) then
		bActivate=0;
	end
	--System:Log("bActivate "..bActivate..", InsideArea "..self.InsideArea);
	if (bActivate==1) then --and (self.InsideArea==0)) then
		self.InsideArea=1;
		Sound:SetMusicTheme(self.Properties.sTheme);
		if (self.Properties.sDefaultMood ~= "") then
			Sound:SetDefaultMusicMood(self.Properties.sDefaultMood);
		end
		if (self.Properties.sMood ~= "") then
			Sound:SetMusicMood(self.Properties.sMood);
		end
	elseif ((bActivate==0) and (self.InsideArea==1)) then
		self.InsideArea=0;
		Sound:SetMusicTheme("");
	end
end

function MusicThemeSelector:Event_SetTheme( player,areaId )
	Sound:SetMusicTheme(self.Properties.sTheme);
	if (self.Properties.sDefaultMood ~= "") then
		Sound:SetDefaultMusicMood(self.Properties.sDefaultMood);
	end
	if (self.Properties.sMood ~= "") then
		Sound:SetMusicMood(self.Properties.sMood);
	end
end

function MusicThemeSelector:Event_Reset( player,areaId )
	Sound:SetMusicTheme("");
	if (self.Properties.sDefaultMood ~= "") then
		Sound:SetDefaultMusicMood("");
	end
end

function MusicThemeSelector:Client_OnLeaveArea( player,areaId )
	--System:Log("leave music theme area "..self.Properties.sTheme);
	--System:Log("InsideArea "..self.InsideArea);
	if (self.InsideArea==1) then
		self.InsideArea=0;
		Sound:SetMusicTheme("");
	end
end

function MusicThemeSelector:Client_OnProceedFadeArea( player,areaId,fadeCoeff )
end

MusicThemeSelector.Server={
	OnInit=function(self)
		self:CliSrv_OnInit()
	end,
	OnShutDown=function(self)
	end,
	Inactive={
	},
	Active={
	},
}

MusicThemeSelector.Client={
	OnInit=function(self)
		self:CliSrv_OnInit()
	end,
	OnShutDown=function(self)
	end,
	OnEnterArea=MusicThemeSelector.Client_OnEnterArea,
	OnLeaveArea=MusicThemeSelector.Client_OnLeaveArea,
	OnProceedFadeArea=MusicThemeSelector.Client_OnProceedFadeArea,
}
