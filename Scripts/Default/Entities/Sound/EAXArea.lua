-----------------------------------------------------------------------------------------------
--
--	EAX entity - to be attached to area 
--	will set specified EAX settings when entering area
--


 EaxReverbDefaultProperties = {	
	    nEnvironment=0,		--sets all listener properties (win32/ps2 only) 
	    fEnvSize=1.0,		--environment size in meters (win32 only) 
	    fEnvDiffusion=0.0,		--environment diffusion (win32/xbox) 
	    nRoom=-10000,		--room effect level (at mid frequencies) (win32/xbox/ps2) 
	    nRoomHF=-10000,		--relative room effect level at high frequencies (win32/xbox) 
	    nRoomLF=-10000,		--relative room effect level at low frequencies (win32 only) 
	    fDecayTime=0.1,		--reverberation decay time at mid frequencies (win32/xbox) 
	    fDecayHFRatio=0.1,		--high-frequency to mid-frequency decay time ratio (win32/xbox) 
	    fDecayLFRatio=0.1,		--low-frequency to mid-frequency decay time ratio (win32 only) 
	    nReflections=-10000,	--early reflections level relative to room effect (win32/xbox) 
	    fReflectionsDelay=0.0,	--initial reflection delay time (win32/xbox) 
	    fReflectionsPan={x=0,y=0,z=0},	--early reflections panning vector (win32 only) 
	    nReverb=-10000,		--late reverberation level relative to room effect (win32/xbox) 
	    fReverbDelay=0.0,		--late reverberation delay time relative to initial reflection (win32/xbox) 
	    fReverbPan={x=0,y=0,z=0},		--late reverberation panning vector (win32 only) 
	    fEchoTime=0.075,		--echo time (win32 only) 
	    fEchoDepth=0.0,		--echo depth (win32 only) 
	    fModulationTime=0.04,	--modulation time (win32 only) 
	    fModulationDepth=0.0,	--modulation depth (win32 only) 
	    fAirAbsorptionHF=0.0,	--change in level per meter at high frequencies (win32 only) 
	    fHFReference=1000.0,	--reference high frequency (hz) (win32/xbox) 
	    fLFReference=20.0,		--reference low frequency (hz) (win32 only) 
	    fRoomRolloffFactor=0.0,	--like CS_3D_Listener_SetRolloffFactor but for room effect (win32/xbox) 
	    fDiffusion=0.0,		--Value that controls the echo density in the late reverberation decay. (xbox only) 
	    fDensity=0.0,		--Value that controls the modal density in the late reverberation decay (xbox only) 
	    nFlags=0,			--CS_REVERB_FLAGS - modifies the behavior of above properties (win32 only) 
    }


EAXArea = {
	type = "EAXArea",

	Editor = {
		Model="Objects/Editor/S.cgf",
	},

	Properties = {
		EaxReverbProperties= {	
	    nEnvironment=0,		--sets all listener properties (win32/ps2 only) 
	    fEnvSize=1.0,		--environment size in meters (win32 only) 
	    fEnvDiffusion=0.0,		--environment diffusion (win32/xbox) 
	    nRoom=-10000,		--room effect level (at mid frequencies) (win32/xbox/ps2) 
	    nRoomHF=-10000,		--relative room effect level at high frequencies (win32/xbox) 
	    nRoomLF=-10000,		--relative room effect level at low frequencies (win32 only) 
	    fDecayTime=0.1,		--reverberation decay time at mid frequencies (win32/xbox) 
	    fDecayHFRatio=0.1,		--high-frequency to mid-frequency decay time ratio (win32/xbox) 
	    fDecayLFRatio=0.1,		--low-frequency to mid-frequency decay time ratio (win32 only) 
	    nReflections=-10000,	--early reflections level relative to room effect (win32/xbox) 
	    fReflectionsDelay=0.0,	--initial reflection delay time (win32/xbox) 
	    fReflectionsPan={x=0,y=0,z=0},	--early reflections panning vector (win32 only) 
	    nReverb=-10000,		--late reverberation level relative to room effect (win32/xbox) 
	    fReverbDelay=0.0,		--late reverberation delay time relative to initial reflection (win32/xbox) 
	    fReverbPan={x=0,y=0,z=0},		--late reverberation panning vector (win32 only) 
	    fEchoTime=0.075,		--echo time (win32 only) 
	    fEchoDepth=0.0,		--echo depth (win32 only) 
	    fModulationTime=0.04,	--modulation time (win32 only) 
	    fModulationDepth=0.0,	--modulation depth (win32 only) 
	    fAirAbsorptionHF=0.0,	--change in level per meter at high frequencies (win32 only) 
	    fHFReference=1000.0,	--reference high frequency (hz) (win32/xbox) 
	    fLFReference=20.0,		--reference low frequency (hz) (win32 only) 
	    fRoomRolloffFactor=0.0,	--like CS_3D_Listener_SetRolloffFactor but for room effect (win32/xbox) 
	    fDiffusion=0.0,		--Value that controls the echo density in the late reverberation decay. (xbox only) 
	    fDensity=0.0,		--Value that controls the modal density in the late reverberation decay (xbox only) 
	    nFlags=0,			--CS_REVERB_FLAGS - modifies the behavior of above properties (win32 only) 
    },
				
		nEAXEnvironment=0, 
		--a value bigger than 0 will use the pre-defined presets. 
		--if the value -1 is specified, the above pre-defined table will be used.
		--if the value 0 is specified, EAX default environment will be used

	},
	
	EaxTempPreset={},

--	nBuilding = -1,
--	nSector = -1,
	fLastFadeCoeff = 0.0,
	ABox = 8,
	maxChance = 1000,
}



