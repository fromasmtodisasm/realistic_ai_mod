Script:LoadScript("scripts/materials/commoneffects.lua");
	
Materials["mat_light_holes"] = {
	type="light_holes",
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
			object = System:LoadObject("Objects/Indoor/lights/decal/ray.cgf"),
			texture = System:LoadTexture("Textures/Decal/lighthole.dds"),
			lifetime = 1000,
			scale = 0.1,
			},
		particles = 
			{
				{ --HotSpot
				focus = 90,
				speed = 0.0,
				count = 2,
				size = 0.02, 
				size_speed=0.01,
				gravity={x=0,y=0,z=0},
				lifetime=0.2,
				tid = System:LoadTexture("Textures/Decal/Spark.dds"),
				frames=0,
				blend_type = 1,
				draw_last = 1,
				},
			
			},

		},
-------------------------------------
	player_land = {
		sounds = {
			--sound , volume , {min, max}
			--NOTE volume and min max are optional
			 {"sounds/doors/dooropen.wav",SOUND_UNSCALABLE,180,5,20},
			 {"sounds/doors/dooropen.wav",SOUND_UNSCALABLE,180,5,20},
			
		},
	},
	gameplay_physic = {
		piercing_resistence = 15,
		friction = 1,
	},

	AI = {
		fImpactRadius = 5,
	},
			
}