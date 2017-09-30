ViewDist = {
	type = "ViewDistController",
	Properties = {	
		MaxViewDist = 25,
		},
	Editor={
		Model="Objects/Editor/T.cgf",
	},
	
	outsideViewDist = 0,
	occupied = 0,
}


function ViewDist:OnInit()
end
-----------------------------------------------------------------------------
--	fade: 0-out 1-in
function ViewDist:OnProceedFadeArea( player,areaId,fadeCoeff )

--System.LogToConsole("--> FadeIS "..fadeCoeff.." vDist "..Lerp(self.outsideViewDist, self.Properties.MaxViewDist, Math.Sqrt( fadeCoeff )));
--	System.SetViewDistance(1200);

--	if(player ~= _localplayer) then
--		return
--	end	

local	cCoeff = sqrt( fadeCoeff );
	fadeCoeff = cCoeff
	System:ViewDistanceSet( Lerp(self.outsideViewDist, self.Properties.MaxViewDist, fadeCoeff) );
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
	
	System:ViewDistanceSet( self.outsideViewDist);
	self.occupied = 0;
end
-----------------------------------------------------------------------------
function ViewDist:OnShutDown()
end