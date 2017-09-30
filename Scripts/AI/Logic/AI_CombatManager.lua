-- AI_CombatManager
-- version 1.0 Amanda 2002-11-18 based on AI_BoredManager
--
-- look for an anchor appropriate to the AI type within specified range, 
-- if find an anchor return identifying string, anchor type and signal otherwise return nil
-- for Combat AI this can be used to signal anchor appropriate behavior
--
-- parameters 
--	enity.id, AI type(constant), range(int)
-- returns 
--	found(string name of anchor), anchorType(constant), signal(string name of goal pipe to call)
--------------------------------------------------------------------------------------------------------------------------------------------
--eg.
--	local combatAnchor = AI_CombatManager:FindAnchor(entity,AI_CombatManager.AICOMBAT_SCIENTIST,20);
--	if (combatAnchor) then
--		entity:SelectPipe(0,combatAnchor.signal,combatAnchor.found);
--	end
--------------------------------------------------------------------------------------------------------------------------------------------

AI_CombatManager = {
	-- define values for AI_Type
	AICOMBAT_GUARD = 1,
	AICOMBAT_SWAT = 2,
	AICOMBAT_SCIENTIST = 3,
}
--anchor may have one or more associated signals
AI_CombatManager.options = {
	[AI_CombatManager.AICOMBAT_SWAT ] = {

		 {anchorType = AIAnchor.AIANCHOR_SHOOTSPOT,  tag = 0, probability = 160, signal = "Shootspot",}, 
		 --standing attack to the left
		 {anchorType = AIAnchor.AIANCHOR_LEFT, tag = 0, probability = 140,
		 	manner = {
				{signal = "swat_comeout_left",  probability = 500}, 
				{signal = "swat_comeout_rollleft",  probability = 300}, 
				{signal = "swat_kneelattack",  probability = 200}, 
				--{signal = "throw_grenade",  probability = 200}, 
				},
		}, 
		--standing attack to the right
		 {anchorType = AIAnchor.AIANCHOR_RIGHT, tag = 0, probability = 140,
		 	manner = {
				{signal = "swat_comeout_right",  probability = 500}, 
				{signal = "swat_comeout_rollright",  probability = 300}, 
				{signal = "swat_kneelattack",  probability = 200}, 
				--{signal = "throw_grenade",  probability = 200}, 
				},
		}, 
		--standing attack to the left in a confined space eg. too tight to roll
		{anchorType = AIAnchor.AIANCHOR_LEFT_TIGHT, tag = 0, probability = 140,
		 	manner = {
				{signal = "ComeOut_Left",  probability = 500}, 
				},
		}, 
		--standing attack to the right in a confined space
		 {anchorType = AIAnchor.AIANCHOR_RIGHT_TIGHT, tag = 0, probability = 140,
		 	manner = {
				{signal = "ComeOut_Right",  probability = 500}, 
				},
		}, 	
		--attack from crouch to the left		
		{anchorType = AIAnchor.AIANCHOR_CROUCH_LEFT, tag = 0, probability = 140,
			manner = {
				--{signal = "Crouch_LeanLeft",  probability = 250}, 
				{signal = "swat_comeout_rollleft",  probability = 200}, 
				{signal = "swat_crouchcomeout_left",  probability = 400}, 
				{signal = "swat_standup",  probability = 400}, 
				--{signal = "Crouch_ThrowGrenade",  probability = 300}, 
				},
		},
		--attack from crouch to the right
		{anchorType = AIAnchor.AIANCHOR_CROUCH_RIGHT, tag = 0, probability = 140,
			manner = {
				{signal = "swat_comeout_rollright",  probability = 200}, 
				{signal = "swat_crouchcomeout_right",  probability = 400}, 
				{signal = "swat_standup",  probability = 400}, 
				--{signal = "Crouch_ThrowGrenade",  probability = 300}, 
				},
		},
	}, 
	[AI_CombatManager.AICOMBAT_SCIENTIST ] = {
 		{anchorType = AIAnchor.AIANCHOR_GUN_RACK,  tag = 0, probability = 100, signal = "scientist_grabGun",}, 
		 {anchorType = AIAnchor.AIANCHOR_PUSH_ALARM,  tag = 0, probability = 350, signal = "scientist_PushAlarm",}, 
		 {anchorType = AIAnchor.AIANCHOR_PULL_ALARM,  tag = 0, probability = 350, signal = "scientist_PullAlarm",}, 
		  {anchorType = AIAnchor.AIANCHOR_TABLE,  tag = 0, probability = 200, 
		  	manner ={ {signal = "scientist_table_crouch",  probability = 500}, 
		  	                   {signal = "scientist_table_prone",  probability = 500}, 
		  	}
		  }, 
	}
}	

function AI_CombatManager:FindAnchor(entity,AI_Type,range)

	--set default values
	local foundObject = nil;
	local option = {};
	local idx = 0;
	self.tagCount = 0;
	
	--check valid AI_type
	if (self.options[AI_Type]) then
	    local countOptions = (getn(self.options[AI_Type]));	
	    self:ResetTags(AI_Type);
	
	    -- take weighted random anchor option for this AI type, tag options that return not found
	    -- continue until you have tried all available options
 	    while ((foundObject == nil) and (self.tagCount < countOptions)) do
 	    	idx = self:WeightedChoice(AI_Type);
 	    	if (idx) then
 	    		option = self.options[AI_Type][idx];
 	    		--foundObject = AI:FindObjectOfType(entity:GetPos(),range,option.anchorType);
 	    		foundObject = AI:FindObjectOfType(entity.id,range,option.anchorType);
 	    		if (foundObject == nil) then
  	    			option.tag = 1;
 	    			self.tagCount = self.tagCount + 1; 
 	    		end
 	    	end
 	    end
 	    
 	    if (foundObject) then 
 	    	-- if there is only one signal send that otherwise choose from set of options
 	    	if (option.signal) then
 	    		return {found = foundObject, anchorType = option.anchorType, signal = option.signal};
 	    	else
 	    		idx = self:ChooseManner(option.manner);
 	    		if (idx) then
 	    			return {found = foundObject, anchorType = option.anchorType, signal = option.manner[idx].signal};	
 	    		end
 		end
 	
 	    else
 	    	return nil;
 	    end
 	else
 	    System:Warning("["..entity:GetName().."] AI_CombatManager+++++++++++++No behaviours have been defined for this AI type");
 	    return nil;
 	end
end

function AI_CombatManager:ResetTags(AI_Type)
	for index,value in self.options[AI_Type] do
		value.tag = 0;
	end
end

function AI_CombatManager:WeightedChoice(AI_Type)
-- choose option based on probability

	local total = 0;
	local rnd = random(1,1000);
	
	for index, value in self.options[AI_Type] do
		-- check that option has not already been tried
		if (value.tag == 0) then
			total = total + value.probability;
			if (rnd < total) then
				return  index;
			end
		end		
	end 

	--return found;
	return nil;
end


function AI_CombatManager:ChooseManner(manner)
-- choose manner based on probability

	local total = 0;
	local rnd = random(1,1000);
	
	for index, value in manner do
		total = total + value.probability;
		if (rnd < total) then
		 	return index;
		end	
	end 

	return nil;
end