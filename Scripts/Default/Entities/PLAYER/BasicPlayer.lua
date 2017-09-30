-- HIGHLY OPTIMIZED BASICPLAYER 1.68C BY MIXER
-- #Script.ReloadScript("scripts/default/entities/player/basicplayer.lua")
GoreDecals = {-- used to be projected on walls/objects/terrain
		count = 1,
		dec1=
		{
			texture = System:LoadTexture("Languages/Textures/human_bullet_hit_d.DDS"),
			scale = .4,
			random_rotation= 360,
			random_scale = 50,
			life_time = 15,
			grow_time = 0,
		},
		dec2=
		{
			texture = System:LoadTexture("Languages/Textures/Decal/flesh_slash.dds"),
			scale = .5,
			random_rotation= 360,
			random_scale = 20,
			life_time = 15,
			grow_time = 0,
		},
	}

GoreDecalsBld = {-- blood under dead body
		count = 1,
		dec1=
		{
			texture = System:LoadTexture("Languages/Textures/blood_pool.DDS"),
			scale = .7,
			random_rotation= 360,
			random_scale = 10,
			life_time = 30,
			grow_time = 30,
		},
		dec2=
		{
			texture = System:LoadTexture("Languages/Textures/Decal/flesh_slash.dds"),
			scale = 1.4,
			random_rotation= 360,
			random_scale = 20,
			life_time = 15,
			grow_time = 15,
		},
	}

-- definition for keyframe identifiers
KEYFRAME_APPLY_MELEE = 1
KEYFRAME_ALLOW_AI_MOVE = 2
KEYFRAME_BREATH_SOUND = 3
KEYFRAME_JOB_ATTACH_MODEL_NOW = 4
KEYFRAME_HOLD_GUN = 9
KEYFRAME_HOLSTER_GUN = 10
KEYFRAME_FIRE_LEFTHAND = 11
KEYFRAME_FIRE_RIGHTHAND = 12
KEYFRAME_FIRE_LEFTTOP = 13
KEYFRAME_FIRE_RIGHTTOP = 14

BasicPlayer = {
	type = "Player",

	UpdateTime = 300,
	death_time = nil,
	decalTime = 0,

	proneMinAngle = -32,
	proneMaxAngle = 32,

	normMinAngle = -95, -- Чё за фигния? Немог смотреть выше,чем 85 градусов!
	normMaxAngle = 85,

	isPhysicalized = 0,

	holdedWeapon = nil,

	BloodTimer = 100000,

	aux_vec = {x=0,y=0,z=0},

	deathImpuls = {x=0,y=0,z=0},
	deathImpulseTorso = 0,
	deathPoint = {x=0,y=0,z=0},
	deathImpulsePart = 0,

	DTExplosion = 0,
	DTSingleP = 1,
	DTSingle = 2,
	DTRapid = 3,

	painSound = nil,

	isProning = 0,
	InWater= 0,
	isRefractive = 0,

	--[filippo]
	lastStanceSound = 0,
	hasJumped = 0,
	jumpSoundPlayed = 0,
	tempvec = {x=0,y=0,z=0},
	jumpTime = 0,
	nextPush = 0,
	nextPush_Client = 0,

	--number of updates to move in bush to have max bush sound volume.Time would be UpdateTime*BushSoundScale
	BushSoundScale = 10,
	--  internal counter of updates
	BushInCounter = 0,
	--the same for AI
	BushSoundScaleAI = 10,
	BushInCounterAI = 0,

	--in seconds
	drown_time=20,

	-- falling damage
	-- if land speed is greater than FallDmgS damage will be applyed.
	-- ammount of damage is (landSpeed - FallDmgS)*FallDmgK
	-- speed = sqrt(2*9.8*height)
	FallDmgS = 11, -- 10
	FallDmgK = 30, -- 22

	-- collision damage coefficient
	CollisionDmg = .5,
	-- collision damage coefficient for vehicles (cars)
	CollisionDmgCar = 3,

	-- protection stuff
	hasHelmet = 0,

	lightFileShader="",
	lightFileTexture="Textures/Lights/gk_spotlight_lg.dds",

	AnimationBlendingTimes = {
		{"srunfwd",.31},
		{"srunback",.23},
		{"arunfwd",.35},
		{"arunback",.33},
		{"srunback_utaim",.2},
		{"srunback_utshoot",.2},
	},

	PainAnimations = {
		"pain_head",
		"pain_torso",
		"pain_larm",
		"pain_rarm",
		"pain_lleg",
		"pain_rleg"
	},

	--- common data over

	soundScale = {
		run = .8,
		walk = .6,
		crouch = .4,
		prone = .3,
	},

	soundRadius = {
		--[filippo]
		run = 6, --before was 12
		walk = 3, -- before was 6 -- 2
		crouch = 1, -- 1
		prone = .5, --before was 1
		jump = 3, --for jump
		sprint = 12, --for sprint
	},

	soundEventRadius = {
		run = 0,
		jump = 0, -- when landing after jump
		walk = 0,
		crouch = 0,
		prone = 0,
	},

	BulletImpactParams = {
		stiffness_scale = 73,
		max_time_step = .02
	},

	DynProp = {
		air_control = .9, --filippo: was .4,default .6
		gravity = 9.81, --18.81,
		jump_gravity = 15, -- gravity used when the player jump,if this parameter dont exist normal gravity is used for jump -- 15 -- 18
		swimming_gravity = -.5, -- 1
		inertia = 10,
		swimming_inertia = .5, -- 1
		nod_speed = 50, --filippo:was 60
		min_slide_angle = 46, -- Невозможно взобраться на простые склоны - это пипец просто! Изменить!
		max_climb_angle = 55,
		min_fall_angle = 70,
		max_jump_angle = 50,
	},

	TpvReloadFX = {
		{"creload_DE_moving",9,Sound:Load3DSound("Sounds/Weapons/DE/DEclipout_10.wav",SOUND_UNSCALABLE,94,5,60)},
		{"creload_DE_moving",41,Sound:Load3DSound("Sounds/Weapons/DE/DEclipin_25.wav",SOUND_UNSCALABLE,94,5,60)},
		{"sreload",7,Sound:Load3DSound("Sounds/Weapons/M4/M4_20.wav",SOUND_UNSCALABLE,96,5,60)},
		{"sreload",29,Sound:Load3DSound("Sounds/Weapons/AG36/Ag36b_38.wav",SOUND_UNSCALABLE,96,5,60)},
		{"creload",7,Sound:Load3DSound("Sounds/Weapons/M4/M4_20.wav",SOUND_UNSCALABLE,96,5,60)},
		{"creload",29,Sound:Load3DSound("Sounds/Weapons/AG36/Ag36b_38.wav",SOUND_UNSCALABLE,96,5,60)},
		{"sreload_DE",9,Sound:Load3DSound("Sounds/Weapons/DE/DEclipout_10.wav",SOUND_UNSCALABLE,94,5,60)},
		{"sreload_DE",41,Sound:Load3DSound("Sounds/Weapons/DE/DEclipin_25.wav",SOUND_UNSCALABLE,94,5,60)},
		{"creload_DE",9,Sound:Load3DSound("Sounds/Weapons/DE/DEclipout_10.wav",SOUND_UNSCALABLE,94,5,60)},
		{"creload_DE",41,Sound:Load3DSound("Sounds/Weapons/DE/DEclipin_25.wav",SOUND_UNSCALABLE,94,5,60)},
		{"sreload_DE_moving",9,Sound:Load3DSound("Sounds/Weapons/DE/DEclipout_10.wav",SOUND_UNSCALABLE,94,5,60)},
		{"sreload_DE_moving",41,Sound:Load3DSound("Sounds/Weapons/DE/DEclipin_25.wav",SOUND_UNSCALABLE,94,5,60)},
		{"sreload_moving",7,Sound:Load3DSound("Sounds/Weapons/M4/M4_20.wav",SOUND_UNSCALABLE,96,5,60)},
		{"sreload_moving",29,Sound:Load3DSound("Sounds/Weapons/AG36/Ag36b_38.wav",SOUND_UNSCALABLE,96,5,60)},
	},

	sndWaterSwim = Sound:LoadSound("sounds/player/water/newswim2lp.wav"),
	sndUnderWaterSwim = Sound:LoadSound("sounds/player/water/underwaterswim2.wav"),

	sndUnderwaterNoise = Sound:LoadSound("sounds/player/water/underwaterloop.wav"),
	sndWaterSplash = Sound:Load3DSound("sounds/player/water/WaterSplash.wav",SOUND_RADIUS,160,3,50),

	sndBreathIn = {
		Sound:LoadSound("sounds/player/breathin.wav"),
		Sound:LoadSound("sounds/player/breathout.wav"),
	},

	tSndNoAir = 100,

	WaterRipples = {
		focus = .2,
		color = {1,1,1},
		speed = 0,
		count = 1,
		size = .15,size_speed=.6,
		gravity=0,
		lifetime=3,
		tid = System:LoadTexture("textures\\ripple.dds"),-- Добавить: эффект прозрачности.
		frames=0,
		color_based_blending = 1,
		particle_type = 1,
	},

	WaterSplash = {
		focus = 3,
		color = {1,1,1},
		speed = 10,
		count = 140,
		size = .025,size_speed=0,
		gravity=1,
		lifetime=.5,
		tid = 0,
		frames=0,
		color_based_blending = 0
	},

	fLightSound = Sound:Load3DSound("SOUNDS/items/flight.wav",SOUND_UNSCALABLE,160,3,30),

	--[marco] Steve add reward sound here (NOTE: these are 2d sounds)
	--sndHeadShotComment=Sound:LoadSound("LANGUAGES/English/missiontalk/impressive.wav",SOUND_UNSCALABLE,160), -- Будет произноситься, если попасть в голову.
	--sndLongDistanceShotComment=Sound:LoadSound("LANGUAGES/English/missiontalk/60meters.wav",SOUND_UNSCALABLE,160),
	--sndFarDistanceShotComment=Sound:LoadSound("LANGUAGES/English/missiontalk/100meters.wav",SOUND_UNSCALABLE,160),

	-- current body heat
	fBodyHeat=1,

	StaminaTable = {
		sprintScale = 1.5, -- 1.4
		sprintSwimScale = 1.4,
		decoyRun = 2, -- 10
		decoyJump = 4, -- 10
		restoreRun = .2, -- 1.5
		restoreWalk = .5, -- 8
		restoreIdle = 1, -- 10
		breathDecoyUnderwater = 2.5, -- 2
		breathDecoyAim = 3,
		breathRestore = 80,
	},

	fallscale = 1,

	expressionsTable = {
		"Scripts/Expressions/DeadRandomExpressions.lua",-- dead
		"Scripts/Expressions/DefaultRandomExpressions.lua",-- idle
		"Scripts/Expressions/SearchRandomExpressions.lua",-- search
		"Scripts/Expressions/CombatRandomExpressions.lua",-- combat
	},
}

-- \return 1=alive / nil=not alife
function BasicPlayer:IsAlive()
	if self and self.GetState then return self:GetState()=="Alive" end
	return nil
end

function BasicPlayer:OnBeginDeadState()
	--System:Log("BEGIN DEAD STATE - PLAY SOUND")
	if self.SwimSound and Sound:IsPlaying(self.SwimSound)==1 then
		Sound:StopSound(self.SwimSound)
		self.SwimSound = nil
	end

	self:DoRandomExpressions("Scripts/Expressions/DeadRandomExpressions.lua",0)
	-- make sure that there is no weapon sound playing anymore
	if self.cnt.weapon then
		-- Hud:AddMessage(self:GetName()..": BasicPlayer OnStopFiring")
		-- System:Log(self:GetName()..": BasicPlayer OnStopFiring")
		BasicWeapon.Client.OnStopFiring(self.cnt.weapon,self)
	end

	-- MIXER: Fix stop rebreath sounds
	if (self.rebreath_snd) and (Sound:IsPlaying(self.rebreath_snd)) then
	Sound:StopSound(self.rebreath_snd) self.rebreath_snd=nil end

	-- MIXER: Fix don't mess with painsound
	if Sound:IsPlaying(self.painSound) then	Sound:StopSound(self.painSound) end

	-- Hud:AddMessage(self:GetName()..": headshot: "..self.HeadShot)
	-- if not self.HeadShot then -- Чтобы при убийстве в голову не издавали никаких охов и ахов, им же голову нафиг разнесли!
		BasicPlayer.PlayOneSound(self,self.deathSounds,101,1,1,1,1,nil,1)
	-- end
	self:ReleaseLipSync()-- we dont want the corpse to say anything...
end

-- function BasicPlayer:RegisterAsDeadBody()
	-- AI:RegisterWithAI(self.id,AIOBJECT_DEADBODY,self.Properties,self.PropertiesInstance)
-- end

function BasicPlayer:MakeDeadbody()
	if not self.IsDedbody then
		self.IsDedbody = 1
		self:KillCharacter(0)
		self:SetPhysicParams(PHYSICPARAM_SIMULATION,self.DeadBodyParams)
		self:SetPhysicParams(PHYSICPARAM_ARTICULATED,self.DeadBodyParams)
		self:SetPhysicParams(PHYSICPARAM_BUOYANCY,self.DeadBodyParams)
		-- if self.deathImpuls==nil or self.deathPoint==nil or self.deathImpulsePart==nil then
			-- System:Log("ERROR: self.cnt:StartDie wrong input") -- Зачем мне это показывать? Итак в большинстве случаев всё нормально.
		-- end
		self.cnt:StartDie(self.deathImpuls,self.deathPoint,self.deathImpulsePart,self.deathType)
	end
end

function BasicPlayer:OnBeginAliveState()
	self:DoRandomExpressions("Scripts/Expressions/DefaultRandomExpressions.lua",0)
end

