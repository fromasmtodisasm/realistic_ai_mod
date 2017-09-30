ScoreBoardManager =
{
	messages = {},
	visible = 0,
	white_dot=System:LoadImage("Textures/hud/white_dot.tga")
}
-----------------------------------------------------------------------------
-- add player score into score list
function ScoreBoardManager:SetPlayerScore(tblPlayerScore)	
	local currPlayer=count(self.tblScoreList)+1;		
	self.tblScoreList[currPlayer]=tblPlayerScore;
end
-----------------------------------------------------------------------------
-- define current score board fields
function ScoreBoardManager:SetBoardFields(tblFields)	
	self.tblScoreFields=tblFields;
end
-----------------------------------------------------------------------------
function ScoreBoardManager.SetVisible(v)
	ScoreBoardManager.visible = v;
end
-----------------------------------------------------------------------------
function ScoreBoardManager:IsVisible()
	return self.visible;
end
-----------------------------------------------------------------------------
function ScoreBoardManager.ClearScores()
	ScoreBoardManager.tblScoreList = {};
	ScoreBoardManager.teamscores = {};
	ScoreBoardManager.tblScoreFields= {};
end

-----------------------------------------------------------------------------
-- sort items callback
function player_compare(a, b, iIndex)
	if(a and b) then
	
		local iElement=1;
		if(iIndex) then
			iElement=iIndex;
		end
		
		-- get sort field
		local sortby=1;
		if(a.sortby and a.sortby[iElement]) then
			sortby=a.sortby[iElement];
		end
				
		if(a[sortby] and b[sortby]) then
			
			-- sort by item values				
			if(type(a[sortby])=="table" and type(b[sortby])=="table" and a[sortby].iVal and b[sortby].iVal) then
			
				if(a[sortby].iVal~=b[sortby].iVal) then 
				
					-- check sorting type (bigger or smaller)
					if(a[sortby].iSort==1) then
						if(a[sortby].iVal>b[sortby].iVal)then 
							return 1;
						end					
					else
						if(a[sortby].iVal<b[sortby].iVal)then 
							return 1;
						end								
					end					
					
				else
					-- members equal? need to sort recursivelly then
					if(a.sortby[iElement+1]) then
						return player_compare(a, b, iElement+1);
					end
				end
			end				
			
		end
				
				a=[[
		-- all stuff equal?? then just sort by name..
		local entity_a=nil;
		if(a.id) then
			entity_a=System:GetEntity(a.id);
		end
		
		local entity_b=nil;
		if(b.id) then
			entity_b=System:GetEntity(b.id);
		end
			
		if(entity_a and entity_b) then
			if(entity_a:GetName()<entity_b:GetName())then 
				return 1;
			end 
		end]]
		
	end
				
end

