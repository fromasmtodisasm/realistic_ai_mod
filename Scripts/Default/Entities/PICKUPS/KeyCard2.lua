Script:LoadScript("scripts/default/entities/pickups/basepickup.lua");

local funcPick=function (self,collider)		
	if (collider.keycards[self.Properties.KeyNumber]==1) then		
		--Hud:AddMessage("KeyCard #"..self.Properties.KeyNumber.." already in inventory !");
		return nil;
	end
	--self:NotifyMessage("@YouPickedUp @KeyCard #"..self.Properties.KeyNumber, collider);
	self:NotifyMessage("@YouPickedUpA @KeyCard"); -- #"..self.Properties.KeyNumber, collider);
	collider.keycards[self.Properties.KeyNumber]=1;
	BroadcastEvent( self,"KeyCardPickUp" );
	return 1;
end

local params={
	func=funcPick,
	model="Objects/Pickups/misc/keycard_ylw.cgf",
	default_amount=15,
	sound="sounds/items/MoTrackTarget.wav",
	modelchoosable=1,
	soundchoosable=1,
	floating_icon="Objects/Pickups/misc/special_icon.cga",
	objectpos = {x=0, y=0, z=-0.07},
}

KeyCard2=CreateCustomPickup(params);
KeyCard2.Properties.Amount=nil;
KeyCard2.Properties.RespawnTime=0;
KeyCard2.Properties.KeyNumber=2;

KeyCard2.Client.OnInit=function(self)
	System:Log("Registering KeyCard");
	BasePickup.Client.OnInit(self);
end

function KeyCard2:OnPropertyChange()
	System:LogToConsole("Changing pickup");
	self:LoadObject(self.Properties.object_Model, 0, 1);
	self:DrawObject( 0, 1 );
	self.soundobj=Sound:LoadSound(self.Properties.sound_Sound);
end

function KeyCard2:Event_KeyCardPickUp(sender)	
	
end