function BasicPlayer:OnReset()
	-- self:ResetAnimation(0)
	-- self:StartAnimation(0,"NULL",4) -- Не помогает здесь.
	--System:Log("BasicPlayer:OnReset name="..self:GetName())
	merge(self,BasicPlayer)
	self["AddAmmo"] = BasicPlayer.AddAmmo
	self["GetAmmoAmount"] = BasicPlayer.GetAmmoAmount
	self.ShowOnRadar = nil -- dont show on radar by default...
	self.bEnemyInCombat = 0  -- default radarstate
	self.HaveHands = nil
	self.SaveGunOutStatus = nil
	self.NotAllowDelay = nil
	self.DownTime = nil
	self.NotSwitch = nil
	self.AiAction = nil
	self.IsIndoor = 1 -- Один - чтобы не проскакивало при активации ИИ и все значения, зависящие от этой переменной не были большими. Потом всё-рано станет как есть на самом деле.
	self.GunTableOfRandomTrace = nil
	if self.MUTANT then
		if self.MUTANT=="big" then
			self.MyToneOfVoice = random(760,1060)
		elseif self.MUTANT=="fast" or self.MUTANT=="stealth" then
			self.MyToneOfVoice = random(800,1060)
		else
			self.MyToneOfVoice = random(970,2300)
		end
	elseif self.ANIMAL=="pig" then
		self.MyToneOfVoice = random(950,1050)	
	elseif self.MERC then
		self.MyToneOfVoice = random(880,1070) -- 900,1060 -- 1080 - голос молодого парня -- По умолчанию - 1000. Сильно высокие ненужно ставить, а то писклявые голоса не к лицу мужикам.
	else
		self.MyToneOfVoice = 1000
	end
	self.cnt:ResetCamera()
	-- BasicPlayer.ResetWeaponPack(self)

	local stats = self.cnt

	local nMaterialID=Game:GetMaterialIDByName("mat_flesh")
	self:CreateLivingEntity(self.PhysParams,nMaterialID)
	self:PhysicalizeCharacter(self.PhysParams.mass,nMaterialID,self.BulletImpactParams.stiffness_scale,0)
	self:SetCharacterPhysicParams(0,"",PHYSICPARAM_SIMULATION,self.BulletImpactParams)
	self.isPhysicalized = 1

	self.LastFootStepTime=0

	local CurWeaponInfo = self.weapon_info
	if (CurWeaponInfo) then
		local tempfiremode = self.cnt.firemode+1
		local w = self.cnt.weapon
		if (w) then
			local CurFireParams = w.FireParams[tempfiremode]
			local SoundData = CurWeaponInfo.SndInstances[tempfiremode]
			if (SoundData) then
				BasicWeapon.StopFireLoop(CurWeapon,self,CurFireParams,SoundData)
			end
		end
	end

	stats:SetCurrWeapon(0)

	stats:SetDimNormal(self.PlayerDimNormal)
	stats:SetDimCrouch(self.PlayerDimCrouch)
	stats:SetDimProne(self.PlayerDimProne)

	stats:SetMinAngleLimitV(self.normMinAngle)
	stats:SetMaxAngleLimitV(self.normMaxAngle)
	stats:EnableAngleLimitV(1)
	stats:EnableAngleLimitH(nil)

	if (self.AniRefSpeeds==nil) then
		self.AniRefSpeeds = self.Properties.AniRefSpeeds
	end

	self.cnt:SetAnimationRefSpeedRun(self.AniRefSpeeds.RunFwd,self.AniRefSpeeds.RunSide,self.AniRefSpeeds.RunBack)
	self.cnt:SetAnimationRefSpeedWalk(self.AniRefSpeeds.WalkFwd,self.AniRefSpeeds.WalkSide,self.AniRefSpeeds.WalkBack)
	self.cnt:SetAnimationRefSpeedWalkRelaxed(self.AniRefSpeeds.WalkRelaxedFwd,self.AniRefSpeeds.WalkRelaxedSide,self.AniRefSpeeds.WalkRelaxedBack)
	self.cnt:SetAnimationRefSpeedXWalk(self.AniRefSpeeds.XWalkFwd,self.AniRefSpeeds.XWalkSide,self.AniRefSpeeds.XWalkBack)
	if (self.AniRefSpeeds.XRunFwd) then
		self.cnt:SetAnimationRefSpeedXRun(self.AniRefSpeeds.XRunFwd,self.AniRefSpeeds.XRunSide,self.AniRefSpeeds.XRunBack)
	end
	self.cnt:SetAnimationRefSpeedCrouch(self.AniRefSpeeds.CrouchFwd,self.AniRefSpeeds.CrouchSide,self.AniRefSpeeds.CrouchBack)

	stats:SetDynamicsProperties(self.DynProp)
	if (Game:IsMultiplayer()) then
	  local Flags = {flags_mask = lef_push_objects+lef_push_players+lef_snap_velocities,flags = lef_snap_velocities,}
	  self:SetPhysicParams(PHYSICPARAM_FLAGS,Flags)
	end

	if self.Properties.max_health>255 then	-- 255 is the maximum for players (network protocol limitation)
		self.Properties.max_health=255
	end

	stats.health = self.Properties.max_health
	stats.max_health = self.Properties.max_health
	stats.armor = 0
	stats.max_armor = 100
	stats.fallscale = self.fallscale
	stats.has_flashlight = 0
	stats.has_binoculars = 0
	self.FlashLightActive = 0
	self.items = {}
	self.IsDedbody = nil
	self.ReceivedDamage = nil

	if self.Properties.equipEquipment then
		local WeaponPack = EquipPacks[self.Properties.equipEquipment]
		if (WeaponPack) then
			--search if there is a primary weapon
			for i,val in WeaponPack do
				if (val.Type=="Item") then
					if (val.Name=="PickupFlashlight") then
						self.cnt:GiveFlashLight(1)
					elseif (val.Name=="PickupBinoculars") then
						self.cnt:GiveBinoculars(1)
					elseif (val.Name=="PickupHeatVisionGoggles") then
						self.items.heatvisiongoggles = 1
					end
				end
			end
		end -- wp
	end -- eq

	if (self.Properties.fMeleeDistance) then
		stats.melee_distance = self.Properties.fMeleeDistance
	else
		stats.melee_distance = 2
	end

	self:EnablePhysics(1)
	self.cnt:InitStaminaTable(self.StaminaTable)
	self:DrawCharacter(0,1)

	if (Game:IsServer()) then
		self:GotoState("Alive")
	end

	self.cnt:UseLadder(0)
	self.cnt:ResetCamera() -- Дважды?
	self.Ladder = nil
	self.DownSound = nil
	self.fBodyHeat=1

	-- available effects: 1= reset,2= team color,3= invulnerable,4= heatsource,5= stealth mode,6= mutated arms
	self.iPlayerEffect=1
	self.bPlayerHeatMask=0
	self.fLastBodyHeat=0
	self.iLastWeaponID=0
	self.bUpdatePlayerEffectParams=1
	-- render effects
	self.iEffectCount=0
	self.pEffectStack={}
	self.pEffectStack[1]=1

	self.jumpSoundPlayed = 0
	self.hasJumped = 0
	self.lastStanceSound = 0
	--self.lastProne = 0

	if self.ANIMAL and self.ANIMAL=="pig" then -- Бред, когда из свиньи выпадает мачете(devils_coast).
		if self.Properties.equipEquipment~="" then self.Properties.equipEquipment="" end
		if self.Properties.equipDropPack~="" then self.Properties.equipDropPack="" end
	end

	self:SetShader("",4)
	self:SetSecondShader("",4)

	if self~=_localplayer and self.Ammo then -- Не помогает чего-то.
		for i,val in MaxAmmo do -- Это если у персонажа нет оружия, чтобы хотя бы гранаты были.
			-- self.Ammo[i]=0 -- Патроны не сбрасывает. (
			self.Ammo["FlareGrenade"] = 0
			self.Ammo["GlowStick"] = 0
			self.Ammo["Rock"] = 0
			self.Ammo["HandGrenade"] = random(0,2) -- 0,3
			self.Ammo["SmokeGrenade"] = random(0,1)
			self.Ammo["FlashbangGrenade"] = random(0,1)
		end
	end

	-- self.AllowPlayTestSoundFile = nil

	if self.SayWordSound and Sound:IsPlaying(self.SayWordSound.Sound) then
		Sound:StopSound(self.SayWordSound.Sound)
	end
end

function BasicPlayer:Server_OnInit()
	-- Only when the player spawns the first time
	if self==_localplayer and not _LastCheckPPos then
		_LastCheckPPos = self:GetPos()
	end
	self:RegisterStates(self)
	if (not self.wasreset) then
		BasicPlayer.OnReset(self)
		self.wasreset=1
	end
	if self.ai then
		self:FriendGroup(self)
	end
	BasicPlayer.InitAllWeapons(self)

	self.MyInventory = new(Inventory)
	Game:CreateVariable("p_max_vert_angle")
	p_max_vert_angle=90

	if (self.isPhysicalized==0) then
		local nMaterialID=Game:GetMaterialIDByName("mat_flesh")
		self:PhysicalizeCharacter(self.PhysParams.mass,nMaterialID,self.BulletImpactParams.stiffness_scale,0)
		self:SetCharacterPhysicParams(0,"",PHYSICPARAM_SIMULATION,self.BulletImpactParams)
		self.isPhysicalized = 1
	end

	self.Refractive = nil
	self.fLastRefractValue = 0
	self.vLastPos = self:GetPos()

	self:SetTimer(self.UpdateTime)
	self.fBodyHeat=1
end

function BasicPlayer:Client_OnInit()

	self:RegisterStates()

	if (not self.wasreset) then
		BasicPlayer.OnReset(self)
		self.wasreset=1
	end
	if (self.SoundEvents) then
		if (not self.Properties.KEYFRAME_TABLE) or (self.Properties.KEYFRAME_TABLE=="BASE_HUMAN_MODEL") then
			merge(self.SoundEvents,self.TpvReloadFX)
		end
		for i,event in self.SoundEvents do
			self:SetAnimationKeyEvent(event[1],event[2],event[3])
			if (event[4]~=nil) then
				Sound:SetSoundVolume(event[3],event[4])
			end
		end
	end

	if (self.AnimationBlendingTimes) then
		for k,blends in self.AnimationBlendingTimes do
			self.cnt:SetBlendTime(blends[1],blends[2])
		end
	end

	--self:RegisterStates()
	--self:GotoState("Alive")

	BasicPlayer.InitAllWeapons(self)

	self.Refractive = nil
	self.fLastRefractValue = 0
	self.vLastPos = self:GetPos()

	if (self.isPhysicalized==0) then
		local nMaterialID=Game:GetMaterialIDByName("mat_flesh")
		self:PhysicalizeCharacter(self.PhysParams.mass,nMaterialID,self.BulletImpactParams.stiffness_scale,0)
		self:SetCharacterPhysicParams(0,"",PHYSICPARAM_SIMULATION,self.BulletImpactParams)
		self.isPhysicalized = 1
	end

	--self:RenderShadow(1) -- enable rendering of player shadow

	self.cnt:InitDynamicLight(self.lightFileTexture,self.lightFileShader)
	self:SetTimer(self.UpdateTime)

	self.fBodyHeat=1

	-- available effects: 1= reset,2= team color,3= invulnerable,4= heatsource,5= stealth mode,6= mutated arms
	self.iPlayerEffect=1
	self.bPlayerHeatMask=0
	self.fLastBodyHeat=0
	self.iLastWeaponID=0
	self.bUpdatePlayerEffectParams=1
	-- render effects
	self.iEffectCount=0
	self.pEffectStack={}
	self.pEffectStack[1]=1
	--System:Log("function BasicPlayer:Client_OnInit() end")
end


function BasicPlayer:InitAllWeapons(forceInit)
	-- Everytime AddWeapon() is called every active player entity gets
	-- ScriptInitWeapon() called for the new weapon. The name is also placed in
	-- the global WeaponsLoaded table. So new players need to traverse the list
	-- of recently spawned weapons them self and call ScriptInitWeapon() for each
	-- of them. Also,the player entity needs to call MakeWeaponAvailable() for
	-- each weapon in his weapon pack

	self.bAllWeaponsInititalized = nil

	if (self.DontInitWeapons==nil) then
		-- Let the container initialize the C/C++ strutures for all weapons
		self.cnt:InitWeapons()
		-- Create a new map to map weapon entity class IDs to weapon state information
		if (self.WeaponState==nil) then
			self.WeaponState = new(Map)
		end
		-- Main player doesn't have an equipEquipment property,copy from global table
		if (not Game:IsMultiplayer()) then
			if ((self.Properties.equipEquipment==nil) or (self==_localplayer)) then
				self.Properties.equipEquipment = MainPlayerEquipPack
			end
		else
			if ((self.Properties.equipEquipment==nil)) then
				self.Properties.equipEquipment = MainPlayerEquipPack
			end
		end
		self.Ammo={}
		for i,val in MaxAmmo do
			self.Ammo[i]=0
		end
		local primary_weapon
		-- Copy initial ammo table from equip pack
		if (self.Properties.equipEquipment) then
			local WeaponPack = EquipPacks[self.Properties.equipEquipment]
			if (WeaponPack) then
				if (self.DontResetAmmo==nil) then
					merge(self.Ammo,WeaponPack.Ammo)
				end
				-- search if there is a primary weapon
				for i,val in WeaponPack do
					if (val.Primary) then
						primary_weapon=val
					end
					if (Game:IsServer()) then
						local item = nil
						if (val.Type=="Item") then
							if (val.Name=="PickupBinoculars") then
								item = "B"
							elseif (val.Name=="PickupHeatVisionGoggles" and self.items) then
								item = "C"
							elseif (val.Name=="PickupFlashlight") then
								item = "F"
							end
						end
						if (item) then
							local serverSlot = Server:GetServerSlotByEntityId(self.id)
							if (serverSlot) then
								serverSlot:SendCommand("GI "..item)
							end
						end
						if self.ai and not self.IsAiPlayer then
							-- Теперь ИИ имеет такой же ограниченный максимальный боезапас как и игрок.
							for i,val in MaxAmmo do -- Надо доработать.
								-- if self.Ammo[i]~=val and self.Ammo[i]~=self.Ammo["VehicleMG"] then
								if self.Ammo[i]~=val and self.Ammo[i]~=self.Ammo["VehicleMG"] then -- В условии присутствует "не равно" из-за того, что по одному магазину сразу девается на зарядку оружия.
									self.Ammo[i]=val
									-- Похоже, случайность для гранат не работает.
									self.Ammo["FlareGrenade"] = 0 -- Искрящиеся гранаты, которые не доработаны. Их убираем.
									self.Ammo["GlowStick"] = 0 -- Светящиеся гранаты, которые не доработаны. Их тоже убираем.
									self.Ammo["Rock"] = 0 -- Камни.
									local IgnoreTable = {"coretech.cgf","evil_worker","lab_assistant","lead_scientist"}
									local IgnoreManTable
									for i,val in IgnoreTable do
										if strfind(strlower(self.Properties.fileModel),val) then IgnoreManTable=1 break end
									end
									if not IgnoreManTable then
										self.Ammo["HandGrenade"] = random(0,2) -- 0,3 Не работает чего-то... Указывается тип снарядов, а не названия пушек!
										self.Ammo["SmokeGrenade"] = random(0,1)
										self.Ammo["FlashbangGrenade"] = random(0,1)
									else
										self.Ammo["HandGrenade"] = 0
										self.Ammo["SmokeGrenade"] = 0
										self.Ammo["FlashbangGrenade"] = 0
									end
								end
							end
						elseif self==_localplayer or self.IsAiPlayer then
							for i,val in MaxAmmo do
								if self.Ammo[i]>val then
									self.Ammo[i]=val
								end
							end
						end
					end
					if (val.Type=="Weapon") then
						BasicPlayer.ScriptInitWeapon(self,val.Name)
					end
				end
			end
		end
		if (primary_weapon and WeaponClassesEx[primary_weapon.Name]) then
			self.cnt:SetCurrWeapon(WeaponClassesEx[primary_weapon.Name].id)
		else
			-- Make sure we have a weapon active
			self.cnt:SelectFirstWeapon()
		end
	else
		self.DontInitWeapons = nil
	end

	--select granade
	--the rock
	self.cnt.grenadetype=1
	local id=2 -- rock id is 1
	for i=id,count(GrenadesClasses) do
		if self.Ammo and self.Ammo[GrenadesClasses[id]]>0 then
			self.cnt.grenadetype=id
			self.cnt.numofgrenades=self.Ammo[GrenadesClasses[id]]
		end
	end
	self.bAllWeaponsInititalized = 1
end

function BasicPlayer:ScriptInitWeapon(wName,bIgnoreLoadClips,ForceAddWeapon)
	-- Add the data structures for the passed weapon to this player and make an instance
	-- of the sounds. Give the weapon to the player if it is in his weapon pack

	-- make sure that the weapon is loaded
	Game:AddWeapon(wName)

	-- Create a new map to map weapon entity class IDs to weapon state information
	if (not self.WeaponState) then
		self.WeaponState = new(Map)
	end

	-- Initializing weapon state info
	local WeaponStateTemplate  = {
		FireMode, -- Firemode
		AmmoInClip, -- Amount of ammunition in the current clip
	}

	local CurWeapon = WeaponClassesEx[wName]

	if not CurWeapon then
		System:Log("ERROR: Can't find weapon '"..wName.."' in weapon tables !")
		do return end
	end

	local CurWeaponClsID = CurWeapon.id

	-- Weapon name and table
	local weapontbl = getglobal(wName)

	-- Create the state table for this weapon
	local NewTable = new(WeaponStateTemplate)
	NewTable.FireMode = 0
	NewTable.AmmoInClip = {0}
	NewTable.Name = wName
	NewTable.SndInstances = {}

	for i2,CurFireParameters in weapontbl.FireParams do
		NewTable.AmmoInClip[i2] = 0
		if ((i2==1 or i2==2) and not bIgnoreLoadClips and
			self.Ammo[CurFireParameters.AmmoType] and self.Ammo[CurFireParameters.AmmoType]>0) then
			local amount
			local distributed
			local bpc=CurFireParameters.bullets_per_clip
			amount=min(bpc,self.Ammo[CurFireParameters.AmmoType])
			self.Ammo[CurFireParameters.AmmoType]=self.Ammo[CurFireParameters.AmmoType]-amount
			NewTable.AmmoInClip[i2]=amount
		end
		-- local Flags = bor(SOUND_RELATIVE,SOUND_UNSCALABLE)
		-- local Flags = bor(SOUND_RELATIVE,SOUND_UNSCALABLE,SOUND_OCCLUSION,SOUND_3D,SOUND_RADIUS,SOUND_DOPPLER,SOUND_FADE_OUT_UNDERWATER)
		local Flags = bor(SOUND_RELATIVE,SOUND_UNSCALABLE,SOUND_OCCLUSION,SOUND_RADIUS,SOUND_DOPPLER)
		-- Marco's NOTE: I'm adding here sound priority for weapon sounds. The last parameter
		-- in load3dsound is the sound priority, the range is from 0 to 255, with 255 Последнее число, 128 - приоритет.
		-- being maximum priority
		NewTable.SndInstances[i2] = {}
		if (type(CurFireParameters.DrySound)=="string") then
			-- NewTable.SndInstances[i2]["DrySound"] = Sound:Load3DSound(CurFireParameters.DrySound,Flags,CurFireParameters.SoundMinMaxVol[1],CurFireParameters.SoundMinMaxVol[2],CurFireParameters.SoundMinMaxVol[3])
			NewTable.SndInstances[i2]["DrySound"] = Sound:Load3DSound(CurFireParameters.DrySound,Flags,CurFireParameters.SoundMinMaxVol[1],1,20,127) -- Это не дело, что звуки того, что патроны закончились звучат так громко.
		end
		if (type(CurFireParameters.FireLoop)=="string") then -- От третьего лица.
			NewTable.SndInstances[i2]["FireLoop"] = Sound:Load3DSound(CurFireParameters.FireLoop,Flags,CurFireParameters.SoundMinMaxVol[1],CurFireParameters.SoundMinMaxVol[2],CurFireParameters.SoundMinMaxVol[3],128)
		end
		if (type(CurFireParameters.FireLoopStereo)=="string") then -- От первого лица.
			NewTable.SndInstances[i2]["FireLoopStereo"] = Sound:LoadSound(CurFireParameters.FireLoopStereo)
		end
		if (type(CurFireParameters.FireLoop)=="table") then -- От третьего лица.
			NewTable.SndInstances[i2]["FireLoop"] = {} -- Что-то не понял, почему именно так, а не так: NewTable.SndInstances[i2].FireLoop = {} ?
			-- НУ НИХЕРА СЕБЕ! НИЖЕ, В FireSounds АБСОЛЮТНО ТОЧНО-ТАКОЕ ЖЕ РЕШЕНИЕ! А я мучался...
			for i,val in CurFireParameters.FireLoop do -- val - текст из переменной, i - порядковый номер, i2 - порядковый номер режима огня.
				-- System:Log(self:GetName()..": CurFireParameters.FireLoop: "..val.. " "..i)
				-- System:Log(self:GetName()..": CurFireParameters.FireLoop: "..i2)
				-- if type(val)=="string" then -- А зачем я вообще так сделал?
					NewTable.SndInstances[i2].FireLoop[i] = Sound:Load3DSound(val,Flags,CurFireParameters.SoundMinMaxVol[1],CurFireParameters.SoundMinMaxVol[2],CurFireParameters.SoundMinMaxVol[3],128)
				-- else
					-- NewTable.SndInstances[i2].FireLoop[i] = val
				-- end
			end
		end
		if (type(CurFireParameters.FireLoopStereo)=="table") then -- От первого лица.
			NewTable.SndInstances[i2]["FireLoopStereo"] = {}
			for i,val in CurFireParameters.FireLoopStereo do
				-- if type(val)=="string" then
					NewTable.SndInstances[i2].FireLoopStereo[i] = Sound:LoadSound(val)
				-- else
					-- NewTable.SndInstances[i2].FireLoopStereo[i] = val
				-- end
			end
		end
		if (type(CurFireParameters.FireLoopIndoor)=="table") then -- От третьего лица.
			NewTable.SndInstances[i2]["FireLoopIndoor"] = {} -- Внутри помещений.
			for i,val in CurFireParameters.FireLoopIndoor do
				NewTable.SndInstances[i2].FireLoopIndoor[i] = Sound:Load3DSound(val,Flags,CurFireParameters.SoundMinMaxVol[1],CurFireParameters.SoundMinMaxVol[2],CurFireParameters.SoundMinMaxVol[3],128)
			end
		end
		if (type(CurFireParameters.FireLoopStereoIndoor)=="table") then -- От первого лица.
			NewTable.SndInstances[i2]["FireLoopStereoIndoor"] = {} -- Внутри помещений.
			for i,val in CurFireParameters.FireLoopStereoIndoor do
				NewTable.SndInstances[i2].FireLoopStereoIndoor[i] = Sound:LoadSound(val)
			end
		end
		if (type(CurFireParameters.TrailOff)=="string") then -- От третьего лица.
			if wName=="MG" then
				NewTable.SndInstances[i2]["TrailOff"] = Sound:Load3DSound(CurFireParameters.TrailOff,Flags,CurFireParameters.SoundMinMaxVol[1],1,50,128)
				-- System:Log(self:GetName()..": USE MG SOUNDS RANGE")
			else
				NewTable.SndInstances[i2]["TrailOff"] = Sound:Load3DSound(CurFireParameters.TrailOff,Flags,CurFireParameters.SoundMinMaxVol[1],CurFireParameters.SoundMinMaxVol[2],CurFireParameters.SoundMinMaxVol[3],128)
			end
		end
		if (type(CurFireParameters.TrailOffStereo)=="string") then -- От первого лица.
			NewTable.SndInstances[i2]["TrailOffStereo"] = Sound:LoadSound(CurFireParameters.TrailOffStereo)
		end
		if (CurFireParameters.FireSounds) then  -- От третьего лица.
			NewTable.SndInstances[i2]["FireSounds"] = {}
			for iSingleSnd,CurSndFile in CurFireParameters.FireSounds do
				if type(CurSndFile)=="string" then
					local CurrSound = Sound:Load3DSound(CurSndFile,Flags,CurFireParameters.SoundMinMaxVol[1],CurFireParameters.SoundMinMaxVol[2],CurFireParameters.SoundMinMaxVol[3],128)
					if CurrSound then Sound:SetSoundPitching(CurrSound,100) end -- И что это такое?
					NewTable.SndInstances[i2]["FireSounds"][iSingleSnd] = CurrSound
				end
			end
		end
		-- [marco] stereo sounds
		if (CurFireParameters.FireSoundsStereo) then -- От первого лица.
			NewTable.SndInstances[i2]["FireSoundsStereo"] = {}
			for iSingleSnd,CurSndFile in CurFireParameters.FireSoundsStereo do
				if type(CurSndFile)=="string" then
					local CurrSound = Sound:LoadSound(CurSndFile)
					if CurrSound then Sound:SetSoundPitching(CurrSound,100)	end
					NewTable.SndInstances[i2]["FireSoundsStereo"][iSingleSnd] = CurrSound
				end
			end
		end
		if (type(CurFireParameters.FireModeChangeSound)=="string") then -- У оружия собственные звуки переключения режима огня.
			NewTable.SndInstances[i2]["FireModeChangeSound"] = Sound:LoadSound(CurFireParameters.FireModeChangeSound,0,128)
		end

		if CurFireParameters.generic_whizz==1 then
			-- local Flags2 = bor(SOUND_RELATIVE,SOUND_UNSCALABLE,SOUND_OCCLUSION,SOUND_DOPPLER)
			local Flags2 = bor(SOUND_UNSCALABLE,SOUND_OCCLUSION,SOUND_DOPPLER)
			NewTable.SndInstances[i2]["generic_whizz_sound"] = {}
			NewTable.SndInstances[i2].generic_whizz_sound={
				Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_01.mp3",Flags2,255,2,10,129),
				Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_02.mp3",Flags2,255,2,10,129),
				Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_03.mp3",Flags2,255,2,10,129),
				Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_04.mp3",Flags2,255,2,10,129),
				Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_05.mp3",Flags2,255,2,10,129),
				Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_06.mp3",Flags2,255,2,10,129),
				Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_07.mp3",Flags2,255,2,10,129),
				Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_08.mp3",Flags2,255,2,10,129),
				Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_09.mp3",Flags2,255,2,10,129),
				Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_10.mp3",Flags2,255,2,10,129),
				Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_11.mp3",Flags2,255,2,10,129),
				Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_12.mp3",Flags2,255,2,10,129),
				Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_13.mp3",Flags2,255,2,10,129),
				Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_14.mp3",Flags2,255,2,10,129),
				Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_15.mp3",Flags2,255,2,10,129),
				Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_16.mp3",Flags2,255,2,10,129),
				Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_17.mp3",Flags2,255,2,10,129),
				Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_18.mp3",Flags2,255,2,10,129),
				Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_19.mp3",Flags2,255,2,10,129),
				Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_20.mp3",Flags2,255,2,10,129),
				Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_21.mp3",Flags2,255,2,10,129),
				Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_22.mp3",Flags2,255,2,10,129),
				Sound:Load3DSound("Sounds/Weapons/Bullets/flyby_23.mp3",Flags2,255,2,10,129),
			}
		end
	end
	-- Add to the weapon state of this player
	self.WeaponState[CurWeaponClsID]=NewTable
	if ForceAddWeapon then
		self.cnt:MakeWeaponAvailable(CurWeaponClsID,1)
	else
		-- Make the weapons available which belong to the player's weapon pack
		local WeaponPackName = self.Properties.equipEquipment
		if (WeaponPackName) then
			local PlayerPack = EquipPacks[WeaponPackName]
			if (PlayerPack) then
				for iIdx,CurPackWeapon in PlayerPack do
					if (CurPackWeapon.Type=="Weapon" and CurPackWeapon.Name==wName) then
						self.cnt:MakeWeaponAvailable(CurWeaponClsID,1)
						--System:Log(" --> Name: "..wName)
					end
				end
			end
		end
	end
end

-- function BasicPlayer:AddItemInWeaponPack(ItemType,ItemName) -- Спрашивается: "А нафига вообще это нужно?". Пока пользы нет.
	-- -- Добавляет указанные вещи в оружейный набор во время игры.
	-- -- Weapon, Item, Ammo, Primary.
	-- if not ItemType or not ItemName then
		-- System:Log("ERROR: BasicPlayer:AddItemInWeaponPack Not enough parameters!")
		-- return
	-- end
	-- local CurrentEquipment = self.Properties.equipEquipment
	-- if not CurrentEquipment then CurrentEquipment="none" end
	-- local MyPack = EquipPacks[CurrentEquipment]
	-- if not MyPack then return end
	-- if not self.SaveWeaponPack then
		-- for i=1,100 do
			-- if MyPack[i] then
				-- if MyPack[i].Type and MyPack[i].Name then
					-- self.SaveWeaponPack={}
					-- self.SaveWeaponPack[i]={MyPack[i].Type,MyPack[i].Name}
				-- end
			-- end
		-- end
	-- end
	-- local MaxStep
	-- for i,val in MyPack do
		-- if val.Type==ItemType then
			-- if val.Name==ItemName then
				-- -- Если этот элемент у нас уже есть, то зачем добавлять его копию?
				-- System:Log("AddItemInWeaponPack: The ItemType ("..ItemName..") is already present in the set, slot number: "..i)
				-- return
			-- else
				-- MaxStep=i -- i - Общее количество.
			-- end
		-- end
	-- end
	-- for i=1,MaxStep+1 do -- При стандартном количестве вещей, в наборе их может быть максимум 51 еденица.
		-- if MyPack[i] then
			-- local Type = MyPack[i].Type
			-- local Name = MyPack[i].Name
			-- if Type and Name then
				-- System:Log(self:GetName()..": Current "..Type.." in weapon pack: "..Name)
			-- end
		-- else
			-- -- Когда нашли пустой слот, мы его заполняем.
			-- MyPack[i]={Type=ItemType,Name=ItemName}
			-- -- for j,weapon in WeaponClassesEx do
				-- -- if j==ItemName then
					-- -- -- self.cnt:MakeWeaponAvailable(weapon.id,1) -- Поможет?
				-- -- end
			-- -- end
			-- EquipPacks[CurrentEquipment]=MyPack
			-- -- if ItemType=="Weapon" then
				-- -- -- AddWeapon(ItemName)
			-- -- end
			-- System:Log(self:GetName()..": Add new "..ItemType.."("..ItemName..") in weapon pack, slot number: "..i)
			-- break
		-- end
	-- end
-- end

-- function BasicPlayer:RemoveItemInWeaponPack(ItemType,ItemName)
	-- -- Удаляет указанные вещи из оружейного набора во время игры.
	-- if not ItemType or not ItemName then
		-- System:Log("ERROR: BasicPlayer:RemoveItemInWeaponPack Not enough parameters!")
		-- return
	-- end
	-- local CurrentEquipment = self.Properties.equipEquipment
	-- if not CurrentEquipment then CurrentEquipment="none" end
	-- local MyPack = EquipPacks[CurrentEquipment]
	-- if not MyPack then return end
	-- if not self.SaveWeaponPack then
		-- for i=1,100 do
			-- if MyPack[i] then
				-- if MyPack[i].Type and MyPack[i].Name then
					-- self.SaveWeaponPack={}
					-- self.SaveWeaponPack[i]={MyPack[i].Type,MyPack[i].Name}
				-- end
			-- end
		-- end
	-- end
	-- for i,val in MyPack do
		-- if val.Type==ItemType then
			-- if val.Name==ItemName then
				-- MyPack[i]=nil
				-- -- for j,weapon in WeaponClassesEx do
					-- -- if j==ItemName then
						-- -- -- self.cnt:MakeWeaponAvailable(weapon.id,0)
					-- -- end
				-- -- end
				-- EquipPacks[CurrentEquipment]=MyPack
				-- System:Log(self:GetName()..": "..ItemType.."("..ItemName..") in weapon pack removed, slot number: "..i)
				-- break
			-- end
		-- end
	-- end
-- end

-- function BasicPlayer:ResetWeaponPack() -- Перестало срабатывать.
	-- -- Восстановление, чтобы не было случаев с повторно добавляющимися элементами или не подбирающимися подарками.
	-- local CurrentEquipment = self.Properties.equipEquipment
	-- if not CurrentEquipment then CurrentEquipment="none" end
	-- local MyPack = EquipPacks[CurrentEquipment]
	-- if not MyPack then return end
	-- System:Log(self:GetName()..": RESET WEAPON PACK")

	-- if self.SaveWeaponPack then
		-- System:Log(self:GetName()..": RESET WEAPON PACK 2")

		-- for i=1,100 do
			-- -- for j,weapon in WeaponClassesEx do
				-- -- self.cnt:MakeWeaponAvailable(weapon.id,0)
			-- -- end
			-- if self.SaveWeaponPack[i] then
				-- MyPack[i]={Type=self.SaveWeaponPack[i][1],Name=self.SaveWeaponPack[i][2]}
				-- -- for j,weapon in WeaponClassesEx do
					-- -- if j==self.SaveWeaponPack[i][2] then
						-- -- -- self.cnt:MakeWeaponAvailable(weapon.id,1)
					-- -- end
				-- -- end
				-- -- if self.SaveWeaponPack[i][1]=="Weapon" then
					-- -- -- AddWeapon(self.SaveWeaponPack[i][2])
				-- -- end
			-- else
				-- MyPack[i]={Type=nil,Name=nil}
			-- end
		-- end
		-- EquipPacks[CurrentEquipment]=MyPack

		-- MyPack = EquipPacks[CurrentEquipment]
		-- for i=1,100 do
			-- if MyPack[i] then
				-- local Type = MyPack[i].Type
				-- local Name = MyPack[i].Name
				-- if Type and Name then
					-- System:Log(self:GetName()..": REAL WEAPON PACK "..Type.." in weapon pack: "..Name)
				-- end
			-- end
		-- end

		-- for i=1,100 do
			-- if self.SaveWeaponPack[i] then
				-- local Type = self.SaveWeaponPack[i][1]
				-- local Name = self.SaveWeaponPack[i][2]
				-- if Type and Name then
					-- System:Log(self:GetName()..": SAVED WEAPON PACK "..Type.." in weapon pack: "..Name)
				-- end
			-- end
		-- end

		-- System:Log(self:GetName()..": Weapon pack was resetted")
		-- self.SaveWeaponPack=nil
	-- end
-- end

--
function BasicPlayer:HelmetOn()
	if (self.PropertiesInstance.bHelmetProtection and self.PropertiesInstance.bHelmetProtection==1) then
		self.hasHelmet = 1
	end
end

--
function BasicPlayer:HelmetOff()
	self.hasHelmet = 0
end

--
function BasicPlayer:HelmetHitProceed(direction,impuls) -- Падение шлема с головы не работает.
	-- we don't have helmets dropped anymore
	do return end

	if (random(0,3)>1) then
		do return end
	end

	local helmet = Server.SpawnEntity("Helmet")
	--self.theHelmet = Server.SpawnEntity("Helmet")
	local pos = self:GetBonePos("hat_bone")
	--self.theHelmet.
	helmet:EnablePhysics(1)
	helmet:SetPos(pos)
	direction.z = direction.z + 5
	helmet:AddImpulseObj(direction,impuls)
	--theHelmet.Activate(theHelmet,direction,impuls)
	helmet:DrawObject(0,1)
	BasicPlayer.HelmetOff(self)
end

function BasicPlayer:AddAmmo(AmmoType,Amount)
	if (self.Ammo[AmmoType]==nil) then
		System:Log("Unknown ammo type so far, add to WeaponSystem.lua-->AmmoAvailable")
		return
	end
	local wi = self.weapon_info
	if (self.cnt.weapon and wi and self.cnt.weapon.FireParams[wi.FireMode+1].AmmoType==AmmoType) then
		self.cnt.ammo=self.cnt.ammo + Amount
		self.Ammo[AmmoType] = self.cnt.ammo
	elseif (GrenadesClasses[self.cnt.grenadetype]==AmmoType) then
		self.cnt.numofgrenades=self.cnt.numofgrenades + Amount
		self.Ammo[AmmoType] = self.cnt.numofgrenades
	else
		self.Ammo[AmmoType] = self.Ammo[AmmoType] + Amount
	end
	--automatically switches grenade type
	for i,val in GrenadesClasses do
		if (AmmoType==val) then
			BasicPlayer.SelectGrenade(self,AmmoType)
		end
	end
end

-- get ammo from all weapons,which the player currently has
-- AmmoType should be a string, such as "SMG" or "ASSAULT"
function BasicPlayer:GetAmmoAmount(AmmoType)
	local stats = self.cnt
	local curr_amount = self.Ammo[AmmoType]
	local wi = self.weapon_info
	if (stats.weapon and wi and wi.FireMode and stats.weapon.FireParams[wi.FireMode+1].AmmoType==AmmoType) then
		curr_amount = stats.ammo
	elseif ((stats.grenadetype~=1) and (GrenadesClasses[stats.grenadetype]==AmmoType)) then
		curr_amount = stats.numofgrenades
	end
	return curr_amount
end

function BasicPlayer:Client_OnUpdate(DeltaTime)
end

function BasicPlayer:Client_DeadOnUpdate(DeltaTime)

	if self.RePlaySound and self.SayWordSound and not self.SayWordSound.DialogWord then -- Почти тоже, что и в Other.
		self.RePlaySound = nil
		if not self.HeadShot then -- Чтобы при убийстве в голову не издавали никаких охов и ахов. Ведь им же голову нафиг разнесли!
			if self.SayWordSound.Scale then 
				self.cnt:PlaySound(self.SayWordSound.Sound,self.SayWordSound.Scale)
				self.SayWordSound.Scale = nil
			else
				self.cnt:PlaySound(self.SayWordSound.Sound) -- Снова воспроизводим файл.
			end
			Sound:SetSoundFrequency(self.SayWordSound.Sound,self.MyToneOfVoice) -- Меняем высоту звука (тон).
			-- if Hud.SharedSoundScale then
				-- Sound:SetSoundVolume(self.SayWordSound.Sound,Hud.SharedSoundScale)
			-- end
		end
	end

	-- http://www.farcry.ru/forum/viewtopic.php?t=1533&postdays=0&postorder=asc&start=140
	self:SetScriptUpdateRate(0)
	local stats = self.cnt
	-- tiago: added body heat,used in CryVision shader -- mixer - slower now
	-- mixer: also used for realistic in-water bleed decreasing
	self.fBodyHeat=self.fBodyHeat - _frametime*.01
	if (self.fBodyHeat<0) then
		self.fBodyHeat=0
	end
	BasicPlayer.ProcessPlayerEffects(self)
	local HasCollided = stats:HasCollided()
	if self.DownSound then
		local Velocity = self:GetVelocity()
		-- System:Log(self:GetName().." Velocity.z: "..Velocity.z)
		if self.PrevHasCollided[1] and not HasCollided and (Velocity.z<-.3 or Velocity.z>.3) then self.DownSound=nil end
	end
	self.PrevHasCollided = {HasCollided}
	if HasCollided and not self.DownSound then
		local CurWeaponInfo = self.weapon_info
		if (CurWeaponInfo) then
			local tempfiremode = self.cnt.firemode+1
			local w = self.cnt.weapon
			if (w) then
				local CurFireParams = w.FireParams[tempfiremode]
				local SoundData = CurWeaponInfo.SndInstances[tempfiremode]
				if (SoundData) then
					BasicWeapon.StopFireLoop(CurWeapon,self,CurFireParams,SoundData) -- Что за???
				end
			end
		end
		local normal = g_Vectors.up
		local material=self.cnt:GetTreadedOnMaterial()
		if material then
			-- Hud:AddMessage(self:GetName().." self.DownSound")
			ExecuteMaterial(self:GetPos(),normal,material.player_drop,1)
		end
		self.BloodTimer = 0
		self.DownSound = 1
		if g_gore~="0" then
			-- Hud:AddMessage(self:GetName().." g_gore: "..g_gore)
			local BodyHitPos = self:GetBonePos("Bip01 Spine")
			self.cnt:GetProjectedBloodPos(BodyHitPos,g_Vectors.v001,"GoreDecals",1)
			self.cnt:GetProjectedBloodPos(BodyHitPos,g_Vectors.v010,"GoreDecals",1)
			self.cnt:GetProjectedBloodPos(BodyHitPos,g_Vectors.v011,"GoreDecals",1)
			self.cnt:GetProjectedBloodPos(BodyHitPos,g_Vectors.v100,"GoreDecals",1)
			self.cnt:GetProjectedBloodPos(BodyHitPos,g_Vectors.v101,"GoreDecals",1)
			self.cnt:GetProjectedBloodPos(BodyHitPos,g_Vectors.v110,"GoreDecals",1)
			self.cnt:GetProjectedBloodPos(BodyHitPos,g_Vectors.v111,"GoreDecals",1)
			self.cnt:GetProjectedBloodPos(BodyHitPos,g_Vectors.av001,"GoreDecals",1)
			self.cnt:GetProjectedBloodPos(BodyHitPos,g_Vectors.av010,"GoreDecals",1)
			self.cnt:GetProjectedBloodPos(BodyHitPos,g_Vectors.av011,"GoreDecals",1)
			self.cnt:GetProjectedBloodPos(BodyHitPos,g_Vectors.av100,"GoreDecals",1)
			self.cnt:GetProjectedBloodPos(BodyHitPos,g_Vectors.av101,"GoreDecals",1)
			self.cnt:GetProjectedBloodPos(BodyHitPos,g_Vectors.av110,"GoreDecals",1)
			self.cnt:GetProjectedBloodPos(BodyHitPos,g_Vectors.av111,"GoreDecals",1)
			self.cnt:GetProjectedBloodPos(BodyHitPos,g_Vectors.bv010,"GoreDecals",1)
			self.cnt:GetProjectedBloodPos(BodyHitPos,g_Vectors.bv020,"GoreDecals",1)
			self.cnt:GetProjectedBloodPos(BodyHitPos,g_Vectors.bv100,"GoreDecals",1)
			self.cnt:GetProjectedBloodPos(BodyHitPos,g_Vectors.bv200,"GoreDecals",1)
		end
	end
end

function BasicPlayer:Server_OnUpdate(DeltaTime)
end

function BasicPlayer:Server_OnEvent(EventId,Params)
	local handler=BasicPlayer.Server_EventHandler[EventId]
	if (handler) then
		return handler(self,Params)
	end
end


function BasicPlayer:Server_OnEventDead(EventId,Params)
	local handler=BasicPlayer.Server_EventHandlerDead[EventId]
	if (handler) then
		return handler(self,Params)
	end
end



function BasicPlayer:Client_OnEvent(EventId,Params)
	local handler=BasicPlayer.Client_EventHandler[EventId]
	if (handler) then
		return handler(self,Params)
	end
end


function BasicPlayer:CalcAttenuation(SoundScale)
	if not SoundScale then SoundScale=1	end
	do return SoundScale end

	if (self and _localplayer and (self~=_localplayer)) then
		merge(BasicPlayer.aux_vec,_localplayer:GetPos())
		local Pos=self:GetPos()
		if (System:IsPointIndoors(BasicPlayer.aux_vec) and System:IsPointIndoors(Pos)) then
			local Hits=System:RayWorldIntersection(Pos,BasicPlayer.aux_vec,10,self.id)
			local Attenuation=getn(Hits)*(20/100)
			SoundScale=SoundScale-Attenuation
		end
	end
	return SoundScale
end

--
function BasicPlayer:PlaySoundEx(SoundHandle,SoundScale,NewToneChatter) -- В основном это звуки из keyframes.lua. А так же фонарик и экипировки (Equipment) когда я перемещаюсь.
	if Hud and Hud.SharedSoundScale==0 then return end
	SoundScale=BasicPlayer.CalcAttenuation(self,SoundScale)
	if SoundScale>0 then
		if NewToneChatter then
			BasicPlayer.SayWord(self,SoundHandle,0,nil,nil,nil,SoundScale)
		else
			self:PlaySound(SoundHandle,SoundScale)
		end
	end
end

--
function BasicPlayer:PlayOneSound(soundList,chance,SoundEvent,OnHead,NewToneChatter,StopPrevSounds,ItPainSound,ItDeathSound) -- В основном звучат звуки из sound_tables.lua. Ранения, падения...
	if Hud and Hud.SharedSoundScale==0 then return end
	local randnum=random(1,100)
	if randnum<chance and soundList then
		local nsounds=getn(soundList)
		if nsounds<=0 then return nil end
		local sounddesc=soundList[random(1,nsounds)]
		-- do this to try ro avoid repeating the same sound
		if sounddesc[6] then
			if _time - sounddesc[6]<2 then
				sounddesc=soundList[random(1,nsounds)]
				if sounddesc[6] then
					if _time - sounddesc[6]<2 then
						sounddesc=soundList[random(1,nsounds)]
					end
				end
			end
		end
		if self.HelicopterIs then -- Тоже самое и для машины сделать.
			-- Hud:AddMessage(self:GetName()..": self.HelicopterIs")
			sounddesc[3]=100 -- Громкость.
			-- sounddesc[4]=5 -- Минимальное растояние.
		end
		self.lastsoundplayed=Sound:Load3DSound(sounddesc[1],sounddesc[2],sounddesc[3],sounddesc[4],sounddesc[5])
		if self.lastsoundplayed then
			if SoundEvent then
				local SoundEventRadius=(sounddesc[4]+sounddesc[5])/2
				local Pos
				if OnHead then
					Pos = self:GetBonePos("Bip01 Head")
				else
					Pos = self:GetPos()
				end
				AI:SoundEvent(self.id,Pos,SoundEventRadius,0,1,self.id)
				-- Hud:AddMessage(self:GetName()..": PlaySound: "..sounddesc[1]..", SoundEventRadius: "..SoundEventRadius)
				-- System:Log(self:GetName()..": PlaySound: "..sounddesc[1]..", SoundEventRadius: "..SoundEventRadius)
			end
			if NewToneChatter then -- То, что звучит голосом когда больно или когда рычат мутанты.
				BasicPlayer.SayWord(self,self.lastsoundplayed,sounddesc[2],sounddesc[3],sounddesc[4],sounddesc[5],1,StopPrevSounds,ItPainSound,ItDeathSound)
			else
				self:PlaySound(self.lastsoundplayed,1)
			end
			sounddesc[6] = _time
		end
		return self.lastsoundplayed
		--BasicPlayer.PlaySoundEx(self,sound)
	end
end

--
function BasicPlayer:SetDeathImpulse(hit)
	self.deathImpuls.x = hit.dir.x
	self.deathImpuls.y = hit.dir.y
	self.deathImpuls.z = hit.dir.z
	self.HeadShot = nil
	--printf(">>>>> %.2f",hit.impact_force_mul_final)
	if (hit.impact_force_mul_final) then
		self.deathImpuls.x = self.deathImpuls.x*hit.impact_force_mul_final
		self.deathImpuls.y = self.deathImpuls.y*hit.impact_force_mul_final
		self.deathImpuls.z = self.deathImpuls.z*hit.impact_force_mul_final
		if (hit.target_material and ((hit.target_material.type=="head") or (hit.target_material.type=="leg"))) then
		-- if (hit.target_material and hit.target_material.type=="leg") then
			self.deathImpulseTorso = 0
		else
			-- [marco] check if this was an headshot,to reward the player afterwards
			if (hit.target_material and hit.target_material.type=="head") then
				self.HeadShot = 1
			end
			if (not hit.impact_force_mul_final_torso) then
				hit.impact_force_mul_final_torso  = 0
			end
			self.deathImpulseTorso = hit.impact_force_mul_final_torso
			if (hit.impact_force_mul_final_torso>0) then
				self.deathImpuls.x = self.deathImpuls.x*2
				self.deathImpuls.y = self.deathImpuls.y*2
				self.deathImpuls.z = self.deathImpuls.z*2
			end
		end
	end
	if (hit.pos) then-- hit was in some point
		self.deathPoint.x = hit.pos.x
		self.deathPoint.y = hit.pos.y
		self.deathPoint.z = hit.pos.z
		self.deathImpulsePart = hit.ipart
		self.shooter=hit.shooter
	else-- just damage (fall)
		self.deathPoint.x = 0
		self.deathPoint.y = 0
		self.deathPoint.z = 0
		self.deathImpulsePart = 0
		self.shooter=nil
	end
end

function BasicPlayer:Server_OnDamage(hit)
	BasicPlayer.SetDeathImpulse(self,hit)
	if hit.damage_type=="normal" or hit.explosion or hit.damage_type=="healthonly" then
		GameRules:OnDamage(hit)
	end
	-- don't process building damage done on players at all
	if (hit.damage_type and hit.damage_type=="building") then
		return
	end
	if (self.cnt.health~=0 and (not hit.explosion)) then
		-- don't need this anymore - always appaly hit impuls
		--if (self.bNoImpulseOnDamage) then return end
		if (hit.ipart) then
			local skeleton_impulse_scale = 1
			if (self.BulletImpactParams.bone_impulse_scale) then
				local bonename = self:GetBoneNameFromTable(hit.ipart)
				for idx=1,getn(self.BulletImpactParams.bone_impulse_scale),2 do
					if (bonename==self.BulletImpactParams.bone_impulse_scale[idx]) then
						skeleton_impulse_scale = self.BulletImpactParams.bone_impulse_scale[idx+1]
						break
					end
				end
			end
			if (self.BulletImpactParams and self.BulletImpactParams.impulse_scale) then
			skeleton_impulse_scale = skeleton_impulse_scale*self.BulletImpactParams.impulse_scale
			end
			self:AddImpulse(hit.ipart,hit.pos,hit.dir,hit.impact_force_mul,skeleton_impulse_scale)
			--System:Log("self:AddImpulse(hit.ipart,hit.pos,hit.dir,"..hit.impact_force_mul..")")
		else
			--System:Log("self:AddImpulse(-1,hit.pos,hit.dir,"..hit.impact_force_mul..")")
			self:AddImpulse(-1,hit.pos,hit.dir,hit.impact_force_mul)
		end
	end
end

function BasicPlayer:Server_OnDamageDead(hit)
	if (Game:IsMultiplayer()) then return end
	self.ReceivedDamage=1
	if (hit.ipart and (not hit.explosion)) then
		self:AddImpulse(hit.ipart,hit.pos,hit.dir,hit.impact_force_mul)
	else
		self:AddImpulse(-1,hit.pos,hit.dir,hit.impact_force_mul)
	end
end

function BasicPlayer:Client_OnDamage(hit)
	--System:Log("client damage "..hit.damage)
	--System:Log("melee damage type "..Hud.meleeDamageType)

	--System.LogToConsole("client damage "..hit.weapon_death_anim_id)
	--System.LogToConsole("deathImp "..hit.dir.x.." "..hit.dir.y.." "..hit.dir.z)

	--if (type(hit)=="table") then
	--System:Log("It was tableHit!")
	--else
	--System:Log("It was valueHit!  "..hit)
	--do return end
	--end

	-- don't process building damage done on players at all
	if (hit.damage_type and hit.damage_type=="building") then
		return
	end

	--dont play client side damage effect if the explosion is not really damaging the player.
	if (hit.explosion) then
		local expl = self:IsAffectedByExplosion()
		if (expl<=0) then
			--Hud:AddMessage(self:GetName().." skip pain sounds because not affected by explosion")
			return
		end
	end

	BasicPlayer.SetDeathImpulse(self,hit)
	--no pain animations now - use physics
	BasicPlayer.PlayPainAnimation(self,hit)

	if (self==_localplayer) then -- localplayer onscreen fx's
		local ShakeAxis = self.cnt:CalcDmgShakeAxis(hit.dir)
		if (ShakeAxis) then
			if (ShakeAxis.y < -.5) then Hud.dmgindicator = bor(Hud.dmgindicator,1) end
			if (ShakeAxis.y > .5) then Hud.dmgindicator = bor(Hud.dmgindicator,2) end
			if (ShakeAxis.x < -.5) then Hud.dmgindicator = bor(Hud.dmgindicator,4) end
			if (ShakeAxis.x > .5) then Hud.dmgindicator = bor(Hud.dmgindicator,8) end

			-- tiago: i've decreased shake amount to half..
			--local ShakeAmount = hit.damage * .05

			--filippo: cap shake between 0-13 (0 = 0 damage,13 = 100 damage)
			local ShakeAmount = min(hit.damage,100)
			ShakeAmount = ShakeAmount/100*13
			--Hud:AddMessage(hit.damage..","..ShakeAmount)

			if (ShakeAmount > 45) then ShakeAmount = 45  end
			if (random(1,100)<50) then
				ShakeAmount = -ShakeAmount
			end
			self.cnt:ShakeCamera(ShakeAxis,ShakeAmount,2,.33)
		end
		-- [tiago]handle diferent screen damage fx's..
		-- fix,since player continues to get damage after dead make sure no screen fx
		if (hit.damage>0 and self.cnt.health > 0) then
			-- override previous hit damage indicators
			if (hit.falling) then
				Hud.dmgindicator = bor(Hud.dmgindicator,16)
			end
			if (hit.explosion) then
				Hud:OnMiscDamage(hit.damage/5)
				Hud:SetScreenDamageColor(.25,0,0)
			elseif (hit.drowning) then
				Hud:OnMiscDamage(hit.damage)
				Hud:SetScreenDamageColor(.6,.7,.9)
			elseif (hit.fire) then
				Hud:OnMiscDamage(hit.damage*10)
				Hud:SetScreenDamageColor(.9,.8,.8)
			elseif (Hud.meleeDamageType=="MeleeDamageNormal") then
				Hud.meleeDamageType=nil
				Hud:OnMiscDamage(hit.damage)
				Hud:SetScreenDamageColor(.9,.8,.8)
			elseif (Hud.meleeDamageType=="MeleeDamageGas") then
				Hud.meleeDamageType=nil
				Hud:OnMiscDamage(hit.damage)
				Hud:SetScreenDamageColor(0,.4,.1)
			elseif hit.target_material and hit.target_material.type=="head" and hit.shooter and hit.shooter.fireparams
			and hit.shooter.fireparams.fire_mode_type==FireMode_Melee then -- Доработать.
				Hud:OnMiscDamage(hit.damage)
				Hud:SetScreenDamageColor(1,1,1)
				-- Hud:AddMessage(self:GetName()..": HEAD!")
			else
				Hud:OnMiscDamage(hit.damage/30)
				Hud:SetScreenDamageColor(.9,.8,.8)
			end
		end
	end
end

function BasicPlayer:DoStepSound()
	local pos=self:GetPos()
	local normal = g_Vectors.up
	self.LastMaterial=self.cnt:GetTreadedOnMaterial()

	if (self.LastMaterial) then -- Возможно ли просто self.LastMaterial? Проверить!
		 if ((_time-self.LastFootStepTime)<.20) then return end
		 local doSoundEvent = 0
		 if (Game:IsMultiplayer() and (self~=_localplayer)) then doSoundEvent = 1  end
		 self.LastFootStepTime=_time
		--if its an AI that use a custom step sound return,because we already play the sound into "DoCustomStep" function.
		if (self.ai and BasicAI.DoCustomStep(self,self.LastMaterial,pos)) then return end
		if (not Game:IsPointInWater(pos)) then-- player feet not under water
			local SoundTable=self.LastMaterial.player_walk
			local SoundScale=BasicPlayer.soundScale.walk
			local EventScale = BasicPlayer.soundEventRadius.walk
			if (self.cnt.running) then
				--AI.SoundEvent(self.id,pos,BasicPlayer.soundRadius.run,0,1,self.id)
				SoundTable=self.LastMaterial.player_run
				SoundScale=BasicPlayer.soundScale.run
				EventScale = BasicPlayer.soundEventRadius.run
			elseif (self.cnt.crouching) then
				--AI.SoundEvent(self.id,pos,BasicPlayer.soundRadius.crouch,0,1,self.id)
				SoundTable=self.LastMaterial.player_crouch
				SoundScale=BasicPlayer.soundScale.crouch
				EventScale = BasicPlayer.soundEventRadius.crouch
			elseif (self.cnt.proning) then
				--AI.SoundEvent(self.id,pos,BasicPlayer.soundRadius.prone,0,1,self.id)
				SoundTable=self.LastMaterial.player_prone
				SoundScale=BasicPlayer.soundScale.prone
				EventScale = BasicPlayer.soundEventRadius.prone
			-- else
				--AI.SoundEvent(self.id,pos,BasicPlayer.soundRadius.walk,0,1,self.id)
				--SoundScale=BasicPlayer.soundScale.walk
			end
			if (SoundTable) then
				ExecuteMaterial(pos,normal,SoundTable,1,nil,nil,self.cnt)
				if (doSoundEvent==1 and EventScale > 0) then
					-- Показывать звуковое событие на радаре.
					Game:SoundEvent(pos,EventScale,1,self.id)
				end
			end
			--System:Log("FOOTSTEP")
			-- lets play random equipment sounds if available
			if (self.EquipmentSoundProbability and self.EquipmentSounds) then
				local EquipmentSounds=getn(self.EquipmentSounds)
				if ((EquipmentSounds>0) and (random(1,100)<=self.EquipmentSoundProbability)) then
					local EquipmentSound=self.EquipmentSounds[random(1,EquipmentSounds)]
					--Sound:SetSoundPosition(EquipmentSound,pos)
					BasicPlayer.PlaySoundEx(self,EquipmentSound,SoundScale)
				end
			end
		else
			if ((self.Diving and self.Diving==0) or (self.Diving==nil)) then
				ExecuteMaterial(pos,normal,self.LastMaterial.player_walk_inwater,1,nil,nil,self.cnt)
				if (doSoundEvent==1 and BasicPlayer.soundEventRadius.walk > 0) then
					-- to show it on the radar
					Game:SoundEvent(pos,BasicPlayer.soundEventRadius.walk,1,self.id)
				end
			end
			--System:Log("\001 WATER FOOTSTEP")
		end
	-- else
		--System:Log("BasicPlayer:DoStepSound() nil material")
		--if (self.cnt.flying) then
		--System:Log("\001 BasicPlayer:DoStepSound() nil material")
		--end
	end
end

function BasicPlayer:DoBushSound()
	--do return end-- [lennert] this will execute footsteps twice in indoors !
	--local pos=self:GetPos()
	--local normal = g_Vectors.up
	--local materialSoft=self.cnt:GetTouchedMaterial()

	-- the following expression comment out all code between [[and]]
	bush_thing=[[
	if (materialSoft) then
		self.BushInCounter = self.BushInCounter + 1
		if (self.InWater==0) then
			local soundScale = self.BushInCounter/self.BushSoundScale
			if (soundScale > 1) then
				soundScale = 1
			end
			--System:Log(" bush soundScale "..soundScale)
			if (self.cnt.running) then
				ExecuteMaterial(pos,normal,materialSoft.player_walk,BasicPlayer.soundScale.run*soundScale)
			elseif (self.cnt.crouching) then
				ExecuteMaterial(pos,normal,materialSoft.player_walk,BasicPlayer.soundScale.crouch*soundScale)
			elseif (self.cnt.proning) then
				ExecuteMaterial(pos,normal,materialSoft.player_walk,BasicPlayer.soundScale.prone*soundScale)
			else
				ExecuteMaterial(pos,normal,materialSoft.player_walk,BasicPlayer.soundScale.walk*soundScale)
			end
		end
	else
		self.BushInCounter = 0
	end
	]]

	local pos=self:GetPos()
	local normal = g_Vectors.up
	local materialSoft=self.cnt:GetTouchedMaterial()

	if (materialSoft) then
		if (self.InWater==0) then
			if (self.cnt.running) then
				ExecuteMaterial(pos,normal,materialSoft.player_walk_by,1,nil,nil,self.cnt)
			elseif (self.cnt.crouching) then
				ExecuteMaterial(pos,normal,materialSoft.player_walk_by,1,nil,nil,self.cnt)
			elseif (self.cnt.proning) then
				ExecuteMaterial(pos,normal,materialSoft.player_walk_by,1,nil,nil,self.cnt)
			else
				ExecuteMaterial(pos,normal,materialSoft.player_walk_by,1,nil,nil,self.cnt)
			end
		end
	end
	--self.bushSndTime = .7
end

function BasicPlayer:DoStepSoundAI()
	-- no footstep sound when in stealth mode
	local material=self.cnt:GetTreadedOnMaterial()
	--[filippo]
	local soundradius=0
	local playervelocity = self:GetVelocity()
	local velocitymodule = sqrt(playervelocity.x*playervelocity.x+playervelocity.y*playervelocity.y+playervelocity.z*playervelocity.z)
	if (material) then
		self.BushInCounterAI = self.BushInCounterAI + 1
		local soundScale = self.BushInCounterAI/self.BushSoundScaleAI
		if (soundScale > 1) then
			soundScale = 1
		end
		local pos=self:GetPos()
		-- if (self.InWater==0) then
		if (self.cnt.running) then
			--[filippo]
			--to get if the player is sprint I check the average value between running speed and sprint speed,
			--this because there could be problem near values around "self.move_params.speed_run"
			--local sprintbias = (self.move_params.speed_run*self.StaminaTable.sprintScale-self.move_params.speed_run)*.5
			local sprintbias=6
			if self.move_params then
				sprintbias = self.move_params.speed_run+(self.move_params.speed_run*self.StaminaTable.sprintScale-self.move_params.speed_run)*.5
			end
			if (velocitymodule>sprintbias) then --player is sprinting
				soundradius = BasicPlayer.soundRadius.sprint*soundScale
			else
				soundradius = BasicPlayer.soundRadius.run*soundScale
			end
		elseif (self.cnt.crouching) then
			--[filippo]
			soundradius = BasicPlayer.soundRadius.crouch*soundScale
		elseif (self.cnt.proning) then
			--[filippo]
			soundradius = BasicPlayer.soundRadius.prone*soundScale
		else
			--[filippo]
			soundradius = BasicPlayer.soundRadius.walk*soundScale
		end
		--[filippo]
		AI:SoundEvent(self.id,pos,soundradius,0,1,self.id)
	else
		self.BushInCounterAI = 0
	end
end

function BasicPlayer:DoBushSoundAI()
	local stats = self.cnt
	-- no footstep sound when in stealth mode
	local materialSoft=stats:GetTouchedMaterial()
	if (materialSoft) then
		local pos=self:GetPos()
		if (stats.running) then
			AI:SoundEvent(self.id,pos,BasicPlayer.soundRadius.run,0,1,self.id)
		elseif (stats.crouching) then
			AI:SoundEvent(self.id,pos,BasicPlayer.soundRadius.crouch,0,1,self.id)
		elseif (stats.proning) then
			AI:SoundEvent(self.id,pos,BasicPlayer.soundRadius.prone,0,1,self.id)
		else
			AI:SoundEvent(self.id,pos,BasicPlayer.soundRadius.walk,0,1,self.id)
		end
	end
	--self.bushSndTimeAI = .7
end

function BasicPlayer:DoLandSound()
	--if (self.cnt.doLandSound==1) then
	local pos=self:GetPos()
	local normal = g_Vectors.up
	local material=self.cnt:GetTreadedOnMaterial()
	if (material) then
		if (Game:IsPointInWater(self:GetPos())~=nil) then-- player feet under water
			ExecuteMaterial(pos,normal,material.player_walk_inwater,1)
		else
			ExecuteMaterial(pos,normal,material.player_walk,1)
		end
	end
	if (Game:IsMultiplayer() and (self~=_localplayer)) then
		Game:SoundEvent(pos,BasicPlayer.soundEventRadius.jump,1,self.id)
	end
	--end
	--self.cnt.doLandSound = 0
end

function BasicPlayer:UpdateInWaterSplash()
	if (self~=_localplayer) then
		return
	end
	if (Game:IsPointInWater(self:GetPos())~=nil) then-- player feet under water
		Sound:SetGroupScale(SOUNDSCALE_UNDERWATER,1)
		local vCamPos = self:GetCameraPosition()
		local bIsCameraUnderwater = Game:IsPointInWater(vCamPos)
		self.InWater = 1
		-- If player is partialy in water,play swim/splash sounds do particles
		if (bIsCameraUnderwater==nil) then-- partially under water
			--r_WaterRefractions=0
			-- stop underwater sound
			if (self.sndUnderwaterNoise and Sound:IsPlaying(self.sndUnderwaterNoise)) then
				Sound:StopSound(self.sndUnderwaterNoise)
			end
			if (Sound:IsPlaying(self.sndUnderWaterSwim)) then
				Sound:StopSound(self.sndUnderWaterSwim)
			end
			if (self.Diving and self.Diving~=0) then
				if (self.cnt.stamina > .12) then
					self.rebreath_snd=self.sndBreathIn[1]
				else
					self.rebreath_snd=self.sndBreathIn[2]
				end
				Sound:PlaySound(self.rebreath_snd)
			end
			self.Diving=0
			if (not self.cnt.moving) then
				return
			end
			--if (self.LastMaterial==nil) then
			if (self.cnt:IsSwimming()) then
				--System:Log("\001")
				if ((self.SwimSound==nil) or (not Sound:IsPlaying(self.SwimSound))) then
					--local iSoundIdx = random(1,getn(BasicPlayer.sndWaterSwim))
					--self.SwimSound = BasicPlayer.sndWaterSwim[iSoundIdx]
					self.SwimSound = BasicPlayer.sndWaterSwim
					if (self.SwimSound) then
						Sound:SetSoundLoop(self.SwimSound,1)
						Sound:PlaySound(self.SwimSound)
					end
				end
			else
				if ((self.SwimSound) and (Sound:IsPlaying(self.SwimSound)==1)) then
					Sound:StopSound(self.SwimSound)
					self.SwimSound=nil
				end
			end
			-- Spawn ripples if player enters water
			if (iLastWaterSurfaceParticleSpawnedTime==nil) then
				self.iLastWaterSurfaceParticleSpawnedTime = _time
			end
			if (_time - self.iLastWaterSurfaceParticleSpawnedTime > .2) then
				local vVec = self:GetPos()
				vVec.z = Game:GetWaterHeight() + .02
				vVec.x = vVec.x + .25 - random(1,100) / 200
				vVec.y = vVec.y + .25 - random(1,100) / 200
				Particle:CreateParticle(vVec,g_Vectors.up,BasicPlayer.WaterRipples)
				self.iLastWaterSurfaceParticleSpawnedTime = _time
			end
		else	-- fully under water
			Sound:SetGroupScale(SOUNDSCALE_UNDERWATER,0)
			self.Diving=1
			-- If player is under water,play random under-water noises and stop
			-- the swim/splash sounds
			if ((self.SwimSound) and (Sound:IsPlaying(self.SwimSound)==1)) then
				Sound:StopSound(self.SwimSound)
				self.SwimSound=nil
			end
			-- MIXER: Fix stop rebreath sounds
			if (self.rebreath_snd) and (Sound:IsPlaying(self.rebreath_snd)) then
				Sound:StopSound(self.rebreath_snd) self.rebreath_snd=nil
			end
			if ((Sound:IsPlaying(self.sndUnderwaterNoise)~=1)) then
				Sound:SetSoundLoop(self.sndUnderwaterNoise,1)
				Sound:PlaySound(self.sndUnderwaterNoise)
			end
			-- if moving - play underwaterSwim sound
			if (self.cnt.moving) then
				if (not Sound:IsPlaying(self.sndUnderWaterSwim)) then
					Sound:SetSoundLoop(self.sndUnderWaterSwim,1)
					Sound:PlaySound(self.sndUnderWaterSwim)
				end
			elseif (Sound:IsPlaying(self.sndUnderWaterSwim)) then
				Sound:StopSound(self.sndUnderWaterSwim)
			end
		end
	else -- not in water at all
		Sound:SetGroupScale(SOUNDSCALE_UNDERWATER,1)
		self.InWater = 0
		self.Diving=0
		if ((self.SwimSound) and (Sound:IsPlaying(self.SwimSound)==1)) then
			Sound:StopSound(self.SwimSound)
			self.SwimSound=nil
		end
		if ((self.sndUnderwaterNoise) and (Sound:IsPlaying(self.sndUnderwaterNoise)==1)) then
			Sound:StopSound(self.sndUnderwaterNoise)
		end
		if (self.sndUnderWaterSwim and Sound:IsPlaying(self.sndUnderWaterSwim)) then
			Sound:StopSound(self.sndUnderWaterSwim)
		end
	end
end

function BasicPlayer:Reload()
	local stats = self.cnt
	local CurWeaponInfo = self.weapon_info
	local CurWeapon = stats.weapon
	if (stats.weapon) then
		if (self.ai) then
			-- Если осталась половина боезапаса в обойме, то не перезаряжать.
			if (stats.ammo_in_clip > self.fireparams.bullets_per_clip/2) and not self.ForceReload then
				do return end
			end
			-- System:Log(self:GetName()..": PRE RELOAD")
		end
		BasicWeapon.Server.Reload(CurWeapon,self)
		BasicWeapon.Client.Reload(CurWeapon,self)
		stats.weapon_busy=CurWeapon.FireParams[CurWeaponInfo.FireMode+1].reload_time
	end
end

function BasicPlayer:OnLoad(stm)
	-- System:Log(self:GetName()..": OnLoad")
	self.cnt.ammo = 0
	self.cnt.ammo_in_clip = 0
	local mutated = stm:ReadBool()
	if (mutated) then
		self.iPlayerEffect = 6
	end
	self.cnt.has_binoculars = stm:ReadBool()
	self.cnt.has_flashlight = stm:ReadBool()
	self.Energy=stm:ReadInt()
	self.MaxEnergy=stm:ReadInt()
	self.Refractive=stm:ReadBool()
	self.WasInCombat=stm:ReadBool()
	-- self.ShowOnRadar=stm:ReadBool()
	self.ShowOnRadar=stm:ReadInt()
	if self.ShowOnRadar > 4 then -- Когда сохранялась пустая переменная после загрузки появилось вот это: 1630468.
		self.ShowOnRadar = nil
	end
	-- self.ShowOnRadar=stm:ReadFloat()
	self.MyToneOfVoice=stm:ReadInt()
	self.bEnemyInCombat=stm:ReadBool()
	if self.Properties.bMayBeInvisible then
		self.OnInitMayBeInvisible=stm:ReadInt()
		-- System:Log(self:GetName()..": BP Read: "..self.OnInitMayBeInvisible)
	end
	self.IsInvisible=stm:ReadBool()
	if self.IsInvisible and self.GoRefractive then
		self:GoRefractive()
		-- System:Log(self:GetName()..": BP self:GoRefractive()")
	end

	local count=stm:ReadInt()
	if (count > 0) then
		-- Mixer: next line prevents weapon activation sound from
		-- being played after load (see BasicWeapon.lua also)
		self.cis_svgload = 1
	end
	while(count>0) do
		local weaponName = stm:ReadString()
		local idx = stm:ReadInt()
		System:Log("LOADING "..idx)
		local t=ReadFromStream(stm)
		local fm=stm:ReadInt()
		if (self.WeaponState[idx]==nil) then
			-- init the weapon
			BasicPlayer.ScriptInitWeapon(self,weaponName)
		end
		if (self.WeaponState[idx]) then
			self.WeaponState[idx].AmmoInClip=t
			self.WeaponState[idx].FireMode=fm
		else
			System:Log("WARNING WEAPON STATE NOT FOUND ")
		end
		count=count-1
	end
	self.Ammo=ReadFromStream(stm)
	--local third_person_v=stm:ReadInt()
	--System:Log("\001 loading >>>  third_person_v "..third_person_v)
	--- restoring camera mode
	--if (third_person_v==1) then
	--Game:SetThirdPerson(1)
	--end
	BasicPlayer.fBodyHeat=1
end


-- this makes sure that all cached ammo values of currently active weapons/grenades are
-- written back to the respective stores (Ammo and AmmoInClip in the weaponstate)
function BasicPlayer:SyncCachedAmmoValues()
	if self.cnt.weapon and self.fireparams then
		self.Ammo[self.fireparams.AmmoType]=self.cnt.ammo
		local weaponState = GetPlayerWeaponInfo(self)
		if weaponState then
			weaponState.AmmoInClip[self.firemodenum]=self.cnt.ammo_in_clip
		end
	end
	-- make sure grenade ammo is up-to-date
	self.Ammo[GrenadesClasses[self.cnt.grenadetype]]=self.cnt.numofgrenades
end

function BasicPlayer:OnSave(stm)
	-- System:Log(self:GetName()..": OnSave")
	BasicPlayer.SyncCachedAmmoValues(self)
	-- is the player mutated?
	stm:WriteBool(self.iPlayerEffect and self.iPlayerEffect==6)
	stm:WriteBool(self.cnt.has_binoculars)
	stm:WriteBool(self.cnt.has_flashlight)
	stm:WriteInt(self.Energy)
	stm:WriteInt(self.MaxEnergy)
	stm:WriteBool(self.Refractive)
	stm:WriteBool(self.WasInCombat)
	-- stm:WriteBool(self.ShowOnRadar)
	stm:WriteInt(self.ShowOnRadar)
	stm:WriteInt(self.MyToneOfVoice)
	-- stm:WriteFloat(self.ShowOnRadar)
	stm:WriteBool(self.bEnemyInCombat)
	if self.Properties.bMayBeInvisible then
		if not self.OnInitMayBeInvisible then
			local MayBeInvisible = tonumber(getglobal("game_PredatorsMayBeInvisible"))
			if MayBeInvisible then self.OnInitMayBeInvisible = MayBeInvisible end
			-- System:Log(self:GetName()..": BP MayBeInvisible: "..MayBeInvisible)
		end
		if not self.OnInitMayBeInvisible then
			-- System:Log(self:GetName()..": BP self.OnInitMayBeInvisible = -1")
			self.OnInitMayBeInvisible = -1
			stm:WriteInt(self.OnInitMayBeInvisible)
			self.OnInitMayBeInvisible = nil
		else
			-- System:Log(self:GetName()..": BP WriteInt: "..self.OnInitMayBeInvisible)
			stm:WriteInt(self.OnInitMayBeInvisible)
		end
	end
	stm:WriteBool(self.IsInvisible)

	local nentries=0
	for i,val in self.WeaponState do
		if (type(i)=="number" and type(val.AmmoInClip)=="table") then nentries=nentries+1  end
	end
	stm:WriteInt(nentries)
	for i,val in self.WeaponState do
		if (type(i)=="number" and type(val.AmmoInClip)=="table") then
		--System:Log("SAVING "..i)
		stm:WriteString(val.Name)
		stm:WriteInt(i)
		WriteToStream(stm,val.AmmoInClip)
		stm:WriteInt(val.FireMode)
		end
	end
	WriteToStream(stm,self.Ammo)

	-- saving camera mode
	--if (not self.cnt.first_person) then
	--else
	--end
	--
	--if (self.cnt.first_person==nil and self==_localplayer) then
	--stm:WriteInt(1)
	--else
	--stm:WriteInt(0)
	--end
end


----------------------------------------------------------------------
function BasicPlayer:ProcessCommand(Params)
	local Sender = System:GetEntity(Params.Sender)
	-- SAY
	if (Params.CommandID==CMD_GO) then
		Game:ShowIngameDialog(-1,"","",12,"A new command has been received: $4Go to the location marked on your map !",10)
		Game:SetNavPoint("Go",Params.Target)
	elseif (Params.CommandID==CMD_ATTACK) then
		Game:ShowIngameDialog(-1,"","",12,"A new command has been received: $4Attack the location marked on your map !",10)
		Game:SetNavPoint("Attack",Params.Target)
	elseif (Params.CommandID==CMD_DEFEND) then
		Game:ShowIngameDialog(-1,"","",12,"A new command has been received: $4Defend the location marked on your map !",10)
		Game:SetNavPoint("Defend",Params.Target)
	elseif (Params.CommandID==CMD_COVER) then
		Game:ShowIngameDialog(-1,"","",12,"A new command has been received: $4Cover the location marked on your map !",10)
		Game:SetNavPoint("Cover",Params.Target)
	elseif (Params.CommandID==CMD_BARRAGEFIRE) then
		Game:ShowIngameDialog(-1,"","",12,"A new command has been received: $4Barrage Fire at the location marked on your map !",10)
		Game:SetNavPoint("Barrage Fire",Params.Target)
	end
end

Server_SpawnGrenadeCallback =
{
	OnEvent = function(self,event,Params)
		local player = Params.player
		if not player or not player.cnt then
		-- Hud:AddMessage("SpawnGrenadeCallback return")
		do return end end -- Чтобы player.cnt не выдавало nil.
		if player.abortGrenadeThrow then player.abortGrenadeThrow = nil return end
		-- if player.grenade_ready_time and player.grenade_ready_time>_time then return end -- Зачем?
		-- Lets just assume we are supposed to throw a grenade
		local Grenade = Server:SpawnEntity(GrenadesClasses[player.cnt.grenadetype])
		if not (player.cnt.grenadetype==1) then
			player.cnt.numofgrenades = player.cnt.numofgrenades-1
		end
		player.cnt:GetFirePosAngles(Params.pos,Params.angles,Params.dir)
		--grenade should spawn a bit forward than the player eye pos,this to prevent problems with the leaning for example.
		local testpos = g_Vectors.temp_v1
		CopyVector(testpos,Params.pos)
		local pos = Params.pos
		local dir = Params.dir
		testpos.x = testpos.x + dir.x * .5
		testpos.y = testpos.y + dir.y * .5
		testpos.z = testpos.z + dir.z * .5
		--test the shifted position,if its safe,use it.
		hits = System:RayWorldIntersection(pos,testpos,1,ent_static+ent_sleeping_rigid+ent_rigid+ent_independent+ent_terrain,self.id,Grenade.id)
		if getn(hits)==0 then
			CopyVector(Params.pos,testpos)
		end
		--projectiles (grenades,for ex) should inherit player's velocity
		--it's calculated in C code,here we should get the correct velocity already
		-- Hud:AddMessage(player:GetName()..": BasicPlayer/SpawnGrenade")
		-- System:Log(player:GetName()..": BasicPlayer/SpawnGrenade")
		Grenade:Launch(player.cnt.weapon,player,Params.pos,Params.angles,Params.dir,Params.lifetime)
		-- player.grenade_ready_time = _time + 1.3
	end
}

function BasicPlayer:Server_OnFireGrenade(Params)
	local stats = self.cnt
	-- if ((type(Params)=="table" and Params.underwater) or stats:IsSwimming() or stats.reloading) then return end
	-- if (type(Params)=="table" and Params.underwater and not self.IsIndoor) or stats.reloading then
	if type(Params)=="table" and Params.underwater and stats.underwater>0 and not self.IsIndoor then -- На перезарядку незачем проверять, анимация бросания гранаты идёт, а гранаты бывает раз, и нет...
	-- Hud:AddMessage(self:GetName()..": 1 Server_OnFireGrenade return")
	return end -- Оказывается, нельзя было бросать гранаты, если подземнное помещение находится ниже уровня воды.
	if self.abortGrenadeThrow then self.abortGrenadeThrow = nil	end
	if stats.grenadetype==1 or stats.numofgrenades>0 then
		if stats:IsSwimming() then
			stats.weapon_busy = 5
		else
			stats.weapon_busy = 1.1
		end
	else
		System:Log("WARNING self.cnt.numofgrenades<0 this shouldn't happen")
	end
	if ClientStuff.vlayers:IsActive("Binoculars") then ClientStuff.vlayers:DeactivateLayer("Binoculars") end
	local ThrowParams = new(Params)
	ThrowParams.player = self
	-- Hud:AddMessage(self:GetName()..": Server_OnFireGrenade: "..ThrowParams.player:GetName())
	Game:SetTimer(Server_SpawnGrenadeCallback,12 * (1000/30),ThrowParams)
end

function BasicPlayer:Client_OnFireGrenade(Params)
	local stats = self.cnt
	-- if ((type(Params)=="table" and Params.underwater) or stats:IsSwimming() or stats.reloading) then return end
	-- if (type(Params)=="table" and Params.underwater and not self.IsIndoor) or stats.reloading then
	if type(Params)=="table"and Params.underwater and stats.underwater>0 and not self.IsIndoor then
	-- Hud:AddMessage(self:GetName()..": 1 Client_OnFireGrenade return")
	return end
	if not (stats.grenadetype==1) and not (stats.numofgrenades>0) then
	-- Hud:AddMessage(self:GetName()..": 2 Client_OnFireGrenade return")
	do return end end
	-- if self==_localplayer and stats.weapon then
	if self==_localplayer and stats.weapon then -- Это моя личная анимация, то есть запускаю её только я.
		BasicWeapon.Client.OnStopFiring(stats.weapon,self)
		-- stats.weapon:StartAnimation(0,"Grenade1"..self.weapon_info.FireMode+1,0,0)
		stats.weapon:StartAnimation(0,"Grenade11",0,0)
	end
	if stats:IsSwimming() then
		stats.weapon_busy = 5
	else
		stats.weapon_busy = 1.1
	end
end

function BasicPlayer:IsDrowning()
	local stats = self.cnt
	--filippo,the drowning check didnt count if the player is underwater or not,this caused drowning screen while jumping with low stamina.
	if stats.stamina<=0 and stats.health>0 and stats.underwater>0 then
		local dmgScale = _frametime
		-- let's cap it to prevent lots of damage if frame was long (was loading in this frame)
		if (dmgScale>.03) then dmgScale = .03 end
		return {
			dir = g_Vectors.v001,
			damage = 230*dmgScale,
			target = self,
			shooter = self,
			landed = 1,
			impact_force_mul_final=5,
			impact_force_mul=5,
			damage_type="healthonly",
			--damage_type="drowning", -- Посмотеть чё это из себя представляет. Что-то очень красивое. )
			drowning=1,
		}
	else
		return nil
	end
