SPRandomizer = {
	RandomPacks = {
		HumanPacks = {
			"voiceA",
			"voiceB",
			"voiceC",
			"voiceD",
		},
		CoreWorkers = {
			"coreworkerA",
			"coreworkerD",
		},
	},
	GroupMap = {
	},
}
--SPRandomizer.HumanPackCount = count(SPRandomizer.HumanPacks)

function SPRandomizer:GetHumanPack(self,SoundPack)
	if not self.MERC or self.Properties.KEYFRAME_TABLE=="VALERIE" or self.Properties.special==1 then return SoundPack end
	--filippo:CanRandomize tell us if the standard voicePack this AI using can be randomized or not,if not return the standard soundpack.
	local Pack = SPRandomizer:CanRandomize(SoundPack,SPRandomizer.RandomPacks,self) -- Проверка на существование оного.
	local HeExists -- Он существует.
	if SOUNDPACK then
		for i,val in SOUNDPACK.AVAILABLE do -- i - название переменной.
			-- System:Log(self:GetName()..": SOUNDPACK.AVAILABLE: "..val..", i: "..i)
			if SoundPack==i then
				-- System:Log(self:GetName()..": AllowUse: "..val..", i: "..i)
				HeExists = 1 -- Если указанный набор вообще существует, тогда выбрать его, иначе, выбрать случайный.
				break
			end
		end
	end
	if self.ANIMAL=="pig" and SoundPack~="pig" then -- Свиньям не свинячить?
		SoundPack="pig"
	elseif self.ANIMAL~="pig" and SoundPack=="pig" then -- Не свиньям как свиньи говорить?
		SoundPack=""
	end
	-- if self.MUTANT and Pack then -- Мутантам хищникам нельзя как человек говорить. Мало ли. ) А как же толстяки?
		-- System:Log(self:GetName()..": You can not use the human voice: "..SoundPack)
		-- SoundPack=""
		-- return SoundPack
	-- end
	if not Pack and SoundPack~="" and HeExists then
		return SoundPack
	else
		if self.Properties.fileModel=="Objects\\characters\\workers\\coretech\\coretech.cgf" then -- Принудительно выбрать именно эти голоса (в некоторых модах слышал как чел в костюме разговаривает как обычный).
			Pack=SPRandomizer.RandomPacks.CoreWorkers
		else
			Pack=SPRandomizer.RandomPacks.HumanPacks
		end
	end -- Пусть проверка такой и остаётся.
	local PackCount = count(Pack)
	local group_entry = "GROUP_"..self.PropertiesInstance.groupid
	if (SPRandomizer.GroupMap[group_entry]) then
		SPRandomizer.GroupMap[group_entry] = SPRandomizer.GroupMap[group_entry] + 1
		--if (SPRandomizer.GroupMap[group_entry] > SPRandomizer.HumanPackCount) then
		if (SPRandomizer.GroupMap[group_entry] > PackCount) then
			SPRandomizer.GroupMap[group_entry] = 1
		end
		-- Hud:AddMessage(self:GetName()..": Pack: "..Pack[SPRandomizer.GroupMap[group_entry]])
		-- System:Log(self:GetName()..": Pack: "..Pack[SPRandomizer.GroupMap[group_entry]])
		return Pack[SPRandomizer.GroupMap[group_entry]]
		--return SPRandomizer.HumanPacks[SPRandomizer.GroupMap[group_entry]]
	else
		local rnd = random(1,PackCount)--1
		SPRandomizer.GroupMap[group_entry] = rnd
		return Pack[rnd]
		--return SPRandomizer.HumanPacks[1]
	end
end

--filippo:CanRandomize look trough all the random tables to find an match with the soundpack. If not means that the soundpack cant be randomized (like valerie)
function SPRandomizer:CanRandomize(SoundPack,Packs,self)
	for i,Pack in Packs do -- i - название.
		for j,Cell in Pack do
			-- Hud:AddMessage(self:GetName()..": Pack: "..i)
			-- System:Log(self:GetName()..": Pack: "..i)
			if (strlower(SoundPack)==strlower(Cell)) then -- j - номер. Pack[j] - название. strlower(Cell) - название, только без верхнего регистра.
				-- Hud:AddMessage(self:GetName()..": Pack: "..Pack[j])
				-- System:Log(self:GetName()..": Pack: "..Pack[j])
				return Pack
			end
		end
	end
	return nil
end