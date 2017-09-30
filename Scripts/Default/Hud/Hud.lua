Script:LoadScript("scripts/GUI/HudCommon.lua")

Hud.objectives={}

function Hud:PushObjective(pos,text)
	--check if the objective is already present
	for i,val in self.objectives do
		if (val.text==text) then
			return
		end
	end
	self.objectives[getn(self.objectives)+1]={pos=new(pos),text=text,completed=nil}
end
-----
function Hud:FlashObjectives()
	self.objectives={}
end

-- [marco] remove it based on objective name
-----
function Hud:CompleteObjective(text)
	for i,val in self.objectives do
		if (val.text==text) then
			val.completed=1
			-- break --in editor mode,there can be more than 1 with the same name
		end
	end
end


-----
function Hud:OnInit()
	System:Log("Hud:OnInit()")
	-- concentration
--	if (s_SFXVolume) then
--		g_GlobalSFXVolume=tonumber(s_SFXVolume)
--	else
--		g_GlobalSFXVolume=0
--	end

	self:CommonInit()
end

-----
function Hud:OnUpdate()
	local player=_localplayer

	-- Update Dynamic music.
	self:UpdateDynamicMusic()

	-- [marco] The environment can be affected by lightning,which blinds any player
	-- using Night Vision for a brief period. In case of the night vision
	-- is done in the above call.
	if (tonumber(cl_display_hud)~=0 and not self.bHide) then
		if (player and player.classname=="Player") then
			ClientStuff.vlayers:DrawOverlay()
			if self.showCenterIcon then
			-- any number of seconds here
				if _time<=self.showCenterIcon+5 and not player.cnt.use_pressed then -- Либо пять секунд, либо кнопка.
					%System:DrawImageColor(self.icon_team_reload, 400 - 64, 300 - 64, 128, 128, 4, 1, 1, 1, 1)
				else
					self.showCenterIcon = nil
				end
			end
		      -- Display on screen damage fx
		    if (hud_screendamagefx=="1" and g_gore~="0") then
				if (not ClientStuff.vlayers:IsActive("SmokeBlur") and not ClientStuff.vlayers:IsFading("SmokeBlur"))
				or not BasicPlayer.IsAlive(player) then -- Когда умер, то обновлять нужно в любом случае.
					-- check damage/hits...
					if (self.hitdamagecounter>0) then
						local fTime=_frametime
						-- something is wrong with frametime. Clamp it.
						if (fTime<.002) then
							fTime=.002
						elseif (fTime>.5) then
							fTime=.5
						end
						System:SetScreenFx("ScreenBlur",1)
						self.hitdamagecounter=self.hitdamagecounter - fTime*3.5
						System:SetScreenFxParamFloat("ScreenBlur","ScreenBlurAmount",self.hitdamagecounter/10)
					else
						System:SetScreenFx("ScreenBlur",0)
						self.hitdamagecounter=0
					end
				end
		    end

			self.SharedSoundScale = 1*255
			-- [lennert] When a loud noise occurs (grenade etc.),the player will be deafened. Client-effect only...
			if (self.deaf_time and self.initial_deaftime) then -- Раньше выбивало nil после перезагрузки.
				--System:Log("deafened:"..self.deaf_time)
				local fSoundScale=1
				-- [marco] gives a couple of seconds before starting
				-- the deafness so that the player will ear the explosion
				-- Задержка перед оглушением.
				if (self.deaf_time<(self.initial_deaftime-1.7)) then
					if (self.deaf_time<self.deafness_fadeout_time) then
						fSoundScale=self.deaf_time/self.deafness_fadeout_time
					end
					self.SharedSoundScale = (1-fSoundScale)*255
					Sound:SetGroupScale(SOUNDSCALE_DEAFNESS,1-fSoundScale)
					if (not Sound:IsPlaying(self.EarRinging)) then
						--System:Log("start ear ringing")
						Sound:PlaySound(self.EarRinging)
					end
					Sound:SetSoundVolume(self.EarRinging,fSoundScale*255)
				end

				self.deaf_time=self.deaf_time-_frametime
				if (self.deaf_time<=0) then
					self.deaf_time=nil
					Sound:StopSound(self.EarRinging)
					Sound:SetGroupScale(SOUNDSCALE_DEAFNESS,1)
				end
			end

			-- self.SharedSoundScale = 0 -- Тестовая! Для заглушки именно 3D звуков! 2D при включенном EAX продолжают глохнуть нормально!
			
			--infos
			%Game:SetHUDFont("hud","ammo")

			--if (not ClientStuff.vlayers:IsActive("Binoculars") and player.cnt.health>0) then
			--	self:DrawCompass(player)
			--end

			-- update hud
			self:OnUpdateCommonHudElements()
			-- display items
			self:DrawItems(player)

			%Game:SetHUDFont("hud","ammo")
			-- GOD O METER-------------------------------------------------
			if god and tonumber(god)==1 then
				%Game:WriteHudString(10,10,"GOD "..GameRules.god_mode_count,0,1,0,1,30,30)
			end

			-- display mission box
			ScoreBoardManager:Render()

			-- display messages
			self:MessagesBox()

		end
	end


	if (player and player.classname=="Player") then
		-- only player gets 'panoramic'.. (there's some bug in renderer, i have to set ONE ZERO blending mode,since blending is not reseted for some reason)
	 	if (hud_panoramic=="1") then
			%System:DrawImageColorCoords(self.black_dot,0,0,800,tonumber(hud_panoramic_height),9,0,0,0,.5,0,0,1,1)
			%System:DrawImageColorCoords(self.black_dot,0,600-tonumber(hud_panoramic_height),800,tonumber(hud_panoramic_height),9,0,0,0,.5,0,0,1,1)
		end

		-- display subtitles when required
		if tonumber(getglobal("game_subtitles2"))==1 then
			self:SubtitlesBox()
		end
	end
end

-------
-- Available DynamicMusic mood events.
-------
DynamicMusicMoodEvents = {
	Alert = {mood = "Alert",timeout = MM_ALERT_TIMEOUT},
	Suspense = {mood = "Suspense",timeout = MM_SUSPENSE_TIMEOUT},
	NearSuspense = {mood = "NearSuspense",timeout = MM_NEARSUSPENSE_TIMEOUT},
	Combat = {mood = "Combat",timeout = 0},
	Victory = {mood = "Victory",timeout = 0}
}

-------
-- Controls moods in dynamic music.
-------
function Hud:UpdateDynamicMusic()
	local sneak = AI:GetPerception()
	local moodEvent = nil

	--System:Log("Sneak="..sneak)
	if (sneak > 110) then
		-- if the AI starts attacking we send a COMBAT-mood event
		moodEvent = DynamicMusicMoodEvents.Combat
	elseif ((sneak > 0 and sneak <= 110) or (self.EnemyAlerted~=0)) then
		-- if the AI starts attacking we send a COMBAT-mood event
		moodEvent = DynamicMusicMoodEvents.Alert
	elseif (self.EnemyInNearSuspense~=0) then
		-- if the AI is very near we send a NEAR-mood event
		moodEvent = DynamicMusicMoodEvents.NearSuspense
	elseif (self.EnemyInSuspense~=0) then
		-- if the AI is near we send a SUSPENSE-mood event
		moodEvent = DynamicMusicMoodEvents.Suspense
	end

	if (self.PrevSneakValue) then
		if (self.PrevSneakValue>50) and (sneak==0) and (Sound:IsInMusicMood("Combat") and (self.EnemyAlerted==0)) then
			-- if the sneak value drops instantly from combat to 0 we killed the last guy,so we send a VICTORY-mood event
			--System:Log("VICTORY !!!")
			moodEvent = DynamicMusicMoodEvents.Victory
		end
	end

	if (moodEvent) then
		Sound:AddMusicMoodEvent(moodEvent.mood,moodEvent.timeout)
	end

	self.PrevSneakValue = sneak
end

function Hud:OnShutdown()
	%System:Log("Hud:OnShutdown()")
	self.EarRinging=nil
end

function Hud:DisplayCenterIcon() -- call this function to show the image for five seconds
	self.showCenterIcon = _time
end

function Hud:DrawCrosshairName()
	local player = _localplayer
	if not player.cnt or not player.cnt.GetViewIntersection then return	end
	-- local language = strlower(getglobal("g_language"))
	-- if language and language=="english" then
		-- %Game:SetHUDFont("FARCEB__","ExtraBold")
	-- else
		-- -- System:LoadFont("default")
		%Game:SetHUDFont("default","default")
	-- end
	local obj=player.cnt:GetViewIntersection()
	if obj and obj.ent and obj.ent.entity_type=="player" then
		if BasicPlayer.IsAlive(obj.ent) and player.Properties.species==obj.ent.Properties.species then
			local Name = obj.ent:GetName()
			-- Name = strupper(Name)
			local LowerName = strlower(Name)
			if LowerName=="lock" or LowerName=="den" or LowerName=="dooch" or LowerName=="lockdub" or LowerName=="dendub" or LowerName=="doochdub" then
				Name = "@"..Name
			else
				Name = "$2**$1"..Name.."$2**"
			end
			local namesizex,namesizy = %Game:GetHudStringSize(Name,20,20)
			local pos=400-(namesizex*.5)
			%Game:WriteHudString(pos,210,Name,1,1,1,1,20,20)
		end
	end
end