Script:LoadScript("scripts/materials/commoneffects.lua");

Materials["mat_pickup"] = {
	type="pickup",
-------------------------------------	
	PhysicsSounds=PhysicsSoundsTable.Soft,
-------------------------------------	
	bullet_hit = {
	},
	pancor_bullet_hit = {
	},


	projectile_hit = CommonEffects.common_projectile_hit,
	mortar_hit = CommonEffects.common_mortar_hit,
	smokegrenade_hit = CommonEffects.common_smokegrenade_hit,
	flashgrenade_hit = CommonEffects.common_flashgrenade_hit,
	grenade_hit = CommonEffects.common_grenade_hit,
	melee_slash = {

	},
-------------------------------------
	player_walk = CommonEffects.player_pebble_walk,
	player_run = CommonEffects.player_pebble_run,
	player_crouch = CommonEffects.player_pebble_crouch,
	player_prone = CommonEffects.player_pebble_prone,
	player_walk_inwater = CommonEffects.player_walk_inwater,
	
	player_drop = {
		sounds = {
			{"sounds/player/bodyfalls/bodyfallmud1.wav",SOUND_UNSCALABLE,210,10,150},
		},

	},
-------------------------------------
	player_land = {
		sounds = {
			--sound , volume , {min, max}
			--NOTE volume and min max are optional
			 {"sounds/doors/dooropen.wav",SOUND_UNSCALABLE,200,1,20},
			 {"sounds/doors/dooropen.wav",SOUND_UNSCALABLE,200,1,20},
			
		},
	},
	gameplay_physic = {
		piercing_resistence = 15,
		friction = 100.0,
		bouncyness= -1, -- default 0
	},

	AI = {
		fImpactRadius = 5,
	},		
}