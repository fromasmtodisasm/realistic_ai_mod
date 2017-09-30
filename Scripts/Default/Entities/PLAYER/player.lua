-- Script:LoadScript("Scripts/AI/BasicAI.lua")
-- Script:ReloadScript("Scripts/AI/BasicAI.lua")
Player = {
	painSounds = {
			{"languages/voicepacks/Jack/pain_1.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_2.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_3.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_4.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_5.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_6.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_7.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_8.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_9.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_10.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_11.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_12.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_13.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_14.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_15.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_16.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_17.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_18.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_19.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_20.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_21.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_22.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_23.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_24.wav",0,175,3,30},
			{"languages/voicepacks/Jack/pain_25.wav",0,175,3,30},
			{"languages/voicepacks/Jack/silence1.wav",0,175,3,30},
			{"languages/voicepacks/Jack/silence2.wav",0,175,3,30},
			{"languages/voicepacks/Jack/silence3.wav",0,175,3,30},
			{"languages/voicepacks/Jack/silence4.wav",0,175,3,30},
			{"languages/voicepacks/Jack/silence5.wav",0,175,3,30},

		},

	deathSounds = {
			{"languages/voicepacks/Jack/death_1.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_2.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_3.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_4.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_5.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_6.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_7.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_8.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_9.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_10.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_11.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_12.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_13.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_14.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_15.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_16.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_17.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_18.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_19.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_20.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_21.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_22.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_23.wav",0,175,3,20},
			{"languages/voicepacks/Jack/death_24.wav",0,175,3,20},

		},

	melee_sounds = {
			{"Sounds/Weapons/melee/swish.wav",0,115,3,20},
	},
	EquipmentSounds = {
		Sound:Load3DSound("SOUNDS/player/playermovement/gingle1.wav",SOUND_UNSCALABLE,50,5,30),
		Sound:Load3DSound("SOUNDS/player/playermovement/gingle3.wav",SOUND_UNSCALABLE,50,5,30),
		Sound:Load3DSound("SOUNDS/player/playermovement/gingle5.wav",SOUND_UNSCALABLE,50,5,30),
		Sound:Load3DSound("SOUNDS/player/playermovement/gingle6.wav",SOUND_UNSCALABLE,50,5,30),
		Sound:Load3DSound("SOUNDS/player/playermovement/gingle7.wav",SOUND_UNSCALABLE,50,5,30),
		Sound:Load3DSound("SOUNDS/player/playermovement/gingle8.wav",SOUND_UNSCALABLE,50,5,30),
		Sound:Load3DSound("SOUNDS/player/playermovement/gingle9.wav",SOUND_UNSCALABLE,50,5,30),
		Sound:Load3DSound("SOUNDS/player/playermovement/gingle10.wav",SOUND_UNSCALABLE,50,5,30),
		Sound:Load3DSound("SOUNDS/player/playermovement/gingle11.wav",SOUND_UNSCALABLE,50,5,30),
		Sound:Load3DSound("SOUNDS/player/playermovement/gingle12.wav",SOUND_UNSCALABLE,50,5,30),
		Sound:Load3DSound("SOUNDS/player/playermovement/gingle13.wav",SOUND_UNSCALABLE,50,5,30),
		Sound:Load3DSound("SOUNDS/player/playermovement/gingle14.wav",SOUND_UNSCALABLE,50,5,30),
		Sound:Load3DSound("SOUNDS/player/playermovement/gingle15.wav",SOUND_UNSCALABLE,50,5,30),

	},
	EquipmentSoundProbability=100,

	--other player sounds
	JumpSounds = {
		Sound:Load3DSound("SOUNDS/player/jump.wav",SOUND_UNSCALABLE,175,5,30),
	},

	LightExertion = {
		Sound:Load3DSound("SOUNDS/player/prone_up.wav",SOUND_UNSCALABLE,175,5,30),
		Sound:Load3DSound("SOUNDS/player/prone_down.wav",SOUND_UNSCALABLE,175,5,30),
	},

	--its commented because empty
	--LandSounds = {
		--strong step+equipment sound for normal landing?
	--},

	LandHardSounds = {
		--not used atm,there are already pain sounds.
		Sound:Load3DSound("SOUNDS/player/lite_fall.wav",SOUND_UNSCALABLE,175,5,30),
		Sound:Load3DSound("SOUNDS/player/heavy_fall.wav",SOUND_UNSCALABLE,175,5,30),
	},

	BreathingSounds = {
		Sound:Load3DSound("SOUNDS/player/heavy_breathing_loop.wav",SOUND_UNSCALABLE,150,5,30),
	},

	HealingSounds = {
		Sound:Load3DSound("SOUNDS/player/relief1.wav",SOUND_UNSCALABLE,175,5,30),
	},

	-- COMMENTED DUE TO BAD SOUNDING,PLEASE DO NOT REMOVE YET !!!
	--ExhaustedBreathingSound=Sound:LoadSound("sounds/player/exhaustedbreathLP2.wav",SOUND_UNSCALABLE,255),
	--ExhaustedBreathingStart=3,	-- start breathing after this amount of seconds after start running
	--ExhaustedBreathingStop=2,		-- stop breathing after this amount of seconds after stop running

	MERC = "player",
	IsAiPlayer = 1,
	iLastWaterSurfaceParticleSpawnedTime = _time,
	Energy = 100,
	MaxEnergy = 100,
	EnergyIncreaseRate = 1,	-- units per second
	MinRequiredEnergy = 20,	-- minimum energy needed to turn on heat vision
	EnergyChanged = nil,
	vLastPos = {x=0,y=0,z=0},
	fLastRefractValue = 0,
    bSplashProcessed = nil,
	BinocularsActive = 0,
	FlashLightActive = 0,
	Ammo = {
		Pistol = 0,
		Assault = 0,
		Sniper = 0,
		Minigun = 0,
		Shotgun = 0,
		MortarShells = 0,
		Grenades = 0,
		HandGrenades = 0,
		Rocket = 0,
		Battery = 0,
	},
	WeaponState = nil,
	soundtimer = 0,
	PropertiesInstance = { -- ИИ.
			sightrange = 110,
			soundrange = 10,
			aibehavior_behaviour = "AIPlayerIdle",
			groupid = 0,
			bHelmetOnStart = 0,
			fileHelmetModel = "",
			bHasLight = 0,
			bGunReady = 1,
			attackrange = 500,
			accuracy = .5,
			aggression = .5,
	},

	Properties = {-- По умолчанию параметры игрока находятся в Properties.
			groupid = 0,
			aicharacter_character = "AiPlayer",
			equipEquipment = MainPlayerEquipPack,
			equipDropPack = MainPlayerEquipPack,
			-- fDamageMultiplier = 1,
			fRushPercentage=-1,
			bHasShield = 0,
			bInvulnerable = 0,
			KEYFRAME_TABLE = "BASE_HUMAN_MODEL",
			SOUND_TABLE = "Jack",
			suppressedThrhld = 5.5,
			bAffectSOM = 1,
			bSleepOnSpawn = 0,
			bHasArmor = 0,
			bHelmetOnStart = 0,
			dropArmor = 0,
			horizontal_fov = 160,
			eye_height = 1.6, -- 2
			forward_speed = 1.27, -- 1.27
			back_speed = 1.27,
			responsiveness = 7.5,
			fSpeciesHostility = 2,
			fGroupHostility = 0,
			fPersistence = 0,
			AnimPack = "Basic",
			SoundPack = "Jack",
			fileModel = getglobal("p_model"),
			max_health = 255,
			pathname = "none",
			pathsteps = 0,
			pathstart = 0,
			ReinforcePoint = "none",
			bPushPlayers = 1,
			bPushedByPlayers = 1,
			AttachHelmetToBone = "hat_bone",
			commrange = 30,
			species = 0, -- Если мой species не равен нулю, то цели, отмечаемые биноклем, добавляются на радар очень резко.
			special = 0,
			bTrackable = 1,
			bTakeProximityDamage = 1,
			speed_scales={ -- ИИ
				run			= 5,
				crouch		= 1.6,
				prone		= .6,
				xrun		= 4.5,
				xwalk		= 3.5,
				rrun		= 4.8,
				rwalk		= .94,
			},
			-- AniRefSpeeds = { -- Не убирать, чтобы не было вылетов при загрузке.
			-- -- those are not real scale ceff's - animation will slide,BUT sound for first person should be ok
				-- WalkFwd = 1.5,
				-- WalkSide = 1.5,
				-- WalkBack = 1.5,
				-- XWalkFwd = 1.5,
				-- XWalkSide = 1.5,
				-- XWalkBack = 1.5,
				-- XRunFwd = 4.5,
				-- XRunSide = 3.5,
				-- XRunBack = 4.5,
				-- RunFwd = 4.8,
				-- RunSide = 4.8,
				-- RunBack = 4.8,
				-- CrouchFwd = 1.02,
				-- CrouchSide = 1.02,
				-- CrouchBack = 1.02,
			-- },
			AniRefSpeeds = {	-- Определяет скорость движения анимации ИИ.
				WalkFwd = 1.5, -- Ходит.
				WalkSide = 1.5,
				WalkBack = 1.5,
				XWalkFwd = 1.5, -- Ходит в состоянии скрытности.
				XWalkSide = 1.5,
				XWalkBack = 1.5,
				WalkRelaxedFwd = 1.05, -- Ходит в расслабленном состоянии.
				WalkRelaxedSide = 1.22,
				WalkRelaxedBack = 1.05,
				XRunFwd = 4.5, -- Бегает в состоянии скрытности.
				XRunSide = 3.5, -- Понизить 5.05
				XRunBack = 4.5, -- Понизить 5.05
				RunFwd = 4.8, -- Бежит.
				RunSide = 4.8,
				RunBack = 4.8,
				CrouchFwd = 1.02, -- Сидит.
				CrouchSide = 1.02,
				CrouchBack = 1.02,
			},
	},

	AniRefSpeeds = {
	-- those are not real scale ceff's - animation will slide,BUT sound for first person should be ok
		WalkFwd = 1.5,
		WalkSide = 1.5,
		WalkBack = 1.5,
		XWalkFwd = 1.5,
		XWalkSide = 1.5,
		XWalkBack = 1.5,
		XRunFwd = 4.5,
		XRunSide = 3.5,
		XRunBack = 4.5,
		RunFwd = 4.8,
		RunSide = 4.8,
		RunBack = 4.8,
		CrouchFwd = 1.02,
		CrouchSide = 1.02,
		CrouchBack = 1.02,
	},

	move_params={
		speed_run=5,
		speed_walk=3.5,
		speed_swim=3,
		speed_crouch=1.6,
		speed_prone=.6,

		speed_run_strafe=4.5,
		speed_walk_strafe=3.5,
		speed_swim_strafe=3,
		speed_crouch_strafe=1.6,
		speed_prone_strafe=.6,

		speed_run_back=4.5,
		speed_walk_back=3.5,
		speed_swim_back=3,
		speed_crouch_back=1.6,
		speed_prone_back=.6,

		jump_force=4.3,
		lean_angle=14,
		bob_pitch=.015,
		bob_roll=.035,
		bob_lenght=5.5,
		bob_weapon=.005,
	},

	PhysParams = {
		mass = 80,
		height = 1.8,
		eyeheight = 1.6,
		sphereheight = 1.2,
		radius = .45,
	},

--pe_player_dimensions structure
-- change log
-- 1.july.02: x,y size changed from .6 to .4 allow the player to enter a 1meter wide gap
--            animation looks fine,no wall cliping. Crouch height changed from 1.1 to 1.5
--            and x,y from .6 to .45. At height 1.1 the players head was inside a wall.
--            Now looks better :] (ray)
	PlayerDimNormal = {
		height = 1.8,
		eye_height = 1.7,
		ellipsoid_height = 1.2,
		x = .45,
		y = .45,
		z = .6, -- .6 оригинал -- .41
		head_height = 1.7, -- Игрок
		head_radius = .31, -- Игрок
	},
	PlayerDimCrouch = {
		height = 1.5,
		eye_height = 1,
		ellipsoid_height = .95,
		x = .45,
		y = .45,
		z = .1, -- .5
		head_height = 1.1,
		head_radius = .35,
	},
	PlayerDimProne = {
		height = .4,
		eye_height = .4,
		ellipsoid_height = .48,
		x = .45,
		y = .45,
		z = .24,
	},

	DeadBodyParams = {
		max_time_step = .025,
		gravityz = -7.5,
		sleep_speed = .025,
		damping = .3,
		freefall_gravityz = -9.81,
		freefall_damping = .1,
		lying_mode_ncolls = 4,
		lying_gravityz = -5,
		lying_sleep_speed = .065,
		lying_damping = 1.5,
		water_damping = .1,
		water_resistance = 1000,
	},

	AI_DynProp = {
		air_control = .9,
		gravity = 9.81,
		jump_gravity = 18,
		swimming_gravity = -.5,
		inertia = 10,
		swimming_inertia = .5,
		nod_speed = 50,
		min_slide_angle = 46,
		max_climb_angle = 55,
		min_fall_angle = 70,
		max_jump_angle = 50,
	},

	BulletImpactParams = {
		stiffness_scale = 73,
		max_time_step = .02
	},

	Params={},--used to pass params to the basic player
	keycards={},	-- holds player's keycards
	explosives={},	-- holds player's explosives
	items={},	-- generic items the player can pick up (heat vision goggles,etc..)
	objects={}, -- very mission specific objects the player can pick up
	SwayModifierProning = .1,
	SwayModifierCrouching = .5,
	GrenadeType = "ProjFlashbangGrenade",

	SoundEvents={
		{"srunfwd",			7 },
		{"srunfwd",			19},
		{"srunback",		5 },
		{"srunback",		14},
		{"xwalkfwd",		2 },
		{"xwalkfwd",		26},
		{"xwalkback",		0 },
		{"xwalkback",		23},
		{"swalkback",		0 },
		{"swalkback",		16},
		{"swalkfwd",		2 },
		{"swalkfwd",		19},
		{"cwalkback",		9 },
		{"cwalkback",		33},
		{"cwalkfwd",		12},
		{"cwalkfwd",		31},
    	{"pwalkfwd",		1 },
    	{"pwalkfwd",		20},
    	{"pwalkback",		1 },
    	{"pwalkback",		20},
		{"arunback",		6 },
		{"arunback",		15},
		{"arunfwd",			7 },
		{"arunfwd",			19},
		{"asprintfwd",		5 },
		{"asprintfwd",		13},
		{"asprintback",		6 },
		{"asprintback",		15},
		{"awalkback",		1 },
		{"awalkback",		17},
		{"awalkfwd",		1 },
		{"awalkfwd",		20},
		{"pwalkback",		3 },
	},
	idUnitHighlight=nil,						-- used by the UnitHighlight on the server - this entity is removed on shutdown
}
--------------------------------
function Player:OnReset()
	-- Hud:AddMessage(self:GetName()..": SpecOnReset 1")
	-- System:Log(self:GetName()..": SpecOnReset 1")
	LocPlayer = tonumber(getglobal("AIPlayer"))
	-- if LocPlayer and LocPlayer>0 then
		-- if BasicAI.OnReset then
			-- BasicAI.OnReset(self)
			-- -- Hud:AddMessage(self:GetName()..": BasicAI.OnReset")
			-- -- System:Log(self:GetName()..": BasicAI.OnReset")
		-- end
	-- end
	self:SetScriptUpdateRate(self.UpdateTime)
	if (self.JustLoaded==nil) then	-- [lennert] this is a dirty hack because OnReset is called after OnLoad for not very clear reasons  this should be fixed !
		self.keycards={}
		self.explosives={}
		self.items={}
		self.objects={}
	end
	self.JustLoaded=nil 	-- [lennert] this is a dirty hack because OnReset is called after OnLoad for not very clear reasons  this should be fixed !

	self.cnt:SetMoveParams(self.move_params)
	-- if LocPlayer and LocPlayer>0 then
		-- -- self.IsAiPlayer=1
		-- AI:RegisterWithAI(self.id,AIOBJECT_PUPPET,self.Properties,self.PropertiesInstance)
	if LocPlayer and LocPlayer<=0 then
		BasicPlayer.OnReset(self)
		AI:RegisterWithAI(self.id,AIOBJECT_PLAYER,self.Properties)
	end
	self:EnableUpdate(1) -- Проверить.
	self.cnt:SwitchFlashLight(0)
	if ClientStuff then
		ClientStuff:OnReset() -- Чтобы сбрасывался интерфейс.
	end
	if BasicWeapon then
		BasicWeapon:Show(self) -- Чтобы пушка сразу отображалась.
	end
	if Hud then
		Hud.deaf_time = 0  -- Убирает оглушение.
		Hud.initial_deaftime = 0
	end
	if LocPlayer and LocPlayer>0 then
		if BasicAI.OnReset then
			BasicAI.OnReset(self)
			-- Hud:AddMessage(self:GetName()..": BasicAI.OnReset")
			-- System:Log(self:GetName()..": BasicAI.OnReset")
		end
	else
		self.IsAiPlayer = nil
	end
	-- Hud:AddMessage(self:GetName()..": SpecOnReset 2")
	-- System:Log(self:GetName()..": SpecOnReset 2")
