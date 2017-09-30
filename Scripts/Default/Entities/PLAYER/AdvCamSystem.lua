AdvCamSystem = 
{
	states =
	{
		-- 1
		{																		-- 1 behind PlayerA watching PlayerB
			src_a_offset={x=0,y=0,z=2.4},			-- 1.7m up
			src_origin=0.0,										-- from PlayerA
			src_b_offset={x=0,y=0,z=0},
			src_ab_offset_m={x=0,y=-2,z=0},		-- 2m behind PlayerA
			src_ab_offset_fac={x=0,y=0,z=0},	
				
			dst_a_offset={x=0,y=0,z=0},
			dst_origin=1.0,										-- to PlayerB
			dst_b_offset={x=0,y=0,z=1.7},			-- 1.7 up = Eye
			dst_ab_offset_m={x=0,y=0,z=0},
			dst_ab_offset_fac={x=0,y=0,z=0},
			
			max_radius = 10,
			min_radius = 3,
			
			show_a = 1,
			show_b = 1,
			
			linked_a = true,
			linked_b = true,
		},
		-- 2
		{																		-- 2 between PlayerA and PlayerB
			src_a_offset={x=0,y=0,z=2.4},			-- 1.7m up
			src_origin=0.5,					--
			src_b_offset={x=0,y=0,z=0},
			src_ab_offset_m={x=0,y=0,z=0},
			src_ab_offset_fac={x=1,y=0,z=0},	-- side
			
			dst_a_offset={x=0,y=0,z=0},
			dst_origin=0.5,					--
			dst_b_offset={x=0,y=0,z=1.7},			-- 1.7 up = Eye
			dst_ab_offset_m={x=0,y=0,z=0},
			dst_ab_offset_fac={x=0,y=0,z=0},

			max_radius = 10,
			min_radius = 3,
			
			show_a = 1,
			show_b = 1,
			
			linked_a = true,
			linked_b = true,
		},
		-- 3
		{																		-- 1 behind PlayerB watching PlayerA
			src_a_offset={x=0,y=0,z=0},				-- 1.7m up
			src_origin=1.0,										-- from PlayerB
			src_b_offset={x=0,y=0,z=2.4},
			src_ab_offset_m={x=0,y=2,z=0},		-- 2m in front of PlayerB
			src_ab_offset_fac={x=0,y=0,z=0},	
				
			dst_a_offset={x=0,y=0,z=1.7},
			dst_origin=0.0,										-- to PlayerB
			dst_b_offset={x=0,y=0,z=0},			-- 1.7 up = Eye
			dst_ab_offset_m={x=0,y=0,z=0},
			dst_ab_offset_fac={x=0,y=0,z=0},

			max_radius = 10,
			min_radius = 3,
			
			show_a = 1,
			show_b = 1,
			
			linked_a = true,
			linked_b = true,
		},
		-- 4
		{																		-- 2 between PlayerA and PlayerB
			src_a_offset={x=0,y=0,z=2.4},			-- 1.7m up
			src_origin=0.5,					--
			src_b_offset={x=0,y=0,z=0},
			src_ab_offset_m={x=0,y=0,z=0},
			src_ab_offset_fac={x=-1,y=0,z=0},	-- side
			
			dst_a_offset={x=0,y=0,z=0},
			dst_origin=0.5,					--
			dst_b_offset={x=0,y=0,z=1.7},			-- 1.7 up = Eye
			dst_ab_offset_m={x=0,y=0,z=0},
			dst_ab_offset_fac={x=0,y=0,z=0},

			max_radius = 10,
			min_radius = 3,
			
			show_a = 1,
			show_b = 1,
			
			linked_a = true,
			linked_b = true,
		},
		-- 5
		{																		-- 3 3rd person behind PlayerA
			src_a_offset={x=0,y=0,z=2.0},			-- 
			src_origin=0.0,										-- from PlayerA
			src_b_offset={x=0,y=0,z=0},
			src_ab_offset_m={x=0,y=0,z=0},		--
			src_ab_offset_fac={x=0,y=0,z=0},	--
			
			dst_a_offset={x=0,y=-1,z=1.5},
			dst_origin=0.0,					-- to PlayerA
			dst_b_offset={x=0,y=0,z=0},		--
			dst_ab_offset_m={x=0,y=0,z=0},
			dst_ab_offset_fac={x=0,y=0,z=0},

			max_radius = 10,
			min_radius = 3,
			
			show_a = 1,
			show_b = 1,
			
			linked_a = true,
			linked_b = true,
		},
		-- 6
		{																		-- 1st person PlayerA watching PlayerB
			src_a_offset={x=0,y=0,z=1.7},			-- 1.7m up
			src_origin=0.0,										-- from PlayerA
			src_b_offset={x=0,y=0,z=0},
			src_ab_offset_m={x=0,y=0,z=0},		-- 0m behind PlayerA .. first person
			src_ab_offset_fac={x=0,y=0,z=0},	
				
			dst_a_offset={x=0,y=0,z=0},
			dst_origin=1.0,										-- to PlayerB
			dst_b_offset={x=0,y=0,z=1.7},			-- 1.7 up = Eye
			dst_ab_offset_m={x=0,y=0,z=0},
			dst_ab_offset_fac={x=0,y=0,z=0},

			max_radius = 10,
			min_radius = 0,
			
			show_a = 0,												-- hide PlayerA
			show_b = 1,
			
			linked_a = true,
			linked_b = true,
		},
		-- 7
		{																		-- 1st person PlayerA watching PlayerB
			src_a_offset={x=0,y=0,z=1.7},			-- 1.7m up
			src_origin=0.0,										-- from PlayerA
			src_b_offset={x=0,y=0,z=0},
			src_ab_offset_m={x=0,y=0,z=0},		-- 0m behind PlayerA .. first person
			src_ab_offset_fac={x=0,y=0,z=0},	
				
			dst_a_offset={x=0,y=0,z=0},
			dst_origin=1.0,										-- to PlayerB
			dst_b_offset={x=0,y=0,z=1.7},			-- 1.7 up = Eye
			dst_ab_offset_m={x=0,y=0,z=0},
			dst_ab_offset_fac={x=0,y=0,z=0},

			max_radius = 10,
			min_radius = 0,
			
			show_a = 0,												-- hide PlayerA
			show_b = 1,
			
			linked_a = true,
			linked_b = true,
		},
		-- 8 - First person player ... no focus on other player
		{																		-- 1st person Player A
			src_a_offset={x=0,y=0,z=1.7},			-- 1.7m up
			src_origin=0.0,										-- from PlayerA
			src_b_offset={x=0,y=0,z=0},
			src_ab_offset_m={x=0,y=0,z=0},		-- 0m behind PlayerA .. first person
			src_ab_offset_fac={x=0,y=0,z=0},	
				
			dst_a_offset={x=0,y=-2,z=0},				-- watching the front
			dst_origin=0.0,										
			dst_b_offset={x=0,y=0,z=1.7},			-- 1.7 up = Eye
			dst_ab_offset_m={x=0,y=0,z=0},
			dst_ab_offset_fac={x=0,y=0,z=0},

			max_radius = 10,
			min_radius = 0,
			
			show_a = 0,												-- hide PlayerA
			show_b = 1,
			
			linked_a = false,
			linked_b = true,
		},
		-- 9 - Focus on PlayerB
		{
			src_a_offset={x=0,y=0,z=0},
			src_origin=0.5,										-- from PlayerB
			src_b_offset={x=0.0,y=0.0,z=4.0},
			src_ab_offset_m={x=0,y=0,z=0},
			src_ab_offset_fac={x=0,y=0,z=0},	
				
			dst_a_offset={x=0,y=0,z=0.0},				-- watching PlayerB
			dst_origin=1.0,										
			dst_b_offset={x=0,y=0,z=1.7},			-- 1.7 up = Eye
			dst_ab_offset_m={x=0,y=0,z=0},
			dst_ab_offset_fac={x=0,y=0,z=0},

			max_radius = 10,
			min_radius = 0,
			
			show_a = 1,												-- hide PlayerA
			show_b = 1,
			
			linked_a = true,
			linked_b = true,
		},
		-- 10 - Focus on PlayerB
		{
			src_a_offset={x=0,y=0,z=1.7},
			src_origin=0.0,										-- from PlayerB
			src_b_offset={x=0,y=0,z=0},
			src_ab_offset_m={x=0,y=0,z=0},
			src_ab_offset_fac={x=0,y=0,z=0},	
				
			dst_a_offset={x=0,y=0,z=0.0},				-- watching PlayerB
			dst_origin=1.0,										
			dst_b_offset={x=0,y=0,z=1.7},			-- 1.7 up = Eye
			dst_ab_offset_m={x=0,y=0,z=0},
			dst_ab_offset_fac={x=0,y=0,z=0},

			max_radius = 10,
			min_radius = 0,
			
			show_a = 0,												-- hide PlayerA
			show_b = 1,
			
			linked_a = true,
			linked_b = true,
		},
	},
	currentState = 1,
	futureState = 1,
	blendFactor = 0,
	blendTime = 0.3,
	isBlending = false
}

