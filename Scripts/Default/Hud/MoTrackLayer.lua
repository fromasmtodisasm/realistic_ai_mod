--------------------------------------------------------------------
-- X-Isle Script File
-- Description: Defines the MotionTracker
-- Created by Lennert Schneider
--------------------------------------------------------------------

MoTrackLayer = {
	StayTime=5,
	FadeTime=1,
	FadeOutTime=2,	-- if target gets lost
	TrackerSize=50,
	MaxTrackerSize=800,
	ZSensivity=0.001,
	TrackSpeed=1000,
	MaxTrackedObjects=20,
	
	DisableTime=nil,
	LastEntities={},
	CurrEntities={},
	fSlowest=99999999,
	nSlowestId=-1,
}

-------------------------------------------------------
function MoTrackLayer:OnInit()
	MoTrackLayer.Indicator=System:LoadImage( "Textures/Hud/Binocular/binoculars_targeting" );
	MoTrackLayer.TargetSnd=Sound:LoadSound("Sounds/Items/MoTrackTarget.wav");
end

-------------------------------------------------------
function MoTrackLayer:OnUpdate()
	if (MoTrackLayer.DisableTime or tonumber(getglobal("cl_motiontracker"))==0) then
	 return
--		MoTrackLayer.DisableTime=MoTrackLayer.DisableTime+_frametime;
--		if (MoTrackLayer.DisableTime>MoTrackLayer.StayTime+MoTrackLayer.FadeTime) then
--			return
--		end
--		if (MoTrackLayer.DisableTime>MoTrackLayer.StayTime) then
--			GlobalFade=1-((MoTrackLayer.DisableTime-MoTrackLayer.StayTime)/MoTrackLayer.FadeTime);
--		end
	end
	MoTrackLayer.fSlowest=99999999;
	MoTrackLayer.nSlowestId=-1;
	local nTrackedObjects=0;
	local pEntities=Game:GetEntitiesScreenSpace("Bip01 Head");
	MoTrackLayer.LastEntities=new(MoTrackLayer.CurrEntities);
	MoTrackLayer.CurrEntities={};
	for i,entity in pEntities do
		local ent=System:GetEntity(entity.pEntity.id);

		--if ((ent) and (ent.cnt) and (ent.cnt.health) and (ent.cnt.health>0)) then
		--if ((ent) and ((ent.Properties) and (ent.Properties.bTrackable))
		--if (((ent.cnt) and (ent.cnt.health>0)) or (not ent.cnt) )) then

		--if ((ent) and (ent.cnt) and (ent.cnt.health) and (ent.cnt.health>0)) then
			
			--if (ent.cnt) then
				--if (ent.cnt.health) then
					--if (ent.cnt.health>0) then

			entity.VelLen=0.01+entity.VelLen+abs(entity.Velocity.z*MoTrackLayer.ZSensivity);
			local ObjectTracked=nil;
			local NewObject=nil;
			local id=entity.pEntity.id;
			-----------------------------
			if (MoTrackLayer.LastEntities[id]) then
				MoTrackLayer.CurrEntities[id]=MoTrackLayer.LastEntities[id];
				if (MoTrackLayer.DisableTime==nil) then	-- only enhance tracking if we the tracker is "online"
					MoTrackLayer.CurrEntities[id].Fade=MoTrackLayer.CurrEntities[id].Fade+entity.VelLen*MoTrackLayer.TrackSpeed*_frametime;
				end

				MoTrackLayer.CurrEntities[id].id=id;
				MoTrackLayer.CurrEntities[id].Position=entity.Position;
				MoTrackLayer.CurrEntities[id].VelLen=entity.VelLen;
				MoTrackLayer.CurrEntities[id].DistFromCenter=entity.DistFromCenter;
				MoTrackLayer.CurrEntities[id].FadeOut=MoTrackLayer.LastEntities[id].FadeOut;
				MoTrackLayer.CurrEntities[id].JustAdded=nil;
				ObjectTracked=1;
			elseif (MoTrackLayer.DisableTime==nil) then	-- only track new objects if we the tracker is "online"
				MoTrackLayer.CurrEntities[id]={};
				MoTrackLayer.CurrEntities[id].bSndPlayed=nil;
				MoTrackLayer.CurrEntities[id].Fade=entity.VelLen*MoTrackLayer.TrackSpeed*_frametime;
				MoTrackLayer.CurrEntities[id].Position=entity.Position;
				MoTrackLayer.CurrEntities[id].VelLen=entity.VelLen;
				MoTrackLayer.CurrEntities[id].FadeOut=nil;
				MoTrackLayer.CurrEntities[id].JustAdded=1;
				ObjectTracked=1;
				NewObject=1;
			end

			if (ObjectTracked) then
				local NewObj=MoTrackLayer.CurrEntities[id];

				if (NewObj.FadeOut==nil) then						
						nTrackedObjects=nTrackedObjects+1;
				else
					NewObj.FadeOut=NewObj.FadeOut+_frametime;
					if (NewObj.FadeOut>=MoTrackLayer.FadeOutTime) then
						--MoTrackLayer.CurrEntities[id]=nil;
					end
				end
			end
					--end
				--end
			--end
		--end
	end
	while (nTrackedObjects>MoTrackLayer.MaxTrackedObjects) do
		MoTrackLayer.fSlowest=99999999;
		MoTrackLayer.nSlowestId=-1;
		for j,trackedentity in MoTrackLayer.CurrEntities do
			if (trackedentity.FadeOut==nil) then
				if (trackedentity.VelLen<MoTrackLayer.fSlowest) then
					MoTrackLayer.fSlowest=trackedentity.VelLen;
					MoTrackLayer.nSlowestId=j;
				end
			end
		end
		if (MoTrackLayer.CurrEntities[MoTrackLayer.nSlowestId].JustAdded) then
			MoTrackLayer.CurrEntities[MoTrackLayer.nSlowestId]=nil;
		else
			MoTrackLayer.CurrEntities[MoTrackLayer.nSlowestId].FadeOut=0;
		end
		nTrackedObjects=nTrackedObjects-1;
	end
	
