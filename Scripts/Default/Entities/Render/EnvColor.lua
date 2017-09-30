EnvColor = {
	type = "EnvColorController",
	Properties = {	
		clrEnvColor={0.0,0.0,0.0},
		clrAmbientColor={0.0,0.0,0.0},
		
		bUseEnvColor=1,
		bUseAmbientColor=0,
		
		fFadeTime = 1,--used only when the fog is triggered manually, with activate/deactivate events.
		},
	Editor={
		Model="Objects/Editor/T.cgf",
	},
	
	outsideEnvColor = {0.0,0.0,0.0},
	outsideAmbientColor = {0.0,0.0,0.0},
	occupied = 0,
	
	lasttime = 0,
}


function EnvColor:OnInit()
	self:OnReset();
end

function EnvColor:OnPropertyChange()
	self:OnReset();
end

function EnvColor:OnReset()

end
-----------------------------------------------------------------------------
--	fade: 0-out 1-in
function EnvColor:OnProceedFadeArea( player,areaId,fadeCoeff )

--System.LogToConsole("--> Fade Proceed "..areaId.." FadeIS "..fadeCoeff);
--	System.SetViewDistance(1200);

--	if(player ~= _localplayer) then
--		return
--	end	

--System.LogToConsole("-->FadeIS "..fadeCoeff.." "..self.outsideColor[1].." "..self.outsideColor[2].." "..self.outsideColor[3]);
--System.LogToConsole("--> "..self.Properties.clrColor[1].." "..self.Properties.clrColor[2].." "..self.Properties.clrColor[3]);
--local	cCoeff = sqrt( fadeCoeff );
--	fadeCoeff = cCoeff

	self:FadeColor(fadeCoeff);

	--if (self.Properties.bUseEnvColor==1) then
	--	System:SetWorldColor(LerpColors(self.outsideEnvColor, self.Properties.clrEnvColor, fadeCoeff));
	--end

	--if (self.Properties.bUseAmbientColor==1) then
	--	System:SetOutdoorAmbientColor(LerpColors(self.outsideAmbientColor, self.Properties.clrAmbientColor, fadeCoeff));
	--end
end

function EnvColor:ResetValues()
	
	if (self.Properties.bUseEnvColor==1) then
		System:SetWorldColor(self.outsideEnvColor);
	end
	
	if (self.Properties.bUseAmbientColor==1) then
		System:SetOutdoorAmbientColor(self.outsideAmbientColor);
	end
end

-----------------------------------------------------------------------------
function EnvColor:OnEnterArea( player,areaId )

--System.LogToConsole("--> Entering EnvColor Area "..areaId.." "..self.Properties.clrColor[1].." "..self.Properties.clrColor[2].." "..self.Properties.clrColor[3]);

--	if(player ~= _localplayer) then
--		return
--	end	
	if(self.occupied == 1) then return end
	
	if (self.Properties.bUseEnvColor==1) then
		self.outsideEnvColor = System:GetWorldColor();
	end
	
	if (self.Properties.bUseAmbientColor==1) then
		self.outsideAmbientColor = System:GetOutdoorAmbientColor();
	end
		
	self.occupied = 1;
end

-----------------------------------------------------------------------------
function EnvColor:OnLeaveArea( player,areaId )

--System.LogToConsole("--> Leaving Fog Area "..areaId);

--	if(player ~= _localplayer) then
--		return
--	end	
	
	self:ResetValues();
	
	self.occupied = 0;
end
-----------------------------------------------------------------------------
function EnvColor:OnShutDown()
end

function EnvColor:Event_Enable( sender )
		
	if(self.occupied == 0 ) then
		
		if (self.fadeamt and self.fadeamt<1) then
			self:ResetValues();
		end
		
		self:OnEnterArea( );
		
		self.fadeamt = 0;
		self.lasttime = _time;
		self.exitfrom = nil;
	end	
	
	self:SetTimer(1);
	
	BroadcastEvent( self,"Enable" );
end

function EnvColor:Event_Disable( sender )
		
	if(self.occupied == 1 ) then
		
		--self:OnLeaveArea( );
		self.occupied = 0;
		
		self.fadeamt = 0;
		self.lasttime = _time;
		self.exitfrom = 1;
	end	
	
	self:SetTimer(1);
	
	BroadcastEvent( self,"Disable" );
end

function EnvColor:OnTimer()

	--System:Log("Ontimer ");

	self:SetTimer(1);
	
	if (self.fadeamt) then
	
		local delta = _time - self.lasttime;
		self.lasttime = _time;
	
		self.fadeamt = self.fadeamt + (delta / self.Properties.fFadeTime);
	
		if (self.fadeamt>=1) then
			
			self.fadeamt = 1;
			self:SetTimer(0);
		end
		
		----------------------------------------------
		--fade	
		local fadeCoeff = self.fadeamt;
		
		if (self.exitfrom) then
			fadeCoeff = 1 - fadeCoeff;	
		end
		
		fadeCoeff = sqrt( fadeCoeff );
		fadeCoeff = sqrt( fadeCoeff );
	
		self:FadeColor(fadeCoeff);
		--self:OnProceedFadeArea( nil,0,self.fadeamt );
	else
		self:SetTimer(0);
	end
end

function EnvColor:FadeColor(fadeCoeff)

        if (self.Properties.bUseEnvColor==1) then
		System:SetWorldColor(LerpColors(self.outsideEnvColor, self.Properties.clrEnvColor, fadeCoeff));
	end
	
	if (self.Properties.bUseAmbientColor==1) then
		System:SetOutdoorAmbientColor(LerpColors(self.outsideAmbientColor, self.Properties.clrAmbientColor, fadeCoeff));
	end
end
