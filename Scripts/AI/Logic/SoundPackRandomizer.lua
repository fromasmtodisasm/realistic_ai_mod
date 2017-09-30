SPRandomizer = {

--	HumanPacks = {
--		"voiceA",
--		"voiceB",
--		"voiceC",
--		"voiceD",
--	},

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

--SPRandomizer.HumanPackCount = count(SPRandomizer.HumanPacks);

function SPRandomizer:GetHumanPack( groupid , soundpack)
		
	--filippo:CanRandomize tell us if the standard voicepack this AI using can be randomized or not, if not return the standard soundpack.
	local pack = SPRandomizer:CanRandomize(soundpack,SPRandomizer.RandomPacks);
	
	if (pack==nil) then return soundpack; end
	
	local packcount = count(pack);
	
	local group_entry = "GROUP_"..groupid;

	if (SPRandomizer.GroupMap[group_entry]) then 
		SPRandomizer.GroupMap[group_entry] = SPRandomizer.GroupMap[group_entry] + 1;
	
		--if (SPRandomizer.GroupMap[group_entry] > SPRandomizer.HumanPackCount) then 
		if (SPRandomizer.GroupMap[group_entry] > packcount) then 
			SPRandomizer.GroupMap[group_entry] = 1;
		end
		return pack[SPRandomizer.GroupMap[group_entry]];
		--return SPRandomizer.HumanPacks[SPRandomizer.GroupMap[group_entry]];
	else
		local randn = random(1,packcount);--1
		
		SPRandomizer.GroupMap[group_entry] = randn;
		return pack[randn];
		--return SPRandomizer.HumanPacks[1];
	end

end

--filippo:CanRandomize look trough all the random tables to find an match with the soundpack. If not means that the soundpack cant be randomized (like valerie)
function SPRandomizer:CanRandomize(soundpack,packs)
				
	for i,pack in packs do
		
		for j,cell in pack do		
				
			if (strlower(soundpack) == strlower(cell)) then
				return pack;
			end
		end
	end
	
	return nil;
end