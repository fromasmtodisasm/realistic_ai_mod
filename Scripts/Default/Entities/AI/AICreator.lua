AICreator = {
	Properties = {
		bEnabled = 1,
		nSpawnlimit = 0,
		sGunName = "P90",
		nGroupId = 10,
		sAiClass = "MutantMonkey",
		fileCoopModel = "",
		sCoopProperties = "",
		nSpecies = 100,
		nSightrange = 110,
		nSoundrange = 10,
		nSpawnDelay = 2,
		nEliminationOffset = 0,
		sPointToGo = "",
		sPathToGo = "",
		bRunning = 1,
		bSurvival_Villain = 0,
		bRandom = 0,
	},
	Editor={
		Model="Objects/characters/Mutants/Mutant_Aberration3/mutant_aberration3.cgf",
	},
}

function AICreator:OnPropertyChange()
	self:OnReset()
end

function AICreator:OnInit()
	self:OnReset()
end

function AICreator:OnReset()
	self.SpawnNum = 0
	self.DeathRow = self.Properties.nEliminationOffset * 1
	self.bEnabled = self.Properties.bEnabled * 1
	self.bWaiting = 0
	self:KillTimer()
	if (GameRules) and (not GameRules.fc_su_aiclass) then
		GameRules.fc_su_aiclass = {
			MutantMonkey = "Objects/characters/Mutants/Mutant_Aberration3/mutant_aberration3.cgf",
			MutantBezerker = "Objects/characters/Mutants/Mutant_Aberration/mutant_aberration.cgf",
			MutantScout = "Objects/characters/Mutants/mutant_fast/mutant_fast.cgf",
			MutantScrew = "Objects/characters/mutants/Mutant_screwed/Mutant_screwed.cgf",
			MutantRear = "Objects/characters/Mutants/mutant_stealth/mutant_stealth_norockets.cgf",
			MercRear = "Objects/characters/Mutants/mutant_stealth/mutant_stealth.cgf",
			MutantCover = "Objects/characters/mutants/Mutant_big/Mutant_big.cgf",
		}
		AI:CreateGoalPipe("Fcsu_point_go")
		AI:PushGoal("Fcsu_point_go","acqtarget",1,"")
		AI:PushGoal("Fcsu_point_go","pathfind",1,"")
		AI:PushGoal("Fcsu_point_go","trace",1,1)
		
		AI:CreateGoalPipe("Fcsu_point_run")
		AI:PushGoal("Fcsu_point_run","setup_combat")
		AI:PushGoal("Fcsu_point_run","acqtarget",1,"")
		AI:PushGoal("Fcsu_point_run","pathfind",1,"")
		AI:PushGoal("Fcsu_point_run","trace",1,1)
	end
end

function AICreator:OnTimer()
	self.bWaiting = 0
	self:Event_CreateAI()
end

function AICreator:Event_EveryoneDestroyed()
	self.DeathRow = 0
	BroadcastEvent( self,"EveryoneDestroyed" )
end

function AICreator:Event_KillSpawnedAis()
	local Entities = System:GetEntities()
	for i,entity in Entities do
		if entity.IsBadMonster and entity.IsBadMonster == self.id and entity.Event_Die then
			entity:Event_Die()
		end
	end
end

function AICreator:Event_Enable()
	self.bEnabled = 1
end

function AICreator:Event_Disable()
	self.bEnabled = 0
end

function AICreator:Event_ResetState()
	self:OnReset()
	BroadcastEvent( self,"ResetState" )
end

function AICreator:Event_ChargeAI()
	if self.Properties.nSpawnDelay > 0 then
		self:SetTimer(self.Properties.nSpawnDelay*1000)
	else
		self:SetTimer(10)
	end
	self.bWaiting = 1
end

function AICreator:Event_Extinct()
	BroadcastEvent( self,"Extinct" )
end

