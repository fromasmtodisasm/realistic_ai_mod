Script:LoadScript("scripts/materials/commoneffects.lua");

local WalkParticles = 
{
	{--dust
		focus = 0,
		speed = 0.25,
		start_color = {0.89,0.69,0.4},
		end_color = {1,1,1},
		count = 5,
		size = 0.3, 
		size_speed=0.2,
		rotation = {x = 0.0, y = 0.0, z = 1},
		gravity = {x = 0.0, y = 0.0, z = 0},
		lifetime=2,
		blend_type = 0,
		tid = System:LoadTexture("textures\\clouda2.dds"),
		frames=0,
	},
}
	
Materials["mat_sand_dry"] = {
	type="sand_dry",
-------------------------------------
	PhysicsSounds=PhysicsSoundsTable.Soft,
-------------------------------------	
	bullet_drop_single = CommonEffects.common_bullet_drop_single_ashphalt,
	bullet_drop_rapid = CommonEffects.common_bullet_drop_rapid_ashphalt,
-------------------------------------	
	projectile_hit = CommonEffects.common_projectile_hit,
	mortar_hit = CommonEffects.common_mortar_hit,
	smokegrenade_hit = CommonEffects.common_smokegrenade_hit,
	flashgrenade_hit = CommonEffects.common_flashgrenade_hit,
	grenade_hit = CommonEffects.common_grenade_hit,

	bullet_hit = {
		sounds = {
			{"Sounds/Bullethits/bsand1.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/bsand2.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/bsand3.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/bsand4.wav",SOUND_UNSCALABLE,200,5,60},
			},
		decal = { 
			texture = System:LoadTexture("Textures/Decal/sand.dds"),
			scale = 0.04,
			},
		
		particleEffects = {
			name = "bullet.hit_sand.a",
			},
	},

	pancor_bullet_hit = {
		sounds = {
			{"Sounds/Bullethits/bsand1.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/bsand2.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/bsand3.wav",SOUND_UNSCALABLE,200,5,60},
			{"Sounds/Bullethits/bsand4.wav",SOUND_UNSCALABLE,200,5,60},
			},
		decal = { 
			texture = System:LoadTexture("Textures/Decal/sand.dds"),
			scale = 0.03,
			},
		
		particleEffects = {
			name = "bullet.hit_sand_pancor.a",
			},
	},

	melee_slash = {
		sounds = {
			{"sounds/weapons/machete/machetesand4.wav",SOUND_UNSCALABLE,185,5,30},
			--{"sounds/weapons/machete/machetesand2.wav",SOUND_UNSCALABLE,255,5,30},
			--{"sounds/weapons/machete/machetesand3.wav",SOUND_UNSCALABLE,255,5,30},
		},
		particles =  CommonEffects.common_machete_hit_canvas_part.particles,

	},


-------------------------------------
	player_walk = {
		sounds = {
			{"sounds/player/footsteps/sand_dry/step1.wav",SOUND_UNSCALABLE,140,10,60},
			{"sounds/player/footsteps/sand_dry/step2.wav",SOUND_UNSCALABLE,140,10,60},
			{"sounds/player/footsteps/sand_dry/step3.wav",SOUND_UNSCALABLE,140,10,60},
			{"sounds/player/footsteps/sand_dry/step4.wav",SOUND_UNSCALABLE,140,10,60},
		},
		particles = WalkParticles,
	},
	player_run = {
		sounds = {
			{"sounds/player/footsteps/sand_dry/step1.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/sand_dry/step2.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/sand_dry/step3.wav",SOUND_UNSCALABLE,200,10,60},
			{"sounds/player/footsteps/sand_dry/step4.wav",SOUND_UNSCALABLE,200,10,60},
		},
		particles = WalkParticles,
	},
	player_crouch = {
		sounds = {
			{"sounds/player/footsteps/sand_dry/step1.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/sand_dry/step2.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/sand_dry/step3.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/sand_dry/step4.wav",SOUND_UNSCALABLE,120,10,60},
		},
		particles = WalkParticles,
	},
	player_prone = {
		sounds = {
			{"sounds/player/footsteps/sand_dry/step1.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/sand_dry/step2.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/sand_dry/step3.wav",SOUND_UNSCALABLE,120,10,60},
			{"sounds/player/footsteps/sand_dry/step4.wav",SOUND_UNSCALABLE,120,10,60},
		},
		particles = WalkParticles,
	},
	player_walk_inwater = CommonEffects.player_walk_inwater,
	
	player_drop = {
		sounds = {
			{"sounds/player/bodyfalls/bodyfalldirt1.wav",SOUND_UNSCALABLE,210,10,150},
			{"sounds/player/bodyfalls/bodyfalldirt2.wav",SOUND_UNSCALABLE,210,10,150},
			{"sounds/player/bodyfalls/bodyfalldirt3.wav",SOUND_UNSCALABLE,210,10,150},
		},

	},
-------------------------------------
	player_land = {
		sounds = {
			--sound , volume , {min, max}
			--NOTE volume and min max are optional
			 {"sounds/doors/dooropen.wav"},
			 {"sounds/doors/dooropen.wav"},
			
		},
	},
	gameplay_physic = {
		piercing_resistence = 15,
		friction = 1,
		bouncyness= -2, -- default 0
	},

	AI = {
		fImpactRadius = 5,
	},
			
	--vehicle effects: particle is called when wheels are slipping, smoke in any case if the vehicle is moving.
	VehicleParticleEffect = CommonEffects.common_vehicle_particles_rocks,
	VehicleSmokeEffect = CommonEffects.common_vehicle_smoke_mud,
}