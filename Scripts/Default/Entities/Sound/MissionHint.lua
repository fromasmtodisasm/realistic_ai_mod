MissionHint = {
	type = "Sound",

	Properties = {
		Hints = {
			sndHint1="",
			sndHint2="",
			sndHint3="",
			sndHint4="",
			sndHint5="",
			sndHint6="",
			sndHint7="",
			sndHint8="",
			sndHint9="",
			sndHint10="",
		},
		sndSkipAcknowledge="",
		iAllowedToSkip=3,
		iVolume=255,
		bLoop=0,	-- Loop sound.
		bOnce=0,
		bEnabled=1,
		bScaleDownVolumes=1,

	},
	skipped=0,
	HintCount = 1,
	SkipCount = 0,
	Editor={
		Model="Objects/Editor/Sound.cgf",
	},	
}

function MissionHint:OnSave(stm)
	--WriteToStream(stm,self.Properties);
	--stm:WriteInt(self.started);
	stm:WriteInt(self.HintCount);
end

function MissionHint:OnLoad(stm)
	--self.Properties=ReadFromStream(stm);
	self:OnReset();
	--self.started = stm:ReadInt();
	self.HintCount = stm:ReadInt();

	--if self.started==1 then
	--    self:Play();
	--end
end

----------------------------------------------------------------------------------------
function MissionHint:OnPropertyChange()
	if (self.soundName ~= self.Properties.sndSource or self.sound == nil or self.Properties.bLoop ~= self.loop) then
		--if (self.started==1) then
		--	self:Play();
		--end
		self.loop = self.Properties.bLoop;
	end
	self:OnReset();
	if (self.sound ~= nil) then
		if (self.Properties.bLoop~=0) then
			Sound:SetSoundLoop(self.sound,1);
		else
			Sound:SetSoundLoop(self.sound,0);
		end;

		Sound:SetSoundVolume(self.sound,self.Properties.iVolume);
		--Sound:SetSoundProperties(self.sound,self.Properties.fFadeValue);			
	end;
end

----------------------------------------------------------------------------------------
function MissionHint:OnReset()
	self:NetPresent(nil);
	-- Set basic sound params.
	--System:LogToConsole("Reset SP");
	--System:LogToConsole("self.Properties.bPlay:"..self.Properties.bPlay..", self.started:"..self.started);
	
	System:LogToConsole("Resetting now");

	self.SkipCount = 0;
	self.HintCount = 1;
	self.skipped = 0;
	self:StopSound();
	self.sound = nil;

	Sound:SetGroupScale(SOUNDSCALE_MISSIONHINT, 1.0);
end
----------------------------------------------------------------------------------------
MissionHint["Server"] = {
	OnInit= function (self)
		self:EnableUpdate(0);
		self.started = 0;
	end,
	OnShutDown= function (self)
	end,
}

----------------------------------------------------------------------------------------
MissionHint["Client"] = {
	----------------------------------------------------------------------------------------
	OnInit = function(self)
		self:EnableUpdate(0);
		--System:LogToConsole("OnInit");
		self.started = 0;
		self.loop = self.Properties.bLoop;
		self.soundName = "";

		if (self.Properties.bPlay==1) then
			self:Play();
		end

	end,

	----------------------------------------------------------------------------------------
	OnTimer= function(self)
		if ((not Sound:IsPlaying(self.sound)) or (_localplayer.cnt.health<1)) then
			--System:Log("sound stopped - sound scale to normal");
			Sound:StopSound(self.sound)
			self.sound = nil;
			Sound:SetGroupScale(SOUNDSCALE_MISSIONHINT, 1.0);
		else
			-- Sound still playing.
			-- set another timer.
			self:SetTimer(1000);
		end
	end,
	----------------------------------------------------------------------------------------
	OnShutDown = function(self)
		self:StopSound();
	end,
}

----------------------------------------------------------------------------------------
function MissionHint:Play()

	--System:LogToConsole("\005 Now playing with "..self.SkipCount.." skip and "..self.HintCount.." hint");

	System:Log("Now playing with "..self.SkipCount.." skip and "..self.HintCount.." hint");

	if ((self.Properties.bEnabled == 0 ) or (self.skipped == 1) ) then 
		do return end;
	end

	if( Sound:IsPlaying(self.sound) )then
		Sound:StopSound(self.sound);
		Sound:SetGroupScale(SOUNDSCALE_MISSIONHINT, 1.0);
		self.SkipCount = self.SkipCount+1;
	end

	self.sound = nil;

	if (self.SkipCount > self.Properties.iAllowedToSkip) then 
		if (sndSkipAcknowledge ~= "") then
			self.skipped = 1;
			self.sound = Sound:LoadSound(self.Properties.sndSkipAcknowledge);
			self.soundName = self.Properties.sndSkipAcknowledge;
		end
	else
		if (self.sound == nil) then
			self:LoadSnd();
			if (self.sound == nil) then
				return;
			end;
		end
	end


	if (self.Properties.bLoop~=0) then
		Sound:SetSoundLoop(self.sound,1);
	else
		Sound:SetSoundLoop(self.sound,0);
	end;

	Sound:SetSoundVolume(self.sound,self.Properties.iVolume);

	--System:LogToConsole("Playing sound");
	--local len=Sound:GetSoundLength(self.sound);
	--System:Log("length="..len);
	--self:SetTimer(80*1000);
	--self:SetTimer((len)*1000);
	
	self:SetTimer( 1000 );

	Game:PlaySubtitle(self.sound);

	--Sound:PlaySoundFadeUnderwater(self.sound);
	--System:LogToConsole( "Play Sound" );

	if (self.Properties.bScaleDownVolumes==1) then
		Sound:SetGroupScale(SOUNDSCALE_MISSIONHINT, SOUND_VOLUMESCALEMISSIONHINT);
	end
end

----------------------------------------------------------------------------------------
function MissionHint:StopSound()

	if (self.Properties.bEnabled == 0 ) then 
		do return end;
	end

--	if (self.sound ~= nil and Sound:IsPlaying(self.sound) ) then
	if (self.sound ~= nil ) then
		Sound:StopSound(self.sound);
		--System:LogToConsole( "Stop Sound" );
		self.sound = nil;
	end
	self.started = 0;
end

----------------------------------------------------------------------------------------
function MissionHint:LoadSnd()

	if (self.Properties.Hints["sndHint"..self.HintCount] ~= "") then
		self.sound = Sound:LoadSound(self.Properties.Hints["sndHint"..self.HintCount]);
		self.HintCount = self.HintCount + 1;
	end

	self.soundName = self.Properties.Hints["sndHint"..self.HintCount];
end

----------------------------------------------------------------------------------------
function MissionHint:Event_Play( sender )

	if(self.started~=0) then
		return
	end
	self:Play();
	--BroadcastEvent( self,"Play" );
end

-------------------------------------------------------------------------------
-- Stop Event
-------------------------------------------------------------------------------
function MissionHint:Event_Stop( sender )
	self:StopSound();
	--BroadcastEvent( self,"Stop" );
end

function MissionHint:Event_Enable( sender )
	self.Properties.bEnabled = 1;
	--BroadcastEvent( self,"Stop" );
end

function MissionHint:Event_Disable( sender )
	self.Properties.bEnabled = 0;
	--BroadcastEvent( self,"Stop" );
end


----------------------------------------------------------------------------------------
function MissionHint:OnWrite( stm )
end

----------------------------------------------------------------------------------------
function MissionHint:OnRead( stm )
end
