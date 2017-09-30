Script:ReloadScript("Scripts/Default/Entities/AI/AISounds/sound_tables.lua");
Script:ReloadScript("Scripts/Default/Entities/AI/AISounds/keyframes.lua");
Script:ReloadScript("Scripts/Default/Entities/AI/AISounds/jumps.lua");
BasicAI = {
	ai=1,
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

	lastMeleeAttackTime = 0,

	isBlinded = 0,

  iLastWaterSurfaceParticleSpawnedTime = _time,
  Energy = 50,
	MaxEnergy = 100,
	EnergyChanged = nil,



	sound_jump = 0,
	sound_death = 0,
	sound_land = 0,
	sound_pain = 0,

	vLastPos = { x=0, y=0, z=0 },
	fLastRefractValue = 0,
	bSplashProcessed = nil,


	WeaponState = nil,

	-- Reloading related

	C_Reloading = nil,			-- Just to check when ammo = 0 if we already started client side FX
	C_LastReloadTriggered = 0,

	-- More complex server variables to keep reload procedure running for the right amount of time
	S_LastReloadTriggered = 0,
	S_Reloaded = 0,
	S_Reloading = nil,

	S_FireModeChangeSeqTriggered = 0,
	C_FireModeChangeSeqTriggered = 0,

	S_WeaponActivated = 0,
	C_WeaponActivated = 0,

	S_LastGrenadeThrow = 0,
	C_LastGrenadeThrow = 0,

	soundtimer = 0,

	Behaviour = {
	},

	temp_ModelName = "",

--	Boredom = 0,
}

function BasicAI:OnPropertyChange()
	System:LogToConsole("prev:"..self.temp_ModelName.." new:"..self.Properties.fileModel);

	if (self.Properties.fileModel ~= self.temp_ModelName) then
		--self:CreateLivingEntity(self.PhysParams);
		self:LoadCharacter(self.Properties.fileModel,0);
		self.temp_ModelName = self.Properties.fileModel;
		local nMaterialID=Game:GetMaterialIDByName("mat_meat");
		self:PhysicalizeCharacter(self.PhysParams.mass, nMaterialID, self.BulletImpactParams.stiffness_scale, 0);
		self:SetCharacterPhysicParams(0,"", PHYSICPARAM_SIMULATION,self.BulletImpactParams);
	end
end

function BasicAI:StopConversation()
	
	if (self.CurrentConversation) then
		self.CurrentConversation:Stop(self);
		self:StopDialog();
		self.CurrentConversation = nil;
	end
end

-----------------------------------------------------------------------------------------------------
function BasicAI:OnReset()

	self.Enemy_Hidden = 0;

	self:NetPresent(1);
	self.PLAYER_ALREADY_SEEN = nil;
	self.DODGING_ALREADY  = nil;
	self.POTSHOTS = 0;
	self.EXPRESSIONS_ALLOWED = 1;
	self:SetScriptUpdateRate(self.UpdateTime);

	self.AI_PlayerEngaged = nil;
	self.AI_ALARMNAME = nil;
	self.RunToTrigger = nil;

	if (AI_ANIM_KEYFRAMES[self.Properties.KEYFRAME_TABLE]) then 
		self.SoundEvents = AI_ANIM_KEYFRAMES[self.Properties.KEYFRAME_TABLE].SoundEvents;
	end

	if (self.Properties.JUMP_TABLE) then
		if (AI_JUMP_KEYFRAMES[self.Properties.JUMP_TABLE]) then
			self.JumpSelectionTable = AI_JUMP_KEYFRAMES[self.Properties.JUMP_TABLE];
		end
	end


	if( self.OnResetCustom ) then
	 self:OnResetCustom();
	end 

	self.AI_GunOut = 1;

	self:StopConversation();

	if (self.Properties.ImpulseParameters) then 
		for name,value in self.Properties.ImpulseParameters do
			self.ImpulseParameters[name] = value;
		end
	end



	BasicPlayer.OnReset(self);

	if (self.AI_DynProp) then
		if ((self.Properties.bPushPlayers~=nil) and (self.Properties.bPushedByPlayers~=nil)) then 
			self.AI_DynProp.push_players = self.Properties.bPushPlayers;
			self.AI_DynProp.pushable_by_players = self.Properties.bPushedByPlayers;
		end

		self.cnt:SetDynamicsProperties( self.AI_DynProp );
	end


	self.isBlinded = 0;	

	
	self.CurrentConversation = nil;

	self.cnt:CounterSetValue("Boredom", 0 );
	
	self.lastMeleeAttackTime = 0;

	self.cnt:SetAISpeedMult( self.Properties.speed_scales );
	
	--randomize only if the AI is using a voicepack.
	if (self.Properties.SoundPack and self.Properties.SoundPack~="") then
		self.Properties.SoundPack = SPRandomizer:GetHumanPack(self.PropertiesInstance.groupid,self.Properties.SoundPack);
		--System:Log(sprintf("%s using %s",self:GetName(),self.Properties.SoundPack));
	end
	
	AI:RegisterWithAI(self.id, AIOBJECT_PUPPET, self.Properties, self.PropertiesInstance);
	self.cnt.health = self.Properties.max_health * getglobal("game_Health");


	BasicPlayer.InitAllWeapons(self);
	
	if (self.Properties.bSleepOnSpawn == 1) then
		self:TriggerEvent(AIEVENT_SLEEP);
	end
	
	BasicPlayer.HelmetOff(self);
	
	if (self.PropertiesInstance.bHelmetOnStart) then
		if(self.PropertiesInstance.bHelmetOnStart == 1) then
			if(self.PropertiesInstance.fileHelmetModel ~= "") then
				self:LoadObject( self.PropertiesInstance.fileHelmetModel,0,0);
				if (self.Properties.AttachHelmetToBone) then
					self:AttachObjectToBone( 0, self.Properties.AttachHelmetToBone, 0, 1  );
				else 
					self:AttachObjectToBone( 0, "hat_bone", 0, 1  );
				end
			end
			BasicPlayer.HelmetOn(self);
		end
	else
		if(self.Properties.bHelmetOnStart == 1) then
			if(self.Properties.fileHelmetModel ~= "")	then
				self:LoadObject( self.Properties.fileHelmetModel,0,0);
				if (self.Properties.AttachHelmetToBone) then
					self:AttachObjectToBone( 0, self.Properties.AttachHelmetToBone, 0, 1  );
				else 
					self:AttachObjectToBone( 0, "hat_bone", 0, 1  );
				end
			end	
			BasicPlayer.HelmetOn(self);
		end
	end

	if (self.PropertiesInstance.bHasLight==1) then
		self.cnt:GiveFlashLight(1);
		self.cnt:SwitchFlashLight(1);
	else
		self.cnt:SwitchFlashLight(0);
	end


	if (self.Properties.bHasShield) then
		if (self.Properties.bHasShield==1) then
			self:LoadObject( "Objects\\characters\\mercenaries\\accessories\\shield.cgf",1,1);
			self:AttachObjectToBone( 1, "Bip01 L Hand" );
		end
	end


	
	if (self.Behaviour["OnSpawn"]) then
		self.Behaviour:OnSpawn(self);
	else
		if (AIBehaviour[self.DefaultBehaviour]) then 
			if (AIBehaviour[self.DefaultBehaviour].OnSpawn) then 
				AIBehaviour[self.DefaultBehaviour]:OnSpawn(self);
			end
		end
	end

	self.groupid = self.PropertiesInstance.groupid;

	if (self.AI_NAME) then 
		self:SetAIName(self.AI_NAME);
	else
		self:SetAIName(self:GetName());
	end

	self.melee_damage = self.Properties.fMeleeDamage;

	if (self.PropertiesInstance.fScale) then 
		self:SetStatObjScale(self.PropertiesInstance.fScale);
	end

	if (AI_SOUND_TABLES[self.Properties.SOUND_TABLE]) then
		self.painSounds = AI_SOUND_TABLES[self.Properties.SOUND_TABLE].painSounds;
		self.deathSounds = AI_SOUND_TABLES[self.Properties.SOUND_TABLE].deathSounds;
		self.chattersounds = AI_SOUND_TABLES[self.Properties.SOUND_TABLE].chattersounds;
		self.breathSounds = AI_SOUND_TABLES[self.Properties.SOUND_TABLE].breathSounds;
		--jump&land sounds
		self.jumpsounds = AI_SOUND_TABLES[self.Properties.SOUND_TABLE].jumpsounds;
		self.landsounds = AI_SOUND_TABLES[self.Properties.SOUND_TABLE].landsounds;
		--custom footstep sounds
		self.footstepsounds = AI_SOUND_TABLES[self.Properties.SOUND_TABLE].footstepsounds;
		
		if (self.footstepsounds) then
			self.footsteparray = {0,0,0};
			self.footstepcount = 1;
		end
	end




	AI:DeCloak(self.id);

	-- count melee animations and special fire animations for this enemy - if applicable
	self.MELEE_ANIM_COUNT = self:DiscoverAnimationCount("attack_melee",1,1);
	self.SPECIAL_FIRE_COUNT = self:DiscoverAnimationCount("fire_special",2,0);
	self.COMBAT_IDLE_COUNT = self:DiscoverAnimationCount("combat_idle",2,0);
	self.BLINDED_ANIM_COUNT = self:DiscoverAnimationCount("blind",2,0);
	self.DRAW_GUN_ANIM_COUNT = self:DiscoverAnimationCount("draw",2,1);
	self.HOLSTER_GUN_ANIM_COUNT = self:DiscoverAnimationCount("holster",2,1);

	self.Properties.LEADING_COUNT = -1;
	self.LEADING = nil;

	-- now the same for special fire animations

	BasicAI.SetSmoothMovement(self);
	
	self.NextChatterSound = 0;
	
	self.LastJumpSound = nil;
	self.LastLandSound = nil;
