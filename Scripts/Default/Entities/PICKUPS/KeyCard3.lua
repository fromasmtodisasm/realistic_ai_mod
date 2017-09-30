Script:LoadScript("scripts/default/entities/pickups/basepickup.lua")

local funcPick=function(self,collider)
	if collider.ai and not collider.IsAiPlayer then return end
	if (collider.keycards[self.Properties.KeyNumber]==1) then
		--Hud:AddMessage("KeyCard #"..self.Properties.KeyNumber.." already in inventory !")
		return nil
	end
	--self:NotifyMessage("@YouPickedUp @KeyCard #"..self.Properties.KeyNumber,collider)
	self:NotifyMessage("@YouPickedUpA @KeyCard") -- #"..self.Properties.KeyNumber,collider)
	collider.keycards[self.Properties.KeyNumber]=1
	BroadcastEvent(self,"KeyCardPickUp")
	return 1
end

local params={
	func=funcPick,
	model="Objects/Pickups/misc/keycard_blue.cgf",
	default_amount=15,
	sound="sounds/items/MoTrackTarget.wav",
	modelchoosable=1,
	soundchoosable=1,
	floating_icon="Objects/Pickups/misc/special_icon.cga",
	objectpos = {x=0,y=0,z=-.07},
}

KeyCard3=CreateCustomPickup(params)
KeyCard3.Properties.Amount=nil
KeyCard3.Properties.RespawnTime=0
KeyCard3.Properties.KeyNumber=3

KeyCard3.Client.OnInit=function(self)
	System:Log("Registering KeyCard")
	BasePickup.Client.OnInit(self)
end

function KeyCard3:OnPropertyChange()
	System:Log("Changing pickup")
	self:LoadObject(self.Properties.object_Model,0,1)
	self:DrawObject(0,1)
	self.soundobj=Sound:LoadSound(self.Properties.sound_Sound)
end

function KeyCard3:Event_KeyCardPickUp(sender)

end