end

function Player:RegisterStates()
	self:RegisterState("Alive")
	self:RegisterState("Dead")
end

function Player:LoadModel()
	if (self.model_loaded==nil) then
--		System:Log("self.cnt.model = "..self.cnt.model)

		local bLoadStandardModel

		-- client might not allow user defined models
		if Game:IsMultiplayer() then
			local mp_usermodels = tostring(getglobal("cl_AllowUserModels"))

			local bIsAStandardModel

			if mp_usermodels=="0" then
				for key,val in MPModelList do
					if val.model==self.cnt.model then
						bIsAStandardModel=1
					end
				end
			end

			if not bIsAStandardModel then
				System:Log("Non Standard mp_model was specified: '"..self.cnt.model.."'")
				System:Log("  standard model is used (cl_AllowUserModels=1)")
				bLoadStandardModel=1
			end
		end


		if bLoadStandardModel or not self:LoadCharacter(self.cnt.model,0) then
			self:LoadCharacter("objects/characters/pmodels/hero/hero_mp.cgf",0)								-- if this model is not there load the default model
		end

		self["model_loaded"]=1
		if (self.Properties.bHelmetOnStart==1)	then
			self:LoadObject("objects/characters/mercenaries/accessories/helmet.cgf",0,1)
		end
	end
