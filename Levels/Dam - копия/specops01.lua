Mission = {
};

function Mission:OnInit()
	-- you may want to load a string-table etc. here...
	Language:LoadStringTable("specops01.xml");
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

function Mission:Event_Check_Gate()
	Hud:SetRadarObjective("Radar_Gate");
	Hud:AddMessage(Localize("NewObjective"),9);
	Hud:PushObjective({},Localize("Eleminate_General"));
	Hud:PushObjective({},Localize("Check_Gates"));
	_localplayer.cnt.health=_localplayer.cnt.max_health;
	_localplayer.cnt.armor=_localplayer.cnt.max_armor;
	if (UI) then
		UI:PlayCutScene('SpecOps.bik');
	end
end

function Mission:Event_Need_Explosive()
	Hud:SetRadarObjective("Radar_Explosive");
	Hud:AddMessage(Localize("NewObjective"),9);
	Hud:CompleteObjective(Localize("Check_Gates"));
	Hud:PushObjective({},Localize("Find_Explo"));
end

function Mission:Event_Gate_Explosive()
	Hud:SetRadarObjective("Radar_Gate");
	Hud:AddMessage(Localize("NewObjective"),9);
	Hud:CompleteObjective(Localize("Find_Explo"));
	Hud:PushObjective({},Localize("Return_Gate"));
end

function Mission:Event_Go_Base()
	Hud:SetRadarObjective("Radar_Base");
	Hud:AddMessage(Localize("NewObjective"),9);
	Hud:CompleteObjective(Localize("Return_Gate"));
	Hud:PushObjective({},Localize("Go_To_Base"));
end

function Mission:Event_Go_Pier()
	Hud:SetRadarObjective("Radar_Pier");
	Hud:AddMessage(Localize("NewObjective"),9);
	Hud:CompleteObjective(Localize("Go_To_Base"));
	Hud:PushObjective({},Localize("Go_To_Pier"));
end

-- MISSION CONTROL

function Mission:Finish()
	-- go to next mission...
end


function Mission:Event_MissionFinished()
	Hud:CompleteObjective(Localize("Go_To_Pier"));
  System:LogToConsole('mission finished, loading next mission...');
  	_localplayer.cnt:SavePlayerElements();
  Game:SendMessage('StartLevelFade SpecOps02');
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
	dooch_warrior.cnt.health=255;
	lock_warrior.cnt.health=255;
	den_warrior.cnt.health=255;
	_localplayer.cnt.health=_localplayer.cnt.max_health;
	_localplayer.cnt.armor=_localplayer.cnt.max_armor;
	_localplayer.Ammo["Pistol"] = MaxAmmo["Pistol"];
	_localplayer.Ammo["SMG"] = MaxAmmo["SMG"];
	_localplayer.Ammo["Assault"] = MaxAmmo["Assault"];
	_localplayer.Ammo["Sniper"] = MaxAmmo["Sniper"];
	_localplayer.Ammo["Shotgun"] = MaxAmmo["Shotgun"];
	_localplayer.Ammo["AG36Grenade"] = MaxAmmo["AG36Grenade"];
	_localplayer.Ammo["OICWGrenade"] = MaxAmmo["OICWGrenade"];
	_localplayer.Ammo["Rocket"] = MaxAmmo["Rocket"];
	_localplayer.Ammo["HandGrenade"] = MaxAmmo["HandGrenade"];
	_localplayer.Ammo["FlashbangGrenade"] = MaxAmmo["FlashbangGrenade"];
	_localplayer.Ammo["SmokeGrenade"] = MaxAmmo["SmokeGrenade"];	
	_localplayer.cnt.ammo_in_clip = _localplayer.fireparams.bullets_per_clip;
	_localplayer.cnt.numofgrenades = MaxAmmo["HandGrenade"];
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

function Mission:Event_MoveTroughGate()
	local DummyDooch=System:GetEntityByName("Dooch_After_Gate_RELOCATE");	
	local DummyLock=System:GetEntityByName("Lock_After_Gate_RELOCATE");	
	local DummyDen=System:GetEntityByName("Den_After_Gate_RELOCATE");
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

function Mission:Event_MoveToOne()
	local DummyDooch=System:GetEntityByName("Dooch_One_RELOCATE");	
	local DummyLock=System:GetEntityByName("Lock_One_RELOCATE");	
	local DummyDen=System:GetEntityByName("Den_One_RELOCATE");
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

function Mission:Event_MoveToTwi()
	local DummyDooch=System:GetEntityByName("Dooch_Twi_RELOCATE");	
	local DummyLock=System:GetEntityByName("Lock_Twi_RELOCATE");	
	local DummyDen=System:GetEntityByName("Den_Twi_RELOCATE");
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