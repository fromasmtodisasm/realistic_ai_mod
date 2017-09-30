-- Idle Manager - 
-- Created by Sten; 18092002
-- improved and made customizeable by Petar may2003
--------------------------
-- this new and improved manager maintains a list of idle animations based on the model of the entity by discovering
-- available animations and their durations 



IdleManager = 	{

		ModelTable = {},
		TagTable = {},
		CountTable = {},
	
		AnimationTable = 	{
				{Name = "_kickground01", duration = 4, Tag = 0},
				{Name = "_kickground02", duration = 4, Tag = 0},
				{Name = "_idle_leanright", duration = 4, Tag = 0},
				{Name = "_idle_leanleft", duration = 5, Tag = 0},
				{Name = "_itchbutt", duration = 2, Tag = 0},
--				{Name = "_rubneck", duration = 3, Tag = 0},
				--{Name = "_sneeze", duration = 4, Tag = 0},
				
				{Name = "_checkwatch1", duration = 2, Tag = 0},
				{Name = "_checkwatch2", duration = 3, Tag = 0},
				{Name = "_chinrub", duration = 4, Tag = 0},
				{Name = "_foottap1", duration = 3, Tag = 0},
				{Name = "_foottap2", duration = 5, Tag = 0},
				{Name = "_headscratch1", duration = 2, Tag = 0},
				{Name = "_headscratch2", duration = 3, Tag = 0},
				{Name = "_humming", duration = 5, Tag = 0},
				{Name = "_insectswat1", duration = 4, Tag = 0},
				{Name = "_insectswat2", duration = 3, Tag = 0},
				{Name = "_kneecheck", duration = 3, Tag = 0},
				{Name = "_laces", duration = 6, Tag = 0},
				{Name = "_legbob", duration = 2, Tag = 0},
				{Name = "_massageneck", duration = 3, Tag = 0},
				{Name = "_shouldershrug", duration = 4, Tag = 0},
				{Name = "_yawn", duration = 4, Tag = 0},
				
				},

		Animation 	= "",
		
}	

function IdleManager:GetIdleAnimation( entity )
	local model = entity.Properties.fileModel;
	if (model) then	

		if (self.ModelTable[model]==nil) then 
			local idleCounter = 0;
			self.ModelTable[model]={};
			local formatted_name = format("idle%02d",idleCounter);
			while (entity:GetAnimationLength(formatted_name)~=0) do
				self.ModelTable[model][idleCounter+1] = {Name = formatted_name, Tag=0 };
				idleCounter = idleCounter + 1;
				formatted_name = format("idle%02d",idleCounter);
			end
			self.TagTable[model] = 1;
			self.CountTable[model] = 0;
		end		

		return self:GetIdle(model)
	end
end
				
	
function IdleManager:GetIdle( model_name )

	local table = self.ModelTable[model_name];
	local count = getn(table);
	
	if( count < 1 ) then 
		System:Warning( "[AI] No idle ainmation for "..model_name.." add animation or change the job ");
		return nil; 
	end
	
	local XRandom = random(1,count);
	local XVal = 0;

	self.CountTable[model_name] =	self.CountTable[model_name] + 1; 

	if (self.CountTable[model_name] > count ) then
		self.TagTable[model_name] = self.TagTable[model_name] + 1;
		self.CountTable[model_name]=1;
	end

	local TableTag = self.TagTable[model_name];


	if (random(1,2) == 1) then
		while (table[XRandom].Tag == TableTag) do
			XRandom = XRandom + 1;
			if (XRandom > count) then
				XRandom = 1;
			end
		end				
	else
		while (table[XRandom].Tag == TableTag) do
			XRandom = XRandom - 1;
			if (XRandom < 1) then
				XRandom = count;
			end
		end				
	end

	table[XRandom].Tag = TableTag;
	return table[XRandom];
end				
	
	
