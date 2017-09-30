
cl_display_hud = 1
cl_drunken_cam = 0
ThirdPersonView = 0
--p_model = "objects/characters/pmodels/hero/hero.cgf"

--Input:BindCommandToKey('#Movie:StopAllCutScenes()',"F7",1)
--Input:BindCommandToKey("\\SkipCutScene","F7",1)

-- Developer Cheat keys ---

--- non standard key bindings ---
-- Please NEWER use F9,F10 keys (reserved for debug purposes) (Vlad)

--Input:BindCommandToKey("#SwitchCameraMode()","f1",1)
-- Input:BindCommandToKey("#r_GetScreenShot=1","f12",1)  -- this is now bindable
Input:BindCommandToKey("#ToggleAIInfo()","f11",1)

--Input:BindCommandToKey("#ToggleScreenshotMode()","f11",1)

Input:BindCommandToKey("#ToggleNewDesignerMode(10,15,0)","f4",1)

-- to be removed
Input:BindCommandToKey("#GotoNextSpawnpoint()","f2",1)
Input:BindCommandToKey("#MoreAmmo()","o",1)
Input:BindCommandToKey("#AllWeapons()","p",1)
Input:BindAction("SAVEPOS", "f9", "default")
Input:BindAction("LOADPOS", "f10", "default")
Input:BindCommandToKey("#ToggleNewDesignerMode(40,120,1)","f3",1)
Input:BindCommandToKey("#System:ShowDebugger() ", "f8", 1)

Input:BindCommandToKey("#CamZoomOut()","-",1) -- Zooms out
Input:BindCommandToKey("#CamZoomIn()","=",1) -- Zooms in
Input:BindCommandToKey("#ToggleGod()","backspace",1)
Input:BindCommandToKey("#ToggleAITestMode()","i",1)
Input:BindCommandToKey("\\save_game Current","f9",1)
Input:BindCommandToKey("\\load_game Current","f10",1)

-- to be removed

-- removed
--Input:BindCommandToKey("#Game.Save()","f5",1)
--Input:BindCommandToKey("#Game.Load()","f6",1)
--Input:BindCommandToKey("#DefaultSpeed()","f5",1)
--Input:BindCommandToKey("#DecreseSpeed()","-",1)
--Input:BindCommandToKey("#IncreseSpeed()","=",1)
--Input:BindCommandToKey("#p_single_step_mode=1-p_single_step_mode","[",1)
--Input:BindCommandToKey("#p_do_step=1","]",1)
--Input:BindCommandToKey("#TCM()",".",1)
--Input:BindCommandToKey("#e_hires_screenshoot=4","f10",1)
-- removed


--- temp variables for functions below ---
prev_speed_walk=p_speed_walk
prev_speed_run=p_speed_run

prev_speed_walk2=p_speed_walk
prev_speed_run2=p_speed_run

default_speed_walk=p_speed_walk
default_speed_run=p_speed_run

screenshotmode=0

function ToggleAIInfo()

	if (not aiinfo) then
		aiinfo=1
	else
		aiinfo=1-aiinfo
	end

	if (aiinfo==1) then
		ai_debugdraw=1
		ai_drawplayernode=1
		ai_area_info=1
	else
		ai_debugdraw=0
		ai_drawplayernode=0
		ai_area_info=0
	end
end

function GotoNextSpawnpoint()

	Hud:AddMessage("[NEXT]: next spawn point")

	local pt
	pt=Server:GetNextRespawnPoint()

	if(not pt)then 												-- last respawn point or there are no respawn points
		pt=Server:GetFirstRespawnPoint() 		-- try to get the first one
	end

	if(pt)then 														-- if there is one
		Game:ForceEntitiesToSleep()

		_localplayer:SetPos(pt)
		_localplayer:SetAngles({ x = pt.xA, y = pt.yA, z = pt.zA })
	end
end

function SetPlayerPos()
	local p=_localplayer
	p:SetPos({x=100,y=100,z=300})
end