end

function BasicPlayer:CountWeaponsInSlots(NoMeleeWeapon,NoHands,AllFireModes,NoUnlimited,NoProjectiles)
	local WeaponsSlots = self.cnt:GetWeaponsSlots()
	if not WeaponsSlots then return 0 end
	local WeaponsCount=0
	for i,New_Weapon in WeaponsSlots do
		if New_Weapon~=0 then
			if AllFireModes then
				for n,FireMode in New_Weapon.FireParams do
					local WeaponState = self.WeaponState
					local WeaponInfo = WeaponState[WeaponClassesEx[New_Weapon.name].id]
					local New_AmmoType
					local FireModeParams
					local New_FireModeType -- Режим огня.
					if WeaponInfo then
						FireModeParams = New_Weapon.FireParams[n]
						New_AmmoType = FireModeParams.AmmoType
						New_FireModeType = FireModeParams.fire_mode_type
					end
					WeaponsCount=WeaponsCount+1
					if ((NoMeleeWeapon or (NoHands and New_Weapon.name=="Hands")) and New_FireModeType==FireMode_Melee)
					or (NoUnlimited and New_AmmoType=="Unlimited") or (NoProjectiles and New_FireModeType==FireMode_Projectile
					and New_Weapon.name~="SniperRifle") then
						WeaponsCount=WeaponsCount-1
					end
				end
			else
				local WeaponState = self.WeaponState
				local WeaponInfo = WeaponState[WeaponClassesEx[New_Weapon.name].id]
				local FireModeParams
				local New_FireModeType -- Режим огня.
				if WeaponInfo then
					FireModeParams = New_Weapon.FireParams[WeaponInfo.FireMode+1]
					New_FireModeType = FireModeParams.fire_mode_type
				end
				WeaponsCount=WeaponsCount+1
				if ((NoMeleeWeapon or (NoHands and New_Weapon.name=="Hands")) and New_FireModeType==FireMode_Melee)
					or (NoUnlimited and New_AmmoType=="Unlimited") or (NoProjectiles and New_FireModeType==FireMode_Projectile
					and New_Weapon.name~="SniperRifle") then
					WeaponsCount=WeaponsCount-1
				end
			end
		end
	end
	return WeaponsCount
