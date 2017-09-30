RandomAmbientSoundPreset = {
	type = "RandomAmbientSoundPreset",

	Editor = {
		Model="Objects/Editor/S.cgf",
	},

	Properties = {
		bLIndoorOnly=0,		--play the sound only if the listener is in indoor
		bLOutdoorOnly=0,	--play the sound only if the listener is in outdoor
		fScale = 1,
		bPlayFromCenter=0,
		sndpresetSoundPreset = "",
		bOnce = 0,
	},

	triggered = 0,
	
	Sounds = {},
	SoundPos={},

--	nBuilding = -1,
--	nSector = -1,
	fLastFadeCoeff = 0.0,
	MaxBox = 200,
	MinBox = 40,
	maxChance = 1000,
}

function RandomAmbientSoundPreset:FlashSounds()
	self.Sounds={};
	--System:LogToConsole("FlashSounds");
--	for i, Element in self.Sounds do
--		if (Element.Sound) then
--			Element.Sound=nil;
--			end
--	end
end

function RandomAmbientSoundPreset:LoadSounds()
	self:FlashSounds();
	if ((SoundPresetDB==nil) or (SoundPresetDB[self.Properties.sndpresetSoundPreset]==nil)) then
		System:Log("Invalid preset specified: "..self.Properties.sndpresetSoundPreset);
		return
	end
	--System:Log("Loading sounds...");
	for i, Element in SoundPresetDB[self.Properties.sndpresetSoundPreset] do
		self.Sounds[i] = {};
		--System:Log("BABA "..i..", "..Element.Sound);
		if (type(Element) == "table" and Element.Sound~=nil) then
			if (Element.Chance == self.maxChance) then
				Element.NoOverlap = "1";
			end
--			System:LogToConsole("doing Sound "..Element.sndSound);
				local bStreaming=0;
				if (Element.Streaming=="1") then
					--System:Log("streaming.");
					if (Element.Centered=="1") then
						bStreaming=1;
					else
						System:Log("WARNING: Trying to load a streaming, non-2D sound "..Element.Sound.." ! Not streaming.");
					end
				end
				if (Element.Centered == "1") then
					if (Element.Sound ~= "") then
						if (bStreaming~=0) then

							if (self.Properties.bLIndoorOnly==1) then
								self.Sounds[i].Sound = Sound:LoadStreamSound(Element.Sound,SOUND_INDOOR);							
							elseif (self.Properties.bLOutdoorOnly==1) then
								self.Sounds[i].Sound = Sound:LoadStreamSound(Element.Sound,SOUND_OUTDOOR);
							end

							if ((self.Properties.bLOutdoorOnly==0) and (self.Properties.bLIndoorOnly==0)) then
								self.Sounds[i].Sound = Sound:LoadStreamSound(Element.Sound);
							end


							--self.Sounds[i].Sound = Sound:LoadStreamSound(Element.Sound);

						else

							if (self.Properties.bLIndoorOnly==1) then
								self.Sounds[i].Sound = Sound:LoadSound(Element.Sound,SOUND_INDOOR);							
							elseif (self.Properties.bLOutdoorOnly==1) then
								self.Sounds[i].Sound = Sound:LoadSound(Element.Sound,SOUND_OUTDOOR);
							end

							if ((self.Properties.bLOutdoorOnly==0) and (self.Properties.bLIndoorOnly==0)) then
								self.Sounds[i].Sound = Sound:LoadSound(Element.Sound);
							end
						end
						--if (self.Sounds[i].Sound) then
							--System:Log("Loading sound "..Element.Sound);
						--end
					end
					if(self.Sounds[i].Sound) then
						if ((tonumber(Element.Chance)==self.maxChance) and ((not Element.Timeout) or (Element.Timeout=="0"))) then
							Sound:SetSoundLoop(self.Sounds[i].Sound, 1);
							--play and stop to force loading
							self:PlayAmbientSound(self.Sounds[i].Sound);
							if (self.fLastFadeCoeff==0) then
								Sound:StopSound(self.Sounds[i].Sound);
							end

							--System:Log("Looping sound "..Element.Sound);
							--Sound:PlaySound(self.Sounds[i].Sound);
							--System:Log("102Playing sound "..Element.Sound);
						else
							Sound:SetSoundLoop(self.Sounds[i].Sound, 0);	
							--play and stop to force loading