function AdvCamSystem:OnInit()
end

function AdvCamSystem:OnShutDown()
end

function AdvCamSystem:OnUpdate( DeltaTime )
	if self.currentState ~= self.futureState then
		self.blendFactor = self.blendFactor + DeltaTime/self.blendTime;

		if self.blendFactor > 1 then
			self.blendFactor = 0;
			self.currentState = self.futureState;
			CamProtoSet(self.currentState, self);
		end
	else
		self.blendFactor = 0;
	end
end

function AdvCamSystem:OnContact( Entity )
end

function AdvCamSystem:OnEvent( EventId, Params )
end

function AdvCamSystem:OnWrite( stm )
end

function AdvCamSystem:OnRead( stm )
end

function AdvCamSystem:OnSave( stm )
end

function AdvCamSystem:OnLoad( stm )
end 

--function CamProto( )
--	Script:LoadScript("SCRIPTS\Default\Entities\PLAYER\AdvCamSystem.lua");
--	CameraPrototypeTest();
--end

-- _localplayer.cnt:DrawThirdPersonWeapon(0);		
-- _localplayer.cnt.drawfpweapon

function CamProtoTest( i )
	Hud:AddMessage("CameraPrototypeTest()");
	
	-- local entPly2=Server:SpawnEntity("Pig");
	local entPly2=Server:SpawnEntity("Player");
	---local entPly2=Server:SpawnEntity("MutantMonkey");
	ai_systemupdate = 0;

	local entCam=Server:SpawnEntity("AdvCamSystem");

	local wpos=_localplayer:GetPos();

	wpos.x=wpos.x-2;
	entCam:SetPos(wpos);	
	wpos.x=wpos.x-2;
	entPly2:SetPos(wpos);	

	entCam.cnt:SetPlayerA(_localplayer.id);
	entCam.cnt:SetPlayerB(entPly2.id);

	-- hide 1st person stuff
	_localplayer.cnt.drawfpweapon = 0;

	-- set entCam as new player
	local slots = Server:GetServerSlotMap();
	for i, slot in slots do
		slot:SetPlayerId(entCam.id);
	end
	
	CamProtoSet(i, entCam);
end

function CamProtoSet( i, entity )
	-- set camera position
	if i == nil then
		i = 1;
	end
	
	if entity == nil then
		entity = _localplayer;
	end
	
	entity.currentState = i;
	entity.futureState = i;
	entity.isBlending = false;
	
	entA = entity.cnt:GetPlayerA();
	entB = entity.cnt:GetPlayerB();
	
	System:GetEntity(entA):DrawCharacter(0, entity.states[entity.currentState].show_a);
	System:GetEntity(entB):DrawCharacter(0, entity.states[entity.currentState].show_b);
	
	if entity.states[entity.currentState].show_a == 0 then
		System:GetEntity(entA).cnt.drawfpweapon = 1;
	end
end

function CamProtoSwap()
	local entSwap=_localplayer.cnt:GetPlayerA();
	_localplayer.cnt:SetPlayerA(_localplayer.cnt:GetPlayerB());
	_localplayer.cnt:SetPlayerB(entSwap);
end

function CamSetMaxRadius( radius )
	_localplayer.max_radius = radius;
end

function CamSetMinRadius( radius )
	_localplayer.min_radius = radius;
end
