Fog = {
	type = "FogController",
	Properties = {	
		StartDist = 30,
		EndDist = 100,
		clrColor={0.5,0.6,0.5},
		xSkyStart = 250,		--	when fogEnd (EndDist) less than this - sky starts to fade 
		xSkyEnd = 150,			--  when fogEnd (EndDist) less than this - sky is faded complitly 
		
		fFadeTime = 1,--used only when the fog is triggered manually, with activate/deactivate events.
		},
	Editor={
		Model="Objects/Editor/T.cgf",
	},
	
	outsideStart = 0,
	outsideEnd = 0,
	outsideColor = {0.0,0.0,0.0},
	
	curStart = 0,
	curEnd = 0,
	curColor = {0.0,0.0,0.0},
	
	doStart = 0,
	doEnd = 0,
	doColor = 0,
	
	occupied = 0,
	
	lasttime = 0,
}


function Fog:OnInit()
	self:OnReset();
	
	self.outsideStart = System:GetFogStart();
	self.outsideEnd = System:GetFogEnd();
	self.outsideColor = System:GetFogColor();
end

function Fog:OnPropertyChange()
	self:OnReset();
end

function Fog:OnReset()

	if(self.occupied == 1 ) then
		self:OnLeaveArea( );
	end	

	if(self.Properties.StartDist ~= 0) then
		self.doStart = 1;
	end
	if(self.Properties.EndDist ~= 0) then
		self.doEnd = 1;
	end
	if(self.Properties.clrColor[1] ~= 0 or self.Properties.clrColor[2] ~= 0 or self.Properties.clrColor[3] ~= 0 ) then
		self.doColor = 1;
	end
	
	self.occupied = 0;
	
	self:SetTimer(0);
end
-----------------------------------------------------------------------------
--	fade: 0-out 1-in
function Fog:OnProceedFadeArea( player,areaId,fadeCoeff )

--System.LogToConsole("--> Fade Proceed "..areaId.." FadeIS "..fadeCoeff);
--	System.SetViewDistance(1200);

--	if(player ~= _localplayer) then
--		return
--	end	

--System.LogToConsole("--> Fade Proceed MY");
--System.LogToConsole("-->FadeIS "..fadeCoeff.." "..self.Properties.EndDist.." "..Lerp(self.outsideEnd, self.Properties.EndDist, fadeCoeff));

	fadeCoeff = sqrt( fadeCoeff );
	fadeCoeff = sqrt( fadeCoeff );
	
	self:FadeFog(fadeCoeff);

--	if(self.doStart==1) then
--		self.curStart = Lerp(self.outsideStart, self.Properties.StartDist, fadeCoeff);
--		System:SetFogStart(self.curStart);
--	end	
--
--	if(self.doEnd==1) then
--		self.curEnd = Lerp(self.outsideEnd, self.Properties.EndDist, fadeCoeff);
--		System:SetFogEnd(self.curEnd);
--	end	
--
--
----System.LogToConsole("--> COlor "..self.Properties.clrColor[1].." "..self.Properties.clrColor[2].." "..self.Properties.clrColor[3].." -- "..self.doColor);
----System.FogColorSet(self.Properties.clrColor);
--	if(self.doColor==1) then
--		self.curColor = LerpColors(self.outsideColor, self.Properties.clrColor, fadeCoeff);
--		System:SetFogColor(self.curColor);
--	end	
end

function Fog:ResetValues()
	
	if(self.doStart==1) then
		System:SetFogStart(self.outsideStart);
	end	
	if(self.doEnd==1) then	
		System:SetFogEnd(self.outsideEnd);
	end	
	if(self.doColor==1) then	
		System:SetFogColor(self.outsideColor);
	end	
end

-----------------------------------------------------------------------------
function Fog:OnEnterArea( player,areaId )

--System.Log("--> Entering Fog Area "..areaId.." "..self.Properties.clrColor[1].." "..self.Properties.clrColor[2].." "..self.Properties.clrColor[3]);

--	if(player ~= _localplayer) then
--		return;
--	end	
--System.LogToConsole("--> Entering Fog Area MY ");

	if(self.occupied == 1) then return end

	self.outsideStart = System:GetFogStart();
	self.outsideEnd = System:GetFogEnd();
	self.outsideColor = System:GetFogColor();

	System:SetSkyFade( self.Properties.xSkyStart, self.Properties.xSkyEnd );

	self.occupied = 1;	
end

-----------------------------------------------------------------------------
function Fog:OnLeaveArea( player,areaId )

--System.Log("--> Leaving Fog Area "..areaId);

--	if(player ~= _localplayer) then
--		return;
--	end	
	
--System.LogToConsole("--> Leaving Fog Area MY ");	

	self:ResetValues();
	
	self.occupied = 0;
end
-----------------------------------------------------------------------------
function Fog:OnShutDown()
end

function Fog:Event_Enable( sender )
		
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

function Fog:Event_Disable( sender )
		
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

function Fog:OnTimer()

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
	
		self:FadeFog(fadeCoeff);
		--self:OnProceedFadeArea( nil,0,self.fadeamt );
	else
		self:SetTimer(0);
	end
end

function Fog:FadeFog(fadeCoeff)

	if(self.doStart==1) then
		self.curStart = Lerp(self.outsideStart, self.Properties.StartDist, fadeCoeff);
		System:SetFogStart(self.curStart);
	end	

	if(self.doEnd==1) then
		self.curEnd = Lerp(self.outsideEnd, self.Properties.EndDist, fadeCoeff);
		System:SetFogEnd(self.curEnd);
	end	

	if(self.doColor==1) then
		self.curColor = LerpColors(self.outsideColor, self.Properties.clrColor, fadeCoeff);
		System:SetFogColor(self.curColor);
	end	
end