-- replacement for ToggleSuperDesignerMode() and ToggleDesignerMode()
--
-- USAGE:
--  deactivate designer mode: (nil,nil,0)
--  old super designer mode (with collision): (40,120,1)
--  old designer mode (without collision): (10,15,0)
--  change values: call with (nil,nil,0) then with the new values (0.., 0.., 0/1)
--
function ToggleNewDesignerMode( speedwalk, speedrun, withcollide )

	if(SuperDesignerMode_Save1~=nil or speedwalk==nil) then
		Hud:AddMessage("[CHEAT]: Designer fly mode OFF")

 		p_speed_walk = SuperDesignerMode_Save1
		p_speed_run = SuperDesignerMode_Save2
		_localplayer.DynProp.gravity = SuperDesignerMode_Save3
		_localplayer.DynProp.inertia = SuperDesignerMode_Save4
		_localplayer.DynProp.swimming_gravity = SuperDesignerMode_Save5
		_localplayer.DynProp.swimming_inertia = SuperDesignerMode_Save6
		_localplayer.DynProp.air_control = SuperDesignerMode_Save7
		_localplayer.cnt:SetDynamicsProperties( _localplayer.DynProp )
		SuperDesignerMode_Save1=nil

		-- activate collision, parameter is 0 or 1
		_localplayer:ActivatePhysics(1)

	else
		Hud:AddMessage("[CHEAT]: Designer fly mode ON")

 		SuperDesignerMode_Save1 = p_speed_walk
		SuperDesignerMode_Save2 = p_speed_run
		SuperDesignerMode_Save3 = _localplayer.DynProp.gravity
		SuperDesignerMode_Save4 = _localplayer.DynProp.inertia
		SuperDesignerMode_Save5 = _localplayer.DynProp.swimming_gravity
		SuperDesignerMode_Save6 = _localplayer.DynProp.swimming_inertia
		SuperDesignerMode_Save7 = _localplayer.DynProp.air_control

		p_speed_walk = speedwalk
		p_speed_run = speedrun
		_localplayer.DynProp.gravity=0.0
		_localplayer.DynProp.inertia=0.0
		_localplayer.DynProp.swimming_gravity=0.0
		_localplayer.DynProp.swimming_inertia=0.0
		_localplayer.DynProp.air_control=1.0
		_localplayer.cnt:SetDynamicsProperties( _localplayer.DynProp )

		-- deactivate collision, parameter is 0 or 1
		_localplayer:ActivatePhysics(withcollide)
	end
end

function ToggleScreenshotMode()
	if(screenshotmode~=0) then
		System:Log("SCREENSHOTMODE OFF-->SWITCH TO NORMAL")
		screenshotmode=0
		hud_crosshair = "1"
		cl_display_hud = "1"
		r_NoDrawNear = "0"
		ai_ignoreplayer = "0"
		ai_soundperception = "1"
		r_DisplayInfo = "1"
	else
		System:Log("SCREENSHOTMODE ON")
		screenshotmode=1
		hud_crosshair = "0"
		cl_display_hud = "0"
		r_NoDrawNear = "1"
		ai_ignoreplayer = "1"
		ai_soundperception = "0"
		r_DisplayInfo = "0"
	end
end

function ToggleAITestMode()
	if AITestMode==1 then
		System:Log("AI TEST MODE OFF")
		AITestMode = 0
		ai_ignoreplayer = "0"
		game_DifficultyLevel = Difficulty
		god = SaveGod
		_localplayer.UnlimitedNighVision = nil
		-- _localplayer.items.heatvisiongoggles = SaveCryVision
		-- ai_soundperception = 1 -- Через GameRules в OnUpdate.
		if not _localplayer.SaveSoundRadius then
			_localplayer.soundRadius.run = 3.0
			_localplayer.soundRadius.walk = 1.0
			_localplayer.soundRadius.crouch = .5
			_localplayer.soundRadius.prone = .25
			_localplayer.soundRadius.jump = 3.0
			_localplayer.soundRadius.sprint = 12.0
		else
			_localplayer.soundRadius = _localplayer.SaveSoundRadius
		end
	else
		System:Log("AI TEST MODE ON")
		AITestMode = 1
		ai_ignoreplayer = "1"
		Difficulty = game_DifficultyLevel
		game_DifficultyLevel = "4"
		SaveGod = god
		god = 1
		-- SaveCryVision = _localplayer.items.heatvisiongoggles
		-- _localplayer.items.heatvisiongoggles = 1
		_localplayer.UnlimitedNighVision=1
		-- ai_soundperception = 1
		_localplayer.SaveSoundRadius = new(_localplayer.soundRadius)
		for i,val in _localplayer.soundRadius do
			_localplayer.soundRadius[i]=0
		end
		-- for i,val in _localplayer.soundRadius do
			-- System:Log("soundRadius: i: "..i..", val: "..val)
		-- end
		-- for i,val in _localplayer.SaveSoundRadius do
			-- System:Log("SaveSoundRadius: i: "..i..", val: "..val)
		-- end
	end