--							self:PlayAmbientSound(self.Sounds[i].Sound);
--							Sound:StopSound(self.Sounds[i].Sound);
							--Sound:PlaySound(self.Sounds[i].Sound);
							--System:Log("102Playing sound "..Element.Sound);
						end	
					end	
				else
					--if(Element.sndSound==nil)then
					--	System:LogToConsole(tostring(i)..".sndSound=nil")
					--end
					if (Element.Sound ~= "") then
						self.Sounds[i] = {};

						if (self.Properties.bLIndoorOnly==1) then
							self.Sounds[i].Sound = Sound:Load3DSound(Element.Sound,bor(SOUND_RADIUS,SOUND_INDOOR));							
						elseif (self.Properties.bLOutdoorOnly==1) then
							self.Sounds[i].Sound = Sound:Load3DSound(Element.Sound,bor(SOUND_RADIUS,SOUND_OUTDOOR));
						end

						if ((self.Properties.bLOutdoorOnly==0) and (self.Properties.bLIndoorOnly==0)) then
							self.Sounds[i].Sound = Sound:Load3DSound(Element.Sound,SOUND_RADIUS);
						end

						--self.Sounds[i].Sound = Sound:Load3DSound(Element.Sound, SOUND_RADIUS);

						--if (self.Sounds[i].Sound) then
							--System:Log("Loading 3d-sound "..Element.Sound);
						--end

					end
				end
			
			if(self.Sounds[i] and self.Sounds[i].Sound) then
				Sound:SetSoundVolume(self.Sounds[i].Sound, tonumber(Element.Volume) * self.fLastFadeCoeff * self.Properties.fScale);
				Sound:AddToScaleGroup(self.Sounds[i].Sound, SOUNDSCALE_UNDERWATER);
				--System:Log("Setting sound "..Element.Sound.." volume "..tonumber(Element.Volume)*self.fLastFadeCoeff);
			end	
		end--if table
	end --for
end

function RandomAmbientSoundPreset:OnSave(stm)
	WriteToStream(stm,self.Properties);
end

function RandomAmbientSoundPreset:OnLoad(stm)
	self.Properties=ReadFromStream(stm);
end

function RandomAmbientSoundPreset:OnPropertyChange()
	self:LoadSounds();
end

function RandomAmbientSoundPreset:OnReset()
	self:NetPresent(nil);
	self.triggered = 0;
	
end

function RandomAmbientSoundPreset:CliSrv_OnInit()

	self:SetStateClientside(1);		-- prevents error when state changes on the client and does not sync state changes to the client 

	if(self.Initialized)then
		return
	end
	self:EnableUpdate(0);
	self:OnReset();
	self:RegisterState("Inactive");
	self:RegisterState("Active");
	self:GotoState("Inactive");
	self["Initialized"]=1;
end

function RandomAmbientSoundPreset:CalcPos(ListenerPosition)
	if (self.Properties.bPlayFromCenter~=0) then
		return self:GetPos();
	else
		local fEdgeDist=self.MaxBox-self.MinBox;
		local fRandom;
		local SoundPos = self.SoundPos;
		fRandom=random(0, fEdgeDist);
		if (fRandom<fEdgeDist*0.5) then
			SoundPos.x = ListenerPosition.x - fRandom - self.MinBox*0.5;
		else
			SoundPos.x = ListenerPosition.x + (fRandom-fEdgeDist*0.5) + self.MinBox*0.5;
		end
		fRandom=random(0, fEdgeDist);
		if (fRandom<fEdgeDist*0.5) then
			SoundPos.y = ListenerPosition.y - fRandom - self.MinBox*0.5;
		else
			SoundPos.y = ListenerPosition.y + (fRandom-fEdgeDist*0.5) + self.MinBox*0.5;
		end
		fRandom=random(0, fEdgeDist);
		if (fRandom<fEdgeDist*0.5) then
			SoundPos.z = ListenerPosition.z - fRandom - self.MinBox*0.5;
		else
			SoundPos.z = ListenerPosition.z + (fRandom-fEdgeDist*0.5) + self.MinBox*0.5;
		end
		--SoundPos.x = ListenerPosition.x + random(0, self.MaxBox) - self.MaxBox*0.5;
		--SoundPos.y = ListenerPosition.y + random(0, self.MaxBox) - self.MaxBox*0.5;
		--SoundPos.z = ListenerPosition.z + random(0, self.MaxBox) - self.MaxBox*0.5;
		return SoundPos;
	end
end