end

function BasicAI:DiscoverAnimationCount( base_name, num_digits, start_value)

	local formatstring = base_name.."%0"..num_digits.."d";

	local num_found = 0;
	local count = start_value;
	local formatted_name = format(formatstring,count);
	while (self:GetAnimationLength(formatted_name)~=0) do
		num_found = num_found + 1;
		count = count+1;
		formatted_name = format(formatstring,count);
	end

	if (num_found>0) then
		return num_found
	else
		return nil
	end
end


function BasicAI:DoChatter()

	-- HACK: the isplaying function returns nil if the sound
	-- is not playing, not 0, so this condition below actually never passes;
	-- but if done correctly, for some reason the AI chatter will create millions 
	-- of 3d AI chatter sounds and eventually
	-- crash the game running out of memory - never enable it!

	-- [Petar] Please next time when you spend time fixing something, make sure that it is fixed at the end of that time.
	-- This is now fixed.

	--filippo:play chatter sound every ~1-2 seconds, the is already a random chance in playonesound func.
	if (self.NextChatterSound > _time) then return; end
	self.NextChatterSound = _time + random(100,200)*0.01;

	if (Sound:IsPlaying(self.chattering_on)==nil) then
		self.chattering_on = nil;
	end
		
	if (self.chattering_on==nil and self.chattersounds) then
		--local rnd=random(1,10);
		--if (rnd>8) then 
			self.chattering_on = BasicPlayer.PlayOneSound(self,self.chattersounds,50);--20);
			
			--if (self.chattering_on) then
			--	Hud:AddMessage(self:GetName().." doing chatter sounds");
			--end
		--end
	end
end

-----------------------------------------------------------------------------------------------------
function BasicAI:Event_Activate( params )


	self:EnableUpdate(1);
	self:TriggerEvent(AIEVENT_WAKEUP);

	
	if (self.Behaviour.OnActivate) then
		self.Behaviour:OnActivate(self);
	elseif (self.DefaultBehaviour and AIBehaviour[self.DefaultBehaviour].OnActivate) then
		AIBehaviour[self.DefaultBehaviour]:OnActivate(self);
	end

	
	BroadcastEvent(self, "Activate");
end



function BasicAI:Event_Die(params)
	if (self.cnt.health > 0) then 
		local	hit = {
			dir = {x=0, y=0, z=1},
			damage = 10000,
			target = self,
			shooter = self,
			landed = 1,
			impact_force_mul_final=5,
			impact_force_mul=5,
			damage_type = "normal",
			};
		self:Damage( hit);
	end
	BroadcastEvent(self, "Die");
end

function BasicAI:Event_Ressurect(params)
	if (self.cnt.health <= 0) then 
		self.wasreset = nil;
		self.bAllWeaponsInititalized = nil;
		self:OnReset();
		self:TriggerEvent(AIEVENT_WAKEUP);
		self:TriggerEvent(AIEVENT_ENABLE);
	end
	BroadcastEvent(self, "Ressurect");