-----------------------------------------------------------------------------
function ScoreBoardManager:RenderTeam(team, score, xpos, ypos, xsize, ysize, clr, bspectator, bclass, yScale)	
	Game:SetHUDFont("default", "scoreboard");
	
	local header_textsize = 13;
	local body_textsize = 13;
	
	local fieldSizeList={};
	local fieldScaledSizeList={};
	local headerScaled=(header_textsize-2)*yScale;
	local fieldsSize=0;
	local fieldsScaledSize=0;
	local fieldSpaceSize=%Game:GetHudStringSize("  ", header_textsize, header_textsize);
	local fieldSpaceScaledSize=%Game:GetHudStringSize("  ", headerScaled, headerScaled);

	-- get text fields size	
	for i, val in self.tblScoreFields do		
		if(self.tblScoreFields[i]) then
			fieldSizeList[i]=%Game:GetHudStringSize(self.tblScoreFields[i].."  ", header_textsize, header_textsize);
			fieldsSize=fieldsSize+fieldSizeList[i];
	
			fieldScaledSizeList[i]=%Game:GetHudStringSize(self.tblScoreFields[i].."  ", headerScaled, headerScaled);
			fieldsScaledSize=fieldsScaledSize+fieldScaledSizeList[i];
		end
	end
	
	local tpos=ypos;
	local xoffset=xpos+xsize-10;
	local gamestate=Client:GetGameStateString();
	
	if(not bspectator and self.tblScoreFields)then
		if(score) then
			%Game:WriteHudString(xpos+6, tpos-5*yScale, "@ScoreBoardTeamScore  "..score, 1, 1, 1, 1,  header_textsize*1.4*yScale, header_textsize*1.4*yScale);				
		end
		tpos=tpos+21*yScale;
	
		local fClassOffset=140;
		if(not self.tblScoreFields[0]) then
			fClassOffset=170;
		end
		
		-- +fClassOffset
		local iIndex=1;
		if(self.tblScoreFields[0]) then
			iIndex=-1;			
		end
		
		for i, val in self.tblScoreFields do	
			--if(count(self.tblScoreFields)-i-1>0) then	
				xoffset=xoffset-fieldScaledSizeList[count(self.tblScoreFields)-i+iIndex];	
				%Game:WriteHudString(xoffset, tpos+6*yScale, "$1"..self.tblScoreFields[count(self.tblScoreFields)-i+iIndex], 0, 1, 0, 1, headerScaled, headerScaled);			
			--end
		end
				
		tpos = tpos + 6*yScale;
					
		if(type(team)=="table" and count(team)>1)then
			sort(team,%player_compare);		
		end	
	end
	tpos = tpos - 6*yScale;
			
	local textsizeScaled=body_textsize*yScale;
		
	local currSpecPosX=0;
	local maxSpecPosX=0;
		
	-- output spectators title
	if(bspectator and count(team)>=1) then			
		tpos=tpos+5*yScale;		
		local size=%Game:GetHudStringSize("@ScoreBoardSpectators", textsizeScaled, textsizeScaled);
		%Game:WriteHudString( 400-size*0.5, tpos, "@ScoreBoardSpectators", 1, 1, 1, 1, textsizeScaled, textsizeScaled);
		tpos=tpos+10*yScale;				
	end
	
	-- compute current max width for spectators
	for v, curr in team do														
		if(bspectator and maxSpecPosX<xsize)then		
			if(team[v+1]) then							
				maxSpecPosX=maxSpecPosX+%Game:GetHudStringSize(curr.name..", ", textsizeScaled, textsizeScaled);
			else
				maxSpecPosX=maxSpecPosX+%Game:GetHudStringSize(curr.name, textsizeScaled, textsizeScaled);
			end
		end
	end
				
	for i,val in team do														
		if(not bspectator)then
			tpos=tpos+21*yScale;
		
			local pname = val.name;
					
			if(pname==_localplayer:GetName())then
				if(gamestate=="PREWAR" and val.ready)then
					%Game:WriteHudString( xpos+10, tpos+6*yScale, "$6"..pname, 1, 1, 1, 1, textsizeScaled, textsizeScaled);
				else
					%Game:WriteHudString( xpos+10, tpos+6*yScale, "$6"..pname, 1, 1, 1, 1, textsizeScaled, textsizeScaled);
				end			
			else
				if(gamestate=="PREWAR" and val.ready)then
					%Game:WriteHudString( xpos+10, tpos+6*yScale, "$1"..pname, 1, 1, 1, 1, textsizeScaled, textsizeScaled);
				else
					%Game:WriteHudString( xpos+10, tpos+6*yScale, "$1"..pname, 1, 1, 1, 1, textsizeScaled, textsizeScaled);
				end			
			end
						
			-- display class icon			
			if (bclass and val.class) then				
				local bs = 32/128;
				local by = 4/128;
				local classx=xpos+xsize-10-fieldsScaledSize;
				local textureScaled=20*yScale;
				local offset=((fieldScaledSizeList[0]-fieldSpaceScaledSize)-textureScaled)*0.5;										
																									
				if (val.class == 0) then
					System:DrawImageColorCoords(self.iClassTexture, classx+offset, tpos+2*yScale, textureScaled, textureScaled, 4, 1, 1, 1, 1, 0, 1-by, bs, by);
				elseif (val.class == 1) then
					System:DrawImageColorCoords(self.iClassTexture, classx+offset, tpos+2*yScale, textureScaled, textureScaled, 4, 1, 1, 1, 1, 1-bs, 1-by, 1, by);
				elseif (val.class == 2) then
					System:DrawImageColorCoords(self.iClassTexture, classx+offset, tpos+2*yScale, textureScaled, textureScaled, 4, 1, 1, 1, 1, bs+bs, 1-by, bs+bs+bs, by);
				end	
			end

			-- display fields information			
			xoffset=xpos+xsize-10;
			local fieldx=0;

			if(bclass and val.class) then				

				-- used in assault
				for v, item in fieldSizeList do											
						local currOffset=count(fieldSizeList)-v;		  	
					
			  		if(val[currOffset]) then
			  			local fieldVal=val[currOffset];
							local text="$1"..fieldVal.iVal;
							local textSize=%Game:GetHudStringSize(text, textsizeScaled, textsizeScaled);

							%Game:WriteHudString(xoffset+fieldx-(fieldScaledSizeList[currOffset]+textSize+fieldSpaceScaledSize)*0.5, tpos+6*yScale, text, 1, 1, 1, 1, textsizeScaled, textsizeScaled);
							
							fieldx=fieldx-fieldScaledSizeList[currOffset];
					end								
				end
				
			else
				
				-- used in tdm/ffa
				for v, item in fieldSizeList do					
						local currOffset=count(fieldSizeList)-v+1;		  	
			  		if(val[currOffset]) then
			  			local fieldVal=val[currOffset];
							local text="$1"..fieldVal.iVal;						
							local textSize=%Game:GetHudStringSize(text, textsizeScaled, textsizeScaled);
							
							%Game:WriteHudString(xoffset+fieldx-(fieldScaledSizeList[currOffset]+textSize+fieldSpaceScaledSize)*0.5, tpos+6*yScale, text, 1, 1, 1, 1, textsizeScaled, textsizeScaled);
							fieldx=fieldx-fieldScaledSizeList[currOffset];
					end			
				end		
					
			end
												
			-- is this used ?
			--if(gamestate=="PREWAR" and val.ready)then
			--	Game:WriteHudString( xpos+5, tpos-21*yScale, "$3R", 1, 1, 1, 1, textsizeScaled, textsizeScaled);
			--end
		else					
			local entName=val.name;

			-- current spectator
			if(team[i+1]) then							
				%Game:WriteHudString(currSpecPosX+400-maxSpecPosX*0.5, tpos, entName..", ", 1, 1, 1, 1, textsizeScaled, textsizeScaled);			
				currSpecPosX=currSpecPosX+%Game:GetHudStringSize(entName..", ", textsizeScaled, textsizeScaled);
			else
				%Game:WriteHudString(currSpecPosX+400-maxSpecPosX*0.5, tpos, entName, 1, 1, 1, 1, textsizeScaled, textsizeScaled);			
				currSpecPosX=currSpecPosX+%Game:GetHudStringSize(entName, textsizeScaled, textsizeScaled);
			end
				
			-- clamp maximum size, and recompute maximum spectator width		
			if(currSpecPosX>xsize) then
				currSpecPosX=0;
				tpos=tpos+10*yScale;
				
				for v, curr in team do														
					if(v>i and bspectator and maxSpecPosX<xsize)then
						local entName=curr.name;
						if(team[v+1]) then							
							maxSpecPosX=maxSpecPosX+Game:GetHudStringSize(entName..",  ", textsizeScaled, textsizeScaled);
						else
							maxSpecPosX=maxSpecPosX+Game:GetHudStringSize(entName, textsizeScaled, textsizeScaled);
						end
					end
				end
			end																														
		end								
		
	end
	return ysize;
