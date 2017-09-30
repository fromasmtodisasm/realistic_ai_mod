Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local funcPick=function (self,collider)
	if ((not self.lasttime) or (_time>(self.lasttime+6))) then
		-- set energy to max
		collider.items.heatvisiongoggles = 1;
		collider:ChangeEnergy(collider.MaxEnergy);
		
		local serverSlot = Server:GetServerSlotByEntityId(collider.id);
		if (serverSlot) then
			serverSlot:SendCommand("GI C");
		end
		
		self.lasttime=_time;
	end		
	
	return 1;		
end

local params={
	func=funcPick,
	model="Objects/pickups/heatvision/heatvision.cgf",
	default_amount=1,
	sound="sounds/items/generic_pickup.wav",
	modelchoosable=nil,
	soundchoosable=nil,
	floating_icon="Objects/Pickups/heatvision/heatvision_icon.cga",
	objectpos = {x=0, y=0, z=-0.08},
}

PickupHeatVisionGoggles=CreateCustomPickup(params);
