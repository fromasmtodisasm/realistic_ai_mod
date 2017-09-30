Mission = {
};

function Mission:OnInit()
	-- you may want to load a string-table etc. here...
	Language:LoadStringTable("specops08.xml");
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

function Mission:Event_M_Goto_Pier()
	Hud:SetRadarObjective("Radar_Pier");
	Hud:AddMessage(Localize("NewObjective"),9);
	Hud:PushObjective({},Localize("Retransa"));
	Hud:PushObjective({},Localize("Finopier"));
	_localplayer.cnt.health=_localplayer.cnt.max_health;
	_localplayer.cnt.armor=_localplayer.cnt.max_armor;
end

function Mission:Event_M_Tower_One()
	Hud:SetRadarObjective("Radar_One");
	Hud:AddMessage(Localize("NewObjective"),9);
	Hud:CompleteObjective(Localize("Finopier"));
	Hud:PushObjective({},Localize("Eplone"));		 
end

function Mission:Event_M_Goto_Jape()
	Hud:SetRadarObjective("Radar_Beac");
	Hud:AddMessage(Localize("NewObjective"),9);
	Hud:CompleteObjective(Localize("Eplone"));
	Hud:PushObjective({},Localize("Findjepd"));
end

function Mission:Event_M_Goto_Road()
	Hud:SetRadarObjective("Radar_Road");
	Hud:AddMessage(Localize("NewObjective"),9);
	Hud:CompleteObjective(Localize("Findjepd"));
	Hud:PushObjective({},Localize("Teamjon"));
end

function Mission:Event_M_Tower_Two()
	Hud:SetRadarObjective("Radar_Two");
	Hud:AddMessage(Localize("NewObjective"),9);
	Hud:CompleteObjective(Localize("Teamjon"));
	Hud:PushObjective({},Localize("Epltwo"));		 
end

function Mission:Event_M_Goto_Buksir()
	Hud:SetRadarObjective("Radar_Buksir");
	Hud:AddMessage(Localize("NewObjective"),9);
	Hud:CompleteObjective(Localize("Epltwo"));
	Hud:PushObjective({},Localize("Buksand"));
end

function Mission:Event_M_Tower_Last()
	Hud:SetRadarObjective("Radar_Last");
	Hud:AddMessage(Localize("NewObjective"),9);
	Hud:CompleteObjective(Localize("Buksand"));
	Hud:PushObjective({},Localize("Eplast"));
end

function Mission:Event_M_Gone_Heli()
	Hud:SetRadarObjective("Radar_Heli");
	Hud:AddMessage(Localize("NewObjective"),9);
	Hud:CompleteObjective(Localize("Eplast"));
	Hud:PushObjective({},Localize("Helioutd"));
end

function Mission:Event_Set_Rocket_One()
	local AIVehicle=System:GetEntityByName("Specjap");
	if(AIVehicle)then
		AIVehicle.ammoRL = 0;
		AIVehicle.Ammo["VehicleRocket"] = AIVehicle.ammoRL;
	end		 
end

-- MISSION CONTROL

function Mission:Finish()
	-- go to next mission...
end


function Mission:Event_MissionFinished()
	Hud:CompleteObjective(Localize("Helioutd"));
   System:LogToConsole('mission finished, loading next mission...');
    _localplayer.cnt:SavePlayerElements();
    Game:SendMessage('StartLevelFade SpecOps09');
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

function Mission:Event_AllLeadTo_10TEN()
   Mission:SetWarriorsLeadCount( 10 );
end

function Mission:Event_AllLeadTo_11ELEVEN()
   Mission:SetWarriorsLeadCount( 11 );
end

function Mission:Event_AllLeadTo_12DOZEN()
   Mission:SetWarriorsLeadCount( 12 );
end

function Mission:Event_AllLeadTo_13THIRTEEN()
   Mission:SetWarriorsLeadCount( 13 );
end

function Mission:Event_AllLeadTo_14FOURTEEN()
   Mission:SetWarriorsLeadCount( 14 );
end

function Mission:Event_AllLeadTo_15FIFTEEN()
   Mission:SetWarriorsLeadCount( 15 );
end

function Mission:Event_AllLeadTo_16SIXTEEN()
   Mission:SetWarriorsLeadCount( 16 );
end

function Mission:Event_AllLeadTo_17SEVENTEEN()
   Mission:SetWarriorsLeadCount( 17 );
end

function Mission:Event_MoveToBuksir()	
	local DummyDooch=System:GetEntityByName("Dooch_Buksir_RELOCATE");	
	local DummyLock=System:GetEntityByName("Lock_Buksir_RELOCATE");	
	local DummyDen=System:GetEntityByName("Den_Buksir_RELOCATE");
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

function Mission:Event_MoveToUnBuksir()	
	local DummyDooch=System:GetEntityByName("Dooch_UnBuksir_RELOCATE");	
	local DummyLock=System:GetEntityByName("Lock_UnBuksir_RELOCATE");	
	local DummyDen=System:GetEntityByName("Den_UnBuksir_RELOCATE");
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

function Mission:Event_MoveToHamwee()	
	local DummyDooch=System:GetEntityByName("Dooch_Hamw_RELOCATE");	
	local DummyLock=System:GetEntityByName("Lock_Hamw_RELOCATE");	
	local DummyDen=System:GetEntityByName("Den_Hamw_RELOCATE");
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

function Mission:Event_MoveToPiero()	
	local DummyDooch=System:GetEntityByName("Dooch_Piero_RELOCATE");	
	local DummyLock=System:GetEntityByName("Lock_Piero_RELOCATE");	
	local DummyDen=System:GetEntityByName("Den_Piero_RELOCATE");
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

function Mission:Event_MoveToBiats()	
	local DummyDooch=System:GetEntityByName("Dooch_Biat_RELOCATE");	
	local DummyLock=System:GetEntityByName("Lock_Biat_RELOCATE");	
	local DummyDen=System:GetEntityByName("Den_Biat_RELOCATE");
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

function Mission:Event_MoveToBrod()	
	local DummyDooch=System:GetEntityByName("Dooch_Brat_RELOCATE");	
	local DummyLock=System:GetEntityByName("Lock_Brat_RELOCATE");	
	local DummyDen=System:GetEntityByName("Den_Brat_RELOCATE");
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

function Mission:Event_MoveToFinat()	
	local DummyDooch=System:GetEntityByName("Dooch_Finat_RELOCATE");	
	local DummyLock=System:GetEntityByName("Lock_Finat_RELOCATE");	
	local DummyDen=System:GetEntityByName("Den_Finat_RELOCATE");
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