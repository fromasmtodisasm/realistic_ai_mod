Script:LoadScript("scripts/Multiplayer/ClientStuffTeamLib.lua");

function ClientStuff:ModeDesc()
	return "TDM";
end

function ClientStuff:ShowScoreBoard(bShow)	
	if (ScoreBoardManager) then
		ScoreBoardManager.SetVisible(bShow);
	end
end

function ClientStuff:ResetScores()
	if (ScoreBoardManager) then
		ScoreBoardManager.ClearScores();
		
		-- set score board fields
		if(not self.scoreboardFields) then
			self.scoreFields={ 				
				[1]="@ScoreBoardKills",
				[2]="@ScoreBoardDeaths",
				[3]="@ScoreBoardEfficiency",
				[4]="@ScoreBoardPing",
			};		
			ScoreBoardManager:SetBoardFields(self.scoreFields);
		end
	end
end

function ClientStuff:SetPlayerScore(Stream)
	local bExtended=Stream:ReadBool();
	
	if(bExtended)then  		-- workaround
		Stream:ReadShort();
		Stream:ReadByte();
		Stream:ReadInt();
		Stream:ReadShort();
		Stream:ReadShort();
		Stream:ReadShort();
		return;
	end
	
	local Entity = System:GetEntity(Stream:ReadShort());		
					
	local iScore = Stream:ReadShort();
	local iDeaths = Stream:ReadShort();
	local iEfficiency = Stream:ReadByte();
	local iPing = Stream:ReadShort();

	if not Entity then
		return;								-- no yet synced
	end

	local szName = Entity:GetName();
	
	-- set player score table
	local playerScore={ 
		[1]= { iVal=iScore, iSort=1 },  -- kills score, sort by bigger
		[2]= { iVal=iDeaths, iSort=0 }, -- deaths score, sort by smaller
		[3]= { iVal=iEfficiency, iSort=1 }, -- effiency score, sort by bigger
		[4]= { iVal=iPing, iSort=0 }, -- ping, sort by smaller
		sortby= { [1]=1, [2]=2, [3]=3, [4]=4 }, -- set sort order fields
		name=szName,
		ready=1,
	};
	
	ScoreBoardManager:SetPlayerScore(playerScore);			
end