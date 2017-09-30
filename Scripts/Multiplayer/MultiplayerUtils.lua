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




MessageTrack={}; -- for flood protection, stored by sSender{}
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

local bKickPlayer = 0; -- use as toggle
local WarnPlayer = 0;-- remove references


	if (MessageTrack.sSender == nil )then   -- no messages are stored for this sender. Store message then continue normally
		
		local MessageTime = _time; 
		local Repeats = 0;
		local History = {_time};-- preinit, avoid errors
		MessageTrack.sSender = {sMessageType,sText,MessageTime,Repeats,History};
	
	else 
		
		local TimeElapsed = _time - MessageTrack.sSender[3];
		MessageTrack.sSender[3] = _time; -- check if still used
		
	    --check for repeating message
			if (MessageTrack.sSender[2] == sText ) then -- same message as last
				MessageTrack.sSender[4] = MessageTrack.sSender[4] + 1;
			else
				MessageTrack.sSender[2] = sText;
				MessageTrack.sSender[4] = 0;
			end
		---------------------------------------------------------
		--reset count if x seconds have passed
			if (tonumber(sv_flood_reset_time) < TimeElapsed) then
			
				MessageTrack.sSender[4] = 0;
			--	System:Log("time passed, resetting count");
			
			end
		---------------------------------------------------------
		--kick player if they ave repeated the same message too much
		
			if (MessageTrack.sSender[4] > sv_message_repeat - 1) then
		--	System:Log("to many repeats".."  "..tostring(MessageTrack.sSender[4]));
			
			MessageTrack.sSender[4] = 0;
			bKickPlayer = 1;
			end
		---------------------------------------------------------
			
			
------------------------------------------------
------------------------------------------------
-- kick if x messages in n seconds

if ( tonumber(sv_message_flood_protection) == 1 ) then -- we will do the x messages in n seconds check.

	local maxmessages = tonumber(sv_max_messages_per_timeframe);
	local timeframe = tonumber(sv_flood_protection_timeframe);
	local historysize = getn(MessageTrack.sSender[5]) ;-- erroring history does not have a size yet, its nill.

------------------------------------------------
-- fill until history size is big enough	
	
		if (historysize < maxmessages) then -- add message to end of table the return.
			
			tinsert(MessageTrack.sSender[5], _time);
			
						
		else -- there is enough history
		
		--shift entries
				for i, index in MessageTrack.sSender[5] do
					-- if this is the last entry replace val with current time
					if (i == maxmessages) then 
						MessageTrack.sSender[5][i] = _time; --insert current time into last slot
					else 
					local nexti = 0; 
					--	System:Log(tostring(i));
					--	System:Log(tostring(_time));
						-- warning the last slot will be the string n and not the correct number, this is a work around.
						if (tostring(i) ~= "n") then
						nexti = tonumber(i)+ 1; 
						else
						nexti = maxmessages;
						MessageTrack.sSender[5][i] = MessageTrack.sSender[5][nexti];
						end
					end
			
				end
				--end entry shifting
		local DiffTime = MessageTrack.sSender[5][maxmessages] - MessageTrack.sSender[5][1];
		
			if (DiffTime < timeframe) then
					bKickPlayer = 1;
				
			end
			
		end
		
	end


end



	
---- kick offender
	if (bKickPlayer == 1) then

--	System:Log("player should be kicked1");

		if ( tonumber(sv_message_flood_protection) == 1) then 
	
--	System:Log("player should be kicked2");

			if (tonumber(sv_kick_flood_offender) == 1) then
			
			--	System:Log("player should be kicked3");
			
				GameRules:Kick(sSender);
				--System:Log(tostring(sSender).." has been kicked for flood violation.");
				MessageTrack.sSender = nil; --clear history
			end
		end
	--System:Log("OnChatMessage: "..sText.."#"..sSender.."#"..sReceiver.."#"..sMessageType);
	end
end

------------------------------------------------
------------------------------------------------

