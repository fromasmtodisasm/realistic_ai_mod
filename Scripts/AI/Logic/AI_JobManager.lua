-- AI_JobManager
-- version 1.0 Amanda 2002-12-03
--
-- look for an anchor appropriate to the parent job that is called from eg. check apparatus will look for buttons, levers, microscope etc.
-- data entry will look for writing, typing or reading magazine.


AI_JobManager = {
	-- define values for AI_Type
	AIJob_CHECK_APPARATUS = 1,
	AIJob_DATA_ENTRY = 2,
}

AI_JobManager.options = {
		[AI_JobManager.AIJob_CHECK_APPARATUS] = {
			{anchorType = AIAnchor.AIANCHOR_PULL, signal = "PullLever", tag = 0, probability =250}, 
			 {anchorType = AIAnchor.AIANCHOR_PUSHBUTTON, signal = "PushButton", tag = 0, probability = 250}, 
			  {anchorType = AIAnchor.AIANCHOR_MICROSCOPE, signal = "UseMicroscope", tag = 0, probability = 250}, 
			   {anchorType = AIAnchor.AIANCHOR_BEAKER, signal = "UseBeaker", tag = 0, probability = 250}, 
		},
		[AI_JobManager.AIJob_DATA_ENTRY] = {
			{anchorType = AIAnchor.AIANCHOR_SIT_WRITE, signal = "SitWrite", tag = 0, probability = 500}, 
			 {anchorType = AIAnchor.AIANCHOR_SIT_TYPE, signal = "SitType", tag = 0, probability = 500}, 
		},
}
function AI_JobManager:FindAnchor(entity,AI_Type,range)
	--set default values
	local foundObject = nil;
	local option = {};
	local idx = 0;
	entity.AI_TagCount = 0;
	
	--check valid AI_type
	if (self.options[AI_Type]) then
	    local countOptions = (getn(self.options[AI_Type]));
	    self:ResetTags(AI_Type);
	
	    -- take weighted random anchor option for this AI type, tag options that return not found
	    -- continue until you have tried all available options
 	    while ((foundObject == nil) and (entity.AI_TagCount < countOptions)) do
 	    	 
 	    	idx = self:WeightedChoice(AI_Type);
 	    	if (idx) then    		
 	    		option = self.options[AI_Type][idx];
 	    		foundObject = AI:FindObjectOfType(entity.id,range,option.anchorType);
 	    		if (foundObject == nil) then
  	    			option.tag = 1;
 	    			entity.AI_TagCount = entity.AI_TagCount + 1; 
 	    		end
 	    	end
 	    end
 	    
 	    if (foundObject) then
 	    	return {found = foundObject, anchorType = option.anchorType, signal = option.signal};
 	    else
 	    	return nil;
 	    end
 	else
 	    System:LogToConsole("++++++++++++++++++++++++There are no Job behaviours defined for this AI type [".. AI_Type .."] name ["..entity:GetName() .."]");
 	    return nil;
 	end
end

function AI_JobManager:ResetTags(AI_Type)
	for index,value in self.options[AI_Type] do
		value.tag = 0;
	end
end

function AI_JobManager:WeightedChoice(AI_Type)
-- choose option based on probability

	local total = 0;
	local rnd = random(1,1000);
	local found = nil;
	local endRange = 0;

	for index, value in self.options[AI_Type] do
		-- check that option has not already been tried
		if (value.tag == 0) then
			endRange = total + value.probability;
			if ((rnd > total) and (rnd <= endRange)) then
				found = index;
				break;
			end
			total = endRange;
		end		
	end 

	return found;
end