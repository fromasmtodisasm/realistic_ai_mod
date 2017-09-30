
Script:LoadScript("scripts/materials/commoneffects.lua")

Materials["mat_grass_tall"] = {
	type="grass_tall",
-------------------------------------	
	PhysicsSounds=PhysicsSoundsTable.Soft,
-------------------------------------
	projectile_hit = CommonEffects.common_projectile_hit,
	-- mg_hit = CommonEffects.common_mg_hit,
	grenade_hit = CommonEffects.common_grenade_hit,
	rock_hit = {
		sounds = {
			{"Sounds/BulletHits/Stone/stone_grass_tall1.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_grass_tall4.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_grass_tall5.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_grass_tall6.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/Stone/stone_grass_tall9.mp3",SOUND_UNSCALABLE,255,2,100},
		},
	},
	bullet_hit = {
		sounds = {
			{"Sounds/BulletHits/Grass/1.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Grass/2.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Grass/3.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Grass/4.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Grass/5.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Grass/6.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Grass/7.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Grass/8.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/9.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/10.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/11.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Grass/12.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Grass/13.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/14.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Grass/15.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/16.mp3",SOUND_UNSCALABLE,255,3,101},
		},
		decal = {
			texture = System:LoadTexture("Textures/Decal/ground.dds"),
			scale = .03,
		},

		
		particleEffects = {
			name = "bullet.hit_leaf.a",
		},
		
	},

	pancor_bullet_hit = {
		sounds = {
			{"Sounds/BulletHits/Grass/1.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Grass/2.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Grass/3.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Grass/4.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Grass/5.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Grass/6.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Grass/7.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Grass/8.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/9.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/10.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/11.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Grass/12.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Grass/13.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/14.mp3",SOUND_UNSCALABLE,255,3,101},
			-- {"Sounds/BulletHits/Grass/15.mp3",SOUND_UNSCALABLE,255,3,101},
			{"Sounds/BulletHits/Grass/16.mp3",SOUND_UNSCALABLE,255,3,101},
		},
		decal = {
			texture = System:LoadTexture("Textures/Decal/ground.dds"),
			scale = .03,
		},

		
		particleEffects = {
			name = "bullet.hit_leaf.a",
		},
		
	},

	mortar_hit = CommonEffects.common_mortar_hit,
	smokegrenade_hit = CommonEffects.common_smokegrenade_hit,
	flashgrenade_hit = CommonEffects.common_flashgrenade_hit,
	melee_slash = {
		sounds = {
			--{"sounds/player/footsteps/metal/step1.wav",SOUND_UNSCALABLE,185,5,30},
			--{"sounds/player/footsteps/metal/step2.wav",SOUND_UNSCALABLE,185,5,30},
			--{"sounds/player/footsteps/metal/step3.wav",SOUND_UNSCALABLE,185,5,30},
			--{"sounds/player/footsteps/metal/step4.wav",SOUND_UNSCALABLE,185,5,30},
		},
		particleEffects = {
			name = "bullet.hit_leaf.a",
		},
	},
-------------------------------------
	player_walk = CommonEffects.player_grass_walk,
	player_run = CommonEffects.player_grass_run,
	player_crouch = CommonEffects.player_grass_crouch,
	player_prone = CommonEffects.player_grass_prone,
	player_walk_inwater = CommonEffects.player_walk_inwater,
	
	player_drop = {
		sounds = {
			{"sounds/player/bodyfalls/bodyfallgrass1.wav",SOUND_UNSCALABLE,210,10,150},
			{"sounds/player/bodyfalls/bodyfallgrass2.wav",SOUND_UNSCALABLE,210,10,150},
		},

	},
-------------------------------------
	player_land = {
		sounds = {
			--sound,volume,{min,max}
			--NOTE volume and min max are optional
			 {"sounds/doors/dooropen.wav"},
			 {"sounds/doors/dooropen.wav"},
			
		},
	},
	gameplay_physic = {
		piercing_resistence = 2,
		friction = .6,
		bouncyness= -2, -- default 0
		no_collide=1,
	},

	AI = {
		fImpactRadius = 5,
	},
			
}