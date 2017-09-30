RL = {
	name			= "RL",
	object		= "Objects/Weapons/RL/RL_bind.cgf",
	character	= "Objects/Weapons/RL/RL.cgf",

	-- if the weapon supports zooming then add this...
	ZoomActive = 0,												-- initially always 0
	MaxZoomSteps = 3,
	ZoomSteps = { 2, 4, 6, },
	ZoomSound=Sound:LoadSound("Sounds/items/scope.wav"),
	ZoomDeadSwitch= 1,
	TargetLocker=1,
	Sway = 1.0,

	---------------------------------------------------
	PlayerSlowDown = 0.7,									-- factor to slow down the player when he holds that weapon
	---------------------------------------------------
	ActivateSound = Sound:LoadSound("sounds/weapons/Mortar/mortar_33.wav"),	-- sound to play when this weapon is selected
	---------------------------------------------------
	DrawFlare=1,

	FireParams =
	{													-- describes all supported firemodes
		{
			HasCrosshair=1,
			AmmoType="Rocket",
			projectile_class="Rocket",
			reload_time=4.5, -- default 3.82
			fire_rate=3.65,
			fire_activation=FireActivation_OnPress,
			bullet_per_shot=1,
			bullets_per_clip=4,
			FModeActivationTime = 0.0,
			iImpactForceMul = 10,
	
			FireSounds = {
				"Sounds/Weapons/rl/FINAL_RL_MONO.wav",
			},
			FireSoundsStereo = {
				"Sounds/Weapons/rl/FINAL_RL_STEREO.wav",
	
			},
			DrySound = "Sounds/Weapons/AG36/DryFire.wav",
	
	-- Light from flying rocket is enough so this light is not needed
	--		LightFlash = {
	--		fRadius = 5.0,
	--			vDiffRGBA = { r = 1.0, g = 1.0, b = 0.0, a = 1.0, },
	--			vSpecRGBA = { r = 0.3, g = 0.3, b = 0.3, a = 1.0, },
	--			fLifeTime = 0.25,
	--		},
	
			SoundMinMaxVol = { 255, 4, 2600 },
		},
	},
	
	--In multiplayer, if this table exist will be merged with the table above for the firemodes in common.
--	FireParams_Mp =
--	{
--		{
--			bullets_per_clip=1,
--		},
--	},

		SoundEvents={
		--	animname,	frame,	soundfile
		{	"reload1",	18,			Sound:LoadSound("Sounds/Weapons/RL/rl_18.wav",0,80)},
		{	"reload1",	88,			Sound:LoadSound("Sounds/Weapons/RL/rl_78.wav",0,80)},
--		{	"swim",		1,			Sound:LoadSound("Sounds/player/water/underwaterswim2.wav",0,255)},
	},
}

function RL:DrawZoomOverlay( ZoomStep )
	if ( ZoomStep ~= self.PrevZoomStep ) then
		if ( RL.ZoomSound ) then
			Sound:StopSound( RL.ZoomSound );
			Sound:PlaySound( RL.ZoomSound );
		end
		self.PrevZoomStep = ZoomStep;
	end
--	System.DrawRectShader("ScreenDistort", 0, 0, 800, 600, 1, 1, 1, 1);

	if ( RL.ZoomBackgroundTID ) then

		-- [tiago] must add crossair..
		System:Draw2DLine(398-44, 300, 398,  300, 0, 0, 0, 1);
		System:Draw2DLine(402, 300, 402+45, 300, 0, 0, 0, 1);
		System:Draw2DLine(400   ,302, 400   ,302+45, 0, 0, 0, 1);

		-- [tiago] must adjust texel coordinates
		local fTexelWidth=1.0/512.0;
		local fTexelHeight=1.0/1024.0;
		System:DrawImageColorCoords( RL.ZoomBackgroundTID, 0, 0, 400, 600, 4, 1, 1, 1, 1,  fTexelWidth, 1-fTexelHeight, 1-fTexelWidth, fTexelHeight);
		System:DrawImageColorCoords( RL.ZoomBackgroundTID, 800, 0, -400, 600, 4, 1, 1, 1, 1,  fTexelWidth, 1-fTexelHeight, 1-fTexelWidth, fTexelHeight);

	end

--	if ( RL.ZoomTID ) then
--		System.DrawImage( RL.ZoomTID[ZoomStep], 400, 22, 185, 80, 4 );
--	end
	--Game:SetHUDFont("radiosta", "sniperscope");
	Game:SetHUDFont("radiosta", "binozoom");
	
	-- Draw distance
	local myPlayer=_localplayer;
	if ( myPlayer ) then
		local int_pt=myPlayer.cnt:GetViewIntersection();
		if ( int_pt ) then
			local s=format( "%07.2fm", int_pt.len*1.5);
			--Game:WriteHudStringFixed(366, 350, s, 0, 1.0, 0.5, 0.5, 20, 20, 0.6);
			Game:WriteHudString(370, 350, s, 0, 1.0, 0.5, 0.5, 15, 15);
		else
			--Game:WriteHudStringFixed(366, 350, "----.--m", 0, 1.0, 0.5, 0.9, 20, 20, 0.6);
			Game:WriteHudString(370, 350, "----.--m", 0, 1.0, 0.5, 0.9, 20, 20);
		end
	end
end

function RL:ZoomToggle()
	TargetLocker:Activate(self.ZoomActive,"RL");
end

CreateBasicWeapon(RL);

function RL.Client:OnInit()
	local cur_r_TexResolution = tonumber( getglobal( "r_TexResolution" ) );
	if( cur_r_TexResolution >= 1 ) then -- lower res texture for low/med texture quality setting
		RL.ZoomBackgroundTID=System:LoadImage("Textures/Hud/crosshair/RL_scope_low");
	else
		RL.ZoomBackgroundTID=System:LoadImage("Textures/Hud/crosshair/RL_scope");
	end


	-- RL.ZoomBackgroundTID=System:LoadImage("Textures/Hud/crosshair/RL_scope");
	self.ZoomOverlayFunc = RL.DrawZoomOverlay;
	BasicWeapon.Client.OnInit( self );
end

function RL.Client:OnShutDown()
	RL.ZoomBackgroundTID=nil;
end

---------------------------------------------------------------
--ANIMTABLE
------------------
RL.anim_table={}
--AUTOMATIC FIRE
RL.anim_table[1]={
	idle={
		"Idle11",
		"Idle21",
	},
	reload={
		"Reload1",
	},
	fidget={
		"fidget11",
		"fidget21",
	},
	fire={
		"Fire11",
		"Fire21",
	},
	swim={
		"swim",
	},
	activate={
		"Activate1",
	},
}