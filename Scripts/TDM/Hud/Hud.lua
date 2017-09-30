Script:LoadScript("scripts/Multiplayer/TeamHud.lua");

-----------------------------------------------------------------------------
function Hud:OnInit()
	self:CommonInit();
	Language:LoadStringTable("MultiplayerHUD.xml");
	
	self.PlayerObjectiveAnimTex=System:LoadImage("textures/hud/multiplayer/TDM_Logo");
	self.PlayerObjectiveAnim=4;
end
