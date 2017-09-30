-- AI_BoredManager
-- version 1.0 Amanda 2002-10-21
--
-- look for an anchor appropriate to the AI type within specified range, 
-- if find an anchor return identifying string, anchor type and signal otherwise return nil
-- for bored AI this can be used to signal anchor appropriate behavior


AI_BoredManager = {

	-- this table fills automatically when new idles are added in AnimIdles.lua	
	ASTable = {},

}


function AI_BoredManager:FindSomethingToDO(entity,range)
	local NumEntries;
	NumEntries = count(self.ASTable);
	if (NumEntries==0) then
		do return end;
	end

	self.SelectedSignal=nil;
	local maxpriority = -1;
	for name,table in self.ASTable do 
		local process = 1;
		if (table.SPECIAL_AI_ONLY and entity.Properties.special) then
			if (entity.Properties.special==0) then
				process = 0;
			end
		end

		if (process==1) then
			local foundObject = AI:FindObjectOfType(entity.id,range,table.anchorType);
			if (foundObject) then
				if (table.priority > maxpriority) then
					maxpriority = table.priority;
					self.SelectedSignal = table;
				  	--self.SelectedSignal.tag = 1;
					return self.SelectedSignal;
				end
			end
		end
		
	end

--	for name,table in self.ASTable do 
--		table.tag = 0;
--	end
		
	return nil;	
end

