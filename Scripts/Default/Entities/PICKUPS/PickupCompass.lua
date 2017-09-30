Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local funcPick=function (self,collider)

	Hud.DisplayControl.bShowRadar = 1;

	self:NotifyMessage("@compass1",collider,14);
	self:NotifyMessage("@compass2",collider,14);
	--self:NotifyMessage("@compass3",collider,14);

	return 1;		
end

local params={
	func=funcPick,
	model="OBJECTS/Pickups/misc/player_compass.cgf",
	default_amount=1,
	sound="sounds/items/generic_pickup.wav",
	modelchoosable=nil,
	soundchoosable=nil,
	floating_icon="Objects/Pickups/binoculars/binocular_icon.cga"
}

PickupCompass=CreateCustomPickup(params);
