Script:LoadScript("scripts/Multiplayer/TeamHud.lua")
function Hud:OnInit()
	self:CommonInit()
	-- Language:LoadStringTable("MultiplayerHUD.xml")
	if getglobal("g_language") and strlower(getglobal("g_language"))=="russian" then
		Language:LoadStringTable("MultiplayerHUD_ru.xml")
	else
		Language:LoadStringTable("MultiplayerHUD_en.xml")
	end
	self.PlayerObjectiveAnimTex=System:LoadImage("textures/hud/multiplayer/TDM_Logo")
	self.PlayerObjectiveAnim=4
end