function AICreator:OnSave(stm)
	stm:WriteBool(self.bEnabled)
	stm:WriteBool(self.bWaiting)
	stm:WriteInt(self.SpawnNum)
	stm:WriteInt(self.DeathRow)
end

function AICreator:OnLoad(stm)
	self.bEnabled=stm:ReadBool()
	self.bWaiting=stm:ReadBool()
	self.SpawnNum=stm:ReadInt()
	self.DeathRow=stm:ReadInt()
	if (self.bWaiting == 1) then
		self:Event_ChargeAI()
	end
end

function AICreator:Event_CreateAI()
	if (Game:IsServer()) and (self.bEnabled==1) then
		if (self.Properties.nSpawnlimit > 0) then
			if (self.SpawnNum>=self.Properties.nSpawnlimit) then
				self.bEnabled = 0
				BroadcastEvent( self,"Extinct" )
				return
			end
		else
			self.SpawnNum = 0
		end

		if (self.Properties.bRandom == 1) then
			if (self.Properties.sGunName=="") then
				self.RandomGun = 1
			end
			local mtable = {
				"MutantMonkey",
				"MutantBezerker",
				"MutantScout",
				"MutantRear",
				"MercRear",
				"MutantCover",
			}
			if (Mission) then
				if (Mission.custommonsters) then
					mtable = Mission.custommonsters
				end
			end
			local chosenmonster = random(1,getn(mtable))
			self.Properties.sAiClass = mtable[chosenmonster]
			if self.RandomGun then
				if (self.Properties.sAiClass=="MutantCover") then
					if (Mission) and (Mission.customguns_shoulder) then
						mtable = Mission.customguns_shoulder
					else
						mtable = {
							"MutantShotgun",
							"COVERRL",
						}
					end
				elseif (Mission) and (Mission.customguns) then
					mtable = Mission.customguns
				else
					mtable = {
						"M4",
						"P90",
						"MP5",
						"OICW",
						"M249",
						"AG36",
						"Shotgun",
						"SniperRifle",
					}
				end
				chosenmonster = random(1,getn(mtable))
				self.Properties.sGunName = mtable[chosenmonster]
			end
		end

		local b_pos = {x=0,y=0,z=0}
		local b_ang = new(self:GetAngles())
		if (self.Properties.bSurvival_Villain) and (self.Properties.bSurvival_Villain == 1) and (GameRules.SetCoopMission) then
			local tag_rel_pos = Game:GetTagPoint(self:GetName().."_RELOCATE")
			if (tag_rel_pos) then
				b_pos = tag_rel_pos
			end
		else
			b_pos = new(self:GetPos())
		end
		local baked_ai = Game:GetEntityClassIDByClassName(self.Properties.sAiClass)
		if (not baked_ai) then
			self.SpawnNum = self.SpawnNum + 1
			BroadcastEvent( self,"CreateAI")
			if (Hud) and (not UI) and (Game:IsClient()) then
				Hud:AddMessage("Wrong AiClass for "..self:GetName().." - do you using this as delay for COOP?")
				System:Warning("Wrong AiClass for "..self:GetName().." - do you using this as delay for COOP?")
			end
			return
		end
		---- Sandbox Editor Related:
		if (not UI) and (Game:IsClient()) then
			if (tonumber(getglobal("ai_debugdraw")) < 1) then
				self.SpawnNum = self.SpawnNum + 1
				BroadcastEvent( self,"CreateAI")
				Particle:SpawnEffect( b_pos,g_Vectors.v001,'misc.sparks.a',20)
				if (not self.debug_editor_snd) then
					self.debug_editor_snd = Sound:LoadSound("Sounds/items/bombcount.wav")
				end
				if (self.debug_editor_snd) then
					Sound:PlaySound(self.debug_editor_snd)
				end
				System:Warning(self:GetName().." will be spawned in game. Set ai_debugdraw to 1 to allow AICreator to spawn in editor")
				if (Hud) then
					Hud:AddMessage(self:GetName().." $2fake spawned. $1ENABLE AI Debug Draw (Render Settings) $2to allow AICreator to spawn in editor")
				end
				return
			end
		end
		----------
		if (self.Properties.fileCoopModel) and (self.Properties.fileCoopModel~="") then

			-- let's let the client knof it has custom coop model by changing extension from .cgf to .cal
			self.Pr_modelext = strsub(self.Properties.fileCoopModel, strlen(self.Properties.fileCoopModel)-1)
			if (self.Pr_modelext) and (self.Pr_modelext == "gf") then -- cgf
				self.Pr_modelext = strsub(self.Properties.fileCoopModel, 1, strlen(self.Properties.fileCoopModel)-2)
				self.Properties.fileCoopModel = self.Pr_modelext.."al"
			end
			if (Mission) and (self.Properties.sCoopProperties~="") then
				if (Mission[self.Properties.sCoopProperties]) then
					Mission[self.Properties.sCoopProperties].fileModel = self.Properties.fileCoopModel
					baked_ai = Server:SpawnEntity({classid=baked_ai,pos=b_pos,angles=b_ang,name=self:GetName(),model=self.Properties.fileCoopModel,properties=Mission[self.Properties.sCoopProperties]})
				else
					self.Properties.nCoopHealth = tonumber(self.Properties.sCoopProperties)
					baked_ai = Server:SpawnEntity({classid=baked_ai,pos=b_pos,angles=b_ang,name=self:GetName(),model=self.Properties.fileCoopModel})
				end
			else
				baked_ai = Server:SpawnEntity({classid=baked_ai,pos=b_pos,angles=b_ang,name=self:GetName(),model=self.Properties.fileCoopModel})
			end
		else
			baked_ai = Server:SpawnEntity({classid=baked_ai,pos=b_pos,angles=b_ang,name=self.Properties.sAiClass,model=GameRules.fc_su_aiclass[self.Properties.sAiClass]})
		end
		if (baked_ai) then
			-- GIVE WEAPON
			if (baked_ai.Properties.NEVER_FIRE) then
				baked_ai.NEVER_FIRE = 1
			end

			if (baked_ai.NEVER_FIRE) or (self.Properties.sGunName=="") then
				baked_ai.Properties.equipDropPack = ""
				if (GameRules.SimulateMelee) then
					baked_ai.NEVER_FIRE = nil
					baked_ai.HASCLAWS = 1
				end
			elseif (WeaponClassesEx[self.Properties.sGunName]) then
				baked_ai.survival_gun = WeaponClassesEx[self.Properties.sGunName].id
				baked_ai.cnt:MakeWeaponAvailable(baked_ai.survival_gun)
				baked_ai.cnt:SetCurrWeapon(baked_ai.survival_gun)
				if (baked_ai.fireparams) and (baked_ai.fireparams.bullets_per_clip) and (baked_ai.fireparams.bullets_per_clip > 0) then
					baked_ai.cnt.ammo_in_clip = random(1,baked_ai.fireparams.bullets_per_clip)
				end
				if (Game:IsMultiplayer()) then
					baked_ai.Properties.equipDropPack = ""
				elseif (not baked_ai.NEVER_FIRE) then
					baked_ai.Properties.equipDropPack = self.Properties.sGunName
				end
			end

			self.SpawnNum = self.SpawnNum + 1
			------- Mixer: Let's Improve It!!!
			--baked_ai.PropertiesInstance.aibehavior_behaviour = "Job_PatrolPathNoIdle"

			if (self.Properties.sPointToGo ~= "") then
					baked_ai.Properties.ReinforcePoint = self.Properties.sPointToGo
			elseif (GameRules.c_center) then
				if (not GameRules.su_temp_go2red) then
					baked_ai.Properties.ReinforcePoint = "rush_mercs"
					GameRules.su_temp_go2red = 1
				else
					baked_ai.Properties.ReinforcePoint = "rush_survivors"
					GameRules.su_temp_go2red = nil
				end
				if (self.Properties.sPathToGo ~= "") then
					AI:CreateGoalPipe("Fcsu_path")
					AI:PushGoal("Fcsu_path","pathfind",1,self.Properties.sPathToGo)
					AI:PushGoal("Fcsu_path","trace",1,1)
					baked_ai.Properties.pathname = self.Properties.sPathToGo
				end
			elseif (self.Properties.sPathToGo ~= "") then
				if (self.Properties.sPathToGo == "follow_me") then
					baked_ai:Event_Follow()
					baked_ai.delayedfollow = 1
				else
					AI:CreateGoalPipe("Fcsu_path")
					AI:PushGoal("Fcsu_path","pathfind",1,self.Properties.sPathToGo)
					AI:PushGoal("Fcsu_path","trace",1,1)
					baked_ai.Properties.pathname = self.Properties.sPathToGo
				end
			end

			function baked_ai:Event_OnDeath()
				if (self.deleteOnGameReset) and (self.deleteOnGameReset == 99) then
					GameRules:RemoveVillain()
				end
				if (self.IsBadMonster) then
					local p_ent = System:GetEntity(self.IsBadMonster)
					if (p_ent) then
						if (p_ent.Properties.nSpawnlimit > 0) then
							p_ent.DeathRow = p_ent.DeathRow + 1
							if (p_ent.DeathRow >= p_ent.Properties.nSpawnlimit) then
								p_ent:Event_EveryoneDestroyed()
							end
						end
					end
				end
				self.fcsu_deathtime = _time + 80
				if (not GameRules.DeadBods) then
					GameRules.DeadBods = {}
				end
				tinsert(GameRules.DeadBods,self.id*1)
			end
			---
			baked_ai.deleteOnGameReset = 1
			baked_ai.bot_born = 1
			baked_ai.vbot_ssid = baked_ai.id
			baked_ai:EnableUpdate(0)
			baked_ai:TriggerEvent(AIEVENT_SLEEP)

			if (Game:IsMultiplayer()) then
				if (GameRules.MonsterHorde) then
					tinsert(GameRules.MonsterHorde,baked_ai)
				end
			else
				Particle:SpawnEffect( b_pos,g_Vectors.v001,'misc.sparks.a',10)
			end
			
			baked_ai.Properties.LEADING_COUNT = 0

			function baked_ai:AntiStuck()
				if (not self.su_ltime) then
					self.su_ltime = _time + 1
				elseif (self.su_ltime < _time) then
					self.su_ltime = _time + 4
					if (not self.cnt.moving) then
						if (self.delayedfollow) then
							--self.delayedfollow = nil
							local target = AI:GetAttentionTargetOf(self.id)
							if (target) and (type(target)=="table") then
								return
							end
							self:Event_Follow()
						elseif (self.Properties.ReinforcePoint~="") then
							local target = AI:GetAttentionTargetOf(self.id)
							if (target) and (type(target)=="table") then
								return
							end
							local tpc = new(Game:GetTagPoint(self.Properties.ReinforcePoint..self.Properties.LEADING_COUNT))
							if (not self.Properties.LEADING_DIR) then
								self.Properties.LEADING_DIR = 1
							end
							if (tpc) then
								self.Properties.LEADING_SUCCESS_SPOT = self.Properties.LEADING_COUNT*1
								tpc = self:GetDistanceFromPoint(tpc)
								if (tpc < 3) then
									self.Properties.LEADING_COUNT = self.Properties.LEADING_COUNT + self.Properties.LEADING_DIR
								end
							else
								if (self.Properties.LEADING_COUNT <= 0) then
									self.Properties.LEADING_DIR = 1
								else
									self.Properties.LEADING_DIR = -self.Properties.LEADING_DIR
								end
								self.Properties.LEADING_COUNT = self.Properties.LEADING_COUNT + self.Properties.LEADING_DIR
								if (self.Properties.LEADING_SUCCESS_SPOT) and (self.Properties.LEADING_COUNT == self.Properties.LEADING_SUCCESS_SPOT) then
									self.Properties.LEADING_COUNT = self.Properties.LEADING_COUNT + self.Properties.LEADING_DIR
									self.Properties.LEADING_SUCCESS_SPOT = nil
								end
							end
							self:SelectPipe(0,"Fcsu_point_go",self.Properties.ReinforcePoint..self.Properties.LEADING_COUNT)
						end
					end
				end
			end

			baked_ai.PropertiesInstance.sightrange = self.Properties.nSightrange*1
			baked_ai.PropertiesInstance.soundrange = self.Properties.nSoundrange*1
			baked_ai.PropertiesInstance.groupid = self.Properties.nGroupId*1
			baked_ai.Properties.species = self.Properties.nSpecies*1
			if (self.Properties.nCoopHealth) then
				baked_ai.Properties.max_health = self.Properties.nCoopHealth
				baked_ai.cnt.health = baked_ai.Properties.max_health * getglobal("game_Health")
			end
			AI:RegisterWithAI(baked_ai.id,AIOBJECT_PUPPET,baked_ai.Properties,baked_ai.PropertiesInstance)
			baked_ai:ChangeAIParameter(AIPARAM_SIGHTRANGE,baked_ai.PropertiesInstance.sightrange)
			baked_ai:ChangeAIParameter(AIPARAM_SOUNDRANGE,baked_ai.PropertiesInstance.soundrange)
			-----
			baked_ai.AI_CanWalk = 1
			baked_ai.Properties.bSleepOnSpawn = 0
			baked_ai:EnableUpdate(1)
			baked_ai:TriggerEvent(AIEVENT_WAKEUP)
			baked_ai.IsBadMonster = self.id
			baked_ai.assault_score = 0
			baked_ai.bot_killstreak = 0
			if (self.Properties.bSurvival_Villain) and (self.Properties.bSurvival_Villain == 1) and (GameRules.AddVillain) then
				GameRules:AddVillain()
				baked_ai.deleteOnGameReset = 99
			end
			-----
			function baked_ai:GoRefractive()
			end
			if (baked_ai.GoVisible) then
				baked_ai:GoVisible()
			end
			function baked_ai:GetPlayerId()
				return self.id
			end
			if (Game:IsClient()) then
				baked_ai:SetViewDistRatio(255)
			end

			if (baked_ai.Properties.pathname~="") then
				baked_ai:SelectPipe(0,"Fcsu_path")
				if (self.Properties.bRunning==1) then
					baked_ai:InsertSubpipe(0,"setup_combat")
				end
			elseif (baked_ai.Properties.ReinforcePoint ~= "") then
				if (self.Properties.bRunning==1) then
					if (GameRules.MonsterGo) then
						if (GameRules:MonsterGo(baked_ai,baked_ai.Properties.ReinforcePoint)==nil) then
							baked_ai:SelectPipe(0,"Fcsu_point_run",baked_ai.Properties.ReinforcePoint)
						end
					else
						baked_ai:SelectPipe(0,"Fcsu_point_run",baked_ai.Properties.ReinforcePoint)
					end
				else
					baked_ai:SelectPipe(0,"Fcsu_point_go",baked_ai.Properties.ReinforcePoint)
				end
			else
				if (baked_ai.Behaviour.OnActivate) then
					baked_ai.Behaviour:OnActivate(baked_ai)
				elseif (baked_ai.DefaultBehaviour and AIBehaviour[baked_ai.DefaultBehaviour].OnActivate) then
					AIBehaviour[baked_ai.DefaultBehaviour]:OnActivate(baked_ai)
				end
			end
			BroadcastEvent( self,"CreateAI")
		end
	end
end