end

function BasicAI:Event_Follow(params)
	self:RestoreDynamicProperties();
	AI:MakePuppetIgnorant(self.id,0);
	AI:Signal(0,0,"SPECIAL_FOLLOW",self.id)
	BroadcastEvent(self, "Follow");
end

function BasicAI:Event_StopSpecial(params)
	self:RestoreDynamicProperties();
	AI:MakePuppetIgnorant(self.id,0);
	AI:Signal(0,0,"SPECIAL_STOPALL",self.id)
	BroadcastEvent(self, "StopSpecial");
end

function BasicAI:Event_DisablePhysics(params)
	self:EnablePhysics(0);
	BroadcastEvent(self, "DisablePhysics");
end

function BasicAI:Event_EnablePhysics(params)
	self:EnablePhysics(1);
	BroadcastEvent(self, "EnablePhysics");
end

function BasicAI:Event_SPECIAL_ANIM_START(params)
	BroadcastEvent(self, "SPECIAL_ANIM_START");
end


function BasicAI:Event_Hide(params)
	self.Enemy_Hidden = 1;
	self:DrawCharacter(0,0);
	self.Properties.bAffectSOM = 0;
	self:TriggerEvent(AIEVENT_WAKEUP);
	self:TriggerEvent(AIEVENT_DISABLE);
	self:EnablePhysics(0);
	BroadcastEvent(self, "Hide");
end

function BasicAI:Event_UnHide(params)
	self.Enemy_Hidden = 0;
	self:DrawCharacter(0,1);
	self.Properties.bAffectSOM = 1;
	self:TriggerEvent(AIEVENT_ENABLE);
	self:EnablePhysics(1);
	BroadcastEvent(self, "UnHide");
end


function BasicAI:Event_HoldSpot(params)
	self:RestoreDynamicProperties();
	AI:MakePuppetIgnorant(self.id,0);
	AI:Signal(0,0,"SPECIAL_HOLD",self.id)
	BroadcastEvent(self, "HoldSpot");
end

function BasicAI:Event_Lead(params)
	self:RestoreDynamicProperties();
	AI:MakePuppetIgnorant(self.id,0);
	AI:Signal(0,0,"SPECIAL_LEAD",self.id)
	BroadcastEvent(self, "Lead");
end

function BasicAI:Event_GoDumb(params)

	AI:MakePuppetIgnorant(self.id,0);
	AI:Signal(0,0,"SPECIAL_GODUMB",self.id)
	--self:SelectPipe(0,"dumb_wrapper");

	BroadcastEvent(self, "GoDumb");
end

function BasicAI:RestoreDynamicProperties()
	if (self.AI_DynProp) then
		if ((self.Properties.bPushPlayers~=nil) and (self.Properties.bPushedByPlayers~=nil)) then 
			self.AI_DynProp.push_players = self.Properties.bPushPlayers;
			self.AI_DynProp.pushable_by_players = self.Properties.bPushedByPlayers;
		end

		self.cnt:SetDynamicsProperties( self.AI_DynProp );
	end

end



function BasicAI:Event_HalfHealthLeft(params)
	BroadcastEvent(self, "HalfHealthLeft");
end




function BasicAI:Event_Relocate( params)
	
	local point = Game:GetTagPoint(self:GetName().."_RELOCATE");
	if (point) then 
		self:SetPos({x=point.x,y=point.y,z=point.z});
	else
		System:Warning( "Entity "..self:GetName().." received a relocate event but has no relocate tagpoint");
	end
	BroadcastEvent(self, "Relocate");
end

function BasicAI:Event_DeActivate( params )

	if (self.Behaviour.OnDeactivate) then
		self.Behaviour:OnDeactivate(self);
	elseif (AIBehaviour[self.DefaultBehaviour].OnDeactivate) then
		AIBehaviour[self.DefaultBehaviour]:OnDeactivate(self);
	end

	self:TriggerEvent(AIEVENT_SLEEP);

	BroadcastEvent(self, "DEActivate");
end

-----------------------------------------------------------------------------------------------------
function BasicAI:Event_OnDeath( params )
	BroadcastEvent(self, "OnDeath");
end

-----------------------------------------------------------------------------------------------------
function BasicAI:Event_MakeVulnerable( params )
	self.Properties.bInvulnerable = 0;
	BroadcastEvent(self, "MakeVulnerable");
end

-----------------------------------------------------------------------------------------------------
function BasicAI:Event_LastGroupMemberDied( params )
	BroadcastEvent(self, "LastGroupMemberDied");
end

--------------
function BasicAI:Event_AcceptSound( sender )
	if (sender) then 
		if (sender.type == "SoundSpot") then
			
			self.ACCEPTED_SOUND = {};
			self.ACCEPTED_SOUND.soundFile = sender.Properties.sndSource;
			self.ACCEPTED_SOUND.Volume = sender.Properties.iVolume;
			self.ACCEPTED_SOUND.min = sender.Properties.InnerRadius;
			self.ACCEPTED_SOUND.max = sender.Properties.OuterRadius;
	
			self:Say(self.ACCEPTED_SOUND);		
		else
			--System:LogToConsole("\001 NOT A SOUND "..sender.type);
		end
	end
	BroadcastEvent(self, "AcceptSOund");
end


--------------------------------------------------------------------------------------------------------
function BasicAI:RegisterStates()
	self:RegisterState( "Alive" );
	self:RegisterState( "Dead" );
end



--------------------------------------------------------------------------------------------------------
function BasicAI:Server_OnInit()

	if( self.OnInitCustom ) then
	 self:OnInitCustom();
	end 

	self:LoadCharacter(self.Properties.fileModel,0);
	self.temp_ModelName = self.Properties.fileModel;
	
--	self:LoadObject( "Objects/characters/mercenaries/accessories/helmet.cgf", 0, 1 );

	BasicPlayer.Server_OnInit( self );

	if (NameGenerator) then
		self.AI_NAME = NameGenerator:GetHumanName();
	end

	self:OnReset();

	self.cnt:CounterAdd("Boredom", .1 );
	self.cnt:CounterSetEvent("Boredom", 1, "OnBored" );


end

--------------------------------------------------------------------------------------------------------
function BasicAI:Client_OnInit()
	self:LoadCharacter(self.Properties.fileModel,0);
	BasicPlayer.Client_OnInit( self );

	if(self.Properties.bHasLight==1) then
		self.cnt.light = 1;
	end


