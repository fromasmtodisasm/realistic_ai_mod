MusicMoodSelector = {
	type = "MusicMoodSelector",

	Editor = {
		Model="Objects/Editor/MusicTheme.cgf",
	},

	Properties = {
		sMood = "",
	},
	InsideArea=0,
	InsideAreaRefCount=0,
}

function MusicMoodSelector:OnSave(stm)
end

function MusicMoodSelector:OnLoad(stm)
end

function MusicMoodSelector:OnPropertyChange()
	if (self.InsideArea==1) then
		Sound:SetDefaultMusicMood(self.Properties.sMood);
	end
end

function MusicMoodSelector:CliSrv_OnInit()
	self:EnableUpdate(0);
end

function MusicMoodSelector:OnShutDown()
end

function MusicMoodSelector:Client_OnEnterArea( player,areaId )
	self.InsideArea=1;
	MusicMoodSelector.InsideAreaRefCount=MusicMoodSelector.InsideAreaRefCount+1;
	Sound:SetDefaultMusicMood(self.Properties.sMood);
end

function MusicMoodSelector:Client_OnLeaveArea( player,areaId )
	self.InsideArea=0;
	MusicMoodSelector.InsideAreaRefCount=MusicMoodSelector.InsideAreaRefCount-1;
	if (MusicMoodSelector.InsideAreaRefCount<=0) then
		MusicMoodSelector.InsideAreaRefCount=0;
		Sound:SetDefaultMusicMood("");
	end
end

function MusicMoodSelector:Event_SetMood( player,areaId )
	Sound:SetMusicMood(self.Properties.sMood);
end

function MusicMoodSelector:Event_SetDefaultMood( player,areaId )
	Sound:SetDefaultMusicMood(self.Properties.sMood);
end

function MusicMoodSelector:Event_ResetDefaultMood( player,areaId )
	Sound:SetDefaultMusicMood("");
end

function MusicMoodSelector:Client_OnProceedFadeArea( player,areaId,fadeCoeff )
end

MusicMoodSelector.Server={
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

MusicMoodSelector.Client={
	OnInit=function(self)
		self:CliSrv_OnInit()
	end,
	OnShutDown=function(self)
	end,
	OnEnterArea=MusicMoodSelector.Client_OnEnterArea,
	OnLeaveArea=MusicMoodSelector.Client_OnLeaveArea,
	OnProceedFadeArea=MusicMoodSelector.Client_OnProceedFadeArea,
}
