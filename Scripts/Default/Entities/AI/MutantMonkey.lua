Script:ReloadScript("SCRIPTS/Default/Entities/AI/MutantMonkey_x.lua")

MutantMonkey=CreateAI(MutantMonkey_x)

function MutantMonkey:GoRefractive()
	if self.Properties.bMayBeInvisible~=1 then return end
	self.IsInvisible = 1
	self.refractionSwitchDirection = 1
	self.refractionValue = .15
end

function MutantMonkey:GoVisible()
	self.refractionSwitchDirection = 2
end

function MutantMonkey:Client_OnTimerCustom()
	if not self.refractionSwitchDirection then return end
	self.bUpdatePlayerEffectParams = 1 -- Обновляется и сразу опустошается.
	self.iPlayerEffect = 5
	self:RenderShadow(0,0)
	if self.refractionSwitchDirection==1 then
		local refrLimit = .01 -- interpolate refraction amount
		self.refractionValue = self.refractionValue+(refrLimit-self.refractionValue)*_frametime -- *50 - стандартное.
		if self.refractionValue<refrLimit+.01 then -- clamp to refraction minimum limit
			self.refractionValue = refrLimit
			self.refractionSwitchDirection = nil
		end
		-- System:Log(self:GetName()..": Invisible refractionValue: "..self.refractionValue)
	elseif self.refractionSwitchDirection==2 then
		local refrLimit = .15
		self.refractionValue = self.refractionValue+(refrLimit-self.refractionValue)*_frametime
		if self.refractionValue>refrLimit-.01 then
			self.refractionValue = refrLimit
			self:ResetStealth()
		end
		-- System:Log(self:GetName()..": Visible refractionValue: "..self.refractionValue)
	end
end

function MutantMonkey:ResetStealth()
	self.refractionSwitchDirection = nil
	self.IsInvisible = nil
	self.iPlayerEffect = 1
	self:RenderShadow(0,1)
end

function MutantMonkey:OnInitCustom()
	self.cnt:CounterAdd("SuppressedValue",-2)
end

function MutantMonkey:OnResetCustom()
	self.cnt:CounterSetValue("SuppressedValue",0)
	self:ResetStealth() -- Постоянное обновление-то в редакторе прекращается и поэтому сбрасывает не до конца...
end