end


--------------------------------
-- \bInvulnerable 1=,nil
function Player:ApplyTeamColor()
--	System:Log("FX: ApplyTeamColor")
	local color=self.cnt:GetColor()

	self:SetShaderFloat("ColorR",color.x,0,0)
	self:SetShaderFloat("ColorG",color.y,0,0)
	self:SetShaderFloat("ColorB",color.z,0,0)
end

--------------------------------
function Player:Server_OnInit()
	-- register as main guy in the AI system
	self:LoadModel()
	BasicPlayer.Server_OnInit(self)
--	self.cnt:SetMoveParams(self.move_params)
	self:OnReset()
	LocPlayer = tonumber(getglobal("AIPlayer"))
	if LocPlayer and LocPlayer>0 then
		self.cnt:CounterAdd("Boredom",.1) -- Я без понятия что это.
		self.cnt:CounterSetEvent("Boredom",1,"OnBored")
	end
end

--------------------------------
function Player:Client_OnInit()
	self:LoadModel()
	BasicPlayer.Client_OnInit(self)
	self.cnt:SetMoveParams(self.move_params)
	LocPlayer = tonumber(getglobal("AIPlayer"))
	if LocPlayer and LocPlayer>0 then
		if self.Properties.bHasLight==1 then
			self.cnt.light = 1
		end
	end
