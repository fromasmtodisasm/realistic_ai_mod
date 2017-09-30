--	exclusive areas
--	areas have to be nested - the next area copmlitly inside the parent
--	tha first (outside) area has to have AreaID 1
--	there might be up to 10 exclusive nested areas for one entity
BgmMusicLoop = {
	Editor = {
		Model="Objects/Editor/S.cgf",
	},
	Properties = {
		sndBgmMusic="",
		bLoop=1,
	},
	my_lastfade = 0,
	InsideArray = 	{0,0,0,0,0,0,0,0,0,0},
} 

function BgmMusicLoop:OnPropertyChange()
	self:LoadSounds()
end

---------------------------------------------------------
--
function BgmMusicLoop:CliSrv_OnInit()
	self:EnableUpdate(0)		
	
	if (self.Initialized) then
		return
	end
	
	self:RegisterState("Inactive")
	self:RegisterState("Active")
	self:GotoState("Inactive")
	self["Initialized"]=1 
end

function BgmMusicLoop:OnSave(stm)
	stm:WriteInt(self.my_lastfade)
end

function BgmMusicLoop:OnLoad(stm)
	self.my_lastfade = stm:ReadInt()
	if (self.my_lastfade > 0) then
		self:LoadSounds()
		if (self.mybgm) then
			Sound:PlaySound(self.mybgm)
		end
	end
end

-------------
--
function BgmMusicLoop:LoadSounds()
	if (self.Properties.sndBgmMusic~="") then
		--
		if (not self.mybgm) then
			self.mybgm = Sound:LoadStreamSound(self.Properties.sndBgmMusic, SOUND_MUSIC+SOUND_UNSCALABLE)
		end
		if (self.mybgm) and (tostring(getglobal("s_MusicEnable"))=="1") then
			Sound:SetSoundVolume(self.mybgm, getglobal("s_MusicVolume") * 255 * self.my_lastfade)
			Sound:SetSoundLoop(self.mybgm,self.Properties.bLoop)
		else
			self.mybgm = nil 
		end
	end
end

----------

function BgmMusicLoop:Client_Active_OnTimer()
	local Player = _localplayer 
	
	if (Player==nil) then
			return
	end

end

---------------------------------------------------------
--
function BgmMusicLoop:OnShutDown()
end

---------------------------------------------------------
--
function BgmMusicLoop:Client_Inactive_OnEnterArea(player,areaId)
	self:LoadSounds()
	self.InsideArray[areaId] = 1 
	------
	if (self.mybgm) then
		Sound:PlaySound(self.mybgm)
	end
	self:GotoState("Active")

end

---------------------------------------------------------
--
function BgmMusicLoop:Client_Active_OnEnterArea(player,areaId)
	self.InsideArray[areaId] = 1 
	-------
	if (self.mybgm) then
		Sound:PlaySound(self.mybgm)
	end
end


---------------------------------------------------------
--
function BgmMusicLoop:Client_Active_OnLeaveArea(player,areaId)
	self.InsideArray[areaId] = 0 
	self.my_lastfade = 0 
	if (self.mybgm) and (Sound:IsPlaying(self.mybgm)) then
		Sound:StopSound(self.mybgm)
	end
	if (areaId==1)	then	-- got out of outside area
		self:GotoState("Inactive")
	end	
end


---------
--
function BgmMusicLoop:Client_Active_OnProceedFadeArea(player,areaId,fadeCoeff)
	self.my_lastfade = fadeCoeff * 1 
	if (self.mybgm) then
		Sound:SetSoundVolume(self.mybgm, getglobal("s_MusicVolume") * 255 * self.my_lastfade)
	end
end

----------------------

BgmMusicLoop.Server={
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

BgmMusicLoop.Client={
	OnInit=function(self)
		self:CliSrv_OnInit()
	end,
	OnShutDown=function(self)
	end,
	Inactive={
		OnEnterArea=BgmMusicLoop.Client_Inactive_OnEnterArea,
	},
	Active={
		OnBeginState=function(self)
			self:SetTimer(200)
		end,
		OnTimer=BgmMusicLoop.Client_Active_OnTimer,
		OnProceedFadeArea=BgmMusicLoop.Client_Active_OnProceedFadeArea,
		OnEnterArea=BgmMusicLoop.Client_Active_OnEnterArea,		
		OnLeaveArea=BgmMusicLoop.Client_Active_OnLeaveArea,
		OnEndState=function(self)
			self:KillTimer()
		end,
	},
}


