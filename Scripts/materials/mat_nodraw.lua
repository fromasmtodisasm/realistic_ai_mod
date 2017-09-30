--#Script:LoadScript("scripts/materials/mat_nodraw.lua")
--
-- A simple script that allows us to shoot through a mat
-- without producing sounds or decals

Materials["mat_nodraw"] = {
			type = "nodraw",


			gameplay_physic = {
					piercing_resistence = nil,
					friction = 0,
					},

	bullet_hit = {

	},	
	pancor_bullet_hit = {

	},	

	melee_slash = {

	},

			AI = {
				fImpactRadius = 5,
			},

			}