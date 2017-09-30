Script:ReloadScript("SCRIPTS/Default/Entities/AI/MutantBezerker_x.lua")

MutantBezerker=CreateAI(MutantBezerker_x)

function MutantBezerker:GoRefractive()
	if self.Properties.bMayBeInvisible~=1 then return end
	self.IsInvisible = 1
	self.refractionSwitchDirection = 1
	self.refractionValue = .15
end

function MutantBezerker:GoVisible()
	self.refractionSwitchDirection = 2
end

function MutantBezerker:Client_OnTimerCustom()
	if not self.refractionSwitchDirection then return end
	self.bUpdatePlayerEffectParams = 1
	self.iPlayerEffect = 5
	self:RenderShadow(0,0)
	if self.refractionSwitchDirection==1 then
		local refrLimit = .01
		self.refractionValue = self.refractionValue+(refrLimit-self.refractionValue)*_frametime
		if self.refractionValue<refrLimit+.01 then
			self.refractionValue = refrLimit
			self.refractionSwitchDirection = nil
		end
	elseif self.refractionSwitchDirection==2 then
		local refrLimit = .15
		self.refractionValue = self.refractionValue+(refrLimit-self.refractionValue)*_frametime
		if self.refractionValue>refrLimit-.01 then
			self.refractionValue = refrLimit
			self:ResetStealth()
		end
	end
end

function MutantBezerker:ResetStealth()
	self.refractionSwitchDirection = nil
	self.IsInvisible = nil
	self.iPlayerEffect = 1
	self:RenderShadow(0,1)
end

function MutantBezerker:OnInitCustom()
	self.cnt:CounterAdd("SuppressedValue",-2)
end

function MutantBezerker:OnResetCustom()
	self.cnt:CounterSetValue("SuppressedValue",0)
	self:ResetStealth()
end