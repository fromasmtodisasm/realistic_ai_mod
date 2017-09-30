Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local funcPick=function (self,collider)


	if ((not self.lasttime) or (_time>(self.lasttime+6))) then
		local serverSlot = Server:GetServerSlotByEntityId(collider.id);
		if (serverSlot) then
			serverSlot:SendCommand("GI F");
		end
		
		self.lasttime=_time;
	end
	
	--self:NotifyMessage("You picked up a flashlight! (Press 'L' to use it)",collider)
	
	if (collider.cnt.has_flashlight == 1) then
		return nil;
	end


	return 1;		
end

local params={
	func=funcPick,
	model="Objects/pickups/flashlight/flashlight.cgf",
	default_amount=1,
	sound="sounds/items/flight.wav",
	modelchoosable=nil,
	soundchoosable=nil,
	floating_icon="Objects/Pickups/flashlight/flashlight_icon.cga"
}

PickupFlashlight=CreateCustomPickup(params);
