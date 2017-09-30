Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local funcPick=function (self,collider,entering)			

	if GameRules and GameRules.OnClassAmmoPickup then
		if GameRules:OnClassAmmoPickup(collider, self.Properties.IsDropPack) then
			--self:NotifyMessage("@YouPickedUp @Ammo",collider);		-- we should optimize this
			
			-- send armor catch 
			local serverSlot = Server:GetServerSlotByEntityId(collider.id);
			if (serverSlot) then	
				serverSlot:SendCommand("HUD P 8 1"); -- hud, generic pick (assault mp mode)
			end
			
			return 1;												-- remove entity
		end
	end

	if (entering == 1) then
		if ((not self.lasttime) or (_time>(self.lasttime+6))) then		
			--self:NotifyMessage("@pickup_not_possible @ammo_pickup_not_possible_trail", collider);
			
			-- send ammo cannot catch 
			local serverSlot = Server:GetServerSlotByEntityId(collider.id);
			if (serverSlot) then
				serverSlot:SendCommand("HUD P 8 -1"); -- hud, generic pick, armor, not available
			end
										
			self.lasttime=_time;
		end
	end
	return nil;
end

local params={
	func=funcPick,
	model="Objects/Pickups/universal_ammo/universal_ammo.cgf",
	default_amount=15,
	sound="Sounds/Weapons/M4/M4_33.wav",							-- todo change sound?
	modelchoosable=1,
	soundchoosable=1,
	floating_icon="Objects/Pickups/universal_ammo/universal_ammo_icon.cga",
	objectpos = {x=0, y=0, z=-0.08},
}

ClassAmmoPickup=CreateCustomPickup(params);
ClassAmmoPickup.Properties.Amount=nil;
ClassAmmoPickup.Properties.RespawnTime=20;
ClassAmmoPickup.Properties.IsDropPack = nil;
ClassAmmoPickup.Properties.AlwaysPhysicalize = 1;

ClassAmmoPickup.Client.OnInit=function(self)
	BasePickup.Client.OnInit(self);
end

function ClassAmmoPickup:OnPropertyChange()
	self:LoadObject(self.Properties.object_Model, 0, 1);
	self:DrawObject( 0, 1 );
	self.soundobj=Sound:LoadSound(self.Properties.sound_Sound);
end