end

function ToggleGod()
	if (not god) then
		god=1
	else
		god=1-god
	end
	if (god==1) then
		Hud:AddMessage("[CHEAT]: GOD MODE ON")
		System:Log("\001CHEAT: GOD MODE ON")
	else
		Hud:AddMessage("[CHEAT]: GOD MODE OFF")
		System:Log("\001CHEAT: GOD MODE OFF")
	end
end

function DecreseSpeed()
	if tonumber(p_speed_walk)>5 then
		p_speed_walk=p_speed_walk-5
		p_speed_run=p_speed_run-5
		System:Log("Decresed player speed by 5")
	else
		System:Log("You can not go any slower!")
	end
end

function IncreseSpeed()
	if tonumber(p_speed_walk)<500 then
		p_speed_walk=p_speed_walk+5
		p_speed_run=p_speed_run+5
		System:Log("Incresed player speed by 5")
	else
		System:Log("You can not go any faster!")
	end
end

function DefaultSpeed()
	p_speed_walk=default_speed_walk
	p_speed_run=default_speed_run
	System:Log("Player speed reset")
end

function TeleportToSpawn(n)
	local player = _localplayer
	local pos = Server:GetRespawnPoint("Respawn"..n)
	if pos then
		player:SetPos(pos)
		player:SetAngles({ x = pos.xA, y = pos.yA, z = pos.zA })
	end
end

-- Give the player the passed weapon, load it if neccesary
function AddWeapon(Name)
	Game:AddWeapon(Name)
	for i, CurWeapon in WeaponClassesEx do
		if (i == Name) then
			_localplayer.cnt:MakeWeaponAvailable(CurWeapon.id)
		end
	end
end

function CamZoomIn()
	if tonumber(ThirdPersonRange)>1 then -- try to always keep this number over 1 else youll get some glitches
		ThirdPersonRange = ThirdPersonRange-1
	end
end

function CamZoomOut()
	if tonumber(ThirdPersonRange)<15 then
		ThirdPersonRange = ThirdPersonRange+1
	end
end

function MoreAmmo()
-- local amount_toadd=nil
 -- local p=_localplayer
 -- Hud:AddMessage(" $4 Max Ammo Added")
 -- amount_toadd=MaxAmmo["Pistol"] - p:GetAmmoAmount("Pistol")
 -- p:AddAmmo("Pistol",amount_toadd)
 -- amount_toadd=MaxAmmo["Assault"] - p:GetAmmoAmount("Assault")
 -- p:AddAmmo("Assault",amount_toadd)
 -- amount_toadd=MaxAmmo["SMG"] - p:GetAmmoAmount("SMG")
 -- p:AddAmmo("SMG",amount_toadd)
 -- amount_toadd=MaxAmmo["Sniper"] - p:GetAmmoAmount("Sniper")
 -- p:AddAmmo("Sniper",amount_toadd)
 -- amount_toadd=MaxAmmo["Shotgun"] - p:GetAmmoAmount("Shotgun")
 -- p:AddAmmo("Shotgun",amount_toadd)
 -- amount_toadd=MaxAmmo["Rocket"] - p:GetAmmoAmount("Rocket")
 -- p:AddAmmo("Rocket",amount_toadd)
 -- amount_toadd=MaxAmmo["OICWGrenade"] - p:GetAmmoAmount("OICWGrenade")
 -- p:AddAmmo("OICWGrenade",amount_toadd)
 -- amount_toadd=MaxAmmo["AG36Grenade"] - p:GetAmmoAmount("AG36Grenade")
 -- p:AddAmmo("AG36Grenade",amount_toadd)
