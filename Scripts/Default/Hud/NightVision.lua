--------------------------------------------------------------------
-- X-Isle Script File
-- Description: Defines the NightVision
-- Created by Lennert Schneider
--------------------------------------------------------------------

NightVision = {
	IsActive = 0,
	
	ActivateSnd=Sound:LoadSound("sounds/items/nvisionactivate.wav"),
	
	Static = 0.43,
	
	BlindnessValue=-1,
}

-------------------------------------------------------
function NightVision:OnInit()
	--NightVision.Mask=System:LoadImage("textures/Hud/NightVisionMulMask");
	NightVision.BlindMask=System:LoadImage("textures/Hud/NightVisionBlindMask");
	self.BlindnessValue=-1;	
end

-------------------------------------------------------
function NightVision:DrawLightning()
	-- The environment can be affected by lightning, which blinds any player 
	-- using Night Vision for a brief period. 

	if (self.BlindnessValue>0) then
		System:DrawImageColor(self.BlindMask, 0, 0, 800, 600, 4, 1,1,1,self.BlindnessValue);
		self.BlindnessValue=self.BlindnessValue-_frametime;
	else
		self.BlindnessValue=-1;
	end
end

-------------------------------------------------------
function NightVision:OnLightning()
	-- here I just set the lighting value because
	-- this function is called from outside some time during
	-- the frame, but the overlay mask for blindness must
	-- be drawn at the end of the frame on top of the already
	-- existing layers, in the already existing function DrawOverlay()

	self.BlindnessValue=1;
end

-------------------------------------------------------
function NightVision:DrawOverlay( DeltaTime )
	--System:DrawRectShader("NoiseMask", 0, 0, 800, 600, 1.0, 1.0, 1.0, self.Static);

	--System:DrawImage(self.Mask, 0, 0, 800, 600, 1);
	self:DrawLightning();
end

-------------------------------------------------------
function NightVision:OnActivate()
	if(not self.OldShadow)then
		System:SetScreenFx("NightVision", 1);						
		Sound:PlaySound( self.ActivateSnd );
		LockToggle=1;
		self.original_color=new(System:GetWorldColor());
		local temp_color=new(self.original_color);
		temp_color[1]=temp_color[1]+0.5; 
		temp_color[2]=temp_color[2]+0.5; 
		temp_color[3]=temp_color[3]+0.5; 
		System:SetWorldColor( temp_color );
		System:Log("Setting new ambient color...");
		self.OldShadow = e_shadow_maps;
		e_shadow_maps = 0;
	end
end
-------------------------------------------------------
function NightVision:OnDeactivate()
	if(self.OldShadow)then
		System:SetScreenFx("NightVision", 0);		
		Sound:StopSound( NightVision.ActivateSnd );
		LockToggle=0;
		
		System:Log("Restoring ambient color..")
		System:SetWorldColor( self.original_color );
		
		e_shadow_maps = self.OldShadow;
		self.OldShadow=nil;
	end
end

-----------------------------------------------------
function NightVision:OnShutdown()
end