end

function BasicPlayer:NewCountWeaponsInSlots(NotAllFireModes,NoMeleeCount,NoHandsCount,NoUnlimitedCount,NoProjectilesCount) -- Все параметры кроме первого только для смешанного числа.
	local WeaponsSlots = self.cnt:GetWeaponsSlots()
	if not WeaponsSlots then return 0 end
	local MixedException=0
	local AllWeapons=0
	local NoMelee=0
	local NoHands=0
	local NoUnlimited=0
	local NoProjectiles=0
	for i,New_Weapon in WeaponsSlots do
		if New_Weapon~=0 then
			for n,FireMode in New_Weapon.FireParams do
				if not NotAllFireModes or n==1 then
					local WeaponState = self.WeaponState
					local WeaponInfo = WeaponState[WeaponClassesEx[New_Weapon.name].id]
					local New_AmmoType
					local FireModeParams
					local New_FireModeType -- Режим огня.
					if WeaponInfo then
						FireModeParams = New_Weapon.FireParams[n]
						New_AmmoType = FireModeParams.AmmoType
						New_FireModeType = FireModeParams.fire_mode_type
					end
					MixedException=MixedException+1
					if ((NoMeleeCount or (NoHandsCount and New_Weapon.name=="Hands")) and New_FireModeType==FireMode_Melee)
						or (NoUnlimitedCount and New_AmmoType=="Unlimited") or (NoProjectilesCount and New_FireModeType==FireMode_Projectile
						and New_Weapon.name~="SniperRifle") then
						MixedException=MixedException-1
					end
					AllWeapons=AllWeapons+1
					if New_FireModeType~=FireMode_Melee then
						NoMelee=NoMelee+1
					end
					if New_Weapon.name~="Hands" then
						NoHands=NoHands+1
					end
					if New_AmmoType~="Unlimited" then
						NoUnlimited=NoUnlimited+1
					end
					if New_FireModeType~=FireMode_Projectile or New_Weapon.name=="SniperRifle" then
						NoProjectiles=NoProjectiles+1
					end
				end
			end
		end
	end
	if not NotAllFireModes then NotAllFireModes = 0 end
	-- System:Log(self:GetName()..": TEST me: "..MixedException..", aw: "..AllWeapons..", nm: "..NoMelee..", nh: "..NoHands..", nu: "..NoUnlimited..", np: "..NoProjectiles..", nafm: "..NotAllFireModes)
	return {MixedException=MixedException,AllWeapons=AllWeapons,NoMelee=NoMelee,NoHands=NoHands,NoUnlimited=NoUnlimited,NoProjectiles=NoProjectiles,NotAllFireModes=NotAllFireModes}
