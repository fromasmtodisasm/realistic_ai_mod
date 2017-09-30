Script:ReloadScript( "SCRIPTS/Default/Entities/AI/NPC_x.lua");


NPC=CreateAI(NPC_x)



------------------------------------------------------------------------------------

function NPC:Event_Follow(params)
	AI:Signal(0,1,"VAL_FOLLOW",self.id)
end


function NPC:Event_Lead(params)
	AI:Signal(0,1,"VAL_LEAD",self.id)
end

