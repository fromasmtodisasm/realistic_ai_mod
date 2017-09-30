-- #Script.ReloadScript("scripts/default/entities/player/basicplayer.lua")

DeadBody =	 {
---------------------------------------------- common data
  	type = "DeadBody",


	isPhysicalized = 0,
	temp_ModelName ="",
	
	DeadBodyParams = {
	  max_time_step = 0.025,
	  gravityz = -7.5,
	  sleep_speed = 0.025,
	  damping = 0.3,
	  freefall_gravityz = -9.81,
	  freefall_damping = 0.1,

	  lying_mode_ncolls = 4,
	  lying_gravityz = -5.0,
	  lying_sleep_speed = 0.065,
	  lying_damping = 1.5,
	  sim_type = 1,
		lying_simtype = 1,
	},

	PhysParams = {
		mass = 80,
		height = 1.8,
		eyeheight = 1.7,
		sphereheight = 1.2,
		radius = 0.45,
	},

  BulletImpactParams = {
    stiffness_scale = 73,
    max_time_step = 0.01
  },

	Properties = {
		bResting = 1,
		fileModel = "Objects/characters/mercenaries/Merc_rear/merc_rear.cgf",
	  lying_gravityz = -5.0,
    lying_damping = 1.5,
    bCollidesWithPlayers = 0,
    bPushableByPlayers = 0,
    Mass = 80,
	},
}


-----------------------------------------------------------------------------------------------------------
function DeadBody:OnReset()
	--self.temp_ModelName ="";
	--self:OnPropertyChange();
	
	self:LoadCharacter(self.Properties.fileModel,0);
	self:StartAnimation( 0,"cidle" );
	self:Physicalize();
end

-----------------------------------------------------------------------------------------------------------
function DeadBody:Server_OnInit()
	if(self.isPhysicalized == 0) then	
		self:SetUpdateType( eUT_Physics );
		DeadBody.OnPropertyChange( self );
		self.isPhysicalized = 1;	
	end

end


-----------------------------------------------------------------------------------------------------------
function DeadBody:Client_OnInit()
	if(self.isPhysicalized == 0) then	
		self:SetUpdateType( eUT_Physics );
		DeadBody.OnPropertyChange( self );
		self.isPhysicalized = 1;	
	end

--	self:RenderShadow( 1 ); -- enable rendering of player shadow

	self:SetShaderFloat("HeatIntensity",0,0,0);
end


-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------
function DeadBody:Server_OnDamageDead( hit )
--printf("server on Damage DEAD %.2f %.2f",hit.impact_force_mul_final,hit.impact_force_mul);
  --System:Log("DeadBody hit part "..hit.ipart);
	if( hit.ipart ) then
		self:AddImpulse( hit.ipart, hit.pos, hit.dir, hit.impact_force_mul );
	else	
		self:AddImpulse( -1, hit.pos, hit.dir, hit.impact_force_mul );
	end	
end


-----------------------------------------------------------------------------------------------------------

function DeadBody:OnPropertyChange()
	--System:LogToConsole("prev:"..self.temp_ModelName.." new:"..self.Properties.fileModel);
	
	self.PhysParams.mass = self.Properties.Mass;

	if (self.Properties.fileModel ~= self.temp_ModelName) then
		self.temp_ModelName = self.Properties.fileModel;
		self:LoadCharacter(self.Properties.fileModel,0);
	end
	self:Physicalize();
end

--------------------------------------------------------------------------------------------------------
function DeadBody:Physicalize()
	self:CreateLivingEntity(self.PhysParams, Game:GetMaterialIDByName("mat_flesh"));
	local nMaterialID=Game:GetMaterialIDByName("mat_meat");
	self:PhysicalizeCharacter(self.PhysParams.mass, nMaterialID, self.BulletImpactParams.stiffness_scale, 0);
	self:SetCharacterPhysicParams(0,"", PHYSICPARAM_SIMULATION,self.BulletImpactParams);
	self:KillCharacter(0);
	if (self.Properties.lying_damping) then
		self.DeadBodyParams.lying_damping = self.Properties.lying_damping;
	end	
  if (self.Properties.lying_gravityz) then
		self.DeadBodyParams.lying_gravityz = self.Properties.lying_gravityz;
	end	
	self:SetPhysicParams(PHYSICPARAM_SIMULATION, self.DeadBodyParams);
	self:SetPhysicParams(PHYSICPARAM_ARTICULATED, self.DeadBodyParams);
	local flagstab = { flags_mask=geom_colltype_player, flags=geom_colltype_player*self.Properties.bCollidesWithPlayers };
	self:SetPhysicParams(PHYSICPARAM_PART_FLAGS, flagstab);
	flagstab.flags_mask = pef_pushable_by_players;
	flagstab.flags = pef_pushable_by_players*self.Properties.bPushableByPlayers;
	self:SetPhysicParams(PHYSICPARAM_FLAGS, flagstab);
	self:EnablePhysics(1);
	if (self.Properties.bResting == 1) then
		self:AwakePhysics(0);
	else
		self:AwakePhysics(1);
	end
end

--------------------------------------------------------------------------------------------------------
function DeadBody:Event_Awake()
	self:AwakePhysics(1);
end

--------------------------------------------------------------------------------------------------------
DeadBody.Server =
{
	OnInit = DeadBody.Server_OnInit,
--	OnShutDown = function( self ) end,
	OnDamage = DeadBody.Server_OnDamageDead,
}

--------------------------------------------------------------------------------------------------------
DeadBody.Client =
{
	OnInit = DeadBody.Client_OnInit,
--	OnShutDown = DeadBody.Client_OnShutDown,
	OnDamage=DeadBody.Client_OnDamage,
}

--------------------------------------------------------------------

