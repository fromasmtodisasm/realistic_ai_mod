Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local funcPick=function (self,collider)

	if ((not self.lasttime) or (_time>(self.lasttime+6))) then		
		local serverSlot = Server:GetServerSlotByEntityId(collider.id);
		if (serverSlot) then
			serverSlot:SendCommand("GI B");
		end
		
		self.lasttime=_time;
	end
	
	if (collider.cnt.has_binoculars == 1) then
		return nil;
	end
		
--	self:NotifyMessage("@bino1",collider,10);
--	self:NotifyMessage("@bino2",collider,10);
--	self:NotifyMessage("@bino3",collider,10);
--	self:NotifyMessage("@bino4",collider,10);

--	self:NotifyMessage("You picked up binoculars! (Press 'B' to use)",collider,5);
--	self:NotifyMessage('Zoom in/out with the mousewheel (or + - keys)',collider,5);
--	self:NotifyMessage('The audio enhancement feature of the binocular allows',collider,5);
--	self:NotifyMessage('you to listen to enemies, even if they are far away',collider,5);

	return 1;		
end

local params={
	func=funcPick,
	model="Objects/pickups/binoculars/binocular.cgf",
	default_amount=1,
	sound="sounds/items/generic_pickup.wav",
	modelchoosable=nil,
	soundchoosable=nil,
	floating_icon="Objects/Pickups/binoculars/binocular_icon.cga",
	objectpos = {x=0, y=0, z=-0.07},
}

PickupBinoculars=CreateCustomPickup(params);
