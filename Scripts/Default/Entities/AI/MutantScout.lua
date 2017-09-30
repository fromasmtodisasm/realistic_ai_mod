Script:ReloadScript("SCRIPTS/Default/Entities/AI/MutantScout_x.lua")
MutantScout=CreateAI(MutantScout_x)

function MutantScout:GoRefractive()				
end

function MutantScout:GoVisible()					
end

function MutantScout:OnResetCustom()
	self.cnt:HoldGun()
	self.AI_GunOut = 1
end