Mission = {
};

function Mission:OnInit()
	-- you may want to load a string-table etc. here...
	Language:LoadStringTable("specops07.xml");
	Hud:FlashObjectives({},"");
	Hud:SetRadarObjective("nil");
end

function Mission:OnUpdate()
	local i;
	local bFinished=1;
	for i,objective in Mission do
		if (type(objective)~="function") then
			if (objective==0) then 
				bFinished=0;				
			else
			end
		end	
	end
	if (bFinished==1) then	
		self.Finish();
	end
end

-- OBJECTIVES

function Mission:Event_Goto_Jeeph()
	Hud:SetRadarObjective("Radar_Jeep");
	Hud:AddMessage(Localize("NewObjective"),9);
	Hud:PushObjective({},Localize("Swamping7"));
	Hud:PushObjective({},Localize("GoOutBase"));
	_localplayer.cnt.health=_localplayer.cnt.max_health;
	_localplayer.cnt.armor=_localplayer.cnt.max_armor;		 
end


function Mission:Event_Goto_Kamps()
	Hud:SetRadarObjective("Radar_Kamps");
	Hud:AddMessage(Localize("NewObjective"),9);
	Hud:CompleteObjective(Localize("GoOutBase"));
	Hud:PushObjective({},Localize("MoveOutKamp"));
end

function Mission:Event_Bronya()
	_localplayer.cnt.health=_localplayer.cnt.max_health;
	_localplayer.cnt.armor=_localplayer.cnt.max_armor; 
end

-- MISSION CONTROL

function Mission:Finish()
	-- go to next mission...
end


function Mission:Event_MissionFinished()
	Hud:CompleteObjective(Localize("MoveOutKamp"));
   System:LogToConsole('mission finished, loading next mission...');
    _localplayer.cnt:SavePlayerElements();
    Game:SendMessage('StartLevelFade SpecOps08');
end

function Mission:Event_OutsideMap()
	if (god) then
		god=nil;
	end
	_localplayer.timetodie=1;	
	_localplayer:SetTimer(100);
end

-- RELOAD POINTS

function Mission:Event_Need_Team_Use()	
	Hud:DisplayCenterIcon()	
end

function Mission:Event_Reload_Team_Use()
	local dooch_warrior=System:GetEntityByName("Dooch");
	local lock_warrior=System:GetEntityByName("Lock");
	local den_warrior=System:GetEntityByName("Den");
	local dooch_warrior2=System:GetEntityByName("DoochDub");
	local lock_warrior2=System:GetEntityByName("LockDub");
	local den_warrior2=System:GetEntityByName("DenDub");
	local List={0,0,0,0,0,0,0}
	List={dooch_warrior,lock_warrior,den_warrior,_localplayer,dooch_warrior2,lock_warrior2,den_warrior2}
	for number,entity in List do
		if entity~=0 then
			for name,amout in MaxAmmo do
				if entity.Ammo[name]~=amout then
					entity.Ammo[name]=amout
					entity.Ammo["FlareGrenade"] = 0; -- Искрящиеся гранаты, которые не доработаны. Их убираем.
					entity.Ammo["GlowStick"] = 0; -- Светящиеся гранаты, которые не доработаны. Их тоже убираем.
					-- Hud:AddMessage(entity:GetName().."$1: "..name..": "..entity.Ammo[name])
					-- System:Log(entity:GetName().."$1: "..name..": "..entity.Ammo[name])
					entity.cnt.health=255;
					entity.cnt.armor=255;
					if entity.fireparams then
						entity.cnt.ammo_in_clip = entity.fireparams.bullets_per_clip;
					end
				end
			end
		end
	end
	Hud:AddMessage(Localize("Reload_Team_Use"), 5);
end

-- WARRIORS DIES

function Mission:Event_Dooch_Dies()
	if (god) then
		god=nil;
	end	
	local ent1 = System:GetEntityByName("Dooch");	
	local pos=new(ent1:GetPos());
	local ang=new(ent1:GetAngles());
	_localplayer:SetPos(pos);
	_localplayer:SetAngles(ang);
	_localplayer.timetodie=1;	
end

function Mission:Event_Lock_Dies()
	if (god) then
		god=nil;
	end	
	local ent2 = System:GetEntityByName("Lock");	
	local pos=new(ent2:GetPos());
	local ang=new(ent2:GetAngles());
	_localplayer:SetPos(pos);
	_localplayer:SetAngles(ang);
	_localplayer.timetodie=1;	
end

function Mission:Event_Den_Dies()
	if (god) then
		god=nil;
	end	
	local ent3 = System:GetEntityByName("Den");	
	local pos=new(ent3:GetPos());
	local ang=new(ent3:GetAngles());
	_localplayer:SetPos(pos);
	_localplayer:SetAngles(ang);
	_localplayer.timetodie=1;	
end

-- CONTROL WARRIORS LEAD POINTS

function Mission:SetWarriorsLeadCount( count ) 
	local dooch_lead = System:GetEntityByName("Dooch");
	local lock_lead = System:GetEntityByName("Lock");
	local den_lead = System:GetEntityByName("Den");
	if (dooch_lead) then
		System:LogToConsole("found warriors");		
		dooch_lead.Properties.LEADING_COUNT = count;
		lock_lead.Properties.LEADING_COUNT = count;
		den_lead.Properties.LEADING_COUNT = count;
	end
end

function Mission:Event_AllLeadTo_1ONE()
   Mission:SetWarriorsLeadCount( 1 );
end

function Mission:Event_AllLeadTo_2TWO()
   Mission:SetWarriorsLeadCount( 2 );
end

function Mission:Event_AllLeadTo_3THREE()
   Mission:SetWarriorsLeadCount( 3 );
end

function Mission:Event_AllLeadTo_4FOUR()
   Mission:SetWarriorsLeadCount( 4 );
end

function Mission:Event_AllLeadTo_5FIVE()
   Mission:SetWarriorsLeadCount( 5 );
end

function Mission:Event_AllLeadTo_6SIX()
   Mission:SetWarriorsLeadCount( 6 );
end

function Mission:Event_AllLeadTo_7SEVEN()
   Mission:SetWarriorsLeadCount( 7 );
end

function Mission:Event_AllLeadTo_8EIGHT()
   Mission:SetWarriorsLeadCount( 8 );
end

function Mission:Event_AllLeadTo_9NINE()
   Mission:SetWarriorsLeadCount( 9 );
end

function Mission:Event_MoveToHamwee()	
	local DummyDooch=System:GetEntityByName("Dooch_Hamwee_RELOCATE");	
	local DummyLock=System:GetEntityByName("Lock_Hamwee_RELOCATE");	
	local DummyDen=System:GetEntityByName("Den_Hamwee_RELOCATE");
	local AIDooch=System:GetEntityByName("Dooch");
	local AILock=System:GetEntityByName("Lock");
	local AIDen=System:GetEntityByName("Den");
	if((DummyDooch)and(AIDooch))then
		System:LogToConsole("found Dooch");
		AIDooch:SetPos(DummyDooch:GetPos());
		AIDooch:SetAngles(DummyDooch:GetAngles());
	end	
	if((DummyLock)and(AILock))then
		System:LogToConsole("found Lock");
		AILock:SetPos(DummyLock:GetPos());
		AILock:SetAngles(DummyLock:GetAngles());
	end
	if((DummyDen)and(AIDen))then
		System:LogToConsole("found Den");
		AIDen:SetPos(DummyDen:GetPos());
		AIDen:SetAngles(DummyDen:GetAngles());
	end
end