end

--------------------------------
function Player:Client_OnRemoteEffect(toktable,pos,normal,userbyte)
--	System:Log("_FX: Setting effect: "..tostring(self.id).."("..tostring(userbyte)..")")
	if (userbyte==0) then
		-- set second shader to none
		BasicPlayer.SecondShader_None(self)
	--	self.iPlayerEffect=1
	elseif (userbyte==1) then
		-- set second shader to apply team coloring
		BasicPlayer.SecondShader_TeamColoring(self)
--		self.iPlayerEffect=2
	elseif (userbyte==2) then
		-- turn on invulnerability
		BasicPlayer.SecondShader_Invulnerability(self,1,1,1,1)
--		self.iPlayerEffect=3
	elseif (userbyte==3) then						-- target is alive
		if (Game:IsMultiplayer()) then
			local hit = {}
			hit.pos = pos
			hit.normal = normal
			hit.target_material = Materials["mat_flesh"]
			-- might be invulnerable!!
			if (self.iPlayerEffect~=3) then
				ExecuteMaterial_Particles(hit,"bullet_hit")
			end

			if (self==_localplayer) then
				Hud:PlayMultiplayerHitSound()
			end
		end

		if (self==_localplayer) then
			Hud.hit=5
		end
--	elseif (userbyte==4) then						-- target is dead
--		if (Game:IsMultiplayer()) then
--			local hit = {}
--			hit.pos = pos
--			hit.normal = normal
--			hit.target_material = Materials["mat_flesh"]
--			ExecuteMaterial_Particles(hit,"bullet_hit")
--		end
	end
