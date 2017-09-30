Tripod = {
	name = "Tripod",
	type = "Tripod",


	Properties = {
	gunClass = "smVulcan",		
	tripodCGF = "Objects/weapons/tripod/tripod2.cgf",			
	},


	theWeapon = nil,

	IsPhisicalized = 0,
	
	firstTime = 1,

	weaponDirection = {0,0,0},
	
}

----------------------------------
function Tripod:Client_OnInit()

	self:SetName( self.name );
	self.type = "Tripod";

--	self:OnReset( );
	if(self.IsPhisicalized == 0) then	
		self:LoadObject(self.Properties.tripodCGF, 0, 1);
		self:CreateStaticEntity( 100, 0 );
		self.IsPhisicalized = 1;
	end

		
	self:DrawObject(0, 1);
	self:RenderShadow( 1 );

	
	
	
	
--	self.cnt.Mount();
--	BasicWeapon.Client_OnInit( self );
	
end


----------------------------------
function Tripod:Server_OnInit()

	self:SetName( self.name );
	self.type = "Tripod";

--	self.OnReset(self);	
	self:OnReset( );

	self:LoadObject(self.Properties.tripodCGF, 0, 1);
	self:CreateStaticEntity( 100, 0 );
	self.IsPhisicalized = 1;

	self.theWeapon = Server:SpawnEntity( self.Properties.gunClass );
	
	if( self.theWeapon ) then
		self.theWeapon:EnableSave(nil);
		self.theWeapon:GotoState("Idle");
		self.theWeapon:SetAngles({x=0,y=0,z=0});
		self:Bind( self.theWeapon );
		self.theWeapon:SetPos(self:GetHelperPos("gun_rotate", 1));
		self.theWeapon:EnablePhysics(0);
	end

	self.weaponDirection = self:GetAngles();
	AI:RegisterWithAI(self.id, AIOBJECT_MOUNTEDWEAPON);
--self:RegisterWithAI(AIOBJECT_MOUNTEDWEAPON);	
	
	self:NetPresent(1);
end


----------------------------------
function Tripod:Server_OnContact( player )

	if( self.theWeapon == nil )then
		do return end
	end	

	if(player.type ~= "Player" ) then
		do return end
	end

	if( self.theWeapon.theUser ) then
		do return end
	end	

	if( player.cnt.use_pressed ) then
		player.cnt.use_pressed = nil;
		self.theWeapon:SetGunner( player );
		self.theWeapon:SetAngles(self.weaponDirection);
		
printf("in ANGL %.2f %.2f %.2f",self.weaponDirection.x, self.weaponDirection.y, self.weaponDirection.z );		
--	else
--		Hud.label = "Press USE to use this weapon...";
	end	
end

----------------------------------
function Tripod:Client_OnContact( player )

	if( self.theWeapon == nil )then
		do return end
	end	

	if(player.type ~= "Player" ) then
		do return end
	end

	if( self.theWeapon.theUser ) then
		do return end
	end	

	if( player.cnt.use_pressed ) then
		player.cnt.use_pressed = nil;
		self.theWeapon:SetGunner( player );
	else
		Hud.label = "Press USE to use this weapon...";
	end	
end


----------------------------------
function Tripod:Server_OnUpdate( dt )

	if( self.theWeapon == nil ) then
		return
	end	
	
	if( self.theWeapon.theUser == nil ) then
		do return end
	end	
	
	if( self.theWeapon.theUser.cnt.use_pressed ) then
		self.theWeapon.theUser.cnt.use_pressed = nil;

printf( "weapon stpUse called" );		
		
		self.theWeapon:StopUsing(  );
--	else
--		Hud.label = "Press USE to use this weapon...";
		self.weaponDirection = self.theWeapon:GetAngles(1);
printf("out ANGL %.2f %.2f %.2f",self.weaponDirection.x, self.weaponDirection.y, self.weaponDirection.z );

	end	
	
	
--	CallCurrentServerStateMethod( self.theWeapon, "CheckTripod", self  );
--	self.theWeapon:CheckTripod( self );
--	self.theWeapon.Server.CheckTripod1( self.theWeapon, self );
end


----------------------------------
function Tripod:Client_OnBind( weapon, par )

--System:Log( " tripod bind " );

	self:Bind( weapon );
	self.theWeapon = weapon;
	weapon:EnablePhysics(0);
end


--------------------------------------------------------------------------------------------
Tripod.Client = {

	OnInit = function(self)
		self:Client_OnInit();
	end,
	OnBind = function(self, weapon, par)
 		self:Client_OnBind(weapon, par);
	end,
	OnContact = function(self,player)
 		self:Client_OnContact(player);
	end,
}

Tripod.Server = {

	OnInit = function(self)
		self:Server_OnInit( );
	end,
	OnContact = function(self,player)
		self:Server_OnContact(player);
	end,	
	OnUpdate = function(self,dt)
 		self:Server_OnUpdate(dt);
	end,
}


------------------------------------------------------------------------------------------------------
function Tripod:OnReset()

	self.IsPhisicalized = 0;
	
	
printf("RESET!!! ---------------------------------------------------------------------");				
	if( self.theWeapon ~= nil ) then
printf("SHUT DOWN!!! ---------------------------------------------------------------------");			
		if( self.theWeapon.theUser ~= nil ) then
printf("Stop user!!! ---------------------------------------------------------------------");						
				self.theWeapon:StopUsing(  );
		end	
--		Server:RemoveEntity(self.theWeapon.id);
	end	
--	self.weaponDirection = self:GetAngles();
end



------------------------------------------------------------------------------------------------------
function Tripod:OnShutDown()

printf("SHUT DOWN!!!");

	if( self.theWeapon == nil ) then
		return
	end	
	Server:RemoveEntity(self.theWeapon.id);
	if( self.theWeapon.theUser == nil ) then
		do return end
	end	
printf("SHUT DOWN!!! ---------------------------------------------------------------------");	
		self.theWeapon:StopUsing(  );

--	self.IsPhisicalized = 0;
end

------------------------------------------------------------------------------------------------------