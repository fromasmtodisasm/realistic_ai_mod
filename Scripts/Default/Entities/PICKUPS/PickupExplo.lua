Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local funcPick=function (self,collider)			

	local sum=0;

	for i,val in collider.explosives do			
		if (val~=0) then
			sum=sum+1;
		end			
	end	

	-- no more than 4 explosive allowed at one time
	if (sum<4) then
		collider.explosives[sum+1]=1;	
		self:NotifyMessage("@YouPickedUpAn @explosive",collider);
--		self:NotifyMessage(self.Properties.Message,collider);	
		self:Event_PickupExploPickUp();	
		return 1;
	else
		--self:NotifyMessage("You cannot carry more than 4 explosives",collider);
		if ((not self.lasttime) or (_time>(self.lasttime+6))) then
			self:NotifyMessage("@Cannotcarrymorethan4exp",collider);
			self.lasttime=_time;
		end
	end	

	return nil;
end

local params={
	func=funcPick,
	model="Objects/Pickups/explosive/explosive_nocount.cgf",
	default_amount=15,
	sound="sounds/items/scouttool_pickup.wav",
	modelchoosable=1,
	soundchoosable=1,
	floating_icon="Objects/Pickups/misc/special_icon.cga"
}

PickupExplo=CreateCustomPickup(params);
PickupExplo.Properties.Amount=nil;
PickupExplo.Properties.RespawnTime=0;
--PickupExplo.Properties.Message="";

PickupExplo.Client.OnInit=function(self)
	--System:Log("Registering ExplosivePickup");
	BasePickup.Client.OnInit(self);
end

function PickupExplo:OnPropertyChange()
	--System:LogToConsole("Changing pickup");
	self:LoadObject(self.Properties.object_Model, 0, 1);
	self:DrawObject( 0, 1 );
	self.soundobj=Sound:LoadSound(self.Properties.sound_Sound);
end

function PickupExplo:Event_PickupExploPickUp(sender)	
	BroadcastEvent( self,"PickupExploPickUp");
end