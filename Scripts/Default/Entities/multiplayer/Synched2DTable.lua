-- 

Synched2DTable = {
	PingTable={},					-- ClientOnly [ClientID] = Ping, update when the scoreboard packet from the server comes in
}

-------------------------------------------------------
function Synched2DTable:OnInit()
-- it needs to comunicate over network so it should be NetPresent
--	self:NetPresent(nil);						
end


-------------------------------------------------------
function Synched2DTable:OnShutDown()
end


-------------------------------------------------------
function Synched2DTable:OnUpdate( DeltaTime )
end
