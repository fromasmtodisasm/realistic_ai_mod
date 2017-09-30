-------------------------------------------------------------------
-- X-Isle Script File
-- Description: Defines the rules of the default game(Single player)
-- Created by Alberto Demichelis
--------------------------------------------------------------------


GameRules = {
	InitialPlayerProperties = {
		health		= 255, 			-- range: 0=dead .. 255=full health

		-- we do not have armor in FarCry right now
		-- [marco] we do,initially is set to 0 though
		armor		= 0,
	},

	m_nMusicId=0,

	-- damage modifier tables { head, heart, body, arm, leg, explosion }
	ai_to_player_damage = { 1, 1, 1, 0.5, 0.5, 0.5 },
	player_to_ai_damage  = { 10, 2.0, 1, 0.5, 0.5, 1 },
	ai_to_ai_damage   = { 0.5, 0.4, 0.4, 0.15, 0.15, 0.15 },

	player_to_player_damage = { 3, 1, 1, 0.5, 0.5, 0.5 },

	Arm2BodyDamage = .75,
	Leg2BodyDamage = 1,
	god_mode_count=0,

	player_death_pos = { x=0, y=0, z=0, xA=0, yA=0, zA=0 },

	TimeRespawn=3,
	TimeDied=0,
	bShowUnitHightlight=nil,			-- 1/nil (show a 3d object on top of every friendly unit)
	fBullseyeDamageLevel =  20,		-- amount of damage until the 
	fBullseyeDamageDecay = 0.5,		-- X units of damage lost per second
}

-- If someone in script needs to know if we are running multiplayer or single player game.
GameRules.bMultiplayer = nil;
GameRules.bSingleplayer = 1;


function GameRules:GetPlayerScoreInfo(ServerSlot, Stream)
end


-------------------------------------------------------
-------------------------------------------------------
function GameRules:OnInit()
	Server:AddTeam("dm");
	--Initialize the debug tag point thingy
	DebugTagPointsMgr:Init(g_LevelName);
	_LastCheckPPos=nil;
	self.god_mode_count=0; -- must be reset when switching to game mode in editor
	--s_deformable_terrain=1;
end

-------------------------------------------------------
-------------------------------------------------------
function GameRules:OnUpdate( DeltaTime )
end

-------------------------------------------------------
-------------------------------------------------------
function GameRules:OnShutdown()
end

-------------------------------------------------------
-------------------------------------------------------

function GameRules:OnMapChange()
    _LastCheckPPos = nil
    _LastCheckPAngles = nil
end




-------------------------------------------------------
-------------------------------------------------------
function GameRules:ApplyDamage( target, damage, damage_type )

	local bGodMode = 0;
	if (god and (tonumber(god) == 1) and (target==_localplayer)) then
		bGodMode = 1;
	end

	if (damage > 0) then
		--- apply damage first to armor, if it is present
		if (damage_type ~= "healthonly") then
			if (target.cnt.armor > 0) then
				target.cnt.armor= target.cnt.armor - (damage*0.5);
				-- clamp to zero
				if (target.cnt.armor < 0) then
					damage = -target.cnt.armor;
					target.cnt.armor = 0;
				else
					damage = 0;
				end
			end
		end
	end
	target.cnt.health = target.cnt.health - damage;

	-- negative damage (medic tool) is is bounded to max_health
	if(target.cnt.health>target.cnt.max_health) then
		target.cnt.health=target.cnt.max_health;
	end

	if ( target.cnt.health < 1 ) then

		if(bGodMode==1)then
			GameRules.god_mode_count=GameRules.god_mode_count+1;
			target.cnt.health = self.InitialPlayerProperties.health;
		else
			target.cnt.health = 0;
			local angles=target:GetAngles();
			--GameRules.player_death_pos.x=target:GetPos();
			local	place = target:GetPos();
			GameRules.player_death_pos.x=place.x;
			GameRules.player_death_pos.y=place.y;
			GameRules.player_death_pos.z=place.z;
			GameRules.player_death_pos.xA=angles.x;
			--GameRules.player_death_pos.yA=angles.y;
			--no roll needed!!!!!
			GameRules.player_death_pos.yA=0;
			GameRules.player_death_pos.zA=angles.z;

			if (target==_localplayer) then
				self.TimeDied=_time;
			end

			target:GotoState( "Dead" );
		end
		--Game:ForceScoreBoard(target.id, 1);
	end
