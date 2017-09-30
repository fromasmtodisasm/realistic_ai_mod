

RaisingWater = {

	
	type = "Trigger",

	Properties = {
		WaterVolume="",
		height_start = 0,
		height_end = 3,
		fSpeed = 0.1, -- between 0 and 1 please
		fUpdateTime = 0.1, -- in seconds
	},

	Editor={
		Model="Objects/Editor/T.cgf",
	},

	--currlevel=0,
	--speed= 0,

}

-------------------------------------------------------------------------------
function RaisingWater:OnPropertyChange()
	self:OnReset();
end

-------------------------------------------------------------------------------
function RaisingWater:OnInit()
	self:OnReset();
end

-------------------------------------------------------------------------------
function RaisingWater:OnShutDown()
end

-------------------------------------------------------------------------------
function RaisingWater:OnSave(stm)	
	stm:WriteFloat(self.currlevel);	
	stm:WriteBool(self.waterstopped);
end

function RaisingWater:OnLoadRELEASE(stm)
end

function RaisingWater:OnLoadPATCH1(stm)
end

-------------------------------------------------------------------------------
function RaisingWater:OnLoad(stm)	 
	self.currlevel=stm:ReadFloat();
	self.waterstopped=stm:ReadBool();
	if (self.currlevel>0.0001) then
		self:OnTimer();	
	end
end

-------------------------------------------------------------------------------
function RaisingWater:OnReset()

	self:EnableUpdate(1);

	self.currlevel = 0;
	self.waterstopped = 0;

	self.band_height = self.Properties.height_end-self.Properties.height_start;


	self.speed=(self.Properties.height_end-self.Properties.height_start)*self.Properties.fSpeed;

	

	System:SetWaterVolumeOffset(self.Properties.WaterVolume,0,0,0);

end

-------------------------------------------------------------------------------
function RaisingWater:Event_RaiseWater()
	
	--System:Log("Raise Water!!");

	self.currlevel = 0;
	self:SetTimer(self.Properties.fUpdateTime*1000);

	--System:Log("Set timer to "..self.Properties.fUpdateTime*1000);
	BroadcastEvent(self, "RaiseWater");
end


-------------------------------------------------------------------------------
function RaisingWater:Event_WaterStopped()
	BroadcastEvent(self, "WaterStopped");
	self.waterstopped=1;	
end

-------------------------------------------------------------------------------
function RaisingWater:OnTimer()

	self.currlevel=self.currlevel+self.speed;

	System:SetWaterVolumeOffset(self.Properties.WaterVolume,0,0,self.currlevel);

	--System:Log("Setting water level to "..self.currlevel);

	
	if ( abs(self.currlevel) < abs(self.band_height)) then
		--System:Log("RE-Setting water level ");
		self:SetTimer(self.Properties.fUpdateTime*1000); -- move again
	else
		-- set it exactly where it should end
		if (self.waterstopped==0) then
			self:Event_WaterStopped();
		end
		System:SetWaterVolumeOffset(self.Properties.WaterVolume,0,0,self.band_height);
	end
end

--function RaisingWater:MIN(first, second)
--	if (first < second) then
--		return first
--	else
--		return second
--	end
--end