-- end

	-- _localplayer.Ammo["Pistol"] = MaxAmmo["Pistol"]
	-- _localplayer.Ammo["SMG"] = MaxAmmo["SMG"]
	-- _localplayer.Ammo["FlashbangGrenade"] = MaxAmmo["FlashbangGrenade"]
	-- _localplayer.Ammo["SmokeGrenade"] = MaxAmmo["SmokeGrenade"]

	if _localplayer and Hud then
		_localplayer.cnt.ammo=999  -- Временно.
		if _localplayer.fireparams then
			_localplayer.cnt.ammo_in_clip = _localplayer.fireparams.bullets_per_clip
		end
		for i,val in MaxAmmo do
			if _localplayer.Ammo[i]~=val then
				_localplayer.Ammo[i]=val
			end
			_localplayer.Ammo["GlowStick"] = 0
		end
		Hud:AddMessage("[CHEAT]: Give 999 ammo")
		System:Log("\001CHEAT: Give 999 ammo")
		-- Hud:AddMessage("[CHEAT]: Give max ammo for all weapons")
		-- System:Log("\001CHEAT: Give max ammo for all weapons")
	-- else
		-- Hud:AddMessage("[CHEAT]: no ammo today")
	end
end

function AllWeapons()
	-- Цикл делать не стал, так как не нужно лишнее оружие.
	-- "Больше не помещается" - в прошлом, всё теперь поместится.
	local SelectFirstWeapon
	if _localplayer.cnt:GetCurrWeaponId()==9 then
		_localplayer.cnt:MakeWeaponAvailable(9,0) -- Убрать руки.
		SelectFirstWeapon=1
	end
	AddWeapon("Machete")  -- А может такую штуку для ботов можно замутить? Функция AddWeapon находится выше. int CScriptObjectGame::AddWeapon(IFunctionHandler *pH)
	AddWeapon("Falcon")
	AddWeapon("M4")
	AddWeapon("SniperRifle")
	AddWeapon("RL")
	AddWeapon("MP5")
	AddWeapon("P90")
	AddWeapon("M249")
	AddWeapon("Shotgun")
	AddWeapon("AG36")
	AddWeapon("OICW")
	AddWeapon("Shocker")
	-- AddWeapon("Wrench")
	if SelectFirstWeapon then
		_localplayer.cnt:SelectFirstWeapon()
	end
	_localplayer.cnt:GiveBinoculars(1)
	_localplayer.cnt:GiveFlashLight(1)
	_localplayer.items.heatvisiongoggles = 1
	-- _localplayer.Ammo["HandGrenade"] = MaxAmmo["HandGrenade"]
	-- _localplayer.Ammo["FlashbangGrenade"] = MaxAmmo["FlashbangGrenade"]
	-- _localplayer.Ammo["SmokeGrenade"] = MaxAmmo["SmokeGrenade"]
	-- _localplayer.cnt.numofgrenades = MaxAmmo["HandGrenade"]
	-- _localplayer.Ammo["HandGrenade"] = 999
	-- _localplayer.Ammo["FlashbangGrenade"] = 999
	-- _localplayer.Ammo["SmokeGrenade"] = 999

	Hud:AddMessage("[CHEAT]: Give all weapons")
	System:Log("\001CHEAT: Give All weapons")
end

-- function VisionAids()
	-- _localplayer.cnt:GiveBinoculars(1)
	-- _localplayer.cnt:GiveFlashLight(1)
	-- _localplayer.items.heatvisiongoggles = 1
	-- _localplayer.cnt.grenadetype=6  -- Flare Nade
	-- _localplayer.cnt.numofgrenades=99
	-- _localplayer.Ammo["GlowStick"]=99
	-- Hud:AddSubtitle("$8 Binocs $2 Flashlight $3 Flare 'Nades $1 and $4 Heat Vision $1 Added")
-- end
-- Input:BindCommandToKey("#VisionAids()","v",1)