end

--------------------------------
function Player:ChangeEnergy(Units)
	self.EnergyChanged = 1
	self.Energy = self.Energy + Units
	if (self.Energy > self.MaxEnergy) then
		self.Energy = self.MaxEnergy
	end
	if (self.Energy < 0) then
		self.Energy = 0
	end
end

--------------------------------
function Player:OnLoad(stm)
	LocPlayer = tonumber(getglobal("AIPlayer"))
	if LocPlayer and LocPlayer>0 then
		BasicAI.OnLoad(self,stm)
	else
		BasicPlayer.OnLoad(self,stm)
	end
	self.keycards=ReadFromStream(stm)
	self.explosives=ReadFromStream(stm)
	self.items=ReadFromStream(stm)
	self.objects=ReadFromStream(stm)
	self.JustLoaded=1 	-- [lennert] this is a dirty hack because OnReset is called after OnLoad for not very clear reasons  this should be fixed !

	GameRules.AiPlayerSpawn = stm:ReadBool()
	if GameRules.AiPlayerSpawn then -- Если при прохождении было разрешено создавать помощника.
		local AiPlayer
		local Entities
		if GameRules.AllEntities then
			Entities = GameRules.AllEntities
		end
		if not Entities then
			System:Log(self:GetName()..": $1Player/OnLoad/ Use System:GetEntities()")
			Entities=System:GetEntities() -- Опять же, на всякий пожарный, как при паузе.
		end
		for i,entity in Entities do
			if entity.IsAiPlayer and entity.id~=self.id then -- Локального игрока с ИИ пропускаем.
				AiPlayer = 1
				break
			end
		end
		if not AiPlayer then
			local sc = tonumber(getglobal("sc"))
			if sc~=1 then
				setglobal("sc",1)
			end
		end
	end
end

function Player:OnSave(stm)
	LocPlayer = tonumber(getglobal("AIPlayer"))
	if LocPlayer and LocPlayer>0 then
		BasicAI.OnSave(self,stm)
	else
		BasicPlayer.OnSave(self,stm)
	end
	WriteToStream(stm,self.keycards)
	WriteToStream(stm,self.explosives)
	WriteToStream(stm,self.items)
	WriteToStream(stm,self.objects)

	stm:WriteBool(GameRules.AiPlayerSpawn)
end

--------------------------------------

function Player:OnSaveOverall(stm)
	BasicPlayer.OnSaveOverall(self,stm)
end

--------------------------------------

function Player:OnLoadOverall(stm)
	BasicPlayer.OnLoadOverall(self,stm)
end


