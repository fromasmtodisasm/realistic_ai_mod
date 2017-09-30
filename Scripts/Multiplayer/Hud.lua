-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- non team Head up display
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
	
Script:LoadScript("scripts/GUI/HudCommon.lua");
Script:LoadScript("scripts/GUI/HudMultiplayer.lua");

Hud.PlayerObjective=nil;			-- sycronized string for HUD e.g. POAtt or PODef


-----------------------------------------------------------------------------
function Hud:OnInit()
	self:CommonInit();	
	Language:LoadStringTable("MultiplayerHUD.xml");
end
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

function Hud:OnUpdate()

	%Game:SetHUDFont("hud", "ammo");


	local player=_localplayer;

	
	
	
	if (player) then
		if(player or (player.entity_type=="spectator") and player.cnt ~= nil)then 
			
				--overlay
				ClientStuff.vlayers:DrawOverlay();
		
				-- [tiago] display onscreen fx, when player gets damage	(only when smokeblur layer not active)
				if (not ClientStuff.vlayers:IsActive("SmokeBlur") and not ClientStuff.vlayers:IsFading("SmokeBlur")) then							
					-- check damage/hits...
					if(self.hitdamagecounter>0) then
						-- [tiago] testing blury/bloody screen fx
						System:SetScreenFx("ScreenBlur", 1);								
						self.hitdamagecounter=self.hitdamagecounter - _frametime*3.5;
						System:SetScreenFxParamFloat("ScreenBlur", "ScreenBlurAmount", self.hitdamagecounter/10.0);
					else
						System:SetScreenFx("ScreenBlur", 0);
						self.hitdamagecounter=0;
					end
							
				end
				
				---------------------------------------------------
				--moved panoramic display before hud visibility check because we need panoramic in cut-scenes and dont anything else
				if(hud_panoramic=="1")then
					%System:DrawImage(self.black_dot, 0, 0, 800, tonumber(hud_panoramic_height), 0);
					%System:DrawImage(self.black_dot, 0, 600-tonumber(hud_panoramic_height), 800, tonumber(hud_panoramic_height), 0);
				end
				-- place to check
				if(cl_display_hud == "0" or self.bHide)then
					return
				end
		
				--DRAW DM SCORE
					
				self:DrawCrosshairName(player);		
				
				--infos
				%Game:SetHUDFont("hud", "ammo");
				
				self:OnUpdateCommonHudElements();

				if Hud.PlayerObjective then
					Game:WriteHudString( 10, 100, "@"..Hud.PlayerObjective, 1, 1, 1, 1, 30, 30);
				end

				--Hud:DrawGooglesOMeter(759,385);
		
		end -- non for the spectator
			if (player.entity_type=="spectator") then
		
				if(cl_display_hud == "0" or self.bHide)then
					return
				end
		
				local sFollowName="";
				-- changed
		
				if(player and player.cnt)then
					if (player.cnt.GetHost) then
						local idHost=player.cnt:GetHost();
						local entHost=System:GetEntity(idHost);
			
						if(entHost)then
							sFollowName=entHost:GetName();
						end
					end
				end
				--spectator
				%Game:SetHUDFont("hud", "ammo");
				%Game:WriteHudString( 10, 10, "@Spectating "..sFollowName, 1, 1, 1, 1, 35, 35);
				%Game:WriteHudString( 10, 40, "@OpenMenuAndJoinNonTeam", 1, 1, 1, 1, 20, 20);
				
				self:DrawCrosshairName(player);
				self:OnUpdateCommonHudElements();
				
	end
end
	self:FlushCommon();
	------------------------------------------
	--if(getn(self.messages)>0)then
	
	self:MessagesBox();
	%Game:SetHUDFont("hud", "ammo");
	
	--end
	if(self.centermessage)then
		self:CenterMessage();
	end
	ScoreBoardManager:Render();
	
						
	%Game:SetHUDFont("hud", "ammo");
	
	if(cl_display_hud ~= "0" and not self.bHide)then
		local iGameState = Client:GetGameState();
		local fTimeLimit = Hud.fTimeLimit;
	
		if (iGameState == CGS_INPROGRESS) then
		
			if (fTimeLimit and (fTimeLimit > 0)) then	
				local fTime = floor(fTimeLimit * 60) - (_time - Client:GetGameStartTime());
				Hud:DrawRightAlignedString("@TimeLeft 99:99","@TimeLeft "..SecondsToString(max(fTime, 0)), 20, 20, 1, 1, 1, 1, 60, 5);
			else
				Hud:DrawRightAlignedString("@NoTimeLimit","@NoTimeLimit", 20, 20, 1, 1, 1, 1, 60, 5);
			end
		
			-- if we have a respawn cycle
			if ((self.iRespawnCycleStart ~= nil) and (self.iRespawnCycleStart ~= nil)) then
	
				local fTime = ceil(self.iRespawnCycleLength - (_time - self.iRespawnCycleStart));						
	
				Hud:DrawRightAlignedString("@Reinforcements 99","@Reinforcements "..tostring(max(fTime, 0)), 20, 20, 1, 1, 1, 1, 73, 5);
			end
	
		elseif (iGameState ~= CGS_INTERMISSION) then
	
			Game:WriteHudString( 360, 20, "@PREWAR", 1, 1, 0, 1, 30, 30);
		
		end
	end		
end


-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
function Hud:OnShutdown()
	%System:Log("Hud:OnShutdown()");
end
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
