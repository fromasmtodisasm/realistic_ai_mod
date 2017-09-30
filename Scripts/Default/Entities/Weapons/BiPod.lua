BiPod = {
	IsActive = 0,
	AccuracyWin = 1.5,
	OldMinSway = 0,
	ActivateSnd = Sound:LoadSound("Sounds/Weapons/bipodopen.wav"),
	DeactivateSnd = Sound:LoadSound("Sounds/Weapons/bipodclose.wav"),
}

function BiPod:Activate( Active )
	if ( BiPod.IsActive == Active ) then
		return
	end
	System:LogToConsole( Active );
	BiPod.IsActive = Active;
	local player = _localplayer;
	if ( BiPod.IsActive ~= 0 ) then
		BiPod.OldMinSway = player.MinSway;
		player.MinSway = player.MinSway / BiPod.AccuracyWin;
		System:LogToConsole( "BiPod enabled" );
		self:StartAnimation(0, "BiPodO");
		Sound:PlaySound( BiPod.ActivateSnd );
	else
		player.MinSway = BiPod.OldMinSway;
		System:LogToConsole( "BiPod disabled" );
		self:StartAnimation(0, "BiPodC");
		Sound:PlaySound( BiPod.DeactivateSnd );
	end
end