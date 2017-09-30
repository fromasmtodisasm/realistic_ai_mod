--
-- 
--

MultiplayerUtils = {

-- deactivated because it's not needed right now
--	RestoreSPSettings=nil,		-- to restore settings from Start() call to after in End() call, nil means multiplayer is started, check with IsStarted()

	ModelColor=
	{
		{0.0,0.0,0.0},	-- 0 black
		{1.0,1.0,1.0},	-- 1 white
		{0.0,0.0,1.0},	-- 2 blue
		{0.0,1.0,0.0},	-- 3 green 
		{1.0,0.0,0.0},	-- 4 red
		{0.0,1.0,1.0},	-- 5 cyan
		{1.0,1.0,0.0},	-- 6 yellow
		{1.0,0.0,1.0},	-- 7 magenta
		{1.0,0.5,0.0},	-- 8 orange
		{0.5,0.5,0.5},	-- 9 grey
	},
}




---------------------------------------------------------------------------------
-- deactivated because it's not needed right now
--function MultiplayerUtils:IsStarted()
--	return self.RestoreSPSettings~=nil;
--end


---------------------------------------------------------------------------------
-- deactivated because it's not needed right now
function MultiplayerUtils:OnMultiplayer()
--
--	if self:IsStarted() then
--		return;
--	end
--
--	System:Log("MultiplayerUtils:OnMultiplayer()");		-- debug
--
--	-- store 
--	self.RestoreSPSettings={};
--	self.RestoreSPSettings.g_MP_fixed_timestep=getglobal("g_MP_fixed_timestep");
--
--	-- change
--	setglobal("g_MP_fixed_timestep",0.01);
end


function MultiplayerUtils:GetServerslotFromName(name)
	local ServerSlots = Server:GetServerSlotMap();

	for i, Slot in ServerSlots do
		local Entity = System:GetEntity(Slot:GetPlayerId());

		if(Entity and Entity:GetName()==name)then
			return Slot;
		end	
	end
end

---------------------------------------------------------------------------------
--
function MultiplayerUtils:OnSinglePlayer()
--	if not self:IsStarted() then
--		return;
--	end
--
--	System:Log("MultiplayerUtils:OnSinglePlayer()");		-- debug
--
--	--restore
--	setglobal("g_MP_fixed_timestep",self.RestoreSPSettings.g_MP_fixed_timestep);
--	
--	self.RestoreSPSettings=nil;
end
