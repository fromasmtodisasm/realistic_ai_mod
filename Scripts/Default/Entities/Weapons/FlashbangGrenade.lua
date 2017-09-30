
Script:LoadScript("scripts/default/entities/weapons/BaseHandGrenade.lua");

function PlayerCanSee(self,player,dotlimit)

	local flashPos = g_Vectors.temp_v1;
	local eyePos = g_Vectors.temp_v2;
	local delta = g_Vectors.temp_v3;

	CopyVector(flashPos,self:GetPos());
			
	if (player.ai) then
		CopyVector(eyePos,player:GetPos());
		eyePos.z = eyePos.z + 1;
	else
		CopyVector(eyePos,player:GetCameraPosition());
	end
	
	local player_viewdir = player:GetDirectionVector(0);
	
	local maxdistance = self.flashRadiusSq;
	local mindistance = self.flashMinRadiusSq;
	
	delta.x = flashPos.x - eyePos.x;
	delta.y = flashPos.y - eyePos.y;
	delta.z = flashPos.z - eyePos.z;
		
	local distSq = delta.x*delta.x + delta.y*delta.y + delta.z*delta.z;
	
	--if the distance is more than max return.
	if (distSq>maxdistance) then
		return nil;
	end
	
	NormalizeVector(delta);
			
	local dot = delta.x * player_viewdir.x + delta.y * player_viewdir.y + delta.z * player_viewdir.z;
		
	local scale = 1 - distSq/maxdistance;
	
	--if player is not looking at the nade but is inside the min radius, calculate scale by min radius.
	if (dot<dotlimit and distSq<mindistance) then
		scale = 1 - distSq/mindistance;
	end
	
	--System:Log("BANG "..tostring(dot).."  "..tostring(scale));
	
	--take care about the dot or if the player is inside the min radius.
	if ( (dot>dotlimit or distSq<mindistance) and scale>0) then
		
		--System:Log("occlusion check");
				
		-- check for occlusion, everything except players.
		local hits = System:RayWorldIntersection(eyePos, flashPos, 1,ent_static+ent_sleeping_rigid+ent_rigid+ent_independent+ent_terrain,player.id,self.id);

		--System:Log("REAL BANG "..tostring(hitCount));
		--for i, hit in hits do
		--	if (i ~= "n") then
		--		System:Log("hit"..tostring(i));
		--		System:Log("  dist    "..tostring(hit.dist));
		--		System:Log("  surface "..tostring(hit.surface));					
		--	end
		--end
		
		if (getn(hits) == 0) then			
			return scale;
		--make another try, higher now, to simulate small objects that could occlude the grenade but that realistically dont protect you from the flash.
		else
--			local hit = hits[1];
--			
--			if (hit) then
--				
--				System:Log("hit z normal:"..hit.normal.z);
--				System:Log("hit dist:"..hit.dist);
--				
--				if (hit.normal.z > 0.7) then
--					return scale;
--				end
--			end

			local flashPosUp = g_Vectors.temp_v4;
			
			flashPosUp.x = flashPos.x;
			flashPosUp.y = flashPos.y;
			flashPosUp.z = flashPos.z + 0.5;
			
			hits = System:RayWorldIntersection(flashPos, flashPosUp, 1,ent_static+ent_sleeping_rigid+ent_rigid+ent_independent+ent_terrain,self.id);
			
			if (getn(hits) == 0) then
				local hits = System:RayWorldIntersection(eyePos, flashPosUp, 1,ent_static+ent_sleeping_rigid+ent_rigid+ent_independent+ent_terrain,player.id,self.id);
				
				if (getn(hits) == 0) then
					return scale;
				end
			end
			
--			vec.z = vec.z + 0.5;
--			
--			hits = System:RayWorldIntersection(eyePos, vec, 1,ent_static+ent_sleeping_rigid+ent_rigid+ent_independent+ent_terrain);
--			
--			if (getn(hits)==0) then
--				return scale;	
--			end
		end
	end
	
	return nil;
end

