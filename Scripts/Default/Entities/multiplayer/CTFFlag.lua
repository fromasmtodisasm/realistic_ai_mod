CTFFlag={
	Properties={
		team="red",
	},
	CTF_FLAG=1,
	FlagCarrier={
--	flag_carrier=nil,			Game:GetTeamFlags(self.Properties.team)
	},
}

function CTFFlag:LoadGeometry()
	if(not self.geometry_loaded)then
		self.geometry_loaded=1
		if (self.Properties.team=="red") then
			self:LoadObject("objects/multiplayer/FlagRed/flag_red_stationary.cgf",0,1);
		elseif (self.Properties.team=="blue") then
			self:LoadObject("objects/multiplayer/FlagBlue/flag_blue_stationary.cgf",0,1);
		else
			System:Error( "Unknown flag team, unable to load CTF flag model.  Specify blue or red in editor");
		end
		
		--<<FIXME>> put the right modela
		self:LoadCharacter("Objects/Pickups/Armor/armor_icon.cga",0);
	end
end

function CTFFlag:RegisterStates()
	self:RegisterState("AtHome");
	self:RegisterState("Captured");
	self:RegisterState("Dropped");
end

function CTFFlag:OnReset()
	self:GotoState("AtHome");
end

function CTFFlag:CaptureFlag(team,carrier)
	GameRules:SetCapture(team,carrier);
	self:GotoState("Captured");
end

function CTFFlag:ReturnFlag()
	if(self.original_pos)then
		self:SetPos(self.original_pos);
		self:SetAngles(self.original_angles);
	end
end

function CTFFlag:Server_AtHome_OnContact(collider)
	--System:Log("GAMESTATE"..GameRules:GetGameState());
	if((GameRules:GetState()=="INPROGRESS") and (collider.type=="Player") and (collider.cnt.health>0))then
		local team=Game:GetEntityTeam(collider.id);
		if((team~=self.Properties.team))then
			--FLAG CAPTURED
			self:CaptureFlag(team,collider);
		else
			--IF IS THE CARRIER OF THE FLAG ..SCORE
			if(GameRules:IsFlagCarrier(team,collider))then
				--SCORE!!!!
				local other_flag=GameRules:GetOtherFlag(self);
				
--				collider:Unbind(other_flag);
				other_flag:ReturnFlag();
				GameRules:TeamCapture(team,collider);
				other_flag:GotoState("AtHome");	
			end
		end
	end
end

function CTFFlag:Server_Dropped_OnContact(collider)
	if((GameRules:GetState()=="INPROGRESS") and (collider.type=="Player") and (collider.cnt.health>0))then
		local team=Game:GetEntityTeam(collider.id);
		if((team~=self.Properties.team))then
			--FLAG CAPTURED
			self:CaptureFlag(team,collider);
		else
			Server:BroadcastText(self.Properties.team.." @FlagReturn");
			self:ReturnFlag();
			self:GotoState("AtHome");
		end
		
	end
end

function CTFFlag:OnPlayerDie(carrier)
	local team=Game:GetEntityTeam(carrier.id);
	if(team~=self.Properties.team and GameRules:IsFlagCarrier(team,carrier))then
	--	carrier:Unbind(self);
		self:DropFlag(carrier, team);
	else
		System:Log("CTFFlag:OnPlayerDie is not the flag carrier");
	end
end

function CTFFlag:DropFlag(carrier,team)
	self:SetPos(carrier:GetPos());
	self:SetAngles(self.original_angles);
	GameRules:ResetCapture(team,carrier);
	Server:BroadcastText(team.." @FlagLost");
	self:GotoState("Dropped");
end

function CTFFlag:DetachFlagFromCarrier()
	-- Stop displaying and detach the flag
	
--	local carrierid=Game:GetTeamFlags(self.Properties.team);
--	local carrier=Game:GetEntityTeam( carrierid );
	
--	if carrier then
--		carrier:DetachObjectToBone("Bip01 Spine2", self.FlagCarrier.bind_handle);
--		self:GotoState("AtHome");
--	end
end

	
----------------------------------------------------
--SERVER
----------------------------------------------------
CTFFlag.Server={
	OnInit=function(self)
		self:LoadGeometry()
		self:RegisterStates();
		self:OnReset();
		--the entity will not move so only the state change is sycronized over the net
		self:NetPresent(1);
		self:EnableUpdate(1);
		if(GameRules.RegisterFlag)then
			GameRules:RegisterFlag(self);
		end
	end,
-------------------------------------
	AtHome={
		OnBeginState=function(self)
			self.original_pos=new(self:GetPos());
			self.original_angles=new(self:GetAngles());
			local p=self.original_pos;
--			System:Log("AtHome pos=("..p.x..","..p.y..","..p.z..")")
		end,
		OnContact=CTFFlag.Server_AtHome_OnContact,
	},
-------------------------------------
	Captured={
		OnBeginState=function(self)
			System:Log("CAPTURED")
		end,
		
	},
-------------------------------------
	Dropped={
		OnBeginState=function(self)
			System:Log("DROPPED")
		end,
		OnContact=CTFFlag.Server_Dropped_OnContact,
	},
}

----------------------------------------------------
--CLIENT
----------------------------------------------------
CTFFlag.Client={
	OnInit=function(self)
		self:LoadGeometry()
		self:RegisterStates();
		self:OnReset();
		self:EnableUpdate(1);
	end,
-------------------------------------
	AtHome={
		OnBeginState=function(self)
			System:Log("AtHome CLI")
			self:DrawObject(0,1);
		--	self:DrawObject(1,0);
			
			self:DetachFlagFromCarrier();
			
			self:DrawCharacter(0,0);
			
			--self:DrawCharacter(0,0);
		end,
	},
-------------------------------------
	Captured={
		OnBeginState=function(self)
			System:Log("CAPTURED CLI")
			self:DrawObject(0,0);
	--		self:DrawObject(1,1);
			self:DrawCharacter(0,0);			
		end,
	},
-------------------------------------
	Dropped={
		OnBeginState=function(self)
			System:Log("DROPPED CLI")
			self:DrawObject(0,1);
	--		self:DrawObject(1,0);
			self:DrawCharacter(0,0);
			
			self:DetachFlagFromCarrier();
			
			--self:DrawObject(0,1);
			--self:DrawCharacter(0,0);
		end,
	},
}