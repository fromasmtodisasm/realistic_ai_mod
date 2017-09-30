CreatureGenerator = {

	Properties = {
		CreatureType = "MutantCover",
		maxCreatures=10,
	},

	Editor={
		Model="Objects/Editor/anchor.cgf",
	},

	currcreatures=0,
}

function CreatureGenerator:OnReset()
	self.currcreatures=0;
end


function CreatureGenerator:OnInit()
	self:OnReset();
end


function CreatureGenerator:Event_Spawn()

	if (self.currcreatures<self.Properties.maxCreatures) then

		local newentity;
		newentity = Server:SpawnEntity(self.Properties.CreatureType);
		if (newentity) then
			newentity:EnableSave(0);
			newentity:SetPos(self:GetPos());
			newentity:SetAngles(self:GetAngles());
			--System:LogToConsole("\003 CreatureGenerator spawned entity");
		else
			System:Warning( "[AI] CreatureGenerator could not spawn entity of type "..self.Properties.CreatureType);
		end

		self.currcreatures=self.currcreatures+1;

	end
end

function CreatureGenerator:OnShutDown()
end
