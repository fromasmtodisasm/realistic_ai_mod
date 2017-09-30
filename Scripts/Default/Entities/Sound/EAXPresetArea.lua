-----------------------------------------------------------------------------------------------
--
--	EAX entity - to be attached to area 
--	will set specified EAX settings when entering area
--

EAXPresetArea = {
	type = "EAXPresetArea",

	Editor = {
		Model="Objects/Editor/S.cgf",
	},

	Properties = {
		eaxpresetEAXPreset="",
		--bLIndoorOnly=0,		-- set eax only if the listener is in indoor
		--bLOutdoorOnly=0,	-- set eax only if the listener is in outdoor
		bOffWhenLeaving=0,	-- set EAX off when leaving the area 
	},
	bInside=0,
}

--function EAXPresetArea:OnSave(stm)
	--WriteToStream(stm, self.Properties);
--end

--function EAXPresetArea:OnLoad(stm)
	--self.Properties=ReadFromStream(stm);
--end

function EAXPresetArea:EnableEAX()
	local Preset=EAXPresetDB[self.Properties.eaxpresetEAXPreset];
	local Flags=0;

--	if (self.Properties.bLIndoorOnly~=0) then
--		Flags=SOUND_INDOOR;
--	elseif (self.Properties.bLOutdoorOnly~=0) then
--		Flags=SOUND_OUTDOOR;
--	end

	if (Preset) then
		System:Log("Using EAX-Preset "..self.Properties.eaxpresetEAXPreset);
		Sound:SetEaxEnvironment(Preset, Flags);
	else
		System:Warning( "EAX-Preset "..self.Properties.eaxpresetEAXPreset.." not defined ! Using default params...");
		Sound:SetEaxEnvironment(0, Flags);
	end
end

function EAXPresetArea:OnPropertyChange()
	if (self.bInside~=0) then
		self:EnableEAX();
	end
end

function EAXPresetArea:CliSrv_OnInit()
	self:NetPresent(nil);
	self:EnableUpdate(0);
	if (self.Initialized) then
		return
	end	
	self:RegisterState("Inactive");
	self:RegisterState("Active");
	self:GotoState("Inactive");
	self.Initialized=1;
end

function EAXPresetArea:OnShutDown()
end

function EAXPresetArea:Client_Inactive_OnEnterArea( player,areaId )
	System:Log("Entering EAX-Area "..areaId);
	--System:Log("Set EAX Environment "..self.Properties.nEAXEnvironment);
--	if (self.Properties.nEAXEnvironment>0) then
--		Sound:SetEaxEnvironment(self.Properties.nEAXEnvironment);
--	else	
	self:EnableEAX();
--	end
	self:GotoState("Active");
	self.bInside=1;
end

function EAXPresetArea:Client_Active_OnLeaveArea( player,areaId )
	System:Log("Leaving EAX-Area "..areaId);
	-- disable eax, choosing OFF preset	
	--System:Log("Set EAX Environment 0");
	--if( self.Properties.EaxReverbProperties~=0 ) then
	--	Sound:SetEaxEnvironment(0);
	--end		
	if (self.Properties.bOffWhenLeaving==1) then
		System:Log("EAX OFF");
		Sound:SetEaxEnvironment(0);
	end
	self:GotoState("Inactive");
	self.bInside=0;
end

--function EAXPresetArea:Client_Active_OnProceedFadeArea( player,areaId,fadeCoeff )
--end

	----------------------------------------------------------------------------------------
function EAXPresetArea:OnMove()
--	local newInsidePos = self:UpdateInSector(self.nBuilding,	self.nSector );
--	self.nBuilding = newInsidePos.x;
--	self.nSector = newInsidePos.y;
end


EAXPresetArea.Server={
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

EAXPresetArea.Client={
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
	
		OnEnterArea=EAXPresetArea.Client_Inactive_OnEnterArea,
		OnMove=EAXPresetArea.OnMove,
--		OnMove=EAXPresetArea.Client.OnMove,		
	},
	Active={
		OnBeginState=function(self)
--System:Log("Entering ACTIVE");		
		--	System:Log("SetTimer");
--			self:SetTimer(200);
		end,
		OnMove=EAXPresetArea.OnMove,
--		OnProceedFadeArea=EAXPresetArea.Client_Active_OnProceedFadeArea,
		OnLeaveArea=EAXPresetArea.Client_Active_OnLeaveArea,
		OnEndState=function(self)
--			System:Log("KillTimer");
--			self:KillTimer();
		end,
	},
}