end

function BasicPlayer:GetDistanceToTarget(att_target) -- Сделать чтобы возвращало сразу несколько параметров. Сразу Distance и att_target.
	local Attention
	if not att_target then
		att_target = AI:GetAttentionTargetOf(self.id)
		Attention = 1
	end
	local Distance
	-- if att_target and type(att_target)=="table" and att_target.type=="Player" then
	if att_target and (not Attention or (type(att_target)=="table" and att_target.type=="Player")) then
		if self.theVehicle and att_target.GetPos then -- Вот пусть от машины и измеряет, иначе, сидя за пушкой в машине позиция отсчитывается от нулевой точки. (
			Distance = self.theVehicle:GetDistanceFromPoint(att_target:GetPos())
		else
			Distance = self:GetDistanceFromPoint(att_target:GetPos())
		end
		-- System:Log(self:GetName()..": DistanceToTarget: "..Distance)
	end
	return Distance
end

function BasicPlayer:FriendFollow(Enter)
	local Entities
	if GameRules.AllEntities then
		Entities = GameRules.AllEntities -- Все найденные сущности.
	end
	if Entities then
		for i,entity in Entities do
			if entity and entity.type=="Player" and BasicPlayer.IsAlive(entity) then
				if self.Properties.species==entity.Properties.species then
					if self.PropertiesInstance.groupid==entity.PropertiesInstance.groupid then
						if self~=entity then -- Если не сам.
							if entity.IsAiPlayer and self.id==_localplayer.id then -- Если друг игрока и если вызвавший - локальный игрок.
								AI:Signal(0,1,"GO_FOLLOW",entity.id)
								-- Hud:AddMessage(entity:GetName()..": GO_FOLLOW")
								-- System:Log(entity:GetName()..": GO_FOLLOW")
								if self.InElevatorArea then
									if not self.cnt.proning and not self.cnt.crouching then
										entity:InsertSubpipe(0,"setup_stand")
										if self.cnt.running or Enter then -- Если игрок выбежал или забежал в лифт, то и мы бежим, потому что "Все бегут". Enter заменяет Player.InElevatorArea.
											entity:InsertSubpipe(0,"do_it_running")
										else
											entity:InsertSubpipe(0,"do_it_walking")
										end
									elseif self.cnt.proning then
										entity:InsertSubpipe(0,"setup_prone")
										entity:InsertSubpipe(0,"do_it_walking")
									elseif self.cnt.crouching then
										entity:InsertSubpipe(0,"setup_crouch")
										entity:InsertSubpipe(0,"do_it_walking")
									end
								elseif self.AutomaticDoorArea then
									entity:InsertSubpipe(0,"setup_stand")
									if self.cnt.running or Enter then
										entity:InsertSubpipe(0,"do_it_running")
									elseif entity.AutomaticDoorArea then
										entity:InsertSubpipe(0,"do_it_walking")
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

function BasicPlayer:AddHands()
	if self:GetState()~="Alive" or self.theVehicle or self.ANIMAL or (self==_localplayer and System:GetScreenFx("ScreenFade")==1) then return end -- Последнее - про переход на другой уровень.
	local CountWeapons = BasicPlayer.CountWeaponsInSlots(self,nil,1)
	if self.ai and not self.MUTANT and not self.ANIMAL and not self.HaveHands then -- Не знаю, либо сделать постоянную проверку, либо оставить как есть.
		local WeaponsSlots = self.cnt:GetWeaponsSlots()
		if WeaponsSlots then
			for i,New_Weapon in WeaponsSlots do
				if New_Weapon~=0 then
					if New_Weapon.name=="Hands" then
						self.HaveHands = 1
						-- if self==_localplayer then
							-- Hud:AddMessage(self:GetName()..": self.HaveHands")
						-- end
						break
					end
				end
			end
		end
		if not self.HaveHands then
			local CurrentWeaponId = self.cnt:GetCurrWeaponId()
			self.cnt:MakeWeaponAvailable(9,1) -- Возьми себя в руки!
			-- if self==_localplayer then
				-- Hud:AddMessage(self:GetName()..": SetCurrWeapon 1")
			-- end
			self.cnt:SetCurrWeapon(9)
			if CountWeapons>0 then
				-- if self==_localplayer then
					-- Hud:AddMessage(self:GetName()..": SetCurrWeapon 2")
				-- end
				self.cnt:SetCurrWeapon(CurrentWeaponId)
			end
		end
	end
	local SkipHide
	local Weapon = self.cnt.weapon
	if (not Weapon or (CountWeapons==0 and Weapon and Weapon.name~="Hands")) and not self.MUTANT and not self.ANIMAL then -- Это-то и даёт руки когда ничего другого нет.
		self.cnt:MakeWeaponAvailable(9,1)
			-- if self==_localplayer then
				-- Hud:AddMessage(self:GetName()..": SetCurrWeapon 3")
			-- end
		self.cnt:SetCurrWeapon(9)
		SkipHide=1
	end
	if self.ai and Weapon and Weapon.name=="Hands" then
		self.PropertiesInstance.bGunReady = 1
	end
	if self==_localplayer and not SkipHide then
		local WeaponsSlots = self.cnt:GetWeaponsSlots()
		local CurrWeaponId = self.cnt:GetCurrWeaponId()
		local HaveWeapon
		if WeaponsSlots and Weapon then
			for i,New_Weapon in WeaponsSlots do
				if New_Weapon~=0 then
					if WeaponClassesEx[New_Weapon.name].id==WeaponClassesEx[Weapon.name].id then
						HaveWeapon=1
						break
					end
				end
			end
		end
		if not HaveWeapon then -- Убирает оружие, которое отсутствовало и отсутствует в слотах, после выхода из машины или турели, с заходом до этого с руками.
			-- Hud:AddMessage(self:GetName()..": New_Weapon.id: "..CurrWeaponId)
			self.cnt:MakeWeaponAvailable(CurrWeaponId,0)
			self.cnt:MakeWeaponAvailable(9,1)
			-- if self==_localplayer then
				-- Hud:AddMessage(self:GetName()..": SetCurrWeapon 4")
			-- end
			self.cnt:SetCurrWeapon(9)
		end
		-- local Count = 0
		-- if WeaponsSlots and Weapon then
			-- for i,New_Weapon in WeaponsSlots do
				-- if New_Weapon~=0 then
					-- Count=Count+1
					-- if WeaponClassesEx[New_Weapon.name].id==WeaponClassesEx[Weapon.name].id then -- Есть нормальный self.cnt:GetCurrWeaponId()...
						-- -- Hud:AddMessage(self:GetName()..": New_Weapon.id: "..WeaponClassesEx[New_Weapon.name].id)
						-- break
					-- end
				-- end
			-- end
		-- end
		-- if not self.CheckBinding then -- ID!!!
			-- self.CheckBinding = 1 -- Не нужно убирать, вываливается весь список.
			-- for i=0,255 do
				-- local Binding = Input:GetBinding("default",i)
				-- if Binding then
					-- for k,val in Binding do
						-- if val then
							-- System:Log(self:GetName()..": Number: "..i..", Block: "..k..", Binding: "..val.key) -- Чтобы узать на id назначений кнопок.
						-- end
					-- end
				-- end
			-- end
		-- end
		local szKeyName = Input:GetXKeyDownName()
		local KeyPressed
		local KeyId = {22,23,24,25} -- Кнопки выбора слота оружия. Код для того чтобы узнать другие ID выше...
		for j,val in KeyId do
			local Binding = Input:GetBinding("default",val)
			for k,val2 in Binding do
				if val2 and szKeyName==val2.key then
					KeyPressed = 1
				end
			end
		end
		local Complies
		-- local Complies2
		-- if (szKeyName=="1" and Count==1) -- Забить имена из управления.
		-- or (szKeyName=="2" and Count==2)
		-- or (szKeyName=="3" and Count==3)
		-- or (szKeyName=="4" and Count==4) then
		if KeyPressed then
			if not self.DownTime and not self.NotAllowDelay then self.DownTime=_time end
			if _time>self.DownTime+.2 then
				Complies = 1
			end
		else
			if self.DownTime then
				self.DownTime = nil
				self.NotAllowDelay = nil
			end
		end
		-- if szKeyName=="1" or szKeyName=="2" or szKeyName=="3" or szKeyName=="4" then
			-- Complies2=1
		-- end
		-- if Weapon.name~="Hands" and Complies and Complies2 then
		if Weapon.name~="Hands" and Complies then
			-- Hud:AddMessage(self:GetName().."$1: 1")
			self.cnt:MakeWeaponAvailable(9,1)
			-- if self==_localplayer then
				-- Hud:AddMessage(self:GetName()..": SetCurrWeapon 5")
			-- end
			self.cnt:SetCurrWeapon(9)
		end
		local HaveHandsInSlots
		if WeaponsSlots and Weapon then
			for i,New_Weapon in WeaponsSlots do
				if New_Weapon~=0 then
					if New_Weapon.name=="Hands" then
						HaveHandsInSlots = 1
						break
					end
				end
			end
		end
		if Weapon.name~="Hands" and HaveHandsInSlots and CountWeapons>0 then
			-- Hud:AddMessage(self:GetName().."$1: 0")
			if not self.IsAiPlayer then -- Не забирать руки когда включен ИИ игрока.
				self.cnt:MakeWeaponAvailable(9,0)
			end
			if self.DownTime then self.NotAllowDelay = 1 end
		end
	end
end

function BasicPlayer:Update() -- C++
	if self.refractionSwitchDirection then -- Невидимость у мутантов.
		if self.Client_OnTimerCustom then self:Client_OnTimerCustom() end
		BasicPlayer.ProcessPlayerEffects(self)
	end
	self.IsIndoor = System:IsPointIndoors(self:GetPos())
	
	BasicPlayer.StopSoundsOnDeaf(self)
	
	local NewSignal = tonumber(getglobal("NS"))
	if not NewSignal then Game:CreateVariable("NS",0) end
	if NewSignal and NewSignal~=0 then
		self.NS = NewSignal
		setglobal("NS",0)
	end
end

function BasicPlayer:StopSoundsOnDeaf()
	-- if self~=_localplayer then
		-- Hud:AddMessage(self:GetName()..": Scale: "..Hud.SharedSoundScale)
	-- end
	if self.SayWordSound and Sound:IsPlaying(self.SayWordSound.Sound) and Hud.SharedSoundScale then
		-- Hud:AddMessage(self:GetName()..": Play")
		-- if self~=_localplayer then
			-- Hud:AddMessage(self:GetName()..": Scale: "..Hud.SharedSoundScale)
		-- end
		-- Sound:SetSoundVolume(self.SayWordSound.Sound,Hud.SharedSoundScale)
		if Hud and Hud.SharedSoundScale==0 then
			Sound:StopSound(self.SayWordSound.Sound)
		-- else
			-- Sound:SetSoundVolume(self.SayWordSound.Sound,Hud.SharedSoundScale)
		end
	end
end

function BasicPlayer:Server_OnTimer()
	self:SetScriptUpdateRate(self.UpdateTime)
	local stats = self.cnt
	local hit = BasicPlayer.IsDrowning(self)
	if hit then self:Damage(hit) end
	-- If not in vehicle and not at mounted weapon
	-- restrict angles
	if (stats.proning) then -- Добавить ограничение скорости поворота.
		if (self.isProning==0) then
			self.isProning=1
			stats:SetMinAngleLimitV(self.proneMinAngle)
			stats:SetMaxAngleLimitV(self.proneMaxAngle)
		end
	elseif (self.isProning==1) then
		self.isProning=0
		stats:SetMinAngleLimitV(self.normMinAngle)
		stats:SetMaxAngleLimitV(self.normMaxAngle)
	end
	-- Update the energy
	if (self.EnergyIncreaseRate) and (self.ChangeEnergy) then
		self:ChangeEnergy(self.EnergyIncreaseRate * self.UpdateTime/1000)
	end
	if stats.moving then BasicPlayer.DoBushSoundAI(self) end
	BasicPlayer.AddHands(self)
	if self.ai then	self:BasicPlayerTimer()	end
	BasicPlayer.Other(self)
	-- when in vehicle (boat) - see if collides with sometnig - release if yes
	BasicPlayer.UpdateCollisions(self)
	--until we dont have some dedicated functions for jumping use this to get if player has jumped
	BasicPlayer.PlayerJumped(self)
	if not self.ActiveTimeStart then self.ActiveTimeStart=_time end
end

function BasicPlayer:SayWord(SoundFileName,Flags,Volume,Min,Max,Scale,StopPrevSounds,ItPainSound,ItDeathSound) -- Всякие выкрикивания, вроде "Это он!". Мой способ.
	if Hud and Hud.SharedSoundScale==0 then return end
	if self.SayWordSound and Sound:IsPlaying(self.SayWordSound.Sound) then
		if not ItDeathSound and self.SayWordSound.ItPainSound then return end
		if StopPrevSounds then -- Если текущий или предыдущий звуки, смертельный или произносится слово (не звук), то остановить...
			Sound:StopSound(self.SayWordSound.Sound)
		end
		-- return
	end
	-- local Flags = bor(SOUND_RELATIVE,SOUND_UNSCALABLE,SOUND_OCCLUSION,SOUND_RADIUS,SOUND_DOPPLER)
	-- local Flags = bor(SOUND_RADIUS,SOUND_OCCLUSION) -- SoundSpot
	-- local Flags = bor(SOUND_RELATIVE,SOUND_UNSCALABLE)
	
	-- local NewF = tonumber(getglobal("SoundPitch")) -- Тестовая фигня.
	-- if not NewF then Game:CreateVariable("SoundPitch",1000) end
	-- self.MyToneOfVoice = NewF

	self.SayWordSound = {Sound=nil,Flags=Flags,Volume=Volume,Min=Min,Max=Max,Scale=Scale,ItPainSound=ItPainSound}
	if type(SoundFileName)=="userdata" then -- Не "string".
		-- Hud:AddMessage(self:GetName()..": SoundFileName: "..type(SoundFileName))
		self.SayWordSound.Sound = SoundFileName -- Это уже загруженный звук.
	else
		self.SayWordSound.Sound = Sound:Load3DSound(SoundFileName,Flags,Volume,Min,Max)
	end
	-- if Volume then Sound:SetSoundVolume(self.SayWordSound.Sound,Volume) end
	-- if Min and Max then Sound:SetMinMaxDistance(self.SayWordSound.Sound,Min,Max) end
	-- Sound:SetSoundProperties(self.SayWordSound.Sound,.1) -- Вроде приглушение при встрече звука с объектами. fFadingValue - the value that should be used for fading / sound occlusion
	if Scale then
		self.cnt:PlaySound(self.SayWordSound.Sound,Scale)
	else
		self.cnt:PlaySound(self.SayWordSound.Sound) -- Проигрываем файл. Почему-то функция изменения тона не работает корректно с однократно воспроизведёнными файлами. Их нужно останавливать и воспроизводить снова.
	end
	if self.MyToneOfVoice and self~=_localplayer and not self.IsSpecOpsMan and not self.IsAiPlayer
	and (not self.ForbiddenCharacters or not self:ForbiddenCharacters()) then
		Sound:SetSoundFrequency(self.SayWordSound.Sound,self.MyToneOfVoice) -- Меняем высоту звука (тон). Собственно, ради этого взлом стандартной говорунской системы и задумывался, ни как иначе!
		Sound:StopSound(self.SayWordSound.Sound) -- Тут же останавливаем его.
		self.RePlaySound = _time+.001 -- Говорим от том, что в следующем обновлении его нужно будет проиграть снова.
	-- elseif Hud.SharedSoundScale then
		-- Sound:SetSoundVolume(self.SayWordSound.Sound,Hud.SharedSoundScale)
	end
	-- Hud:AddMessage(self:GetName()..": SoundFileName: "..SoundFileName..", Volume: "..Volume..", Min: "..Min..", Max: "..Max)
	-- System:Log(self:GetName()..": SoundFileName: "..SoundFileName..", Volume: "..Volume..", Min: "..Min..", Max: "..Max)

	-- local NewF = tonumber(getglobal("SoundPitch")) -- Рабочее.
	-- if not NewF then Game:CreateVariable("SoundPitch",750) end
	-- if not self.TestSoundFile then self.TestSoundFile = Sound:LoadSound("Mods/Test/alert_to_idle_alone_13_VoiceC.wav") end
	-- self.cnt:PlaySound(self.TestSoundFile)
	-- Sound:SetSoundFrequency(self.TestSoundFile,NewF)
	-- Sound:StopSound(self.TestSoundFile)
	-- if not self.RePlaySoundTimerStart then self.RePlaySoundTimerStart = _time end
end

function BasicPlayer:SayDialogWord(SoundFileName,Flags,Volume,Min,Max,Scale)
	if Hud and Hud.SharedSoundScale==0 then return end
	if self.SayWordSound and Sound:IsPlaying(self.SayWordSound.Sound) then
		Sound:StopSound(self.SayWordSound.Sound)
	end
	
	-- local NewF = tonumber(getglobal("SoundPitch"))
	-- if not NewF then Game:CreateVariable("SoundPitch",1000) end
	-- self.MyToneOfVoice = NewF

	self.SayWordSound = {Sound=nil,Flags=Flags,Volume=Volume,Min=Min,Max=Max,Scale=Scale,DialogWord=DialogWord}
	-- self.SayWordSound.Sound = Sound:Load3DSound(SoundFileName,Flags)
	self.SayWordSound.Sound = Sound:Load3DSound(SoundFileName,Flags,Volume,Min,Max)
	-- Sound:SetMinMaxDistance(self.SayWordSound.Sound,Min,Max)
	-- Sound:SetSoundVolume(self.SayWordSound.Sound,Volume)
	-- Sound:SetSoundProperties(self.SayWordSound.Sound,1)
	self.cnt:PlaySound(self.SayWordSound.Sound) -- Проигрываем файл. Почему-то функция изменения тона не работает корректно с однократно воспроизведёнными файлами. Их нужно останавливать и воспроизводить снова.
	-- Sound:SetSoundPitching(self.SayWordSound.Sound,750)
	if self.MyToneOfVoice and self~=_localplayer and not self.IsSpecOpsMan and not self.IsAiPlayer
	and (not self.ForbiddenCharacters or not self:ForbiddenCharacters()) then
		Sound:SetSoundFrequency(self.SayWordSound.Sound,self.MyToneOfVoice) -- Меняем высоту звука (тон). Собственно, ради этого взлом стандартной говорунской системы и задумывался, ни как иначе!
		Sound:StopSound(self.SayWordSound.Sound) -- Тут же останавливаем его.
		self.RePlaySound = _time+.1 -- Говорим от том, что в следующем обновлении его нужно будет проиграть снова.
	-- elseif Hud.SharedSoundScale then
		-- Sound:SetSoundVolume(self.SayWordSound.Sound,Hud.SharedSoundScale)
	end
	-- System:Log(self:GetName()..": SoundFileName: "..SoundFileName)
	self.NeedThisSoundTimeInMS = SoundFileName
	if self.ThisSoundTimeInMS then
		-- System:Log(self:GetName()..": WARNING! ThisSoundTimeInMS: "..self.ThisSoundTimeInMS)
		self.ThisSoundTimeInMS = nil
	end
	self.SayDialogWordStart = _time
end

function BasicPlayer:Other()
	if not _localplayer then return end -- В самом-самом начале после загрузки выдаёт.
	-- if self.RePlaySoundTimerStart and _time>self.RePlaySoundTimerStart+.000001 then
		-- self.RePlaySoundTimerStart = nil
		-- -- Sound:StopSound(self.TestSoundFile)
		-- self.cnt:PlaySound(self.TestSoundFile)
		-- Sound:SetSoundFrequency(self.TestSoundFile,750)
	-- end
	if self.SoundMS then -- С++
		Hud:AddMessage(self:GetName()..": self.SoundMS: "..self.SoundMS)
	end
	-- if self.RePlaySound and self.SayWordSound then -- Копия в Client_DeadOnUpdate.
	if self.RePlaySound and _time>self.RePlaySound and self.SayWordSound then -- Копия в Client_DeadOnUpdate.
		self.RePlaySound = nil
		if self.SayWordSound.Scale then 
			self.cnt:PlaySound(self.SayWordSound.Sound,self.SayWordSound.Scale)
			self.SayWordSound.Scale = nil
		else
			self.cnt:PlaySound(self.SayWordSound.Sound) -- Снова воспроизводим файл.
		end
		Sound:SetSoundFrequency(self.SayWordSound.Sound,self.MyToneOfVoice) -- Меняем высоту звука (тон).
		-- if Hud.SharedSoundScale then
			-- Sound:SetSoundVolume(self.SayWordSound.Sound,Hud.SharedSoundScale)
		-- end
	end

	if self.ThisSoundTimeInMS and self.SayDialogWordStart then
		-- Hud:AddMessage(self:GetName()..": _time: ".._time..", self.SayDialogWordStart: "..self.SayDialogWordStart..", self.ThisSoundTimeInMS: "..self.ThisSoundTimeInMS)
		-- System:Log(self:GetName()..": _time: ".._time..", self.SayDialogWordStart: "..self.SayDialogWordStart..", self.ThisSoundTimeInMS: "..self.ThisSoundTimeInMS)
		if _time>self.SayDialogWordStart+self.ThisSoundTimeInMS+random(.2,1.5) then -- 2 -- .2
			self.NeedThisSoundTimeInMS = nil
			self.ThisSoundTimeInMS = nil
			self.SayDialogWordStart = nil
			-- System:Log(self:GetName()..": self.CurrentConversation:Continue")
			-- Hud:AddMessage(self:GetName()..": self.CurrentConversation:Continue")
			if self.CurrentConversation then self.CurrentConversation:Continue(self) end
		end
	end

	-- 750 - 1150
	-- local NewF = tonumber(getglobal("SoundPitch"))
	-- if not NewF then Game:CreateVariable("SoundPitch",1) end
	-- if not self.TestSoundFile then self.TestSoundFile = Sound:LoadSound("Mods/Test/alert_to_idle_alone_13_VoiceC.wav") end
	-- if self.AllowPlayTestSoundFile then
		-- if not Sound:IsPlaying(self.TestSoundFile) then
			-- Sound:SetSoundLoop(self.TestSoundFile,1)
			-- Sound:PlaySound(self.TestSoundFile)
			-- self.PrevF = NewF
		-- else
			-- if self.PrevF~=NewF then
				-- Sound:SetSoundFrequency(self.TestSoundFile,NewF)
				-- self.PrevF = NewF
				-- -- Sound:StopSound(self.TestSoundFile)
				-- Sound:PlaySound(self.TestSoundFile)
			-- end
		-- end
	-- else
		-- if Sound:IsPlaying(self.TestSoundFile) then
			-- Sound:StopSound(self.TestSoundFile)
			-- self.TestSoundFile = nil
		-- end
	-- end

	if self.NotAllowPickUpInArea and self.NotAllowPickUpInArea~=_time then self.NotAllowPickUpInArea = nil end -- Не разрешать подбирать только что брошенное оружие пока не выйдешь из зоны контакта с ним и не войдёшь снова. При этом другие могут у тебя его выхватить.

	-- local Angles = new(self:GetAngles())
	-- Hud:AddMessage(self:GetName().." Angles: x: "..Angles.x..", y: "..Angles.y..", z: "..Angles.z)
	if self==_localplayer and GameRules.PlayerEntitiesScreenSpace then -- Доработать. Проверка на "я - не я" блокирует.
		local entities=GameRules.PlayerEntitiesScreenSpace
		for i,entity in entities do -- Посмотреть как сделано в бинокле, что всех засекает.
			-- Hud:AddMessage(self:GetName()..": entity: "..entity.pEntity:GetName())
			-- System:Log(self:GetName()..": entity: "..entity.pEntity:GetName())
			-- if entity.DistFromCenter<30 then
			if (entity.DistFromCenter<30 and not self.theVehicle) or (entity.DistFromCenter<90 and self.theVehicle) then
			-- if (entity.DistFromCenter<30 and not self.theVehicle) or self.theVehicle then
				-- if entity.pEntity.type=="Player" and entity.pEntity.cnt.health>0 and not entity.pEntity.IsAiPlayer and not entity.pEntity.IsAiSpecOpsMan
				if entity.pEntity.type=="Player" and entity.pEntity.cnt.health>0 then
				-- and self.Properties.species~=entity.pEntity.Properties.species then
					-- Hud:AddMessage(self:GetName()..": aim target: "..entity.pEntity:GetName())
					-- System:Log(self:GetName()..": aim target: "..entity.pEntity:GetName())
					local Entities
					if GameRules.AllEntities then
						Entities = GameRules.AllEntities
					end
					if Entities then
						for i,entity2 in Entities do
							if entity2 and entity2.type=="Player" and entity2~=self and entity2~=entity.pEntity and BasicPlayer.IsAlive(entity2) then
								-- Hud:AddMessage(self:GetName()..": entity 1")
								if self.Properties.species==entity2.Properties.species then
								-- and self.PropertiesInstance.groupid==entity2.PropertiesInstance.groupid then
									-- Hud:AddMessage(self:GetName()..": entity 2")
									local NotSendFriends
									if entity2.Properties.species==entity.pEntity.Properties.species then -- Если человек из списка друг человеку, которого видно...
									-- and entity2.PropertiesInstance.groupid==entity.pEntity.PropertiesInstance.groupid then
										NotSendFriends = 1
									end
									if not NotSendFriends then
										-- local fDistance = self:GetDistanceFromPoint(entity2:GetPos())
										local fDistance = BasicPlayer.GetDistanceToTarget(self,entity2) -- Так правильнее определяет расстояние если я в технике.
										-- Hud:AddMessage(self:GetName()..": entity2: "..entity2:GetName()..", fDistance: "..fDistance)
										-- System:Log(self:GetName()..": entity2: "..entity2:GetName()..", fDistance: "..fDistance)
										if fDistance<=60 then
											-- AI:Signal(0,1,"TESTSIGNAL",entity2.id)
											-- Hud:AddMessage(self:GetName()..": aim target: "..entity.pEntity:GetName()..", receiver: "..entity2:GetName())
											-- System:Log(self:GetName()..": aim target: "..entity.pEntity:GetName()..", receiver: "..entity2:GetName())
											self.SenderId = entity.pEntity.id
											entity2.ForceSenderId = self.id
											AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY_ON_ATTACK(entity2) -- Посылает всем ближайшим союзникам сигнал о замеченной цели.
											-- entity2.ForceSenderId = nil
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	if self==_localplayer then
		if self.Ammo["HandGrenade"]>3 then self.Ammo["HandGrenade"] = 3 end -- Проверить. Работает только после переключения.
		if self.Ammo["SmokeGrenade"]>3 then self.Ammo["SmokeGrenade"] = 3 end
		if self.Ammo["FlashbangGrenade"]>3 then self.Ammo["FlashbangGrenade"] = 3 end

		local Entities = {}
		Game:GetPlayerEntitiesInRadius(self:GetPos(),100000,Entities)
		for i,entity in Entities do -- Сесть или вылезть за игроком в ТС.
			entity = entity.pEntity
			-- local fDistance = entity:GetDistanceFromPoint(self:GetPos())
			-- System:Log(entity:GetName()..": fDistance: "..fDistance)
			if entity and entity.type=="Player" and entity~=self and self.Properties.species==entity.Properties.species and entity.IsAiPlayer then
				self.IHaveAiFriend = 1
			-- if entity and entity.type=="Player" and entity~=self and self.Properties.species==entity.Properties.species and (entity.IsAiPlayer or ((fDistance<=30 and not entity.theVehicle) or (entity.RunToTrigger and entity.theVehicle))) then
				-- local InVehicle = strfind(entity.Behaviour.Name,"InVehicle")
				if self.theVehicle then
					-- Hud:AddMessage(entity:GetName()..": entity.sees: "..entity.sees..": entity.not_sees_timer_start: "..entity.not_sees_timer_start)
					-- if not InVehicle and (entity.sees~=1 or entity.not_sees_timer_start~=0) then
					local att_target = AI:GetAttentionTargetOf(entity.id) -- Добавил потому что сразу после загрузки, когда игрок садится в лодку, друг не может сесть из-за того, что sees у него почему-то 1 (видит цель), а не 0 (целей нет).
					if not entity.theVehicle and (entity.sees~=1 or entity.not_sees_timer_start~=0 or not att_target) then
						AIBehaviour.DEFAULT:SHARED_ENTER_ME_VEHICLE(entity,self.theVehicle) -- Сесть в транспорт, в котором находится игрок.
						-- Hud:AddMessage(entity:GetName()..": theVehicle: "..entity.theVehicle:GetName())
						-- System:Log(entity:GetName()..": theVehicle: "..entity.theVehicle:GetName())
					end
				else
					if entity.theVehicle then
						if entity.theVehicle and entity.theVehicle.driverT and entity.theVehicle.driverT.entity==entity
						and entity.theVehicle.driverT.state~=4 then
							VC.InitLeaving(entity.theVehicle,entity.theVehicle.driverT)
							AI:MakePuppetIgnorant(entity.id,0)
						end
						if entity.theVehicle and entity.theVehicle.gunnerT and entity.theVehicle.gunnerT.entity==entity
						-- and entity.theVehicle.gunnerT.state~=4 and (entity.sees==0 or entity.not_sees_timer_start~=0) then
						and entity.theVehicle.gunnerT.state~=4 and (entity.sees~=1 or entity.not_sees_timer_start~=0)
						and BasicPlayer.IsAlive(self) then -- Выходить только если игрок ещё жив, а не по любому. Так эффекту больше будет когда игрок погибнет, а друг будет продолжать стрелять.
							VC.InitLeaving(entity.theVehicle,entity.theVehicle.gunnerT)
							AI:MakePuppetIgnorant(entity.id,0)
						end
						if entity.theVehicle then -- Ещё раз написал потому, что иногда nil всё-равно выдаёт.
							for idx=1,entity.theVehicle.passengerLimit do
								if entity.theVehicle.passengersTT[idx].entity==entity and entity.theVehicle.passengersTT[idx].state~=4 then
									VC.InitLeaving(entity.theVehicle,entity.theVehicle.passengersTT[idx])
									AI:MakePuppetIgnorant(entity.id,0)
									break
								end
							end
						end
					end
				end
			else
				self.IHaveAiFriend = nil
			end
		end
	end
	-- System:Log(self:GetName()..": self:GetViewDistRatio(): "..self:GetViewDistRatio())
	-- self:SetViewDistRatio(1000)
	-- self:SetViewDistUnlimited() -- Выставляет дистанцию, равную 1 километру.
	-- self:SetViewDistRatio(255)

	-- if self.SaveGunOutStatus then
		-- if Weapon then
			-- if Weapon.name~="Hands" then
				-- self.AI_GunOut=self.SaveGunOutStatus
				-- self.SaveGunOutStatus = nil
			-- end
		-- end
	-- end

	-- self.IsIndoor = System:IsPointIndoors(self:GetPos())
	-- if self.cnt.weapon then
		-- BasicWeapon:CheckStopFireLoop(self,self.fireparams,self.sounddata)
	-- end

	-- if not self.ai then -- У игрока.
		-- if self.AmbientLightAmount and self.LightAmount and self.TotalLightScale then -- 49/0/49|49/49/98
			-- -- System:Log(self:GetName()..": AmbientLightAmount: "..self.AmbientLightAmount.." + LightAmount: "..self.LightAmount.." = TotalLightScale: "..self.TotalLightScale)
		-- end
	-- else -- У ИИ.
		-- if self.AmbientLightAmount and self.LightAmount and self.TotalLightScale then -- 49/0/49|49/49/98
			-- -- System:Log(self:GetName()..": AmbientLightAmount: "..self.AmbientLightAmount.." + LightAmount: "..self.LightAmount.." = TotalLightScale: "..self.TotalLightScale)
		-- end
		-- if self.TargetAmbientLightAmount and self.TargetLightAmount and self.TargetTotalLightScale and self.TargetMaxTotalLightScale then -- 0/0/0|49/49/98 - точные.
			-- -- System:Log(self:GetName()..": TargetAmbientLightAmount: "..self.TargetAmbientLightAmount.." + TargetLightAmount: "..self.TargetLightAmount.." = TargetTotalLightScale: "..self.TargetTotalLightScale..", TargetMaxTotalLightScale: "..self.TargetMaxTotalLightScale)
		-- end
	-- end
	if not _localplayer.cnt.bForceWalk and System:GetScreenFx("FlashBang")==1 and tonumber(getglobal("game_DifficultyLevel"))>=2 then
		_localplayer.cnt.bForceWalk = 1
	elseif not ClientStuff.vlayers:IsActive("WeaponScope") and not ClientStuff.vlayers:IsActive("Binoculars") and _localplayer.cnt.bForceWalk then
		_localplayer.cnt.bForceWalk = nil
	end

	if not UI then -- В GameRules пихать бесполезно, так как там обновление работает только когда игрок в игре.
		local SoundPerception = tonumber(getglobal("ai_soundperception"))
		if SoundPerception==0 then
			setglobal("ai_soundperception",1) -- Постоянно включать у ИИ чувствительность ко всем звукам, а то проверки поведения получаются неправильными.
		end
	end
end

function BasicPlayer:OnTextMessage(self,Command,SenderName,Text)
	-- Hud:AddMessage(SenderName..": $1"..Text)
	if Text then
		local Command
		local LowerText = strlower(Text)
		if LowerText=="a" or LowerText=="attack" then
			Command = "Attack" -- Атаковать цель, которую помнит.
		elseif LowerText=="s" or LowerText=="stop" then
			Command = "Stop" -- Находиться на месте и ждать приказа. Выход из режима только в случае опасности.
		elseif LowerText=="w" or LowerText=="wait" then
			Command = "Wait" -- Находиться на месте и ждать любого тревожного сигнала.
		elseif LowerText=="h" or LowerText=="fh" or LowerText=="hide" or LowerText=="forcehide" then
			Command = "Hide" -- Спрятаться и постоянно перепрятываться от источников шума. Выход из режима только в случае опасности.
		elseif LowerText=="hs" or LowerText=="has" or LowerText=="hidestop" or LowerText=="hideandstop" then
			Command = "HideAndStop" -- Спрятаться, находиться на месте и ждать приказа. Выход из режима только в случае опасности.
		elseif LowerText=="hw" or LowerText=="haw" or LowerText=="hidewait" or LowerText=="hideandwait" then
			Command = "HideAndWait" -- Спрятаться, находиться на месте и ждать любого тревожного сигнала.
		elseif LowerText=="m" or LowerText=="move" then
			Command = "Move" -- Отменить приказы (Возвращается к состоянию по умолчанию, становится автономным).
		elseif LowerText=="f" or LowerText=="follow" then
			Command = "Follow" -- Бежать за нами до любого тревожного сигнала. После потери цели он не будет её искать, а сразу побежит к нам.
		elseif LowerText=="ff" or LowerText=="forcefollow" then
			Command = "ForceFollow" -- Бежать за нами до того как увидит цель. Бежит к нам сразу как только перестанет её видеть.
		elseif LowerText=="b" or LowerText=="back" then
			Command = "Back" -- Сразу же вернуться к нам как только потеряет цель. По возвращении вернуться к обычному состоянию.
		elseif LowerText=="r" or LowerText=="respawn" then
			Command = "Respawn" -- Переместить к нам. Очень прошу не злоупотреблять. Добавил ввиду того что может где-нибудь застрять так, что сам не сможет выбраться.
		elseif LowerText=="sh" or LowerText=="search" then
			Command = "Search" -- Сказать искать цель.
		elseif LowerText=="hp" or LowerText=="hh" or LowerText=="hold" or LowerText=="holdpositon" then
			Command = "Hold" -- Держать оборону. Он не перемещается, поэтому осторожно подходите с выбором позиции. Выходит из режима при получении ранения.
		elseif LowerText=="ss" or LowerText=="suppress" then
			Command = "Suppress" -- Подавляет. Почти тоже, что и "Hold", только постоянно смотрит в сторону видимой цели или цели которую помнит и стреляет пока не убьёт.
		-- elseif LowerText=="r" or LowerText=="retreat" then
			-- Command = "Retreat" -- Отступаем.
		-- elseif LowerText=="rf" or LowerText=="retreatforward" then
			-- Command = "RetreatForward" -- Отступаем пятясь(спиной).
		-- elseif LowerText=="gl" or LowerText=="goleft" then
			-- Command = "GoLeft" -- Обойти цель слева.
		-- elseif LowerText=="gr" or LowerText=="goright" then
			-- Command = "GoRight" -- Обойти цель справа.
		end
		-- Положение тела, скорость перемещений, не стрелять, молчать, фонарь, пушка, выбросить пушку, смотри на меня, встань на моё место, сядь за пулемёт.
		-- атаку доработать
		if Command then
			self.AiAction = Command
			-- Hud:AddMessage(self:GetName()..": "..Command.." on command: "..Text)
		end
	end
end

-- function BasicPlayer:OnFakeMemory()
	-- if not self.randomshoottime then self.randomshoottime=random(.5,3) end
	-- if _time>self.FakeMemoryStart+tonumber(self.randomshoottime) and _time<self.FakeMemoryStart+tonumber(self.randomshoottime)+.3 then
		-- self.randomshoottime = nil
		-- self.LittleShoot=1  -- Когда 1, тогда оставшиеся секунды не стрелять.
	-- end
	-- if _time>self.FakeMemoryStart+tonumber(10) then
		-- self.FakeMemory = 2
		-- -- self.NoTargetUpdate = 1
		-- self.FakeMemoryStart = nil
	-- end
-- end

-- IMPROVED DIVING BY MIXER
BasicPlayer.fp_watersplash = {
	sounds = {
		{"Sounds/player/water/underwatersplash.wav",SOUND_UNSCALABLE,200,5,200},
	},
	particleEffects = {
		name = "water.water_splash.a",
		scale = .4,
	},
}

function BasicPlayer:OnEnterWater()
	-- player has just entered the water,check its velocity
	local vel = new(self:GetVelocity())
	if ((vel.z < -1.1)) then
		local pos=new(self:GetPos())
		if self==_localplayer then
			ExecuteMaterial(pos,g_Vectors.v001,BasicPlayer.fp_watersplash,1)
		else
			ExecuteMaterial(pos,g_Vectors.v001,CommonEffects.water_splash,1)
		end
	end
end
-- IMPROVED DIVING ENDS

-- ProcessPlayerEffects: process/handles all shader based character effects
function BasicPlayer.ProcessPlayerEffects(entity)
	if not entity then return end
	-- process player effects

	-- only set,when shader changes !
	local iEffectsElementsCount=getn(entity.pEffectStack)
	local iUpdate=0
	if (entity.iPlayerEffect>0 and entity.pEffectStack[iEffectsElementsCount]~=entity.iPlayerEffect) then
		-- remove current effect
		if (entity.iPlayerEffect==1) then
			if (iEffectsElementsCount>1) then
				tremove(entity.pEffectStack)
				entity.iPlayerEffect=entity.pEffectStack[iEffectsElementsCount-1]
			end
		else
			-- add new effect
			tinsert(entity.pEffectStack,entity.iPlayerEffect)
		end
		iUpdate=1
		BasicPlayer.SetPlayerEffect(entity)
	end

	if (entity==_localplayer and entity.iLastWeaponID~=_localplayer.cnt.weaponid) then
		entity.iLastWeaponID=_localplayer.cnt.weaponid
		iUpdate=1
	end
	-- cryvision is special case,overlap all other shader effects
	if (entity.bPlayerHeatMask==1 or entity.bPlayerHeatMask==3) then
		if (entity.bPlayerHeatMask==1 or iUpdate==1) then
			-- reset all
			entity:SetShader("",4)
			if (entity==_localplayer) then
				-- now set to character and arms
				entity:SetShader("TemplCryVisionPlayer",2)
				entity:SetSecondShader("",4)
			else
				-- set characters heat mask on 1st layer,and heat signature on 2nd layer
				entity:SetShader("TemplCryVision_Mask",0)
				entity:SetSecondShader("TemplCryVision",2)
			end
			entity.bPlayerHeatMask=3
		end
		if (entity.fLastBodyHeat~=entity.fBodyHeat) then
			entity.bUpdatePlayerEffectParams=1
			entity.fLastBodyHeat=entity.fBodyHeat
		end
	elseif (entity.bPlayerHeatMask==2 or (entity==_localplayer and iUpdate==1)) then
		entity.bPlayerHeatMask=0
		-- restore old effects
		BasicPlayer.SetPlayerEffect(entity)
	end
	-- update player effect params
	if entity.bUpdatePlayerEffectParams or entity.iPlayerEffect==5 then
		entity.bUpdatePlayerEffectParams = nil
		BasicPlayer.UpdatePlayerEffectParams(entity)
	end
end

-- SetPlayerEffect: set current character render effect
-- Notes: any new shader effect for characters,should be handled here to ensure
-- proper SetShader/SetSecondShader functionality,and shaders dependencies (eg: heat source,overcomes all other shaders)
-- available effects are:
-- 1. reset effect
-- 2. character color mask
-- 3. invulnerability
-- 4. heat source
-- 5. stealth
-- 6. mutated (note,should be used only with Jack model/localplayer)

-- Note: SetShader/SetSecondShader changed,now works like SetSecondShader(szShaderName,Mask)
-- where Mask= 0: character only,1: character+attached,2: character+arms,3:character+arms+attached,4: all

function BasicPlayer.SetPlayerEffect(entity)
	-- get current effect ID
	local iEffectID=entity.pEffectStack[getn(entity.pEffectStack)]
	entity:SetShader("",4)
	entity:SetSecondShader("",4)
	if (iEffectID==3) then  -- iEffectID invulnerable ?
		entity:SetSecondShader("CharacterInvulnerability_Metal",0)
	elseif (iEffectID==5) then-- is in stealth ?
		entity:SetShader("MutantStealth",4)
	elseif (iEffectID==2) then-- is colored ?
		entity:SetSecondShader("PlayerMaskModulate",0)
	elseif (iEffectID==6) then-- mutated arms effect
		entity:SetSecondShader("TemplMutatedArms",2)
	end
end

function BasicPlayer.UpdatePlayerEffectParams(entity)
	-- get current effect ID
	local iEffectID=entity.pEffectStack[getn(entity.pEffectStack)]
	-- cryvision is special case
	if (entity.bPlayerHeatMask==1 or entity.bPlayerHeatMask==3) then
		-- set shaders
		local fHeat=entity.fBodyHeat+.4
		if (fHeat>.85) then
			fHeat=.85
		end
		if (entity==_localplayer) then
			entity:SetShaderFloat("BodyHeat",fHeat,0,0)
		else
			entity:SetShaderFloat("BodyHeat",fHeat,0,0)
		end
	end
	-- if (iEffectID==3) then  -- iEffectID invulnerable ?
	-- no params to update
	-- elseif (iEffectID==5) then-- is in stealth ?
	if (iEffectID==5) then-- is in stealth ?
		entity:SetShaderFloat("Refraction",entity.refractionValue,0,0)
	elseif (iEffectID==2) then-- is colored ?
		local color=entity.cnt:GetColor()
		entity:SetShaderFloat("ColorR",color.x,0,0)
		entity:SetShaderFloat("ColorG",color.y,0,0)
		entity:SetShaderFloat("ColorB",color.z,0,0)
	-- elseif (iEffectID==6) then-- mutated arms effect
	-- no params to update
	end
end

function BasicPlayer:Client_OnTimer()
	BasicPlayer.ProcessPlayerEffects(self)
	self:SetScriptUpdateRate(self.UpdateTime)
	if self.Client_OnTimerCustom then self:Client_OnTimerCustom() end
	local hit = BasicPlayer.IsDrowning(self)
	if (hit) then BasicPlayer.Client_OnDamage(self,hit) end
	local stats = self.cnt
	if self.ladder then self.ladder:UpdatePlayerSound(self) end

	-- check for local client only
	if (self==_localplayer) then
		if (Hud) then
			-- Update the energy
			if (Game:IsMultiplayer() and self.EnergyIncreaseRate and self.ChangeEnergy) then
				self:ChangeEnergy(self.EnergyIncreaseRate * self.UpdateTime/1000)
			end
			-- spawn some bubbles when he drows
			if (stats.underwater>0) then
				local Pos=self:GetPos()
				Pos.z=Pos.z+1.5
				BasicWeapon.UnderwaterBubbles.count=16+random(1,64)
				BasicWeapon.UnderwaterBubbles.fPosRandomOffset=1.5
				Particle:CreateParticle(Pos,g_Vectors.v001,BasicWeapon.UnderwaterBubbles)
				BasicWeapon.UnderwaterBubbles.count=1
				BasicWeapon.UnderwaterBubbles.fPosRandomOffset=0
			end
			Hud.breathlevel=stats.breath
			Hud.staminalevel=stats.stamina
			--System:Log("\002 "..self.cnt.stamina.." "..self.cnt.breath)
			-- there's some problem in stamina update,when inside water,stops being updated
			--Hud.staminalevel=self.cnt.stamina
		end -- IF HUD
		----------------------------
		-- Main player specific update code
		----------------------------
		self.vLastPos = self:GetPos()
		-- restrict angles
		if (stats.proning) then
			if (self.isProning==0) then
				self.isProning=1
				--stats:SetAngleLimitBaseOnEnviroment()
				stats:SetMinAngleLimitV(self.proneMinAngle)
				stats:SetMaxAngleLimitV(self.proneMaxAngle)
				--Input:SetMouseSensitivityScale(.1)
			end
		else
			if (self.isProning==1) then
			self.isProning=0
			--stats:SetAngleLimitBaseOnVertical()
			stats:SetMinAngleLimitV(self.normMinAngle)
			stats:SetMaxAngleLimitV(self.normMaxAngle)
			--Input:SetMouseSensitivityScale(1)
			end
		end

		-- set send an sneaking-mood-event if we're crouching or proning
		if (self.cnt.crouching or self.cnt.proning) then
			Sound:AddMusicMoodEvent("Sneaking",MM_SNEAKING_TIMEOUT)
		end

		if (self.Energy < 1) then
			ClientStuff.vlayers:DeactivateActiveLayer("HeatVision")
		end

		-- disable some stuff when the player goes swimming
		if (self.cnt:IsSwimming()) then
			ClientStuff.vlayers:DeactivateActiveLayer("HeatVision")
			ClientStuff.vlayers:DeactivateActiveLayer("WeaponScope")
			ClientStuff.vlayers:DeactivateActiveLayer("Binoculars")
		end
	end
	-- FOR ALL PLAYERS FROM HERE
	BasicPlayer.UpdateInWaterSplash(self)
	if (self.cnt.vel > .001) then
		self:ApplyForceToEnvironment(1,self.cnt.vel*.05)
	end
	--self.bushSndTime = self.bushSndTime - DeltaTime
	--if (stats.moving and self.bushSndTime <= 0) then
	if (stats.moving) then
		BasicPlayer.DoBushSound(self)
		--System.MeasureTime("DoBushSound")
	end
	-- play heavy breathing sound when exhausted...
	-- COMMENTED DUE TO BAD SOUNDING,PLEASE DO NOT REMOVE YET !!!
	--if (stats.running and self.ExhaustedBreathingSound) then
	--if (not self.ExhaustedStartTime) then
	--self.ExhaustedStartTime=0
	--end
	--self.ExhaustedStartTime=self.ExhaustedStartTime+self.UpdateTime/1000
	--if (self.ExhaustedStartTime>self.ExhaustedBreathingStart) then
	--if (not Sound:IsPlaying(self.ExhaustedBreathingSound)) then
	--System:Log("Start Breathing")
	--Sound:SetSoundLoop(self.ExhaustedBreathingSound,1)
	--Sound:PlaySound(self.ExhaustedBreathingSound)
	--self.ExhaustedStopTime=0
	--end
	--end
	--else
	--self.ExhaustedStartTime=0
	--if (self.ExhaustedStopTime) then
	--System:Log("self.ExhaustedStopTime")
	--self.ExhaustedStopTime=self.ExhaustedStopTime+self.UpdateTime/1000
	--if (self.ExhaustedStopTime>self.ExhaustedBreathingStop) then
	--System:Log("Stop Breathing")
	--Sound:SetSoundLoop(self.ExhaustedBreathingSound,0)
	--self.ExhaustedStopTime=nil
	---Sound:StopSound(self.ExhaustedBreathingSound)
	--end
	--end
	--end

	--until we dont have some dedicated functions for jumping use this to get if player has jumped
	BasicPlayer.PlayerJumped(self)
	BasicPlayer.PlayJumpSound(self)
	if (self.theVehicle) then
		BasicPlayer.DoSpecialVehicleAnimation(self)
	end
	--when player have 4 weapons,and is near a weapon to pickup,display the message.
	if (self.pickup_ent) then
		--Hud.label = "@PressDropWeapon @"..self.cnt.weapon.name.." @AndPickUp @"..self.pickup_ent.weapon
		--Hud.labeltime = self.UpdateTime/1000
		local dist = EntitiesDistSq(self,self.pickup_ent)
		if (dist>self.pickup_dist+.01) then
			self.pickup_ent = nil
			self.pickup_OnContact = nil
			self.pickup_dist = 0
		elseif (self.pickup_OnContact) then
			self.pickup_OnContact(self.pickup_ent,self)
			Hud.labeltime = self.UpdateTime/1000 --keep the label message for a while.
		end
	end
end

function BasicPlayer:Client_OnTimerDead()
	-- no blood from dead body
	if g_gore=="0" or g_gore=="1" then return end
	self:SetTimer(100)
	local pos = self:GetBonePos("Bip01 Spine")
	if (not pos) then
		pos = self:GetPos()
	end
	if (Game:IsPointInWater(pos)) then
		pos.z = pos.z - .06
	end
	if (Game:IsPointInWater(pos)) then
		-- Если утонули сущности, которые сами вошли в воду не получали огнестрельных ранений или ранений от взрывов, то этого эффекта не будет.
		if self.ReceivedDamage then
			Particle:SpawnEffect(pos,g_Vectors.up,"blood.on_water.a",.6*self.fBodyHeat)
		end
	else
		if (self.BloodTimer < 1000) then
			self.BloodTimer = self.BloodTimer + 100
			if (self.BloodTimer >= 1000) then
				pos.z = pos.z + .5
				self.cnt:GetProjectedBloodPos(pos,g_Vectors.down,"GoreDecalsBld",4)
			end
		end
	end
end

function BasicPlayer:PhysicalizeOnDemand()
	if (self.cnt.health~=0) then
		self:SetCharacterPhysicParams(0,"",PHYSICPARAM_SIMULATION,self.BulletImpactParams)
	end
end

function BasicPlayer.SecondShader_Invulnerability(entity,amount,r,g,b)
	-- hack: since this is called when player spawned and player not in heatvisionmask list,set flag on
	local bHeatLayerPresent=(ClientStuff and ClientStuff.vlayers)
	if (bHeatLayerPresent and ClientStuff.vlayers:IsActive("HeatVision")) then
		entity.bPlayerHeatMask=1
	end
	-- set invulnerability effect
	entity.iPlayerEffect=3
	BasicPlayer.ProcessPlayerEffects(entity)
end

function BasicPlayer.SecondShader_TeamColoring(entity)
	-- hack: since this is called when player spawned and player not in heatvisionmask list,set flag on
	local bHeatLayerPresent=(ClientStuff and ClientStuff.vlayers)
	if (bHeatLayerPresent and ClientStuff.vlayers:IsActive("HeatVision")) then
		entity.bPlayerHeatMask=1
	end
	-- set team coloring effect
	entity.iPlayerEffect=2
	BasicPlayer.ProcessPlayerEffects(entity)
end

function BasicPlayer.SecondShader_None(entity)
	-- hack: since this is called when player spawned and player not in heatvisionmask list,set flag on
	local bHeatLayerPresent=(ClientStuff and ClientStuff.vlayers)
	if (bHeatLayerPresent and ClientStuff.vlayers:IsActive("HeatVision")) then
		entity.bPlayerHeatMask=1
	end
	-- reset shader
	entity.iPlayerEffect=1
	BasicPlayer.ProcessPlayerEffects(entity)
end

BasicPlayer.Server_EventHandler={
	[ScriptEvent_FireModeChange]=function(self,Params)
		Params.shooter=self
		return BasicWeapon.Server.OnEvent(self.cnt.weapon,ScriptEvent_FireModeChange,Params)
	end,
	[ScriptEvent_AnimationKey]=function(self,Params)
		-- Hud:AddMessage(self:GetName().." type(Params): "..type(Params))
		-- System:Log(self:GetName().." type(Params): "..type(Params))
		if (type(Params)=="table") then
			-- for i,val in Params do -- i - что это (animation), val - название.
				-- if Params.userdata and Params.userdata~=0 then
					-- val = "ThisSound"
				-- end	
				-- Hud:AddMessage(self:GetName()..": i: "..i..", val: "..val)
				-- System:Log(self:GetName()..": i: "..i..", val: "..val)
			-- end
			if (self.ai) and (Params.number) then
				if (Params.number==KEYFRAME_APPLY_MELEE) then
					if (self.cnt.weapon) then
						BasicWeapon.Client.OnStopFiring(self.cnt.weapon,self)
					end
					if (self.cnt.melee_attack==nil) then
						self.cnt.melee_attack = 1
						local target = AI:GetAttentionTargetOf(self.id)
						if (type(target)=="table") then
							self.cnt.melee_target = target
							if ((self.Properties.bSingleMeleeKillAI==1) and (target.ai)) then
								self.melee_damage = 10000
							else
								self.melee_damage = self.Properties.fMeleeDamage
							end
						else
							self.cnt.melee_target = nil
							self.melee_damage = self.Properties.fMeleeDamage
						end
						if (self.ImpulseParameters) then
							self.ImpulseParameters.pos = self:GetPos()
							local power = self.ImpulseParameters.impulsive_pressure
							self:ApplyImpulseToEnvironment(self.ImpulseParameters)
						end
					end
				elseif (Params.number==KEYFRAME_JOB_ATTACH_MODEL_NOW) then
					if (self.Behaviour) then
						self.Behaviour:AttachNow(self)
					end
				elseif (Params.number==KEYFRAME_BREATH_SOUND) then
					if (Sound:IsPlaying(self.breath_sound)==nil) then
						self.breath_sound = BasicPlayer.PlayOneSound(self,self.breathSounds,110,1,1,1)
					end
				elseif (Params.number==KEYFRAME_ALLOW_AI_MOVE) then
					AI:EnablePuppetMovement(self.id,1)
				elseif (Params.number==KEYFRAME_HOLD_GUN) then
					self.cnt:HoldGun()
					self.AI_GunOut = 1
				elseif (Params.number==KEYFRAME_HOLSTER_GUN) then
					self.cnt:HolsterGun()
					self.AI_GunOut = nil
				elseif (Params.number > KEYFRAME_HOLSTER_GUN) then
					-- Hud:AddMessage(self:GetName()..": BasicPlayer/FireOverride")
					-- System:Log(self:GetName()..": BasicPlayer/FireOverride")
					AI:FireOverride(self.id) -- То есть, один раз выстреливает и прекращает.
					self.ROCKET_ORIGIN_KEYFRAME = Params.number
				end
			end
		end
		BasicPlayer.DoStepSoundAI(self)
	end,
	[ScriptEvent_Use]=function(self,Params)
		local entities=self:GetEntitiesInContact() -- Редкость, в одном экземпляре.
		local used
		if (entities) then
			for id,ent in entities do
				if (ent.OnUse) then
					if (ent:OnUse(self)==1) then
						used=1
					end
				end
			end
		end
		return used
	end,
	[ScriptEvent_CycleVehiclePos]=function(self,Params)
		if (self.theVehicle) then
			VC.CyclePosition(self.theVehicle,self)
		end
	end,
	[ScriptEvent_FireGrenade]=function(self,Params)
		--NOTE self.cnt.grenadetype=1 is the ROCK so unlimited ammo
		if self.cnt.grenadetype==1 or self.cnt.numofgrenades>0 then
			return BasicPlayer.Server_OnFireGrenade(self,Params)
		else
			return
		end
	end,
	[ScriptEvent_Land] = function(self,Params)
		BasicPlayer.HandleLanding(self,1)
		if self.NoFallDamage then return end
		local fallDmg = Params/100
		if (fallDmg>self.FallDmgS) then
			if (self.cnt.fallscale) then
				fallDmg = (fallDmg - self.FallDmgS)*self.FallDmgK*self.cnt.fallscale
			else
				fallDmg = (fallDmg - self.FallDmgS)*self.FallDmgK
			end
			local hit = {
				dir = g_Vectors.v001,
				damage = fallDmg,
				target = self,
				shooter = self,
				landed = 1,
				impact_force_mul_final=5,
				impact_force_mul=5,
				damage_type = "healthonly",
				falling=1,
			}
			self:Damage(hit)
		end
	end,
	[ScriptEvent_PhysCollision] = function(self,Params)
		local shooter = self
		local isvehicle
		if ((not Params.collider) or (not Params.collider.Properties)
		or (not Params.collider.Properties.damage_players)
		or (Params.collider.Properties.damage_players==0)) then
			return
		end
		local cldDmg = Params.damage*self.CollisionDmg*Params.collider.Properties.damage_players

		if (Params.collider.IsVehicle==1) then
		-- just left some vehicle - don't damage by vehicle
		if (self.outOfVehicleTime and _time-self.outOfVehicleTime<2) then return end
			if (Params.collider.driverT and Params.collider.driverT.entity) then
				-- if this is vehicle drawen by Val - don't damage local player from it
				if (self==_localplayer and Params.collider.driverT.entity.Properties.special==1) then return end
				shooter = Params.collider.driverT.entity
				isvehicle = 1
			end
			cldDmg = Params.damage*self.CollisionDmgCar
		end
		if (Params.collider.Properties.damage_scale) then
			cldDmg = cldDmg*Params.collider.Properties.damage_scale
		end
		local hit = {
			dir = new(Params.dir),
			ipart = -1,
			damage = cldDmg,
			target = self,
			shooter = shooter,
			landed = 1,
			impact_force_mul_final=5,
			impact_force_mul=5,
			impact_force_mul_final_torso=0,
			target_material={type="arm"},
			damage_type="normal",
			weapon = Params.collider,
		}
		hit.impact_force_mul_final = 0
		if (Params.collider_mass >self.PhysParams.mass) then
			if ((Params.collider) and (Params.collider.Properties) and (Params.collider.Properties.hit_upward_vel)) then
				hit.dir.x=0  hit.dir.y=0  hit.dir.z=1
				hit.impact_force_mul_final_torso = Params.collider.Properties.hit_upward_vel*self.PhysParams.mass
			else
				hit.impact_force_mul_final_torso = 0 --Params.collider_velocity*self.PhysParams.mass*1.3
			end
		end
		self:Damage(hit)
	end,
	[ScriptEvent_CycleGrenade] = function(self,Params)
		local curr=self.cnt.grenadetype
		local gtypecount=count(GrenadesClasses)
		local n=0
		local next=curr
		repeat
		next=next+1
		n=n+1
		if (next>gtypecount) then
			next=1
		end
		--next==1 mean "rock" so always available
		until(next==1 or (self.Ammo[GrenadesClasses[next]] and self.Ammo[GrenadesClasses[next]]>0 and not(GrenadesClasses[next]=="FlareGrenade" and not self.ai)) or n>=gtypecount)
		self.Ammo[GrenadesClasses[curr]]=self.cnt.numofgrenades
		self.cnt.numofgrenades=self.Ammo[GrenadesClasses[next]]
		self.cnt.grenadetype=next
	end,
	[ScriptEvent_MeleeAttack]=function(self,Params)
		--System:Log("MELEE SERVER")
		self.cnt.weapon_busy=1
		-- move the raycast in C++ and send just a event when an hit occur
		local t=Game:GetMeleeHit(Params)
		if (t) then
			if (t.target) then
				if (self.melee_damage) then
					t.damage=self.melee_damage
				else
					t.damage=100
				end
				t.melee=1
				t.damage_type = "normal"
				t.target:Damage(t)
				--System:Log("DRAW MELEE BLOOD 111")
			end
			if t.target_material then -- Проверить.
				local MeleeHit=t.target_material.melee_punch  -- Исправить: Пишет что target_material пустой.
				if (self.MeleeHitType and t.target_material[self.MeleeHitType]) then
					MeleeHit=t.target_material[self.MeleeHitType]
					--System:Log("player specific melee")
				-- else
					--System:Log("standard melee")
				end
				ExecuteMaterial(t.pos,t.normal,MeleeHit,1)
			end
		-- else
			--System:Log("MISSED")
		end
	end,
	[ScriptEvent_PhysicalizeOnDemand]=BasicPlayer.PhysicalizeOnDemand,
	[ScriptEvent_AllClear]=function(self,Params)
	end,
	[ScriptEvent_InVehicleAmmo] = function(self,Params)
		--System:Log("\001 ScriptEvent_InVehicleAmmo   "..self:GetName())
		if (not self.theVehicle) then return end
		--System:Log("\001 ScriptEvent_InVehicleAmmo  2 >> "..Params)
		if (Params==1) then
			VC.VehicleAmmoEnter(self.theVehicle,self)
		else
			VC.VehicleAmmoLeave(self.theVehicle,self)
		end
	end,
}

BasicPlayer.Server_EventHandlerDead={
[ScriptEvent_InVehicleAmmo] = function(self,Params)
	--System:Log("\001 ScriptEvent_InVehicleAmmo   "..self:GetName())
	if (not self.theVehicle) then return end
	--System:Log("\001 ScriptEvent_InVehicleAmmo  2 >> "..Params)
	if (Params==1) then
		VC.VehicleAmmoEnter(self.theVehicle,self)
	else
		VC.VehicleAmmoLeave(self.theVehicle,self)
	end
end
}


BasicPlayer.Client_EventHandler={
	[ScriptEvent_FireModeChange]=function(self,Params)
		local WeaponParams =
		{
			shooter = self
		}
		-- Call the weapon so it has the chance to abort any active
		-- processes going on for the old firemode
		return BasicWeapon.Client.OnEvent(self.cnt.weapon,ScriptEvent_FireModeChange,WeaponParams)
	end,
	[ScriptEvent_FlashLightSwitch]=function(self,Params)
		--System:Log("--------------- fLight switched")
		if (self.fLightSound==nil) then return end
		BasicPlayer.PlaySoundEx(self,self.fLightSound)
		--if (self==_localplayer) then
		if self.FlashLightActive==0 then
			self.FlashLightActive = 1
		else
			self.FlashLightActive = 0
		end
		--end
	end,
	[ScriptEvent_Command]=BasicPlayer.ProcessCommand,
	[ScriptEvent_AnimationKey]=function(self,Params)
		if (type(Params)=="table") then
			if Params.userdata then
				if Params.userdata~=0 then
					if not self.cnt.first_person then
						if strfind(strlower(Params.animation),"idle") then
							BasicPlayer.PlaySoundEx(self,Params.userdata,nil,1)
						else
							BasicPlayer.PlaySoundEx(self,Params.userdata)
						end
					end
				end
			else
				BasicPlayer.DoStepSound(self)
			end
		else
			BasicPlayer.DoStepSound(self)
		end
	end,
	[ScriptEvent_SelectWeapon]=function(self,Params)
		if ((self==_localplayer) and ClientStuff.vlayers:IsActive("Binoculars")) then
			ClientStuff.vlayers:DeactivateLayer("Binoculars",1)
		end
		if (not self.current_mounted_weapon) then
			self:StartAnimation(0,"weaponswitch",1)
		end
		if (self==_localplayer) then
			BasicPlayer.ProcessPlayerEffects(self)
		end
	end,
	[ScriptEvent_FireGrenade]=function(self,Params)
		local gclass=GrenadesClasses[self.cnt.grenadetype]
		if self.cnt.grenadetype==1 or self.cnt.numofgrenades>0 then
			return BasicPlayer.Client_OnFireGrenade(self,Params)
		end
	end,
	[ScriptEvent_MeleeAttack]=function(self,Params)
		--System:Log("MELEE CLIENT")
		--PLAY SOUND
		if (self.melee_sounds) then
			--System:Log("BasicPlayer.PlayOneSound(self,self.melee_sounds,100)")
			BasicPlayer.PlayOneSound(self,self.melee_sounds,101,1)
		end
		if (self.cnt.first_person) then
			if (self.cnt.weapon) then
				self.cnt.weapon:StartAnimation(0,"Melee",.1,0)
			end
		else
			self:StartAnimation(0,"amelee",0,0)
		end
	end,
	[ScriptEvent_PhysicalizeOnDemand]=BasicPlayer.PhysicalizeOnDemand,
	[ScriptEvent_StanceChange]=function(self,Params)
		BasicPlayer.PlayChangeStanceSound(self)
		--if (self.StanceChangeSound) then
		--Sound:PlaySound(self.StanceChangeSound)
		--end
	end,
	[ScriptEvent_EnterWater]=BasicPlayer.OnEnterWater,
	[ScriptEvent_Expression]=function(self,Params)
		--System:Log("ScriptEvent_Expression "..Params)
		if self.EXPRESSIONS_ALLOWED then
			self:DoRandomExpressions(self.expressionsTable[Params+1],0) -- +1 - чтоб не нуль.
			--System:Log("ScriptEvent_Expression >>>> "..self.expressionsTable[Params+1])
		else
			self:DoRandomExpressions("Scripts/Expressions/NoRandomExpressions.lua",0)
			--System:Log("ScriptEvent_Expression << not EXPRESSIONS_ALLOWED ")
		end
	end,
	[ScriptEvent_InVehicleAnimation] = function(self,Params)
		--System:Log("\001 animationg InVehicle "..Params)
		if (not self.theVehicle) then return end -- no vehicle - should not get the event
		if (self.UsingSpecialVehicleAnimation) then return end --we are playing some special vehicle anim? return.
		local inVclTabl = VC.FindUserTable(self.theVehicle,self)
		if (not inVclTabl) then
			System:Warning("ScriptEvent_InVehicleAnimation cant find user in the vehicle "..self.GetName())
			return
		end
		if (Params==self.prevInVehicleAnim) then return end
		if (self.ai and _time-inVclTabl.entertime < self.vhclATime) then return end
		if (inVclTabl.animations and inVclTabl.animations[Params]) then
			--System:Log("\001 animationg InVehicle playeing "..inVclTabl.animations[Params])
			if (Params==2) then-- hit impact has to be blended in fast
				self:StartAnimation(0,inVclTabl.animations[Params],2,.25)
			else
				self:StartAnimation(0,inVclTabl.animations[Params],2,.5)
			end
			self.prevInVehicleAnim = Params
		-- else
		end
	end,
	[ScriptEvent_Land] = function(self,Params)
		BasicPlayer.HandleLanding(self)
		BasicPlayer.DoLandSound(self)
		local onfalldamage = nil
		if not self.NoFallDamage then
			local fallDmg = Params/100
			if (fallDmg>self.FallDmgS) then
				--fallDmg = (fallDmg - self.FallDmgS)*self.FallDmgK
				if (self==_localplayer) then
					Hud.dmgindicator = bor(Hud.dmgindicator,16)
					Hud:OnMiscDamage(fallDmg*.4)
				end
				onfalldamage = 1
			end
		end
		BasicPlayer.PlayLandDamageSound(self,onfalldamage)
	end,
	[ScriptEvent_Jump]= function(self,Params)
	BasicPlayer.OnPlayerJump(self,Params)
	end,
}

function BasicPlayer:PlayPainAnimation(hit)
	if not BasicPlayer.IsAlive(self) then return end
	if hit.damage>0 and not Sound:IsPlaying(self.painSound) then
		-- MIXER: Fix stop rebreath sounds
		if (self.rebreath_snd) and (Sound:IsPlaying(self.rebreath_snd)) then
		Sound:StopSound(self.rebreath_snd) self.rebreath_snd=nil  end
		if self.cnt.underwater==0 then
			-- if not self.HeadShot then
				self.painSound = BasicPlayer.PlayOneSound(self,self.painSounds,101,1,1,1,1,1)
			-- end
		elseif (self==_localplayer) then
			local uw_painsnd = random(1,6)
			if uw_painsnd > 4 then
				if uw_painsnd==5 then
					self.painSound = Sound:LoadSound("sounds/ai/pain/pain3.wav")
				else
					self.painSound = Sound:LoadSound("sounds/ai/pain/pain4.wav")
				end
				Sound:PlaySound(self.painSound)
			end
		end
	end
	if hit.explosion then return end -- no pain ani for explosions
	if hit.shooter==self then return end -- no pain ani for falling/droving damage
	--AI and not a mutant, do pain expression.
	if self.ai and not self.MUTANT then
	-- if self.ai and (not self.MUTANT or (self.MUTANT=="fast" or self.MUTANT=="stealth" or self.MUTANT=="big")) then
		if (self.lastpainexpression==nil) then self.lastpainexpression = 0  end
		if (self.lastpainexpression<_time) then
			self:StartAnimation(0,"#full_angry_teeth",0,.05,1)
			--self:DoRandomExpressions(BasicPlayer.expressionsTable[4],0)
			self.lastpainexpression = _time + .1
		end
	end
	--if (hit.melee) then return end -- no pain ani for melee
	if self.theVehicle then return end -- no pain anim when driving
	--if (self.cnt.proning) then return end --no pain anim when prone
	local zone = self.cnt:GetBoneHitZone(hit.ipart)
	if (zone==0) then zone = 1 end
	--if ((zone==5 or zone==6) and (self.cnt.crouching or self.cnt.proning or self.theVehicle)) then return end
	local aniname = BasicPlayer.PainAnimations[zone]
	local animoffset = 1
	if (zone==2) then--torso special case
		animoffset = random(1,3)
	end
	self:StartAnimation(0,aniname..animoffset,4,.125,1.25)
	if self.ai and not self.IsAiPlayer then -- Пока такая проверка. Не знаю, как это внешне отразится на союзнике.
		local anim_dur = self:GetAnimationLength(aniname..animoffset)
		self:TriggerEvent(AIEVENT_ONBODYSENSOR,anim_dur+.500)-- account for blending times aswell Запрещает на указанное время стрелять.
	end
end

function BasicPlayer:SelectGrenade(name)
	local cyclefunc = self.Server_EventHandler[ScriptEvent_CycleGrenade]
	local currgrenade=GrenadesClasses[self.cnt.grenadetype]
	local selected
	for i,val in GrenadesClasses do
		cyclefunc(self)
		if (GrenadesClasses[self.cnt.grenadetype]==name) then
			selected=1
			break
		end
	end
	if (not selected) then
		BasicPlayer.SelectGrenade(self,currgrenade)
	end
end
-- ARMOR Helpers
function BasicPlayer:HasFullArmor()
	local state = self.cnt
	if (state==nil) then
		return nil
	end

	if (state.armor >= state.max_armor) then
		return 1
	else
		return nil
	end
end

function BasicPlayer:AddArmor(amount)
	local state = self.cnt
	if (state==nil) then
		return nil
	end
	state.armor = state.armor + amount
	local pickupAmount = amount
	local diff = state.max_armor - state.armor
	if (diff < 0) then
		pickupAmount = amount - diff
		state.armor = state.max_armor
	end
	return pickupAmount
end

-- move all ammo in the clips to the ammo stash
function BasicPlayer:EmptyClips(weaponid)
	local weaponstate = self.WeaponState
	local ammo = self.Ammo
	if (weaponstate and ammo) then
		local state = weaponstate[weaponid]
		if (state) then
			local weapontbl = getglobal(state.Name)
			for i,CurFireParameters in weapontbl.FireParams do
				if (self.Ammo[CurFireParameters.AmmoType]~=nil and state.AmmoInClip[i]~=nil) then
					self.Ammo[CurFireParameters.AmmoType] =  self.Ammo[CurFireParameters.AmmoType] + state.AmmoInClip[i]
					state.AmmoInClip[i] = 0
				end
			end
		end
		-- also do this for grenades
		ammo[GrenadesClasses[self.cnt.grenadetype]]=self.cnt.numofgrenades
	end
end


function BasicPlayer:DoProjectedGore(hit)
	if (g_gore=="0") then
		-- not to spawn too many decals
		return
	elseif (_time - self.decalTime < .5) then
		return
	end
	self.decalTime = _time
	self.cnt:GetProjectedBloodPos(hit.pos,hit.dir,"GoreDecals",5)
end

function BasicPlayer:Server_OnShutDown(hit)
	--System:Log("BasicPlayer:Server_OnShutDown "..tostring(self.id).." "..tostring(self.idUnitHighlight))
	-- release vehicle if currently using
	if (self.theVehicle) then
		VC.ReleaseUserOnShutdown(self.theVehicle,self)
	end
	-- release mounted weapon if currently using
	if (self.current_mounted_weapon) then
		self.current_mounted_weapon:AbortUse()
	end

	if self.idUnitHighlight then
		Server:RemoveEntity(self.idUnitHighlight)
	end
end


function BasicPlayer:Client_OnShutDown(hit)
	if (self.theVehicle) then
		VC.ReleaseUserOnShutdown(self.theVehicle,self)
	end
	if ((self.SwimSound) and (Sound:IsPlaying(self.SwimSound)==1)) then
		Sound:StopSound(self.SwimSound)
		self.SwimSound=nil
	end
end
-- check point and five points around to see if
-- player can stand there (no obstacles/walls)
function BasicPlayer:CanStandPos(pos)
	if (not self.cnt) then return end
	if (not self.cnt:CanStand(pos)) then
		pos.z = pos.z+.5
		if (not self.cnt:CanStand(pos)) then
			pos.x = pos.x+.5
			if (not self.cnt:CanStand(pos)) then
				pos.x = pos.x-1
				if (not self.cnt:CanStand(pos)) then
					pos.x = pos.x+.5
					pos.y = pos.y+.5
					if (not self.cnt:CanStand(pos)) then
						pos.y = pos.y-1
						if (not self.cnt:CanStand(pos)) then
							return nil
						end
					end
				end
			end
		end
	end
	return pos
end

--filippo
function BasicPlayer:PlayChangeStanceSound()
	--if (self.cnt.proning==self.lastProne) then return end
	if (self.lastStanceSound and self.lastStanceSound<_time) then
		local lightexertion = self.LightExertion
		if (lightexertion) then
			self:PlaySound(lightexertion[random(1,getn(lightexertion))],1)
		end
		self.lastStanceSound = _time + .7
		--self.lastProne = self.cnt.proning
	end
end

function BasicPlayer:PlayJumpSound()
	if (self.hasJumped==1 and self.jumpSoundPlayed==0) then
		local jumpsounds = self.JumpSounds
		if (jumpsounds) then
			self:PlaySound(jumpsounds[random(1,getn(jumpsounds))],1)
		end
		self.jumpSoundPlayed = 1
	end
end

function BasicPlayer:HandleLanding(serverside)
	--if is server side play AI sound.
	if (serverside and self.hasJumped==1) then
		local ppos = self:GetPos()
		AI:SoundEvent(self.id,ppos,BasicPlayer.soundRadius.jump,0,1,self.id)
	end
	self.hasJumped = 0
	self.jumpSoundPlayed = 0
end

function BasicPlayer:PlayerJumped()
	local pvel = self:GetVelocity()
	if (pvel.z>=1 and self.cnt.flying and self.hasJumped==0) then
		self.hasJumped = 1
		self.jumpTime = _time
	end
end

function BasicPlayer:PlayLandDamageSound(onfalldamage)
	if (onfalldamage) then
		if (not Sound:IsPlaying(self.painSound)) then
			-- if not self.HeadShot then
				self.painSound = BasicPlayer.PlayOneSound(self,self.painSounds,101,1,1,1,1,1)
			-- end
		end
	else
		local landsounds = self.LandSounds
		if (landsounds) then
			self:PlaySound(landsounds[random(1,getn(landsounds))],1)
		end
	end
end

-- when in vehicle (boat) - see if collides with sometnig - release if yes
-- do it only for boats - in cars player is inside vehicle geometry
function BasicPlayer:UpdateCollisions()
	if (not self.theVehicle) then return end
	if (not self.theVehicle.IsBoat) then return end
	local colliders = self:CheckCollisions(1)
	local used
	if (count(colliders.contacts)>0) then --colliders nil
		local vehicleTbl = VC.FindUserTable(self.theVehicle,self)
		if (vehicleTbl) then
			VC.CanGetOut(self.theVehicle,vehicleTbl)-- need this to find exit point (side or top)
			VC.ReleaseUser(self.theVehicle,vehicleTbl)
		end
	end
	do return end
end

function BasicPlayer:PlayerContact(contact,serverside)
	-- System:Log(self:GetName()..": PlayerContact")
	------------------------ PHYSPICKUP ------------------------
	-- if (contact.physpickup) and (not self.ai) then
	if contact.physpickup and not self.ANIMAL and (not self.MUTANT or (self.MUTANT=="fast" or self.MUTANT=="stealth")) then -- Боты тоже хотят иметь крутые пушки с физкой! )
		if contact.ai or not contact.Properties.Animation or not contact.Properties.Animation.Animation then return end
		AI:SoundEvent(self.id,self:GetPos(),3,.5,.5,self.id)
		if contact.PhysPickTouched then
			-- Mixer: huge part of code is moved to PickupPhysCommon.lua
			if (contact.pp_lastdrop and contact.pp_lastdrop > _time) or self.NotAllowPickUpInArea then -- Временное решение.
				self.NotAllowPickUpInArea = _time
				return
			end
			contact:PhysPickTouched(self)
		end
		return
	end
	------------------------------------------------------------

	--player is pressing use key?
	if (not self.cnt.use_pressed) then return end
	--AI dont push
	if (self.ai) then return end -- ИИ не жмёт на кнопки, чтобы толкать лодки в воду. А как понять тогда трюк с канатным тросом?
	--dont push client-side if is not MP
	if (serverside==0) then
		if (not Game:IsMultiplayer() or self==_localplayer) then return end
	end
	--push rate cap
	if (serverside==1) then
		if (self.nextPush and self.nextPush > _time) then return end
	else
		if (self.nextPush_Client and self.nextPush_Client > _time) then return end
	end
	--Mixer: place your usable entities func here!
	local pushpower = 90
	--if canbepushed exist it can return 3 possible values: nil (cant be pushed),-1 (can be pushed with the player push power),n > 0 (a custom push power,boats use this)
	if (contact.CanBePushed) then
		local power = contact:CanBePushed()
		if (power==nil) then return end
		if (power>0) then pushpower = power  end
	else
		--there is no CanBepushed func,so return  if we want player push everything just comment the "return" or create some CanBepushed function to the entities that can be pushed.
		return
	end
	local ppos = self.tempvec
	merge(ppos,self:GetPos())
	ppos.z = ppos.z + 1
	if (not PointInsideBBox(ppos,contact,1)) then return end
	local impdir = self:GetDirectionVector()
	local bias = .3
	--if player is looking down use a less push power
	if (impdir.z < -bias) then
		pushpower = pushpower * (1+bias+impdir.z)
	end
	--in any case push the entity a bit up
	if (impdir.z<.8) then impdir.z = .8  end
	--FIXME: use a better impulse start position,now its the center of the entity
	--contact:AddImpulse(-1,ppos,impdir,pushpower)
	contact:AddImpulseObj(impdir,pushpower)
	--add a .3 sec delay between a push and the next
	if (serverside==1) then
		self.nextPush = _time + .3
	else
		self.nextPush_Client = _time + .3
	end
