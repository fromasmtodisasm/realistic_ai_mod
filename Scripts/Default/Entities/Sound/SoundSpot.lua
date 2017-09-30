SoundSpot = {
	type = "Sound",

	Properties = {
		sndSource="",
		iVolume=255,
		InnerRadius=2,
		OuterRadius=10,
		fFadeValue=1.0, -- for indoor sector sounds
		bLoop=1,	-- Loop sound.
		bPlay=0,	-- Immidiatly start playing on spawn.
		bOnce=0,
		bEnabled=1,
		--bOcclusion=1,
		--bDirectional=0,
	},
	started=0,
	Editor={
		Model="Objects/Editor/Sound.cgf",
	},
	bEnabled=1,
}

function SoundSpot:OnSave(stm)
	--WriteToStream(stm,self.Properties);
	stm:WriteInt(self.started);
	stm:WriteInt(self.bEnabled);
end

function SoundSpot:OnLoad(stm)
	--self.Properties=ReadFromStream(stm);
	--self:OnReset();
	self.started = stm:ReadInt();
	self.bEnabled = stm:ReadInt();
	if ((self.started==1) and (self.Properties.bOnce~=1)) then
	    self:PlaySound();
	end	
end

----------------------------------------------------------------------------------------
function SoundSpot:OnPropertyChange()
	if (self.soundName ~= self.Properties.sndSource or self.sound == nil or self.Properties.bLoop ~= self.loop) then
		if (self.started==1) then
			self:PlaySound();
		end
		self.loop = self.Properties.bLoop;
	end
	self:OnReset();
	if (self.sound ~= nil) then
		if (self.Properties.bLoop~=0) then
			Sound:SetSoundLoop(self.sound,1);
		else
			Sound:SetSoundLoop(self.sound,0);
		end;
		Sound:SetMinMaxDistance(self.sound,self.Properties.InnerRadius,self.Properties.OuterRadius);
		Sound:SetSoundVolume(self.sound,self.Properties.iVolume);
		Sound:SetSoundProperties(self.sound,self.Properties.fFadeValue);			
	end;
end

----------------------------------------------------------------------------------------
function SoundSpot:OnReset()
	self:NetPresent(nil);
	-- Set basic sound params.
	--System:LogToConsole("Reset SP");
	--System:LogToConsole("self.Properties.bPlay:"..self.Properties.bPlay..", self.started:"..self.started);

	self.bEnabled=self.Properties.bEnabled;

	if (self.Properties.bPlay == 0 and self.sound ~= nil) then
		self:StopSound();
	end

	if (self.Properties.bPlay~=0 and self.started == 0) then
		self:PlaySound();
	end
	self.Client:OnMove();


	self.started = 0; -- [marco] fix playonce on reset for switch editor/game mode
end
----------------------------------------------------------------------------------------
SoundSpot["Server"] = {
	OnInit= function (self)
		self:EnableUpdate(0);
		self.started = 0;
	end,
	OnShutDown= function (self)
	end,
}

----------------------------------------------------------------------------------------
SoundSpot["Client"] = {
	----------------------------------------------------------------------------------------
	OnInit = function(self)
		self:EnableUpdate(0);
		--System:LogToConsole("OnInit");
		self.started = 0;
		self.loop = self.Properties.bLoop;
		self.soundName = "";

		if (self.Properties.bPlay==1) then
			self:PlaySound();
			--System:LogToConsole("Play sound"..self.Properties.sndSource);
		end
		self.Client:OnMove();
	end,
	----------------------------------------------------------------------------------------
	OnShutDown = function(self)
		self:StopSound();
	end,

	----------------------------------------------------------------------------------------
	OnMove = function(self)
		if (self.sound ~= nil) then
			Sound:SetSoundPosition( self.sound,self:GetPos() );			
		end;

	end,
	----------------------------------------------------------------------------------------
}

----------------------------------------------------------------------------------------
function SoundSpot:PlaySound()

	if (self.bEnabled == 0 ) then 
		do return end;
	end

	if (self.sound == nil) then
		self:LoadSnd();
		if (self.sound == nil) then
			return;
		end;
	end;

	if (self.Properties.bLoop~=0) then
		Sound:SetSoundLoop(self.sound,1);
	else
		Sound:SetSoundLoop(self.sound,0);
	end;


	Sound:SetSoundPosition(self.sound,self:GetPos());
	Sound:SetMinMaxDistance(self.sound,self.Properties.InnerRadius,self.Properties.OuterRadius);
	Sound:SetSoundVolume(self.sound,self.Properties.iVolume);

	if( Sound:IsPlaying(self.sound) )then
		Sound:StopSound(self.sound);
	end
	Sound:PlaySound(self.sound);
	--System:LogToConsole( "Play Sound" );
	self.started = 1;
end

----------------------------------------------------------------------------------------
function SoundSpot:StopSound()

	if (self.bEnabled == 0 ) then 
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
function SoundSpot:LoadSnd()
	if (self.sound ~= nil) then
		self:StopSound();
	end
	if (self.Properties.sndSource ~= "") then
		local sndFlags = bor(SOUND_RADIUS,SOUND_OCCLUSION);
		--local sndFlags = SOUND_RADIUS;
		--if (self.Properties.bOcclusion == 1) then
			-- sndFlags = bor(sndFlags,SOUND_OCCLUSION);
		--end
		
		self.sound = Sound:Load3DSound(self.Properties.sndSource,sndFlags);
		--System:LogToConsole("loading "..self.Properties.sndSource);
		Sound:SetSoundProperties(self.sound,self.Properties.fFadeValue);			
	end
	self.soundName = self.Properties.sndSource;
end

----------------------------------------------------------------------------------------
function SoundSpot:Event_Play( sender )

	if(self.Properties.bOnce~=0 and self.started~=0) then
		return
	end
	self:PlaySound();
	--BroadcastEvent( self,"Play" );
end

-------------------------------------------------------------------------------
-- Stop Event
-------------------------------------------------------------------------------
function SoundSpot:Event_Stop( sender )
	self:StopSound();
	--BroadcastEvent( self,"Stop" );
end

function SoundSpot:Event_Enable( sender )
	self.bEnabled = 1;
	--BroadcastEvent( self,"Stop" );
end

function SoundSpot:Event_Disable( sender )
	self.bEnabled = 0;
	--BroadcastEvent( self,"Stop" );
end


function SoundSpot:Event_Redirect( sender )
	BroadcastEvent( self,"Redirect" );
end

