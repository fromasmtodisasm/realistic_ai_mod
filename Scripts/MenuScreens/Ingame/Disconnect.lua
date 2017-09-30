UI.PageDisconnect=
{
	GUI=
	{
		OnActivate = function(Sender)
			Game:Disconnect();
		end,
	},
}

UI:CreateScreenFromTable("Disconnect", UI.PageDisconnect.GUI);