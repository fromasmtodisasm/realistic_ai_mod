Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local funcPick=function (self,collider)		
	
	if (strlen(self.Properties.Object)>0) then
	
		-- reject item, if already in inventory
		if (collider.objects[self.Properties.Object]==1) then		
			--Hud:AddMessage("Already in inventory !");
			return nil;
		end	
		
		collider.objects[self.Properties.Object]=1;
		self:NotifyMessage(self.Properties.Message,collider, 5);
		self:Event_PickupGenericPickUp();				
	end
		  
	return 1;
end

local params={
	func=funcPick,
	--model="Objects/Pickups/misc/keycard_ylw.cgf",
	model="",
	default_amount=15,
	sound="sounds/items/bombbutton.wav",
	modelchoosable=1,
	soundchoosable=1,
	floating_icon="Objects/Pickups/misc/special_icon.cga",
}

PickupGeneric=CreateCustomPickup(params);
PickupGeneric.Properties.Amount=nil;
PickupGeneric.Properties.RespawnTime=0;
PickupGeneric.Properties.Message="";
PickupGeneric.Properties.Object="";

PickupGeneric.Client.OnInit=function(self)
	--System:Log("Registering PickupGeneric");
	BasePickup.Client.OnInit(self);
end

function PickupGeneric:OnPropertyChange()
	System:LogToConsole("Changing pickup");
	self:LoadObject(self.Properties.object_Model, 0, 1);
	self:DrawObject( 0, 1 );
	self.soundobj=Sound:LoadSound(self.Properties.sound_Sound);
end

function PickupGeneric:Event_PickupGenericPickUp(sender)	
	BroadcastEvent( self,"PickupGenericPickUp");
end