end

function ScoreBoardManager:RenderTeamGame(bclass)

	if(self.visible==1 and ScoreBoardManager.tblScoreList~=nil)then
	
		local teams={
			blue={},
			red={},
			spectators={}
		}
		
		local bluescore=Game:GetTeamScore("red");
		local redscore=Game:GetTeamScore("blue");
		for id, val in ScoreBoardManager.tblScoreList do			
			
			if (val.type=="Spectator" or val.type=="Player") then
				
				local team=val.team;
				teams[team][count(teams[team])+1]=val;
				
			end			
		end
		
		
		if(not blue and not red) then
	--		return;
		end
																						
		local playersCount=max(count(teams.blue),count(teams.red));
		local spectatorsCount=0; --count(teams.spectators);

		local yScale=1;				
		if(playersCount+spectatorsCount>22) then
			yScale=22/(playersCount+spectatorsCount);
		end		
		
		-- always center scoreboard...
		local ypos=300-(((playersCount+spectatorsCount)+3)*21)*0.5*yScale;		
		
		local ysize=(playersCount+1)*21*yScale;
				
		-- display scoreboard
		ScoreBoardManager:RenderServerInfo(40, ypos-10*yScale, 0, 0, 1, 1.4, yScale);
		ScoreBoardManager:RenderTeamWindow(40, ypos-10*yScale, playersCount, spectatorsCount, 0, 0, 1, 1.4, yScale);
		ScoreBoardManager:RenderTeamWindow(405, ypos-10*yScale, playersCount, spectatorsCount, 1, 0, 0, 1.4, yScale);
					
		-- display teams data
		local bluepos=self:RenderTeam(teams.blue, Game:GetTeamScore("blue"), 45, ypos, 256*1.4, ysize, {0,0,1,0.3}, nil, bclass, yScale);
		local redpos=self:RenderTeam(teams.red, Game:GetTeamScore("red"), 410, ypos, 256*1.4, ysize, {1,0,0,0.3}, nil, bclass, yScale);
		
		-- always increase size to fit..
		if(playersCount>=1) then
			ysize=ysize+55*yScale;						
			ypos=ypos+ysize;
		else
			ypos=ypos+75*yScale;
		end		
						
		-- display spectators data		
		self:RenderTeam(teams.spectators, 0, 40, ypos, 256*1.38, ysize, nil, 1, 0, yScale);		
	end
end

