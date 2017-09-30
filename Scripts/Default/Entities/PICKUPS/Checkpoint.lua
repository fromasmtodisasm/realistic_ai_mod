Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local funcPick=function (self,collider)
	printf("CHECKPOINT REACHED: "..self.Properties.nId);
	self:EnableSave(nil);

	_LastCheckPPos = new (self:GetPos());
	_LastCheckPAngles = new(self:GetAngles());
	Game:TouchCheckPoint(self.Properties.nId, _LastCheckPPos, _LastCheckPAngles);

	return 1;
end

local params={
	func=funcPick,
	model="objects/pickups/misc/checkpoint.cgf",
	default_amount=0,
	sound="sounds/waypoint/waypoint1.wav",
	modelchoosable=nil,
	soundchoosable=nil
}

Checkpoint=CreateCustomPickup(params);
Checkpoint.Properties.Amount=nil;
Checkpoint.Properties.RespawnTime=0;
Checkpoint.Properties.nId=0;

-- still respawn
-- current checkpoint is saved in the old state
-- renders own player
-- ammo count and other vars
