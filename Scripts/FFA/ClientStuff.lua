Script:LoadScript("scripts/Multiplayer/ClientStuffLib.lua");
Script:LoadScript("scripts/FFA/shared.lua");

function ClientStuff:ModeDesc()
	return "FFA";
end




--------------------------------------------
function ClientStuff:UpdateScoreboard()
	if not ClientStuff.idScoreboard then
		System:Log("Error: ASSAULT idScoreboard is nil");
		return;
	end

	if ScoreBoardManager:IsVisible()==0 then
		return;
	end
	
	ScoreBoardManager.ClearScores();

	-- set score board fields
	self.scoreFields={ 		
		[1]="@ScoreBoardKills",
		[2]="@ScoreBoardDeaths",
		[3]="@ScoreBoardEfficiency",
		[4]="@ScoreBoardPing",
	};		
	ScoreBoardManager:SetBoardFields(self.scoreFields);
	
	local SBEntityEnt = System:GetEntity(ClientStuff.idScoreboard);
	local SBEntity = SBEntityEnt.cnt;

	local iY,X;
	local iLines=SBEntity:GetLineCount();
	local iColumns=SBEntity:GetColumnCount();
	
	for iY=0,iLines-1 do
		local idThisClient = SBEntity:GetEntryXY(ScoreboardTableColumns.ClientID,iY)-1;		-- first element is the clientid-1
		
		if idThisClient~=-1 then
			local iScore=SBEntity:GetEntryFloatXY(ScoreboardTableColumns.iScore,iY);
			local iDeaths=SBEntity:GetEntryFloatXY(ScoreboardTableColumns.iDeaths,iY);
			local iPlayerTeam=SBEntity:GetEntryFloatXY(ScoreboardTableColumns.iPlayerTeam,iY);
			local iSuicides=SBEntity:GetEntryFloatXY(ScoreboardTableColumns.iSuicides,iY);
			local szName=SBEntity:GetEntryXY(ScoreboardTableColumns.sName,iY);
			local iPing=SBEntityEnt.PingTable[idThisClient];

			if not iPing then
				iPing=999;
			end
			
			local sType="Player";
		
			if iPlayerTeam==0 then
				sType="Spectator";
			end
			
			local iEfficiency=self:CalcEfficiency(iScore,iDeaths,iSuicides);

			-- set player score table
			local playerScore={ 
				[1]= { iVal=iScore, iSort=1 }, -- kills score, sort by bigger
				[2]= { iVal=iDeaths, iSort=0 }, -- deaths score, sort by smaller
				[3]= { iVal=iEfficiency, iSort=1 }, -- effiency score, sort by bigger
				[4]= { iVal=iPing, iSort=0 }, -- ping, sort by smaller
				sortby= { [1]=1, [2]=2, [3]=3, [4]=4 }, -- set sort order fields
				type=sType,
				name=szName,
				ready=1,
			};
			ScoreBoardManager:SetPlayerScore(playerScore);		
		end	
	end
end