--------------------------------
Player.Server =
{
--	OnTimer = BasicPlayer.Server_OnTimer,
--	OnUpdate = BasicPlayer.Server_OnTimer,
	OnEvent = BasicPlayer.Server_OnEvent,
	OnInit = Player.Server_OnInit,
	OnShutDown = BasicPlayer.Server_OnShutDown,
	Alive = {
		OnBeginState = function(self)
--			System:Log("ServerAliveState")
			self.cnt.modelhidden=0
		end,
		OnEndState = function(self)
		end,
		OnEvent = BasicPlayer.Server_OnEvent,
		-- OnDamage = BasicPlayer.Server_OnDamage,
		OnDamage = function(self,hit)
			LocPlayer = tonumber(getglobal("AIPlayer"))
			if LocPlayer and LocPlayer>0 then
				BasicAI.Server.Alive.OnDamage(self,hit)
			else
				BasicPlayer.Server_OnDamage(self,hit)
			end
		end,
--		OnTimer = function(self)
		OnUpdate = function(self)
			-- Hud:AddMessage(self:GetName()..": Player/Server/Alive/OnUpdate")
			-- System:Log(self:GetName()..": Player/Server/Alive/OnUpdate")
			if self.timetodie then
				if self.timetodie~=2 then
					self:DrawCharacter(0,0)
					self.cnt.modelhidden=1
				end
				System:ExecuteCommand("kill")
				self.timetodie=nil
			end
			BasicPlayer.Server_OnTimer(self)
		end,
		--pushing stuff
		OnContact = function(self,contact)
			BasicPlayer.PlayerContact(self,contact,1)
		end,
	},
	Dead = {
		OnBeginState = function(self)
			LocPlayer = tonumber(getglobal("AIPlayer"))
			if LocPlayer and LocPlayer>0 then
				BasicAI.Server.Dead.OnBeginState(self)
			end
--			System:Log("ServerDeadState health "..self.cnt.health)
			local weapon = self.cnt.weapon
			if weapon then
				self.cnt:DeselectWeapon()
			end
			BasicPlayer.MakeDeadbody(self)
			-- BasicPlayer.RegisterAsDeadBody(self)
			self:NetPresent(nil)
		end,
		OnEvent = BasicPlayer.Server_OnEventDead,
		OnDamage = function(self,hit)
			LocPlayer = tonumber(getglobal("AIPlayer"))
			if LocPlayer and LocPlayer>0 then
				BasicPlayer.Server_OnDamageDead(self,hit)
			end
		end,
		OnEndState = function(self)
		end,
		OnTimer = BasicPlayer.Server_OnTimer,
	},
}

--------------------------------
Player.Client =
{
--	OnTimer = BasicPlayer.Client_OnTimer,
	OnInit = Player.Client_OnInit,
	OnRemoteEffect = Player.Client_OnRemoteEffect,
	OnShutDown = BasicPlayer.Client_OnShutDown,
	Alive = {
--		OnTimer = BasicPlayer.Client_OnTimer,
		-- OnUpdate = BasicPlayer.Client_OnTimer,
		OnUpdate = function(self)
			LocPlayer = tonumber(getglobal("AIPlayer"))
			if LocPlayer and LocPlayer>0 then
				BasicAI.Client.Alive.OnUpdate(self)
			else
				BasicPlayer.Client_OnTimer(self)
			end
		end,
		OnBeginState = function(self)
			BasicPlayer.OnBeginAliveState(self)
			if self==_localplayer then
				Input:SetActionMap("default")
--				System:Log("ClientAliveState MY player")
				self.AnimationSystemEnabled = 1
				self:EnablePhysics(1)
				if Hud then Hud.deaf_time=nil end
			end
--			System:Log("ClientAliveState")
		end,
		OnEndState = function(self)
		end,
		-- OnDamage = BasicPlayer.Client_OnDamage,
		OnDamage = function(self,hit)
			LocPlayer = tonumber(getglobal("AIPlayer"))
			if LocPlayer and LocPlayer>0 then
				BasicAI.Client.Alive.OnDamage(self,hit)
			else
				BasicPlayer.Client_OnDamage(self,hit)
			end
		end,
		OnEvent = function(self,EventId,Params)
			local EventSwitch=self.EventHandlers[EventId]
			if EventSwitch then
				EventSwitch(self,EventId,Params)
			else
				BasicPlayer.Client_OnEvent(self,EventId,Params)
			end
		end,

		--pushing stuff
		OnContact = function(self,contact)
			BasicPlayer.PlayerContact(self,contact)
		end,
	},
	Dead = {
		OnBeginState = function(self)
			LocPlayer = tonumber(getglobal("AIPlayer"))
			if LocPlayer and LocPlayer<=0 then
				BasicPlayer.OnBeginDeadState(self)
			end
			self.cnt.health=0 		-- server might not send this info
			if self==_localplayer then
				ClientStuff.vlayers:DeactivateAll() -- Включить или выключить? Лучше пусть всё отрубается, а то красного эффекта иногда не наблюдается.
				-- if (ClientStuff.vlayers:IsActive("WeaponScope")) then
					-- ClientStuff.vlayers:DeactivateLayer("WeaponScope")
				-- end
				-- if (ClientStuff.vlayers:IsActive("MoTrack")) then
					-- ClientStuff.vlayers:DeactivateLayer("MoTrack")
				-- end
				-- if (ClientStuff.vlayers:IsActive("Binoculars")) then
					-- ClientStuff.vlayers:DeactivateLayer("Binoculars")
				-- end
				-- disable the flashbang effect when the player dies
				System:SetScreenFx("FlashBang",0) -- Выключать эффект ослепления когда игрок умер.
				if Hud then	Hud.deaf_time=nil end
				if not Game:IsMultiplayer() then
					Hud:OnMiscDamage(10000)
					-- Hud:SetScreenDamageColor(1,0,0) -- Всё было залито кровью...
					-- Hud:SetScreenDamageColor(0,0,0) -- Аж в глазах потемнело!
					Hud:SetScreenDamageColor(1,1,1) -- Я вижу свет в конце тоннеля!
					System:SetScreenFx("ScreenFade",1)
					if Game:ShowSaveGameMenu() then -- Если доступно меню, тогда...
						System:SetScreenFxParamFloat("ScreenFade","ScreenFadeTime",GameRules.TimeRespawn+.35) -- Игра. Если x <= TimeRespawn, затенение исчезает перед тем как появится меню, если x > TimeRespawn, не успевает отобразиться hud в редакторе.
					else
						System:SetScreenFxParamFloat("ScreenFade","ScreenFadeTime",GameRules.TimeRespawn+.5) -- Редактор. +.5 - Идеально: интерфейс вновь появляется, не заметен переход между затемнением и цветом дамага.
					end
				end
			end
			LocPlayer = tonumber(getglobal("AIPlayer"))
			if LocPlayer and LocPlayer<=0 then
				BasicPlayer.MakeDeadbody(self)
			end
			-- stop breathing sound in case it is still playing...
			if (self.ExhaustedBreathingSound) then
				Sound:StopSound(self.ExhaustedBreathingSound)
			end
--			System:Log("ClientDeadState --- health "..self.cnt.health)
			--BasicPlayer.PlayOneSound(self,self.deathSounds,110)
			self:SetTimer(self.UpdateTime)
			self:SetScriptUpdateRate(0)
			-- BasicPlayer.RegisterAsDeadBody(self)
		end,
		OnUpdate = BasicPlayer.Client_DeadOnUpdate,
		OnEndState = function(self)
		end,
--		OnDamage=BasicPlayer.Client_OnDamage,
		OnDamage = BasicPlayer.Server_OnDamageDead,
		OnTimer = BasicPlayer.Client_OnTimerDead,
		OnEvent = function(self,EventId,Params)
			LocPlayer = tonumber(getglobal("AIPlayer"))
			if LocPlayer and LocPlayer>0 then
				BasicAI.Client.Dead.OnEvent(self,EventId,Params)
			end
		end
	},
}

