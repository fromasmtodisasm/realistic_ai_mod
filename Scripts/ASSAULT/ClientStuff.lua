
Script:LoadScript("scripts/Multiplayer/ClientStuffClassLib.lua");							-- derive functionality

ClientStuff.SndIdAvertCapture=Sound:LoadSound("Sounds/Items/seek.wav");				-- sound id, for a Multiplayer hit, cannot be local because of garbage collector	

function ClientStuff:OnUpdate()				
	self.vlayers:Update();
end

function ClientStuff:ModeDesc()
	return "Assault";
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
				[0]="@ScoreBoardClass",
				[1]="@ScoreBoardKills",
				[2]="@ScoreBoardSupport",
				[3]="@ScoreBoardScore",
				[4]="@ScoreBoardPing",
			};		
			ScoreBoardManager:SetBoardFields(self.scoreFields);
		end
	end
end

function ClientStuff:SetPlayerScore(Stream)
	local bExtended=Stream:ReadBool();
	
	if(not bExtended)then  		-- workaround
		Stream:ReadShort();
		Stream:ReadShort();
		Stream:ReadShort();
		Stream:ReadByte();
		Stream:ReadShort();
		return;
	end
	
	local Entity = System:GetEntity(Stream:ReadShort());		
				
	local iClass = Stream:ReadByte(); -- read the class of the player: 0 = grunt, 1 = support, 2 = sniper
	local iTotalScore = Stream:ReadInt();
	local iSupportScore = Stream:ReadShort();
	local iKillScore = Stream:ReadShort();
	local iPing = Stream:ReadShort();
	
	if not Entity then
		return;								-- no yet synced
	end
	
	local szName = Entity:GetName();
	
	-- set player score table
	local playerScore={ 
		[1]= { iVal=iKillScore, iSort=1 }, -- kills core, sort by bigger
		[2]= { iVal=iSupportScore, iSort=1 }, -- support score, sort by bigger
		[3]= { iVal=iTotalScore, iSort=1 }, -- total score, sort by bigger
		[4]= { iVal=iPing, iSort=0 },  -- ping, sort by smaller
		sortby= { [1]=3, [2]=1, [3]=2, [4]=4 }, -- set sort order fields
		class=iClass,
		name=szName,
		ready=1,
	};
	
	ScoreBoardManager:SetPlayerScore(playerScore);			
end

---------------------------------------------------------------------------------
-- Avert Caprture sound playback
-- e.g. "AVC" 
ClientStuff.ServerCommandTable["AVC"]=function(String,toktable)
	Sound:PlaySound(ClientStuff.SndIdAvertCapture);
end;