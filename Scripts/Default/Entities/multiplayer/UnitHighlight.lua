-- used to highlight friendly units in team muliplayer

UnitHighlight = {
	idPlayerEntityId=nil,					--
}

-------------------------------------------------------
function UnitHighlight:OnInit()
	self:LoadObject( "Objects/multiplayer/teamSign/teamsign.cgf", 0, 1 );		-- slot 0, scale 1

	self:SetViewDistUnlimited();		-- do not fade out object - no matter how far away it is
	self:NetPresent(nil);
end

-------------------------------------------------------
function UnitHighlight:OnShutDown()
	if Server and self.idPlayerEntityId then
		Server:RemoveEntity(self.idUnitHighlight);
			
		local player = System:GetEntity(self.idPlayerEntityId);
		
		if player then
			player.idUnitHighlight=nil;
		end
		
		self.idPlayerEntityId=nil;
	end
end


-------------------------------------------------------
function UnitHighlight:OnUpdate( DeltaTime )
	if not self.idPlayerEntityId then
		return																-- player to follow was not set yet
	end
	
	-- update might be one frame behind

	local player = System:GetEntity(self.idPlayerEntityId);
	
	if player then
	
		local iVisible=1;
	
		if _localplayer then
			if _localplayer.id==player.id then
				iVisible = 0;
			elseif Game:GetEntityTeam(_localplayer.id)~=Game:GetEntityTeam(self.idPlayerEntityId) then
				iVisible = 0;
			end
		end

		local pos=new(player:GetPos());
		pos.z = pos.z + 2.5;

		self:SetPos(pos);
		self:DrawObject( 0, iVisible );		-- slot 0
	end
end


--------------------------------------------------------------------------------------------------------
-- get "follow this player" command
function UnitHighlight:OnRemoteEffect(toktable, pos, normal, userbyte)
	if count(toktable)==2 then
	 	self.idPlayerEntityId=tonumber(toktable[2]);
	end
end