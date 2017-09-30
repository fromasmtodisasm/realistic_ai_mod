-- Mutant Idle Manager
-- Created by Amanda 2003 -01-17
--------------------------

Mutant_IdleManager = 	{
	
		AnimationTable = 	{ 
				Bezerker = {
					{Name = "idle_look", Tag = 0},
					{Name = "idle_beatchest", Tag = 0},
					{Name = "idle_eatbug", Tag = 0},
				},
				Abberation = {
					{Name = "idle_chimp", Tag = 0},
					{Name = "idle_itchback", Tag = 0},
					{Name = "idle_beatchest", Tag = 0},
					{Name = "idle_alert", Tag = 0},
				},
				MutantScout = {
					{Name = "idle_look", Tag = 0},	
					{Name = "idle_itch", Tag = 0},	
					{Name = "idle_itch_head", Tag = 0},				
				},
				MutantRear = {
					{Name = "idle_lookaround", Tag = 0},
					{Name = "idle_lookaround2", Tag = 0},
					{Name = "idle_sharpen_blade", Tag = 0},
				},
				MutantCover = {
					{Name = "idle_fidget", Tag = 0},
					{Name = "idle_frustrated", Tag = 0},
					{Name = "idle_lookaround", Tag = 0},
					{Name = "idle_heardsomething", Tag = 0},
					{Name = "idle_catchbug", Tag = 0},
					{Name = "idle_stretch", Tag = 0},
				},
				Merc = {
					{Name = "_kickground01", Tag = 0},
					{Name = "_kickground02", Tag = 0},
					{Name = "_idle_leanright", Tag = 0},
					{Name = "_idle_leanleft", Tag = 0},
					{Name = "_itchbutt", Tag = 0},
					{Name = "_checkwatch1", Tag = 0},
					{Name = "_checkwatch2", Tag = 0},
					{Name = "_chinrub", Tag = 0},
					{Name = "_foottap1", Tag = 0},
					{Name = "_foottap2", Tag = 0},
					{Name = "_headscratch1", Tag = 0},
					{Name = "_headscratch2", Tag = 0},
					{Name = "_humming", Tag = 0},
					{Name = "_insectswat1", Tag = 0},
					{Name = "_insectswat2", Tag = 0},
					{Name = "_kneecheck", Tag = 0},
					{Name = "_laces", Tag = 0},
					{Name = "_legbob", Tag = 0},
					{Name = "_massageneck", Tag = 0},
					{Name = "_shouldershrug", Tag = 0},
					{Name = "_yawn", Tag = 0},
				},
				
		},
		GlobalTag	= 0,
		AddVal		= 0,
		Animation 	= "",
		
}	
				
	
function Mutant_IdleManager:GetIdle(entity)
	local Character = entity.Properties.aicharacter_character;
	if (self.AnimationTable[Character] == nil) then
		Character = "Merc";
	end
--	System:Log("\001 [".. entity:GetName().."]<<<<<<<<<Character["..Character .."]");
		local count = getn(self.AnimationTable[Character]);
		local XRandom = random(1,count);
		local XVal = 0;
		self.AddVal = self.AddVal + 1; 
		if (self.AddVal > count ) then
			self.GlobalTag = self.GlobalTag +1;
			self.AddVal=1;
		end
		if (random(1,2) == 1) then
			while (self.AnimationTable[Character][XRandom].Tag > self.GlobalTag) do
				XRandom = XRandom + 1;
				if (XRandom > count) then
					XRandom = 1;
				end
			end				
		else
			while (self.AnimationTable[Character][XRandom].Tag > self.GlobalTag) do
				XRandom = XRandom - 1;
				if (XRandom < 1) then
					XRandom = count;
				end
			end				
		end
		self.AnimationTable[Character][XRandom].Tag = self.GlobalTag + 1; 
--		System:LogToConsole("\001[".. Character.."]Mutant_IdleManager<<<<<<<<animation["..self.AnimationTable[Character][XRandom].Name .."]");
--	
		local duration = entity:GetAnimationLength(self.AnimationTable[Character][XRandom].Name);
		if (duration == nil) then 
			duration = 2;
		end
		return {Name = self.AnimationTable[Character][XRandom].Name,duration = duration};

end				
	
	