function RandomAmbientSoundPreset:PlayAmbientSound(CurSnd)
	local Player = _localplayer;
	if (Player == nil) then
		return
	end
	local ListenerPosition = Player:GetPos();
	local SoundPos=self:CalcPos(ListenerPosition);
	Sound:SetSoundPosition(CurSnd, SoundPos);
	Sound:SetMinMaxDistance(CurSnd, 10, 300);
	Sound:PlaySound(CurSnd);
end

function RandomAmbientSoundPreset:Client_Active_OnTimer()
	
	local TimerDelta=1.0;

	--set the next iteration
	self:SetTimer(TimerDelta*1000);
	
	if ((SoundPresetDB==nil) or (SoundPresetDB[self.Properties.sndpresetSoundPreset]==nil)) then
		System:Log("Invalid preset specified: "..self.Properties.sndpresetSoundPreset);
		return
	end
	
	--System:Log("OnTimer");
	for i, Element in SoundPresetDB[self.Properties.sndpresetSoundPreset] do
		if (type(Element) == "table" and self.Sounds[i]~=nil and self.Sounds[i].Sound~=nil) then
			local bSkip = 0;
			if (Element.Centered ~= "0" and tonumber(Element.Chance) == self.maxChance) then
				--System:LogToConsole("SKIP DUE MAXCHANCE");
				bSkip = 1;
			elseif(Element.NoOverlap == "1" and Sound:IsPlaying(self.Sounds[i].Sound)) then
				--System:LogToConsole("SKIP DUE STILL PLAYING");
				bSkip = 1;
			elseif ((Element.Timeout) and (self.Sounds[i].Timeout) and (self.Sounds[i].Timeout<tonumber(Element.Timeout))) then
				--System:LogToConsole("SKIP DUE TIMEOUT");
				bSkip = 1;
			else
				--System:LogToConsole("NO SKIP");
			end
			if (self.Sounds[i].Timeout) then
				self.Sounds[i].Timeout=self.Sounds[i].Timeout+TimerDelta;
			end
		
			if (bSkip == 0) then
				local CurSnd = self.Sounds[i].Sound;
				if (random(0, self.maxChance) < tonumber(Element.Chance)) then
--					if (Element.Centered == "0") then
						self:PlayAmbientSound(CurSnd);
						--System:Log("Playing sound "..Element.Sound.." ("..SoundPos.x..", "..SoundPos.y..", "..SoundPos.z..")");
						--System:Log("ListenerPosition ("..ListenerPosition.x..", "..ListenerPosition.y..", "..ListenerPosition.z..")");
						--local dx=SoundPos.x-ListenerPosition.x;
						--local dy=SoundPos.y-ListenerPosition.y;
						--local dz=SoundPos.z-ListenerPosition.z;
						--System:Log("Sound Distance "..sqrt(dx*dx+dy*dy+dz*dz));
					--else
				--		Sound:PlaySound(CurSnd);
						--System:Log("181Playing sound "..Element.Sound);
				--	end
					Sound:SetSoundVolume(CurSnd, tonumber(Element.Volume) * self.fLastFadeCoeff * self.Properties.fScale);
					--System:LogToConsole("blah:"..tonumber(Element.Volume) * self.fLastFadeCoeff * self.Properties.fScale);
					self.Sounds[i].Timeout=0; -- reset timeout
					--System:Log("Setting sound "..Element.Sound.." volume "..tonumber(Element.Volume)*self.fLastFadeCoeff);
				end
			end
		end
	end
end

function RandomAmbientSoundPreset:OnShutDown()
end

function RandomAmbientSoundPreset:Client_Inactive_OnEnterArea( player,areaId )

	if(self.Properties.bOnce == 1 and self.triggered == 1) then
		--System:Log("Sound Area once NOY entering");
		do return end
	end	
		
	self.triggered = 1;
		
	--System:Log("Entering Sound Area "..areaId);

--load the sounds
	--self:LoadSounds();
	
	if ((SoundPresetDB==nil) or (SoundPresetDB[self.Properties.sndpresetSoundPreset]==nil)) then
		System:Log("Invalid preset specified: "..self.Properties.sndpresetSoundPreset);
		return
	end
	
	for i, Element in SoundPresetDB[self.Properties.sndpresetSoundPreset] do
		if (type(Element) == "table" and self.Sounds[i]~=nil and self.Sounds[i].Sound~=nil) then
			if (tonumber(Element.Chance) == self.maxChance) then
