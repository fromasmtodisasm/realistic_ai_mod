
-----------------------------------------------------------------------------
function Hud:DrawCTFTeamScore(x,y,otherteamstate,team)
	local tclr=self.teamrgb[team];
	%System:DrawImageColor(self.white_dot, x, y, 30, 30, 4,tclr[1],tclr[2],tclr[3],0.4);
	if(otherteamstate)then
		%System:DrawImageColor(self.flag_icon,x,y,30,30,4,0.7,0.7,0.7,0.5);
	else
		%System:DrawImageColor(self.flag_icon,x,y,30,30,4,1,1,1,1);
	end
end

-----------------------------------------------------------------------------
function Hud:DrawTeams(player)
	---TEAMS STUFFF------------------------------------
	local team=Game:GetEntityTeam(player.id);
	--if(team=="red")then
--		%System:DrawImageColor(self.white_dot, 0, 559, 800, 600, 4,1,0,0,0.4);
	--else
	--	%System:DrawImageColor(self.white_dot, 0, 559, 800, 600, 4,0,0,1,0.4);
	--end	
	
	local red_score=Game:GetTeamScore("red");
	local blue_score=Game:GetTeamScore("blue");
	
	--%System:DrawImageColor(self.white_dot, 0, 0, 50, 30, 4,1,0,0,0.4);
	--%Game:WriteHudNumber( 5, 0, red_score, 1, 1, 1, 1, 30, 30);
	--%System:DrawImageColor(self.white_dot, 0, 31, 50, 30, 4,0,0,1,0.4);
	--%Game:WriteHudNumber( 5, 30, blue_score, 1, 1, 1, 1, 30, 30);
	
	if(self.CTF)then
		local red_carrier=Game:GetTeamFlags("red");
		local blue_carrier=Game:GetTeamFlags("blue");
		local red_captured,blue_captured;
		if(red_carrier~=0)then
			red_captured="X";
		end
		
		if(blue_carrier~=0)then
			blue_captured="X";
		end
		self:DrawCTFTeamScore(50,0,blue_captured,"red");
		self:DrawCTFTeamScore(50,31,red_captured,"blue");
		if(Game:GetTeamFlags(team)==player.id)then
			%System:DrawImageColor(self.flag_icon,660,565,30,30,4,1,1,1,1);
		end
	end
end

-----------------------------------------------------------------------------
function Hud:CenterMessage()
	%Game:SetHUDFont("default", "default");
	%Game:WriteHudString(16, 80, self.centermessage, 1, 1, 0, 1, 14, 14);
	self.centermessagetime=self.centermessagetime-_frametime;
	if(self.centermessagetime<0)then
		self.centermessage=nil;
	end
end

-- \param player - usually _localplayer
function Hud:DrawCrosshairName(player)

	if player.cnt==nil then				
		return;									-- player is dead?
	end
	
	if not player.cnt.GetViewIntersection then
		return									-- spectator ?
	end

	-- make sure we use the right font
	%Game:SetHUDFont("default", "default");
	
	local obj=player.cnt:GetViewIntersection();
	
	if obj and obj.ent and obj.ent.entity_type=="player" then
		if BasicPlayer.IsAlive(obj.ent) then
		
			local CompareTeam = Game:GetEntityTeam(obj.ent.id);
			local MyTeam = Game:GetEntityTeam(player.id);
			local curCrossName= tonumber(getglobal("gr_CrossName"));
			if (CompareTeam and MyTeam) then
				System:Log("Debug Crossname: "..curCrossName.."|"..CompareTeam.."-"..MyTeam.."="..CompareTeam==MyTeam);
			end
			if ( (curCrossName==1) or (CompareTeam and CompareTeam~="players" and CompareTeam==MyTeam) ) then
			
				local color="$1";
				
				if self.teamcolors then
					color=self.teamcolors[Game:GetEntityTeam(obj.ent.id)];
				end
				
				if color then
					local name = color.."**$1"..obj.ent:GetName()..color.."**";
					
					local namesizex,namesizy = %Game:GetHudStringSize(name, 20, 20);
					local pos=400-(namesizex*0.5);
					
					%Game:WriteHudString(pos,210,name , 1, 1, 1, 1, 20,20);
				end
			end
		end
	end
end


----------------------------------------------

---------------------------------------------
------------------------------------------------------------
 			
 