--------------------------------------------------------------------
-- Items switch
Player.ItemActivation={
	-------------------------------
	[0]=function(self)
		if (self~=_localplayer) then return end

		-- no binoculars if using mounted weapon
		if (self.cnt.has_binoculars==1 and (not self.current_mounted_weapon) and
			  (not self.cnt:IsSwimming()) and not self.cnt.reloading) then
			if (ClientStuff.vlayers:IsActive("Binoculars")) then
				ClientStuff.vlayers:DeactivateLayer("Binoculars")
				--ClientStuff.vlayers:DeactivateLayer("HeatVision")
			else
				if (ClientStuff.vlayers:IsActive("WeaponScope") or ClientStuff.vlayers:IsFading("WeaponScope")) then
					ClientStuff.vlayers:DeactivateLayer("WeaponScope",1)
				end
				ClientStuff.vlayers:ActivateLayer("Binoculars")
			end
		end
	end,
	-------------------------------
	[1]=function(self)
		if (self~=_localplayer) then return end

		-- todo: handle screen refraction only when finished the fx
		if (self.items.heatvisiongoggles and (not self.cnt:IsSwimming())) then

			if (ClientStuff.vlayers:IsActive("HeatVision")) then
				ClientStuff.vlayers:DeactivateLayer("HeatVision")
			else
				-- need to be above minimum required energy (or if player is using binoculars)
				if (self.Energy > self.MinRequiredEnergy or ClientStuff.vlayers:IsActive("Binoculars")) then
				  -- activate cryvision
				  ClientStuff.vlayers:ActivateLayer("HeatVision")
				end
			end
		end

	end,
}
--------------------------------------------------------------------
-- Events switch
Player.EventHandlers={
	-------------------------------
	[ScriptEvent_ZoomToggle] = function(self,EventId,Params)
		if self~=_localplayer then return end
		local stats = self.cnt
		local weapon = stats.weapon
		-- if (weapon and (not weapon.NoZoom) and (not stats.reloading)) then
			-- local dead_switch = weapon.ZoomDeadSwitch
			-- if (stats.first_person and not self.fireparams.no_zoom) then
				-- -- Hud:AddMessage(self:GetName()..": Params: "..Params)
				-- if (ClientStuff.vlayers:IsActive("WeaponScope")) then
					-- if (((Params==0 or Params==2) and (not dead_switch))
						-- or ((Params==1 or Params==2) and dead_switch)) then
						-- ClientStuff.vlayers:DeactivateLayer("WeaponScope")
					-- end
				-- elseif (not stats:IsSwimming()) then
					-- if (Params==1 and ((not stats.running or self.theVehicle) or weapon.AimMode==1)) then
						-- if (ClientStuff.vlayers:IsActive("Binoculars")) then
							-- ClientStuff.vlayers:DeactivateLayer("Binoculars",1)
						-- end
						-- if (not ClientStuff.vlayers:IsFading("WeaponScope")) then
							-- ClientStuff.vlayers:ActivateLayer("WeaponScope")
						-- end
					-- end
				-- end
			-- end
		-- end
		if weapon and not weapon.NoZoom and not stats.reloading then
			local dead_switch = weapon.ZoomDeadSwitch
			if stats.first_person and not self.fireparams.no_zoom then
				-- Hud:AddMessage(self:GetName()..": Params: "..Params)
				if ClientStuff.vlayers:IsActive("WeaponScope") then
					-- if ((Params==0 or Params==2) and not dead_switch) or ((Params==1 or Params==2) and dead_switch) then
					-- if (not dead_switch and (Params==0 or Params==2)) or (dead_switch and (Params==1 or Params==2)) then
					-- if Params==0 or Params==2 then
					-- if self.AiPlayerAimLook then
						-- Hud:AddMessage(self:GetName()..": self.AiPlayerAimLook")
					-- else
						-- Hud:AddMessage(self:GetName()..": NOT self.AiPlayerAimLook")
					-- end
					if (self.AiPlayerAimLook and Params==0 or Params==2) -- C++
					or (not self.AiPlayerAimLook and ((not dead_switch and (Params==0 or Params==2)) or (dead_switch and (Params==1 or Params==2)))) then
						-- Hud:AddMessage(self:GetName()..": DeactivateLayer")
						ClientStuff.vlayers:DeactivateLayer("WeaponScope")
					end
				elseif not stats:IsSwimming() then
					if Params==1 and ((not stats.running or self.theVehicle) or weapon.AimMode==1) then
						if ClientStuff.vlayers:IsActive("Binoculars") then
							ClientStuff.vlayers:DeactivateLayer("Binoculars",1)
						end
						if not ClientStuff.vlayers:IsFading("WeaponScope") then
							-- if not self.IsAiPlayer or (not self.OnWeaponScopeDeactivatingReloading and (weapon.AimMode~=2 or (not AI:IsMoving(self.id) and (weapon.AimMode==2 or dead_switch)))) then
							if not self.IsAiPlayer or (weapon.AimMode~=2 or (not AI:IsMoving(self.id) and (weapon.AimMode==2 or dead_switch))) then -- Оружие с оптикой не приближать во время движения.
								-- Hud:AddMessage(self:GetName()..": ActivateLayer")
								-- System:Log(self:GetName()..": ActivateLayer")
								ClientStuff.vlayers:ActivateLayer("WeaponScope")
							end
						end
					end
				end
			end
		end
	end,
	-------------------------------
	[ScriptEvent_ZoomIn] = function(self,EventId,Params)
		if (self~=_localplayer) then return end
		ZoomView:ZoomIn()
	end,
	-------------------------------
	[ScriptEvent_ZoomOut] = function(self,EventId,Params)
		if (self~=_localplayer) then return end
		ZoomView:ZoomOut()
	end,
	-------------------------------
	[ScriptEvent_ItemActivated] = function(self,EventId,Params)
		local ItemSwitch=self.ItemActivation[Params]
		if (ItemSwitch) then
			ItemSwitch(self)
		end
	end,
	-------------------------------
	[ScriptEvent_Deafened] = function(self,EventId,Params)
		if (self==_localplayer and Hud) then
			if (Hud.deaf_time) then
				if (Hud.deaf_time<Params.fTime) then
					Hud.deaf_time=Params.fTime
				end
			else
				Hud.deaf_time=Params.fTime
			end
			Hud.initial_deaftime=Hud.deaf_time

--			System:Log("Deafened for "..Hud.deaf_time.." seconds...")
		end
	end,
	[ScriptEvent_SelectWeapon]=function(self,eventid,Params)
		if (Hud and self==_localplayer) then
			Hud.weapons_alpha=1
			--BasicPlayer.ProcessPlayerEffects(self)
		end
		BasicPlayer.Client_OnEvent(self,EventId,Params)
	end,
}

LocPlayer = tonumber(getglobal("AIPlayer"))
if LocPlayer and LocPlayer>0 then
	-- AI:RegisterWithAI(Player.id,AIOBJECT_PUPPET,Player.Properties,Player.PropertiesInstance)
	-- mergef(Player,BasicAI,1) -- Теперь может использовать всё, что есть в BasicAI.lua. Проблема: функции из BasicAI перекрывают функции из Player.
	local NewTable = {}
	mergef(NewTable,BasicAI,1)
	mergef(NewTable,Player,1)
	Player = NewTable -- А вот так та проблема c mergef решена.
	-- Player.IsAiPlayer=1
	-- Player = CreateAI(Player) -- А такой способ ничего толком не даёт.
end