end

-------------------------------------------------------
-------------------------------------------------------
function GameRules:OnDamage( hit )
    local theTarget = hit.target;
    local theShooter = hit.shooter;



    --System.LogToConsole("--> GameRules:OnDamage shooter == "..hit.shooter.GetID());

	--mat_head
	--mat_heart
	--mat_arm
	--mat_leg
	--mat_flesh
	--mat_armor
	--mat_helmet
	
	
	if ( theTarget ) then
		if(theTarget.type == "Player" ) then
		
			local bShooterIsPlayer;
			local bShooterIsAI;

			if theShooter then
				if theShooter.ai then
					bShooterIsAI=1;
				else
					bShooterIsPlayer=1;
				end
			end	

			-- used for Autobalancing
			theTarget.LastDamageDoneByPlayer=bShooterIsPlayer;

			local difficulty = tonumber(getglobal("game_DifficultyLevel"));
			local	dmgTable;
			
			-- if it is "realistic" difficylty
			if (Game:IsMultiplayer()) then
				dmgTable = GameRules.player_to_player_damage;
			elseif (difficulty and difficulty == 4) then
				dmgTable = GameRules.player_to_ai_damage;
			else
				dmgTable = GameRules.ai_to_player_damage;
				-- determine correct damage modifier table
				if theTarget.ai then
					if bShooterIsAI then
						dmgTable=GameRules.ai_to_ai_damage;
					elseif bShooterIsPlayer then
						dmgTable=GameRules.player_to_ai_damage;
					end
				end
			end	

			if(hit.explosion ~= nil )then
				local expl=theTarget:IsAffectedByExplosion();
				if(expl<=0)then return end
				hit.damage= expl * hit.damage * dmgTable[6];
				hit.damage_type = "normal";
			end
			if(hit.target_material ~= nil ) then
				local	targetMatType = hit.target_material.type;
				local dmgf =1;
				--System.LogToConsole("onDamage mat: "..targetMatType);

				-- proceed protection gear
				if(targetMatType=="helmet")then
					if(theTarget.hasHelmet == 0) then
						hit.target_material = Game:GetMaterialBySurfaceID(Game:GetMaterialIDByName("mat_head"));
						targetMatType = hit.target_material.type;
					else
						BasicPlayer.HelmetHitProceed(theTarget, hit.dir, hit.damage);
						dmgf = 0.01;
					end
				elseif(targetMatType=="armor")then
					if(theTarget.Properties.bHasArmor == 0) then
						hit.target_material = Game:GetMaterialBySurfaceID(Game:GetMaterialIDByName("mat_flesh"));
						targetMatType = hit.target_material.type;
					else