-- render team display window
function ScoreBoardManager:RenderServerInfo(xpos, ypos, r, g, b, xScale, yScale)
		
	-- Display Server name and IP
	local header_textsize = 15;
	local body_textsize = 13;
	local headerScaled=header_textsize*yScale;
	local tpos=ypos;
	local xoffset=xpos+(256*1.4)-10;
	local ipAddr;
	if (Game:IsServer()) then
		ipAddr = Game:GetServerIP();
		local iColon = strfind(ipAddr, ':');
		if (not iColon) then
			ipAddr = ipAddr..":"..getglobal("sv_port");
		end
	else
		ipAddr = getglobal("g_LastIP")..":"..getglobal("g_LastPort");
	end
	%Game:WriteHudString(xpos, tpos-30*yScale, "$1IP: "..ipAddr, 0, 1, 0, 1, headerScaled, headerScaled);			
	%Game:WriteHudString(xpos, tpos-18*yScale, "$1Server: "..tostring(getglobal("g_LastServerName")), 0, 1, 0, 1, headerScaled, headerScaled);			

end
-- render team display window
function ScoreBoardManager:RenderTeamWindow(xpos, ypos, playersCount, spectatorsCount, r, g, b, xScale, yScale)
	local x, y, plCount, specCount=xpos, ypos, playersCount, spectatorsCount;
		
	
	
	-- render red team menu
	Hud:DrawScoreBoard(x, y, xScale, 0.45*yScale, 100, Hud.tmpscoreboard.bar_score, r, g, b, 1, 0, 0);		
	y=y+31*yScale;
	
	Hud:DrawScoreBoard(x, y, xScale, yScale, 100, Hud.tmpscoreboard.bar_info, 1, 1, 1, 1, 0, 0);
	y=y+21*yScale;
	
	while plCount>0 do					
		Hud:DrawScoreBoard(x, y, xScale, yScale, 100, Hud.tmpscoreboard.bar_player, 1, 1, 1, 1, 0, 0);
		y=y+21*yScale;
		plCount=plCount-1;
	end
	
	while specCount>0 do							
		Hud:DrawScoreBoard(x, y, xScale, yScale, 100, Hud.tmpscoreboard.bar_player, 1, 1, 1, 1, 0, 0);
		y=y+21*yScale;
		specCount=specCount-1;
	end
	
	Hud:DrawScoreBoard(x, y, xScale, yScale, 100, Hud.tmpscoreboard.bar_bottom, 1, 1, 1, 1, 0, 0);
end

-------------------------------------------------------------------------------
--CLASSIC INDIVIDUAL GAME (DM etc...)
-------------------------------------------------------------------------------
function ScoreBoardManager:RenderDMGame()
	Game:SetHUDFont("default", "scoreboard");
	
	local header_textsize = 16;
	local body_textsize = 14;
		
	if(self.visible==1 and ScoreBoardManager.tblScoreList~=nil)then
		local players={}
		local spectators={}
				
		for id, val in ScoreBoardManager.tblScoreList do
			--RENDER PLAYERS
			local ent = System:GetEntityByName(val.name);
			if(ent)then
				if (ent.classname=="Player") then
					players[count(players)+1]=val
				elseif (ent.classname=="Spectator") then
					spectators[count(spectators)+1]=val
				end
			end
		end

		if(not players) then
		--	return;
		end

		local playersCount=count(players);
		local spectatorsCount=0; --count(spectators);

		local yScale=1;				
		if(playersCount+spectatorsCount>22) then
			yScale=22/(playersCount+spectatorsCount);
		end		
		
		-- always center scoreboard...
		local ypos=300-(((playersCount+spectatorsCount)+3)*21)*0.5*yScale;		
		
		local ysize=(playersCount+1)*21*yScale;
				
		-- display scoreboard
		ScoreBoardManager:RenderServerInfo(400-256*1.38*0.5, ypos-10*yScale, 0, 0, 1, 1.38, yScale);
		ScoreBoardManager:RenderTeamWindow(400-256*1.38*0.5, ypos-10*yScale, playersCount, spectatorsCount, 0, 0, 1, 1.38, yScale);
							
		-- display teams data
		ScoreBoardManager:RenderTeam(players, nil, 400-256*1.38*0.5+5, ypos, 256*1.38, ysize, {0,0,1,0.3}, nil, 0, yScale);
				
		-- always increase size to fit..
		if(playersCount>=1) then
			ysize=ysize+55*yScale;						
			ypos=ypos+ysize;
		else
			ypos=ypos+75*yScale;
		end
		
		-- display spectators data
		ScoreBoardManager:RenderTeam(spectators, nil, 140, ypos, 256*1.38, ysize, nil, 1, 0, yScale);						
		
	end
end

function ReloadScoreBoard()
	System:Log("\001Reloading Scoreboard...");
	Script:ReloadScript("SCRIPTS/Multiplayer/TDMscoreboard.lua");	
	Script:ReloadScript("SCRIPTS/Assault/Hud/scoreboard.lua");	
end

Input:BindCommandToKey("#ReloadScoreBoard()","f5",1);