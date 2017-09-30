Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local funcPick=function (self,collider)

	if(Game:GetEntityTeam(collider.id)==self.Properties.Team)then
		if(collider.cnt.health<collider.cnt.max_health)then
			collider.cnt.health=collider.cnt.max_health;
		end
		
		for at,amount in MaxAmmo do
			self.Properties.Amount=amount;
			self.ammo_type=at;
				%__PickAmmo(self,collider)
		end
			
		--if (collider.Properties.equipEquipment) then
	--		local WeaponPack = EquipPacks[collider.Properties.equipEquipment];
		--	if (WeaponPack) then
				--merge(collider.Ammo,WeaponPack.Ammo);
			--end
		--end
		return 1;
	end
	
	return 0;
end

local params={
	func=funcPick,
	model="Objects/glm/ww2_indust_set1/machinery/energybank.cgf",
	default_amount=15,
	sound="sounds/items/health.wav",
	doesnt_expire=1,
	multiplayer=1,
	modelchoosable=nil,
	soundchoosable=nil
}

HealingPoint=CreateCustomPickup(params);
HealingPoint.Properties.Team="red"

