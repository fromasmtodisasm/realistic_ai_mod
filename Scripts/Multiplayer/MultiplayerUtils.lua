--
-- 
--

MultiplayerUtils = {

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
-- is called by the console command "listplayers"
function MultiplayerUtils:ListPlayers()
	local Entity 
	
	if GameRules then
		Entity = System:GetEntity(GameRules.idScoreboard).cnt;
	elseif ClientStuff then
		Entity = System:GetEntity(ClientStuff.idScoreboard).cnt;
	end

	local iY,X;
	local iLines=Entity:GetLineCount();
	local iColumns=Entity:GetColumnCount();
	
	for iY=0,iLines-1 do
		local idThisClient = Entity:GetEntryXY(ScoreboardTableColumns.ClientID,iY)-1;		-- first element is the clientid-1
		
		if idThisClient~=-1 then
			System:LogAlways(tostring(idThisClient).." "..Entity:GetEntryXY(ScoreboardTableColumns.sName,iY));
		end
	end
	System:LogAlways("");
end



---------------------------------------------------------------------------------
--
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
-- called on the server when client are chatting
-- \param sText string
-- \param sSender player name
-- \param sReceiver "all", team name or player name
-- \param sMessageType "say"=to all ,"sayteam"=to team ,"sayone"=to private
function MultiplayerUtils:OnChatMessage( sText, sSender, sReceiver, sMessageType )

--	System:Log("OnChatMessage: "..sText.."#"..sSender.."#"..sReceiver.."#"..sMessageType);

end