end

--------------------------------------------------------------------------------------------------------
function BasicAI:Client_OnShutDown()
	BasicPlayer.OnShutDown( self );
	-- Free resources
end


--------------------------------------------------------------------------------------------------------
--
--
--------------------------------------------------------------------------------------------------------
--
--//DMG_HEAD		1
--//DMG_TORSO		2
--//DMG_ARM		3
--//DMG_LEG		4
--//DMG_DEFAULT		2



--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

function BasicAI:OnSaveOverall(stm)
	BasicPlayer.OnSaveOverall(self, stm);
end

--------------------------------------------------------------------------------------------------------------

function BasicAI:OnLoadOverall(stm)
	BasicPlayer.OnLoadOverall(self, stm);
end

--------------------------------------------------------------------------------------------------------
-------------------------------------------------------
function BasicAI:OnLoad(stm)
	BasicPlayer.OnLoad(self,stm);
	self.Properties.LEADING_COUNT = stm:ReadInt();

	-- by request of Sten, special AI are regenerated when loaded
	if (self.Properties.special == 1) then 
		self.cnt.health = self.Properties.max_health;
	end

	local special_behaviour = stm:ReadString();

	if (special_behaviour ~= "NA" ) then
		self.AI_SpecialBehaviour = special_behaviour;
		self:TriggerEvent(AIEVENT_CLEARSOUNDEVENTS);
		AI:Signal(0,1,self.AI_SpecialBehaviour,self.id);
	end
	
	BasicAI.SetSmoothMovement(self);

	self.Enemy_Hidden = stm:ReadInt();
	if (self.Enemy_Hidden == 1) then 
		self:Event_Hide();
	end
end

--------------------------------------------------------------------------------------------------------
-------------------------------------------------------
function BasicAI:OnLoadRELEASE(stm)
	BasicPlayer.OnLoad(self,stm);
	self.Properties.LEADING_COUNT = stm:ReadInt();

	-- by request of Sten, special AI are regenerated when loaded
	if (self.Properties.special == 1) then 
		self.cnt.health = self.Properties.max_health;
	end

	local special_behaviour = stm:ReadString();

	if (special_behaviour ~= "NA" ) then
		self.AI_SpecialBehaviour = special_behaviour;
		self:TriggerEvent(AIEVENT_CLEARSOUNDEVENTS);
		AI:Signal(0,1,self.AI_SpecialBehaviour,self.id);
	end
	
	BasicAI.SetSmoothMovement(self);
end


--------------------------------------------------------------------------------------------------------
-------------------------------------------------------
function BasicAI:OnSave(stm)
	BasicPlayer.OnSave(self,stm);
	if (self.Properties.LEADING_COUNT) then
		stm:WriteInt(self.Properties.LEADING_COUNT);
	end

	if (self.AI_SpecialBehaviour) then
		stm:WriteString(self.AI_SpecialBehaviour);
	else
		stm:WriteString("NA");
	end

	stm:WriteInt(self.Enemy_Hidden);

end

--------------------------------------------------------------------------------------------------------

function BasicAI:CheckFlashLight()

	if (self.Properties.special == 1) then 
		do return end
	end

	local name = AI:FindObjectOfType(self.id,2,AIAnchor.AIANCHOR_FLASHLIGHT);
	
	if (name) then 
		self:InsertSubpipe(0,"flashlight_investigate",name);
	end
end


function BasicAI:MakeMissionConversation()

	if (self.Properties.special == 1) then 
		do return end
	end

	local name = AI:FindObjectOfType(self.id,3,AIAnchor.MISSION_TALK_INPLACE);

	if (name) then
		if (self.CurrentConversation == nil) then
			self.CurrentConversation = AI_ConvManager:GetRandomCriticalConversation(name,1);
			if (self.CurrentConversation) then
				self.CurrentConversation:Join(self);
				AI:Signal(SIGNALFILTER_NEARESTGROUP,0,"CONVERSATION_REQUEST_INPLACE",self.id);
				return 1
			end
		end
	end


	name = AI:FindObjectOfType(self.id,3,AIAnchor.AIANCHOR_MISSION_TALK);

	if (name) then
		if (self.CurrentConversation == nil) then
			self.CurrentConversation = AI_ConvManager:GetRandomCriticalConversation(name);
			if (self.CurrentConversation) then
				self.CurrentConversation:Join(self);
				AI:Signal(SIGNALFILTER_NEARESTGROUP,0,"CONVERSATION_REQUEST",self.id);
				return 1
			end
		end
	end
	return nil

end



function BasicAI:MakeRandomConversation()

	if (self.Properties.special == 1) then 
		do return end
	end


	local name = AI:FindObjectOfType(self.id,2,AIAnchor.AIANCHOR_RANDOM_TALK);

	if (name) then
		if (self.CurrentConversation == nil) then
			self.CurrentConversation = AI_ConvManager:GetRandomIdleConversation();
			if (self.CurrentConversation) then
				self.CurrentConversation:Join(self);
				AI:Signal(SIGNALFILTER_NEARESTGROUP,1,"CONVERSATION_REQUEST",self.id);
				return 1
			end
		end
	end
	return nil

end

function BasicAI:RushTactic( probability)

	if (self.Properties.fRushPercentage) then 
		if (self.Properties.fRushPercentage>0) then
			local percent = self.cnt.health / self.Properties.max_health;
			if (percent<self.Properties.fRushPercentage) then
				local rnd=random(1,10);
				if (rnd>probability) then
					AI:Signal(SIGNALFILTER_SUPERGROUP,1,"RUSH_TARGET",self.id);
					AI:Signal(SIGNALID_READIBILITY, 1, "LO_RUSH_TACTIC",self.id);
				end
			end
		end
	end
end

