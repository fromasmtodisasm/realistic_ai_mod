-- AICONFIG 
-- Used to load/reload everything related to ai
-- Загружается через main.lua

Script:ReloadScript("Scripts/AI/BasicAI.lua")
Script:ReloadScript("Scripts/AI/anchor.lua")
Script:ReloadScript("Scripts/AI/Characters/AICharacter.lua")
Script:ReloadScript("Scripts/AI/Logic/AI_BoredManager.lua")
Script:ReloadScript("Scripts/AI/Behaviors/Personalities/SHARED/Idles/Idle_Any.lua")
Script:ReloadScript("Scripts/AI/GoalPipes/PipeManager.lua")
Script:ReloadScript("Scripts/AI/Behaviors/AIBehaviour.lua")
Script:ReloadScript("Scripts/AI/Logic/IdleManager.lua")
Script:ReloadScript("Scripts/AI/Logic/Mutant_IdleManager.lua")
Script:ReloadScript("Scripts/AI/Packs/Animation/PACKS.lua")
Script:ReloadScript("Scripts/AI/Packs/Sound/PACKS.lua")

if (not Game:IsMultiplayer()) then
	AIBehaviour:LoadAll()
	AICharacter:LoadAll()
end

Script:ReloadScript("Scripts/AI/Logic/AI_Conversation.lua")
Script:ReloadScript("Scripts/AI/Logic/AI_ConvManager.lua")
Script:ReloadScript("Scripts/AI/Logic/AI_JobManager.lua")
Script:ReloadScript("Scripts/AI/Logic/AI_CombatManager.lua")
Script:ReloadScript("Scripts/AI/Logic/NameGenerator.lua")
Script:ReloadScript("Scripts/AI/Logic/SoundPackRandomizer.lua")
Script:ReloadScript("Scripts/AI/Packs/Conversations/Idle.lua")
Script:ReloadScript("Scripts/AI/Packs/Conversations/Critical.lua")
Script:ReloadScript("Scripts/AI/Logic/NOCOVER.lua")
Script:ReloadScript("Scripts/Default/Entities/Weapons/AIWeapons.lua")

if (PipeManager) then
	PipeManager:OnInit()
end

AI:SetSpeciesThreatMultiplier(0,1.1) -- Насколько сильно надо бояться тех, кто имеет species равный нулю.
-- SETTING UP THE PLAYER ASSESMENT MULTIPLIER
AI:SetAssesmentMultiplier(AIOBJECT_PLAYER,1.1) -- Лучше, чтобы было как у мутантов, тогда ИИ будет более правильно распределять приоритеты между игроком и мутантами.
AI:SetAssesmentMultiplier(AIOBJECT_ATTRIBUTE,1)
AI:SetAssesmentMultiplier(AIAnchor.AIOBJECT_DAMAGEGRENADE,2) -- Можно повесить на опасные обьекты.

-- MAKE MUTANTS TWICE MORE SCARY THAN OTHER SPECIES
AI:SetSpeciesThreatMultiplier(100,1.1)

System:Log("[AISTATUS] CONFIG SCRIPT FILE LOADED.")