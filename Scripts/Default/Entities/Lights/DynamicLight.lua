DynamicLight = 
{
	Properties=
	{
		bActive=1, 
		lighttype=0,		
		-- 0=normal light without object,
		-- 1=normal light with object,
		-- 2=industrial light with ropes		
		-- 3=swinglight
--		bCastShadows=0,
        bProjectInAllDirs=0,
        AnimationSpeed=0,
        LightStyle=0,
        CoronaScale=1,

--		vector_RndPos = {x=0.0,y=0.0,z=0.0},
--		vector_LightDir = {x=0.0,y=0.0,z=0.0},
		vector_LightDir = {x=0.0,y=90.0,z=0.0},		
		RndPosFreq=0.5,

		OuterRadius=5,			

		clrDiffuse={1, 1, 1},
		DiffuseMultiplier=1,

		clrSpecular={1, 1, 1},
		SpecularMultiplier=1,

		weight = 5,

		fileModel01="Objects/Editor/invisiblebox.cgf",
		fileModel2="Objects/glm/ww2_indust_set1/lights/LIGHT_INDUST2/light_indust2.cgf",
		fileModel3="Objects/Indoor/lights/light6phys.cgf",
		AnimName="default", 
		bUseAnimation=1,
		ProjectorFov=90,
		texture_ProjectorTexture="",
		shader_lightShader="",
		bAffectsThisAreaOnly=1,
		shakeAmount=100,
		shakeRefreshTime=0,
		bUsedInRealTime=1,
		bFakeLight=0,
		bHeatSource=0,

		bDot3Type=1,		
		bFakeRadiosity=0,
		bOcclusion=0,				

		damping = 0.5,
		sleep_speed = 0.01,
		max_time_step = 0.02,

		bIgnoreTerrain=0,
		bFixedLightDir=0,
		
		-- Table for optimization parameters.
		Optimization = {
			bOnlyForHighSpec = 0,
			bSpecularOnlyForHighSpec = 0,
		},
	},

	TempPos = {x=0.0,y=0.0,z=0.0},

	Editor=
	{
		Model="Objects/Editor/Light_Omni.cgf",
	},

}

function DynamicLight:OnReset()
	self:NetPresent(nil);
	self:EnableUpdate(1);
	--self.active=self.Properties.bActive;	
	
	if (self.Properties.lighttype == 0) then
		self:LoadObject( self.Properties.fileModel01, 0,0);
		self:DrawObject( 0,0 );
	elseif (self.Properties.lighttype == 1) then
		self:LoadObject( self.Properties.fileModel01, 0,0);
		self:DrawObject( 0,1 );
	else
		self:CreateRigidBody(0,1,0);
		self:SetPhysicParams(PHYSICPARAM_SIMULATION, self.Properties );
		local RopeParams = {
			entity_id = -1,
		  entity_part_id = 0,
		};

		if (self.Properties.lighttype == 2) then
			self:LoadCharacter(self.Properties.fileModel2,0);

			self:PhysicalizeCharacter(self.Properties.weight,0,0,0);
			self:SetCharacterPhysicParams(0,"rope1", PHYSICPARAM_ROPE,RopeParams);
			self:SetCharacterPhysicParams(0,"rope2", PHYSICPARAM_ROPE,RopeParams);
			self:SetCharacterPhysicParams(0,"rope1", PHYSICPARAM_SIMULATION, self.Properties);
			self:SetCharacterPhysicParams(0,"rope2", PHYSICPARAM_SIMULATION, self.Properties);		
		else
			self:LoadCharacter(self.Properties.fileModel3,0);

			self:PhysicalizeCharacter(self.Properties.weight,0,0,0);
			self:SetCharacterPhysicParams(0,"rope", PHYSICPARAM_ROPE,RopeParams);
			self:SetCharacterPhysicParams(0,"rope", PHYSICPARAM_SIMULATION, self.Properties);
		end

		self:DrawObject(0, 1);
	end

--	self:SetRadius(0); removed coz it disables bbox update

	--self.proj_tex_id = System:LoadTexture(self.Properties.texture_ProjectorTexture,1);
	
	self:InitDynamicLight(self.Properties.texture_ProjectorTexture, self.Properties.shader_lightShader, 
		self.Properties.bProjectInAllDirs, self.Properties.AnimationSpeed, self.Properties.LightStyle, self.Properties.CoronaScale);
	
	if (self.Properties.shakeRefreshTime>0) then
		self:SetTimer(self.Properties.shakeRefreshTime);
	end
end

function DynamicLight:OnPropertyChange()
	self:OnReset();
end

