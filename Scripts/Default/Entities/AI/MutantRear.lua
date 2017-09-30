Script:ReloadScript("SCRIPTS/Default/Entities/AI/MutantRear_x.lua")
MutantRear=CreateAI(MutantRear_x)

function MutantRear:GoRefractive()
	self.IsInvisible = 1
	self.refractionSwitchDirection = 1
	self.refractionValue = .15
end

function MutantRear:GoVisible()
	self.refractionSwitchDirection = 2
end

-- function MutantRear:OnDamageCustom()
	-- if self.cnt.health < 1 and self.IsInvisible then self.refractionSwitchDirection = 2 end
-- end

function MutantRear:Client_OnTimerCustom()
	if self.cnt.health < 1 and self.IsInvisible then self.refractionSwitchDirection = 2 end
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

function MutantRear:ResetStealth()
	self.refractionSwitchDirection = nil
	self.IsInvisible = nil
	self.iPlayerEffect = 1
	self:RenderShadow(0,1)
end

function MutantRear:OnResetCustom()
	if self.Properties.fileBackpackModel and self.Properties.fileBackpackModel~="" then
		self:LoadObject(self.Properties.fileBackpackModel,1,0)
		self:AttachObjectToBone(1,"Bip01 Spine2")
	end
	self:ResetStealth()
	self:GoRefractive()
	self.cnt:HoldGun()
	self.AI_GunOut = 1
end