function EAXArea:OnSave(stm)
	WriteToStream(stm,self.Properties);
end

function EAXArea:OnLoad(stm)
	self.Properties=ReadFromStream(stm);
end

function EAXArea:OnPropertyChange()
	
end

function EAXArea:CliSrv_OnInit()
	self:EnableUpdate(0);
	if(self.Initialized)then
		return
	end
	
	self:RegisterState("Inactive");
	self:RegisterState("Active");
	self:GotoState("Inactive");
	self["Initialized"]=1;
end


function EAXArea:OnShutDown()
end

function EAXArea:Client_Inactive_OnEnterArea( player,areaId )

System:Log("Entering Sound Area "..areaId);

	System:Log("Set EAX Environment "..self.Properties.nEAXEnvironment);
	if (self.Properties.nEAXEnvironment>0) then
		Sound:SetEaxEnvironment(self.Properties.nEAXEnvironment);
	else	
		Sound:SetEaxEnvironment(self.Properties.EaxReverbProperties);
	end

	self:GotoState("Active");
	
end

function EAXArea:Client_Active_OnLeaveArea( player,areaId )
System:Log("Leaving Sound Area "..areaId);
	self:GotoState("Inactive");

	-- disable eax, choosing OFF preset	
	System:Log("Set EAX Environment 0");
	--if( self.Properties.EaxReverbProperties~=0 ) then
	--	Sound:SetEaxEnvironment(0);
	--end		
	
	Sound:SetEaxEnvironment(EaxReverbDefaultProperties);
	
end

--function EAXArea:Client_Active_OnProceedFadeArea( player,areaId,fadeCoeff )
--end

	----------------------------------------------------------------------------------------
function EAXArea:OnMove()
--	local newInsidePos = self:UpdateInSector(self.nBuilding,	self.nSector );
--	self.nBuilding = newInsidePos.x;
--	self.nSector = newInsidePos.y;
end


EAXArea.Server={
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

EAXArea.Client={
	OnInit=function(self)
		self:CliSrv_OnInit()
		self:OnMove();
	end,
	OnShutDown=function(self)
	end,
	Inactive={
		OnBeginState=function(self)
--System:Log("Entering INACTIVE");		
		end,
	
		OnEnterArea=EAXArea.Client_Inactive_OnEnterArea,
		OnMove=EAXArea.OnMove,
--		OnMove=EAXArea.Client.OnMove,		
	},
	Active={
		OnBeginState=function(self)
--System:Log("Entering ACTIVE");		
		--	System:Log("SetTimer");
--			self:SetTimer(200);
		end,
		OnMove=EAXArea.OnMove,
--		OnProceedFadeArea=EAXArea.Client_Active_OnProceedFadeArea,
		OnLeaveArea=EAXArea.Client_Active_OnLeaveArea,
		OnEndState=function(self)
--			System:Log("KillTimer");
--			self:KillTimer();
		end,
	},
}
