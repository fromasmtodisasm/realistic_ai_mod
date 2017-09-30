Script:LoadScript("scripts/materials/commoneffects.lua");

Materials["mat_bounce"] = {
	type="bounce",
	gameplay_physic = {
		piercing_resistence = nil,
		bouncyness = 0.25, -- default 0.33
		friction = 4, -- default 3
	},		

	AI = {
		fImpactRadius = 5,
	},

}
