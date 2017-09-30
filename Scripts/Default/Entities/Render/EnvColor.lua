EnvColor = {
	type = "EnvColorController",
	Properties = {	
		clrEnvColor={0.0,0.0,0.0},
		clrAmbientColor={0.0,0.0,0.0},
		
		bUseEnvColor=1,
		bUseAmbientColor=0,
		},
	Editor={
		Model="Objects/Editor/T.cgf",
	},
	
	outsideEnvColor = {0.0,0.0,0.0},
	outsideAmbientColor = {0.0,0.0,0.0},
	occupied = 0,
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

	if (self.Properties.bUseEnvColor==1) then
		System:SetWorldColor(LerpColors(self.outsideEnvColor, self.Properties.clrEnvColor, fadeCoeff));
	end
	
	if (self.Properties.bUseAmbientColor==1) then
		System:SetOutdoorAmbientColor(LerpColors(self.outsideAmbientColor, self.Properties.clrAmbientColor, fadeCoeff));
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
	
	if (self.Properties.bUseEnvColor==1) then
		System:SetWorldColor(self.outsideEnvColor);
	end
	
	if (self.Properties.bUseAmbientColor==1) then
		System:SetOutdoorAmbientColor(self.outsideAmbientColor);
	end
	
	self.occupied = 0;
end
-----------------------------------------------------------------------------
function EnvColor:OnShutDown()
end