local ExplodeClient=function(self)
	-- hide grenade
	self:DrawObject(0,0);
	
	local canseeflash = PlayerCanSee(self,_localplayer,0.3);
		
	if (canseeflash) then	
				
		local vec = self:GetPos();
		System:ProjectToScreen(vec);
		System:SetScreenFx("FlashBang", 1);
		System:SetScreenFxParamFloat("FlashBang", "FlashBangFlashPosX", vec.x);
		System:SetScreenFxParamFloat("FlashBang", "FlashBangFlashPosY", vec.y);
		System:SetScreenFxParamFloat("FlashBang", "FlashBangTimeScale", (canseeflash * self.flashTime));

	elseif (self.light) then
		--local diff= self.light.vDiffRGBA;
		--local spec= self.light.vSpecRGBA;
		--self:AddDynamicLight(vec, self.light.fRadius, diff.r, diff.g, diff.b, diff.a, spec.r, spec.g, spec.b, spec.a, self.light.fLifetime);
	end
end

local ExplodeServer=function(self)
	--FIXME: optimize, use global tables to avoid to much garbage & mem allocation on the fly.

	--ExplodeServer is needed just for AI, in multiplayer return.
	if (Game:IsMultiplayer()) then
		return;
	end
	
	local difficulty = tonumber(getglobal("game_DifficultyLevel"));

	local pos = new(self:GetPos());
	local radius = sqrt(self.flashRadiusSq);
	local players = {};
	local tempplayer = nil;
	local temppos = {x=0,y=0,z=0};

	Game:GetPlayerEntitiesInRadius(pos, radius, players );
	
	--System:Log("players: "..count(players));
	
	if (players and type(players)=="table") then
		
		for i, cell in players do
			
			local tempplayer = cell.pEntity;
								
			if (tempplayer.ai) then
					
				merge(temppos,tempplayer:GetPos());
				
				temppos.z = temppos.z + 1; -- about eye height
				
				--filippo:in realistic AI act like the player, if they look at the flashbang they will blinded, otherwise not.
				local dot = -1.0;
				if (difficulty>=4) then 
					dot = 0.3;
				elseif (difficulty>=3) then
					dot = 0.0; 
				elseif (difficulty>=2) then
					dot = -0.3; 
				end
										
				local canseeflash = PlayerCanSee(self,tempplayer,dot);
				
				if (canseeflash) then
					--System:Log("AI "..tempplayer:GetName().." blind");
					AI:Signal(0, 1, "FLASHBANG_GRENADE_EFFECT",tempplayer.id);
				else
					--System:Log("AI "..tempplayer:GetName().." not blinded");
				end
			end
		end
	end	
	
	--AI:FreeSignal(1, "FLASHBANG_GRENADE_EFFECT", self:GetPos(), sqrt(self.flashRadiusSq));
end

local param={
	model="objects/Pickups/grenade/grenade_flash_pickup.cgf",
	AIBouncingSound = {
		SoundRadius  = AIWeaponProperties.GrenadeBounce.VolumeRadius,
		Interest = AIWeaponProperties.GrenadeBounce.fInterest,
		Threat = AIWeaponProperties.GrenadeBounce.fThreat,
	},
	AIExplodingSound = {
		SoundRadius  = AIWeaponProperties.FlashbangGrenade.VolumeRadius,
		Interest = AIWeaponProperties.FlashbangGrenade.fInterest,
		Threat = AIWeaponProperties.FlashbangGrenade.fThreat,
	},
	
	ClientHooks = {
		OnExplode = ExplodeClient,
	},
	ServerHooks = {
		OnExplode = ExplodeServer,
	},
	
	exploding_sound={
		sound="sounds/weapons/explosions/flashbang.wav",
		flags=SOUND_UNSCALABLE,
		volume=255,
		min=10,
		max=150,
	},
	hit_effect = "flashgrenade_hit",
	
	no_explosion=1,
	lifetime=10000,
	damage_on_player_contact = 1,
	
	-- flash bang parameters
	flashRadiusSq = 1600,
	flashMinRadiusSq = 25,--if someone is inside this radius blind him in any case, also if he is not looking at the flashbang.
	flashTime = 10.0,

	light = {
		fRadius = 40.0,
		vDiffRGBA = { r = 1.0, g = 1.0, b = 1.0, a = 1.0, },
		vSpecRGBA = { r = 0.3, g = 0.3, b = 0.3, a = 1.0, },
		fLifeTime = 1.0,
	},	
};

FlashbangGrenade=CreateHandGrenade(param);

FlashbangGrenade.SmokeTrail = {
		focus = 0,
		color = {1,1,1},
		speed = 0.0,
		count = 1,
		size = 0.05, size_speed=0.25,
		lifetime=0.5,
		frames=1,
		tid = System:LoadTexture("textures/clouda1.dds"),
		rotation={x=0,y=0,z=3},
	}


--<<FIXME>> add back the soft cover