--						dmgf = 1.0;
						dmgf = 0.0;
					end
				end

				if (targetMatType=="bullseye") then
					dmgf = 0.0;
					-- do damage decay stuff
					if (theTarget.bullseyeTime == nil) then
						theTarget.bullseyeTime = _time;
					end
					
					-- calculate the amount of time passed
					local timeSpan = _time - theTarget.bullseyeTime;
					local bullseyeDamage = 0;
					
					if (theTarget.bullseyeDamage ~= nil) then
						bullseyeDamage = theTarget.bullseyeDamage;
					end
					
					-- subtract the damage decay
					bullseyeDamage = bullseyeDamage - GameRules.fBullseyeDamageDecay * timeSpan;
					
					-- clamp to 0
					if (bullseyeDamage < 0) then
						bullseyeDamage = 0;
					end
					
					-- add current damage (use flesh damage factor -> dmgTable[3])
					bullseyeDamage = bullseyeDamage + hit.damage * dmgTable[3];
					
					-- decide if damagelevel is high enough
					if (bullseyeDamage > GameRules.fBullseyeDamageLevel) then
						theTarget.bullseyeDamage = nil;
						theTarget.bullseyeTime = nil;
						AI:Signal(0,1,"HIT_THE_SPOT",theTarget.id);
					else
						theTarget.bullseyeDamage = bullseyeDamage;
						theTarget.bullseyeTime = _time;
					end
				end

				if(targetMatType=="head") then
					dmgf = dmgTable[1];
				elseif(targetMatType=="heart")then
					dmgf = dmgTable[2];
				elseif(targetMatType=="flesh")then
					dmgf = dmgTable[3];
				elseif(targetMatType=="arm")then
					dmgf = dmgTable[4];
					theTarget.cnt.armhealth = theTarget.cnt.armhealth - hit.damage*dmgf;
					if( theTarget.cnt.armhealth<0 ) then
						theTarget.cnt.armhealth = 0;
					end
					dmgf = dmgf * GameRules.Arm2BodyDamage;
					dmgPrc = theTarget.cnt:GetArmDamage();
					--System.LogToConsole( "Arm HIT "..dmgPrc );
					if( dmgPrc>50 ) then
						theTarget.cnt.dmgFireAccuracy = 100 - (dmgPrc-50)/2;
					end
				elseif(targetMatType=="leg")then
					dmgf = dmgTable[5];
					theTarget.cnt.leghealth = theTarget.cnt.leghealth - hit.damage*dmgf;
					if( theTarget.cnt.leghealth<0 ) then
						theTarget.cnt.leghealth = 0;
					end
					dmgf = dmgf * GameRules.Leg2BodyDamage;
				end


				--System.LogToConsole("onDamage mat: "..targetMatType.." A "..theTarget.cnt.armhealth.." L "..theTarget.cnt.leghealth.." df "..dmgf.." H "..hit.damage);
				--System:LogToConsole("--> Inflicted Damage: "..(hit.damage*dmgf).." health "..theTarget.cnt.health);

				GameRules:ApplyDamage( theTarget, hit.damage*dmgf, hit.damage_type )
			else
				if(hit.landed == 1) then
					GameRules:ApplyDamage( theTarget, hit.damage, hit.damage_type )
				else
					System:Log("OnDamage: no material assigned for body: ");
				end
			end
		end
	end


--	if ( theTarget ) then
--		if(theTarget.type == "Player" ) then

--        	local zone = theTarget.cnt.GetBoneHitZone(hit.ipart);
--        	if zone==0 then zone = 2 end;
            --System.LogToConsole("health1: "..theTarget.cnt.health.." part: "..zone);
--            local dmgf = GameRules.bodydamage[zone];
--            if theTarget.ai then
--                dmgf = GameRules.aidamage[zone];
--            end
--        	theTarget.cnt.health = theTarget.cnt.health - hit.damage*dmgf;
            --System.LogToConsole("health2: "..theTarget.cnt.health);

	--		if ( theTarget.cnt.health < 1 ) then
--				theTarget.cnt.health = 0;
--				theTarget.GotoState( "Dead" );
--				Game.ForceScoreBoard(theTarget.id, 1);
--			end
--		end
--	end
end