--				Sound:SetSoundVolume(Element.Sound, 0);
				self:PlayAmbientSound(self.Sounds[i].Sound);
				--System:Log("205Playing sound "..Element.Sound);
			end
		end
	end
	self:GotoState("Active");
	
end


function RandomAmbientSoundPreset:Client_Active_OnEnterArea( player,areaId )
	--System:Log("ReEntering Sound Area "..areaId);

--load the sounds
	
	for i, Element in SoundPresetDB[self.Properties.sndpresetSoundPreset] do
		if (type(Element) == "table" and self.Sounds[i]~=nil and self.Sounds[i].Sound~=nil) then
			if (tonumber(Element.Chance) == self.maxChance) then
--				Sound:SetSoundVolume(Element.Sound, 0);
				self:PlayAmbientSound(self.Sounds[i].Sound);
				--System:Log("205Playing sound "..Element.Sound);
			end
		end
	end
	
end


function RandomAmbientSoundPreset:Client_Active_OnLeaveArea( player,areaId )
	--System:Log("Leaving Sound Area "..areaId);

	if ((SoundPresetDB==nil) or (SoundPresetDB[self.Properties.sndpresetSoundPreset]==nil)) then
		System:Log("Invalid preset specified: "..self.Properties.sndpresetSoundPreset);
		return
	end
	
	for i, Element in SoundPresetDB[self.Properties.sndpresetSoundPreset] do
		if (type(Element) == "table" and self.Sounds[i]~=nil and self.Sounds[i].Sound~=nil) then
			--if(Element.Sound) then
			--System:Log("Stopping sound "..Element.Sound);
			--System:Log("****");
			Sound:StopSound(self.Sounds[i].Sound);
			--end
		end
	end
	self:GotoState("Inactive");
	--self:FlashSounds();
	self.fLastFadeCoeff=0;
end

function RandomAmbientSoundPreset:Client_Active_OnProceedFadeArea( player,areaId,fadeCoeff )

--System:Log("FADE proceed "..fadeCoeff);

	self.fLastFadeCoeff = fadeCoeff;
	
	if ((SoundPresetDB==nil) or (SoundPresetDB[self.Properties.sndpresetSoundPreset]==nil)) then
		System:Log("Invalid preset specified: "..self.Properties.sndpresetSoundPreset);
		return
	end
	
	for i, Element in SoundPresetDB[self.Properties.sndpresetSoundPreset] do
		if (type(Element) == "table" and self.Sounds[i]~=nil and self.Sounds[i].Sound~=nil) then
			--if (Element.Sound) then
			Sound:SetSoundVolume(self.Sounds[i].Sound, tonumber(Element.Volume) * self.fLastFadeCoeff * self.Properties.fScale);
			--System:Log("Setting sound "..Element.Sound.." volume "..tonumber(Element.Volume)*self.fLastFadeCoeff*self.Properties.fScale);
			--end
		end
	end
end

	----------------------------------------------------------------------------------------
function RandomAmbientSoundPreset:OnMove()
--	local newInsidePos = self:UpdateInSector(self.nBuilding,	self.nSector );
--	self.nBuilding = newInsidePos.x;
--	self.nSector = newInsidePos.y;
end


RandomAmbientSoundPreset.Server={
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

RandomAmbientSoundPreset.Client={
	OnInit=function(self)
		self:CliSrv_OnInit()
		self:OnMove();
		self:LoadSounds();
	end,
	OnShutDown=function(self)
	end,
	Inactive={
		OnBeginState=function(self)
--System:Log("Entering INACTIVE");		
		end,
	
		OnEnterArea=RandomAmbientSoundPreset.Client_Inactive_OnEnterArea,
		OnMove=RandomAmbientSoundPreset.OnMove,
--		OnMove=RandomAmbientSoundPreset.Client.OnMove,		
	},
	Active={
		OnBeginState=function(self)
--System:Log("Entering ACTIVE");		
			--System:Log("SetTimer");
			self:SetTimer(200);
		end,
		OnTimer=RandomAmbientSoundPreset.Client_Active_OnTimer,
		OnMove=RandomAmbientSoundPreset.OnMove,
		OnProceedFadeArea=RandomAmbientSoundPreset.Client_Active_OnProceedFadeArea,
		OnEnterArea=RandomAmbientSoundPreset.Client_Active_OnEnterArea,		
		OnLeaveArea=RandomAmbientSoundPreset.Client_Active_OnLeaveArea,
		OnEndState=function(self)
--			System:Log("KillTimer");
			self:KillTimer();
		end,
	},
}