end

function BasicPlayer:OnPlayerJump(Params)
	if (self.ai) then
		BasicAI.DoJump(self,Params)
	end
end
--this function play the "go back" vehicle animation if the player is looking in the opposite direction of the vehicle.
function BasicPlayer:DoSpecialVehicleAnimation()
	--ai dont have to deal with this stuff.
	if (self.ai) then return end
	local dir = self.tempvec
	CopyVector(dir,self:GetDirectionVector(0))
	local vdir = self.theVehicle:GetDirectionVector(0)
	local dot = dotproduct3d(dir,vdir)
	--player is looking back
	if (dot > .3) then
		--6 is the index pos for the "go back" animation in the vehicle table.
		local animidx = 6
		if (self.prevInVehicleAnim~=animidx) then
			local inVclTabl = VC.FindUserTable(self.theVehicle,self)
			if (inVclTabl==nil) then return end
			if (inVclTabl.animations==nil) then return end
			local anim = inVclTabl.animations[animidx]
			if (anim) then
				self:StartAnimation(0,anim,2,.5)
			end
			self.prevInVehicleAnim = animidx
		end
		self.UsingSpecialVehicleAnimation = 1
	else
		self.UsingSpecialVehicleAnimation = nil
	end
end

function BasicPlayer:OnSaveOverall(stm)
	-- System:Log(self:GetName()..": OnSaveOverall")
	if (self.current_mounted_weapon) then
		stm:WriteInt(self.current_mounted_weapon.id)
	else
		stm:WriteInt(0)
	end
	if (self.theRope) then
		stm:WriteInt(self.theRope.id)
	else
		stm:WriteInt(0)
	end
end

function BasicPlayer:OnLoadOverall(stm)
	-- System:Log(self:GetName()..": OnLoadOverall")
	local mntWeaponId = stm:ReadInt()
	self.current_mounted_weapon = System:GetEntity(mntWeaponId)
	if (self.current_mounted_weapon and self.current_mounted_weapon.SetGunner) then
		self.current_mounted_weapon:SetGunner(self)
	end
	local theRope = stm:ReadInt()
	self.theRope = System:GetEntity(theRope)
	if (self.theRope) then
		self.theRope.state = 0
		self.theRope:GoDown()
		self.theRope:DropTheEntity(self,1)
	end
end