-------------------------------------------------------
-------------------------------------------------------
function GameRules:RespawnPlayer(server_slot,player)

	if(player.type=="Player")then
		--set the default stats
		player.cnt.max_health=self.InitialPlayerProperties.health;
		player.cnt.health=self.InitialPlayerProperties.health;
		player.cnt.armor=self.InitialPlayerProperties.armor;
		player.cnt.alive=1;
		player:EnablePhysics(1);

		-- [marco] make certain player elements persistent between levels
		-- here it's ok because in multiplayer we never save between levels, 
		-- so this function will do nothing, and this is the final place where
		-- player stats are set before starting the game
		if (tonumber(getglobal("g_LevelStated")) == 0) then
			player.cnt:LoadPlayerElements();
		end

		-- [marco] set global EAX preset
		Sound:SetEaxEnvironment(EAXPresetDB["noreflectmoistair"],SOUND_OUTDOOR);

		Game:ShowIngameDialog(-1, "", "", 12, "Respawning at last checkpoint",5);
	end

	--local RespawnPoint = Game.GetRandomRespawnPoint();

	--local pos = {x = RespawnPoint.x, y = RespawnPoint.y, z = RespawnPoint.z};
	--local dir = {x = RespawnPoint.xA, y = RespawnPoint.yA, z = RespawnPoint.zA};

	--player.SetPos(pos);
	--player.SetAngles(dir);
	player:SetName(server_slot:GetName());

	if (_LastCheckPPos) then
		player:SetPos(_LastCheckPPos);
		player:SetAngles(_LastCheckPAngles);
	else
		local RespawnPoint = Server:GetFirstRespawnPoint();
		-- FIXME ... this is a bit ugly, but somehow we don't have a spawn point
		if (not RespawnPoint) then
			RespawnPoint = {x=0,y=0,z=0,xA=0,yA=0,zA=0};
		end
		player:SetPos({x = RespawnPoint.x, y = RespawnPoint.y, z = RespawnPoint.z});
		player:SetAngles({x = RespawnPoint.xA, y = RespawnPoint.yA, z = RespawnPoint.zA});
	end

end

-------------------------------------------------------
-------------------------------------------------------
function GameRules:OnClientConnect( server_slot, requested_classid )
	--create a new player entity
--	local RespawnPoint = Server:GetRandomRespawnPoint();
	local RespawnPoint = Server:GetFirstRespawnPoint();
	-- FIXME ... this is a bit ugly, but somehow we don't have a spawn point
	if (not RespawnPoint) then
		RespawnPoint = {x=0,y=0,z=0,xA=0,yA=0,zA=0};
	end
	
	local dir = {x = RespawnPoint.xA, y = RespawnPoint.yA, z = RespawnPoint.zA};
	local newPlayer=Server:SpawnEntity(requested_classid,RespawnPoint);
	newPlayer:SetAngles(dir);
	
--	System:Log("FirstRespawnPoint player pos x="..RespawnPoint.x.." y="..RespawnPoint.y.." z="..RespawnPoint.z);
--	System:Log("FirstRespawnPoint player angles x="..dir.x.." y="..dir.y.." z="..dir.z);

	--delete the old player entity
	if(server_slot:GetPlayerId()~=0)then
		Server:RemoveEntity(server_slot.GetPlayerId());
	end

	--bind the new created player to the serverslot
	server_slot:SetPlayerId(newPlayer.id);

	--inform player about current game state (TODO: put in proper state & time)
	server_slot:SetGameState(0, 0);

	--set the player at the respawn point and set the starting health and stuff
	GameRules:RespawnPlayer(server_slot,newPlayer);
	Game:ForceScoreBoard(newPlayer.id, nil);
	server_slot.first_request=nil;
end

-------------------------------------------------------
-------------------------------------------------------
function GameRules:OnClientDisconnect( server_slot )
	--remove the player from the team
	--remove the entity
	if(server_slot:GetPlayerId()~=0)then
		Server:RemoveEntity(server_slot:GetPlayerId());
		server_slot:SetPlayerId(0); -- set an invalid player id
	end

end

