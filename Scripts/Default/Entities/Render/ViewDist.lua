ViewDist = {
	type = "ViewDistController",
	Properties = {	
		MaxViewDist = 25,
		fFadeTime = 1,
		},
	Editor={
		Model="Objects/Editor/T.cgf",
	},
	
	outsideViewDist = 0,
	occupied = 0,
}


function ViewDist:OnInit()

	self:OnReset();

	self.outsideViewDist = System:ViewDistanceGet( );
end

function ViewDist:OnPropertyChange()
	self:OnReset();
end

function ViewDist:OnReset()

	if(self.occupied == 1 ) then
		self:OnLeaveArea( );
	end	
		
	self.occupied = 0;
	
	self:SetTimer(0);
end
-----------------------------------------------------------------------------
--	fade: 0-out 1-in
function ViewDist:OnProceedFadeArea( player,areaId,fadeCoeff )

--System.LogToConsole("--> FadeIS "..fadeCoeff.." vDist "..Lerp(self.outsideViewDist, self.Properties.MaxViewDist, Math.Sqrt( fadeCoeff )));
--	System.SetViewDistance(1200);

--	if(player ~= _localplayer) then
--		return
--	end	

	self:FadeViewDist(fadeCoeff);

--local	cCoeff = sqrt( fadeCoeff );
--	fadeCoeff = cCoeff
--	System:ViewDistanceSet( Lerp(self.outsideViewDist, self.Properties.MaxViewDist, fadeCoeff) );
end

function ViewDist:ResetValues()

	System:ViewDistanceSet( self.outsideViewDist);
end

-----------------------------------------------------------------------------
function ViewDist:OnEnterArea( player,areaId )

--	if(player ~= _localplayer) then
--		return
--	end	

--System.LogToConsole("--> Entering ViewDist Area "..areaId);

	if(self.occupied == 1) then return end
	
	self.outsideViewDist = System:ViewDistanceGet( );
	self.occupied = 1;
end

-----------------------------------------------------------------------------
function ViewDist:OnLeaveArea( player,areaId )

--System.LogToConsole("--> Leaving ViewDist Area "..areaId);

--	if(player ~= _localplayer) then
--		return
--	end	
	
	self:ResetValues();
	self.occupied = 0;
end
-----------------------------------------------------------------------------
function ViewDist:OnShutDown()
end

-----------------------------------------------------------------------------
function ViewDist:Event_Enable( sender )
		
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

function ViewDist:Event_Disable( sender )
		
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

function ViewDist:OnTimer()

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
		
		self:FadeViewDist(fadeCoeff);
		--self:OnProceedFadeArea( nil,0,self.fadeamt );
	else
		self:SetTimer(0);
	end
end

function ViewDist:FadeViewDist(fadeCoeff)

	local cCoeff = sqrt( fadeCoeff );
	fadeCoeff = cCoeff;
	
	System:ViewDistanceSet( Lerp(self.outsideViewDist, self.Properties.MaxViewDist, fadeCoeff) );
end