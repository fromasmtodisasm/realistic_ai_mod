Phoenix={
	Properties={
		fRespawnTime=0.0,			-- the time to wait until an entity is respawned
		bWithRespawnCycle=0,	-- 0/1=wait for the next respawn wave 
	},
	
	Editor={
		Model="Objects/Editor/phoenix.cgf",
	},
}

function Phoenix:OnReset()
	self.WaitingCandidates = {};
	self.Ashes = {};
end

function Phoenix:RaiseFromAshes()
	local n = getn(self.Ashes);
	
	-- reset all scheduled entities and remove them from Ashes
	if (n>0) then
		for i = n, 1, -1 do
			local ent = self.Ashes[i];
			local data = ent.PhoenixData;
			ent:SetPos(data.pos);
			ent:SetAngles(data.angles);
			ent:AwakeEnvironment();
			ent:OnReset();
			-- remove entity from Ashes
  		tremove(self.Ashes, i);
		end
	end
	
	-- assert ... Ashes should be empty at this point
end

function Phoenix:Event_Reset(sender)
	if (sender and sender.PhoenixData) then
		sender.PhoenixData.fRespawnTime = _time + self.Properties.fRespawnTime;

		-- put the sender into the list
		tinsert(self.WaitingCandidates, sender);
	end
end

Phoenix.Server={
	OnInit=function(self)
		self:OnReset();
		self:NetPresent(nil);
		self:EnableUpdate(1);
	end,
	OnUpdate=function(self, dt)
		if (self.WaitingCandidates == nil or self.Ashes == nil) then return end;
		
		local bProcess = 1;
		
		while bProcess do		
			bProcess=nil;
			for i, ent in self.WaitingCandidates do
				if (i ~= "n") then
					-- if we have consumed our time ... reset the entity
					if (ent.PhoenixData.fRespawnTime < _time) then
						-- remove the entity
						tremove(self.WaitingCandidates, i);
						--schedule entity for respawn
						tinsert(self.Ashes, ent);
						bProcess=1;
						break;
					end
				end
			end -- for
		end
		
		-- if we don't have to wait for a wave to trigger our respawn, do it now
		if (self.Properties.bWithRespawnCycle == 0) then
			self:RaiseFromAshes();
		end
	end,
}

Phoenix.Client={
	OnInit=function(self)
		self:OnReset();
	end,
	OnUpdate=function(self, dt)
	end,
}