end
-------------------------------------------------------
function MoTrackLayer:DrawOverlay()

 	if(tonumber(getglobal("cl_motiontracker"))==0) then
	 return;
	end
	
	local GlobalFade=1;
	local firstOne=1; -- scan only the first AI, closest to the center

	for i,entity in MoTrackLayer.CurrEntities do
		local f=entity.Fade/10;
		local OutFadeFactor=1;
		if (f>1) then
			f=1;
			if (not entity.bSndPlayed) then
				Sound:PlaySound(MoTrackLayer.TargetSnd);
				entity.bSndPlayed=1;
				local Entity=System:GetEntity(entity.id);
				if (Entity) then
					Entity.bShowOnRadar=1;
					AI:Signal(0,1,"YOU_ARE_BEING_WATCHED",Entity.id);
				end
			end
		end
		if (entity.FadeOut) then
			OutFadeFactor=1-(entity.FadeOut/MoTrackLayer.FadeOutTime);
		end
		System:DrawImageColor(MoTrackLayer.Indicator, entity.Position.x-MoTrackLayer.TrackerSize/2-(1-f)*MoTrackLayer.MaxTrackerSize/2, entity.Position.y-MoTrackLayer.TrackerSize/4-(1-f)*MoTrackLayer.MaxTrackerSize/4, MoTrackLayer.TrackerSize+(1-f)*MoTrackLayer.MaxTrackerSize, (MoTrackLayer.TrackerSize+(1-f)*MoTrackLayer.MaxTrackerSize)/2, 4, 1, 1, 1, (f*f*f*f)*OutFadeFactor*GlobalFade*0.5);

		--if (entity.bSndPlayed and firstOne==1) then
			-- if the object has been tracked successfully,
			-- and we haven't scanned one already
			-- check if the player wants to scan the character 

			--if ((_localplayer) and (_localplayer.cnt) and (_localplayer.cnt.use_pressed)) then
				-- To scan the character, the player must put them in the center of their view 
				-- in the binocular and press the fire button
				--System:LogToConsole("FIRE WAS PRESSED - DIST FROM CENTER="..entity.DistFromCenter);

				--if (entity.DistFromCenter<232) then
				--	local ent=System:GetEntity(entity.id);		
				--	local len = 0;
				--	if (ent.Properties.specialInfo) then 
				--		len=strlen(ent.Properties.specialInfo);
				--		%Game:WriteHudString( 400-(len*8)*0.5, 300-16, ent.Properties.specialInfo ,1, 0, 0, 1, 16, 16);
				--	end
				--	len=strlen(ent:GetAIName());
				--	%Game:WriteHudString( 400-(len*8)*0.5, 300+32, ent:GetAIName() ,1, 0, 0, 1, 16, 16);

					--len=strlen(ent.Properties.equipEquipment);
					--%Game:WriteHudString( 400-(len*8)*0.5, 300+48, ent.Properties.equipEquipment ,1, 0, 0, 1, 16, 16);

					--len=strlen(ent.Properties.aicharacter_character);
					--%Game:WriteHudString( 400-(len*8)*0.5, 300+48, ent.Properties.aicharacter_character ,1, 0, 0, 1, 16, 16);

					--System:LogToConsole("SCANNING:"..ent.Properties.specialInfo);
					--firstOne=0;
				--end
			--end
		--end	
	end
end
-------------------------------------------------------
function MoTrackLayer:OnShutdown()
	MoTrackLayer.TargetSnd=nil;
end

-------------------------------------------------------
function MoTrackLayer:OnActivate()
	MoTrackLayer.DisableTime=nil;
	MoTrackLayer.CurrEntities={};	-- clear tracking-buffer
	--Game:EnableViewLayer( nLayerId, 1 );	-- enable motiontracker
end

-------------------------------------------------------
function MoTrackLayer:OnDeactivate()
	MoTrackLayer.DisableTime=0;
end