-------------------------------------------------------
-------------------------------------------------------
function GameRules:OnClientRequestRespawn( server_slot, requested_classid )

	--System:LogToConsole("Clicked!");

	--System:LogToConsole("time=".._time-self.TimeDied);
	if (_time-self.TimeDied<self.TimeRespawn) then
		--System:LogToConsole("time=".._time-self.TimeDied);
		return 
	end

	-- be sure this is removed when the client connects or the
	-- save menu appears
	--System:SetScreenFx("ScreenFade",0);

	--hack to slow down the respawn (should this be inside the if-then below?)
	if(Game:ShowSaveGameMenu())then
		--System:Log('Game:ToggleMenu()')
		Game:SendMessage("Switch");

		return
	else
--		System:Log("Game:ShowSaveGameMenu() returned nil")
	end

	if(server_slot.first_request)then

		local player;
		--for now I don't respawn the entity
		--create a new player entity
		local RespawnPoint = Server:GetRandomRespawnPoint();
		if(tonumber(gr_RespawnAtDeathPos)==1)then
			if(GameRules.player_death_pos)then
				RespawnPoint=GameRules.player_death_pos;
			end
		end
		local dir = {x = RespawnPoint.xA, y = RespawnPoint.yA, z = RespawnPoint.zA};
		local newPlayer=Server:SpawnEntity(requested_classid,RespawnPoint);
		newPlayer:SetAngles(dir);

--		System:Log("player pos x="..RespawnPoint.x.." y="..RespawnPoint.y.." z="..RespawnPoint.z);
--		System:Log("player angles x="..dir.x.." y="..dir.y.." z="..dir.z);


		if(server_slot:GetPlayerId()~=0)then
			Server:RemoveEntity(server_slot:GetPlayerId());
		end


		GameRules:RespawnPlayer(server_slot,newPlayer);
		server_slot:SetPlayerId(newPlayer.id)
		Game:ForceScoreBoard(newPlayer.id, nil);
	else
		server_slot.first_request=1;
	end
end

-- player requests to be killed (typed in the "kill" console command)
function GameRules:OnKill(server_slot)
    local id = server_slot:GetPlayerId();

    if id ~= 0 then
        local ent = System:GetEntity(id);
        self:OnDamage({ target = ent, shooter = ent, damage = 1000, ipart = 0,target_material=Materials.mat_default });
    end
end

-------------------------------------------------------
-------------------------------------------------------
function GameRules:OnClientJoinTeamRequest(server_slot,team_name)
		if(server_slot:GetPlayerId()~=0)then

			local requested_classid=1;
			local player=System:GetEntity(server_slot:GetPlayerId());

			if(team_name~=player:GetTeam())then

				if(team_name=="spectators")then
					requested_classid=SPECTATOR_CLASS_ID;
				end

				local newEntity=Server:SpawnEntity(requested_classid);

				Server:RemoveEntity(player.id);
				server_slot:SetPlayerId(newEntity.id);
				newEntity:SetTeam(team_name);

			end
		end
end

-------------------------------------------------------
-------------------------------------------------------

function GameRules:OnCallVote(server_slot, command, arg1)
	System:LogToConsole("vote called: "..command.." "..arg1);
	-- TODO: clone voting system from ffa rules.
end





-------------------------------------------------------
-------------------------------------------------------
-- return 1=if interaction is accepted, otherwise nil 
function GameRules:IsInteractionPossible(actor,entity)
	-- prevent a player who is in a vehicle from interacting with the entity
	if (actor.theVehicle) then
		return nil;
	end

	-- prevent ai from using entities that are marked for player only use
	--if(entity.Properties.bPlayerOnly and entity.Properties.bPlayerOnly==1 and actor.ai~=nil)then
	--	return nil;
	--end
	-- prevent all ai from picking up things
	if(actor.ai~=nil)then
		return nil;
	end


	-- prevent corpses from interacting with something
	if(actor.cnt and (actor.cnt.health == nil or actor.cnt.health < 1))then
		return nil;
	end

	return 1;
end