function DynamicLight:OnDamage( hit )

	--System:LogToConsole("dir="..hit.dir.x..","..hit.dir.y..","..hit.dir.z);
	--System:LogToConsole("pos="..hit.pos.x..","..hit.pos.y..","..hit.pos.z);
	--System:LogToConsole("impact_force="..hit.impact_force_mul);

	if( hit.ipart ) then
		self:AddImpulse( hit.ipart, hit.pos, hit.dir, hit.impact_force_mul );
	else	
		self:AddImpulse( -1, hit.pos, hit.dir, hit.impact_force_mul );
	end	
end

function DynamicLight:OnSave(stm)
	--WriteToStream(stm,self.Properties);
	--stm.WriteInt(self.Properties.bActive);
end

function DynamicLight:OnLoad(stm)
	--self.Properties=ReadFromStream(stm);
	self:OnReset();
	--self.Properties.bActive=stm.ReadInt();
end

function DynamicLight:OnInit()
	self:EnableUpdate(1);
	self:SetUpdateIfPotentiallyVisible(1);
	--self.Pos=self:GetPos();
	self:OnReset();
end

function DynamicLight:OnTimer()
	self:Event_Shake();

	-- this check is needed because in the editor the
	-- shaking time can be set to 0 (no shake) while the light
	-- is still shaking...
	if (self.Properties.shakeRefreshTime>0) then
		self:SetTimer(self.Properties.shakeRefreshTime*1000);
	end
end


function DynamicLight:OnUpdate( DeltaTime )
	local props = self.Properties;

	if (props.bActive == 0) then
		return
	end

	local diffR = props.clrDiffuse[1];
	local diffG = props.clrDiffuse[2];
	local diffB = props.clrDiffuse[3];
	local specR = props.clrSpecular[1];
	local specG = props.clrSpecular[2];
	local specB = props.clrSpecular[3];
	local orad = props.OuterRadius;

	--local pos=new(self:GetPos());
	--self.TempPos=pos;

	self.TempPos=self:GetPos();

	if (props.lighttype>1) then		
--		self.TempPos=self:GetBonePos("lamp");
--	elseif (props.lighttype==3) then		
		self.TempPos=self:GetBonePos("LightBone");
	end	

	
--!-------------------------------


	local Dir=self:GetAngles();
--	Dir.x=Dir.x+props.vector_LightDir.x;
--	Dir.y=Dir.y+props.vector_LightDir.y;
--	Dir.z=Dir.z+props.vector_LightDir.z;

	self:AddDynamicLight(self.TempPos,
				orad, 
				diffR*props.DiffuseMultiplier, 
				diffG*props.DiffuseMultiplier, 
				diffB*props.DiffuseMultiplier,
				1,
				specR*props.SpecularMultiplier, 
				specG*props.SpecularMultiplier, 
				specB*props.SpecularMultiplier,
				1,
				0,
				0, -- not used
				Dir,
				props.ProjectorFov,
				self.proj_tex_id,
				props.bAffectsThisAreaOnly,
				props.bUsedInRealTime,
				props.bHeatSource, 
				props.bFakeLight,
				props.bIgnoreTerrain,
				props.Optimization,
 				props.bDot3Type,
				props.bFakeRadiosity,
				props.vector_LightDir,
				props.bFixedLightDir,
				props.bOcclusion );
end



function DynamicLight:Event_Enable()
	self.Properties.bActive=1;
end

function DynamicLight:Event_Disable()
	self.Properties.bActive=0;

end

function DynamicLight:Event_Shake()
	if (not self.hit) then
		self.hit = {};
		self.hit.dir={x=0,y=0,z=1};
	end
	self.hit.pos=self:GetPos();
	self.hit.dir.x = 0.9;
	self.hit.dir.y = 0.2;
	self.hit.dir.z = 0.2;
	self.hit.impact_force_mul=self.Properties.shakeAmount;
	self:OnDamage(self.hit);
end

function DynamicLight:OnShutDown()
	self.proj_tex_id = nil;
	--if (self.proj_tex_id) then
		--self.proj_tex_id = System:LoadTexture(self.Properties.texture_ProjectorTexture,1);
	--end
end


------------------------------------------------------------------------------------------------------
-- Events to switch material Applied to object.
------------------------------------------------------------------------------------------------------
function DynamicLight:CommonSwitchToMaterial( numStr )
	if (not self.sOriginalMaterial) then
		self.sOriginalMaterial = self:GetMaterial();
	end
	
	if (self.sOriginalMaterial) then
		self:SetMaterial( self.sOriginalMaterial..numStr );
	end
end

------------------------------------------------------------------------------------------------------
function DynamicLight:Event_SwitchToMaterialOriginal(sender)
	self:CommonSwitchToMaterial( "" );
end

------------------------------------------------------------------------------------------------------
function DynamicLight:Event_SwitchToMaterial1(sender)
	self:CommonSwitchToMaterial( "1" );
end
------------------------------------------------------------------------------------------------------
function DynamicLight:Event_SwitchToMaterial2(sender)
	self:CommonSwitchToMaterial( "2" );
end