--------------------------------------------------------------------------------------------------------
BasicAI.Server =
{
	OnInit = BasicAI.Server_OnInit,
	OnShutdown = function( self ) end,
	Alive = {
--		OnTimer = BasicPlayer.Server_OnTimer,
		OnUpdate = BasicPlayer.Server_OnTimer,
		OnBeginState = function( self )
		end,
		OnEndState = function( self )
		end,
--		OnUpdate = BasicAI.OnUpdate,
		OnEvent = BasicPlayer.Server_OnEvent,
		OnDamage = function (self, hit)

			if (self.Properties.fDamageMultiplier) then 
				hit.damage = hit.damage * self.Properties.fDamageMultiplier;
			end


--			if (game_AI_Invulnerable == 0 ) then 
				if (self.Properties.bInvulnerable~=nil) then				
					if (self.Properties.bInvulnerable~=1) then				
						BasicPlayer.Server_OnDamage( self, hit);	
					end
				else
					BasicPlayer.Server_OnDamage( self, hit);	
				end
--			end
		
			if (self.Behaviour.OnKnownDamage and hit.shooter~=nil) then
				self.Behaviour:OnKnownDamage(self,hit.shooter);
			else
				AI:Signal(0,1,"OnReceivingDamage",self.id);
			end

			if (self.LastDamageDoneByPlayer) then

				if (hit.damage_type == "normal" and hit.explosion == nil and hit.fire == nil and hit.drowning == nil) then 
					AI:RegisterPlayerHit();
				end
			end

			local dmg_percent = self.cnt.health / self.Properties.max_health; 
			if (dmg_percent<0.5) then
				self:Event_HalfHealthLeft();
			end

			self:RushTactic(5);
		

		end,
	},
	Dead = {
		OnBeginState = function( self )
			self:StopConversation();
			
			local dir = self.deathImpuls;
			NormalizeVector(dir);
			if ((dir.z<0.15) and (dir.z>-0.2)) then
				dir.z = 0.15;
			end
			--self:AddImpulse(1,self:GetCenterOfMassPos(),dir,self.deathImpulseTorso);			
			self:AddImpulse(1,{0,0,0},dir,self.deathImpulseTorso);


			-- used for Autobalancing
			if (self.LastDamageDoneByPlayer) then
				self:TriggerEvent(AIEVENT_DROPBEACON);
				self:TriggerEvent(AIEVENT_AGENTDIED,1);
			else
				self:TriggerEvent(AIEVENT_AGENTDIED);
			end

			self.LAST_SHOOTER = nil;

			AI:Signal(SIGNALFILTER_ANYONEINCOMM,1,"RESUME_SPECIAL_BEHAVIOUR",self.id);


			self:Event_OnDeath();

			if (AI:FindObjectOfType(self.id,40,AIAnchor.RETREAT_WHEN_HALVED)) then
				AI:Signal(SIGNALFILTER_HALFOFGROUP,1,"RETREAT_NOW",self.id);
			end


			-- call the behaviour one last time :(
			if (self.Behaviour.OnDeath) then
				self.Behaviour:OnDeath(self);
			else
				if (AIBehaviour[self.DefaultBehaviour]) then
					if (AIBehaviour[self.DefaultBehaviour].OnDeath) then
						AIBehaviour[self.DefaultBehaviour]:OnDeath(self);
					else
						AIBehaviour.DEFAULT:OnDeath(self);
					end
				end
			end

	
			AI:DeCloak(self.id);

			if (self.AI_ParticleHandle) then
				Particle:Detach(self.id,self.AI_ParticleHandle);
			end

			if (AI:GetGroupCount(self.id) == 0) then
				self:Event_LastGroupMemberDied();
			end						

			self:RushTactic(8);


			BasicAI.Drop(self, self.Properties.equipDropPack);
--			self:Drop(self.Properties.equipDropPack);
			self:SetTimer(self.UpdateTime);
			
			self:NetPresent(nil);
		end,
		OnEvent = BasicPlayer.Server_OnEventDead,
		OnDamage = function (self, hit)
			BasicPlayer.Server_OnDamageDead( self, hit);
		end,
		OnEndState = function( self )
		end,
	},
}

--------------------------------------------------------------------------------------------------------
BasicAI.Client =
{
	OnInit = BasicAI.Client_OnInit,
--	OnShutdown = Player.Client_OnShutDown,
	Alive = {
--		OnTimer = BasicPlayer.Client_OnTimer,
		OnUpdate = BasicPlayer.Client_OnTimer,		
		OnBeginState = function( self )
--			if( self== _localplayer) then
--				Input:SetActionMap("default");
				self.AnimationSystemEnabled = 1;
				self:EnablePhysics(1);
--			end

			-- init local stuff on client
			BasicPlayer.OnBeginAliveState(self);

		end,
		OnEndState = function( self )
		end,

		-- Just temporary
		-- Needed cause the BasicWeapon client update wouldn't be called otherwise.
		-- Since the ending of the client side reloading state is detected there, the
		-- client would never stop reloading, so no more client side effects (sounds, trails)
		-- would be played. Keep until these things are removed from the OnUpdate()
--		OnUpdate = function(self, DeltaTime)
--			BasicPlayer.Client_OnUpdate(self, DeltaTime);
--		end,

		OnDamage = function (self, hit)
			if( self.OnDamageCustom ) then
				self:OnDamageCustom();
			end
 			BasicPlayer.Client_OnDamage(self, hit);
--			AI:Signal(SIGNALID_READIBILITY, 1, "PAIN",self.id);
--			BasicPlayer.SetDeathImpulse( self, hit );
		end,
		OnEvent = BasicPlayer.Client_OnEvent,
	},
	Dead = {
		OnBeginState = function( self )
			BasicPlayer.MakeDeadbody(self);
			self.cnt.health=0;		-- server might not send this info
		
			--stop chatter/jump/land sounds when die
			BasicAI.StopSounds(self);

			-- stop any readibility
			self:StopDialog();
		
			-- setup local stuff on client
			BasicPlayer.OnBeginDeadState(self);

			if( self.OnDamageCustom ) then
				self:OnDamageCustom();
			end
			

			-- [marco] reward the player when he makes something cool with a gun			
			-- first of all check if it was really the player to kill the AI
			if (0 and self.shooter and self.shooter==_localplayer) then
			-- if (self.shooter and self.shooter==_localplayer) then

				-- check for a headshot	
				if (self.headshot and self.headshot==1) then
					--System:Log("HEADSHOT");	

					if (not self.shooter.numshots) then
						--System:Log("numshots 0");	
						self.shooter.numshots=0;
					else
						self.shooter.numshots=self.shooter.numshots+1;
						if (self.shooter.numshots>20) then
							self.shooter.numshots=0;
						end
						--System:Log("numshots.."..self.shooter.numshots);	
					end
					
					if (self.sndHeadShotComment and self.shooter.numshots==0) then
						Sound:PlaySound(self.sndHeadShotComment);
					end
				end
				coomentedout=[[
				else 
				-- check for a long distance shot
					local vPos1=new(self.shooter:GetPos());
					--System:Log("pos1="..vPos1.x..","..vPos1.y..","..vPos1.z);
					local vPos2=new(self:GetPos());
					--System:Log("pos2="..vPos2.x..","..vPos2.y..","..vPos2.z);
					local diff=DifferenceVectors(vPos1,vPos2);									
					--System:Log("diff="..diff.x..","..diff.y..","..diff.z);
					local distfromshooter=LengthSqVector(diff);
					--System:Log("DISTANCE="..distfromshooter);
					if (distfromshooter>100*100) then
						--System:Log("VERY LONG DISTANCE SHOT, 200+ METERS!");							
						if (self.sndFarDistanceShotComment) then
							Sound:PlaySound(self.sndFarDistanceShotComment);
						end						
					else
						if (distfromshooter>60*60) then
							--System:Log("LONG DISTANCE SHOT, 120+ METERS!");
							if (self.sndLongDistanceShotComment) then
								Sound:PlaySound(self.sndLongDistanceShotComment);
							end
						end
					end
				end
				]]
			end

			-- Release trigger when dying
			local Weapon = self.cnt.weapon;
			if (Weapon) then
				local WeaponStateData = GetPlayerWeaponInfo(self);
				local FireModeNum = WeaponStateData.FireMode;
				local CurFireParams = Weapon.FireParams[FireModeNum];
				if (CurFireParams.FireOnRelease ~= 1) then
					local Params =  {};
					Params["shooter"] = self;
					Params["fire_event_type"] = 2;
					BasicWeapon.Client_OnFire(Weapon, Params);
				end
			end


			if (self.cnt.health < 1) then

				--self.WeaponState = nil;
				--System:Log("------------------------------------> Cleared Sounds !");

				--System:Log("------------------------------------> StopFireLoop Called !");
				local CurWeaponInfo = self.weapon_info;
				if (CurWeaponInfo) then
					local CurFireMode = CurWeaponInfo.FireMode;
					local CurWeapon = self.cnt.weapon;
					local CurFireParams;
					if (CurWeapon) then
						CurFireParams = CurWeapon.FireParams[CurFireMode];
					end
					local SoundData = CurWeaponInfo.SndInstances[CurFireMode];
					BasicWeapon.StopFireLoop(CurWeapon, self, CurFireParams, SoundData);
				end
			end
			self:SetTimer(self.UpdateTime);
			self:SetScriptUpdateRate(0);
		end,
		OnUpdate = BasicPlayer.Client_DeadOnUpdate,
		OnEndState = function( self )
		end,
		OnTimer = BasicPlayer.Client_OnTimerDead,

		-- [marco] only event to be updated when the AI is dead is the
		-- eventonwater, as the dead AI can slide and fall into water		
		OnEvent = function (self,EventId,Params)
			--System:Log("Event called");
			if (EventId==ScriptEvent_EnterWater) then
				--System:Log("Event enter water detected");
				BasicPlayer.OnEnterWater(self,Params);
			end
		end	
		
	},
}

function BasicAI:Drop(packname)

	if (EquipPacks == nil) then
		System:LogToConsole("EquipPacks global table NOT PRESENT. Talk to TIM!!!");
		do return end
	end

	-- spawn pickups
	--
	-- They are always spawned at different positions. Otherwise they collide immediately with each
	-- other and don't fall down anymore.
	local deadguy_pos = self:GetPos();
	deadguy_pos.z = deadguy_pos.z + 1.0;
	
	-- drop armor
	if (self.Properties.dropArmor ~= nil and self.Properties.dropArmor > 0) then
		local newentity = Server:SpawnEntity("Armor");
		if(newentity)then
			newentity.Properties.Amount = self.Properties.dropArmor;
			newentity:EnableSave(0);
			newentity:Physicalize(self);
			newentity:SetPos(deadguy_pos);
		else
			System:Log("Failure dropping armor!");
		end
	end

	local packtable = EquipPacks[packname];
	if (packtable) then
		local dropOffset=0.16;
		for i,value in packtable do
			if (value.Type == "Item") then
				local newentity = Server:SpawnEntity(value.Name);
				if(newentity)then
--					newentity:EnableSave(0);
					newentity:Physicalize(self);
					-- raise position
					deadguy_pos.z = deadguy_pos.z + dropOffset;
					newentity:SetPos(deadguy_pos);
					dropOffset = dropOffset+0.1;
				else
					System:Log("Failure dropping the entity:"..value.Name);
				end
			end
		end
	else
		System:Warning( "Enemy"..self:GetName().." could not find pack "..packname.." to drop!");
	end
end


--------------------------------------------------------------------------------------------------------


function BasicAI:MakeAlerted()

	self:StopConversation();
	-- Make this guy alerted
	self:ChangeAIParameter(AIPARAM_SIGHTRANGE,self.PropertiesInstance.sightrange*2);	-- add 100% to sight range
	self:ChangeAIParameter(AIPARAM_SOUNDRANGE,self.PropertiesInstance.soundrange+10);	-- add 10 m to sound range
	self:ChangeAIParameter(AIPARAM_FOV,self.Properties.horizontal_fov+20);		-- focus attention
	self:ChangeAIParameter(AIPARAM_RESPONSIVENESS,10);		-- focus attention
	--self:ChangeAIParameter(AIPARAM_COMMRANGE,self.Properties.commrange+100);	-- add 100 m to communications range

	if (self.AI_GunOut==nil) then 
		if (self.DRAW_GUN_ANIM_COUNT) then 
			local rnd=random(1,self.DRAW_GUN_ANIM_COUNT);
			local anim_name = format("draw%02d",rnd);
			self:StartAnimation(0,anim_name,2);	
			local anim_dur = self:GetAnimationLength(anim_name);	
			self:TriggerEvent(AIEVENT_ONBODYSENSOR,anim_dur);
			AI:EnablePuppetMovement(self.id,0,anim_dur);
			self.AI_GunOut = 1;
		end
	end

end

function BasicAI:MakeIdle()
	-- Make this guy idle
	self:ChangeAIParameter(AIPARAM_SIGHTRANGE,self.PropertiesInstance.sightrange);
	self:ChangeAIParameter(AIPARAM_SOUNDRANGE,self.PropertiesInstance.soundrange);
	self:ChangeAIParameter(AIPARAM_FOV,self.Properties.horizontal_fov);
	self:ChangeAIParameter(AIPARAM_RESPONSIVENESS,self.Properties.responsiveness);		-- focus attention
	--self:ChangeAIParameter(AIPARAM_COMMRANGE,self.Properties.commrange+100);	-- add 100 m to communications range
end


function BasicAI:InsertMeleePipe( anim_name )

	local anim_time = self:GetAnimationLength(anim_name);
	anim_time = anim_time / 2;

	AI:CreateGoalPipe("melee_animation_delay");
	AI:PushGoal("melee_animation_delay","firecmd",0,0);
	AI:PushGoal("melee_animation_delay","timeout",1,anim_time);
	AI:PushGoal("melee_animation_delay","signal",1,1,"APPLY_MELEE_DAMAGE",0);
--	AI:PushGoal("melee_animation_delay","timeout",1,anim_time);
	AI:PushGoal("melee_animation_delay","signal",1,1,"RESET_MELEE_DAMAGE",0);

	if (self:InsertSubpipe(0,"melee_animation_delay")) then 
		self:StartAnimation(0,anim_name,4);
	end


end

function BasicAI:InsertAnimationPipe( anim_name , layer_override, signal_at_end, fBlendTime, multiplier)

	if (fBlendTime==nil) then
		fBlendTime = 0.33;
	end

	if (multiplier==nil) then 
		multiplier = 1;
	end


	AI:CreateGoalPipe("temp_animation_delay");
	AI:PushGoal("temp_animation_delay","timeout",1,self:GetAnimationLength(anim_name)*multiplier);
	if (signal_at_end) then
		AI:PushGoal("temp_animation_delay","signal",1,-1,signal_at_end,0);
	end

	if (self:InsertSubpipe(0,"temp_animation_delay")) then
		if (layer_override) then
			self:StartAnimation(0,anim_name,layer_override,fBlendTime);
		else
			self:StartAnimation(0,anim_name,4,fBlendTime);
		end
	end

end

function BasicAI:MakeRandomIdleAnimation()
	-- pick random idle animation
	local MyAnim = IdleManager:GetIdleAnimation( self );
	if (MyAnim) then
		self:InsertAnimationPipe(MyAnim.Name);
	else
		System:Warning( "[AI] [ART ERROR][DESIGN ERRoR] Model "..self.Properties.fileModel.." used, assigned a job BUT HAS NO idleXX animations.");
	end
end

function BasicAI:DoSomethingInteresting()

	if ((self.Properties.bAffectSOM==0) and (self.Properties.special == 0)) then 
		do return end
	end

	local specialTextAnchor = AI:FindObjectOfType(self.id,5,AIAnchor.DO_SOMETHING_SPECIAL);	
	
	local boredAnchor = AI_BoredManager:FindSomethingToDO(self,10);
	if (boredAnchor) then
		AI:Signal(0,1, boredAnchor.signal,self.id);
		self.EventToCall = "OnSpawn";
		return 1
	end
end


function BasicAI:NotifyGroup()

	if (self.Properties.special == 1) then 
		do return end
	end


	local anch = AI:FindObjectOfType(self.id,30,AIAnchor.AIANCHOR_NOTIFY_GROUP_DELAY);		
	if (anch) then
		self:InsertSubpipe(0,"delay_headsup",anch);
		return 1
	end

	return nil

end

function BasicAI:GettingAlerted()

	if (self.Properties.special == 1) then 
		do return end
	end


	local mounted = AI:FindObjectOfType(self.id,30,AIAnchor.USE_THIS_MOUNTED_WEAPON);		
	if (mounted) then
		if (AI:GetGroupCount(self.id)>1) then 
			AI:Signal(SIGNALFILTER_NEARESTGROUP,1,"SWITCH_TO_MORTARGUY",self.id);
		else
			AI:Signal(0,1,"SWITCH_TO_MORTARGUY",self.id);
			do return end;
		end	end
	
	
	if (self.cnt:GetCurrWeapon() == nil) then 
		--System:LogToConsole("\001 NO WEAPON");
		-- this enemy has no weapon
		local gunrack = AI:FindObjectOfType(self:GetPos(),30,AIAnchor.GUN_RACK);
		if (gunrack) then 
			self:InsertSubpipe(0,"get_gun",gunrack);
		end
	else
		--System:LogToConsole("\001 WEAPON");
		self:InsertSubpipe(0,"DRAW_GUN");
	end
end

function BasicAI:Blind_RunToAlarm()

	if (self.Properties.special == 1) then 
		do return end
	end

	self.AI_ALARMNAME = AI:FindObjectOfType(self.id,30,AIAnchor.BLIND_ALARM);		
	if (self.AI_ALARMNAME) then	
		AI:Signal(0, 2, "GOING_TO_TRIGGER",self.id);
	end

end



function BasicAI:RunToAlarm()

	if (self.Properties.special == 1) then 
		do return end
	end


	local mounted = AI:FindObjectOfType(self.id,30,AIAnchor.USE_THIS_MOUNTED_WEAPON);		
	if (mounted) then
		if (AI:GetGroupCount(self.id)>1) then 
			AI:Signal(SIGNALFILTER_NEARESTGROUP,1,"SWITCH_TO_MORTARGUY",self.id);
		else
			AI:Signal(0,1,"SWITCH_TO_MORTARGUY",self.id);
			do return end;
		end
	end

	local flare_name = AI:FindObjectOfType(self.id,10,AIAnchor.AIANCHOR_THROW_FLARE);		
	if (flare_name) then

		AI:Signal(0, 2, "THROW_FLARE",self.id);
		BasicPlayer.SelectGrenade(self,"FlareGrenade");
	end

	self.AI_ALARMNAME = AI:FindObjectOfType(self.id,30,AIAnchor.AIANCHOR_PUSH_ALARM);		
	if (self.AI_ALARMNAME) then	
		AI:Signal(0, 2, "GOING_TO_TRIGGER",self.id);
	end

end

function BasicAI:MutantJump( AnchorType, fDistance, flags )

	if (AnchorType == nil) then 
		AnchorType = AIAnchor.MUTANT_JUMP_TARGET;
	end


	if (fDistance == nil) then 
		fDistance = 30;
	end


	if (self.cnt.flying) then
		do return end
	end

	if (self.AI_SpecialPoints==nil) then
		self.AI_SpecialPoints = 0;
	end

	local jmp_name = self:GetName().."_JUMP"..self.AI_SpecialPoints;
	local TagPoint = Game:GetTagPoint(jmp_name);
	if (TagPoint~=nil) then 	

		AI:CreateGoalPipe("jump_to");
		AI:PushGoal("jump_to","ignoreall",0,1); 
		AI:PushGoal("jump_to","clear",0); 
		AI:PushGoal("jump_to","firecmd",0,0); 
		AI:PushGoal("jump_to","jump",1,0,0,0,self.Properties.fJumpAngle); -- actual jump executed here
		AI:PushGoal("jump_to","ignoreall",0,0); 

		AI:Signal(0,1,"JUMP_ALLOWED",self.id);
		self:SelectPipe(0,"jump_wrapper");
		self:InsertSubpipe(0,"jump_to",jmp_name);
		self.AI_SpecialPoints=self.AI_SpecialPoints+1;
		return 1;
	end

	local jmp_point=nil;
	if (AnchorType==AIAnchor.MUTANT_JUMP_TARGET) then 
		 jmp_point = AI:FindObjectOfType(self.id,fDistance,AIAnchor.MUTANT_JUMP_TARGET_WALKING,flags);
	end
	if (jmp_point == nil) then
		jmp_point = AI:FindObjectOfType( self.id, fDistance, AnchorType,flags);
		if (jmp_point) then
			self.AI_CanWalk = nil;
		end
	else
		self.AI_CanWalk = 1;
	end

	if (jmp_point) then 

		AI:CreateGoalPipe("jump_to");
		AI:PushGoal("jump_to","ignoreall",0,1); 
		AI:PushGoal("jump_to","clear",0); 
		AI:PushGoal("jump_to","firecmd",0,0); 
		AI:PushGoal("jump_to","jump",1,0,0,0,self.Properties.fJumpAngle); -- actual jump executed here
		AI:PushGoal("jump_to","ignoreall",0,0); 



		AI:Signal(0,1,"JUMP_ALLOWED",self.id);
		self:SelectPipe(0,"jump_wrapper");
		self:InsertSubpipe(0,"jump_to",jmp_point);
		return 1;
	end

	return nil;	
end


function BasicAI:PushStuff()

	local push_point = AI:GetAnchor(self.id,AIAnchor.PUSH_THIS_WAY,10);
--	local push_point = AI:FindObjectOfType(self.id,10,AIAnchor.PUSH_THIS_WAY);
	if (push_point) then 
		self:InsertSubpipe(0,"mutant_push_stuff_at",push_point);
	end
	
end


function BasicAI:InitAIRelaxed()
	--self.cnt:DrawThirdPersonWeapon(0);

	local weapon = self.cnt:GetCurrWeapon();
	if (weapon) then
		if (weapon.name == "Falcon") then 
			self.PropertiesInstance.bGunReady =1;
		end
	else
		--System:LogToConsole("\001 currently selected Weapon is NULL ");
	end

	if (self.PropertiesInstance.bGunReady == 0) then
		self.cnt:HolsterGun();
		self.AI_GunOut = nil;
	end
	self.RunToTrigger = nil;
end

function BasicAI:InitAICombat()
	--self.cnt:DrawThirdPersonWeapon(0);
	self.cnt:HoldGun();
	self.AI_GunOut = 1;
	self.RunToTrigger = nil;
end


----------------------------------------------------------------------------------
function BasicAI:Say( phrase, AIConvTable )
	if (phrase) then
--		System:Log("Saying "..phrase.soundFile);
		self:SayDialog(phrase.soundFile, phrase.Volume, phrase.min, phrase.max, SOUND_RADIUS,AIConvTable);
	end
end




function BasicAI:Readibility( signal , bSkipGroupCheck)

	--if (bSkipGroup) then 
	if (bSkipGroupCheck==nil) then 
		if (AI:GetGroupCount(self.id) > 1) then	
			AI:Signal(SIGNALID_READIBILITY, 1, signal.."_GROUP",self.id);	
		else
			AI:Signal(SIGNALID_READIBILITY, 1, signal,self.id);	
		end
	else
		AI:Signal(SIGNALID_READIBILITY, 1, signal,self.id);	
	end
end

----------------------------
function BasicAI:StopSounds()

	Sound:StopSound(self.chattering_on);
	Sound:StopSound(self.LastLandSound);
	Sound:StopSound(self.LastJumpSound);
	
	if (self.footsteparray) then
		for i,footstep in self.footsteparray do
			Sound:StopSound(footstep);
		end
	end
end

---------------
function BasicAI:DoJump(Params)
	
	if (Params==1) then
		--Hud:AddMessage("land");
		if (Sound:IsPlaying(self.LastLandSound)==nil) then
			self.LastLandSound = nil;
		end
		
		if (self.landsounds and self.LastLandSound==nil) then
			self.LastLandSound = BasicPlayer.PlayOneSound(self,self.landsounds,100);
		end
	else
		--Hud:AddMessage("jump");
		if (Sound:IsPlaying(self.LastJumpSound)==nil) then
			self.LastJumpSound = nil;
		end
		
		if (self.jumpsounds and self.LastJumpSound==nil) then
			self.LastJumpSound = BasicPlayer.PlayOneSound(self,self.jumpsounds,100);
		end
	end
end

---------------
function BasicAI:DoCustomStep(material,pos)
		
	if (self.footstepsounds==nil) then return nil; end
	
	if (LengthSqVector(self:GetVelocity())<1) then return nil; end
	
	if(not Game:IsPointInWater(pos)) then
		
		local footstepcount = self.footstepcount;
			
		--stop the previous sound if exist.
		Sound:StopSound(self.footsteparray[footstepcount]); 
				
		self.footsteparray[footstepcount] = BasicPlayer.PlayOneSound(self,self.footstepsounds,100);
		
		footstepcount = footstepcount + 1;
		
		--loop cycle through the foot step array
		if (footstepcount > count(self.footsteparray)) then footstepcount = 1; end
		
		self.footstepcount = footstepcount;
		
		--System:Log(sprintf("foot step iterator : %i",self.footstepcount));
		
		return 1;
	end
	
	return nil;
end

function BasicAI:SetSmoothMovement()
	-- smooth AI movement input (acceleration,deceleration,indoor_acceleration,indoor_deceleration)
	self.cnt:SetSmoothInput(3,15,5,15);
end

----------------------------------------------------------------------------------
function CreateAI(child)


	local newt={}
	mergef(newt,BasicAI,1);
	mergef(newt,child,1);
	
	newt.PropertiesInstance.bHelmetProtection = 1;
	
	return newt;
end
