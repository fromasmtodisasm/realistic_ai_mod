Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local funcPick=function (self, collider, entering)

	--self:NotifyMessage("collider.cnt.armor="..collider.cnt.armor..", collider.cnt.max_armor="..collider.cnt.max_armor);

	if (BasicPlayer.HasFullArmor(collider))then
		if (entering == 1) then
			if ((not self.lasttime) or (_time>(self.lasttime+6))) then
				-- send armor cannot catch 
				local serverSlot = Server:GetServerSlotByEntityId(collider.id);
				if (serverSlot) then
					serverSlot:SendCommand("HUD P 1 -1"); -- hud, generic pick, armor, not available
				end
			
				--self:NotifyMessage("@pickup_not_possible @armor_pickup_not_possible_trail", collider);
				self.lasttime=_time;
			end
		end
		return nil;
	end	

	local amount = BasicPlayer.AddArmor(collider, self.Properties.Amount);
	
	-- send armor catch 
	local serverSlot = Server:GetServerSlotByEntityId(collider.id);
	if (serverSlot) then	
		serverSlot:SendCommand("HUD P 1 "..self.Properties.Amount); -- hud, generic pick, armor, amount
	end
	
	--self:NotifyMessage("@YouPickedUp "..self.Properties.Amount.." @UnitsOf @Armor", collider)
	
	return 1;
		
end

local params={
	func=funcPick,
	model="Objects/pickups/armor/bodyarmor.cgf",
	default_amount=15,
	sound="sounds/player/zipper.wav",
	modelchoosable=nil,
	soundchoosable=nil,
	floating_icon="Objects/Pickups/armor/armor_icon.cga"
}

Armor=CreateCustomPickup(params);
