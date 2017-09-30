SoundSupressor = {
	type = "AISoundSupressor",

	Properties = {
		fRadius = 10,
	},
	Editor={
		Model="Objects/Editor/Sound.cgf",
	},
}

----------------------------------------------------------------------------------------
function SoundSupressor:OnInit( )
	self:OnReset();
end


----------------------------------------------------------------------------------------
function SoundSupressor:OnPropertyChange()
	self:OnReset();
end

----------------------------------------------------------------------------------------
function SoundSupressor:OnReset()
	AI:RegisterWithAI(self.id, AIOBJECT_SNDSUPRESSOR, self.Properties.fRadius);	
	self:EnableUpdate(1);
end


----------------------------------------------------------------------------------------
function SoundSupressor:Event_Enable()

	self:TriggerEvent(AIEVENT_ENABLE);

end

----------------------------------------------------------------------------------------
function SoundSupressor:Event_Disable()

	self:TriggerEvent(AIEVENT_DISABLE);

end

----------------------------------------------------------------------------------------
function SoundSupressor:OnShutDown()

end

